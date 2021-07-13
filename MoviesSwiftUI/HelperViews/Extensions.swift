//
//  Extensions.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 30.12.2020.
//

import Foundation
import SwiftUI


struct CustomScrollView<Content: View> : UIViewRepresentable {
    var width : CGFloat
    var height : CGFloat
    
    let content: () -> Content
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        control.delegate = context.coordinator
        
        let childView = UIHostingController(rootView: content())
        childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        control.addSubview(childView.view)
        return control
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) { }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var control: CustomScrollView<Content>
        init(_ control: CustomScrollView) {
            self.control = control
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
                print("bottom reached")
                // not working
            }
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
        }
    }
}
