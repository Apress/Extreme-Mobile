//
//  SettingsTVC.swift
//  SettingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import UIKit

class SettingsTVC: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteValueLabel: UILabel!
    
    var configuration: Dictionary<String,Any>?
    
    func configure(configuration: Dictionary<String,Any>) {
        self.configuration = configuration
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
                
        let frameworkBundle = Bundle(for: SettingsTVC.self)
        self.navigationItem.title = String(localized: "settingsTVCUINavigationItemTitle", bundle: frameworkBundle)
        self.nameLabel.text = String(localized: "settingsTVCUILabelName", bundle: frameworkBundle)
        self.emailLabel.text = String(localized: "settingsTVCUILabelEmail", bundle: frameworkBundle)
        self.websiteLabel.text = String(localized: "settingsTVCUILabelWebsite", bundle: frameworkBundle)

        // In a production app, the following values would typically be fetched via network API request...
        self.nameValueLabel.text = "Graphixware, LLC"
        self.emailValueLabel.text = "gw@graphixware.com"
        self.websiteValueLabel.text = "https://graphixware.com"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
