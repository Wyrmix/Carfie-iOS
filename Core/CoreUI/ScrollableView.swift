//
//  ScrollableView.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol ScrollableView: class {
    var scrollView: UIScrollView { get }
    var containingView: UIView { get }
    
    func adjustScrollViewForKeyboard(_ scrollViewPosition: ScrollViewPosition, and viewToScroll: UIView?)
}

extension ScrollableView {
    func adjustScrollViewForKeyboard(_ scrollViewPosition: ScrollViewPosition, and viewToScroll: UIView?) {
        scrollView.contentInset = scrollViewPosition.insets
        scrollView.scrollIndicatorInsets = scrollViewPosition.insets
        
        guard let viewToScroll = viewToScroll else { return }
        
        var visibleRect = containingView.frame
        visibleRect.size.height -= scrollViewPosition.frame.height
        if visibleRect.contains(viewToScroll.frame.origin) {
            scrollView.scrollRectToVisible(viewToScroll.frame, animated: true)
        }
    }
}
