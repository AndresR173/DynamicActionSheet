//
//  DynamicActionSheet.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

class DynamicActionSheet: UIViewController {
    //MARK: - Properties
    lazy open var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return backgroundView
    }()
    let rootView = ListView.instanceFromNib()
    open var presentingNavigationController: UINavigationController? {
        return (presentingViewController as? UINavigationController) ?? presentingViewController?.navigationController
    }
    fileprivate var initialContentInset: UIEdgeInsets!
    open var contentHeight: CGFloat = 200
    open var delegate: ListViewDelegate? {
        didSet {
            self.rootView.delegate = delegate
        }
    }
    open var datasource: ListViewDataSource? {
        didSet {
            self.rootView.datasource = datasource
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
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
    }
    
    @objc func hideCardView(tapGestureRecognizer: UITapGestureRecognizer) {
        let location = tapGestureRecognizer.location(in: backgroundView)
        if !rootView.frame.contains(location) {
            self.dismiss(animated: true)
        }
    }
    
    private func revealAnimation() {
        let navHeight =  UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.4, animations: {
            self.rootView.frame = CGRect(x: 0, y: navHeight - self.contentHeight, width: self.view.frame.width, height: self.contentHeight)
        })
    }
}
