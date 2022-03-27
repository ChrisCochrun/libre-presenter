add_executable(presenter)

target_sources(presenter
 PRIVATE
 main.cpp resources.qrc
 songsqlmodel.cpp songsqlmodel.h
 serviceitem.cpp serviceitem.h
 videosqlmodel.cpp videosqlmodel.h
 mpv/mpvobject.h mpv/mpvobject.cpp
 mpv/qthelper.hpp mpv/mpvhelpers.h
)

target_link_libraries(presenter
        Qt5::Quick
        Qt5::Qml
        Qt5::Gui
        Qt5::QuickControls2
        Qt5::Widgets
        Qt5::Sql
        Qt5::X11Extras
        KF5::Kirigami2
        KF5::I18n
        mpv
)

target_compile_options (presenter PUBLIC -fexceptions)
