//
//  SettingsViewController.swift
//  Prestoid - Dropbox sync video camera app with speech to text recognition
//  Application version 2.0, build 69, 2017.12.06
//
//  Created by Alexander Iashchuk on 5/12/17.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), http://iashchuk.com
//  Application owner - Scott Leatham. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var languageString: String = String()
    var videoString: String = String()
    let savedLangSettingsStringKey = "savedLanguage"
    let savedVideoSettingsStringKey = "savedVideoQuality"

    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var videoSegmentedControl: UISegmentedControl!
    
    @IBAction func restartAppButton(_ sender: Any) {
        
    }
    
    @IBAction func languageChanged(_ sender: Any) {
        switch languageSegmentedControl.selectedSegmentIndex
        {
        case 0:
            print("First language selected")
            languageString = "en"
            defaults.set(languageString, forKey: savedLangSettingsStringKey)
        case 1:
            print("Second language selected")
            languageString = "fr"
            defaults.set(languageString, forKey: savedLangSettingsStringKey)
        case 2:
            print("Third language selected")
            languageString = "it"
            defaults.set(languageString, forKey: savedLangSettingsStringKey)
        case 3:
            print("Fourth language selected")
            languageString = "de"
            defaults.set(languageString, forKey: savedLangSettingsStringKey)
        case 4:
            print("Fifth language selected")
            languageString = "es"
            defaults.set(languageString, forKey: savedLangSettingsStringKey)
        default:
            break;
        }
    }
    
    @IBAction func videoChanged(_ sender: Any) {
        switch videoSegmentedControl.selectedSegmentIndex
        {
        case 0:
            print("First Video selected")
            videoString = "top"
            defaults.set(videoString, forKey: savedVideoSettingsStringKey)
        case 1:
            print("Second Video selected")
            videoString = "mid"
            defaults.set(videoString, forKey: savedVideoSettingsStringKey)
        case 2:
            print("Third Video selected")
            videoString = "low"
            defaults.set(videoString, forKey: savedVideoSettingsStringKey)
        default:
            break;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let stringValue1 = defaults.string(forKey: savedLangSettingsStringKey) {
            languageString = stringValue1
        }
        print(languageString)
        switch languageString
        {
        case "en":
            languageSegmentedControl.selectedSegmentIndex = 0
        case "fr":
            languageSegmentedControl.selectedSegmentIndex = 1
        case "it":
            languageSegmentedControl.selectedSegmentIndex = 2
        case "de":
            languageSegmentedControl.selectedSegmentIndex = 3
        case "es":
            languageSegmentedControl.selectedSegmentIndex = 4
        default:
            languageSegmentedControl.selectedSegmentIndex = 0
            break;
        }
        if let stringValue2 = defaults.string(forKey: savedVideoSettingsStringKey) {
            videoString = stringValue2
        }
        print(videoString)
        switch videoString
        {
        case "top":
            videoSegmentedControl.selectedSegmentIndex = 0
        case "mid":
            videoSegmentedControl.selectedSegmentIndex = 1
        case "low":
            videoSegmentedControl.selectedSegmentIndex = 2
        default:
            videoSegmentedControl.selectedSegmentIndex = 1
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
