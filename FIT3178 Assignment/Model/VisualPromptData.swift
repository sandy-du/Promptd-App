//
//  VisualPromptData.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 23/4/2022.
//

import UIKit

class VisualPromptData: NSObject, Decodable {
    
    var imageURL: String?
    
    private enum RootKeys: String, CodingKey {
        case urls
    }
    private enum ImageKeys: String, CodingKey {
        case small
    }
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the image links container for the thumbnail
        let imageContainer = try? rootContainer.nestedContainer(keyedBy: ImageKeys.self, forKey: .urls)
        
        // Get the url for small image
        imageURL = try imageContainer?.decode(String.self, forKey: .small)
    }
}
