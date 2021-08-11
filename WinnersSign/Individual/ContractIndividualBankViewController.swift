//
//  ContractIndividualBankViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/23.
//

import UIKit

class ContractIndividualBankViewController : UIViewController, UITextFieldDelegate, SignProtocol {
    func SignData(fileName: String, data: Array<UInt8>) {
        let bytes: NSData = NSData(bytes: data, length: data.count)
        
        if fileName == "\(DataManager.instance.sessionMember.mb_id)_in_sign3.png" {
            signImageView.image = UIImage(data: bytes as Data)
            signImageView.isHidden = false
            signButton.isHidden = true
            isSignCheck = true
            
            underTextField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var bankNumTextField: UITextField!
    @IBOutlet weak var depositorTextField: UITextField!
 
    @IBOutlet weak var signTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var signImageView: UIImageView!
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var underTextField: UITextField!
    @IBOutlet weak var agentTextField: UITextField!
    
    var isSignCheck = false
    var isSignLoad = false
    
    let BankList: [String] = ["농협", "신한", "국민", "IBK기업", "카카오뱅크", "하나", "우리", "국민", "SC제일", "대구", "부산", "광주", "새마을", "경남", "전북", "제주", "산업", "우체국", "신협", "수협", "씨티", "케이뱅크", "도이치", "BOA", "BNP", "중국공상", "HSBC", "JP모간", "산림조합", "저축은행", "교보증권", "대신증권", "동부증권", "카카오페이증권", "메리츠", "미래에셋대우", "부국증권", "삼성증권", "신영증권", "유진투자", "유안타", "이베스트", "케이프투자", "키움증권", "한국포스증권", "NH투자", "하나금융", "하이투자", "한국투자", "현대차증권", "KB증권", "KTB투자", "SK증권"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        signImageView.isHidden = true
        SetToday()
        
        bankNumTextField.delegate = self
        depositorTextField.delegate = self
        signTextField.delegate = self
        underTextField.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        LoadIndividualContract()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if( string == " ") {
            return false
        }
        return true
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/afd0c58478854127b3ed5b65b1380b25") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == bankNumTextField) {
            depositorTextField.becomeFirstResponder()
        } else if(textField == depositorTextField) {
            signTextField.becomeFirstResponder()
        } else if(textField == underTextField) {
            NextStep()
        }
        
        return true
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
    
    func SetToday() {
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        self.todayLabel.text = date.string(from: Date())
    }
    
    func LoadIndividualContract() {
        HttpsManager.instance.selectMyIndividual(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: {
            (sucess, data) in
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Individual.self, from: data) {
                
                if contract.result == "true" {
                    DataManager.instance.individual.in_seq = contract.in_seq
                    
                    if contract.in_bank_name.isEmpty {
                        self.bankButton.setTitle("은행명 선택", for: .normal)
                    } else {
                        self.bankButton.setTitle(contract.in_bank_name, for: .normal)
                    }
                    
                    self.bankNumTextField.text = contract.in_bank_num
                    self.depositorTextField.text = contract.in_depositor
                    self.signTextField.text = contract.in_name
                    self.underTextField.text = contract.in_name
                    self.agentTextField.text = contract.in_agent
                    
                    if let signURL = URL(string: contract.path7) {
                        let signImage = try? Data(contentsOf: signURL)
                        self.signImageView.image = UIImage(data: signImage!)
                        self.signImageView.isHidden = false
                        self.signButton.isHidden = true
                        self.isSignCheck = true
                        self.isSignLoad = true
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "계약서 정보가 없습니다", viewController: self)
                }
            }
        })
    }
    
    @IBAction func didTapBank(_ sender: UIButton) {
        let alert = UIAlertController(title: "은행 선택", message: "은행을 선택해주세요", preferredStyle: UIAlertController.Style.actionSheet)
        
        for bank in BankList {
            let bankAction = UIAlertAction(title: bank, style: .default, handler: {
                (action) in
                self.bankButton.setTitle(bank, for: .normal)
            })
            
            alert.addAction(bankAction)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: {
            (action) in
            self.bankButton.setTitle("은행명 선택", for: .normal)
        })
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapSign(_ sender: UIButton) {
        let signView = self.storyboard?.instantiateViewController(withIdentifier: "SignDrowViewController") as? SignDrowViewController
        signView?.fileName = "\(DataManager.instance.sessionMember.mb_id)_in_sign3.png"
        signView?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        signView?.delegate = self
        
        self.present(signView!, animated: true, completion: {
        })
    }
    
    func NextStep() {
        if bankButton.titleLabel?.text == "은행명 선택" {
            UIManager.instance.ShowAlert(title: "", message: "은행을 선택해주세요", viewController: self)
            return
        }
        
        if signTextField.text != underTextField.text {
            UIManager.instance.ShowAlert(title: "", message: "서명과 신청인이 일치해야합니다", viewController: self)
            return
        }
        
        if isSignCheck == false {
            UIManager.instance.ShowAlert(title: "", message: "전자서명을 완료해주세요", viewController: self)
            return
        }
        
        if Auth.checkBankNum(data: bankNumTextField.text!, vc: self) &&
            Auth.EmptyChecker(data: depositorTextField.text!, errorMessage: "예금주를 입력해주세요", vc: self) &&
            Auth.EmptyChecker(data: signTextField.text!, errorMessage: "서명을 입력해주세요", vc: self) &&
            Auth.EmptyChecker(data: underTextField.text!, errorMessage: "신청인을 입력해주세요", vc: self) {
            // && Auth.EmptyChecker(data: agentTextField.text!, errorMessage: "담당자를 입력해주세요", vc: self)
            //조건검사끝
            RequestServer()
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        NextStep()
    }
    
    func RequestServer() {
        var dic = [String: String]()
        dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "in_idnum")
        dic.updateValue(DataManager.instance.individual.in_seq, forKey: "in_seq")
        dic.updateValue((bankButton.titleLabel?.text!)!, forKey: "in_bank_name")
        dic.updateValue(bankNumTextField.text!, forKey: "in_bank_num")
        dic.updateValue(depositorTextField.text!, forKey: "in_depositor")
        dic.updateValue(signTextField.text!, forKey: "in_name")
        //dic.updateValue(agentTextField.text!, forKey: "in_agent")
        
        //서버로 전송
        HttpsManager.instance.updateIndividual(view: self, data: dic, completionHandler: {
            (success, responseString) in
            let response = responseString as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Individual.self, from: data) {
                
                DataManager.instance.individual.in_seq = contract.in_seq
                
                if contract.result == "true" {
                    self.UploadImage()
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "다시 시도 해주세요", viewController: self)
                }
            }
        })
    }
    
    func UploadImage() {
        
        if isSignLoad {
            self.NextViewController()
            return
        }
        
        let fileName = "\(DataManager.instance.sessionMember.mb_id)_in_sign3.png"
        
        HttpsManager.instance.imgUpload(view: self, imagePath: fileName, fileGroup: "7", seq: DataManager.instance.individual.in_seq, completionHandler: {
            (success, data) in
            
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let result = try?
                JSONDecoder().decode(UploadImageResult.self, from: data) {
                if result.result == "success" {
                    self.NextViewController()
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "오류가 발생했습니다. 다시 시도해주세요", viewController: self)
                }
            }
        })
    }
    
    func NextViewController() {
        //다음씬
        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualFinishViewController")
    }
    
}
