//
//  ContentView.swift
//  Calculator
//
//  Created by mac os on 2020/9/19.
//  Copyright © 2020 mac os. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let num9t7 = ["9","8","7","*"]
    let num6t4 = ["6","5","4","-"]
    let num3t1 = ["3","2","1","+"]
    let char1 = ["C","+/-","%","/"]
    
    @State var text:String = ""
    
    var body: some View {
        //Text("Hello, World!")
        ZStack{
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack {
                TextField("",text: $text)
//                    .frame(width:400,height: 100)
//                    .background(Color.white)
                    .frame(width: 360, height: 80, alignment: .leading)
                    .padding(.leading)
                    .font(.system(size: 50))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 4)
                            .foregroundColor(.black)
                  )
                ZStack{
                    VStack{
                        HStack {
                            ForEach(0..<char1.count){ index in
                                NumberView(text:self.$text, number:self.char1[index])
                            }
                        }
                        HStack {
                            ForEach(0..<num9t7.count){ index in
                                NumberView(text:self.$text, number:self.num9t7[index])
                            }
                        }
                        HStack {
                            ForEach(0..<num6t4.count){ index in
                                NumberView(text: self.$text,number:self.num6t4[index])
                            }
                        }
                        HStack {
                            ForEach(0..<num3t1.count){ index in
                                NumberView(text:self.$text ,number:self.num3t1[index])
                            }
                        }
                        HStack{
                            NumberView(text:$text ,number: "0").position(x: 145, y: 50)
                            NumberView(text:$text ,number: "=").position(x: 128, y: 50)
                        }
                    }
                    .position(x: 180, y: 380)
                }
            }
        }
    }
}



struct NumberView : View {
    @Binding var text : String
    
    @State var color:Color = Color.black
    
    @State var number:String
    
    var body: some View{
        ZStack{
            Circle()
                .frame(width:80, height:80)
                .foregroundColor(color)
            Text(number)
                .foregroundColor(Color.orange)
                .font(.system(size: 50))
            .onTapGesture(perform: {
                withAnimation(.easeInOut(duration: 0.3)){
                    self.color = Color.gray
                }
                withAnimation(.default){
                    self.color = Color.black
                }
                
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                
                if(self.number == "C"){
                    self.text = ""
                }else if(self.number == "+/-"){
                    
                }else if(self.number == "="){
//                    self.text = String(Plus(numberToPlus: OrganizeNum(numberToOrganize: self.text)))
                    self.text = String( Plus(numberToPlus: Multiply(numberToMultiply: OrganizeNum(numberToOrganize: self.text) ) ) )
                }else{
                    self.text.append(self.number)
                }
            })
        }.shadow(color:Color.black,radius: 3)
    }
}

func OrganizeNum(numberToOrganize : String) -> Array<String>{
    var numberString : String = ""
    var finalString : [String] = []
    
    for scalar in numberToOrganize.unicodeScalars{
        if(Int(scalar.value)-48 <= 9 && Int(scalar.value)-48 >= 0){
            let ret = String.init(scalar)
            numberString.append(ret)
        }else{
            finalString.append(numberString)
            let symbol = String.init(scalar)
            finalString.append(symbol)
            numberString.removeAll()
        }
    }
    finalString.append(numberString)
    numberString.removeAll()
    
    print(finalString)
    
    return finalString
}

func Plus(numberToPlus:Array<String>)->Int{
    var sum:Int = 0
    
    var model:Int = 1
    
    for num in numberToPlus{
        if(num != "+" && num != "-"){
            if(model == 1){
                sum += Int(num) ?? 0
            }else{
                sum -= Int(num) ?? 0
            }
        }else{
            if(num == "+"){
                model = 1
            }else{
                model = 0
            }
        }
    }
    
    return sum
}

func Multiply(numberToMultiply : Array<String>) -> Array<String>{
    var doneMultiply : Array<String> = []
    
    let express = numberToMultiply
    
    var unused : String = ""
    
    var temp = 0
    
    for num in express{
        if(num == "*"){
            let cnt1 = express[(express
                .lastIndex(of: num) ?? 0) + 1]
            print(cnt1)
            temp = (Int(doneMultiply.last ?? "0") ?? 1) * Int(cnt1)!
            
            doneMultiply.removeLast()
            
//            express.remove(at: (express
//            .lastIndex(of: num) ?? 0)+1)
            unused.append(express[(express
                        .lastIndex(of: num) ?? 0)+1])
            
            doneMultiply.append(String.init(temp))
        }else if(num == "/"){
            let cnt2 = express[(express
            .lastIndex(of: num) ?? 0) + 1]
            
            temp = (Int(doneMultiply.last ?? "0" ) ?? 1) / Int(cnt2)!
            
            doneMultiply.removeLast()
            
//            express.remove(at: express
//            .lastIndex(of: num) ?? 0 + 1)
            unused.append(express[(express
            .lastIndex(of: num) ?? 0)+1])
            
            doneMultiply.append(String.init(temp))
        }else{
            if(unused.contains(num)){
                
            }else{
                doneMultiply.append(num)
            }
            
        }
        
    }
    
    
    
    return doneMultiply
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
