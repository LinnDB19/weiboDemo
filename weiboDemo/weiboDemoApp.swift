//
//  weiboDemoApp.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/15.
//

import SwiftUI

//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//           return .portrait
//       }
//}

@main
struct weiboDemoApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(UserData())
        }
    }
}
