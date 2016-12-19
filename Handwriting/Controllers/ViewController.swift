//
//  ViewController.swift
//  Handwriting
//
//  Created by Igor Angelov on 17/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(myGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Dismiss curent Keyboard
     */
    func dismissKeyboard()
    {
         view.endEditing(true)
    }
    
    // MARK: - TableView delegate
    
    /**
     Tableview delegate remove fake placeholder
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (textView.text == "Saisir votre text")
        {
            textView.text = ""
        }
    }

}

