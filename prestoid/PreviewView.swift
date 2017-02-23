//
//  PreviewView.swift
//  Prestoid - Dropbox sync video camera app with speech to text recognition
//  Application version 1.3, build 25, 2017.02.24
//
//  Created by Alexander Iashchuk on 11/8/16.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), http://iashchuk.com
//  Application owner - Scott Leatham. All rights reserved.
//


import UIKit
import AVFoundation

class PreviewView: UIView {
    
	var videoPreviewLayer: AVCaptureVideoPreviewLayer {
		return layer as! AVCaptureVideoPreviewLayer
	}
	
	var session: AVCaptureSession? {
		get {
			return videoPreviewLayer.session
		}
		set {
			videoPreviewLayer.session = newValue
		}
	}
    
    override class var layerClass: AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
    
}
