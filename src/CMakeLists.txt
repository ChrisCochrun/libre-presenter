
add_executable(presenter main.cpp resources.qrc)

target_sources(presenter
 PRIVATE
 main.cpp resources.qrc
 cpp/songsqlmodel.cpp cpp/songsqlmodel.h
 cpp/serviceitemmodel.cpp cpp/serviceitemmodel.h
 cpp/serviceitem.cpp cpp/serviceitem.h
 cpp/slide.cpp cpp/slide.h
 cpp/videosqlmodel.cpp cpp/videosqlmodel.h
 cpp/imagesqlmodel.cpp cpp/imagesqlmodel.h
 cpp/filemanager.cpp cpp/filemanager.h
 cpp/presentationsqlmodel.cpp cpp/presentationsqlmodel.h
 cpp/mpv/mpvobject.h cpp/mpv/mpvobject.cpp
 cpp/mpv/qthelper.hpp cpp/mpv/mpvhelpers.h
)

target_compile_options (presenter PUBLIC -fexceptions)
