//
//  Story.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 4/5/2022.
//

import UIKit
import FirebaseFirestoreSwift
import CloudKit

class Story: NSObject, Codable {
    
    @DocumentID var id: String?
    var prompt: Prompt?
    var text: String?
    var datePosted: Date?

}
