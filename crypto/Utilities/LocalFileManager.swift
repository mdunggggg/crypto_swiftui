//
//  LocalFileManager.swift
//  crypto
//
//  Created by ImDung on 18/7/24.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    let folderName = "coin_images"
    private init(){
        createFolderIfNeeded()
    }
    
    private func createFolderIfNeeded(){
        guard let url = getFolderPath() else {
            return
        }
        if !FileManager.default.fileExists(atPath: url.path) {
            print("File is not exist")
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                print("Error when create folder")
            }
        }
    }
    
    private func getFolderPath() -> URL? {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(imageName : String) -> URL? {
        guard let folderImage = getFolderPath() else {return nil}
        return folderImage.appendingPathComponent(imageName + ".png")
    }
    
    func saveImage(image : UIImage, imageName : String){
        guard
            let data = image.pngData(),
            let url = getImagePath(imageName: imageName) else {return}
        do {
            try data.write(to: url)
        }
        catch{
            print("error when save image \(error)")
        }
    }
    
    func getImage(imageName : String) -> UIImage? {
        guard
            let url = getImagePath(imageName: imageName),
            FileManager.default.fileExists(atPath: url.path) else {return nil}
        return UIImage(contentsOfFile: url.path)
    }
    
    
    
}
