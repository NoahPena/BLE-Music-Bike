# Automatically generated build file. Do not edit.
COMPONENT_INCLUDES += $(IDF_PATH)/components/bt/bluedroid/bta/include $(IDF_PATH)/components/bt/bluedroid/bta/sys/include $(IDF_PATH)/components/bt/bluedroid/btcore/include $(IDF_PATH)/components/bt/bluedroid/device/include $(IDF_PATH)/components/bt/bluedroid/gki/include $(IDF_PATH)/components/bt/bluedroid/hci/include $(IDF_PATH)/components/bt/bluedroid/osi/include $(IDF_PATH)/components/bt/bluedroid/btc/core/include $(IDF_PATH)/components/bt/bluedroid/btc/profile/esp/blufi/include $(IDF_PATH)/components/bt/bluedroid/btc/profile/esp/include $(IDF_PATH)/components/bt/bluedroid/btc/profile/std/gatt/include $(IDF_PATH)/components/bt/bluedroid/btc/profile/std/gap/include $(IDF_PATH)/components/bt/bluedroid/btc/profile/std/sdp/include $(IDF_PATH)/components/bt/bluedroid/btc/profile/std/include $(IDF_PATH)/components/bt/bluedroid/btc/include $(IDF_PATH)/components/bt/bluedroid/stack/btm/include $(IDF_PATH)/components/bt/bluedroid/stack/btu/include $(IDF_PATH)/components/bt/bluedroid/stack/gap/include $(IDF_PATH)/components/bt/bluedroid/stack/gatt/include $(IDF_PATH)/components/bt/bluedroid/stack/hcic/include $(IDF_PATH)/components/bt/bluedroid/stack/l2cap/include $(IDF_PATH)/components/bt/bluedroid/stack/sdp/include $(IDF_PATH)/components/bt/bluedroid/stack/smp/include $(IDF_PATH)/components/bt/bluedroid/stack/include $(IDF_PATH)/components/bt/bluedroid/api/include $(IDF_PATH)/components/bt/bluedroid/include $(IDF_PATH)/components/bt/include
COMPONENT_LDFLAGS += -lbt -L $(IDF_PATH)/components/bt/lib -lbtdm_app
COMPONENT_LINKER_DEPS += $(IDF_PATH)/components/bt/lib/libbtdm_app.a
COMPONENT_SUBMODULES += $(IDF_PATH)/components/bt/lib
bt-build: 
