//
//  FindPwViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/06.
//

import UIKit

class FindPwViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var phoneAuthCode = ""
    var isPhoneCheck = false
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.text = userId
        
        nameTextField.delegate = self
        idTextField.delegate = self
        phoneTextField.delegate = self
        authCodeTextField.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nameTextField) {
            idTextField.becomeFirstResponder()
        } else if(textField == idTextField) {
            phoneTextField.becomeFirstResponder()
        } else if(textField == phoneTextField) {
            SendAuthCode()
            authCodeTextField.becomeFirstResponder()
        } else if(textField == authCodeTextField) {
            Next()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if( string == " ") {
            return false
        }
        return true
    }
    
    @objc func EndEditing() {
        self.view.endEditing(true)
    }
    
    func SendAuthCode() {
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
    
    func Next() {
        if isPhoneCheck == false {
            UIManager.instance.ShowAlert(title: "", message: "휴대폰 인증을 해주세요", viewController: self)
            return
        }
        
        if Auth.checkPhoneCode(code: self.phoneAuthCode, phoneAuthCode: self.authCodeTextField.text!) == false {
            UIManager.instance.ShowAlert(title: "", message: "인증번호가 일치하지 않습니다", viewController: self)
            return
        }
        
        if Auth.checkName(name: nameTextField.text!, vc: self) &&
            Auth.checkID(id: idTextField.text!, vc: self) &&
            Auth.checkPhoneNum(number: phoneTextField.text!, vc: self) {
            
            //이동
            HttpsManager.instance.selectFindPw(view: self, name: nameTextField.text!, id: idTextField.text!, phone: phoneTextField.text!, completionHandler: {
                (success, data) in
                let result = data as! String
                if result.elementsEqual("null") {
                    UIManager.instance.ShowAlert(title: "", message: "존재하지 않는 회원입니다.", viewController: self)
                    
                    return
                } else {
                    print(result)
                    //이동
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FindPwChangeViewController") as? FindPwChangeViewController

                    viewController?.userId = self.idTextField.text!
                    viewController?.userPhone = self.phoneTextField.text!

                    self.navigationController?.pushViewController(viewController!, animated: true)
                    
                }
            })
        }
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/7dc1abb48bb7482bae99f01ea787a0bb") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapSendAuthCode(_ sender: UIButton) {
        SendAuthCode()
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        Next()
    }
    
}
