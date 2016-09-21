//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


typealias DataModelAction = (() -> Void)

struct AreaDataModel {
    let viewModel: AreaViewModel
    let action: DataModelAction
}

struct AreaViewModel {
    let title: String
}

enum AreasMapPresenterResponse {
    case updateAreas([[AreaDataModel]])
}

protocol ListAreaPresenterOutput: class {
    func presenterUpdate(_ response:AreasMapPresenterResponse)
}


class AreasPresenter: AreasInteractorOutput {

    weak var output: ListAreaPresenterOutput?
    let action: AreaSelectionAction


    init(interface: ListAreaPresenterOutput, action: @escaping AreaSelectionAction) {
        self.output = interface
        self.action = action
    }


    func didFetchAreas(_ areaList:[BBQArea]) {

        let dataModelList = areaList.map {

            AreaDataModel(viewModel: AreaViewModel(title:$0.title()), action: actionForTitle($0))
        }
        output?.presenterUpdate( .updateAreas([dataModelList]) )
    }


    fileprivate func actionForTitle(_ area: BBQArea) -> DataModelAction {

        return  {
            self.action(area)
        }
    }
}
