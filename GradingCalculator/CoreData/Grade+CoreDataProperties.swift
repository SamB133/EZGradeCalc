//
//  Grade+CoreDataProperties.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/13/23.
//
//

import Foundation
import CoreData

extension Grade {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grade> {
        return NSFetchRequest<Grade>(entityName: "Grade")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var grade: Double
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var order: Int64
    @NSManaged public var weight: Double
    @NSManaged public var courses: Course?
}

extension Grade : Identifiable, Comparable {
    public static func < (lhs: Grade, rhs: Grade) -> Bool {
        return lhs.date ?? Date(timeIntervalSinceNow: 999999999) > rhs.date ?? Date(timeIntervalSinceNow: 99999999)
    }
}
