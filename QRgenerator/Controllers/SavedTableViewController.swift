//
//  SavedTableViewController.swift
//  QRgenerator
//
//  Created by Artjoms Vorona on 19/12/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import CoreData
import UIKit

class SavedTableViewController: UITableViewController {
    
    var items = [Items]()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    //MARK: Core Data functions
    
    func saveData() {
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do {
            items = try (context?.fetch(request))!
        } catch  {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? SavedTableViewCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.qrCodeImageView.image = UIImage(data: item.qrImage!)
        if item.text == "" {
            cell.codeTextLabel?.text = "QR code text is empty"
        } else {
            cell.codeTextLabel?.text = item.text
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = items[indexPath.row]
            items.remove(at: indexPath.row)
            context?.delete(itemToDelete)
            self.saveData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVCsegue" {
            guard let detailVC = segue.destination as? DetailViewController else { return}
            
            let item = items[tableView.indexPathForSelectedRow!.row]
            
            detailVC.qrImage = item.qrImage
            detailVC.text = item.text ?? ""
        }
    }
    

}
