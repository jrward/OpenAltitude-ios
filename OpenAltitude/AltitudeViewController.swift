//
//  ViewController.swift
//  OpenAltitude
//
//  Created by Jonathan Ward on 7/8/17.
//  Copyright © 2017 Jonathan Ward. All rights reserved.
//

import UIKit

class AltitudeViewController: UIViewController, AltitudeDelegate{
    
    let altitude : Altitude = Altitude.default

    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBAction func altitudeTapped(_ sender: UITapGestureRecognizer) {
        altitude.changeUnits()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        altitudeLabel.text = "Acquiring..."
        altitudeLabel.isUserInteractionEnabled = true
        altitude.delegate = self
        altitude.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(altitude: Int, accuracy: Int, units: AltitudeUnits) {
        let unitsAbbrev : String = units == .feet ? "ft" : "m"
        altitudeLabel.text = "\(altitude) ± \(accuracy) \(unitsAbbrev)"
    }


}

