//
//  ActionTableViewCell.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

open class ActionTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet public weak var imgView: UIImageView?
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        imgView?.layer.cornerRadius = 20
        imgView?.layer.masksToBounds = true
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}
