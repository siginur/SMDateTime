//
//  SMDuration.swift
//  SMDateTime
//
//  Created by Alexey Siginur on 02/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

public struct SMDuration: Codable {
	
	// MARK: - Static Members
	
	public static let zero = SMDuration(totalSeconds: 0)
	
	// MARK: - Members
	
	public var days: Int
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
	
	public var durationInSeconds: Int {
		return days * 86400 + hours * 3600 + minutes * 60 + seconds
	}
	
//	var durationInMinutes: Int {
//		return hours * 60 + minutes
//	}

	// MARK: - Initializations
	
	public init(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
		self.days = max(days, 0)
		self.hours = max(min(hours, 23), 0)
		self.minutes = max(min(minutes, 59), 0)
		self.seconds = max(min(seconds, 59), 0)
	}
	
//	public init(durationInHours: String) {
//		let timeStr = durationInHours.filter({ "0123456789.".contains($0) }).trimmingCharacters(in: CharacterSet.init(charactersIn: "."))
//		let value: Double = (Double(timeStr) ?? 0)
//		hours = Int(floor(value))
//		minutes = Int(round((value - Double(hours)) * 60))
//	}
	
	public init(totalSeconds: Int) {
		var durationInSeconds = abs(totalSeconds)
		
		days = devideAndFloor(value: durationInSeconds, devider: 86400)
		durationInSeconds -= days * 86400
		
		hours = devideAndFloor(value: durationInSeconds, devider: 3600)
		durationInSeconds -= hours * 3600
		
		minutes = devideAndFloor(value: durationInSeconds, devider: 60)
		seconds = durationInSeconds - minutes * 60
	}
	
	public init(startTime: SMTime, finishTime: SMTime) {
		let timeInSeconds = finishTime.timeInSeconds - startTime.timeInSeconds
		self.init(totalSeconds: timeInSeconds)
	}
	
}

// MARK: - Mathematic Operations

extension SMDuration {
	
	public static func + (lhs: SMDuration, rhs: SMDuration) -> SMDuration {
		let seconds = lhs.durationInSeconds + rhs.durationInSeconds
		return SMDuration(totalSeconds: seconds)
	}
	
	public static func - (lhs: SMDuration, rhs: SMDuration) -> SMDuration {
		let seconds = lhs.durationInSeconds - rhs.durationInSeconds
		return SMDuration(totalSeconds: seconds)
	}
	
	public static func / (lhs: SMDuration, rhs: Int) -> SMDuration {
		let seconds = devideAndRound(value: lhs.durationInSeconds, devider: rhs)
		return SMDuration(totalSeconds: seconds)
	}
	
	public static func * (lhs: SMDuration, rhs: Int) -> SMDuration {
		let seconds = lhs.durationInSeconds * rhs
		return SMDuration(totalSeconds: seconds)
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
		return "\(hours)h \(minutes)m"
	}
	
}
