# Direct-Mapping-Cache
A direct mapping cache in Prolog and Haskell involves creating a system that efficiently stores and retrieves data using a direct-mapped cache design. In this design, each memory address is mapped to a specific cache location based on a simple hash function or direct addressing mechanism.

# Description
Cache is a component that stores data so that future requests for that data can be served faster. Recently or frequently used data are stored temporarily in the cache to speed up the retrieval of the data by reducing the time needed for accessing cache clients data such as the CPU. In this project you must present a successful implementation of a simplified CPU cache system that works by retrieving data (from cache if possible, otherwise from memory) given the memory addresses of the data and successfully updating the cache upon the data retrieval. The idea of a cache is that it introduces hierarchy into memory systems. Thus, instead of having one level for a large memory which will probably be slow because it needs to be cheap, we can have multiple levels.

In the project we will assume we have two levels as shown in Figure 1\

![Memo](https://github.com/Khaledayman9/Direct-Mapping-Cache/assets/105018459/a84cf58a-9ef2-497d-b934-665150463681)


The operation in this case goes as follows:
 - A specific block of data is requested. The block is identified by its location in the main memory
 - First, the system has to look if the block at the required address was mapped somewhere in the cache.
 - If found in the cache, there is no need to go to the main memory.
 - If the data is not available in the cache then:
   - The system has to rad the block from the main memory.
   - The bread block has to be placed in the cache.
   - The place where the block is placed in the cache depends on the type of the cache as shown in the next section.
   - If the chosen cache location(line) is not empty, then the block already in the cache will be overwritten by the new block read from the main memory.


# Address:
An address of a block in the main memory is always translated to a binary number. The address is split into two parts index field and a tag field. Each part is assigned a specific number of bits. 
  - The index always indicates the location inside the cache to which this main memory block will map to.
   - The tag is used as an identifier for the block.
For example if the main memory address is 00011001 such that the index has 3 bits and the tag has 5 bits then the address is divided as below:

![example](https://github.com/Khaledayman9/Direct-Mapping-Cache/assets/105018459/ea877f53-dd7a-4b35-8302-9da0d34229df)

Thus the least significant 3 bits in this case are the index bits and the rest of the address is the tag This means that the memory block with address 00011001 should be mapped to an option in the cache indexed by 001.

# Cache Options

The number of options inside the cache indicate the number of bits needed for the index part.
  - For example, if there are 4 options in the cache then these options will be numbered as follows: 00, 01, 10 and 1. Thus we need 2 bits for the index.
  - In case we have 8 options in the cache. These options are numbered from 000 to 111. Thus we need 3 bits for the index.
  - In general if we have 2i options in the cache, we need i bits for the index part of the address.
  
The options inside the cache differ according to the type of the cache. Details on the mapping are shown according to the types in the following sections.


# Direct Mapping Cache:

- Steps are:
  - Split address into index and tag part
  - Check if a data item is available in cache
  - Get data from cache

![Direct Mapped](https://github.com/Khaledayman9/Direct-Mapping-Cache/assets/105018459/82b39518-798b-4a76-bd0f-d059aa16b4c7)

- In the case of direct mapping, any block in the main memory can map to exactly **one location** in the cache. In other words, direct mapping maps each block of data in main memory into only one possible cache line. 
- In case of direct mapping, the options of mapping are the blocks inside the cache. The index part of the address will specify which line/location in the cache you will go to.
- The tag will confirm whether the data stored in this line of cache is of the correct address or not by comparing it with the tag stored in cache.
- For example: If the index is 3 bits and the given address is **"00000101"** then the index is **"101"** and the tag is **"00000"**. The memory address **"00001101"** will
 have the same index **"101"** but a different tag **"00001"**.

![Add](https://github.com/Khaledayman9/Direct-Mapping-Cache/assets/105018459/dea55ac8-cad2-42b7-ba0a-312db5b444e4)

- Every entry in the cache will have two values:
  - Data Value representing the actual data inside this location
  - Tag value indicating which specific memory block is inside this cache location. In more words, as shown in the previous example multiple memory blocks can map to the same location inside the cache. How would we know which specific memory block is there? From the tag.
  
- Given the below example as part of the cache:
  
![tabl](https://github.com/Khaledayman9/Direct-Mapping-Cache/assets/105018459/80841edd-83d9-44b8-8777-a6cb962af759)

- If we are searching for memory block **00000101**, we will do the following:
  - Extract the index. In this case the index is 101.
  - Extract the tag. In this case the tag is 00000.
  - Extract the tag available in the cache at this location. The tag in this case is 00001.
  - Compare both tags together. Since they are not the same then the memory block 00000101 is not available in cache.
- If we are searching for memory block **00001101**, we will do the following:
  - Extract the index. In this case the index is 101.
  - Extract the tag. In this case the tag is 00001.
  - Extract the tag available in the cache at this location. The tag in this case is 00001.
  - Compare both tags together. Since they are equal then the memory block 00001101 is available in cache and the data of this block is ABC.
 

# Data retrieval
If the processor finds that the memory location is in the cache, a cache hit has occurred and data is read from cache. If the processor does not find the memory location in the cache, a cache miss has occurred. For a cache miss, the cache allocates a new entry and copies in data from main memory, then the request is fulfilled from the contents of the cache.

# Replacement
When a cache miss occurs and no empty slots present, data should be retrieved from the memory to update the cache and get the data. Different replacement strategies are available according to the cache type. In case, of direct mappimg there are no choiced to make since the block maps to exactly one location. 

# Technologies
- Prolog
  
- Haskell
  
- Notepad++
