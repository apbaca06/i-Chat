//
//  FriendCollectionViewCell.swift
//  i-Chat
//
//  Created by cindy on 2018/1/2.
//  Copyright © 2018年 Jui-hsin.Chen. All rights reserved.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageView.cornerRadius = profileImageView.bounds.width/2

    }

}