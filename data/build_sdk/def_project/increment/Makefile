utf8_sig_fix := not delete

program_name := blink
source_dir   := src
build_dir    := build

CC  := $(RP2040_SDK)bin/arm-none-eabi-gcc.exe
CXX := $(RP2040_SDK)bin/arm-none-eabi-g++.exe

LINK_WRAP  := -Wl,--wrap=sprintf,--wrap=snprintf,--wrap=vsnprintf,--wrap=__clzsi2,--wrap=__clzdi2,--wrap=__ctzsi2,--wrap=__ctzdi2,--wrap=__popcountsi2,--wrap=__popcountdi2,--wrap=__clz,--wrap=__clzl,--wrap=__clzll,--wrap=__aeabi_idiv,--wrap=__aeabi_idivmod,--wrap=__aeabi_ldivmod,--wrap=__aeabi_uidiv,--wrap=__aeabi_uidivmod,--wrap=__aeabi_uldivmod,--wrap=__aeabi_dadd,--wrap=__aeabi_ddiv,--wrap=__aeabi_dmul,--wrap=__aeabi_drsub,--wrap=__aeabi_dsub,--wrap=__aeabi_cdcmpeq,--wrap=__aeabi_cdrcmple,--wrap=__aeabi_cdcmple,--wrap=__aeabi_dcmpeq,--wrap=__aeabi_dcmplt,--wrap=__aeabi_dcmple,--wrap=__aeabi_dcmpge,--wrap=__aeabi_dcmpgt,--wrap=__aeabi_dcmpun,--wrap=__aeabi_i2d,--wrap=__aeabi_l2d,--wrap=__aeabi_ui2d,--wrap=__aeabi_ul2d,--wrap=__aeabi_d2iz,--wrap=__aeabi_d2lz,--wrap=__aeabi_d2uiz,--wrap=__aeabi_d2ulz,--wrap=__aeabi_d2f,--wrap=sqrt,--wrap=cos,--wrap=sin,--wrap=tan,--wrap=atan2,--wrap=exp,--wrap=log,--wrap=ldexp,--wrap=copysign,--wrap=trunc,--wrap=floor,--wrap=ceil,--wrap=round,--wrap=sincos,--wrap=asin,--wrap=acos,--wrap=atan,--wrap=sinh,--wrap=cosh,--wrap=tanh,--wrap=asinh,--wrap=acosh,--wrap=atanh,--wrap=exp2,--wrap=log2,--wrap=exp10,--wrap=log10,--wrap=pow,--wrap=powint,--wrap=hypot,--wrap=cbrt,--wrap=fmod,--wrap=drem,--wrap=remainder,--wrap=remquo,--wrap=expm1,--wrap=log1p,--wrap=fma,--wrap=__aeabi_lmul,--wrap=__aeabi_fadd,--wrap=__aeabi_fdiv,--wrap=__aeabi_fmul,--wrap=__aeabi_frsub,--wrap=__aeabi_fsub,--wrap=__aeabi_cfcmpeq,--wrap=__aeabi_cfrcmple,--wrap=__aeabi_cfcmple,--wrap=__aeabi_fcmpeq,--wrap=__aeabi_fcmplt,--wrap=__aeabi_fcmple,--wrap=__aeabi_fcmpge,--wrap=__aeabi_fcmpgt,--wrap=__aeabi_fcmpun,--wrap=__aeabi_i2f,--wrap=__aeabi_l2f,--wrap=__aeabi_ui2f,--wrap=__aeabi_ul2f,--wrap=__aeabi_f2iz,--wrap=__aeabi_f2lz,--wrap=__aeabi_f2uiz,--wrap=__aeabi_f2ulz,--wrap=__aeabi_f2d,--wrap=sqrtf,--wrap=cosf,--wrap=sinf,--wrap=tanf,--wrap=atan2f,--wrap=expf,--wrap=logf,--wrap=ldexpf,--wrap=copysignf,--wrap=truncf,--wrap=floorf,--wrap=ceilf,--wrap=roundf,--wrap=sincosf,--wrap=asinf,--wrap=acosf,--wrap=atanf,--wrap=sinhf,--wrap=coshf,--wrap=tanhf,--wrap=asinhf,--wrap=acoshf,--wrap=atanhf,--wrap=exp2f,--wrap=log2f,--wrap=exp10f,--wrap=log10f,--wrap=powf,--wrap=powintf,--wrap=hypotf,--wrap=cbrtf,--wrap=fmodf,--wrap=dremf,--wrap=remainderf,--wrap=remquof,--wrap=expm1f,--wrap=log1pf,--wrap=fmaf,--wrap=malloc,--wrap=calloc,--wrap=realloc,--wrap=free,--wrap=memcpy,--wrap=memset,--wrap=__aeabi_memcpy,--wrap=__aeabi_memset,--wrap=__aeabi_memcpy4,--wrap=__aeabi_memset4,--wrap=__aeabi_memcpy8,--wrap=__aeabi_memset8,--wrap=printf,--wrap=vprintf,--wrap=puts,--wrap=putchar,--wrap=getchar
CC_FLAGS   := -mcpu=cortex-m0plus -mthumb -ffunction-sections -fdata-sections --specs=nosys.specs -I$(RP2040_SDK)include
LINK_FLAGS := -Wl,-L$(RP2040_SDK)lib,--script=flash.ld,-z,max-page-size=4096,--gc-sections,-lpico,$(RP2040_SDK)lib/reset_interface.c.obj
# -Wl,-Map=test_blink.elf.map


#функция рекурсивного поиска файлов в подкатологах (параметры: $1-каталог, $2-маска поиска)
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
init_build=yes

ifeq (debug,$(filter debug,$(MAKECMDGOALS)))
  CC_FLAGS := -g -DDEBUG $(CC_FLAGS)
  obj_dir  := $(addsuffix /debug,$(build_dir))
  out_name := $(program_name)_d
else
  CC_FLAGS := -O3 -DNDEBUG $(CC_FLAGS)
  obj_dir  := $(addsuffix /release,$(build_dir))
  out_name := $(program_name)
endif

ifeq (clean,$(filter clean,$(MAKECMDGOALS)))
  init_build=no
endif

ifeq (name,$(filter name,$(MAKECMDGOALS)))
  init_build=no
endif

ifeq (name_uf2,$(filter name_uf2,$(MAKECMDGOALS)))
  init_build=no
endif

ifeq (pio,$(filter pio,$(MAKECMDGOALS)))
  init_build=no
#.h/h - всегда ребилд (т.к. каталог с именем результат - ошибка)
  sources_pio := $(addsuffix .h/h,$(call rwildcard, $(source_dir),*.pio))
endif


ifeq ($(init_build),yes)
# !!(параметры без пробела  ./src/,*.cpp )
  sources_cpp = $(subst $(source_dir),,$(call rwildcard, $(source_dir),*.cpp))
  sources_c   = $(subst $(source_dir),,$(call rwildcard, $(source_dir),*.c))
  sources_S   = $(subst $(source_dir),,$(call rwildcard, $(source_dir),*.S))

  OBJ_DIRS = $(addprefix $(obj_dir),$(sort $(dir $(sources_cpp)$(sources_c)$(sources_S))))
  OBJECTS  = $(addprefix $(obj_dir),$(sources_cpp:.cpp=.cpp.o) $(sources_c:.c=.c.o) $(sources_S:.S=.S.o))
  DEPENDS  = $(OBJECTS:.o=.d)
endif

#определение windows/linux
ifeq ($(shell echo "check_quotes"),"check_quotes")
   WINDOWS := yes
else
   WINDOWS := no
endif
#враперы для удаление/создания дирректорий (крос)
ifeq ($(WINDOWS),yes)
   mkdir = mkdir $(subst /,\,$(1)) > nul 2>&1 || (exit 0)
   rm    = $(wordlist 2,65535,$(foreach FILE,$(subst /,\,$(1)),& del /S /Q /F $(FILE) > nul 2>&1)) || (exit 0)
   rmdir = rmdir /s /q $(subst /,\,$(1)) > nul 2>&1 || (exit 0)
   echo  = echo $(1)
else
   mkdir = mkdir -p $(1)
   rm    = rm $(1) > /dev/null 2>&1 || true
   rmdir = rmdir $(1) > /dev/null 2>&1 || true
   echo  = echo "$(1)"
endif

.PHONY: .build pio uf2 release debug .build_elf clean .clean_out .make_obj_dir name name_uf2

.build: .clean_out .build_elf ;

ifeq ($(init_build),yes)
release:.build ;
debug:.build ;
-include $(DEPENDS)
else
release:
	@exit 0
debug:
	@exit 0
endif

name:
	@$(call echo,$(out_name).elf)
name_uf2:
	@$(call echo,$(out_name).uf2)


pio: $(sources_pio) ;

uf2:.build
	@$(call echo,elf2uf2 ./$(out_name).uf2)
	@$(RP2040_SDK)bin/elf2uf2.exe $(out_name).elf $(out_name).uf2

.build_elf:|.make_obj_dir $(OBJECTS)
	@$(call echo,link    ./$(out_name).elf)
	@$(CXX) $(RP2040_SDK)lib/bs2_flash.S $(OBJECTS) $(CC_FLAGS) $(LINK_WRAP) $(LINK_FLAGS) -o $(out_name).elf

%.d:% |.make_obj_dir ;
%.cpp.o:%.cpp ;
%.c.o:%.c ;
%.S.o:%.S ;

%.cpp:
	@$(call echo,build   $(source_dir)$(subst $(obj_dir)/,/,$@))
	@$(CXX) -MMD  $(CC_FLAGS) -o $@.o -c $(source_dir)$(subst $(obj_dir)/,/,$@)

%.c:
	@$(call echo,build   $(source_dir)$(subst $(obj_dir)/,/,$@))
	@$(CC) -MMD  $(CC_FLAGS) -o $@.o -c $(source_dir)$(subst $(obj_dir)/,/,$@)

%.S:
	@$(call echo,build   $(source_dir)$(subst $(obj_dir)/,/,$@))
	@$(CC) -MMD  $(CC_FLAGS) -o $@.o -c $(source_dir)$(subst $(obj_dir)/,/,$@)

%.pio.h/h:
	@$(call echo,build   $(patsubst %.h/h,%,$@))
	@$(RP2040_SDK)bin/pioasm.exe $(patsubst %.h/h,%,$@) $(patsubst %.h/h,%.h,$@)

.make_obj_dir: $(OBJ_DIRS) ;
#	@$(call echo,mkdir   ./$(obj_dir)/*)

$(OBJ_DIRS):
	@$(call mkdir,$@)

clean: .clean_out
	@$(call echo,rm      ./$(obj_dir)/*)
	@$(call rm,./$(obj_dir))
	@$(call rmdir,./$(obj_dir))

.clean_out:
	@$(call echo,del     ./$(out_name).[elf uf2])
	@$(call rm,$(out_name).elf)
	@$(call rm,$(out_name).uf2)

