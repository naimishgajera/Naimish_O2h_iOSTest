//
//  HomeVC.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    private var isLoading = false
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let footerActivityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        bindViewModel()
        loadInitialData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Setup main loading indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemGray
        view.addSubview(activityIndicator)
        
        // Setup footer loading indicator for pagination
        footerActivityIndicator.hidesWhenStopped = true
        footerActivityIndicator.color = .systemGray
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        // Improve scrolling performance
        collectionView.isPrefetchingEnabled = true
        collectionView.decelerationRate = .fast
    }
    
    private func bindViewModel() {
        viewModel.reloadCollection = { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.activityIndicator.stopAnimating()
            self.footerActivityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self = self else { return }
            self.isLoading = false
            self.activityIndicator.stopAnimating()
            self.footerActivityIndicator.stopAnimating()
            self.showError(message: errorMessage)
        }
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        guard !isLoading else { return }
        isLoading = true
        activityIndicator.startAnimating()
        viewModel.fetchWallpapers()
    }
    
    private func loadMoreData() {
        guard !isLoading, viewModel.canLoadMore else { return }
        isLoading = true
        footerActivityIndicator.startAnimating()
        viewModel.fetchWallpapers()
    }
    
    // MARK: - Helper Methods
    private func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            if self?.viewModel.wallpapers.isEmpty == true {
                self?.loadInitialData()
            } else {
                self?.loadMoreData()
            }
        })
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollViewCell",for: indexPath) as? WallpaperCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let wallpaper = viewModel.wallpapers[indexPath.row]
        cell.configure(with: wallpaper)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeVC: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // Trigger pagination when user scrolls near the bottom
        let threshold: CGFloat = 100
        if offsetY > contentHeight - scrollViewHeight - threshold {
            loadMoreData()
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension HomeVC: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Prefetch images for better scrolling performance
        let urls = indexPaths.compactMap { indexPath -> URL? in
            guard indexPath.row < viewModel.wallpapers.count,
                  let urlString = viewModel.wallpapers[indexPath.row].download_url else {
                return nil
            }
            return URL(string: urlString)
        }
        
        // Kingfisher prefetching
        ImagePrefetcher(urls: urls).start()
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel prefetching if needed
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = LayoutConstants.self
        let totalWidth = collectionView.bounds.width - (layout.sectionPadding * 2)
        let totalInteritemSpacing = (layout.numberOfColumns - 1) * layout.interitemSpacing
        let itemWidth = (totalWidth - totalInteritemSpacing) / layout.numberOfColumns
        
        return CGSize(width: itemWidth, height: itemWidth + layout.cellHeightOffset)
    }
}
