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
    @State var gradeArr: [Grade]
    @State var grade = ""
    @State var weight = ""
    @State var average = ""
    @State var showAddCourse = false
    @State var isHidden = true
    @State var addGrade = false
    @State var courseIndex = 0
    @StateObject var vm: GradeVM
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Title")
                        .font(.system(size: 12))
                        .padding(.leading, 10)
                    Spacer()
                    Text("Grade(%)")
                        .font(.system(size: 12))
                    Text("Weight(%)")
                        .font(.system(size: 12))
                        .padding(.trailing, 20)
                }
                ForEach (vm.courses[courseIndex].grades, id: \.self) { grade in
                    NavigationLink {
                        EditGrade(courses: courses, course: course, currentGrade: grade, vm: vm)
                    } label: {
                        HStack {
                            Text(grade.name)
                            Spacer()
                            Text(String(grade.grade))
                                .padding(.trailing, 23)
                            Text(String(grade.weight))
                                .padding(.trailing, 13)
                        }
                    }
                }
                .onDelete { indices in
                    vm.courses[courseIndex].grades.remove(atOffsets: indices)
                    vm.saveCourse()
                }
                .onMove { indices, newOffset in
                    gradeArr.move(fromOffsets: indices, toOffset: newOffset)
                    vm.courses[courseIndex].grades = gradeArr
                    vm.saveCourse()
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
                AddGrade(courses: self.courses, course: self.course, grades: gradeArr, vm: vm)
            }
        }
    }
    
    func retrieveStoredData() {
        self.courses = vm.retrieveCourse()
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

//struct CalculateGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        CalculateGrade(course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), gradeArr: [Grade(name: "Exam 1", grade: 82, weight: 45)], vm: GradVM())
//    }
//}
