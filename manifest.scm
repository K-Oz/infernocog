;;; Development manifest for InfernoCog (Inferno OS)
;;; Use with: guix shell -m manifest.scm

(use-modules (guix packages)
             (gnu packages base)
             (gnu packages gcc)
             (gnu packages make)
             (gnu packages xorg)
             (gnu packages fontutils)
             (gnu packages compression))

(packages->manifest
 (list gcc
       make
       fontconfig
       freetype))