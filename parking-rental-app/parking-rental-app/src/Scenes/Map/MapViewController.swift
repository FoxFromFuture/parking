//
//  MapViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

// MARK: - MapViewController
final class MapViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: MapBusinessLogic
    private let router: MapRoutingLogic
    private let initReservationID: String?
    private let initBuildingID: String?
    private let mapScrollView = UIScrollView()
    private var mapView: MapView?
    private let startTimeView = UIView()
    private let startTimeLabel = UILabel()
    private let endTimeView = UIView()
    private let endTimeLabel = UILabel()
    private let floorButton = UIButton()
    private let datePicker = UIDatePicker()
    private let startTimeDatePicker = UIDatePicker()
    private let endTimeDatePicker = UIDatePicker()
    private var curFloorID: String?
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingFailureLabel = UILabel()
    private let reloadButton = UIButton()
    private var currentState: MapState = .loading {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: MapRoutingLogic,
        interactor: MapBusinessLogic,
        reservationID: String?,
        buildingID: String?
    ) {
        self.router = router
        self.interactor = interactor
        self.initReservationID = reservationID
        self.initBuildingID = buildingID
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        interactor.loadStart(Model.Start.Request())
        currentState = .loading
        interactor.loadParkingMap(MapModel.ParkingMap.Request(initBuildingID: self.initBuildingID, initReservationID: self.initReservationID))
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureDatePicker()
        configureStartTimeView()
        configureStartTimeLabel()
        configureEndTimeView()
        configureEndTimeLabel()
        configureStartTimeDatePicker()
        configureFloorButton()
        configureEndTimeDatePicker()
        configureMapScrollView()
        configureLoadingIndicator()
        configureLoadingFailureLabel()
        configureReloadButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.active.uiColor
    }
    
    private func configureDatePicker() {
        datePicker.calendar = Calendar.current
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = Colors.background.uiColor
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 10
        datePicker.addTarget(self, action: #selector(datePickerValueWasChanged), for: .editingDidEnd)
    }
    
    private func configureFloorButton() {
        floorButton.backgroundColor = Colors.secondaryButton.uiColor
        floorButton.layer.cornerRadius = 10
        floorButton.setTitle("\("floor".localize()): -", for: .normal)
        floorButton.setTitleColor(Colors.mainText.uiColor, for: .normal)
        floorButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func configureStartTimeView() {
        startTimeView.backgroundColor = Colors.secondaryButton.uiColor
        startTimeView.layer.cornerRadius = 10
    }
    
    private func configureStartTimeLabel() {
        startTimeLabel.text = "startTime".localize()
        startTimeLabel.textColor = Colors.mainText.uiColor
        startTimeLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func configureStartTimeDatePicker() {
        startTimeDatePicker.calendar = Calendar.current
        startTimeDatePicker.datePickerMode = .time
        startTimeDatePicker.minuteInterval = 30
        startTimeDatePicker.layer.masksToBounds = true
        startTimeDatePicker.layer.cornerRadius = 10
        startTimeDatePicker.addTarget(self, action: #selector(startTimeDatePickerValueWasChanged), for: .editingDidEnd)
    }
    
    private func configureEndTimeView() {
        endTimeView.backgroundColor = Colors.secondaryButton.uiColor
        endTimeView.layer.cornerRadius = 10
    }
    
    private func configureEndTimeLabel() {
        endTimeLabel.text = "endTime".localize()
        endTimeLabel.textColor = Colors.mainText.uiColor
        endTimeLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func configureEndTimeDatePicker() {
        endTimeDatePicker.calendar = Calendar.current
        endTimeDatePicker.datePickerMode = .time
        endTimeDatePicker.minuteInterval = 30
        endTimeDatePicker.layer.masksToBounds = true
        endTimeDatePicker.layer.cornerRadius = 10
        endTimeDatePicker.addTarget(self, action: #selector(endTimeDatePickerValueWasChanged), for: .editingDidEnd)
    }
    
    private func configureLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.pinCenter(to: self.view)
        loadingIndicator.color = Colors.secondaryText.uiColor
    }
    
    private func configureLoadingFailureLabel() {
        loadingFailureLabel.text = "connectionError".localize()
        loadingFailureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        loadingFailureLabel.textColor = Colors.mainText.uiColor
    }
    
    private func configureReloadButton() {
        reloadButton.setTitle("reload".localize(), for: .normal)
        reloadButton.setTitleColor(Colors.active.uiColor, for: .normal)
        reloadButton.setTitleColor(Colors.secondaryText.uiColor, for: .highlighted)
        reloadButton.backgroundColor = .clear
        reloadButton.addTarget(self, action: #selector(reloadButtonWasPressed), for: .touchUpInside)
    }
    
    private func configureMapScrollView() {
        mapScrollView.backgroundColor = Colors.background.uiColor
        mapScrollView.isScrollEnabled = true
        mapScrollView.minimumZoomScale = 0.5
        mapScrollView.maximumZoomScale = 1.2
        mapScrollView.clipsToBounds = true
        mapScrollView.delegate = self
        mapScrollView.showsVerticalScrollIndicator = false
        mapScrollView.showsHorizontalScrollIndicator = false
    }
    
    private func configureMapView(notAvailableParkingSpots: [ParkingSpot]?, notFreeParkingSpots: [ParkingSpot]?, freeParkingSpots: [ParkingSpot]?, reservedParkingSpot: ParkingSpot?, mapCanvas: Canvas) {
        let mapFrame = CGRect(x: 0, y: 0, width: mapCanvas.width, height: mapCanvas.height)
        self.mapView = MapView(notAvailableParkingSpots: notAvailableParkingSpots, notFreeParkingSpots: notFreeParkingSpots, freeParkingSpots: freeParkingSpots, reservedParkingSpot: reservedParkingSpot, frame: mapFrame)
        self.mapView?.configureFreeSpotPressAction(pressAction: { [weak self] id in
            if let date = self?.datePicker.date, let startTime = self?.startTimeDatePicker.date, let endTime = self?.endTimeDatePicker.date, let onUpdateAction = self?.reservationCardOnUpdateAction {
                self?.interactor.loadReservationCard(MapModel.ReservationCard.Request(parkingSpotID: id, date: date, startTime: startTime, endTime: endTime, onUpdateAction: onUpdateAction, spotState: .freeSpot))
            }
        })
        self.mapView?.configureReservedSpotPressAction(pressAction: { [weak self] id in
            if let date = self?.datePicker.date, let startTime = self?.startTimeDatePicker.date, let endTime = self?.endTimeDatePicker.date, let onUpdateAction = self?.reservationCardOnUpdateAction {
                self?.interactor.loadReservationCard(MapModel.ReservationCard.Request(parkingSpotID: id, date: date, startTime: startTime, endTime: endTime, onUpdateAction: onUpdateAction, spotState: .reservedSpot))
            }
        })
        if let mapView = self.mapView {
            self.mapScrollView.contentSize = CGSize(width: mapCanvas.width, height: mapCanvas.height)
            self.mapScrollView.addSubview(mapView)
            self.mapScrollView.zoomScale = 0.5
            
            self.view.addSubview(datePicker)
            datePicker.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
            datePicker.pinLeft(to: self.view.leadingAnchor, 17)
            
            self.view.addSubview(floorButton)
            floorButton.pinTop(to: self.datePicker.bottomAnchor, 10)
            floorButton.pinLeft(to: self.view.leadingAnchor, 17)
            floorButton.setWidth(90)
            
            self.view.addSubview(startTimeView)
            startTimeView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
            startTimeView.pinRight(to: self.view.trailingAnchor, 17)
            
            self.startTimeView.addSubview(startTimeDatePicker)
            startTimeDatePicker.pinVertical(to: self.startTimeView, 5)
            startTimeDatePicker.pinRight(to: self.startTimeView.trailingAnchor, 10)
            
            self.startTimeView.addSubview(startTimeLabel)
            startTimeLabel.pinLeft(to: self.startTimeView.leadingAnchor, 10)
            startTimeLabel.pinVertical(to: self.startTimeView, 5)
            startTimeLabel.pinRight(to: self.startTimeDatePicker.leadingAnchor, 5)
            
            self.view.addSubview(endTimeView)
            endTimeView.pinTop(to: self.startTimeDatePicker.bottomAnchor, 10)
            endTimeView.pinRight(to: self.view.trailingAnchor, 17)
            
            self.endTimeView.addSubview(endTimeDatePicker)
            endTimeDatePicker.pinVertical(to: self.endTimeView, 5)
            endTimeDatePicker.pinRight(to: self.endTimeView.trailingAnchor, 10)
            
            self.endTimeView.addSubview(endTimeLabel)
            endTimeLabel.pinLeft(to: self.endTimeView.leadingAnchor, 10)
            endTimeLabel.pinVertical(to: self.endTimeView, 5)
            endTimeLabel.pinRight(to: self.endTimeDatePicker.leadingAnchor, 5)
        }
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadPreviousScene(Model.PreviousScene.Request())
    }
    
    private func showMapScrollView() {
        view.addSubview(mapScrollView)
        mapScrollView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        mapScrollView.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        mapScrollView.pinHorizontal(to: self.view)
    }
    
    @objc
    private func datePickerValueWasChanged() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if let curFloorID = self.curFloorID {
            currentState = .loading
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: self.datePicker.date, startTime: self.startTimeDatePicker.date, endTime: self.endTimeDatePicker.date))
        }
    }
    
    @objc
    private func startTimeDatePickerValueWasChanged() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if let curFloorID = self.curFloorID {
            currentState = .loading
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: self.datePicker.date, startTime: self.startTimeDatePicker.date, endTime: self.endTimeDatePicker.date))
        }
    }
    
    @objc
    private func endTimeDatePickerValueWasChanged() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if let curFloorID = self.curFloorID  {
            currentState = .loading
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: self.datePicker.date, startTime: self.startTimeDatePicker.date, endTime: self.endTimeDatePicker.date))
        }
    }
    
    @objc
    private func reloadButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        loadingFailureLabel.removeFromSuperview()
        reloadButton.removeFromSuperview()
        if currentState == .loadingError {
            currentState = .loading
            self.interactor.loadParkingMap(MapModel.ParkingMap.Request(initBuildingID: self.initBuildingID, initReservationID: self.initReservationID))
        } else if currentState == .reloadingError {
            if let curFloorID = self.curFloorID {
                currentState = .loading
                self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: self.datePicker.date, startTime: self.startTimeDatePicker.date, endTime: self.endTimeDatePicker.date))
            }
        }
    }
    
    private func showLoadingFailure() {
        view.addSubview(loadingFailureLabel)
        loadingFailureLabel.pinCenterX(to: self.view.centerXAnchor)
        loadingFailureLabel.pinTop(to: self.view, self.view.frame.height / 2.0 - 15)
        
        view.addSubview(reloadButton)
        reloadButton.pinTop(to: self.view, self.view.frame.height / 2.0 + 15)
        reloadButton.pinCenterX(to: self.view.centerXAnchor)
    }
    
    private func reservationCardOnUpdateAction() {
        if let curFloorID = self.curFloorID {
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: self.datePicker.date, startTime: self.startTimeDatePicker.date, endTime: self.endTimeDatePicker.date))
        }
    }
}

// MARK: - DisplayLogic
extension MapViewController: MapDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayParkingMap(_ viewModel: Model.ParkingMap.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            
            self?.showMapScrollView()
            
            self?.configureMapView(notAvailableParkingSpots: viewModel.notAvailableParkingSpots, notFreeParkingSpots: viewModel.notFreeParkingSpots, freeParkingSpots: viewModel.freeParkingSpots, reservedParkingSpot: viewModel.reservedParkingSpot, mapCanvas: viewModel.parkingLevelCanvas)
            
            self?.datePicker.date = viewModel.curDate
            self?.datePicker.minimumDate = viewModel.minDate
            self?.datePicker.maximumDate = viewModel.maxDate
            
            self?.startTimeDatePicker.date = viewModel.curStartTimeDate
            self?.startTimeDatePicker.minimumDate = viewModel.minStartTimeDate
            self?.startTimeDatePicker.maximumDate = viewModel.maxStartTimeDate
            
            self?.endTimeDatePicker.date = viewModel.curEndTimeDate
            self?.endTimeDatePicker.minimumDate = viewModel.minEndTimeDate
            self?.endTimeDatePicker.maximumDate = viewModel.maxEndTimeDate
            
            self?.curFloorID = viewModel.levelForDisplay.id
            
            var actions: [UIAction] = []
            
            actions.append(UIAction(title: "\("floor".localize()): \(viewModel.levelForDisplay.levelNumber)", state: .on, handler: { action in
                self?.curFloorID = viewModel.levelForDisplay.id
                if let curFloorID = self?.curFloorID, let curDate = self?.datePicker.date, let curStartTime = self?.startTimeDatePicker.date, let curEndTime = self?.endTimeDatePicker.date {
                    self?.currentState = .loading
                    self?.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
                }
            }))
            
            for floor in viewModel.parkingLevels {
                if floor.levelNumber != viewModel.levelForDisplay.levelNumber {
                    actions.append(UIAction(title: "\("floor".localize()): \(floor.levelNumber)", handler: { action in
                        self?.curFloorID = floor.id
                        if let curFloorID = self?.curFloorID, let curDate = self?.datePicker.date, let curStartTime = self?.startTimeDatePicker.date, let curEndTime = self?.endTimeDatePicker.date {
                            self?.currentState = .loading
                            self?.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
                        }
                    }))
                }
            }
            
            self?.floorButton.menu = UIMenu(children: actions)
            
            self?.floorButton.showsMenuAsPrimaryAction = true
            self?.floorButton.changesSelectionAsPrimaryAction = true
            
            self?.navigationItem.title = viewModel.buildingForDisplay.name
        }
    }
    
    func displayPreviousScene(_ viewModel: Model.PreviousScene.ViewModel) {
        self.router.routeToPreviousScene()
    }
    
    func displayReloadedMap(_ viewModel: Model.ReloadMap.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            self?.mapView?.removeFromSuperview()
            self?.datePicker.removeFromSuperview()
            self?.startTimeView.removeFromSuperview()
            self?.startTimeLabel.removeFromSuperview()
            self?.startTimeDatePicker.removeFromSuperview()
            self?.endTimeView.removeFromSuperview()
            self?.endTimeLabel.removeFromSuperview()
            self?.endTimeDatePicker.removeFromSuperview()
            self?.floorButton.removeFromSuperview()
            
            if let updatedCurEndTime = viewModel.curEndTimeDate {
                self?.endTimeDatePicker.date = updatedCurEndTime
            }
            
            self?.startTimeDatePicker.minimumDate = viewModel.minStartTimeDate
            self?.endTimeDatePicker.minimumDate = viewModel.minEndTimeDate

            self?.configureMapView(notAvailableParkingSpots: viewModel.notAvailableParkingSpots, notFreeParkingSpots: viewModel.notFreeParkingSpots, freeParkingSpots: viewModel.freeParkingSpots, reservedParkingSpot: viewModel.reservedParkingSpot, mapCanvas: viewModel.parkingLevelCanvas)
        }
    }
    
    func displayReservationCard(_ viewModel: Model.ReservationCard.ViewModel) {
        self.router.routeToReservationCard(Model.ReservationCard.RouteData(parkingSpotID: viewModel.parkingSpotID, date: viewModel.date, startTime: viewModel.startTime, endTime: viewModel.endTime, onUpdateAction: viewModel.onUpdateAction, spotState: viewModel.spotState))
    }
    
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loadingError
        }
    }
    
    func displayReloadingFailure(_ viewModel: Model.ReloadingFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .reloadingError
        }
    }
}

extension MapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapView
    }
}

// MARK: - UpdateUIForState
extension MapViewController {
    func updateUIForState(_ state: MapState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .loadingError:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        case .reloadingError:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        }
    }
}
