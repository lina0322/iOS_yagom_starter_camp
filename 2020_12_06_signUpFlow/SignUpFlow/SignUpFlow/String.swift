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
    case disableSignIn = "아이디, 비밀번호를 확인해주세요."
    case wrongNumber = "전화번호를 확인해주세요."
    case empty = ""
}

enum ImageSelect: String {
    case album = "앨범에서 선택"
    case camera = "카메라로 촬영"
    case cancel = "취소"
}
