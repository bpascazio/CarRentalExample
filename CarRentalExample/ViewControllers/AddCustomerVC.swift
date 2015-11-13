//
//  AddCustomerVC.swift
//  CarRentalExample
//
//  Created by Bob Pascazio on 11/10/15.
//  Copyright © 2015 PACE. All rights reserved.
//

import UIKit

class AddCustomerVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let DSM = DataStoreManagerMem.sharedInstance
    let DSMDB = DataStoreManagerDB.sharedInstance

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var thumbConstraint: NSLayoutConstraint!
    @IBOutlet weak var customerNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var customerNameTextView: UITextField!
    @IBOutlet weak var thumbnailImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cancelButton.action = NSSelectorFromString("cancelHit:")
        saveButton.action = NSSelectorFromString("saveHit:")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        customerNameTextView.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.thumbConstraint.constant = 55
        self.customerNameTopConstraint.constant = 10
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.thumbConstraint.constant = 116
        self.customerNameTopConstraint.constant = 46
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelHit(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveHit(sender: UIBarButtonItem) {
        
        let imageData = UIImagePNGRepresentation(self.thumbnailImageView!.image!)
        
        let customer = Customer(name:self.customerNameTextView!.text!, photo: imageData!)
        
        DSM.addCustomer(customer)
        
        let customerDB = DSMDB.createCustomer()
        customerDB?.name = self.customerNameTextView!.text!
        DSMDB.saveContext()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func imageHit(sender: AnyObject) {
        
        let albumPickerController: UIImagePickerController = UIImagePickerController();
        
        albumPickerController.delegate = self;
        
        albumPickerController.modalPresentationStyle = UIModalPresentationStyle.FullScreen;
        albumPickerController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        
        presentViewController(albumPickerController, animated: true, completion: nil);
  
    }

    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String: AnyObject]){
                
        let editedImage: UIImage? = info[UIImagePickerControllerOriginalImage] as! UIImage?
        thumbnailImageView.image = editedImage
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    
}
