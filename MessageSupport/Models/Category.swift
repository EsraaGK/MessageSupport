
import Foundation

struct Category: Codable {

	let category: String?
	let subCategory: [SubCategory]?
	let categoryImageURL: String?


	enum CodingKeys: String, CodingKey {
		case category = "Category"
		case subCategory = "SubCategory"
		case categoryImageURL = "categoryImageURL"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent(String.self, forKey: .category)
		subCategory = try values.decodeIfPresent([SubCategory].self, forKey: .subCategory)
		categoryImageURL = try values.decodeIfPresent(String.self, forKey: .categoryImageURL)
	}
}
