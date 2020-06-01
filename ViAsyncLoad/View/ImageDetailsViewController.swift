//
//  ImageDetailsViewController.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation
import UIKit

class ImageDetailsViewController :UIViewController{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var resolution: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    var imageUrl:URL = URL(string:"about:blank")!
    override func viewDidLoad() {
        if let backgroundImage = UIImage(named: "background.jpg"){
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }else{
            view.backgroundColor = .black
        }
        if let image = LocalFileManager.shared.retrieveImage(forKey: imageUrl){
            self.image.image = image
            setupImage()
        }
        setupUrlLabel()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let delegate = UIApplication.shared.delegate as? AppDelegate{
//            delegate.orientationLock = .portrait
//            UIDevice.current.setValue(UIInterfaceOrientationMask.portrait.rawValue, forKey: "orientation")
//            UINavigationController.attemptRotationToDeviceOrientation()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if let delegate = UIApplication.shared.delegate as? AppDelegate{
//            delegate.orientationLock = .all
//            UIDevice.current.setValue(UIInterfaceOrientationMask.all.rawValue, forKey: "orientation")
//            UINavigationController.attemptRotationToDeviceOrientation()
//        }
//    }
    
    func configer(imageUrl:URL){
        self.imageUrl = imageUrl
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        UIApplication.shared.open(imageUrl)
    }
    
    private func setupUrlLabel(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageDetailsViewController.tapFunction))
               url.isUserInteractionEnabled = true
               url.addGestureRecognizer(tap)
               
               let text = imageUrl.absoluteString
               let textRange = NSMakeRange(0, text.count)
               let attributedText = NSMutableAttributedString(string: text)
               attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
               attributedText.addAttribute(NSAttributedString.Key.foregroundColor , value: UIColor.systemBlue, range: textRange)
               self.url.attributedText = attributedText
    }
    private func setupImage(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width - 20
        let screenHeight = screenSize.height - 100
        
        var width = CGFloat(self.image.image?.size.width ?? screenWidth)
        var height = CGFloat(self.image.image?.size.height ?? screenHeight)
        let ratio = CGFloat(width/height)
        
        resolution.text = String(format: "%.0f * %.0f", width,height)
        if width > screenWidth{
            width = screenWidth
            height = width/ratio
        }
        
        if height > screenHeight{
            height = screenHeight
            width = height*ratio
        }
        
        imageHeight.constant = height
        imageWidth.constant = width
        
    }
}

