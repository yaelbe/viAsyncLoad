//
//  GalleryViewController.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoStreamViewController: UICollectionViewController {
    
    private let segueToDetailsName = "segueToDetails"
    let viewModel = PhotosViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "I ❤️ Marvel"
        if let backgroundImage = UIImage(named: "background.jpg"){
            collectionView?.backgroundColor = UIColor(patternImage: backgroundImage)
        }else{
            collectionView?.backgroundColor = .black
        }
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        viewModel.onDownloadComplited = { [weak self] indexPath in
            if (self?.collectionView.cellForItem(at: indexPath)) != nil{
                self?.collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}

extension PhotoStreamViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as!  PhotoCell
        viewModel.updateRecordState(at: indexPath,withState:.visable )
        cell.photo = viewModel.imageForCell(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let numberOfRows = 4
        var cellSize = CGSize(width: 200, height: 200)
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.top
                + flowLayout.sectionInset.bottom
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfRows - 1))
            let size = (collectionView.bounds.height - totalSpace) / CGFloat(numberOfRows)
            if let currentImage = viewModel.imageForCell(at: indexPath){
                let width = CGFloat(currentImage.size.width)
                let height = CGFloat(currentImage.size.height)
                let ratio = CGFloat(width/height)
                cellSize =  CGSize(width: min(Int(size * ratio),Int(collectionView.bounds.width - 32)), height: Int(size))
            }
        }
        return cellSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = viewModel.record(at: indexPath).url
        self.performSegue(withIdentifier: segueToDetailsName, sender: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToDetailsName{
            if let details = segue.destination as? ImageDetailsViewController , let url = sender as? URL{
                details.configer(imageUrl: url)
            }
        }
    }
    
    // MARK: - scrollview delegate methods
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            viewModel.loadImagesForOnscreenCells(collectionView.indexPathsForVisibleItems)
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.loadImagesForOnscreenCells(collectionView.indexPathsForVisibleItems)
    }
}
