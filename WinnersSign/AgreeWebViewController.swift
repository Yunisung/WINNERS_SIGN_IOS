//
//  AgreeWebViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/03/30.
//

import UIKit
import WebKit

class AgreeWebViewController : UIViewController, WKUIDelegate, WKNavigationDelegate {

    var linkURL: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString("https://winnerssign.bkwinners.kr/_files/agree1.html", baseURL: nil)
        loadURL()

    }
    
    
    func loadURL() {
        
        let weburl = URL(string: linkURL!)!
        let request = URLRequest(url: weburl)
        
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    
    @IBAction func didTapAgree(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    
}
