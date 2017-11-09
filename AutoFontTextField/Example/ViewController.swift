//
//  ViewController.swift
//  AutoFontTextField
//
//  Created by Barlow Tucker on 10/28/17.
//  Copyright © 2017 Barlow Tucker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    private var sizer:FontSizer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sizer = FontSizer(font: UIFont.systemFont(ofSize: 12), minimum: 8.0, maximum: 75.0)
        self.updateFontSize()
    }

    fileprivate func updateFontSize() {
        let size = self.sizer.textViewSize(forArea: self.textView.frame.size, text: self.textView.text)
        self.textView.font = self.textView.font?.withSize(size)
    }
}

extension ViewController: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Update Font Size
        self.updateFontSize()
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        // Update Font Size
        self.updateFontSize()
    }
}
