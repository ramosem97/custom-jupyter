FROM jupyter/all-spark-notebook:latest

# install the locales you want to use
ENV LANG=C.UTF-8

# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt requirements.txt
RUN pip install --quiet --no-cache-dir --requirement requirements.txt && \
    pip install --upgrade jupyterlab jupyterlab-git

# Fix Permissions   
RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Clean Conda
RUN conda clean --all -f -y

# Install Jupyter Lab Extensions 
RUN jupyter labextension install --no-build   \
    @jupyter-widgets/jupyterlab-manager \
    @jupyterlab/apputils \
    @jupyterlab/toc \
    @jupyterlab/fasta-extension \
    @jupyterlab/server-proxy \
    @jupyterlab/statusbar \
    @jupyterlab/latex \
    @jupyterlab/translation \
    @jupyterlab/debugger \
    @jupyterlab/pullrequests \
    @jupyterlab/celltags \
    && jupyter lab build --dev-build=False --minimize=False -y  && jupyter lab clean -y

# Install Jupyter Lab Extensions from Other People
RUN jupyter labextension install --no-build \
    jupyter-matplotlib \
    jupyterlab-plotly \
    jupyterlab-jupytext \
    @kiteco/jupyterlab-kite \
    @jupyterlab/toc-extension @jupyterlab/debugger-extension @jupyterlab/celltags-extension @jupyterlab/translation-extension \
    && jupyter lab build  --dev-build=False --minimize=False -y  && jupyter lab clean -y

EXPOSE 9000
CMD jupyter lab --ip=* --allow-root --port=9000