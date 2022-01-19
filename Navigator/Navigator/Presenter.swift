import Foundation



protocol UserPresenter {
    var view: UserView? { get set }
}

protocol UserPresenter1 {
    var interactor: UserInteractor? { get set }
    func getData()
}

final class Presenter: UserPresenter, UserPresenter1 {
    var view: UserView?
    var interactor: UserInteractor?
    
    func getData() {
        //
    }
}
