//
//  HorizontalFlowLayout.swift
//  AppStore
//
//  Created by seojiwon on 2017. 12. 7..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class HorizontalFlowLayout: UICollectionViewFlowLayout {
    
    var saveOffset = CGPoint()
    var baseLineX: CGFloat = 0.0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard
            let collectionView = self.collectionView,
            let cells = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return saveOffset }
        
        var candidate : UICollectionViewLayoutAttributes?
        
        for cell in cells {
            guard let leftCell = candidate else {
                candidate = cell
                continue
            }
            
            if velocity.x == 0 { //속도가 0일 경우 중앙을 기점으로 좌우 거리 비교 후 이동
                let center = collectionView.contentOffset.x + baseLineX
                let left = leftCell.center.x - center < 0 ? -(leftCell.center.x - center) : (leftCell.center.x - center)
                let right = cell.center.x - center < 0 ? -(cell.center.x - center) : (cell.center.x - center)
                if left > right { candidate = cell }// 속도 없이 오른쪽이 더 가까운 상태로 놓을 경우 오른쪽 셀로 이동
                
            } else if velocity.x > 0 { candidate = cell } // 오른쪽으로 속도 있게 스크롤 시 오른쪽 셀로 이동
            
        }
        
        guard let confirmCell = candidate else { return saveOffset }
        saveOffset = CGPoint(x: floor(confirmCell.center.x - baseLineX), y: proposedContentOffset.y)
        return saveOffset
    }
}
