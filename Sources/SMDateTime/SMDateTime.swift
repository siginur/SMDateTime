//
//  SMDateTime.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 10/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

import Foundation

/**
DateTime structure
*/
public struct SMDateTime: Hashable, Codable {
	
	// MARK: - Private Members
	
	private var _date: SMDate
	private var _time: SMTime
	
	
	
	// MARK: - Static Members
	
	/// Current system date and time
	public static var now: SMDateTime {
		return SMDateTime(date: Date())
	}

	
	
	// MARK: - Members
	
	/// Hours. Greater than `0`
	public var year: Int {
		get {
			return _date.year
		}
		set {
			_date.year = newValue
		}
	}
	
	/// Month. Range: `0...11`
	public var month: Int {
		get {
			return _date.month
		}
		set {
			_date.month = newValue
		}
	}
	
	/// Month. Range: `1...31`
	public var day: Int {
		get {
			return _date.day
		}
		set {
			_date.day = newValue
		}
	}
	
	/// Hours. Range: `0...23`
	public var hours: Int {
		get {
			return _time.hours
		}
		set {
			_time.hours = newValue
		}
	}
	
	/// Minutes. Range: `0...59`
	public var minutes: Int {
		get {
			return _time.minutes
		}
		set {
			_time.minutes = newValue
		}
	}
	
	/// Seconds. Range: `0...59`
	public var seconds:	Int {
		get {
			return _time.seconds
		}
		set {
			_time.seconds = newValue
		}
	}
	
	
	
	// MARK: - Calculatable Members
	
	/// `Weekday` of the date
	public var weekday: SMDate.Weekday! {
		return _date.weekday
	}
	
	/// `Date` object
	public var calendarDate: Date! {
		let calendar = Calendar.current
		let components = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hours, minute: minutes, second: seconds)
		return calendar.date(from: components)
	}
	
	/// Copy of `SMTime`
	public var time: SMTime {
		return _time
	}
	
	/// Copy of `SMDate`
	public var date: SMDate {
		return _date
	}
	
	/// Unix Timestamp in seconds
	public var timestamp: Int {
		return Int(calendarDate.timeIntervalSince1970)
	}
	
	/// Check if self date is yesturday
	public var isYesturday: Bool {
		return _date.isYesturday
	}
	
	/// Check if self date is today
	public var isToday: Bool {
		return _date.isToday
	}
	
	/// Check if self date is tomorrow
	public var isTomorrow: Bool {
		return _date.isTomorrow
	}
	
	
	
	// MARK: - Initializations
	
	/**
	Constructor.
	Create `SMDateTime` structure based on extracted `.day`, `.month`, `.year`, `hour`, `minute` and `second` components from the current `Calendar`
	
	- Parameter date: `Date` object
	*/
	public init(date: Date) {
		_date = SMDate(date: date)
		_time = SMTime(date: date)
	}
	
	/**
	Constructor.
	Create `SMDateTime` structure based on `SMDate` and `SMTime` values
	
	- Parameters:
		- date: `SMDate` object
		- time:	`SMTime` object
	*/
	public init(date: SMDate, time: SMTime) {
		_date = SMDate(timestamp: date.timestamp)
		_time = SMTime(totalSeconds: time.totalSeconds)
	}
	
	
	/**
	Constructor.
	Create `SMDateTime` object based on timestamp
	
	- Parameter timestamp: Unix Timestamp in seconds
	*/
	public init(timestamp: Int) {
		self.init(date: Date(timeIntervalSince1970: TimeInterval(timestamp)))
	}
	
	
	/**
	Constructor.
	Create `SMDateTime` object based on `.day`, `.month`, `.year`, `hour`, `minute` and `second` values
	
	- Parameters:
		- year:		Date year.
		- month:	Date month.
		- day:		Date day.
		- hours:	Time hours. `default` is `0`
		- minutes:	Time minutes. `default` value is `0`
		- seconds:	Time seconds. `default` value is `0`
	- Requires: `year >= 0`
	- Requires: `month >= 0. month <= 11`
	- Requires: `day >= 1. day <= 31`
	- Requires: `hours >= 0. hours <= 23`
	- Requires: `minutes >= 0. minutes <= 59`
	- Requires: `seconds >= 0. seconds <= 59`
	*/
	public init(year: Int, month: Int, day: Int, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
		_date = SMDate(year: year, month: month, day: day)
		_time = SMTime(hours: hours, minutes: minutes, seconds: seconds)
	}
	
	
	/**
	Constructor.
	Create `SMDateTime` object based on parsed specified string and format
	
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
	
	
	
	// MARK: - Functions
	
	/**
	Generate readable `String` from members
	
	- Parameters:
		- format:	Date format to represent date
		- labels:	One or more `StringLabel` that can be used for more readable result
	- Returns: Readable `String` generated from members
	*/
	public func string(format: String, labels: SMDate.StringLabel = []) -> String {
		if labels.contains(.yesturday) && isYesturday {
			return "Yesturday"
		} else if labels.contains(.today) && isToday {
			return "Today"
		} else if labels.contains(.tomorrow) && isYesturday {
			return "Tomorrow"
		}
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: calendarDate)
	}
	
}



// MARK: - Mathematic Operations

extension SMDateTime {
	
	
	/**
	'Minus' mathematic operator.
	
	- Parameters:
	- lhs:	First dateTime
	- rhs:	Second dateTime
	
	- Returns:
	Duration between two dates
	*/
	public static func - (lhs: SMDateTime, rhs: SMDateTime) -> SMDuration {
		let seconds = lhs.timestamp - rhs.timestamp
		return SMDuration(totalSeconds: seconds)
	}
	
	
	/**
	'Minus' mathematic operator.
	
	- Parameters:
	- lhs:	DateTime
	- rhs:	Duration
	
	- Returns:
	Date and time before specific duration
	*/
	public static func - (lhs: SMDateTime, rhs: SMDuration) -> SMDateTime {
		let timestamp = lhs.timestamp - rhs.totalSeconds
		return SMDateTime(timestamp: timestamp)
	}
	
	
	/**
	'Minus' mathematic operator.

	- Parameters:
	- lhs:	Source date and time
	- rhs:	Duration that would be subtracted
	*/
	public static func -= (lhs: inout SMDateTime, rhs: SMDuration) {
		lhs = lhs - rhs;
	}
	
	
	/**
	'Minus' mathematic operator.
	
	- Parameters:
	- lhs:	DateTime
	- rhs:	Duration in seconds
	
	- Returns:
	 Date and time before given number of seconds
	*/
	public static func - (lhs: SMDateTime, rhs: TimeInterval) -> SMDateTime {
		let timestamp = lhs.timestamp - Int(rhs)
		return SMDateTime(timestamp: timestamp)
	}
	
	
	/**
	'Minus' mathematic operator.

	- Parameters:
	- lhs:	Source date and time
	- rhs:	Duration in seconds that would be subtracted
	*/
	public static func -= (lhs: inout SMDateTime, rhs: TimeInterval) {
		lhs = lhs - rhs;
	}
	
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
	- lhs:	DateTime
	- rhs:	Duration
	
	- Returns:
	Date and time after specific duration
	*/
	public static func + (lhs: SMDateTime, rhs: SMDuration) -> SMDateTime {
		let timestamp = lhs.timestamp + rhs.totalSeconds
		return SMDateTime(timestamp: timestamp)
	}
	
	
	/**
	'Plus' mathematic operator.

	- Parameters:
	- lhs:	Source date and time
	- rhs:	Duration that would be added
	*/
	public static func += (lhs: inout SMDateTime, rhs: SMDuration) {
		lhs = lhs + rhs;
	}
	
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
	- lhs:	DateTime
	- rhs:	Duration in seconds
	
	- Returns:
	Date and time after given number of seconds
	*/
	public static func + (lhs: SMDateTime, rhs: TimeInterval) -> SMDateTime {
		let timestamp = lhs.timestamp + Int(rhs)
		return SMDateTime(timestamp: timestamp)
	}
	
	
	/**
	'Plus' mathematic operator.

	- Parameters:
	- lhs:	Source date and time
	- rhs:	Duration in seconds that would be added
	*/
	public static func += (lhs: inout SMDateTime, rhs: TimeInterval) {
		lhs = lhs + rhs;
	}
	
}



// MARK: - Equatable & Comparable Protocols

extension SMDateTime: Equatable, Comparable {
	
	public static func < (lhs: SMDateTime, rhs: SMDateTime) -> Bool {
		if lhs._date != rhs._date {
			return lhs._date < rhs._date
		} else {
			return lhs._time < rhs._time
		}
	}
	
}



// MARK: - Description Protocol

extension SMDateTime: CustomStringConvertible {
	
	public var description: String {
		return "\(_date) \(_time)"
	}
	
}



// MARK: - Formatter Extension

public extension DateFormatter {
	
	func string(from date: SMDateTime) -> String {
		self.string(from: date.calendarDate)
	}
	
	func smDateTime(from string: String) -> SMDateTime? {
		guard let date = self.date(from: string) else {
			return nil
		}
		return SMDateTime(date: date)
	}
	
}
