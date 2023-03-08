//
//  HomePageViewController.swift
//  Helpet
//
//  Created by Nazlıcan Çay on 20.02.2023.
//

import UIKit
import CoreData

class HomePageViewController: UIViewController {

    @IBOutlet weak var SaveBtn: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SaveVetBtn(_ sender: Any) {
        let newVet = VeterinarianModels(context: context)
        newVet.id = 1
        newVet.cd1 = 40.15057058702278
        newVet.cd2 = 26.41210888012721
        newVet.name = "deneme"
        do{
            try context.save()
            print("success")
            
        } catch{
            print("Error")
        }
        
        
    //    newVet.id = 1
    //    newVet.cd1 = 40.15057058702278
    //    newVet.cd2 = 26.41210888012721
    //    newVet.name = "deneme"

       
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
