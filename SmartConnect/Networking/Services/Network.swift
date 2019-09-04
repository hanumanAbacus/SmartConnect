//
//  Network.swift
//  GitHub-iOS
//
//  Created by 罗红瑞 on 2017/9/9.
//  Copyright © 2017年 罗红瑞. All rights reserved.
//

import Foundation
import Gloss
import Moya

enum VoidResult {
    case success
    case failure(Error)
}

class Network <T: TargetType> {
    let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true)
    
    let networkActivityPlugin = NetworkActivityPlugin { (change, _) in
        switch change {
        case .began:
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        case .ended:
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    init() {
        provider = MoyaProvider<T>(
            plugins: [self.networkLoggerPlugin, self.networkActivityPlugin]
        )
    }
    
    var _provider: MoyaProvider<T> = MoyaProvider<T>()
    var provider: MoyaProvider<T> {
        get {
            return _provider
        }
        set {
            var plugins: [PluginType] = [self.networkActivityPlugin]
            switch SMConfiguration.environment {
            case .Staging:
                plugins.append(self.networkLoggerPlugin)
                _provider = MoyaProvider<T>(plugins: plugins)
            case .Production:
                _provider = MoyaProvider<T>(plugins: plugins)
            case .StubLocal:
                plugins.append(self.networkLoggerPlugin)
                _provider = MoyaProvider<T>(stubClosure: MoyaProvider.immediatelyStub, plugins: plugins)
            }
        }
    }
    
    func request<U: Gloss.JSONDecodable>(_ target: T, type: U.Type, completion: @escaping (U?, Error?) -> Void) {
        provider.request(target) { (result) in
            switch result {
            case let .success(moyaResponse):
                let response = moyaResponse
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    
                    // 204: no content
                    if response.statusCode == 204 {
                        completion(nil, nil)
                    } else {
                        do {
                            let result = try response.mapObject(type)
                            completion(result, nil)
                        } catch {
                            completion(nil, error)
                        }
                    }
                } catch {
                    if response.statusCode == 403 || response.statusCode == 401 {
                        completion(nil, NetworkError.error(withErrorCode: .Forbidden))
                    } else if let error = error as? MoyaError {
                        do {
                            let json = try error.response?.mapJSON()
                            guard let jsonDict = json as? [String: Any] else {
                                completion(nil, error)
                                return
                            }
                            completion(nil, NetworkError.error(json: jsonDict))
                        } catch {
                            completion(nil, error)
                        }
                    }
                }
            case let .failure(error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    func request(_ target: T, key: String?, completion: @escaping (_ response: Any?, _ error: Error?) -> Void ) {
        provider.request (target) {[weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case let .success (response):
                weakSelf.processSuccess(response, key: key, completion: completion)
            case let .failure(error):
                switch error {
                case .underlying(let networkError as NSError?, nil):
                    completion(nil, networkError)
                default:
                    completion(nil, error)
                }
            }
        }
    }
    
    func queueRequest(_ target: T, key: String?, completion: @escaping (_ response: Any?, _ error: Error?) -> Void ) {
        provider.request (target, callbackQueue: DispatchQueue(label: "requestQueue")) {[weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case let .success (response):
                weakSelf.processSuccess(response, key: key, completion: completion)
            case let .failure(error):
                switch error {
                case .underlying(let networkError as NSError?, nil):
                    completion(nil, networkError)
                default:
                    completion(nil, error)
                }
            }
        }
    }
    
    private func processSuccess(_ response: Response, key: String?, completion: @escaping (_ response: Any?, _ error: Error?) -> Void ) {
        do {
            _ = try response.filterSuccessfulStatusCodes()
            let expectedResponse = try? JSONSerialization.jsonObject(with: response.data, options: [])
            
            if response.statusCode == 201 || response.statusCode == 204 {
                guard let processResponse = expectedResponse as? [String: Any] else {
                    completion(nil, nil)
                    return
                }
                if let keyValue = key, let expectedFromProcessResponse = processResponse[keyValue] {
                    completion(expectedFromProcessResponse, nil)
                    return
                }
                completion(processResponse, nil)
            } else if let processResponse = expectedResponse as? [String: Any] {
                if let keyValue = key {
                    completion(processResponse[keyValue], nil)
                    return
                }
                completion(processResponse, nil)
            } else {
                completion(nil, NetworkError.error(withErrorCode: .JSONMalformed))
            }
        } catch {
            if response.statusCode == 403 || response.statusCode == 401 {
                completion(nil, NetworkError.error(withErrorCode: .Forbidden))
            } else if 500 ... 599 ~= response.statusCode {
                completion(nil, NetworkError.error(withErrorCode: .ServerError) )
            } else if let error = error as? MoyaError {
                do {
                    let json = try error.response?.mapJSON()
                    guard let jsonDict = json as? [String: Any] else {
                        completion(nil, error)
                        return
                    }
                    completion(nil, NetworkError.error(json: jsonDict))
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}

struct SmartConnectService {
    static let service = Network<SmartConnectAPI>()
}
