//
//  MyTableView.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 25/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit

class MyTableView: UITableView {
    
    override func reloadData() {
        let offset = contentOffset
        super.reloadData()
        contentOffset = offset
    }
}
