//
//  MyBusinessContractViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/27.
//

import UIKit

class MyBusinessContractViewController : UIViewController {
    
    @IBOutlet weak var serviceDivideLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var serviceCalculateLabel: UILabel!
    @IBOutlet weak var terminalLabel: UILabel!
    
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var BusinessDivideLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var businessNumLabel: UILabel!
    @IBOutlet weak var cinditionLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var reNameLabel: UILabel!
    @IBOutlet weak var reBirthLabel: UILabel!
    @IBOutlet weak var rePhoneLabel: UILabel!
    @IBOutlet weak var reEmailLabel: UILabel!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankNumLabel: UILabel!
    @IBOutlet weak var depositorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var agentLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img1.layer.borderWidth = 1
        img1.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        img2.layer.borderWidth = 1
        img2.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        img3.layer.borderWidth = 1
        img3.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        LoadMyBusinessContract()
    }
    
    func LoadMyBusinessContract() {
        
        var dic = [String: String]()
        dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "li_idnum")
        
        HttpsManager.instance.selectContract_li(view: self , data: dic, completionHandler: {
            (success, responseString) in
            let response = responseString as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Business.self, from: data) {
                
                if contract.li_sv_divide == "1" {
                    self.serviceDivideLabel.text = "신용카드"
                } else if contract.li_sv_divide == "2" {
                    self.serviceDivideLabel.text = "가상계좌"
                } else if contract.li_sv_divide == "3" {
                    self.serviceDivideLabel.text = "계좌이체"
                } else {
                    self.serviceDivideLabel.text = "휴대폰결제"
                }
                
                self.serviceChargeLabel.text = "3.5%(부과세별도)"
                self.serviceCalculateLabel.text = contract.li_sv_calculate
                
                if contract.li_terminal_1 == "Y" {
                    self.terminalLabel.text?.append("수기결제, ")
                }
                
                if contract.li_terminal_2 == "Y" {
                    self.terminalLabel.text?.append("스와이프, ")
                }
                
                if contract.li_terminal_3 == "Y" {
                    self.terminalLabel.text?.append("무선단말기, ")
                }
                
                let range = (self.terminalLabel.text?.index(self.terminalLabel.text!.endIndex, offsetBy: -2))!..<self.terminalLabel.text!.endIndex
                self.terminalLabel.text?.removeSubrange(range)
                
                self.companyLabel.text = contract.li_company
                
                if contract.li_bs_divide == "1" {
                    self.BusinessDivideLabel.text = "개인"
                } else {
                    self.BusinessDivideLabel.text = "법인"
                }
                
                self.adminLabel.text = contract.li_admin
                self.telLabel.text = contract.li_tel
                self.businessNumLabel.text = contract.li_bs_num
                self.cinditionLabel.text = contract.li_cindition
                self.eventLabel.text = contract.li_event
                
                let address = "(\(contract.li_zipcode))  \(contract.li_addr1) \(contract.li_addr2)"
                self.addressLabel.text = address
                self.reNameLabel.text = contract.li_re_name
                self.reBirthLabel.text = contract.li_re_birth
                self.rePhoneLabel.text = contract.li_re_phone
                self.reEmailLabel.text = contract.li_re_email
                self.bankNameLabel.text = contract.li_bank_name
                self.bankNumLabel.text = contract.li_bank_num
                self.depositorLabel.text = contract.li_depositor
                
                self.dateLabel.text = contract.li_wdate
                self.nameLabel.text = contract.li_name
                self.agentLabel.text = contract.li_agent
                
                //이미지 로드
                if let idURL = URL(string: contract.path3) {
                    let idData = try? Data(contentsOf: idURL)
                    self.img1.image = UIImage(data: idData!)
                }
                
                if let bankURL = URL(string: contract.path4) {
                    let bankData = try? Data(contentsOf: bankURL)
                    self.img2.image = UIImage(data: bankData!)
                }
                
                if let licenseURL = URL(string: contract.path5) {
                    let licenseData = try? Data(contentsOf: licenseURL)
                    self.img3.image = UIImage(data: licenseData!)
                }
                
                if let signURL = URL(string: contract.path7) {
                    let signData = try? Data(contentsOf: signURL)
                    self.signImage.image = UIImage(data: signData!)
                }

            }
            
        })
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "LoginMenuViewController")
    }
    
    
}
