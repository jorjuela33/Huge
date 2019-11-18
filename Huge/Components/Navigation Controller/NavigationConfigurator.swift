//
//  NavigationConfigurator.swift
//  Huge
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import UIKit.UIColor
import UIKit.UIImage

class NavigationConfigurator {
    let barTintColor: UIColor
    let navigationBarBackgroundImage: UIImage?
    let shadowImage: UIImage?
    let tintColor: UIColor

    static let `default` = NavigationConfigurator()

    // MARK: Initializers

    init(
        barTintColor: UIColor = #colorLiteral(red: 0.1137254902, green: 0.6784313725, blue: 0.137254902, alpha: 1),
        navigationBarBackgroundImage: UIImage? = nil,
        shadowImage: UIImage? = nil,
        tintColor: UIColor = .white
        ) {

        self.barTintColor = barTintColor
        self.navigationBarBackgroundImage = navigationBarBackgroundImage
        self.shadowImage = shadowImage
        self.tintColor = tintColor
    }
}
