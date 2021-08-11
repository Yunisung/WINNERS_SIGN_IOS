//
//  HttpsManager.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/03/30.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration

struct Response: Codable {
    let success: Bool
    let result: String
    let message: String
}

struct LoginResponse: Codable {
    let mb_idnum: String
    let mb_id: String
    let mb_name: String
}



class HttpsManager {
    static let instance: HttpsManager = HttpsManager()
    private init() {
    }
    
    
    let defaultURL = "https://winnerssign.bkwinners.kr"
    
    func requestPost(url: String, method: String, param: [String:Any], completionHandler: @escaping (Bool, Any) -> Void) {
        let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: url) else  {
            print("Error : cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            print("data :  \(data)")
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            print("response :  \(response)")
            
            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            
            print("Output : \(output)")
            
            //completionHandler(true, data)
        }.resume()
    }
    
    func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, Any) -> Void) {
        requestPost(url: url, method: method, param: param!) { (success, data) in
            completionHandler(success, data)
        }
    }
    
    
    //로그인
    func goLogin(view: UIViewController, id: String, pw: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=goLogin"
        
        let data = [
            "mb_id": id,
            "mb_pw": pw,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let jsonToString = String(data: jsonData!, encoding: .utf8)
    
        let parameter = [
            "goLogin": jsonToString
        ]
        //위에껀 삭제금지
        
        let stringParameter = "goLogin=" + jsonToString!
        print("String parameter : \(stringParameter)")

        
//        let url = URL(string: defaultURL+subURL)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = stringParameter.data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) {
//            (data, response, error) in
//
//            DispatchQueue.main.async {
//                UIManager.instance.HideIndicator()
//
//                if let e = error {
//                    UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: e.localizedDescription, viewController: view)
//                    return
//                }
//
//                let response = String(decoding: data!, as: UTF8.self)
//                print("reponseString : \(response)")
//
//                completionHandler(true, response)
//            }
//
//        }
//        task.resume()
        
        

        AF.request(defaultURL+subURL, method: .post, parameters: parameter).responseString { response in

            UIManager.instance.HideIndicator()

            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")

                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //아이디 중복체크
    func IdCheck(view: UIViewController, id: String, completionHandler: @escaping (Bool, Any) -> Void) {
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=joinIdCk"
        let data = [
            "mb_id": id,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "joinIdCk": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
        
    }
    
    //휴대폰 인증코드
    func PhoneNumCheck(view: UIViewController, number: String, code: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=sendPhone"
        let data = [
            "phNum": number,
            "num": code,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "sendPhone": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //회원가입
    func InsertJoin(view: UIViewController, member: Member, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=insertJoin"
        
        let jsonData = try? JSONEncoder().encode(member)
        //let jsonData = try? JSONSerialization.data(withJSONObject: data!, options: .prettyPrinted)
        
        let param = [
            "insertJoin": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //아이디 찾기
    func selectFindId(view: UIViewController, number: String, phone: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectFindId"
        
        let data = [
            "mb_name": number,
            "mb_phone": phone,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectFindId": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //비밀번호 찾기
    func selectFindPw(view: UIViewController, name: String, id: String, phone: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectFindPw"
        
        let data = [
            "mb_name": name,
            "mb_id": id,
            "mb_phone": phone,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectFindPw": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //비밀번호변경
    func updatePw(view: UIViewController, id: String, newPw: String, phone: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=updatePw"
        
        let data = [
            "mb_id": id,
            "mb_phone": phone,
            "mb_pw": newPw,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "updatePw": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    
    
    //회원정보 접근
    func selectPw(view: UIViewController, id: String, pw: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectPw"
        
        let data = [
            "mb_id": id,
            "mb_pw": pw,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectPw": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //회원정보 불러오기
    func selectMyInfo(view: UIViewController, id: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectMyInfo"
        
        let data = [
            "mb_id": id,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectMyInfo": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //회원정보 수정
    func updateInfo(view: UIViewController, info: UpdateUserInfo, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=updateInfo"

        let jsonData = try? JSONEncoder().encode(info)
        
        let param = [
            "updateInfo": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //계약서 정보 요청
    func selectMyContract(view: UIViewController, idnum: String, contract: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectMyContract"
        
        let data = [
            "mb_idnum": idnum,
            "contract": contract,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectMyContract": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //사업자 계약서 조회
    func countYLicensee(view: UIViewController, idnum: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=countYLicensee"
        
        let data = [
            "li_idnum": idnum,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "countYLicensee": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //개인계약서 조회
    func countYIndividual(view: UIViewController, idnum: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=countYIndividual"
        
        let data = [
            "in_idnum": idnum,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "countYIndividual": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //이미 쓴 사업자 계약서 불러오기
    func selectMyLicensee(view: UIViewController, idnum: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectMyLicensee"
        
        let data = [
            "li_idnum": idnum,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectMyLicensee": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
        
    }
    
    //이미 쓴 개인 계약서 불러오기
    func selectMyIndividual(view: UIViewController, idnum: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectMyIndividual"
        
        let data = [
            "in_idnum": idnum,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectMyIndividual": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("[S]selectMyIndividual Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("[S]selectMyIndividual Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("[F]selectMyIndividual Request: \(String(describing: response.request))")
                print("[F]selectMyIndividualResponse: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
        
    }
    
    //[사업자] 계약서 등록
    func insertLicensee(view: UIViewController, idnum: String, signName: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=insertLicensee"
        
        let data = [
            "li_idnum": idnum,
            "li_name": signName,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "insertLicensee": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
        
    }
    
    //[개인] 계약서 등록
    func insertIndividual(view: UIViewController, idnum: String, signName: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=insertIndividual"
        
        let data = [
            "in_idnum": idnum,
            "in_name": signName,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "insertIndividual": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
        
    }
    
    //[사업자] 계약서 수정
    func updateLicensee(view: UIViewController, data: Dictionary<String, String>, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=updateLicensee"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "updateLicensee": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //[개인] 계약서 수정
    func updateIndividual(view: UIViewController, data: Dictionary<String, String>, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=updateIndividual"
        
        print("UpdateIndividual Request : \(data)")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "updateIndividual": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                //print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //[사업자] 계약서 확인
    func selectContract_li(view: UIViewController, data: Dictionary<String, String>, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectContract_li"

        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectContract_li": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    //[개인] 계약서 확인
    func selectContract_in(view: UIViewController, data: Dictionary<String, String>, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=selectContract_in"

        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        let param = [
            "selectContract_in": String(data: jsonData!, encoding: .utf8)
        ]
        
        AF.request(defaultURL+subURL, method: .post, parameters: param).responseString { response in
            
            UIManager.instance.HideIndicator()
            
            switch response.result {
            case .success(let result):
                print("Request Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                print("Response: \(result)")
                
                completionHandler(true, result)
            case .failure:
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }

        }
    }
    
    //이미지 전송
    func imgUpload(view: UIViewController, imagePath: String, fileGroup: String, seq: String, completionHandler: @escaping (Bool, Any) -> Void) {
        
        UIManager.instance.ShowIndicator(viewController: view)
        
        let subURL = "/app/Appdbconn?page=imgUpload"
            
        let image = ImageFileManager.shared.getSavedImage(named: imagePath)
        let imageData = image?.pngData()!
        
        if imageData == nil {
            UIManager.instance.ShowAlert(title: "", message: "파일을 불러올수 없습니다. 파일을 다시 선택해주세요", viewController: view)
            UIManager.instance.HideIndicator()
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "uploaded_file", fileName: imagePath, mimeType: "image/png")
            multipartFormData.append(Data(DataManager.instance.sessionMember.mb_idnum.utf8), withName: "idnum")
            multipartFormData.append(Data(seq.utf8), withName: "seq")
            multipartFormData.append(Data(fileGroup.utf8), withName: "fi_group")
        }, to: defaultURL+subURL).responseString(completionHandler: { response in
            
            UIManager.instance.HideIndicator()
            
            print("imagePath : \(imagePath), fileGroup : \(fileGroup), seq : \(seq)")
            
            switch response.result {
            case .success(let result):
                print("[S]imgUpload Request: \(response.request?.httpBody)")
                print("[S]imgUpload Response: \(result)")
                completionHandler(true, result)
            case .failure:
                print("[F]imgUpload Request: \(String(describing: response.request))")
                print("[F]imgUpload Response: \(String(describing: response.response))")
                UIManager.instance.ShowAlert(title: "인터넷 연결 실패", message: response.error!.localizedDescription, viewController: view)
            }
            
        })
        
    }
    
    func checkNetworkConnect(view: UIViewController) {
        if isConnectedToNetwork() {
            print("Network Connect")
        } else {
            print("Network Not Connect")
            
            UIManager.instance.ShowAlert(title: "Internet Connect Fail", message: "인터넷 연결상태를 확인해주세요", viewController: view)
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0,0,0,0,0,0,0,0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
}
