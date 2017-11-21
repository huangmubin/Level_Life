//
//  ViewController.swift
//  Level Life
//
//  Created by Myron on 2017/11/21.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

/** Base View Controller, extension view controller methods. */
class ViewController: UIViewController {
    
    // MARK: - Values
    
    /** 是否是当前屏幕上显示的控制器 */
    public var is_appearing_controller: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        is_appearing_controller = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        is_appearing_controller = false
    }
    
    // MARK: - View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientation_will_changed),
            name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientation_did_changed),
            name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboard_will_changed_frame(_:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Orientation Supporet
    
    /** 屏幕支持的旋转方向是否只支持竖屏 */
    @IBInspectable var orientation_only_portrait: Bool = true {
        didSet {
            if orientation_only_portrait {
                value_supportedInterfaceOrientations = .portrait
            } else {
                value_supportedInterfaceOrientations = .all
            }
        }
    }
    /** 变量 - 屏幕支持的旋转方向，默认只支持竖屏 */
    var value_supportedInterfaceOrientations: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
    /** 屏幕支持的旋转方向，默认只支持竖屏 */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return value_supportedInterfaceOrientations
    }
    
    // MARK: - Status Bar State
    
    /** 变量 - 状态栏是否隐藏，默认否 */
    var value_prefersStatusBarHidden: Bool = false
    /** 状态栏是否隐藏，默认否 */
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - 屏幕旋转事件
    
    /** 屏幕即将旋转监听 */
    @objc private func orientation_will_changed() {
        switch UIDevice.current.orientation {
        case .faceDown, .faceUp, .portrait, .portraitUpsideDown:
            orientation_will_changed_aciton(is_portrait_now: UIScreen.main.bounds.height < UIScreen.main.bounds.width, is_portrait_after: true)
        case .landscapeLeft, .landscapeRight:
            orientation_will_changed_aciton(is_portrait_now: UIScreen.main.bounds.height < UIScreen.main.bounds.width, is_portrait_after: false)
        case .unknown:
            orientation_will_changed_aciton(is_portrait_now: UIScreen.main.bounds.height < UIScreen.main.bounds.width, is_portrait_after: UIScreen.main.bounds.height < UIScreen.main.bounds.width)
        }
    }
    
    /** 屏幕完成旋转监听 */
    @objc private func orientation_did_changed() {
        DispatchQueue.main.async { [weak self] in
            self?.orientation_did_changed_aciton(is_portrait: UIScreen.main.bounds.height < UIScreen.main.bounds.width)
        }
    }
    
    /** 子类重写 - 屏幕即将旋转 */
    func orientation_will_changed_aciton(is_portrait_now: Bool, is_portrait_after: Bool) { }
    /** 子类重写 - 屏幕完成旋转 */
    func orientation_did_changed_aciton(is_portrait: Bool) { }
    
    // MARK: - Key Board Changed
    
    /** 键盘变化事件监听 */
    @objc func keyboard_will_changed_frame(_ notification: Notification) {
        if let info = notification.userInfo {
            if let rect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyboard_will_changed_frame_action(keyboard: rect, bottom_space: self.view.frame.height - (rect.origin.y - self.view.frame.origin.y))
            }
        }
    }
    
    /** 子类重写 - 键盘变化事件监听 */
    func keyboard_will_changed_frame_action(keyboard: CGRect, bottom_space: CGFloat) { }
    
    // MARK: - Tab Bar 调用事件
    
    /** 子类重写 - TabBarController 能否选择当前控制器 */
    func tabbar_controller(current_index: Int, current_controller: UIViewController?, select_index: Int?) -> Bool {
        return true
    }
    
    /** 子类重写 - TabBarController 选择了当前控制器 */
    func tabbar_controller(did_select_index index: Int) { }
}

// MARK: - Class Tools

extension ViewController {
    
    /** 获取当前屏幕最顶部的控制器 */
    class func top_view_controller() -> UIViewController? {
        func top(controller: UIViewController) -> UIViewController? {
            if let navigation = controller as? UINavigationController {
                return navigation.topViewController
            } else if let tabbar = controller as? UITabBarController {
                return tabbar.selectedViewController
            } else {
                return controller
            }
        }
        
        var top_controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while top_controller?.presentedViewController != nil {
            top_controller = top(controller: top_controller!.presentedViewController!)
        }
        return top_controller
    }
    
}
