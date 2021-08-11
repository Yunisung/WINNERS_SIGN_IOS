//
//  UIManager.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/04.
//

import UIKit

class UIManager {
    static let instance: UIManager = UIManager()
    private init() {}
    
    let backgroudView = UIView()
    //인디케이터 세팅
    lazy var indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.stopAnimating()
        
        return activityIndicator
    }()
    
    //알림띄우기
    func ShowAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //알람띄우기 닫을때 액션 실행
    func ShowAlert(title: String, message: String, viewController: UIViewController, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: { action in
            completionHandler(true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //알람띄우기 버튼2개 액션 실행
    func ShowAlert(title: String, message:String, viewController: UIViewController, button1Name: String, button2Name: String, button1Handler: @escaping (Bool) -> Void, button2Handler: @escaping (Bool) -> Void) {
        
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button1Name, style: .default, handler: { action in button1Handler(true)
            
        }))
        
        alert.addAction(UIAlertAction(title: button2Name, style: .default, handler: { action in button2Handler(true)
            
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //인디케이터
    func ShowIndicator(viewController: UIViewController) {
        indicator.center = viewController.view.center
        indicator.isHidden = false
        indicator.startAnimating()
        
        backgroudView.isHidden = false
        backgroudView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        backgroudView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        backgroudView.addSubview(indicator)
        
        viewController.view.addSubview(backgroudView)
    }
    
    func HideIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
        backgroudView.isHidden = true
    }
}
