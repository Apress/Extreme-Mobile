//
//  RecordingTVC.swift
//  RecordingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import UIKit

class RecordingTVC: UITableViewController {
    @IBOutlet weak var copyrightNameLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var dateNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var lengthNameLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var bitrateNameLabel: UILabel!
    @IBOutlet weak var bitrateLabel: UILabel!
    
    @IBOutlet weak var sizeNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    let detailsTitle = "Details"
    let previewTitle = "Preview"
    var recording: Recording?
    
    let kbps = "kbps"
    let mb = "MB"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        self.navigationItem.title = recording?.title ?? detailsTitle
        
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        
        copyrightLabel.text = recording?.copyright ?? ""
        dateLabel.text = recording?.date ?? ""
        
        if let length = recording?.length {
            let quotient = length / 60
            let remainder = length % 60
            lengthLabel.text = String(describing: quotient) + ":" + String(describing: remainder)
        }
        
        typeLabel.text = recording?.type ?? ""
        
        if let bitrate = recording?.bitrate {
            bitrateLabel.text = String(describing: bitrate / 1024) + " kbps"
        }
        
        if let size = recording?.size {
            let quotientMB = size / (1024 * 1024)
            let remainder = size % (1024 * 1024)
            let value = remainder > 0 ? String(describing: remainder) + "." : ""
            sizeLabel.text = String(describing: quotientMB) + value + " MB"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < 1 {
            let outerView = UIView(frame: self.tableView.frame)
            
            let innerView = UIView(frame: CGRect(x: outerView.frame.origin.x + 50.0, y: outerView.frame.origin.y + 10.0, width: outerView.frame.width - 100.0, height: 0.5))
            
            innerView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            
            outerView.addSubview(innerView)
            
            return outerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 21.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 58.0 : 44.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        var title = ""
        
        switch section {
        case 0:
            title = detailsTitle
        case 1:
            title = previewTitle
        default:
            break
        }
        
        let titleView = view as! UITableViewHeaderFooterView
        titleView.textLabel?.text = title // Remove all capitalized letters
    }
}
