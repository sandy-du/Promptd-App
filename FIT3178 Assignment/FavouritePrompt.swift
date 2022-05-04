//
//  FavouritePrompt.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 4/5/2022.
//

import UIKit
import FirebaseFirestoreSwift
import CloudKit

class FavouritePrompt: NSObject, Codable {
    
    @DocumentID var id: String?
    var imageURL: String?
    var text: String?

}
