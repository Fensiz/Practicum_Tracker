//
//  ImageUtils.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

import UIKit
import CoreImage

enum ImageUtils {
	private static func cropWhitespace(from image: UIImage) -> UIImage? {
		guard let cgImage = image.cgImage else { return nil }
		guard let context = CGContext(
			data: nil,
			width: cgImage.width,
			height: cgImage.height,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: CGColorSpaceCreateDeviceRGB(),
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		) else { return nil }

		let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
		context.draw(cgImage, in: rect)

		guard let data = context.data else { return nil }
		let pixelData = data.bindMemory(to: UInt8.self, capacity: cgImage.width * cgImage.height * 4)

		var minX = cgImage.width
		var minY = cgImage.height
		var maxX = 0
		var maxY = 0

		for y in 0..<cgImage.height {
			for x in 0..<cgImage.width {
				let index = ((cgImage.width * y) + x) * 4
				let alpha = pixelData[index + 3]
				if alpha > 0 { // Непрозрачный пиксель
					minX = min(minX, x)
					maxX = max(maxX, x)
					minY = min(minY, y)
					maxY = max(maxY, y)
				}
			}
		}

		if minX >= maxX || minY >= maxY {
			return image // ничего не найдено, возвращаем оригинал
		}

		let cropRect = CGRect(
			x: CGFloat(minX),
			y: CGFloat(minY),
			width: CGFloat(maxX - minX + 1),
			height: CGFloat(maxY - minY + 1)
		)

		guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return image }

		return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
	}

	private static func emojiToImage(emoji: String, font: UIFont, size: CGSize = CGSize(width: 80, height: 80)) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: size)
		let image = renderer.image { _ in
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center

			let attributes: [NSAttributedString.Key: Any] = [
				.font: font,
				.paragraphStyle: paragraphStyle
			]

			let textSize = (emoji as NSString).size(withAttributes: attributes)
			let rect = CGRect(
				x: (size.width - textSize.width) / 2,
				y: (size.height - textSize.height) / 2,
				width: textSize.width,
				height: textSize.height
			)

			(emoji as NSString).draw(in: rect, withAttributes: attributes)
		}

		return cropWhitespace(from: image)
	}

	private static func applyGrayScaleToImage(image: UIImage) -> UIImage? {
		guard let ciImage = CIImage(image: image) else { return nil }

		let filter = CIFilter(name: "CIColorControls")
		filter?.setValue(ciImage, forKey: kCIInputImageKey)
		filter?.setValue(0.0, forKey: kCIInputSaturationKey) // обесцвечивание
		filter?.setValue(0.0, forKey: kCIInputBrightnessKey)
		filter?.setValue(1.0, forKey: kCIInputContrastKey)

		let context = CIContext(options: nil)
		guard let outputImage = filter?.outputImage,
			  let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
			return nil
		}

		return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
	}

	static func emojiToGrayscaleImage(emoji: String, font: UIFont, size: CGSize = CGSize(width: 80, height: 80)) -> UIImage? {
		guard let emojiImage = emojiToImage(emoji: emoji, font: font, size: size) else {
			return nil
		}
		return applyGrayScaleToImage(image: emojiImage)
	}
}
