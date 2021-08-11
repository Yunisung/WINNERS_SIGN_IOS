//
//  ContractIndividualServiceViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/23.
//

import UIKit

class ContractIndividualServiceViewController : UIViewController {
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var businessNumLabel: UILabel!
    @IBOutlet weak var calculateLabel: UILabel!
    
    @IBOutlet weak var terminal1Button: UIButton!
    @IBOutlet weak var terminal2Button: UIButton!
    @IBOutlet weak var terminal3Button: UIButton!
    
    @IBOutlet weak var terminal4Button: UIButton!
    @IBOutlet weak var terminal5Button: UIButton!
    
    @IBOutlet weak var costlumpsumbtn: UIButton!
    @IBOutlet weak var costmonthlybtn: UIButton!
    @IBOutlet weak var costView: UIStackView!
    
    var isTerminal1 = false
    var isTerminal2 = false
    var isTerminal3 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        costView.isHidden = true
        LoadIndividualContract()
        self.companyLabel.text = "부국위너스 주식회사"
        self.chargeLabel.text = "3.5%(부과세별도)"
    }
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/93269af6c85c43eb823b764f2ba2b5ba") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func LoadIndividualContract() {
        HttpsManager.instance.selectMyIndividual(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: {
            (sucess, data) in
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Individual.self, from: data) {
                
                if contract.result == "true" {
                    
                    self.companyLabel.text = "부국위너스 주식회사"
                    self.chargeLabel.text = "3.5%(부과세별도)"
                    self.businessNumLabel.text = contract.in_sv_bs_num
                    self.calculateLabel.text = contract.in_sv_calculate
                    
                    if contract.in_terminal_1 == "Y" {
                        //self.terminal1Button.isSelected = true
                        self.isTerminal1 = true
                        self.terminal5Button.isSelected = true
                    }
                    
                    if contract.in_terminal_2 == "Y" {
                        //self.terminal2Button.isSelected = true
                        //self.isTerminal2 = true
                    }
                    
                    if contract.in_terminal_3 == "Y" {
                        //self.terminal3Button.isSelected = true
                        self.isTerminal3 = true
                        self.terminal4Button.isSelected = true
                        
                        self.costView.isHidden = false
                        if (contract.in_sv_cost == "lumpsum") {
                            self.costlumpsumbtn.isSelected = true
                            self.costmonthlybtn.isSelected = false
                        } else if (contract.in_sv_cost == "monthly") {
                            self.costmonthlybtn.isSelected = true
                            self.costlumpsumbtn.isSelected = false
                        }
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "다시 시도해주세요", viewController: self)
                }
            }
        })
    }
    
    @IBAction func didTapTerminal1(_ sender: UIButton) {
        sender.isSelected.toggle()
        isTerminal1 = sender.isSelected
    }
    
    @IBAction func didTapTerminal2(_ sender: UIButton) {
        //sender.isSelected.toggle()
        //isTerminal2 = sender.isSelected
    }
    
    @IBAction func didTapTerminal3(_ sender: UIButton) {
        sender.isSelected.toggle()
        isTerminal3 = sender.isSelected
    }
    
    //무선단말기
    @IBAction func didTapTerminal4(_ sender: UIButton) {
        sender.isSelected.toggle()
        isTerminal3 = sender.isSelected
        
        if (sender.isSelected) {
            costView.isHidden = false
        } else {
            costView.isHidden = true
        }
    }
    
    //수기결제
    @IBAction func didTapTerminal5(_ sender: UIButton) {
        sender.isSelected.toggle()
        isTerminal1 = sender.isSelected
    }
    
    @IBAction func didTaplumpsum(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if(costmonthlybtn.isSelected) {
            costmonthlybtn.isSelected = false
        }
    }
    
    @IBAction func didTapMonthly(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if(costlumpsumbtn.isSelected) {
            costlumpsumbtn.isSelected = false
        }
    }
    
    
    @IBAction func didTapNext(_ sender: UIButton) {
        
        if isTerminal3 {
            if(costmonthlybtn.isSelected == false &&
                costlumpsumbtn.isSelected == false) {
                UIManager.instance.ShowAlert(title: "", message: "청구비용을 선택해주세요", viewController: self)
                return
            }
            
        }
        
        
        if isTerminal1 || isTerminal2 || isTerminal3 {
            var dic = [String: String]()
            
            if isTerminal1 { dic.updateValue("Y", forKey: "in_terminal_1")}
            else { dic.updateValue("N", forKey: "in_terminal_1")}
            
//            if isTerminal2 { dic.updateValue("Y", forKey: "in_terminal_2")}
//            else { dic.updateValue("N", forKey: "in_terminal_2")}
            
            if isTerminal3 {
                
                dic.updateValue("Y", forKey: "in_terminal_3")
                
                if (costlumpsumbtn.isSelected) {
                    dic.updateValue("lumpsum", forKey: "in_sv_cost")
                } else if (costmonthlybtn.isSelected) {
                    dic.updateValue("monthly", forKey: "in_sv_cost")
                }
            }
            else { dic.updateValue("N", forKey: "in_terminal_3")}
            
            dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "in_idnum")
            dic.updateValue(DataManager.instance.individual.in_seq, forKey: "in_seq")
            
            //수수료 변경
            dic.updateValue("부국위너스 주식회사", forKey: "in_sv_company")
            dic.updateValue("3.5%", forKey: "in_sv_charge")
            
            
            dic.updateValue(DataManager.instance.sessionMember.mb_id, forKey: "in_admin")
            
            //서버로 전송
            HttpsManager.instance.updateIndividual(view: self, data: dic, completionHandler: {
                (success, responseString) in
                let response = responseString as! String
                let data = response.data(using: .utf8)
                if let data = data, let contract = try?
                    JSONDecoder().decode(Individual.self, from: data) {
                    
                    if contract.result == "true" {
                        //다음씬
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualWriteViewController")
                    } else {
                        UIManager.instance.ShowAlert(title: "", message: "다시 시도 해주세요", viewController: self)
                    }
                }
            })
            
        } else {
            UIManager.instance.ShowAlert(title: "", message: "결제수단은 반드시 하나이상을 선택해야합니다", viewController: self)
        }
    }
    
}
