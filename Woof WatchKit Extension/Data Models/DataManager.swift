//
//  Walks.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/23/21.
//

import CoreData
import Foundation

// Main data manager to handle the todo items
class DataManager: NSObject, ObservableObject {
    // Dynamic properties that the UI will react to
    @Published var exerciseItems: [ExerciseItem] = [ExerciseItem]()
    
    // Add the Core Data container with the model name
    let container: NSPersistentContainer = NSPersistentContainer(name: "Model")
    
    // Default init method. Load the Core Data container
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }
}
