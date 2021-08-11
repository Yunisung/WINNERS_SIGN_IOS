//
//  ContractIndividualAddFileViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/23.
//

import UIKit
import Photos

class ContractIndividualAddFileViewController : UIViewController {
    
    @IBOutlet weak var identificationImageView: UIImageView!
    @IBOutlet weak var bankImageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    var selectButton = ""
    
    var isImg1 = false
    var isImg2 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_home"), style: .plain, target: self, action: #selector(goHome))
        
        imagePickerController.delegate = self
        
        identificationImageView.layer.borderWidth = 1
        identificationImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        bankImageView.layer.borderWidth = 1
        bankImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        LoadIndividualContract()
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/22110d92f03a469d9f76cb959fbe8701") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
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
                    
                    //이미지 로드
                    if let idURL = URL(string: contract.path3) {
                        let idData = try? Data(contentsOf: idURL)
                        self.identificationImageView.image = UIImage(data: idData!)
                        self.isImg1 = true
                    }
                    
                    if let bankURL = URL(string: contract.path4) {
                        let bankData = try? Data(contentsOf: bankURL)
                        self.bankImageView.image = UIImage(data: bankData!)
                        self.isImg2 = true
                    }
                    
                } else {
                    UIManager.instance.ShowAlert(title: "", message: "다시 시도해주세요", viewController: self)
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

    
    func MoveNext() {
        //다음씬으로 이동
        ViewControllerManager.instance.ChangeViewController(viewController: self, nextViewController: "ContractIndividualBankViewController")
    }
    
    @IBAction func didTapIdAlbum(_ sender: UIButton) {
        selectButton = "Id"
        OpenAlbum()
    }
    
    @IBAction func didTapIdCamera(_ sender: UIButton) {
        selectButton = "Id"
        OpenCamera()
    }
    
    @IBAction func didTapbankAlbum(_ sender: UIButton) {
        selectButton = "Bank"
        OpenAlbum()
    }
 
    @IBAction func didTapbankCamera(_ sender: UIButton) {
        selectButton = "Bank"
        OpenCamera()
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if identificationImageView.image == nil ||
            bankImageView.image == nil {
            
            UIManager.instance.ShowAlert(title: "", message: "파일을 첨부해주세요", viewController: self)
            return
        }
        
        MoveNext()
    }
    
}

extension ContractIndividualAddFileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if self.selectButton == "Id" {
                self.identificationImageView.image = image
                
                let fileName = "\(DataManager.instance.sessionMember.mb_id)_in_Id.png"
                
                ImageFileManager.shared.saveImage(image: self.identificationImageView.image!, name: fileName) {
                    [weak self] onSuccess in
                    print("saveImage : \(fileName) onSuccess:\(onSuccess)")
                    
                    self?.isImg1 = false
                    
                    HttpsManager.instance.imgUpload(view: self!, imagePath: fileName, fileGroup: "3", seq: DataManager.instance.individual.in_seq, completionHandler: {
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
                
                let fileName = "\(DataManager.instance.sessionMember.mb_id)_in_Bank.png"
                
                ImageFileManager.shared.saveImage(image: self.bankImageView.image!, name: fileName) {
                    [weak self] onSuccess in
                    print("saveImage : \(fileName) onSuccess:\(onSuccess)")
                    
                    self?.isImg2 = false
                    
                    HttpsManager.instance.imgUpload(view: self!, imagePath: fileName, fileGroup: "4", seq: DataManager.instance.individual.in_seq, completionHandler: {
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
