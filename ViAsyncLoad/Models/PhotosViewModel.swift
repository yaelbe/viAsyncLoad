//
//  PhotosViewModel.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewModel{
    
    private var photos :[PhotoRecord] = []
    let pendingOperations = DownloadOperations()
    var onDownloadComplited: ((IndexPath) -> Void)?
    
    init() {
        photos = allPhotos()
    }
    
    func itemCount()-> Int{
        return photos.count
    }
    
    func updateRecordState(at index:IndexPath, withState state:PhotoRecordState){
        var currentRecord = self.record(at: index)
        currentRecord.setState(state)
        photos[index.row] = currentRecord
    }
    
    func record (at index:IndexPath)->PhotoRecord{
        return photos[index.row]
    }
    
    func imageForCell(at index:IndexPath)->UIImage?{
        let photo = photos[index.row]
        if let imageData = LocalFileManager.shared.retrieveImage(forKey: photo.url){
            updateRecordState(at:index, withState:.downloaded)
            return imageData
        }
        var image: UIImage? = nil
        switch (photo.state) {
        case .failed:
            print("Failed to load")
        case .visable:
            startOperations(for: photo, at: index)
        case .downloaded:
            image = LocalFileManager.shared.retrieveImage(forKey: photo.url)
        default:
            break
        }
        return image
    }
    
    private func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        switch (photoRecord.state) {
        case .visable:
            startDownload(for: photoRecord, at: indexPath)
        default:
            break
        }
    }
    
    private func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloader = ImageDownloader(photoRecord)
        
        downloader.completionBlock = { [weak self]  in
            self?.updateRecordState(at: indexPath, withState: .downloaded)
            DispatchQueue.main.async {
                self?.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self?.onDownloadComplited?(indexPath)
            }
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells(_ pathsArray:[IndexPath]) {
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
    
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray)
        toBeCancelled.subtract(visiblePaths)
      
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
     
        for indexPath in toBeCancelled {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
        }
        resumeAllOperations()
    }
    
    private func allPhotos() -> [PhotoRecord] {
        var photos: [PhotoRecord] = []
        guard
            let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String: String]]
            else {
                return photos
        }
        for dictionary in photosFromPlist {
            if let url = Foundation.URL(string : dictionary["URL"] ?? "") {
                photos.append(PhotoRecord(url: url))
            }
        }
        return photos
    }
}
