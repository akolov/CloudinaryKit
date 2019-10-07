//
//  CloudinaryVideoOptions.swift
//  CloudinaryKit
//
//  Created by Alexander Kolov on 2018-12-10.
//  Copyright © 2018 Wineapp Ltd. All rights reserved.
//

import UIKit.UIScreen

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
  public let scale = UIScreen.main.scale

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
    height: Double? = nil
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
  }

  public func serialized() -> String {
    var params = [String]()

    params.append("f_mp4")

    if audioCodec != .passthrough {
      params.append("ac_" + audioCodec.rawValue)
    }

    if videoCodec != .auto {
      params.append("vc_" + videoCodec.rawValue)
    }

    if crop != .none {
      params.append("c_" + crop.rawValue)
    }

    if let effect = effect {
      params.append("e_" + effect)
    }

    if !flags.isEmpty {
      params.append(flags.map { $0.rawValue }.joined(separator: "."))
    }

    if let framerate = framerate {
      if framerate.lowerBound == framerate.upperBound {
        params.append("fps_\(framerate.lowerBound)")
      }
      else {
        params.append("fps_\(framerate.lowerBound)-\(framerate.upperBound)")
      }
    }

    if gravity != .center {
      params.append("g_" + gravity.rawValue)
    }

    if let quality = quality {
      params.append("q_\(quality)")
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

    return params.joined(separator: ",")
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
