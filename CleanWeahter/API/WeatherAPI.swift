//
//  WeatherAPI.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//
import CoreLocation
import Foundation

import Moya

enum WeatherAPI {
	case forecast(location: CLLocation, unit: String)
}

extension WeatherAPI: TargetType {

	var baseURL: URL {
		return URL(string: "https://weather-ydn-yql.media.yahoo.com")!
	}

	var path: String {
		switch self {
			case .forecast:
				return "/forecastrss"
		}
	}

	var method: Moya.Method {
		switch self {
			case .forecast:
				return .get
		}
	}

	var sampleData: Data {
		return Data()
	}

	var task: Task {
		switch self {
			case .forecast:
				return .requestParameters(parameters: parameters!, encoding: parametersEncoding)
		}
	}

	var parameters: [String: Any]? {
		switch self {
		case .forecast(let location, let unit):
			return ["lat": location.coordinate.latitude,
					"lon": location.coordinate.longitude,
						"format": "json",
						"u": unit]
		}
	}

	var parametersEncoding: ParameterEncoding {
		switch self {
			case .forecast:
				return URLEncoding.queryString
		}
	}

	var headers: [String: String]? {
		return [
			"X-Yahoo-App-Id": parseKeys().apiID]
	}
}
