FROM opensuse:tumbleweed
RUN zypper ar -f http://download.opensuse.org/repositories/YaST:/Head/openSUSE_Tumbleweed/ yast
# set a higher priority for the storage-ng repo to prefer the packages from this repo
RUN zypper ar -f -p 50 http://download.opensuse.org/repositories/YaST:/storage-ng/openSUSE_Tumbleweed/ storage-ng
RUN zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
  'rubygem(fast_gettext)' \
  'rubygem(gettext)' \
  'rubygem(raspell)' \
  'rubygem(rspec)' \
  'rubygem(rubocop)' \
  'rubygem(simplecov)' \
  'rubygem(yard)' \
  'rubygem(yast-rake)' \
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
  python-devel \
  rpm-build \
  ruby-devel \
  screen \
  sgml-skel \
  swig \
  update-desktop-files \
  which \
  yast2 \
  yast2-devtools \
  yast2-ruby-bindings \
  && zypper clean -a
COPY storage-ng-travis-* /usr/local/bin/
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# just a smoke test, make sure YaST...
RUN /usr/lib/YaST2/bin/y2base --help
# ...and GCC work
RUN c++ --version
