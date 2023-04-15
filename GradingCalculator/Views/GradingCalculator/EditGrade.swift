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
    
    @State var course: Course
    @State var currentGrade: Grade
    @State var title = ""
    @State var grade = ""
    @State var weight = ""
    @State private var showAlert = false
    @State var colorSelection: String = ".systemBackground"
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var grades: FetchedResults<Grade>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Course.order)]) var courses: FetchedResults<Course>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("", text: $title)
                        .placeholder(when: title.isEmpty) {
                            Text(currentGrade.name ?? "")
                        }
                } header: {
                    Text("Grade Title")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color("DarkSecondary") : Color(.white)) : Color(colorSelection))
                Section {
                    TextField("", text: $grade)
                        .keyboardType(.decimalPad)
                        .placeholder(when: grade.isEmpty) {
                            Text(String(currentGrade.grade))
                        }
                } header: {
                    Text("Grade (%)")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color("DarkSecondary") : Color(.white)) : Color(colorSelection))
                Section {
                    TextField("", text: $weight)
                        .keyboardType(.decimalPad)
                        .placeholder(when: weight.isEmpty) {
                            Text(String(currentGrade.weight))
                        }
                } header: {
                    Text("Weight (%)")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color("DarkSecondary") : Color(.white)) : Color(colorSelection))
                Section {
                    Button("Submit Changes") {
                        if !title.isEmpty || !grade.isEmpty || !weight.isEmpty {
                            var gradeIndex = 0
                            for i in 0..<course.gradeArray.count {
                                if course.gradeArray[i].id == currentGrade.id {
                                    gradeIndex = i
                                }
                            }
                            var myArray = course.grades?.array as? [Grade]
                                if !title.isEmpty {
                                    currentGrade.name = title
                                }
                                if !self.grade.isEmpty {
                                   currentGrade.grade = Double(self.grade) ?? 0.0
                                }
                                if !weight.isEmpty {
                                    currentGrade.weight = Double(self.weight) ?? 0.0
                                }
                            myArray?[gradeIndex] = currentGrade
                            for grade in (course.grades?.array as? [Grade])! {
                                course.addToGrades(grade)
                            }
                                dataManager.save()
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
                .listRowBackground(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color("DarkSecondary") : Color(.white)) : Color(colorSelection))
            }
            .background(colorSelection == ".systemBackground" ? (colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.secondarySystemBackground)) : Color(colorSelection).opacity(1))
            .scrollContentBackground(.hidden)
            .navigationBarTitle(Text("Edit Grade"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
        .onAppear {
            if let color = UserDefaults.standard.value(forKey: "colorTheme") as? String {
                colorSelection = color
            }
        }
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

extension NSSet {
    func toArray<S>(_ of: S.Type) -> [S] {
        let array = self.map({$0 as! S})
        return array
    }
}
