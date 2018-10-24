//
//  ViewController.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func showList(_ sender: Any) {
        let list = DynamicActionSheet()
        list.delegate = self
        list.datasource = self
        self.present(list, animated: true)
    }
}

extension ViewController: ListViewDataSource, ListViewDelegate {
    func numberOfRows(for tableView: UITableView) -> Int {
        return 3
    }
    
    func image(for tableView: UITableView, at index: Int) -> UIImage? {
        return UIImage(named: "no-thumbnail")
    }
    
    func title(for tableView: UITableView, at index: Int) -> String? {
        return "Andres \(index)"
    }
    
    func subtitle(for tableView: UITableView, at index: Int) -> String? {
        return "Software developer \(index)"
    }
    
    func listView(didSelectRowAt index: Int) {
        print("cell \(index)")
    }
    
    func didTapButton() {
        print("button")
    }
}
