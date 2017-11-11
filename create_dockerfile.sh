# Generate Dockerfile.
docker run --rm kaczmarj/neurodocker:master generate \
--base debian:stretch --pkg-manager apt \
--dcm2niix version=latest \
--fsl version=5.0.10 \
--minc version=1.9.15 \
--user neuro \
--miniconda env_name=neuro \
            conda_opts="--channel vida-nyu" \
            conda_install="python=3.5.1 numpy pandas reprozip traits" \
            pip_install="nipype" \
            activate=true \
--miniconda env_name=neuro \
            pip_install="pylsl" \
--miniconda env_name=py27 \
            conda_install="python=2.7" \
--user root \
--mrtrix3 \
--neurodebian os_codename="stretch" \
              download_server="usa-nh" \
              pkgs="dcm2niix git-annex-standalone datalad" \
--petpvc version=1.2.0-b \
--install git vim \
--user neuro \
--workdir /home/neuro \
--no-check-urls > Dockerfile

# Build Docker image using the saved Dockerfile.
docker build -t myimage -f Dockerfile .
