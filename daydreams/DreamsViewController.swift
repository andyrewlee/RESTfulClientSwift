//
//  ViewController.swift
//  daydreams
//
//  Created by Jae Hoon Lee on 7/7/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//

import UIKit

class DreamsViewController: UITableViewController, DreamDetails {
    
    var dreams = [Dream]()
    
    var userIsEditingDream: Bool = false
    var editingDream: Dream?

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllDreams()
    }
    
    func getAllDreams() {
        dreams = [Dream]()
        if let urlToReq = NSURL(string: "https://protected-tundra-1202.herokuapp.com/dreams") {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfDreams = parseJSON(data)
                
                if let allDreams = arrOfDreams {
                    for dream in allDreams {
                        let object = dream as! NSDictionary
                        if object["story"] != nil && object["id"] != nil {
                            dreams.append(Dream(story: object["story"] as! String, id: (object["id"] as! Int)))
                        }
                    }
                }
                
            }
        }

        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            print(NSThread.isMainThread() ? "Main Thread" : "Not on Main Thread")
            self.tableView.reloadData()
        })

    }
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
            return arrOfObjects as? NSArray
        } catch {
            return nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dreams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DreamCell")!
        cell.textLabel?.text = dreams[indexPath.row].story
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        userIsEditingDream = true
        editingDream = dreams[indexPath.row]
        performSegueWithIdentifier("DreamDetailsSegue", sender: self)
    }
    
    func cancelButtonPressed(controller: DreamDetailsViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneButtonPressed(controller: DreamDetailsViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        getAllDreams()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DreamDetailsSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! DreamDetailsViewController
            controller.delegate = self
            
            if userIsEditingDream {
                if let dream = editingDream {
                    controller.editingDream = dream
                }
            }
            
            userIsEditingDream = false
            editingDream = nil
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let id = dreams[indexPath.row].id {
            if let urlToReq = NSURL(string: "https://protected-tundra-1202.herokuapp.com/dreams/\(id)") {
                let request = NSMutableURLRequest(URL: urlToReq)
                request.HTTPMethod = "DELETE"
                NSURLSession.sharedSession().dataTaskWithRequest(request)?.resume()
            }
        }
        
        dreams.removeAtIndex(indexPath.row)
        tableView.reloadData()
    }
}