# 📈 Luxury Stocks

Тестовое задание для компании **Luxury Team**.

Мобильное приложение на iOS, реализующее просмотр списка акций с возможностью отслеживания изменений цены и добавления избранных компаний.

Время выполнения: 2 рабочих дня.

---

## 🛠️ Стек технологий

- **Swift**
- **UIKit**
- **SnapKit** — верстка UI через автолейаут кодом
- **CoreData** — хранение избранных акций
- **MVVM + Coordinators** — архитектура

---

## 📱 Функциональность

- Загрузка списка публичных акций по API от [FMP](https://site.financialmodelingprep.com/developer/docs)
- Отображение:
  - Названия и тикера компании
  - Текущей цены
  - Изменения за день (`change`, `changePercent`)
- Добавление/удаление из избранного
- Хранение избранных акций локально (CoreData)
- Фильтрация: Все / Избранное
- Отображение лоадеров и состояния "нет данных"

---

## 🧭 Архитектура

Проект построен на основе паттерна **MVVM + Coordinators**:

- `ViewController` — отображает данные, управляется через ViewModel
- `ViewModel` — преобразует модельные данные в формат для отображения
- `Coordinator` — отвечает за навигацию и инициализацию модулей

---

## 📷 Скриншоты

<img width="245.5" height="465" alt="Screenshot 2025-07-20 at 11 32 50 PM" src="https://github.com/user-attachments/assets/f8133c65-af72-4761-8c3b-1c74aa16df64" />
<img width="245.5" height="465" alt="Screenshot 2025-07-20 at 11 33 04 PM" src="https://github.com/user-attachments/assets/50abf5fd-f34c-42df-a2e7-b21350f44f85" />
<img width="245.5" height="465" alt="Screenshot 2025-07-20 at 11 33 33 PM" src="https://github.com/user-attachments/assets/e5787dac-e127-4583-8b8a-722ef10ed52c" />
<img width="245.5" height="465" alt="Screenshot 2025-07-20 at 11 33 44 PM" src="https://github.com/user-attachments/assets/cefa2703-638b-4e9f-95c6-af7ed32158e5" />

---

## 🎨 Дизайн

Дизайн доступен в [Figma](https://www.figma.com/design/dhE0H7hjTS2zDxGv909VFe/Тестовое--Copy-?node-id=0-1&p=f&t=muC6JNMK5OqM6fRF-0)

---

## 🚀 Запуск проекта

1. Откройте `.xcodeproj` или `.xcworkspace` в **Xcode 15+**
2. Убедитесь, что выбрана цель `iOS 15.6+`
3. Установите зависимости через Swift Package Manager (если подключено)
4. Соберите и запустите проект (`Cmd + R`)

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
