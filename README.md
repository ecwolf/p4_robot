In-network Low Latency Robot Arm Kinematics Control using P4
===

[![License: BSD v3](https://img.shields.io/badge/License-BSD%20v3-blue.svg)](LICENSE)

## About P4+Robot control
Prototype implementation of a robot arm control use case boosted by a P4 program running in a near-by hardware switch. The P4 pipeline is able to parse and identify geometric position coordinates of the robot arm carried in  the payload of TCP segments exchanged between of the robot and the controller. Upon a threshold calculation, the P4 switch is able to rapidly craft a custom  stop message within the TCP connection resulting in an ultra-low latency command.

<p align="center">
  <img src="https://github.com/ecwolf/p4_robot/raw/master/images/robot_system.png">
</p>


## Citation
To cite `In-network Low Latency Robot Arm Kinematics Control using P4`, we recommend the following

```latex
@inproceedings{10.1145/3360468.3368178,
	author = {Rodriguez, Fabricio and Rothenberg, Christian Esteve and Pongr\'{a}cz, Gergely},
	title = {In-Network P4-Based Low Latency Robot Arm Control},
	year = {2019},
	isbn = {9781450370066},
	publisher = {Association for Computing Machinery},
	address = {New York, NY, USA},
	url = {https://doi.org/10.1145/3360468.3368178},
	doi = {10.1145/3360468.3368178},
	booktitle = {Proceedings of the 15th International Conference on Emerging Networking EXperiments and Technologies},
	pages = {59–61},
	numpages = {3},
	keywords = {P4, Robotic control, Low Latency applications},
	location = {Orlando, FL, USA},
	series = {CoNEXT '19 Companion}
}
```
