//
//  FilterOptionsViewModel.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 31.05.2025.
//

final class FilterOptionsViewModel {
	let options: [Option] = [.allTrackers, .todayTrackers, .completed, .uncompleted]
	let selectedOption: Option
	weak var delegate: (any FilterOptionSelectionDelegate)?

	init(
		selectedOption: Option = .allTrackers,
		delegate: FilterOptionSelectionDelegate
	) {
		self.selectedOption = selectedOption
		self.delegate = delegate
	}

	func didSelectOption(at: Int) {
		delegate?.didSelectFilterOption(options[at])
	}
}
