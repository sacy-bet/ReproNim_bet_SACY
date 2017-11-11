# Generated by Neurodocker v0.3.1-21-ged92d36.
#
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
#     https://github.com/kaczmarj/neurodocker
#
# Timestamp: 2017-11-11 19:19:03

FROM neurodebian:stretch-non-free

ARG DEBIAN_FRONTEND=noninteractive

#----------------------------------------------------------
# Install common dependencies and create default entrypoint
#----------------------------------------------------------
ENV LANG="en_US.UTF-8" \
    LC_ALL="C.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN apt-get update -qq && apt-get install -yq --no-install-recommends  \
    	apt-utils bzip2 ca-certificates curl locales unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && localedef --force --inputfile=en_US --charmap=UTF-8 C.UTF-8 \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> $ND_ENTRYPOINT \
         && echo 'set +x' >> $ND_ENTRYPOINT \
         && echo 'if [ -z "$*" ]; then /usr/bin/env bash; else $*; fi' >> $ND_ENTRYPOINT; \
       fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker
ENTRYPOINT ["/neurodocker/startup.sh"]

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends fsl-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add command(s) to entrypoint
RUN sed -i '$isource /etc/fsl/fsl.sh' $ND_ENTRYPOINT

# Create new user: neuro
RUN useradd --no-user-group --create-home --shell /bin/bash neuro
USER neuro

USER root

#------------------
# Install Miniconda
#------------------
ENV CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH
RUN echo "Downloading Miniconda installer ..." \
    && miniconda_installer=/tmp/miniconda.sh \
    && curl -sSL -o $miniconda_installer https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash $miniconda_installer -b -p $CONDA_DIR \
    && rm -f $miniconda_installer \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && conda clean -tipsy && sync

#-------------------------
# Create conda environment
#-------------------------
RUN conda create -y -q --name neuro --channel vida-nyu python=3.5.1 \
                                                       numpy \
                                                       pandas \
                                                       reprozip \
                                                       traits \
    && sync && conda clean -tipsy && sync \
    && /bin/bash -c "source activate neuro \
      && pip install -q --no-cache-dir nipype" \
    && sync \
    && sed -i '$isource activate neuro' $ND_ENTRYPOINT

#--------------------------------------------------
# Add NeuroDebian repository
# Please note that some packages downloaded through
# NeuroDebian may have restrictive licenses.
#--------------------------------------------------
RUN apt-get update -qq && apt-get install -yq --no-install-recommends dirmngr gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -sSL http://neuro.debian.net/lists/stretch.us-nh.full \
    > /etc/apt/sources.list.d/neurodebian.sources.list \
    && curl -sSL https://dl.dropbox.com/s/zxs209o955q6vkg/neurodebian.gpg \
    | apt-key add - \
    && (apt-key adv --refresh-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 || true) \
    && apt-get update

# Install NeuroDebian packages
RUN apt-get update -qq && apt-get install -yq --no-install-recommends dcm2niix git-annex-standalone datalad \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER neuro

WORKDIR /home/neuro

#--------------------------------------
# Save container specifications to JSON
#--------------------------------------
RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "check_urls": false, \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "neurodebian:stretch-non-free" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "fsl-core" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "add_to_entrypoint", \
    \n      [ \
    \n        "source /etc/fsl/fsl.sh" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "root" \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "env_name": "neuro", \
    \n        "conda_opts": "--channel vida-nyu", \
    \n        "conda_install": "python=3.5.1 numpy pandas reprozip traits", \
    \n        "pip_install": "nipype", \
    \n        "activate": true \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "neurodebian", \
    \n      { \
    \n        "os_codename": "stretch", \
    \n        "download_server": "usa-nh", \
    \n        "pkgs": "dcm2niix git-annex-standalone datalad" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ], \
    \n    [ \
    \n      "workdir", \
    \n      "/home/neuro" \
    \n    ] \
    \n  ], \
    \n  "generation_timestamp": "2017-11-11 19:19:03", \
    \n  "neurodocker_version": "0.3.1-21-ged92d36" \
    \n}' > /neurodocker/neurodocker_specs.json
