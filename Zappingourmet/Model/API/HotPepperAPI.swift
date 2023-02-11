//
//  HotPepperAPI.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/10.
//

import Foundation
import Combine
import Moya
import CombineMoya

protocol HotPepperResponse: Codable {
    
    associatedtype Results: HotPepperResults
    
    var results: Results { get }
    
}

struct HotPepperErrorResult: Codable {
    
    var message: String
    var code: Int
    
}

protocol HotPepperResults: Codable {
    
    var error: [HotPepperErrorResult]? { get }
    
}

final class HotPepperAPI {
    
    // MARK: - Static
    
    static let shared = HotPepperAPI()
    
    // MARK: - Property
    
    private let provider = MoyaProvider<MultiTarget>()
    private let stubbingProvider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub)
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - Public
    
    func request<T: HotPepperTargetType>(target: T) -> AnyPublisher<T.Response, Error> {
        return self.provider.requestPublisher(MultiTarget(target))
            .map { $0.data }
            .decode(type: T.Response.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func requestStub<T: HotPepperTargetType>(target: T) -> AnyPublisher<T.Response, Error> {
        return self.stubbingProvider.requestPublisher(MultiTarget(target))
            .map { $0.data }
            .decode(type: T.Response.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private init() {}
    
}
