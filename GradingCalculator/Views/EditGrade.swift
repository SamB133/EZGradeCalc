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
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: GradeVM
    
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
                        _ = vm.retrieveCourse()
                        if !title.isEmpty || !grade.isEmpty || !weight.isEmpty {
                                var grade: Grade = self.currentGrade
                                let courseIndex = vm.getCourseIndex(courseName: course.name)
                                let gradeIndex = vm.getGradeIndexForCourseIndex(courseIndex: courseIndex, grade: grade, currentGrade: currentGrade) + 1
                                if !title.isEmpty {
                                    vm.courses[courseIndex].grades[gradeIndex].name = title
                                }
                                if !self.grade.isEmpty {
                                    vm.courses[courseIndex].grades[gradeIndex].grade = Double(self.grade) ?? 0.0
                                }
                                if !weight.isEmpty {
                                    vm.courses[courseIndex].grades[gradeIndex].weight = Double(self.weight) ?? 0.0
                                }
                                grade = Grade(name: (title.isEmpty ? currentGrade.name : title), grade: Double(self.grade) ?? currentGrade.grade, weight: Double(self.weight) ?? currentGrade.weight)
                            vm.courses[courseIndex].grades[gradeIndex] = grade
                                vm.courses[courseIndex].grades[gradeIndex] = grade
                                vm.saveCourse()
                                dismiss()
                          
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
}

struct EditGrade_Previews: PreviewProvider {
    static var previews: some View {
        EditGrade(courses: [Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)])], course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), currentGrade: Grade(name: "Exam 1", grade: 90, weight: 25), vm: GradeVM())
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
