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
    @State var id: UUID?
    @State var isShow = false
    
    init(colorManager: ColorManager) {}

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Calculated GPA: ")
                        Text(calculatedGPA)
                            .frame(maxWidth: .infinity)
                    }
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme).glassEffect())
                Section {
                    TextField("Current Completed Credits", text: $currentCredits)
                        .keyboardType(.numberPad)
                        .focused($textFieldIsFocused)
                    TextField("Completed Grade Points Total", text: $currentGradePoints)
                        .keyboardType(.numberPad)
                        .focused($textFieldIsFocused)
                    Button("Apply Optional Fields Changes") {
                        textFieldIsFocused = false
                        if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) || (currentCredits.isEmpty && currentGradePoints.isEmpty)) {
                            calculatedGPA = calculateGPA()
                            if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) && GPAs.count == 0) {
                                calculatedGPA = calculateCurrentGPA()
                            }
                        } else {
                            showAlert = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                } header: {
                    Text("Optional for Cumulative GPA")
                } footer: {
                    Text("Fill out this section only if you want to calculate your overall cumulative GPA. Otherwise, leave blank to calculate only your semester GPA.\nAfter changes are made to the optional fields, press the \"Apply Optional Fields Changes\" button to apply the changes.")
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Missing Information"), message: Text("You have filled out only one of the optional fields. Please either have both fields filled out, or have both fields empty."), dismissButton: .default(Text("Ok")))
                }
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
                        EditGPACourse(gpa: gpaCourse, showView: $isShow, closure: { value in
                            if value {
                                if ((!currentCredits.isEmpty && currentGradePoints.isEmpty) || (currentCredits.isEmpty && !currentGradePoints.isEmpty)) {
                                    currentCredits = ""
                                    currentGradePoints = ""
                                }
                                calculatedGPA = calculateGPA()
                            }
                        })
                        .environmentObject(dataManager)
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
                    if ((!currentCredits.isEmpty && currentGradePoints.isEmpty) || (currentCredits.isEmpty && !currentGradePoints.isEmpty)) {
                        currentCredits = ""
                        currentGradePoints = ""
                    }
                    dataManager.onDelete(at: indices, courses: GPAs)
                    textFieldIsFocused = false
                    calculatedGPA = calculateGPA()
                }
            }
            .refreshable {
                if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) || (currentCredits.isEmpty && currentGradePoints.isEmpty)) {
                    calculatedGPA = calculateGPA()
                    if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) && GPAs.count == 0) {
                        calculatedGPA = calculateCurrentGPA()
                    }
                } else {
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Information"), message: Text("You have filled out only one of the optional fields. Please either have both fields filled out, or have both fields empty."), dismissButton: .default(Text("Ok")))
            }
            .scrollContentBackground(.hidden)
            .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme))
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("GPA")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if ((!currentCredits.isEmpty && currentGradePoints.isEmpty) || (currentCredits.isEmpty && !currentGradePoints.isEmpty)) {
                            currentCredits = ""
                            currentGradePoints = ""
                        }
                        addGPACourse.toggle()
                        textFieldIsFocused = false
                    } label: {
                        Text("Add Course")
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        textFieldIsFocused = false
                    }
                }
            }
            .sheet(isPresented: $addGPACourse, onDismiss: {
                textFieldIsFocused = false
            }) {
                AddGPACourse()
            }
        }
        .onAppear {
            colorManager.colorSelection = colorManager.getColorForKey(.colorThemeKey)
            if let currentCredits = UserDefaults.standard.string(forKey: "CurrentCredits") {
                self.currentCredits = currentCredits
            }
            if let currentGradePoints = UserDefaults.standard.string(forKey: "CurrentGradePoints") {
                self.currentGradePoints = currentGradePoints
            }
            calculatedGPA = calculateGPA()
        }
        .onChange(of: GPAs.count) {
            calculatedGPA = calculateGPA()
        }
        .onChange(of: currentCredits) { oldValue, newValue in
            UserDefaults.standard.setValue(newValue, forKey: "CurrentCredits")
        }
        .onChange(of: currentGradePoints) { oldValue, newValue in
            UserDefaults.standard.setValue(newValue, forKey: "CurrentGradePoints")
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

    func calculateCurrentGPA() -> String {
        let sumOfCredits = Int(currentCredits) ?? 0
        let gradePointsTotal = Double(currentGradePoints) ?? 0.0
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
