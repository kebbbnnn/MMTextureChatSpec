
//
//  ChatAsyncCell.swift
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//


import UIKit
import AsyncDisplayKit

public let kAMMessageCellNodeAvatarImageSize: CGFloat = 24

public let kAMMessageCellNodeTopTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                  NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
public let kAMMessageCellNodeContentTopTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                         NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)]
public let kAMMessageCellNodeBottomTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                     NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)]
public let kAMMessageCellNodeBubbleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                 NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
public let kAMMessageCellNodeCaptionTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                      NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)]


@objc protocol ChatDelegate{
    
    //Bubble delegate
    func openImageGallery(message : Message)
    func openuserProfile(message : Message)
}


class ChatAsyncCell: ASCellNode,ASVideoNodeDelegate {
    
    fileprivate let avatarImageNode: ASNetworkImageNode?
    var bubbleNode: ASDisplayNode?
    fileprivate let contentTopTextNode : ASTextNode?
    fileprivate let topTextNode : ASTextNode?
    fileprivate let bottomTextNode : ASTextNode?
    fileprivate let message : Message?

    private let isOutgoing: Bool
    let bubbleImageProvider = MessageBubbleImageProvider()
    
    weak var delegate : ChatDelegate!
    
    
    
    func didTap(_ videoNode: ASVideoNode) {
        print("test video")
        if(delegate != nil){
            if let msg = message{
                self.delegate.openImageGallery(message: msg)
                
            }
        }

    }

    
    @objc func handleZoomTap() {
    
        if(delegate != nil){
            if let msg = message{
                self.delegate.openImageGallery(message: msg)
    
            }
        }
    
    }
    
    
    @objc func handleUserTap() {
    
        if(delegate != nil){
            if let msg = message{
                self.delegate.openuserProfile(message: msg)
    
            }
        }
    }
    
    


    
    
    init(message : Message? , isOutGoing : Bool) {
        
        
        self.message = message
        self.isOutgoing = isOutGoing
        let bubbleImg = bubbleImageProvider.bubbleImage(isOutgoing, hasTail: true)
        bubbleNode = nil
        contentTopTextNode = ASTextNode()
        
        //whatsapp
//        bubbleImg = isOutGoing ? UIImage(named : "bubbleMine")! : UIImage(named : "bubbleSomeone")!
        
        if let url = message?.videoUrl{
            
            bubbleNode = MessageVideoNode(url: url, bubbleImage: bubbleImg, isOutgoing: isOutgoing)
            
        }
        
        if let url = message?.imageUrl{
            
            let caption = message?.text == nil ? "" : message?.text?.string
            
            bubbleNode = MessageNetworkImageBubbleNode(img: url, text: NSAttributedString(string: caption!, attributes: kAMMessageCellNodeCaptionTextAttributes), isOutgoing: isOutgoing, bubbleImage: bubbleImg)
            
            
            
        }

        else{
            if let body = message?.text{
                bubbleNode = MessageTextBubbleNode(text: NSAttributedString(attributedString: body), isOutgoing: isOutgoing, bubbleImage: bubbleImg)
                
//                bubbleNode = MessageWhatsappBubbleNode(text: NSAttributedString(attributedString: body), isOutgoing: isOutGoing, time: NSAttributedString(string: "06.00 AM", attributes: kAMMessageCellNodeTopTextAttributes), bubbleImage: bubbleImg)
                
            }
        }
        

        if let name = message?.name{
            contentTopTextNode?.attributedText = NSAttributedString(string: name , attributes: kAMMessageCellNodeContentTopTextAttributes)
            
        }
        
        
        if let stamp = message?.sectionStamp{
            topTextNode = ASTextNode()
//            topTextNode?.backgroundColor = UIColor.red
                        
            topTextNode?.attributedText = NSAttributedString(string: stamp, attributes: kAMMessageCellNodeTopTextAttributes)
            topTextNode?.style.alignSelf = .center
            topTextNode?.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            
        }else{
            topTextNode = nil
        }
        
        
        
        
        if let time = message?.timestamp{
            bottomTextNode = ASTextNode()
            bottomTextNode?.attributedText = NSAttributedString(string: time, attributes: kAMMessageCellNodeBottomTextAttributes)
            bottomTextNode?.textContainerInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
            
        }else{
            bottomTextNode = nil
        }
       

        avatarImageNode = ASNetworkImageNode()
        //avatar
        if let avatarstr = message?.userImgURL{
            if let avatarurl = URL(string: avatarstr){
                avatarImageNode?.url = avatarurl

            }
            
        }else{
            avatarImageNode?.image = UIImage(named: "avatar")
        }

        if(isOutgoing){
            avatarImageNode?.style.preferredSize = CGSize.zero

            
        }else{
            avatarImageNode?.style.preferredSize = CGSize(width: kAMMessageCellNodeAvatarImageSize, height: kAMMessageCellNodeAvatarImageSize)
            avatarImageNode?.cornerRadius = kAMMessageCellNodeAvatarImageSize/2
            avatarImageNode?.clipsToBounds = true

        }
        
        bubbleNode?.style.flexShrink = 1.0


        super.init()
        if let _ = message?.videoUrl{
            addSubnode(bubbleNode!)
            (bubbleNode as! MessageVideoNode).videoNode.delegate = self

            
        }
        if let _ = message?.imageUrl{
            addSubnode(bubbleNode!)

        }else{
            if let _ = message?.text{
                addSubnode(bubbleNode!)
                
            }
        }
        

        addSubnode(avatarImageNode!)
        addSubnode(contentTopTextNode!)
        
        if let _ = message?.sectionStamp{
            addSubnode(topTextNode!)

        }
       
        
        if let _ = message?.timestamp{
            addSubnode(bottomTextNode!)
            
        }

        selectionStyle = .none
        
        //target
        if let node = bubbleNode as? MessageNetworkImageBubbleNode{
            node.messageImageNode.addTarget(self, action: #selector(handleZoomTap), forControlEvents: ASControlNodeEvent.touchUpInside)
            
        }
        avatarImageNode?.addTarget(self, action: #selector(handleUserTap), forControlEvents: ASControlNodeEvent.touchUpInside)

    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let contentTopFinal : ASLayoutSpec? = message?.name == nil ? nil : ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 20 + 24, bottom: 0, right: 0), child: contentTopTextNode!)

        let horizontalSpec = ASStackLayoutSpec()
        horizontalSpec.style.width = ASDimensionMakeWithPoints(constrainedSize.max.width)
        horizontalSpec.direction = .horizontal
        horizontalSpec.spacing = 2
        horizontalSpec.justifyContent = .start
        horizontalSpec.verticalAlignment = .bottom
        
        if isOutgoing {
            if let bub = bubbleNode{
                horizontalSpec.setChild(bub, at: 0)
  
            }
            if let avatar = avatarImageNode{
                horizontalSpec.setChild(avatar, at: 1)

            }
            horizontalSpec.style.alignSelf = .end
            horizontalSpec.horizontalAlignment = .right
            
        } else {
            
            if let avatar = avatarImageNode{
                horizontalSpec.setChild(avatar, at: 0)
                
            }
            if let bub = bubbleNode{
                horizontalSpec.setChild(bub, at: 1)
                
            }
            horizontalSpec.style.alignSelf = .end
            horizontalSpec.horizontalAlignment = .left
        }
        
        horizontalSpec.style.flexShrink = 1.0
        horizontalSpec.style.flexGrow = 1.0
        
        let verticalSpec = ASStackLayoutSpec()
        verticalSpec.direction = .vertical
        verticalSpec.spacing = 0
        verticalSpec.justifyContent = .start
        verticalSpec.alignItems = isOutgoing == true ? .end : .start
        

        
        if let contentTopFinal = contentTopFinal {
            verticalSpec.setChild(contentTopFinal, at: 0)
        }
        
        verticalSpec.setChild(horizontalSpec, at: 1)
        


        if let _ = message?.timestamp{
            if(isOutgoing){
                contentTopTextNode?.style.preferredSize = CGSize.zero
            }
            verticalSpec.setChild(bottomTextNode!, at: 2)
            
        }
        
        let insetSpec = ASInsetLayoutSpec(insets: isOutgoing ? UIEdgeInsets(top: 1, left: 32, bottom: 5, right: 4) : UIEdgeInsets(top: 1, left: 4, bottom: 5, right: 32), child: verticalSpec)

        if let _ = message?.sectionStamp{
            let stackLay = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topTextNode! , insetSpec])
            return stackLay
            
        }else{
            return insetSpec

        }
//        print(message?.text?.string)
        

    }
    
    


}
