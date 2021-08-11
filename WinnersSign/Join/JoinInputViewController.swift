//
//  JoinInputViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/03/30.
//

import UIKit

class JoinInputViewController : UIViewController, UITextFieldDelegate {
    
    var isMarketingAgree: Bool?
    var keyHeight: CGFloat?
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdCheckTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    
    var isIdChecker = false
    var isPhoneCheck = false
    var phoneAuthCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        isIdChecker = false
        isPhoneCheck = false
        
        nameTextField.delegate = self
        idTextField.delegate = self
        pwdTextField.delegate = self
        pwdCheckTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameTextField) {
            idTextField.becomeFirstResponder();
        } else if (textField == idTextField) {
            pwdTextField.becomeFirstResponder()
        } else if (textField == pwdTextField) {
            pwdCheckTextField.becomeFirstResponder()
        } else if (textField == pwdCheckTextField) {
            emailTextField.becomeFirstResponder()
        } else if (textField == emailTextField) {
            phoneTextField.becomeFirstResponder()
        } else if (textField == phoneTextField) {
            authCodeTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    @objc func EndEditing() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let scrollY = scrollview.contentOffset.y
//            print(scrollY)
//            print("keyboard : \(keyboardRectangle.height)")
//            if scrollY != 0 {
//                self.view.frame.origin.y = -keyboardRectangle.height
//            }

        }
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        //self.view.frame.origin.y = 0
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if( string == " ") {
            return false
        }
        return true
    }
    
    

    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/87287ac6c980443895e374bf19b26af3") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapCheckID(_ sender: UIButton) {
        if Auth.checkID(id: idTextField.text!, vc: self) == false {
            idTextField.text = ""
            return
        }
        
        let id = idTextField.text!
        HttpsManager.instance.IdCheck(view: self, id: id, completionHandler: { (success, data) in
            let result = data as! String
            if result == "true" {
                UIManager.instance.ShowAlert(title: "", message: "이미 등록되어있는 아이디 입니다", viewController: self)
                self.idTextField.text = ""
            } else {
                UIManager.instance.ShowAlert(title: "", message: "사용 가능한 아이디 입니다", viewController: self)
                self.isIdChecker = true
            }
        })
    }
    
    @IBAction func didTapSendAuthCode(_ sender: UIButton) {
        if Auth.checkPhoneNum(number: phoneTextField.text!, vc: self) == false {
            return
        }
        
        let number = phoneTextField.text!
        self.phoneAuthCode = Auth.createPhoneCode()
        print(self.phoneAuthCode)
        
        HttpsManager.instance.PhoneNumCheck(view: self, number: number, code: self.phoneAuthCode, completionHandler: { (success, data) in
            let result = data as! String
            if result == "1" {
                self.isPhoneCheck = true
                UIManager.instance.ShowAlert(title: "", message: "인증번호를 전송했습니다", viewController: self)
            } else if result == "4" {
                UIManager.instance.ShowAlert(title: "", message: "휴대폰번호를 확인해주세요", viewController: self)
            } else {
                UIManager.instance.ShowAlert(title: "", message: "다시 시도해 주세요", viewController: self)
            }
        })
        
    }
    
    @IBAction func didTapMemberJoin(_ sender: UIButton) {
        if isIdChecker == false {
            UIManager.instance.ShowAlert(title: "", message: "아이디 중복체크를 해주세요", viewController: self)
            return
        }
        
        if isPhoneCheck == false {
            UIManager.instance.ShowAlert(title: "", message: "휴대폰 인증을 해주세요", viewController: self)
            return
        }
        
        if Auth.checkPhoneCode(code: self.phoneAuthCode, phoneAuthCode: authCodeTextField.text!) == false {
            UIManager.instance.ShowAlert(title: "", message: "인증번호가 일치하지 않습니다", viewController: self)
            return
        }
        
        if Auth.checkName(name: nameTextField.text!, vc: self) &&
            Auth.checkID(id: idTextField.text!, vc: self) &&
            Auth.checkPw(pw: pwdTextField.text!, repw: pwdCheckTextField.text!, vc: self) &&
            Auth.checkEmail(email: emailTextField.text!, vc: self) &&
            Auth.checkPhoneNum(number: phoneTextField.text!, vc: self) {
            print("맴버생성 가능")
            insertJoin()
        }
    }
    
    func insertJoin() {
        let wdate = DateFormatter()
        wdate.dateFormat = "yyyyMMdd"
        let str_wdate = wdate.string(from: Date())
        
        let wtime = DateFormatter()
        wtime.dateFormat = "HHmmss"
        let str_wtime = wtime.string(from: Date())
        
        var ck3:String = ""
        
        if isMarketingAgree! {
            ck3 = "Y"
        } else {
            ck3 = "N"
        }

        let member = Member(mb_idnum: "", mb_id: idTextField.text!, mb_pw: pwdTextField.text!, mb_name: nameTextField.text!, mb_phone: phoneTextField.text!, mb_email: emailTextField.text!, mb_wdate: str_wdate, mb_wtime: str_wtime, mb_mdate: "", mb_mtime: "", mb_ck3: ck3)
        
        
        print(member)
        
        HttpsManager.instance.InsertJoin(view: self, member: member, completionHandler: { (success, data) in
            let result = data as! String
            if result == "true" {
                UIManager.instance.ShowAlert(title: "회원가입 완료", message: "Winners Sign 회원가입이 완료되었습니다", viewController: self, completionHandler: {
                    (result) in
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                })

                
            } else {
                UIManager.instance.ShowAlert(title: "", message: "회원가입에 실패했습니다", viewController: self)
            }
        })
        
        
    }
        
}
