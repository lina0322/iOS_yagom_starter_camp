
# 아홉번째 프로젝트 - 오픈 마켓

## 프로젝트 정보
- 🗓 기간 : 2021/01/25 ~ 2021/02/07(2w)

- 📝 설명 : 판매할 물건을 등록하고, 사람들의 물건을 리스트와 그리드 뷰로 구경하며, 비밀번호를 아는 게시물은 삭제도 할 수 있는 앱 🧺

- 🗂 세부사항
  - HTTP 서버와 통신할 수 있는 모델 구현(CURD)
  - mock 데이터와, mockURLSession을 이용하여 서버가 없는 상태에서도 테스트할 수 있도록 Unit Test 구현
  - 상품 목록을 Segmented Control을 활용해, 테이블뷰와 컬렌션뷰로 구현
  - 스토리보드와 코드를 모두 사용하여 UI 구현
  - completionHandler 사용
  - CustomStringConvertible 프로토콜 채택하여 description 구현
  - 제네릭 사용
  

- <img width="250" src="https://user-images.githubusercontent.com/49546979/117136006-bcff6380-ade2-11eb-98df-60e77df05e24.gif">

## 프로젝트 구조

![UML](https://user-images.githubusercontent.com/49546979/117167308-1a56dd00-ae02-11eb-8614-2462252402cd.png)


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
이렇게 변환할때에는, 각 type에 defaultf로 구현된 description을 반환하게 된다고 합니다.  
결국 이 description을 custom하면 원하는대로 출력할 수 있게 되는 것이지요.  

### 2. LocalizedError
위와 비슷한 이유로 아래의 오류 코드도 CustomStringConvertible을 채택하여 작성 하였는데요.
```swift
enum OpenMarketError: Error, CustomStringConvertible {
     case wrongURL
     
     var description: String {
         switch self {
         case .wrongURL:
             return "잘못된 URL입니다."
         }
      }
}
```

리뷰를 받고 LocalizedError라는 프로토콜을 알게 되었습니다.   
이 프로토콜은 오류와 오류가 발생한 이유를 설명하는 현지화 된 메시지를 제공하는 특수 오류라고 [공식 문서](https://developer.apple.com/documentation/foundation/localizederror)에 정의되어 있는데요.    
기본적으로 에러와 관련된 내용을 전달할 수 있게 프로퍼티를 이미 가지고 있으므로(errorDescription, failureReason, helpAnchor, recoverySuggestion)   
에러에는 CustomStringConvertible보다는 LocalizedError를 사용하는게 맞다고 판단하여, 아래와 같이 변경하게 되었습니다.  

```swift
enum OpenMarketError: Error {
     case wrongURL
}
 
extension OpenMarketError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongURL:
            return "잘못된 URL입니다."
        }
    }
}
```

### 3. mock값을 이용하여 네트워킹 테스트 하기
decodeData 함수 안에서는 네트워크 코드를 테스트 하면서  
실제로 네트워킹을 통해 이뤄지기 때문에 속도도 느리고,  
인터넷 연결을 끊고 테스트를 실행하게 당연히 실패하는 문제가 발생한다는 문제를 알게 되었습니다.     
이럴때는 네트워킹을 하는게 아니라 로컬에서 mock값을 이용해 테스트를 할 수 있다고 해서, 도전해 보았습니다.

우선 `URLSessionProtocol`을 만들었는데요.  
제가 URLSession을 사용할 곳에서, 원래 존재하는 `URLSession`과 저의 `MockURLSession` 중에 사용할 수 있게 하기위해. 
기존의 `URLSession`과 저의 `MockURLSession` 모두 해당 프로토콜을 채택하도록 합니다.  
(두 클래스가 반드시 가지고 있어야할 것은 dataTask 메서드이기에, 프로토콜 내부에 이 부분만 선언해주었습니다.)    

```swift
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { } // 기존 URLSession에 URLSessionProtocol 채택

class MockURLSession: URLSessionProtocol { } // 테스트 용으로 만든 URLSessionProtocol에 URLSessionProtocol 채택

```

아래처럼 실제 네트워크를 다루는 `NetworkHandler` 타입의 구조체를 생성할때, `MockURLSession`을 주입할 수 있게 됩니다.

```swift
struct NetworkHandler {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}
```

그리고 나서 아까 만든 MockURLSession가 작동할 수 있도록 메서드를 구현하였고, 이 후에 성공이냐 실패냐에 따라 다르게 생성될 수 있도록 추가하였습니다.  
(하단에는 중요한 부분만 작성하였습니다.)  

```swift
class MockURLSession: URLSessionProtocol {
    var isSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?
    var apiRequestType: APIRequestType
    var data: Data {
            return MockAPI.test.sampleItems.data
        }
    }
    
    init(isSuccess: Bool = true, apiRequestType: APIRequestType = APIRequestType.loadPage(page: 1)) {
        self.isSuccess = isSuccess
        self.apiRequestType = apiRequestType
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                              statusCode: 410,
                                              httpVersion: "2",
                                              headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.isSuccess {
                completionHandler(self.data, successResponse, nil)
            } else {
                completionHandler(nil, failureResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}

```

해당 코드를 작성하는데에는 [우아한 형제들의 기술 블로그](https://woowabros.github.io/swift/2020/12/20/ios-networking-and-testing.html)를 참고하였습니다.


### 정리해야할 이슈들 
Segmented Control
complition Handler
Content-Disposition: form-data
제네릭
콜렉션뷰
NSCache
LayoutConstraint - 잘못된 레이아웃 제약 
로딩셀 + 스크롤
import Foundation

## 참고 주소

- 🛠 [original repository](https://github.com/zziro95/ios-open-market)

- 📝 [Pull Request && Review](https://github.com/yagom-academy/ios-open-market/pulls)
  - [첫번째 PR](https://github.com/yagom-academy/ios-open-market/pull/2)
  - [두번째 PR](https://github.com/yagom-academy/ios-open-market/pull/10)
  - [세번째 PR](https://github.com/yagom-academy/ios-open-market/pull/18)


