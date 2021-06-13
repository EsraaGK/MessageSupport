//
//	FAQ.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FAQ : Codable {

	let answer : String?
	let question : String?


	enum CodingKeys: String, CodingKey {
		case answer = "Answer"
		case question = "Question"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		answer = try values.decodeIfPresent(String.self, forKey: .answer)
		question = try values.decodeIfPresent(String.self, forKey: .question)
	}


}