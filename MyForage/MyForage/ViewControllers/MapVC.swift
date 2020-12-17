//
//  MapVC.swift
//  MyForage
//
//  Created by Cora Jacobson on 12/15/20.
//

import UIKit
import MapKit

class ForageSpot: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String
    var favorability: Int
    var image: UIImage
    
    init(coordinate: CLLocationCoordinate2D, name: String, favorability: Int, image: UIImage) {
        self.coordinate = coordinate
        self.name = name
        self.favorability = favorability
        self.image = image
    }
}

class MapVC: UIViewController, Storyboarded {
    
    // TODO:
    // custom annotation, images, styling
    // didSelect
    // move ForageSpot to its own file
    // remove dummyData
    
    
    // MARK: - UI Elements
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    fileprivate let locationManager = CLLocationManager()
    var span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    var userLocation: CLLocationCoordinate2D?
    
    var forageSpots: [ForageSpot] = [] {
        didSet {
            let oldSpots = Set(oldValue)
            let newSpots = Set(forageSpots)
            
            let addedSpots = newSpots.subtracting(oldSpots)
            let removedSpots = oldSpots.subtracting(newSpots)
            
            mapView.removeAnnotations(Array(removedSpots))
            
            mapView.addAnnotations(Array(addedSpots))
        }
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        dummyData()
    }
    
    // MARK: - Private Functions
    
    private func setUpMap() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseIdentifier.forageAnnotation)
    }
    
    private func dummyData() {
        forageSpots = [ForageSpot(coordinate: CLLocationCoordinate2D(latitude: 37.8, longitude: -122.19), name: "Tasty Mushrooms", favorability: 7, image: UIImage(systemName: "suit.spade.fill")!),
                       ForageSpot(coordinate: CLLocationCoordinate2D(latitude: 37.8, longitude: -122.21), name: "Chanterelles?", favorability: 5, image: UIImage(systemName: "suit.spade.fill")!)]
    }

}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let forageSpot = annotation as? ForageSpot else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifier.forageAnnotation, for: forageSpot) as! MKMarkerAnnotationView
        
        annotationView.glyphImage = UIImage(systemName: "heart")!
        annotationView.canShowCallout = true
        let detailView = ForageAnnotationView()
        detailView.forageSpot = forageSpot
        annotationView.detailCalloutAccessoryView = detailView
        
        switch forageSpot.favorability {
        case 0..<3:
            annotationView.markerTintColor = .systemRed
        case 3..<5:
            annotationView.markerTintColor = .systemOrange
        case 5..<7:
            annotationView.markerTintColor = .systemYellow
        case 7...10:
            annotationView.markerTintColor = .systemGreen
        default:
            annotationView.markerTintColor = .systemGray
        }
        
        annotationView.displayPriority = .required
        
        return annotationView
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        userLocation = currentLocation
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
