import SwiftUI
import BezierKit


struct Change: UIViewRepresentable {
    func makeUIView(context: Context) -> UIButton {
        UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.setTitle("Press me", for: .normal)
        uiView.backgroundColor = .blue
    }
    
    typealias UIViewType = UIButton
    
}

//struct ChangeUIView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        <#code#>
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        override func draw(_ rect: CGRect) {
//            super.draw(rect)
//
//            guard let contexty = UIGraphicsGetCurrentContext() else { return }
//            let curve = CubicCurve(
//                p0: CGPoint(x: 100, y: 25),
//                p1: CGPoint(x: 500, y: 500),
//                p2: CGPoint(x: 1000, y: 100),
//                p3: CGPoint(x: 150, y: 700)
//
//
//
//            )
//
//            let context: CGContext = contexty     // your graphics context here
//            Draw.drawSkeleton(context, curve: curve)  // draws visual representation of curve control points
//            Draw.drawCurve(context, curve: curve)
//
//        }
//
//    }
//
//    typealias UIViewType = UIView
//}

struct ChangeUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
//        let drawingView = CustomDrawingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let drawingView = SmoothedBIView()
        
        
        drawingView.backgroundColor = UIColor.white
        return drawingView
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No need for implementation here
    }
    
    typealias UIViewType = UIView
    
    

    class SmoothedBIView: UIView {
        private var path = UIBezierPath()
        private var incrementalImage: UIImage?
        private var pts = [CGPoint](repeating: .zero, count: 5)
        private var ctr: UInt32 = 0
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.isMultipleTouchEnabled = false
            path.lineWidth = 2.0
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.isMultipleTouchEnabled = false
            self.backgroundColor = UIColor.white
            path.lineWidth = 2.0
        }
        
        override func draw(_ rect: CGRect) {
            incrementalImage?.draw(in: rect)
            path.stroke()
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            ctr = 0
            if let touch = touches.first {
                pts[0] = touch.location(in: self)
            }
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                let p = touch.location(in: self)
                ctr += 1
                pts[Int(ctr)] = p
                if ctr == 4 {
                    pts[3] = CGPoint(x: (pts[2].x + pts[4].x) / 2.0, y: (pts[2].y + pts[4].y) / 2.0)
                    path.move(to: pts[0])
                    path.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
                    setNeedsDisplay()
                    pts[0] = pts[3]
                    pts[1] = pts[4]
                    ctr = 1
                }
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            drawBitmap()
            setNeedsDisplay()
            path.removeAllPoints()
            ctr = 0
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            touchesEnded(touches, with: event)
        }
        
        private func drawBitmap() {
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
            
            if incrementalImage == nil {
                let rectpath = UIBezierPath(rect: bounds)
                UIColor.blue.setFill()
                rectpath.fill()
            }
            
            incrementalImage?.draw(at: .zero)
            UIColor.black.setStroke()
            path.stroke()
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    
    // Create a custom UIView subclass for drawing
    class CustomDrawingView: UIView {





        override func draw(_ rect: CGRect) {
            // Create a UIBezierPath for a rounded rectangle
            let path = UIBezierPath(roundedRect: CGRect(x: 50, y: 50, width: 500, height: 1000), cornerRadius: 20)

            // Set stroke and fill colors
            UIColor.blue.setStroke()
            UIColor.green.setFill()

            // Set line width
            path.lineWidth = 3

            // Draw the path
            path.stroke()
            path.fill()


            super.draw(rect)

            var points: [CGPoint] = [
                CGPoint(x: 125, y: 453.0),
                CGPoint(x: 672, y: 234.8),
                CGPoint(x: 300, y: 855.5),
                CGPoint(x: 507, y: 10.2),
                CGPoint(x: 903, y: 676.9),
                CGPoint(x: 250, y: 300),
                CGPoint(x: 802, y: 567),
                CGPoint(x: 153, y: 708),
                CGPoint(x: 406, y: 201),
                CGPoint(x: 709, y: 456),
                CGPoint(x: 338, y: 907),
                CGPoint(x: 581, y: 134),
                CGPoint(x: 927, y: 75.2),
                CGPoint(x: 100, y: 5.0),
                CGPoint(x: 604, y: 47.3),
                CGPoint(x: 22.9, y: 82.1),
                CGPoint(x: 100, y: 18.9),
                CGPoint(x: 88.6, y: 64.0),
                CGPoint(x: 38.5, y: 28.6),
                CGPoint(x: 72.0, y: 53.2)]
            var num = 10





        guard let contexty = UIGraphicsGetCurrentContext() else { return }
        let curve = CubicCurve(
            p0: CGPoint(x: 200, y: 25),
            p1: CGPoint(x: 500, y: 500),
            p2: CGPoint(x: 10, y: 100),
            p3: CGPoint(x: 150, y: 700)
        )

        let context: CGContext = contexty     // your graphics context here
        Draw.drawSkeleton(context, curve: curve)  // draws visual representation of curve control points
        Draw.drawCurve(context, curve: curve)

        if points.count >= num {
            for i in 1...(num-1)/3 {
                var m = 3 * i

                var mycurve = CubicCurve(p0: CGPoint(x: 100, y: 200), p1: points[m-3], p2: points[m-2], p3: CGPoint(x: (points[m-2].x+points[m].x)/2, y: (points[m-2].y+points[m].y)/2))
                Draw.drawCurve(context, curve: mycurve)


            }
        }

    }

}

}





struct ContentView: View {
    var body: some View {
        VStack {
            Text("HI")
            //            Change()
            ChangeUIView()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


