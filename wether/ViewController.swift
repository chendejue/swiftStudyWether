//
//  ViewController.swift
//  wether
//
//  Created by 陈德爵 on 2017/6/24.
//  Copyright © 2017年 wether. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var curLocation = CLLocation()
    
    
    var city = ""
    
    let key = "b7b7ba24a0d84df79c961fede892c0d5"
    @IBOutlet weak var tqtpIV: UIImageView!
    
    @IBOutlet weak var tbsmLB: UILabel!

    @IBOutlet weak var tqmsLB: UILabel!
    
    @IBOutlet weak var tqxqLB: UILabel!
    
    var wltqt = UIImageView()
    var wltqrq = UILabel()
    var wltqxq = UILabel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        
        GetLocation()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    
    func GetLocation() {
        
        //设置代理
        locationManager.delegate = self
        
        
        //设置定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if #available(iOS 8.0, *) {
            
            //需要时使用定位
            locationManager.requestWhenInUseAuthorization()
            //后台定位
            locationManager.requestAlwaysAuthorization()

        }
        
        //开始进行定位
        locationManager.startUpdatingLocation()
        
    }
    
    //使用系统分析获取到的地理位置的经纬度等信息
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //获取最后一个
        
      //  let location:CLLocation = locations[locations.count-1]
        
         curLocation = locations.last!
        
        
        if curLocation.horizontalAccuracy > 0 {
            //定位成功
            
            
  //          let lat = curLocation.coordinate.latitude
            
  //          let long = curLocation.coordinate.longitude
            
            
            ChangeName() //转换为城市名字
            
            
            //停止定位
            locationManager.stopUpdatingLocation()
        }
        
        //定位不成功的处理方法
        
    }
    
    //经纬度转换为城市相关信息
    
    func ChangeName()  {
        let geocoder:CLGeocoder = CLGeocoder() //初始化一个接受对象
        
//        if let location = curLocation {
        geocoder.reverseGeocodeLocation(curLocation) { (placemark, error) in
            
            if error == nil {
                
                
                let array = placemark! as NSArray
                
                let mark = array.firstObject as! CLPlacemark
                
                //获取城市
                
                let city = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                self.city = city
                
//                self.test()
                self.GetWether()
            
            }else{
                print(error ?? "未知的错误")
            }
        }
       // }
        
    }
    
    
    //测试
    func test()  {
        print(city + "main")

    }
    
    //获取数据
    func GetWether() {
        Wether.Request(city: self.city, key: self.key) { (wether) in
            
            self.tbsmLB.text = self.city + "今天天气预报"
            self.tqtpIV.image = UIImage(named: wether.nowCondCode)
            self.tqmsLB.text = wether.nowCondTxt
            self.tqxqLB.text = wether.nowTmp + "°   " + wether.nowWindDir + "   " + wether.nowWindSc + "级"
            
            var i = 200
            
            for daily in wether.daily_forecast {
                
                let j  = i
                //查找未来天气的相关放置点
                self.wltqt = self.view.viewWithTag(j+1) as! UIImageView
                self.wltqt.image = UIImage(named: daily.condCodeD)
                self.wltqrq = self.view.viewWithTag(j+2) as! UILabel
                self.wltqrq.text = daily.date
                self.wltqxq = self.view.viewWithTag(j+3) as! UILabel
                self.wltqxq.text = daily.condTxtD + "\n" + daily.tmpMin + "°-" + daily.tmpMax + "°"
                
                i = i + 100
                
                
            }
        }
    }

}

