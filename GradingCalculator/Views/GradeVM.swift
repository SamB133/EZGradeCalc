//
//  GradeVM.swift
//  GradingCalculator
//
//  Created by derharta on 4/1/23.
//

import Foundation

class GradeVM: ObservableObject {
    
    @Published var courses: [Course]  = [Course]()
    
    func saveCourse() {
        do {
            let data = try JSONEncoder().encode(courses)
            UserDefaults.standard.set(data, forKey: "courses")
        }
        catch {}
    }
    
    func retrieveCourse() -> [Course] {
        if let data = UserDefaults.standard.value(forKey: "courses") as? Data {
            if let coursesData = try? JSONDecoder().decode([Course].self, from: data) {
                self.courses = coursesData
                return self.courses
            }
        }
        return []
    }
    
    func addGrade(courseName: String, grade: Grade) {
        courses[getCourseIndex(courseName: courseName)].grades.append(grade)
    }
    
    func getCourseIndex(courseName: String) -> Int {
       
        var courseIndex = 0
        for i in 0..<courses.count {
            if courseName == courses[i].name {
                courseIndex = i
            }
        }
        return courseIndex
    }
    
    func getGradeIndexForCourseIndex(courseIndex: Int, grade: Grade, currentGrade: Grade) -> Int {
       
        var gradeIndex = 0
        let grades = courses[courseIndex].grades
        for i in 0..<grades.count - 1 {
            if grade.id == currentGrade.id {
                gradeIndex = i
            }
        }
        return gradeIndex
   
    }
}
