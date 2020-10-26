//
//  OAuthInterceptor .swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import Foundation

import Alamofire
import Moya
import OAuthSwift

/*
https://github.com/OAuthSwift/OAuthSwiftAlamofire

I don't know this repo notworking...
so i edited for use in Moya
*/

class OAuthInterceptor: RequestInterceptor {
	
	let oauthSwift: OAuthSwift
	
	init() {
		
		let key = parseKeys()
		
		self.oauthSwift = OAuth1Swift(consumerKey: key.consumerKey,
									  consumerSecret: key.consumerSecret)
	}
	
	public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, MoyaError>) -> Void) {
		completion(.success(urlRequest))
		
		var config = OAuthSwiftHTTPRequest.Config(
			urlRequest: urlRequest,
			paramsLocation: .authorizationHeader,
			dataEncoding: .utf8
		)
		config.updateRequest(credential: oauthSwift.client.credential)
		
		do {
			completion(.success(try OAuthSwiftHTTPRequest.makeRequest(config: config)))
		} catch {
			completion(.failure(MoyaError.underlying(error, nil)))
		}
	}

	public func retry(_ request: Request,
					  for session: Session,
					  dueTo error: Error,
					  completion: @escaping (RetryResult) -> Void) {
		completion(.doNotRetry)
	}
	
}
