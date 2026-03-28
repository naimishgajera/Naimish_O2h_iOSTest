//
//  HomeViewModel.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import Foundation
import Network

class HomeViewModel {

    // MARK: - Properties
    private(set) var wallpapers: [Wallpaper] = []
    private var currentPage = 1
    private var isLoadingData = false
    private(set) var canLoadMore = true
    private let itemsPerPage = 10

    // MARK: - Closures
    var reloadCollection: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init() {

        NetworkMonitor.shared.connectionHandler = { [weak self] isConnected in

            guard let self = self else { return }

            if isConnected {
                // Internet available → load API
                if self.wallpapers.isEmpty {
                    self.fetchWallpapers()
                }

            } else {
                // Internet lost → load CoreData
                self.loadFromLocal()
            }
        }
    }

    // MARK: - API Methods
    func fetchWallpapers() {

        guard !isLoadingData, canLoadMore else { return }

        guard NetworkMonitor.shared.isConnected else {
            loadFromLocal()
            return
        }

        isLoadingData = true

        APIService.shared.fetchWallpapers(page: currentPage, limit: itemsPerPage) { [weak self] (newWallpapers: [Wallpaper]) in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoadingData = false

                if newWallpapers.isEmpty {
                    self.canLoadMore = false
                } else {

                    self.wallpapers.append(contentsOf: newWallpapers)

                    // Save to CoreData
                    CoreDataManager.shared.saveWallpapers(newWallpapers)

                    self.currentPage += 1
                }

                self.reloadCollection?()
            }
        }
    }

    // MARK: - Load Offline Data
    private func loadFromLocal() {

        wallpapers = CoreDataManager.shared.fetchWallpapers()
        reloadCollection?()
    }

    // MARK: - Helper Methods
    func reset() {
        wallpapers.removeAll()
        currentPage = 1
        canLoadMore = true
        isLoadingData = false
    }

    func wallpaper(at index: Int) -> Wallpaper? {
        guard index >= 0 && index < wallpapers.count else { return nil }
        return wallpapers[index]
    }
}
