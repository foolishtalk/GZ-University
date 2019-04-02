//
//  UINavigationItem+Extension.swift
//  UINavigationItem+Extension
//
//  Created by Fidetro on 2018/9/25.
//  Copyright © 2018 kt. All rights reserved.
//

import UIKit

enum NavigationItemsOrientation {
    case left
    case right
}

extension UINavigationItem {
    private convenience init(_ left:[Any]?,center _:Any? = nil,_ right:[Any]?) {
        self.init()
        if let items = left {
            setupNavigationItem(items: items, orientation: .left)
        }
        if let items = right {
            setupNavigationItem(items: items, orientation: .right)
        }
    }
    func setupNavigationItem(items:[Any],
                             orientation:NavigationItemsOrientation,
                             actions:[Selector?]? = nil,
                             target:AnyObject? = nil) {
        var buttonItems = [UIBarButtonItem]()
        for (index,element) in items.enumerated() {
            let action = actions?[index]
            switch element {
            case let element as UIButton:
                if let action = action {
                    element.addTarget(target, action: action, for: .touchUpInside)
                }
                let item = UIBarButtonItem.init(customView: element)
                buttonItems.append(item)
            case let element as UIView:
                let item = UIBarButtonItem.init(customView: element)
                buttonItems.append(item)
            case var element as UIImage:
                element = element.withRenderingMode(.alwaysOriginal)
                let item = UIBarButtonItem.init(image: element, style: .plain, target: nil, action: nil)
                item.action = action
                item.target = target
                buttonItems.append(item)
            case let element as String:
                let item = UIBarButtonItem.init(title: element, style: .plain, target: nil, action: nil)                
                item.action = action
                item.target = target
                buttonItems.append(item)
            case  let element as UIBarButtonItem:
                element.action = action
                element.target = target
                buttonItems.append(element)
            case  let element as Int:
                let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceItem.width = CGFloat(element)
                buttonItems.append(spaceItem)
            case  let element as Float:
                let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceItem.width = CGFloat(element)
                buttonItems.append(spaceItem)
            case  let element as CGFloat:
                let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceItem.width = CGFloat(element)
                buttonItems.append(spaceItem)
            case  let element as Double:
                let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceItem.width = CGFloat(element)
                buttonItems.append(spaceItem)
            default:
                break
                
            }
        }
        if orientation == .left {
            self.leftBarButtonItems = buttonItems
        }else{
            self.rightBarButtonItems = buttonItems
        }
        
    }
    private func initBaseButton() -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .selected)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}
