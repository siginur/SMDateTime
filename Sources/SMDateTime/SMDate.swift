//
//  SMDate.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

import Foundation

/**
Date structure
*/
public struct SMDate: Hashable, Codable {
	
	// MARK: - Static Members
	
	/// Yesturday date
    public static var yesturday: SMDate {
        SMDate(date: Date(timeIntervalSinceNow: -86400))
    }

	/// Today date
    public static var today: SMDate {
        SMDate(date: Date())
    }
	
	/// Tomorrow date
    public static var tomorrow: SMDate {
        SMDate(date: Date(timeIntervalSinceNow: 86400))
    }
	
	/// Current weekday
    public static var weekday: Weekday! {
        today.weekday
    }

	
	
	// MARK: - Members
	
	/// Hours. Greater than `0`
	public var year: Int
	
	/// Month. Range: `0...11`
	public var month: Int {
		didSet {
			month = max(min(month, 11), 0)
		}
	}
	
	/// Month. Range: `1...31`
	public var day: Int {
		didSet {
			day = max(min(day, 31), 1)
		}
	}
	
	
	
	// MARK: - Calculatable Members
	
	/// `Weekday` of the date
	public var weekday: Weekday! {
		let weekDay = Calendar.current.component(.weekday, from: date!)
		return Weekday(rawValue: weekDay)
	}
	
	/// `Date` object
	public var date: Date! {
		let calendar = Calendar.current
		let components = DateComponents(calendar: calendar, year: year, month: month, day: day)
		return calendar.date(from: components)
	}
	
	/// Unix Timestamp in seconds
	public var timestamp: Int {
		return Int(date.timeIntervalSince1970)
	}
	
	/// Check if self date is yesturday
	public var isYesturday: Bool {
		return self == SMDate.yesturday
	}
	
	/// Check if self date is today
	public var isToday: Bool {
		return self == SMDate.today
	}
	
	/// Check if self date is tomorrow
	public var isTomorrow: Bool {
		return self == SMDate.tomorrow
	}
	
	/// Check if self date is on this month
	public var isThisMonth: Bool {
		let today = SMDate.today
		return self.month == today.month && self.year == today.year
	}
	
	/// Check if self date is on this month
	public var isThisYear: Bool {
		return self.year == SMDate.today.year
	}
	
	
	
	// MARK: - Initializations
	
	/**
	Constructor.
	Create `SMDate` object based on extracted `.day`, `.month` and `.year` components from the current `Calendar`
	
	- Parameter date: `Date` object
	*/
	public init(date: Date) {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
		self.year = components.year ?? 0
		self.month = components.month ?? 0
		self.day = components.day ?? 0
	}
	
	
	/**
	Constructor.
	Create `SMDate` object based on timestamp
	
	- Parameter timestamp: Unix Timestamp in seconds
	*/
	public init(timestamp: Int) {
		self.init(date: Date(timeIntervalSince1970: TimeInterval(timestamp)))
	}
	
	
	/**
	Constructor.
	Create `SMDate` object based on `.day`, `.month` and `.year` values
	
	- Parameters:
		- year:		Date year.
		- month:	Date month.
		- day:		Date day.
	- Requires: `year >= 0`
	- Requires: `month >= 0. month <= 11`
	- Requires: `day >= 1. day <= 31`
	*/
	public init(year: Int, month: Int, day: Int) {
		self.year = year
		self.month = month
		self.day = day
	}
	
	
	/**
	Constructor.
	Create `SMDate` object based on parsed specified string and format
	
	- Parameters:
		- string: Source string that should be parsed.
		- format: Format of the date.
		- locale: Date locale. `default` value is `.current`
		- timeZone: Time Zone. `default` value is `.current`
	 */
	public init?(string: String, format: SMDateTime.Format, locale: Locale? = .current, timeZone: TimeZone? = .current) {
		 let formatter = DateFormatter()
		 formatter.dateFormat = format.rawValue
		 formatter.locale = locale
		 formatter.timeZone = timeZone
		 self.init(string: string, formatter: formatter)
	}
	
	
	/**
	 Constructor.
	 Create `SMDate` object based on parsed specified string and format.
	 
	 - Parameters:
	 	- string: Source string that should be parsed.
	 	- formatter: Date formatter
	*/
	public init?(string: String, formatter: DateFormatter) {
		guard let date = formatter.date(from: string) else {
			return nil
		}
		self.init(date: date)
	}
	
	
	
	// MARK: - Methods
	
	/**
	 Generate readable `String` from members
	
	 - Parameters:
	 	- format:	Date format to represent date
		- locale:   Locale
		- timeZone:	Time Zone. `default` value is `.current`
		- labels:		One or more `StringLabel` that can be used for more readable result. `default` value is `[]`
	 - Returns: Readable `String` generated from members
	 */
	public func string(format: SMDateTime.Format, locale: Locale? = .current, timeZone: TimeZone? = .current, labels: SMDate.StringLabel = []) -> String {
		if labels.contains(.yesturday) && isYesturday {
			return "Yesturday"
		} else if labels.contains(.today) && isToday {
			return "Today"
		} else if labels.contains(.tomorrow) && isYesturday {
			return "Tomorrow"
		}
		let formatter = DateFormatter()
		formatter.dateFormat = format.rawValue
		formatter.locale = locale
		formatter.timeZone = timeZone
		return formatter.string(from: date)
	}
	
	
	/**
	Date of the next day
	
	- Returns: `Date` of the next day
	*/
	public func nextDay(count: Int = 1) -> SMDate {
		let nextDate = Calendar.current.date(byAdding: .day, value: count, to: date)!
		return SMDate(date: nextDate)
	}
	

	/**
	Date of the previous day
	
	- Returns: `Date` of the previous day
	*/
	public func prevDay(count: Int = 1) -> SMDate {
		let prevDate = Calendar.current.date(byAdding: .day, value: -count, to: date)!
		return SMDate(date: prevDate)
	}
	

	/**
	Date to be in N months
	
	- Parameter count: Number of months to add
	- Returns: `Date`by adding N months
	*/
	public func nextMonth(count: Int = 1) -> SMDate {
		let nextDate = Calendar.current.date(byAdding: .month, value: count, to: date)!
		return SMDate(date: nextDate)
	}
	

	/**
	Date that was N months ago
	
	- Parameter count: Number of months to substract
	- Returns: `Date`by subtracting N months
	*/
	public func prevMonth(count: Int = 1) -> SMDate {
		let prevDate = Calendar.current.date(byAdding: .month, value: -count, to: date)!
		return SMDate(date: prevDate)
	}
	
	
	/**
	Date of the next specific weekday
	
	- Returns: `Date` of the next weekday
	*/
	public func next(_ weekday: Weekday) -> SMDate {
		let calendar = Calendar.current
		let nextDateComponent = DateComponents(weekday: weekday.rawValue)
		let resultDate = calendar.nextDate(after: date,
										   matching: nextDateComponent,
										   matchingPolicy: .nextTime,
										   direction: .forward)
		return SMDate(date: resultDate!)
	}
	
	
	/**
	Date of the previous specific weekday
	
	- Returns: `Date` of the previous weekday
	*/
	public func prev(_ weekday: Weekday) -> SMDate {
		let calendar = Calendar.current
		let nextDateComponent = DateComponents(weekday: weekday.rawValue)
		let resultDate = calendar.nextDate(after: date,
										   matching: nextDateComponent,
										   matchingPolicy: .nextTime,
										   direction: .backward)
		return SMDate(date: resultDate!)
	}
	
}



// MARK: - Mathematic Operations

extension SMDate {
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	Started date
		- rhs:	Duration that would be added to time
	
	- Returns:
		Date with added duration
	*/
	public static func + (lhs: SMDate, rhs: SMDuration) -> SMDate {
		let timestamp = lhs.timestamp + rhs.totalSeconds
		return SMDate(timestamp: timestamp)
	}
	
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	Duration that would be added to time
		- rhs:	Started date
	
	- Returns:
		Date with added duration
	*/
	public static func + (lhs: SMDuration, rhs: SMDate) -> SMDate {
		let timestamp = lhs.totalSeconds + rhs.timestamp
		return SMDate(timestamp: timestamp)
	}
	
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	Source date
		- rhs:	Duration that would be added
	*/
	public static func += (lhs: inout SMDate, rhs: SMDuration) {
		let timestamp = lhs.timestamp + rhs.totalSeconds
		lhs = SMDate(timestamp: timestamp)
	}

	
	/**
	'Minus' mathematic operator.
	
	- Parameters:
		- lhs:	Source date
		- rhs:	Duration that would be subtracted
	
	- Returns:
		Date with subtracted duration
	*/
	public static func - (lhs: SMDate, rhs: SMDuration) -> SMDate {
		let timestamp = lhs.timestamp - rhs.totalSeconds
		return SMDate(timestamp: timestamp)
	}
	
}



// MARK: - Enums and OptionsSets

extension SMDate {
	
	/**
	Weekday. Contain all 7 days of the week
	*/
	public enum Weekday: Int {
		/// Sunday
		case sunday		= 1
		/// Monday
		case monday		= 2
		/// Tuesday
		case tuesday	= 3
		/// Wednesday
		case wednesday	= 4
		/// Thursday
		case thursday	= 5
		/// Friday
		case friday		= 6
		/// Saturday
		case saturday	= 7
	}
	
	/**
	String Label. Literal options to represent date in readable form
	*/
	public struct StringLabel: OptionSet {
		
		public let rawValue: Int
		
		/// Used when date equal to yesturday date
		public static let yesturday = StringLabel(rawValue: 1 << 0)
		/// Used when date equal to today date
		public static let today	= StringLabel(rawValue: 1 << 1)
		/// Used when date equal to tomorrow date
		public static let tomorrow = StringLabel(rawValue: 1 << 2)
		
		/// All available labels
		public static let all: StringLabel = [.yesturday, .today, .tomorrow]

		public init(rawValue: Int) {
			self.rawValue = rawValue
		}
		
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



// MARK: - Identifiable Protocol

extension SMDate: Identifiable {
	
	public var id: Int {
		return (year * 100 + month) * 100 + day
	}
	
}



// MARK: - Formatter Extension

public extension DateFormatter {
	
	func string(from date: SMDate) -> String {
		self.string(from: date.date)
	}
	
	func smDate(from string: String) -> SMDate? {
		guard let date = self.date(from: string) else {
			return nil
		}
		return SMDate(date: date)
	}
	
}
