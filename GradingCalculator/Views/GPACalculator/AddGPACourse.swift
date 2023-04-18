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
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var colorManager: ColorManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Course Title", text: $title)
                } header: {
                    Text("Course Title")
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                Section {
                    TextField("Grade Point (on 4.0 scale)", text: $grade)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Grade Point (on 4.0 scale)")
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                Section {
                    TextField("Number of credits for course", text: $credits)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Number of credits for course")
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
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
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
            }
            .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
            .scrollContentBackground(.hidden)
            .navigationBarTitle(Text("Add Course"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
        .onAppear {
            colorManager.colorSelection = colorManager.getColorForKey(.colorThemeKey)
        }
    }
}

struct AddGPACourse_Previews: PreviewProvider {
    static var previews: some View {
        AddGPACourse()
    }
}
