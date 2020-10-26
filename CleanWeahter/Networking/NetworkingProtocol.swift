//
//  NetworkingProtocol.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import SystemConfiguration
import UIKit

import Moya
import RxSwift

protocol NetworkingProtocol: class {
	func request(_ target: TargetType, file: StaticString,
				 function: StaticString, line: UInt) -> Single<Response>

}

extension NetworkingProtocol {
	func request(_ target: TargetType, file: StaticString = #file,
				 function: StaticString = #function, line: UInt = #line) -> Single<Response> {
		self.request(target, file: file, function: function, line: line)
	}
}

final class Networking: MoyaProvider<MultiTarget>, NetworkingProtocol {

	let intercepter: OAuthInterceptor

	init(logger: [PluginType] = [AccessTokenPlugin]()) {
		let session = MoyaProvider<MultiTarget>.defaultAlamofireSession()
		session.sessionConfiguration.timeoutIntervalForRequest = 20
		session.sessionConfiguration.timeoutIntervalForResource = 20
		let intercepter = OAuthInterceptor()
		self.intercepter = intercepter
		super.init(requestClosure: { endpoint, completion in
			do {
				let urlRequest = try endpoint.urlRequest()
				intercepter.adapt(urlRequest, for: session, completion: completion)
			} catch MoyaError.requestMapping(let url) {
				completion(.failure(MoyaError.requestMapping(url)))
			} catch MoyaError.parameterEncoding(let error) {
				completion(.failure(MoyaError.parameterEncoding(error)))
			} catch {
				completion(.failure(MoyaError.underlying(error, nil)))
			}
		}, session: session, plugins: logger)
	}

	deinit {
		print(self)
	}

	func request(_ target: TargetType, file: StaticString, function: StaticString, line: UInt) -> Single<Response> {
		let requestString = "\(target.method.rawValue) \(target.path)"
		return self.rx.request(.target(target))
			.filterSuccessfulStatusCodes()
			.do(
				onSuccess: { value in
					let message = "SUCCESS: \(requestString) (\(value.statusCode))"
					print(message)
				},
				onError: { error in
					if let response = (error as? MoyaError)?.response {
						if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
							let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
							print(message)
						} else if let rawString = String(data: response.data, encoding: .utf8) {
							let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
							print(message)
						} else {
							let message = "FAILURE: \(requestString) (\(response.statusCode))"
							print(message)
						}
					} else {
						let message = "FAILURE: \(requestString)\n\(error)"
						print(message)
					}
				},
				onSubscribed: {
					let message = "REQUEST: \(requestString)"
					print(message)
				}
			)
	}

} 
