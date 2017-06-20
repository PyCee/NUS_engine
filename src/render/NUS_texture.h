#ifndef NUS_TEXTURE_H
#define NUS_TEXTURE_H

#include "../NUS_vulkan.h"
#include "../NUS_result.h"
#include "../gpu/NUS_binding.h"

struct NUS_gpu;
struct NUS_queue_info;

typedef struct NUS_texture{
  VkImage image;
  VkDeviceMemory memory;
  VkFormat format;
  unsigned int width, height;
  size_t image_size;
  NUS_binding binding;
} NUS_texture;

NUS_result nus_texture_build
(unsigned int, unsigned int, VkFormat, unsigned int, unsigned int,
 NUS_texture *);
void nus_texture_free(NUS_texture *);
NUS_result nus_texture_buffer_image
(void *, size_t, NUS_texture *);
NUS_result nus_cmd_texture_transition
(NUS_texture, VkCommandBuffer, VkImageLayout, VkImageLayout, unsigned int);


#endif /* NUS_TEXTURE_H */
