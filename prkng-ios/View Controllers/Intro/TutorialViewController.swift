//
//  TutorialViewController.swift
//  prkng-ios
//
//  Created by Cagdas Altinkaya on 26/05/15.
//  Copyright (c) 2015 PRKNG. All rights reserved.
//

import UIKit

class TutorialViewController: GAITrackedViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var delegate: TutorialViewControllerDelegate?
    var pageViewController : UIPageViewController
    var pageControl : UIPageControl
    var nextButton : UIButton
    var getStartedButton : UIButton
    var contentViewControllers : Array<UIViewController>
    
    static let PAGE_CONTROL_BOTTOM_OFFSET = 90
    
    let pageCount = 4
    
    let images = [ UIImage(named: "tutorial_1"),
        UIImage(named: "tutorial_2"),
        UIImage(named: "tutorial_3"),
        UIImage(named: "tutorial_4")]
    
    let texts = [ "tutorial_step_1".localizedString,
        "tutorial_step_2".localizedString,
        "tutorial_step_3".localizedString,
        "tutorial_step_4".localizedString]
    
    init() {
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageControl = UIPageControl()
        nextButton = UIButton()
        getStartedButton = ViewFactory.redRoundedButton()
        contentViewControllers = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func loadView() {
        self.view = UIView()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "Intro - Tutorial View"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setupViews() {
        
        for i in 0...(pageCount - 1) {
            let backgroundImageName = ((i % 2) == 0) ? "bg_red_gradient" : "bg_blue_gradient"
            let backgroundImage = UIImage(named: backgroundImageName)
            let page = TutorialContentViewController(backgroundImage: backgroundImage!, image: images[i]!, text: texts[i], index : i)
            contentViewControllers.append(page)
        }
        
        pageViewController.willMoveToParentViewController(self)
        addChildViewController(pageViewController)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([contentViewControllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        view.addSubview(pageViewController.view)
        
        pageControl.numberOfPages = pageCount
        view.addSubview(pageControl)
        
        nextButton.setImage(UIImage(named:"btn_forward"), forState: UIControlState.Normal)
        nextButton.addTarget(self, action: "nextButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(nextButton)
        
        getStartedButton.setTitle("tutorial_confirm".localizedString, forState: UIControlState.Normal)
        getStartedButton.hidden = true
        getStartedButton.addTarget(self, action: "getStartedButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(getStartedButton)
    }
    
    
    func setupConstraints () {
        
        pageViewController.view.snp_makeConstraints { (make) -> () in
            make.edges.equalTo(self.view)
        }
        
        pageControl.snp_makeConstraints { (make) -> () in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(0 - TutorialViewController.PAGE_CONTROL_BOTTOM_OFFSET)
        }
        
        nextButton.snp_makeConstraints { (make) -> () in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-31)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
        getStartedButton.snp_makeConstraints { (make) -> () in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-31)
            make.size.equalTo(CGSizeMake(113, 26))
        }
        
    }
    
    func nextButtonTapped() {
        
        if pageViewController.viewControllers != nil && pageViewController.viewControllers!.count < 1 {
            return
        }
        
        if let vc = pageViewController.viewControllers?.first as? TutorialContentViewController {
            
            let index = vc.pageIndex >= contentViewControllers.count ? contentViewControllers.count - 1 : vc.pageIndex + 1
            
            if (index >= contentViewControllers.count) {
                return
            }
            
            let nextVC = contentViewControllers[index]
            
            self.pageViewController.setViewControllers([nextVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true) { (completed) -> Void in
                self.updateViews()
            }
        }
    }
    
    func getStartedButtonTapped() {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.delegate?.didFinishAndDismissTutorial()
        })
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! TutorialContentViewController
        
        if (vc.pageIndex > 0) {
            return contentViewControllers[vc.pageIndex - 1]
        }
        return nil
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! TutorialContentViewController
        
        if (vc.pageIndex < pageCount - 1) {
            return contentViewControllers[vc.pageIndex + 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateViews()
    }
    
    
    func updateViews() {
        pageControl.currentPage = (pageViewController.viewControllers?.first as! TutorialContentViewController).pageIndex
        
        if (pageControl.currentPage == pageCount - 1 && self.getStartedButton.hidden) {
            
            self.getStartedButton.alpha = 0.0
            self.getStartedButton.hidden = false
            
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                self.getStartedButton.alpha = 1.0
                self.nextButton.alpha = 0.0
                }, completion: { (completed) -> Void in
                    self.nextButton.hidden = true
            })
        }
    }
    
    
}

protocol TutorialViewControllerDelegate {
    func didFinishAndDismissTutorial()
}
