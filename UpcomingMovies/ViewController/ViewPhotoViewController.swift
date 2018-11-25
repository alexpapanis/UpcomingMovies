//
//  ViewPhotoViewController.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 23/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit
import Photos

class ViewPhotoViewController: UIViewController {
    
    //MARK: - Variables
    var image: UIImage?
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: - Actions
    @IBAction func closePhoto(_ sender: UIButton) {
        if let orientation = UIDevice.current.value(forKey: "orientation") as? Int {
            if orientation == Int(UIInterfaceOrientation.landscapeLeft.rawValue) || orientation == Int(UIInterfaceOrientation.landscapeRight.rawValue) {
                
                UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                
                let deadlineTime = DispatchTime.now() + .milliseconds(500)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    print("rotating image")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = image!
        
        photoImageView.isUserInteractionEnabled = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.downloadImage))
        photoImageView.addGestureRecognizer(longPressGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    //MARK: - Functions
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    @objc func downloadImage() {
        if let photoImage = photoImageView.image {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let downloadAction = UIAlertAction(title: "Save image", style: .default, handler: {action in
                
                UIImageWriteToSavedPhotosAlbum(photoImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(downloadAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("an error occurred! " + error.localizedDescription)
        } else {
            print("image saved successfully")
        }
    }
        
}
