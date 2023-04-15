//
//  Settings.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/14/23.
//

import SwiftUI

struct Settings: View {
    
    @State var colorSelection: String = ".systemBackground"
    @State var primaryTextColor: String = " "
    @State var secondaryTextColor: String = " "
    @State var buttonColor: String = " "
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        colorSelection = ".systemBackground"
                    } label: {
                        Text("System Default")
                    }
                    .listRowBackground(Color(.white))
                    Button {
                        colorSelection = "Dark"
                    } label: {
                        Text("Dark")
                    }
                    .listRowBackground(Color("Dark"))
                    Button {
                        colorSelection = "SkyBlue"
                    } label: {
                        Text("Sky Blue")
                    }
                    .listRowBackground(Color("SkyBlue"))
                    Button {
                        colorSelection = "Maroon"
                    } label: {
                        Text("Maroon")
                    }
                    .listRowBackground(Color("Maroon"))
                    Button {
                        colorSelection = "MintGreen"
                    } label: {
                        Text("Mint Green")
                    }
                    .listRowBackground(Color("MintGreen"))
                    Button {
                        colorSelection = "DeepOrange"
                    } label: {
                        Text("Deep Orange")
                    }
                    .listRowBackground(Color("DeepOrange"))
                } header: {
                    Text("Theme Selection")
                }
            }
            .background(colorSelection == ".systemBackground" ? Color(UIColor.secondarySystemBackground) : Color(colorSelection).opacity(1))
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
        .onAppear {
            if let color = UserDefaults.standard.value(forKey: "colorTheme") as? String {
                colorSelection = color
            }
        }
        .onChange(of: colorSelection) { newValue in
            UserDefaults.standard.set(colorSelection, forKey: "colorTheme")
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
