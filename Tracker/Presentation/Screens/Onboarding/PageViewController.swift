//
//  PageViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.05.2025.
//

import UIKit

class PageViewController: UIPageViewController {

	var switchAction: (() -> Void)?

	private func makePage(imageName: String, text: String) -> UIViewController {
		let vc = UIViewController()
		vc.view = UIImageView(image: UIImage(named: imageName) ?? UIImage())
		let label = UILabel()
		label.font = .systemFont(ofSize: 32, weight: .bold)
		label.numberOfLines = 2
		label.textAlignment = .center
		label.text = text
		label.translatesAutoresizingMaskIntoConstraints = false
		vc.view.addSubview(label)
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: 64),
			label.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: Constants.commonPadding),
			label.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -Constants.commonPadding),
		])
		return vc
	}

	private lazy var pages: [UIViewController] = {
		let first = makePage(imageName: "background-first", text: "Отслеживайте только то, что хотите")
		let second = makePage(imageName: "background-second", text: "Даже если это не литры воды и йога")

		return [first, second]
	}()

	private lazy var button = {
		let button = AppButton(title: "Вот это технологии!")
		let action = UIAction { [weak self] _ in
			self?.switchAction?()
		}
		button.addAction(action, for: .touchUpInside)
		return button
	}()

	private lazy var pageControl: UIPageControl = {
		let control = UIPageControl()
		control.currentPageIndicatorTintColor = .label
		control.pageIndicatorTintColor = .systemGray
		control.translatesAutoresizingMaskIntoConstraints = false
		control.addAction(
			UIAction { [weak self] action in
				guard let self,
					  let control = action.sender as? UIPageControl else { return }

				let selectedIndex = control.currentPage
				let currentVC = self.viewControllers?.first
				let currentIndex = self.pages.firstIndex(of: currentVC ?? UIViewController()) ?? 0

				let direction: UIPageViewController.NavigationDirection = selectedIndex > currentIndex ? .forward : .reverse

				self.setViewControllers(
					[self.pages[selectedIndex]],
					direction: direction,
					animated: true,
					completion: nil
				)
			},
			for: .valueChanged
		)
		return control
	}()


	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .light

		delegate = self
		dataSource = self

		if let first = pages.first {
			setViewControllers([first], direction: .forward, animated: true, completion: nil)
		}

		view.addSubview(button)
		view.addSubview(pageControl)

		pageControl.numberOfPages = pages.count
		pageControl.currentPage = 0

		NSLayoutConstraint.activate([
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.mediumPadding),
			button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.mediumPadding),
			button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
			button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
			pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pageControl.centerYAnchor.constraint(equalTo: button.topAnchor, constant: -24),
		])
	}
}

extension PageViewController: UIPageViewControllerDataSource {

	// MARK: - UIPageViewControllerDataSource

	func pageViewController(
		_ pageViewController: UIPageViewController,
		viewControllerBefore viewController: UIViewController
	) -> UIViewController? {
		//возвращаем предыдущий (относительно переданного viewController) дочерний контроллер
		guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
			return nil
		}

		let previousIndex = viewControllerIndex - 1

		guard previousIndex >= 0 else {
			return nil
		}

		return pages[previousIndex]
	}

	func pageViewController(
		_ pageViewController: UIPageViewController,
		viewControllerAfter viewController: UIViewController
	) -> UIViewController? {
		//возвращаем следующий (относительно переданного viewController) дочерний контроллер
		guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
			return nil
		}

		let nextIndex = viewControllerIndex + 1

		guard nextIndex < pages.count else {
			return nil
		}

		return pages[nextIndex]
	}
}

extension PageViewController: UIPageViewControllerDelegate {
	func pageViewController(
		_ pageViewController: UIPageViewController,
		didFinishAnimating finished: Bool,
		previousViewControllers: [UIViewController],
		transitionCompleted completed: Bool
	) {
		guard completed,
			  let currentVC = viewControllers?.first,
			  let index = pages.firstIndex(of: currentVC) else {
			return
		}

		pageControl.currentPage = index
	}
}

#Preview {
	PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
}
