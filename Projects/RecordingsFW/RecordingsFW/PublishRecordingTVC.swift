//
//  PublishRecordingTVC.swift
//  RecordingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import UIKit

class PublishRecordingTVC: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var songwritersLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    
    let copyrightTitle = "Copyright"
    let previewTitle = "Preview"
    let publishTitle = "Publish"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.backBarButtonItem = cancelBarButtonItem
        
        if let font = UILabel.appearance().font {
            let boldFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: font.pointSize)
            titleLabel.font = boldFont
            songwritersLabel.font = boldFont
            yearLabel.font = boldFont
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < 2 {
            let outerView = UIView(frame: self.tableView.frame)
            
            let innerView = UIView(frame: CGRect(x: outerView.frame.origin.x + 50.0, y: outerView.frame.origin.y + 10.0,
                                                 width: outerView.frame.width - 100.0, height: 0.5))
            
            innerView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            
            outerView.addSubview(innerView)
            
            return outerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 21.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        var title = ""
        
        switch section {
        case 0:
            title = copyrightTitle
        case 1:
            title = previewTitle
        case 2:
            title = publishTitle
        default:
            break
        }
        
        let titleView = view as! UITableViewHeaderFooterView
        titleView.textLabel?.text = title // Remove all capitalized letters
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func publishButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
