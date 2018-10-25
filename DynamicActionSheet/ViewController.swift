//
//  ViewController.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBoutlets
    @IBOutlet weak var showButtonSwitch: UISwitch!
    //MARK: - IBActions
    @IBAction func showList(_ sender: Any) {
        let list = DynamicActionSheet()
        list.delegate = self
        list.datasource = self
        list.showButton = showButtonSwitch.isOn
        self.present(list, animated: true)
    }
    
    //MARK: - LIfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: ListViewDataSource, ListViewDelegate {
    func listView(didSelectRowAt index: Int) {
        print("Cell \(index)")
    }
    
    var listTitle: String? {
        return "Select..."
    }
    
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
    
    func didTapButton() {
        print("button")
    }
    
    var buttonTitle: String? {
        return "All"
    }
}
