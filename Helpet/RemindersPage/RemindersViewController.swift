//
//  RemaindersViewController.swift
//  Helpet
//
//  Created by Nazlıcan Çay on 3.01.2023.
//

import UIKit

class RemindersViewController: UIViewController, UICalendarViewDelegate {
    
    var FoodButoons : [UIButton] = []
    
    @IBOutlet weak var foodBtn1: UIButton!
    
    @IBOutlet weak var FoodBtn2: UIButton!
    
    @IBOutlet weak var FoodBtn3: UIButton!
    
    @IBOutlet weak var Glass1: UIButton!
    
    @IBOutlet weak var Glass3: UIButton!
    
    @IBOutlet weak var Glass2: UIButton!
    
    
    @IBAction func Drink1(_ sender: Any) {
        Glass1.setImage(UIImage(named: "GlassFull"), for: .normal)
        popUp(ImageName: "Drinking Cat")
    }
    
    @IBAction func drink2(_ sender: Any) {
        Glass1.setImage(UIImage(named: "GlassFull"), for: .normal)
        popUp(ImageName: "Drinking Cat")
    }
    
    @IBAction func drink3(_ sender: Any) {
        Glass1.setImage(UIImage(named: "GlassFull"), for: .normal)
        popUp(ImageName: "Drinking Cat")
    }
    
    
    @IBAction func Touched(_ sender: Any) {
        
        foodBtn1.setImage(UIImage(named:"FoodIkonChoosen"), for: .normal)
        popUp(ImageName: "Image")


    }
    
    @IBAction func Touched2(_ sender: Any) {
        FoodBtn2.setImage(UIImage(named: "FoodIkonChoosen"), for: .normal)
        popUp(ImageName: "Image")
    }
    
    @IBAction func touched3(_ sender: Any) {
        
        FoodBtn3.setImage(UIImage(named: "FoodIkonChoosen"), for: .normal)
        popUp(ImageName: "Image")
    }
    
    func popUp(ImageName : String){
        let showAlert = UIAlertController(title: "You're cat is happy now", message: nil, preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
        imageView.image = UIImage(named: ImageName)
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        
        showAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            // your actions here...
        }))
        self.present(showAlert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FoodButoons.append(foodBtn1)
        FoodButoons.append(FoodBtn2)
        FoodButoons.append(FoodBtn3)
        CreateCalender()

        
        
        
    }
    
    func CreateCalender(){
        let CalenderView = UICalendarView()
        CalenderView.translatesAutoresizingMaskIntoConstraints = false
        
        CalenderView.calendar = .current
        CalenderView.locale = .current
        CalenderView.fontDesign = .rounded
        CalenderView.delegate = self
        
        view.addSubview(CalenderView)
        
        NSLayoutConstraint.activate(
            [CalenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
             CalenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
             CalenderView.heightAnchor.constraint(equalToConstant: 300),
             CalenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 400)
            ])
    }
    
    
   
}

extension UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        nil
    }
    
}
