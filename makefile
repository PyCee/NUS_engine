CC=gcc
CFLAGS=-g -Wall \
	-Wshadow \
	-Wpointer-arith \
	-Wcast-qual \
	-Wcast-align \
	-Wstrict-prototypes \
	-Wmissing-prototypes \
	-Wconversion \
	-I/home/kims/VulkanSDK/1.0.33.0/x86_64/include

GPU_SRC_FILES=NUS_gpu_group.c NUS_vulkan_instance.c
GPU_DIR=gpu

IO_SRC_FILES=NUS_window.c NUS_system_events.c
IO_DIR=io

MATH_SRC_FILES=vector.c matrix.c quaternion.c pythag.c angle.c cartesian_system.c \
	frustum.c NUS_octree.c
MATH_DIR=math

MOD_SRC_FILES=vertex.c triangle.c texture.c mesh.c model.c joint.c skeleton.c
MOD_DIR=model

PHY_SRC_FILES=center.c physics_state.c movement.c orientation.c kinematic_property.c
PHY_DIR=physics

REN_SRC_FILES=NUS_presentation_surface.c
REN_DIR=render

GPU_SRC=$(addprefix $(GPU_DIR)/, $(GPU_SRC_FILES))
IO_SRC=$(addprefix $(IO_DIR)/, $(IO_SRC_FILES))
MATH_SRC=$(addprefix $(MATH_DIR)/, $(MATH_SRC_FILES))
MOD_SRC=$(addprefix $(MOD_DIR)/, $(MOD_SRC_FILES))
PHY_SRC=$(addprefix $(PHY_DIR)/, $(PHY_SRC_FILES))
REN_SRC=$(addprefix $(REN_DIR)/, $(REN_SRC_FILES))

GPU_HEA=$(GPU_SRC:.c=.h)
IO_HEA=$(IO_SRC:.c=.h)
MATH_HEA=$(MATH_SRC:.c=.h)
MOD_HEA=$(MOD_SRC:.c=.h)
PHY_HEA=$(PHY_SRC:.c=.h)
REN_HEA=$(REN_SRC:.c=.h)
OTHER_HEA=NUS_engine.h NUS_result.h

#NUS_SRC_FILES=$(IO_SRC) $(MATH_SRC) $(MOD_SRC) $(PHY_SRC) $(REN_SRC)
NUS_SRC_FILES=$(GPU_SRC) $(IO_SRC) $(REN_SRC)
SRC_DIR=src
NUS_SRC=$(addprefix $(SRC_DIR)/, $(NUS_SRC_FILES))

NUS_OBJ=$(NUS_SRC:.c=.o)
NUS_HEA=src/NUS_engine.h src/NUS_result.h $(NUS_SRC:.c=.h)

all: $(NUS_SRC) compile

compile: $(NUS_OBJ)
	sudo ar rcs /usr/local/lib/libNUS_engine.a $(NUS_OBJ)
	if [ ! -d "/usr/local/include/NUS" ]; then \
		sudo mkdir /usr/local/include/NUS; fi
	if [ ! -d "/usr/local/include/NUS/$(GPU_DIR)" ]; then \
		sudo mkdir /usr/local/include/NUS/$(GPU_DIR); fi
	if [ ! -d "/usr/local/include/NUS/$(IO_DIR)" ]; then \
		sudo mkdir /usr/local/include/NUS/$(IO_DIR); fi
	if [ ! -d "/usr/local/include/NUS/$(MATH_DIR)" ]; then \
		sudo mkdir /usr/local/include/NUS/$(MATH_DIR); fi
	if [ ! -d "/usr/local/include/NUS/$(MOD_DIR)" ]; then \
		sudo mkdir /usr/local/include/NUS/$(MOD_DIR); fi
	if [ ! -d "/usr/local/include/NUS/$(PHY_DIR)" ]; then \
		sudo mkdir /usr/local/include/NUS/$(PHY_DIR); fi
	if [ ! -d "/usr/local/include/NUS/$(REN_DIR)" ]; then \
		sudo mkdir /usr/local/include/NUS/$(REN_DIR); fi
	sudo cp $(addprefix $(SRC_DIR)/, $(GPU_HEA)) /usr/local/include/NUS/$(GPU_DIR)/
	sudo cp $(addprefix $(SRC_DIR)/, $(IO_HEA)) /usr/local/include/NUS/$(IO_DIR)/
	sudo cp $(addprefix $(SRC_DIR)/, $(MATH_HEA)) /usr/local/include/NUS/$(MATH_DIR)/
	sudo cp $(addprefix $(SRC_DIR)/, $(MOD_HEA)) /usr/local/include/NUS/$(MOD_DIR)/
	sudo cp $(addprefix $(SRC_DIR)/, $(PHY_HEA)) /usr/local/include/NUS/$(PHY_DIR)/
	sudo cp $(addprefix $(SRC_DIR)/, $(REN_HEA)) /usr/local/include/NUS/$(REN_DIR)/
	sudo cp $(addprefix $(SRC_DIR)/, $(OTHER_HEA)) /usr/local/include/NUS/
rebuild: clean all

.c.o:
	$(CC) $(CFLAGS) -c $<  -o $@
.PHONY: clean
clean:
	find . -type f \( -name '*.o' -o -name '*~' \) -delete
install:
	sudo apt-get install libx11-xcb-dev libx11-dev libxi-dev \
	libglm-dev graphviz libxcb-dri3-0 libxcb-present0 libpciaccess0 cmake \
	libpng-dev libxcb-dri3-dev libmirclient-dev libwayland-dev \
	xorg-dev build-essential

