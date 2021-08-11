//
//  LoginMenuViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

class LoginMenuViewController : UIViewController {
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var nameLebel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [self]
        
        nameLebel.text = "\(DataManager.instance.sessionMember.mb_name)님"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func didTapWriteLicense(_ sender: UIButton) {
        HttpsManager.instance.countYLicensee(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: { (success, data) in
            let response = data as! String
            let responseData = response.data(using: .utf8)
            if let data = responseData, let contract = try? JSONDecoder().decode(ContractResult.self, from: data) {
                
                if contract.result == "Y" {
                    UIManager.instance.ShowAlert(title: "계약서 작성", message: "이미 작성한 계약서가 있습니다. 관리자에게 문의해주세요.", viewController: self)
                } else if contract.result == "N" {
                    print("사업자 계약서 작성하기")
                    
                    //데이터 세팅
                    DataManager.instance.business.db_div = "I"

                    //씬이동
                    ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractBusinessAgreeViewController")
                } else if contract.result == "write" {
                    print("작성중인 계약서가 있다")
                    
                    //데이터 세팅
                    DataManager.instance.business.seq = contract.li_seq
                    
                    //알림메세지
                    UIManager.instance.ShowAlert(title: "계약서 작성", message: "작성중인 계약서가 있습니다. 이어서 작성하시겠습니까?", viewController: self, button1Name: "이어서 작성", button2Name: "새로 작성", button1Handler: {
                        (result) in
                        
                        //이어서 작성시 데이터 세팅
                        DataManager.instance.business.db_div = "U"
                        
                        //씬이동
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractBusinessAgreeViewController")
                        
                    }, button2Handler: {
                        (result) in
                        
                        //새로 작성시 데이터 세팅
                        DataManager.instance.business.db_div = "I"
                        
                        //씬이동
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractBusinessAgreeViewController")
                    })
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "다시 시도해주세요", viewController: self)
                }
            }
        })
    }
    
    @IBAction func didTapWriteIndividual(_ sender: UIButton) {
        HttpsManager.instance.countYIndividual(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: { (success, data) in
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try? JSONDecoder().decode(ContractResult.self, from: data) {
                
                if contract.result == "Y" {
                    UIManager.instance.ShowAlert(title: "계약서 작성", message: "이미 작성한 계약서가 있습니다. 관리자에게 문의해주세요.", viewController: self)
                } else if contract.result == "N" {
                    print("개인 계약서 작성하기")
                    
                    //데이터 세팅
                    DataManager.instance.individual.db_div = "I"
                    
                    //씬이동
                    ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualAgreeViewController")
                    
                } else if contract.result == "write" {
                    print("작성중인 계약서가 있다")
                    
                    //데이터 세팅
                    DataManager.instance.individual.seq = contract.in_seq
                    
                    //알림메세지
                    UIManager.instance.ShowAlert(title: "계약서 작성", message: "작성중인 계약서가 있습니다. 이어서 작성하시겠습니까?", viewController: self, button1Name: "이어서 작성", button2Name: "새로 작성", button1Handler: {
                        (result) in
                        
                        //이어서 작성시 데이터 세팅
                        DataManager.instance.individual.db_div = "U"
                        
                        //씬이동
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualAgreeViewController")
                        
                    }, button2Handler: {
                        (result) in
                        
                        //새로 작성시 데이터 세팅
                        DataManager.instance.individual.db_div = "I"
                        
                        //씬이동
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualAgreeViewController")
                        
                    })
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "다시 시도해주세요", viewController: self)
                }
            }
        })
    }
    
    @IBAction func didTapViewLicense(_ sender: UIButton) {
        HttpsManager.instance.selectMyContract(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, contract: "li", completionHandler: {(success, data) in
            let result = data as! String
            if result == "true" {
                print("사업자 계약서 보여주기")
                ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "MyBusinessContractViewController")
            } else {
                UIManager.instance.ShowAlert(title: "나의 계약서", message: "등록된 사업자 계약서가 없습니다", viewController: self)
            }
            
        })
    }
    
    @IBAction func didTapViewIndividual(_ sender: UIButton) {
        HttpsManager.instance.selectMyContract(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, contract: "in", completionHandler: {(success, data) in
            let result = data as! String
            if result == "true" {
                print("개인 계약서 보여주기")
                ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "MyIndividualContractViewController")
            } else {
                UIManager.instance.ShowAlert(title: "나의 계약서", message: "등록된 개인 계약서가 없습니다", viewController: self)
            }
        })
    }
    
    @IBAction func didTapMarupay(_ sender: UIButton) {
        if let url = URL(string: "https://marupay.kr/login/Login") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        
        DataManager.instance.resetSessionMember()
        UserDefaults.standard.setValue("off", forKey: "autoLogin")
        
        //self.navigationController?.popToRootViewController(animated: true)
        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "LoginViewController")
    }
    
    @IBAction func didTapUpdateInfo(_ sender: UIButton) {
        
    }
}
