import Foundation
import UIKit


typealias EntryPoint = UserView & UIViewController

protocol UserRouter {
    var entry: EntryPoint? { get }
    static func start() -> UserRouter
}

final class Router: UserRouter {
    var entry: EntryPoint?
    
    static func start() -> UserRouter {
        
        let router = Router()
        
        var view: UserView = ViewController()
        let presenter = Presenter()
        var interactor: UserInteractor = Interactor()
        let internetService: UserInternetService = InternetService()
        let storeService: UserStoreService = StoreService()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        
        interactor.internetService = internetService
        interactor.storeService = storeService
        
        router.entry = view as? EntryPoint
        return router
    }
}
