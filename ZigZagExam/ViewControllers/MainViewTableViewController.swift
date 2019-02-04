//
//  MainViewTableViewController.swift
//  ZigZagExam
//
//  Created by Eliric Rivera on 03/02/2019.
//  Copyright © 2019 Eliric Rivera. All rights reserved.
//

import UIKit

class MainViewTableViewController: UITableViewController {
    var venues:[Venue]?
    let segueDetail = "showDetails"
    var iRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.venues?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        // Configure the cell...
        let venue = self.venues?[indexPath.row]
        cell.textLabel?.text = venue?.name
        cell.detailTextLabel?.text = "Distance: \(String(describing: venue!.distance))m"
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        iRow = indexPath.row
        performSegue(withIdentifier: segueDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueDetail {
            if let destinationVC = segue.destination as? DetailsViewController {
                let venue = venues?[iRow]
                destinationVC.venue = venue
            }
        }
    }

}
