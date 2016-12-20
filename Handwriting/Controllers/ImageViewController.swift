//
//  ImageViewController.swift
//  Handwriting
//
//  Created by Igor Angelov on 19/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    
    var data : Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureImageView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureImageView(){
        
        if let imageView = self.imageView
        {
            imageView.image = UIImage.init(data: self.data!)
        }
    }
    

}
