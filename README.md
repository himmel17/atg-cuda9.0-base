# atg-cuda9.0-base
## What is this?

nvidia-docker2を使ってコンテナ内でCUDAを動かす．

- CUDA 9.0
- cuDNN 7
- Python 3.5.2
- Tensorflow-gpu 1.8.0
- Keras 2.2.0
- PyTorch 0.4.0

## Download method1

    git clone https://github.com/himmel17/atg-cuda9.0-base.git .

## Download method2

こちらの方法だと~/.gitが含まれないことに注意．

    curl -Lk https://github.com/himmel17/atg-cuda9.0-base/archive/master.tar.gz -o atg-cuda9.0.tar.gz

## Build

    docker build -t atg-cuda9.0-base:0.1 .
