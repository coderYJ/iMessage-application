//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by simplyou on 2016/9/20.
//  Copyright © 2016年 coderYJ. All rights reserved.
//



/*
 虽然没有严格限制,但是苹果建议的表情文件大小:
 1. Small: 100 x 100 pt @3x scale (300 x 300 pixel image)
 2. Medium: 136 x 136 pt @3x scale (378 x 378 pixel image)
 3. Large: 206 x 206 pt @3x scale (618 x 618 pixel image)
 
 表情包的大小:
 1. 文件中images不可以大于500kb;
 2. iamge不可以小于100 x 100 pt (300 x 300 pixels).
 3. iamge不可以大于206 x 206 pt (618 x 618 pixels).
 4. 图片格式必须是 PNG, APNG, JPEG, GIF ;
 
 
 MessageExtension文件
 1. MessagesViewController.swift : iMessage app的程序入口;
 2. MainInterface.storyboard: 可视化操作;
 3. Assets.xcassets: 图片集合;
 4. Info.plist : 配置一些扩展信息;
 */

/* 文档注释
 //        // 这个就是一个image
 //        let image = #imageLiteral(resourceName: "02.png")
 //        // 一个image
 //        let image1 = #imageLiteral(resourceName: "hello")
 //
 //        let imageV =  UIImageView(image: image)
 //        view.addSubview(imageV)
 */
import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // 创建一个MSSticker数组来存储我们的表情包
    var stickers = [MSSticker]()
    /**
      这个方法是用来初始化表情数据的
     - returns: 返回值
     - throws: 抛出异常
     */

    
    // 微信公众号关注iOS精汇 coderYJ
    
    // 文本注释快捷键
    //    option + command + /
    
    
    
    /// 单行文本注释
    ///
    /// 多行文本注释
    private func loadStickers() {
        
       let image =  #imageLiteral(resourceName: "hello")
        
        
        
        for i in 1...31 {
            // 语法变了
            let str = String(format: "%02d", i)
            if let url = Bundle.main.url(forResource: str, withExtension: "gif") {
                
                do {
                    let sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "")
                    stickers.append(sticker)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // 初始化一个MSStickerBrowserViewController作为根视图
    
    /**
     这个是一个方法
     - throws: 抛出异常
     - returns: 野指针
     */
    
    /// 这是一个很牛xx的功能
    ///
    /// 你好
    private func setupStickerBrowser() {
        /*
         case small 小图模式
         case regular 中图
         case large 大图
         }
         */
        let controller = MSStickerBrowserViewController(stickerSize: .small)
        
        addChildViewController(controller)
        view.addSubview(controller.view)
        // 语法变了
        controller.stickerBrowserView.backgroundColor = UIColor.yellow
        // 设置数据源
        controller.stickerBrowserView.dataSource = self
        // 布局
        view.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: controller.view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: controller.view.rightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化本地表情包
        loadStickers()
        
        // 创建本地表情包控制器
//        setupStickerBrowser()
        
        setupAddBtn()
        
        // <UILabel: 0x7f8e21e07180; frame = (0 0; 1000 1000); text = 'Hello World'; clipsToBounds = YES; opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x608000282a80>>
//        for view in view.subviews {
////            print(view)
//            if view is UILabel {
//                (view as! UILabel).text = "你好"
////                view.removeFromSuperview()
//            }
//        }
    }
    /*
     * 添加一个button
     */
    func setupAddBtn() {
        let btn = UIButton(type: .contactAdd)
        view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(btnOnClick), for: .touchUpInside)
    }
    
    // button 点击调用的方法
    func btnOnClick() {
        print("hello")
        
        // activeConversation 会话对象
        activeConversation?.insertText("hello", completionHandler: { (error) in
            print("插入信息成功")
        })
        // 插入一个表情
        activeConversation?.insert(stickers[0], completionHandler: { (error) in
            print("123")
        })
    }
    // 当发生内存警告的时候调用
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    // 会话处理
    
    // 将要获取焦点
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        print("willBecomeActive")
    }
    // 失去焦点
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        print("didResignActive")
    }
    
   // 收到信息
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
        print("didReceive")
    }
    // 开始发送
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
        print("didStartSending")
    }
    // 取消发送
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
        print("didCancelSending")
        
    }
    // 将要过度,可以改变风格
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        
        print("willTransition")
    }
    
    // 过度完毕
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
        print("didTransition")
    }

}
// MARK: - MSStickerBrowserViewDataSource 必须要实现的数据源方法
extension MessagesViewController: MSStickerBrowserViewDataSource{
    // 一共有多少个
    func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    // 每一个要显示什么
    func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
}
