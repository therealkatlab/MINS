# Modular interactive nuclear segmentation (MINS)

This repository holds the code for the software **MINS** (modular interactive nuclear segmentation), develolped by Xinghua Lou in [Kat Hadjantonakis' lab](https://www.mskcc.org/research-areas/labs/anna-katerina-hadjantonakis), at Sloan Kettering Institute and published in [Stem Cell Reports in 2014](http://www.sciencedirect.com/science/article/pii/S2213671114000277 'Lou et al'). 

Alternatively, the software can also be found in [katlab-tools.org], alongside a brief user guide.

## From the paper's Methods section:

*MINS was implemented using a combination of MATLAB and C++. MATLAB serves as the high-level glue language that provides the GUI and also for construction of the overall pipeline. C++, on the other hand, was used to implement the underlying algorithms for better computational efficiency. All core algorithmic components are implemented in C++ and invoked in MATLAB as functions. Furthermore, some algorithms are paralleled including the PSGIS algorithm. The implementation has GUI support and is available to interested users.*

*Currently, MINS runs on a PC with 64-bit Windows OS. Necessary supporting software includes MATLAB with the Image Processing and Statistics Toolboxes. Java Runtime Environ- ment is also required. For segmenting large 3D data, we used an Intel Xeon Processor E5530 Quad Core 2.40 GHz with 24G memory.*

