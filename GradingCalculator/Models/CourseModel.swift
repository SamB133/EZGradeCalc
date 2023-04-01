//
//  CourseModel.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/23/23.
//

import Foundation

struct Course: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var semester: String
    var year: Int
    var grades: [Grade]
    init(id: UUID = UUID(), name: String, semester: String, year: Int, grades: [Grade]) {
        self.id = UUID()
        self.name = name
        self.semester = semester
        self.year = year
        self.grades = grades
    }
}

struct Grade: Identifiable, Hashable, Codable, Equatable {
    var id: UUID
    var name: String
    var grade: Double
    var weight: Double
    init(id: UUID = UUID(), name: String, grade: Double, weight: Double) {
        self.id = UUID()
        self.name = name
        self.grade = grade
        self.weight = weight
    }
    static func == (lhs: Grade, rhs: Grade) -> Bool {
        lhs.id == rhs.id
    }
}
