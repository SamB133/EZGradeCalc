//
//  Settings.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/14/23.
//

import SwiftUI
import WebKit

struct Settings: View {
    
    @State var colorSelection: String = "systemBackground"
    @State var primaryTextColor: String = " "
    @State var secondaryTextColor: String = " "
    @State var buttonTextColor: String = " "
    @State private var isPresentContactUs = false
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var colorManager: ColorManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        colorManager.setColor(.colorSchemeKey, .light, colorScheme: colorScheme)
                        saveSystemDefault()
                    } label: {
                        Text("Light")
                            .foregroundColor(Color(ColorThemeColors.black.rawValue))
                    }
                    .listRowBackground(Color(ColorThemeColors.white.rawValue))
                    Button {
                        colorManager.setColor(.colorSchemeKey, .dark, colorScheme: colorScheme)
                        saveSystemDefault()
                    } label: {
                        Text("Dark")
                            .foregroundColor(Color(ColorThemeColors.white.rawValue))
                    }
                    .listRowBackground(Color(ColorThemeColors.darkSecondary.rawValue))
                    Button {
                        colorManager.setColor(.colorSchemeKey, .light, colorScheme: colorScheme)
                        colorManager.setColor(.colorThemeKey, .skyBlue, colorScheme: colorScheme)
                    } label: {
                        Text("Sky Blue")
                            .foregroundColor(Color(ColorThemeColors.black.rawValue))
                    }
                    .listRowBackground(Color("SkyBlue"))
                    Button {
                        colorManager.setColor(.colorSchemeKey, .dark, colorScheme: colorScheme)
                        colorManager.setColor(.colorThemeKey, .maroon, colorScheme: colorScheme)
                    } label: {
                        Text("Maroon")
                            .foregroundColor(Color(ColorThemeColors.white.rawValue))
                    }
                    .listRowBackground(Color("Maroon"))
                    Button {
                        colorManager.setColor(.colorSchemeKey, .light, colorScheme: colorScheme)
                        colorManager.setColor(.colorThemeKey, .mintGreen, colorScheme: colorScheme)
                    } label: {
                        Text("Mint Green")
                            .foregroundColor(Color(ColorThemeColors.black.rawValue))
                    }
                    .listRowBackground(Color("MintGreen"))
                    Button {
                        colorManager.setColor(.colorSchemeKey, .light, colorScheme: colorScheme)
                        colorManager.setColor(.colorThemeKey, .deepOrange, colorScheme: colorScheme)
                    } label: {
                        Text("Deep Orange")
                            .foregroundColor(Color(ColorThemeColors.black.rawValue))
                    }
                    .listRowBackground(Color("DeepOrange"))
                    Button {
                        colorManager.setColor(.colorSchemeKey, .light, colorScheme: colorScheme)
                        colorManager.setColor(.colorThemeKey, .lavender, colorScheme: colorScheme)
                    } label: {
                        Text("Lavender")
                            .foregroundColor(Color(ColorThemeColors.black.rawValue))
                    }
                    .listRowBackground(Color("Lavender"))
                    Button {
                        colorManager.setColor(.colorSchemeKey, .light, colorScheme: colorScheme)
                        colorManager.setColor(.colorThemeKey, .flamingo, colorScheme: colorScheme)
                    } label: {
                        Text("Flamingo")
                            .foregroundColor(Color(ColorThemeColors.black.rawValue))
                    }
                    .listRowBackground(Color("Flamingo"))
                } header: {
                    Text("Theme Selection")
                        .foregroundColor(Color(colorManager.secondaryTextColor))
                }
                Section {
                    Button("Contact Us") {
                        isPresentContactUs = true
                    }
                    .frame(maxWidth: .infinity)
                    .sheet(isPresented: $isPresentContactUs) {
                        NavigationStack {
                            ContactUs(url: URL(string: "https://samb133.github.io/EZGradeCalc-SupportSite/")!)
                                .ignoresSafeArea()
                                .navigationTitle("Contact Us")
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationBarItems(trailing: Button("Cancel") {
                                    isPresentContactUs = false
                                })
                        }
                    }
                }
                .listRowBackground(colorManager.getColorDarkWhite(colorScheme: colorScheme))
            }
            .background( colorManager.getColorSystemBackSecondaryBack(colorScheme: colorScheme).opacity(1))
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

struct ContactUs: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
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
