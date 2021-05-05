
# 아홉번째 프로젝트 - 오픈 마켓

## 프로젝트 정보
- 🗓 기간 : 2021/01/25 ~ 2021/02/07(2w)

- 📝 설명 : 사람들에게 

- 🗂 세부사항
  - 서버와 통신할 수 있는 모델 구현
  - mock 데이터와, mockURLSession을 이용하여 서버가 없는 상태에서도 테스트할 수 있도록 Unit Test 구현
  - 상품 목록을 Segmented Control을 활용해, 테이블뷰와 컬렌션뷰로 구현
  - completionHandler 사용
  

- <img width="250" src="https://user-images.githubusercontent.com/49546979/117136006-bcff6380-ade2-11eb-98df-60e77df05e24.gif">

## 프로젝트 구조



## 프로젝트 이슈

### 1. enum의 String 값 타입 vs CustomStringConvertible
이 전 프로젝트에서는 주로 enum을 정의하고 case에 바로 원시값을 주어서 사용하였습니다.(아래 예시처럼)
```swift
enum Example1: String {
  case test = "TEST"
}
```
하지만 이번 프로젝트에서는 CustomStringConvertible 프로토콜을 채택하고, description을 정의하여 사용해 보았는데요.
```swift
enum Example2: CustomStringConvertible {
     case test
     
     var description: String {
         switch self {
         case .test:
             return "TEST"
         }
      }
}
```
전자와 같은 경우 Test라는 문자열을 얻어오기위해 case의 rawValue로 접근을 해야하는데 ex) print(Example1.test.rawValue) // TEST  
ustomStringConvertible프로토콜을 준수하는 경우 description에 출력하고 싶은 형태를 만들면  
case까지만 접근을 해도 TEST라는 문자열을 받아올 수 있습니다. ex) print(Example2.test)  // TEST  

이것은 기본적으로 Swift의 모든 instance가 String으로 변환이 가능하기 때문인데요.  
이렇게 변환할떄에는, 각 type에 defaultf로 구현된 description을 반환하게 됩니다.  
이 description을 custom하면 원하는대로 출력할 수 있게 되는 것이지요.  



## 참고 주소

- 🛠 [original repository](https://github.com/zziro95/ios-open-market)

- 📝 [Pull Request && Review](https://github.com/yagom-academy/ios-open-market/pulls)
  - [첫번째 PR](https://github.com/yagom-academy/ios-open-market/pull/2)
  - [두번째 PR](https://github.com/yagom-academy/ios-juice-maker/pull/11)
  - [세번째 PR](https://github.com/yagom-academy/ios-juice-maker/pull/22)


