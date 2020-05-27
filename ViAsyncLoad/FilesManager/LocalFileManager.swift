//
//  LocalFileManager.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation
import UIKit

class LocalFileManager{
    static let shared = LocalFileManager()
    
    func store(imageData: Data,
               forKey key: String) {
        if let filePath = filePath(forKey: key) {
            do {
                try imageData.write(to: filePath,
                                    options: .atomic)
            } catch let err {
                print("Saving results in error: ", err)
            }
        }
    }
    
    func retrieveImage(forKey key: URL) -> UIImage? {
        if let filePath = self.filePath(forKey: (key.path as NSString).lastPathComponent),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {
                                                    return nil
        }
        return documentURL.appendingPathComponent(key)
    }
}
