//
//  PreviewView.swift
//  Prestoid - Dropbox sync video camera app with speech to text recognition
//
//  Created by Alexander Iashchuk on 11/8/16.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), https://iashchuk.com
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


//class PreviewView: UIView {
//    
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//        return layer as! AVCaptureVideoPreviewLayer
//    }
//    
//    var session: AVCaptureSession? {
//        get {
//            return videoPreviewLayer.session
//        }
//        set {
//            videoPreviewLayer.session = newValue
//        }
//    }
//    
//    override class var layerClass: AnyClass {
//        return AVCaptureVideoPreviewLayer.self
//    }
//    
//}
