//
//  PetShopsTableViewController.swift
//  Helpet
//
//  Created by Nazlıcan Çay on 10.06.2023.
//

import UIKit
import MapKit

class PetShopsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCoordinates: CLLocationCoordinate2D?
    
    var PetShops : [PetShop] =
    [
        PetShop(name: "İda PetShop", votes: "4.6/5", proximity: "170 m " , latitude: 40.153291818069384,  longitude: 26.409182333566303),
        PetShop(name: " Cesur PetShop", votes: "4.4/5", proximity: "500 m" , latitude: 40.149027536083906,  longitude: 26.408324026690455),
        PetShop(name: "Çiftlik PetShop ", votes: "4.7/5", proximity: "650 m" , latitude:40.15263579211374, longitude:  26.403946661623607),
        PetShop(name: " Cesur PetShop", votes: "4.4/5", proximity: "650 m" , latitude: 40.149027536083906,  longitude: 26.408324026690455),
        PetShop(name: "Doğa Kuş Evi PetShop", votes: "4.6/5", proximity: "750 m " , latitude: 40.14771539545526,longitude:  26.404890799187047),
        PetShop(name: "Alfa Pet market   ", votes: "4.7/5", proximity: "1.4 m" , latitude:40.14372897513092,longitude:  26.40226190565836),
        PetShop(name: "Mamacı PetShop ", votes: "4.7/5", proximity: "1.5 m" , latitude:40.14259780481118, longitude: 26.415362143072432),
       
        PetShop(name: "Petin PetShop ", votes: "4.9/5", proximity: "1.9 km" , latitude:40.13702050424094, longitude:  26.40892484150355)
       
    ]
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PetShops.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let Petshop =  PetShops[indexPath.row]
        
        let Petcell = tableView.dequeueReusableCell(withIdentifier: "PetShopCell", for: indexPath) as! PetShopsTableViewCell
        Petcell.nameLabel.text = Petshop.name
        Petcell.proximityLabel.text = Petshop.proximity
        Petcell.votesLabel.text = Petshop.votes
        
        return Petcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let PetShop = PetShops[indexPath.row]
            selectedCoordinates = CLLocationCoordinate2D(latitude: PetShop.latitude, longitude: PetShop.longitude)
            
            // Perform the segue to the RouteViewController
            performSegue(withIdentifier: "RouteFromPetshopSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RouteFromPetshopSegue" {
            if let routeViewController = segue.destination as? RouteViewController {
                routeViewController.coordinates = selectedCoordinates
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired height for each cell including the spacing
        return 80.0  // Adjust this value as per your requirement
    }
    
        
  
        struct PetShop {
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
