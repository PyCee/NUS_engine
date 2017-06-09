#include "NUS_model.h"
#include "../gpu/NUS_queue_info.h"
#include <stdlib.h>
#include <string.h>
#include "stdio.h"
#include "../NUS_log.h"
#include <NUSM/NUSM_library.h>

NUS_result nus_model_build(NUS_absolute_path absolute_path, NUS_model *p_model)
{
  if(nusm_read(absolute_path.path, &p_model->contents) != NUSM_SUCCESS){
    NUS_LOG_ERROR("failed to read model file: %s\n", absolute_path.path);
    return NUS_FAILURE;
  }
  
  return NUS_SUCCESS;
}
void nus_model_free(NUS_queue_info queue_info, NUS_model *p_model)
{
  nus_memory_map_free(&p_model->vertex_memory, queue_info);
  nus_memory_map_free(&p_model->index_memory, queue_info);
  nus_texture_free(*queue_info.p_gpu, &p_model->texture);
  // free model contents
}
NUS_result nus_model_buffer
(NUS_queue_info queue, NUS_model *p_model)
{
  // load texture
  if(nus_texture_build(queue, p_model->contents.texture_width,
		       p_model->contents.texture_height, VK_FORMAT_R8G8B8A8_UNORM,
		       VK_IMAGE_USAGE_TRANSFER_DST_BIT |
		       VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT,
		       VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
		       VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
		       &p_model->texture) != NUS_SUCCESS){
    NUS_LOG_ERROR("failed to build model texture\n");
    return NUS_FAILURE;
  }
  if(nus_texture_buffer_image(queue, p_model->contents.texture_data,
			      p_model->contents.texture_data_size,
			      &p_model->texture) != NUS_SUCCESS){
    NUS_LOG_ERROR("failed to load model texture data\n");
    return NUS_FAILURE;
  }
  
  if(nus_memory_map_build(queue, p_model->contents.vertex_data_size,
			  VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
			  VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT,
			  &p_model->vertex_memory) != NUS_SUCCESS){
    printf("ERROR::failed to build memory map for vertices\n");
    return NUS_FAILURE;
  }
  if(nus_memory_map_build(queue, p_model->contents.index_data_size,
			  VK_BUFFER_USAGE_INDEX_BUFFER_BIT,
			  VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT,
			  &p_model->index_memory) != NUS_SUCCESS){
    printf("ERROR::failed to build memory map for indices\n");
    return NUS_FAILURE;
  }
  if(nus_memory_map_flush(p_model->vertex_memory, queue,
			  p_model->contents.vertex_data) != NUS_SUCCESS){
    printf("ERROR::failed to flush vertex memory\n");
    return NUS_FAILURE;
  }
  if(nus_memory_map_flush(p_model->index_memory, queue,
			  p_model->contents.index_data) != NUS_SUCCESS){
    printf("ERROR::failed to flush index memory\n");
    return NUS_FAILURE;
  }
  return NUS_SUCCESS;
}
