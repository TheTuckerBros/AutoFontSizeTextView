//
//  FontSizer.swift
//  AutoFontTextField
//
//  Created by Barlow Tucker on 11/8/17.
//  Copyright © 2017 Barlow Tucker. All rights reserved.
//

import UIKit

public class FontSizer {
    private let minimumSize: CGFloat
    private let maximumSize: CGFloat?
    private let font: UIFont
    
    init(font: UIFont, minimum: Double, maximum: Double? = nil) {
        self.font = font
        self.minimumSize = CGFloat(minimum)
        
        if let max = maximum {
            self.maximumSize = CGFloat(max)
        } else {
            self.maximumSize = nil
        }
    }
    
    public func textViewSize(forArea area: CGSize, text: String) -> CGFloat {
        let textView = UITextView()
        let max = self.maximumSize ?? area.height - 10
        
        textView.text = text
        textView.font = self.font.withSize(max)
        
        return self.shrink(view: textView, area: area, currentSize: max)
    }
    
    public func labelSize(forArea area: CGSize, text: String) -> CGFloat {
        let label = UILabel()
        let max = self.maximumSize ?? area.height - 10
        
        label.text = text
        label.font = self.font.withSize(max)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return self.shrink(view: label, area: area, currentSize: max)
    }
    
    private func shouldShrink(view: UIView, area: CGSize, currentSize: CGFloat) -> Bool {
        let height = view.sizeThatFits(CGSize(width: area.width, height: CGFloat.greatestFiniteMagnitude)).height
        return (height > area.height) && (currentSize > self.minimumSize)
    }
    
    private func shrink(view: UIView, area: CGSize, currentSize: CGFloat) -> CGFloat {
        guard self.shouldShrink(view: view, area: area, currentSize: currentSize) else { return currentSize }
        
        let newSize = currentSize - 1
        
        if let textView = view as? UITextView {
            textView.font = self.font.withSize(newSize)
        } else if let label = view as? UILabel {
            label.font = self.font.withSize(newSize)
        } else {
            return currentSize
        }
        
        return self.shrink(view: view, area: area, currentSize:newSize)
    }
}

