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
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(sortDescriptors: []) var GPAs: FetchedResults<GPA>
    
    var body: some View {
        NavigationStack {
            List {
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
                ForEach (GPAs, id: \.id) { gpaCourse in
                    NavigationLink {
                        EditGPACourse(gpa: gpaCourse).environmentObject(dataManager)
                    } label: {
                        HStack {
                            Text(gpaCourse.name ?? "")
                            Spacer()
                            Text(String(gpaCourse.grade))
                                .padding(.trailing, 23)
                            Text(String(gpaCourse.credits))
                                .padding(.trailing, 13)
                        }
                    }
                }
                .onDelete { indices in
                    dataManager.onDelete(at: indices, courses: GPAs)
                }
                Section {
                    Section {
                        TextField("Current Completed Credits", text: $currentCredits)
                            .keyboardType(.numberPad)
                    }
                    Section {
                        TextField("Completed Grade Points Total", text: $currentGrapdePoints)
                            .keyboardType(.numberPad)
                    }
                } header: {
                    Text("Optional for Cumulative GPA")
                } footer: {
                    Text("Fill out this section only if you want to calculate your overall cumulative GPA. Otherwise, leave blank to calculate only your semester GPA.")
                }
                Section {
                    Button("Calculate GPA") {
                        if ((!currentCredits.isEmpty && !currentGrapdePoints.isEmpty) || (currentCredits.isEmpty && currentGrapdePoints.isEmpty)) {
                            calculatedGPA = calculateGPA()
                        } else {
                            showAlert.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Missing Information"), message: Text("You have filled out only one of the optional fields. Please either have both fields filled out, or have both fields empty."), dismissButton: .default(Text("Ok")))
                    }
                }
                HStack {
                    Text("Calculated GPA: ")
                    Text(calculatedGPA)
                        .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("GPA")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        addGPACourse.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .padding(.leading, 275)
                }
            }
            .sheet(isPresented: $addGPACourse, onDismiss: {
            }) {
                AddGPACourse()
            }
        }
    }
    
    func calculateGPA() -> String {
        var sumOfCredits = Int(currentCredits) ?? 0
        var gradePointsTotal = Double(currentGrapdePoints) ?? 0.0
        for GPA in GPAs {
            gradePointsTotal += (GPA.grade * Double(GPA.credits))
            sumOfCredits += Int(GPA.credits)
        }
        // foreach course: take the grade point and multiply it by the number of credits, and add that to the gradePointsTotal; Also in this loop, take the number of credits for each course and add them to the sumOfCredits
        let cumulativeGPA = gradePointsTotal / Double(sumOfCredits)
        return String(format: "%.3f", cumulativeGPA)
    }
}

struct CalculateGPA_Previews: PreviewProvider {
    static var previews: some View {
        CalculateGPA()
    }
}
