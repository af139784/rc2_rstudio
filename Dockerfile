FROM ubuntu:xenial

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rocker-org/rocker-versioned" \
      org.label-schema.vendor="Rocker Project" \
      maintainer="Carl Boettiger <cboettig@ropensci.org>"

#R
ENV R_VERSION=4.0.3
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://packagemanager.rstudio.com/all/__linux__/focal/latest
ENV TZ=Etc/UTC

# Change Locale 
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen ja_JP.UTF-8 \
  && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" \
  && /bin/bash -c "source /etc/default/locale" \
  && ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# Install JP Fonts 
RUN apt-get update && apt-get install -y \
    fonts-ipaexfont \
    fonts-noto-cjk

COPY scripts /rocker_scripts

RUN /rocker_scripts/install_R.sh

#RStudio
ENV S6_VERSION=v1.21.7.0
ENV RSTUDIO_VERSION=latest
ENV PATH=/usr/lib/rstudio-server/bin:$PATH


RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh

#Tidyverse
RUN /rocker_scripts/install_tidyverse.sh

#Verse
ENV CTAN_REPO=http://mirror.ctan.org/systems/texlive/tlnet
ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH

RUN /rocker_scripts/install_verse.sh

EXPOSE 8787

CMD ["/init"]

