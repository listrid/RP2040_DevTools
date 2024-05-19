program_name := blink
source_dirs  := src

CC := $(RP2040_SDK)bin/arm-none-eabi-g++.exe

.PHONY: .build pio uf2 release debug clean name name_uf2

LINK_WRAP  := -Wl,--wrap=sprintf,--wrap=snprintf,--wrap=vsnprintf,--wrap=__clzsi2,--wrap=__clzdi2,--wrap=__ctzsi2,--wrap=__ctzdi2,--wrap=__popcountsi2,--wrap=__popcountdi2,--wrap=__clz,--wrap=__clzl,--wrap=__clzll,--wrap=__aeabi_idiv,--wrap=__aeabi_idivmod,--wrap=__aeabi_ldivmod,--wrap=__aeabi_uidiv,--wrap=__aeabi_uidivmod,--wrap=__aeabi_uldivmod,--wrap=__aeabi_dadd,--wrap=__aeabi_ddiv,--wrap=__aeabi_dmul,--wrap=__aeabi_drsub,--wrap=__aeabi_dsub,--wrap=__aeabi_cdcmpeq,--wrap=__aeabi_cdrcmple,--wrap=__aeabi_cdcmple,--wrap=__aeabi_dcmpeq,--wrap=__aeabi_dcmplt,--wrap=__aeabi_dcmple,--wrap=__aeabi_dcmpge,--wrap=__aeabi_dcmpgt,--wrap=__aeabi_dcmpun,--wrap=__aeabi_i2d,--wrap=__aeabi_l2d,--wrap=__aeabi_ui2d,--wrap=__aeabi_ul2d,--wrap=__aeabi_d2iz,--wrap=__aeabi_d2lz,--wrap=__aeabi_d2uiz,--wrap=__aeabi_d2ulz,--wrap=__aeabi_d2f,--wrap=sqrt,--wrap=cos,--wrap=sin,--wrap=tan,--wrap=atan2,--wrap=exp,--wrap=log,--wrap=ldexp,--wrap=copysign,--wrap=trunc,--wrap=floor,--wrap=ceil,--wrap=round,--wrap=sincos,--wrap=asin,--wrap=acos,--wrap=atan,--wrap=sinh,--wrap=cosh,--wrap=tanh,--wrap=asinh,--wrap=acosh,--wrap=atanh,--wrap=exp2,--wrap=log2,--wrap=exp10,--wrap=log10,--wrap=pow,--wrap=powint,--wrap=hypot,--wrap=cbrt,--wrap=fmod,--wrap=drem,--wrap=remainder,--wrap=remquo,--wrap=expm1,--wrap=log1p,--wrap=fma,--wrap=__aeabi_lmul,--wrap=__aeabi_fadd,--wrap=__aeabi_fdiv,--wrap=__aeabi_fmul,--wrap=__aeabi_frsub,--wrap=__aeabi_fsub,--wrap=__aeabi_cfcmpeq,--wrap=__aeabi_cfrcmple,--wrap=__aeabi_cfcmple,--wrap=__aeabi_fcmpeq,--wrap=__aeabi_fcmplt,--wrap=__aeabi_fcmple,--wrap=__aeabi_fcmpge,--wrap=__aeabi_fcmpgt,--wrap=__aeabi_fcmpun,--wrap=__aeabi_i2f,--wrap=__aeabi_l2f,--wrap=__aeabi_ui2f,--wrap=__aeabi_ul2f,--wrap=__aeabi_f2iz,--wrap=__aeabi_f2lz,--wrap=__aeabi_f2uiz,--wrap=__aeabi_f2ulz,--wrap=__aeabi_f2d,--wrap=sqrtf,--wrap=cosf,--wrap=sinf,--wrap=tanf,--wrap=atan2f,--wrap=expf,--wrap=logf,--wrap=ldexpf,--wrap=copysignf,--wrap=truncf,--wrap=floorf,--wrap=ceilf,--wrap=roundf,--wrap=sincosf,--wrap=asinf,--wrap=acosf,--wrap=atanf,--wrap=sinhf,--wrap=coshf,--wrap=tanhf,--wrap=asinhf,--wrap=acoshf,--wrap=atanhf,--wrap=exp2f,--wrap=log2f,--wrap=exp10f,--wrap=log10f,--wrap=powf,--wrap=powintf,--wrap=hypotf,--wrap=cbrtf,--wrap=fmodf,--wrap=dremf,--wrap=remainderf,--wrap=remquof,--wrap=expm1f,--wrap=log1pf,--wrap=fmaf,--wrap=malloc,--wrap=calloc,--wrap=realloc,--wrap=free,--wrap=memcpy,--wrap=memset,--wrap=__aeabi_memcpy,--wrap=__aeabi_memset,--wrap=__aeabi_memcpy4,--wrap=__aeabi_memset4,--wrap=__aeabi_memcpy8,--wrap=__aeabi_memset8,--wrap=printf,--wrap=vprintf,--wrap=puts,--wrap=putchar,--wrap=getchar
CC_FLAGS   := -mcpu=cortex-m0plus -mthumb -ffunction-sections -fdata-sections --specs=nosys.specs -I$(RP2040_SDK)include
LINK_FLAGS := -Wl,-L$(RP2040_SDK)lib,--script=flash.ld,-z,max-page-size=4096,--gc-sections,-lpico,$(RP2040_SDK)lib/reset_interface.c.obj
# -Wl,-Map=test_blink.elf.map

ifeq (debug,$(filter debug,$(MAKECMDGOALS)))
  CC_FLAGS := -g -DDEBUG $(CC_FLAGS)
  out_name := $(program_name)_d
else
  CC_FLAGS := -O3 -DNDEBUG $(CC_FLAGS)
  out_name := $(program_name)
endif

# windows/linux
ifeq ($(shell echo "check_quotes"),"check_quotes")
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

#recursiv scan dirs from mask (param: $1-dir, $2-mask)
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

init_build=yes
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
  sources_pio := $(addsuffix .h/h,$(call rwildcard, $(source_dirs),*.pio))
endif


ifeq ($(init_build),yes)

source_dirs := $(addprefix ./,$(source_dirs))
search_c    := $(addsuffix /*.c,$(source_dirs))
search_cpp  := $(addsuffix /*.cpp,$(source_dirs))
search_S    := $(addsuffix /*.S,$(source_dirs))
source      := $(wildcard $(search_cpp)) $(wildcard $(search_c)) $(wildcard $(search_S))

.build: clean
	@$(call echo,build   ./$(out_name).elf)
	@$(CC) $(CC_FLAGS) $(source) $(RP2040_SDK)lib/bs2_flash.S $(LINK_WRAP) $(LINK_FLAGS) -o $(out_name).elf
else
.build:
	@exit 0
endif

release:.build ;
debug:.build ;

name:
	@$(call echo,$(out_name).elf)
name_uf2:
	@$(call echo,$(out_name).uf2)


pio: $(sources_pio) ;

uf2:.build
	@$(call echo,elf2uf2 ./$(out_name).uf2)
	@$(RP2040_SDK)bin/elf2uf2.exe $(out_name).elf $(out_name).uf2

%.pio.h/h:
	@$(call echo,build   $(patsubst %.h/h,%,$@))
	@$(RP2040_SDK)bin/pioasm.exe $(patsubst %.h/h,%,$@) $(patsubst %.h/h,%.h,$@)

clean:
	@$(call echo,del     ./$(out_name).[elf uf2])
	@$(call rm,$(out_name).elf)
	@$(call rm,$(out_name).uf2)

