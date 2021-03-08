# Style-Transfer-Mapping
This is a matlab implementation of the paper *[Multisource Transfer Learning for Cross-Subject EEG Emotion Recognition](https://ieeexplore.ieee.org/document/8675478)*


## Environment
- matlab
- libsvm

## Data

You need to change the data dir in `multiSourceClassifier.m` file.

## Training

修改后 run `main_guan.m`


multiSourceClassifier_guan.m 修改后可用的代码，准确率82%。


data2.mat构成：3394*15*310（总session长，人数，特征数）


新的data构成： 运行stm_loadseeddata.m。
