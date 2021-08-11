//
//  JoinViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/03/30.
//

import UIKit

class JoinViewController : UIViewController {
    
    var isAllAgree = false;
    var isServiceAgree = false;
    var isUserInfoAgree = false;
    var isMarketingAgree = false;
    
    @IBOutlet weak var allAgreeButton: UIButton!
    @IBOutlet weak var serviceAgreeButton: UIButton!
    @IBOutlet weak var userInfoAgreeButton: UIButton!
    @IBOutlet weak var marketingAgreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func CheckAllAgree() {
        if isServiceAgree && isUserInfoAgree && isMarketingAgree {
            isAllAgree = true
            
        } else {
            isAllAgree = false
        }
        
        allAgreeButton.isSelected = isAllAgree
        
    }
    
    func MoveToWebView(check: Bool ,name: String) {
        if check == false {
            return
        }
        
        var linkURL = "";
        
        if name == "Service" {
            linkURL = "https://winnerssign.bkwinners.kr/_files/agree1.html"
        } else if name == "UserInfo" {
            linkURL = "https://winnerssign.bkwinners.kr/_files/agree2.html"
        } else if name == "Marketing" {
            linkURL = "https://winnerssign.bkwinners.kr/_files/agree3.html"
        }
        
        let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "AgreeWebViewController") as? AgreeWebViewController
        
        webViewController?.linkURL = linkURL
        
        self.navigationController?.pushViewController(webViewController!, animated: true)
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/748cb2b7c4274bca968ed04dd6399840") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapAllAgree(_ sender: UIButton) {
        sender.isSelected.toggle()
        isAllAgree = sender.isSelected
        
        isServiceAgree = isAllAgree
        isUserInfoAgree = isAllAgree
        isMarketingAgree = isAllAgree
        
        serviceAgreeButton.isSelected = isServiceAgree
        userInfoAgreeButton.isSelected = isUserInfoAgree
        marketingAgreeButton.isSelected = isMarketingAgree
    }
    
    @IBAction func didTapServiceAgree(_ sender: UIButton) {
        sender.isSelected.toggle()
        isServiceAgree = sender.isSelected
        
        CheckAllAgree()
        
        if isServiceAgree {
            MoveToWebView(check: isServiceAgree, name: "Service")
        }
        
    }
    
    @IBAction func didTapUserInfoAgree(_ sender: UIButton) {
        sender.isSelected.toggle()
        isUserInfoAgree = sender.isSelected
        
        CheckAllAgree()
        
        if isUserInfoAgree {
            MoveToWebView(check: isUserInfoAgree, name: "UserInfo")
        }
        
    }
    
    @IBAction func didTapMarketingAgree(_ sender: UIButton) {
        sender.isSelected.toggle()
        isMarketingAgree = sender.isSelected
        
        CheckAllAgree()
        
        if isMarketingAgree {
            MoveToWebView(check: isMarketingAgree, name: "Marketing")
        }
        
    }
    
    @IBAction func didTapNextStep(_ sender: UIButton) {
        if isServiceAgree && isUserInfoAgree {
            //nextStep
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "JoinInputViewController") as? JoinInputViewController
            
            viewController?.isMarketingAgree = isMarketingAgree
            
            self.navigationController?.pushViewController(viewController!, animated: true)
        } else {
            UIManager.instance.ShowAlert(title: "", message: "필수항목을 체크해주세요", viewController: self)
        }
    }
}
