//
//  CommonFunc.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import Foundation

func parseKeys() -> SettingKey {
	guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
		let data = try? Data(contentsOf: url) else { return SettingKey() }
	let decoder = PropertyListDecoder()
	guard let keys = try? decoder.decode(SettingKey.self, from: data) else { return SettingKey() }
	return keys
}
