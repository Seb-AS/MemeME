//
//  MeMeDetailViewController.swift
//  MemeME
//
//  Created by Sebas on 10/23/15.
//  Copyright © 2015 Sebas. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {
    
    @IBOutlet weak var detailView: UIImageView!
    
    var savedMeme: Meme!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailView.image = savedMeme.memedImage
    }
}