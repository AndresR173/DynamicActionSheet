//
//  DynamicActionSheet.swift
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

public class DynamicActionSheet: UIViewController {

    // MARK: - Properties

    /**
     Enabling this value, the action sheet will show a 'Done' button and it will add the ability to select multiple values.
     Once the 'Done' button is tapped, the action sheet will return an array with all the selected indexes
     */
    open var canSelectMultipleValues: Bool = false
    
    /**
     Enabling this value, will show a button at the bottom of the action sheet
     */
    open var showButton: Bool = true

    /**
     Set the style of the action sheet cells
     - options:
     - basic: the action sheet will show a cell with just one label
     - detail: the action sheet will show a cell with an UIImageView, UILabel for a title and UILabel for a subtitle
     */
    open var cellType: DynamicCellType!

    /// This array will store all the idexes selected by the user
    private var indexes = [Int]()

    /// The delegate for the view, gets called when user taps button or self
    open weak var delegate: DynamicActionSheetDelegate?

    /// The datasource for the list
    open weak var datasource: DynamicActionSheetDataSource?

    // MARK: UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Done", comment: "done"), for: .normal)

        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(doneButton)
        stackView.alignment = .fill
        stackView.spacing = 18

        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var auxButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY, width: self.view.frame.width, height: 250))
        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true

        return view
    }()

    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return backgroundView
    }()
    
    // MARK: - LifeCycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

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

// MARK: - Helpers

extension DynamicActionSheet {
    
    private func setupUI() {
        let tapReconigzer = UITapGestureRecognizer(target: self, action: #selector(hideCardView(tapGestureRecognizer:)))
        tapReconigzer.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tapReconigzer)

        let bundle = Bundle.init(for: DynamicActionSheet.self)
        self.tableView.register(UINib(nibName: cellType.rawValue, bundle: bundle), forCellReuseIdentifier: ActionTableViewCell.IDENTIFIER)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        containerView.addSubview(tableView)
        containerView.addSubview(doneButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(auxButton)
        containerView.addSubview(stackView)

        backgroundView.addSubview(containerView)
        view.addSubview(backgroundView)

        //Background View
        self.backgroundView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height))
        self.backgroundView.isUserInteractionEnabled = true
        self.view.addSubview(backgroundView)

        auxButton.isHidden = !showButton
        doneButton.isHidden = !canSelectMultipleValues

        self.titleLabel.text = self.datasource?.listTitle
        self.auxButton.setTitle(self.datasource?.buttonTitle, for: .normal)

        let showStack = self.datasource?.listTitle != nil || canSelectMultipleValues

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: showStack ? 44 : 0),

            auxButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            auxButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            auxButton.heightAnchor.constraint(equalToConstant: showButton ? 44 : 0),

            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: auxButton.topAnchor, constant: -8)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.revealAnimation()
        }
    }
    
    @objc func hideCardView(tapGestureRecognizer: UITapGestureRecognizer) {
        let location = tapGestureRecognizer.location(in: backgroundView)
        if !containerView.frame.contains(location) {
            self.hideAnimation()
        }
    }

    private func hideAnimation() {
        UIView.animate(withDuration: 0.4, animations: {
            self.containerView.frame = CGRect(x: 0,
                                              y: UIScreen.main.bounds.maxY,
                                              width: self.view.frame.width,
                                              height: self.containerView.frame.height)
        }, completion: { _ in
            self.dismiss(animated: true)
        })
    }
    
    private func revealAnimation() {
        var contentHeight = self.view.frame.height * 0.8
        let tableViewHeight = self.tableView.contentSize.height
        let currentHeight = self.stackView.frame.height + tableViewHeight + self.auxButton.frame.height + 16
        if (currentHeight < contentHeight) {
            contentHeight = currentHeight
        }
        let navHeight =  UIScreen.main.bounds.maxY - contentHeight

        UIView.animate(withDuration: 0.4, animations: {
            self.containerView.frame = CGRect(x: 0,
                                              y: navHeight,
                                              width: self.view.frame.width,
                                              height: contentHeight)
        })
    }

    @objc private func buttonAction(_ sender: UIButton) {
        self.delegate?.didTapButton()
        self.hideAnimation()
    }

    @objc private func doneButtonAction(_ sender: Any) {
        self.delegate?.didSelectMultipleIndexes(indexes: self.indexes)
        self.hideAnimation()
    }
}

// MARK: - UITableView Delegate - Datasource

extension DynamicActionSheet: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource?.numberOfRows(for: tableView) ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellType == .basic ? 40 : 60
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionTableViewCell.IDENTIFIER, for: indexPath) as! ActionTableViewCell
        self.datasource?.dynamicSheet(cell, forItemAt: indexPath.row)
        if let _ = indexes.firstIndex(where: {$0 == indexPath.row }) {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if canSelectMultipleValues {
            if let index = indexes.firstIndex(where: {$0 == indexPath.row}) {
                indexes.remove(at: index)
            } else {
                indexes.append(indexPath.row)
            }
            tableView.reloadData()
        } else {
            self.delegate?.dynamicSheet(didSelectRowAt: indexPath.row)
            self.hideAnimation()
        }
    }
}

public enum DynamicCellType: String {
    case basic = "BasicTableViewCell"
    case detail = "ActionTableViewCell"
}
