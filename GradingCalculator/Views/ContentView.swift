//
//  ContentView.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/22/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var showAddCourse = false
    @State var courses: [Course]
    @State var grades: [Grade] = []
    var didUpdate: (([Course]) -> Void)?
    @StateObject var gradeVM = GradeVM()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(gradeVM.courses, id: \.self) { course in
                    VStack(alignment: .leading) {
                        NavigationLink {
                            CalculateGrade(course: course, gradeArr: course.grades, vm: gradeVM)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(course.name)
                                Text("\(course.semester) \(String(course.year))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete { indices in
                    gradeVM.courses.remove(atOffsets: indices)
                    gradeVM.saveCourse()
                }
                .onMove { indices, newOffset in
                    gradeVM.courses.move(fromOffsets: indices, toOffset: newOffset)
                    gradeVM.saveCourse()
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("Courses")
            .navigationBarItems(trailing: EditButton())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAddCourse.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddCourse, onDismiss: {
           _ = retrieveStoredData()
       
        }) {
            AddCourse(courses: gradeVM.courses, vm: gradeVM)
            
        }
        .onAppear {
            _ = retrieveStoredData()
           
        }
       
    }
    
    func retrieveStoredData() -> [Course]{
        return gradeVM.retrieveCourse()
    }
    
    func save(_ courses: [Course]) {
        gradeVM.saveCourse()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(courses: [Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), Course(name: "Physics 101", semester: "Fall", year: 2024, grades: [Grade(name: "Exam 2", grade: 75, weight: 55)])])
    }
}
