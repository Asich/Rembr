//
//  SettingsViewController.swift
//  Rembr
//
//  Created by Askar Mustafin on 12/29/16.
//  Copyright © 2016 asich. All rights reserved.
//

import Cocoa


struct SettingsConstants {
    static let kNotificationInterval = "kNotificationInterval"
}


class SettingsViewController: NSViewController {

    @IBOutlet weak var intervalCombobox: NSComboBox!
    
    
    let possibleNotificationIntervals = [1, 5, 10, 15, 20, 30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        configUI()
    }
    
    //MARK: - config ui
    
    func configUI() {
        
        //apend items to combobox
        for i in possibleNotificationIntervals {
            intervalCombobox.addItem(withObjectValue: i)
        }
        
        //select item in combobox (default will be 20)
        let selectedItem = UserDefaults.standard.integer(forKey: SettingsConstants.kNotificationInterval)
        
        print("selectedItem: \(selectedItem)")
        if selectedItem == 0 {
            intervalCombobox.selectItem(at: 4)
        } else {
            intervalCombobox.selectItem(at:possibleNotificationIntervals.index(of:selectedItem)!)
        }
    }
    
}


extension SettingsViewController : NSComboBoxDelegate, NSComboBoxDataSource {
    
    
    public func comboBoxSelectionDidChange(_ notification: Notification) {
        let selectedItem = (possibleNotificationIntervals[intervalCombobox.indexOfSelectedItem])
        UserDefaults.standard.set(selectedItem, forKey: SettingsConstants.kNotificationInterval)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIntervalChanged"), object: nil)
    }
    
    
    public func numberOfItems(in comboBox: NSComboBox) -> Int {
        return possibleNotificationIntervals.count
    }
    
}
