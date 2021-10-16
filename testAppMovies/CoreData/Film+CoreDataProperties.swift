//
//  Film+CoreDataProperties.swift
//  testAppMovies
//
//  Created by pavel on 14.10.21.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var name: String?

}

extension Film : Identifiable {

}
