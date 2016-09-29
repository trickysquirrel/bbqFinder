//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

struct AreaViewModel {
    let title: String
    let subtitle: String
    let action: DataModelAction
}

enum AreasMapPresenterResponse {
    case updateAreas([[AreaViewModel]])
}

protocol ListAreaPresenterOutput: class {
    func presenterUpdate(_ response:AreasMapPresenterResponse)
}


final class AreasPresenter: AreasInteractorOutput {

    private weak var output: ListAreaPresenterOutput?
    private let action: RouterAreaSelectionAction


    init(interface: ListAreaPresenterOutput, action: @escaping RouterAreaSelectionAction) {
        self.output = interface
        self.action = action
    }


    func didFetchAreas(_ areaList:[BBQArea]) {

        let dataModelList = areaList.map {

            AreaViewModel(title:$0.title(), subtitle:$0.subtitle(),
                          action: actionForTitle($0))
        }
        output?.presenterUpdate( .updateAreas([dataModelList]) )
    }


    fileprivate func actionForTitle(_ area: BBQArea) -> DataModelAction {

        return  {
            self.action(area)
        }
    }
}
