//
//  CompositionRoot.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import UIKit
import Kingfisher

struct AppDependency {
    let window: UIWindow
    let configureAppearance: () -> Void
}

final class CompositionRoot {
    static func resolve() -> AppDependency {
        // MARK: - Window
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.makeKeyAndVisible()
        window.rootViewController = UINavigationController(rootViewController: MainViewController())
        
        return AppDependency(
            window: window,
            configureAppearance: self.configureAppearance
        )
    }
    
    static func configureAppearance() {
        print("\(#function) AppDependency configureAppearance")
        // MARK: - TableView
        CompositionRoot.configureKingfisherAppearance()
    }
}


// MARK: - Kingfisher
private extension CompositionRoot {
    static func configureKingfisherAppearance() {
        let scale = UIScreen.main.scale
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 300 * scale, height: 300 * scale))
        
        KingfisherManager.shared.defaultOptions += [
            .backgroundDecode,
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .transition(.fade(0.6)),
            .processor(resizingProcessor)
        ]
    }
}
