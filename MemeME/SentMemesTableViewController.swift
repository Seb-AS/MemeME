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
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //set navigation bar title
        self.navigationItem.title = "Sent Memes"
        self.tableView.reloadData()
    }
    
    //table delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //identify number of rows in table based on number of Memes in array
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //set cell data for each row in the table
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath)
        cell.imageView?.image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
        cell.textLabel?.text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].topString
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //set data for view controller
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemesDetailViewController") as! SentMemesDetailViewController
        detailController.savedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        //Open SentMemesDetailViewController
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}