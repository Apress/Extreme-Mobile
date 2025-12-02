//
//  RecordingsFWTests.swift
//  RecordingsFWTests
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation
import Combine
import Testing
@testable import RecordingsFW   // Replace if your module name differs

final class MockRecordingsService: StubAPIService {
    enum MockMode {
        case success
        case networkError
        case parsingError
    }
    
    var mode: MockMode = .success
    
    private let recordings: [Recording] = [
        Recording(bitrate: 131_072,
                  copyright: "© 2025 Words and Music by John Doe",
                  date: "04/28/2025",
                  length: 270,
                  size: 5 * 1024 * 1024,
                  title: "My Electric Guitar Anthem",
                  type: "AAC Audio File",
                  url: "https://graphixware.com/MyElectricAnthem.aac"),
        Recording(bitrate: 131_072,
                  copyright: "© 2025 Words and Music by John Doe",
                  date: "08/24/2025",
                  length: 228,
                  size: 10 * 1024 * 1024,
                  title: "My Acoustic Guitar Ballad",
                  type: "AAC Audio File",
                  url: "https://graphixware.com/MyAcousticBallad.aac")
    ]
    
    func fetch<T>(_t: T.Type, url: URL) -> AnyPublisher<[T], RecordingsError> where T : Decodable {
        switch mode {
        case .networkError:
            return Fail(error: RecordingsError.network(message: ".networkError: Simulated network error"))
                .eraseToAnyPublisher()
        case .parsingError:
            return Fail(error: RecordingsError.parsing(message: ".parsingError: Simulated parsing error"))
                .eraseToAnyPublisher()
        case .success:
            guard let result = recordings as? [T] else {
                return Fail(error: RecordingsError.parsing(message: ".success: Type mismatch"))
                    .eraseToAnyPublisher()
            }
            return Just(result)
                .setFailureType(to: RecordingsError.self)
                .eraseToAnyPublisher()
        }
    }
}

extension Publisher {
    func waitForValue(
        timeout: Duration = .seconds(1),
        condition: @escaping (Output) -> Bool
    ) async -> Output? {
        await withCheckedContinuation { continuation in
            var cancellable: AnyCancellable?
            let deadline = ContinuousClock.now + timeout
            
            cancellable = self.sink(
                receiveCompletion: { _ in
                    continuation.resume(returning: nil)
                    cancellable?.cancel()
                },
                receiveValue: { value in
                    if condition(value) {
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                    }
                })
            
            Task {
                try? await Task.sleep(until: deadline, clock: .continuous)
                continuation.resume(returning: nil)
                cancellable?.cancel()
            }
        }
    }
}

extension ObservableObject {
    func waitForPublishedValue<Value>(
        _ keyPath: KeyPath<Self, Published<Value>.Publisher>,
        timeout: Duration = .seconds(1),
        condition: @escaping (Value) -> Bool
    ) async -> Value? {
        let publisher = self[keyPath: keyPath]
        return await publisher.waitForValue(timeout: timeout, condition: condition)
    }
}

extension PublishedRecordingsViewModel {
    func waitForRecordings(
        timeout: Duration = .seconds(1),
        condition: @escaping ([Recording]) -> Bool
    ) async -> [Recording]? {
        await waitForPublishedValue(\.$recordings, timeout: timeout, condition: condition)
    }
}

@MainActor
struct PublishedRecordingsViewModelTests {
    @Test("Fetch recordings successfully")
    func testFetchRecordingsSuccess() async throws {
        let mockService = MockRecordingsService()
        mockService.mode = .success
        let viewModel = PublishedRecordingsViewModel(
            service: mockService,
            endpoint: .fetchRecordings
        )
        
        viewModel.fetch()
        let recordings = await viewModel.waitForRecordings { !$0.isEmpty }
        
        #expect(recordings?.count == 2)
        #expect(recordings?.first?.title == "My Electric Guitar Anthem")
        #expect(recordings?.last?.title == "My Acoustic Guitar Ballad")
    }
    
    @Test("Handle network error properly")
    func testFetchRecordingsNetworkError() async throws {
        let mockService = MockRecordingsService()
        mockService.mode = .networkError
        let viewModel = PublishedRecordingsViewModel(
            service: mockService,
            endpoint: .fetchRecordings
        )
        
        viewModel.fetch()
        let recordings = await viewModel.waitForRecordings { $0.isEmpty }
        
        #expect(recordings?.isEmpty == true)
    }
    
    @Test("Handle parsing error properly")
    func testFetchRecordingsParsingError() async throws {
        let mockService = MockRecordingsService()
        mockService.mode = .parsingError
        let viewModel = PublishedRecordingsViewModel(
            service: mockService,
            endpoint: .fetchRecordings
        )
        
        viewModel.fetch()
        let recordings = await viewModel.waitForRecordings { $0.isEmpty }
        
        #expect(recordings?.isEmpty == true)
    }
    
    @Test("Use generic @Published helper properly")
    func testGenericWaitForPublishedValue() async throws {
        class DummyViewModel: ObservableObject {
            @Published var isLoading = true
            func finishLoading() { isLoading = false }
        }
        
        let dummy = DummyViewModel()
        Task {
            try? await Task.sleep(for: .milliseconds(200))
            dummy.finishLoading()
        }
        
        let isDone = await dummy.waitForPublishedValue(\.$isLoading) { $0 == false }
        #expect(isDone == false)
    }
}
