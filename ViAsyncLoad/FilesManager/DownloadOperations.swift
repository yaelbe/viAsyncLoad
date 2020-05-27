//
//  PendingOperations.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//



import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState {
    case new, downloaded, visable, failed
}

class DownloadOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
}

class ImageDownloader: Operation {
    
    var photoRecord: PhotoRecord
    
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    
    override func main() {
       
        guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
        
        if !imageData.isEmpty {
            LocalFileManager.shared.store(imageData: imageData, forKey: (photoRecord.url.path as NSString).lastPathComponent)
            photoRecord.setState(.downloaded)
        } else {
            photoRecord.setState(.failed)
        }
    }
}
