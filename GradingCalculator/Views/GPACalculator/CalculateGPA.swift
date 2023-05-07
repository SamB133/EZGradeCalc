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
    init(colorManager: ColorManager) {
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .prominent)
        appearance.backgroundColor = UIColor(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorManager.colorScheme).opacity(0.1))
        UIToolbar.appearance().barTintColor = UIColor(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light).opacity(1))
        UIToolbar.appearance().backgroundColor = UIColor(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light).opacity(1))
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
                            if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) && GPAs.count == 0) {
                                calculatedGPA = calculateCurrentGPA()
                            } else if calculatedGPA == "0.000" && (currentCredits.isEmpty && currentGradePoints.isEmpty) {
                               showAlert = true
                            }
                        }else {
                            showAlert = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .alert(isPresented: $showAlert) {
                    if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) || (currentCredits.isEmpty && currentGradePoints.isEmpty)) {
                        if calculatedGPA == "0.000" && (currentCredits.isEmpty && currentGradePoints.isEmpty) {
                           return Alert(title: Text("Nothing to Calculate"), message: Text("Please add at least one course, and/or fill out the optional fields, in order to calculate your GPA."), dismissButton: .default(Text("Ok")))
                        }
                    }
                    return Alert(title: Text("Missing Information"), message: Text("You have filled out only one of the optional fields. Please either have both fields filled out, or have both fields empty."), dismissButton: .default(Text("Ok")))
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
                    calculatedGPA = calculateGPA()
                    UserDefaults.standard.setValue(calculatedGPA, forKey: "gpa")
                }
            }
            .refreshable {
                if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) || (currentCredits.isEmpty && currentGradePoints.isEmpty)) {
                    calculatedGPA = calculateGPA()
                    if ((!currentCredits.isEmpty && !currentGradePoints.isEmpty) && GPAs.count == 0) {
                        calculatedGPA = calculateCurrentGPA()
                    }
                }
            }
            .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
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
            _ = calculateGPA()
            calculatedGPA = UserDefaults.standard.string(forKey: "gpa") ?? ""
            if let currentCredits = UserDefaults.standard.string(forKey: "CurrentCredits") {
                self.currentCredits = currentCredits
            }
            if let currentGradePoints = UserDefaults.standard.string(forKey: "CurrentGradePoints") {
                self.currentGradePoints = currentGradePoints
            }
        }
        .onChange(of: GPAs.count) { newValue in
            calculatedGPA = calculateGPA()
            UserDefaults.standard.setValue(calculatedGPA, forKey: "gpa")
        }
        .onChange(of: currentCredits) { newValue in
            UserDefaults.standard.setValue(newValue, forKey: "CurrentCredits")
        }
        .onChange(of: currentGradePoints) { newValue in
            UserDefaults.standard.setValue(newValue, forKey: "CurrentGradePoints")
        }
        .onDisappear{
            calculatedGPA = calculateGPA()
            UserDefaults.standard.setValue(calculatedGPA, forKey: "gpa")
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
        UserDefaults.standard.setValue(String(format: "%.3f", cumulativeGPA), forKey: "gpa")
        return String(format: "%.3f", cumulativeGPA)
    }
    
    func calculateCurrentGPA() -> String {
        let sumOfCredits = Int(currentCredits) ?? 0
        let gradePointsTotal = Double(currentGradePoints) ?? 0.0
        let cumulativeGPA = gradePointsTotal / Double(sumOfCredits)
        dataManager.saveGPA(gpa: cumulativeGPA)
        UserDefaults.standard.setValue(String(format: "%.3f", cumulativeGPA), forKey: "gpa")
        return String(format: "%.3f", cumulativeGPA)
    }
}

struct CalculateGPA_Previews: PreviewProvider {
    static var previews: some View {
        CalculateGPA(colorManager: ColorManager())
    }
}
