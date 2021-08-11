//
//  ContractIndividualAgreeViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/12.
//

import UIKit
import WebKit

class ContractIndividualAgreeViewController : UIViewController, UITextFieldDelegate, WKUIDelegate, SignProtocol {
    
    func SignData(fileName: String, data: Array<UInt8>) {
        let bytes: NSData = NSData(bytes: data, length: data.count)
        
        if fileName == "\(DataManager.instance.sessionMember.mb_id)_in_sign1.png" {
            upperSignImage.image = UIImage(data: bytes as Data)
            //upperSignImage.isHidden = false
            upperButton.isHidden = false
            upperButton.setImage(UIImage(data: bytes as Data), for: .normal)
            
            HttpsManager.instance.imgUpload(view: self, imagePath: fileName, fileGroup: "1", seq: DataManager.instance.individual.in_seq, completionHandler: { (success, data) in
                
                let response = data as! String
                let data = response.data(using: .utf8)
                if let data = data, let result = try? JSONDecoder().decode(UploadImageResult.self, from: data) {
                    if result.result == "success" {
                        
                
                        
                    } else {
                        //첫번째 서명 저장실패
                        UIManager.instance.ShowAlert(title: "", message: "서명 저장을 실패했습니다", viewController: self)
                    }
                }
                
            })
        }
        
        if fileName == "\(DataManager.instance.sessionMember.mb_id)_in_sign2.png" {
            bottomSignImage.image = UIImage(data: bytes as Data)
            //bottomSignImage.isHidden = false
            bottomButton.isHidden = false
            bottomButton.setImage(UIImage(data: bytes as Data), for: .normal)
            
            
            HttpsManager.instance.imgUpload(view: self, imagePath: fileName, fileGroup: "2", seq: DataManager.instance.individual.in_seq, completionHandler: { (success, data) in
                
                let response = data as! String
                let data = response.data(using: .utf8)
                if let data = data, let result = try? JSONDecoder().decode(UploadImageResult.self, from: data) {
                    if result.result == "success" {
                        
                
                        
                    } else {
                        //첫번째 서명 저장실패
                        UIManager.instance.ShowAlert(title: "", message: "서명 저장을 실패했습니다", viewController: self)
                    }
                }
                
            })
        }
    }
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var upperWebView: WKWebView!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var upperButton: UIButton!
    @IBOutlet weak var upperSignImage: UIImageView!
    
    @IBOutlet weak var bottomWebView: WKWebView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var bottomSignImage: UIImageView!
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    var isUpperSign = false
    var isBottomSign = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upperTextField.delegate = self
        bottomTextField.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        upperSignImage.isHidden = true
        bottomSignImage.isHidden = true
        
        upperWebView.layer.borderWidth = 1
        upperWebView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        bottomWebView.layer.borderWidth = 1
        bottomWebView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        loadUpperWebView()
        loadBottomWebView()
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EndEditing))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if DataManager.instance.individual.db_div == "U" {
            LoadIndividualContract()
        }
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/0d457ea7317e458e85e5a33764b486d5") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if( string == " ") {
            return false
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
    
    func LoadIndividualContract() {
        HttpsManager.instance.selectMyIndividual(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, completionHandler: {
            (sucess, data) in
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let contract = try?
                JSONDecoder().decode(Individual.self, from: data) {
                
                
                if contract.result == "true" {
                    
                    DataManager.instance.individual.in_seq = contract.in_seq
                    
                    self.upperTextField.text = contract.in_name
                    self.bottomTextField.text = contract.in_name
                    
                    if let upperUrl = URL(string: contract.path1) {
                        let upperImgData = try? Data(contentsOf: upperUrl)
                        self.upperSignImage.image = UIImage(data: upperImgData!)
                        //self.upperSignImage.isHidden = false
                        self.upperButton.isHidden = false
                        self.upperButton.setImage(UIImage(data: upperImgData!), for: .normal)
                        self.isUpperSign = true
                    }
                    
                    
                    if let bottomUrl = URL(string: contract.path2) {
                        let bottomImgData = try? Data(contentsOf: bottomUrl)
                        self.bottomSignImage.image = UIImage(data: bottomImgData!)
                        //self.bottomSignImage.isHidden = false
                        self.bottomButton.isHidden = false
                        self.bottomButton.setImage(UIImage(data: bottomImgData!), for: .normal)
                        self.isBottomSign = true
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "계약서 정보가 없습니다", viewController: self)
                }
            }
        })
    }
    
    @IBAction func didTapUpperSign(_ sender: UIButton) {
        let signView = self.storyboard?.instantiateViewController(withIdentifier: "SignDrowViewController") as? SignDrowViewController
        signView?.fileName = "\(DataManager.instance.sessionMember.mb_id)_in_sign1.png"
        signView?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        signView?.delegate = self
        
        self.present(signView!, animated: true, completion: {
        })
    }
    
    @IBAction func didTapBottomSign(_ sender: UIButton) {
        let signView = self.storyboard?.instantiateViewController(withIdentifier: "SignDrowViewController") as? SignDrowViewController
        signView?.fileName = "\(DataManager.instance.sessionMember.mb_id)_in_sign2.png"
        signView?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        signView?.delegate = self
        
        self.present(signView!, animated: true, completion: {
        })
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if upperTextField.text?.count == 0 || bottomTextField.text?.count == 0{
            UIManager.instance.ShowAlert(title: "", message: "약관동의 이름이 필요합니다", viewController: self, completionHandler: {(result) in
                
                if self.upperTextField.text?.count == 0 {
                    self.upperTextField.becomeFirstResponder()
                } else if self.bottomTextField.text?.count == 0 {
                    self.bottomTextField.becomeFirstResponder()
                }
                
            })
            return
        }
        
        if upperTextField.text != bottomTextField.text {
            UIManager.instance.ShowAlert(title: "", message: "약관동의 이름이 일치해야 합니다", viewController: self)
            return
        }
        
        if Auth.checkName(name: upperTextField.text!, vc: self) == false {
            return
        }
        
        if upperSignImage.image == nil {
            UIManager.instance.ShowAlert(title: "", message: "전자서명을 완료해야합니다", viewController: self, completionHandler: {(result) in
                
                let signView = self.storyboard?.instantiateViewController(withIdentifier: "SignDrowViewController") as? SignDrowViewController
                signView?.fileName = "\(DataManager.instance.sessionMember.mb_id)_in_sign1.png"
                signView?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                signView?.delegate = self
                
                self.present(signView!, animated: true, completion: {
                })
            })
            
            return
        }
        
        if bottomSignImage.image == nil {
            UIManager.instance.ShowAlert(title: "", message: "전자서명을 완료해야합니다", viewController: self, completionHandler: {(result) in
                
                let signView = self.storyboard?.instantiateViewController(withIdentifier: "SignDrowViewController") as? SignDrowViewController
                signView?.fileName = "\(DataManager.instance.sessionMember.mb_id)_in_sign2.png"
                signView?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                signView?.delegate = self
                
                self.present(signView!, animated: true, completion: {
                })
            })
            
            return
        }
        
        //서버전달
        if DataManager.instance.individual.db_div == "U" {
            
            var dic = [String : String]()
            dic.updateValue(DataManager.instance.sessionMember.mb_idnum, forKey: "in_idnum")
            dic.updateValue(upperTextField.text!, forKey: "in_name")
            dic.updateValue(DataManager.instance.individual.in_seq, forKey: "in_seq")
            
            HttpsManager.instance.updateIndividual(view: self, data: dic, completionHandler: { (success, data) in
                
                let response = data as! String
                let data = response.data(using: .utf8)
                if let data = data, let contract = try? JSONDecoder().decode(Individual.self, from: data) {
                    if contract.result == "true" {
                        //계약서 사진 저장
                        //DataManager.instance.business.li_seq = contract.li_seq
                        self.UploadImage()
                    }
                    else {
                        UIManager.instance.ShowAlert(title: "", message: "계약서 저장을 실패 했습니다", viewController: self)
                    }
                }
                
                
            })
        } else {
            print("mb_idnum : \(DataManager.instance.sessionMember.mb_idnum)")
            HttpsManager.instance.insertIndividual(view: self, idnum: DataManager.instance.sessionMember.mb_idnum, signName: upperTextField.text!, completionHandler: { (success, data) in
                
                let response = data as! String
                let data = response.data(using: .utf8)
                if let data = data, let contract = try? JSONDecoder().decode(Individual.self, from: data) {
                    if contract.result == "true" {
                        
                        DataManager.instance.individual.in_seq = contract.in_seq
                        //계약서 사진 저장
                        self.UploadImage()
                    }
                    else {
                        UIManager.instance.ShowAlert(title: "", message: "계약서 저장을 실패 했습니다", viewController: self)
                    }
                }
            })
        }
    }
    
    
    func loadUpperWebView() {
        let weburl = URL(string: "https://winnerssign.bkwinners.kr/_files/in_agree1.html")!
        let request = URLRequest(url: weburl)
        
        upperWebView.load(request)
        upperWebView.uiDelegate = self
    }
    
    func loadBottomWebView() {
        let weburl = URL(string: "https://winnerssign.bkwinners.kr/_files/in_agree2.html")!
        let request = URLRequest(url: weburl)
        
        bottomWebView.load(request)
        bottomWebView.uiDelegate = self
    }
    
    func UploadImage() {
        
        if isUpperSign && isBottomSign {
            self.MoveNext()
            return
        }
        
        DataManager.instance.individual.db_div = "U"
        
        self.MoveNext()
        
        
        HttpsManager.instance.imgUpload(view: self, imagePath: "\(DataManager.instance.sessionMember.mb_id)_in_sign1.png", fileGroup: "1", seq: DataManager.instance.individual.in_seq, completionHandler: { (success, data) in
            
            let response = data as! String
            let data = response.data(using: .utf8)
            if let data = data, let result = try? JSONDecoder().decode(UploadImageResult.self, from: data) {
                if result.result == "success" {
                    
                    HttpsManager.instance.imgUpload(view: self, imagePath: "\(DataManager.instance.sessionMember.mb_id)_in_sign2.png", fileGroup: "2", seq: DataManager.instance.individual.in_seq, completionHandler: { (success, data) in
                        
                        let response = data as! String
                        let data = response.data(using: .utf8)
                        if let data = data, let result = try? JSONDecoder().decode(UploadImageResult.self, from: data) {
                            if result.result == "success" {
                                
                                DataManager.instance.individual.db_div = "U"
                                
                                self.MoveNext()
                                
                            } else {
                                //두번째 서명 저장 실패
                                UIManager.instance.ShowAlert(title: "", message: "서명 저장을 실패했습니다", viewController: self)
                            }
                        }
                        
                    })
                    
                    
                } else {
                    //첫번째 서명 저장실패
                    UIManager.instance.ShowAlert(title: "", message: "서명 저장을 실패했습니다", viewController: self)
                }
            }
            
        })
    }
    
    func MoveNext() {
        //다음으로 이동
        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualServiceViewController")
    }
}
