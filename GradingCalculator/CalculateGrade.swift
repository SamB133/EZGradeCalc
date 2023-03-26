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
    @State var average: Int = 0
    @State var showAddCourse = false
    @State var course: Course
    @State var isHidden = true
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (course.grades, id: \.self) { grade in
                    HStack {
                        Text(grade.name)
                        HStack {
                            Text(String(grade.grade))
                            TextField("\(grade.grade, specifier: "%0.2f")", text: $grade).bold()
                                .frame(width: 60, alignment: .trailing)
                            TextField("\(grade.weight, specifier: "%0.2f")", text: $weight)
                                .frame(width: 60, alignment: .trailing)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .onDelete { indices in
                    self.course.grades.remove(atOffsets: indices)
                }
                .onMove { indices, newOffset in
                    self.course.grades.move(fromOffsets: indices, toOffset: newOffset)
                }
                Section {
                    Button("Calculate Grade") {
                        
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
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct CalculateGrade_Previews: PreviewProvider {
    static var previews: some View {
        CalculateGrade(course: Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]))
    }
}
