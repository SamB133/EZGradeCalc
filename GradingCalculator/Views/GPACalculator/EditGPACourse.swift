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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $title)
                        .placeholder(when: title.isEmpty) {
                            Text(gpa.name ?? "")
                        }
                } header: {
                    Text("Course Title")
                }
                Section {
                    TextField("", text: $grade)
                        .keyboardType(.numberPad)
                        .placeholder(when: grade.isEmpty) {
                            Text(String(gpa.grade))
                        }
                } header: {
                    Text("Grade Point (on 4.0 scale)")
                }
                Section {
                    TextField("", text: $credits)
                        .keyboardType(.numberPad)
                        .placeholder(when: credits.isEmpty) {
                            Text(String(gpa.credits))
                        }
                } header: {
                    Text("Number of credits for course")
                }
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
            }
            .navigationBarTitle(Text("Edit GPA Course"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}
    
//struct EditGPACourse_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGPACourse()
//    }
//}
