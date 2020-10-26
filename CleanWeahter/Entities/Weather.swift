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
	let sunrise: String
	let sunset: String
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
	let date: Date
	let low, high: Int
	let text: String
	let code: Int
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.day = try values.decode(String.self, forKey: .day)
		self.low = try values.decode(Int.self, forKey: .low)
		self.high = try values.decode(Int.self, forKey: .high)
		self.code = try values.decode(Int.self, forKey: .code)
		self.text = try values.decode(String.self, forKey: .text)
		
		let stringDate = try values.decode(Int.self, forKey: .date)
		let timeIntervalDate = Date(timeIntervalSince1970: TimeInterval(stringDate))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy/MM/dd"
		dateFormatter.locale = Locale(identifier: "ko-kr")
		dateFormatter.timeZone = TimeZone(identifier: "KST")
		let date = dateFormatter.string(from: timeIntervalDate)
		self.date = dateFormatter.date(from: date)!
		
	}
	
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
