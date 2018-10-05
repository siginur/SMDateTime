//
//  SMTime.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//


public struct SMTime: Codable {
	
	// MARK: - Static Members
	
	public static var now: SMTime {
		return SMTime(date: Date())
	}

	// MARK: - Members
	
	public var hours: Int {
		didSet {
			hours = max(min(hours, 23), 0)
		}
	}
	public var minutes: Int {
		didSet {
			minutes = max(min(minutes, 59), 0)
		}
	}
	public var seconds:	Int {
		didSet {
			seconds = max(min(seconds, 59), 0)
		}
	}

	// MARK: - Calculatable Members
	
	public var timeInSeconds: Int {
		return hours * 3600 + minutes * 60 + seconds
	}
	
	// MARK: - Initializations

	/**
	Constructor
	
	Create `SMTime` object by extracting `.hour`, `.minute` and `.second` components from the current `Calendar`
	
	- Parameter date: Date from where should extract time components
	*/
	public init(date: Date) {
		let nowDate = Date()
		let calendar = Calendar.current
		self.hours = calendar.component(.hour, from: nowDate)
		self.minutes = calendar.component(.minute, from: nowDate)
		self.seconds = calendar.component(.second, from: nowDate)
	}
	
	
	/**
	Constructor
	
	Create `SMTime` object by `hour`, `minutes` and `seconds` values
	
	- Parameters:
		- hours:	Time hours. `default` is `0`
		- minutes:	Time minutes. `default` value is `0`
		- seconds:	Time seconds. `default` value is `0`
	- Requires: `hours >= 0. hours <= 23`
	- Requires: `minutes >= 0. minutes <= 59`
	- Requires: `seconds >= 0. seconds <= 59`
	*/
	public init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
		self.hours = max(min(hours, 23), 0)
		self.minutes = max(min(minutes, 59), 0)
		self.seconds = max(min(seconds, 59), 0)
	}
	
	
	/**
	Constructor
	
	Create `SMTime` object by `totalSeconds` of the time
	
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
	Constructor
	
	Create `SMTime` object by parsing specified `string` and `format`
	
	- Parameters:
		- string: Source string that should be parsed by specified `format` in next parameter
		- format: Format of the time (`DateFormatter`)
	*/
	public init?(string: String, format: String) {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		guard let date = formatter.date(from: format) else {
			return nil
		}
		self.init(date: date)
	}
	
	// MARK: - Static Functions
	
	public static func timeFromNow(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> SMTime {
		let totalSeconds: Int = now.timeInSeconds + hours * 3600 + minutes * 60 + seconds
		return SMTime(totalSeconds: totalSeconds)
	}
	
	// MARK: - Functions
	
	public func string(clock: ClockType = .system, includeSeconds: Bool = true) -> String {
		let hoursStr, suffix: String

		if clock == .hours_24 || (clock == .system && SMTime.systemClockType == .hours_24) {
			hoursStr = SMTime.numberFormatter.string(for: hours) ?? "\(hours)"
			suffix = ""
		} else if hours > 12 {
			hoursStr = SMTime.numberFormatter.string(for: hours - 12) ?? "\(hours - 12)"
			suffix = " pm"
		} else {
			hoursStr = SMTime.numberFormatter.string(for: hours) ?? "\(hours)"
			suffix = " am"
		}
		let minutesStr = SMTime.numberFormatter.string(for: minutes) ?? "\(minutes)"
		let secondsStr = SMTime.numberFormatter.string(for: seconds) ?? "\(seconds)"

		return "\(hoursStr):\(minutesStr):\(secondsStr)" + suffix
	}
	
//	public func timeInMinutes(roundType: RoundType = .automatic) -> Int {
//		let minutesValue = timeInMinutes() as Double
//
//		switch roundType {
//		case .up:
//			return Int(ceil(minutesValue))
//		case .down:
//			return Int(floor(minutesValue))
//		case .automatic:
//			return Int(minutesValue)
//		}
//	}
//
//	public func timeInMinutes() -> Double {
//		return Double(timeInSeconds) / 60.0
//	}
	
//	public init(timeInHours: String) {
//		let timeStr = timeInHours.filter({ "0123456789:".contains($0) })
//		let timeParts = timeStr.split(separator: ":")
//		guard timeParts.count == 2 else {
//			hours = 0
//			minutes = 0
//			return
//		}
//		hours = Int(timeParts[0]) ?? 0
//		minutes = Int(timeParts[1]) ?? 0
//	}
	
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
	
	private static let systemClockType: ClockType = {
		guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) else {
			return .hours_24
		}
		return dateFormat.index( of: "a") == nil ? ClockType.hours_24 : ClockType.hours_12
	}()
	
}

// MARK: - Mathematic Operations

extension SMDuration {
	
	public static func + (lhs: SMTime, rhs: SMDuration) -> SMTime {
		let seconds = lhs.timeInSeconds + rhs.durationInSeconds
		return SMTime(totalSeconds: seconds)
	}
	
	public static func + (lhs: SMDuration, rhs: SMTime) -> SMTime {
		let seconds = lhs.durationInSeconds + rhs.timeInSeconds
		return SMTime(totalSeconds: seconds)
	}
	
	public static func - (lhs: SMTime, rhs: SMDuration) -> SMTime {
		let seconds = lhs.timeInSeconds - rhs.durationInSeconds
		return SMTime(totalSeconds: seconds)
	}
	
}

// MARK: - Enums

extension SMTime {
	
	public enum RoundType {
		case up
		case down
		case automatic
	}
	
	public enum ClockType {
		case hours_24
		case hours_12
		case system
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
	
	public var description: String {
		return "\(hours):\(minutes):\(seconds)"
	}
	
}
