//
//  MapView.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/24/24.
//

import UIKit

class MapView: UIView {
    // MARK: - Properties
    private var parkingSpotsCoords: [OnCanvasCoords]?
    private var parkingSpotsCanvases: [Canvas]?
    private var parkingSpotsPaths: [UIBezierPath]?
    private var parkingSpotsLayers: [CAShapeLayer]?
    
    // MARK: - LifeCycle
    init(parkingSpotsCoords: [OnCanvasCoords], parkingSpotsCanvases: [Canvas], frame: CGRect) {
        super.init(frame: frame)
        self.parkingSpotsCoords = parkingSpotsCoords
        self.parkingSpotsCanvases = parkingSpotsCanvases
        self.backgroundColor = .yellow
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureUI() {
        self.parkingSpotsPaths = Array(repeating: UIBezierPath(), count: self.parkingSpotsCoords?.count ?? 0)
        self.parkingSpotsLayers = Array(repeating: CAShapeLayer(), count: self.parkingSpotsCoords?.count ?? 0)
        
        if let parkingSpotsLayers = self.parkingSpotsLayers {
            for layer in parkingSpotsLayers {
                self.layer.addSublayer(layer)
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.parkingSpotButtonWasPressed(_:))
        )
        addGestureRecognizer(tapRecognizer)
    }
    
    func createParkingSpot(coords: OnCanvasCoords, canvas: Canvas, path: UIBezierPath, layer: CAShapeLayer) {
        path.move(to: CGPoint(x: coords.x, y: coords.y))
        path.addLine(to: CGPoint(x: coords.x + canvas.width, y: coords.y))
        path.addLine(to: CGPoint(x: coords.x + canvas.width, y: coords.y + canvas.height))
        path.addLine(to: CGPoint(x: coords.x, y: coords.y + canvas.height))
        path.addLine(to: CGPoint(x: coords.x, y: coords.y))
        path.close()
        layer.frame = bounds
        layer.path = path.cgPath
        layer.lineWidth = 3
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.gray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let parkingSpotsPaths = self.parkingSpotsPaths, let parkingSpotsLayers = self.parkingSpotsLayers, let parkingSpotsCoords = self.parkingSpotsCoords, let parkingSpotsCanvases = self.parkingSpotsCanvases {
            for idx in 0..<parkingSpotsCoords.count {
                self.createParkingSpot(coords: parkingSpotsCoords[idx], canvas: parkingSpotsCanvases[idx], path: parkingSpotsPaths[idx], layer: parkingSpotsLayers[idx])
            }
        }
    }
    
    // MARK: - Actions
    @objc
    private func parkingSpotButtonWasPressed(_ sender: UITapGestureRecognizer? = nil) {
        // TODO: - Show parking spot reservation subview
    }
}
