deps_config := \
	/home/noah-pena/Libraries/esp/esp-idf/components/aws_iot/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/bt/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/esp32/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/ethernet/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/fatfs/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/freertos/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/log/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/lwip/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/mbedtls/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/openssl/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/spi_flash/Kconfig \
	/home/noah-pena/Projects/BLE-Music-Bike/main/Kconfig \
	/home/noah-pena/Libraries/esp/esp-idf/components/bootloader/Kconfig.projbuild \
	/home/noah-pena/Libraries/esp/esp-idf/components/esptool_py/Kconfig.projbuild \
	/home/noah-pena/Libraries/esp/esp-idf/components/partition_table/Kconfig.projbuild \
	/home/noah-pena/Libraries/esp/esp-idf/Kconfig

include/config/auto.conf: \
	$(deps_config)


$(deps_config): ;
