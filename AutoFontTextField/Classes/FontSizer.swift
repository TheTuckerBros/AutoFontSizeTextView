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
    
    public func size(forArea area: CGSize, text: String) -> CGFloat {
        let textView = UITextView()
        let max = self.maximumSize ?? area.height - 10
        
        textView.text = text
        textView.font = self.font.withSize(max)
        
        return self.shrink(label: textView, area: area, currentSize: max)
    }
    
    private func shouldShrink(label: UITextView, area: CGSize) -> Bool {
        let height = label.sizeThatFits(CGSize(width: area.width, height: CGFloat.greatestFiniteMagnitude)).height
        return height > area.height
    }
    
    private func shrink(label: UITextView, area: CGSize, currentSize: CGFloat) -> CGFloat {
        guard self.shouldShrink(label: label, area: area) else { return currentSize }
        
        let newSize = currentSize - 1
        label.font = self.font.withSize(newSize)
        
        return self.shrink(label: label, area: area, currentSize:newSize)
    }
}
