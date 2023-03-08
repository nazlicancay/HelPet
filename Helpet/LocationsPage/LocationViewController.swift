import UIKit
import MapboxMaps
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections



import UIKit
import MapboxMaps

public class LocationViewController: UIViewController {

    private var mapView: MapView!
    private var cameraLocationConsumer: CameraLocationConsumer!
    private lazy var toggleBearingImageButton = UIButton(frame: .zero)
    private lazy var styleToggle = UISegmentedControl(items: Style.allCases.map(\.name))
    private var style: Style = .satelliteStreets {
        didSet {
            mapView.mapboxMap.style.uri = style.uri
        }
    }
    private var showsBearingImage: Bool = false {
        didSet {
            syncPuckAndButton()
        }
    }

    private enum Style: Int, CaseIterable {
        var name: String {
            switch self {
            case .light:
                return "Light"
            case .satelliteStreets:
                return "Satelite"
           
            }
        }

        var uri: StyleURI {
            switch self {
            case .light:
                return .light
            case .satelliteStreets:
                return .satelliteStreets
          
            }
        }

        case light
        case satelliteStreets
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

       
        // Set initial camera settings
        let options = MapInitOptions(styleURI: style.uri)

        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoibmNhbmNheSIsImEiOiJjbGUyc3U3ZHcwMjE3M3BxamFta3JrdHIwIn0.QVqq7hxdNsP43y_rE2FtVQ")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.15272098666998, longitude: 26.413460997807974)
        let point = Point(centerCoordinate)

            // Add a map view
            let AnatationOptions = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate, zoom: 7))
            mapView = MapView(frame: view.bounds, mapInitOptions: AnatationOptions)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           // view.addSubview(mapView)
        
        mapView.mapboxMap.onNext(.mapLoaded) { [weak self] _ in
               guard let self = self else { return }
               let markerId = self.addMarker(at: point)
               self.addViewAnnotation(at: centerCoordinate, withMarkerId: markerId)
           }
        
        
        
        // Add the view annotation
        self.addViewAnnotation(at: centerCoordinate)
    
        self.view.addSubview(mapView)

    
        
        addStyleToggle()
        

        // Setup and create button for toggling show bearing image
        setupToggleShowBearingImageButton()

        cameraLocationConsumer = CameraLocationConsumer(mapView: mapView)

        // Add user position icon to the map with location indicator layer
        mapView.location.options.puckType = .puck2D()

        // Allows the delegate to receive information about map events.
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            // Register the location consumer with the map
            // Note that the location manager holds weak references to consumers, which should be retained
            self.mapView.location.addLocationConsumer(newConsumer: self.cameraLocationConsumer)

        }
    }
    
    
    // Add a marker image via a symbol layer
    private func addMarker(at point: Point) -> String {
        let featureId = "some-feature-id"
        let style = mapView.mapboxMap.style
        
        // Add an image of a red marker to the style
        try? style.addImage(UIImage(named: "red_pin")!, id: "red-pin-image", stretchX: [], stretchY: [])
        
        // Create a GeoJSON source
        var source = GeoJSONSource()
        let sourceId = "some-source-id"
        var feature = Feature(geometry: Geometry.point(point))
        feature.identifier = .string(featureId)
        source.data = .featureCollection(FeatureCollection(features: [feature]))
        try? mapView.mapboxMap.style.addSource(source, id: sourceId)

        // Create a symbol layer using the GeoJSON source
        // and image added above
        var layer = SymbolLayer(id: "some-layer-id")
        layer.source = sourceId
        layer.iconImage = .constant(.name("red-pin-image"))
        layer.iconAnchor = .constant(.bottom)
        layer.iconAllowOverlap = .constant(false)
        try? mapView.mapboxMap.style.addLayer(layer)
        
        return featureId
    }
   
    // Update options to attach to a feature
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D, withMarkerId markerId: String? = nil) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 100,
            height: 40,
            associatedFeatureId: markerId,
            anchor: .bottom,
            offsetY: 40
        )
        let sampleView = createSampleView(withText: "Hello world!")
        try? mapView.viewAnnotations.add(sampleView, options: options)
    }

    
    private func createSampleView(withText text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //finish()
    }

    @objc func showHideBearingImage() {
        showsBearingImage.toggle()
    }

    func syncPuckAndButton() {
        // Update puck config
        let configuration = Puck2DConfiguration.makeDefault(showBearing: showsBearingImage)

        mapView.location.options.puckType = .puck2D(configuration)

        // Update button title
        let title: String = showsBearingImage ? "Hide bearing image" : "Show bearing image"
        toggleBearingImageButton.setTitle(title, for: .normal)
    }

    private func setupToggleShowBearingImageButton() {
        // Styling
        toggleBearingImageButton.backgroundColor = .systemBlue
        toggleBearingImageButton.addTarget(self, action: #selector(showHideBearingImage), for: .touchUpInside)
        toggleBearingImageButton.setTitleColor(.white, for: .normal)
        toggleBearingImageButton.layer.cornerRadius = 4
        toggleBearingImageButton.clipsToBounds = true
        toggleBearingImageButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        toggleBearingImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleBearingImageButton)

        // Constraints
        toggleBearingImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        toggleBearingImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        toggleBearingImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70.0).isActive = true

        syncPuckAndButton()
    }

    @objc func switchStyle(sender: UISegmentedControl) {
        style = Style(rawValue: sender.selectedSegmentIndex) ?? . satelliteStreets
    }

    func addStyleToggle() {
        // Create a UISegmentedControl to toggle between map styles
        styleToggle.selectedSegmentIndex = style.rawValue
        styleToggle.addTarget(self, action: #selector(switchStyle(sender:)), for: .valueChanged)
        styleToggle.translatesAutoresizingMaskIntoConstraints = false

        // set the segmented control as the title view
        navigationItem.titleView = styleToggle
    }
}

// Create class which conforms to LocationConsumer, update the camera's centerCoordinate when a locationUpdate is received
public class CameraLocationConsumer: LocationConsumer {
    weak var mapView: MapView?

    init(mapView: MapView) {
        self.mapView = mapView
    }

    public func locationUpdate(newLocation: Location) {
        mapView?.camera.ease(
            to: CameraOptions(center: newLocation.coordinate, zoom: 15),
            duration: 1.3)
    }
}


