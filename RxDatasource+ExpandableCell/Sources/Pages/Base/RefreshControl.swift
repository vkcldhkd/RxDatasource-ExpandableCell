//
//  RefreshControl.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import UIKit

final class RefreshControl: UIRefreshControl {
    private static let swizzle: Void = {
        method_exchangeImplementations(
            class_getInstanceMethod(RefreshControl.self, NSSelectorFromString("_scrollViewHeight"))!,
            class_getInstanceMethod(RefreshControl.self, NSSelectorFromString("ss_scrollViewHeight"))!
        )
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.zPosition = -999
//        self.tintColor = Colors.main
        self.tintColor = .gray
    }
    
    override convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        RefreshControl.swizzle
        super.didMoveToSuperview()
        if let scrollView = self.superview as? UIScrollView {
            self.tintColor = self.tintColor ?? UIRefreshControl.appearance().tintColor
            scrollView.contentOffset.y = CGFloat(-self.frame.height)
        }
    }
    
    @objc func ss_scrollViewHeight() -> CGFloat {
        // this makes refresh control distance shorter
        return 0
    }
}
