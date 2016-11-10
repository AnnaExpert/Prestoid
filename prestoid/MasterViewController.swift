//
//  MasterViewController.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/9/16.
//  Copyright © 2016 Alexander Iashchuk. All rights reserved.
//

import UIKit
import AVFoundation

class MasterViewController: UITableViewController {
    
    var detailViewController: PlayerViewController? = nil
    var videosArray: [String] = Array()
    var thumbnailsArray: [Data] = Array()
    let savedVideosArrayKey = "savedVideosArray"
    let thumbnailsArrayKey = "thumbnailsArray"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let arrayValue = defaults.array(forKey: savedVideosArrayKey) {
            videosArray = arrayValue as! [String]
        }
        if let arrayValue = defaults.array(forKey: thumbnailsArrayKey) {
            thumbnailsArray = arrayValue as! [Data]
        }
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! PlayerViewController
            if let pathIndex = tableView.indexPathForSelectedRow?.row {
            destination.path = videosArray[pathIndex]
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let thumbnail = UIImage(data:thumbnailsArray[indexPath.row],scale:1.0)
        cell.imageView?.image = thumbnail
        
        let stringName = videosArray[indexPath.row]
        cell.textLabel!.text = stringName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            videosArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    @IBAction func unwindInMaster(_ segue: UIStoryboardSegue)  {
        /*
         Empty. Exists solely so that "unwind in master" segues can
         find this instance as a destination.
         */
    }
}
