//
//  SMDate.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

public struct SMDate {
	
	// MARK: - Static Members
	
	public static var today = SMDate(date: Date())
	
	// MARK: - Members
	
	public var year: Int
	public var month: Int {
		didSet {
			month = max(min(month, 11), 0)
		}
	}
	public var day: Int {
		didSet {
			day = max(min(day, 30), 0)
		}
	}
	
	// MARK: - Calculatable Members
	
	public var dayOfWeek: DayOfWeek! {
		let weekDay = Calendar.current.component(.weekday, from: date!)
		return DayOfWeek(rawValue: weekDay)
	}
	
	public var date: Date! {
		let calendar = Calendar.current
		let components = DateComponents(calendar: calendar, year: year, month: month, day: day)
		return calendar.date(from: components)
	}
	
	public var timestamp: Int {
		return Int(date.timeIntervalSince1970)
	}
	
	
	// MARK: - Initializations
	
	public init(date: Date) {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
		self.year = components.year ?? 0
		self.month = components.month ?? 0
		self.day = components.day ?? 0
	}
	
	public init(timestamp: Int) {
		self.init(date: Date(timeIntervalSince1970: TimeInterval(timestamp)))
	}
	
//	init(date: String) {
//		let dateParts = date.split(separator: "-")
//		guard dateParts.count == 3 else {
//			day = 0
//			month = 0
//			year = 0
//			return
//		}
//		day = Int(dateParts[0]) ?? 0
//		month = Int(dateParts[1]) ?? 0
//		year = Int(dateParts[2]) ?? 0
//	}
	
}

// MARK: - Mathematic Operations

extension SMDate {
	
	public static func + (lhs: SMDate, rhs: SMDuration) -> SMDate {
		let timestamp = lhs.timestamp + rhs.durationInSeconds
		return SMDate(timestamp: timestamp)
	}
	
	public static func + (lhs: SMDuration, rhs: SMDate) -> SMDate {
		let timestamp = lhs.durationInSeconds + rhs.timestamp
		return SMDate(timestamp: timestamp)
	}

	public static func - (lhs: SMDate, rhs: SMDuration) -> SMDate {
		let timestamp = lhs.timestamp - rhs.durationInSeconds
		return SMDate(timestamp: timestamp)
	}
	
}

// MARK: - Enums

extension SMDate {
	
	public enum DayOfWeek: Int {
		case monday		= 1
		case tuesday	= 2
		case wednesday	= 3
		case thursday	= 4
		case friday		= 5
		case saturday	= 6
		case sunday		= 7
	}

}

// MARK: - Equatable & Comparable Protocols

extension SMDate: Equatable, Comparable {
	
	public static func < (lhs: SMDate, rhs: SMDate) -> Bool {
		if lhs.year != rhs.year {
			return lhs.year < rhs.year
		} else if lhs.month != rhs.month {
			return lhs.month < rhs.month
		} else {
			return lhs.day < rhs.day
		}
	}
	
}

// MARK: - Description Protocol

extension SMDate: CustomStringConvertible {
	
	public var description: String {
		return "\(day).\(month).\(year)"
	}
	
}
