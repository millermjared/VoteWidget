//
//  PieChartView.swift
//  piechart
//
//  Created by Matt Miller on 6/13/17.
//  Copyright © 2017 Matt Miller. All rights reserved.
//

import UIKit

struct Segment {
    
    // the color of a given segment
    var color: UIColor
    
    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat
    
    var label: String
    
    var formattedValue: String  {
        
        guard value != CGFloat.nan else {return ""}
        
        let roundedPercentage = Int((value * 100).rounded())
        return "\(roundedPercentage)%"
    }
}

class PieChartView: UIView {
    
    /// An array of structs representing the segments of the pie chart
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay() // re-draw view when the values get set
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    func rectForText(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> CGRect {
        
        let middleAngle = (startAngle + endAngle) / 2.0
        
        let pointB = pointOnCircle(center: center, radius: radius / 1.4, angle: middleAngle)

        let width: CGFloat = 29.0
        let height: CGFloat = 12.0
        
        return CGRect(x: pointB.x - width/2.0, y: pointB.y - height/2.0, width: width, height: height)
    }
    
    override func draw(_ rect: CGRect) {
        
        // get current context
        let ctx = UIGraphicsGetCurrentContext()
        
        // radius is the half the frame's width or height (whichever is smallest)
        let radius = min(frame.size.width, frame.size.height) * 0.4
        
        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        
        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = segments.reduce(0, {$0 + $1.value})
        
        // the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
        var startAngle = -CGFloat.pi * 0.5
        
        ctx?.setStrokeColor(UIColor.white.cgColor)
        ctx?.setLineWidth(2.0)
        ctx?.setLineCap(.round)
        
        let textFontAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
            NSForegroundColorAttributeName: UIColor.black,
            ] as [String : Any]
        
        for segment in segments { // loop through the values array
            
            // set fill color to the segment color
            ctx?.setFillColor(segment.color.cgColor)
            
            // update the end angle of the segment
            let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
            
            // move to the center of the pie chart
            ctx?.move(to: viewCenter)
            
            // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            // fill segment
            ctx?.fillPath()

            // move to the center of the pie chart
            ctx?.move(to: viewCenter)
            ctx?.addLine(to: pointOnCircle(center: viewCenter, radius: radius, angle: startAngle))
            ctx?.strokePath()
            
            let labelRadius = segment.value > 0.10  ? radius : radius * 1.6
            segment.formattedValue.draw(in: rectForText(center: viewCenter, radius: labelRadius, startAngle: startAngle, endAngle: endAngle), withAttributes: textFontAttributes)

            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
        }
        
        ctx?.move(to: viewCenter)
        ctx?.addLine(to: pointOnCircle(center: viewCenter, radius: radius, angle: startAngle))
        ctx?.strokePath()
    }
}
