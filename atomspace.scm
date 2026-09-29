;;; GNU Guix package definition for atomspace@5.0.3-1.86c848d
;;;
;;; Install this exact OpenCog AtomSpace revision with:
;;;
;;;   guix install -f atomspace.scm
;;;
;;; After this module is on GUIX_PACKAGE_PATH (or via `guix install -L .`):
;;;
;;;   guix install atomspace@5.0.3-1.86c848d
;;;
;;; Source: https://github.com/opencog/atomspace @ 86c848dfc7135b3c47deb581f8da54a60f6711c9

(use-modules (guix packages)
             (guix git-download)
             (guix build-system cmake)
             (guix utils)
             (guix licenses)
             (gnu packages boost)
             (gnu packages check)
             (gnu packages databases)
             (gnu packages guile)
             (gnu packages multiprecision)
             (gnu packages pkg-config)
             (gnu packages python))

;; CogUtil is a required input.  Same pin as cogutil@2.0.3-1.b07b41b so
;; `guix install -f atomspace.scm` is self-contained.
(define cogutil
  (let ((commit "b07b41b2eaf01627c78b27f1f28bb09ef7086f8e")
        (revision "1"))
    (package
      (name "cogutil")
      (version (git-version "2.0.3" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/opencog/cogutil")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1ymmcrinp0prlxsmxmwdjjl4kgaj7wzq39d5b1q2apgg94yfdhqb"))))
      (build-system cmake-build-system)
      (arguments
       `(#:tests? #f            ; cxxtest binaries need a full test env
         #:configure-flags
         (list "-DCMAKE_BUILD_TYPE=Release")))
      (inputs
       `(("boost" ,boost)))
      (native-inputs
       `(("cxxtest" ,cxxtest)
         ("python" ,python-minimal)
         ("pkg-config" ,pkg-config)))
      (home-page "https://github.com/opencog/cogutil/")
      (synopsis "Low-level C++ programming utilities used by OpenCog components")
      (description
       "CogUtil provides foundational utilities and data structures for the
OpenCog framework, including logging, configuration management, thread-safe
queues, stacks and sets, and OS portability layers.")
      (license (list agpl3 asl2.0)))))

(define-public atomspace
  ;; The last release was in 2016 and doesn't build with our Boost package.
  ;; git-version yields atomspace@5.0.3-1.86c848d.
  (let ((commit "86c848dfc7135b3c47deb581f8da54a60f6711c9")
        (revision "1"))
    (package
      (name "atomspace")
      (version (git-version "5.0.3" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/opencog/atomspace")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0vxzhszb0z8081li38hid07a5axzxyflsmq1mcn4b1k4z1j8ggch"))))
      (build-system cmake-build-system)
      (arguments
       `(#:tests? #f            ; cxxtest binaries need a full test env
         #:configure-flags
         (list "-DCMAKE_BUILD_TYPE=Release"
               "-DWITH_GUILE=TRUE"
               "-DWITH_PYTHON=TRUE")))
      (inputs
       `(("boost" ,boost)
         ("cogutil" ,cogutil)
         ("gmp" ,gmp)
         ("guile" ,guile-3.0)
         ("postgresql" ,postgresql)))
      (native-inputs
       `(("cxxtest" ,cxxtest)
         ("python" ,python-minimal)
         ("pkg-config" ,pkg-config)))
      (home-page "https://github.com/opencog/atomspace/")
      (synopsis "OpenCog hypergraph database, query system and rule engine")
      (description
       "The OpenCog AtomSpace is an in-RAM knowledge representation (KR)
database, an associated query engine and graph-re-writing system, and a
rule-driven inferencing engine that can apply and manipulate sequences of
rules to perform reasoning.  It is a layer that sits on top of ordinary
distributed (graph) databases, providing a large variety of advanced features
not otherwise available.")
      (license agpl3))))

;; Return atomspace so `guix install -f atomspace.scm` installs this version.
atomspace
