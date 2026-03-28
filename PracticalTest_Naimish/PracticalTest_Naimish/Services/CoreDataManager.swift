//
//  CoreDataManager.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 28/03/26.
//

import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()

    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }

    func saveWallpapers(_ wallpapers: [Wallpaper]) {

        wallpapers.forEach { wallpaper in

            let entity = Wallpapers(context: context)
            entity.id = wallpaper.id
            entity.url = wallpaper.url
            entity.download_url = wallpaper.download_url
        }

        try? context.save()
    }

    func fetchWallpapers() -> [Wallpaper] {

        let request: NSFetchRequest<Wallpapers> = Wallpapers.fetchRequest()

        let results = (try? context.fetch(request)) ?? []

        return results.map {
            Wallpaper(
                id: $0.id,
                author: nil,
                width: nil,
                height: nil,
                url: $0.url,
                download_url: $0.download_url
            )
        }
    }
}
