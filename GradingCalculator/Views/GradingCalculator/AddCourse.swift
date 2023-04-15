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
    @State var colorSelection: String = ".systemBackground"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var courses: FetchedResults<Course>
   
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Course Title", text: $title)
                } header: {
                    Text("Course Title")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
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
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
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
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
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
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
            }
            .background(colorSelection == ".systemBackground" ? Color(UIColor.secondarySystemBackground) : Color(colorSelection).opacity(1))
            .scrollContentBackground(.hidden)
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
        .onAppear {
            if let color = UserDefaults.standard.value(forKey: "colorTheme") as? String {
                colorSelection = color
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
