//
//  Bundle+decode.swift
//  SaltMiniProject
//
//  Created by Hafshy Yazid Albisthami on 20/10/23.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not load \(file) in the project")
        }
        
        return loadedData
    }
}
