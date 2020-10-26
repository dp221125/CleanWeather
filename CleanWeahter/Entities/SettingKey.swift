//
//  SettingKey.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

struct SettingKey: Decodable {

	let apiID: String
	let consumerKey: String
	let consumerSecret: String

	private enum CodingKeys: String, CodingKey {
		case apiID = "API_ID"
		case consumerKey = "ConsumerKey"
		case consumerSecret = "ConsumerSecret"
	}

	init() {
		apiID = ""
		consumerKey = ""
		consumerSecret = ""
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		apiID = try values.decode(String.self, forKey: .apiID)
		consumerKey = try values.decode(String.self, forKey: .consumerKey)
		consumerSecret = try values.decode(String.self, forKey: .consumerSecret)
	}
}

