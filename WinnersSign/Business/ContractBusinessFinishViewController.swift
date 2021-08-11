//
//  ContractBusinessFinishViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/21.
//

import UIKit

class ContractBusinessFinishViewController : UIViewController {
    
    @IBOutlet weak var serviceDivideLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var serviceCalculateLabel: UILabel!
    @IBOutlet weak var terminalLabel: UILabel!
    
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var businessDivideLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var businessNumLabel: UILabel!
    @IBOutlet weak var cinditionLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var addr1Label: UILabel!
    @IBOutlet weak var addr2Label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankNumLabel: UILabel!
    @IBOutlet weak var depositorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var signNameLabel: UILabel!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var agentLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        img1.layer.borderWidth = 1
        img1.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        img2.layer.borderWidth = 1
        img2.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        img3.layer.borderWidth = 1
        img3.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        LoadBusinessContract()
    }
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/6e480593f7d0476cb042ac0bbde65ae4") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        RequsetServer()
    }
    
    
    func LoadBusinessContract() {
        HttpsManager.instance.selectMyLicensee(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: {
            (success, data) in
            
            let response = data as! String
            let responseData = response.data(using: .utf8)
            if let data = responseData, let contract = try?
                JSONDecoder().decode(Business.self, from: data) {
                
                if contract.result == "true" {
                    
                    DataManager.instance.business.li_seq = contract.li_seq
                    
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
                        self.businessDivideLabel.text = "개인"
                    } else {
                        self.businessDivideLabel.text = "법인"
                    }
                    
                    self.adminLabel.text = contract.li_admin
                    self.telLabel.text = contract.li_tel
                    self.businessNumLabel.text = contract.li_bs_num
                    self.cinditionLabel.text = contract.li_cindition
                    self.eventLabel.text = contract.li_event
                    self.zipcodeLabel.text = contract.li_zipcode
                    self.addr1Label.text = contract.li_addr1
                    self.addr2Label.text = contract.li_addr2
                    self.nameLabel.text = contract.li_re_name
                    self.birthLabel.text = contract.li_re_birth
                    self.phoneLabel.text = contract.li_re_phone
                    self.emailLabel.text = contract.li_re_email
                    self.bankNameLabel.text = contract.li_bank_name
                    self.bankNumLabel.text = contract.li_bank_num
                    self.depositorLabel.text = contract.li_depositor
                    
                    self.dateLabel.text = contract.li_wdate
                    self.signNameLabel.text = contract.li_name
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
                        self.img4.image = UIImage(data: signData!)
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "계약서 정보가 없습니다", viewController: self)
                }
                
            }
        })
    }
    
    func RequsetServer() {
        var dic = [String: String]()
        dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "li_idnum")
        dic.updateValue(DataManager.instance.business.li_seq, forKey: "li_seq")
        dic.updateValue("Y", forKey: "li_finish")
        
        HttpsManager.instance.updateLicensee(view: self, data: dic, completionHandler: {
            (success, responseString) in
            let response = responseString as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Business.self, from: data) {
                
                if contract.result == "true" {
                    UIManager.instance.ShowAlert(title: "가입신청 완료", message: "계약서 작성이 완료되었습니다", viewController: self, completionHandler: {
                        (result) in
                        
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "LoginMenuViewController")
                    })
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "다시 시도 해주세요", viewController: self)
                }
            }
        })
    }
}
