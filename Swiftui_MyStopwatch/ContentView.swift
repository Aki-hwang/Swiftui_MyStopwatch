//
//  ContentView.swift
//  Swiftui_MyStopwatch
//
//  Created by Chuljin Hwang on 2022/01/29.
//

import SwiftUI

struct ContentView: View {
    @State private var time : Double = 0
    
    var humanReadableTime: String{ //인트때는 % 가능하지만 더블등은 다른함수가 요구대
        let sec = Int(time) % 60
        
        let min = Int(time) / 60
        let mili = time.truncatingRemainder(dividingBy: 1) //소수점만 남기게 하기 위해서 time % 1 을 위와 같이 표시
        let miliString = String(format: "%.2f", mili).split(separator: ".").last ?? "0"
        //점을 기준으로 자르고 마지막 값만 가저올꺼야
        
        return "\(String(format: "%02d",min))" + ":" + "\(String(format: "%02d",sec))" + ":" + "\(miliString)"
    } //정수 두자리 하려면 %02d
    
    
    @State private var isStart = false
    var timer = Timer.publish(every:0.1, on: .current, in: .default).autoconnect()// every 이벤트 발생단위
    
    var body: some View {
        VStack{
            ZStack{
                ClockTick()
                ClockNumber()
                SecondHand(sec: time)
                Minhand(sec: time)
                CenterCircle()
                MilliClockTick()
                    .offset(y:40)
                Millihand(sec: time)
                    .offset(y:40)
                CenterCircle()
                    .offset(y:40)
            }
            .onReceive(timer, perform: { _ in //타임 발생을 위해
                withAnimation { //값을 변경하는 부분에 에니메이션을 적용하면 된다
                    if isStart{ //트루일때만 증가}
                    self.time += 0.1
                  }
                }
            })
            StartButton(isStart: $isStart)
                .offset(y:120)
            Text(humanReadableTime)
                .offset(y:130)
                .font(.largeTitle)
        }
       
     
    }
}

struct StartButton: View{
    @Binding var isStart : Bool
    var body: some View{
        HStack(spacing : 0){
            Button(action: {  // <<이런 구조로 해야 버튼 전체를 모두 누를수 있어
                isStart = true
            }, label: {
                Text("Start")
                    .font(.largeTitle)
                    .frame(width:UIScreen.main.bounds.size.width / 2, height: 50)
                    .background(Color.pink.opacity(0.5))
                    .cornerRadius(10)
                    
            })
            Button(action: {
                isStart = false
            }, label: {
                Text("Stop")
                    .font(.largeTitle)
                    .frame(width:UIScreen.main.bounds.size.width / 2, height: 50)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(10)
                   
            })
            
            
            
//            Button("Start"){  <<얘는 스트링 부문만 클릭만되거든
//                isStart = true
//            } .frame(width:UIScreen.main.bounds.size.width / 2, height: 50)
//                .background(Color.pink.opacity(0.5))
//            Button("Stop"){
//                isStart = false
//            }.frame(width:UIScreen.main.bounds.size.width / 2, height: 50)
//                .background(Color.green.opacity(0.5))
        }
        
    }
    
}
struct CenterCircle: View{
    var body: some View{
        Circle()
            .fill(Color.blue)
            .frame(width: 10, height: 10)
            
    }
}

struct ClockTick: View{
    var body: some View{
        let tickCount = 60
        ZStack{
            ForEach(0..<tickCount){ tick in
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 1, height: tick % 5 == 0 ? 20 : 10)
                    .offset(y:100)
                    .rotationEffect(.degrees(Double(tick) / Double(tickCount) * 360))
            }
            
        }
    }
}

struct ClockNumber: View{
    var tickCount = 60
    var body: some View{
        ZStack{
            ForEach(0..<tickCount){ tick in
                ZStack{
                    Text(tick % 5 == 0 ? "\(tick)" : "")// 글자 모양을 똑바로 하려고 2번 설정
                        .rotationEffect(.degrees(Double(tick) / Double(tickCount) * -360))
                }
                .offset(y:-120)
                .rotationEffect(.degrees(Double(tick) / Double(tickCount) * 360))
            }
        }
        
    }
}

//바늘 만들기
struct SecondHand: View{
    private var sec : Double
    private var height: CGFloat = 80
    init(sec:Double){ //프라이빗 쓰려면 이니셜라이즈 해야해
        self.sec = sec
    }
    var body: some View{
        Rectangle()
            .fill(Color.black)
            .frame(width: 3, height: height)
            .offset(y: -height / 2)
            .rotationEffect(.degrees( sec / 60 * 360))
    }
}

struct Minhand: View{
    private var sec  : Double
    init(sec:Double){ //프라이빗 쓰려면 이니셜라이즈 해야해
        self.sec = sec
    }
    private var height: CGFloat = 60
    var body: some View{
        Rectangle()
            .fill(Color.blue)
            .frame(width: 3, height: height)
            .offset(y: -height / 2)
            .rotationEffect(.degrees( sec  / 60 / 60 * 360))
    }
}
 
struct Millihand: View{
    private var sec  : Double
    init(sec:Double){ //프라이빗 쓰려면 이니셜라이즈 해야해
        self.sec = sec
    }
    private var height: CGFloat = 30
    var body: some View{
        Rectangle()
            .fill(Color.orange)
            .frame(width: 3, height: height)
            .offset(y: -height / 2)
            .rotationEffect(.degrees( sec / 60 * 60 * 360))
    }
    
}
struct MilliClockTick: View{
    var body: some View{
        let tickCount = 10
        ZStack{
            ForEach(0..<tickCount){ tick in
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1, height: tick % 5 == 0 ? 5 : 5)
                    .offset(y:30)
                    .rotationEffect(.degrees(Double(tick) / Double(tickCount) * 360))
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
