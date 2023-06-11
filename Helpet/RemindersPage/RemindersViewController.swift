//
//  RemaindersViewController.swift
//  Helpet
//
//  Created by Nazlıcan Çay on 3.01.2023.
//

import UIKit
import EventKit
import EventKitUI


class RemindersViewController: UIViewController, UICalendarViewDelegate,EKEventEditViewDelegate, EKEventViewDelegate {
   
   
    let store = EKEventStore()
    var FoodButoons : [UIButton] = []
    
    @IBOutlet weak var AddEventBtn: UIButton!
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
    
    @IBAction func DidTapAdd(_ sender: Any) {
        
        store.requestAccess(to: .event){ [weak self] success, error in
            if success, error==nil{
                DispatchQueue.main.async {
                    guard let store = self?.store else {return}
                    
                    let newEvent = EKEvent(eventStore: store)
                    newEvent.title = "Bir Hatırlatıcı Oluştur"
                    newEvent.startDate = Date()
                    newEvent.endDate = Date()
                 
                    let Vc = EKEventEditViewController()
                    Vc.editViewDelegate = self
                    Vc.eventStore = store
                    Vc.event = newEvent
                    
                    
                    
                    self?.present(Vc, animated: true,completion: nil)
                    
                   
                }
            }
            
        }
        
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
          
        }))
        self.present(showAlert, animated: true, completion: nil)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FoodButoons.append(foodBtn1)
        FoodButoons.append(FoodBtn2)
        FoodButoons.append(FoodBtn3)
   
        
        
        
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        controller.dismiss(animated: true , completion: nil)
    }
    
    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        let calendar = controller.eventStore.defaultCalendarForNewEvents!
           controller.event?.location = "" // Set location to an empty string
           return calendar
       }

    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        if action == .done {
                if let event = controller.event {
                    let eventStore = EKEventStore()

                    do {
                        try eventStore.save(event, span: .thisEvent)
                        print("Reminder saved successfully!")
                    } catch {
                        print("Error saving reminder: \(error.localizedDescription)")
                    }
                }
            }

            controller.dismiss(animated: true, completion: nil)
    }
    
    
    
   
}


