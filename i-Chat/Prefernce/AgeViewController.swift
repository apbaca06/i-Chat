//
//  AgeViewController.swift
//  i-Chat
//
//  Created by cindy on 2017/12/26.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import Foundation
import Firebase
import KeychainSwift
import Crashlytics

extension Date {

    var compareToNow: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}

class AgeViewController: UIViewController {

    @IBOutlet weak var birthdayImage: UIImageView!

    @IBOutlet weak var chickenImage: UIImageView!

    @IBOutlet weak var decriptionLabel: UILabel!

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var ageLabel: UILabel!

    @IBOutlet weak var button: UIButton!

    var formatter = DateFormatter()

    let keychain = KeychainSwift()

    @IBAction func pickDate(_ sender: UIDatePicker) {

        let userBirthday = "\(formatter.string(from: sender.date))"

        dateLabel.text = userBirthday

        let birthdayComponents = userBirthday.components(separatedBy: "-")

        let dateTransform = Calendar.current.date(from: DateComponents(year:
            Int(birthdayComponents[0]), month: Int(birthdayComponents[1]), day:
            Int(birthdayComponents[2])))!

        let age = dateTransform.compareToNow

        UserDefaults.standard.set(age, forKey: "Age")

        ageLabel.text = String(describing: age)

        guard let uid = keychain.get("uid")
            else { return }

        DatabasePath.userRef.child(uid).updateChildValues(["age": age])
        DatabasePath.userRef.child(uid).child("agePreference").updateChildValues([
            "min": 18,
            "max": 55
            ])
        DatabasePath.userRef.child(uid).updateChildValues([
            "maxDistance": 160])
        DatabasePath.userRef.child(uid).child("likeList").updateChildValues([
            "test": 0])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        decriptionLabel.text = NSLocalizedString("Set your birthday", comment: "")

        button.cornerRadius = 10

        button.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)

        dateLabel.text = NSLocalizedString("Your birthday", comment: "")

        ageLabel.text = NSLocalizedString("Your age", comment: "")

        self.formatter.dateFormat = "yyyy-MM-dd"

        datePicker.datePickerMode = .date

        let defaultDate = formatter.date(from: "1994-04-09")!
        datePicker.date = defaultDate

        let fromDateTime = formatter.date(from: "1940-01-01")

        let tillDateTime = Calendar.current.date(byAdding: .year, value: -18, to: Date())

        datePicker.minimumDate = fromDateTime

        datePicker.maximumDate = tillDateTime

    }
    @IBAction func confirm(_ sender: Any) {

        if ageLabel.text != NSLocalizedString("Your age", comment: "") {

           let setImgViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetImgViewController")
        self.navigationController?.pushViewController(setImgViewController)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Please select your age!", comment: ""), message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            alertController.addAction(okAction)
            alertController.show()
        }
    }

}
