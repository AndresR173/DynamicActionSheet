//
//  ListViewController.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

public protocol ListViewDelegate: class {
    func listView(didSelectRowAt index: Int)
    func didTapButton()
}

public protocol ListViewDataSource: class {
    func numberOfRows(for tableView: UITableView) -> Int
    func image(for tableView: UITableView, at index: Int) -> UIImage?
    func title(for tableView: UITableView, at index: Int) -> String?
    func subtitle(for tableView: UITableView, at index: Int) -> String?
    func title(for tableView: UITableView) -> String?
}

class ListView: UIView {
    //MARK: - Properties
    /// The delegate for the view, gets called when user taps button or self
    open weak var delegate: ListViewDelegate?
    /// The datasource for the list
    open weak var datasource: ListViewDataSource?
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    //MARK: - IBActions
    @IBAction func buttonAction(_ sender: UIButton) {
        self.delegate?.didTapButton()
    }
    
    //MARK: - LifeCycle
    class func instanceFromNib() -> ListView {
        return UINib(nibName: "ListView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ListView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.register(UINib(nibName: "ActionTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func showTitle() {
        if let title = self.datasource?.title(for: self.tableView) {
            self.titleLabel.text = title
        } else {
            self.titleHeightConstraint.constant = 0
        }
    }
}

extension ListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource?.numberOfRows(for: tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath) as! ActionTableViewCell
        cell.cellImage = self.datasource?.image(for: tableView, at: indexPath.row)
        cell.title = self.datasource?.title(for: tableView, at: indexPath.row)
        cell.subtitle = self.datasource?.subtitle(for: tableView, at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.listView(didSelectRowAt: indexPath.row)
    }
}


private struct Constants {
    static let cell = "ListCell"
}
