//
//  CourseDetail.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/23/23.
//

import SwiftUI

struct CalculateGrade: View {
    
    @State var grade = ""
    @State var weight = ""
    @State var average = ""
    @State var showAddCourse = false
    @State var isHidden = true
    @State var addGrade = false
    @State var courseIndex = 0
    @StateObject var course: Course
    @FetchRequest(sortDescriptors: [SortDescriptor(\Grade.order)]) var grades: FetchedResults<Grade>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Course.order)]) var courses: FetchedResults<Course>
    @EnvironmentObject var dataController: DataManager

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
                ForEach (course.gradeArray, id:\.id) { grade in
                    NavigationLink {
                        EditGrade(course: course, currentGrade: grade)
                    } label: {
                        HStack {
                            Text(grade.name ?? "No Name")
                            Spacer()
                            Text(String(grade.grade))
                                .padding(.trailing, 23)
                            Text(String(grade.weight))
                                .padding(.trailing, 13)
                        }
                    }
                }
                .onDelete { indices in
                    dataController.onDelete(at: indices, courses: grades)
                }
                .onMove { indices, newOffset in
                    dataController.moveItem(at: indices, destination: newOffset, courses: grades)
                }
                Section {
                    Button("Calculate Grade") {
                        average = calculateGrade()
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
            .sheet(isPresented: $addGrade, onDismiss: {
            }) {
                AddGrade(course: self.course)
            }
        }
    }

    func calculateGrade() -> String {
        var sumOfTotal = 0.0
        var sumOfWeights = 0.0
        var totalAverage = 0.0
        for grade in course.gradeArray {
            sumOfTotal += grade.grade * grade.weight
            sumOfWeights += grade.weight
        }
        totalAverage = sumOfTotal / sumOfWeights
        return String(format: "%.3f", totalAverage)
    }
}

//struct CalculateGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        CalculateGrade(course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), gradeArr: [Grade(name: "Exam 1", grade: 82, weight: 45)], vm: GradVM())
//    }
//}
