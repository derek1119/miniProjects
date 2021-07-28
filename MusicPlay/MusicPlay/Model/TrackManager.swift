//
//  TrackManager.swift
//  MusicPlay
//
//  Created by Sh Hong on 2021/07/27.
//

import UIKit
import AVFoundation

class TrackManager {
    //필요한 것들 : 트랙들, 앨범들, 오늘의 곡
    var tracks : [AVPlayerItem] = []
    var albums : [Album] = []
    var todaysTrack : AVPlayerItem?
    
    init() {
        let tracks = loadTracks()
        self.tracks = tracks
        self.albums = loadAlbums(tracks: tracks)
        self.todaysTrack = self.tracks.randomElement()
    }
    
    func loadTracks() -> [AVPlayerItem] {
        //파일들을 읽어서 avplayeritem 만들기
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
        
//        var items : [AVPlayerItem] = []
//
//        for url in urls {
//            let item = AVPlayerItem(url: url)
//            items.append(item)
//        }
        let items = urls.map { url in
           return AVPlayerItem(url: url)
        }
        
        return items
    }
    
    func track(at index : Int) -> Track? {
        let playerItem = tracks[index]
        let track = playerItem.convertToTrack()
        return track
    }
    
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let trackList: [Track] = tracks.compactMap{ $0.convertToTrack()}
        let albumDics = Dictionary(grouping: trackList, by: {(track) in track.albumName})
        var albums: [Album] = []
        for (key, value) in albumDics {
            let title = key
            let tracks = value
            let album = Album(title: title, tracks: tracks)
            albums.append(album)
        }
        
        return albums
    }
    
    func loadTodaysTrack() {
        self.todaysTrack = self.tracks.randomElement()
    }
}
