//
//  Constants.swift
//  PokeDex
//
//  Created by Finn Friedman-Olshan (student LM) on 1/2/25.
//

import Foundation
import SwiftUI


struct Constants {
    static let pixelBoldFont: Font = Font(UIFont(name: "Silkscreen-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24))
    static let pixelFont: Font = Font(UIFont(name: "Silkscreen-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16))
    
}

extension Color{
    static let backgroundRed = Color("Background")
    static let borderGrey = Color("Borderer")
    static let whiteFont = Color("Font")
}
