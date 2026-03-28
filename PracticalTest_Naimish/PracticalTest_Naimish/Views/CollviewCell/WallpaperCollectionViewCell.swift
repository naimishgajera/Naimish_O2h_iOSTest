//
//  WallpaperCollectionViewCell.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import UIKit
import Kingfisher

class WallpaperCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var wallpaperImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wallpaperImg.kf.cancelDownloadTask()
        wallpaperImg.image = nil
        activityIndicator?.stopAnimating()
    }
    
    // MARK: - Setup
    private func setupUI() {
        UIHelper.makeRounded(view: wallpaperImg, radius: 12)
        UIHelper.makeRounded(view: contentView, radius: 12)
       
        wallpaperImg.clipsToBounds = true
        // Setup activity indicator if available
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.color = .white
    }
    
    // MARK: - Configuration
    func configure(with wallpaper: Wallpaper) {
        guard let urlString = wallpaper.download_url,
              let url = URL(string: urlString) else {
            wallpaperImg.image = UIImage(systemName: "photo")
            return
        }
        
        activityIndicator?.startAnimating()
        
        // Determine scale using context to avoid UIScreen.main deprecation
        let displayScale: CGFloat
        if #available(iOS 26.0, *) {
            if traitCollection.responds(to: NSSelectorFromString("displayScale")) {
                displayScale = traitCollection.displayScale
            } else if let scale = window?.windowScene?.screen.scale {
                displayScale = scale
            } else {
                displayScale = 1.0
            }
        } else {
            displayScale = window?.windowScene?.screen.scale ?? traitCollection.displayScale
        }
        
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.2)),
            .cacheOriginalImage,
            .scaleFactor(displayScale)
        ]
        
        wallpaperImg.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: options
        ) { [weak self] result in
            self?.activityIndicator?.stopAnimating()
        }
    }
}

