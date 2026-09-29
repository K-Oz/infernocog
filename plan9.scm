;;; GNU Guile architecture for Plan 9 principles in InfernoCog.
;;; Load with: guile -c '(load "plan9.scm")'
;;; Documentation: plan9.scm.md

;; Plan 9 resource model: files, namespaces, and protocols.
(define plan9-resources
  '((files
     (regular-files "/path/to/file")
     (devices "/dev/device")
     (network "/net/tcp")
     (processes "/proc/pid"))
    (namespaces
     (private-view "/private/namespace")
     (shared-view "/shared/namespace")
     (union-view "/union/namespace"))
    (protocols
     (9p "network file system")
     (styx "secure 9p variant"))))

(define file-operations
  '((read "cat /dev/time")
    (write "echo data > /dev/audio")
    (mount "mount /net/cs /n/cs")
    (bind "bind /tmp /n/tmp")
    (unmount "unmount /n/service")))

(define atomspace-filesystem
  '((/n/atomspace
     (atoms/
      (concept/
       (cat #f "ConceptNode")
       (dog #f "ConceptNode")
       (animal #f "ConceptNode"))
      (predicate/
       (isa #f "PredicateNode")
       (likes #f "PredicateNode"))
      (link/
       (inheritance/
        (cat-animal #f "InheritanceLink")
        (dog-animal #f "InheritanceLink"))
       (evaluation/
        (likes-cat #f "EvaluationLink"))))
     (queries/
      (ctl #f "query control")
      (pattern #f "pattern matcher")
      (results/ #f "query results"))
     (stats/
      (atom-count #f "total atoms")
      (memory-usage #f "memory statistics")
      (load-average #f "system load")))))

(define cogserver-service
  '((announcement
     (name "cogserver")
     (port "17001")
     (protocol "9p")
     (version "2000"))
    (filesystem
     (sessions/
      (new #f "create new session")
      (active/ #f "active sessions"))
     (modules/
      (python #f "Python bridge")
      (scheme #f "Scheme bridge")
      (c++ #f "C++ bridge"))
     (ctl #f "server control"))))

(define service-discovery
  '((cs-server "/net/cs")
    (dns-server "/net/dns")
    (opencog-registry "/net/opencog")
    (atomspace-services
     (local "tcp!localhost!17001")
     (cluster-1 "tcp!node1!17001")
     (cluster-2 "tcp!node2!17001"))))

(define process-communication
  '((pipes
     (unnamed-pipe "|")
     (named-pipe "/srv/cogpipe"))
    (channels
     (rendezvous "/srv/rendezvous")
     (synchronous "/srv/sync-chan")
     (asynchronous "/srv/async-chan"))
    (shared-memory
     (atomspace "/srv/atoms")
     (knowledge-base "/srv/kb"))))

(define private-namespace
  '((atomspace
     (personal "/n/personal-atoms")
     (working "/n/working-set")
     (cache "/n/atom-cache"))
    (services
     (local-cogserver "/n/cogserver")
     (reasoning "/n/reasoner")
     (learning "/n/learner"))
    (data
     (models "/n/models")
     (training "/n/training-data")
     (results "/n/results"))))

(define shared-resources
  '((global-atomspace "/srv/global-atoms")
    (knowledge-bases "/srv/knowledge")
    (reasoning-engines "/srv/reasoners")
    (learning-modules "/srv/learners")
    (bio-data "/srv/bio-knowledge")))

(define union-namespace
  '((combined-atomspace
     (layers
      (personal "/n/personal-atoms")
      (shared "/srv/global-atoms")
      (cached "/n/atom-cache"))
     (priority "personal > cached > shared"))
    (unified-knowledge
     (layers
      (local-kb "/n/local-knowledge")
      (bio-kb "/srv/bio-knowledge")
      (global-kb "/srv/global-knowledge"))
     (priority "local > bio > global"))))

(define opencog-processes
  '((reasoning-process
     (type "lightweight")
     (communication "channels")
     (shared-state "atomspace")
     (isolation "namespace"))
    (learning-process
     (type "lightweight")
     (communication "files")
     (shared-state "models")
     (isolation "namespace"))
    (bio-analysis-process
     (type "lightweight")
     (communication "9p")
     (shared-state "bio-data")
     (isolation "container"))))

(define message-patterns
  '((request-response
     (client-sends "/srv/request-chan")
     (server-responds "/srv/response-chan"))
    (publish-subscribe
     (publisher-sends "/srv/pub-chan")
     (subscribers-receive "/srv/sub-chan"))
    (pipeline
     (stage-1-output "/srv/pipe-1")
     (stage-2-input "/srv/pipe-1")
     (stage-2-output "/srv/pipe-2"))))

(define authentication
  '((user-auth
     (method "challenge-response")
     (credentials "/adm/users")
     (tickets "/srv/tickets"))
    (service-auth
     (method "capability-based")
     (capabilities "/adm/caps")
     (delegation "/srv/delegation"))))

(define authorization
  '((file-permissions
     (read "r")
     (write "w")
     (execute "x"))
    (namespace-access
     (owner "full-access")
     (group "read-access")
     (other "no-access"))
    (service-access
     (opencog-admin "full-control")
     (reasoning-user "query-only")
     (guest-user "read-only"))))

(define caching-strategy
  '((atom-cache
     (location "/n/atom-cache")
     (policy "LRU")
     (size "256MB"))
    (query-cache
     (location "/n/query-cache")
     (policy "frequency-based")
     (size "128MB"))
    (network-cache
     (location "/n/net-cache")
     (policy "temporal")
     (size "64MB"))))

(define load-balancing
  '((reasoning-distribution
     (strategy "round-robin")
     (nodes ("node1" "node2" "node3"))
     (health-check "/srv/health"))
    (atomspace-sharding
     (strategy "consistent-hashing")
     (partitions 16)
     (replication-factor 3))))

(define build-tools
  '((mk-files
     (atomspace "mkfile.atomspace")
     (cogserver "mkfile.cogserver")
     (reasoning "mkfile.reasoning"))
    (dependencies
     (lib9 "plan9-compat")
     (libbio "buffered-io")
     (libmath "mathematics"))
    (targets
     (libraries ".a files")
     (programs "executable files")
     (tests "test programs"))))

(define debugging-tools
  '((process-debugging
     (ps "/proc/ps")
     (trace "/proc/trace")
     (profile "/proc/profile"))
    (atomspace-debugging
     (dump "/n/atomspace/dump")
     (validate "/n/atomspace/validate")
     (statistics "/n/atomspace/stats"))
    (network-debugging
     (connections "/net/tcp")
     (packets "/net/ether")
     (protocols "/net/log"))))

(define plan9-principles
  '(everything-is-a-file
    9p-protocol
    namespaces
    lightweight-processes
    utf8-throughout))

(define (plan9-assoc-ref alist key)
  (let ((entry (assq key alist)))
    (cond
      ((not entry) #f)
      ((null? (cdr entry)) #f)
      ((null? (cddr entry)) (cadr entry))
      (else (cdr entry)))))

(define (plan9-resource-types)
  (map car plan9-resources))

(define (plan9-atomspace-root)
  (car (car atomspace-filesystem)))

(define (plan9-cogserver-announcement)
  (plan9-assoc-ref cogserver-service 'announcement))

(define (plan9-cogserver-field field)
  (plan9-assoc-ref (plan9-cogserver-announcement) field))

(define (plan9-architecture-ok?)
  "Return #t when the Plan 9 architecture tables are well-formed."
  (and (memq 'files (plan9-resource-types))
       (memq 'namespaces (plan9-resource-types))
       (memq 'protocols (plan9-resource-types))
       (eq? (plan9-atomspace-root) '/n/atomspace)
       (equal? (plan9-cogserver-field 'protocol) "9p")
       (equal? (plan9-cogserver-field 'port) "17001")
       (assq '9p (plan9-assoc-ref plan9-resources 'protocols))
       (assq 'global-atomspace shared-resources)
       (assq 'reasoning-process opencog-processes)
       #t))
