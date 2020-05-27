//
//  PhotoRecord.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit
import Foundation

struct PhotoRecord {
    public let url: URL
    public private(set) var state = PhotoRecordState.new
    
    init(url:URL) {
        self.url = url
    }
    
    mutating func setState(_ state:PhotoRecordState){
        self.state = state
    }
}



