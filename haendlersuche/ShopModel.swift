//
//  ShopModel.swift
//  haendlersuche
//
//  Copyright © 2016 Matthias Jaap. All rights reserved.
//

import UIKit

class ShopModel {
	var id: String?
	var title: String?
	var type: String?
	var language: String?
	var locality: String?
	var postal_code: String?
	var thoroughfare: String?
	var latitude: String?
	var longitude: String?

	init(json: NSDictionary) {
		self.id = json["id"] as? String ?? "0"
		self.title = json["title"] as? String ?? ""
		self.type = json["type"] as? String ?? ""
		self.language = json["language"] as? String  ?? ""
		self.thoroughfare = json["thoroughfare"] as? String  ?? ""
		self.locality = json["locality"] as? String  ?? ""
		self.postal_code = json["postal_code"] as? String  ?? ""
		self.latitude = json["lat"] as? String  ?? "0"
		self.longitude = json["lon"] as? String  ?? "0"
	}

}
