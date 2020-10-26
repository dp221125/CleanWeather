//
//  ForecastDTO.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import Foundation

struct ForecastDTO {
	let weekend: String
	let date: Date
	private let minTemp: Int
	private let maxTemp: Int
	let weatherCode: Int
	
	var temp: String {
		return "\(maxTemp)-\(minTemp)"
	}
}
