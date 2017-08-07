//
//  MainVC.swift
//  DreamLister
//
//  Created by Ismail Hossain on 2017-07-26.
//  Copyright © 2017 Ismail Hossain. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        self.generateTestData()
        self.attemptFetch()
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if self.segment.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
        }
        else if self.segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
        }
        else if self.segment.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do {
            
            try controller.performFetch()
        }
        catch {
            
            let error = error as NSError
            print("Error: \(error)")
        }
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        let item = self.controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func generateTestData() {
        
        let item1 = Item(context: context)
        item1.title = "New MacBook Pro"
        item1.price = 2300
        item1.details = "Can't wait to get my hands on the new MacBook Pro!"
        
        let item2 = Item(context: context)
        item2.title = "Wireless Keyboard"
        item2.price = 100
        item2.details = "Need one for my desktop"
        
        let item3 = Item(context: context)
        item3.title = "Chevy Camaro SS"
        item3.price = 95000
        item3.details = "Always wanted a bumblebee for myself"
        
        appDelegate.saveContext()
    }
    
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        
        self.attemptFetch()
        self.tableView.reloadData()
    }
    
    
    /**
    * DELEGATES
    */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = self.controller.sections {
            
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = self.controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell {
            
            self.configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objects = self.controller.fetchedObjects, objects.count > 0 {
            
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "goToItemDetailsVC", sender: item)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                self.configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItemDetailsVC" {
            
            if let destination = segue.destination as? ItemDetailsVC {
                
                if let item = sender as? Item {
                    
                    destination.itemToEdit = item
                }
            }
        }
    }

}

