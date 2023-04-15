//
//  EditGPACourse.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/2/23.
//

import SwiftUI

struct EditGPACourse: View {
    
    @State var title = ""
    @State var grade = ""
    @State var credits = ""
    @State var gpa: GPA
    @State private var showAlert = false
    @State var colorSelection: String = ".systemBackground"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("", text: $title)
                        .placeholder(when: title.isEmpty) {
                            Text(gpa.name ?? "")
                        }
                } header: {
                    Text("Course Title")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
                Section {
                    TextField("", text: $grade)
                        .keyboardType(.decimalPad)
                        .placeholder(when: grade.isEmpty) {
                            Text(String(gpa.grade))
                        }
                } header: {
                    Text("Grade Point (on 4.0 scale)")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
                Section {
                    TextField("", text: $credits)
                        .keyboardType(.numberPad)
                        .placeholder(when: credits.isEmpty) {
                            Text(String(gpa.credits))
                        }
                } header: {
                    Text("Number of credits for course")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
                Section {
                    Button("Submit Changes") {
                        if !title.isEmpty || !grade.isEmpty || !credits.isEmpty {
                            if !title.isEmpty {
                                gpa.name = title
                            }
                            if !self.grade.isEmpty {
                                gpa.grade = Double(grade) ?? 0.0
                            }
                            if !credits.isEmpty {
                                gpa.credits = Int16(credits) ?? 0
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
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
            }
            .background(colorSelection == ".systemBackground" ? Color(UIColor.secondarySystemBackground) : Color(colorSelection).opacity(1))
            .scrollContentBackground(.hidden)
            .navigationBarTitle(Text("Edit GPA Course"))
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
    
//struct EditGPACourse_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGPACourse()
//    }
//}
