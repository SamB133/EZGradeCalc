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
    var didUpdate: (([Course]) -> Void)?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(courses, id: \.self) { course in
                    VStack(alignment: .leading) {
                        NavigationLink {
                            CalculateGrade(course: course)
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
                    self.courses.remove(atOffsets: indices)
                    save(courses)
                }
                .onMove { indices, newOffset in
                    self.courses.move(fromOffsets: indices, toOffset: newOffset)
                    save(courses)
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
            retrieveStoredData()
        }) {
            AddCourse(courses: courses)
        }
        .onAppear {
            retrieveStoredData()
        }
    }
    
    func retrieveStoredData() {
        if let data = UserDefaults.standard.value(forKey: "courses") as? Data {
            if let coursesData = try? JSONDecoder().decode([Course].self, from: data) {
                self.courses = coursesData
            }
        }
    }
    
    func save(_ courses: [Course]) {
        do {
            let data = try JSONEncoder().encode(courses)
            UserDefaults.standard.set(data, forKey: "courses")
        }
        catch {}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(courses: [Course(name: "Mathematics 101", semester: "Spring", year: 2023, grades: [Grade(name: "Exam 1", grade: 82, weight: 45)]), Course(name: "Physics 101", semester: "Fall", year: 2024, grades: [Grade(name: "Exam 2", grade: 75, weight: 55)])])
    }
}
