//
//  message.swift
//  SignUpFlow
//
//  Created by 임리나 on 2020/12/02.
//

import Foundation

enum Message: String {
    case existedId = "이미 존재하는 아이디입니다."
    case enterId = "아이디를 입력해주세요."
    case enterPassword = "패스워드를 입력해주세요."
    case disableSignIn = "지금은 로그인 할 수 없습니다."
    case empty = ""
}
