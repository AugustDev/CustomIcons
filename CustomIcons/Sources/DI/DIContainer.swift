//
//  DIContainer.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

// MARK: - InjectionMap
struct InjectionMap {
    static var appCoordinator = AppCoordinator()
    static var listCoordinator = ListCoordinator()
    static var listController = ListController()
    static var listViewModel = ListViewModel()
    static var listModel: ListModelType = ListModel()
    static var service: ServiceType = Service()
    static var listViewLoader = ListViewLoader()
}

// MARK: AppCoordinator
protocol AppCoordinatorInjected {}

extension AppCoordinatorInjected {
    var appCoordinator: AppCoordinator { get { return InjectionMap.appCoordinator } }
}

// MARK: ListCoordinator
protocol ListCoordinatorInjected {}

extension ListCoordinatorInjected {
    var listCoordinator: ListCoordinator { get { return InjectionMap.listCoordinator } }
}

// MARK: ListController
protocol ListControllerInjected {}

extension ListControllerInjected {
    var listController: ListController { get { return InjectionMap.listController } }
}

// MARK: ListViewModel
protocol ListViewModelInjected {}

extension ListViewModelInjected {
    var listViewModel: ListViewModel { get { return InjectionMap.listViewModel } }
}

// MARK: ListModel
protocol ListModelInjected {}

extension ListModelInjected {
    var listModel: ListModelType { get { return InjectionMap.listModel } }
}

// MARK: Service
protocol ServiceInjected {}

extension ServiceInjected {
    var service: ServiceType { get { return InjectionMap.service } }
}

// MARK: ListViewLoader
protocol ListViewLoaderInjected {}

extension ListViewLoaderInjected {
    var listViewLoader: ListViewLoader { get { return InjectionMap.listViewLoader } }
}


// MARK: - Util
extension InjectionMap {
    
    static var window = UIWindow(frame: UIScreen.main.bounds)
    static var navController = UINavigationController()
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

// MARK: UINavigationController
protocol NavControllerInjected {}

extension NavControllerInjected {
    var navController: UINavigationController { get { return InjectionMap.navController } }
}

// MARK: JSONDecoder
protocol JSONDecoderInjected {}

extension JSONDecoderInjected {
    var jsonDecoder: JSONDecoder { get { return InjectionMap.jsonDecoder } }
}
