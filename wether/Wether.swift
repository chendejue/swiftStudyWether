//
//  Wether.swift
//  wether
//
//  Created by 陈德爵 on 2017/6/24.
//  Copyright © 2017年 wether. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

struct Wether:Mappable {
    
    var nowCondCode: String!
    var nowCondTxt: String!
    var nowTmp: String!
    var nowWindDir: String!
    var nowWindSc: String!
    var daily_forecast:[Dailyforecast]!





    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        nowCondCode <- map["HeWeather5.0.now.cond.code"]
        nowCondTxt <- map["HeWeather5.0.now.cond.txt"]
        nowTmp <- map["HeWeather5.0.now.tmp"]
        nowWindDir <- map["HeWeather5.0.now.wind.dir"]
        nowWindSc <- map["HeWeather5.0.now.wind.sc"]
        daily_forecast <- map["HeWeather5.0.daily_forecast"]




    }
    
}
struct Dailyforecast:Mappable {
    var condCodeD: String!
    var condTxtD: String!
    var date:String!
    var tmpMax:String!
    var tmpMin:String!

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        condCodeD <- map["cond.code_d"]
        condTxtD <- map["cond.txt_d"]
        date <- map["date"]
        tmpMax <- map["tmp.max"]
        tmpMin <- map["tmp.min"]

    }
    
    
    
}


//封装扩展

extension Wether{
    //通过网络请求获取分类
    //由于网络请求的相关函数和普通的不太一样,因为,网络请求会有网络延时,所以,网络请求不能有明确的返回值,可以使用闭包来实现.有请求回来在执行闭包用@escaping来进行修饰
    static func Request(city:String , key:String , completion: @escaping (Wether)->Void)  {
        
        let provider = MoyaProvider<WetherService>() //定义一个泛型的provider对象
        
        provider.request(.weather(city: city, key: key)) { (returnData) in
            
            //返回的数据处理
            switch returnData {
                
            case let .success(returnData):
                
                let jsonData = try! returnData.mapJSON() as![String: Any]
                
                if let wether = Wether(JSON: jsonData){
                    
                
                    completion(wether)
                    
                }
                
                break
            case .failure:
                print("请求出错")
                break
                
            }
            
            
        }
        
        
        
    }

}
