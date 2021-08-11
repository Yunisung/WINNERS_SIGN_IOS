//
//  UpdateUserInfoViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

class UpdateUserInfoViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var idTextView: UITextView!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdCheckTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pwdTextField.delegate = self
        pwdCheckTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        HttpsManager.instance.selectMyInfo(view: self, id: DataManager.instance.sessionMember.mb_id, completionHandler: {(success, data) in
            let result = data as! String
            if !result.isEmpty {
                let data = result.data(using: .utf8)
                if let data = data, let info = try?
                    JSONDecoder().decode(MyInfo.self, from: data) {
                    
                    print(info)
                    DataManager.instance.myinfo = info
                    
                    self.nameTextView.text = DataManager.instance.myinfo.mb_name
                    self.idTextView.text = DataManager.instance.myinfo.mb_id
                    self.emailTextField.text = DataManager.instance.myinfo.mb_email
                    self.phoneTextField.text = DataManager.instance.myinfo.mb_phone
                }
            }
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if( string == " ") {
            return false
        }
        return true
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/69cb27d106164025bbbf73e8551b836e") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func EndEditing() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        if Auth.checkPw(pw: pwdTextField.text!, repw: pwdCheckTextField.text!, vc: self) &&
            Auth.checkPhoneNum(number: phoneTextField.text!, vc: self) {
            
            let mdate = DateFormatter()
            mdate.dateFormat = "yyyyMMdd"
            let str_mdate = mdate.string(from: Date())
            
            let mtime = DateFormatter()
            mtime.dateFormat = "HHmmss"
            let str_mtime = mtime.string(from: Date())
            
            let myinfo = DataManager.instance.myinfo
            
            let updateInfo = UpdateUserInfo(mb_idnum: myinfo.mb_idnum, mb_id: myinfo.mb_id, mb_name: myinfo.mb_name, mb_phone: phoneTextField.text!, mb_email: emailTextField.text!, mb_pw: pwdTextField.text!, mb_mdate: str_mdate, mb_mtime: str_mtime)
            
            HttpsManager.instance.updateInfo(view: self, info: updateInfo, completionHandler: {(success, data) in
                let result = data as! String
                if result == "Y" {
                    UIManager.instance.ShowAlert(title: "", message: "이전 비밀번호와 같습니다. 새로운 비밀번호로 입력해주세요", viewController: self)
                } else if result == "true" {
                    print("회원정보수정완료")
                    //ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "UpdateUserInfoFinishViewController")
                    
                    UIManager.instance.ShowAlert(title: "정보수정 완료", message: String("회원정보 수정이 완료되었습니다"), viewController: self, button1Name: "나의 정보", button2Name: "메인으로", button1Handler: {
                         (checker) in
                         
                        //나의정보
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "MyinfoPwViewController")
                         
                     }, button2Handler: {
                         (checker) in
                         
                        //메인
                        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "LoginMenuViewController")

                         
                     })
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "정보수정에 실패했습니다. 다시시도 해주세요", viewController: self)
                }
            })
        }
    }
    
    
}
