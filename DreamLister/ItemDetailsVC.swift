//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Ismail Hossain on 2017-08-02.
//  Copyright © 2017 Ismail Hossain. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }

    }

}
