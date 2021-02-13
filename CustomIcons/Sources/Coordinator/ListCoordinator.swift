//
//  ListCoordinator.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

final class ListCoordinator: Coordinator, NavControllerInjected, ListControllerInjected {
    func start() {
        navController.pushViewController(listController, animated: false)
    }
}
