//
//  CalculateGPA.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/2/23.
//

import SwiftUI

struct CalculateGPA: View {
    
    @State var currentCredits = ""
    @State var currentGrapdePoints = ""
    @State var calculatedGPA = ""
    @State var addGPACourse = false
    @State private var showAlert = false
    @State private var showAlert2 = false
    @State var colorSelection: String = ".systemBackground"
    @EnvironmentObject var dataManager: DataManager
    @FocusState private var textFieldIsFocused: Bool
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \GPA.date, ascending: false)]) var GPAs: FetchedResults<GPA>
    
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
                        if ((!currentCredits.isEmpty && !currentGrapdePoints.isEmpty) || (currentCredits.isEmpty && currentGrapdePoints.isEmpty)) {
                            calculatedGPA = calculateGPA()
                            if calculatedGPA == "" {
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
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
                Section {
                    Section {
                        TextField("Current Completed Credits", text: $currentCredits)
                            .keyboardType(.numberPad)
                            .focused($textFieldIsFocused)
                    }
                    Section {
                        TextField("Completed Grade Points Total", text: $currentGrapdePoints)
                            .keyboardType(.numberPad)
                            .focused($textFieldIsFocused)
                    }
                } header: {
                    Text("Optional for Cumulative GPA")
                } footer: {
                    Text("Fill out this section only if you want to calculate your overall cumulative GPA. Otherwise, leave blank to calculate only your semester GPA.")
                }
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
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
                .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
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
                    .listRowBackground(colorSelection == ".systemBackground" ? Color(.white) : Color(colorSelection))
                }
                .onDelete { indices in
                    dataManager.onDelete(at: indices, courses: GPAs)
                    textFieldIsFocused = false
                }
            }
            .background(colorSelection == ".systemBackground" ? Color(UIColor.secondarySystemBackground) : Color(colorSelection).opacity(1))
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .navigationBarTitle("GPA")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addGPACourse.toggle()
                        textFieldIsFocused = false
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                }
            }
            .sheet(isPresented: $addGPACourse, onDismiss: {
                textFieldIsFocused = false
            }) {
                AddGPACourse()
            }
        }
        .onAppear {
            if let color = UserDefaults.standard.value(forKey: "colorTheme") as? String {
                colorSelection = color
            }
        }
    }
    
    func calculateGPA() -> String {
        guard GPAs.count > 0 else { return "" }
        var sumOfCredits = Int(currentCredits) ?? 0
        var gradePointsTotal = Double(currentGrapdePoints) ?? 0.0
        for GPA in GPAs {
            gradePointsTotal += (GPA.grade * Double(GPA.credits))
            sumOfCredits += Int(GPA.credits)
        }
        let cumulativeGPA = gradePointsTotal / Double(sumOfCredits)
        return String(format: "%.3f", cumulativeGPA)
    }
}

struct CalculateGPA_Previews: PreviewProvider {
    static var previews: some View {
        CalculateGPA()
    }
}
