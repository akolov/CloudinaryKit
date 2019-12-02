//
//  CloudinaryHost.swift
//  CloudinaryKit
//
//  Created by Alexander Kolov on 2019-12-02.
//  Copyright © 2018 Wineapp Ltd. All rights reserved.
//

public enum CloudinaryHost {

  case standard
  case custom(String)

  var host: String {
    switch self {
    case .standard:
      return "res.cloudinary.com"
    case let .custom(value):
      return value
    }
  }

}
