//
//  TabBarController.swift
//  Level Life
//
//  Created by Myron on 2017/11/21.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Value
    
    /** 是否在横屏的时候隐藏 TabBar */
    @IBInspectable var tabBar_hide_at_landscape: Bool = false
    
    // MARK: - View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientation_will_changed),
            name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 屏幕支持方向与状态栏
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }
    
    // MARK: - 屏幕旋转事件
    
    /** 屏幕即将旋转监听 */
    @objc private func orientation_will_changed() {
        let portrait = UIScreen.main.bounds.height < UIScreen.main.bounds.width
        switch UIDevice.current.orientation {
        case .faceDown, .faceUp, .portrait, .portraitUpsideDown, .unknown:
            orientation_will_changed_aciton(is_portrait_now: portrait, is_portrait_after: true)
            tabbar_changed_to(hidden: false)
        case .landscapeLeft, .landscapeRight:
            orientation_will_changed_aciton(is_portrait_now: portrait, is_portrait_after: false)
            if tabBar_hide_at_landscape {
                tabbar_changed_to(hidden: true)
            } else {
                tabbar_changed_to(hidden: false)
            }
        }
    }
    
    /** 子类重写 - 屏幕即将旋转 */
    func orientation_will_changed_aciton(is_portrait_now: Bool, is_portrait_after: Bool) { }
    
    // MARK: - TabBar Hidden
    
    /** Tabbar 高度记录 */
    private var tabbar_height_tag: CGFloat = 0
    /** 修改 Tabbar 隐藏状态 */
    func tabbar_changed_to(hidden: Bool) {
        if tabbar_height_tag == 0 {
            tabbar_height_tag = self.view.subviews.first?.frame.height ?? 0
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.subviews.first?.frame.size.height = hidden ? 0 : self.tabbar_height_tag
            self.tabBar.isHidden = hidden
        })
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let controller = viewController as? ViewController {
            return controller.tabbar_controller(
                current_index: self.selectedIndex,
                current_controller: selectedViewController,
                select_index: viewControllers?.index(of: viewController)
            )
        } else if let controller = viewController as? TableViewController {
            return controller.tabbar_controller(
                current_index: self.selectedIndex,
                current_controller: selectedViewController,
                select_index: viewControllers?.index(of: viewController)
            )
        } else if let navigation = viewController as? NavigationController {
            if let controller = navigation.viewControllers.first as? ViewController {
                return controller.tabbar_controller(
                    current_index: self.selectedIndex,
                    current_controller: selectedViewController,
                    select_index: viewControllers?.index(of: viewController)
                )
            } else if let controller = viewController as? TableViewController {
                return controller.tabbar_controller(
                    current_index: self.selectedIndex,
                    current_controller: selectedViewController,
                    select_index: viewControllers?.index(of: viewController)
                )
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let controller = viewController as? ViewController {
            controller.tabbar_controller(did_select_index: selectedIndex)
        } else if let controller = viewController as? TableViewController {
            controller.tabbar_controller(did_select_index: selectedIndex)
        } else if let navigation = viewController as? NavigationController {
            for navigation_controller in navigation.viewControllers {
                if let controller = navigation_controller as? ViewController {
                    controller.tabbar_controller(did_select_index: selectedIndex)
                } else if let controller = viewController as? TableViewController {
                    controller.tabbar_controller(did_select_index: selectedIndex)
                }
            }
        }
    }
    
}
