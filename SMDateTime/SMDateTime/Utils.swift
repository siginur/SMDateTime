//
//  Utils.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

import Foundation

internal func devideAndFloor(value: Int, devider: Int) -> Int {
	return Int(floor(Double(value) / Double(devider)))
}

internal func devideAndRound(value: Int, devider: Int) -> Int {
	return Int(round(Double(value) / Double(devider)))
}

internal func devideAndCeil(value: Int, devider: Int) -> Int {
	return Int(ceil(Double(value) / Double(devider)))
}
