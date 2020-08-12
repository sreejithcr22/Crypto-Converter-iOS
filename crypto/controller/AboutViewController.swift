//
//  AboutViewController.swift
//  crypto
//
//  Created by Sreejith CR on 12/08/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var feedbackContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onFeedbackClicked(_ sender: UITapGestureRecognizer) {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["codit.apps@gmail.com"])
            mail.setSubject("Feedback: Crypto-iOS")
            present(mail, animated: true)
        } else {
            showAlertWith(message: "This action could not be completed")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}
