//
//  ExcerciseStore.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 09/07/2025.
//

import Foundation

struct ExerciseStore {
    
    static func save<T: Codable>(_ items: T, to fileDirectory: String) {
        if let data = try? JSONEncoder().encode(items) {
            let url = URL.documentsDirectory.appending(path: fileDirectory)
            
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func load<T: Codable>(from fileDirectory: String) throws -> T {
        let url = URL.documentsDirectory.appending(path: fileDirectory)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
