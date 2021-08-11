//
//  ContractBusinessWriteViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/17.
//

import UIKit

class ContractBusinessWriteViewController : UIViewController, UITextFieldDelegate, AddressProtocol {
  
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var bsNumTextField: UITextField!
    @IBOutlet weak var individualButton: UIButton!
    @IBOutlet weak var businessButton: UIButton!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var cinditionTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var addr1TextField: UITextField!
    @IBOutlet weak var addr2TextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var li_bs_divide = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetTextFieldDelegate()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        LoadBusinessContract()
    }
    
    func SetTextFieldDelegate() {
        companyTextField.delegate = self
        bsNumTextField.delegate = self
        telTextField.delegate = self
        cinditionTextField.delegate = self
        eventTextField.delegate = self
        zipCodeTextField.delegate = self
        addr1TextField.delegate = self
        addr2TextField.delegate = self
        nameTextField.delegate = self
        birthTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == companyTextField) {
            bsNumTextField.becomeFirstResponder()
        } else if (textField == bsNumTextField) {
            telTextField.becomeFirstResponder()
        } else if (textField == telTextField) {
            cinditionTextField.becomeFirstResponder()
        } else if (textField == cinditionTextField) {
            eventTextField.becomeFirstResponder()
        } else if (textField == eventTextField) {
            SearchZipCode()
        } else if (textField == addr2TextField) {
            nameTextField.becomeFirstResponder()
        } else if (textField == nameTextField) {
            birthTextField.becomeFirstResponder()
        } else if (textField == birthTextField) {
            phoneTextField.becomeFirstResponder()
        } else if (textField == phoneTextField) {
            emailTextField.becomeFirstResponder()
        } else if (textField == emailTextField) {
            NextStep()
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
        if let url = URL(string: "https://www.notion.so/d46d3f86ee0d49e5afc37a65f72603a4") {
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
    
    func LoadBusinessContract() {
        HttpsManager.instance.selectMyLicensee(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: {
            (success, data) in
            let response = data as! String
            let responseData = response.data(using: .utf8)
            if let data = responseData, let contract = try?
                JSONDecoder().decode(Business.self, from: data) {
                
                if contract.result == "true" {
                    
                    DataManager.instance.business.li_seq = contract.li_seq
                    
                    self.nameLabel.text = DataManager.instance.sessionMember.mb_name
                    self.idLabel.text = contract.li_admin
                    
                    self.companyTextField.text = contract.li_company
                    self.bsNumTextField.text = contract.li_bs_num
                    self.telTextField.text = contract.li_tel
                    self.cinditionTextField.text = contract.li_cindition
                    self.eventTextField.text = contract.li_event
                    self.zipCodeTextField.text = contract.li_zipcode
                    self.addr1TextField.text = contract.li_addr1
                    self.addr2TextField.text = contract.li_addr2
                    self.nameTextField.text = contract.li_re_name
                    self.birthTextField.text = contract.li_re_birth
                    self.phoneTextField.text = contract.li_re_phone
                    self.emailTextField.text = contract.li_re_email
                    
                    if contract.li_bs_divide == "1" {
                        self.individualButton.isSelected = true
                        self.businessButton.isSelected = false
                        self.li_bs_divide = "1"
                    } else if contract.li_bs_divide == "2" {
                        self.individualButton.isSelected = false
                        self.individualButton.isSelected = true
                        self.li_bs_divide = "2"
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "계약서 정보가 없습니다", viewController: self)
                }
            }
        })
    }
    
    
    
    @IBAction func didTapIndividual(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected == true {
            self.li_bs_divide = "1"
            businessButton.isSelected = false
        }
    }
    
    @IBAction func didTapBusiness(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected == true {
            self.li_bs_divide = "2"
            individualButton.isSelected = false
        }
    }
    
    //우편번호 찾기
    @IBAction func didTapZipCode(_ sender: UIButton) {
        SearchZipCode()
    }
    
    func SearchZipCode() {
        let addressView = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController
        addressView?.delegate = self
        
        self.navigationController?.pushViewController(addressView!, animated: true)
    }
    
    //주소 받아서 파싱
    func AddressData(address1: String, address2: String, address_Building: String) {
        
        zipCodeTextField.text = String.init(address1.utf8)
        addr1TextField.text = String.init(address2.utf8) + String.init(address_Building.utf8)
        addr2TextField.becomeFirstResponder()
    }
    
    func NextStep() {
        if !Auth.checkCompany(company: companyTextField.text!, vc: self) {
            companyTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.checkBusinessNum(number: bsNumTextField.text!, vc: self) {
            bsNumTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.checkTel(tel: telTextField.text!, vc: self) {
            telTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.checkCindition(text: cinditionTextField.text!, vc: self) {
            cinditionTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.checkEvent(text: eventTextField.text!, vc: self) {
            eventTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.EmptyChecker(data: zipCodeTextField.text!, errorMessage: "우편번호를 검색해주세요", vc: self) {
            zipCodeTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.EmptyChecker(data: addr1TextField.text!, errorMessage: "기본주소를 입력해주세요", vc: self) {
            addr1TextField.becomeFirstResponder()
            return
        }
        
        if !Auth.EmptyChecker(data: addr2TextField.text!, errorMessage: "상세주소를 입력해주세요", vc: self) {
            addr2TextField.becomeFirstResponder()
            return
        }
        
        if !Auth.EmptyChecker(data: nameTextField.text!, errorMessage: "대표자 성명을 입력해주세요", vc: self) {
            nameTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.checkBirth(data: birthTextField.text!, vc: self) {
            birthTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.checkPhone(data: phoneTextField.text!, vc: self) {
            phoneTextField.becomeFirstResponder()
            return
        }
        
        if !Auth.checkEmail(email: emailTextField.text!, vc: self) {
            emailTextField.becomeFirstResponder()
            return
        }
        
        
        if li_bs_divide == "0" {
            UIManager.instance.ShowAlert(title: "", message: "사업자 구분을 선택해주세요", viewController: self)
        } else {
            var dic = [String: String]()
            dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "li_idnum")
            dic.updateValue(DataManager.instance.business.li_seq, forKey: "li_seq")
            dic.updateValue(companyTextField.text!, forKey: "li_company")
            dic.updateValue(idLabel.text!, forKey: "li_admin")
            dic.updateValue(bsNumTextField.text!, forKey: "li_bs_num")
            dic.updateValue(telTextField.text!, forKey: "li_tel")
            dic.updateValue(cinditionTextField.text!, forKey: "li_cindition")
            dic.updateValue(eventTextField.text!, forKey: "li_event")
            dic.updateValue(zipCodeTextField.text!, forKey: "li_zipcode")
            dic.updateValue(addr1TextField.text!, forKey: "li_addr1")
            dic.updateValue(addr2TextField.text!, forKey: "li_addr2")
            dic.updateValue(nameTextField.text!, forKey: "li_re_name")
            dic.updateValue(birthTextField.text!, forKey: "li_re_birth")
            dic.updateValue(phoneTextField.text!, forKey: "li_re_phone")
            dic.updateValue(emailTextField.text!, forKey: "li_re_email")
            dic.updateValue(li_bs_divide, forKey: "li_bs_divide")
            
            //서버로 전송
            HttpsManager.instance.updateLicensee(view: self, data: dic, completionHandler: {
                (success, responseString) in
                let response = responseString as! String
                let data = response.data(using: .utf8)
                if let data = data, let contract = try?
                    JSONDecoder().decode(Business.self, from: data) {
                    
                    if contract.result == "true" {
                        //다음씬
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractBusinessAddFileViewController")
                    } else {
                        UIManager.instance.ShowAlert(title: "", message: "다시 시도 해주세요", viewController: self)
                    }
                }
            })
        }
    }
    
    //다음
    @IBAction func didTapNext(_ sender: UIButton) {
        NextStep()
    }
    
}
