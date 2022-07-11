//
//  ViewController.swift
//  Reminder
//
//  Created by Zardasht  on 09/07/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UnService.shared.authorize()
        CLService.shared.authorize()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterRegion),
                                               name: NSNotification.Name("InternalNotifications.enteredRegion"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAction(_:)),
                                               name: NSNotification.Name("internalNotification.handleAction"),
                                               object: nil)
        
    }

    
    
    @IBAction func onTimerTapped() {
        print("Timer")
        AlertService.actionSheet(in: self, title: "5 Seconds") {
            UnService.shared.timerRequest(with: 5)
        }
       
    }
    
    @IBAction func onDateTapped() {
        print("Date")
        AlertService.actionSheet(in: self, title: "Some Future time!") {
            var componets = DateComponents()
            componets.second = 0
            UnService.shared.dateRequest(with: componets)
        }
        
    }
    
    @IBAction func onLocationTapped() {
        //print("Locations")
        AlertService.actionSheet(in: self, title: "When I returned") {
            CLService.shared.updateLocations()
        }
        
    }
    
    @objc func didEnterRegion() {
        print("Did Enter Region!")
        UnService.shared.locationRequest()
    }
    
    @objc func handleAction(_ sender: Notification) {
        
        guard let action = sender.object as? notificationsActionID else {return}
        switch action {
            
        case .timer:
            print("timer Logic")
        case .location:
            print("locations Logic")
            changeBackground()
        case .date:
            print("date logic")
        
        }
        
    }
    
    private func changeBackground() {
        self.view.backgroundColor = .magenta
    }

}

