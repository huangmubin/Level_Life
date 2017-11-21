//
//  NavigationController.swift
//  Level Life
//
//  Created by Myron on 2017/11/21.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    /** 返回当前控制器支持的屏幕方向
     如果是 UIAlertController 则选择下一个控制器
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        var visible = self.viewControllers.count - 1
        while visible >= 0 {
            switch self.viewControllers[visible] {
            case is UIAlertController: break
            default:
                return self.viewControllers[visible].supportedInterfaceOrientations
            }
            visible -= 1
        }
        return self.visibleViewController?.supportedInterfaceOrientations ?? .all
    }
    
    /** 返回当前状态栏是否隐藏
     如果是 UIAlertController 则选择下一个控制器
     */
    override var prefersStatusBarHidden: Bool {
        var visible = self.viewControllers.count - 1
        while visible >= 0 {
            switch self.viewControllers[visible] {
            case is UIAlertController: break
            default:
                return self.viewControllers[visible].prefersStatusBarHidden
            }
            visible -= 1
        }
        return self.visibleViewController?.prefersStatusBarHidden ?? false
    }
}
