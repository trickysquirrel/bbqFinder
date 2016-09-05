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

protocol ListAreaViewInterface {
    func reloadData(dataSource:[[AreaDataModel]])
}


class AreasPresenter: AreasInteractorOutput {

    let interface: ListAreaViewInterface
    let action: AreaSelectionAction


    init(interface: ListAreaViewInterface, action: AreaSelectionAction) {
        self.interface = interface
        self.action = action
    }


    func didFetchAreas(areaList:[String]) {

        let dataModelList = areaList.map {

            AreaDataModel(viewModel: AreaViewModel(title:$0), action: actionForTitle($0))
        }
        interface.reloadData([dataModelList])
    }


    private func actionForTitle(title:String) -> DataModelAction {

        return  {
            self.action(areaTitle: title)
        }
    }
}
