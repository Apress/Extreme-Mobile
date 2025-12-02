//
//  IAPService.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation
import Combine
internal import OHHTTPStubs
internal import OHHTTPStubsSwift

protocol StubAPIService {
    func fetch<T>(_t: T.Type, url: URL) -> AnyPublisher<[T],IAPError> where T: Decodable
}

class IAPService: StubAPIService {
    public static let shared = IAPService()
    
    weak var stubDesc: HTTPStubsDescriptor?
    
    private init() {
        stubDesc = stub(condition: isHost("graphixware.com")) { request in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("IAP.json", type(of: self))!, statusCode: 200,
                                     headers: ["Content-Type":"application/json"]
            )
        }
        
        stubDesc?.name = "IAP.json"
        
        HTTPStubs.onStubActivation { (request: URLRequest, stub: HTTPStubsDescriptor, response: HTTPStubsResponse) in
            print("IAPService.init(): Request to \(request.url!) has been stubbed with \((stub.name != nil) ? stub.name! : "?")")
        }
    }
    
    func fetch<T>(_t: T.Type, url: URL) -> AnyPublisher<[T], IAPError> where T : Decodable {
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                IAPError.network(message: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, IAPError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                IAPError.parsing(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

}
