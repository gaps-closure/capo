#ifndef _PARTITIONER_H_
#define _PARTITIONER_H_

#define OK 0
#define NOTOK (-1)


/**
 * This is a function preparing the partitioner runtime.
 * Has to be called before any of send/receive functions are used.
 * Parameters (read only):
 * enclave - the name of the enclave where this program is running.
 * 
 * Returns OK if no error was encountered, NOTOK otherwise.
 */
int initialize_partitioner(char * enclave);

/**
 * This is a function that cleans up partitioner runtime, and performs any other
 * ending activity
 */
int cleanup_partitioner();




/**
 * Guarded send is the designated transfer method for exchanging data between enclaves.
 * It unidirectionally sends data to another enclave, without acknowledgement.
 * Parameters (all read only):
 * enclave - a string with enclave name (e.g., "orange") to which data is sent.
 * name - a string with variable name (may be arbitrary, but will be matched at the reading side)
 * size - number of bytes that will be sent
 * data_ptr - data to be sent (e.g., pointer to a variable)
 *
 * Returns OK if no error has been encountered, NOTOK otherwise. Does NOT wait for data to be actually sent.
 * Note that 'no error' does NOT mean the data has been transfered and/or received on the other side,
 * only that the sending mechanism has accepted the data to be sent.
 *
 * TBD: marshalling the data. At this time binary representation is sent.
 */
int guarded_send(char * enclave, char * name, int size, void * data_ptr);


/**
 * Guarded receive is the designated transfer method for exchenging data between enclaves.
 * It attempts to read a value of a variable, if available.
 * Parameters:
 * name - a string with variable name (may be arbitrary, but is matched with the name 
 *        attached to the sent data by guarded_send())
 * size_max - maximum number of bytes that can be received
 * variable_ptr - pointer to a pointer variable that will be allocated for receiving the data, if it points to NULL.
 *                it will be used directly if it points to not NULL.
 *
 * This is blocking call, it will wait until data is available.
 * Returns OK if data was received successfully, NOTOK if an error occured.
 *
 * TBD: marshalling the data. At this time binary representation is received.
 */
int guarded_receive(char * name, int size_max, void **variable_ptr);

#endif /*_PARTITIONER_H_*/
