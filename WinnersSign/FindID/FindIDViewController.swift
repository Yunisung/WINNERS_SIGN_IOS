//
//  FindIDViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/06.
//

import UIKit

class FindIDViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    var isPhoneCheck = false
    var phoneAuthCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
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
            phoneTextField.becomeFirstResponder()
        } else if(textField == phoneTextField) {
            SendAuthCode()
            authCodeTextField.becomeFirstResponder()
        } else if(textField == authCodeTextField) {
            FindID()
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
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/a87d75c0dae245d7a5eb1b8e1430dfb8") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func didTapSendAuthCode(_ sender: UIButton) {
        SendAuthCode()
    }
    
    func FindID() {
        if isPhoneCheck == false {
            UIManager.instance.ShowAlert(title: "", message: "휴대폰 인증을 해주세요", viewController: self)
            return
        }
        
        if Auth.checkPhoneCode(code: self.phoneAuthCode, phoneAuthCode: self.authCodeTextField.text!) == false {
            UIManager.instance.ShowAlert(title: "", message: "인증번호가 일치하지 않습니다", viewController: self)
            return
        }
        
        if Auth.checkName(name: nameTextField.text!, vc: self) && Auth.checkPhoneNum(number: phoneTextField.text!, vc: self) {
            
            //이동
            HttpsManager.instance.selectFindId(view: self, number: nameTextField.text!, phone: phoneTextField.text!, completionHandler: {
                (success, data) in
                let result = data as! String
                if result == "null" {
                    UIManager.instance.ShowAlert(title: "", message: "존재하지 않는 회원입니다.", viewController: self)
                    return
                } else {
                    print(result)
                    //이동
                    UIManager.instance.ShowAlert(title: "아이디 찾기 완료", message: String("고객님의 아이디는 \(result)입니다"), viewController: self, button1Name: "로그인", button2Name: "비밀번호 찾기", button1Handler: {
                         (checker) in
                         
                        self.navigationController?.popToRootViewController(animated: true)
                         
                     }, button2Handler: {
                         (checker) in
                         
                        //비밀번호찾기
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FindPwViewController") as? FindPwViewController
                        
                        viewController?.userId = result
                        
                        self.navigationController?.pushViewController(viewController!, animated: true)
                         
                     })
                
                }
            })
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        FindID()
    }
    
}
