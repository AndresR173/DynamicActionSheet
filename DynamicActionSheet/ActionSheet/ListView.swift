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

public class ListView: UIView {

    //MARK: - Properties



    // MARK: - UI properties

    
    
    // MARK: - IBOutlets
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var button: UIButton!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var doneButton: UIButton!
//    @IBOutlet weak var doneButtonWidthConstraint: NSLayoutConstraint!

    // MARK: - IBActions
//    @IBAction func buttonAction(_ sender: UIButton) {
//        self.delegate?.didTapButton()
//        DispatchQueue.main.async {
//            self.listViewDelegate?.dismissView()
//        }
//    }
//    @IBAction func doneButtonAction(_ sender: Any) {
//        self.delegate?.didSelectMultipleIndexes(indexes: self.indexes)
//        DispatchQueue.main.async {
//            self.listViewDelegate?.dismissView()
//        }
//    }

    // MARK: - LifeCycle
//    class func instanceFromNib() -> ListView {
//        return UINib(nibName: "ListView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ListView
//    }

    // MARK: - LifeCycle
    public override init(frame: CGRect) {
        super.init(frame: frame)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



// MARK: - Helpers
extension ListView {
    

    private func setupUI() {

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
