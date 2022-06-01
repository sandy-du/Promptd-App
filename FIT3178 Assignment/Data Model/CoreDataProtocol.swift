//
//  CoreDataProtocol.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 25/5/2022.
//

import Foundation

enum CoreDataDatabaseChange {
    case add
    case remove
    case update
}

enum CoreDataListenerType {
    case draft
    case all
}

protocol CoreDataListener: AnyObject {
    var listenerType: CoreDataListenerType {get set}
    func onDraftChange(change: CoreDataDatabaseChange, drafts: [StoryDraft])
}

protocol CoreDataProtocol: AnyObject {
    func cleanup()
    
    func addListener(listener: CoreDataListener)
    func removeListener(listener: CoreDataListener)
    func addDraft(prompt: FavouritePrompt, text: String) -> StoryDraft
    func deleteDraft(draft: StoryDraft)
}
