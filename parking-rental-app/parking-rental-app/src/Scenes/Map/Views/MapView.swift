//
//  MapView.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/24/24.
//

import UIKit
import Logging

enum ParkingSpotType {
    case notAvailable
    case notFree
    case free
    case reserved
}

class MapView: UIView {
    // MARK: - Properties
    private let logger = Logger(label: "com.foxfromfuture.parking-rental-app.mapView")
    
    private var notAvailableParkingSpots: [ParkingSpot]?
    private var notFreeParkingSpots: [ParkingSpot]?
    private var freeParkingSpots: [ParkingSpot]?
    private var reservedParkingSpot: ParkingSpot?
    
    private var notAvailableParkingSpotsLayers: [CAShapeLayer]?
    private var notFreeParkingSpotsLayers: [CAShapeLayer]?
    private var freeParkingSpotsLayers: [CAShapeLayer]?
    private var reservedParkingSpotLayer: CAShapeLayer?
    
    private var position: CGPoint?
    private var freeSpotPressAction: ((String) -> Void)?
    private var reservedSpotPressAction: ((String) -> Void)?
    
    // MARK: - LifeCycle
    init(notAvailableParkingSpots: [ParkingSpot]?, notFreeParkingSpots: [ParkingSpot]?, freeParkingSpots: [ParkingSpot]?, reservedParkingSpot: ParkingSpot?, frame: CGRect) {
        super.init(frame: frame)
        self.notAvailableParkingSpots = notAvailableParkingSpots
        self.notFreeParkingSpots = notFreeParkingSpots
        self.freeParkingSpots = freeParkingSpots
        self.reservedParkingSpot = reservedParkingSpot
        self.backgroundColor = Colors.background.uiColor
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureUI() {
        if let freeParkingSpots = self.freeParkingSpots {
            self.freeParkingSpotsLayers = []
            for _ in freeParkingSpots {
                self.freeParkingSpotsLayers?.append(CAShapeLayer())
            }
        }
        
        if let notAvailableParkingSpots = self.notAvailableParkingSpots {
            self.notAvailableParkingSpotsLayers = []
            for _ in notAvailableParkingSpots {
                self.notAvailableParkingSpotsLayers?.append(CAShapeLayer())
            }
        }
        
        if let notFreeParkingSpots = self.notFreeParkingSpots {
            self.notFreeParkingSpotsLayers = []
            for _ in notFreeParkingSpots {
                self.notFreeParkingSpotsLayers?.append(CAShapeLayer())
            }
        }
        
        if let _ = self.reservedParkingSpot {
            self.reservedParkingSpotLayer = CAShapeLayer()
        }
    }
    
    func configureFreeSpotPressAction(pressAction: @escaping (String) -> Void) {
        self.freeSpotPressAction = pressAction
    }
    
    func configureReservedSpotPressAction(pressAction: @escaping (String) -> Void) {
        self.reservedSpotPressAction = pressAction
    }
    
    private func createParkingSpot(parkingSpotNumber: String, parkingSpotType: ParkingSpotType, coords: OnCanvasCoords, canvas: Canvas, layer: CAShapeLayer) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: coords.x, y: coords.y))
        path.addLine(to: CGPoint(x: coords.x + canvas.width, y: coords.y))
        path.addLine(to: CGPoint(x: coords.x + canvas.width, y: coords.y + canvas.height))
        path.addLine(to: CGPoint(x: coords.x, y: coords.y + canvas.height))
        path.addLine(to: CGPoint(x: coords.x, y: coords.y))
        path.close()

        layer.path = path.cgPath
        
        switch parkingSpotType {
        case .notAvailable:
            layer.fillColor = Colors.notAvailableSpot.uiColor.cgColor
        case .notFree:
            layer.fillColor = Colors.notFreeSpot.uiColor.cgColor
        case .free:
            layer.fillColor = Colors.freeSpot.uiColor.cgColor
        case .reserved:
            layer.fillColor = Colors.accent.uiColor.cgColor
        }
        
        self.layer.addSublayer(layer)
        
        let label = CATextLayer()
        label.fontSize = 24.0
        label.frame = CGRect(x: coords.x + 5, y: coords.y + 5, width: canvas.width, height: canvas.height)
        label.string = parkingSpotNumber
        label.foregroundColor = Colors.mainText.uiColor.light.cgColor
        self.layer.addSublayer(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let notAvailableParkingSpots = self.notAvailableParkingSpots, let notAvailableParkingSpotsLayers = self.notAvailableParkingSpotsLayers {
            for idx in 0..<notAvailableParkingSpots.count {
                self.createParkingSpot(parkingSpotNumber: notAvailableParkingSpots[idx].parkingNumber, parkingSpotType: .notAvailable, coords: notAvailableParkingSpots[idx].onCanvasCoords, canvas: notAvailableParkingSpots[idx].canvas, layer: notAvailableParkingSpotsLayers[idx])
            }
        }
        
        if let notFreeParkingSpots = self.notFreeParkingSpots, let notFreeParkingSpotsLayers = self.notFreeParkingSpotsLayers {
            for idx in 0..<notFreeParkingSpots.count {
                self.createParkingSpot(parkingSpotNumber: notFreeParkingSpots[idx].parkingNumber, parkingSpotType: .notFree, coords: notFreeParkingSpots[idx].onCanvasCoords, canvas: notFreeParkingSpots[idx].canvas, layer: notFreeParkingSpotsLayers[idx])
            }
        }
        
        if let freeParkingSpots = self.freeParkingSpots, let freeParkingSpotsLayers = self.freeParkingSpotsLayers {
            for idx in 0..<freeParkingSpots.count {
                self.createParkingSpot(parkingSpotNumber: freeParkingSpots[idx].parkingNumber, parkingSpotType: .free, coords: freeParkingSpots[idx].onCanvasCoords, canvas: freeParkingSpots[idx].canvas, layer: freeParkingSpotsLayers[idx])
            }
        }
        
        if let reservedParkingSpot = self.reservedParkingSpot, let reservedParkingSpotLayer = self.reservedParkingSpotLayer {
            self.createParkingSpot(parkingSpotNumber: reservedParkingSpot.parkingNumber, parkingSpotType: .reserved, coords: reservedParkingSpot.onCanvasCoords, canvas: reservedParkingSpot.canvas, layer: reservedParkingSpotLayer)
        }
    }
    
    // MARK: - Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            position = touch.location(in: self)
            if let freeParkingSpotsLayers = self.freeParkingSpotsLayers, let position = self.position {
                for idx in 0..<freeParkingSpotsLayers.count {
                    if let path = freeParkingSpotsLayers[idx].path, path.contains(position) {
                        if let id = freeParkingSpots?[idx].id {
                            self.freeSpotPressAction?(id)
                        }
                        self.logger.info("freeSpot: \(self.freeParkingSpots?[idx].parkingNumber ?? "-")")
                        break
                    }
                }
            }
            if let reservedParkingSpotLayer = self.reservedParkingSpotLayer, let position = self.position {
                if let path = reservedParkingSpotLayer.path, path.contains(position) {
                    if let id = reservedParkingSpot?.id {
                        self.reservedSpotPressAction?(id)
                    }
                    self.logger.info("reservedSpot: \(self.reservedParkingSpot?.parkingNumber ?? "-")")
                }
            }
        }
    }
}
