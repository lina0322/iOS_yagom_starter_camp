### 첫번째 프로젝트 - 묵찌빠
🗓 기간 : 2020/11/03 ~ 2020/11/04(2d)

📝 설명 : 컴퓨터와 묵찌빠 게임하는 프로그램 만들기(console app)

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

### 처음 구현하고자 했던 것(mukchibaGame.swfit)

1. 가위바위보 게임구현(비겼을 때는 자동으로 다시!)
2. 가위바위보 게임을 이용한 묵찌빠 구현
   
   
### 첫번째 리팩토링 시도(re_mukchibaGame.swift)

1. 직관적이지 않은 변수, 함수 이름 등을 최대한 직관적으로 하려고 노력함
2. 나만 알아보는게 아니라, 다른 사람들 혹은 3년 후에 나도 알아볼 수 있도록 노력함
3. enum을 사용해서 만들어봄
4. 전역변수를 사용함


### 두번째 리팩토링 시도(re_re_mukchibaGame.swift)

1. 전역변수를 사용하지 않기 위해, 클래스로 구현해봄
2. 좀 더 함수를 잘게 쪼개어봄

