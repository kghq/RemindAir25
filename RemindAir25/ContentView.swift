//
//  ContentView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var exercises = Exercises()
    
    var body: some View {
        NavigationStack {
            // placeholder image if empty
            List(exercises.items) { exercise in
                
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem {
                    Button("Add", systemImage: "plus") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
