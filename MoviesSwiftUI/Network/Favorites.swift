//
//  Favorites.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 27.10.2020.
//

import SwiftUI


class Favorites: ObservableObject {
    private var tasks: Set<Int>
    let defaults = UserDefaults.standard
    
    init() {
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey: "Favorites") as? Data {
            let taskData = try? decoder.decode(Set<Int>.self, from: data)
            self.tasks = taskData ?? []
            print("tasks",self.tasks)
        } else {
            self.tasks = []
            print("girmedi")
        }
        
    }
    
    
    func getTaskIds() {
        objectWillChange.send()
        
    }
    
    func isEmpty() -> Bool {
        tasks.count < 1
    }
    
    func contains(_ task: Movies) -> Bool {
        if let id = task.id{
         return tasks.contains(id)
        }else{
            print("containserror")
            return false
        }
        
    }
    
    func add(_ task: Movies) {
        objectWillChange.send()
        if let id = task.id{
            tasks.insert(id)
            save()
        }else{
            print("adderror")
        }
       
    }
    
    func remove(_ task: Movies) {
        objectWillChange.send()
        if let id = task.id{
            tasks.remove(id)
            save()
        }else{
            print("removeerror")
        }
       
    }
    
    func save() {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(tasks) {
                defaults.set(encoded, forKey: "Favorites")
            }
        }
    
}
