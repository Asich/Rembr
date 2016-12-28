//
//  ViewController.swift
//  SwiftCoreData
//
//  Created by Askar Mustafin on 12/23/16.
//  Copyright © 2016 asich. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var enWordTextField: NSTextField!
    @IBOutlet weak var ruWordTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var words = [NSManagedObject]()
    
    override func viewDidLoad() {

        super.viewDidLoad()

        CoreDataHelper.fetch(entity: "Word") { [unowned self] objects in

            self.words = objects
            self.tableView.reloadData()

        }

        let not = NotificationManager()
        not.start()
        
        handleDeleteMenuButton()
        
        
    }
    
    //MARK: - config actions

    
    func handleDeleteMenuButton() {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.onDeleteItemClick = {
            self.removeRow()
        }
    }
    
    func removeRow() {
        let selectedRowIndexes = tableView.selectedRowIndexes
        let selectedRowIndex = selectedRowIndexes.first
        
        
        if selectedRowIndexes.count > 0 {

            for index in 0...words.count - 1 {
                
                if index == selectedRowIndex {

                    CoreDataHelper.delete(word: words[index], callback: nil)

                    CoreDataHelper.fetch(entity: "Word") { [unowned self] objects in

                        self.words = objects
                        self.tableView.reloadData()

                    }

                    break
                }
            }
        }
    }

    @IBAction func clickAddButton(_ sender: Any?) {
        
        if ((enWordTextField.stringValue != "") && (ruWordTextField.stringValue != "")) {

            CoreDataHelper.write(enWord: enWordTextField.stringValue, ruWord: ruWordTextField.stringValue) { [unowned self] object in

                self.words.append(object)

            }

            CoreDataHelper.fetch(entity: "Word") { [unowned self] objects in

                self.words = objects
                self.tableView.reloadData()

            }
            
            enWordTextField.stringValue = "";
            ruWordTextField.stringValue = "";
            
        } else {
            
            dialogOKCancel(question: "Введите оба поля", text: "")
            
        }
        
    }
    
    //MARK: - config ui
    
    func dialogOKCancel(question: String, text: String) {
        
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        myPopup.addButton(withTitle: "Cancel")
        myPopup.runModal()
        
    }

}


extension ViewController : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return words.count 
    }
    
    
    
}

extension ViewController : NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let EnWord = "EnWordCellID"
        static let RuWord = "RuWordCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        //assigning cell identifiers
        var cellIdentifier : String = ""
        var text : String = ""
        let word = words[row]
        
        if tableColumn == tableView.tableColumns[0] {
            
            cellIdentifier = CellIdentifiers.EnWord
            
            text = word.value(forKey: "enword") as! String
            
        } else if tableColumn == tableView.tableColumns[1] {
         
            cellIdentifier = CellIdentifiers.RuWord
            
            text = word.value(forKey: "ruword") as! String
        }
        
        
        //returning cell
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            
            cell.textField?.stringValue = text
            
            return cell
            
        }
        
        return nil
        
    }
    
}
