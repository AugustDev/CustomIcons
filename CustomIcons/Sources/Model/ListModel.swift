//
//  ListModel.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import Foundation
import Combine

protocol ListModelType: class, ServiceInjected, JSONDecoderInjected {
    func get() -> AnyPublisher<[Icon], Error>
}

final class ListModel: ListModelType {
    func get() -> AnyPublisher<[Icon], Error> {
        return service.get(EndPoint.remote)
            .decode(type: [Icon].self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
