//
//  ViewController.swift
//  PDFJS
//
//  Created by singl on 2018/10/24.
//  Copyright © 2018年 wyzw. All rights reserved.
//
//---------------------- UIWebView加载pdf---------------------------
import UIKit

class ViewController: UIViewController,UIWebViewDelegate{

    private lazy var pdfweb : UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        webView.isUserInteractionEnabled = true
        webView.scrollView.bounces = true
        webView.scalesPageToFit = true
        webView.isUserInteractionEnabled = true
        webView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        webView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        webView.isMultipleTouchEnabled  = true
        webView.scrollView.isScrollEnabled = true
        webView.contentMode = UIView.ContentMode.scaleAspectFit
        return webView
    }()
    
    var urls : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        layOutUI()

        urls = Bundle.main.path(forResource: "123.pdf", ofType: nil)

        if urls == ""{return}
        guard let tempUrl = urls else {return}
        loadUrl(url: tempUrl)

    }
    

    func layOutUI() {
        view.addSubview(pdfweb)
        pdfweb.frame = view.frame
      
    }

    func loadUrl(url:String){
        let ishttp = url.hasPrefix("http")
        if ishttp == true{

            let urlrequest = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 1.0)
            pdfweb.loadRequest(urlrequest)

        }else{

//     ******************用pdf.js库加载pdf***********************

            guard let viwerPath: String = Bundle.main.path(forResource:"viewer", ofType: "html", inDirectory: "minified/web") else{return}

            let urlStr: String = "\(viwerPath)?file=\(url)"

            if let TempurlStr = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed){

                let pathUrl = URL(string: TempurlStr)

                if let fileurl = pathUrl {

                    let request = URLRequest(url: fileurl)

                    pdfweb.loadRequest(request)
                }
            }

//      ****************** 原生直接加载pdf***********************
        /*
 
         guard let fileurl = urls else{return}
            let lasturl = fileurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
            let request = URLRequest(url: URL(string: lasturl!)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 1.0)
            
         pdfweb.loadRequest(request)

        }
        */
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let jsMeta = "var meta = document.createElement('meta');meta.content='width=device-width,initial-scale=1.0,minimum-scale=.5,maximum-scale=3';meta.name='viewport';document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.stringByEvaluatingJavaScript(from: jsMeta)
    }
}


//---------分割线---------------WKWebView加载PDF------------------------
//
//import UIKit
//import WebKit
////import AFNetworking
//import AFNetworking
//
//let kBasePath = NSHomeDirectory() + "/Documents/myFolder/Files/"
//
//class ViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
//
//    private let fileManager = FileManager.default
//
//    private lazy var wkweb : WKWebView = {
//        let webView = WKWebView()
//        webView.navigationDelegate = self
//        webView.uiDelegate = self
//        webView.isUserInteractionEnabled = true
//        webView.scrollView.bounces = true
//        webView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
//        webView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
//        webView.isMultipleTouchEnabled  = true
//        webView.scrollView.isScrollEnabled = true
//        webView.contentMode = UIView.ContentMode.scaleAspectFit
//        return webView
//    }()
//    var documnetPath:String = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        downPDF(url: "http://zw-ltx.oss-cn-beijing.aliyuncs.com/books/media/pdfjs/web/1.pdf", pdfName: "1.pdf")
//
//    }
//
//    func layOutUI() {
//        view.addSubview(wkweb)
//        wkweb.frame = view.frame
//    }
//
//    func loadUrl(){
//        let viwerPath: String = Bundle.main.path(forResource:"viewer", ofType: "html", inDirectory: "minified/web")!
//        let pdfUrl = Bundle.main.url(forResource: "123", withExtension: "pdf")
//        var urlStr: String = "file://\(viwerPath)?file=\(pdfUrl!)"
//        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//
//        let pathUrl = URL(string: urlStr)
//        wkweb.load(URLRequest(url: pathUrl!))
////        wkweb.load(URLRequest(url: URL(fileURLWithPath: urlStr)))
////        wkweb.loadFileURL(URL(fileURLWithPath: urlStr), allowingReadAccessTo: pathUrl!)
////        wkweb.loadHTMLString("file://\(self.documnetPath)", baseURL: pathUrl!)
//    }
//    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//
//        let frameInfo = navigationAction.targetFrame
//        if frameInfo?.isMainFrame ?? true{
//            webView.load(navigationAction.request)
//        }
//        return nil
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("over")
//    }
//
//    func downPDF(url:String,pdfName:String) {
//        let manage = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
//        let request = URLRequest(url: URL(string: url)!)
//        documnetPath = kBasePath + "BookAnswer/Pdf"
//        let isexit = FileManager.default.fileExists(atPath: documnetPath)
//        if !isexit{
//            try? fileManager.createDirectory(atPath: documnetPath,
//                                             withIntermediateDirectories: true, attributes: nil)
//        }
//        documnetPath = documnetPath + "/" + pdfName
//
//        let downTask = manage.downloadTask(with: request, progress: { (downloadProgress) in
//            print(downloadProgress)
//        }, destination: { (targetPath, response) -> URL in
//            return URL(fileURLWithPath: self.documnetPath)
//        }) { (response, filePath, error) in
//            print(filePath)
//            self.layOutUI()
//            self.loadUrl()
//        }
//        downTask.resume()
//    }
//}
