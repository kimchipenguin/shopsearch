//
//  ShopDetailViewController.swift
//  haendlersuche
//
//  Copyright © 2016 Matthias Jaap. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController {

	@IBOutlet weak var vendorAdress: UILabel!
	@IBOutlet weak var vendorName: UILabel!
	@IBOutlet weak var mapview: MKMapView!

	var shopName = ""
	var shopLocationText = ""
	var shopLat = "0"
	var shopLong = "0"
	let regionRadius: CLLocationDistance = 500

	override func viewDidLoad() {
        super.viewDidLoad()
		let btnName = UIButton()
		btnName.setImage(UIImage(named: "pin"), for: .normal)
		btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		btnName.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
		let rightBarButton = UIBarButtonItem()
		rightBarButton.customView = btnName
		self.navigationItem.rightBarButtonItem = rightBarButton

		self.vendorName.text = self.shopName
		self.vendorAdress.text = self.shopLocationText
		let momentaryLatitude = (self.shopLat as NSString).doubleValue
		let momentaryLongitude = (self.shopLong as NSString).doubleValue

		let initialLocation = CLLocation(latitude: momentaryLatitude, longitude: momentaryLongitude)
		centerMapOnLocation(location: initialLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	func openMaps() {
		let coordinate = CLLocationCoordinate2DMake((self.shopLat as NSString).doubleValue,(self.shopLong as NSString).doubleValue)
		let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
		mapItem.name = self.shopName
		mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
	}
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                            regionRadius * 2.0, regionRadius * 2.0)
		mapview.setRegion(coordinateRegion, animated: true)
		let annotation = MKPointAnnotation()
		annotation.coordinate = location.coordinate
		annotation.title = self.shopName
		mapview.addAnnotation(annotation)
	}
    
}
