//
//  SettingsViewController.swift
//  Prestoid - Dropbox sync video camera app with speech to text recognition
//  Application version 2.0, build 13, 2017.12.06
//
//  Created by Alexander Iashchuk on 5/12/17.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), http://iashchuk.com
//  Application owner - Scott Leatham. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var videoSegmentedControl: UISegmentedControl!
    
    @IBAction func languageChanged(_ sender: Any) {
        switch languageSegmentedControl.selectedSegmentIndex
        {
        case 0:
            print("First language selected");
        case 1:
            print("Second language selected");
        case 2:
            print("Third language selected");
        case 3:
            print("Fourth language selected");
        case 4:
            print("Fifth language selected");
        default:
            break;
        }
    }
    
    @IBAction func videoChanged(_ sender: Any) {
        switch videoSegmentedControl.selectedSegmentIndex
        {
        case 0:
            print("First Video selected");
        case 1:
            print("Second Video selected");
        case 2:
            print("Third Video selected");
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
