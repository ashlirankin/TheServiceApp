//
//  StorageService.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
import FirebaseStorage

struct StorageKeys {
  static let ImagesKey = "images"
}

final class StorageService {
  static var storageRef: StorageReference = {
    let ref = Storage.storage().reference()
    return ref
  }()
   static var currentUploadTask: StorageUploadTask?
  static public func postImage(imageData: Data, imageName: String, completion: @escaping (Error?, URL?) -> Void) {
    let metadata = StorageMetadata()
    let imageRef = storageRef.child(StorageKeys.ImagesKey + "/\(imageName)")
    metadata.contentType = "image/jpg"
    let uploadTask = imageRef
      .putData(imageData, metadata: metadata) { (metadata, error) in
        if let error = error {
          print("upload task error: \(error)")
        } else if let _ = metadata {
          
        }
    }
    
//    return uploadTask
//    uploadTask.pause()
    // upload
    uploadTask.observe(.failure) { (snapshot) in
      //
    }
    uploadTask.observe(.pause) { (snapshot) in
      //
    }
    uploadTask.observe(.progress) { (snapshot) in
      //
    }
    uploadTask.observe(.resume) { (snapshot) in
      //
    }
    uploadTask.observe(.success) { (snapshot) in
      //
      imageRef.downloadURL(completion: { (url, error) in
        if let error = error {
          completion(error, nil)
        } else if let url = url {
          completion(nil, url)
        }
      })
    }
  }
    
    
    static func uploadPortfolio(data: Data, fileName: String, block: @escaping (_ url: String?) -> Void) {
        // Upload the file to the path
        let metadata = StorageMetadata()
        let imageRef = StorageService.storageRef.child(StorageKeys.ImagesKey + "/portfolio/\(fileName)")
        metadata.contentType = "image/jpg"
        startUploading(data: data, withName: fileName, atPath: imageRef) { (url) in
            block(url)
        }
    }
    
   static func startUploading(data: Data, withName fileName: String, atPath path: StorageReference, block: @escaping(_ url: String?) -> Void) {
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpg"
        currentUploadTask = path.putData(data, metadata: metadata) { (metaData, error) in
            guard metaData != nil else {
                block(nil)
                return
            }
            
            path.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    block(nil)
                    return
                }
                block(downloadUrl.absoluteString)
            }
        }
        
    }
    
    func cancel() {
        StorageService.currentUploadTask?.cancel() 
    }
}
