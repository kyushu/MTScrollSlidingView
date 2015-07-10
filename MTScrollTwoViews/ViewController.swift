//
//  ViewController.swift
//  MTScrollTwoViews
//
//  Created by kyushu on 2015/7/10.
//  Copyright (c) 2015年 kyushu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    // View Tag Parameters
    let Top_ScrollView_Tag: Int = 1
    let Content_ScrollView_Tag: Int = 2
    let First_Table_Tag: Int = 3
    let Second_Table_Tag: Int = 4
    
    /************* Dimension Parameters *************/
    let Status_Bar_Height: CGFloat = 20.0
    
    // Top Title
    let Top_Bar_Height: CGFloat = 44.0
    let Title_X_Margin: CGFloat = 20.0
    let Sub_Title_Width_Ratio: CGFloat = 0.75
    
    // Article Table Cell
    let Photo_Image_Size: CGFloat = 50.0
    let Cell_X_Offset: CGFloat = 20.0
    let Cell_Y_Offset: CGFloat = 10.0
    
    // Bottom Tool Bar
    let Bottom_Bar_Height: CGFloat = 64.0
    let PageControl_Height: CGFloat = 15.0
    let Button_X_Offset: CGFloat = 20.0
    
    // Number of Pages
    let NumOfPage: Int = 2
    
    
    var topScrollView: UIScrollView!
    var mainScrollView: UIScrollView!
    var bottomToolBarView: UIView!
    var pageCtl: UIPageControl!
    
    var firstTable: UITableView!
    var secondTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /************************************************************************************************
        ** 1. Initial Top bar Scroll View
        ************************************************************************************************/
        var frame = CGRectMake(0, 20, view.bounds.width, Top_Bar_Height)
        topScrollView = UIScrollView(frame: frame)
        topScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: view.bounds.width * 0.25)
        topScrollView.delegate = self
        topScrollView.tag = Top_ScrollView_Tag
        topScrollView.pagingEnabled = true
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.showsVerticalScrollIndicator = false
        //topScrollView.contentSize = CGSizeMake(view.frame.width, Top_Bar_Height)
        view.addSubview(topScrollView)
        
        initialTitleSubView(topScrollView)
        
        /************************************************************************************************
        ** 2. Initial Bottom Tool bar  View
        ************************************************************************************************/
//        frame.origin.y = view.frame.height - Bottom_Bar_Height
        frame = CGRectMake(0, view.bounds.height - Bottom_Bar_Height, view.bounds.width, Bottom_Bar_Height)
        bottomToolBarView = UIView(frame: frame)
        bottomToolBarView.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(bottomToolBarView)
        
        initialBottomSubciew(bottomToolBarView)
        
        
        /************************************************************************************************
        ** 3. Initial Main Content Scroll View
        ************************************************************************************************/
        frame = CGRectMake(0, Status_Bar_Height + Top_Bar_Height, view.bounds.width, view.bounds.height - Status_Bar_Height - Top_Bar_Height - Bottom_Bar_Height)
        mainScrollView = UIScrollView(frame: frame)
        mainScrollView.delegate = self
        mainScrollView.tag = Content_ScrollView_Tag
        mainScrollView.pagingEnabled = true
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.contentSize = CGSizeMake(2 * view.bounds.width, view.bounds.height - Status_Bar_Height - Top_Bar_Height - Bottom_Bar_Height)
        view.addSubview(mainScrollView)
        
        // Init First Table View
        frame.origin.y = 0
        initFirstTableView(frame)
        
        // Init Second Table View
        frame.origin.x = view.bounds.width
        initSecondTableView(frame)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    /***************************************************************************************************
    ** MARK: - UIScrollView Delegate
    ****************************************************************************************************/
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == Content_ScrollView_Tag {
            println("content content offset: \(mainScrollView.contentOffset)")
            let x = mainScrollView.contentOffset.x
            let w = mainScrollView.bounds.size.width
            pageCtl.currentPage = Int(x/w)
        }
        else if scrollView.tag == Top_ScrollView_Tag {
            println("top content offset: \(topScrollView.contentOffset)")
            println("content content offset: \(mainScrollView.contentOffset)")
            
            // move MainScrollView with animation
            let pageIndex = ceil(mainScrollView.contentOffset.x / mainScrollView.frame.width)
            mainScrollView.setContentOffset(CGPointMake(pageIndex * mainScrollView.frame.width, 0), animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.tag == Content_ScrollView_Tag {
            
            if scrollView.dragging {
                println("content scroll view is dragging")
                let xOffset = scrollView.contentOffset.x * topScrollView.frame.width * Sub_Title_Width_Ratio / scrollView.frame.width
                println("xoffset: \(xOffset)")
                topScrollView.setContentOffset(CGPointMake(xOffset, 0), animated: false)
                
            }
        }else if scrollView.tag == Top_ScrollView_Tag {
            
            if scrollView.dragging {
                println("top title scroll view is dragging: \(scrollView.contentOffset)")
                
                let xOffset = scrollView.contentOffset.x / topScrollView.frame.width * Sub_Title_Width_Ratio * mainScrollView.frame.width
                println("xoffset: \(xOffset)")
                mainScrollView.setContentOffset(CGPointMake(xOffset, 0), animated: false)
            }
        }
    }
    
    /****************************************************************************************************
    ** MARK: - Table view data source
    ****************************************************************************************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableView.tag == First_Table_Tag {
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        if tableView.tag == First_Table_Tag {
            return 9
        }
        else if tableView.tag == Second_Table_Tag {
            return 2
        }
        else {
            return 1
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == First_Table_Tag {
            return dequeuefirstTableCell(tableView, indexPath: indexPath)
        }
        else if tableView.tag == Second_Table_Tag {
            // Favorite Area Table
            return dequeueSecondTableCell(tableView, indexPath: indexPath)
        }
        else {
            return UITableViewCell()
        }
    }
    
    
    /****************************************************************************************************
    ** MARK: Top Title Bar Setting
    ****************************************************************************************************/
    func initialTitleSubView(scrollView: UIScrollView) {
        
        let sub_fWidth = scrollView.frame.width * Sub_Title_Width_Ratio
        
        // 1.
        let firstSubView = UIView(frame: CGRectMake(0, 0, sub_fWidth, Top_Bar_Height))
        scrollView.addSubview(firstSubView)
        
        var xOffset: CGFloat = 0
        let firstTitle = UILabel(frame: CGRectMake(0, 0, sub_fWidth, Top_Bar_Height))
        firstTitle.text = "第一個Section"
        firstTitle.font = UIFont.systemFontOfSize(20)
        firstTitle.textAlignment = NSTextAlignment.Left
        firstTitle.textColor = UIColor.blackColor()
        firstTitle.sizeToFit()
        firstTitle.frame = CGRectMake(Title_X_Margin, 0, firstTitle.frame.width, Top_Bar_Height)
        firstTitle.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapOnfirstTitle:")
        firstTitle.addGestureRecognizer(tapGesture)
        firstSubView.addSubview(firstTitle)
        xOffset += sub_fWidth
        
        println("firstSubView.frame: \(firstSubView.frame)")
        
        // 2.
        let secondSubView = UIView(frame: CGRectMake(xOffset, 0, sub_fWidth, Top_Bar_Height))
        scrollView.addSubview(secondSubView)
        
        let secondTitle = UILabel(frame: CGRectMake(0, 0, sub_fWidth, Top_Bar_Height))
        secondTitle.text = "第二個Section"
        secondTitle.font = UIFont.systemFontOfSize(20)
        secondTitle.textAlignment = NSTextAlignment.Left
        secondTitle.textColor = UIColor.blackColor()
        secondTitle.sizeToFit()
        secondTitle.frame = CGRectMake(Title_X_Margin, 0, secondTitle.frame.width, Top_Bar_Height)
        secondSubView.addSubview(secondTitle)
        xOffset += sub_fWidth
        println("secondSubView.frame: \(secondSubView.frame)")
        
        // Update Title Scroll View's Content Size
        scrollView.contentSize = CGSizeMake(xOffset, Top_Bar_Height)
        println("top content size: \(topScrollView.contentSize)")
    }
    
    // MARK: Tap On Title
    func tapOnfirstTitle(recognizer: UIGestureRecognizer) {
        
    }
    
    /****************************************************************************************************
    ** MARK: Bottom Tool Bar Setting
    ****************************************************************************************************/
    func initialBottomSubciew(parentView: UIView) {
        
        var pFrame = parentView.frame
        // SetUp PageControl
        pageCtl = UIPageControl(frame: CGRectMake(
            0,
            pFrame.height - PageControl_Height,
            pFrame.width,
            PageControl_Height))
        
        pageCtl.backgroundColor = UIColor.clearColor()
        pageCtl.pageIndicatorTintColor = UIColor.grayColor()
        pageCtl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageCtl.numberOfPages = NumOfPage
        pageCtl.currentPage = 0
        parentView.addSubview(pageCtl)
        
        pFrame.size.height -= PageControl_Height
        
        // SetUp Button
        let writeButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        writeButton.setImage(UIImage(named: "edit"), forState: UIControlState.Normal)
        writeButton.sizeToFit()
        println("writeButton size: \(writeButton.frame)")
        writeButton.frame = CGRectMake(Button_X_Offset, (pFrame.height - writeButton.frame.height) * 0.5, writeButton.frame.width, writeButton.frame.height)
        parentView.addSubview(writeButton)
        
        
    }
    
    /***********************************************
    ** MARK: First TableView Setting
    ***********************************************/
    // MARK: Initial First TableView
    func initFirstTableView(frame: CGRect) {
        firstTable = UITableView(frame: frame)
        firstTable.tag = First_Table_Tag
        firstTable.dataSource = self
        firstTable.delegate = self
        firstTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        firstTable.rowHeight = 80.0
        mainScrollView.addSubview(firstTable)
        
    }
    // MARK: Setting Table Cell for First Table View
    func dequeuefirstTableCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "FirstTableCell"
        
        
        return cell
    }
    
    
    /***********************************************
    ** MARK: Second TableView Setting
    ***********************************************/
    // MARK: Initial Second TableView
    func initSecondTableView(frame: CGRect) {
        
        secondTable = UITableView(frame: frame)
        secondTable.tag = Second_Table_Tag
        secondTable.dataSource = self
        secondTable.delegate = self
        secondTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        //        secondTable.rowHeight = 80.0
        mainScrollView.addSubview(secondTable)
        
    }
    
    // MARK: Setting Table Cell for Second Table
    func dequeueSecondTableCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "SecondTableCell"
        
        return cell
    }

}

