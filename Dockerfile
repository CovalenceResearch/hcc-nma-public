FROM rocker/r-ver:4

RUN /rocker_scripts/setup_R.sh https://packagemanager.posit.co/cran/__linux__/jammy/2023-01-29

# system libraries of general use
# from openanalytics docs for shinyproxy
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

# system requirements
# can check Posit Package Manager as well
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
    git \
    libcurl4-openssl-dev \
    libicu-dev \
    libnode-dev \
    libssl-dev \
    libxml2-dev \
    make \
    pandoc \
    zlib1g-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# copy necessary files
# https://github.com/openanalytics/shinyproxy-template/blob/master/Dockerfile
RUN mkdir /root/hcc-nma-public
WORKDIR /root/hcc-nma-public

# Prepare for renv::restore()
COPY .Rprofile renv.lock ./
COPY renv/activate.R renv/

# Install and run renv::restore()
# https://www.statworx.com/en/content-hub/blog/how-to-dockerize-shinyapps/
RUN R -q -e "install.packages('renv')"
RUN R -q -e "renv::restore()"

# Copy app
COPY *.R ./
COPY www www/

EXPOSE 3838

CMD ["R", "-q", "-e", "shiny::runApp('/root/hcc-nma-public')"]
