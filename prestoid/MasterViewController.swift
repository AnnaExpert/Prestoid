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
    
    //    struct CellInformationContent {
    //        var cellDict = [Int: Bool]()
    //    }
    
    var cellInformationContent = [Int: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        tableView.delegate = self
        tableView.dataSource = self
        //        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 151.0;//Choose your custom row height
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
        let moviePath = docsPath + "/" + fileName + ".mov"
        do {
            let asset = AVURLAsset(url: URL(fileURLWithPath: moviePath), options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
        /*
         var datePart = fileName.characters.prefix(8)
         datePart.insert(".", at: datePart.index(datePart.startIndex, offsetBy: 6))
         datePart.insert(".", at: datePart.index(datePart.startIndex, offsetBy: 4))
         let date = String(datePart)
         
         var timePart = fileName.characters.dropFirst(9)
         timePart = timePart.prefix(4)
         timePart.insert(":", at: timePart.index(timePart.startIndex, offsetBy: 2))
         let time = String(timePart)
         */
        
        var creation = ""
        var duration = 0
        var latitude = ""
        var longitude = ""
        
        let movieURL = URL.init(fileURLWithPath: moviePath)
        let asset = AVURLAsset(url: movieURL, options: nil)
        var metadata = AVMetadataItem()
        if !asset.metadata.isEmpty {
            metadata = asset.metadata[0]
            let locationArray = String(describing: metadata.value!).components(separatedBy: "_")
            duration = Int(asset.duration.seconds)
            let creationDate = asset.creationDate!.value as! Date
            creation = creationDate.toString()
            latitude = locationArray[1]
            longitude = locationArray[3]
        } else {
            let dataArray = String(describing: fileName).components(separatedBy: "_")
            let stringLat = dataArray[3]
            let stringLon = dataArray[4]
            
            latitude = stringLat
            longitude = stringLon
            duration = Int(asset.duration.seconds)
            let creationDate = asset.creationDate!.value as! Date
            creation = creationDate.toString()
        }
        
        cell.cellImageView.image = thumbnail
        cell.cellDateTextLabel.text = String("Video recorded: \(creation)")
        cell.cellDurationTextLabel.text = String("Video duration: \(duration) seconds")
        cell.cellTopTextLabel.text = String("Latitude: \(latitude)")
        cell.cellBottomTextLabel.text = String("Longitude: \(longitude)")
        
        if (cellInformationContent[indexPath.row] != nil) {
            cell.cellInformationView.isHidden = cellInformationContent[indexPath.row]!
            cell.cellDateTextLabel.isHidden = cellInformationContent[indexPath.row]!
            cell.cellDurationTextLabel.isHidden = cellInformationContent[indexPath.row]!
            cell.cellTopTextLabel.isHidden = cellInformationContent[indexPath.row]!
            cell.cellBottomTextLabel.isHidden = cellInformationContent[indexPath.row]!
        } else {
            cellInformationContent[indexPath.row] = true
            cell.cellInformationView.isHidden = cellInformationContent[indexPath.row]!
            cell.cellDateTextLabel.isHidden = cellInformationContent[indexPath.row]!
            cell.cellDurationTextLabel.isHidden = cellInformationContent[indexPath.row]!
            cell.cellTopTextLabel.isHidden = cellInformationContent[indexPath.row]!
            cell.cellBottomTextLabel.isHidden = cellInformationContent[indexPath.row]!
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: Swipe to edit
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            // Swipe to delete cell
            
            let filename = self.videosArray[indexPath.row]
            let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent((filename as NSString).appendingPathExtension("mov")!)
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    self.videosArray.remove(at: indexPath.row)
                    let defaults = UserDefaults.standard
                    defaults.set(self.videosArray, forKey: self.savedVideosArrayKey)
                    if (self.cellInformationContent[indexPath.row] != nil) {
                        self.cellInformationContent.removeValue(forKey: indexPath.row)
                    }
                    let dropbox = DropboxViewController()
                    dropbox.deleteFile(name: filename)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                catch {
                    print("Could not remove file at url: \(URL(fileURLWithPath: path))")
                }
            } else {
                self.videosArray.remove(at: indexPath.row)
                let defaults = UserDefaults.standard
                defaults.set(self.videosArray, forKey: self.savedVideosArrayKey)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        let metadata = UITableViewRowAction(style: .normal, title: "File info") { (action, indexPath) in
            
            // Swipe to show metadata
            
            //            let filename = self.videosArray[indexPath.row]
            //            let docsPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            //            let moviePath = docsPath + "/" + filename + ".mov"
            //            let movieURL = URL.init(fileURLWithPath: moviePath)
            //            let asset = AVURLAsset(url: movieURL, options: nil)
            //            var metadata = AVMetadataItem()
            //            metadata = asset.metadata[0]
            //            let locationArray = String(describing: metadata.value!).components(separatedBy: "_")
            //            let duration = Int(asset.duration.seconds)
            //            let creation = asset.creationDate!.value as! Date
            //            let latitude = locationArray[1]
            //            let longitude = locationArray[3]
            
            //            self.presentViewController(shareMenu, animated: true, completion: nil)
            
            
            //            print(duration)
            //            print(creation.description(with: Locale.current as Locale))
            //            print(latitude)
            //            print(longitude)
            //            if (self.cellInformationContent[indexPath.row] != nil) {
            //                self.cellInformationContent[indexPath.row] = !self.cellInformationContent[indexPath.row]!
            //            } else {
            //                self.cellInformationContent[indexPath.row] = false
            //            }
            
            if (self.cellInformationContent[indexPath.row] != nil) {
                self.cellInformationContent[indexPath.row] = !self.cellInformationContent[indexPath.row]!
            } else {
                self.cellInformationContent[indexPath.row] = false
            }
            
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
            tableView.setEditing(false, animated: true)
        }
        
        metadata.backgroundColor = UIColor.orange
        print("self.cellInformationContent")
        print(self.cellInformationContent)
        
        return [delete, metadata]
    }
    
    @IBAction func unwindInMaster(_ segue: UIStoryboardSegue)  {
        /*
         Empty. Exists solely so that "unwind in master" segues can
         find this instance as a destination.
         */
    }
}

extension Date {
    func toString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
}
