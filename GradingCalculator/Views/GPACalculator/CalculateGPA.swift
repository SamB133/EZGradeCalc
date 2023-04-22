//
//  CalculateGPA.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/2/23.
//

import SwiftUI

struct CalculateGPA: View {
    
    @State var currentCredits = ""
    @State var currentGradePoints = ""
    @State var calculatedGPA = ""
    @State var addGPACourse = false
    @State private var showAlert = false
    @State private var showAlert2 = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \GPA.date, ascending: false)]) var GPAs: FetchedResults<GPA>
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) var commGPAs: FetchedResults<CommGPA>
    @EnvironmentObject var colorManager: ColorManager
    @FocusState private var textFieldIsFocused: Bool
    init(colorManager: ColorManager) {
        UIToolbar.appearance().barTintColor = UIColor(Color(colorManager.colorSelection))
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Calculated GPA: ")
                        Text(calculatedGPA)
                            .frame(maxWidth: .infinity)
                    }
                    Button("Calculate GPA") {
                        textFieldIsFocused = false
                        if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) || (currentCredits.isEmpty && currentGradePoints.isEmpty)) {
                            calculatedGPA = calculateGPA()
                            if calculatedGPA == "0.000" {
                                showAlert2.toggle()
                            }
                        } else {
                            showAlert.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Missing Information"), message: Text("You have filled out only one of the optional fields. Please either have both fields filled out, or have both fields empty."), dismissButton: .default(Text("Ok")))
                    }
                    .alert(isPresented: $showAlert2) {
                        Alert(title: Text("No Courses to Calculate"), message: Text("Please add at least one course in order to calculate your GPA."), dismissButton: .default(Text("Ok")))
                    }
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                Section {
                    Section {
                        TextField("Current Completed Credits", text: $currentCredits)
                            .keyboardType(.numberPad)
                            .focused($textFieldIsFocused)
                    }
                    Section {
                        TextField("Completed Grade Points Total", text: $currentGradePoints)
                            .keyboardType(.numberPad)
                            .focused($textFieldIsFocused)
                    }
                } header: {
                    Text("Optional for Cumulative GPA")
                } footer: {
                    Text("Fill out this section only if you want to calculate your overall cumulative GPA. Otherwise, leave blank to calculate only your semester GPA.")
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                HStack {
                    Text("Title")
                        .font(.system(size: 12))
                        .padding(.leading, 10)
                    Spacer()
                    Text("Grade(#)")
                        .font(.system(size: 12))
                    Text("Credits(#)")
                        .font(.system(size: 12))
                        .padding(.trailing, 20)
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                ForEach (GPAs, id: \.id) { gpaCourse in
                    NavigationLink {
                        EditGPACourse(gpa: gpaCourse).environmentObject(dataManager)
                    } label: {
                        HStack {
                            Text(gpaCourse.name ?? "")
                            Spacer()
                            Text(String(gpaCourse.grade))
                                .padding(.trailing, 36)
                            Text(String(gpaCourse.credits))
                                .padding(.trailing, 24)
                        }
                    }
                    .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                }
                .onDelete { indices in
                    dataManager.onDelete(at: indices, courses: GPAs)
                    textFieldIsFocused = false
                }
            }
            .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .navigationBarTitle("GPA")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addGPACourse.toggle()
                        textFieldIsFocused = false
                    } label: {
                        Text("Add Course")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if GPAs.count > 0 {
                        EditButton()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        textFieldIsFocused = false
                    }
                }
            }
            .toolbar(.visible, for: .automatic)
            .toolbarBackground(Color(colorManager.colorSelection), for: .automatic)
            .sheet(isPresented: $addGPACourse, onDismiss: {
                textFieldIsFocused = false
            }) {
                AddGPACourse()
            }
        }
        .onAppear {
            colorManager.colorSelection = colorManager.getColorForKey(.colorThemeKey)
            if let gpa = users.last?.gpa {
                calculatedGPA = gpa == 0 ? "0.000" : String(format: "%.3f", gpa)
            }
            if let currentCompletedCredits = commGPAs.last?.completedCredits{
                self.currentCredits = currentCompletedCredits == 0 ? "" : String(currentCompletedCredits)
            }
            if let currentCompletedGradePoints = commGPAs.last?.completedGradePoints {
                self.currentGradePoints = currentCompletedGradePoints == 0 ? "" : String(currentCompletedGradePoints)
            }
        }
        .onChange(of: GPAs.count) { newValue in
            calculatedGPA = calculateGPA()
            dataManager.saveGPA(gpa: Double(calculatedGPA) ?? 0.0)
        }
        .onChange(of: currentCredits) { newValue in
            dataManager.saveCompletedCredits(gpas: commGPAs, completedCredits: Int16(currentCredits) ?? 0, completedGradePoints: Int16(currentGradePoints) ?? 0)
        }
        .onChange(of: currentGradePoints) { newValue in
            dataManager.saveCompletedCredits(gpas: commGPAs, completedCredits: Int16(currentCredits) ?? 0, completedGradePoints: Int16(currentGradePoints) ?? 0)
        }
    }
    
    func calculateGPA() -> String {
        guard GPAs.count > 0 else { return "0.000" }
        var sumOfCredits = Int(currentCredits) ?? 0
        var gradePointsTotal = Double(currentGradePoints) ?? 0.0
        for GPA in GPAs {
            gradePointsTotal += (GPA.grade * Double(GPA.credits))
            sumOfCredits += Int(GPA.credits)
        }
        let cumulativeGPA = gradePointsTotal / Double(sumOfCredits)
        dataManager.saveGPA(gpa: cumulativeGPA)
        return String(format: "%.3f", cumulativeGPA)
    }
}

struct CalculateGPA_Previews: PreviewProvider {
    static var previews: some View {
        CalculateGPA(colorManager: ColorManager())
    }
}
