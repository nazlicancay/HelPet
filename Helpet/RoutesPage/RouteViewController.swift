import MapKit

class RouteViewController: UIViewController {
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var coordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the map view
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map's region to display the user's location
        mapView.showsUserLocation = true
        
        // Add the map view to the view controller's view
        view.addSubview(mapView)
        
        // Set the map view's delegate
        mapView.delegate = self
        
        // Request location permission
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Function to display the route once location permission is granted
    func displayRoute(destinationCoordinate : CLLocationCoordinate2D) {
        guard let userLocation = mapView.userLocation.location else {
            return
        }
        
        let sourceCoordinate = userLocation.coordinate // Source coordinate
        let destinationCoordinate = destinationCoordinate// Destination coordinate
        
        // Call the function to display the route
        calculateRoute(sourceCoordinate: sourceCoordinate, destinationCoordinate: destinationCoordinate)
        
        // Add a marker to the destination location
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationCoordinate
        destinationAnnotation.title = "Destination"
        mapView.addAnnotation(destinationAnnotation)
    }
    
    func calculateRoute(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        // Perform the route calculation and draw the route on the map
        // Add your route calculation code here
        
        // Example code to draw a route using a polyline
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let route = response?.routes.first else {
                return
            }
            
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
}

extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "destinationPin")
        annotationView.pinTintColor = .red
        return annotationView
    }
}

extension RouteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else {
            return
        }
        
        // Set the map's region to display the user's location
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Stop updating the user's location once it's obtained
        locationManager.stopUpdatingLocation()
        
        // Display the route
        displayRoute(destinationCoordinate: coordinates!)
    }
}
