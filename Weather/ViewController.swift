//
//  ViewController.swift
//  Weather
//
//  Created by Veasna Ouk on 6/25/17.
//  Copyright © 2017 Veasna Ouk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var lblTempurature: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.string(forKey: "city")==nil {
            self.performSegue(withIdentifier: "setting", sender: nil)
        }
        else {fetchAllRooms(UserDefaults.standard.string(forKey: "city")!)}
    }
    
    
    open func fetchAllRooms(_ city: String)  {
        let url="http://api.openweathermap.org/data/2.5/weather?q="+city+"&appid=2330a0a3fb5310a0e90f5ef6dd89aac1"
        Alamofire.request(url)
            .responseJSON { response in
                
                var json = JSON(response.result.value)
                var weather=json["weather"][0].dictionary
                var temperature=json["main"].dictionary
                let visibility=json["visibility"].int
                let windSpeed=json["wind"]["speed"].double
                var misc=json["sys"].dictionary
                let cityFull=json["name"].stringValue
                
                let temp=temperature?["temp"]?.double
                let imageURL="http://openweathermap.org/img/w/"+(weather?["icon"]?.stringValue)!+".png"
                Alamofire.request(imageURL).responseData{ response in
                    self.ivWeather.image = UIImage(data: response.result.value!, scale:1)
                }
                self.lblTempurature.text="\(temp!-273.15)C"
                self.lblCity.text=cityFull+", "+(misc?["country"]?.stringValue)!
                self.lblDescription.text=weather?["description"]?.stringValue
                self.lblStatus.text=weather?["main"]?.stringValue
                
                let sunriseEpoch = Date(timeIntervalSince1970: (misc?["sunrise"]?.double!)!)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "HH:mm"
                let sunrise = dateFormatter.string(from: sunriseEpoch)
                
                self.lblSunrise.text=sunrise
                let sunsetEpoch = Date(timeIntervalSince1970: (misc?["sunset"]?.double!)!)
                let sunset = dateFormatter.string(from: sunsetEpoch)
                self.lblSunset.text=sunset
                let hum=temperature?["humidity"]?.int
                self.lblHumidity.text="\(hum!)%"
                self.lblWind.text="\(windSpeed!) mps"
                self.lblVisibility.text="\(visibility!/1000) km"
                
                
        }
    }

    @IBAction func gotoSetting(_ sender: Any) {
    }
}

