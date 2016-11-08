//
//  ViewController.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/7/16.
//  Copyright © 2016 Alexander Iashchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CaptureViewControllerDelegate {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    private lazy var captureVC: CaptureViewController = {
        let vc = CaptureViewController(inputs: [.video], outputs: [.stillImage])
        vc.captureDelegate = self
        return vc
    }()
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        captureVC.captureManager.refreshOrientation()
    }
    
    //MARK: IBActions
    
    @IBAction func handleTakePictureButton(_ sender: UIButton) {
        present(captureVC, animated: true, completion: nil)
    }
    
    //MARK: CaptureViewControllerDelegate
    
    public func captureViewController(_ controller: CaptureViewController, didCaptureStillImage image: UIImage?) {
        controller.dismiss(animated: true)
        
        guard let img = image else {
            print("Woops, we didn't get an image!")
            return
        }
        
        imageView.image = img
    }
    
}
