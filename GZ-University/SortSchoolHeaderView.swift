//
//  SortSchoolHeaderView.swift
//  GZ-University
//
//  Created by Fidetro on 2019/3/11.
//  Copyright © 2019 karim. All rights reserved.
//

import UIKit

class SortSchoolHeaderView: UITableViewHeaderFooterView {

    static let height = CGFloat(40)
    
    var clickAction:((_ sender: PickerViewButton)->())? = nil
    
    lazy var pickerBtn: PickerViewButton = {
        var view = PickerViewButton.init(dataSource: [["distance","varScore"]], detailSource: [["距离","分数"]])
        view.addTarget(self, action: #selector(selectPickAction(_:)), for: .touchUpInside)
        view.setTitle("排序", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        snpLayoutSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectPickAction(_ sender: PickerViewButton) {
        sender.becomeFirstResponder()
        if let clickAction = clickAction {
            clickAction(sender)
        }
    }
    
    func snpLayoutSubview() {
        contentView.addSubview(pickerBtn)
        pickerBtn.snp.makeConstraints{
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(100)
        }
    }
}
