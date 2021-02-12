//
//  ListCoordinator.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

final class ListCoordinator: Coordinator, NavControllerInjected {
    
    func start() {
        let controller = ListController()
        navController.pushViewController(controller, animated: false)
    }
}
