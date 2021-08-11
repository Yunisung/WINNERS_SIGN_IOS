//
//  ContractBusinessAddFileViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/19.
//

import UIKit
import Photos


class ContractBusinessAddFileViewController : UIViewController {
    
    @IBOutlet weak var identificationImageView: UIImageView!
    @IBOutlet weak var bankImageView: UIImageView!
    @IBOutlet weak var licenseImageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    var selectButton = ""
    
    var isImage1 = false
    var isImage2 = false
    var isImage3 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        imagePickerController.delegate = self
        
        identificationImageView.layer.borderWidth = 1
        identificationImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        bankImageView.layer.borderWidth = 1
        bankImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        licenseImageView.layer.borderWidth = 1
        licenseImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        LoadBusinessContract()
    }
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/6147151867c949199a35ffe20368eac2") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func didTapIdAlbum(_ sender: UIButton) {
        selectButton = "Id"
        OpenAlbum()
    }
    
    @IBAction func didTapIdCamera(_ sender: UIButton) {
        selectButton = "Id"
        OpenCamera()
    }
    
    @IBAction func didTapBankAlbum(_ sender: UIButton) {
        selectButton = "Bank"
        OpenAlbum()
    }
    
    @IBAction func didTapBankCamera(_ sender: UIButton) {
        selectButton = "Bank"
        OpenCamera()
    }
    
    @IBAction func didTapLicenseAlbum(_ sender: UIButton) {
        selectButton = "License"
        OpenAlbum()
    }
    
    @IBAction func didTapLicenseCamera(_ sender: UIButton) {
        selectButton = "License"
        OpenCamera()
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if identificationImageView.image == nil ||
            bankImageView.image == nil ||
            licenseImageView.image == nil {
            UIManager.instance.ShowAlert(title: "", message: "파일을 첨부해주세요", viewController: self)
            return
        }
        
        MoveNext()
    }
    
    func MoveNext() {
        //다음씬으로 이동
        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractBusinessBankViewController")
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
                    
                    //이미지 로드
                    if let idURL = URL(string: contract.path3) {
                        let idData = try? Data(contentsOf: idURL)
                        self.identificationImageView.image = UIImage(data: idData!)
                        self.isImage1 = true
                    }
                    
                    if let bankURL = URL(string: contract.path4) {
                        let bankData = try? Data(contentsOf: bankURL)
                        self.bankImageView.image = UIImage(data: bankData!)
                        self.isImage2 = true
                    }
                    
                    if let licenseURL = URL(string: contract.path5) {
                        let licenseData = try? Data(contentsOf: licenseURL)
                        self.licenseImageView.image = UIImage(data: licenseData!)
                        self.isImage3 = true
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "계약서 정보가 없습니다", viewController: self)
                }
                
            }
        })
    }

    func OpenAlbum() {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func OpenCamera() {
        
        AVCaptureDevice.requestAccess(for: .video) {
            (granted) in
            DispatchQueue.main.async {
                if granted {
                    print("Camera: 권한 허용")
                    self.imagePickerController.sourceType = .camera
                    self.present(self.imagePickerController, animated: true, completion: nil)
                } else {
                    print("Camera: 권한 거부")
                }
            }
        }
    }
    
    func SettingAlert() {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let alert = UIAlertController(title: "설정", message: "\(appName)이(가) 카메라 접근 허용되어 있지않습니다. 설명화면으로 가시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: {
                (action) in
            })
            
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: {
                (action) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        }
    }
    
}

extension ContractBusinessAddFileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if self.selectButton == "Id" {
                self.identificationImageView.image = image
                isImage1 = false
                
                let fileName = "\(DataManager.instance.sessionMember.mb_id)_li_Id.png"
                
                ImageFileManager.shared.saveImage(image: self.identificationImageView.image!, name: fileName) {
                    [weak self] onSuccess in
                    print("saveImage : \(fileName) onSuccess:\(onSuccess)")
                    
                    HttpsManager.instance.imgUpload(view: self!, imagePath: fileName, fileGroup: "3", seq: DataManager.instance.business.li_seq, completionHandler: {
                        (success, data) in
                        
                        let response = data as! String
                        let data = response.data(using: .utf8)
                        if let data = data, let result = try?
                            JSONDecoder().decode(UploadImageResult.self, from: data) {
                            if result.result == "success" {
                                
                            }
                        }
                    })
                    
                }
        
            } else if self.selectButton == "Bank" {
                self.bankImageView.image = image
                isImage2 = false
                
                let fileName = "\(DataManager.instance.sessionMember.mb_id)_li_Bank.png"
                
                ImageFileManager.shared.saveImage(image: self.bankImageView.image!, name: fileName) {
                    [weak self] onSuccess in
                    print("saveImage : \(fileName) onSuccess:\(onSuccess)")
                    
                    HttpsManager.instance.imgUpload(view: self!, imagePath: fileName, fileGroup: "4", seq: DataManager.instance.business.li_seq, completionHandler: {
                        (success, data) in
                        
                        let response = data as! String
                        let data = response.data(using: .utf8)
                        if let data = data, let result = try?
                            JSONDecoder().decode(UploadImageResult.self, from: data) {
                            if result.result == "success" {
                                
                            }
                        }
                    })
                }
                
            } else if self.selectButton == "License" {
                self.licenseImageView.image = image
                isImage3 = false
                
                let fileName = "\(DataManager.instance.sessionMember.mb_id)_li_License.png"
                
                ImageFileManager.shared.saveImage(image: self.licenseImageView.image!, name: fileName) {
                    [weak self] onSuccess in
                    print("saveImage : \(fileName) onSuccess:\(onSuccess)")
                    
                    HttpsManager.instance.imgUpload(view: self!, imagePath: fileName, fileGroup: "5", seq: DataManager.instance.business.li_seq, completionHandler: {
                        (success, data) in
                        
                        let response = data as! String
                        let data = response.data(using: .utf8)
                        if let data = data, let result = try?
                            JSONDecoder().decode(UploadImageResult.self, from: data) {
                            if result.result == "success" {
                                
                            }
                        }
                    })
                }
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
