
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

### 4. 잘못된 레이아웃 수정하기

테이블뷰 셀을 코드로 구현하면서 아래와 같은 레이아웃 오류가 발생하게 되었습니다.
<img width="700" src="https://user-images.githubusercontent.com/33537899/106461177-c2919880-64d7-11eb-8f84-05a8d1d677d7.png">

당시에 [Why The Failure, Auto Layout?](https://www.wtfautolayout.com)이라는 사이트에 해당 오류를 넣어보니, 아래와 같은 그림을 볼 수 있었습니다.
<img width="700" src="https://cdn.discordapp.com/attachments/772758139274919947/805814783805751417/2021-02-01_10.07.57.png">

그림을 살펴보면, 이미지 뷰에 이미 **높이**를 넓이와 1:1로 주었는데  
또 다시 이미지뷰의 top과 bottom을 지정해주면 중복으로 **높이**가 잡힌다는 문제가 발생한다는 것을 알 수 있었습니다.

위치를 위해 top은 그대로 두고, bottom을 잡아주는 코드를 삭제하여 모호한 오토 레이아웃 오류를 수정하게 되었습니다.

[👉 해당 커밋](https://github.com/yagom-academy/ios-open-market/pull/10/commits/3cd47aed1ff9bd6279f2294dc6b678bd9471cc15)


### 5. Launch srceen이 멈춘 것 처럼 보이는 문제

처음 이 부분을 고민하게 된 배경은 네트워크 통신에 걸리는 `시간`이 문제였습니다.  
서버와의 통신하는데 시간이 오래걸리면, 첫 테이블뷰의 데이터가 채워지는데 시간이 오래 걸리게 되는 문제가 발생할 수 있는데요.  
그래서 처음에는 테이블 뷰 화면에 인디케이터를 띄우려고 했습니다.  
하지만 무언가 인디케이터의 사이즈도 작고, 눈에 잘 띄지 않을 것 같아서   

[H.I.G](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/launch-screen/)에서 아래와 같은 문구를 참고하여,    
`Launch screen`과 똑같이 생긴 `Launch View Controller`에서 로딩이 완료된 후에 `OpenMarket View Controller`에 들어가게되는 구조를 만들게 되었습니다.   

```
**Design a launch screen that’s nearly identical to the first screen of your app.**  
If you include elements that look different when the app finishes launching, 
people can experience an unpleasant flash between the launch screen and the first screen of the app. 
```

그러다보니 만약 불러와야할 데이터의 양이 많아지면, 사용자가 `Launch View Controller`에 오랜시간 머무르게 되는데요.  
그래서 이 경우 사용자는 앱이 동작되고 있는지 의심하게 될 수도 있다는 리뷰를 받게 되었습니다.  

결과적으로 이 부분을 해결하기 위해 `Launch View Controller`에서 인디케이터를 사용하게 되었습니다.

<img width="150" alt="스크린샷 2021-02-01 23 13 44" src="https://user-images.githubusercontent.com/49546979/106471919-7b120900-64e5-11eb-92ca-a64c3622e7f6.png">


하지만 차후에 리뷰어들과 이야기를 나눠본 결과, 위에서 제가 이야기했던 H.I.G에 나온 이야기는 아래와 같은 스켈레톤 뷰에 대한 이야기일 것이라는 의견을 듣게 되었습니다.  

<img width="150" src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbWNgxr%2FbtqUfZsBiu7%2F7nFGh3EGpg8tioeeplLTQ0%2Fimg.gif">

> 출처: https://icksw.tistory.com/173
 
비록 현재는 수정하지 못했지만, 기회가 된다면 위와 같이 스켈레톤 뷰를 활용하여 사용자에게 로딩중임을 표현하는 것이 더욱 좋을 것 같다는 생각이 들었습니다.  

### 6. 얼마만큼의 데이터를 한번에 로드하는 것이 좋을까?

화면을 구현하면서 얼마만큼의 데이터를 한 번에 가지고 오는 것이 좋을지에 대해 고민하게 되었습니다.  
서버에는 이미 100개 이상의 상품이 준비되어있었고, 새로운 상품을 올릴 수도 있는 상태였습니다.  
또한 서버에서도 1페이지씩(상품 20개씩) 데이터를 내려주었기 때문에, 처음에 모든 데이터(모든 페이지)를 가져오는 것은 좋지 못한 동작이라고 생각이 되었습니다.  
그래서 첫 페이지에 20개의 상품을 보여주고, 스크롤을 내려서 맨 마지막 셀이 보였을 때 더 가져올 데이터가 있다면 추가로 가져오는 방식으로 구현하게 되었습니다.  

<img width="150" alt="스크린샷 2021-02-01 22 30 09" src="https://user-images.githubusercontent.com/49546979/106472024-9bda5e80-64e5-11eb-933c-20900482f343.png"><img width="150" alt="스크린샷 2021-02-01 22 30 00" src="https://user-images.githubusercontent.com/49546979/106472029-9d0b8b80-64e5-11eb-8687-a02f9b87f776.png">
<img width="150" alt="스크린샷 2021-02-02 20 45 02" src="https://user-images.githubusercontent.com/49546979/106595905-9d645f00-6597-11eb-994e-72c4b7833478.png"><img width="150" alt="스크린샷 2021-02-02 20 45 07" src="https://user-images.githubusercontent.com/49546979/106595907-9e958c00-6597-11eb-9600-6dc99f9478f1.png">

> 전 2개 이미지: 불러올 데이터가 있을 때, 후 2개 이미지: 불러올 데이터가 더 이상 없을 때

테이블뷰와 컬렉션뷰에서 각각 위 이미지 처럼 동작하게 구현하였고,  
런치 스크린에서 인디케이터를 사용한 것과 마찬가지로  
데이터를 불러올때 혹시라도 잠깐의 멈춤이 있다면, 이를 사용자가 앱의 정지라고 느끼지 않도록 하기 위해서 로딩셀을 구현하였습니다.


### 정리해야할 이슈들. 
Segmented Control
complition Handler
Content-Disposition: form-data
제네릭
콜렉션뷰
NSCache
import Foundation

## 참고 주소

- 🛠 [original repository](https://github.com/zziro95/ios-open-market)

- 📝 [Pull Request && Review](https://github.com/yagom-academy/ios-open-market/pulls)
  - [첫번째 PR](https://github.com/yagom-academy/ios-open-market/pull/2)
  - [두번째 PR](https://github.com/yagom-academy/ios-open-market/pull/10)
  - [세번째 PR](https://github.com/yagom-academy/ios-open-market/pull/18)


