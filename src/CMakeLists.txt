
add_executable(presenter main.cpp resources.qrc)

target_sources(presenter
 PRIVATE
 main.cpp resources.qrc
 songsqlmodel.cpp songsqlmodel.h
 serviceitemmodel.cpp serviceitemmodel.h
 serviceitem.cpp serviceitem.h
 slide.cpp slide.h
 videosqlmodel.cpp videosqlmodel.h
 imagesqlmodel.cpp imagesqlmodel.h
 filemanager.cpp filemanager.h
 presentationsqlmodel.cpp presentationsqlmodel.h
 mpv/mpvobject.h mpv/mpvobject.cpp
 mpv/qthelper.hpp mpv/mpvhelpers.h
)

target_compile_options (presenter PUBLIC -fexceptions)
