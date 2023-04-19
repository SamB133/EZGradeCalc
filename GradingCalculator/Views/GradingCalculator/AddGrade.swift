//
//  AddGrade.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/29/23.
//

import SwiftUI

struct AddGrade: View {
    
    @State var course: Course
    @State var title = ""
    @State var grade = ""
    @State var weight = ""
    @State private var showAlert = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var grades: FetchedResults<Grade>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Course.order)]) var courses: FetchedResults<Course>
    @EnvironmentObject var dataController: DataManager
    @EnvironmentObject var colorManager: ColorManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Grade Title", text: $title)
                } header: {
                    Text("Grade Title")
                }
                .scrollContentBackground(.hidden)
                .listRowBackground(colorManager.getSecondaryColor(colorScheme: colorScheme))
                   
                Section {
                    TextField("Grade (%)", text: $grade)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Grade (%)")
                }
                .listRowBackground(colorManager.getSecondaryColor(colorScheme: colorScheme))
                Section {
                    TextField("Weight (%)", text: $weight)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Weight (%)")
                }
                .listRowBackground( colorManager.getSecondaryColor(colorScheme: colorScheme))
                Section {
                    Button("Add Grade") {
                        if !title.isEmpty && !grade.isEmpty && !weight.isEmpty {
                            dataController.addGrade(name: title, grade: Double(grade) ?? 0.0, weight: Double(weight) ?? 0.0, course: course)
                                
                                dismiss()
                        } else {
                            showAlert.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Missing Information"), message: Text("Please insert the missing information and try again."), dismissButton: .default(Text("Ok")))
                    }
                }
                .listRowBackground( colorManager.getSecondaryColor(colorScheme: colorScheme))
            }
            .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
            .scrollContentBackground(.hidden)
            .navigationBarTitle(Text("Add Grade"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
        .onAppear {
            colorManager.colorSelection = colorManager.getColorForKey(.colorThemeKey)
        }
    }
}

//struct AddGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        AddGrade(courses: [Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)])], course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), grades: [Grade(name: "newGrade", grade: 99, weight: 40)], vm: GradeVM())
//    }

