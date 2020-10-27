//
//  MainRepository.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import CoreLocation
import Foundation

import Moya
import RxSwift
import RxCocoa

protocol MainRemoteRepositoryProtocol: class {
	func requestWeather(location: CLLocationCoordinate2D, unit: String) -> Single<Response>
}

protocol MainLocalRepositoryProtocol { }

protocol MainRepositoryProtocol: MainRemoteRepositoryProtocol, MainLocalRepositoryProtocol { }

final class MainRepository: MainRepositoryProtocol {

	let network: NetworkingProtocol

	init(network: NetworkingProtocol = Networking()) {
		self.network = network
	}

	func requestWeather(location: CLLocationCoordinate2D, unit: String) -> Single<Response> {
		return self.network.request(WeatherAPI.forecast(location: location, unit: unit))
	}
}
