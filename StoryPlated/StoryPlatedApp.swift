//
//  StoryPlatedApp.swift
//  StoryPlated
//
//  Created by Liyang Zhou on 5/31/25.
//

import SwiftUI

@main
struct StoryPlatedApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                RecipeListView()
                    .tabItem {
                        Label("Browse", systemImage: "book.fill")
                    }
                
                Text("My Recipes")
                    .tabItem {
                        Label("My Recipes", systemImage: "heart.fill")
                    }
                
                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

struct StoryPlatedApp_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            RecipeListView()
                .tabItem {
                    Label("Browse", systemImage: "book.fill")
                }
            
            Text("My Recipes")
                .tabItem {
                    Label("My Recipes", systemImage: "heart.fill")
                }
            
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}