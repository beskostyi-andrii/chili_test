//
//  ChiliTestApp.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import SwiftUI

@main
struct ChiliTestApp: App {
    init() {
        DependencyContainer.register(APIClient())
    }
    
    var body: some Scene {
        WindowGroup {
            Search()
        }
    }
}
