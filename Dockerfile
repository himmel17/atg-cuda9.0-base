FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer="himmel17"
LABEL title="CUDA9.0 Base Image"
LABEL version="0.1"
LABEL description="CUDA9.0 Base Image"

ARG user_name="tester"
ARG user_id=1001
ARG group_name="rsd"
ARG group_id=1001

ENV http_proxy=http://proxy.atg.sony.co.jp:10080/
ENV https_proxy=https://proxy.atg.sony.co.jp:10080/

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/local/lib:/usr/lib:/usr/lib/x86_64-linux-gnu:/lib64:/lib

# TODO: https://qiita.com/DUxCA/items/7bf3862569cfca122d73 を参考に，
#       必要なものがあったら追加していく．
# TODO: 別のDockerfileでOpenCVをbuildする．
RUN set -x && \
	apt update -y && \
	: "Python3環境を構築" && \
	apt install -y --no-install-recommends \
		python3-dev \
		python3-pip \
		python3-setuptools \
		python3-wheel && \
	: "キャッシュを消してイメージを小さくする" && \
	apt clean -y && \
	apt autoremove -y && \
	apt autoclean -y && \
	rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY req_cuda9p0.txt ./
RUN : "前回buildしたキャッシュを無効にしてインストール" && \
	pip3 install --no-cache-dir --requirement req_cuda9p0.txt && \
	: "Installing PyTorch for CUDA9.0" && \
	pip3 install --no-cache-dir http://download.pytorch.org/whl/cu90/torch-0.4.0-cp35-cp35m-linux_x86_64.whl && \
	pip3 install --no-cache-dir torchvision

# ユーザ設定
# ユーザID,グループIDをパラメータにすることでホストボリュームに対する操作を
# ユーザ権限で実行できるようにしている．
RUN groupadd -g ${group_id} ${group_name} && \
	useradd --create-home --shell /bin/bash \
	--uid ${user_id} --gid ${group_id} --home-dir /home/${user_name} \
	${user_name}

USER ${user_name}
WORKDIR /home/${user_name}
ENV HOME /home/${user_name}
