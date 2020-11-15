//
//  RandomController.swift
//  RandomPairs
//
//  Created by LAURA JELENICH on 11/15/20.
//

import Foundation

class RandomController {
    
    // MARK: - Shared Instance
    static let shared = RandomController()

    // MARK: - Source of truth
    var randomized: [Person] = []
    
    init() {
        loadFromPersistenStorage()
    }

    //MARK: - Helper Functions
    func makePairs() -> [[Person]] {
        let shuffledPairs = randomized.shuffled()

        var pairs = [[Person]]()
        var pair = [Person]()

        for name in shuffledPairs {
            if pair.count == 0 {
                pair.append(name)
            } else {
                pair.append(name)
                pairs.append(pair)
                pair = [Person]()
            }
        }
        if pair.count != 0 {
            pairs.append(pair)
        }
        return pairs
    }
    
    // MARK: - CRUD
    func create(name: String) {
        let randomName = Person(name: name)
        randomized.append(randomName)
        saveToPersistenStorage()
    }
 
    func delete(person: Person) {
        guard let index = randomized.firstIndex(of: person) else { return }
        randomized.remove(at: index)
        saveToPersistenStorage()
    }
    
    //MARK: - Save Functions
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "randomPairs.json"
        let documentDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentDirectoryURL
    }
    
    private func saveToPersistenStorage() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(randomized)
            try data.write(to: fileURL())
        } catch {
            print(error)
        }
    }
    
    private func loadFromPersistenStorage() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let randomized = try jsonDecoder.decode([Person].self, from: data)
            self.randomized = randomized
        } catch {
            print(error)
        }
    }
}
