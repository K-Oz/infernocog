;;; Development manifest for InfernoCog with OpenCog integration
;;; Use with: guix shell -m manifest.scm

(use-modules (guix packages)
             (gnu packages base)
             (gnu packages gcc)
             (gnu packages make)
             (gnu packages cmake)
             (gnu packages boost)
             (gnu packages python)
             (gnu packages python-xyz)
             (gnu packages pkg-config)
             (gnu packages xorg)
             (gnu packages fontutils)
             (gnu packages compression)
             (gnu packages check)
             (gnu packages version-control))

;; Load local OpenCog packages
(load "opencog.scm")

(packages->manifest
 (list ;; Basic development tools
       gcc
       make
       cmake
       pkg-config
       git
       
       ;; InfernoCog base system
       infernocog
       
       ;; OpenCog stack
       cogutil
       atomspace
       cogserver
       attention
       opencog-core
       agi-bio
       
       ;; Development dependencies
       boost
       python
       python-pytest
       cxxtest
       guile-3.0
       
       ;; System libraries
       fontconfig
       freetype
       
       ;; Utilities
       gzip
       tar))