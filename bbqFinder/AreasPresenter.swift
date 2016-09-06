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
    func presenterUpdate(response:AreasMapPresenterResponse)
}


class AreasPresenter: AreasInteractorOutput {

    weak var output: ListAreaPresenterOutput?
    let action: AreaSelectionAction


    init(interface: ListAreaPresenterOutput, action: AreaSelectionAction) {
        self.output = interface
        self.action = action
    }


    func didFetchAreas(areaList:[BBQArea]) {

        let dataModelList = areaList.map {

            AreaDataModel(viewModel: AreaViewModel(title:$0.title()), action: actionForTitle($0))
        }
        output?.presenterUpdate( .updateAreas([dataModelList]) )
    }


    private func actionForTitle(area: BBQArea) -> DataModelAction {

        return  {
            self.action(area: area)
        }
    }
}
