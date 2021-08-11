//
//  FindPwFinishViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

class FindPwFinishViewController : UIViewController {
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
