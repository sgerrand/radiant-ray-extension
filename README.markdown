Overview
========

Ray is just a rake file with some tasks that simplify the installation, disabling, enabling and uninstallation of Radiant extensions. Although Ray relies on GitHub (as the extension host) it does not rely on the `git` command, if you don't have `git` installed then the Ruby Open-URI library is used to download compressed archives.

To use Ray you need `git` or `tar` installed in addition to the normal Radiant stack; Windows users probably need one of those "unixy" environment things since Ray does occasionally call out to system tools (I really don't know about Windows though). Ray **only** supports the `git` <abbr title="Source Code Management">SCM</abbr>; although I'd happily accept a patch that used `git`'s tools to access CVS, SVN or whatever else it can handle. If you need to install extensions from other sources you should use Radiant's built-in `script/extension install` command which can handle a wide variety of installation types.

Table of contents
=================

0. [Installation](http://johnmuhl.github.com/radiant-ray-extension/#installation)
  0. [Upgrading with Git](http://johnmuhl.github.com/radiant-ray-extension/#upgrading-with-git)
  0. [Upgrading with HTTP](http://johnmuhl.github.com/radiant-ray-extension/#upgrading-with-http)
0. [Bugs & feature requests](http://github.com/johnmuhl/radiant-ray-extension/issues)
0. [Usage](http://johnmuhl.github.com/radiant-ray-extension/#usage)
  0. [Installing extensions](http://johnmuhl.github.com/radiant-ray-extension/#ext-install)
  0. [Searching for extensions](http://johnmuhl.github.com/radiant-ray-extension/#ext-search)
  0. [Disabling extensions](http://johnmuhl.github.com/radiant-ray-extension/#ext-disable)
  0. [Enabling extensions](http://johnmuhl.github.com/radiant-ray-extension/#ext-enable)
  0. [Uninstalling extensions](http://johnmuhl.github.com/radiant-ray-extension/#ext-uninstall)
  0. [Updating extensions](http://johnmuhl.github.com/radiant-ray-extension/#ext-update)
  0. [Bundling extensions](http://johnmuhl.github.com/radiant-ray-extension/#ext-bundle)
0. [Extension dependencies](http://johnmuhl.github.com/radiant-ray-extension/#extension-dependencies)
0. [Advanced usage](http://johnmuhl.github.com/radiant-ray-extension/#advanced-usage)
  0. [Download preference setup](http://johnmuhl.github.com/radiant-ray-extension/#setup-download)
  0. [Server restart preference setup](http://johnmuhl.github.com/radiant-ray-extension/#setup-restart)
  0. [Adding extension remotes](http://johnmuhl.github.com/radiant-ray-extension/#ext-remote)
  0. [Pulling extension remotes](http://johnmuhl.github.com/radiant-ray-extension/#ext-pull)
0. [Legacy information](http://johnmuhl.github.com/radiant-ray-extension/#legacy-information)
  0. [What happened to "some" shortcut?](http://johnmuhl.github.com/radiant-ray-extension/#shortcuts-redux)
  0. [What changed in `extensions.yml`?](http://johnmuhl.github.com/radiant-ray-extension/#ext-bundle-diff)
  0. [What if I don't like the new commands?](http://johnmuhl.github.com/radiant-ray-extension/#shortcuts)


Authors
=======

* john muhl
* Michael Kessler
* Arik Jones
* Benny Degezelle

MIT License
============

Copyright (c) 2008, 2009 john muhl

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
