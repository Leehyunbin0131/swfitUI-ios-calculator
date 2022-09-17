//
//  ContentView.swift
//  MyApp
//
//  Created by Lee hyun bin on 2022/08/31.
//

import SwiftUI

enum CalculatorButton: String {
    case zero, one, two, three, four, five, six, seven, eight, nine
    case equals, plus, minus, multiply, divide
    case ac, plusMinus, percent
    case dot
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "X"
        case .plusMinus: return "+/-"
        case .percent: return "%"
        case .equals: return "="
        case .dot: return "."
        case .divide: return "/"
        default:
            return "AC"
        }
    }
    
    var buttonBackGroundColor: Color{ //버튼 색 설정
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return Color(.darkGray)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        default:
            return .orange
        }
    }
}

class GlobalEnvironment: ObservableObject {
    
    @Published var display = "0"
    
    func receiveInput(calculatorButton: CalculatorButton) {
        self.display = calculatorButton.title
    }
}

struct ContentView: View {
    
   @EnvironmentObject var env: GlobalEnvironment
    
    let touchButtons:[[CalculatorButton]] = [ //버튼 배열
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equals],
    ]
    
    var body: some View {
        ZStack (alignment: .bottom){ //정렬 위치 bottom으로
            Color.black.edgesIgnoringSafeArea(.all) //배경색 설정
            VStack(spacing: 20){ //세로정렬 //spacing: 정렬간격
                HStack{//스페이서를 가로 정렬하기 위해 HStack 사용
                    Spacer() //스페이서
                    Text(env.display)
                        .foregroundColor(Color.white)
                        .font(.system(size: 60))
                }.padding() //최적의 간격으로 자동설정
                ForEach(touchButtons, id: \.self){ row in
                    HStack(spacing: 20){ //가로정렬
                        ForEach(row, id: \.self) { i in //i == button
                            CalculatorButotnView(i: i)
                        }
                    }
                }
            }.padding(.bottom) //아래쪽 간격 자동정렬
        }
    }
}

struct CalculatorButotnView: View{
    
    var i: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View{
        Button(action: {
            self.env.receiveInput(calculatorButton: self.i )
        }) {
            Text(i.title)
                .font(.system(size: 40)) //text font size
                .foregroundColor(Color.white) //text color
                //.frame(width: 70, height: 70) //text frame size
                .frame(width: self.touchButtonsWidth(i: i), height: (UIScreen.main.bounds.width - 5 * 20) / 4)
                //self는 인스턴스가 가지고 있는 프로퍼티
                .background(i.buttonBackGroundColor) //text background color
                .cornerRadius(self.touchButtonsWidth(i: i)) //텍스트 프레임 코너지름 설정
        }
    }
    private func touchButtonsWidth(i: CalculatorButton) -> CGFloat{ //문자열을 CGFloat로 변환 //기종에 따라 다른 디스플레이 해상도에 맞게 버튼넒이를 설정
        if i == .zero {
            return (UIScreen.main.bounds.width - 4 * 20) / 4*2
        }
        return (UIScreen.main.bounds.width - 5 * 20) / 4 //디스플레이 해상도에 맞게 버튼넒이를 조정하는 계산 식
        //UIScreen.main.bounds.width: 디스플레이 해상도 넒이 값
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}
