cmake_minimum_required(VERSION 3.12)
project(OpENer LANGUAGES C VERSION 2.3)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

if(MSVC)
    set(OpENer_PLATFORM "WIN32")
elseif(MINGW)
    set(OpENer_PLATFORM "MINGW")
else()
    set(OpENer_PLATFORM "POSIX")
endif()

set(OpENer_Device_Config_Vendor_Id    1)
set(OpENer_Device_Config_Device_Type  12)
set(OpENer_Device_Config_Product_Code 65001)
set(OpENer_Device_Config_Device_Name  "OpENer PC")
set(OPENER_CONFIG_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/OpENer/cmake/)


option(OPENER_PRODUCED_DATA_HAS_RUN_IDLE_HEADER "Shall produced data from OpENer also include a run idle header?" FALSE)
option(OPENER_CONSUMED_DATA_HAS_RUN_IDLE_HEADER "Will consumed data from OpENer also include a run idle header?" TRUE)
option(OPENER_64_BIT_DATA_TYPES_ENABLED "Enable 64-bit data type support" OFF)
option(OPENER_TRACES "Activate OpENer traces" OFF)

if(OPENER_TRACES)
    option(OPENER_TRACE_LEVEL_ERROR   "Error trace level"   ON)
    option(OpENer_TRACE_LEVEL_WARNING "Warning trace level" ON)
    option(OpENer_TRACE_LEVEL_STATE   "State trace level"   ON)
    option(OpENer_TRACE_LEVEL_INFO    "Info trace level"    ON)
endif()

configure_file(
    source/src/ports/devicedata.h.in
    ${PROJECT_BINARY_DIR}/source/src/ports/devicedata.h
)

set(OpENer_SOURCES
    source/src/cip/appcontype.c
    source/src/cip/cipassembly.c
    source/src/cip/cipclass3connection.c
    source/src/cip/cipcommon.c
    source/src/cip/cipconnectionmanager.c
    source/src/cip/cipconnectionobject.c
    source/src/cip/cipelectronickey.c
    source/src/cip/cipepath.c
    source/src/cip/cipethernetlink.c
    source/src/cip/cipidentity.c
    source/src/cip/cipioconnection.c
    source/src/cip/cipmessagerouter.c
    source/src/cip/cipqos.c
    source/src/cip/ciptcpipinterface.c
    source/src/enet_encap/cpf.c
    source/src/enet_encap/encap.c
    source/src/enet_encap/endianconv.c
    source/src/ports/generic_networkhandler.c
    source/src/ports/socket_timer.c
    source/src/ports/udp_protocol.c
    source/src/ports/${OpENer_PLATFORM}/networkconfig.c
    source/src/ports/${OpENer_PLATFORM}/networkhandler.c
    source/src/ports/${OpENer_PLATFORM}/opener_error.c
    source/src/utils/doublylinkedlist.c
    source/src/utils/enipmessage.c
    source/src/utils/random.c
    source/src/utils/xorshiftrandom.c
)

set(OpENer_HEADERS
    source/src/opener_api.h
    source/src/trace.h
    source/src/typedefs.h
    source/src/cip/appcontype.h
    source/src/cip/cipassembly.h
    source/src/cip/cipclass3connection.h
    source/src/cip/cipcommon.h
    source/src/cip/cipconnectionmanager.h
    source/src/cip/cipconnectionobject.h
    source/src/cip/cipelectronickey.h
    source/src/cip/cipepath.h
    source/src/cip/ciperror.h
    source/src/cip/cipethernetlink.h
    source/src/cip/cipidentity.h
    source/src/cip/cipioconnection.h
    source/src/cip/cipmessagerouter.h
    source/src/cip/cipqos.h
    source/src/cip/ciptcpipinterface.h
    source/src/cip/ciptypes.h
    source/src/enet_encap/cpf.h
    source/src/enet_encap/encap.h
    source/src/enet_encap/endianconv.h
    source/src/ports/generic_networkhandler.h
    source/src/ports/opener_error.h
    source/src/ports/${OpENer_PLATFORM}/networkconfig.h
    source/src/ports/${OpENer_PLATFORM}/networkhandler.h
    source/src/ports/${OpENer_PLATFORM}/sample_application/opener_user_conf.h
    source/src/ports/socket_timer.h
    source/src/ports/udp_protocol.h
    source/src/utils/doublylinkedlist.h
    source/src/utils/enipmessage.h
    source/src/utils/random.h
    source/src/utils/xorshiftrandom.h
    ${PROJECT_BINARY_DIR}/source/src/ports/devicedata.h
)

add_library(OpENer ${OpENer_SOURCES} ${OpENer_HEADERS})

target_include_directories(OpENer PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/src/>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/src/cip>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/src/enet_encap>
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/source/src/ports>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/src/ports>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/src/ports/${OpENer_PLATFORM}>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/src/ports/${OpENer_PLATFORM}/sample_application>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/src/utils>
    $<$<C_COMPILER_ID:MSVC>:$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/contrib/msinttypes>>
    $<INSTALL_INTERFACE:include>
)


target_compile_definitions(OpENer PUBLIC
    $<$<BOOL:${OPENER_64_BIT_DATA_TYPES_ENABLED}>:OPENER_SUPPORT_64BIT_DATATYPES=1>
    $<$<BOOL:${OPENER_PRODUCED_DATA_HAS_RUN_IDLE_HEADER}>:OPENER_PRODUCED_DATA_HAS_RUN_IDLE_HEADER=1>
    $<$<BOOL:${OPENER_CONSUMED_DATA_HAS_RUN_IDLE_HEADER}>:OPENER_CONSUMED_DATA_HAS_RUN_IDLE_HEADER=1>
)

if(MSVC OR MINGW)
    target_compile_definitions(OpENer PUBLIC RESTRICT=__restrict WIN32)
else()
    target_compile_definitions(OpENer PUBLIC
        $<$<COMPILE_LANGUAGE:CXX>:RESTRICT=>
        $<$<COMPILE_LANGUAGE:C>:RESTRICT=restrict>
        _POSIX_C_SOURCE=200112L __USE_GNU __USE_XOPEN2K OPENER_POSIX
    )
endif()

if(OPENER_TRACES)
    set(TRACE_LEVEL 0)

    if(OpENer_TRACE_LEVEL_ERROR)
        math(EXPR TRACE_LEVEL "${TRACE_LEVEL} + 1")
    endif()

    if(OPENER_TRACE_LEVEL_WARNING)
        math(EXPR TRACE_LEVEL "${TRACE_LEVEL} + 2")
    endif()

    if(OPENER_TRACE_LEVEL_STATE)
        math(EXPR TRACE_LEVEL "${TRACE_LEVEL} + 4")
    endif()

    if(OPENER_TRACE_LEVEL_INFO)
        math(EXPR TRACE_LEVEL "${TRACE_LEVEL} + 8")
    endif()

    target_compile_definitions(OpENer PUBLIC
        OPENER_WITH_TRACES
        OPENER_TRACE_LEVEL=${TRACE_LEVEL}
    )
endif()


install(
    TARGETS OpENer
    EXPORT OpENerTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(
    FILES ${OpENer_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/OpENer
)

install(
    EXPORT OpENerTargets
    NAMESPACE OpENer::
    DESTINATION ${OPENER_CONFIG_INSTALL_DIR}
)

write_basic_package_version_file(
    ${PROJECT_BINARY_DIR}/OpENerConfigVersion.cmake
    VERSION ${PACKAGE_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    ${PROJECT_SOURCE_DIR}/OpENerConfig.cmake.in
    ${PROJECT_BINARY_DIR}/OpENerConfig.cmake
    INSTALL_DESTINATION ${OPENER_CONFIG_INSTALL_DIR}
)

install(
    FILES ${PROJECT_BINARY_DIR}/OpENerConfigVersion.cmake
    ${PROJECT_BINARY_DIR}/OpENerConfig.cmake
    DESTINATION ${OPENER_CONFIG_INSTALL_DIR}
)
