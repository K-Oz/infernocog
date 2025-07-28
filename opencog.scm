;;; GNU Guix package definition for OpenCog stack integrated with InfernoCog
;;; This file provides the complete OpenCog cognitive architecture

(use-modules (guix packages)
             (guix download)
             (guix git-download)
             (guix build-system gnu)
             (guix build-system cmake)
             (guix build-system trivial)
             (guix licenses)
             (gnu packages)
             (gnu packages base)
             (gnu packages gcc)
             (gnu packages cmake)
             (gnu packages boost)
             (gnu packages python)
             (gnu packages python-xyz)
             (gnu packages pkg-config)
             (gnu packages tls)
             (gnu packages compression)
             (gnu packages databases)
             (gnu packages check)
             (gnu packages guile))

;; Define cxxtest for older Guix versions that might not have it
(define cxxtest
  (package
    (name "cxxtest")
    (version "4.4")
    (source #f)
    (build-system trivial-build-system)
    (arguments '(#:builder (mkdir %output)))
    (synopsis "Placeholder for CxxTest")
    (description "Placeholder package for CxxTest")
    (home-page "http://cxxtest.com/")
    (license lgpl3+)))

;;; CogUtil - Foundational utilities for OpenCog
(define-public cogutil
  (package
    (name "cogutil")
    (version "2.0.3-1.b07b41b")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/opencog/cogutil")
                    (commit "b07b41b")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       (list "-DCMAKE_BUILD_TYPE=Release"
             "-DCUNIT_FOUND=TRUE")
       #:tests? #f))  ; Tests require network access
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("boost" ,boost)
       ("cxxtest" ,cxxtest)))
    (synopsis "OpenCog utilities library")
    (description
     "CogUtil provides foundational utilities and data structures for the
OpenCog framework, including logging, configuration management, and basic
data structures.")
    (home-page "https://github.com/opencog/cogutil")
    (license lgpl2.1+)))

;;; AtomSpace - The hypergraph database
(define-public atomspace
  (package
    (name "atomspace")
    (version "5.0.3-1.86c848d")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/opencog/atomspace")
                    (commit "86c848d")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       (list "-DCMAKE_BUILD_TYPE=Release"
             "-DWITH_GUILE=TRUE"
             "-DWITH_PYTHON=TRUE")
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("cogutil" ,cogutil)
       ("boost" ,boost)
       ("guile" ,guile-3.0)
       ("python" ,python)
       ("cxxtest" ,cxxtest)))
    (synopsis "OpenCog hypergraph database")
    (description
     "AtomSpace is a hypergraph database for representing knowledge and
relationships in OpenCog.  It provides storage, indexing, and pattern
matching capabilities for cognitive processing.")
    (home-page "https://github.com/opencog/atomspace")
    (license lgpl2.1+)))

;;; CogServer - Network server for AtomSpace
(define-public cogserver
  (package
    (name "cogserver")
    (version "0-2.ec5f3b9")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/opencog/cogserver")
                    (commit "ec5f3b9")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       (list "-DCMAKE_BUILD_TYPE=Release")
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("atomspace" ,atomspace)
       ("cogutil" ,cogutil)
       ("boost" ,boost)
       ("cxxtest" ,cxxtest)))
    (synopsis "OpenCog network server")
    (description
     "CogServer provides network access to OpenCog AtomSpace through a
command-line interface and module system.  It enables distributed access
to cognitive knowledge bases.")
    (home-page "https://github.com/opencog/cogserver")
    (license lgpl2.1+)))

;;; Attention - Attention allocation mechanisms
(define-public attention
  (package
    (name "attention")
    (version "0-1.87d4367")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/opencog/attention")
                    (commit "87d4367")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       (list "-DCMAKE_BUILD_TYPE=Release")
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("atomspace" ,atomspace)
       ("cogutil" ,cogutil)
       ("boost" ,boost)
       ("cxxtest" ,cxxtest)))
    (synopsis "OpenCog attention allocation")
    (description
     "The attention package provides attention allocation mechanisms for
OpenCog, including economic attention networks and importance diffusion
algorithms for focusing cognitive resources.")
    (home-page "https://github.com/opencog/attention")
    (license lgpl2.1+)))

;;; OpenCog Core - Main reasoning engine
(define-public opencog-core
  (package
    (name "opencog")
    (version "0.1.4-1.ceac905")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/opencog/opencog")
                    (commit "ceac905")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       (list "-DCMAKE_BUILD_TYPE=Release"
             "-DWITH_GUILE=TRUE"
             "-DWITH_PYTHON=TRUE")
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("atomspace" ,atomspace)
       ("cogserver" ,cogserver)
       ("attention" ,attention)
       ("cogutil" ,cogutil)
       ("boost" ,boost)
       ("guile" ,guile-3.0)
       ("python" ,python)
       ("cxxtest" ,cxxtest)))
    (synopsis "OpenCog artificial general intelligence framework")
    (description
     "OpenCog is a framework for developing artificial general intelligence.
It combines symbolic reasoning, neural networks, evolutionary programming,
and other AI techniques in a unified cognitive architecture.")
    (home-page "https://github.com/opencog/opencog")
    (license lgpl2.1+)))

;;; AGI-Bio - Bioinformatics integration
(define-public agi-bio
  (package
    (name "agi-bio")
    (version "0-1.b5c6f3d")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/opencog/agi-bio")
                    (commit "b5c6f3d")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       (list "-DCMAKE_BUILD_TYPE=Release")
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("opencog" ,opencog-core)
       ("atomspace" ,atomspace)
       ("cogutil" ,cogutil)
       ("boost" ,boost)
       ("python" ,python)
       ("cxxtest" ,cxxtest)))
    (synopsis "OpenCog bioinformatics integration")
    (description
     "AGI-Bio provides bioinformatics and life sciences integration for
OpenCog, enabling AI reasoning about biological systems, genomics,
and molecular biology.")
    (home-page "https://github.com/opencog/agi-bio")
    (license lgpl2.1+)))

;;; InfernoCog - Inferno OS base for OpenCog (renamed from original)
(define-public infernocog
  (package
    (name "infernocog")
    (version "1.0.0")
    (source (local-file "." "inferno-source" #:recursive? #t
                        #:select? (lambda (file stat)
                                    (not (or (string-contains file ".git")
                                             (string-contains file "Linux/386"))))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f  ; No test suite
       #:make-flags (list (string-append "ROOT=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)  ; No configure script
         (add-before 'build 'setup-build-environment
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; Set up the build environment
               (setenv "ROOT" (getcwd))
               (setenv "SYSHOST" "Linux")
               (setenv "SYSTARG" "Linux")
               (setenv "OBJTYPE" "386")
               
               ;; Configure mkconfig for Linux build
               (substitute* "mkconfig"
                 (("ROOT=/usr/inferno") (string-append "ROOT=" (getcwd)))
                 (("SYSHOST=Plan9") "SYSHOST=Linux")
                 (("SYSTARG=\\$SYSHOST") "SYSTARG=Linux")
                 (("OBJTYPE=\\$objtype") "OBJTYPE=386"))
               
               ;; Remove 32-bit flags for compatibility with 64-bit systems
               (substitute* "mkfiles/mkfile-Linux-386"
                 (("-m32") ""))
               
               ;; Set up platform include directory
               (mkdir-p "Linux/386/include")
               (copy-recursively "include" "Linux/386/include")
               
               ;; Copy lib9.h from another platform as template
               (copy-file "Linux/power/include/lib9.h" "Linux/386/include/lib9.h")
               #t)))
         (replace 'build
           (lambda* (#:key make-flags #:allow-other-keys)
             ;; Build mk tool first
             (invoke "sh" "makemk.sh")
             
             ;; Add mk to PATH
             (setenv "PATH" (string-append (getcwd) "/Linux/386/bin:"
                                           (getenv "PATH")))
             
             ;; Build essential libraries only to avoid segfault issues
             (invoke "Linux/386/bin/mk" "lib9/install")
             (invoke "Linux/386/bin/mk" "libbio/install")
             (invoke "Linux/386/bin/mk" "libmp/install")
             (invoke "Linux/386/bin/mk" "libsec/install")
             (invoke "Linux/386/bin/mk" "libmath/install")
             (invoke "Linux/386/bin/mk" "utils/iyacc/install")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; Install binaries
               (when (file-exists? "Linux/386/bin")
                 (copy-recursively "Linux/386/bin" 
                                   (string-append out "/bin")))
               ;; Install libraries
               (when (file-exists? "Linux/386/lib")
                 (copy-recursively "Linux/386/lib"
                                   (string-append out "/lib")))
               ;; Install include files
               (copy-recursively "include"
                                 (string-append out "/include"))
               ;; Install platform include files
               (when (file-exists? "Linux/386/include")
                 (copy-recursively "Linux/386/include"
                                   (string-append out "/include/platform")))
               ;; Install man pages
               (when (file-exists? "man")
                 (copy-recursively "man"
                                   (string-append out "/share/man")))
               ;; Install documentation
               (mkdir-p (string-append out "/share/doc/infernocog"))
               (install-file "README.md" (string-append out "/share/doc/infernocog"))
               (install-file "INSTALL" (string-append out "/share/doc/infernocog"))
               (install-file "opencog.scm.md" (string-append out "/share/doc/infernocog"))
               (install-file "inferno.scm.md" (string-append out "/share/doc/infernocog"))
               (install-file "plan9.scm.md" (string-append out "/share/doc/infernocog"))
               #t))))))
    (native-inputs
     `(("gcc" ,gcc)))
    (inputs
     `(("fontconfig" ,fontconfig)
       ("freetype" ,freetype)))
    (synopsis "Inferno distributed operating system with OpenCog integration")
    (description
     "InfernoCog is a distributed operating system based on Inferno OS,
designed to support OpenCog cognitive architecture.  It provides the
essential libraries and tools for Inferno development, including the mk
build system and core libraries, optimized for AI workloads.")
    (home-page "https://github.com/K-Oz/infernocog")
    (license (list gpl2+ lgpl2.1+))))

;;; Complete OpenCog stack package
(define-public opencog-stack
  (package
    (name "opencog-stack")
    (version "1.0.0")
    (source #f)
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let ((out (assoc-ref %outputs "out")))
           (mkdir-p (string-append out "/share/doc"))
           (call-with-output-file (string-append out "/share/doc/opencog-stack.txt")
             (lambda (port)
               (display "OpenCog Stack - Complete cognitive architecture\n" port)
               (display "This meta-package installs the complete OpenCog stack.\n" port)))
           #t))))
    (propagated-inputs
     `(("infernocog" ,infernocog)
       ("cogutil" ,cogutil)
       ("atomspace" ,atomspace)
       ("cogserver" ,cogserver)
       ("attention" ,attention)
       ("opencog" ,opencog-core)
       ("agi-bio" ,agi-bio)))
    (synopsis "Complete OpenCog cognitive architecture stack")
    (description
     "This meta-package installs the complete OpenCog cognitive architecture
stack, including all core components and the InfernoCog distributed operating
system foundation.")
    (home-page "https://github.com/K-Oz/infernocog")
    (license lgpl2.1+)))

;; Return the stack for 'guix install -f opencog.scm'
opencog-stack