//
//  LocationsTableViewController.swift
//  Helpet
//
//  Created by Nazlıcan Çay on 10.06.2023.
//

import UIKit
import MapKit

class LocationsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    var selectedCoordinates: CLLocationCoordinate2D?
    
    var veterinarians: [Veterinarian] = [
        Veterinarian(name: "Anka Veteriner Kliniği", votes: "4.4/5", proximity: "550 m " , latitude: 40.15272098666998, longitude: 26.413460997807974),
        Veterinarian(name: "Vetland  Veteriner Kliniği ", votes: "4.7/5", proximity: "450 m" , latitude: 40.15426676793403, longitude: 26.41198039854528),
        Veterinarian(name: "Vetlife  Veteriner Kliniği ", votes: "4.7/5", proximity: "650 m" , latitude: 40.156529976344046, longitude: 26.41549945673627 ),
        Veterinarian(name: "Pet Concept Veteriner Kliniği ", votes: "5/5", proximity: "700 m" , latitude:40.157677951775895, longitude: 26.413675554625087),
        Veterinarian(name: "SEMPATİ Veteriner Kliniği ", votes: "4.8/5", proximity: "750 km" , latitude: 40.14689373434186,  longitude: 26.421786930642124),
        Veterinarian(name: " PETIKO Veteriner Kliniği ", votes: "5/5", proximity: "900 m" , latitude: 40.14478436689745,  longitude: 26.416418362972674),
        Veterinarian(name: "CAN-VET Veteriner Kliniği ", votes: "4.8/5", proximity: "900 km" , latitude: 40.14464776766234, longitude:   26.406066084610742),
       
        Veterinarian(name: "Petgiller Veteriner Kliniği ", votes: "5/5", proximity: "650 km" , latitude: 40.145918484750695,  longitude: 26.40989900437134),
        Veterinarian(name: "MEGA Veteriner Kliniği ", votes: "4.8/5", proximity: "1 km" , latitude: 40.14689373434186,  longitude: 26.421786930642124),
        Veterinarian(name: "18 Mart Veteriner Kliniği ", votes: "4.8/5", proximity: "1.7 km" , latitude: 40.165432744436806,  longitude: 26.419160326938847),
      
      
        // Add more veterinarians
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return veterinarians.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vet =  veterinarians[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VeterinarianTableViewCell
        cell.nameLabel.text = vet.name
        cell.proximityLabel.text = vet.proximity
        cell.votesLabel.text = vet.votes
       
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let veterinarian = veterinarians[indexPath.row]
            selectedCoordinates = CLLocationCoordinate2D(latitude: veterinarian.latitude, longitude: veterinarian.longitude)
            
            // Perform the segue to the RouteViewController
            performSegue(withIdentifier: "RouteSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RouteSegue" {
            if let routeViewController = segue.destination as? RouteViewController {
                routeViewController.coordinates = selectedCoordinates
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired height for each cell including the spacing
        return 80.0  // Adjust this value as per your requirement
    }
    
    struct Veterinarian {
        let name: String
        let votes: String
        let proximity: String
        let latitude : Double
        let longitude : Double
    }
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
