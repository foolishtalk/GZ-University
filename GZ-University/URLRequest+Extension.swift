//
//  URLRequest+Extension.swift
//  GZ-University
//
//  Created by Fidetro on 2019/2/18.
//  Copyright © 2019 karim. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func save( cookies: [HTTPCookie]) {
        let headers = HTTPCookie.requestHeaderFields(with: cookies)
        for (name, value) in headers {
            addValue(value, forHTTPHeaderField: name)
        }
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
}
