//
//  TableViewController.swift
//  SwiftModulesDemo
//
//  Created by ash on 2020/8/21.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit

class ATableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        debugPrint("awakeFromNib")
        super.awakeFromNib()
    }
    
    override func cc_setupUI() {
        debugPrint("setupUI")
    }
    
    override func cc_setupLayout() {
        debugPrint("setupLayout")
    }
    
    override func cc_bindViewModel() {
        debugPrint("bindViewModel")
    }
}


class TableViewController: UITableViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

}
