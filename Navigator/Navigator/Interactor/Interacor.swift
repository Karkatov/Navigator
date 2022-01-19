import Foundation



protocol UserInteractor {
    var internetService: UserInternetService? { get set }
    var storeService: UserStoreService? { get set }
}

final class Interactor: UserInteractor {
    var internetService: UserInternetService?
    var storeService: UserStoreService?
}
