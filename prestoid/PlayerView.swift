//
//  PlayerView.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/10/16.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), https://iashchuk.com All rights reserved.
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
