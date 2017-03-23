FROM opensuse:tumbleweed
RUN zypper ar -f http://download.opensuse.org/repositories/YaST:/Head/openSUSE_Tumbleweed/ yast
# set a higher priority for the storage-ng repo to prefer the packages from this repo
RUN zypper ar -f -p 50 http://download.opensuse.org/repositories/YaST:/storage-ng/openSUSE_Tumbleweed/ storage-ng

# we need to install Ruby first to define the %{rb_default_ruby_abi} RPM macro
# see https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#/build-cache
# why we need "zypper clean -a" at the end
RUN zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
  ruby && zypper clean -a

RUN RUBY_VERSION=`rpm --eval '%{rb_default_ruby_abi}'` && \
  zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
  augeas-lenses \
  "rubygem($RUBY_VERSION:cfa_grub2)" \
  "rubygem($RUBY_VERSION:coveralls)" \
  "rubygem($RUBY_VERSION:fast_gettext)" \
  "rubygem($RUBY_VERSION:gettext)" \
  "rubygem($RUBY_VERSION:raspell)" \
  "rubygem($RUBY_VERSION:rspec)" \
  "rubygem($RUBY_VERSION:rubocop)" \
  "rubygem($RUBY_VERSION:simplecov)" \
  "rubygem($RUBY_VERSION:yard)" \
  "rubygem($RUBY_VERSION:yast-rake)" \
  aspell-en \
  autoconf \
  automake \
  boost-devel \
  dejagnu \
  docbook-xsl-stylesheets \
  doxygen \
  fdupes \
  gcc-c++ \
  git \
  graphviz \
  grep \
  libstorage-ng-ruby \
  libtool \
  libxml2-devel \
  libxslt \
  obs-service-source_validator \
  python-devel \
  rpm-build \
  ruby-devel \
  screen \
  sgml-skel \
  swig \
  update-desktop-files \
  which \
  yast2 \
  yast2-core-devel \
  yast2-devtools \
  yast2-network \
  yast2-installation-control \
  yast2-packager \
  yast2-proxy \
  yast2-ruby-bindings \
  yast2-storage-ng \
  yast2-testsuite \
  yast2-users \
  && zypper clean -a
COPY storage-ng-travis-* /usr/local/bin/
ENV LC_ALL=en_US.UTF-8
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# run some smoke tests to make sure there is no serious issue with the image
RUN /usr/lib/YaST2/bin/y2base --help
RUN c++ --version
RUN rake -r yast/rake -V
