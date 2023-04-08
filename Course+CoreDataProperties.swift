//
//  Course+CoreDataProperties.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/7/23.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var semester: String?
    @NSManaged public var year: Int16
    @NSManaged public var order: Int64
    @NSManaged public var grades: NSSet?
    
    public var gradeArray: [Grade] {
        let set = grades as? Set<Grade> ?? []
        return set.sorted{
            $0.order < $1.order
        }
    }

}

// MARK: Generated accessors for grades
extension Course {

    @objc(addGradesObject:)
    @NSManaged public func addToGrades(_ value: Grade)

    @objc(removeGradesObject:)
    @NSManaged public func removeFromGrades(_ value: Grade)

    @objc(addGrades:)
    @NSManaged public func addToGrades(_ values: NSSet)

    @objc(removeGrades:)
    @NSManaged public func removeFromGrades(_ values: NSSet)

}

extension Course : Identifiable {

}
