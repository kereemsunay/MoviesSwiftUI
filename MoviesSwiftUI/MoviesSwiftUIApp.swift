//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 26.09.2020.
//

import SwiftUI
import UIKit
import Firebase

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(">> your code here !!")
        FirebaseApp.configure()
        return true
    }
}

@main
struct MoviesSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RepositoriesListContainer(viewModel: RepositoriesViewModel())
        }
    }
}
