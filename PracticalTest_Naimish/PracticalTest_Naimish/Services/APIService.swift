//
//  APIService.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    func fetchWallpapers(page: Int,
                         limit: Int = 20,
                         completion: @escaping ([Wallpaper]) -> Void) {
        
        let urlString = "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for network error
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            // Check for valid response
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                print("HTTP Error: Status code \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            do {
                let wallpapers = try JSONDecoder().decode([Wallpaper].self, from: data)
                
                DispatchQueue.main.async {
                    completion(wallpapers)
                }
                
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
            
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
