//
//  AutoFontTextField.swift
//  AutoFontTextField
//
//  Created by Barlow Tucker on 10/28/17.
//  Copyright © 2017 Barlow Tucker. All rights reserved.
//

import UIKit

@IBDesignable
public class AutoFontTextView: UIView {
    // MARK: - IBInspectable variables
    @IBInspectable public var text: String {
        get { return self.textView.text }
        set { self.textView.text = self.text }
    }
    @IBInspectable public var minFontSize: Double = 12.0
    @IBInspectable public var maxFontSize: Double = 75.0
    @IBInspectable public var font: UIFont! = nil
    
    // MARK: - Variables
    weak var delegate:UITextViewDelegate? = nil

    // MARK: - Private variables
    private var textView: UITextView = UITextView()
    private var currentSize: Double = 0.0
    private var previousLength: Int = 0
    
    // MARK: - UIView Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateFontSize()
    }
    
    // MARK: - Private Methods
    private func setup() {
        let textView: UITextView = UITextView()
        textView.text = self.text
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: CGFloat(self.maxFontSize))
        textView.backgroundColor = self.backgroundColor

        self.textView = textView
        self.addSubview(textView)
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view" : textView])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : textView])
        
        self.addConstraints(hConstraints)
        self.addConstraints(vConstraints)
        
        self.currentSize = self.maxFontSize
        self.clipsToBounds = true
    }
    
    private func growFont() {
        guard (self.textView.contentSize.height + 1.0 < self.frame.size.height) && (self.text.count > 0) && (self.currentSize < self.maxFontSize) else { return }
        
        self.currentSize += 1.0
        self.textView.font = UIFont.systemFont(ofSize: CGFloat(self.currentSize))
        self.growFont()
    }
    
    private func shrinkFont() {
        guard (self.textView.contentSize.height > self.frame.size.height) && (self.currentSize > self.minFontSize) else { return }
        
        self.currentSize -= 1.0
        self.textView.font = UIFont.systemFont(ofSize: CGFloat(self.currentSize))
        self.shrinkFont()
    }
    
    fileprivate func updateFontSize() {
        // First we grow the font, then shrink if needed
        if (self.textView.contentSize.height + 1.0 < self.frame.size.height) && (self.currentSize < self.maxFontSize) {
            self.growFont()
        }

        if self.textView.contentSize.height > self.frame.size.height && self.currentSize > self.minFontSize {
            self.shrinkFont()
        }
        
        guard self.textView.contentSize.height < self.frame.size.height else { return }
        // Center the text Vertically
        var topCorrection = (self.frame.size.height - self.textView.contentSize.height * self.textView.zoomScale) / 2.0
        topCorrection = max(0, topCorrection)
        self.textView.transform = CGAffineTransform(translationX: 0, y: topCorrection)

        // Fix offset when the original size pushed to a new row
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
}

extension AutoFontTextView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Update Font Size
        self.updateFontSize()
        
        // Call delegate
        guard let delegate = self.delegate else { return true }
        return delegate.textViewShouldBeginEditing?(textView) ?? true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        // Update Font Size
        self.updateFontSize()
        
        // Call delegate
        guard let delegate = self.delegate else { return }
        delegate.textViewDidChange?(textView)
    }
}
