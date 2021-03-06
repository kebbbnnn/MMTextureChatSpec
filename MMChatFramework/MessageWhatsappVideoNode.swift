//
//  MessageWhatsappVideoNode.swift
//  MMTextureChat
//
//  Created by Mukesh on 19/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import ionicons

class MessageWhatsappVideoNode : ASDisplayNode{
    
    var videoNode : ASVideoNode
    private let isOutgoing: Bool
    private let playBut : ASButtonNode
    private let videoURL : String
    
    public init(url : String  , isOutgoing : Bool) {
        
        self.isOutgoing = isOutgoing
        
        
        videoNode = ASVideoNode()
        videoNode.cornerRadius = 6
        videoNode.clipsToBounds = true
        
        videoNode.shouldAutoplay = false
        self.videoURL = url
        videoNode.backgroundColor = UIColor.lightGray
        videoNode.style.preferredSize = CGSize(width: 210, height: 150)
        videoNode.gravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        
        playBut = ASButtonNode()
        playBut.style.preferredSize = CGSize(width: 50, height: 50)
        playBut.backgroundColor = UIColor.clear
        playBut.isUserInteractionEnabled = false
        playBut.setImage(IonIcons.image(withIcon:"\u{f488}", size: 40, color: UIColor.black), for: .normal)
        
        super.init()
        
        addSubnode(videoNode)
        addSubnode(playBut)
        
        
        
    }
    
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let verticalSpec = ASStackLayoutSpec()
        verticalSpec.direction = .vertical
        verticalSpec.spacing = 0
        verticalSpec.justifyContent = .start
        verticalSpec.alignItems = isOutgoing == true ? .end : .start
        
        verticalSpec.setChild(videoNode, at: 0)
        
        
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let insetSpec = ASInsetLayoutSpec(insets: insets, child: verticalSpec)
        
        let overlay = ASOverlayLayoutSpec(child: insetSpec, overlay: playBut)
        
        return overlay
        
        
    }
    
    
    override public func didLoad() {
        super.didLoad()
        
        if let temp = URL(string: self.videoURL){
            videoNode.asset = AVAsset(url: temp)
        }
        
    }
    
    
}
