//
//  Bean.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

//회원가입정보
struct Member : Codable {
    let mb_idnum: String
    let mb_id: String
    let mb_pw: String
    let mb_name: String
    let mb_phone: String
    let mb_email: String
    let mb_wdate: String
    let mb_wtime: String
    let mb_mdate: String
    let mb_mtime: String
    var mb_lv: String = "1"
    var mb_state: String = "1"
    let mb_ck3: String
}

//로그인정보
struct SessionMb : Codable {
    var mb_id: String
    var mb_idnum: String
    var mb_name: String
}

//정보변경 - 개인정보수정 받아오기
struct MyInfo : Codable {
    let mb_idnum: String
    let mb_id: String
    let mb_name: String
    let mb_phone: String
    let mb_email: String
    let mb_pw: String
}

//정보변경 - 개인정보수정 덮어쓰기
struct UpdateUserInfo : Codable {
    var mb_idnum: String
    var mb_id: String
    var mb_name: String
    var mb_phone: String
    var mb_email: String
    var mb_pw: String
    var mb_mdate: String
    var mb_mtime: String
}

//계약서 정보 받아보기
struct ContractResult : Codable {
    var result : String
    var in_seq : String
    var li_seq : String
    
    private enum CodingKeys: String, CodingKey {
        case result, in_seq, li_seq
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = (try? values.decode(String.self, forKey: .result)) ?? ""
        in_seq = (try? values.decode(String.self, forKey: .in_seq)) ?? ""
        li_seq = (try? values.decode(String.self, forKey: .li_seq)) ?? ""
    }
}

//개인 계약서 정보
struct Individual : Codable {
    var in_idnum: String
    var in_seq: String
    var in_name: String
    var in_rrn: String
    var in_phone: String
    var in_company: String
    var in_admin: String
    var in_item: String
    var in_zipcode: String
    var in_addr1: String
    var in_addr2: String
    var in_tel: String
    var in_bank_name: String
    var in_bank_num: String
    var in_depositor: String
    var in_state: String
    var in_wdate: String
    var in_wtime: String
    var in_mdate: String
    var in_mtime: String
    var in_note: String
    var in_sv_company: String
    var in_sv_charge: String
    var in_sv_calculate: String
    var in_sv_bs_num: String
    var in_sv_cost: String
    var in_terminal_1: String = "N" //결제수단
    var in_terminal_2: String = "N" //결제수단
    var in_terminal_3: String = "N" //결제수단
    var in_agent: String //담당자
    var path1: String //약관동의서명1
    var path2: String //약관동의서명2
    var path3: String //신분증
    var path4: String //통장사본
    var path5: String //사업자등록증
    var path6: String //서비스대행사
    var path7: String //완료서명
    var result: String //db결과값 true/false
    
    var db_div: String //db구분(작성중OR신규)
    var seq: String
    
    private enum CodingKeys: String, CodingKey {
        case in_idnum, in_seq, in_name, in_rrn, in_phone, in_company, in_admin, in_item, in_zipcode, in_addr1, in_addr2, in_tel, in_bank_name, in_bank_num, in_depositor, in_state, in_wdate, in_wtime, in_mdate, in_mtime, in_note, in_sv_company, in_sv_charge, in_sv_calculate, in_sv_bs_num, in_sv_cost, in_terminal_1, in_terminal_2, in_terminal_3, in_agent, path1, path2, path3, path4, path5, path6, path7, result, db_div, seq
    }
    
    init() {
        in_idnum = ""
        in_seq = ""
        in_name = ""
        in_rrn = ""
        in_phone = ""
        in_company = ""
        in_admin = ""
        in_item = ""
        in_zipcode = ""
        in_addr1 = ""
        in_addr2 = ""
        in_tel = ""
        in_bank_name = ""
        in_bank_num = ""
        in_depositor = ""
        in_state = ""
        in_wdate = ""
        in_wtime = ""
        in_mdate = ""
        in_mtime = ""
        in_note = ""
        in_sv_company = ""
        in_sv_charge = ""
        in_sv_calculate = ""
        in_sv_bs_num = ""
        in_sv_cost = ""
        in_terminal_1 = ""
        in_terminal_2 = ""
        in_terminal_3 = ""
        in_agent = ""
        path1 = ""
        path2 = ""
        path3 = ""
        path4 = ""
        path5 = ""
        path6 = ""
        path7 = ""
        result = ""
        
        db_div = ""
        seq = ""
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        in_idnum = (try? values.decode(String.self, forKey: .in_idnum)) ?? ""
        in_seq = (try? values.decode(String.self, forKey: .in_seq)) ?? ""
        in_name = (try? values.decode(String.self, forKey: .in_name)) ?? ""
        in_rrn = (try? values.decode(String.self, forKey: .in_rrn)) ?? ""
        in_phone = (try? values.decode(String.self, forKey: .in_phone)) ?? ""
        in_company = (try? values.decode(String.self, forKey: .in_company)) ?? ""
        in_item = (try? values.decode(String.self, forKey: .in_item)) ?? ""
        in_admin = (try? values.decode(String.self, forKey: .in_admin)) ?? ""
        in_zipcode = (try? values.decode(String.self, forKey: .in_zipcode)) ?? ""
        in_addr1 = (try? values.decode(String.self, forKey: .in_addr1)) ?? ""
        in_addr2 = (try? values.decode(String.self, forKey: .in_addr2)) ?? ""
        in_tel = (try? values.decode(String.self, forKey: .in_tel)) ?? ""
        in_bank_name = (try? values.decode(String.self, forKey: .in_bank_name)) ?? ""
        in_bank_num = (try? values.decode(String.self, forKey: .in_bank_num)) ?? ""
        in_depositor = (try? values.decode(String.self, forKey: .in_depositor)) ?? ""
        in_state = (try? values.decode(String.self, forKey: .in_state)) ?? ""
        in_wdate = (try? values.decode(String.self, forKey: .in_wdate)) ?? ""
        in_wtime = (try? values.decode(String.self, forKey: .in_wtime)) ?? ""
        in_mdate = (try? values.decode(String.self, forKey: .in_mdate)) ?? ""
        in_mtime = (try? values.decode(String.self, forKey: .in_mtime)) ?? ""
        in_note = (try? values.decode(String.self, forKey: .in_note)) ?? ""
        in_sv_company = (try? values.decode(String.self, forKey: .in_sv_company)) ?? ""
        in_sv_charge = (try? values.decode(String.self, forKey: .in_sv_charge)) ?? ""
        in_sv_calculate = (try? values.decode(String.self, forKey: .in_sv_calculate))
            ?? ""
        in_sv_bs_num = (try? values.decode(String.self, forKey: .in_sv_bs_num)) ?? ""
        in_sv_cost = (try? values.decode(String.self, forKey: .in_sv_cost)) ?? ""
        in_terminal_1 = (try? values.decode(String.self, forKey: .in_terminal_1)) ?? ""
        in_terminal_2 = (try? values.decode(String.self, forKey: .in_terminal_2)) ?? ""
        in_terminal_3 = (try? values.decode(String.self, forKey: .in_terminal_3)) ?? ""
        in_agent = (try? values.decode(String.self, forKey: .in_agent)) ?? ""
        path1 = (try? values.decode(String.self, forKey: .path1)) ?? ""
        path2 = (try? values.decode(String.self, forKey: .path2)) ?? ""
        path3 = (try? values.decode(String.self, forKey: .path3)) ?? ""
        path4 = (try? values.decode(String.self, forKey: .path4)) ?? ""
        path5 = (try? values.decode(String.self, forKey: .path5)) ?? ""
        path6 = (try? values.decode(String.self, forKey: .path6)) ?? ""
        path7 = (try? values.decode(String.self, forKey: .path7)) ?? ""
        result = (try? values.decode(String.self, forKey: .result)) ?? ""
        
        db_div = (try? values.decode(String.self, forKey: .db_div)) ?? ""
        seq = (try? values.decode(String.self, forKey: .seq)) ?? ""
        
    }
}


//사업자 계약서 정보
struct Business : Codable {
    var li_idnum: String
    var li_seq: String
    var li_sv_divide: String //서비스 구분(신용카드:1, 가상계좌:2, 계좌이체:3, 휴대폰결제:4)
    var li_company: String //상호명
    var li_bs_divide: String //사업자구분(개인:1, 법인:2)
    var li_admin: String
    var li_bs_num: String
    var li_tel: String
    var li_zipcode: String
    var li_addr1: String
    var li_addr2: String
    var li_cindition: String //업태
    var li_event: String //종목
    var li_re_name: String
    var li_re_birth: String
    var li_re_phone: String
    var li_re_email: String
    var li_bank_name: String
    var li_bank_num: String
    var li_depositor: String //예금주
    var li_state: String
    var li_wdate: String //등록일
    var li_wtime: String //등록시간
    var li_mdate: String //수정일
    var li_mtime: String //수정시간
    var li_note: String //수정이유
    var li_sv_charge: String
    var li_sv_calculate: String
    var li_sv_cost: String
    var li_terminal_1: String = "N" //결제수단
    var li_terminal_2: String = "N" //결제수단
    var li_terminal_3: String = "N" //결제수단
    var li_agent: String //담당자
    var li_name: String //신청인
    var path1: String //약관동의서명1
    var path2: String //약관동의서명2
    var path3: String //신분증
    var path4: String //통장사본
    var path5: String //사업자등록증
    var path6: String //서비스대행사
    var path7: String //완료서명
    var result: String //db결과값 true/false
    
    var db_div: String //db구분(작성중 or 신규)
    var seq: String
    
    private enum CodingKeys: String, CodingKey {
        case li_idnum, li_seq, li_sv_divide, li_company, li_bs_divide, li_admin, li_bs_num, li_tel, li_zipcode, li_addr1, li_addr2, li_cindition, li_event, li_re_name, li_re_birth, li_re_phone, li_re_email, li_bank_name, li_bank_num, li_depositor, li_state, li_wdate, li_wtime, li_mdate, li_mtime, li_note, li_sv_charge, li_sv_calculate, li_sv_cost, li_terminal_1, li_terminal_2, li_terminal_3, li_agent, li_name, path1, path2, path3, path4, path5, path6, path7, result, db_div, seq
    }
    
    init() {
        li_idnum = ""
        li_seq = ""
        li_sv_divide = ""
        li_company = ""
        li_bs_divide = ""
        li_admin = ""
        li_bs_num = ""
        li_tel = ""
        li_zipcode = ""
        li_addr1 = ""
        li_addr2 = ""
        li_cindition = ""
        li_event = ""
        li_re_name = ""
        li_re_birth = ""
        li_re_phone = ""
        li_re_email = ""
        li_bank_name = ""
        li_bank_num = ""
        li_depositor = ""
        li_state = ""
        li_wdate = ""
        li_wtime = ""
        li_mdate = ""
        li_mtime = ""
        li_note = ""
        li_sv_charge = ""
        li_sv_calculate = ""
        li_sv_cost = ""
        li_terminal_1 = ""
        li_terminal_2 = ""
        li_terminal_3 = ""
        li_agent = ""
        li_name = ""
        path1 = ""
        path2 = ""
        path3 = ""
        path4 = ""
        path5 = ""
        path6 = ""
        path7 = ""
        result = ""
        
        db_div = ""
        seq = ""
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        li_idnum = (try? values.decode(String.self, forKey: .li_idnum)) ?? ""
        li_seq = (try? values.decode(String.self, forKey: .li_seq)) ?? ""
        li_sv_divide = (try? values.decode(String.self, forKey: .li_sv_divide)) ?? ""
        li_company = (try? values.decode(String.self, forKey: .li_company)) ?? ""
        li_bs_divide = (try? values.decode(String.self, forKey: .li_bs_divide)) ?? ""
        li_admin = (try? values.decode(String.self, forKey: .li_admin)) ?? ""
        li_bs_num = (try? values.decode(String.self, forKey: .li_bs_num)) ?? ""
        li_tel = (try? values.decode(String.self, forKey: .li_tel)) ?? ""
        li_zipcode = (try? values.decode(String.self, forKey: .li_zipcode)) ?? ""
        li_addr1 = (try? values.decode(String.self, forKey: .li_addr1)) ?? ""
        li_addr2 = (try? values.decode(String.self, forKey: .li_addr2)) ?? ""
        li_cindition = (try? values.decode(String.self, forKey: .li_cindition)) ?? ""
        li_event = (try? values.decode(String.self, forKey: .li_event)) ?? ""
        li_re_name = (try? values.decode(String.self, forKey: .li_re_name)) ?? ""
        li_re_birth = (try? values.decode(String.self, forKey: .li_re_birth)) ?? ""
        li_re_phone = (try? values.decode(String.self, forKey: .li_re_phone)) ?? ""
        li_re_email = (try? values.decode(String.self, forKey: .li_re_email)) ?? ""
        li_bank_name = (try? values.decode(String.self, forKey: .li_bank_name)) ?? ""
        li_bank_num = (try? values.decode(String.self, forKey: .li_bank_num)) ?? ""
        li_depositor = (try? values.decode(String.self, forKey: .li_depositor)) ?? ""
        li_state = (try? values.decode(String.self, forKey: .li_state)) ?? ""
        li_wdate = (try? values.decode(String.self, forKey: .li_wdate)) ?? ""
        li_wtime = (try? values.decode(String.self, forKey: .li_wtime)) ?? ""
        li_mdate = (try? values.decode(String.self, forKey: .li_mdate)) ?? ""
        li_mtime = (try? values.decode(String.self, forKey: .li_mtime)) ?? ""
        li_note = (try? values.decode(String.self, forKey: .li_note)) ?? ""
        li_sv_charge = (try? values.decode(String.self, forKey: .li_sv_charge)) ?? ""
        li_sv_calculate = (try? values.decode(String.self, forKey: .li_sv_calculate))
            ?? ""
        li_sv_cost = (try? values.decode(String.self, forKey: .li_sv_cost))
            ?? ""
        
        li_terminal_1 = (try? values.decode(String.self, forKey: .li_terminal_1)) ?? ""
        li_terminal_2 = (try? values.decode(String.self, forKey: .li_terminal_2)) ?? ""
        li_terminal_3 = (try? values.decode(String.self, forKey: .li_terminal_3)) ?? ""
        li_agent = (try? values.decode(String.self, forKey: .li_agent)) ?? ""
        li_name = (try? values.decode(String.self, forKey: .li_name)) ?? ""
        path1 = (try? values.decode(String.self, forKey: .path1)) ?? ""
        path2 = (try? values.decode(String.self, forKey: .path2)) ?? ""
        path3 = (try? values.decode(String.self, forKey: .path3)) ?? ""
        path4 = (try? values.decode(String.self, forKey: .path4)) ?? ""
        path5 = (try? values.decode(String.self, forKey: .path5)) ?? ""
        path6 = (try? values.decode(String.self, forKey: .path6)) ?? ""
        path7 = (try? values.decode(String.self, forKey: .path7)) ?? ""
        result = (try? values.decode(String.self, forKey: .result)) ?? ""
        
        db_div = (try? values.decode(String.self, forKey: .db_div)) ?? ""
        seq = (try? values.decode(String.self, forKey: .seq)) ?? ""
        
    }
}

//이미지 전송 결과 받기
struct UploadImageResult : Codable {
    var result: String
}
