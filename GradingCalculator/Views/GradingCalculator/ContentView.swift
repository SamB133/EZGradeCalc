//
//  ContentView.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/22/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\Course.order, order: .forward), SortDescriptor(\Course.date, order: .reverse)]) var courses: FetchedResults<Course>
    @State var showAddCourse = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataController: DataManager
    @EnvironmentObject var colorManager: ColorManager
    
    var body: some View {
        if courses.count == 0 {
            NavigationStack {
                List {
                    Section {
                        Button("Add A Course") {
                            showAddCourse.toggle()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                }
                .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                .navigationBarTitle("Courses")
            }
            .sheet(isPresented: $showAddCourse, onDismiss: {
            }) {
                AddCourse(courses: _courses)
                    .environmentObject(colorManager)
            }
        }else {
            NavigationStack {
                List {
                    ForEach(courses, id: \.date) { course in
                        VStack(alignment: .leading) {
                            NavigationLink {
                                CalculateGrade(course: course)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(course.name ?? "")
                                    Text("\(course.semester ?? "") \(String(course.year))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
                    }.onDelete(perform: { set in
                        dataController.onDelete(at: set, courses: courses)
                    })
                    .onMove { set, destinaton in
                        dataController.moveItem(at: set, destination: destinaton, courses: courses)
                    }
                }
                .background(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                .navigationBarTitle("Courses")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddCourse.toggle()
                        } label: {
                            Text("Add Course")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        if courses.count > 0 {
                            EditButton()
                        }
                    }
                }
            }
            .onAppear {
                colorManager.colorSelection = colorManager.getColorForKey(.colorThemeKey)
            }
            .sheet(isPresented: $showAddCourse, onDismiss: {
            }) {
                AddCourse(courses: _courses)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataManager.sharedManager)
    }
}
