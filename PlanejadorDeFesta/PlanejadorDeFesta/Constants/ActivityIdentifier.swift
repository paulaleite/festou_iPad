//
//  ActivityIdentifier.swift
//  PlanejadorDeFesta
//
//  Created by Paula Leite on 27/03/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
enum ActivityIdentifier: String {
    case partiesList = "br.lk.PlanejadorDeFesta.parties"
    case create = "br.lk.PlanejadorDeFesta.tasks"
  
    
    func sceneConfiguration() -> UISceneConfiguration {
        switch self {
        case .partiesList:
            return UISceneConfiguration(name: SceneConfigurationNames.standard, sessionRole: .windowApplication)
        case .create:
            return UISceneConfiguration(name: SceneConfigurationNames.newParty, sessionRole: .windowApplication
      )
    }
  }
}
