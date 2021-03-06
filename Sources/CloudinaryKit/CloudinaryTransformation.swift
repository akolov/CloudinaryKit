//
//  CloudinaryTransformation.swift
//  CloudinaryKit
//
//  Created by Alexander Kolov on 2018-07-04.
//  Copyright © 2018 Wineapp Ltd. All rights reserved.
//

import Foundation

public struct CloudinaryTransformation {

  public init(
    cloudinaryID: String,
    bucket: String?,
    mediaType: CloudinaryMediaType,
    deliveryType: DeliveryType = .upload,
    kind: Kind? = nil,
    format: Format?
  ) {
    self.cloudinaryID = cloudinaryID
    self.cloudinaryBucket = bucket
    self.mediaType = mediaType
    self.deliveryType = deliveryType
    self.transformationKind = kind
    self.format = format ?? {
      switch mediaType {
      case .image:
        return .image(.default)
      case .video:
        return .video(.default)
      }
    }()
  }

  // MARK: Subtypes

  public enum AspectRatio {
    case ratio(Int, Int)
    case decimal(Decimal)
  }

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
    case auto(String?), north, west, south, east, center
    case northEast, northWest, southWest, southEast
    case face
  }

  public enum Quality {
    case auto, best, good, eco, low, value(Int)
  }

  public enum ImageFormat: String {
    case auto, heic, jpeg = "jpg", pdf, png, webp
    public static var `default`: ImageFormat {
      return .heic
    }
  }

  public enum AudioCodec: String {
    case passthrough, none, aac, mp3
  }

  public enum VideoCodec: String {
    case auto, h264, h265
  }

  public enum VideoFormat: String {
    case m4v, mkv, m3u8
    public static var `default`: VideoFormat {
      return .m4v
    }
  }

  public struct VideoTrim {
    public let start: TimeInterval?
    public let end: TimeInterval?
    public let duration: TimeInterval?
  }

  public enum Format {
    case image(ImageFormat)
    case video(VideoFormat)
  }

  public enum Kind {
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

  public static var host: CloudinaryHost = .standard

  public let cloudinaryID: String
  public let cloudinaryBucket: String?
  public let mediaType: CloudinaryMediaType
  public let deliveryType: DeliveryType
  public let transformationKind: Kind?
  public let format: Format

}

extension CloudinaryTransformation {

  private var pathPrefix: String {
    var path = [String]()
    if let cloudinaryBucket = cloudinaryBucket, case .standard = Self.host {
      path.append(cloudinaryBucket)
    }

    switch mediaType {
    case .image:
      path.append("image")
    case .video:
      path.append("video")
    }

    path.append("upload")
    return "/" + path.joined(separator: "/")
  }

  public var url: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = Self.host.host
    components.path = pathPrefix

    var url = components.url
    if let transformationKind = transformationKind {
      switch transformationKind {
      case let .dynamic(options):
        url = url?.appendingPathComponent(options.serialized())
      case let .named(name):
        url = url?.appendingPathComponent("t_\(name.rawValue)")
      }
    }

    url = url?.appendingPathComponent(cloudinaryID)

    switch format {
    case let .image(imageFormat):
      url = url?.appendingPathExtension(imageFormat.rawValue)
    case let .video(videoFormat):
      url = url?.appendingPathExtension(videoFormat.rawValue)
    }

    return url
  }

  public var rawURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = Self.host.host
    components.path = pathPrefix + "/" + cloudinaryID
    return components.url
  }

}

// MARK: CloudinaryTransformation.AspectRatio

extension CloudinaryTransformation.AspectRatio {

  var rawValue: String {
    switch self {
    case let .ratio(w, h):
      return "\(w):\(h)"
    case let .decimal(v):
      return "\(v)"
    }
  }

}

// MARK: CloudinaryTransformation.Gravity

extension CloudinaryTransformation.Gravity {

  var rawValue: String {
    switch self {
    case let .auto(string):
      return string.map { "auto:\($0)" } ?? "auto"
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
    case .face:
      return "face"
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
