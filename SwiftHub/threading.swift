//
//  threading.swift
//  thewaves
//
//  Created by Sahand Nayebaziz on 9/16/14.
//  Copyright (c) 2014 Sahand Nayebaziz. All rights reserved.
//

import Foundation

func dispatch_to_background_queue(block: dispatch_block_t?) {
    let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(q, block!)
}

func dispatch_to_main_queue(block: dispatch_block_t?) {
    dispatch_async(dispatch_get_main_queue(), block!)
}