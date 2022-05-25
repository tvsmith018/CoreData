//
//  AlbumModel.swift
//  Top100Official
//
//  Created by Consultant on 5/20/22.
//

import Foundation

struct musicModel: Decodable{
    let feed: Feed
}

struct Feed:Decodable {
    let title: String
    let id: String
    let author: Author
    //let links: [Link]
    let copyright, country: String
    let icon: String
    let updated: String
    let results: [Result1]
}

struct Author: Decodable{
    let name: String
    let url: String
}

struct Link: Decodable{
    let linkSelf: String
}

struct Result1: Decodable{
    let artistName, id, name, releaseDate: String
    //let kind: Kind
    let artistID: String?
    let artistURL: String?
    //let contentAdvisoryRating: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String
}

enum ContentAdvisoryRating: Decodable {
    case explict
}

struct Genre: Decodable{
    //let genreID: String
    let name: String
    let url: String
}

enum Kind: Decodable {
    case albums
}
