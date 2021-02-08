## ⛺️iOS_yagom_stater_camp
저는 이 repository에 2020년 11월부터 2021년 4월까지(예정) 이루어진, [yagom ios 스타터 캠프](https://yagom.net/ios-starter-camp-2nd/)에 1기로 참여하여 학습한 내용을 정리하였습니다.

### 📖목차

[첫번째 프로젝트 - 묵찌빠](#첫번째-프로젝트---묵찌빠)

[두번째 프로젝트 - 웹 브라우저](#두번째-프로젝트---웹-브라우저)

[세번째 프로젝트 - 주스 메이커](#세번째-프로젝트---주스-메이커)

[네번째 프로젝트 - 회원가입](#네번째-프로젝트---회원가입)

[다섯번째 프로젝트 - 계산기](#다섯번째-프로젝트---계산기)

[여섯번째 프로젝트 - 만국박람회](#여섯번째-프로젝트---만국박람회)

[일곱번째 프로젝트 - 은행 창구 매니저](#일곱번째-프로젝트---은행-창구-매니저)

[여덟번째 프로젝트 - 날씨정보](#여덟번째-프로젝트---날씨정보)

[아홉번째 프로젝트 - 오픈 마켓](#아홉번째-프로젝트---오픈-마켓)

---

### 첫번째 프로젝트 - 묵찌빠
🗓 기간 : 2020/11/03 ~ 2020/11/04(2d)

📝 설명 : 컴퓨터와 묵찌빠 게임(console app)

<img width="300" src="https://user-images.githubusercontent.com/49546979/107147258-5fe54480-6990-11eb-8e09-ad96901fa484.png">
<img width="300" src="https://user-images.githubusercontent.com/49546979/107147255-5c51bd80-6990-11eb-89e4-693f6e598b5b.png">

🗂 세부사항
- enum과 enum의 rawValue 사용
- class 구현
- if let과 guard let의 사용

📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2020_11_04_mukchibaGame)

🖇 해당 주차 TIL
- git 명령어,  git pull request : [2020_11_03](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_03.md)

</br>

### 두번째 프로젝트 - 웹 브라우저
🗓 기간 : 2020/11/09 ~ 2020/11/13(5d)

📝 설명 : WKWebView을 사용한 웹 브라우저 app

<img width="300" src="https://user-images.githubusercontent.com/49546979/107150699-78f6f100-69a2-11eb-9e87-af8669304bbe.gif">

🗂 세부사항
- WKWebView(goBack, goForward, reload 등) 사용
- 정규식을 사용하여 URL주소의 유효성 검증
- alert 사용

📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2020_11_13_webBrowser)

🖇 해당 주차 TIL
-  H.I.G(textView와 textField의 차이), 전역변수 단점 : [2020_11_09](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_09.md)
-  타입, 정규표현식 : [2020_11_09](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_12.md)
-  OOP의 특징 : [2020_11_09](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_13.md)

</br>

### 세번째 프로젝트 - 주스 메이커
🗓 기간 : 2020/11/16 ~ 2020/11/29(2w)

📝 설명 : 맛있는 주스를 만들고, 재고 관리까지 해주는 app

<img width="600" src="https://user-images.githubusercontent.com/49546979/107152042-266d0300-69a9-11eb-8842-3eac77a01067.gif">

🗂 세부사항
- 읽기전용 프로퍼티 사용
- enum의 연산프로퍼티 사용
- CustomStringConvertible 프로토콜을 활용하여 enum의 description 구현
- Dictionary 사용
- 예외처리(throws, do-catch, try) 사용
- Error 프로토콜을 채택한 enum 구현
- typealias 사용 
- 싱글턴 사용
- stepper 사용

📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2020_11_29_juiceMaker)

🖇 해당 주차 TIL
- struct와 class, 값타입과 참조타입, 프로퍼티, 디자인패턴, 솔리드원칙 : [2020_11_16](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_16.md)
- Access control : [2020_11_17](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_17.md)
- if vs guard : [2020_11_19](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_19.md)
- init vs 프로퍼티 직접 초기화 : [2020_11_23](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_23.md)
- KVO, 노티피케이션 센터 : [2020_11_26](https://github.com/lina0322/iOS_yagom_starter_camp/blob/main/TIL/2020_11/2020_11_26.md)

</br>

### 네번째 프로젝트 - 회원가입
🗓 기간 : 2020/11/30 ~ 2020/12/06(1w)

📝 설명 : 

<img width="300" src="">

🗂 세부사항
- 

📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2020_12_06_signUpFlow)

🖇 해당 주차 TIL
-  : []()

</br>

### 다섯번째 프로젝트 - 계산기
🗓 기간 : 2020/12/07 ~ 2020/12/20(2w)

📝 설명 : 

<img width="300" src="">

🗂 세부사항
- 

📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2020_12_20_calculator)

🖇 해당 주차 TIL
-  : []()

</br>

### 여섯번째 프로젝트 - 만국박람회
🗓 기간 : 2020/12/21 ~ 2021/12/27(1w)

📝 설명 : 

<img width="300" src="">

🗂 세부사항
- 
📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2021_01_03_exposition)

🖇 해당 주차 TIL
-  : []()

</br>

### 일곱번째 프로젝트 - 은행 창구 매니저
🗓 기간 : 2021/01/04 ~ 2021/01/17(2w)

📝 설명 : (console app)

<img width="300" src="">

🗂 세부사항
- 
📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2021_01_17_bankManager)

🖇 해당 주차 TIL
-  : []()

</br>

### 여덟번째 프로젝트 - 날씨정보
🗓 기간 : 2021/01_18 ~ 2012/01/24(1w)

📝 설명 : 

<img width="300" src="">

🗂 세부사항
- 
📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/2021_01_24_weatherForecast)

🖇 해당 주차 TIL
-  : []()

</br>

### 째 프로젝트 - 오픈 마켓
🗓 기간 : 

📝 설명 : 

<img width="300" src="">

🗂 세부사항
- 
📎 [해당 폴더로 이동](https://github.com/lina0322/iOS_yagom_starter_camp/tree/main/)

🖇 해당 주차 TIL
-  : []()

</br>
