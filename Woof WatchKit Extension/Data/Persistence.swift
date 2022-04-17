//
//  Persistence.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/16/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Exercise(context: viewContext)
            newItem.id = UUID()
            newItem.date = Date()
            newItem.duration = 0
        }
        do {
            try viewContext.save()
        } catch {
            // replace fatal error before shipping
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Exercises")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // replace later
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // error
            }
        }
    }
    
}

extension Exercise {
    static var todaysExercisesFetchRequest: NSFetchRequest<Exercise> {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", Date.now.stripTime() as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending:true)]
        
        return request
    }
    
}
