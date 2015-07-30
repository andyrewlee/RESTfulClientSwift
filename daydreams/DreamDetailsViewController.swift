//
//  DreamDetailsViewController.swift
//  daydreams
//
//  Created by Jae Hoon Lee on 7/7/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//

import UIKit

protocol DreamDetails: class {
    func doneButtonPressed(controller: DreamDetailsViewController)
    func cancelButtonPressed(controller: DreamDetailsViewController)
}

class DreamDetailsViewController: UITableViewController {
    
    weak var delegate: DreamDetails?
    
    var editingDream: Dream?

    @IBOutlet weak var dreamTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let dream = editingDream {
            dreamTextField.text = dream.story
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(self)
        editingDream = nil
    }
    
    @IBAction func addBarButtonPressed(sender: UIBarButtonItem) {
        if let dream = editingDream {
            dream.story = dreamTextField.text!
            if let urlToReq = NSURL(string: "https://protected-tundra-1202.herokuapp.com/dreams/\(dream.id!)") {
                let request = NSMutableURLRequest(URL: urlToReq)
                request.HTTPMethod = "PATCH"
                
                let bodyData = "story=\(dream.story)"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: afterRequest)!.resume()
            }
        } else {
            if let urlToReq = NSURL(string: "https://protected-tundra-1202.herokuapp.com/dreams") {
                let request = NSMutableURLRequest(URL: urlToReq)
                request.HTTPMethod = "POST"
                let bodyData = "story=\(dreamTextField.text!)"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: afterRequest)!.resume()
            }
        }
        
        editingDream = nil
    }
    
    func afterRequest(data: NSData?, response: NSURLResponse?, error: NSError?) {
        delegate?.doneButtonPressed(self)
    }
}