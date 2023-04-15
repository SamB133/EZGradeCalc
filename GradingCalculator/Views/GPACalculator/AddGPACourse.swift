//
//  AddGPACourse.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/2/23.
//

import SwiftUI

struct AddGPACourse: View {
    
    @State var title = ""
    @State var grade = ""
    @State var credits = ""
    @State private var showAlert = false
    @State var colorSelection: String = ".systemBackground"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
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
                    TextField("Grade Point (on 4.0 scale)", text: $grade)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Grade Point (on 4.0 scale)")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
                Section {
                    TextField("Number of credits for course", text: $credits)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Number of credits for course")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
                Section {
                    Button("Add Course") {
                        if !title.isEmpty && !grade.isEmpty && !credits.isEmpty {
                            dataManager.addGPA(name: title, grade: Double(grade) ?? 0.0, credits: Int(credits) ?? 0)
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
        }
        .onAppear {
            if let color = UserDefaults.standard.value(forKey: "colorTheme") as? String {
                colorSelection = color
            }
        }
    }
}

struct AddGPACourse_Previews: PreviewProvider {
    static var previews: some View {
        AddGPACourse()
    }
}
