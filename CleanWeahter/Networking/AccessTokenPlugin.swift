//
//  AccessTokenPlugin.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import Foundation

import Moya

final class AccessTokenPlugin: PluginType {
	func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
		return request
	}
}
