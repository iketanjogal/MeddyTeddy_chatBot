//
//  SendMessageCell.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import UIKit

class SendMessageCell: UITableViewCell {

    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(message: ChatMessage) {
        lblMessageText.text = message.message
    }

}
