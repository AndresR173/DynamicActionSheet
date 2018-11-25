//
//  ListViewController.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

public protocol DynamicActionSheetDelegate: class {
    func dynamicSheet(didSelectRowAt index: Int)
    func didSelectMultipleIndexes(indexes: [Int])
    func didTapButton()
}

public protocol DynamicActionSheetDataSource: class {
    func numberOfRows(for tableView: UITableView) -> Int
    func dynamicSheet(_ actionCell: ActionTableViewCell, forItemAt index: Int)
    var listTitle: String? { get }
    var buttonTitle: String? { get }
}

protocol ListViewDelegate: class {
    func dismissView()
}

class ListView: UIView {
    //MARK: - Properties
    /// The delegate for the view, gets called when user taps button or self
    open weak var delegate: DynamicActionSheetDelegate?
    /// The datasource for the list
    open weak var datasource: DynamicActionSheetDataSource?
    
    //open var defaultTableViewHeight: CGFloat = 193.0
    
    open var canSelectMultipleValues: Bool = false
    
    open var indexes = [Int]()
    
    open var cellType: DynamicCellType! {
        didSet {
            self.registerNib()
        }
    }
    
    weak var listViewDelegate: ListViewDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneButtonWidthConstraint: NSLayoutConstraint!
    
    //MARK: - IBActions
    @IBAction func buttonAction(_ sender: UIButton) {
        self.delegate?.didTapButton()
        DispatchQueue.main.async {
            self.listViewDelegate?.dismissView()
        }
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        self.delegate?.didSelectMultipleIndexes(indexes: self.indexes)
        DispatchQueue.main.async {
            self.listViewDelegate?.dismissView()
        }
    }
    
    //MARK: - LifeCycle
    class func instanceFromNib() -> ListView {
        return UINib(nibName: "ListView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ListView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = insets
    }
    
    func showTitle() {
        self.titleLabel.text = self.datasource?.listTitle
        self.button.setTitle(self.datasource?.buttonTitle, for: .normal)
    }
    
    private func registerNib() {
        if cellType == .detail {
            self.tableView.register(UINib(nibName: "ActionTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        } else {
            self.tableView.register(UINib(nibName: "BasicTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        }
    }
}

extension ListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource?.numberOfRows(for: tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ActionTableViewCell
        self.datasource?.dynamicSheet(cell, forItemAt: indexPath.row)
        if let _ = indexes.index(where: {$0 == indexPath.row }) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.cellType == .detail {
            return 70
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !canSelectMultipleValues {
            self.delegate?.dynamicSheet(didSelectRowAt: indexPath.row)
            DispatchQueue.main.async {
                self.listViewDelegate?.dismissView()
            }
        } else {
            if let index = indexes.index(where: {$0 == indexPath.row}) {
                indexes.remove(at: index)
            } else {
                self.indexes.append(indexPath.row)
            }
            self.tableView.reloadData()
        }
    }
}

extension DynamicActionSheetDataSource {
    var buttonTitle: String? { get { return "" } }
}

extension DynamicActionSheetDelegate {
    func didTapButton() { }
    func dynamicSheet(didSelectRowAt index: Int) { }
    func didSelectMultipleIndexes(indexes: [Int]) { }
}
