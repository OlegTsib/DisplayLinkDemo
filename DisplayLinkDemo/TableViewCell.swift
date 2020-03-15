//
//  TableViewCell.swift
//  DisplayLink
//
//  Created by Oleg Tsibulevskiy on 14/03/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//

import UIKit
import DisplayLink

class TableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayLinkTick(_:)), name: DisplayLink.notificationName, object: nil)
    }

    @objc private func displayLinkTick(_ sender: NSNotification)
    {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss"
        
        dateLabel.text = df.string(from: d)
    }
}
