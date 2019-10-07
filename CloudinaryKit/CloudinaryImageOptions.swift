//
//  CloudinaryImageOptions.swift
//  CloudinaryKit
//
//  Created by Alexander Kolov on 2018-12-10.
//  Copyright © 2018 Wineapp Ltd. All rights reserved.
//

import UIKit.UIScreen

public struct CloudinaryImageOptions: CloudinaryTransformationOptions {

  public let imageFormat: CloudinaryTransformation.ImageFormat
  public let crop: CloudinaryTransformation.Crop
  public let effect: String?
  public let flags: [ImageFlags]
  public let gravity: CloudinaryTransformation.Gravity
  public let quality: CloudinaryTransformation.Quality?
  public let height: Double?
  public let width: Double?
  public let scale = UIScreen.main.scale
  public let trim: CloudinaryTransformation.VideoTrim?
  public let layers: [CloudinaryLayer]

  public enum ImageFlags: String {
    case progressive = "fl_progressive"
  }

}

extension CloudinaryImageOptions {

  public init(
    imageFormat: CloudinaryTransformation.ImageFormat = CloudinaryImageOptions.defaultImageFormat,
    crop: CloudinaryTransformation.Crop = .none,
    effect: String? = nil,
    flags: [CloudinaryImageOptions.ImageFlags] = [],
    gravity: CloudinaryTransformation.Gravity = .center,
    quality: CloudinaryTransformation.Quality? = nil,
    trim: CloudinaryTransformation.VideoTrim? = nil,
    width: Double? = nil,
    height: Double? = nil,
    layers: [CloudinaryLayer] = []
  ) {
    self.imageFormat = imageFormat
    self.crop = crop
    self.effect = effect
    self.flags = flags
    self.gravity = gravity
    self.quality = quality
    self.trim = trim
    self.width = width
    self.height = height
    self.layers = layers
  }

  public func serialized() -> String {
    var params = [String]()

    if imageFormat != .auto {
      params.append("f_" + imageFormat.rawValue)
    }

    if crop != .none {
      params.append("c_" + crop.rawValue)
    }

    if let effect = effect {
      params.append("e_" + effect)
    }

    if !flags.isEmpty {
      params.append(flags.map { $0.rawValue } .joined(separator: "."))
    }

    if gravity != .center {
      params.append("g_" + gravity.rawValue)
    }

    if let quality = quality {
      params.append("q_" + quality.rawValue)
    }

    if let trim = trim {
      if let start = trim.start {
        params.append("so_\(start)")
      }

      if let end = trim.end {
        params.append("eo_\(end)")
      }

      if let duration = trim.duration {
        params.append("du_\(duration)")
      }
    }

    if let height = height {
      params.append("h_\(Int(height))")
    }

    if let width = width {
      params.append("w_\(Int(width))")
    }

    if scale != 1.0 {
      params.append("dpr_\(scale)")
    }

    return [
      params.joined(separator: ","),
      layers.map { $0.serialized() }.joined(separator: "/")
    ].joined(separator: "/")
  }

  public static let defaultImageFormat: CloudinaryTransformation.ImageFormat = .jpeg

}