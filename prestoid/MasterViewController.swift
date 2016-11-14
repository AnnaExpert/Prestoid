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
    let savedVideosArrayKey = "savedVideosArray"
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 251.0;//Choose your custom row height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! CellMasterView

        var thumbnail = UIImage()
        let fileName = videosArray[indexPath.row]
        
        
        let docsPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let moviePath = docsPath + "/" + videosArray[indexPath.row] + ".mov"
        do {
            let asset = AVURLAsset(url: URL(fileURLWithPath: moviePath), options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }

        var datePart = fileName.characters.prefix(8)
        datePart.insert(".", at: datePart.index(datePart.startIndex, offsetBy: 6))
        datePart.insert(".", at: datePart.index(datePart.startIndex, offsetBy: 4))
        let date = String(datePart)
        
        var timePart = fileName.characters.dropFirst(9)
        timePart = timePart.prefix(4)
        timePart.insert(":", at: timePart.index(timePart.startIndex, offsetBy: 2))
        let time = String(timePart)
        
        cell.cellImageView.image = thumbnail
        cell.cellTopTextLabel.text = String("on \(date)")
        cell.cellBottomTextLabel.text = String("at \(time)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            let filename = videosArray[indexPath.row]
            let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent((filename as NSString).appendingPathExtension("mov")!)
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    videosArray.remove(at: indexPath.row)
                    let defaults = UserDefaults.standard
                    defaults.set(videosArray, forKey: savedVideosArrayKey)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                catch {
                    print("Could not remove file at url: \(URL(fileURLWithPath: path))")
                }
            } else {
                videosArray.remove(at: indexPath.row)
                let defaults = UserDefaults.standard
                defaults.set(videosArray, forKey: savedVideosArrayKey)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
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