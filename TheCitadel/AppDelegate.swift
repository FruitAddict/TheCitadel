//
//  AppDelegate.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 04/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = UIColor.appColor
        return true
    }
}

