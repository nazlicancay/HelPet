import UIKit
import CoreLocation
import Lottie

class HomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var weatherAnim: UIView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var PetPicture: UIImageView!
    @IBOutlet weak var FunFacts: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        fetchCatFact { (fact, error) in
            if let error = error {
                print("Error fetching cat fact: \(error.localizedDescription)")
            } else if let fact = fact {
                DispatchQueue.main.async {
                    self.FunFacts.text = fact
                    print(fact)
                }
            } else {
                print("Failed to fetch cat fact.")
            }
        }
        
        fetchRandomPetPicture { (image, error) in
            if let error = error {
                print("Error fetching pet picture: \(error.localizedDescription)")
            } else if let image = image {
                // Use the fetched image in your Swift project
                DispatchQueue.main.async {
                    // Display the image in a UIImageView or perform any other desired action
                    self.PetPicture = UIImageView(image: image)
                    // ...
                }
            } else {
                print("Failed to fetch pet picture.")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.first else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let apiKey = "3ef8e9ff06b945288b8122318231604"
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(latitude),\(longitude)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {

                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherAPIResponse.self, from: data)
                
                DispatchQueue.main.async { [self] in
                    var isSunny : Bool
                    self.weatherLabel.text = "\(weatherResponse.current.tempC)°C"
                    
                    if weatherResponse.current.condition.code == 1000 {
                        self.messageLabel.text = "Yürüyüş İçin Harika Bir Gün "
                        isSunny = true
                        self.loadLottieAnimation(name: "sun")

                    } else {
                        self.messageLabel.text = " Bugün evde oyun oynayabilirsiniz "
                        isSunny = false
                        self.loadLottieAnimation(name: "cloudy")
                        
                    }
                    print(isSunny)
                   
                }
            } catch let error {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
     
    }
    
    
    func loadLottieAnimation(name : String) {
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(name)
        animationView.frame = weatherAnim.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        weatherAnim.addSubview(animationView)
    }
}



struct WeatherAPIResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let tempC: Int
    let condition: WeatherCondition
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
    }
}

struct WeatherCondition: Codable {
    let code: Int
    let text: String
}
// GEtting fun facts about pets

func fetchCatFact(completion: @escaping (String?, Error?) -> Void) {
    let apiUrl = URL(string: "https://cat-fact.herokuapp.com/facts/random")!
    
    URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let fact = json?["text"] as? String {
                    completion(fact, nil)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }.resume()
}

func fetchRandomPetPicture(completion: @escaping (UIImage?, Error?) -> Void) {
    let apiUrl = URL(string: "https://placekitten.com/200/300")! // You can customize the image size as needed
    
    URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        if let data = data, let image = UIImage(data: data) {
            completion(image, nil)
        } else {
            completion(nil, nil)
        }
    }.resume()
}



