//
//  IncomingCallViewController.swift
//  i-Chat
//
//  Created by cindy on 2017/12/14.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class IncomingCallViewController: UIViewController {

    @IBOutlet weak var callDescription: UILabel!

    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var acceptButton: UIButton!

    @IBOutlet weak var rejectButton: UIButton!

    @IBAction func rejectButton(_ sender: UIButton) {
        
        RingtoneManager.shared.ringPlayer.stop()

        print("***Did reject")

        CallManager.shared.session?.rejectCall(nil)

        print("****\(CallManager.shared.session)")

        CallManager.shared.session = nil

        self.callDescription.text = NSLocalizedString("拒絕通話", comment: "")

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func acceptButton(_ sender: UIButton) {
        
        print("Did accept")
        
        RingtoneManager.shared.ringPlayer.stop()

        // userInfo - the custom user information dictionary for the accept call. May be nil.
        //        let userInfo: [String: String] = ["key": "value"]
        CallManager.shared.session?.acceptCall(nil)

        let audioViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AudioViewController")

        self.present(audioViewController, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonShape()

        RingtoneManager.shared.playRingtone()

    }

    func setUpButtonShape() {
        rejectButton.layer.cornerRadius = rejectButton.frame.width/2

        acceptButton.layer.cornerRadius = acceptButton.frame.width/2
    }

}