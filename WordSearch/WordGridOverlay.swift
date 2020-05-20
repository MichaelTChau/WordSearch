//
//  WordGridOverlay.swift
//  WordSearch
//
//  Created by Michael Chau  on 2020-05-19.
//  Copyright © 2020 Michael Chau . All rights reserved.
//

import UIKit



class WordGridOverlay: UIView {
    private let lineWidth: CGFloat = 15
    private let opacity: CGFloat = 0.6
    
    private var completedLines: [(CGPoint, CGPoint, UIColor)] = []
    
    private var currentLineStart: CGPoint?
    private var currentLineEnd: CGPoint?
    lazy private var currentLineColour: UIColor = UIColor(red: 0.78, green: 0.93, blue: 1.00, alpha: 1.00).withAlphaComponent(opacity)
    
    // MARK: UI
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .clear
        
        if let context = UIGraphicsGetCurrentContext() {
            if let start = currentLineStart, let end = currentLineEnd {
                context.setStrokeColor(currentLineColour.cgColor)
                context.setLineWidth(lineWidth)
                context.move(to: start)
                context.addLine(to: end)
                context.strokePath()
            }
            
            for line in completedLines {
                context.setStrokeColor(line.2.cgColor)
                context.setLineWidth(lineWidth)
                context.move(to: line.0)
                context.addLine(to: line.1)
                context.strokePath()
            }
        }
    }
    
    // MARK: Public func
    func addCompletedLine(begin: CGPoint,
                          end: CGPoint,
                          colour: UIColor) {
        completedLines.append((begin,
                               end,
                               colour.withAlphaComponent(opacity)))
        setNeedsDisplay()
    }
    
    func setCurrentLine(begin: CGPoint?,
                        end: CGPoint?) {
        currentLineStart = begin
        currentLineEnd = end
        setNeedsDisplay()
    }
}
