;;; GNU Guix package definition for cogutil@2.0.3-1.b07b41b
;;;
;;; Install this exact OpenCog utilities revision with:
;;;
;;;   guix install -f cogutil.scm
;;;
;;; After this module is on GUIX_PACKAGE_PATH (or via `guix install -L .`):
;;;
;;;   guix install cogutil@2.0.3-1.b07b41b
;;;
;;; Source: https://github.com/opencog/cogutil @ b07b41b2eaf01627c78b27f1f28bb09ef7086f8e

(use-modules (guix packages)
             (guix git-download)
             (guix build-system cmake)
             (guix utils)
             (guix licenses)
             (gnu packages boost)
             (gnu packages check)
             (gnu packages pkg-config)
             (gnu packages python))

(define-public cogutil
  ;; The last release was in 2016.  Other OpenCog packages require a later
  ;; version.  git-version yields cogutil@2.0.3-1.b07b41b.
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

;; Return cogutil so `guix install -f cogutil.scm` installs this version.
cogutil
