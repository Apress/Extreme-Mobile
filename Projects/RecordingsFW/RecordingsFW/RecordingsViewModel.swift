//
//  RecordingsViewModel.swift
//  RecordingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation

class RecordingsViewModel: RefreshableViewModel {
    private(set) var recordings: [Recording]! {
        didSet {
            self.bindRecordingsViewModelToController()
        }
    }
    
    var bindRecordingsViewModelToController : (() -> ()) = {}

    init() {
    }
    
    func getRecordings() -> [Recording] {
        return recordings
    }
    
    func refresh() {
        fetch()
    }
    
    private func fetch() {
        RecordingsService.shared.fetch() { [weak self] recordings, error in
            guard let strongSelf = self else { return }
            
            if let err = error {
                print("RecordingsViewModel.fetch(): error = \(err.localizedDescription)")
            } else {
                strongSelf.recordings = recordings
            }
        }
    }
}
