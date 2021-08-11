//
//  ContractIndividualFinishViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/27.
//

import UIKit

class ContractIndividualFinishViewController : UIViewController {
    
    @IBOutlet weak var serviceCompanyLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var serviceBusinessNumLabel: UILabel!
    @IBOutlet weak var serviceCalculateLabel: UILabel!
    @IBOutlet weak var terminalLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var rrnLabel: UILabel!
    
    @IBOutlet weak var cinditionLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var addr1Label: UILabel!
    @IBOutlet weak var addr2Label: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var bankNumLabel: UILabel!
    @IBOutlet weak var depositorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var signNameLabel: UILabel!
    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var agentLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        img1.layer.borderWidth = 1
        img1.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        img2.layer.borderWidth = 1
        img2.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        LoadIndividualContract()
        
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/3bebc81941ff4f76ad3a78f12fa59eee") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func LoadIndividualContract() {
        HttpsManager.instance.selectMyIndividual(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: {
            (sucess, data) in
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Individual.self, from: data) {
                
                if contract.result == "true" {
                    DataManager.instance.individual.in_seq = contract.in_seq
                    
                    self.nameLabel.text = contract.in_name
                    self.companyLabel.text = contract.in_company
                    self.adminLabel.text = contract.in_admin
                    self.phoneLabel.text = contract.in_phone
                    self.rrnLabel.text = contract.in_rrn
                    self.itemLabel.text = contract.in_item
                    self.zipcodeLabel.text = contract.in_zipcode
                    self.addr1Label.text = contract.in_addr1
                    self.addr2Label.text = contract.in_addr2
                    self.telLabel.text = contract.in_tel
                    self.bankLabel.text = contract.in_bank_name
                    self.bankNumLabel.text = contract.in_bank_num
                    self.depositorLabel.text = contract.in_depositor
                    self.dateLabel.text = contract.in_wdate
                    self.signNameLabel.text = contract.in_name
                    self.agentLabel.text = contract.in_agent
                    
                    self.serviceCompanyLabel.text = "부국위너스 주식회사"
                    self.serviceChargeLabel.text = "3.5%(부과세별도)"
                    self.serviceBusinessNumLabel.text = contract.in_sv_bs_num
                    self.serviceCalculateLabel.text = contract.in_sv_calculate
                    
                    if contract.in_terminal_1 == "Y" {
                        self.terminalLabel.text?.append("수기결제, ")
                    }
                    
                    if contract.in_terminal_2 == "Y" {
                        self.terminalLabel.text?.append("스와이프, ")
                    }
                    
                    if contract.in_terminal_3 == "Y" {
                        self.terminalLabel.text?.append("무선단말기, ")
                    }
                    
                    let range = (self.terminalLabel.text?.index(self.terminalLabel.text!.endIndex, offsetBy: -2))!..<self.terminalLabel.text!.endIndex
                    self.terminalLabel.text?.removeSubrange(range)
                    
                    //이미지 로드
                    if let idURL = URL(string: contract.path3) {
                        let idData = try? Data(contentsOf: idURL)
                        self.img1.image = UIImage(data: idData!)
                    }
                    
                    if let bankURL = URL(string: contract.path4) {
                        let bankData = try? Data(contentsOf: bankURL)
                        self.img2.image = UIImage(data: bankData!)
                    }
                    
                    if let signURL = URL(string: contract.path7) {
                        let signData = try? Data(contentsOf: signURL)
                        self.signImage.image = UIImage(data: signData!)
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "계약서 정보가 없습니다", viewController: self)
                }
            }
        })
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        var dic = [String: String]()
        dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "in_idnum")
        dic.updateValue(DataManager.instance.individual.in_seq, forKey: "in_seq")
        dic.updateValue("Y", forKey: "in_finish")
        
        //서버로 전송
        HttpsManager.instance.updateIndividual(view: self, data: dic, completionHandler: {
            (success, responseString) in
            let response = responseString as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Individual.self, from: data) {
                
                DataManager.instance.individual.in_seq = contract.in_seq
                
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
