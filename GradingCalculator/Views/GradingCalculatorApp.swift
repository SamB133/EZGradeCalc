//
//  GradingCalculatorApp.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/22/23.
//

import SwiftUI

@main
struct GradingCalculatorApp: App {
    
    @StateObject private var dataController = DataManager()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                       Label("Grading Calculator", systemImage: "studentdesk")
                    }
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
                  
                CalculateGPA()
                    .tabItem {
                        Label("GPA Calculator", systemImage: "list.bullet.clipboard.fill")
                    }
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
            }
        }.onChange(of: scenePhase) { _ in
            dataController.save()
        }
    }
}
