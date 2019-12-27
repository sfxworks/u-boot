setenv blink_power 'led power off; sleep 0.1; led power on'
setenv blink_standby 'led standby off; sleep 0.1; led standby on'

run blink_power
sf probe

if size ${devtype} ${devnum}:${distro_bootpart} spi_combined.img; then
  load ${devtype} ${devnum}:${distro_bootpart} ${kernel_addr_r} spi_combined.img

  run blink_power blink_power
  # TODO calculate erase size
  sf erase 0 400000

  # write flash
  run blink_power blink_power blink_power
  sf write ${kernel_addr_r} 0 ${filesize}

  # blink forever
  while true; do run blink_power; sleep 1; done
else
  # blink forever
  echo "missing spi_combined.img"
  while true; do run blink_standby; sleep 1; done
fi
