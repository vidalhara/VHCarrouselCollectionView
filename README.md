# VHCarrouselCollectionView

[![Swift](https://img.shields.io/badge/Swift-4.0_5.1_5.2_5.3_5.4_5.5_5.6_5.7-blue)](https://img.shields.io/badge/Swift-4.0_5.1_5.2_5.3_5.4_5.5-Orange)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-blue)](https://img.shields.io/badge/Platforms-iOS-Blue)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-pistachiogreen)](https://img.shields.io/badge/Swift_Package_Manager-compatible-pistachiogreen)

VHCarrouselCollectionView is an horizontal UICollectionView written in Swift which loops infinitely.

## Requirements

| Platform | Minimum Swift Version | Installation |
| --- | --- | --- |
| iOS 11.0+ | 4.0 | [Swift Package Manager](#swift-package-manager) |

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding VHCarrouselCollectionView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```
dependencies: [
    .package(url: "https://github.com/vidalhara/VHCarrouselCollectionView.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

You should call following functions in order to work your carrousel.

```
@IBOutlet weak var collectionView: VHCarrouselCollectionView!

extension ViewController: UICollectionViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        collectionView.scrollViewWillBeginDragging()
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        collectionView.scrollViewWillEndDragging(with: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.scrollViewDidEndScrollingAnimation()
    }
}
```

## Configure Example

```
let source: [UIColor] = [.purple, .green, .blue]

collectionView.delegate = self
collectionView.dataSource = self
collectionView.carrouselDelegate = self
collectionView.sourceMultiplier = .triple

extension ViewController: VHCarrouselCollectionViewDelegate {
    func vhCarrouselView(
        _ carrouselView: VHCarrouselCollectionView, centeredSourceIndexPath sourceIndexPath: IndexPath
    ) {
        debugPrint("\(sourceIndexPath.item)")
    }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LocalCVC
        let sourceIndex = indexPath.vhCarrouselSourceIndexPath(for: collectionView).item
        cell.backgroundColor = source[sourceIndex]
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
}

```

## License

VHCarrouselCollectionView is released under the MIT license. [See LICENSE](https://github.com/vidalhara/VHCarrouselCollectionView/blob/master/LICENSE) for details.
