//
//  WeekDaySetTransformer.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 09.05.2025.
//

//import CoreData

import Foundation

//@objc(WeekDaySetTransformer)
//final class WeekDaySetTransformer: NSSecureUnarchiveFromDataTransformer {
//
//	override class func allowsReverseTransformation() -> Bool { true }
//
//	override class func transformedValueClass() -> AnyClass {
//		NSSet.self
//	}
//
//	static let name = NSValueTransformerName(rawValue: String(describing: WeekDaySetTransformer.self))
//
//	override class var allowedTopLevelClasses: [AnyClass] {
//		[NSArray.self, NSSet.self, NSNumber.self]
//	}
//}

@objc(WeekDayArrayTransformer)
final class WeekDayArrayTransformer: NSSecureUnarchiveFromDataTransformer {
	override class var allowedTopLevelClasses: [AnyClass] {
		[NSArray.self, NSNumber.self]
	}

	static let name = NSValueTransformerName(rawValue: "WeekDayArrayTransformer")
}
