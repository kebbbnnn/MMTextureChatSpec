//
//  TextNodeEx.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

extension ASTextNode{
    func addLinkDetection(_ text: String, highLightColor: UIColor) {
        self.isUserInteractionEnabled = true
        let types: NSTextCheckingResult.CheckingType = [.link]
        do{
            let detector = try NSDataDetector(types: types.rawValue)
            let range = NSMakeRange(0, (text as NSString).length)
            if let attributedText = self.attributedText {
                let mutableString = NSMutableAttributedString()
                mutableString.append(attributedText)
                detector.enumerateMatches(in: text, range: range) {
                    (result, _, _) in
                    if let fixedRange = result?.range {
                        mutableString.addAttribute(NSAttributedString.Key.underlineColor, value: highLightColor, range: fixedRange)
                        mutableString.addAttribute(NSAttributedString.Key.link, value: result?.url as Any , range: fixedRange)
                        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: highLightColor, range: fixedRange)
                        
                    }
                }
                self.attributedText = mutableString
            }
        }
        catch{
            
        }
        
    }
}

extension ASTextNode{
    
    
    func addUserMention(highLightColor : UIColor){
        
        if let attrText = self.attributedText{
            let replaced = NSMutableAttributedString(attributedString: attrText)
            var _ : [NSRange] = []

            do{
                let regex = try NSRegularExpression(pattern: "@(\\w+){1,}?", options: .caseInsensitive)
                
                
                let result = regex.matches(in: attrText.string, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0,(attrText.string as NSString).length))
                
               
                _ = NSMutableDictionary()
                for range in result{
                    replaced.addAttribute(NSAttributedString.Key.link, value: "ptuser", range: range.range)
                    replaced.addAttribute(NSAttributedString.Key.underlineColor, value: highLightColor, range: range.range)
                    replaced.addAttribute(NSAttributedString.Key.foregroundColor, value: highLightColor, range: range.range)
                    
                }
                
          
                
                
                self.attributedText = replaced
                
            }catch{}
        }
        
    }
    
}
