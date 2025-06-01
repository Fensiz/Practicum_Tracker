//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 01.06.2025.
//

import AppMetricaCore

struct AnalyticsService {
	enum AnalyticsEventType: String {
		case open, close, click
	}

	enum AnalyticsScreen: String {
		case main = "Main"
		case trackerTypeSelection = "TrackerTypeSelection"
		case trackerCreation = "TrackerCreation"
	}

	enum AnalyticsItem: String {
		case addTrack = "add_track"
		case track
		case untrack
		case pin
		case unpin
		case filter
		case edit
		case delete
	}

	static func logEvent(
		_ event: AnalyticsEventType,
		screen: AnalyticsScreen,
		item: AnalyticsItem? = nil
	) {
		var parameters: [String: Any] = [
			"event": event.rawValue,
			"screen": screen.rawValue
		]
		if let item {
			parameters["item"] = item.rawValue
		}

		AppMetrica.reportEvent(name: "action", parameters: parameters)
		print("AppMetrica event sent:", parameters)
	}

	static func initialize() {
		if let configuration = AppMetricaConfiguration(apiKey: "d42ac58f-dd36-4f90-bc7b-5d0172e03214") {
			AppMetrica.activate(with: configuration)
		}
	}
}
