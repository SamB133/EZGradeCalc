//
//  AddCourse.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/23/23.
//

import SwiftUI

struct AddCourse: View {
    
    @State var courses: [Course]
    @State var title = ""
    var semesters = ["Fall", "Spring", "Summer", "Winter"]
    @State var years: [Int] = []
    @State private var selectedSemester = ""
    @State private var selectedYear: Int = Date().addYear()
    @State private var yearsCount = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Course Title", text: $title)
                }
                Section {
                    Picker("Semester", selection: $selectedSemester) {
                        ForEach(semesters, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Section {
                    Button("Add Course") {
                        if title != "" && selectedSemester != "" {
                            let course = Course(name: title, semester: selectedSemester, year: selectedYear, grades: [])
                            courses.append(course)
                            do {
                                let data = try JSONEncoder().encode(courses)
                                UserDefaults.standard.set(data, forKey: "courses")
                            }
                            catch {}
                        }
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarTitle(Text("Add Course"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .onChange(of: selectedYear) { newValue in
                self.selectedYear = newValue
                print(newValue)
            }
            .onAppear {
                for i in Date().addYear()..<Date().addYear(11) {
                    years.append(i)
                }
                self.yearsCount = years.count
            }
        }
    }
}

extension Date {
    func addYear(_ yearCount: Int = 0) -> Int {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = yearCount
        let date = calendar.date(byAdding: dateComponents, to: self) ?? Date()
        return calendar.dateComponents([.year], from: date).year ?? 0
    }
}

struct AddCourse_Previews: PreviewProvider {
    static var previews: some View {
        AddCourse(courses: [Course(name: "Math", semester: "Spring", year: 2023, grades: [])])
    }
}
