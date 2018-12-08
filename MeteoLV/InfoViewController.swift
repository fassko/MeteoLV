//
//  InfoViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/03/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, Storyboarded {
  
  @IBOutlet weak var infoTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    //swiftlint:disable line_length
    infoTextView.text = """
      Weather Latvia shows current weather observations in Latvia. Data comes from Latvian Environment, Geology and Meteorology Centre and Latvian State Roads.
    
      App is maintained by Kristaps Grinbergs and open sourced at https://github.com/fassko/MeteoLV
    """
    infoTextView.accessibilityLabel = "Description"
  }
}
