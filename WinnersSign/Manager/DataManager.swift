//
//  DataManager.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/07.
//

import UIKit

class DataManager {
    static let instance = DataManager()
    private init() {}
    
    var sessionMember: SessionMb = SessionMb(mb_id: "", mb_idnum: "", mb_name: "")
    
    var myinfo: MyInfo = MyInfo(mb_idnum: "", mb_id: "", mb_name: "", mb_phone: "", mb_email: "", mb_pw: "")
    
    //var individual: Individual = Individual(in_idnum: "", in_seq: "", in_name: "", in_rrn: "", in_phone: "", in_company: "", in_admin: "", in_zipcode: "", in_addr1: "", in_addr2: "", in_tel: "", in_bank_name: "", in_bank_num: "", in_depositor: "", in_state: "", in_wdate: "", in_wtime: "", in_mdate: "", in_mtime: "", in_note: "", in_sv_company: "", in_sv_charge: "", in_sv_calculate: "", in_sv_bs_num: "", in_agent: "", path1: "", path2: "", path3: "", path4: "", path5: "", path6: "", path7: "", result: "", db_div: "", seq: "")
    
    //var individual = Individual(from: "")
    var individual: Individual = Individual()
    var business: Business = Business()
    
    //var business: Business = Business(li_idnum: "", li_seq: "", li_sv_divide: "", li_company: "", li_bs_divide: "", li_admin: "", li_bs_num: "", li_tel: "", li_zipcode: "", li_addr1: "", li_addr2: "", li_cindition: "", li_event: "", li_re_name: "", li_re_birth: "", li_re_phone: "", li_re_email: "", li_bank_name: "", li_bank_num: "", li_depositor: "", li_state: "", li_wdate: "", li_wtime: "", li_mdate: "", li_mtime: "", li_note: "", li_sv_charge: "", li_sv_calculate: "", li_agent: "", li_name: "", path1: "", path2: "", path3: "", path4: "", path5: "", path6: "", path7: "", result: "", db_div: "", seq: "")
    
    
    var isMyinfoPw: Bool = false // 회원정보수정 확인
    
    
    func resetSessionMember() {
        sessionMember.mb_id = ""
        sessionMember.mb_idnum = ""
        sessionMember.mb_name = ""
    }
}
