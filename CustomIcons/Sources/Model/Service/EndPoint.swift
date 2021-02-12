//
//  EndPoint.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import Foundation

protocol EndPointType {
    var url: URL? { get }
}

enum EndPoint: EndPointType {
    
    case remote
    case image(url: String)
    case mock
    
    var url: URL? {
        switch self {
        case .remote: return URL(string: "https://irapps.github.io/wzpsolutions/tests/ios-custom-icons/IconsData.json")
        case .image(let url): return URL(string: url)
        case .mock: return URL(fileURLWithPath: Bundle.main.path(forResource: "IconsData", ofType: "json") ?? "")
        }
    }
}
