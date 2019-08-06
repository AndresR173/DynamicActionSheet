//
//  DynamicActionSheet.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

public class DynamicActionSheet: UIViewController {
    //MARK: - Properties
    lazy open var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return backgroundView
    }()
    
    lazy private var rootView: ListView = { [unowned self] in
        let view = ListView.instanceFromNib()
        view.listViewDelegate = self
        return view
    }()
    
    open var presentingNavigationController: UINavigationController? {
        return (presentingViewController as? UINavigationController) ?? presentingViewController?.navigationController
    }
    
    fileprivate var initialContentInset: UIEdgeInsets!
    lazy var contentHeight: CGFloat = { [weak self] in
        return self!.view.frame.height * 0.8
        }()
    
    ///Dynamic cell delegate
    open var delegate: DynamicActionSheetDelegate? {
        didSet {
            self.rootView.delegate = delegate
        }
    }
    
    ///Dynamic cell datasource
    open var datasource: DynamicActionSheetDataSource? {
        didSet {
            self.rootView.datasource = datasource
        }
    }
    
    /**
     Enabling this value, the action sheet will show a 'Done' button and it will add the ability to select multiple values.
     Once the 'Done' button is tapped, the action sheet will return an array with all the selected indexes
     */
    open var canSelectMultipleValues: Bool = false {
        didSet {
            self.rootView.canSelectMultipleValues = canSelectMultipleValues
        }
    }
    
    /**
     Enabling this value, will show a button at the bottom of the action sheet
     */
    open var showButton: Bool = true {
        didSet {
            self.rootView.button.isHidden = !showButton
        }
    }
    /**
     Set the style of the action sheet cells
     - options:
     - basic: the action sheet will show a cell with just one label
     - detail: the action sheet will show a cell with an UIImageView, UILabel for a title and UILabel for a subtitle
     */
    open var cellType: DynamicCellType! {
        didSet {
            self.rootView.cellType = cellType
        }
    }
    
    open var indexes = [Int]() {
        didSet {
            self.rootView.indexes = indexes
        }
    }
    
    //MARK: - LifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        addBottomSheeetView()
    }
    
    // MARK: - ActionController initializers
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }
}

extension DynamicActionSheet {
    func addBottomSheeetView() {
        let height = view.frame.height
        let width  = view.frame.width
        
        rootView.frame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height), size: rootView.frame.size)
        self.backgroundView.addSubview(rootView)
        
        //Background View
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.backgroundView.isUserInteractionEnabled = true
        self.view.addSubview(backgroundView)
        self.rootView.showTitle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.revealAnimation()
        }
    }
    
    private func setupUI() {
        let tapReconigzer = UITapGestureRecognizer(target: self, action: #selector(hideCardView(tapGestureRecognizer:)))
        tapReconigzer.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tapReconigzer)
        self.rootView.layer.cornerRadius = 7
        self.rootView.layer.masksToBounds = true
        
        if !canSelectMultipleValues {
            self.rootView.doneButtonWidthConstraint.constant = 0
        }
    }
    
    @objc func hideCardView(tapGestureRecognizer: UITapGestureRecognizer) {
        let location = tapGestureRecognizer.location(in: backgroundView)
        if !rootView.frame.contains(location) {
            self.dismiss(animated: true)
        }
    }
    
    private func revealAnimation() {
        let tableViewHeight = self.rootView.tableView.contentSize.height
        let currentHeight = self.rootView.titleLabel.frame.height + self.rootView.button.frame.height + 32 + tableViewHeight
        if (currentHeight <= self.contentHeight) {
            self.contentHeight = currentHeight
        }
        var navHeight =  UIScreen.main.bounds.maxY - self.contentHeight
        if !showButton {
            navHeight = navHeight + self.rootView.button.frame.height
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.rootView.frame = CGRect(x: 0, y: navHeight, width: self.view.frame.width, height: self.contentHeight)
        })
    }
}
public enum DynamicCellType: String {
    case basic = "BasicTableViewCell"
    case detail = "ActionTableViewCell"
}

extension DynamicActionSheet: ListViewDelegate {
    func dismissView() {
        self.dismiss(animated: true)
    }
}
