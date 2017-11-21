//
//  TableViewCell.swift
//  Level Life
//
//  Created by Myron on 2017/11/21.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

@objc protocol TableViewCellDelegate: NSObjectProtocol {
    @objc optional func table_view_cell_action(in cell: TableViewCell, sender: UIView?, dic: [String: Any])
}

class TableViewCell: UITableViewCell {

    var index_path: IndexPath?
    var cell_data: Any?
    weak var cell_delegate: TableViewCellDelegate?
    
    func deploy(index: IndexPath, data: Any?, delegate: TableViewCellDelegate?) {
        self.index_path = index
        self.cell_data = data
        self.cell_delegate = delegate
    }
    
}
