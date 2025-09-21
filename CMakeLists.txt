cmake_minimum_required(VERSION 3.16)

project(SalesMate VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
#Configure ZXing properly BEFORE adding it
set(ZXING_EXAMPLES OFF CACHE BOOL "" FORCE)
set(ZXING_BLACKBOX_TESTS OFF CACHE BOOL "" FORCE)
set(ZXING_UNIT_TESTS OFF CACHE BOOL "" FORCE)
add_subdirectory(core/zxing-cpp EXCLUDE_FROM_ALL)  # Critical change
find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia Sql Charts Concurrent)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appSalesMate
    main.cpp
     rsources.qrc
)

qt_add_qml_module(appSalesMate
    URI SalesMate
    VERSION 1.0

    QML_FILES
        Main.qml

        # UI Components
        UI/Drawer/Profile.qml
        UI/Drawer/ImageProcessor.js
        UI/Drawer/DrawerMenu.qml
        UI/Drawer/DrawerModel.qml
        UI/Drawer/DrawerDelegate.qml
        UI/Home/HomePage.qml
        UI/Home/MainSatckView.qml
        UI/Home/Home.qml
        UI/Home/CurrentSales.qml
        UI/Welcome/WelcomePage.qml
        UI/Auth/SignInPage.qml
        UI/Auth/SignUpPage.qml
        UI/About/AboutAppPage.qml
        UI/About/AboutUsPage.qml
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
        UI/Profile/ProfileEditPage.qml
        UI/Profile/AvataDrawerTools.qml
        UI/Notification/NotificationPage.qml
        UI/Notification/NotificationModel.qml
        UI/Notification/NotificationDelegate.qml
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
        UI/SearchBarcode/SearchBarcodeDelegate.qml

        # Statistics
        UI/Satatistics/Statistics.qml
        UI/Satatistics/Summary.qml
        UI/Satatistics/Reports.qml
        UI/Satatistics/Daily.qml
        UI/Satatistics/Monthly.qml
        UI/Satatistics/Yearly.qml

        # Updates
        UI/Updates/ChechUpdatePage.qml

        # Receipts
        UI/Receipt/Receipt.qml
        UI/Receipt/ReceiptText.qml

    SOURCES
        # Android System



        # Barcode Engine



        # System
        core/sources/androidsystem.h
        core/sources/androidsystem.cpp
        core/sources/barcodeengine.h
        core/sources/barcodeengine.cpp
        core/sources/product.h
        core/sources/product.cpp
        core/sources/databasemanager.h
        core/sources/databasemanager.cpp
        core/sources/productfilterproxymodel.h
        core/sources/productfilterproxymodel.cpp
        core/sources/incomemodel.h
        core/sources/incomemodel.cpp
        core/sources/expensesmodel.h
        core/sources/expensesmodel.cpp
        core/sources/expense.h
        core/sources/expense.cpp
        core/sources/income.h
        core/sources/income.cpp
        core/sources/service.h
        core/sources/service.cpp
        core/sources/servicemodel.h
        core/sources/servicemodel.cpp
        core/sources/reportmanager.h
        core/sources/reportmanager.cpp

    RESOURCES
        # Android Configuration
        android/AndroidManifest.xml
        android/build.gradle
        android/res/values/libs.xml
        android/res/xml/qtprovider_paths.xml
        android/gradle/wrapper/gradle-wrapper.jar
        android/gradle/wrapper/gradle-wrapper.properties
        android/gradle.properties
        android/gradlew
        android/gradlew.bat
        RESOURCES android/src/com/salesmate/ScheduledWorker.java
        RESOURCES android/src/com/salesmate/WorkManagerHelper.java
        RESOURCES android/src/com/salesmate/NativeBridge.java
        RESOURCES android/src/com/salesmate/AlarmHelper.java
        RESOURCES android/src/com/salesmate/BatteryOptimizationHelper.java
        RESOURCES android/src/com/salesmate/AlarmReceiver.java
        RESOURCES android/src/com/salesmate/AlarmService.java
        QML_FILES UI/Utils/CircularProgressBar.qml
        QML_FILES UI/Utils/SearchBar.qml
        QML_FILES UI/Satatistics/ItemReportViewDelegate.qml
        QML_FILES UI/Satatistics/ItemReportViewModel.qml
        QML_FILES UI/Profile/CameraPage.qml
        QML_FILES UI/Profile/ProfilePage.qml



        # Android Source Code

)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
# Android-specific fixes
set_target_properties(appSalesMate PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSalesMate
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSalesMate
    PRIVATE Qt6::Quick Qt6::Core Qt6::CorePrivate ZXing::ZXing
    Qt6::Multimedia  Qt6::Sql Qt6::Charts Qt6::Concurrent
)
set_property(TARGET appSalesMate APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)


include(GNUInstallDirs)
install(TARGETS appSalesMate
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
