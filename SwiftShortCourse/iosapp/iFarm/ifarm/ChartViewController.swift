//
//  ChartViewController.swift
//  iFarm
//
//  Created by Vinh The on 9/10/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class ChartViewController: BaseViewController {

    @IBOutlet weak var BarChart: BarChartView!
    
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(months, values: unitsSold)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        BarChart.noDataText = "Không có dữ liệu để hiển thị chart"
        BarChart.noDataTextDescription = "Bạn cần cung cấp dữ liệu của sensor để hiển thị Chart"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        BarChart.data = chartData
        BarChart.descriptionText = ""
        

        
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

}
