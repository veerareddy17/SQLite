//
//  ViewController.swift
//  EventManager
//
//  Created by vera on 22/11/17.
//  Copyright © 2017 vera. All rights reserved.
//

import UIKit
import SQLite
import SQLite3
import EventKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var EventNameBtn: UITextField!
    @IBOutlet weak var EventDatePicker: UIDatePicker!
    
    var dateFormatter:DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCreate(_ sender: Any) {
        print("date : \(EventDatePicker.date)")
        
        guard let name = EventNameBtn.text, !name.isEmpty else {
            showAlert(title: "Please eneter event name")
            return
        }
        
        let event2 = Event.shared.insert(name: name, dateTime: EventDatePicker.date)
        if(event2 != nil){
            print("Success!!")
            
            let now = Date()
            if EventDatePicker.date > now {
                print("Add reminder")
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let reminder = EKReminder(eventStore: appDelegate.eventStore!)
                reminder.title = name
                reminder.calendar = appDelegate.eventStore!.defaultCalendarForNewReminders()
                let date = EventDatePicker.date
                let alarm = EKAlarm(absoluteDate: date)
                reminder.addAlarm(alarm)
                
                do {
                    try appDelegate.eventStore?.save(reminder,commit: true)
                } catch let error {
                    print("Reminder failed with error \(error.localizedDescription)")
                }
            } else {
                print("Event start date is in the past")
            }
  
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func showAlert(title: String){
        let alertController = UIAlertController(title: "Alert", message: title, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}





