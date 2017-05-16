# TCScreenShotTools

[![CI Status](http://img.shields.io/travis/itanchao/TCScreenShotTools.svg?style=flat)](https://travis-ci.org/itanchao/TCScreenShotTools)
[![Version](https://img.shields.io/cocoapods/v/TCScreenShotTools.svg?style=flat)](http://cocoapods.org/pods/TCScreenShotTools)
[![License](https://img.shields.io/cocoapods/l/TCScreenShotTools.svg?style=flat)](http://cocoapods.org/pods/TCScreenShotTools)
[![Platform](https://img.shields.io/cocoapods/p/TCScreenShotTools.svg?style=flat)](http://cocoapods.org/pods/TCScreenShotTools)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TCScreenShotTools is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TCScreenShotTools"
```

## Setting

![](./setting.png)

## Using



```swift
 import TCScreenShotTools
class AppDelegate{
  func shareView(_ shareView: TrickyShareView, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage) {
        print(withShareType)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        TCScreenShotTools.shared.enable = true
        TCScreenShotTools.shared.handle = shareView(_:didClickShareBtn:withIcon:)
        return true
    }
}

```





![yanshi](./演示.gif)



## Author

itanchao, itanchao@gmail.com

## License

TCScreenShotTools is available under the MIT license. See the LICENSE file for more info.
