//
//  UODownloadManager.swift
//
//  Created by Rana Alhaj
//


import Foundation
import AVKit

final class UODownloadManager {

    private init() {

    }
    static let shared:UODownloadManager = UODownloadManager()
    func downloadFile(url:String,filename:String,isDownloading:@escaping((Bool)->Void)) {
        print("downloadFile")
//        isDownloading = true

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(filename).mp4")
        if let destinationUrl = destinationUrl {
//            if (FileManager().fileExists(atPath: destinationUrl.path)) {
//                print("File already exists")
//                isDownloading(false)
           // } else {
                let urlRequest = URLRequest(url: URL(string: url)!)

                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

                    if let error = error {
                        print("Request error: ", error)
                        isDownloading(false)
                        return
                    }

                    guard let response = response as? HTTPURLResponse else { return }

                    if response.statusCode == 200 {
                        guard let data = data else {
                            isDownloading(false)
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)

                                DispatchQueue.main.async {
                                    isDownloading(true)
                                }
                            } catch let error {
                                print("Error decoding: ", error)
                                isDownloading(false)
                            }
                        }
                    }
                }
                dataTask.resume()
            //}
        }
    }
    func  getListVideosLocal(complation:(([String]?)->Void)){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)

            print(directoryContents)
            // if you want to filter the directory contents you can do like this:
            let mp4Files = directoryContents.filter{ $0.pathExtension == "mp4" }
            print("mp4 urls:",mp4Files)
            var mp4FilesStr:[String] = []
            for i in mp4Files{
                mp4FilesStr.append(i.lastPathComponent)
            }
            complation(mp4FilesStr)
//            let mp4FileNames = mp4Files.map{ $0.deletingPathExtension().lastPathComponent }
//            print("mp4 list:", mp4FileNames)
        } catch {
            print(error.localizedDescription)
            complation(nil)
        }

    }
    func deleteFile(filename : String) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(filename).mp4")
        if let destinationUrl = destinationUrl {
            guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
                print("File deleted successfully")
//                isDownloaded = false
            } catch let error {
                print("Error while deleting video file: ", error)
            }
        }
    }

    func checkFileExists() {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
//                isDownloaded = true
            } else {
//                isDownloaded = false
            }
        } else {
//            isDownloaded = false
        }
    }

    func getVideoFileAsset(filename:String) -> AVPlayerItem? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(filename).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                let avAssest = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAssest)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

