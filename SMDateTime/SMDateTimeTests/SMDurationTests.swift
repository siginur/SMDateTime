//
//  SMDurationTests.swift
//  SMDateTimeTests
//
//  Created by Alexey Siginur on 24/01/2019.
//  Copyright © 2019 merkova. All rights reserved.
//

import XCTest
import SMDateTime

class SMDurationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testRoundBySecondsUnit() {
		for days in 0...1 {
			for hours in 0...23 {
				for minutes in 0...59 {
					for seconds in 0...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						checkDuration(duration: duration, roundToUnit: .second, requiredDuration: duration)
					}
				}
			}
		}
	}
	
	func testRoundByMinutesUnit() {
		for days in 0...1 {
			for hours in 0...23 {
				for minutes in 0...59 {
					for seconds in 0...29 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let requiredDuration = SMDuration(days: days, hours: hours, minutes: minutes)
						checkDuration(duration: duration, roundToUnit: .minute, requiredDuration: requiredDuration)
					}
					for seconds in 30...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let requiredDuration = SMDuration(totalSeconds: duration.totalSeconds - seconds + 60)
						checkDuration(duration: duration, roundToUnit: .minute, requiredDuration: requiredDuration)
					}
				}
			}
		}
	}
	
	func testRoundByHourUnit() {
		for days in 0...1 {
			for hours in 0...23 {
				for minutes in 0...29 {
					for seconds in 0...29 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let requiredDuration = SMDuration(days: days, hours: hours)
						checkDuration(duration: duration, roundToUnit: .hour, requiredDuration: requiredDuration)
					}
					for seconds in 30...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let requiredDuration = SMDuration(totalSeconds: days * 86400 + (hours + (minutes == 29 ? 1 : 0)) * 3600)
						checkDuration(duration: duration, roundToUnit: .hour, requiredDuration: requiredDuration)
					}
				}
				for minutes in 30...59 {
					for seconds in 0...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let requiredDuration = SMDuration(totalSeconds: duration.totalSeconds - seconds - minutes * 60 + 3600)
						checkDuration(duration: duration, roundToUnit: .hour, requiredDuration: requiredDuration)
					}
				}
			}
		}
	}
	
	func testRoundByDayUnit() {
		for days in 0...1 {
			for hours in 0...10 {
				for minutes in 0...59 {
					for seconds in 0...59 {
						checkDuration(days: days, hours: hours, minutes: minutes, seconds: seconds, roundToUnit: .day, requiredDuration: SMDuration(days: days))
					}
				}
			}
			for hours in 11...11 {
				for minutes in 0...28 {
					for seconds in 0...59 {
						checkDuration(days: days, hours: hours, minutes: minutes, seconds: seconds, roundToUnit: .day, requiredDuration: SMDuration(days: days))
					}
				}
				for minutes in 29...29 {
					for seconds in 0...59 {
						checkDuration(days: days, hours: hours, minutes: minutes, seconds: seconds, roundToUnit: .day, requiredDuration: SMDuration(days: days + (seconds > 29 ? 1 : 0)))
					}
				}
				for minutes in 30...59 {
					for seconds in 0...59 {
						checkDuration(days: days, hours: hours, minutes: minutes, seconds: seconds, roundToUnit: .day, requiredDuration: SMDuration(days: days + 1))
					}
				}
			}
			for hours in 12...23 {
				for minutes in 0...59 {
					for seconds in 0...59 {
						checkDuration(days: days, hours: hours, minutes: minutes, seconds: seconds, roundToUnit: .day, requiredDuration: SMDuration(days: days + 1))
					}
				}
			}
		}
	}
	
	fileprivate func checkDuration(days: Int, hours: Int, minutes: Int, seconds: Int, roundToUnit: SMDuration.TimeUnit, requiredDuration: SMDuration) {
		let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
		checkDuration(duration: duration, roundToUnit: roundToUnit, requiredDuration: requiredDuration)
	}
	
	fileprivate func checkDuration(duration: SMDuration, roundToUnit: SMDuration.TimeUnit, requiredDuration: SMDuration) {
		let roundedDuration = duration.rounded(toUnit: roundToUnit)
		XCTAssertEqual(requiredDuration, roundedDuration)
//		print(duration, "-", roundedDuration)
	}

}
