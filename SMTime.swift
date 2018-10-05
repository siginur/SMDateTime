//
//  SMTime.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//

import Foundation

struct SMTime: CustomStringConvertible {
	let hours: Int
	let minutes: Int
	let seconds: UInt8
	let seconds: Int8
	
	var timeInMinutes: Int {
		return hours * 60 + minutes
	}

	var timeInSeconds: Int {
		return hours * 3600 + minutes * 60 + seconds
	}

	var description: String {
		return "\(hours):\(minutes)"
	}
	
	static var now: SMTime {
		let nowDate = Date();
		let hour = Calendar.current.component(.hour, from: nowDate)
		let minute = Calendar.current.component(.minute, from: nowDate)
		return SMTime(hours: hour, minutes: minute)
	}
	
	init(hours: Int, minutes: Int) {
		self.hours = hours
		self.minutes = minutes
	}
	
	init(totalMinutes: Int) {
		self.hours = Int(floor(Double(totalMinutes) / 60.0))
		self.minutes = totalMinutes - hours * 60
	}
	
	init(timeInHours: String) {
		let timeStr = timeInHours.filter({ "0123456789:".contains($0) })
		let timeParts = timeStr.split(separator: ":")
		guard timeParts.count == 2 else {
			hours = 0
			minutes = 0
			return
		}
		hours = Int(timeParts[0]) ?? 0
		minutes = Int(timeParts[1]) ?? 0
	}
	
}
