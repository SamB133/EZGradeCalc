//
//  ContentView.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/22/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\Course.order)]) var courses: FetchedResults<Course>
    @State var showAddCourse = false
    @EnvironmentObject var dataController: DataManager

    var body: some View {
        NavigationStack {
            List {
                ForEach(courses, id: \.id) { course in
                    VStack(alignment: .leading) {
                        NavigationLink {
                            CalculateGrade(course: course)
                                .environmentObject(dataController)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(course.name ?? "")
                                Text("\(course.semester ?? "") \(String(course.year))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }.onDelete(perform: { set in
                    dataController.onDelete(at: set, courses: courses)
                })
                .onMove { set, destinaton in
                    dataController.moveItem(at: set, destination: destinaton, courses: courses)
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("Courses")
            .navigationBarItems(trailing: EditButton())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAddCourse.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddCourse, onDismiss: {
        }) {
            AddCourse(courses: _courses)
        }
        .onAppear {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataManager.sharedManager)
    }
}
