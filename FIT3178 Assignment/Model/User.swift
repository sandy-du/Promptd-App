//
//  User.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 18/5/2022.
//

import UIKit
import FirebaseFirestoreSwift
import CloudKit

class User: NSObject, Codable {
    
    @DocumentID var id: String?
    var uid: String?
    var stories: [Story] = []

}
