//
//  FindIDFinishViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/06.
//

import UIKit

class FindIDFinishViewController : UIViewController {
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var resultLabel: UILabel!
    
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.setHidesBackButton(true, animated: true)
        resultLabel.text = String("고객님의 아이디는 \(userId!)입니다")
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapFindPwd(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FindPwViewController") as? FindPwViewController
        
        viewController?.userId = self.userId!
        
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}
