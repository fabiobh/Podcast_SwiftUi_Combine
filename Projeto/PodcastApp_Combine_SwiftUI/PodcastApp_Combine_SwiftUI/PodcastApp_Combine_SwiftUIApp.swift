//
//  PodcastApp_Combine_SwiftUIApp.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 08/12/24.
//

import SwiftUI

@main
struct PodcastApp_Combine_SwiftUIApp: App {
    @StateObject private var playerManager = PlayerManager()
    
    var body: some Scene {
       WindowGroup {
           ContentView()
               .environmentObject(playerManager)
       }
   }
}
