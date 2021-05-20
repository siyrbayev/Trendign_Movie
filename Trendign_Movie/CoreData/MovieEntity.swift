//
//  MovieEntity.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 16.05.2021.
//

import Foundation
import CoreData

class MoviewEntiry:NSManagedObject {
    let id: Int64
    let title: String
    init(id: Int64, title: String) {
        self.id = id
        self.title = title
    }
}
