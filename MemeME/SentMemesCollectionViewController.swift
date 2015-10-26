//
//  MeMeCollectionViewController.swift
//  MemeME
//
//  Created by Sebas on 10/22/15.
//  Copyright © 2015 Sebas. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //set navigation bar title
        navigationItem.title = "Sent Memes"
        collectionView.reloadData()
    }
    
    //collection delegate methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let totalWidth: CGFloat = (self.view.frame.width / 3)//3 columns
        let totalHeight: CGFloat = totalWidth
        
        return CGSizeMake(totalWidth, totalHeight)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! SentMemesCollectionCell
        let meme = appDelegate.memes
        
        // Set image in collection view
        cell.memeImage.image = meme[indexPath.item].memedImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //set data for view controller
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("SentMemesDetailViewController") as! SentMemesDetailViewController
        detailController.savedMeme = appDelegate.memes[indexPath.row]
        
        // Open SentMemesDetailViewController
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}

