//
//  ShareViewController.swift
//  MeteoLVShare
//
//  Created by Kristaps Grinbergs on 19/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
  
  override func isContentValid() -> Bool {
    return true
  }
  
  override func didSelectPost() {
    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
  }
  
  override func configurationItems() -> [Any]! {
    return []
  }
}
