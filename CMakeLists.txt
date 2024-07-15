cmake_minimum_required(VERSION 3.16)

project(DYQML6 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

find_package(Qt6 REQUIRED COMPONENTS Widgets)

qt_standard_project_setup()

qt_add_executable(appDYQML6
    main.cpp
)

qt_add_qml_module(appDYQML6
    URI DYQML6
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES qml/js/parseParameters.js
    QML_FILES qml/js/procEmitSignal.js
    QML_FILES qml/js/readHash.js
    QML_FILES qml/controls/DControllerBase.qml
    QML_FILES qml/controls/DObject.qml
    QML_FILES qml/controls/DShowerBase.qml
    QML_FILES qml/controls/DYArea.qml
    QML_FILES qml/controls/DYBlinkDot.qml
    QML_FILES qml/controls/DYBusyIndicator.qml
    QML_FILES qml/controls/DYButton.qml
    QML_FILES qml/controls/DYColorSpace.qml
    QML_FILES qml/controls/DYComboBox.qml
    QML_FILES qml/controls/DYConfirmBtn.qml
    QML_FILES qml/controls/DYDataShower.qml
    QML_FILES qml/controls/DYForm.qml
    QML_FILES qml/controls/DYIconBtn.qml
    QML_FILES qml/controls/DYLoader.qml
    QML_FILES qml/controls/DYPlaceholder.qml
    QML_FILES qml/controls/DYShortcut.qml
    QML_FILES qml/controls/DYSwitch.qml
    QML_FILES qml/controls/DYText.qml
    QML_FILES qml/controls/DYTextInput.qml
    QML_FILES qml/controls/DYToolTip.qml
    SOURCES C++/dybackend.cpp C++/dybackend.h
    SOURCES C++/guifileloader.cpp C++/guifileloader.h
    SOURCES C++/qmlinterface.cpp C++/qmlinterface.h
    SOURCES C++/fakeFunction/genfakehashdata.cpp C++/fakeFunction/genfakehashdata.h
    SOURCES C++/fakeFunction/testtriggergui.cpp C++/fakeFunction/testtriggergui.h
    QML_FILES qml/controls/DYCheckBox.qml
    QML_FILES qml/controls/DYRadioButton.qml
    QML_FILES qml/controls/DYSlider.qml
    QML_FILES qml/controls/DYSwipePage.qml
    QML_FILES qml/controls/DYSigPopUp.qml
    QML_FILES qml/js/procColorSpace.js
    QML_FILES qml/controls/DYBarChart.qml
#    QML_FILES qml/controls/subControls/InnerItem.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appDYQML6 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appDYQML6
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDYQML6
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS appDYQML6
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
