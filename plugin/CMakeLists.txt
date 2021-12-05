
set(plasmabitwarden_SRCS
    plasmabitwardenplugin.cpp
    )

add_library(plasmabitwarden STATIC ${plasmabitwarden_SRCS})

target_link_libraries(plasmabitwarden
    Qt5::Quick
    KF5::Plasma
)


