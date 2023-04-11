//
//  GPA+CoreDataProperties.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/10/23.
//
//

import Foundation
import CoreData

extension GPA {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GPA> {
        return NSFetchRequest<GPA>(entityName: "GPA")
    }

    @NSManaged public var credits: Int16
    @NSManaged public var grade: Double
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
}

extension GPA : Identifiable {

}
