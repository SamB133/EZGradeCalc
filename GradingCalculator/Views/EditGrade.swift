//
//  EditGrade.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/30/23.
//

import SwiftUI
enum gradeType {
    case title
    case grade
    case weight
}

struct EditGrade: View {
    @State var courses: [Course]
    @State var course: Course
    @State var currentGrade: Grade
    @State var title = ""
    @State var grade = ""
    @State var weight = ""
    @State private var showAlert = false
    @State var gradeVariation: gradeType?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $title)
                        .placeholder(when: title.isEmpty) {
                            Text(currentGrade.name)
                        }
                }
                Section {
                    TextField("", text: $grade)
                        .keyboardType(.numberPad)
                        .placeholder(when: grade.isEmpty) {
                            Text(String(currentGrade.grade))
                        }
                }
                Section {
                    TextField("", text: $weight)
                        .keyboardType(.numberPad)
                        .placeholder(when: weight.isEmpty) {
                            Text(String(currentGrade.weight))
                        }
                }
                Section {
                    Button("Submit Changes") {
                        retrieveStoredData()
                        if !title.isEmpty || !grade.isEmpty || !weight.isEmpty {
                            do {
                                var grade: Grade = self.currentGrade
                                var courseIndex = 0
                                for i in 0..<courses.count {
                                    if course.name == courses[i].name {
                                        courseIndex = i
                                    }
                                }
                                var gradeIndex = 0
                                let grades = courses[courseIndex].grades
                                for i in 0..<grades.count - 1 {
                                    if grade.id == self.currentGrade.id {
                                        gradeIndex = i
                                    }
                                }
                                if !title.isEmpty {
                                    courses[courseIndex].grades[gradeIndex].name = title
                                }
                                if !self.grade.isEmpty {
                                    courses[courseIndex].grades[gradeIndex].grade = Double(self.grade) ?? 0.0
                                }
                                if !weight.isEmpty {
                                    courses[courseIndex].grades[gradeIndex].weight = Double(self.weight) ?? 0.0
                                }
                                grade = Grade(name: (title.isEmpty ? currentGrade.name : title), grade: Double(self.grade) ?? currentGrade.grade, weight: Double(self.weight) ?? currentGrade.weight)
                                courses[courseIndex].grades[gradeIndex] = grade
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
                        Alert(title: Text("No Changes"), message: Text("No changes have been made."), dismissButton: .default(Text("Ok")))
                    }
                }
            }
            .navigationBarTitle(Text("Edit Grade"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    func retrieveCourseInfo() -> Grade {
        var grade = Grade(name: title, grade: Double(grade) ?? 0.0, weight: Double(weight) ?? 0.0)
        var courseIndex = 0
        for i in 0..<courses.count {
            if course.name == courses[i].name {
                courseIndex = i
            }
        }
        let courseGradesIndex = courses[courseIndex].grades
        var gradeIndex = 0
        for i in 0..<courseGradesIndex.count {
            if courseGradesIndex[i].name == courseGradesIndex[i].name {
                gradeIndex = i
            }
        }
        grade.name = courseGradesIndex[gradeIndex].name
        grade.grade = courseGradesIndex[gradeIndex].grade
        grade.weight = courseGradesIndex[gradeIndex].weight
        return grade
    }
    
    func retrieveStoredData() {
        if let data = UserDefaults.standard.value(forKey: "courses") as? Data {
            if let coursesData = try? JSONDecoder().decode([Course].self, from: data) {
                self.courses = coursesData
            }
        }
    }
}

struct EditGrade_Previews: PreviewProvider {
    static var previews: some View {
        EditGrade(courses: [Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)])], course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), currentGrade: Grade(name: "Exam 1", grade: 90, weight: 25))
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1:0)
            self
        }
    }
}
