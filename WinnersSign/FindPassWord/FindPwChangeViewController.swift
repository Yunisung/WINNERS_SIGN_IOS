//
//  FindPwChangeViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

class FindPwChangeViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var userId: String?
    var userPhone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pwTextField.delegate = self
        pwCheckTextField.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == pwTextField) {
            pwCheckTextField.becomeFirstResponder()
        } else if (textField == pwCheckTextField) {
            ChangePw()
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
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/76c85f78d7ad4782911e03fd02b6a272") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func ChangePw() {
        if Auth.checkPw(pw: pwTextField.text!, repw: pwCheckTextField.text!, vc: self) {
            
            //서버전송 씬 이동
            HttpsManager.instance.updatePw(view: self, id: userId!, newPw: pwTextField.text!, phone: userPhone!, completionHandler: {
                (success, data) in
                let result = data as! String
                if result == "Y" {
                    UIManager.instance.ShowAlert(title: "", message: "이전 비밀번호와 같습니다. 새로운 비밀번호를 입력해주세요", viewController: self)
                } else if result == "true" {
                    UIManager.instance.ShowAlert(title: "", message: "비민번호 변경이 완료되었습니다", viewController: self, completionHandler: {
                        (result) in
                        
                        if DataManager.instance.isMyinfoPw == true {
                            //회원정보에서 왔으면 회원정보로 이동
                            DataManager.instance.isMyinfoPw = false
                            
                            
                            self.navigationController?.popToRootViewController(animated: true)
                            
                            
                        } else {
                            //비밀번호완료 페이지로 이동 -> 로그인 화면으로 이동
                            ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "LoginViewController")
                            
                        }
                        
                    })
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "비밀번호 변경에 실패 하셨습니다", viewController: self)
                }
            })
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        ChangePw()
    }
    
}
