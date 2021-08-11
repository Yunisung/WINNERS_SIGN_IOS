//
//  ViewControllerMananer.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

class ViewControllerManager {
    static let instance = ViewControllerManager()
    private init() {}
    
    func ChangeViewController(viewController: UIViewController, nextViewController: String) {
        let nextView = viewController.storyboard?.instantiateViewController(withIdentifier: nextViewController)
        
        viewController.navigationController?.pushViewController(nextView!, animated: true)
    }
    
    func PopViewController(viewContoller: UIViewController) {
        viewContoller.navigationController?.popViewController(animated: true)
    }
}
