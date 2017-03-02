#ifndef NUS_COMPONENT_KEY_H
#define NUS_COMPONENT_KEY_H

#define NUS_COMPONENT_KEY_MOVEMENT 1
#define NUS_COMPONENT_KEY_ORIENTATION (NUS_COMPONENT_KEY_MOVEMENT << 1)
#define NUS_COMPONENT_KEY_MODEL (NUS_COMPONENT_KEY_ORIENTATION << 1)

typedef unsigned int NUS_component_key;

#endif /* NUS_COMPONENT_KEY_H */
