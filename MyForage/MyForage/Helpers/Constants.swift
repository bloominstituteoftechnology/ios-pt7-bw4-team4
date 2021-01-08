//
//  Constants.swift
//  MyForage
//
//  Created by Cora Jacobson on 12/16/20.
//

import Foundation

enum ReuseIdentifier {
    static let forageAnnotation = "ForageAnnotationView"
    static let forageCell = "ForageCell"
    static let noteCell = "NoteCell"
    static let weatherCell = "WeatherCell"
    static let headerView = "HeaderView"
    static let footerView = "FooterView"
}

enum MushroomType: String, CaseIterable, Identifiable {
    case chanterelle = "Chanterelle"
    case morel = "Morel"
    case lionsMain = "Lion's Mane"
    case oyster = "Oyster"
    case giantPuffBall = "Giant Puff Ball"
    case wineCap = "Wine Cap"
    case porcini = "Porcini"
    case shiitake = "Shiitake"
    case trumpet = "Trumpet"
    case other = "Other"
    
    var id: String { self.rawValue }
}
