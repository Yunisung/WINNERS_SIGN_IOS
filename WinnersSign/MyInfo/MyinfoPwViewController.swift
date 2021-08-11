//
//  MyinfoPwViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

class MyinfoPwViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.instance.isMyinfoPw = false
        idTextField.text = DataManager.instance.sessionMember.mb_id
        
        idTextField.delegate = self
        pwTextField.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == idTextField) {
            pwTextField.becomeFirstResponder()
        } else if (textField == pwTextField) {
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
        if let url = URL(string: "https://www.notion.so/ed173f9a2d6a4ca8b22ebadc13a023aa") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func EndEditing() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapFindPw(_ sender: UIButton) {
        DataManager.instance.isMyinfoPw = true
        
        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "FindPwViewController")
    }
    
    func NextStep() {
        if Auth.checkID(id: idTextField.text!, vc: self) &&
            Auth.checkPw(pw: pwTextField.text!, repw: pwTextField.text!, vc: self) {
            //http: 아이디 비번 체크
            HttpsManager.instance.selectPw(view: self, id: idTextField.text!, pw: pwTextField.text!, completionHandler: { (success, data) in
                let result = data as! String
                if result == "true" {
                    //이동
                    ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "UpdateUserInfoViewController")
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "패스워드가 일치하지 않습니다. 다시 시도해 주세요", viewController: self)
                }
            })
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        NextStep()
    }
    
    
}
