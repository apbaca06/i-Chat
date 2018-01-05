//
//  ChatCollectionViewCell.swift
//  i-Chat
//
//  Created by cindy on 2017/12/17.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class ChatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var numberLabel: UILabel!

    var friendList: [User] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.cornerRadius = numberLabel.bounds.width/2

        label.text = NSLocalizedString("Friends", comment: "")

    }

}
