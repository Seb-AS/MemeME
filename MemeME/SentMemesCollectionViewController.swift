//
//  MeMeCollectionViewController.swift
//  MemeME
//
//  Created by Sebas on 10/22/15.
//  Copyright © 2015 Sebas. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedCell: SentMemesCollectionCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // set the Edit/Done button to the nav bar left button
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.reloadData()
        // disable the button if there are no memes (after a delete)
       navigationItem.leftBarButtonItem?.enabled = appDelegate.memes.count > 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //set navigation bar title
        navigationItem.title = "Sent Memes"
        collectionView.reloadData()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView!.reloadData()
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
        
        let totalWidth: CGFloat = (view.frame.width / 3)//3 columns
        let totalHeight: CGFloat = totalWidth
        
        return CGSizeMake(totalWidth, totalHeight)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! SentMemesCollectionCell
        let meme = appDelegate.memes
        
        selectedCell = cell
        
        // Set image in collection view
        selectedCell!.memeImage.image = meme[indexPath.item].memedImage
        
        selectedCell!.deleteButton.hidden = !editing
        selectedCell!.deleteButton.addTarget(self, action: "onPressDelete:", forControlEvents: .TouchUpInside)
        
        return selectedCell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //set data for view controller
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("SentMemesDetailViewController") as! SentMemesDetailViewController
        detailController.savedMeme = appDelegate.memes[indexPath.row]
        
        // Open SentMemesDetailViewController
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func onPressDelete(sender: UIButton) {
        // need to get to the cell from the button
        //let cell = sender.superview!.superview! as! SentMemesCollectionCell
        let index = collectionView!.indexPathForCell(selectedCell!)!
        appDelegate.memes.removeAtIndex(index.item)
        collectionView!.deleteItemsAtIndexPaths([index]);
        selectedCell = nil
        
        //if still items in the collections then don't change the button to edit
        let stillItems = appDelegate.memes.count > 0
        
        setEditing(stillItems, animated: true)
        navigationItem.leftBarButtonItem?.enabled = stillItems
    }
}

