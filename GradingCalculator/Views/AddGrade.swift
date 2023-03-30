//
//  AddGrade.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/29/23.
//

import SwiftUI

struct AddGrade: View {
    
    @State var courses: [Course]
    @State var course: Course
    @State var title = ""
    @State var grade = ""
    @State var weight = ""
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Grade Title", text: $title)
                }
                Section {
                    TextField("Grade (%)", text: $grade)
                        .keyboardType(.numberPad)
                }
                Section {
                    TextField("Weight (%)", text: $weight)
                        .keyboardType(.numberPad)
                }
                Section {
                    Button("Add Grade") {
                        retrieveStoredData()
                        if !title.isEmpty && !grade.isEmpty && !weight.isEmpty {
                            do {
                                let grade = Grade(name: title, grade: Double(grade) ?? 0.0, weight: Double(weight) ?? 0.0)
                                var courseIndex = 0
                                for j in 0..<courses.count {
                                    if course.name == courses[j].name {
                                        courseIndex = j
                                    }
                                }
                                courses[courseIndex].grades.append(grade)
                                let data = try JSONEncoder().encode(self.courses)
                                UserDefaults.standard.set(data, forKey: "courses")
                                dismiss()
                            }
                            catch {}
                        } else {
                            showAlert.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Missing Information"), message: Text("Please insert the missing information and try again."), dismissButton: .default(Text("Ok")))
                    }
                }
            }
            .navigationBarTitle(Text("Add Grade"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    func retrieveStoredData() {
        if let data = UserDefaults.standard.value(forKey: "courses") as? Data {
            if let coursesData = try? JSONDecoder().decode([Course].self, from: data) {
                self.courses = coursesData
            }
        }
    }
}

struct AddGrade_Previews: PreviewProvider {
    static var previews: some View {
        AddGrade(courses: [Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)])], course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]))
    }
}
