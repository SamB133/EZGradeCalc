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
    @StateObject private var colorManager = ColorManager()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Group{
                    ContentView()
                        .tabItem {
                            Label("Grading Calculator", systemImage: "studentdesk")
                        }
                        .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(dataController)
                        .environmentObject(colorManager)
                    CalculateGPA(colorManager: colorManager)
                        .tabItem {
                            Label("GPA Calculator", systemImage: "list.bullet.clipboard.fill")
                        }
                        .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(dataController)
                        .environmentObject(colorManager)
                    Settings(colorManager: colorManager)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .environmentObject(colorManager)
                }.toolbarBackground(Color(colorManager.colorSelection), for: .tabBar)
                    .toolbar(.visible, for: .tabBar)
            }
            .preferredColorScheme(colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light)
        }
        .onChange(of: scenePhase) { _ in
            dataController.save()
        }
    }
}
