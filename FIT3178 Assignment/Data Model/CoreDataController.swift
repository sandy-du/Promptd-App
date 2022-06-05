//
//  CoreDataController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 25/5/2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataController: NSObject, CoreDataProtocol, NSFetchedResultsControllerDelegate {
    
    var listeners = MulticastDelegate<CoreDataListener>()
    var persistentContainer: NSPersistentContainer
    
    // Monitor changes and tell all listeners when they occur
    var allDraftsFetchedResultsController: NSFetchedResultsController<StoryDraft>?

    override init() {
        persistentContainer = NSPersistentContainer(name: "PromptdCoreDataModel")
        persistentContainer.loadPersistentStores() { (description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
    }
    
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(listener: CoreDataListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .draft || listener.listenerType == .all {
            listener.onDraftChange(change: .update, drafts: fetchAllDrafts())
        }
    }
    
    func removeListener(listener: CoreDataListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: - Fetched Results Controller Protocol methods
    // This will be called whenever the FetchedResultsController detects a change to the result of its fetch.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allDraftsFetchedResultsController {
            listeners.invoke() { listener in
                if listener.listenerType == .draft || listener.listenerType == .all {
                    listener.onDraftChange(change: .update, drafts: fetchAllDrafts())
                }
            }
        }
    }
    
    // Retrieve all draft entities stored within persistent memory
    func fetchAllDrafts() -> [StoryDraft] {
        
        // Check if controller is instantiated
        if allDraftsFetchedResultsController == nil {
            let request: NSFetchRequest<StoryDraft> = StoryDraft.fetchRequest()
            // Need to change the primary key to id
            let nameSortDescriptor = NSSortDescriptor(key: "promptText", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allDraftsFetchedResultsController =
            NSFetchedResultsController<StoryDraft>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext,sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allDraftsFetchedResultsController?.delegate = self
            
            
            // Perform fetch request
            do {
                try allDraftsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        // Assuming it is instantiated, we check if it contains fetched objects. If it does, we return the array.
        if let drafts = allDraftsFetchedResultsController?.fetchedObjects {
            return drafts
        }
        
        return [StoryDraft]()
    }
    
    func addDraft(prompt: Prompt, text: String) -> StoryDraft {
        
        var draft: StoryDraft?
        
        // Checks if a draft already exists for this prompt
        // Reference: https://stackoverflow.com/questions/64192760/coredata-if-something-exists-dont-save-it-if-it-doesnt-exists-then-save-it
        do {
            let context = persistentContainer.viewContext
            let request: NSFetchRequest<StoryDraft> = StoryDraft.fetchRequest()
            request.predicate = NSPredicate(format: "promptText == %@", prompt.text!)
            let noRecords = try context.count(for: request)
            if noRecords == 0 {
                // If number of records is 0, the draft doesn't exist yet so add
                draft = NSEntityDescription.insertNewObject(forEntityName: "StoryDraft", into: persistentContainer.viewContext) as? StoryDraft
                draft!.promptImage = prompt.imageURL
                draft!.promptText = prompt.text
                draft!.draftText = text
            } else {
                request.fetchLimit = 1
                draft = try context.fetch(request).first
                draft?.draftText = text
            }
        } catch {
            print("Error saving context \(error)")
        }
        return draft!
    }
    
    func deleteDraft(draft: StoryDraft) {
        persistentContainer.viewContext.delete(draft)
    }
}

