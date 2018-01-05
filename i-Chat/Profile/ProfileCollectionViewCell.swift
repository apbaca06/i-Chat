//
//  ProfileCollectionViewCell.swift
//  i-Chat
//
//  Created by cindy on 2017/12/17.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Nuke
import KeychainSwift

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var toSettingButton: UIButton!

    @IBOutlet weak var ageLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var profileImg: UIImageView!

    @IBOutlet weak var circleProfileImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        circleProfileImg.layer.cornerRadius = (UIScreen.main.bounds.width * 0.85)/2
        circleProfileImg.clipsToBounds = true

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)

        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.frame = profileImg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileImg.addSubview(blurEffectView)

        let keychain = KeychainSwift()

        guard let uid = keychain.get("uid")
            else { return }

        DatabasePath.userRef.child(uid).observeSingleEvent(of: .value) { [unowned self] (datashot) in

            guard let jsonObject = datashot.value as? [String: Any],
                let name = jsonObject["name"] as? String,
                let age = jsonObject["age"] as? Int,
                let profileImgString = jsonObject["profileImgURL"]  as? String
                else { return }

            self.nameLabel.text = name

            self.ageLabel.text = "\(String(describing: age)) yr"

            if let profileImgURL = URL(string: profileImgString) {

                Manager.shared.loadImage(with: profileImgURL, into: self.profileImg)
                Manager.shared.loadImage(with: profileImgURL, into: self.circleProfileImg)

                self.reloadInputViews()

                self.profileImg.contentMode = .scaleAspectFill
            }

        }

    }

}
