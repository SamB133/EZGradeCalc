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
    @State var buttonTextColor: String = " "
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var colorManager: ColorManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        saveSystemDefault()
                    } label: {
                        Text("System Default")
                    }
                    .listRowBackground(Color(.white))
                    Button {
                        colorManager.setColor(.colorThemeKey, .skyBlue, colorScheme: colorScheme)
                    } label: {
                        Text("Sky Blue")
                    }
                    .listRowBackground(Color("SkyBlue"))
                    Button {
                        colorManager.setColor(.colorThemeKey, .maroon, colorScheme: colorScheme)
                       
                    } label: {
                        Text("Maroon")
                            .foregroundColor(Color("White"))
                    }
                    .listRowBackground(Color("Maroon"))
                    Button {
                        colorManager.setColor(.colorThemeKey, .mintGreen, colorScheme: colorScheme)
                    } label: {
                        Text("Mint Green")
                    }
                    .listRowBackground(Color("MintGreen"))
                    Button {
                        colorManager.setColor(.colorThemeKey, .deepOrange, colorScheme: colorScheme)
                    } label: {
                        Text("Deep Orange")
                    }
                    .listRowBackground(Color("DeepOrange"))
                } header: {
                    Text("Theme Selection")
                        .foregroundColor(Color(colorManager.secondaryTextColor))
                }
            }
            .background( colorManager.colorSelection == "systemBackground"
            ? (colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.secondarySystemBackground)) : Color(colorManager.colorSelection).opacity(1))
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
        .onAppear {
            colorManager.colorSelection =  colorManager.getColorForKey(.colorThemeKey)
        }
        .onChange(of: colorSelection) { newValue in
            colorManager.setColor(.colorThemeKey, .init(rawValue: newValue) ?? .noColor, colorScheme: colorScheme)
            colorManager.saveColors()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(colorManager: ColorManager())
    }
}

extension UIColor {
    static func navPrimaryColor() -> UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
}

extension Settings {
    func saveSystemDefault() {
        colorManager.setColor(.colorThemeKey, .systemBackground, colorScheme: colorScheme)
        colorManager.setColor(.primaryTextColorKey, .black, .white, colorScheme: colorScheme)
        colorManager.setColor(.secondaryTextColorKey, .lightModeSecondaryText, .darkModeSecondaryText, colorScheme:  colorScheme)
        colorManager.setColor(.buttonTextColorKey, .lightModeButtonText, .darkModeButtonText, colorScheme: colorScheme)
    }
}
