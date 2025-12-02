//
//  RecordingStudioVC.swift
//  RecordingStudioFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import UIKit

class RecordingStudioVC: UIViewController {
    @IBOutlet weak var track1ImageView: UIImageView!
    @IBOutlet weak var track2ImageView: UIImageView!
    @IBOutlet weak var track3ImageView: UIImageView!
    @IBOutlet weak var track4ImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var trackCount = 1
        
        if let bundle = Bundle(identifier:"com.gw.RecordingStudioFW"),
           let path = bundle.path(forResource: "RecordingStudio", ofType: "plist"),
           let plistDict = NSDictionary(contentsOfFile: path),
           let tracks = plistDict.object(forKey: "trackCount") as? Int {
            trackCount = tracks
        }
        
        if let features = UserDefaults.standard.object(forKey: "iaps") as? [String: Any],
           let tracks = features["trackCount"] as? Int {
            trackCount = tracks
        }
        
        switch trackCount {
        case 2:
            initializeImageView(imageView: self.track1ImageView, enableTrack: true)
            initializeImageView(imageView: self.track2ImageView, enableTrack: true)
            initializeImageView(imageView: self.track3ImageView, enableTrack: false)
            initializeImageView(imageView: self.track4ImageView, enableTrack: false)
        case 3:
            initializeImageView(imageView: self.track1ImageView, enableTrack: true)
            initializeImageView(imageView: self.track2ImageView, enableTrack: true)
            initializeImageView(imageView: self.track3ImageView, enableTrack: true)
            initializeImageView(imageView: self.track4ImageView, enableTrack: false)
        case 4:
            initializeImageView(imageView: self.track1ImageView, enableTrack: true)
            initializeImageView(imageView: self.track2ImageView, enableTrack: true)
            initializeImageView(imageView: self.track3ImageView, enableTrack: true)
            initializeImageView(imageView: self.track4ImageView, enableTrack: true)
        default:
            initializeImageView(imageView: self.track1ImageView, enableTrack: true)
            initializeImageView(imageView: self.track2ImageView, enableTrack: false)
            initializeImageView(imageView: self.track3ImageView, enableTrack: false)
            initializeImageView(imageView: self.track4ImageView, enableTrack: false)
        }
    }
    
    func initializeImageView(imageView: UIImageView, enableTrack: Bool) {
        imageView.image = UIImage(named: "AudioMixer_Track", in: Bundle(for: RecordingStudioVC.self), with: nil)
        
        imageView.isUserInteractionEnabled = enableTrack ? true : false
        
        imageView.layer.opacity = enableTrack ? 1.0 : 0.25
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
    }
}
