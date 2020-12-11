FROM bioconductor/bioconductor_docker:RELEASE_3_12

WORKDIR /home/rstudio

COPY --chown=rstudio:rstudio . /home/rstudio/

# getting error with gert that seems to be fixed with this in the Github actions so adding it here
RUN Rscript -e "remotes::install_github('r-hub/sysreqs')" &&\
    sysreqs=$(Rscript -e "cat(sysreqs::sysreq_commands('DESCRIPTION'))") &&\
    sudo -s eval "$sysreqs"

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); BiocManager::install(ask=FALSE)"

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); devtools::install('.', dependencies=TRUE, build_vignettes=TRUE, repos = BiocManager::repositories())"

