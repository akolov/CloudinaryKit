//
//  CloudinaryTransformation.swift
//  CloudinaryKit
//
//  Created by Alexander Kolov on 2018-07-04.
//  Copyright © 2018 Wineapp Ltd. All rights reserved.
//

import UIKit.UIScreen

public struct CloudinaryTransformation {

  public init(
    cloudinaryID: String,
    bucket: String,
    mediaType: CloudinaryMediaType,
    deliveryType: DeliveryType = .upload,
    transformationType: TransformationType? = nil
  ) {
    self.cloudinaryID = cloudinaryID
    self.cloudinaryBucket = bucket
    self.mediaType = mediaType
    self.deliveryType = deliveryType
    self.transformationType = transformationType
  }

  // MARK: Subtypes

  public enum Crop: String {
    case none, crop, scale, limit, thumb
    case fit, minimumFit = "mfit"
    case fill, limitFill = "lfill"
    case pad, limitPad = "lpad", minimumPad = "mpad", fillPad = "fill_pad"
  }

  public enum DeliveryType: String {
    case upload, `private`, authenticated, fetch
  }

  public enum Gravity {
    case auto(String), north, west, south, east, center
    case northEast, northWest, southWest, southEast
  }

  public enum Quality {
    case auto, best, good, eco, low, value(Int)
  }

  public enum ImageFormat: String {
    case auto, heic, jpeg = "jpg", pdf, png, webp
  }

  public enum AudioCodec: String {
    case passthrough, none, aac, mp3
  }

  public enum VideoCodec: String {
    case auto, h264, h265
  }

  public struct VideoTrim {
    public let start: TimeInterval?
    public let end: TimeInterval?
    public let duration: TimeInterval?
  }

  public enum TransformationType {
    case dynamic(CloudinaryTransformationOptions)
    case named(NamedTransformation)
  }

  public struct NamedTransformation {

    public init(_ rawValue: String) {
      self.rawValue = rawValue
    }

    public let rawValue: String
  }

  // MARK: Properties

  public let cloudinaryID: String
  public let cloudinaryBucket: String
  public let mediaType: CloudinaryMediaType
  public let deliveryType: DeliveryType
  public let transformationType: TransformationType?

}

extension CloudinaryTransformation {

  public var url: URL? {
    let resourceType: String
    switch mediaType {
    case .image:
      resourceType = "image"
    case .video:
      resourceType = "video"
    }

    var components = URLComponents()
    components.scheme = "https"
    components.host = "res.cloudinary.com"
    components.path = "/\(cloudinaryBucket)/\(resourceType)/upload"

    var url = components.url
    if let transformationType = transformationType {
      switch transformationType {
      case let .dynamic(options):
        url = url?.appendingPathComponent(options.serialized())
      case let .named(name):
        url = url?.appendingPathComponent("t_\(name.rawValue)")
      }

    }
    url = url?.appendingPathComponent(cloudinaryID)

    return url
  }

  public var rawURL: URL? {
    let resourceType: String
    switch mediaType {
    case .image:
      resourceType = "image"
    case .video:
      resourceType = "video"
    }

    var components = URLComponents()
    components.scheme = "https"
    components.host = "res.cloudinary.com"
    components.path = "/\(cloudinaryBucket)/\(resourceType)/upload/\(cloudinaryID)"
    return components.url
  }

}

// MARK: CloudinaryTransformation.Gravity

extension CloudinaryTransformation.Gravity {

  var rawValue: String {
    switch self {
    case .auto(let string):
      return "auto:\(string)"
    case .center:
      return "center"
    case .north:
      return "north"
    case .west:
      return "west"
    case .south:
      return "south"
    case .east:
      return "east"
    case .northEast:
      return "north_east"
    case .northWest:
      return "north_west"
    case .southWest:
      return "south_west"
    case .southEast:
      return "south_east"
    }
  }

}

extension CloudinaryTransformation.Gravity: Equatable {

  public static func == (lhs: CloudinaryTransformation.Gravity, rhs: CloudinaryTransformation.Gravity) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

}

// MARK: CloudinaryTransformation.Quality

extension CloudinaryTransformation.Quality {

  var rawValue: String {
    switch self {
    case .auto:
      return "auto"
    case .best:
      return "auto:best"
    case .good:
      return "auto:good"
    case .eco:
      return "auto:eco"
    case .low:
      return "auto:low"
    case .value(let quality):
      return "\(quality)"
    }
  }

}

// MARK: CloudinaryTransformation.VideoTrim

extension CloudinaryTransformation.VideoTrim {

  public init(start: TimeInterval, end: TimeInterval) {
    self.start = start
    self.end = end
    self.duration = nil
  }

  public init(start: TimeInterval, duration: TimeInterval) {
    self.start = start
    self.end = nil
    self.duration = duration
  }

  public init(end: TimeInterval, duration: TimeInterval) {
    self.start = nil
    self.end = end
    self.duration = duration
  }

  public init(start: TimeInterval) {
    self.start = start
    self.end = nil
    self.duration = nil
  }

  public init(end: TimeInterval) {
    self.start = nil
    self.end = end
    self.duration = nil
  }

  public init(duration: TimeInterval) {
    self.start = nil
    self.end = nil
    self.duration = duration
  }

}