//
//  Prospect.swift
//  HotProspects
//
//  Created by Gorkem Turan on 23.01.2023.
//

import SwiftUI

class Prospect: Identifiable, Codable, Equatable {
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var dateAdded = Date()
    fileprivate(set) var isContacted = false
    var formattedDate : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return formatter.string(from: dateAdded)
    }
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    let saveKey = "SavedData"
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    init() {
        // User Defaults
//        if let data = UserDefaults.standard.data(forKey: saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                people = decoded
//                return
//            }
//        }
//
//        people = []
        
        // Doc Directory
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }
    
    private func save() {
        // User Defaults
//        if let encoded = try? JSONEncoder().encode(people) {
//            UserDefaults.standard.set(encoded, forKey: saveKey)
//        }
        
        // Doc Directory
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
        
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    func remove(at selected: Prospect) {
        if let found = people.firstIndex(of: selected) {
            let idx: IndexSet = IndexSet(integer: found)
            
            people.remove(atOffsets: idx)
            save()
        }
    }

}
