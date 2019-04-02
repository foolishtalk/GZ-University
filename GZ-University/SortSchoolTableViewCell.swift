//
//  DistanceTableViewCell.swift
//  GZ-University
//
//  Created by Fidetro on 2019/1/22.
//  Copyright © 2019 karim. All rights reserved.
//

import UIKit
import SnapKit
class SortSchoolTableViewCell: UITableViewCell {
    lazy var leftLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.textAlignment = .right
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        snpLayoutSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: setup view
extension SortSchoolTableViewCell {
    func snpLayoutSubview() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        leftLabel.snp.makeConstraints{
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints{
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
}
