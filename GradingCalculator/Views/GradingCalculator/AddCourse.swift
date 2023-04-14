//
//  AddCourse.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/23/23.
//

import SwiftUI

struct AddCourse: View {
    
    @State var title = ""
    var semesters = ["Fall", "Spring", "Summer", "Winter"]
    @State var years: [Int] = []
    @State private var selectedSemester = ""
    @State private var selectedYear: Int = Date().addYear()
    @State private var yearsCount = 0
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var courses: FetchedResults<Course>
   
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Course Title", text: $title)
                } header: {
                    Text("Course Title")
                }
                Section {
                    Picker("Semester", selection: $selectedSemester) {
                        ForEach(semesters, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } header: {
                    Text("Semester")
                }
                Section {
                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("Year")
                }
                Section {
                    Button("Add Course") {
                        if !title.isEmpty && !selectedSemester.isEmpty {
                            dataManager.addCourse(name: title, semester: "\(selectedSemester)", year: Int16(selectedYear))
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

//struct AddCourse_Previews: PreviewProvider {
//    static var previews: some View {
//       
//        AddCourse(courses: courses)
//    }
//}
