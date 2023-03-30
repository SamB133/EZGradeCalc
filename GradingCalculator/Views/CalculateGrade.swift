//
//  CourseDetail.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/23/23.
//

import SwiftUI

struct CalculateGrade: View {
    
    @State var courses: [Course] = []
    @State var course: Course
    @State var grade = ""
    @State var weight = ""
    @State var average = ""
    @State var showAddCourse = false
    @State var isHidden = true
    @State var addGrade = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (course.grades, id: \.self) { grade in
                    HStack {
                        Text(grade.name)
                        Spacer()
                        Text(String(grade.grade))
                            .padding(.trailing, 20)
                        Text(String(grade.weight))
                    }
                }
                .onDelete { indices in
                    self.course.grades.remove(atOffsets: indices)
                    save(courses)
                }
                .onMove { indices, newOffset in
                    self.course.grades.move(fromOffsets: indices, toOffset: newOffset)
                    save(courses)
                }
                Section {
                    Button("Calculate Grade") {
                        average = calculateGrade(course: course)
                    }
                    .frame(maxWidth: .infinity)
                }
                HStack {
                    Text("Calculated Average: ")
                    Text(String(average))
                        .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("Grades")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addGrade.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                        .padding(.leading, 275)
                }
            }
            .onAppear() {
                retrieveStoredData()
            }
            .sheet(isPresented: $addGrade, onDismiss: {
                retrieveStoredData()
            }) {
                AddGrade(courses: self.courses, course: self.course)
            }
        }
    }
    
    func retrieveStoredData() {
        if let data = UserDefaults.standard.value(forKey: "courses") as? Data {
            if let coursesData = try? JSONDecoder().decode([Course].self, from: data) {
                self.courses = coursesData
                var courseIndex = 0
                for j in 0..<courses.count {
                    if course.name == courses[j].name {
                        courseIndex = j
                    }
                }
                self.course = self.courses[courseIndex]
            }
        }
    }
    
    func save(_ courses: [Course]) {
        do {
            let data = try JSONEncoder().encode(courses)
            UserDefaults.standard.set(data, forKey: "courses")
        }
        catch {}
    }
    
    func calculateGrade(course: Course) -> String {
        var sumOfTotal = 0.0
        var sumOfWeights = 0.0
        var totalAverage = 0.0
        for grade in course.grades {
            sumOfTotal += grade.grade * grade.weight
            sumOfWeights += grade.weight
        }
        totalAverage = sumOfTotal / sumOfWeights
        return String(format: "%.5f", totalAverage)
    }
}

struct CalculateGrade_Previews: PreviewProvider {
    static var previews: some View {
        CalculateGrade(course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]))
    }
}
