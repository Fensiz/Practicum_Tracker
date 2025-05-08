//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//


protocol ScheduleViewControllerDelegate: AnyObject {
	func didSelectDays(_ days: Set<WeekDay>)
}
