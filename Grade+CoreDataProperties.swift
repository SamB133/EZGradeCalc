//
//  Grade+CoreDataProperties.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/7/23.
//
//

import Foundation
import CoreData


extension Grade {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grade> {
        return NSFetchRequest<Grade>(entityName: "Grade")
    }

    @NSManaged public var grade: Double
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var weight: Double
    @NSManaged public var order: Int64
    @NSManaged public var courses: NSSet?

    public var courseArray: [Course] {
        let set = courses as? Set<Course> ?? []
        return set.sorted{
            $0.order < $1.order
        }
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

}
