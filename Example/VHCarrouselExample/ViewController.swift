//
//  ViewController.swift
//  CarrouselCV
//
//  Created by Vidal HARA on 23.07.2022.
//

import UIKit
import VHCarrouselCollectionView

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: VHCarrouselCollectionView!
    let source: [UIColor] = [.purple, .green, .blue]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.carrouselDelegate = self
        collectionView.sourceMultiplier = .triple
        collectionView.configureTimer(interval: 2, animated: true)

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.enableTimer()
        }
    }
}

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
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LocalCVC
        let sourceIndex = indexPath.vhCarrouselSourceIndexPath(for: collectionView).item
        cell.backgroundColor = source[sourceIndex]
        cell.label.text = "\(indexPath.row)"
        return cell
        // swiftlint:enable force_cast
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

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

final class LocalCVC: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}
