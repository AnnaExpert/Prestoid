//
//  PlayerView.swift
//  Prestoid - Dropbox sync video camera app with speech to text recognition
//  Application version 2.0, build 13, 2017.12.05
//
//  Created by Alexander Iashchuk on 11/10/16.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), http://iashchuk.com
//  Application owner - Scott Leatham. All rights reserved.
//


import UIKit
import AVFoundation

class PlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
}
