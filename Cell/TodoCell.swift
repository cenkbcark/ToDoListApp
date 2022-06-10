//
//  TodoCell.swift
//  WillDo
//
//  Created by Ufuk Köşker on 1.06.2022.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareTodoName(name: String) {
        titleLabel.text = name
    }
    
}
