[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<a href="https://twitter.com/kazuwombat">
	<img src="https://img.shields.io/badge/contact-@kazuwombat-blue.svg?style=flat" alt="Twitter: @kazuwombat" />
</a>
# PositionScrollView
![アセット 2@3x](https://user-images.githubusercontent.com/6919381/92070946-70453200-ede8-11ea-9960-dca19aebd2eb.png)

> Position Scroll View is  pure Swift UI Scroll View which can get or move scroll position.

<img src="https://user-images.githubusercontent.com/6919381/92070990-94a10e80-ede8-11ea-8a70-a9e55bfcb513.gif" data-canonical-src="https://gyazo.com/eb5c5741b6a9a16c692170a41a49c858.png" width="375" />

##  Features
- [x] Get scroll position of scroll
- [x] Vertical, Horizontal,  Two Dimensional scroll
- [x] Move scroll position by code
- [x] Stick edge of scroll page or follow momentum  after scroll ends.

## Requirements
* Xcode 11.6+
* Swift 5.2+

## Install
SwiftPackageManager
Add `url` in the Swit Package Magener tab in Xcode

CocoaPods

```
pod ‘PositionScrollView’ 
```

##  Usage
PositionScrollView divides whole target view to pages and units to treat scroll position easily.
![Group 38](https://user-images.githubusercontent.com/6919381/92071233-290b7100-ede9-11ea-92d9-0b574b9ea378.png)

And you can get/set position in each ranges.
![Group 41](https://user-images.githubusercontent.com/6919381/92072022-39245000-edeb-11ea-9eb3-fcc8ea3f6593.png)

Minimal horizontal scroll view example below.

```swift
import Foundation
import SwiftUI

/// Extended ScrollView which can controll position
public struct MinimalHorizontalExample: View, PositionScrollViewDelegate {
    /// Page size of Scroll
    var pageSize = CGSize(width: 200, height: 300)
    
    // Create PositionScrollViewModel
    // (Need to create in parent view to bind the state between this view and PositionScrollView)
    @ObservedObject var psViewModel = PositionScrollViewModel(
        pageSize: CGSize(width: 200, height: 300),
        horizontalScroll: Scroll(
            scrollSetting: ScrollSetting(pageCount: 5, afterMoveType: .stickNearestUnitEdge),
            pageLength: 200 // Page length of direction
        )
    )
   
    public var body: some View {
        return VStack {
            PositionScrollView(
                viewModel: self.psViewModel,
                delegate: self
            ) {
                HStack(spacing: 0) {
                    ForEach(0...4, id: \.self){ i in
                        ZStack {
                            Rectangle()
                                .fill(BLUES[i])
                                .border(Color.black)
                                .frame(
                                    width: self.pageSize.width, height: self.pageSize.height
                            )
                            Text("Page\(i)")
                                .foregroundColor(Color.white)
                                .font(.system(size: 24, weight: .heavy, design: .default))
                        }
                    }
                    
                }
            }
			  // Get page via scroll object
            Text("page: \(self.psViewModel.horizontalScroll?.page ?? 0)")
			  // Get position via scroll object
            Text("position: \(self.psViewModel.horizontalScroll?.position ?? 0)")
        }
    }
    
    struct SampleView_Previews: PreviewProvider {
        static var previews: some View {
            return MinimalHorizontalExample()
        }
    }
    
    // Delegate methods of PositionScrollView
	  // You can monitor changes of position
    public func onScrollStart() {
        print("onScrollStart")
    }
    public func onChangePage(page: Int) {
        print("onChangePage to page: \(page)")
    }
    
    public func onChangePosition(position: CGFloat) {
        print("position: \(position)")
    }
    
    public func onScrollEnd() {
        print("onScrollEnd")
    }
}
```

## API Details
### ScrollSetting
Setting variables
| ValueName  | Type | Default | Detail |
| ------------- | ------------- | ------------- | ------------- | 
| pageCount* | Int | - |Count of page |
| initialPage | Int | 0 | Initial page of scroll |
| unitCountInPage | Int | 1 | Unit count of single page |
| afterMoveType | AfterScrollEndsBehavior | .stickToNearestUnitEdge | Behavior of scroll move after scroll ends<br>  stickToNearestUnitEdge: Stick nearest unit edge<br>  momentum: It move until momentum disappear.|
| scrollSpeedToDetect | Double | 30 | Scroll speed to detect |

### Scroll
Variables

| ValueName  | Type | Detail |
| ------------- | ------------- | ------------- | 
| position | CGFloat | Position based on the start of page 0 |
| page | Int | Current page |
| positionInPage | CGFloat | Current position based on the start of the page |
| unit | Int | Current unit in page |
| positionInUnit | CGFloat | Current position based on the start of the unit |

Functions

| FunctionName | Args | Detail |
| ------------- | ------------- | ------------- | 
| moveBy | value: CGFloat | Move scroll by argment value |
| moveTo | position: CGFloat | Move scroll to argment position |
| moveToPage | page: Int <br> unit: Int = 0 <br> positionInUnit: CGFloat = 0 | Move scroll to argument page|

### PositionScrollViewDelegate

| FunctionName | Args | Detail |
| ------------- | ------------- | ------------- |
| onScrollStart | - | Called when a scroll starts|
| onChangePosition | position: CGFloat |Called when position changed|
| onChangePage | page: Int | Called when scroll page changed |
| onChangeUnit | unit: Int | Called when unit changed |
| onChangePositionInPage | positionInPage: CGFloat | Called when position in page changed |
| onChangePositionInUnit | positionInUnit: CGFloat | Called when position in unit changed | 
| onScrollEnd | - | Called when a scroll ends |


## Contact, Author
Please feel free to contact me.
[kazuooooo](https://github.com/kazuooooo)

[Company](https://wombat-tech.com)



