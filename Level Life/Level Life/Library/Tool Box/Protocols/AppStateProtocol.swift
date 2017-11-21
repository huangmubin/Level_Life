//
//  AppStateProtocol.swift
//  Level Life
//
//  Created by Myron on 2017/11/21.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

@objc protocol AppStateProtocol: NSObjectProtocol {
    /** 双击 home 键，拉起控制栏 */
    @objc optional func application_will_resign_active(_ application: UIApplication)
    /** 锁屏，进入后台 */
    @objc optional func application_did_enter_background(_ application: UIApplication)
    /** 开屏，即将进入前台 */
    @objc optional func application_will_enter_foreground(_ application: UIApplication)
    /** 进入活动状态 */
    @objc optional func application_did_become_active(_ application: UIApplication)
    /** 应用被强退 */
    @objc optional func application_will_terminate(_ application: UIApplication)
}
