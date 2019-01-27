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
						XCTAssertEqual(duration, duration.rounded(toUnit: .second))
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
						let roundedDuration = duration.rounded(toUnit: .minute)
						XCTAssertEqual(SMDuration(days: days, hours: hours, minutes: minutes), roundedDuration)
						print(duration, "-", roundedDuration)
					}
					for seconds in 30...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let roundedDuration = duration.rounded(toUnit: .minute)
						let requiredDuration = SMDuration(totalSeconds: duration.totalSeconds - seconds + 60)
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
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
						let roundedDuration = duration.rounded(toUnit: .hour)
						let requiredDuration = SMDuration(days: days, hours: hours)
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
					}
					for seconds in 30...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let roundedDuration = duration.rounded(toUnit: .hour)
						let requiredDuration = SMDuration(totalSeconds: days * 86400 + (hours + (minutes == 29 ? 1 : 0)) * 3600)
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
					}
				}
				for minutes in 30...59 {
					for seconds in 0...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let roundedDuration = duration.rounded(toUnit: .hour)
						let requiredDuration = SMDuration(totalSeconds: duration.totalSeconds - seconds - minutes * 60 + 3600)
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
					}
				}
			}
		}
	}

	func testRoundByDayUnit() {
		for days in 0...0 {
			for hours in 0...10 {
				for minutes in 0...59 {
					for seconds in 0...29 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let roundedDuration = duration.rounded(toUnit: .day)
						let requiredDuration = SMDuration(days: days)
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
					}
					for seconds in 30...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let roundedDuration = duration.rounded(toUnit: .day)
						let requiredDuration = SMDuration(days: days + (hours == 11 && minutes >= 29 ? 1 : 0))
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
					}
				}
			}
			
			for hours in 12...23 {
				for minutes in 0...29 {
					for seconds in 0...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let roundedDuration = duration.rounded(toUnit: .day)
						let requiredDuration = SMDuration(days: days)
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
					}
				}
				for minutes in 30...59 {
					for seconds in 0...59 {
						let duration = SMDuration(days: days, hours: hours, minutes: minutes, seconds: seconds)
						let roundedDuration = duration.rounded(toUnit: .day)
						let requiredDuration = SMDuration(days: days + 1)
						XCTAssertEqual(requiredDuration, roundedDuration)
						print(duration, "-", roundedDuration)
					}
				}
			}
		}
	}

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
