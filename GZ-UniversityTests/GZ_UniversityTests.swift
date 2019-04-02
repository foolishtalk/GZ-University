//
//  GZ_UniversityTests.swift
//  GZ-UniversityTests
//
//  Created by Fidetro on 2019/1/16.
//  Copyright © 2019 karim. All rights reserved.
//

import XCTest
@testable import GZ_University

class GZ_UniversityTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    
    func testExample() {
        let expect = expectation(description: "爬虫")
        let urlString = "https://data-gkcx.eol.cn/soudaxue/queryProvinceScore.html?messtype=jsonp&callback=jQuery18305411070348048146_1550483337014&provinceforschool=%E5%B9%BF%E4%B8%9C&schooltype=&page=2&size=37&keyWord=&schoolproperty=&schoolflag=&province=%E5%B9%BF%E4%B8%9C&fstype=%E7%90%86%E7%A7%91&zhaoshengpici=&fsyear=2017&_=1550483340487"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: configuration)
        
        var  request = URLRequest.init(url: URL.init(string: urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        
        request.allHTTPHeaderFields = ["DNT":"1",
                                       "Referer":"https://gkcx.eol.cn/soudaxue/queryProvinceScore.html?&studentprovince=%E5%B9%BF%E4%B8%9C&fstype=%E7%90%86%E7%A7%91&province=%E5%B9%BF%E4%B8%9C&page=7&schoolyear=2017",
                                       "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"]
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data,let str = String(data: data, encoding: .utf8),let first = str.firstPosition(of: "(") {
                
                print("str.from(first)")
                
                do{
                    if let last = str.subString(first+1, to: str.count-3)!.data(using: .utf8) {
                        let json = try JSONSerialization.jsonObject(with: last, options: .allowFragments)
                        print(json)
                        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                        try! last.write(to: URL.init(fileURLWithPath: documentDirectory+"/test.json"))
                        print(documentDirectory+"/test.json")
                    }
                }catch{
                    print(error)
                }
                
            }
            expect.fulfill()
            
        }
        task.resume()
        wait(for: [expect], timeout: 20)
        
    }
        
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
