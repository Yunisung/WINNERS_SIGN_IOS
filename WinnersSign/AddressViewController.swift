//
//  AddressViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/18.
//

import UIKit
import WebKit

class AddressViewController : UIViewController, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var webContentView: UIView!
    
    var delegate: AddressProtocol?
    
    var webview: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name : "setAddress")
        
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        
        self.webview = WKWebView(frame: webContentView.bounds, configuration: webConfiguration)
        self.webContentView.addSubview(self.webview!)
        
        LoadURL()
    }
    
    func LoadURL() {
        let weburl = URL(string: "https://winnerssign.bkwinners.kr/_files/address_ios.html")!
        let request = URLRequest(url: weburl)
        
        
        self.webview!.load(request)
        self.webview!.uiDelegate = self
        
    }
    
    open func setAddress(data1: String, data2: String, data3: String) {
        self.delegate?.AddressData(address1: data1, address2: data2, address_Building: data3)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let value:[String:String] = message.body as! Dictionary
        let address1 = value["address1"]
        let address2 = value["address2"]
        let address_building = value["address_building"]
        
        self.setAddress(data1: address1!, data2: address2!, data3: address_building!)
        
        ViewControllerManager.instance.PopViewController(viewContoller: self)
    }
}
