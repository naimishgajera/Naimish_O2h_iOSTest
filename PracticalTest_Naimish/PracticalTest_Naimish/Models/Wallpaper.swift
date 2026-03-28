//
//  Wallpaper.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import Foundation

struct Wallpaper: Codable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let download_url: String?
    
    // Computed property for aspect ratio
    var aspectRatio: CGFloat {
        guard let width = width, let height = height, height != 0 else {
            return 1.0
        }
        return CGFloat(width) / CGFloat(height)
    }
    
    // Computed property for formatted dimensions
    var dimensions: String {
        guard let width = width, let height = height else {
            return "Unknown"
        }
        return "\(width) × \(height)"
    }
}

// MARK: - Identifiable (for SwiftUI compatibility)
extension Wallpaper: Identifiable {
    var identifier: String {
        return id ?? UUID().uuidString
    }
}

// MARK: - Equatable
extension Wallpaper: Equatable {
    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.id == rhs.id
    }
}
