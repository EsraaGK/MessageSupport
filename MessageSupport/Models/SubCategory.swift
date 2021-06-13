//
//	SubCategory.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SubCategory : Codable {

	let desc : String?
	let fAQ : [FAQ]?
	let name : String?
	let richContent : String?
	let screenId : String?


	enum CodingKeys: String, CodingKey {
		case desc = "Desc"
		case fAQ = "FAQ"
		case name = "Name"
		case richContent = "RichContent"
		case screenId = "ScreenId"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		desc = try values.decodeIfPresent(String.self, forKey: .desc)
		fAQ = try values.decodeIfPresent([FAQ].self, forKey: .fAQ)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		richContent = try values.decodeIfPresent(String.self, forKey: .richContent)
		screenId = try values.decodeIfPresent(String.self, forKey: .screenId)
	}


}