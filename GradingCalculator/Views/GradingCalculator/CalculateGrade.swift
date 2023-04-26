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
    @State private var showAlert = false
    @State var gradesArray: [Grade] = []
    @StateObject var course: Course
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var grades: FetchedResults<Grade>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Course.order, order: .reverse), SortDescriptor(\Course.date, order: .reverse)]) var courses: FetchedResults<Course>
    @FetchRequest(sortDescriptors: [] ) var users: FetchedResults<User>
    @EnvironmentObject var dataController: DataManager
    @EnvironmentObject var colorManager: ColorManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Calculated Average: ")
                        Text(average)
                            .frame(maxWidth: .infinity)
                    }
                    Button("Calculate Grade") {
                        if course.grades?.count == 0 {
                            showAlert.toggle()
                        } else {
                            calculateGrade()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("No Grades to Calculate"), message: Text("Please add at least one grade in order to calculate your average grade."), dismissButton: .default(Text("Ok")))
                    }
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
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
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                ForEach (course.gradeArray, id: \.id) { grade in
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
                    .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                }
                .onDelete { indices in
                    dataController.onDeleteGrades(at: indices, grades: course.gradeArray)
                    if course.grades?.count == 0 {
                        average = "0.000"
                        dataController.saveGrade(averageGrade: 0.000, gradeArray: gradesArray, courses: courses , course: course)
                    }
                }
            }
            .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .navigationBarTitle("Grades")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addGrade.toggle()
                    } label: {
                        Text("Add Grade")
                    }
                }
            }
            .sheet(isPresented: $addGrade, onDismiss: {
            }) {
                AddGrade(course: self.course)
            }
            .onAppear {
                self.gradesArray = course.gradeArray
                self.gradesArray.sort(by: >)
            }
        }
        .onAppear {
            colorManager.colorSelection = colorManager.getColorForKey(.colorThemeKey)
            average = String(format: "%.3f", course.averageGrade)
        }
        .onChange(of: course.grades?.count) { newValue in
            calculateGrade()
            average = String(format: "%.3f", course.averageGrade)
        }
    }

    func calculateGrade()  {
        guard course.grades?.count ?? 0 > 0 else { return  }
        var sumOfTotal = 0.0
        var sumOfWeights = 0.0
        var totalAverage = 0.0
        for grade in course.gradeArray {
            sumOfTotal += grade.grade * grade.weight
            sumOfWeights += grade.weight
        }
        totalAverage = sumOfTotal / sumOfWeights
        dataController.saveGrade(averageGrade: totalAverage, gradeArray: gradesArray, courses: courses , course: course)
        average = String(format: "%.3f", totalAverage)
    }
}

//struct CalculateGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        CalculateGrade(course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), gradeArr: [Grade(name: "Exam 1", grade: 82, weight: 45)], vm: GradVM())
//    }
//}
