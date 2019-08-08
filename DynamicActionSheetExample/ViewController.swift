//
//  ViewController.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit
import DynamicActionSheet

class ViewController: UIViewController {
    //MARK: - IBoutlets
    @IBOutlet weak var showButtonSwitch: UISwitch!
    @IBOutlet weak var multipleSelectionSwitch: UISwitch!
    //MARK: - IBActions
    @IBAction func showList(_ sender: Any) {
        let list = DynamicActionSheet(nibName: nil, bundle: nil)
        list.delegate = self
        list.datasource = self
        list.cellType = .basic
        list.showButton = showButtonSwitch.isOn
        list.canSelectMultipleValues = multipleSelectionSwitch.isOn
        self.present(list, animated: true)
    }
    
    //MARK: - LIfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: DynamicActionSheetDelegate, DynamicActionSheetDataSource {
    func didTapButton() {
        
    }

    func numberOfRows(for tableView: UITableView) -> Int {
        return 10
    }
    
    func dynamicSheet(_ actionCell: ActionTableViewCell, forItemAt index: Int) {
        actionCell.titleLabel.text = "Cell \(index)"
    }
    
    func didSelectMultipleIndexes(indexes: [Int]) {
        print("\(indexes.count) values selected")
    }
    
    var listTitle: String? {
        return "Title"
    }
    
    var buttonTitle: String? {
        return "All Items"
    }
    
    func dynamicSheet(didSelectRowAt index: Int) {
        print("row \(index) selected")
    }
}
