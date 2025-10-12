cmake_minimum_required(VERSION 3.16)

project(SalesMate VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# ----------------------------------------
# ZXing setup
# ----------------------------------------
set(ZXING_EXAMPLES OFF CACHE BOOL "" FORCE)
set(ZXING_BLACKBOX_TESTS OFF CACHE BOOL "" FORCE)
set(ZXING_UNIT_TESTS OFF CACHE BOOL "" FORCE)
add_subdirectory(core/zxing-cpp EXCLUDE_FROM_ALL)

# ----------------------------------------
# Qt setup
# ----------------------------------------
find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia Sql Charts Concurrent)
qt_standard_project_setup(REQUIRES 6.8)

# ----------------------------------------
# Executable definition
# ----------------------------------------
qt_add_executable(appSalesMate
    main.cpp
    rsources.qrc
)

# ----------------------------------------
# Android package directory
# ----------------------------------------
set_property(TARGET appSalesMate APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

# ----------------------------------------
# QML & C++ sources
# ----------------------------------------
qt_add_qml_module(appSalesMate
    URI SalesMate
    VERSION 1.0

    QML_FILES
        Main.qml

        # Drawer
        UI/Drawer/Profile.qml
        UI/Drawer/ImageProcessor.js
        UI/Drawer/DrawerMenu.qml
        UI/Drawer/DrawerModel.qml
        UI/Drawer/DrawerDelegate.qml

        # Home
        UI/Home/HomePage.qml
        UI/Home/MainSatckView.qml
        UI/Home/Home.qml
        UI/Home/CurrentSales.qml

        # Welcome
        UI/Welcome/WelcomePage.qml

        # Auth
        UI/Auth/SignInPage.qml
        UI/Auth/SignUpPage.qml

        # About
        UI/About/AboutAppPage.qml
        UI/About/AboutUsPage.qml

        # Stock
        UI/Stock/AddItemPage.qml
        UI/Stock/ShowStock.qml
        UI/Stock/AddExpensePage.qml
        UI/Stock/OtherIncomePage.qml
        UI/Stock/ShowSalesPage.qml
        UI/Stock/AddStock.qml
        UI/Stock/SearchBar.qml
        UI/Stock/StockModel.qml
        UI/Stock/StockDelegate.qml
        UI/Stock/CurrentSalesDelegate.qml

        # Profile
        UI/Profile/ProfileEditPage.qml
        UI/Profile/AvataDrawerTools.qml
        UI/Profile/CameraPage.qml
        UI/Profile/ProfilePage.qml

        # Notification
        UI/Notification/NotificationPage.qml
        UI/Notification/NotificationModel.qml
        UI/Notification/NotificationDelegate.qml

        # Utils
        UI/Utils/BarcodeScanner.qml
        UI/Utils/ScannerTools.qml
        UI/Utils/CustomButton.qml
        UI/Utils/Avatar.qml
        UI/Utils/Utils.js
        UI/Utils/InfoPopup.qml
        UI/Utils/DirectionalText.qml
        UI/Utils/BarcodeSearch.qml
        UI/Utils/Heading.qml
        UI/Utils/PopupHeading.qml
        UI/Utils/ProductEditPopup.qml
        UI/Utils/AddNewService.qml
        UI/Utils/CircularProgressBar.qml
        UI/Utils/SearchBar.qml

        # Search Barcode
        UI/SearchBarcode/SearchBarcodeDelegate.qml

        # Satatistics
        UI/Satatistics/Statistics.qml
        UI/Satatistics/Summary.qml
        UI/Satatistics/Reports.qml
        UI/Satatistics/Daily.qml
        UI/Satatistics/Monthly.qml
        UI/Satatistics/Yearly.qml
        UI/Satatistics/ItemReportViewDelegate.qml
        UI/Satatistics/ItemReportViewModel.qml

        # Updates
        UI/Updates/ChechUpdatePage.qml

        # Receipt
        UI/Receipt/Receipt.qml
        UI/Receipt/ReceiptText.qml

    SOURCES
        core/sources/androidsystem.cpp
        core/sources/androidsystem.h
        core/sources/barcodeengine.cpp
        core/sources/barcodeengine.h
        core/sources/product.cpp
        core/sources/product.h
        core/sources/databasemanager.cpp
        core/sources/databasemanager.h
        core/sources/productfilterproxymodel.cpp
        core/sources/productfilterproxymodel.h
        core/sources/incomemodel.cpp
        core/sources/incomemodel.h
        core/sources/expensesmodel.cpp
        core/sources/expensesmodel.h
        core/sources/expense.cpp
        core/sources/expense.h
        core/sources/income.cpp
        core/sources/income.h
        core/sources/service.cpp
        core/sources/service.h
        core/sources/servicemodel.cpp
        core/sources/servicemodel.h
        core/sources/reportmanager.cpp
        core/sources/reportmanager.h
)

# ----------------------------------------
# Android-specific sources
# ----------------------------------------
target_sources(appSalesMate PRIVATE
    android/AndroidManifest.xml
    android/build.gradle
    android/res/values/libs.xml
    android/res/xml/qtprovider_paths.xml
    android/gradle/wrapper/gradle-wrapper.jar
    android/gradle/wrapper/gradle-wrapper.properties
    android/gradle.properties
    android/gradlew
    android/gradlew.bat

    android/src/com/salesmate/ScheduledWorker.java
    android/src/com/salesmate/WorkManagerHelper.java
    android/src/com/salesmate/NativeBridge.java
    android/src/com/salesmate/AlarmHelper.java
    android/src/com/salesmate/BatteryOptimizationHelper.java
    android/src/com/salesmate/AlarmReceiver.java
    android/src/com/salesmate/AlarmService.java
)

# ----------------------------------------
# Linking order
# ----------------------------------------
target_link_libraries(appSalesMate
    PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::Multimedia
        Qt6::Sql
        Qt6::Charts
        Qt6::Concurrent
        ZXing::ZXing
)

# ----------------------------------------
# Target properties
# ----------------------------------------
set_target_properties(appSalesMate PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

# ----------------------------------------
# Install rules
# ----------------------------------------
include(GNUInstallDirs)
install(TARGETS appSalesMate
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
