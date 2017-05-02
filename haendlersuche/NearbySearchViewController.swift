//
//  NearbySearchViewController.swift
//  haendlersuche
//
//  Anzeige der nächsten Händler
//  Copyright © 2016 Matthias Jaap. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class NearbySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

	@IBOutlet weak var nearbyShops: UITableView!
	@IBOutlet weak var mapview: MKMapView!
	let regionRadius: CLLocationDistance = 10000
	var json = NSDictionary()
	var shoplist = [ShopModel]()
	var locationManager: CLLocationManager!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Location service
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
		
		// URL request
		let stringPost="?action=nearby&lat="+String(locValue.latitude)+"&lon="+String(locValue.longitude)
		var request = URLRequest(url: URL(string: "<API URL>"+stringPost)!)

		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: { (data, respose, error) -> Void in
			if error != nil {
				print(error ?? "")
			} else {
				if let data = data {

					do { self.json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
						DispatchQueue.main.async {
							if let vendorList = self.json["stores"] as? [NSDictionary] {
								for vendor in vendorList {
									let vendordata=ShopModel(json: vendor)
									self.shoplist.append(vendordata)
									let shopLatitude = Double(vendordata.latitude!)
									let shopLongitude = Double(vendordata.longitude!)
									
									let shopLocation = CLLocation(latitude: shopLatitude!, longitude: shopLongitude!)
									let adress=[vendordata.thoroughfare, vendordata.postal_code, vendordata.locality].flatMap{$0}.joined(separator: " ")
									self.addannotation(location: shopLocation, locationTitle: vendordata.title!, locationSubTitle: adress)
								}
								if let refreshTable=self.nearbyShops {
									DispatchQueue.main.async {
										refreshTable.reloadData()
									}
								}
							}
						}
					} catch {
						print("json error: \(error.localizedDescription)")
					}
				}
			}
		})
		task.resume()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if let path = nearbyShops.indexPathForSelectedRow {
			nearbyShops.deselectRow(at: path, animated: true)
		}
		getUserLocation()
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shoplist.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyshopsid", for: indexPath) as! NearbyShopsTableViewCell
		let shop = shoplist[(indexPath as NSIndexPath).row]
		cell.nearByShopTitle.text=shop.title
		cell.nearByShopAdress.text=[shop.thoroughfare,shop.postal_code,shop.locality].flatMap{$0}.joined(separator: " ")
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "vendornearbydetails" {
			let detailViewController = segue.destination as! ShopDetailViewController
			let cell = sender as! NearbyShopsTableViewCell
			let indexPaths = self.nearbyShops.indexPath(for: cell)
			let thisShop = self.shoplist[(indexPaths! as NSIndexPath).row] as ShopModel
			detailViewController.shopName = thisShop.title!
			detailViewController.shopLocationText = [thisShop.thoroughfare,thisShop.postal_code,thisShop.locality].flatMap{$0}.joined(separator: " ")
			detailViewController.shopLat = thisShop.latitude!
			detailViewController.shopLong = thisShop.longitude!
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func getUserLocation() {
		let locManager = CLLocationManager()
		locManager.requestWhenInUseAuthorization()
		var currentLocation = CLLocation()
		if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse||CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
			currentLocation = locManager.location!
			// Keine Auswahl - aktuelle Position des Users anzeigen
			centerMapOnLocation(location: currentLocation, locationTitle: "Ihr Standort", locationSubTitle: "")
			// Optional: Standorte aller Händler auf der Karte vermerken
			print(currentLocation.coordinate.longitude)
			print(currentLocation.coordinate.latitude)
		}
	}
	func centerMapOnLocation(location: CLLocation, locationTitle: String, locationSubTitle: String) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                            regionRadius * 2.0, regionRadius * 2.0)
		mapview.setRegion(coordinateRegion, animated: true)
		addannotation(location: location, locationTitle: locationTitle, locationSubTitle: locationSubTitle)
	}
	func addannotation(location: CLLocation, locationTitle: String, locationSubTitle: String) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = location.coordinate
		annotation.title = locationTitle
		annotation.subtitle = locationSubTitle
		mapview.addAnnotation(annotation)
	}

}

