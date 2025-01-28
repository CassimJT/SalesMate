cmake_minimum_required(VERSION 3.16)

project(SalesMate VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
add_subdirectory(./zxing-cpp/)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia Sql)

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
        RESOURCES
            android/AndroidManifest.xml
            android/build.gradle android/res/values/libs.xml
            android/res/xml/qtprovider_paths.xml
            android/gradle/wrapper/gradle-wrapper.jar
            android/gradle/wrapper/gradle-wrapper.properties
            android/gradle.properties
            android/gradlew
            android/gradlew.bat
            SOURCES
                androidsystem.h
                androidsystem.cpp
                RESOURCES android/src/com/native/Native.java
                QML_FILES UI/Drawer/Profile.qml
                QML_FILES UI/Drawer/ImageProcessor.js
                QML_FILES UI/Drawer/DrawerMenu.qml
                QML_FILES UI/Drawer/DrawerModel.qml
                QML_FILES UI/Drawer/DrawerDelegate.qml
                QML_FILES UI/Home/HomePage.qml
                QML_FILES UI/Welcome/WelcomePage.qml
                QML_FILES UI/Auth/SignInPage.qml
                QML_FILES UI/Auth/SignUpPage.qml
                QML_FILES UI/About/AboutAppPage.qml
                QML_FILES UI/About/AboutUsPage.qml
                QML_FILES UI/Stock/AddItemPage.qml
                QML_FILES UI/Stock/ShowStock.qml
                QML_FILES UI/Updates/ChechUpdatePage.qml
                QML_FILES UI/Stock/AddExpensePage.qml
                QML_FILES UI/Stock/OtherIncomePage.qml
                QML_FILES UI/Stock/ShowSalesPage.qml
                QML_FILES UI/Profile/ProfileEditPage.qml
                QML_FILES UI/Utils/BarcodeScanner.qml
                QML_FILES UI/Utils/ScannerTools.qml
                QML_FILES UI/Utils/CustomButton.qml
                QML_FILES UI/Stock/AddStock.qml
                QML_FILES UI/Stock/SearchBar.qml
                QML_FILES UI/Stock/StockModel.qml
                QML_FILES UI/Stock/StockDelegate.qml
                QML_FILES UI/Notification/NotificationPage.qml
                QML_FILES UI/Notification/NotificationModel.qml
                QML_FILES UI/Notification/NotificationDelegate.qml
                QML_FILES UI/Utils/Avatar.qml
                QML_FILES UI/Profile/AvataDrawerTools.qml
                QML_FILES UI/Utils/Utils.js
                SOURCES barcodeengine.h barcodeengine.cpp
                SOURCES System/product.h System/product.cpp
                SOURCES System/databasemanager.h System/databasemanager.cpp
                QML_FILES UI/Utils/InfoPopup.qml
                QML_FILES UI/Home/MainSatckView.qml
                QML_FILES UI/Utils/ProductEditPopup.qml
                SOURCES
                SOURCES System/productfilterproxymodel.h System/productfilterproxymodel.cpp
                QML_FILES UI/Home/Home.qml
                QML_FILES UI/Home/CurrentSales.qml
                QML_FILES UI/Stock/CurrentSalesDelegate.qml
                QML_FILES UI/Utils/Wanning.qml



)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSalesMate PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSalesMate
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSalesMate
    PRIVATE Qt6::Quick Qt6::Core Qt6::CorePrivate Qt6::Multimedia ZXing::ZXing Qt6::Sql
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
