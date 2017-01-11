![import Genius](https://www.dropbox.com/s/w7ga70d9gt9a7d3/swifthub%20header.png?dl=1)

SwiftHub is an iOS app that displays Swift repositories from GitHub. SwiftHub was built with [StateView](https://github.com/sahandnayebaziz/StateView).

## Requirements

- Swift 3+
- StateView

## Overview

SwiftHub was the second app made with [StateView](https://github.com/sahandnayebaziz/StateView), an intuitive UIView subclass I made to help make managing views and rich, interactive states in an app easier and more approachable. 

Most of the work that you would normally do adding and removing subviews, orchestrating initializing those views and creating patterns to communicate information back and forth is taken care of by StateView as the normal code I wrote (not complex, cryptically functional, declarative, or stream and sequence based) does things like present a UIAlertController, accept an array of repositories from the GitHub API, and update a value in a state dictionary with the current filter being used. SwiftHub is safe, fast, and the source is happily missing a lot of code that would normally be there to move views around. 

SwiftHub is a simple app that can display the most popular repositories on GitHub written in Swift that were made in the last week, the last month, the last year, and anytime before that. 

SwiftHub is a great example of what you can do with [StateView](https://github.com/sahandnayebaziz/StateView).

## Screenshots

<img width=250 src="https://github.com/sahandnayebaziz/StateView-Samples-SwiftHub/blob/master/screenshot1.png?raw=true"> 
<img width=250 src="https://github.com/sahandnayebaziz/StateView-Samples-SwiftHub/blob/master/screenshot2.png?raw=true"> 

## Credits

SwiftHub was written by Sahand Nayebaziz and made with [StateView](https://github.com/sahandnayebaziz/StateView).

## License

SwiftHub is released under the MIT license. See LICENSE for details.
