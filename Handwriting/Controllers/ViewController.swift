//
//  ViewController.swift
//  Handwriting
//
//  Created by Igor Angelov on 17/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit
import MBProgressHUD

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
    
    @IBAction func sendText() {
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Chargement";
        spinnerActivity.detailsLabel.text = "Traitement des données ...";
        

        
        self.dismissKeyboard()
        ServicesManager.getRenderPNG(text: self.textView.text, callback: { (error , data ) in
            
            if let dataImage  = data 
            {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "imageViewController") as! ImageViewController
                detailVC.data = dataImage as? Data
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            spinnerActivity.hide(animated: false)
        })
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

