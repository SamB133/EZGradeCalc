//
//  CommGPA+CoreDataProperties.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/17/23.
//
//

import Foundation
import CoreData

extension CommGPA {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommGPA> {
        return NSFetchRequest<CommGPA>(entityName: "CommGPA")
    }

    @NSManaged public var completedCredits: Int16
    @NSManaged public var completedGradePoints: Int16
}

extension CommGPA : Identifiable {

}
