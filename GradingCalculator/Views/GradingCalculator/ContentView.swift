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
    
    init() {
        let colorManager = ColorManager.shared
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .prominent)
        appearance.backgroundColor = UIColor(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light).opacity(0.1))
        UIToolbar.appearance().barTintColor = UIColor(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light).opacity(1))
        UIToolbar.appearance().backgroundColor = UIColor(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light).opacity(1))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
