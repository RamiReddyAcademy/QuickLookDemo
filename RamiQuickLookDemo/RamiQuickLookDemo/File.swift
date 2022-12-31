//
//  File.swift
//  RamiQuickLookDemo
//
//  Created by RamiReddy on 11/12/22.
//

import UIKit
import QuickLook

class File:NSObject{
    let url:URL
    init(url: URL) {
        self.url = url
    }
    var name:String {
        url.deletingPathExtension().lastPathComponent
    }
}

//MARK:- QL Preview Item
extension File:QLPreviewItem{
    var previewItemURL: URL?{
        url
    }
}


extension File {
    func generateThumbNail(completion:@escaping (UIImage) -> Void) {
        let size = CGSize(width: 120, height: 102)
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
        
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { thumbanil, _,error in
            if let thumbnail = thumbanil {
                completion(thumbnail.uiImage)
            } else if let error = error {
                print(error)
            }
            
        }
    }
}
