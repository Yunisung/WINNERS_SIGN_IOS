//
//  ContractIndividualWriteViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/23.
//

import UIKit

class ContractIndividualWriteViewController : UIViewController, UITextFieldDelegate, AddressProtocol {
    
    func AddressData(address1: String, address2: String, address_Building: String) {
        zipCodeTextField.text = String.init(address1.utf8)
        addr1TextField.text = String.init(address2.utf8) + String.init(address_Building.utf8)
        addr2TextField.becomeFirstResponder()
    }
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var rrnTextField: UITextField!
    
    @IBOutlet weak var cinditionTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var addr1TextField: UITextField!
    @IBOutlet weak var addr2TextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyTextField.delegate = self
        phoneTextField.delegate = self
        rrnTextField.delegate = self
        itemTextField.delegate = self
        zipCodeTextField.delegate = self
        addr1TextField.delegate = self
        addr2TextField.delegate = self
        telTextField.delegate = self
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        LoadIndividualContract()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == companyTextField) {
            phoneTextField.becomeFirstResponder()
        } else if (textField == phoneTextField) {
            rrnTextField.becomeFirstResponder()
        } else if (textField == rrnTextField) {
            itemTextField.becomeFirstResponder()
        } else if (textField == itemTextField) {
            SearchZipCode()
        } else if (textField == addr2TextField) {
            telTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if( string == " ") {
            return false
        }
        return true
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/fe96466eb20b4d75be1a163b66b86678") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func EndEditing() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
//        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let scrollY = scrollview.contentOffset.y
//
//            if scrollY != 0 {
//                self.view.frame.origin.y = -keyboardRectangle.height
//            }
//
//        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        //self.view.frame.origin.y = 0
    }
    
    func LoadIndividualContract() {
        HttpsManager.instance.selectMyIndividual(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: {
            (sucess, data) in
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Individual.self, from: data) {
                
                if contract.result == "true" {
                    
                    self.nameLabel.text = contract.in_name
                    self.companyTextField.text = contract.in_company
                    self.idLabel.text = contract.in_admin
                    self.itemTextField.text = contract.in_item
                    self.phoneTextField.text = contract.in_phone
                    self.rrnTextField.text = contract.in_rrn
                    self.zipCodeTextField.text = contract.in_zipcode
                    self.addr1TextField.text = contract.in_addr1
                    self.addr2TextField.text = contract.in_addr2
                    self.telTextField.text = contract.in_tel
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "다시 시도해주세요", viewController: self)
                }
            }
        })
    }
    
    @IBAction func didTapZipCode(_ sender: UIButton) {
        SearchZipCode()
    }
    
    func SearchZipCode() {
        let addressView = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController
        addressView?.delegate = self
        
        self.navigationController?.pushViewController(addressView!, animated: true)
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if Auth.EmptyChecker(data: nameLabel.text!, errorMessage: "성명을 입력해주세요", vc: self) &&
            Auth.EmptyChecker(data: companyTextField.text!, errorMessage: "상호명을 입력해주세요", vc: self) &&
            Auth.checkTel(tel: phoneTextField.text!, vc: self) &&
            Auth.checkRRN(data: rrnTextField.text!, vc: self) &&
            Auth.EmptyChecker(data: zipCodeTextField.text!, errorMessage: "우편번호를 검색해주세요", vc: self) &&
            Auth.EmptyChecker(data: addr1TextField.text!, errorMessage: "기본주소를 검색해주세요", vc: self) &&
            Auth.EmptyChecker(data: addr2TextField.text!, errorMessage: "상세주소를 검색해주세요", vc: self) &&
            Auth.EmptyChecker(data: telTextField.text!, errorMessage: "사업장 연락처를 입력해주세요", vc: self) {
            
            //전송할 데이터 세팅
            var dic = [String: String]()
            dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "in_idnum")
            dic.updateValue(DataManager.instance.individual.in_seq, forKey: "in_seq")
            dic.updateValue(nameLabel.text!, forKey: "in_name")
            dic.updateValue(companyTextField.text!, forKey: "in_company")
            dic.updateValue(idLabel.text!, forKey: "in_admin")
            dic.updateValue(phoneTextField.text!, forKey: "in_phone")
            dic.updateValue(rrnTextField.text!, forKey: "in_rrn")
            dic.updateValue(itemTextField.text!, forKey: "in_item")
            dic.updateValue(zipCodeTextField.text!, forKey: "in_zipcode")
            dic.updateValue(addr1TextField.text!, forKey: "in_addr1")
            dic.updateValue(addr2TextField.text!, forKey: "in_addr2")
            dic.updateValue(telTextField.text!, forKey: "in_tel")
            
            HttpsManager.instance.updateIndividual(view: self, data: dic, completionHandler: {
                (success, responseString) in
                let response = responseString as! String
                let data = response.data(using: .utf8)
                if let data = data, let contract = try?
                    JSONDecoder().decode(Individual.self, from: data) {
                    
                    if contract.result == "true" {
                        //다음씬
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualAddFileViewController")
                    } else {
                        UIManager.instance.ShowAlert(title: "", message: "다시 시도 해주세요", viewController: self)
                    }
                }
            })
        }
            
            
        
    }
    
}
