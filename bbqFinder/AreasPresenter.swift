//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

struct AreaViewModel {
    let title: String
    let subtitle: String
    let showMapAction: ViewModelAction
}

enum AreasMapPresenterResponse {
    case updateAreas([[AreaViewModel]])
}

protocol ListAreaPresenterOutput: class {
    func presenterUpdate(_ response:AreasMapPresenterResponse)
}


final class AreasPresenter: AreasInteractorOutput {

    private weak var output: ListAreaPresenterOutput?
    private let routerShowMapAction: RouterAreaSelectionAction


    init(interface: ListAreaPresenterOutput, routerShowMapAction: @escaping RouterAreaSelectionAction) {
        self.output = interface
        self.routerShowMapAction = routerShowMapAction
    }


    func didFetchAreas(_ areaList:[BBQArea]) {

        let dataModelList = areaList.map {

            AreaViewModel(title:$0.title(),
                          subtitle:$0.subtitle(),
                          showMapAction: showMapActionForArea($0))
        }
        output?.presenterUpdate( .updateAreas([dataModelList]) )
    }


    fileprivate func showMapActionForArea(_ area: BBQArea) -> ViewModelAction {

        return  {
            self.routerShowMapAction(area)
        }
    }
}
