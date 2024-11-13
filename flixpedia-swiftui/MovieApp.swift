//
//  flixpedia_swiftuiApp.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 12/11/24.
//

import SwiftUI
import RealmSwift

@main
struct MovieApp: SwiftUI.App {
    init() {
        migrateRealm()
    }

    var body: some Scene {
        WindowGroup {
            let interactor = MainInteractor(apiService: MovieAPIService())
            let viewModel = MainViewModel(interactor: interactor)
            MainScreenView(viewModel: viewModel)
        }
    }

    private func migrateRealm() {
        let config = Realm.Configuration(
            schemaVersion: 5,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 5 {
                    
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config

        // Try to open the Realm to ensure that migration is applied
        do {
            _ = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
}
