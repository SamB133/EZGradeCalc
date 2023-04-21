//
//  Course+CoreDataProperties.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/17/23.
//
//

import Foundation
import CoreData

extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var order: Int64
    @NSManaged public var semester: String?
    @NSManaged public var year: Int16
    @NSManaged public var grade: Double
    @NSManaged public var averageGrade: Double
    @NSManaged public var grades: NSOrderedSet?
    
    public var gradeArray: [Grade] {
        return (grades?.array as? [Grade] ?? []).sorted(by: >)
    }
}

// MARK: Generated accessors for grades
extension Course {

    @objc(insertObject:inGradesAtIndex:)
    @NSManaged public func insertIntoGrades(_ value: Grade, at idx: Int)

    @objc(removeObjectFromGradesAtIndex:)
    @NSManaged public func removeFromGrades(at idx: Int)

    @objc(insertGrades:atIndexes:)
    @NSManaged public func insertIntoGrades(_ values: [Grade], at indexes: NSIndexSet)

    @objc(removeGradesAtIndexes:)
    @NSManaged public func removeFromGrades(at indexes: NSIndexSet)

    @objc(replaceObjectInGradesAtIndex:withObject:)
    @NSManaged public func replaceGrades(at idx: Int, with value: Grade)

    @objc(replaceGradesAtIndexes:withGrades:)
    @NSManaged public func replaceGrades(at indexes: NSIndexSet, with values: [Grade])

    @objc(addGradesObject:)
    @NSManaged public func addToGrades(_ value: Grade)

    @objc(removeGradesObject:)
    @NSManaged public func removeFromGrades(_ value: Grade)

    @objc(addGrades:)
    @NSManaged public func addToGrades(_ values: NSOrderedSet)

    @objc(removeGrades:)
    @NSManaged public func removeFromGrades(_ values: NSOrderedSet)
}

extension Course : Identifiable, Comparable {
    public static func < (lhs: Course, rhs: Course) -> Bool {
        return lhs.date ?? Date(timeIntervalSinceNow: 999999999) > rhs.date ?? Date(timeIntervalSinceNow: 99999999)
    }
}
