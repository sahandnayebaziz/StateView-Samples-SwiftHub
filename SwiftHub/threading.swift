//
//  threading.swift
//  thewaves
//
//  Created by Sahand Nayebaziz on 9/16/14.
//  Copyright (c) 2014 Sahand Nayebaziz. All rights reserved.
//

import Foundation

func dispatch_to_background_queue(block: @escaping (()->Void)) {
    DispatchQueue.global().async {
        block()
    }
}

func dispatch_to_main_queue(block: @escaping (()->Void)) {
    DispatchQueue.main.async {
        block()
    }
}
