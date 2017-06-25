//
//  Setting.swift
//  Weather
//
//  Created by Neat Ouk on 6/25/17.
//  Copyright © 2017 Veasna Ouk. All rights reserved.
//

import Foundation
import UIKit

class Setting: UIViewController {
    @IBOutlet weak var tvCity: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tvCity.text=UserDefaults.standard.string(forKey: "city")
        
    }
    @IBAction func setCity(_ sender: Any) {
        UserDefaults.standard.set(tvCity.text,forKey: "city")
        self.dismiss(animated: true, completion: nil)
    }
}
