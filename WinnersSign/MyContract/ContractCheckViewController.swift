//
//  ContractCheckViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/09.
//

import UIKit

class ContractCheckViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = "\(DataManager.instance.sessionMember.mb_name)님, 환영합니다"
    }
    
    @IBAction func didTapBusiness(_ sender: UIButton) {

        
    }
    
    @IBAction func didTapIndividual(_ sender: UIButton) {

        
    }
    
}
