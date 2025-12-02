//
//  RecordingsService.swift
//  RecordingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation

class RecordingsService {
    public static let shared = RecordingsService()
    
    typealias RecordingCompletionHandler = ([Recording]?, Error?) -> ()
    
    private let recordings: [Recording] = [
        Recording(bitrate: 131072, copyright: "© 2025 Words and Music by  John Doe", date: "04/28/2025", length: 270, size: 5*1024*1024,
                  title: "My Electric Guitar Anthem", type: "AAC Audio File", url: "https://graphixware.com/MyElectricAnthem.aac"),
        Recording(bitrate: 131072, copyright: "© 2025 Words and Music by John Doe", date: "08/24/2025", length: 228, size: 10*1024*1024,
                  title: "My Acoustic Guitar Ballad", type: "AAC Audio File", url: "https://graphixware.com/MyAcousticBallad.aac")
    ]
    
    private init() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        for recording in recordings {
            do {
                let file = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent(recording.title + ".aac")
                
                if !FileManager.default.fileExists(atPath: file.lastPathComponent) {
                    try encoder.encode(recording).write(to: file)
                }
            } catch {
                print("RecordingsService.init(): Error = \(error.localizedDescription)")
            }
        }
    }

    func fetch(completion: @escaping RecordingCompletionHandler) {
        var recordingModels: [Recording] = []
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                if let recording = read(type: Recording.self, file: fileURL) {
                    recordingModels.append(recording)
                }
            }
        } catch {
            print("RecordingsService.fetch(): Error = \(error.localizedDescription)")
        }
        
        completion(recordingModels, nil)
    }
    
    private func read<T: Codable>(type: T.Type, file: URL) -> T? {
        var data: Data?
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            print("RecordingsService.read(): Error = \(error.localizedDescription)")
        }
        
        guard let recordingData = data else { return nil }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: recordingData)
        } catch {
            print("RecordingsService.read(): Error = \(error.localizedDescription)")
        }
        
        return nil
    }

}

