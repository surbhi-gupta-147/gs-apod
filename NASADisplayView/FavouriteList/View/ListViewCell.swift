//
//  ListViewCell.swift
//  NASADisplayView
//

import Foundation

import UIKit

class ListViewCell: UITableViewCell {
    
    //**************************************************
    // MARK: - Outlets
    //**************************************************

    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    //**************************************************
    // MARK: - LifeCycle Methods
    //**************************************************
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        selectionStyle = .none
        dateLabel.sizeToFit()
        titleLabel.sizeToFit()
    }
    
}
