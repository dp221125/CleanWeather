//
//  Weather.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
	let location: UserLocation
	let currentObservation: CurrentObservation
	let forecasts: [Forecast]

	enum CodingKeys: String, CodingKey {
		case location
		case currentObservation = "current_observation"
		case forecasts
	}
}

// MARK: - CurrentObservation
struct CurrentObservation: Codable {
	let wind: Wind
	let atmosphere: Atmosphere
	let astronomy: Astronomy
	let condition: Condition
	let pubDate: Int
}

// MARK: - Astronomy
struct Astronomy: Codable {
	let sunrise: Date
	let sunset: Date
	
	init(from decoder: Decoder) throws {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a"
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let sunriseString = try values.decode(String.self, forKey: .sunrise)
		let sunsetString = try values.decode(String.self, forKey: .sunset)
		if let sunrise = dateFormatter.date(from: sunriseString),
		   let sunset = dateFormatter.date(from: sunsetString) {
			self.sunrise = sunrise
			self.sunset = sunset
		} else {
			self.sunrise = Date()
			self.sunset = Date()
		}
		
	}
}

// MARK: - Atmosphere
struct Atmosphere: Codable {
	let humidity: Int
	let visibility: Double
	let pressure, rising: Int
}

// MARK: - Condition
struct Condition: Codable {
	let text: String
	let code, temperature: Int
}

// MARK: - Wind
struct Wind: Codable {
	let chill, direction, speed: Int
}

// MARK: - Forecast
struct Forecast: Codable {
	let day: String
	let date, low, high: Int
	let text: String
	let code: Int
}

// MARK: - Location
struct UserLocation: Codable {
	let city, region: String
	let woeid: Int
	let country: String
	let lat, long: Double
	let timezoneID: String

	enum CodingKeys: String, CodingKey {
		case city, region, woeid, country, lat, long
		case timezoneID = "timezone_id"
	}
}
