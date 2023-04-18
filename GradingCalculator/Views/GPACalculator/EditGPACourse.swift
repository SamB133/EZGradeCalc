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
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var colorManager: ColorManager
    
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
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                Section {
                    TextField("", text: $grade)
                        .keyboardType(.decimalPad)
                        .placeholder(when: grade.isEmpty) {
                            Text(String(gpa.grade))
                        }
                } header: {
                    Text("Grade Point (on 4.0 scale)")
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                Section {
                    TextField("", text: $credits)
                        .keyboardType(.numberPad)
                        .placeholder(when: credits.isEmpty) {
                            Text(String(gpa.credits))
                        }
                } header: {
                    Text("Number of credits for course")
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
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
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
            }
            .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
            .scrollContentBackground(.hidden)
            .navigationBarTitle(Text("Edit GPA Course"))
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
        .onAppear {
            colorManager.colorSelection = colorManager.getColorForKey(.colorThemeKey)
        }
    }
}
    
//struct EditGPACourse_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGPACourse()
//    }
//}
