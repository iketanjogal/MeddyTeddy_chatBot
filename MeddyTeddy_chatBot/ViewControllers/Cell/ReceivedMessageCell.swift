//
//  ReceivedMessageCell.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import UIKit

class ReceivedMessageCell: UITableViewCell {

    @IBOutlet weak var lblRecieverMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var constMemberDetailedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memeberDetailedView: UIView!
    
    //MARK:-  private variable
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func setupCell(message: ChatMessage) {
        
        lblRecieverMessage.text = message.message
        //lblName.text = message.senderName
        //lblTimeStamp.text = timeStringFromUnixTime(unixTime: Double(message.createdAt ?? 0))
    }
    

}
