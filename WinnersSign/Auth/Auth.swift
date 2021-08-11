//
//  Auth.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/06.
//

import UIKit

class Auth {
    //이름 체크
    static func checkName(name: String, vc: UIViewController) -> Bool{
        if name.isEmpty == true {
            UIManager.instance.ShowAlert(title: "", message: "이름을 입력해주세요", viewController: vc)
            return false
        }
        
        if isValidName(name: name) == false {
            UIManager.instance.ShowAlert(title: "", message: "이름을 다시 확인해주세요", viewController: vc)
            return false
        }
        
        if name.count < 2 {
            UIManager.instance.ShowAlert(title: "", message: "이름을 2글자 이상 적어주세요", viewController: vc)
            return false
        }
        
        return true
    }
    
    //아이디 체크
    static func checkID(id: String, vc: UIViewController) -> Bool {
        if id.isEmpty == true {
            UIManager.instance.ShowAlert(title: "", message: "아이디를 입력해주세요", viewController: vc)
            return false
        }
        
        if ((id.contains(" ")) == true) {
            UIManager.instance.ShowAlert(title: "", message: "아이디에 공백을 넣을수 없습니다", viewController: vc)
            return false
        }
        
        if isValidId(id: id) == false {
            UIManager.instance.ShowAlert(title: "", message: "아이디는 4~12 소문자, 숫자만 사용 가능합니다", viewController: vc)
            return false
        }
        
        return true
    }
    
    //비밀번호 체크
    static func checkPw(pw: String, repw: String, vc: UIViewController) -> Bool {
        if pw.isEmpty == true {
            UIManager.instance.ShowAlert(title: "", message: "비밀번호를 입력해주세요", viewController: vc)
            return false
        }
        
        if repw.isEmpty == true {
            UIManager.instance.ShowAlert(title: "", message: "비밀번호확인란을 입력해주세요", viewController: vc)
            return false
        }
        
        if isValidPassword(pwd: pw) == false {
            UIManager.instance.ShowAlert(title: "", message: "비밀번호는 4~12 영문과 숫자만 사용 가능합니다", viewController: vc)
            return false
        }
        
        if((pw.elementsEqual(repw)) == false) {
            UIManager.instance.ShowAlert(title: "", message: "비밀번호가 일치하지 않습니다", viewController: vc)
            return false
        }
        
        return true
    }
    
    //이메일 체크
    static func checkEmail(email: String, vc: UIViewController) -> Bool {
        
        if email.isEmpty == true {
            UIManager.instance.ShowAlert(title: "", message: "이메일을 입력해주세요", viewController: vc)
            return false
        }
        
        if Auth.isValidEmail(email: email) == false {
            UIManager.instance.ShowAlert(title: "", message: "올바른 형식의 이메일이 아닙니다", viewController: vc)
            return false
        }
        
        return true
    }
    
    //휴대폰번호 체크
    static func checkPhoneNum(number: String, vc: UIViewController) -> Bool {
        if number.isEmpty == true {
            UIManager.instance.ShowAlert(title: "", message: "휴대폰번호를 입력해주세요", viewController: vc)
            return false
        }
        
        if isValidPhoneNumber(phone: number) == false {
            UIManager.instance.ShowAlert(title: "", message: "올바른 형식의 휴대폰번호가 아닙니다", viewController: vc)
            return false
        }
        
        return true
    }
    
    //휴대폰 인증코드 체크
    static func checkPhoneCode(code: String, phoneAuthCode: String) -> Bool {
        if code == phoneAuthCode {
            return true
        } else {
            return false
        }
    }
    
    //상호명 체크
    static func checkCompany(company: String, vc: UIViewController) -> Bool {
        if isValidText(text: company) == false {
            UIManager.instance.ShowAlert(title: "", message: "한글, 영문, 숫자만 사용 가능합니다", viewController: vc)
            return false
        }
        
        return EmptyChecker(data: company, errorMessage: "상호명을 입력해주세요", vc: vc)
    }
    
    //사업자 번호 체크
    static func checkBusinessNum(number: String, vc: UIViewController) -> Bool {
        if number.count != 10 {
            UIManager.instance.ShowAlert(title: "", message: "사업자 등록번호는 10자리 입니다", viewController: vc)
            return false
        }
        
        return true
    }
    
    //대표번호 체크
    static func checkTel(tel: String, vc: UIViewController) -> Bool {
//        if !(isValidTelNumber(data: tel) || isValidPhoneNumber(phone: tel)){
//            UIManager.instance.ShowAlert(title: "", message: "올바른 형식이 아닙니다", viewController: vc)
//            return false
//        }
        
        return EmptyChecker(data: tel, errorMessage: "대표번호를 입력해주세요", vc: vc)
    }
    
    //업태 체크
    static func checkCindition(text: String, vc: UIViewController) -> Bool {
        if isValidText(text: text) == false {
            UIManager.instance.ShowAlert(title: "", message: "한글, 영문, 숫자만 사용 가능합니다", viewController: vc)
            return false
        }
        
        return EmptyChecker(data: text, errorMessage: "업태를 입력해주세요", vc: vc)
    }
    
    //종목 체크
    static func checkEvent(text: String, vc: UIViewController) -> Bool {
        if isValidText(text: text) == false {
            UIManager.instance.ShowAlert(title: "", message: "한글, 영문, 숫자만 사용 가능합니다", viewController: vc)
            return false
        }
        
        return EmptyChecker(data: text, errorMessage: "종목을 입력해주세요", vc: vc)
    }
    
    //생년월일 체크
    static func checkBirth(data: String, vc: UIViewController) -> Bool {
        if isValidBirth(data: data) == false {
            UIManager.instance.ShowAlert(title: "", message: "생년월일을 다시 확인해주세요", viewController: vc)
            return false
        }
        
        return EmptyChecker(data: data, errorMessage: "생년월일을 입력해주세요", vc: vc)
    }
    
    //연락처 체크
    static func checkPhone(data: String, vc: UIViewController) -> Bool {
        if isValidPhoneNumber(phone: data) == false {
            UIManager.instance.ShowAlert(title: "", message: "올바른 휴대폰번호 형식이 아닙니다", viewController: vc)
            return false
        }
        
        return EmptyChecker(data: data, errorMessage: "연락처를 입력해주세요", vc: vc)
    }
    
    //계좌번호 체크
    static func checkBankNum(data: String, vc: UIViewController) -> Bool {
        if (data.count > 10 && data.count < 17) == false {
            UIManager.instance.ShowAlert(title: "", message: "계좌번호는 11~16자 입니다", viewController: vc)
            return false
        }
        
        return EmptyChecker(data: data, errorMessage: "계좌번호를 입력해주세요", vc: vc)
    }
    
    static func checkRRN(data: String, vc: UIViewController) -> Bool {
        if isValidRRN(data: data) == false {
            UIManager.instance.ShowAlert(title: "", message: "올바른 주민등록번호 형식이 아닙니다", viewController: vc)
            return false
        }
        
        return EmptyChecker(data: data, errorMessage: "주민등록번호를 입력해주세요", vc: vc)
    }
    
    //공백체크 통일
    static func EmptyChecker(data: String, errorMessage: String, vc: UIViewController) -> Bool {
        if data.isEmpty {
            UIManager.instance.ShowAlert(title: "", message: errorMessage, viewController: vc)
            return false
        }
        
        return true
    }
    
    //이름 정규식 체크
    static func isValidName(name: String) -> Bool {
        let korNameRegEx = "^[가-힣]*$"
        let engNameRegEx = "^[a-zA-Z]*$"
        let korNameTest = NSPredicate(format: "SELF MATCHES %@", korNameRegEx)
        let engNameTest = NSPredicate(format: "SELF MATCHES %@", engNameRegEx)
        return korNameTest.evaluate(with: name) || engNameTest.evaluate(with: name)
    }
    
    //ID 정규식 체크
    static func isValidId(id: String) -> Bool {
        let idRegEx = "^[a-z0-9]{4,12}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: id)
    }
    
    //비밀번호 정규식 체크
    static func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]{4,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
    
    //email 정규식 체크
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    //휴대폰번호 정규식 체크
    static func isValidPhoneNumber(phone: String) -> Bool {
        let phoneRegEx = "^01([0-9])([0-9]{3,4})([0-9]{4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: phone)
    }
    
    //대표번호 정규식 체크
    static func isValidTelNumber(data: String) -> Bool {
        let RegEx = "^(15|16|18)[0-9]{2}-?[0-9]{4}$"
        let Test = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return Test.evaluate(with: data)
    }
    
    //텍스트 정규식 체크
    static func isValidText(text: String) -> Bool {
        let textRegEx = "^[가-힣a-zA-Z0-9]+$"
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textTest.evaluate(with: text)
    }
    
    //생년월일 정규식 체크
    static func isValidBirth(data: String) -> Bool {
        let RegEx = "^(19[0-9][0-9]|20[0-9][0-9])(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$"
        let Test = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return Test.evaluate(with: data)
    }
    
    //주민번호 정규식 체크
    static func isValidRRN(data: String) -> Bool {
        let RegEx = "^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))[1-4][0-9]{6}$"
        let Test = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return Test.evaluate(with: data)
    }
    
    //휴대폰 인증번호 생성
    static func createPhoneCode() -> String {
        var num = ""
        
        for _ in 1...6 {
            let random = arc4random_uniform(10)
            num.append(String(random))
        }
        
        return num
    }
    
    static func Masking(div: String, val: String) -> String {
        var num1: String
        var num2: String
        var num3: String
        var output: String = ""
        
        if div == "tel" {
            if val.count == 11 {
                let startidx: String.Index = val.index(val.startIndex, offsetBy: 3)
                num1 = String(val[...startidx])
                let midindex: String.Index = val.index(startidx, offsetBy: 4)
                num2 = String(val[startidx...midindex])
                num3 = String(val[midindex...])
                output = num1 + "-" + num2 + "-" + num3
            } else if val.count == 10 {
                let startidx: String.Index = val.index(val.startIndex, offsetBy: 3)
                num1 = String(val[...startidx])
                let midindex: String.Index = val.index(startidx, offsetBy: 3)
                num2 = String(val[startidx...midindex])
                num3 = String(val[midindex...])
                output = num1 + "-" + num2 + "-" + num3
            } else if val.count == 8 {
                let startidx: String.Index = val.index(val.startIndex, offsetBy: 4)
                num1 = String(val[...startidx])
                let midindex: String.Index = val.index(startidx, offsetBy: 4)
                num2 = String(val[midindex...])
                output = num1 + "-" + num2
            }
        }
        
        return output
    }
}
