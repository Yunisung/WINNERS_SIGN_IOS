//
//  JoinFinishViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/06.
//

import UIKit

class JoinFinishViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func didTapLoginButton(_ sender: UIButton) {
        //let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        //self.navigationController?.pushViewController(login!, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
