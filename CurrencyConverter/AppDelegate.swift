//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 20/08/2025.
//

import netfox
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        #if DEBUG
        NFX.sharedInstance().start()
        print("Staging")
        #else
        print("Production")
        #endif
        return true
    }
}
