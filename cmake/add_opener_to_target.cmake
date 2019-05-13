# Copyright (c) 2019 Canopy Growth Corporation. All rights reserved.
# This software ("Software") is owned by Canopy Growth Corporation.
#
include_guard()

set(_add_opener_to_target_dir ${CMAKE_CURRENT_LIST_DIR})

function(add_opener_to_target)

    set(options
        64_BIT_DATA_TYPES_ENABLED
        PRODUCED_DATA_HAS_RUN_IDLE_HEADER
        CONSUMED_DATA_HAS_RUN_IDLE_HEADER
        WITH_TRACES
        TRACE_LEVEL_ERROR
        TRACE_LEVEL_WARNING
        TRACE_LEVEL_STATE
        TRACE_LEVEL_INFO
    )

    set(paramList
        TARGET
        DEVICE_VENDOR_ID
        DEVICE_TYPE
        DEVICE_PRODUCT_CODE
        DEVICE_MAJOR_REVISION
        DEVICE_MINOR_REVISION
        DEVICE_NAME
        CIP_NUM_APPLICATION_SPECIFIC_CONNECTABLE_OBJECTS
        CIP_NUM_EXPLICIT_CONNS
        CIP_NUM_EXLUSIVE_OWNER_CONNS
        CIP_NUM_INPUT_ONLY_CONNS
        CIP_NUM_INPUT_ONLY_CONNS_PER_CON_PATH
        CIP_NUM_LISTEN_ONLY_CONNS
        CIP_NUM_LISTEN_ONLY_CONNS_PER_CON_PATH
        MESSAGE_DATA_REPLY_BUFFER
        NUMBER_OF_SUPPORTED_SESSIONS
        TIMER_TICK_IN_MILLISECONDS
        ETHERNET_BUFFER_SIZE
    )

    cmake_parse_arguments(OPENER "${options}" "${paramList}" "" ${ARGN})

    if(NOT DEFINED OPENER_CONSUMED_DATA_HAS_RUNID_HEADER)
        set(OPENER_CONSUMED_DATA_HAS_RUNID_HEADER 0)
    endif()

    if (OPENER_PRODUCED_DATA_HAS_RUNID_HEADER)
        set(OPENER_PRODUCED_DATA_HAS_RUNID_HEADER 0)
    endif()

    if(NOT DEFINED OPENER_TARGET)
        message(FATAL_ERROR "No 'TARGET' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_DEVICE_VENDOR_ID)
        message(FATAL_ERROR "No 'DEVICE_VENDOR_ID' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_DEVICE_TYPE)
        message(FATAL_ERROR "No 'DEVICE_TYPE' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_DEVICE_PRODUCT_CODE)
        message(FATAL_ERROR "No 'DEVICE_PRODUCT_CODE' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_DEVICE_MAJOR_REVISION)
        message(FATAL_ERROR "No 'DEVICE_MAJOR_REVISION' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_DEVICE_MINOR_REVISION)
        message(FATAL_ERROR "No 'DEVICE_MINOR_REVISION' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_DEVICE_NAME)
        message(FATAL_ERROR "No 'DEVICE_NAME' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_CIP_NUM_APPLICATION_SPECIFIC_CONNECTABLE_OBJECTS)
        message(FATAL_ERROR "No 'CIP_NUM_APPLICATION_SPECIFIC_CONNECTABLE_OBJECTS' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_CIP_NUM_EXPLICIT_CONNS)
        message(FATAL_ERROR "No 'CIP_NUM_EXPLICIT_CONNS' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_CIP_NUM_EXLUSIVE_OWNER_CONNS)
        message(FATAL_ERROR "No 'CIP_NUM_EXLUSIVE_OWNER_CONNS' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_CIP_NUM_INPUT_ONLY_CONNS)
        message(FATAL_ERROR "No 'CIP_NUM_INPUT_ONLY_CONNS' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_CIP_NUM_INPUT_ONLY_CONNS_PER_CON_PATH)
        message(FATAL_ERROR "No 'CIP_NUM_INPUT_ONLY_CONNS_PER_CON_PATH' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_CIP_NUM_LISTEN_ONLY_CONNS)
        message(FATAL_ERROR "No 'CIP_NUM_LISTEN_ONLY_CONNS' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_CIP_NUM_LISTEN_ONLY_CONNS_PER_CON_PATH)
        message(FATAL_ERROR "No 'CIP_NUM_LISTEN_ONLY_CONNS_PER_CON_PATH' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_MESSAGE_DATA_REPLY_BUFFER)
        message(FATAL_ERROR "No 'MESSAGE_DATA_REPLY_BUFFER' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_NUMBER_OF_SUPPORTED_SESSIONS)
        message(FATAL_ERROR "No 'NUMBER_OF_SUPPORTED_SESSIONS' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_TIMER_TICK_IN_MILLISECONDS)
        message(FATAL_ERROR "No 'TIMER_TICK_IN_MILLISECONDS' was given to 'add_opener_to_target'")
    endif()
    if(NOT DEFINED OPENER_ETHERNET_BUFFER_SIZE)
        message(FATAL_ERROR "No 'ETHERNET_BUFFER_SIZE' was given to 'add_opener_to_target'")
    endif()

    if(NOT TARGET ${OPENER_TARGET})
        message(FATAL_ERROR "No target '${OPENER_TARGET}' currently exists. Make sure add_library/add_executable has been run before adding OpENer to it.")
    endif()

    if(MSVC)
        set(OPENER_PLATFORM "WIN32")
    elseif(MINGW)
        set(OPENER_PLATFORM "MINGW")
    else()
        set(OPENER_PLATFORM "POSIX")
    endif()

    configure_file(
        ${_add_opener_to_target_dir}/opener_user_conf.h.in
        ${CMAKE_CURRENT_BINARY_DIR}/generated/include/opener_user_conf.h
        @ONLY
    )

    target_compile_definitions(${OPENER_TARGET} PUBLIC
        $<$<BOOL:${OPENER_64_BIT_DATA_TYPES_ENABLED}>:OPENER_SUPPORT_64BIT_DATATYPES=1>
        $<$<BOOL:${OPENER_PRODUCED_DATA_HAS_RUN_IDLE_HEADER}>:OPENER_PRODUCED_DATA_HAS_RUN_IDLE_HEADER=1>
        $<$<BOOL:${OPENER_CONSUMED_DATA_HAS_RUN_IDLE_HEADER}>:OPENER_CONSUMED_DATA_HAS_RUN_IDLE_HEADER=1>
    )

    if(MSVC OR MINGW)
        target_compile_definitions(${OPENER_TARGET} PUBLIC RESTRICT=__restrict WIN32)
    else()
        target_compile_definitions(${OPENER_TARGET} PUBLIC
            $<$<COMPILE_LANGUAGE:CXX>:RESTRICT=>
            $<$<COMPILE_LANGUAGE:C>:RESTRICT=restrict>
            _POSIX_C_SOURCE=200112L __USE_GNU __USE_XOPEN2K OPENER_POSIX
        )
    endif()

    if(OPENER_WITH_TRACES)
        set(TRACE_LEVEL 0)
        if(OPENER_TRACE_LEVEL_ERROR)
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
        target_compile_definitions(${OPENER_TARGET} PUBLIC
            OPENER_WITH_TRACES
            OPENER_TRACE_LEVEL=${TRACE_LEVEL}
        )
    endif()

    target_include_directories(${OPENER_TARGET} PUBLIC
        ${CMAKE_CURRENT_BINARY_DIR}/generated/include
        ${_add_opener_to_target_dir}/../source/src
        ${_add_opener_to_target_dir}/../source/src/cip
        ${_add_opener_to_target_dir}/../source/src/enet_encap
        ${_add_opener_to_target_dir}/../source/src/ports
        ${_add_opener_to_target_dir}/../source/src/ports/${OPENER_PLATFORM}
        ${_add_opener_to_target_dir}/../source/src/utils
        $<$<BOOL:$<C_COMPILER_ID:MSVC>>:${_add_opener_to_target_dir}/../source/contrib/msinttypes>
    )

    target_sources(${OPENER_TARGET} PUBLIC
        ${_add_opener_to_target_dir}/../source/src/cip/appcontype.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipassembly.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipclass3connection.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipcommon.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipconnectionmanager.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipconnectionobject.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipelectronickey.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipepath.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipethernetlink.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipidentity.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipioconnection.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipmessagerouter.c
        ${_add_opener_to_target_dir}/../source/src/cip/cipqos.c
        ${_add_opener_to_target_dir}/../source/src/cip/ciptcpipinterface.c
        ${_add_opener_to_target_dir}/../source/src/enet_encap/cpf.c
        ${_add_opener_to_target_dir}/../source/src/enet_encap/encap.c
        ${_add_opener_to_target_dir}/../source/src/enet_encap/endianconv.c
        ${_add_opener_to_target_dir}/../source/src/ports/${OPENER_PLATFORM}/networkconfig.c
        ${_add_opener_to_target_dir}/../source/src/ports/${OPENER_PLATFORM}/networkhandler.c
        ${_add_opener_to_target_dir}/../source/src/ports/${OPENER_PLATFORM}/opener_error.c
        ${_add_opener_to_target_dir}/../source/src/ports/generic_networkhandler.c
        ${_add_opener_to_target_dir}/../source/src/ports/socket_timer.c
        ${_add_opener_to_target_dir}/../source/src/ports/udp_protocol.c
        ${_add_opener_to_target_dir}/../source/src/utils/doublylinkedlist.c
        ${_add_opener_to_target_dir}/../source/src/utils/enipmessage.c
        ${_add_opener_to_target_dir}/../source/src/utils/random.c
        ${_add_opener_to_target_dir}/../source/src/utils/xorshiftrandom.c
        )

endfunction()
