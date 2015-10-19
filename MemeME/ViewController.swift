//
//  ViewController.swift
//  MemeME
//
//  Created by Sebas on 10/13/15.
//  Copyright © 2015 Sebas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topMemeTextField: UITextField!
    @IBOutlet weak var bottomMemeTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    var activeTextField: String!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]
    
    //hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable sharebutton
        self.shareButton.enabled = false
        
        self.topMemeTextField.defaultTextAttributes = memeTextAttributes
        self.topMemeTextField.textAlignment = NSTextAlignment.Center
        self.topMemeTextField.text = "TOP"
        self.topMemeTextField.delegate = self
        
        self.bottomMemeTextField.defaultTextAttributes = memeTextAttributes
        self.bottomMemeTextField.textAlignment = NSTextAlignment.Center
        self.bottomMemeTextField.text  = "BOTTOM"
        self.bottomMemeTextField.delegate = self
        
        //set black background color
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //check for camera device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //add keyboard notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // UITextField Delegates //
    func textFieldDidBeginEditing(textField: UITextField) {
        print("[TextField] did begin editing method called")
        self.activeTextField = textField.text
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("[TextField] did end editing method called")
        
        if (textField.text == ""){
            textField.text = self.activeTextField
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("[TextField] should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("[TextField] should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("[TextField] should snd editing method called")
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("[TextField] While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("[TextField] should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        if bottomMemeTextField.isFirstResponder() {
            return keyboardSize.CGRectValue().height
        } else {
            
            return 0
        }
    }
    
    //shift view when keyboard displays so we don't obscure the text field
    func keyboardWillShow(notification: NSNotification) {
        if bottomMemeTextField.isFirstResponder() {
            
            //doesn't work
            //view.frame.origin.y -= getKeyboardHeight(notification)
            
            //disable camera and album
            self.albumButton.enabled = false
            self.cameraButton.enabled = false
            
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    //return view to original position when keyboard is dismissed
    func keyboardWillHide(notification: NSNotification) {
        if bottomMemeTextField.isFirstResponder() {
            
            //doesn't work
            //view.frame.origin.y += getKeyboardHeight(notification)
            
            //enable camera and album
            self.albumButton.enabled = true
            self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            
            self.view.frame.origin.y = 0
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //set selected image and aspect fit
            self.imagePickerView.image = image
            self.imagePickerView.contentMode = .ScaleAspectFit
            //enable share button
            self.shareButton.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("[imagePicker] Cancelled")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                print("[Error] sharing meme")
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        //cancel button pressed, dismiss Meme Editor
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.topMemeTextField.text = "TOP"
        self.bottomMemeTextField.text = "BOTTOM"
        self.imagePickerView.image = nil
    }
    
    func save(image: UIImage) {
        //Create the meme
        let meMe = Meme(topString: topMemeTextField.text!, bottomString: bottomMemeTextField.text!, originalImage: imagePickerView.image!, memedImage: image)
        
        //save generated meMe to shared model
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meMe)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbars
        self.topNavBar.hidden = true
        self.bottomToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbars
        self.topNavBar.hidden = false
        self.bottomToolBar.hidden = false
        
        return memedImage
    }
    
    func pickAnImage(type: String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //select spurcetype based on type string
        imagePicker.sourceType = type == "CAMERA" ? UIImagePickerControllerSourceType.Camera : UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        self.pickAnImage("CAMERA")
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        self.pickAnImage("ALBUM")
    }
}

