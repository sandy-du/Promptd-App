//
//  User.swift
//  FIT3178 Assignment
//
//  User is anyone who uses the application. This maps users that some personal fields from stored in Firestore.
//
//  Created by Sandy Du on 18/5/2022.
//

import UIKit
import FirebaseFirestoreSwift
import CloudKit

class User: NSObject, Codable {
    
    @DocumentID var id: String?
    var uid: String?
    var username: String?
    var postedStories: [Story]?
    var friends: [User]?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case username
        case postedStories
        case friends
    }

}
