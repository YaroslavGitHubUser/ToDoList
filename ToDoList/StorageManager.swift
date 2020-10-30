//
//  StorageManager.swift
//  ToDoList
//
//  Created by Yaroslav on 28.10.2020.
//  Copyright © 2020 Yaroslav. All rights reserved.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "KeyFive"
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var archieveURL: URL!
    
    private init() {
        archieveURL = documentDirectory.appendingPathComponent("Tasks").appendingPathExtension("plist")
    }

    //    Saving and fetching data - UserDefaults
//    func fetchTasks() -> [[Task]] {
//        if let savedTasks = userDefaults.object(forKey: key) as? Data {
//            if let loadedTasks = try? JSONDecoder().decode([[Task]].self, from: savedTasks) {
//                return loadedTasks
//            }
//        }
//        return [[], [], []]
//    }
//
//    func saveTask(with newTasks: [[Task]]) {
//        if let encoded = try? JSONEncoder().encode(newTasks) {
//            userDefaults.set(encoded, forKey: key)
//        }
//    }
    
    
    //Saving and fetching data - PLIST file
    func fetchTasksFromFile() -> [[Task]] {
        guard let data = try? Data(contentsOf: archieveURL) else { return [[], [], []] }
        guard let tasks = try? PropertyListDecoder().decode([[Task]].self, from: data) else { return [[], [], []] }
        return tasks
    }
    
    func saveTaskToFile(with newTasks: [[Task]]) {
        if let data = try? PropertyListEncoder().encode(newTasks) {
            try? data.write(to: archieveURL, options: .noFileProtection)
        }
    }
}

