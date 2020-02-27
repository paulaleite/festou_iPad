//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Lia Kassardjian on 27/02/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    var keyboardView: UIView!
    
    var proxy: UITextDocumentProxy!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInterface()
        
        proxy = textDocumentProxy as UITextDocumentProxy
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

    @IBAction func clickButton(_ sender: UIButton) {
        let textBeforeInput = proxy.documentContextBeforeInput ?? "0"
        guard let currentNumber = Int(textBeforeInput) else {
                print("return")
                return
        }
        for _ in 1...(textBeforeInput).count {
            proxy.deleteBackward()
        }
        proxy.insertText(String(sender.tag + currentNumber))
    }
    
    func loadInterface() {
        let keyboardNib = UINib(nibName: "keyboard", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        keyboardView.frame.size = view.frame.size
        view.addSubview(keyboardView)
    }
    
    
}
