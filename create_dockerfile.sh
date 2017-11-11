# Generate Dockerfile.
docker run --rm kaczmarj/neurodocker:master generate -b neurodebian:stretch-non-free -p apt \
--install fsl-core \
--add-to-entrypoint "source /etc/fsl/fsl.sh" \
--user neuro \
--user root \
--neurodebian os_codename="stretch" \
              download_server="usa-nh" \
              pkgs="dcm2niix git-annex-standalone datalad" \
--user neuro \
--workdir /home/neuro \
--no-check-urls > Dockerfile

# Build Docker image using the saved Dockerfile.
docker build -t myimage -f Dockerfile .
