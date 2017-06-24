//
//  WetherService.swift
//  wether
//
//  Created by 陈德爵 on 2017/6/24.
//  Copyright © 2017年 wether. All rights reserved.
//

import Foundation
import Moya

enum WetherService {
    case weather(city:String,key:String)
   // case now(city:String,key:String)
}

extension WetherService: TargetType{
    
    var baseURL: URL{
        return URL(string: "https://free-api.heweather.com/v5/")!
    }
    var path:String{
        return "weather"
    }
    var method: Moya.Method{
        return .get
    }
    
    var parameters: [String:Any]?{
        
        switch self {
        case .weather(let city,let key):
            return ["city": city,"key": key]
        }
    }
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return "获取成功".utf8Encoded
    }
    
    var task: Task {
        return .request
    }

    
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
