//
//  HscrollViewController.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/16.
//

import SwiftUI

struct HscrollViewController<Content: View> : UIViewControllerRepresentable
{
    let pageWidth: CGFloat
    let contentSize: CGSize
    let content: Content
    @Binding  var leftPercent: CGFloat
    
    init(pageWidth:CGFloat, contentSize: CGSize, leftPercent: Binding<CGFloat>  , @ViewBuilder content: () -> Content)
    {
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self._leftPercent = leftPercent // 下划线表示绑定
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController  // some表示要么是这个类，要么是这个类的子类
    {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        context.coordinator.scrollView = scrollView

        let vc = UIViewController()
        vc.view.addSubview(scrollView)

        let host = UIHostingController(rootView: content) // 把SwiftUI的view 添加到 UIkit 的UIView上
        vc.addChild(host)
        scrollView.addSubview(host.view)
        host.didMove(toParent: vc)
        context.coordinator.host = host

        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context)
    {
        let scrollView: UIScrollView  = context.coordinator.scrollView!
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: pageWidth * leftPercent, y: 0), animated: true)
        context.coordinator.host.view.frame = CGRect(origin: .zero, size: contentSize)
    }

    class Coordinator: NSObject, UIScrollViewDelegate
    {
        let parent: HscrollViewController
        var scrollView: UIScrollView!
        var host: UIHostingController<Content>!

        init(_ parent: HscrollViewController)
        {
            self.parent = parent
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
        {
            //print("scrollView Did End Decelerating")
            withAnimation { parent.leftPercent = scrollView.contentOffset.x < parent.pageWidth * 0.5 ? 0 : 1 } // 小于一半说明在第一页
        }
    }
}
