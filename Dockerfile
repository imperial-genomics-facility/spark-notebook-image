FROM imperialgenomicsfacility/base-notebook-image:release-v0.0.7
LABEL maintainer="imperialgenomicsfacility"
LABEL version="0.0.1"
LABEL description="Docker image for running Apache Spark using Jupyter notebook"
ENV NB_USER vmuser
ENV NB_UID 1000
USER root
WORKDIR /
RUN apt-get -y update &&   \
    apt-get install --no-install-recommends -y \
      libfontconfig1 \
      libxrender1 \
      libreadline-dev \
      libreadline7 \
      libicu-dev \
      libc6-dev \
      icu-devtools \
      libjpeg-dev \
      libxext-dev \
      libcairo2 \
      libicu60 \
      libicu-dev \
      gcc \
      g++ \
      make \
      libgcc-5-dev \
      gfortran \
      git  && \
    apt-get purge -y --auto-remove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
USER $NB_USER
WORKDIR /home/$NB_USER
ENV TMPDIR=/tmp
ENV PATH=$PATH:/home/$NB_USER/miniconda3/bin/
RUN rm -f /home/$NB_USER/environment.yml && \
    rm -f /home/$NB_USER/Dockerfile
COPY environment.yml /home/$NB_USER/environment.yml
COPY Dockerfile /home/$NB_USER/Dockerfile
COPY entrypoint.sh /home/$NB_USER/entrypoint.sh
USER root
RUN chown ${NB_UID} /home/$NB_USER/environment.yml && \
    chown ${NB_UID} /home/$NB_USER/Dockerfile && \
    chmod a+x /home/$NB_USER/entrypoint.sh
USER $NB_USER
WORKDIR /home/$NB_USER
RUN conda update -n base -c defaults conda && \
    conda env update -q -n notebook-env --file /home/$NB_USER/environment.yml && \
    conda clean -a -y && \
    rm -rf /home/$NB_USER/.cache && \
    rm -rf /tmp/* && \
    mkdir -p /home/$NB_USER/.cache && \
    find miniconda3/ -type f -name *.pyc -exec rm -f {} \; 
EXPOSE 8888
EXPOSE 4040
CMD [ "notebook" ]
