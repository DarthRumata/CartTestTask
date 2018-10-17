//
//  FileService.swift
//  Core
//
//  Created by Rumata on 4/2/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation

enum FileType: String {
  case json
}

enum FileError: Error {
  case invalidFileContent
  case fileNotFound(String)
}

final class FileService {

  func readTextFileInBundle(withName name: String, fileType: FileType) throws -> Data {
    let path = try filePathInBundle(withName: name, fileType: fileType)
    guard let data = try String(contentsOfFile: path).data(using: .utf8) else {
      throw FileError.invalidFileContent
    }

    return data
  }

  private func filePathInBundle(withName name: String, fileType: FileType) throws -> String {
    guard let path = Bundle.main.path(forResource: name, ofType: fileType.rawValue) else {
      throw FileError.fileNotFound("\(name).\(fileType.rawValue)")
    }

    return path
  }

}
