//
//  CapturePreviewView.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/7/16.
//  Copyright © 2016 Alexander Iashchuk. All rights reserved.
//

import UIKit
import AVFoundation

/**
 A UIView subclass that overrides the default `layerClass` with `AVCaptureVideoPreviewLayer.self`.
*/
open class CapturePreviewView: UIView {
  
  override open class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  fileprivate func setUp() {
    backgroundColor = .black
  }
  
}
