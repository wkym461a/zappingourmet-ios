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

final class HotPepperAPI {
    
    // MARK: - Static
    
    static let shared = HotPepperAPI(MoyaProvider.neverStub)
//    static let stubbed = HotPepperAPI(MoyaProvider.immediatelyStub)
    
    // MARK: - Property
    
    private let provider: MoyaProvider<MultiTarget>
    
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
    
    // MARK: - Private
    
    private init(_ stubClosure: @escaping MoyaProvider<MultiTarget>.StubClosure) {
        self.provider = MoyaProvider<MultiTarget>(stubClosure: stubClosure)
    }
    
}
