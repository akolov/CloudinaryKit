//
//  CloudinaryVideoOptions.swift
//  CloudinaryKit
//
//  Created by Alexander Kolov on 2018-12-10.
//  Copyright © 2018 Wineapp Ltd. All rights reserved.
//

#if canImport(UIKit)
import UIKit.UIScreen
#elseif canImport(AppKit)
import AppKit
#endif

public struct CloudinaryVideoOptions: CloudinaryTransformationOptions {

  public let audioCodec: CloudinaryTransformation.AudioCodec
  public let videoCodec: CloudinaryTransformation.VideoCodec
  public let crop: CloudinaryTransformation.Crop
  public let effect: String?
  public let flags: [VideoFlags]
  public let framerate: ClosedRange<Int>?
  public let gravity: CloudinaryTransformation.Gravity
  public let quality: Int?
  public let trim: CloudinaryTransformation.VideoTrim?
  public let height: Double?
  public let width: Double?
  public let aspectRatio: CloudinaryTransformation.AspectRatio?

  #if canImport(UIKit)
  public let scale = UIScreen.main.scale
  #elseif canImport(AppKit)
  public let scale = NSScreen.main?.backingScaleFactor ?? 1.0
  #endif

  public enum VideoFlags: String {
    case waveform = "fl_waveform"
  }

}

extension CloudinaryVideoOptions {

  public init(
    audioCodec: CloudinaryTransformation.AudioCodec = .passthrough,
    videoCodec: CloudinaryTransformation.VideoCodec = CloudinaryVideoOptions.defaultVideoCodec,
    crop: CloudinaryTransformation.Crop = .none,
    effect: String? = nil,
    flags: [CloudinaryVideoOptions.VideoFlags] = [],
    framerate: ClosedRange<Int>? = nil,
    gravity: CloudinaryTransformation.Gravity = .center,
    quality: Int? = nil,
    trim: CloudinaryTransformation.VideoTrim? = nil,
    width: Double? = nil,
    height: Double? = nil,
    aspectRatio: CloudinaryTransformation.AspectRatio
  ) {
    self.audioCodec = audioCodec
    self.videoCodec = videoCodec
    self.crop = crop
    self.effect = effect
    self.flags = flags
    self.framerate = framerate
    self.gravity = gravity
    self.quality = quality
    self.trim = trim
    self.width = width
    self.height = height
    self.aspectRatio = aspectRatio
  }

  public func serialized() -> String {
    var encodingParams = [String]()
    var transParams = [String]()

    encodingParams.append("f_mp4")

    if audioCodec != .passthrough {
      encodingParams.append("ac_" + audioCodec.rawValue)
    }

    if videoCodec != .auto {
      encodingParams.append("vc_" + videoCodec.rawValue)
    }

    if let framerate = framerate {
      if framerate.lowerBound == framerate.upperBound {
        encodingParams.append("fps_\(framerate.lowerBound)")
      }
      else {
        encodingParams.append("fps_\(framerate.lowerBound)-\(framerate.upperBound)")
      }
    }

    if let quality = quality {
      encodingParams.append("q_\(quality)")
    }

    if crop != .none {
      transParams.append("c_" + crop.rawValue)
    }

    if let effect = effect {
      transParams.append("e_" + effect)
    }

    if !flags.isEmpty {
      transParams.append(flags.map { $0.rawValue }.joined(separator: "."))
    }

    if gravity != .center {
      transParams.append("g_" + gravity.rawValue)
    }

    if let trim = trim {
      if let start = trim.start {
        transParams.append("so_\(start)")
      }

      if let end = trim.end {
        transParams.append("eo_\(end)")
      }

      if let duration = trim.duration {
        transParams.append("du_\(duration)")
      }
    }

    if let height = height {
      transParams.append("h_\(Int(height))")
    }

    if let width = width {
      transParams.append("w_\(Int(width))")
    }

    if let aspectRatio = aspectRatio {
      transParams.append("ar_\(aspectRatio.rawValue)")
    }

    if scale != 1.0 {
      transParams.append("dpr_\(scale)")
    }

    let params = [encodingParams, transParams]
    return params
      .map { $0.joined(separator: ",") }
      .filter { !$0.isEmpty }
      .joined(separator: "/")
  }

  public static let defaultVideoCodec: CloudinaryTransformation.VideoCodec = {
    if #available(iOS 11, *) {
      return .h265
    }
    else {
      return .h264
    }
  }()

}
