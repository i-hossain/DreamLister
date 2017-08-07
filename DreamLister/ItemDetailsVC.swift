//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Ismail Hossain on 2017-08-02.
//  Copyright © 2017 Ismail Hossain. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var imageThumbnail: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        imagePicker = UIImagePickerController()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        imagePicker.delegate = self
        
//        // Test Data
//        let store1 = Store(context: context)
//        store1.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context)
//        store3.name = "Future shop"
//        let store4 = Store(context: context)
//        store4.name = "Walmart"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "Zara"
//        
//        appDelegate.saveContext()
        
        self.getStores()
        
        if itemToEdit != nil {
            
            self.loadItemData()
        }
    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }
        catch {
            
            // If fetch fails, handle the error
            let error = error as NSError
            print("Error: \(error)")
        }
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            
            self.titleField.text = item.title
            self.priceField.text = "\(item.price)"
            self.detailsField.text = item.details
            self.imageThumbnail.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        self.storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
        }
    }
    
    
    @IBAction func saveItemPressed(_ sender: UIButton) {
        
        var item: Item!
        
        let picture = Image(context: context)
        picture.image = imageThumbnail.image
        
        if itemToEdit == nil {
            
            item = Item(context: context)
        }
        else {
            
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = self.titleField.text {
            
            item.title = title
        }
        
        if let price = self.priceField.text {
            
            item.price = (price as NSString).doubleValue
        }
        
        if let details = self.detailsField.text {
            
            item.details = details
        }
        
        item.toStore = stores[self.storePicker.selectedRow(inComponent: 0)]
        
        appDelegate.saveContext()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            appDelegate.saveContext()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    /**
    * Delegate methods
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update when selected
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.imageThumbnail.image = img
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }

}
