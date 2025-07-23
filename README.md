# Тестовое задание

Мобильное приложение на iOS, реализующее просмотр списка акций с возможностью отслеживания изменений цены и добавления избранных компаний.


---

## 🛠️ Стек технологий

- **Swift**
- **UIKit**
- **SnapKit** — верстка UI через автолейаут кодом
- **CoreData** — хранение избранных акций
- **MVVM + Coordinators** — архитектура

---


## 🧭 Архитектура

Проект построен на основе паттерна **MVVM + Coordinators**:

- `ViewController` — отображает данные, управляется через ViewModel
- `ViewModel` — преобразует модельные данные в формат для отображения
- `Coordinator` — отвечает за навигацию и инициализацию модулей

---

## 📂 Структура проекта
<details>
<summary>📁 Структура проекта</summary>

- Common/
  - Base/
    - ViewControllers/
      - BaseViewController.swift
    - ViewModels/
      - BaseViewModel.swift  
      - BaseViewModelCoordinatorDelegate.swift  
      - BaseViewModelProtocol.swift
    - Views/
      - Cells/
  - Models/
    - AppConstants.swift
    - Environment.swift
  - ViewDatas/
    - AlertViewData.swift  
    - OptionItemViewData.swift

- Extensions/
  - Collection+.swift  
  - UIColor+.swift  
  - UINavigationController+Completion.swift  
  - UIStackView+ArrangedSubviews.swift  
  - UIView+Subviews.swift  
  - UIViewController+Keyboard.swift

- Generated/
  - Colors.swift  
  - Fonts.swift  
  - Images.swift  
  - Strings.swift

- Helpers/
  - DiffableDataSourceHelperImplementation.swift  
  - Feedback.swift  
  - ListTableCellFactory.swift  
  - Sizes.swift

- Screens/
  - List/
    - ListCoordinator.swift  
    - ViewController/
      - ListViewController.swift  
    - ViewDatas/
      - CollectionRowViewData.swift  
      - ListTableViewData.swift  
    - ViewModels/
      - ListViewModel.swift  
      - ListViewModelCoordinatorDelegate.swift  
    - Views/
      - Cells/  
      - Headers/  
      - ListFilterTabsView.swift  
      - SearchBarView.swift
  - Root/
    - RootCoordinator.swift  
    - ViewControllers/
      - RootViewController.swift  
    - ViewModels/
      - RootViewModel.swift  
      - RootViewModelCoordinatorDelegate.swift

- Services/
  - API/
    - APIService.swift  
    - APIServiceImplementation.swift  
    - LargeJSONStreamParser.swift  
    - Models/
      - StockModel.swift  
  - CoreData/
    - CoreDataService.swift  
    - CoreDataServiceImplementation.swift  
    - Model/
      - luxury_team_test_task.xcdatamodeld  
  - Logs/
    - LogService.swift  
  - Storage/
    - StorageService.swift

- Startup/
  - AppDelegate.swift  
  - Base.lproj/
    - LaunchScreen.storyboard  
  - Coordinator/
    - AppCoordinator.swift  
    - Coordinator.swift

- Resources/
  - en.lproj/  
  - Fonts/  
  - Localizations/
    - en.lproj/
      - Localizable.strings

- Info.plist
</details>
