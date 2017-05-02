//
//  ShopViewController.swift
//  haendlersuche
//
//  Einlesen der JSON-Datei, Anzeige in einer TableView
//  Copyright © 2016 Matthias Jaap. All rights reserved.
//

import UIKit
import CoreLocation

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
	var json = NSDictionary()
	var shoplist = [ShopModel]()
	var locationManager: CLLocationManager!
	
	@IBOutlet weak var vendorTable: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!

	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.delegate = self
		
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		
		loadData(url: "<API URL>")
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let path = vendorTable.indexPathForSelectedRow {
			vendorTable.deselectRow(at: path, animated: true)
		}
	}

	func loadData(url: String) {
		let jsonURL = URL(string: url)
		let session = URLSession.shared
		let task = session.dataTask(with: jsonURL!, completionHandler: { (data, respose, error) -> Void in
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
								}
								if let refreshTable=self.vendorTable {
									DispatchQueue.main.async {
										refreshTable.reloadData()
									}
								}
							}
						}
					} catch {}
				}
			}
		})
		task.resume()
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shoplist.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "vendortablecell", for: indexPath) as! ShopTableViewCell
		let shop = shoplist[(indexPath as NSIndexPath).row]
		cell.vendorTitle.text=shop.title
		cell.vendorAdress.text=[shop.thoroughfare,shop.postal_code,shop.locality].flatMap{$0}.joined(separator: " ")
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					print("received")
				}
			}
		}
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		print("Search")
		self.vendorTable.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "vendordetails" {
			let detailViewController = segue.destination as! ShopDetailViewController
			let cell = sender as! ShopTableViewCell
			let indexPaths = self.vendorTable.indexPath(for: cell)
			let thisShop = self.shoplist[(indexPaths! as NSIndexPath).row] as ShopModel
			detailViewController.shopName = thisShop.title!
			detailViewController.shopLocationText = [thisShop.thoroughfare,thisShop.postal_code,thisShop.locality].flatMap{$0}.joined(separator: " ")
			detailViewController.shopLat = thisShop.latitude!
			detailViewController.shopLong = thisShop.longitude!
		}

	}

}

