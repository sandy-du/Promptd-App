//
//  StoryDraft+CoreDataProperties.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 25/5/2022.
//
//

import Foundation
import CoreData


extension StoryDraft {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoryDraft> {
        return NSFetchRequest<StoryDraft>(entityName: "StoryDraft")
    }

    @NSManaged public var promptImage: String?
    @NSManaged public var promptText: String?
    @NSManaged public var draftText: String?

}

extension StoryDraft : Identifiable {

}
