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
하지만 **기존의 방식대로 코드를 작성하니 은행원 3명이 업무를 보는 것이 아니라**, 은행원 1명이 업무를 끝날때까지 모두가 기다리고. 
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
그래서 저는 메인(은행)에서 업무를 분담해주면, 백그라운드(은행원들)에서 업무를 진행할 수 있도록 `비동기적 처리(Asynchronous)`를 사용하게 되었습니다. 

### 비동기 프로그래밍을 하기위해 무엇을 사용해야할까

이에 대해서 구글링을 해본 결과 `NSThread`, `GCD`, `OperationQueue`의 3가지 방법을 찾아볼 수 있었습니다.

`NSThread`는 멀티스레드 프로그래밍을 위해 애플에서 제공하는 스레드 클래스로, 스레드에 대한 직접 제어를 원하거나 필요로 할 때 사용합니다. 이 방식이 복잡하기때문에 이를 대체하는 방법으로 아래 두 방법이 나왔다고 합니다.

`GCD(Grand Central Dispatch)`는 기본적으로 스레드 풀의 관리를 프로그래머가 아닌 운영체제에서 관리하기 때문에 프로그래머가 작업을 비동기적으로 간편하게 사용할 수 있습니다. 프로그래머가 작업을 생성하고 Dispatch Queue에 추가하면 GCD는 작업에 맞는 스레드를 자동으로 생성해서 실행하고 작업이 종료되면 스레드를 제거합니다. 멀티 코어와 멀티 프로세싱 환경에서 최적화된 프로그래밍을 할 수 있도록 애플이 개발한 기술입니다.

`Operation Queue`는 비동기적으로 실행되어야하는 작업을 객체 지향적인 방법으로 사용합니다. GCD를 기반으로 하고있으며, 동시에 실행할 수 있는 Operation의 최대 수를 설정할 수 있고, Operation를 일시 정지, 다시 시작 및 취소할 수 있습니다. 또한 KVO를 사용할 수 있는 많은 프로퍼티들이 있습니다.

GCD는 Operation Queue처럼 다양한 기능을 할 수는 없지만, 현재 스펙상으로는 작업을 취소하는 등의 기능이 필요하지 않아 GCD를 사용하기로 결정하였습니다.

global Queue와 CustomQueue...?

### 3. Dispatch Group과 세마포어(뮤텍스는 무엇?) 

## 참고 주소

- 🛠 [original repository](https://github.com/jryoun1/ios-bank-manager/tree/step3-lina-develop)

- 📝 [Pull Request && Review](https://github.com/yagom-academy/ios-bank-manager/pulls)
  - [첫번째 PR](https://github.com/yagom-academy/ios-bank-manager/pull/4)
  - [두번째 PR](https://github.com/yagom-academy/ios-bank-manager/pull/15)
  - [세번째 PR](https://github.com/yagom-academy/ios-bank-manager/pull/19)


