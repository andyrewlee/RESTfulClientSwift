//
//  Dream.swift
//  daydreams
//
//  Created by Jae Hoon Lee on 7/7/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//

import Foundation

class Dream {
    var story: String
    var id: Int?
    
    init(story: String, id: Int?) {
        self.id = id
        self.story = story
    }
}