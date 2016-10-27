//
//  ViewController.swift
//  SmoothPictures
//
//  Created by O.Ohorbach on 10/24/16.
//  Copyright © 2016 O.Ohorbach. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = dataSource
        }
    }
    
    var delegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = delegate
        }
    }
}

extension ViewController: ImageDataSourceOutput {
    func didUpdate() {
        tableView.reloadData()
    }
}

