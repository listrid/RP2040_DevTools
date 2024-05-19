import os
import re
import shutil

inc_dir = os.path.abspath(os.curdir + '/../include')
lib_dir = os.path.abspath(os.curdir + '/../lib')
sdk_dir = os.path.abspath(os.environ['PICO_SDK_PATH']);

def scandir_include(dirname):
    subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
    for dirname in list(subfolders):
        if re.search('cyw43', dirname) :
            continue
        dirname +='/include'
        if os.path.isdir(dirname):
#            print('copy '+dirname);
            shutil.copytree(dirname, inc_dir, dirs_exist_ok=True)
    return subfolders

print('sdk_dir='+sdk_dir)
print('inc_dir='+inc_dir)
os.makedirs(inc_dir, exist_ok=True)
os.makedirs(lib_dir, exist_ok=True)

scandir_include(sdk_dir+'/src/rp2040')
shutil.copytree(sdk_dir+'/src/boards/include', inc_dir, dirs_exist_ok=True)
scandir_include(sdk_dir+'/src/common')
scandir_include(sdk_dir+'/src/rp2_common')

shutil.copyfile('./libpico.a', lib_dir+'/libpico.a')
#shutil.copyfile('./build_flash/libpico.a', lib_dir+'/libpico_flash.a')
#shutil.copyfile('./build_ram/libpico.a', lib_dir+'/libpico_ram.a')
shutil.copyfile('./generated/pico_base/pico/version.h', inc_dir + '/pico/version.h')

file = open(inc_dir+'/pico/config_autogen.h', 'w+')
file.write('// based on PICO_CONFIG_HEADER_FILES:\n')
file.write('#include "boards/pico.h"\n')
file.write('// based on PICO_RP2040_CONFIG_HEADER_FILES:\n')
file.write('#include "cmsis/rename_exceptions.h"\n')
if os.environ['STDOUT_UART'] == '1':
    file.write('#define LIB_PICO_STDIO_UART 1\n')
if os.environ['STDOUT_USB'] == '1':
    file.write('#define LIB_PICO_STDIO_USB 1\n')
if os.environ['STDOUT_SEMIHOSTING'] == '1':
    file.write('#define LIB_PICO_STDIO_SEMIHOSTING 1\n')


file.write('#define LIB_PICO_MULTICORE   1\n')
file.write('#define LIB_PICO_PRINTF_PICO 1\n')
file.write('#define PICO_ON_DEVICE       1\n')
file.close()


#shutil.copyfile(sdk_dir+'/src/rp2_common/pico_standard_link/memmap_blocked_ram.ld', lib_dir+'/memmap_blocked_ram.ld');
#shutil.copyfile(sdk_dir+'/src/rp2_common/pico_standard_link/memmap_copy_to_ram.ld', lib_dir+'/copy_to_ram.ld');
shutil.copyfile(sdk_dir+'/src/rp2_common/pico_standard_link/memmap_default.ld', lib_dir+'/flash.ld');
shutil.copyfile('./pico-sdk/src/rp2_common/boot_stage2/bs2_default_padded_checksummed.S', lib_dir+'/bs2_flash.S');

shutil.copyfile(sdk_dir+'/src/rp2040/hardware_regs/rp2040.svd', lib_dir+'/../rp2040.svd');

