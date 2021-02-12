//
//  DIContainer.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

// MARK: - InjectionMap
struct InjectionMap {}


// MARK: - Util
extension InjectionMap {
    
    static var window = UIWindow(frame: UIScreen.main.bounds)
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }
}

// MARK: UIWindow
protocol WindowInjected {}

extension WindowInjected {
    var window: UIWindow { get { return InjectionMap.window } }
}

// MARK: JSONDecoder
protocol JSONDecoderInjected {}

extension JSONDecoderInjected {
    var jsonDecoder: JSONDecoder { get { return InjectionMap.jsonDecoder } }
}
