//
//  ForecastViewController.swift
//  Weather
//
//  Created by Neat Ouk on 6/25/17.
//  Copyright © 2017 Veasna Ouk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ForecastViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCity: UILabel!
    var array: JSON = []
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEEE"
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllRooms(city: UserDefaults.standard.string(forKey: "city")!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forcastCell:ForecastCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ForecastCell!
        let imageURL="http://openweathermap.org/img/w/"+(array[indexPath.row]["weather"][0]["icon"].stringValue)+".png"
       
        Alamofire.request(imageURL).responseData{ response in
            forcastCell.ivWeather.image = UIImage(data: response.result.value!, scale:1)
        }
        let min: Int = Int(array[indexPath.row]["temp"]["min"].double!-273.15)
        forcastCell.lblMin.text = "\(min)C"
        let max: Int = Int(array[indexPath.row]["temp"]["max"].double!-273.15)
        forcastCell.lblMax.text="\(max)C"
        let dow = Date(timeIntervalSince1970: array[indexPath.row]["dt"].double!)
        let day = dateFormatter.string(from: dow)
        forcastCell.lblDay.text=day
        return forcastCell;
    }
    
    open func fetchAllRooms(city: String)  {
        let url="http://api.openweathermap.org/data/2.5/forecast/daily?q="+city+"&appid=2330a0a3fb5310a0e90f5ef6dd89aac1"
        Alamofire.request(url)
            .responseJSON { response in
                
                var json = JSON(response.result.value!)
                self.lblCity.text="Weekly forecast for "+json["city"]["name"].stringValue+", "+json["city"]["country"].stringValue
                self.array=json["list"]
                
                self.tableView.reloadData()
                
                
        }
    }
}
