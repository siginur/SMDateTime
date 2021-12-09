//
//  SMTime.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

import Foundation

/**
Time structure
*/
public struct SMTime: Hashable, Codable {
	
	// MARK: - Static Members
	
	/// Current system time
	public static var now: SMTime {
		return SMTime(date: Date())
	}

	
	
	// MARK: - Members
	
	/// Hours. Range: `0...23`
	public var hours: Int {
		didSet {
			hours = max(min(hours, 23), 0)
		}
	}
	
	/// Minutes. Range: `0...59`
	public var minutes: Int {
		didSet {
			minutes = max(min(minutes, 59), 0)
		}
	}
	
	/// Seconds. Range: `0...59`
	public var seconds:	Int {
		didSet {
			seconds = max(min(seconds, 59), 0)
		}
	}

	
	
	// MARK: - Calculatable Members
	
	/// Time representation in seconds. Range: `0..<86400`
	public var totalSeconds: Int {
		return hours * 3600 + minutes * 60 + seconds
	}
	
	
	
	
	// MARK: - Initializations

	/**
	Constructor.
	Create `SMTime` object based on extracted `.hour`, `.minute` and `.second` components from the current `Calendar`
	
	- Parameter date: Date from where should extract time components
	*/
	public init(date: Date) {
		let calendar	= Calendar.current
		self.hours		= calendar.component(.hour, from: date)
		self.minutes	= calendar.component(.minute, from: date)
		self.seconds	= calendar.component(.second, from: date)
	}

	/**
	Constructor.
	Create `SMTime` object based on extracted `.hour`, `.minute` and `.second` components from the current `Calendar`
	
	- Parameter date: Date from where should extract time components
	*/
	public init(date: SMDateTime) {
		self.hours		= date.hours
		self.minutes	= date.minutes
		self.seconds	= date.seconds
	}
	
	
	/**
	Constructor.
	Create `SMTime` object based on `hour`, `minutes` and `seconds` values
	
	- Parameters:
		- hours:	Time hours. Default value is `0`
		- minutes:	Time minutes. Default value is `0`
		- seconds:	Time seconds. Default value is `0`
	- Requires: `hours >= 0. hours <= 23`
	- Requires: `minutes >= 0. minutes <= 59`
	- Requires: `seconds >= 0. seconds <= 59`
	*/
	public init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
		self.hours		= max(min(hours, 23), 0)
		self.minutes	= max(min(minutes, 59), 0)
		self.seconds	= max(min(seconds, 59), 0)
	}
	
	
	/**
	Constructor.
	Create `SMTime` object based on total number of seconds
	
	- Parameter totalSeconds: Time representation in seconds
	
	- Requires: `totalSeconds >= 0`
	- Requires: `totalSeconds < 86400 (number of seconds in day)`
	
	- Precondition:
		````
		while totalSeconds >= secondsInDay {
			totalSeconds -= secondsInDay
		}
		if totalSeconds < 0 {
			totalSeconds += secondsInDay
		}
		````
	*/
	public init(totalSeconds: Int) {
		let secondsInDay = 60 * 60 * 24
		var totalSeconds = totalSeconds
		while totalSeconds >= secondsInDay {
			totalSeconds -= secondsInDay
		}
		if totalSeconds < 0 {
			totalSeconds += secondsInDay
		}
		
		self.hours = devideAndFloor(value: totalSeconds, devider: 3600)
		self.minutes = devideAndFloor(value: totalSeconds - hours * 3600, devider: 60)
		self.seconds = Int(totalSeconds - hours * 3600 - minutes * 60)
	}
	
	
	/**
	Constructor.
	Create `SMTime` object based on parsed specified string and format
	
	- Parameters:
		- string: Source string that should be parsed by specified `format` in next parameter
		- format: Format of the time (`DateFormatter`)
	*/
	public init?(string: String, format: String) {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		guard let date = formatter.date(from: string) else {
			return nil
		}
		self.init(date: date)
	}
	
	
	
	// MARK: - Static Functions
	
	/**
	All input parameters would be converted to seconds and added to current time
	
	- Parameters:
	  - hours:		Hours. Default value is `0`
	  - minutes:	Minutes. Default value is `0`
	  - seconds:	Seconds. Default value is `0`
	- Returns: `SMTime` object represents time after added seconds
	*/
	public static func timeFromNow(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> SMTime {
		let totalSeconds: Int = now.totalSeconds + hours * 3600 + minutes * 60 + seconds
		return SMTime(totalSeconds: totalSeconds)
	}
	
	
	
	// MARK: - Functions
	
	/**
	Generate readable `String` from members
	
	- Parameters:
		- clock:			`ClockType` that represent 24 or 12 hours clock
		- includeSeconds:	If `true`, add `seconds` to result string. Default value is `0`
	- Returns: Readable `String` generated from members
	*/
	public func string(clock: ClockType, includeSeconds: Bool = true) -> String {
		let hoursStr, suffix: String

		if clock == .hours_24 {
			hoursStr = Self.numberFormatter.string(for: hours) ?? "\(hours)"
			suffix = ""
		} else if hours >= 12 {
			hoursStr = Self.numberFormatter.string(for: hours - 12) ?? "\(hours - 12)"
			suffix = " pm"
		} else {
			hoursStr = Self.numberFormatter.string(for: hours) ?? "\(hours)"
			suffix = " am"
		}
		let minutesStr = Self.numberFormatter.string(for: minutes) ?? "\(minutes)"
		let secondsStr = Self.numberFormatter.string(for: seconds) ?? "\(seconds)"

		return "\(hoursStr):\(minutesStr)" + (includeSeconds ? ":\(secondsStr)" : "") + suffix
	}
	
}



// MARK: - Private

extension SMTime {
	
	private static let numberFormatter: NumberFormatter = {
		let f = NumberFormatter()
		f.numberStyle = .decimal
		f.maximumFractionDigits = 0
		f.minimumIntegerDigits = 2
		return f
	}()
	
}



// MARK: - Mathematic Operations

extension SMDuration {
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	Started time
		- rhs:	Duration that would be added to time
	
	- Returns:
		Time with added duration
	*/
	public static func + (lhs: SMTime, rhs: SMDuration) -> SMTime {
		let seconds = lhs.totalSeconds + rhs.totalSeconds
		return SMTime(totalSeconds: seconds)
	}
	
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	Duration that would be added to time
		- rhs:	Started time
	
	- Returns:
		Time with added duration
	*/
	public static func + (lhs: SMDuration, rhs: SMTime) -> SMTime {
		let seconds = lhs.totalSeconds + rhs.totalSeconds
		return SMTime(totalSeconds: seconds)
	}
	
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	Source time
		- rhs:	Duration that would be added
	*/
	public static func += (lhs: inout SMTime, rhs: SMDuration) {
		let seconds = lhs.totalSeconds + rhs.totalSeconds
		lhs = SMTime(totalSeconds: seconds)
	}
	
	
	/**
	'Minus' mathematic operator.
	
	- Parameters:
		- lhs:	Source time
		- rhs:	Duration that would be subtracted
	
	- Returns:
		Time with subtracted duration
	*/
	public static func - (lhs: SMTime, rhs: SMDuration) -> SMTime {
		let seconds = lhs.totalSeconds - rhs.totalSeconds
		return SMTime(totalSeconds: seconds)
	}
	
}



// MARK: - Enums

extension SMTime {
	
	/**
	Round type. Describes how to round double values to integers
	*/
	public enum RoundType {
		/// Always round value up. Examples: (`3.01 -> 4`) and (`6.91 -> 7`)
		case up
		/// Always round value down. Examples: (`3.01 -> 3`) and (`6.91 -> 6`)
		case down
		/// Round value to nearest integer. Examples: (`3.01 -> 3`) and (`6.91 -> 7`)
		case automatic
	}
	
	
	/**
	Clock type. Can be 12 or 24 clock type. Also contain help static values
	*/
	public enum ClockType {
		/// The 24-hour clock (00:00 - 23:59)
		case hours_24
		/// The 12-hour clock (am/pm)
		case hours_12
		
		/// Clock type that configured in system preferences
		public static let system: ClockType = {
			guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) else {
				return .hours_24
			}
			return dateFormat.firstIndex( of: "a") == nil ? .hours_24 : .hours_12
		}()
	}
	
}



// MARK: - Equatable & Comparable Protocols

extension SMTime: Equatable, Comparable {

	public static func < (lhs: SMTime, rhs: SMTime) -> Bool {
		if lhs.hours != rhs.hours {
			return lhs.hours < rhs.hours
		} else if lhs.minutes != rhs.minutes {
			return lhs.minutes < rhs.minutes
		} else {
			return lhs.seconds < rhs.seconds
		}
	}
	
}



// MARK: - Description Protocol

extension SMTime: CustomStringConvertible {
	
	/// String description of the `SMTime`
	public var description: String {
		return "\(hours):\(minutes):\(seconds)"
	}
	
}



// MARK: - Formatter Extension

public extension DateFormatter {
	
	func string(from time: SMTime) -> String {
		self.string(from: SMDateTime(date: SMDate(date: Date(timeIntervalSince1970: 0)), time: time))
	}
	
	func smTime(from string: String) -> SMTime? {
		guard let date = self.date(from: string) else {
			return nil
		}
		return SMTime(date: date)
	}
	
}
