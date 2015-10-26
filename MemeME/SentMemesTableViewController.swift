//
//  MeMeTableViewController.swift
//  MemeME
//
//  Created by Sebas on 10/22/15.
//  Copyright © 2015 Sebas. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var memes: [Meme]!
    var deleteMemeIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //set navigation bar title
        navigationItem.title = "Sent Memes"
        tableView.reloadData()
    }
    
     //table delegate methods
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
   
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteMemeIndexPath = indexPath
            let memeToDelete = appDelegate.memes[indexPath.row].topString
            confirmDelete(memeToDelete)
        }
    }
    
    // Delete Confirmation and Handling
    func confirmDelete(meme: String!) {
        let alert = UIAlertController(title: "Delete meme", message: "Are you sure you want to permanently delete \(meme)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteMemeIndexPath {
            tableView.beginUpdates()
            
            appDelegate.memes.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteMemeIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deleteMemeIndexPath = nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //identify number of rows in table based on number of Memes in array
        return appDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //set cell data for each row in the table
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath)
        
        cell.imageView?.image = appDelegate.memes[indexPath.row].memedImage
        cell.textLabel?.text = appDelegate.memes[indexPath.row].topString
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //set data for view controller
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("SentMemesDetailViewController") as! SentMemesDetailViewController
        detailController.savedMeme = appDelegate.memes[indexPath.row]
        
        //Open SentMemesDetailViewController
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}