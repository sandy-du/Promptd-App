//
//  Prompt.swift
//  FIT3178 Assignment
//
//  Prompt is the object of the various prompts constructed from images and text.
//
//  Created by Sandy Du on 5/6/2022.
//

import UIKit
import FirebaseFirestoreSwift
import CloudKit

class Prompt: NSObject, Codable {

    @DocumentID var id: String?
    var imageURL: String?
    var text: String?
}
