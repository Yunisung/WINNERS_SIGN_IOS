//
//  ContractBusinessServiceViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/15.
//

import UIKit

class ContractBusinessServiceViewController : UIViewController {
    

    @IBOutlet weak var charageLabel: UILabel!
    @IBOutlet weak var calculateLabel: UILabel!
    
    @IBOutlet weak var service1Button: UIButton!
    @IBOutlet weak var service2Button: UIButton!
    @IBOutlet weak var service3Button: UIButton!
    @IBOutlet weak var service4Button: UIButton!
    @IBOutlet weak var service5Button: UIButton!
    
    
    @IBOutlet weak var terminal1Button: UIButton!
    @IBOutlet weak var terminal2Button: UIButton!
    @IBOutlet weak var terminal3Button: UIButton!
    @IBOutlet weak var terminal4Button: UIButton!
    @IBOutlet weak var terminal5Button: UIButton!
    
    @IBOutlet weak var cost1Button: UIButton!
    @IBOutlet weak var cost2Button: UIButton!
    @IBOutlet weak var costView: UIStackView!
    
    
    var isTerminal1 = false
    var isTerminal2 = false
    var isTerminal3 = false
    
    var isCost1 = false
    var isCost2 = false
 
    var selectServiceNum = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        costView.isHidden = true;
        LoadBusinessContract()
        
        
        self.charageLabel.text = "3.5%(부과세별도)"
    }
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/ebaedf3ae73546c1abaa39040110b1f3") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func LoadBusinessContract() {
        HttpsManager.instance.selectMyLicensee(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: { [self]
            (success, data) in
            let response = data as! String
            let responseData = response.data(using: .utf8)
            if let data = responseData, let contract = try?
                JSONDecoder().decode(Business.self, from: data) {
                
                
                
                if contract.result == "true" {
                    DataManager.instance.business.li_seq = contract.li_seq
                    
                    // 서비스 관련 로드
                    //self.SelectService(service: contract.li_sv_divide)
                    if contract.li_sv_divide == "1" {
                        self.service5Button.isSelected = true
                        self.selectServiceNum = contract.li_sv_divide
                    }
                    
                    
                    self.charageLabel.text = "3.5%(부과세별도)"
                    self.calculateLabel.text = contract.li_sv_calculate
                    
                    //체크박스 로드
                    //수기결제
                    if contract.li_terminal_1 == "Y" {
                        //self.terminal1Button.isSelected = true
                        self.isTerminal1 = true
                        self.terminal5Button.isSelected = true
                    }
                    
                    if contract.li_terminal_2 == "Y" {
                        //self.terminal2Button.isSelected = true
                        //self.isTerminal2 = true
                    }
                    
                    //무선단밀기
                    if contract.li_terminal_3 == "Y" {
                        //self.terminal3Button.isSelected = true
                        self.isTerminal3 = true
                        self.terminal4Button.isSelected = true
                        
                        
                        self.costView.isHidden = false
                        if (contract.li_sv_cost == "lumpsum") {
                            self.cost1Button.isSelected = true
                            self.cost2Button.isSelected = false
                            isCost1 = true
                            isCost2 = false
                        } else if (contract.li_sv_cost == "monthly") {
                            self.cost2Button.isSelected = true
                            self.cost1Button.isSelected = false
                            isCost2 = true
                            isCost1 = false
                        }
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "계약서 정보가 없습니다", viewController: self)
                }
            }
        })
    }

    
    @IBAction func didTapService1(_ sender: UIButton) {
        SelectService(service: "1")
    }
    
    @IBAction func didTapService2(_ sender: UIButton) {
        //SelectService(service: "2")
    }
    
    @IBAction func didTapService3(_ sender: UIButton) {
        //SelectService(service: "3")
    }
    
    @IBAction func didTapService4(_ sender: UIButton) {
        //SelectService(service: "4")
    }
    
    //210714신용카드 하나일때
    @IBAction func didTapService5(_ sender: UIButton) {
        service5Button.isSelected = true
        selectServiceNum = "1";
    }
    
    
    func SelectService(service: String) {
        service1Button.isSelected = false
        service2Button.isSelected = false
        service3Button.isSelected = false
        service4Button.isSelected = false
        
        if service == "1" {
            service1Button.isSelected = true
            selectServiceNum = service
        }
        if service == "2" {
            //service2Button.isSelected = true
        }
        if service == "3" {
            //service3Button.isSelected = true
        }
        if service == "4" {
            //service4Button.isSelected = true
        }
        
        
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
        if(sender.isSelected) {
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
    
    
    @IBAction func didTapCost1(_ sender: UIButton) {
        sender.isSelected.toggle()
        isCost1 = sender.isSelected
        
        if(isCost2 == true) {
            isCost2 = false
            cost2Button.isSelected = false
        }
    }
    
    
    @IBAction func didTapCost2(_ sender: UIButton) {
        sender.isSelected.toggle()
        isCost2 = sender.isSelected
        
        if (isCost1 == true) {
            isCost1 = false
            cost1Button.isSelected = false
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if selectServiceNum == "0" {
            UIManager.instance.ShowAlert(title: "", message: "서비스 구분을 선택해주세요", viewController: self)
            
            return
        }
        
        if isTerminal3 {
            if(cost1Button.isSelected == false &&
                cost2Button.isSelected == false) {
                UIManager.instance.ShowAlert(title: "", message: "청구비용을 선택해주세요", viewController: self)
                return
            }
            
        }
        
        if isTerminal1 || isTerminal2 || isTerminal3 {
            var dic = [String: String]()
            
            if isTerminal1 { dic.updateValue("Y", forKey: "li_terminal_1")}
            else { dic.updateValue("N", forKey: "li_terminal_1")}
            
//            if isTerminal2 { dic.updateValue("Y", forKey: "li_terminal_2")}
//            else { dic.updateValue("N", forKey: "li_terminal_2")}
            
            if isTerminal3 {
                dic.updateValue("Y", forKey: "li_terminal_3")
                
                if(cost1Button.isSelected) {
                    dic.updateValue("lumpsum", forKey: "li_sv_cost")
                } else if (cost2Button.isSelected) {
                    dic.updateValue("monthly", forKey: "li_sv_cost")
                }
            }
            else { dic.updateValue("N", forKey: "li_terminal_3")}
            
            dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "li_idnum")
            dic.updateValue(DataManager.instance.business.li_seq, forKey: "li_seq")
            
            dic.updateValue(selectServiceNum, forKey: "li_sv_divide")
            
            dic.updateValue(DataManager.instance.sessionMember.mb_id, forKey: "li_admin")
            
            //수수료 변경
            dic.updateValue("3.5%", forKey: "li_sv_charge")
            
            //서버로 전송
            HttpsManager.instance.updateLicensee(view: self, data: dic, completionHandler: {
                (success, responseString) in
                let response = responseString as! String
                let data = response.data(using: .utf8)
                if let data = data, let contract = try?
                    JSONDecoder().decode(Business.self, from: data) {
                    
                    if contract.result == "true" {
                        //다음씬
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractBusinessWriteViewController")
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
