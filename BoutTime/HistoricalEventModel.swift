//
//  HistoricalEventModel.swift
//  BoutTime
//
//  Created by William Vivas on 7/6/16.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import GameKit

protocol Equatable {}
protocol Comparable {}

func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.year == rhs.year && lhs.month == rhs.month
}

func <(lhs: Event, rhs: Event) -> Bool {
    return lhs.year < rhs.year || (lhs.year == rhs.year && lhs.month < rhs.month)
}

struct Event: Equatable, Comparable {
    
    let description: String
    let year: Int
    let month: Int
    let website: String
}

struct HistoricalEventModel {
    let eventCollection: [Event] = [
        Event(description: "Mike Markkula named apple CEO", year: 1981, month: 1, website: "https://en.wikipedia.org/wiki/Mike_Markkula"),
        Event(description: "Swift 1.0 release", year: 2014, month: 9, website: "https://en.wikipedia.org/wiki/Swift_(programming_language)"),
        Event(description: "John Scully takes over as president and CEO of Apple", year: 1983, month: 6, website: "https://en.wikipedia.org/wiki/John_Sculley"),
        Event(description: "Apple Macintosh is released", year: 1984, month: 7, website: "https://en.wikipedia.org/wiki/Macintosh"),
        Event(description: "Apple Lisa is released", year: 1983, month: 9, website: "https://en.wikipedia.org/wiki/Apple_Lisa"),
        Event(description: "Post-it's are first sold across the US", year: 1980, month: 4, website:  "https://en.wikipedia.org/wiki/Post-it_note"),
        Event(description: "Steve Jobs leaves apple and launches Next", year: 1985, month: 7, website: "https://en.wikipedia.org/wiki/NeXT_Computer"),
        Event(description: "Mac Portable is released", year: 1989, month: 9, website: "https://en.wikipedia.org/wiki/Macintosh_Portable"),
        Event(description: "Steve Jobs Establishes Pixar", year: 1986, month: 1, website: "https://en.wikipedia.org/wiki/Pixar"),
        Event(description: "Powerbook 100 released", year: 1991, month: 7, website: "https://en.wikipedia.org/wiki/PowerBook_100"),
        Event(description: "Michael Spindler named CEO of Apple", year: 1993, month: 1, website: "https://en.wikipedia.org/wiki/Michael_Spindler"),
        Event(description: "Apple acquires Next company", year: 1996, month: 1, website: "https://en.wikipedia.org/wiki/NeXT"),
        Event(description: "Steve jobs returns to apple as interim CEO", year: 1997, month: 1, website: "https://en.wikipedia.org/wiki/History_of_Apple_Inc."),
        Event(description: "The iMac is released", year: 1998, month: 10, website: "https://en.wikipedia.org/wiki/IMac"),
        Event(description: "First iPod is released", year: 2001, month: 1, website: "https://en.wikipedia.org/wiki/IPod"),
        Event(description: "iTunes music store opens", year: 2003, month: 10, website: "https://en.wikipedia.org/wiki/ITunes"),
        Event(description: "The first iphone is released", year: 2007, month: 3, website: "https://en.wikipedia.org/wiki/IPhone"),
        Event(description: "first iPad is released", year: 2010, month: 11, website: "https://en.wikipedia.org/wiki/IPad"),
        Event(description: "Tim Cook becomes CEO of Apple", year: 2011, month: 4, website: "https://en.wikipedia.org/wiki/Tim_Cook"),
        Event(description: "Apple releases Macbook Air", year: 2008, month: 3, website: "https://en.wikipedia.org/wiki/MacBook_Air"),
        Event(description: "iPad air is released", year: 2013, month: 10, website: "https://en.wikipedia.org/wiki/IPad_Air"),
        Event(description: "Apple watch makes its debut", year: 2015, month: 4, website: "https://en.wikipedia.org/wiki/Apple_Watch"),
        Event(description: "Swift 3.0 is released", year: 2016, month: 7, website: "https://swift.org/blog/swift-3-0-released/"),
        Event(description: "Apple pencil is released", year: 2015, month: 12, website: "https://en.wikipedia.org/wiki/Apple_Pencil"),
        Event(description: "Apple TV is released", year: 2007, month: 1, website: "https://en.wikipedia.org/wiki/Apple_TV")
    ]
    
    var events: [Event] = []
    
    init() {
        getNewEvents()
    }
    
    subscript(index: Int) -> Event {
        return events[index]
    }
    
    mutating func rearrangeEvents(_ indexA: Int, indexB: Int) {
        let temp: Event = events[indexA]
        events[indexA] = events[indexB]
        events[indexB] = temp
    }
    
    mutating func getNewEvents() {
        var indices: [Int] = []
        indices.append(GKRandomSource.sharedRandom().nextInt(upperBound: eventCollection.count))
        while indices.count < 4 {
            let newIndex = GKRandomSource.sharedRandom().nextInt(upperBound: eventCollection.count)
            if !(indices.contains(newIndex)) { // ensure no duplicates
                indices.append(newIndex)
            }
        }

        events = (0..<4).map({eventCollection[indices[$0]]})
    }
    
    func inOrder() -> Bool {
        return events[0] < events[1] && events[1] < events[2] && events[2] < events[3]
    }
}
