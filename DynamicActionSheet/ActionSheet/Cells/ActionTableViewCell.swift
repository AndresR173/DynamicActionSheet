//
//  ActionTableViewCell.swift
//  DynamicActionSheet
//
//  Created by Andres Rojas on 10/24/18.
//  Copyright © 2018 MIlaro Software. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //MARK: - Properties
    var cellImage: UIImage? {
        didSet {
            self.imgView.image = cellImage
        }
    }
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var subtitle: String? {
        didSet {
            self.subtitleLabel.text = subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
    }
    
}
