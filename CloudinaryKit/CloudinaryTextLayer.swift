//
//  CloudinaryTextLayer.swift
//  CloudinaryKit
//
//  Created by Alexander Kolov on 2019-05-20.
//  Copyright © 2019 Wineapp Ltd. All rights reserved.
//

public struct CloudinaryTextLayer {

  public init(text: String, font: String, color: String? = nil) {
    self.text = text
    self.font = font
    self.color = color
  }

  public let text: String
  public let font: String
  public let color: String?

}

extension CloudinaryTextLayer: CloudinaryLayer {

  public func serialized() -> String {
    let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? text

    var params = ["l_text"]
    params.append(font)
    params.append(encoded)

    if let color = color {
      params.append(color)
    }

    return params.joined(separator: ":")
  }

}
