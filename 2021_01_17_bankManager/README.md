# 일곱번째 프로젝트 - 은행 창구 매니저

## 프로젝트 정보
- 🗓 기간 : 2021/01/04 ~ 2021/01/17(2w)

- 📝 설명 : 은행을 개점하면 10~30명의 고객이 방문한다! 고객 등급과 업무에 따라 은행원과 본사가 재빠르게 일처리를 하는 콘솔앱 🏦

- 🗂 세부사항
  - 

- <img width="250" src="https://user-images.githubusercontent.com/49546979/117671143-72ffee80-b1e3-11eb-981f-8863778b72bf.gif">

## 프로젝트 구조

![UML](https://user-images.githubusercontent.com/49546979/117694761-78b4fe80-b1fa-11eb-9479-52eda923c2b6.png)


## 프로젝트 이슈

### 어떻게하면 은행원 3명이 동시에 업무를 볼수있을까

처음에는 은행원 1명으로 코드를 작성하였습니다. 이때는 은행원이 1명이고, 고객을 1명씩 순차적으로 처리하면 되었기 때문에 큰 문제가 없었습니다.
그런데 은행원이 3명이 되면서 각각의 은행원들이 자신의 업무를 보아야하는 상황 다시말해, `3명이 동시에 업무를 처리해야하는 상황`이 발생하였습니다.
하지만 기존의 방식대로 코드를 작성하니 은행원 3명이 업무를 보는 것이 아니라, 은행원 1명이 업무를 끝날때까지 모두가 기다리고
은행원 1의 업무가 끝나서 돌아오면, 또 다시 은행원 1이 업무를 보게 되는 상황이 생겼습니다.
해당 코드는 아래와 같습니다. (처음에 구현했던 방식을 제가 다시 추측, 간소화해서 작성한 것이라 조금 다를 수 있습니다!)
```swift

import Foundation

class Teller {
    var windowNumber: Int
    var isWorking = false
    
    init(windowNumber: Int) {
        self.windowNumber = windowNumber
    }
    
    func doBusiness(for client: Int) {
        isWorking = true
        print("\(windowNumber)번 은행원이 \(client)번 고객을 위해 업무를 시작합니다.")
        Thread.sleep(forTimeInterval: 3)
        print("\(windowNumber)번 은행원이 \(client)번 고객의 업무를 완료하였습니다.")
        isWorking = false
    }
}

func bankBusiness(clientCount: Int) {
    let firstTeller = Teller(windowNumber: 1)
    let secondTeller = Teller(windowNumber: 2)
    let thirdTeller = Teller(windowNumber: 3)
    let tellers = [firstTeller, secondTeller, thirdTeller]
    
    var client = 1
    while client <= clientCount {
        for teller in tellers {
            if teller.isWorking == false {
                teller.doBusiness(for: client)
                client += 1
                break
            }
        }
    }
}

bankBusiness(clientCount: 10)
```

위 코드를 실행하면, 아래와 같이 동작하게 됩니다.😂

<img width="250" src="https://user-images.githubusercontent.com/49546979/118225297-d3cb4780-b4bf-11eb-99bc-6fe32db67c54.gif">

왜 이렇게 동작하는걸까요?

보통 프로그래밍에서 코드의 실행은 작성된 코드의 위에서 부터 아래로 진행됩니다.
이처럼 코드가 위에서부터 아래로 내려오며 하나가 끝나면 다음 코드가 실행되는 방식을 `동기적 처리(Synchronous)`라고 합니다.
하지만, 이렇게 하나의 코드가 끝나기를 기다리면 은행원들은 3명이 동시에 일을 할 수 없게됩니다!
그래서 저는 메인 스레드(은행)에서 업무를 분담해주면, 각각의 스레드들(은행원들)이 업무를 진행할 수 있도록 `비동기적 처리(Asynchronous)`를 사용하게 되었습니다. 

### 비동기 프로그래밍은 어떻게 하는걸까



### 3. Dispatch Group과 세마포어(뮤텍스는 무엇?) 

## 참고 주소

- 🛠 [original repository](https://github.com/jryoun1/ios-bank-manager/tree/step3-lina-develop)

- 📝 [Pull Request && Review](https://github.com/yagom-academy/ios-bank-manager/pulls)
  - [첫번째 PR](https://github.com/yagom-academy/ios-bank-manager/pull/4)
  - [두번째 PR](https://github.com/yagom-academy/ios-bank-manager/pull/15)
  - [세번째 PR](https://github.com/yagom-academy/ios-bank-manager/pull/19)


