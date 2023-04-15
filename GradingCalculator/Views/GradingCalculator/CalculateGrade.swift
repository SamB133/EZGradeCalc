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
    @State var colorSelection: String = ".systemBackground"
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var grades: FetchedResults<Grade>
    @EnvironmentObject var dataController: DataManager

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Calculated Average: ")
                        Text(String(average))
                            .frame(maxWidth: .infinity)
                    }
                    Button("Calculate Grade") {
                        average = calculateGrade()
                        if average == "" {
                            showAlert.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("No Grades to Calculate"), message: Text("Please add at least one grade in order to calculate your average grade."), dismissButton: .default(Text("Ok")))
                    }
                }
                .listRowBackground(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color("DarkSecondary") : Color(.white)) : Color(colorSelection))
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
                .listRowBackground(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color("DarkSecondary") : Color(.white)) : Color(colorSelection))
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
                    .listRowBackground(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color("DarkSecondary") : Color(.white)) : Color(colorSelection))
                }
                .onDelete { indices in
                    dataController.onDeleteGrades(at: indices, grades: course.gradeArray)
                }
            }
            .background(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.secondarySystemBackground)) : Color(colorSelection).opacity(1))
            .scrollContentBackground(.hidden)
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
            if let color = UserDefaults.standard.value(forKey: "colorTheme") as? String {
                colorSelection = color
            }
        }
    }

    func calculateGrade() -> String {
        guard course.grades?.count ?? 0 > 0 else { return "" }
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
