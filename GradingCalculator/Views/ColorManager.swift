//
//  ColorManager.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/15/23.
//

import Foundation
import SwiftUI

enum ColorThemeColors: String {
    case skyBlue = "SkyBlue"
    case systemDefault = "systemDefault"
    case systemBackground = "systemBackground"
    case black = "Black"
    case white = "White"
    case lightModeSecondaryText = "LightModeSecondaryText"
    case lightModeButtonText = "LightModeButtonText"
    case darkModeSecondaryText = "DarkModeSecondaryText"
    case darkModeButtonText = "DarkModeButtonText"
    case darkSecondary = "DarkSecondary"
    case deepOrange = "DeepOrange"
    case mintGreen = "MintGreen"
    case maroon = "Maroon"
    case noColor
    
    init?(rawValue: String) {
        switch rawValue {
        case "SkyBlue":
            self = .skyBlue
        case "systemDefault":
            self = .systemDefault
        case "systemBackground":
            self = .systemBackground
        case "DarkSecondary":
            self = .darkSecondary
        case "Black" :
            self = .black
        case "White":
            self = .white
        case "LightModeSecondaryText":
            self = .lightModeSecondaryText
        case "LightModeButtonText" :
            self = .lightModeButtonText
        case "DarkModeSecondaryText":
            self = .darkModeSecondaryText
        case "DarkModeButtonText":
            self = .darkModeButtonText
        case  "DeepOrange":
            self = .deepOrange
        case "MintGreen":
            self = .mintGreen
        case "Maroon":
            self = .maroon

        default:
            self = .noColor
        }
    }
}

enum ColorKey: String {
    case colorThemeKey = "colorTheme"
    case primaryTextColorKey = "primaryTextColor"
    case secondaryTextColorKey = "secondaryTextColor"
    case buttonTextColorKey = "buttonTextColor"
}

class ColorManager: ObservableObject {
    
    @Published var colorSelection: String = " "
    @Published var primaryTextColor: String = " "
    @Published var secondaryTextColor: String = " "
    @Published var buttonTextColor: String = " "
    @Published var colorThemes: [String: String] = [:]
    public static let shared = ColorManager()
    init() {
        if let color = UserDefaults.standard.value(forKey: "color") as? [String: String] {
            colorThemes = color
        }
        retrieve(key: .primaryTextColorKey)
        retrieve(key: .colorThemeKey)
        retrieve(key: .secondaryTextColorKey)
        retrieve(key: .buttonTextColorKey)
    }
    
    func saveColors() {
        UserDefaults.standard.set(colorThemes, forKey: "color")
    }
    
    func retrieve(key: ColorKey) {
        guard let dictonary = UserDefaults.standard.value(forKey: "color") as? [String: String] else
        {return }
        self.colorThemes = dictonary
        switch(key) {
        case .colorThemeKey:
            colorSelection = getColorForKey(.colorThemeKey)
        case .buttonTextColorKey:
            buttonTextColor = getColorForKey(.buttonTextColorKey)
        case .secondaryTextColorKey:
            secondaryTextColor = getColorForKey(.secondaryTextColorKey)
        case .primaryTextColorKey:
            primaryTextColor = getColorForKey(.primaryTextColorKey)
        }
    }
    
    private func set(key: String, value: String) {
        colorThemes[key] = value
        UserDefaults.standard.setValue(colorThemes, forKey: "color")
    }
}

extension ColorManager {
    
    func getColorDarkWhite (colorScheme: ColorScheme) -> Color {
        if colorSelection.isEmpty || colorSelection == " "{
            saveSystemDefault(colorScheme: colorScheme)
            return Color(colorSelection)
        }
        return  colorSelection == ColorThemeColors.systemBackground.rawValue ? (
            colorScheme == .dark ? Color(ColorThemeColors.darkSecondary.rawValue)
            : Color(ColorThemeColors.white.rawValue)):
                            Color(colorSelection)
    }
    func getColorSystemBackSecondaryBack(colorScheme: ColorScheme) -> Color {
        if colorSelection.isEmpty || colorSelection == " "{
            saveSystemDefault(colorScheme: colorScheme)
            return Color(colorSelection)
        }
        return  colorSelection == ColorThemeColors.systemBackground.rawValue ? (
            colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.secondarySystemBackground)): Color(colorSelection)
    }
    func getColor(colorScheme: ColorScheme, _ color1: UIColor = .clear, _ color2:UIColor = .clear) -> Color {
        return colorSelection == ColorThemeColors.systemBackground.rawValue ? (
            colorScheme == .dark ? Color(color1) : Color(color2)) : Color(colorSelection)
    }
    
    func getColor(colorScheme: ColorScheme, _ color1: ColorThemeColors = .noColor, _ color2:ColorThemeColors = .noColor) -> Color {
        return colorSelection == ColorThemeColors.systemBackground.rawValue ? (
            colorScheme == .dark ? Color(color1.rawValue) : Color(color2.rawValue)) : Color(colorSelection)
    }
    
    func getColorForKey(_ key: ColorKey) -> String {
        return colorThemes[key.rawValue] ?? ""
    }
    func getColorForKey(_ key: ColorKey) -> ColorThemeColors {
        return ColorThemeColors(rawValue:colorThemes[key.rawValue] ?? "") ?? .noColor
    }
    
    func saveSystemDefault(colorScheme: ColorScheme) {
      setColor(.colorThemeKey, .systemBackground, colorScheme: colorScheme)
        setColor(.primaryTextColorKey, .black, .white, colorScheme: colorScheme)
        setColor(.secondaryTextColorKey, .lightModeSecondaryText, .darkModeSecondaryText, colorScheme:  colorScheme)
        setColor(.buttonTextColorKey, .lightModeButtonText, .darkModeButtonText, colorScheme: colorScheme)
    }
    
    func setColor(_ key: ColorKey, _ lightMode: ColorThemeColors, _ darkMode : ColorThemeColors = .noColor, colorScheme: ColorScheme){
        if darkMode == .noColor {
            colorThemes[key.rawValue] = lightMode.rawValue
        }
        else {
            colorThemes[key.rawValue] = colorScheme == .light ? lightMode.rawValue : darkMode.rawValue
        }
        
        colorSelection = colorThemes[ColorKey.colorThemeKey.rawValue] ?? ""
        primaryTextColor = colorThemes[ColorKey.primaryTextColorKey.rawValue] ?? ""
        secondaryTextColor = colorThemes[ColorKey.secondaryTextColorKey.rawValue] ?? ""
        buttonTextColor = colorThemes[ColorKey.buttonTextColorKey.rawValue] ?? ""
        saveColors()
    }
}
