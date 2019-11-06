//
//  SMDuration.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//


/**
Duration structure
*/
public struct SMDuration: Hashable, Codable {
	
	// MARK: - Enums
	
	/**
	Time unit. Describes availables unit of times
	*/
	public enum TimeUnit {
		/// Days unit
		case day
		/// Hours unit
		case hour
		/// Minutes unit
		case minute
		/// Seconds unit
		case second
	}
	
	
	
	// MARK: - Static Members
	
	/// Zero duration.
	public static let zero = SMDuration(totalSeconds: 0)
	

	
	// MARK: - Members
	
	/// Days. Greater than `0`
	public var days: Int
	
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
	
	/// Duration in days. This value always possible
	public var totalDays: Double {
		return Double(totalSeconds) / 86400.0
	}
	
	/// Duration in hours. This value always possible
	public var totalHours: Double {
		return Double(totalSeconds) / 3600.0
	}
	
	/// Duration in minutes. This value always possible
	public var totalMinutes: Double {
		return Double(totalSeconds) / 60.0
	}
	
	/// Duration in seconds. This value always possible
	public var totalSeconds: Int {
		return days * 86400 + hours * 3600 + minutes * 60 + seconds
	}
	
	
	

	// MARK: - Initializations
	
	/**
	Constructor.
	Create `SMDuration` object based on `days`, `hours`, `minutes` and `seconds` values
	
	- Parameters:
		- days:		Duration hours. `default` is `0`
		- hours:	Duration hours. `default` is `0`
		- minutes:	Duration minutes. `default` value is `0`
		- seconds:	Duration seconds. `default` value is `0`
	- Requires: `days >= 0`
	- Requires: `hours >= 0. hours <= 23`
	- Requires: `minutes >= 0. minutes <= 59`
	- Requires: `seconds >= 0. seconds <= 59`
	*/
	public init(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
		self.days = max(days, 0)
		self.hours = max(min(hours, 23), 0)
		self.minutes = max(min(minutes, 59), 0)
		self.seconds = max(min(seconds, 59), 0)
	}
	
	
	/**
	Constructor.
	Create `SMDuration` object based on total number of days
	
	- Parameter totalDays: Duration in days
	
	- Requires: `totalDays >= 0`
	*/
	public init(totalDays: Double) {
		self.init(totalMinutes: totalDays * 1440) // 1440 is number of minutes in day
	}
	
	
	/**
	Constructor.
	Create `SMDuration` object based on total number of hours
	
	- Parameter totalHours: Duration in hours
	
	- Requires: `totalHours >= 0`
	*/
	public init(totalHours: Double) {
		self.init(totalMinutes: totalHours * 60)
	}
	
	
	/**
	Constructor.
	Create `SMDuration` object based on total number of minutes
	
	- Parameter totalMinutes: Duration in minutes
	
	- Requires: `totalMinutes >= 0`
	*/
	public init(totalMinutes: Double) {
		self.init(totalSeconds: Int(floor(totalMinutes * 60)))
	}

	
	/**
	Constructor.
	Create `SMDuration` object based on total number of seconds
	
	- Parameter totalSeconds: Duration in seconds
	
	- Requires: `totalSeconds >= 0`
	*/
	public init(totalSeconds: Int) {
		var durationInSeconds = abs(totalSeconds)
		
		days = devideAndFloor(value: durationInSeconds, devider: 86400)
		durationInSeconds -= days * 86400
		
		hours = devideAndFloor(value: durationInSeconds, devider: 3600)
		durationInSeconds -= hours * 3600
		
		minutes = devideAndFloor(value: durationInSeconds, devider: 60)
		seconds = durationInSeconds - minutes * 60
	}
	
	
	/**
	Constructor
	Create `SMDuration` object based on time interval between `startTime` and `finishTime`
	
	- Parameters:
		- startTime:	Start time
		- finishTime:	Finish time
	*/
	public init(startTime: SMTime, finishTime: SMTime) {
		let timeInSeconds = finishTime.totalSeconds - startTime.totalSeconds
		self.init(totalSeconds: timeInSeconds)
	}
	
	
	
	// MARK: - Functions
	
	/**
	Round current duration to specific `unit` and return new value
	
	- Parameters:
	- toUnit:	`TimeUnit` that should be rounded
	- Returns:	New `SMDuration` created by rounding current duration
	*/
	public func rounded(toUnit unit: TimeUnit) -> SMDuration {
		var days = self.days
		var hours = self.hours
		var minutes = self.minutes
		var seconds = self.seconds

		switch unit {
		case .day:
			minutes += seconds >= 30 ? 1 : 0
			hours += minutes >= 30 ? 1 : 0
			days += hours >= 12 ? 1 : 0
			seconds = 0
			minutes = 0
			hours = 0
		case .hour:
			minutes += seconds >= 30 ? 1 : 0
			hours += minutes >= 30 ? 1 : 0
			seconds = 0
			minutes = 0
		case .minute:
			minutes += seconds >= 30 ? 1 : 0
			seconds = 0
		case .second:
			break;
		}
		seconds += minutes * 60 + hours * 3600 + days * 86400
		return SMDuration(totalSeconds: seconds)
	}
	
}



// MARK: - Mathematic Operations

extension SMDuration {
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	First duration
		- rhs:	Second duration
	
	- Returns:
		Sum of both durations
	*/
	public static func + (lhs: SMDuration, rhs: SMDuration) -> SMDuration {
		let seconds = lhs.totalSeconds + rhs.totalSeconds
		return SMDuration(totalSeconds: seconds)
	}
	
	
	/**
	'Minus' mathematic operator.
	
	- Parameters:
		- lhs:	First duration
		- rhs:	Second duration
	
	- Returns:
		Difference between two durations
	*/
	public static func - (lhs: SMDuration, rhs: SMDuration) -> SMDuration {
		let seconds = lhs.totalSeconds - rhs.totalSeconds
		return SMDuration(totalSeconds: seconds)
	}
	
	
	/**
	'Division' mathematic operator.
	
	- Parameters:
		- lhs:	Source duration
		- rhs:	Divider
	
	- Returns:
		Quotient
	*/
	public static func / (lhs: SMDuration, rhs: Int) -> SMDuration {
		let seconds = devideAndRound(value: lhs.totalSeconds, devider: rhs)
		return SMDuration(totalSeconds: seconds)
	}
	
	
	/**
	'Multiplication' mathematic operator.
	
	- Parameters:
		- lhs:	Source duration
		- rhs:	Factor
	
	- Returns:
		Quotient.
	*/
	public static func * (lhs: SMDuration, rhs: Int) -> SMDuration {
		let seconds = lhs.totalSeconds * rhs
		return SMDuration(totalSeconds: seconds)
	}
	
	
	/**
	'Plus' mathematic operator.
	
	- Parameters:
		- lhs:	Source duration
		- rhs:	Duration that would be added
	*/
	public static func += (lhs: inout SMDuration, rhs: SMDuration) {
		lhs = lhs + rhs;
	}
	
	
	/**
	'Minus' mathematic operator.
	
	- Parameters:
		- lhs:	Source duration
		- rhs:	Duration that would be subtracted
	*/
	public static func -= (lhs: inout SMDuration, rhs: SMDuration) {
		lhs = lhs - rhs;
	}
	
}



// MARK: - Equatable & Comparable Protocols

extension SMDuration: Equatable, Comparable {
	
	public static func < (lhs: SMDuration, rhs: SMDuration) -> Bool {
		if lhs.days != rhs.days {
			return lhs.days < rhs.days
		} else if lhs.hours != rhs.hours {
			return lhs.hours < rhs.hours
		} else if lhs.minutes != rhs.minutes {
			return lhs.minutes < rhs.minutes
		} else {
			return lhs.seconds < rhs.seconds
		}
	}
	
}



// MARK: - Description Protocol

extension SMDuration: CustomStringConvertible {
	
	public var description: String {
		var components: [String?] = []
		components.append(days > 0 ? "\(days)d" : nil)
		components.append(hours > 0 ? "\(hours)h" : nil)
		components.append(minutes > 0 ? "\(minutes)m" : nil)
		components.append(seconds > 0 ? "\(seconds)s" : nil)
		let notNilComponents = components.compactMap{ $0 }
		return notNilComponents.count == 0 ? "0s" : notNilComponents.joined(separator: " ")
	}
	
}
