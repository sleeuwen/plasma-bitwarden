add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_com.github.sleeuwen.plasmabitwarden\")

set (plasmabitwardenplugin_SRCS
     plasmabitwardenplugin.cpp
     bitwardenvault.cpp
     passwordsmodel.cpp
)

add_library(plasmabitwardenplugin SHARED ${plasmabitwardenplugin_SRCS})

target_link_libraries(plasmabitwardenplugin
    KF5::I18n
    KF5::Wallet
    Qt5::Gui
    Qt5::Qml
)
install(TARGETS plasmabitwardenplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/github/sleeuwen/private/plasmabitwarden)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/github/sleeuwen/private/plasmabitwarden)
