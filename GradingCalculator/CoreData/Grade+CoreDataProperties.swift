//
//  Grade+CoreDataProperties.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/10/23.
//
//

import Foundation
import CoreData

extension Grade {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grade> {
        return NSFetchRequest<Grade>(entityName: "Grade")
    }

    @NSManaged public var grade: Double
    @NSManaged public var weight: Double
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var order: Int64
    @NSManaged public var date: Date?
    @NSManaged public var courses: NSSet?
    
    public var courseArray: [Course] {
        return courses?.allObjects as? [Course] ?? []
    }
}

// MARK: Generated accessors for courses
extension Grade {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)
}

extension Grade : Identifiable {
    static func ==(lhs: Grade, rhs: Grade) -> Bool{
        return lhs.id == lhs.id
    }
}
