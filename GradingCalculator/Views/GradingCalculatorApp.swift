//
//  GradingCalculatorApp.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 3/22/23.
//

import SwiftUI


struct TabItemData {
    let image: String
    let selectedImage: String
    let title: String
}

@main struct GradingCalculatorApp: App {
    
    @StateObject private var dataController = DataManager()
    @StateObject private var colorManager = ColorManager()
    @Environment(\.scenePhase) var scenePhase
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
                }
                .toolbarBackground(colorManager.getColorSystemBackSecondaryBack(colorScheme: colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light).opacity(1), for: .tabBar)
                .toolbar(.visible, for: .tabBar)
            }
            .preferredColorScheme(colorManager.colorMode == ColorThemeColors.dark.rawValue ? .dark : .light)
        }
        .onChange(of: scenePhase) { _ in
            dataController.save()
        }
    }
}
