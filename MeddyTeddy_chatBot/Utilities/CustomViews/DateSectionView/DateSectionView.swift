//
//  DateSectionView.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import UIKit

class DateSectionView: UITableViewHeaderFooterView {
    @IBOutlet weak var lblDateHeader: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.white
    }

}
