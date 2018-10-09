//
//  SMDate.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//


/**
Date structure
*/
public struct SMDate: Codable {
	
	// MARK: - Static Members
	
	/// Yesturday date
	public static var yesturday = SMDate(date: Date(timeIntervalSinceNow: -86400))

	/// Today date
	public static var today = SMDate(date: Date())
	
	/// Tomorrow date
	public static var tomorrow = SMDate(date: Date(timeIntervalSinceNow: 86400))
	
	/// Current weekday
	public static var weekday = today.weekday

	
	
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
	Create `SMDate` object based on parsed specified string and format
	
	- Parameters:
		- string: Source string that should be parsed by specified `format` in next parameter
		- format: Format of the date ('DateFormatter')
	*/
	public init?(string: String, format: String) {
		let formatter = DateFormatter()
		formatter.dateFormat = format
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
		- labels:	One or more `StringLabel` that can be used for more readable result
	- Returns: Readable `String` generated from members
	*/
	public func string(format: String, labels: StringLabel = []) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: date)
	}
	
	
	/**
	Date of the next day
	
	- Returns: `NSDate` of the next day
	*/
	public func nextDay() -> SMDate {
		let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
		return SMDate(date: nextDate)
	}
	

	/**
	Date of the previous day
	
	- Returns: `NSDate` of the previous day
	*/
	public func prevDay() -> SMDate {
		let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
		return SMDate(date: prevDate)
	}
	
	
	/**
	Date of the next specific weekday
	
	- Returns: `NSDate` of the next weekday
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
	
	- Returns: `NSDate` of the previous weekday
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
