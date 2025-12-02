//
//  RecordingsTVC.swift
//  RecordingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import UIKit
import Combine

class RecordingsTVC: UITableViewController {
    @IBOutlet weak var publishBarButtonItem: UIBarButtonItem! // Note: To be used in a future chapter
    
    var viewModel: RefreshableViewModel?
    
    let publishedTitle = "Published Recordings"
    let localTitle = "Local Recordings"

    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.publishBarButtonItem.isHidden = true // Note: To be used in a future chapter
        
        self.clearsSelectionOnViewWillAppear = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl?.beginRefreshing()
        
        if showPublished() {
            self.navigationItem.title = publishedTitle
            
            // Initialize published recordings
            initRemoteServiceVM()
        } else {
            self.navigationItem.title = localTitle
            
            // Initialize local recordings
            initLocalServiceVM()
        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var enablePublishing = false
        
        if let bundle = Bundle(identifier:"com.gw.RecordingsFW"),
           let path = bundle.path(forResource: "Recordings", ofType: "plist"),
           let plistDict = NSDictionary(contentsOfFile: path),
           let publishing = plistDict.object(forKey: "enablePublishing") as? Bool {
            enablePublishing = publishing
        }
        
        if let iaps = UserDefaults.standard.object(forKey: "iaps") as? [String: Any],
           let publishing = iaps["publishRecordings"] as? Bool {
            enablePublishing = publishing
        }
        
        self.publishBarButtonItem.isHidden = !enablePublishing
    }

    func showPublished() -> Bool {
        var showPublished = false
        
        if let bundle = Bundle(identifier:"com.gw.RecordingsFW"), let path = bundle.path(forResource: "Recordings", ofType: "plist"),
           let plistDict = NSDictionary(contentsOfFile: path) {
            showPublished = plistDict.object(forKey: "showPublished") as? Bool ?? false
        }
        
        if let features = UserDefaults.standard.object(forKey: "features") as? [String:String] {
            if let publishedValue = features["showPublished"], let published = Bool(publishedValue) {
                showPublished = published
            }
        }
        
        return showPublished
    }

    func initLocalServiceVM() {
        self.viewModel = RecordingsViewModel()
        
        (self.viewModel as! RecordingsViewModel).bindRecordingsViewModelToController = { [weak self] in
            guard let strongSelf = self else { return }
            
            if let recordings = strongSelf.viewModel?.getRecordings(), recordings.count == 0 {
                print("RecordingsTVC.initLocalServiceVM(): No recordings found...")
            }
            
            DispatchQueue.main.async {
                strongSelf.refreshControl?.endRefreshing()
                strongSelf.tableView.reloadData()
            }
        }
        
        self.viewModel?.refresh()
    }
    
    func initRemoteServiceVM() {
        self.viewModel = PublishedRecordingsViewModel(service: PublishedRecordingsService.shared, endpoint: .fetchRecordings)
        
        (self.viewModel as! PublishedRecordingsViewModel).$recordings
            .sink { [weak self] recordings in
                guard let strongSelf = self else { return }
                                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    strongSelf.refreshControl?.endRefreshing()
                    strongSelf.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        self.viewModel?.refresh()
    }

    @objc func refresh(_ sender: AnyObject) {
        viewModel?.refresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getRecordings().count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingsCell", for: indexPath)
        
        if let recordingCell = cell as? RecordingsCell, let recording = self.viewModel?.getRecordings()[indexPath.row] {
            recordingCell.titleLabel.text = recording.title
            recordingCell.copyrightLabel.text = recording.copyright
            return recordingCell
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordingDetailsSegue" {
            if let recordingTVC = segue.destination as? RecordingTVC {
                if let indexPath = self.tableView.indexPathForSelectedRow, let recording = self.viewModel?.getRecordings()[indexPath.row]  {
                    recordingTVC.recording = recording
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func publishButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RecordingsUI", bundle: Bundle(for: RecordingsTVC.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "PublishRecordingNC")
        self.present(viewController, animated: true)
    }
}

class RecordingsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
}
