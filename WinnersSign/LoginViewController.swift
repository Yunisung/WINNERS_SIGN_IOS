//
//  LoginViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/03/29.
//

import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    var isAutoLogin: Bool = false
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var autoLoginButton: UIButton!
    @IBOutlet weak var findIDButton: UIButton!
    @IBOutlet weak var findPwdButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [self]
        
        userNameTextField.delegate = self
        passWordTextField.delegate = self
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let autoLogin = UserDefaults.standard.string(forKey: "autoLogin") {
            if autoLogin == "on" {
                isAutoLogin = true
                autoLoginButton.isSelected = true
                userNameTextField.text = UserDefaults.standard.string(forKey: "id")
                passWordTextField.text = UserDefaults.standard.string(forKey: "pwd")
                Login()
            } else {
                isAutoLogin = false
                autoLoginButton.isSelected = false
                userNameTextField.text = "";
                passWordTextField.text = "";
            }
        }
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        loginButton.addTarget(self, action: #selector(onClickLogin(_:)), for: .touchUpInside)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if( string == " ") {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == userNameTextField) {
            passWordTextField.becomeFirstResponder()
        } else if(textField == passWordTextField) {
            Login()
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func EndEditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapAutoLogin(_ sender: UIButton) {
        sender.isSelected.toggle()
        isAutoLogin = sender.isSelected
        if self.isAutoLogin {
            print("on")
            UserDefaults.standard.setValue("on", forKey: "autoLogin")
        } else {
            print("off")
            UserDefaults.standard.setValue("off", forKey: "autoLogin")
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        
        if Auth.checkID(id: userNameTextField.text!, vc: self) &&
            Auth.checkPw(pw: passWordTextField.text!, repw: passWordTextField.text!, vc: self) {
            Login()
        }
    }
    
    @objc internal func onClickLogin(_ sender: Any) {
        if let button = sender as? UIButton {
            didTapLoginButton(button)
        }
    }
    
    @IBAction func didTapManual(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/PDF-0e3e5df643694f98bb80e3521d3073e0") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    
    @IBAction func FindID(_ sender: Any) {
        //-> FindIDViewController
    }
    
    @IBAction func FindPwd(_ sender: Any) {
        //-> FindPwdViewController
    }
    
    func Login() {
        HttpsManager.instance.goLogin(view: self, id: userNameTextField.text!, pw: passWordTextField.text!, completionHandler: { (success, data) in
            let result = data as! String
            
            if result == "null" {
                UIManager.instance.ShowAlert(title: "", message: "아이디와 패스워드가 일치 하지 않습니다", viewController: self)
                return
            } else {
                //json데이터로 변환
                let data = result.data(using: .utf8)
                if let data = data, let member = try? JSONDecoder().decode(SessionMb.self, from: data) {
                    
                    //데이터 파싱
                    let dataManager = DataManager.instance
                    dataManager.sessionMember = member
                    
                    //자동 로그인 체크
                    if self.isAutoLogin == true {
                        
                    }
                    //아이디 저장
                    UserDefaults.standard.setValue(self.userNameTextField.text!, forKey: "id")
                    //비밀번호 저장
                    UserDefaults.standard.setValue(self.passWordTextField.text!, forKey: "pwd")
                    
                    
                    //씬이동
                    ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "LoginMenuViewController")
                    
                }
            }
        })
    }
}

