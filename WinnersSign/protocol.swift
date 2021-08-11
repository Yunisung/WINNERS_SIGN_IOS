//
//  protocol.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/13.
//

import Foundation

//ViewController 간에 데이터 전송
protocol SignProtocol {
    func SignData(fileName: String, data: Array<UInt8>)
}

protocol AddressProtocol {
    func AddressData(address1: String, address2: String, address_Building: String)
}
