add_executable(presenter)

target_sources(presenter
 PRIVATE
 main.cpp resources.qrc
 songlistmodel.cpp songlistmodel.h
)

target_link_libraries(presenter
        Qt5::Quick
        Qt5::Qml
        Qt5::Gui
        Qt5::QuickControls2
        Qt5::Widgets
        KF5::Kirigami2
        KF5::I18n
)

target_compile_options (presenter PUBLIC -fexceptions)
