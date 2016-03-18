//
//  RecordedAudio.swift
//  Pitch Perfect

//  Created by Steven Hertz on 7/7/15.
//  Copyright (c) 2015 Steven Hertz. All rights reserved.
//

import Foundation

class RecordedAudio {
  var fielPathUrl: NSURL
  var title: String
  
  init(fielPathUrl: NSURL, title: String) {
    self.fielPathUrl = fielPathUrl
    self.title = title
  }

}
