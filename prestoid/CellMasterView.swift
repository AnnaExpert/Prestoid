//
//  CellMasterView.swift
//  Prestoid - Dropbox sync video camera app with speech to text recognition
//  Application version 1.4, build 4, 2017.02.19
//
//  Created by Alexander Iashchuk on 11/13/16.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), http://iashchuk.com
//  Application owner - Scott Leatham. All rights reserved.
//
NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
NSEntityDescription *entity = [NSEntityDescription entityForName:@"<#Entity name#>" inManagedObjectContext:<#context#>];
[fetchRequest setEntity:entity];
// Specify criteria for filtering which objects to fetch
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
[fetchRequest setPredicate:predicate];
// Specify how the fetched objects should be sorted
NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#key#>"
ascending:YES];
[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

NSError *error = nil;
NSArray *fetchedObjects = [<#context#> executeFetchRequest:fetchRequest error:&error];
if (fetchedObjects == nil) {
    <#Error handling code#>
}
import UIKit

class CellMasterView: UITableViewCell {
    
    @IBOutlet weak var cellTextView: UIView!
    @IBOutlet weak var cellInformationView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellDateTextLabel: UILabel!
    @IBOutlet weak var cellDurationTextLabel: UILabel!
    @IBOutlet weak var cellTopTextLabel: UILabel!
    @IBOutlet weak var cellBottomTextLabel: UILabel!
    @IBOutlet weak var cellSpeechTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
