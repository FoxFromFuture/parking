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
    private let tabBar = TabBar()
    private let mapScrollView = UIScrollView()
    private var mapView: MapView?
    private let floorButton = UIButton()
    private let datePicker = UIDatePicker()
    private let startTimeDatePicker = UIDatePicker()
    private let endTimeDatePicker = UIDatePicker()
    private var curDate: String?
    private var curStartTime: String?
    private var curEndTime: String?
    private var curFloorID: String?
    private var hasReservationsForTime: Bool = false
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
        configureTabBar()
        configureDatePicker()
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
    
    private func configureTabBar() {
        view.addSubview(tabBar)
        tabBar.pinBottom(to: self.view.bottomAnchor)
        tabBar.pinLeft(to: self.view.leadingAnchor)
        tabBar.pinRight(to: self.view.trailingAnchor)
        tabBar.setHeight(92)
        tabBar.setMoreButtonAction { [weak self] in
            self?.interactor.loadMore(Model.More.Request())
        }
        tabBar.setHomeButtonAction { [weak self] in
            self?.interactor.loadHome(Model.Home.Request())
        }
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = Colors.secondaryButton.uiColor
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
    
    private func configureStartTimeDatePicker() {
        startTimeDatePicker.datePickerMode = .time
        startTimeDatePicker.backgroundColor = Colors.secondaryButton.uiColor
        startTimeDatePicker.minuteInterval = 30
        startTimeDatePicker.layer.masksToBounds = true
        startTimeDatePicker.layer.cornerRadius = 10
        startTimeDatePicker.layer.backgroundColor = UIColor.clear.cgColor
        startTimeDatePicker.addTarget(self, action: #selector(startTimeDatePickerValueWasChanged), for: .editingDidEnd)
    }
    
    private func configureEndTimeDatePicker() {
        endTimeDatePicker.datePickerMode = .time
        endTimeDatePicker.minuteInterval = 30
        endTimeDatePicker.backgroundColor = Colors.secondaryButton.uiColor
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
    }
    
    private func configureMapView(notAvailableParkingSpots: [ParkingSpot]?, notFreeParkingSpots: [ParkingSpot]?, freeParkingSpots: [ParkingSpot]?, reservedParkingSpot: ParkingSpot?, mapCanvas: Canvas) {
        let mapFrame = CGRect(x: 0, y: 0, width: mapCanvas.width, height: mapCanvas.height)
        self.mapView = MapView(notAvailableParkingSpots: notAvailableParkingSpots, notFreeParkingSpots: notFreeParkingSpots, freeParkingSpots: freeParkingSpots, reservedParkingSpot: reservedParkingSpot, frame: mapFrame)
        self.mapView?.configureFreeSpotPressAction(pressAction: { [weak self] id in
            if let date = self?.curDate, let startTime = self?.curStartTime, let endTime = self?.curEndTime, let onUpdateAction = self?.reservationCardOnUpdateAction {
                self?.interactor.loadReservationCard(MapModel.ReservationCard.Request(parkingSpotID: id, date: date, startTime: startTime, endTime: endTime, onUpdateAction: onUpdateAction, spotState: .freeSpot))
            }
        })
        self.mapView?.configureReservedSpotPressAction(pressAction: { [weak self] id in
            if let date = self?.curDate, let startTime = self?.curStartTime, let endTime = self?.curEndTime, let onUpdateAction = self?.reservationCardOnUpdateAction {
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
            
            self.view.addSubview(startTimeDatePicker)
            startTimeDatePicker.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
            startTimeDatePicker.pinRight(to: self.view.trailingAnchor, 17)
            
            self.view.addSubview(endTimeDatePicker)
            endTimeDatePicker.pinTop(to: self.startTimeDatePicker.bottomAnchor, 10)
            endTimeDatePicker.pinRight(to: self.view.trailingAnchor, 17)
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
        mapScrollView.pinBottom(to: self.tabBar.topAnchor)
        mapScrollView.pinHorizontal(to: self.view)
    }
    
    @objc
    private func datePickerValueWasChanged() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let curMonthInt = Calendar.current.component(.month, from: self.datePicker.date)
        let curDayInt = Calendar.current.component(.day, from: self.datePicker.date)
        var curMonth = "\(Calendar.current.component(.month, from: self.datePicker.date))"
        var curDay = "\(Calendar.current.component(.day, from: self.datePicker.date))"
        
        if curMonthInt <= 9 {
            curMonth = "0\(curMonth)"
        }
        if curDayInt <= 9 {
            curDay = "0\(curDay)"
        }
        
        self.curDate = "\(Calendar.current.component(.year, from: self.datePicker.date))-\(curMonth)-\(curDay)"
        
        if let curFloorID = self.curFloorID, let curDate = self.curDate, let curStartTime = self.curStartTime, let curEndTime = self.curEndTime {
            currentState = .loading
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
        }
    }
    
    @objc
    private func startTimeDatePickerValueWasChanged() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let curHourInt = Calendar.current.component(.hour, from: self.startTimeDatePicker.date)
        let curMinuteInt = Calendar.current.component(.minute, from: self.startTimeDatePicker.date)
        var curHour = "\(Calendar.current.component(.hour, from: self.startTimeDatePicker.date))"
        var curMinute = "\(Calendar.current.component(.minute, from: self.startTimeDatePicker.date))"
        
        if curHourInt <= 9 {
            curHour = "0\(curHour)"
        }
        if curMinuteInt <= 9 {
            curMinute = "0\(curMinute)"
        }
        
        self.curStartTime = "\(curHour):\(curMinute)"
        
        if let curFloorID = self.curFloorID, let curDate = self.curDate, let curStartTime = self.curStartTime, let curEndTime = self.curEndTime {
            currentState = .loading
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
        }
    }
    
    @objc
    private func endTimeDatePickerValueWasChanged() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let curHourInt = Calendar.current.component(.hour, from: self.endTimeDatePicker.date)
        let curMinuteInt = Calendar.current.component(.minute, from: self.endTimeDatePicker.date)
        var curHour = "\(Calendar.current.component(.hour, from: self.endTimeDatePicker.date))"
        var curMinute = "\(Calendar.current.component(.minute, from: self.endTimeDatePicker.date))"
        
        if curHourInt <= 9 {
            curHour = "0\(curHour)"
        }
        if curMinuteInt <= 9 {
            curMinute = "0\(curMinute)"
        }
        
        self.curEndTime = "\(curHour):\(curMinute)"
        
        if let curFloorID = self.curFloorID, let curDate = self.curDate, let curStartTime = self.curStartTime, let curEndTime = self.curEndTime {
            currentState = .loading
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
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
            if let curFloorID = self.curFloorID, let curDate = self.curDate, let curStartTime = self.curStartTime, let curEndTime = self.curEndTime {
                currentState = .loading
                self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
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
        if let curFloorID = self.curFloorID, let curDate = self.curDate, let curStartTime = self.curStartTime, let curEndTime = self.curEndTime {
            self.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
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
            
            self?.hasReservationsForTime = viewModel.hasReservationsForTime
            
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
            
            self?.curDate = viewModel.curDateStr
            self?.curEndTime = viewModel.curEndTimeStr
            self?.curStartTime = viewModel.curStartTimeStr
            self?.curFloorID = viewModel.levelForDisplay.id
            
            var actions: [UIAction] = []
            
            actions.append(UIAction(title: "\("floor".localize()): \(viewModel.levelForDisplay.levelNumber)", state: .on, handler: { action in
                self?.curFloorID = viewModel.levelForDisplay.id
                if let curFloorID = self?.curFloorID, let curDate = self?.curDate, let curStartTime = self?.curStartTime, let curEndTime = self?.curEndTime {
                    self?.currentState = .loading
                    self?.interactor.loadReloadedMap(MapModel.ReloadMap.Request(floorID: curFloorID, date: curDate, startTime: curStartTime, endTime: curEndTime))
                }
            }))
            
            for floor in viewModel.parkingLevels {
                if floor.levelNumber != viewModel.levelForDisplay.levelNumber {
                    actions.append(UIAction(title: "\("floor".localize()): \(floor.levelNumber)", handler: { action in
                        self?.curFloorID = floor.id
                        if let curFloorID = self?.curFloorID, let curDate = self?.curDate, let curStartTime = self?.curStartTime, let curEndTime = self?.curEndTime {
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
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayPreviousScene(_ viewModel: Model.PreviousScene.ViewModel) {
        self.router.routeToPreviousScene()
    }
    
    func displayReloadedMap(_ viewModel: Model.ReloadMap.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            self?.mapView?.removeFromSuperview()
            self?.datePicker.removeFromSuperview()
            self?.startTimeDatePicker.removeFromSuperview()
            self?.endTimeDatePicker.removeFromSuperview()
            self?.floorButton.removeFromSuperview()
            
            self?.startTimeDatePicker.minimumDate = viewModel.minStartTimeDate
            self?.endTimeDatePicker.minimumDate = viewModel.minEndTimeDate
            
            if let endTime = viewModel.curEndTimeDate, let endTimeStr = viewModel.curEndTimeStr {
                self?.endTimeDatePicker.date = endTime
                self?.curEndTime = endTimeStr
            }
            
            self?.hasReservationsForTime = viewModel.hasReservationsForTime
            
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
