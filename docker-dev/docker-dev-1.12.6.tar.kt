 API built around the Process type:
	http://golang.org/pkg/os/#Process

The order of arguments to template.Execute has been reversed to be consistent
the notion of "destination first", as with io.Copy, fmt.Fprint, and others.

Gotest now works for package main in directories using Make.cmd-based makefiles.

The memory allocation runtime problems from the last release are not completely
fixed.  The virtual memory exhaustion problems encountered by people using
ulimit -v have been fixed, but there remain known garbage collector problems
when using GOMAXPROCS > 1.

Other changes:
* 5l: stopped generating 64-bit eor.
* 8l: more work on plan9 support (thanks Yuval Pavel Zholkover).
* archive/zip: handle files with data descriptors.
* arm: working peep-hole optimizer.
* asn1: marshal true as 255, not 1.
* buffer.go: minor optimization, expanded comment.
* build: drop syslog on DISABLE_NET_TESTS=1 (thanks Gustavo Niemeyer),
       allow clean.bash to work on fresh checkout,
       change "all tests pass" message to be more obvious,
       fix spaces in GOROOT (thanks Christopher Nielsen).
* bytes: fix bug in buffer.ReadBytes (thanks Evan Shaw).
* 5g: better int64 code,
       don't use MVN instruction.
* cgo: don't run cgo when not compiling (thanks Gustavo Niemeyer),
       fix _cgo_run timestamp file order (thanks Gustavo Niemeyer),
       fix handling of signed enumerations (thanks Gustavo Niemeyer),
       os/arch dependent #cgo directives (thanks Gustavo Niemeyer),
       rename internal f to avoid conflict with possible C global named f.
* codereview: fix hgpatch on windows (thanks Yasuhiro Matsumoto),
       record repository, base revision,
       use cmd.communicate (thanks Yasuhiro Matsumoto).
* container/ring: replace Iter() with Do().
* crypto/cipher: add resync open to OCFB mode.
* crypto/openpgp/armor: bug fixes.
* crypto/openpgp/packet: new subpackage.
* crypto/tls: load a chain of certificates from a file,
       select best cipher suite, not worst.
* crypto/x509: add support for name constraints.
* debug/pe: ImportedSymbols fixes (thanks Wei Guangjing).
* doc/code: update to reflect that package names need not be unique.
* doc/codelab/wiki: a bunch of fixes (thanks Andrey Mirtchovski).
* doc/install: update for new versions of Mercurial.
* encoding/line: fix line returned after EOF.
* flag: allow hexadecimal (0xFF) and octal (0377) input for integer flags.
* fmt.Scan: scan binary-exponent floating format, 2.4p-3,
       hexadecimal (0xFF) and octal (0377) integers.
* fmt: document %%; also %b for floating point.
* gc, ld: detect stale or incompatible object files,
       package name main no longer reserved.
* gc: correct receiver in method missing error (thanks Lorenzo Stoakes),
       correct rounding of denormal constants (thanks Eoghan Sherry),
       select receive bug fix.
* go/printer, gofmt: smarter handling of multi-line raw strings.
* go/printer: line comments must always end in a newline,
       remove notion of "Styler", remove HTML mode.
* gob: allow Decode(nil) and have it just discard the next value.
* godoc: use IsAbs to test for absolute paths (fix for win32) (thanks Yasuhiro Matsumoto),
       don't hide package lookup error if there's no command with the same name.
* gotest: enable unit tests for main programs.
* http: add Server type supporting timeouts,
       add pipelining to ClientConn, ServerConn (thanks Petar Maymounkov),
       handle unchunked, un-lengthed HTTP/1.1 responses.
* io: add RuneReader.
* json: correct Marshal documentation.
* netchan: graceful handling of closed connection (thanks Graham Miller).
* os: implement new Process API (thanks Alex Brainman).
* regexp tests: make some benchmarks more meaningful.
* regexp: add support for matching against text read from RuneReader interface.
* rpc: make more tolerant of errors, properly discard values (thanks Roger Peppe).
* runtime: detect failed thread creation on Windows,
       faster allocator, garbage collector,
       fix virtual memory exhaustion,
       implemented windows console ctrl handler (SIGINT) (thanks Hector Chu),
       more detailed panic traces, line number work,
       improved Windows callback handling (thanks Hector Chu).
* spec: adjust notion of Assignability,
       allow import of packages named main,
       clarification re: method sets of newly declared pointer types,
       fix a few typos (thanks Anthony Martin),
       fix Typeof() return type (thanks Gustavo Niemeyer),
       move to Unicode 6.0.
* sync: diagnose Unlock of unlocked Mutex,
       new Waitgroup type (thanks Gustavo Niemeyer).
* syscall: add SetsockoptIpMreq (thanks Dave Cheney),
       add sockaddr_dl, sysctl with routing message support for darwin, freebsd (thanks Mikio Hara),
       do not use NULL for zero-length read, write,
       implement windows version of Fsync (thanks Alex Brainman),
       make ForkExec acquire the ForkLock under windows (thanks Hector Chu),
       make windows API return errno instead of bool (thanks Alex Brainman),
       remove obsolete socket IO control (thanks Mikio Hara).
* template: add simple formatter chaining (thanks Kyle Consalus),
       allow a leading '*' to indirect through a pointer.
* testing: include elapsed time in test output
* windows: replace remaining __MINGW32__ instances with _WIN32 (thanks Joe Poirier).
</pre>

<h2 id="2011-02-01">2011-02-01</h2>

<pre>
This release includes significant changes to channel operations and minor
changes to the log package. Your code will require modification if it uses
channels in non-blocking communications or the log package's Exit functions.

Non-blocking channel operations have been removed from the language.
The equivalent operations have always been possible using a select statement
with a default clause.  If a default clause is present in a select, that clause
will execute (only) if no other is ready, which allows one to avoid blocking on
a communication.

For example, the old non-blocking send operation,

	if ch &lt;- v {
		// sent
	} else {
		// not sent
	}

should be rewritten as,

	select {
	case ch &lt;- v:
		// sent
	default:
		// not sent
	}

Similarly, this receive,

	v, ok := &lt;-ch
	if ok {
		// received
	} else {
		// not received
	}

should be rewritten as,

	select {
	case v := &lt;-ch:
		// received
	default:
		// not received
	}

This change is a prelude to redefining the 'comma-ok' syntax for a receive.
In a later release, a receive expression will return the received value and an
optional boolean indicating whether the channel has been closed. These changes
are being made in two stages to prevent this semantic change from silently
breaking code that uses 'comma-ok' with receives.
There are no plans to have a boolean expression form for sends.

Sends to a closed channel will panic immediately. Previously, an unspecified
number of sends would fail silently before causing a panic.

The log package's Exit, Exitf, and Exitln functions have been renamed Fatal,
Fatalf, and Fatalln respectively. This brings them in line with the naming of
the testing package. 

The port to the "tiny" operating system has been removed. It is unmaintained
and untested. It was a toy to show that Go can run on raw hardware and it
served its purpose. The source code will of course remain in the repository
history, so it could be brought back if needed later.

This release also changes some of the internal structure of the memory
allocator in preparation for other garbage collector changes. 
If you run into problems, please let us know.
There is one known issue that we are aware of but have not debugged yet:
	http://code.google.com/p/go/issues/detail?id=1464&amp;.

Other changes in this release:
* 5l: document -F, force it on old ARMs (software floating point emulation)
* 6g: fix registerization of temporaries (thanks Eoghan Sherry),
        fix uint64(uintptr(unsafe.Pointer(&amp;x))).
* 6l: Relocate CMOV* instructions (thanks Gustavo Niemeyer),
        windows/amd64 port (thanks Wei Guangjing).
* 8l: add PE dynexport, emit DWARF in Windows PE, and
        code generation fixes (thanks Wei Guangjing).
* bufio: make Flush a no-op when the buffer is empty.
* bytes: Add Buffer.ReadBytes, Buffer.ReadString (thanks Evan Shaw).
* cc: mode to generate go-code for types and variables.
* cgo: define CGO_CFLAGS and CGO_LDFLAGS in Go files (thanks Gustavo Niemeyer),
        windows/386 port (thanks Wei Guangjing).
* codereview: fix windows (thanks Hector Chu),
        handle file patterns better,
        more ASCII vs. Unicode nonsense.
* crypto/dsa: add support for DSA.
* crypto/openpgp: add s2k.
* crypto/rand: use defer to unlock mutex (thanks Anschel Schaffer-Cohen).
* crypto/rsa: correct docstring for SignPKCS1v15.
* crypto: add package, a common place to store identifiers for hash functions.
* doc/codelab/wiki: update to work with template changes, add to run.bash.
* doc/spec: clarify address operators.
* ebnflint: exit with non-zero status on error.
* encoding/base32: new package (thanks Miek Gieben).
* encoding/line: make it an io.Reader too.
* exec: use custom error for LookPath (thanks Gustavo Niemeyer).
* fmt/doc: define width and precision for strings.
* gc: clearer error for struct == struct,
        fix send precedence,
        handle invalid name in type switch,
        special case code for single-op blocking and non-blocking selects.
* go/scanner: fix build (adjust scanner EOF linecount).
* gob: better debugging, commentary,
        make nested interfaces work,
        report an error when encoding a non-empty struct with no public fields.
* godoc: full text index for whitelisted non-Go files,
        show line numbers for non-go files (bug fix).
* gofmt -r: match(...) arguments may be nil; add missing guards.
* govet: add Panic to the list of functions.
* http: add host patterns (thanks Jose Luis V√°zquez Gonz√°lez),
        follow relative redirect in Get.
* json: handle capital floating point exponent (1E100) (thanks Pieter Droogendijk).
* ld: add -I option to set ELF interpreter,
        more robust decoding of reflection type info in generating dwarf.
* lib9: update to Unicode 6.0.0.
* make.bash: stricter selinux test (don't complain unless it is enabled).
* misc/vim: Import/Drop commands (thanks Gustavo Niemeyer),
        set 'syntax sync' to a large value (thanks Yasuhiro Matsumoto).
* net: fix race condition in test,
        return cname in LookupHost.
* netchan: avoid race condition in test,
        fixed documentation for import (thanks Anschel Schaffer-Cohen).
* os: add ETIMEDOUT (thanks Albert Strasheim).
* runtime: generate Go defs for C types,
        implementation of callback functions for windows (thanks Alex Brainman),
        make Walk web browser example work (thanks Hector Chu),
        make select fairer,
        prefer fixed stack allocator over general memory allocator,
        simpler heap map, memory allocation.
* scanner: fix Position returned by Scan, Pos,
        don't read ahead in Init.
* suffixarray: use binary search for both ends of Lookup (thanks Eric Eisner).
* syscall: add missing network interface constants (thanks Mikio Hara).
* template: treat map keys as zero, not non-existent (thanks Roger Peppe).
* time: allow cancelling of After events (thanks Roger Peppe),
        support Solaris zoneinfo directory.
* token/position: added SetLinesForContent.
* unicode: update to unicode 6.0.0.
* unsafe: add missing case to doc for Pointer.
</pre>

<h2 id="2011-01-20">2011-01-20</h2>

<pre>
This release removes the float and complex types from the language.

The default type for a floating point literal is now float64, and
the default type for a complex literal is now complex128.

Existing code that uses float or complex must be rewritten to
use explicitly sized types.

The two-argument constructor cmplx is now spelled complex.
</pre>

<h2 id="2011-01-19">2011-01-19</h2>

<pre>
The 5g (ARM) compiler now has registerization enabled.  If you discover it
causes bugs, use 5g -N to disable the registerizer and please let us know.

The xml package now allows the extraction of nested XML tags by specifying
struct tags of the form "parent>child". See the XML documentation for an
example: http://golang.org/pkg/xml/

* 5a, 5l, 6a, 6l, 8a, 8l: handle out of memory, large allocations (thanks Jeff R. Allen).
* 8l: pe changes (thanks Alex Brainman).
* arm: fixes and improvements.
* cc: fix vlong condition.
* cgo: add complex float, complex double (thanks Sebastien Binet),
        in _cgo_main.c define all provided symbols as functions.
* codereview: don't mail change lists with no files (thanks Ryan Hitchman).
* crypto/cipher: add OFB mode.
* expvar: add Float.
* fmt: document %X of string, []byte.
* gc, runtime: make range on channel safe for multiple goroutines.
* gc: fix typed constant declarations (thanks Anthony Martin).
* go spec: adjust language for constant typing.
* go/scanner: Make Init take a *token.File instead of a *token.FileSet.
* godoc: bring back "indexing in progress" message,
        don't double HTML-escape search result snippets,
        enable qualified identifiers ("math.Sin") as query strings again,
        peephole optimization for generated HTML,
        remove tab before formatted section.
* gofmt, go/printer: do not insert extra line breaks where they may break the code.
* http: fix Content-Range and Content-Length in response (thanks Clement Skau),
        fix scheme-relative URL parsing; add ParseRequestURL,
        handle HEAD requests correctly,
        support for relative URLs.
* math: handle denormalized numbers in Frexp, Ilogb, Ldexp, and Logb (thanks Eoghan Sherry).
* net, syscall: return source address in Recvmsg (thanks Albert Strasheim).
* net: add LookupAddr (thanks Kyle Lemons),
        add unixpacket (thanks Albert Strasheim),
        avoid nil dereference if /etc/services can't be opened (thanks Corey Thomasson),
        implement windows timeout (thanks Wei Guangjing).
* netchan: do not block sends; implement flow control (thanks Roger Peppe).
* regexp: reject bare '?'. (thanks Ben Lynn)
* runtime/cgo: don't define crosscall2 in dummy _cgo_main.c.
* runtime/debug: new package for printing stack traces from a running goroutine.
* runtime: add per-pause gc stats,
        fix arm reflect.call boundary case,
        print signal information during panic.
* spec: specify that int and uint have the same size.
* syscall: correct WSTOPPED on OS X,
        correct length of GNU/Linux abstract Unix domain sockaddr,
        correct length of SockaddrUnix.
* tutorial: make stdin, stdout, stderr work on Windows.
* windows: implement exception handling (thanks Hector Chu).
</pre>

<h2 id="2011-01-12">2011-01-12</h2>

<pre>
The json, gob, and template packages have changed, and code that uses them
may need to be updated after this release. They will no longer read or write
unexported struct fields. When marshalling a struct with json or gob the
unexported fields will be silently ignored. Attempting to unmarshal json or
gob data into an unexported field will generate an error. Accessing an
unexported field from a template will cause the Execute function to return
an error.

Godoc now supports regular expression full text search, and this
functionality is now available on golang.org.

Other changes:
* arm: initial cut at arm optimizer.
* bytes.Buffer: Fix bug in UnreadByte.
* cgo: export unsafe.Pointer as void*, fix enum const conflict,
        output alignment fix (thanks Gustavo Niemeyer).
* crypto/block: mark as deprecated.
* crypto/openpgp: add error and armor.
* crypto: add twofish package (thanks Berengar Lehr).
* doc/spec: remove Maxalign from spec.
* encoding/line: new package for reading lines from an io.Reader.
* go/ast: correct end position for Index and TypeAssert expressions.
* gob: make (en|dec)code(Ui|I)nt methods rather than functions.
* godefs: better handling of enums.
* gofmt: don't attempt certain illegal rewrites,
        rewriter matches apply to expressions only.
* goinstall: preliminary support for cgo packages (thanks Gustavo Niemeyer).
* hg: add cgo/_cgo_* to .hgignore.
* http: fix text displayed in Redirect.
* ld: fix exported dynamic symbols on Mach-O,
        permit a Mach-O symbol to be exported in the dynamic symbol table.
* log: add methods for exit and panic.
* net: use closesocket api instead of CloseHandle on Windows (thanks Alex Brainman).
* netchan: make fields exported for gob change.
* os: add Sync to *File, wraps syscall.Fsync.
* runtime/cgo: Add callbacks to support SWIG.
* runtime: Restore scheduler stack position if cgo callback panics.
* suffixarray: faster creation algorithm (thanks Eric Eisner).
* syscall: fix mksysnum_linux.sh (thanks Anthony Martin).
* time.NewTicker: panic for intervals &lt;= 0.
* time: add AfterFunc to call a function after a duration (thanks Roger Peppe),
        fix tick accuracy when using multiple Tickers (thanks Eoghan Sherry).</pre>

<h2 id="2011-01-06">2011-01-06</h2>

<pre>
This release includes several fixes and changes:

* build: Make.pkg: use installed runtime.h for cgo.
* cgo: disallow use of C.errno.
* crypto/cipher: fix OCFB,
        make NewCBCEncrypter return BlockMode.
* doc: 6l: fix documentation of -L flag,
        add golanguage.ru to foreign-language doc list,
        effective go: explain the effect of repanicking better,
        update Effective Go for template API change,
        update contribution guidelines to prefix the change description.
* encoding/binary: reject types with implementation-dependent sizes (thanks Patrick Gavlin).
* exp/evalsimple fix handling of slices like s[:2] (thanks Sebastien Binet).
* fmt: made format string handling more efficient,
        normalize processing of format string.
* gc: return constant floats for parts of complex constants (thanks Anthony Martin),
        rewrite complex /= to l = l / r (thanks Patrick Gavlin),
        fix &amp;^=.
* go/ast: provide complete node text range info.
* gob: generate a better error message in one confusing place.
* godoc: fix godoc -src (thanks Icarus Sparry).
* goinstall: add -clean flag (thanks Kyle Lemons),
        add checkout concept (thanks Caine Tighe),
        fix -u for bzr (thanks Gustavo Niemeyer).
* http: permit empty Reason-Phrase in response Status-Line.
* io: fix Copyn EOF handling.
* net: fix close of Listener (thanks Michael Hoisie).
* regexp: fix performance bug, make anchored searches fail fast,
        fix prefix bug.
* runtime/cgo: fix stackguard on FreeBSD/amd64 (thanks Anthony Martin).
* strconv: atof: added 'E' as valid token for exponent (thanks Stefan Nilsson),
        update ftoa comment for 'E' and 'G'.
* strings: fix description of FieldsFunc (thanks Roger Peppe).
* syscall: correct Linux Splice definition,
        make Access second argument consistently uint32.
</pre>

<h2 id="2010-12-22">2010-12-22</h2>

<pre>
A small release this week. The most significant change is that some 
outstanding cgo issues were resolved.

* cgo: handle references to symbols in shared libraries.
* crypto/elliptic: add serialisation and key pair generation.
* crypto/hmac: add HMAC-SHA256 (thanks Anthony Martin).
* crypto/tls: add ECDHE support ("Elliptic Curve Diffie Hellman Ephemeral"),
        add support code for generating handshake scripts for testing.
* darwin, freebsd: ignore write failure (during print, panic).
* exp/draw: remove Border function.
* expvar: quote StringFunc output, same as String output.
* hash/crc64: fix typo in Sum.
* ld: allow relocations pointing at ELF .bss symbols, ignore stab symbols.
* misc/cgo/life: fix, add to build.
* regexp: add HasMeta, HasOperator, and String methods to Regexp.
* suffixarray: implemented FindAllIndex regexp search.
* test/bench: update numbers for regex-dna after speedup to regexp.
* time: explain the formats a little better.
</pre>

<h2 id="2010-12-15">2010-12-15</h2>

<pre>
Package crypto/cipher has been started, to replace crypto/block.
As part of the changes, rc4.Cipher's XORKeyStream method signature has changed from
        XORKeyStream(buf []byte)
to
        XORKeyStream(dst, src []byte)
to implement the cipher.Stream interface.  If you use crypto/block, you'll need
to switch to crypto/cipher once it is complete.

Package smtp's StartTLS now takes a *tls.Config argument.

Package reflect's ArrayCopy has been renamed to Copy.  There are new functions
Append and AppendSlice.

The print/println bootstrapping functions now write to standard error.
To write to standard output, use fmt.Print[ln].

A new tool, govet, has been added to the Go distribution. Govet is a static
checker for Go programs. At the moment, and for the foreseeable future,
it only checks arguments to print calls.

The cgo tool for writing Go bindings for C code has changed so that it no
longer uses stub .so files (like cgo_stdio.so).  Cgo-based packages using the
standard Makefiles should build without any changes.  Any alternate build
mechanisms will need to be updated.

The C and Go compilers (6g, 6c, 8g, 8c, 5g, 5c) now align structs according to
the maximum alignment of the fields they contain; previously they aligned
structs to word boundaries.  This may break non-cgo-based code that attempts to
mix C and Go.

NaCl support has been removed. The recent linker changes broke NaCl support
a month ago, and there are no known users of it.
If necessary, the NaCl code can be recovered from the repository history.

* 5g/8g, 8l, ld, prof: fix output of 32-bit values (thanks Eoghan Sherry).
* [68]l and runtime: GDB support for interfaces and goroutines.
* 6l, 8l: support for linking ELF and Mach-O .o files.
* all: simplify two-variable ranges with unused second variable (thanks Ryan Hitchman).
* arm: updated soft float support.
* codereview: keep quiet when not in use (thanks Eoghan Sherry).
* compress/flate: implement Flush, equivalent to zlib's Z_SYNC_FLUSH.
* crypto/tls: use rand.Reader in cert generation example (thanks Anthony Martin).
* dashboard: fix project tag filter.
* debug/elf, debug/macho: add ImportedLibraries, ImportedSymbols.
* doc/go_mem: goroutine exit is not special.
* event.go: another print glitch from gocheck.
* gc: bug fixes,
        syntax error for incomplete chan type (thanks Ryan Hitchman).
* go/ast: fix ast.Walk.
* gob: document the byte count used in the encoding of values,
        fix bug sending zero-length top-level slices and maps,
        Register should use the original type, not the indirected one.
* godashboard: support submitting projects with non-ascii names (thanks Ryan Hitchman)
* godefs: guard against structs with pad fields
* godoc: added textual search, to enable use -fulltext flag.
* gofmt: simplify "x, _ = range y" to "x = range y".
* gopack: allow ELF/Mach-O objects in .a files without clearing allobj.
* go/token,scanner: fix comments so godoc aligns properly.
* govet: on error continue to the next file (thanks Christopher Wedgwood).
* html: improved parsing.
* http: ServeFile handles Range header for partial requests.
* json: check for invalid UTF-8.
* ld: allow .o files with no symbols,
        reading of ELF object files,
        reading of Mach-O object files.
* math: change float64 bias constant from 1022 to 1023 (thanks Eoghan Sherry),
        rename the MinFloat constant to SmallestNonzeroFloat.
* nm: silently ignore .o files in .a files.
* os: fix test of RemoveAll.
* os/inotify: new package (thanks Balazs Lecz).
* os: make MkdirAll work with symlinks (thanks Ryan Hitchman).
* regexp: speed up by about 30%; also simplify code for brackets.
* runtime/linux/386: set FPU to 64-bit precision.
* runtime: remove paranoid mapping at 0.
* suffixarray: add Bytes function.
* syscall: add network interface constants for linux/386, linux/amd64 (thanks Mikio Hara).
* syscall/windows: restrict access rights param of OpenProcess(),
        remove \r and \n from error messages (thanks Alex Brainman).
* test/bench: fixes to timing.sh (thanks Anthony Martin).
* time: fix bug in Ticker: shutdown using channel rather than memory.
* token/position: provide FileSet.File, provide files iterator.
* xml: disallow invalid Unicode code points (thanks Nigel Kerr).
</pre>

<h2 id="2010-12-08">2010-12-08</h2>

<pre>
This release includes some package changes. If you use the crypto/tls or
go/parser packages your code may require changes.

The crypto/tls package's Dial function now takes an additional *Config
argument.  Most uses will pass nil to get the same default behavior as before.
See the documentation for details:
        http://golang.org/pkg/crypto/tls/#Config
        http://golang.org/pkg/crypto/tls/#Dial

The go/parser package's ParseFile function now takes a *token.FileSet as its
first argument. This is a pointer to a data structure used to store
position information. If you don't care about position information you
can pass "token.NewFileSet()". See the documentation for details:
        http://golang.org/pkg/go/parser/#ParseFile

This release also splits the patent grant text out of the LICENSE file into a
separate PATENTS file and changes it to be more like the WebM grant.
These clarifications were made at the request of the Fedora project.

Other changes:
* [68]l: generate debug info for builtin structured types, prettyprinting in gdb.
* 8l: add dynimport to import table in Windows PE (thanks Wei Guangjing).
* 8l, runtime: fix Plan 9 386 build (thanks Yuval Pavel Zholkover).
* all: fix broken calls to Printf etc.
* bufio: make Reader.Read implement io.Reader semantics (thanks Roger Peppe).
* build: allow archiver to be specified by HOST_AR (thanks Albert Strasheim).
* bytes: add Buffer.UnreadRune, Buffer.UnreadByte (thanks Roger Peppe).
* crypto/tls: fix build of certificate generation example (thanks Christian Himpel).
* doc/install: describe GOHOSTOS and GOHOSTARCH.
* errchk: accept multiple source files (thanks Eoghan Sherry).
* exec.LookPath: return os.PathError instad of os.ENOENT (thanks Michael Hoisie)..
* flag: fix format error in boolean error report,
        handle multiple calls to flag.Parse.
* fmt: add %U format for standard Unicode representation of code point values.
* gc: fix method offsets of anonymous interfaces (thanks Eoghan Sherry),
        skip undefined symbols in import . (thanks Eoghan Sherry).
* go/scanner: remove Tokenize - was only used in tests
* gobuilder: add buildroot command-line flag (thanks Devon H. O'Dell).
* html: unescape numeric entities (thanks Ryan Hitchman).
* http: Add EncodeQuery, helper for constructing query strings.
* ld: fix dwarf decoding of 64-bit reflect values (thanks Eoghan Sherry).
* math: improve accuracy of Exp2 (thanks Eoghan Sherry).
* runtime: add Goroutines (thanks Keith Rarick).
* sync: small naming fix for armv5 (thanks Dean Prichard).
* syscall, net: Add Recvmsg and Sendmsg on Linux (thanks Albert Strasheim).
* time: make After use fewer goroutines and host processes (thanks Roger Peppe).
</pre>

<h2 id="2010-12-02">2010-12-02</h2>

<pre>
Several package changes in this release may require you to update your code if
you use the bytes, template, or utf8 packages. In all cases, any outdated code
will fail to compile rather than behave erroneously.

The bytes package has changed. Its Add and AddByte functions have been removed,
as their functionality is provided by the recently-introduced built-in function
"append". Any code that uses them will need to be changed:
s = bytes.Add(s, b)    -&gt;    s = append(s, b...)
s = bytes.AddByte(b, c)    -&gt;    s = append(s, b)
s = bytes.Add(nil, c)    -&gt;    append([]byte(nil), c)

The template package has changed. Your code will need to be updated if it calls
the HTMLFormatter or StringFormatter functions, or implements its own formatter
functions. The function signature for formatter types has changed to:
        func(wr io.Writer, formatter string, data ...interface{})
to allow multiple arguments to the formatter.  No templates will need updating.
See the change for examples:
        http://code.google.com/p/go/source/detail?r=2c2be793120e

The template change permits the implementation of multi-word variable
instantiation for formatters. Before one could say
        {field}
or
        {field|formatter}
Now one can also say
        {field1 field2 field3}
or
        {field1 field2 field3|formatter}
and the fields are passed as successive arguments to the formatter,
by analogy to fmt.Print.

The utf8 package has changed. The order of EncodeRune's arguments has been
reversed to satisfy the convention of "destination first".
Any code that uses EncodeRune will need to be updated.

Other changes:
* [68]l: correct dwarf location for globals and ranges for arrays.
* big: fix (*Rat) SetFrac64(a, b) when b &lt; 0 (thanks Eoghan Sherry).
* compress/flate: fix typo in comment (thanks Mathieu Lonjaret).
* crypto/elliptic: use a Jacobian transform for better performance.
* doc/code.html: fix reference to "gomake build" (thanks Anschel Schaffer-Cohen).
* doc/roadmap: update gdb status.
* doc/spec: fixed some omissions and type errors.
* doc: some typo fixes (thanks Peter Mundy).
* exp/eval: build fix for parser.ParseFile API change (thanks Anschel Schaffer-Cohen).
* fmt: Scan accepts Inf and NaN,
        allow "% X" as well as "% x".
* go/printer: preserve newlines in func parameter lists (thanks Jamie Gennis).
* http: consume request body before next request.
* log: ensure writes are atomic (thanks Roger Peppe).
* path: Windows support for Split (thanks Benny Siegert).
* runtime: fix SysFree to really free memory on Windows (thanks Alex Brainman),
        parallel definitions in Go for all C structs.
* sort: avoid overflow in pivot calculation,
        reduced stack depth to lg(n) in quickSort (thanks Stefan Nilsson).
* strconv: Atof on Infs and NaNs.
</pre>

<h2 id="2010-11-23">2010-11-23</h2>

<pre>
This release includes a backwards-incompatible package change to the
sort.Search function (introduced in the last release).
See the change for details and examples of how you might change your code:
        http://code.google.com/p/go/source/detail?r=102866c369

* build: automatically #define _64BIT in 6c.
* cgo: print required space after parameter name in wrapper function.
* crypto/cipher: new package to replace crypto/block (thanks Adam Langley).
* crypto/elliptic: new package, implements elliptic curves over prime fields (thanks Adam Langley).
* crypto/x509: policy OID support and fixes (thanks Adam Langley).
* doc: add link to codewalks,
        fix recover() documentation (thanks Anschel Schaffer-Cohen),
        explain how to write Makefiles for commands.
* exec: enable more tests on windows (thanks Alex Brainman).
* gc: adjustable hash code in typecheck of composite literals
        (thanks to vskrap, Andrey Mirtchovski, and Eoghan Sherry).
* gc: better error message for bad type in channel send (thanks Anthony Martin).
* godoc: bug fix in relativePath,
        compute search index for all file systems under godoc's observation,
        use correct time stamp to indicate accuracy of search result.
* index/suffixarray: use sort.Search.
* net: add ReadFrom and WriteTo windows version (thanks Wei Guangjing).
* reflect: remove unnecessary casts in Get methods.
* rpc: add RegisterName to allow override of default type name.
* runtime: free memory allocated by windows CommandLineToArgv (thanks Alex Brainman).
* sort: simplify Search (thanks Roger Peppe).
* strings: add LastIndexAny (thanks Benny Siegert).
</pre>

<h2 id="2010-11-10">2010-11-10</h2>

<pre>
The birthday release includes a new Search capability inside the sort package.
It takes an unusual but very general and easy-to-use approach to searching
arbitrary indexable sorted data.  See the documentation for details:
    http://golang.org/pkg/sort/#Search

The ARM port now uses the hardware floating point unit (VFP).  It still has a
few bugs, mostly around conversions between unsigned integer and floating-point
values, but it's stabilizing.

In addition, there have been many smaller fixes and updates: 

* 6l: generate dwarf variable names with disambiguating suffix.
* container/list: make Remove return Value of removed element.
    makes it easier to remove first or last item.
* crypto: add cast5 (default PGP cipher),
    switch block cipher methods to be destination first.
* crypto/tls: use pool building for certificate checking
* go/ast: change embedded token.Position fields to named fields
    (preparation for a different position representation)
* net: provide public access to file descriptors (thanks Keith Rarick)
* os: add Expand function to evaluate environment variables.
* path: add Glob (thanks Benny Siegert)
* runtime: memequal optimization (thanks Graham Miller)
    prefix all external symbols with "runtime¬∑" to avoid
    conflicts linking with external C libraries.
</pre>

<h2 id="2010-11-02">2010-11-02</h2>

<pre>
This release includes a language change: the new built-in function, append.
Append makes growing slices much simpler. See the spec for details:
        http://golang.org/doc/go_spec.html#Appending_and_copying_slices

Other changes:
* 8l: pe generation fixes (thanks Alex Brainman).
* doc: Effective Go: append and a few words about "..." args.
* build: fiddle with make variables.
* codereview: fix sync and download in Python 2.7 (thanks Fazlul Shahriar).
* debug/pe, cgo: add windows support (thanks Wei Guangjing).
* go/ast: add Inspect function for easy AST inspection w/o a visitor.
* go/printer: do not remove parens around composite literals starting with
        a type name in control clauses.
* go/scanner: bug fixes, revisions, and more tests.
* gob: several fixes and documentation updates.
* godoc: bug fix (bug introduced with revision 3ee58453e961).
* gotest: print empty benchmark list in a way that gofmt will leave alone.
* http server: correctly respond with 304 NotModified (thanks Michael Hoisie).
* kate: update list of builtins (thanks Evan Shaw).
* libutf: update to Unicode 5.2.0 to match pkg/unicode (thanks Anthony Martin).
* misc/bbedit: update list of builtins (thanks Anthony Starks).
* misc/vim: update list of builtins.
* mkrunetype: install a Makefile and tweak it slightly so it can be built.
* netchan: fix locking bug.
* pidigits: minor improvements (thanks Evan Shaw).
* rpc: fix client deadlock bug.
* src: use append where appropriate (often instead of vector).
* strings: add Contains helper function (thanks Brad Fitzpatrick).
* syscall: SIO constants for Linux (thanks Albert Strasheim),
        Stat(path) on windows (thanks Alex Brainman).
* test/ken/convert.go: add conversion torture test.
* testing: add Benchmark (thanks Roger Peppe).
</pre>

<h2 id="2010-10-27">2010-10-27</h2>

<pre>
*** This release changes the encoding used by package gob. 
    If you store gobs on disk, see below. ***

The ARM port (5g) now passes all tests. The optimizer is not yet enabled, and
floating point arithmetic is performed entirely in software. Work is underway
to address both of these deficiencies.

The syntax for arrays, slices, and maps of composite literals has been
simplified. Within a composite literal of array, slice, or map type, elements
that are themselves composite literals may elide the type if it is identical to
the outer literal's element type. For example, these expressions:
	[][]int{[]int{1, 2, 3}, []int{4, 5}}
	map[string]Point{"x": Point{1.5, -3.5}, "y": Point{0, 0}}
can be simplified to:
	[][]int{{1, 2, 3}, {4, 5}}
	map[string]Point{"x": {1.5, -3.5}, "y": {0, 0}}
Gofmt can make these simplifications mechanically when invoked with the 
new -s flag.

The built-in copy function can now copy bytes from a string value to a []byte.
Code like this (for []byte b and string s): 
	for i := 0; i &lt; len(s); i++ {
		b[i] = s[i]
	}
can be rewritten as:
	copy(b, s)

The gob package can now encode and decode interface values containing types
registered ahead of time with the new Register function. These changes required
a backwards-incompatible change to the wire format.  Data written with the old
version of the package will not be readable with the new one, and vice versa.
(Steps were made in this change to make sure this doesn't happen again.) 
We don't know of anyone using gobs to create permanent data, but if you do this
and need help converting, please let us know, and do not update to this release
yet.  We will help you convert your data.

Other changes:
* 5g, 6g, 8g: generate code for string index instead of calling function.
* 5l, 6l, 8l: introduce sub-symbols.
* 6l/8l: global and local variables and type info.
* Make.inc: delete unnecessary -fno-inline flag to quietgcc.
* arm: precise float64 software floating point, bug fixes.
* big: arm assembly, faster software mulWW, divWW.
* build: only print "You need to add foo to PATH" when needed.
* container/list: fix Remove bug and use pointer to self as identifier.
* doc: show page title in browser title bar,
        update roadmap.
* encoding/binary: give LittleEndian, BigEndian specific types.
* go/parser: consume auto-inserted semi when calling ParseExpr().
* gobuilder: pass GOHOSTOS and GOHOSTARCH to build,
        write build and benchmarking logs to disk.
* goinstall: display helpful message when encountering a cgo package,
        fix test for multiple package names (thanks Fazlul Shahriar).
* gotest: generate correct gofmt-formatted _testmain.go.
* image/png: speed up paletted encoding ~25% (thanks Brad Fitzpatrick).
* misc: update python scripts to specify python2 as python3 is now "python".
* net: fix comment on Dial to mention unix/unixgram.
* rpc: expose Server type to allow multiple RPC Server instances.
* runtime: print unknown types in panic.
* spec: append built-in (not yet implemented).
* src: gofmt -s -w src misc.
        update code to use copy-from-string.
* test/bench: update numbers.
* websocket: fix short Read.
</pre>

<h2 id="2010-10-20">2010-10-20</h2>

<pre>
This release removes the log package's deprecated functions.
Code that has not been updated to use the new interface will break.
See the previous release notes for details:
	http://golang.org/doc/devel/release.html#2010-10-13

Also included are major improvements to the linker. It is now faster, 
uses less memory, and more parallelizable (but not yet parallel).

The nntp package has been removed from the standard library.
Its new home is the nntp-go project at Google Code:
	http://code.google.com/p/nntp-go
You can install it with goinstall:
	goinstall nntp-go.googlecode.com/hg/nntp
And import it in your code like so:
	import "nntp-go.googlecode.com/hg/nntp"

Other changes:
* 6g: avoid too-large immediate constants.
* 8l, runtime: initial support for Plan 9 (thanks Yuval Pavel Zholkover).
* 6l, 8l: more improvements on exporting debug information (DWARF).
* arm: code gen fixes. Most tests now pass, except for floating point code.
* big: add random number generation (thanks Florian Uekermann).
* gc: keep track of real actual type of identifiers,
	report that shift must be unsigned integer,
	select receive with implicit conversion.
* goplay: fix to run under windows (thanks Yasuhiro Matsumoto).
* http: do not close connection after sending HTTP/1.0 request.
* netchan: add new method Hangup to terminate transmission on a channel.
* os: change TestForkExec so it can run on windows (thanks Yasuhiro Matsumoto).
* runtime: don't let select split stack.
* syscall/arm: correct 64-bit system call arguments.
</pre>

<h2 id="2010-10-13">2010-10-13</h2>

<pre>
This release includes changes to the log package, the removal of exp/iterable,
two new tools (gotry and goplay), one small language change, and many other
changes and fixes.  If you use the log or iterable packages, you need to make
changes to your code.

The log package has changed.  Loggers now have only one output, and output to
standard error by default.  The names have also changed, although the old names
are still supported.  They will be deleted in the next release, though, so it
would be good to update now if you can.  For most purposes all you need to do
is make these substitutions:
        log.Stderr -&gt; log.Println or log.Print
        log.Stderrf -&gt; log.Printf
        log.Crash -&gt; log.Panicln or log.Panic
        log.Crashf -&gt; log.Panicf
        log.Exit -&gt; log.Exitln or log.Exit
        log.Exitf -&gt; log.Exitf (no change)
Calls to log.New() must drop the second argument.
Also, custom loggers with exit or panic properties will need to be reworked.
For full details, see the change description:
        http://code.google.com/p/go/source/detail?r=d8a3c7563d

The language change is that uses of pointers to interface values no longer
automatically dereference the pointer.  A pointer to an interface value is more
often a beginner's bug than correct code.

The package exp/iterable has been removed. It was an interesting experiment,
but it encourages writing inefficient code and has outlived its utility.

The new tools:
* gotry: an exercise in reflection and an unusual tool. Run 'gotry' for details.
* goplay: a stand-alone version of the Go Playground. See misc/goplay.

Other changes:
* 6l: Mach-O fixes, and fix to work with OS X nm/otool (thanks Jim McGrath).
* [568]a: correct line numbers for statements.
* arm: code generation and runtime fixes,
	adjust recover for new reflect.call,
	enable 6 more tests after net fix.
* big: fix panic and round correctly in Rat.FloatString (thanks Anthony Martin).
* build: Make.cmd: remove $(OFILES) (thanks Eric Clark),
        Make.pkg: remove .so before installing new one,
        add GOHOSTOS and GOHOSTARCH environment variables.
* crypto/tls: better error messages for certificate issues,
        make SetReadTimeout work.
* doc: add Sydney University video,
	add The Expressiveness of Go talk.
* exp/draw/x11: support X11 vendors other than "The X.Org Foundation".
* expvar: add (*Int).Set (thanks Sam Thorogood).
* fmt: add Errorf helper function,
        allow %d on []byte.
* gc: O(1) string comparison when lengths differ,
        various bug fixes.
* http: return the correct error if a header line is too long.
* image: add image.Tiled type, the Go equivalent of Plan 9's repl bit.
* ld: be less picky about bad line number info.
* misc/cgo/life: fix for new slice rules (thanks Graham Miller).
* net: allow _ in DNS names.
* netchan: export before import when testing, and
        zero out request to ensure correct gob decoding. (thanks Roger Peppe).
* os: make tests work on windows (thanks Alex Brainman).
* runtime: bug fix: serialize mcache allocation,
        correct iteration of large map values,
        faster strequal, memequal (thanks Graham Miller),
        fix argument dump in traceback,
        fix tiny build.
* smtp: new package (thanks Evan Shaw).
* syscall: add sockaddr_ll support for linux/386, linux/amd64 (thanks Mikio Hara),
        add ucred structure for SCM_CREDENTIALS over UNIX sockets. (thanks Albert Strasheim).
* syscall: implement WaitStatus and Wait4() for windows (thanks Wei Guangjing).
* time: add After.
* websocket: enable tests on windows (thanks Alex Brainman).
</pre>

<h2 id="2010-09-29">2010-09-29</h2>

<pre>
This release includes some minor language changes and some significant package
changes. You may need to change your code if you use ...T parameters or the
http package.

The semantics and syntax of forwarding ...T parameters have changed.
        func message(f string, s ...interface{}) { fmt.Printf(f, s) }
Here, s has type []interface{} and contains the parameters passed to message.
Before this language change, the compiler recognized when a function call
passed a ... parameter to another ... parameter of the same type, and just
passed it as though it was a list of arguments.  But this meant that you
couldn't control whether to pass the slice as a single argument and you
couldn't pass a regular slice as a ... parameter, which can be handy.  This
change gives you that control at the cost of a few characters in the call.
If you want the promotion to ...,  append ... to the argument:
        func message(f string, s ...interface{}) { fmt.Printf(f, s...) }
Without the ..., s would be passed to Printf as a single argument of type
[]interface{}.  The bad news is you might need to fix up some of your code, 
but the compiler will detect the situation and warn you.

Also, the http.Handler and http.HandlerFunc types have changed. Where http
handler functions previously accepted an *http.Conn, they now take an interface
type http.ResponseWriter. ResponseWriter implements the same methods as *Conn,
so in most cases the only change required will be changing the type signature
of your handler function's first parameter. See:
  http://golang.org/pkg/http/#Handler

The utf8 package has a new type, String, that provides efficient indexing 
into utf8 strings by rune (previously an expensive conversion to []int 
was required). See:
  http://golang.org/pkg/utf8/#String

The compiler will now automatically insert a semicolon at the end of a file if
one is not found. This effect of this is that Go source files are no longer
required to have a trailing newline.

Other changes:
* 6prof: more accurate usage message.
* archive/zip: new package for reading Zip files.
* arm: fix code generation, 10 more package tests pass.
* asn1: make interface consistent with json.
* bufio.UnreadRune: fix bug at EOF.
* build: clear custom variables like GREP_OPTIONS,
        silence warnings generated by ubuntu gcc,
        use full path when compiling libraries.
* bytes, strings: change lastIndexFunc to use DecodeLastRune (thanks Roger Peppe).
* doc: add to and consolidate non-english doc references,
        consolidate FAQs into a single file, go_faq.html,
        updates for new http interface.
* fmt/Printf: document and tweak error messages produced for bad formats.
* gc: allow select case expr = &lt;-c,
        eliminate duplicates in method table,
        fix reflect table method receiver,
        improve error message for x \= 0.
* go/scanner: treat EOF like a newline for purposes of semicolon insertion.
* gofmt: stability improvements.
* gotest: leave _testmain.go for "make clean" to clean up.
* http: correct escaping of different parts of URL,
        support HTTP/1.0 Keep-Alive.
* json: do not write to unexported fields.
* libcgo: don't build for NaCl,
        set g, m in thread local storage for windows 386 (thanks Wei Guangjing).
* math: Fix off-by-one error in Ilogb and Logb.  (thanks Charles L. Dorian).
* misc/dashboard/builder: remove build files after benchmarking.
* nacl: update instructions for new SDK.
* net: enable v4-over-v6 on ip sockets,
        fix crash in DialIP.
* os: check for valid arguments in windows Readdir (thanks Peter Mundy).
* runtime: add mmap of null page just in case,
        correct stats in SysFree,
        fix unwindstack crash.
* syscall: add IPPROTO_IPV6 and IPV6_V6ONLY const to fix nacl and windows build,
        add inotify on Linux (thanks Balazs Lecz),
        fix socketpair in syscall_bsd,
        fix windows value of IPV6_V6ONLY (thanks Alex Brainman),
        implement windows version of Utimes (thanks Alex Brainman),
        make mkall.sh work for nacl.
* test: Add test that causes incorrect error from gccgo.
* utf8: add DecodeLastRune and DecodeLastRuneInString (thanks Roger Peppe).
* xml: Allow entities inside CDATA tags (thanks Dan Sinclair).
</pre>

<h2 id="2010-09-22">2010-09-22</h2>

<pre>
This release includes new package functionality, and many bug fixes and changes.
It also improves support for the arm and nacl platforms.

* 5l: avoid fixed buffers in list.
* 6l, 8l: clean up ELF code, fix NaCl.
* 6l/8l: emit DWARF frame info.
* Make.inc: make GOOS detection work on windows (thanks Alex Brainman).
* build: fixes for native arn build,
        make all.bash run on Ubuntu ARM.
* cgo: bug fixes,
        show preamble gcc errors (thanks Eric Clark).
* crypto/x509, crypto/tls: improve root matching and observe CA flag.
* crypto: Fix certificate validation.
* doc: variable-width layout.
* env.bash: fix building in directory with spaces in the path (thanks Alex Brainman).
* exp/4s, exp/nacl/av: sync to recent exp/draw changes.
* exp/draw/x11: mouse location is a signed integer.
* exp/nacl/av: update color to max out at 1&lt;&lt;16-1 instead of 1&lt;&lt;32-1.
* fmt: support '*' for width or precision (thanks Anthony Martin).
* gc: improvements to static initialization,
        make sure path names are canonical.
* gob: make robust when decoding a struct with non-struct data.
* gobuilder: add -cmd for user-specified build command,
        add -rev= flag to build specific revision and exit,
        fix bug that caused old revisions to be rebuilt.
* godoc: change default filter file name to "",
        don't use quadratic algorithm to filter paths,
        show "Last update" info for directory listings.
* http: new redirect test,
        URLEscape now escapes all reserved characters as per the RFC.
* nacl: fix zero-length writes.
* net/dict: parse response correctly (thanks Fazlul Shahriar).
* netchan: add a cross-connect test,
        handle closing of channels,
        provide a method (Importer.Errors()) to recover protocol errors.
* os: make Open() O_APPEND flag work on windows (thanks Alex Brainman),
        make RemoveAll() work on windows (thanks Alex Brainman).
* pkg/Makefile: disable netchan test to fix windows build (thanks Alex Brainman).
* regexp: delete Iter methods.
* runtime: better panic for send to nil channel.
* strings: fix minor bug in LastIndexFunc (thanks Roger Peppe).
* suffixarray: a package for creating suffixarray-based indexes.
* syscall: Use vsyscall for syscall.Gettimeofday and .Time on linux amd64.
* test: fix NaCl build.
* windows: fix netchan test by using 127.0.0.1.
</pre>

<h2 id="2010-09-15">2010-09-15</h2>

<pre>
This release includes a language change: the lower bound of a subslice may
now be omitted, in which case the value will default to 0.
For example, s[0:10] may now be written as s[:10], and s[0:] as s[:].

The release also includes important bug fixes for the ARM architecture,
as well as the following fixes and changes:

* 5g: register allocation bugs
* 6c, 8c: show line numbers in -S output
* 6g, 6l, 8g, 8l: move read-only data to text segment
* 6l, 8l: make etext accurate; introduce rodata, erodata.
* arm: fix build bugs.
        make libcgo build during OS X cross-compile
        remove reference to deleted file syntax/slice.go
        use the correct stat syscalls
        work around reg allocator bug in 5g
* bufio: add UnreadRune.
* build: avoid bad environment interactions
        fix build for tiny
        generate, clean .exe files on Windows (thanks Joe Poirier)
        test for _WIN32, not _MINGW32 (thanks Joe Poirier)
        work with GNU Make 3.82 (thanks Jukka-Pekka Kekkonen)
* cgo: add typedef for uintptr in generated headers
        silence warning for C call returning const pointer
* codereview: convert email address to lower case before checking CONTRIBUTORS
* crypto/tls: don't return an error from Close()
* doc/tutorial: update for slice changes.
* exec: separate LookPath implementations for unix/windows (thanks Joe Poirier)
* exp/draw/x11: allow clean shutdown when the user closes the window.
* exp/draw: clip destination rectangle to the image bounds.
        fast path for drawing overlapping image.RGBAs.
        fix double-counting of pt.Min for the src and mask points.
        reintroduce the MouseEvent.Nsec timestamp.
        rename Context to Window, and add a Close method.
* exp/debug: preliminary support for 'copy' function (thanks Sebastien Binet)
* fmt.Fscan: use UnreadRune to preserve data across calls.
* gc: better printing of named constants, func literals in errors
        many bug fixes
        fix line number printing with //line directives
        fix symbol table generation on windows (thanks Alex Brainman)
        implement comparison rule from spec change 33abb649cb63
        implement new slice spec (thanks Scott Lawrence)
        make string x + y + z + ... + w efficient
        more accurate line numbers for ATEXT
        remove &amp;[10]int -&gt; []int conversion
* go-mode.el: fix highlighting for 'chan' type (thanks Scott Lawrence)
* godoc: better support for directory trees for user-supplied paths
        use correct delay time (bug fix)
* gofmt, go/printer: update internal estimated position correctly
* goinstall: warn when package name starts with http:// (thanks Scott Lawrence)
* http: check https certificate against host name
        do not cache CanonicalHeaderKey (thanks Jukka-Pekka Kekkonen)
* image: change a ColorImage's minimum point from (0, 0) to (-1e9, -1e9).
        introduce Intersect and Union rectangle methods.
* ld: handle quoted spaces in package path (thanks Dan Sinclair)
* libcgo: fix NaCl build.
* libmach: fix build on arm host
        fix new thread race with Linux
* math: make portable Tan(Pi/2) return NaN
* misc/dashboard/builder: gobuilder, a continuous build client
* net: disable tests for functions not available on windows (thanks Alex Brainman)
* netchan: make -1 unlimited, as advertised.
* os, exec: rename argv0 to name
* path: add IsAbs (thanks Ivan Krasin)
* runtime: fix bug in tracebacks
        fix crash trace on amd64
        fix windows build (thanks Alex Brainman)
        use manual stack for garbage collection
* spec: add examples for slices with omitted index expressions.
        allow omission of low slice bound (thanks Scott Lawrence)
* syscall: fix windows Gettimeofday (thanks Alex Brainman)
* test(arm): disable zerodivide.go because compilation fails.
* test(windows): disable tests that cause the build to fail (thanks Joe Poirier)
* test/garbage/parser: sync with recent parser changes
* test: Add test for //line
        Make gccgo believe that the variables can change.
        Recognize gccgo error messages.
        Reduce race conditions in chan/nonblock.go.
        Run garbage collector before testing malloc numbers.
* websocket: Add support for secure WebSockets (thanks Jukka-Pekka Kekkonen)
* windows: disable unimplemented tests (thanks Joe Poirier)
</pre>

<h2 id="2010-09-06">2010-09-06</h2>

<pre>
This release includes the syntactic modernization of more than 100 files in /test,
and these additions, changes, and fixes: 
* 6l/8l: emit DWARF in macho.
* 8g: use FCHS, not FMUL, for minus float.
* 8l: emit DWARF in ELF,
        suppress emitting DWARF in Windows PE (thanks Alex Brainman).
* big: added RatString, some simplifications.
* build: create bin and pkg directories as needed; drop from hg,
        delete Make.386 Make.amd64 Make.arm (obsoleted by Make.inc),
        fix cgo with -j2,
        let pkg/Makefile coordinate building of Go commands,
        never use quietgcc in Make.pkg,
        remove more references to GOBIN and GOROOT (thanks Christian Himpel).
* codereview: Fix uploading for Mercurial 1.6.3 (thanks Evan Shaw),
        consistent indent, cut dead code,
        fix hang on standard hg commands,
        print status when tasks take longer than 30 seconds,
        really disable codereview when not available,
        upload files in parallel (5x improvement on large CLs).
* crypto/hmac: make Sum idempotent (thanks Jukka-Pekka Kekkonen).
* doc: add links to more German docs,
        add round-robin flag to io2010 balance example,
        fix a bug in the example in Constants subsection (thanks James Fysh),
        various changes for validating HTML (thanks Scott Lawrence).
* fmt: delete erroneous sentence about return value for Sprint*.
* gc: appease bison version running on FreeBSD builder,
        fix spurious syntax error.
* go/doc: use correct escaper for URL.
* go/printer: align ImportPaths in ImportDecls (thanks Scott Lawrence).
* go/typechecker: 2nd step towards augmenting AST with full type information.
* gofmt: permit omission of first index in slice expression.
* goinstall: added -a flag to mean "all remote packages" (thanks Scott Lawrence),
        assume go binaries are in path (following new convention),
        use https for Google Code checkouts.
* gotest: allow make test of cgo packages (without make install).
* http: add Date to server, Last-Modified and If-Modified-Since to file server,
        add PostForm function to post url-encoded key/value data,
        obscure passwords in return value of URL.String (thanks Scott Lawrence).
* image: introduce Config type and DecodeConfig function.
* libcgo: update Makefile to use Make.inc.
* list: update comment to state that the zero value is ready to use.
* math: amd64 version of Sincos (thanks Charles L. Dorian).
* misc/bash: add *.go completion for gofmt (thanks Scott Lawrence).
* misc/emacs: make _ a word symbol (thanks Scott Lawrence).
* misc: add zsh completion (using compctl),
        syntax highlighting for Fraise.app (OS X) (thanks Vincent Ambo).
* net/textproto: Handle multi-line responses (thanks Evan Shaw).
* net: add LookupMX (thanks Corey Thomasson).
* netchan: Fix race condition in test,
        rather than 0, make -1 mean infinite (a la strings.Split et al),
        use acknowledgements on export send.
        new methods Sync and Drain for clean teardown.
* regexp: interpret all Go characer escapes \a \b \f \n \r \t \v.
* rpc: fix bug that caused private methods to attempt to be registered.
* runtime: Correct commonType.kind values to match compiler,
        add GOOS, GOARCH; fix FuncLine,
        special case copy, equal for one-word interface values (thanks Kyle Consalus).
* scanner: fix incorrect reporting of error in Next (thanks Kyle Consalus).
* spec: clarify that arrays must be addressable to be sliceable.
* template: fix space handling around actions.
* test/solitaire: an exercise in backtracking and string conversions.
* test: Recognize gccgo error messages and other fixes.
* time: do not crash in String on nil Time.
* tutorial: regenerate HTML to pick up change to progs/file.go.
* websocket: fix missing Sec-WebSocket-Protocol on server response (thanks Jukka-Pekka Kekkonen).
</pre>

<h2 id="2010-08-25">2010-08-25</h2>

<pre>
This release includes changes to the build system that will likely require you
to make changes to your environment variables and Makefiles.

All environment variables are now optional:
 - $GOOS and $GOARCH are now optional; their values should now be inferred 
   automatically by the build system,
 - $GOROOT is now optional, but if you choose not to set it you must run
   'gomake' instead of 'make' or 'gmake' when developing Go programs
   using the conventional Makefiles,
 - $GOBIN remains optional and now defaults to $GOROOT/bin;
   if you wish to use this new default, make sure it is in your $PATH
   and that you have removed the existing binaries from $HOME/bin.

As a result of these changes, the Go Makefiles have changed. If your Makefiles
inherit from the Go Makefiles, you must change this line:
    include ../../Make.$(GOARCH)
to this:
    include ../../Make.inc

This release also removes the deprecated functions in regexp and the 
once package. Any code that still uses them will break.
See the notes from the last release for details:
    http://golang.org/doc/devel/release.html#2010-08-11

Other changes:
* 6g: better registerization for slices, strings, interface values
* 6l: line number information in DWARF format
* build: $GOBIN defaults to $GOROOT/bin,
        no required environment variables
* cgo: add C.GoStringN (thanks Eric Clark).
* codereview: fix issues with leading tabs in CL descriptions,
        do not send "Abandoned" mail if the CL has not been mailed.
* crypto/ocsp: add missing Makefile.
* crypto/tls: client certificate support (thanks Mikkel Krautz).
* doc: update gccgo information for recent changes.
        fix errors in Effective Go.
* fmt/print: give %p priority, analogous to %T,
        honor Formatter in Print, Println.
* gc: fix parenthesization check.
* go/ast: facility for printing AST nodes,
        first step towards augmenting AST with full type information.
* go/printer: do not modify tabwriter.Escape'd text.
* gofmt: do not modify multi-line string literals,
        print AST nodes by setting -ast flag.
* http: fix typo in http.Request documentation (thanks Scott Lawrence)
        parse query string always, not just in GET
* image/png: support 16-bit color.
* io: ReadAtLeast now errors if min > len(buf).
* jsonrpc: use `error: null` for success, not `error: ""`.
* libmach: implement register fetch for 32-bit x86 kernel.
* net: make IPv6 String method standards-compliant (thanks Mikio Hara).
* os: FileInfo.Permission() now returns uint32 (thanks Scott Lawrence),
        implement env using native Windows API (thanks Alex Brainman).
* reflect: allow PtrValue.PointTo(nil).
* runtime: correct line numbers for .goc files,
        fix another stack split bug,
        fix freebsd/386 mmap.
* syscall: regenerate syscall/z* files for linux/386, linux/amd64, linux/arm.
* tabwriter: Introduce a new flag StripEscape.
* template: fix handling of space around actions,
        vars preceded by white space parse correctly (thanks Roger Peppe).
* test: add test case that crashes gccgo.
* time: parse no longer requires minutes for time zone (thanks Jan H. Hosang)
* yacc: fix bounds check in error recovery.
</pre>

<h2 id="2010-08-11">2010-08-11</h2>

<pre>
This release introduces some package changes. You may need to change your
code if you use the once, regexp, image, or exp/draw packages.

The type Once has been added to the sync package. The new sync.Once will
supersede the functionality provided by the once package. We intend to remove
the once package after this release. See:
    http://golang.org/pkg/sync/#Once
All instances of once in the standard library have been replaced with
sync.Once. Reviewing these changes may help you modify your existing code. 
The relevant changeset:
    http://code.google.com/p/go/source/detail?r=fa2c43595119

A new set of methods has been added to the regular expression package, regexp.
These provide a uniformly named approach to discovering the matches of an
expression within a piece of text; see the package documentation for details: 
    http://golang.org/pkg/regexp/
These new methods will, in a later release, replace the old methods for
matching substrings.  The following methods are deprecated:
    Execute (use FindSubmatchIndex)
    ExecuteString (use FindStringSubmatchIndex)
    MatchStrings(use FindStringSubmatch)
    MatchSlices (use FindSubmatch)
    AllMatches (use FindAll; note that n&lt;0 means 'all matches'; was n&lt;=0)
    AllMatchesString (use FindAllString; note that n&lt;0 means 'all matches'; was n&lt;=0)
(Plus there are ten new methods you didn't know you wanted.) 
Please update your code to use the new routines before the next release.

An image.Image now has a Bounds rectangle, where previously it ranged 
from (0, 0) to (Width, Height). Loops that previously looked like:
    for y := 0; y &lt; img.Height(); y++ {
        for x := 0; x &lt; img.Width(); x++ {
            // Do something with img.At(x, y)
        }
    }
should instead be:
    b := img.Bounds()
    for y := b.Min.Y; y &lt; b.Max.Y; y++ {
        for x := b.Min.X; x &lt; b.Max.X; x++ {
            // Do something with img.At(x, y)
        }
    }
The Point and Rectangle types have also moved from exp/draw to image.

Other changes:
* arm: bugfixes and syscall (thanks Kai Backman).
* asn1: fix incorrect encoding of signed integers (thanks Nicholas Waples).
* big: fixes to bitwise functions (thanks Evan Shaw).
* bytes: add IndexRune, FieldsFunc and To*Special (thanks Christian Himpel).
* encoding/binary: add complex (thanks Roger Peppe).
* exp/iterable: add UintArray (thanks Anschel Schaffer-Cohen).
* godoc: report Status 404 if a pkg or file is not found.
* gofmt: better reporting for unexpected semicolon errors.
* html: new package, an HTML tokenizer.
* image: change image representation from slice-of-slices to linear buffer,
        introduce Decode and RegisterFormat,
        introduce Transparent and Opaque,
        replace Width and Height by Bounds, add the Point and Rect types.
* libbio: fix Bprint to address 6g issues with large data structures.
* math: fix amd64 Hypot (thanks Charles L. Dorian).
* net/textproto: new package, with example net/dict.
* os: fix ForkExec() handling of envv == nil (thanks Alex Brainman).
* png: grayscale support (thanks Mathieu Lonjaret).
* regexp: document that backslashes are the escape character.
* rpc: catch errors from ReadResponseBody.
* runtime: memory free fix (thanks Alex Brainman).
* template: add ParseFile method to template.Template.
* test/peano: use directly recursive type def.
</pre>

<h2 id="2010-08-04">2010-08-04</h2>

<pre>
This release includes a change to os.Open (and co.). The file permission
argument has been changed to a uint32. Your code may require changes - a simple
conversion operation at most.

Other changes:
* amd64: use segment memory for thread-local storage.
* arm: add gdb support to android launcher script,
        bugfixes (stack clobbering, indices),
        disable another flaky test,
        remove old qemu dependency from gotest.
* bufio: introduce Peek.
* bytes: added test case for explode with blank string (thanks Scott Lawrence).
* cgo: correct multiple return value function invocations (thanks Christian Himpel).
* crypto/x509: unwrap Subject Key Identifier (thanks Adam Langley).
* gc: index bounds tests and other fixes.
* gofmt/go/parser: strengthen syntax checks.
* goinstall: check for error from exec.*Cmd.Wait() (thanks Alex Brainman).
* image/png: use image-specific methods for checking opacity.
* image: introduce Gray and Gray16 types,
        remove the named colors except for Black and White.
* json: object members must have a value (thanks Anthony Martin).
* misc/vim: highlight misspelled words only in comments (thanks Christian Himpel).
* os: Null device (thanks Peter Mundy).
* runtime: do not fall through in SIGBUS/SIGSEGV.
* strings: fix Split("", "", -1) (thanks Scott Lawrence).
* syscall: make go errors not clash with windows errors (thanks Alex Brainman).
* test/run: diff old new,
* websocket: correct challenge response (thanks Tarmigan Casebolt),
        fix bug involving spaces in header keys (thanks Bill Neubauer). 
</pre>

<h2 id="2010-07-29">2010-07-29</h2>

<pre>
* 5g: more soft float support and several bugfixes.
* asn1: Enumerated, Flag and GeneralizedTime support.
* build: clean.bash to check that GOOS and GOARCH are set.
* bytes: add IndexFunc and LastIndexFunc (thanks Fazlul Shahriar),
	add Title.
* cgo: If CC is set in environment, use it rather than "gcc",
	use new command line syntax: -- separates cgo flags from gcc flags.
* codereview: avoid crash if no config,
	don't run gofmt with an empty file list,
	make 'hg submit' work with Mercurial 1.6.
* crypto/ocsp: add package to parse OCSP responses.
* crypto/tls: add client-side SNI support and PeerCertificates.
* exp/bignum: delete package - functionality subsumed by package big.
* fmt.Print: fix bug in placement of spaces introduced when ...T went in.
* fmt.Scanf: handle trailing spaces.
* gc: fix smaller-than-pointer-sized receivers in interfaces,
	floating point precision/normalization fixes,
	graceful exit on seg fault,
	import dot shadowing bug,
	many fixes including better handling of invalid input,
	print error detail about failure to open import.
* gccgo_install.html: add description of the port to RTEMS (thanks Vinu Rajashekhar).
* gobs: fix bug in singleton arrays.
* godoc: display synopses for all packages that have some kind of documentation..
* gofmt: fix some linebreak issues.
* http: add https client support (thanks Fazlul Shahriar),
	write body when content length unknown (thanks James Whitehead).
* io: MultiReader and MultiWriter (thanks Brad Fitzpatrick),
	fix another race condition in Pipes.
* ld: many fixes including better handling of invalid input.
* libmach: correct handling of .5 files with D_REGREG addresses.
* linux/386: use Xen-friendly ELF TLS instruction sequence.
* mime: add AddExtensionType (thanks Yuusei Kuwana).
* misc/vim: syntax file recognizes constants like 1e9 (thanks Petar Maymounkov).
* net: TCPConn.SetNoDelay, back by popular demand.
* net(windows): fix crashing Read/Write when passed empty slice on (thanks Alex Brainman),
	implement LookupHost/Port/SRV (thanks Wei Guangjing),
	properly handle EOF in (*netFD).Read() (thanks Alex Brainman).
* runtime: fix bug introduced in revision 4a01b8d28570 (thanks Alex Brainman),
	rename cgo2c, *.cgo to goc2c, *.goc (thanks Peter Mundy).
* scanner: better comment.
* strings: add Title.
* syscall: add ForkExec, Syscall12 on Windows (thanks Daniel Theophanes),
	improve windows errno handling (thanks Alex Brainman).
* syscall(windows): fix FormatMessage (thanks Peter Mundy),
	implement Pipe() (thanks Wei Guangjing).
* time: fix parsing of minutes in time zones.
* utf16(windows): fix cyclic dependency when testing (thanks Peter Mundy).
</pre>

<h2 id="2010-07-14">2010-07-14</h2>

<pre>
This release includes a package change. In container/vector, the Iter method
has been removed from the Vector, IntVector, and StringVector types. Also, the
Data method has been renamed to Copy to better express its actual behavior.
Now that Vector is just a slice, any for loops ranging over v.Iter() or
v.Data() can be changed to range over v instead.

Other changes:
* big: Improvements to Rat.SetString (thanks Evan Shaw),
        add sign, abs, Rat.IsInt.
* cgo: various bug fixes.
* codereview: Fix for Mercurial >= 1.6 (thanks Evan Shaw).
* crypto/rand: add Windows implementation (thanks Peter Mundy).
* crypto/tls: make HTTPS servers easier,
        add client OCSP stapling support.
* exp/eval: converted from bignum to big (thanks Evan Shaw).
* gc: implement new len spec, range bug fix, optimization.
* go/parser: require that '...' parameters are followed by a type.
* http: fix ParseURL to handle //relative_path properly.
* io: fix SectionReader Seek to seek backwards (thanks Peter Mundy).
* json: Add HTMLEscape (thanks Micah Stetson).
* ld: bug fixes.
* math: amd64 version of log (thanks Charles L. Dorian).
* mime/multipart: new package to parse multipart MIME messages
        and HTTP multipart/form-data support.
* os: use TempFile with default TempDir for test files (thanks Peter Mundy).
* runtime/tiny: add docs for additional VMs, fix build (thanks Markus Duft).
* runtime: better error for send/recv on nil channel.
* spec: clarification of channel close(),
        lock down some details about channels and select,
        restrict when len(x) is constant,
        specify len/cap for nil slices, maps, and channels.
* windows: append .exe to binary names (thanks Joe Poirier).
</pre>

<h2 id="2010-07-01">2010-07-01</h2>

<pre>
This release includes some package changes that may require changes to 
client code.

The Split function in the bytes and strings packages has been changed.
The count argument, which limits the size of the return, previously treated
zero as unbounded. It now treats 0 as 0, and will return an empty slice.  
To request unbounded results, use -1 (or some other negative value).
The new Replace functions in bytes and strings share this behavior.
This may require you change your existing code.

The gob package now allows the transmission of non-struct values at the
top-level. As a result, the rpc and netchan packages have fewer restrictions
on the types they can handle.  For example, netchan can now share a chan int.

The release also includes a Code Walk: "Share Memory By Communicating".
It describes an idiomatic Go program that uses goroutines and channels:
	http://golang.org/doc/codewalk/sharemem/

There is now a Projects page on the Go Dashboard that lists Go programs, 
tools, and libraries:
	http://godashboard.appspot.com/project

Other changes:
* 6a, 6l: bug fixes.
* bytes, strings: add Replace.
* cgo: use slash-free relative paths for .so references.
* cmath: correct IsNaN for argument cmplx(Inf, NaN) (thanks Charles L. Dorian).
* codereview: allow multiple email addresses in CONTRIBUTORS.
* doc/codewalk: add Share Memory By Communicating.
* exp/draw/x11: implement the mapping from keycodes to keysyms.
* fmt: Printf: fix bug in handling of %#v, allow other verbs for slices
        Scan: fix handling of EOFs.
* gc: bug fixes and optimizations.
* gob: add DecodeValue and EncodeValue,
        add support for complex numbers.
* goinstall: support for Bazaar+Launchpad (thanks Gustavo Niemeyer).
* io/ioutil: add TempFile for Windows (thanks Peter Mundy).
* ld: add -u flag to check safe bits; discard old -u, -x flags.
* math: amd64 versions of Exp and Fabs (thanks Charles L. Dorian).
* misc/vim: always override filetype detection for .go files.
* net: add support for DNS SRV requests (thanks Kirklin McDonald),
        initial attempt to implement Windows version (thanks Alex Brainman).
* netchan: allow chan of basic types now that gob can handle such,
        eliminate the need for a pointer value in Import and Export.
* os/signal: only catch all signals if os/signal package imported.
* regexp: bug fix: need to track whether match begins with fixed prefix.
* rpc: allow non-struct args and reply (they must still be pointers).
* runtime: bug fixes and reorganization.
* strconv: fix bugs in floating-point and base 2 conversions
* syscall: add syscall_bsd.go to zsycall_freebsd_386.go (thanks Peter Mundy),
        add socketpair (thanks Ivan Krasin).
* time: implement time zones for Windows (thanks Alex Brainman).
* x509: support non-self-signed certs. 
</pre>

<h2 id="2010-06-21">2010-06-21</h2>

<pre>
This release includes a language change. The "..." function parameter form is
gone; "...T" remains. Typically, "...interface{}" can be used instead of "...".

The implementation of Printf has changed in a way that subtly affects its
handling of the fmt.Stringer interface. You may need to make changes to your
code. For details, see:
        https://groups.google.com/group/golang-nuts/msg/6fffba90a3e3dc06

The reflect package has been changed. If you have code that uses reflect, 
it will need to be updated. For details, see:
        https://groups.google.com/group/golang-nuts/msg/7a93d07c590e7beb

Other changes:
* 8l: correct test for sp == top of stack in 8l -K code.
* asn1: allow '*' in PrintableString.
* bytes.Buffer.ReadFrom: fix bug.
* codereview: avoid exception in match (thanks Paolo Giarrusso).
* complex divide: match C99 implementation.
* exp/draw: small draw.drawGlyphOver optimization.
* fmt: Print*: reimplement to switch on type first,
        Scanf: improve error message when input does not match format.
* gc: better error messages for interface failures, conversions, undefined symbols.
* go/scanner: report illegal escape sequences.
* gob: substitute slice for map.
* goinstall: process dependencies for package main (thanks Roger Peppe).
* gopack: add S flag to force marking a package as safe,
        simplify go metadata code.
* html: sync testdata/webkit to match WebKit tip.
* http: reply to Expect 100-continue requests automatically (thanks Brad Fitzpatrick).
* image: add an Alpha16 type.
* ld: pad Go symbol table out to page boundary (fixes cgo crash).
* misc/vim: reorganize plugin to be easier to use (thanks James Whitehead).
* path: add Base, analogous to Unix basename.
* pkg/Makefile: allow DISABLE_NET_TESTS=1 to disable network tests.
* reflect: add Kind, Type.Bits, remove Int8Type, Int8Value, etc.
* runtime: additional Windows support (thanks Alex Brainman),
        correct fault for 16-bit divide on Leopard,
        fix 386 signal handler bug.
* strconv: add AtofN, FtoaN.
* string: add IndexFunc and LastIndexFunc (thanks Roger Peppe).
* syslog: use local network for tests. 
</pre>

<h2 id="2010-06-09">2010-06-09</h2>

<pre>
This release contains many fixes and improvements, including several
clarifications and consolidations to the Language Specification.

The type checking rules around assignments and conversions are simpler but more
restrictive: assignments no longer convert implicitly from *[10]int to []int
(write x[0:] instead of &amp;x), and conversions can no longer change the names of
types inside composite types.

The fmt package now includes flexible type-driven (fmt.Scan) and 
format-driven (fmt.Scanf) scanners for all basic types.

* big: bug fix for Quo aliasing problem.
* bufio: change ReadSlice to match description.
* cgo: bug fixes.
* doc: add Google I/O talk and programs,
        codereview + Mercurial Queues info (thanks Peter Williams).
* exp/draw: Draw fast paths for the Over operator,
        add Rectangle.Eq and Point.In, fix Rectangle.Clip (thanks Roger Peppe).
* fmt: Scan fixes and improvements.
* gc: backslash newline is not a legal escape sequence in strings,
        better error message when ~ operator is found,
        fix export of complex types,
        new typechecking rules.
* go/parser: correct position of empty statement ';'.
* gofmt: fix test script.
* goinstall: use 'git pull' instead of 'git checkout' (thanks Michael Hoisie).
* http: add Head function for making HTTP HEAD requests,
        handle status 304 correctly.
* image: add Opaque method to the image types.
        make Color.RGBA return 16 bit color instead of 32 bit color.
* io/ioutil: add TempFile.
* math: Pow special cases and additional tests (thanks Charles L. Dorian).
* netchan: improve closing and shutdown.
* os: implement os.FileInfo.*time_ns for windows (thanks Alex Brainman).
* os/signal: correct the regexp for finding Unix signal names (thanks Vinu Rajashekhar).
* regexp: optimizations (thanks Kyle Consalus).
* runtime: fix printing -Inf (thanks Evan Shaw),
        finish pchw -&gt; tiny, added gettime for tiny (thanks Daniel Theophanes).
* spec: clean-ups and consolidation.
* syscall: additional Windows compatibility fixes (thanks Alex Brainman).
* test/bench: added regex-dna-parallel.go (thanks Kyle Consalus).
* vector: type-specific Do functions now take f(type) (thanks Michael Hoisie). 
</pre>

<h2 id="2010-05-27">2010-05-27</h2>

<pre>
A sizeable release, including standard library improvements and a slew of
compiler bug fixes. The three-week interval was largely caused by the team
preparing for Google I/O. 

* big: add Rat type (thanks Evan Shaw),
        new features, much performance tuning, cleanups, and more tests.
* bignum: deprecate by moving into exp directory.
* build: allow MAKEFLAGS to be set outside the build scripts (thanks Christopher Wedgwood).
* bytes: add Trim, TrimLeft, TrimRight, and generic functions (thanks Michael Hoisie).
* cgo: fix to permit cgo callbacks from init code.
* cmath: update range of Phase and Polar due to signed zero (thanks Charles L. Dorian).
* codereview: work better with mq (thanks Peter Williams).
* compress: renamings
	NewDeflater -&gt; NewWriter
	NewInflater -&gt; NewReader
	Deflater -&gt; Compressor
	Inflater -&gt; Decompressor
* exp/draw/x11: respect $XAUTHORITY,
        treat $DISPLAY the same way x-go-bindings does.
* exp/draw: fast path for glyph images, other optimizations,
        fix Rectangle.Canon (thanks Roger Peppe).
* fmt: Scan, Scanln: Start of a simple scanning API in the fmt package,
        fix Printf crash when given an extra nil argument (thanks Roger Peppe).
* gc: better error when computing remainder of non-int (thanks Evan Shaw),
        disallow middot in Go programs,
        distinguish array, slice literal in error messages,
        fix shift/reduce conflict in go.y export syntax,
        fix unsafe.Sizeof on ideal constants,
        handle use of builtin function outside function call,
        many other bug fixes.
* gob: add support for maps,
        add test for indirect maps, slices, arrays.
* godoc: collect package comments from all package files.
* gofmt: don't lose mandatory semicolons,
        exclude test w/ illegal syntax from test cases,
        fix printing of labels.
* http: prevent crash if remote server is not responding with "HTTP/".
* json: accept escaped slash in string scanner (thanks Michael Hoisie),
        fix array -&gt; non-array decoding.
* libmach: skip __nl_symbol_ptr section on OS X.
* math: amd64 versions of Fdim, Fmax, Fmin,
        signed zero Sqrt special case (thanks Charles L. Dorian).
* misc/kate: convert isn't a built in function (thanks Evan Shaw).
* net: implement BindToDevice,
        implement raw sockets (thanks Christopher Wedgwood).
* netFD: fix race between Close and Read/Write (thanks Michael Hoisie).
* os: add Chtimes function (thanks Brad Fitzpatrick).
* pkg/Makefile: add netchan to standard package list.
* runtime: GOMAXPROCS returns previous value,
        allow large map values,
        avoid allocation for fixed strings,
        correct tracebacks for nascent goroutines, even closures,
        free old hashmap pieces during resizing.
* spec: added imaginary literal to semicolon rules (was missing),
        fix and clarify syntax of conversions,
        simplify section on channel types,
        other minor tweaks.
* strconv: Btoui64 optimizations (thanks Kyle Consalus).
* strings: use copy instead of for loop in Map (thanks Kyle Consalus).
* syscall: implement BindToDevice (thanks Christopher Wedgwood),
        add Utimes on Darwin/FreeBSD, add Futimes everywhere,
        regenerate syscalls for some platforms.
* template: regularize name lookups of interfaces, pointers, and methods.
</pre>

<h2 id="2010-05-04">2010-05-04</h2>

<pre>
In this release we renamed the Windows OS target from 'mingw' to 'windows'.
If you are currently building for 'mingw' you should set GOOS=windows instead.

* 5l, 6l, 8l, runtime: make -s binaries work.
* 5l, 6l, 8l: change ELF header so that strip doesn't destroy binary.
* 8l: fix absolute path detection on Windows.
* big: new functions, optimizations, and cleanups,
	add bitwise methods for Int (thanks Evan Shaw).
* bytes: Change IndexAny to look for UTF-8 encoded characters.
* darwin: bsdthread_create can fail; print good error.
* fmt: %T missing print &lt;nil&gt; for nil (thanks Christopher Wedgwood).
* gc: many fixes.
* misc/cgo/gmp: fix bug in SetString.
* net: fix resolv.conf EOF without newline bug (thanks Christopher Wedgwood).
* spec: some small clarifications (no language changes).
* syscall: add EWOULDBLOCK to sycall_nacl.go,
	force O_LARGEFILE in Linux open system call,
	handle EOF on pipe - special case on Windows (thanks Alex Brainman),
	mingw Sleep (thanks Joe Poirier).
* test/bench: import new fasta C reference, update Go, optimizations.
* test: test of static initialization (fails).
* vector: use correct capacity in call to make.
* xml: allow text segments to end at EOF.
</pre>

<h2 id="2010-04-27">2010-04-27</h2>

<pre>
This release includes a new Codelab that illustrates the construction of a
simple wiki web application: 
	http://golang.org/doc/codelab/wiki/

It also includes a Codewalk framework for documenting code. See:
	http://golang.org/doc/codewalk/

Other changes:
* 6g: fix need for parens around array index expression.
* 6l, 8l: include ELF header in PT_LOAD mapping for text segment.
* arm: add android runner script,
	support for printing floats.
* big: implemented Karatsuba multiplication,
	many fixes and improvements (thanks Evan Shaw).
* bytes: add Next method to Buffer, simplify Read,
	shuffle implementation, making WriteByte 50% faster.
* crypto/tls: simpler implementation of record layer.
* exp/eval: fixes (thanks Evan Shaw).
* flag: eliminate unnecessary structs.
* gc: better windows support,
	cmplx typecheck bug fix,
	more specific error for statements at top level.
* go/parser: don't require unnecessary parens.
* godoc: exclude duplicate entries (thanks Andrei Vieru),
	use int64 for timestamps (thanks Christopher Wedgwood).
* gofmt: fine-tune stripping of parentheses,
* json: Marshal, Unmarshal using new scanner,
	preserve field name case by default,
	scanner, Compact, Indent, and tests,
	support for streaming.
* libmach: disassemble MOVLQZX correctly.
* math: more special cases for signed zero (thanks Charles L. Dorian).
* net: add Pipe,
	fix bugs in packStructValue (thanks Michael Hoisie),
	introduce net.Error interface.
* os: FileInfo: regularize the types of some fields,
	create sys_bsd.go (thanks Giles Lean),
	mingw bug fixes (thanks Alex Brainman).
* reflect: add FieldByNameFunc (thanks Raif S. Naffah),
	implement Set(nil), SetValue(nil) for PtrValue and MapValue.
* regexp: allow escaping of any punctuation.
* rpc/jsonrpc: support for jsonrpc wire encoding.
* rpc: abstract client and server encodings,
	add Close() method to rpc.Client.
* runtime: closures, defer bug fix for Native Client,
	rename cgo2c, *.cgo to goc2c, *.goc to avoid confusion with real cgo.
	several other fixes.
* scanner: implement Peek() to look at the next char w/o advancing.
* strings: add ReadRune to Reader, add FieldsFunc (thanks Kyle Consalus).
* syscall: match linux Setsid function signature to darwin,
	mingw bug fixes (thanks Alex Brainman).
* template: fix handling of pointer inside interface.
* test/bench: add fannkuch-parallel.go (thanks Kyle Consalus),
	pidigits ~10% performance win by using adds instead of shifts.
* time: remove incorrect time.ISO8601 and add time.RFC3339 (thanks Micah Stetson).
* utf16: add DecodeRune, EncodeRune.
* xml: add support for XML marshalling embedded structs (thanks Raif S. Naffah),
	new "innerxml" tag to collect inner XML.
</pre>

<h2 id="2010-04-13">2010-04-13</h2>

<pre>
This release contains many changes:

* 8l: add DOS stub to PE binaries (thanks Evan Shaw).
* cgo: add //export.
* cmath: new complex math library (thanks Charles L. Dorian).
* docs: update to match current coding style (thanks Christopher Wedgwood).
* exp/eval: fix example and add target to Makefile (thanks Evan Shaw).
* fmt: change behaviour of format verb %b to match %x when negative (thanks Andrei Vieru).
* gc: compile s == "" as len(s) == 0,
	distinguish fatal compiler bug from error+exit,
	fix alignment on non-amd64,
	good syntax error for defer func() {} - missing fina (),
	implement panic and recover,
	zero unnamed return values on entry if func has defer.
* goyacc: change to be reentrant (thanks Roger Peppe).
* io/ioutil: fix bug in ReadFile when Open succeeds but Stat fails.
* kate: update for recent language changes (thanks Evan Shaw).
* libcgo: initial mingw port work - builds but untested (thanks Joe Poirier).
* math: new functions and special cases (thanks Charles L. Dorian) 
* net: use chan bool instead of chan *netFD to avoid cycle.
* netchan: allow client to send as well as receive.
* nntp: new package, NNTP client (thanks Conrad Meyer).
* os: rename os.Dir to os.FileInfo.
* rpc: don't log normal EOF,
	fix ServeConn to block as documented.
* runtime: many bug fixes, better ARM support.
* strings: add IndexRune, Trim, TrimLeft, TrimRight, etc (thanks Michael Hoisie).
* syscall: implement some mingw syscalls required by os (thanks Alex Brainman).
* test/bench: add k-nucleotide-parallel (thanks Kyle Consalus).
* Unicode: add support for Turkish case mapping.
* xgb: move from the main repository to http://code.google.com/p/x-go-binding/
</pre>

<h2 id="2010-03-30">2010-03-30</h2>

<pre>
This release contains three language changes:

1. Accessing a non-existent key in a map is no longer a run-time error.  
It now evaluates to the zero value for that type.  For example:
        x := myMap[i]   is now equivalent to:   x, _ := myMap[i]

2. It is now legal to take the address of a function's return value.  
The return values are copied back to the caller only after deferred
functions have run.

3. The functions panic and recover, intended for reporting and recovering from
failure, have been added to the spec:
	http://golang.org/doc/go_spec.html#Handling_panics 
In a related change, panicln is gone, and panic is now a single-argument
function.  Panic and recover are recognized by the gc compilers but the new
behavior is not yet implemented.

The ARM build is broken in this release; ARM users should stay at release.2010-03-22.

Other changes:
* bytes, strings: add IndexAny.
* cc/ld: Add support for #pragma dynexport,
        Rename dynld to dynimport throughout. Cgo users will need to rerun cgo.
* expvar: default publishings for cmdline, memstats
* flag: add user-defined flag types.
* gc: usual bug fixes
* go/ast: generalized ast filtering.
* go/printer: avoid reflect in print.
* godefs: fix handling of negative constants.
* godoc: export pprof debug information, exported variables,
        support for filtering of command-line output in -src mode,
        use http GET for remote search instead of rpc.
* gofmt: don't convert multi-line functions into one-liners,
        preserve newlines in multiline selector expressions (thanks Risto Jaakko Saarelma).
* goinstall: include command name in error reporting (thanks Andrey Mirtchovski)
* http: add HandleFunc as shortcut to Handle(path, HandlerFunc(func))
* make: use actual dependency for install
* math: add J1, Y1, Jn, Yn, J0, Y0 (Bessel functions) (thanks Charles L. Dorian)
* prof: add pprof from google-perftools
* regexp: don't return non-nil *Regexp if there is an error.
* runtime: add Callers,
        add malloc sampling, pprof interface,
        add memory profiling, more statistics to runtime.MemStats,
        implement missing destroylock() (thanks Alex Brainman),
        more malloc statistics,
        run all finalizers in a single goroutine,
        Goexit runs deferred calls.
* strconv: add Atob and Btoa,
        Unquote could wrongly return a nil error on error (thanks Roger Peppe).
* syscall: add IPV6 constants,
        add syscall_bsd.go for Darwin and other *BSDs (thanks Giles Lean),
        implement SetsockoptString (thanks Christopher Wedgwood).
* websocket: implement new protocol (thanks Fumitoshi Ukai).
* xgb: fix request length and request size (thanks Firmansyah Adiputra).
* xml: add CopyToken (thanks Kyle Consalus),
        add line numbers to syntax errors (thanks Kyle Consalus),
        use io.ReadByter in place of local readByter (thanks Raif S. Naffah). 
</pre>

<h2 id="2010-03-22">2010-03-22</h2>

<pre>
With this release we announce the launch of the Go Blog:
	http://blog.golang.org/
The first post is a brief update covering what has happened since the launch.

This release contains some new packages and functionality, and many fixes:
* 6g/8g: fix issues with complex data types, other bug fixes.
* Makefiles: refactored to make writing external Makefiles easier.
* crypto/rand: new package.
* godoc: implemented command-line search via RPC,
	improved comment formatting: recognize URLs.
* gofmt: more consistent formatting of const/var decls.
* http: add Error helper function,
	add ParseQuery (thanks Petar Maymounkov),
	change RawPath to mean raw path, not raw everything-after-scheme.
* image/jpeg: fix typos.
* json: add MarshalIndent (accepts user-specified indent string).
* math: add Gamma function (thanks Charles L. Dorian).
* misc/bbedit: support for cmplx, real, imag (thanks Anthony Starks).
* misc/vim: add new complex types, functions and literals.
* net: fix IPMask.String not to crash on all-0xff mask.
* os: drop File finalizer after normal Close.
* runtime: add GOROOT and Version,
	lock finalizer table accesses.
* sha512: add sha384 (truncated version) (thanks Conrad Meyer).
* syscall: add const ARCH, analogous to OS.
* syscall: further additions to mingw port (thanks Alex Brainman).
* template: fixed html formatter []byte input bug.
* utf16: new package.
* version.bash: cope with ancient Mercurial.
* websocket: use URL.RawPath to construct WebSocket-Location: header.
</pre>

<h2 id="2010-03-15">2010-03-15</h2>

<pre>
This release includes a language change: support for complex numbers.
	http://golang.org/doc/go_spec.html#Imaginary_literals
	http://golang.org/doc/go_spec.html#Complex_numbers
There is no library support as yet.

This release also includes the goinstall command-line tool. 
	http://golang.org/cmd/goinstall/
	http://groups.google.com/group/golang-nuts/t/f091704771128e32

* 5g/6g/8g: fix double function call in slice.
* arm: cleanup build warnings. (thanks Dean Prichard)
* big: fix mistakes with probablyPrime.
* bufio: add WriteRune.
* bytes: add ReadRune and WriteRune to bytes.Buffer.
* cc: stack split bug fix.
* crypto: add SHA-224 to sha256, add sha512 package. (thanks Conrad Meyer)
* crypto/ripemd160: new package. (thanks Raif S. Naffah)
* crypto/rsa: don't use safe primes.
* gc: avoid fixed length buffer cleanbuf. (thanks Dean Prichard)
	better compilation of floating point +=
	fix crash on complicated arg to make slice.
	remove duplicate errors, give better error for I.(T)
* godoc: support for multiple packages in a directory, other fixes.
* gofmt: bug fixes.
* hash: add Sum64 interface.
* hash/crc32: add Update function.
* hash/crc64: new package implementing 64-bit CRC.
* math: add ilogb, logb, remainder. (thanks Charles L. Dorian) 
* regexp: add ReplaceAllFunc, ReplaceAllStringFunc.
* runtime: clock garbage collection on bytes allocated, not pages in use.
* strings: make Split(s, "", n) faster. (thanks Spring Mc)
* syscall: minimal mingw version of syscall. (thanks Alex Brainman)
* template: add ParseFile, MustParseFile.
</pre>

<h2 id="2010-03-04">2010-03-04</h2>

<pre>
There is one language change: the ability to convert a string to []byte or 
[]int.  This deprecates the strings.Bytes and strings.Runes functions.
You can convert your existing sources using these gofmt commands:
	gofmt -r 'strings.Bytes(x) -&gt; []byte(x)' -w file-or-directory-list
	gofmt -r 'strings.Runes(x) -&gt; []int(x)' -w file-or-directory-list
After running these you might need to delete unused imports of the "strings" 
package.

Other changes and fixes:
* 6l/8l/5l: add -r option
* 8g: make a[byte(x)] truncate x
* codereview.py: fix for compatibility with hg >=1.4.3
* crypto/blowfish: new package (thanks Raif S. Naffah)
* dashboard: more performance tuning
* fmt: use String method in %q to get the value to quote.
* gofmt: several cosmetic changes
* http: fix handling of Connection: close, bug in http.Post
* net: correct DNS configuration,
	fix network timeout boundary condition,
	put [ ] around IPv6 addresses for Dial.
* path: add Match,
	fix bug in Match with non-greedy stars (thanks Kevin Ballard)
* strings: delete Bytes, Runes (see above)
* tests: an Eratosthenesque concurrent prime sieve (thanks Anh Hai Trinh) 
</pre>

<h2 id="2010-02-23">2010-02-23</h2>

<pre>
This release is mainly bug fixes and a little new code.
There are no language changes.

6g/5g/8g: bug fixes
8a/8l: Added FCMOVcc instructions (thanks Evan Shaw and Charles Dorian)
crypto/x509: support certificate creation
dashboard: caching to avoid datastore queries
exec: add dir argument to Run
godoc: bug fixes and code cleanups
http: continued implementation and bug fixes (thanks Petar Maymounkov)
json: fix quoted strings in Marshal (thanks Sergei Skorobogatov)
math: more functions, test cases, and benchmarks (thanks Charles L. Dorian)
misc/bbedit: treat predeclared identifiers as "keywords" (thanks Anthony Starks)
net: disable UDP server test (flaky on various architectures)
runtime: work around Linux kernel bug in futex,
	pchw is now tiny
sync: fix to work on armv5 (thanks Dean Prichard)
websocket: fix binary frame size decoding (thanks Timo Savola)
xml: allow unquoted attribute values in non-Strict mode (thanks Amrut Joshi)
	treat bool as value in Unmarshal (thanks Michael Hoisie) 
</pre>

<h2 id="2010-02-17">2010-02-17</h2>

<pre>
There are two small language changes:
* NUL bytes may be rejected in souce files, and the tools do reject them.
* Conversions from string to []int and []byte are defined but not yet implemented.

Other changes and fixes:
* 5a/6a/8a/5c/6c/8c: remove fixed-size arrays for -I and -D options (thanks Dean Prichard)
* 5c/6c/8c/5l/6l/8l: add -V flag to display version number
* 5c/6c/8c: use "cpp" not "/bin/cpp" for external preprocessor (thanks Giles Lean)
* 8a/8l: Added CMOVcc instructions (thanks Evan Shaw)
* 8l: pe executable building code changed to include import table for kernel32.dll functions (thanks Alex Brainman)
* 5g/6g/8g: bug fixes
* asn1: bug fixes and additions (incl marshalling)
* build: fix build for Native Client, Linux/ARM
* dashboard: show benchmarks, add garbage collector benchmarks
* encoding/pem: add marshalling support
* exp/draw: fast paths for a nil mask
* godoc: support for directories outside $GOROOT
* http: sort header keys when writing Response or Request to wire (thanks Petar Maymounkov)
* math: special cases and new functions (thanks Charles Dorian)
* mime: new package, used in http (thanks Michael Hoisie)
* net: dns bug fix - use random request id
* os: finalize File, to close fd.
* path: make Join variadic (thanks Stephen Weinberg)
* regexp: optimization bug fix
* runtime: misc fixes and optimizations
* syscall: make signature of Umask on OS X, FreeBSD match Linux. (thanks Giles Lean)
</pre>

<h2 id="2010-02-04">2010-02-04</h2>

<pre>
There is one language change: support for ...T parameters:
	http://golang.org/doc/go_spec.html#Function_types

You can now check build status on various platforms at the Go Dashboard: 
	http://godashboard.appspot.com

* 5l/6l/8l: several minor fixes
* 5a/6a/8a/5l/6l/8l: avoid overflow of symb buffer (thanks Dean Prichard)
* compress/gzip: gzip deflater (i.e., writer)
* debug/proc: add mingw specific build stubs (thanks Joe Poirier)
* exp/draw: separate the source-point and mask-point in Draw
* fmt: handle nils safely in Printf
* gccgo: error messages now match those of gc
* godoc: several fixes
* http: bug fixes, revision of Request/Response (thanks Petar Maymounkov)
* image: new image.A type to represent anti-aliased font glyphs
	add named colors (e.g. image.Blue), suitable for exp/draw
* io: fixed bugs in Pipe
* malloc: merge into package runtime
* math: fix tests on FreeBSD (thanks Devon H. O'Dell)
	add functions; update tests and special cases (thanks Charles L. Dorian)
* os/signal: send SIGCHLDs to Incoming (thanks Chris Wedgwood)
* reflect: add StringHeader to reflect
* runtime: add SetFinalizer
* time: Sleep through interruptions (thanks Chris Wedgwood)
	add RFC822 formats
	experimental implemenation of Ticker using two goroutines for all tickers
* xml: allow underscores in XML element names (thanks Michael Hoisie)
	allow any scalar type in xml.Unmarshal
</pre>

<h2 id="2010-01-27">2010-01-27</h2>

<pre>
There are two small language changes: the meaning of chan &lt;- chan int
is now defined, and functions returning functions do not need to 
parenthesize the result type.

There is one significant implementation change: the compilers can
handle multiple packages using the same name in a single binary.
In the gc compilers, this comes at the cost of ensuring that you
always import a particular package using a consistent import path.
In the gccgo compiler, the cost is that you must use the -fgo-prefix
flag to pass a unique prefix (like the eventual import path).

5a/6a/8a: avoid use of fixed-size buffers (thanks Dean Prichard)
5g, 6g, 8g: many minor bug fixes
bufio: give Writer.WriteString same signature as bytes.Buffer.WriteString.
container/list: PushFrontList, PushBackList (thanks Jan Hosang)
godoc: trim spaces from search query (thanks Christopher Wedgwood)
hash: document that Sum does not change state, fix crypto hashes
http: bug fixes, revision of Request/Response (thanks Petar Maymounkov)
math: more handling of IEEE 754 special cases (thanks Charles Dorian)
misc/dashboard: new build dashboard
net: allow UDP broadcast,
	use /etc/hosts to resolve names (thanks Yves Junqueira, Michael Hoisie)
netchan: beginnings of new package for connecting channels across a network
os: allow FQDN in Hostname test (thanks Icarus Sparry)
reflect: garbage collection bug in Call
runtime: demo of Go on raw (emulated) hw in runtime/pchw,
	performance fix on OS X
spec: clarify meaning of chan &lt;- chan int,
	func() func() int is allowed now,
	define ... T (not yet implemented)
template: can use interface values
time: fix for +0000 time zone,
	more robust tick.Stop.
xgb: support for authenticated connections (thanks Firmansyah Adiputra)
xml: add Escape (thanks Stephen Weinberg)
</pre>

<h2 id="2010-01-13">2010-01-13</h2>

<pre>
This release is mainly bug fixes with a little new code.
There are no language changes.

build: $GOBIN should no longer be required in $PATH (thanks Devon H. O'Dell),
	new package target "make bench" to run benchmarks
8g: faster float -&gt; uint64 conversion (thanks Evan Shaw)
5g, 6g, 8g:
	clean opnames.h to avoid stale errors (thanks Yongjian Xu),
	a handful of small compiler fixes
5g, 6g, 8g, 5l, 6l, 8l: ignore $GOARCH, which is implied by name of tool
6prof: support for writing input files for google-perftools's pprof
asn1: fix a few structure-handling bugs
cgo: many bug fixes (thanks Devon H. O'Dell)
codereview: repeated "hg mail" sends "please take another look"
gob: reserve ids for future expansion
godoc: distinguish HTML generation from plain text HTML escaping (thanks Roger Peppe)
gofmt: minor bug fixes, removed -oldprinter flag
http: add CanonicalPath (thanks Ivan Krasin),
	avoid header duplication in Response.Write,
	correctly escape/unescape URL sections
io: new interface ReadByter
json: better error, pointer handling in Marshal (thanks Ivan Krasin)
libmach: disassembly of FUCOMI, etc (thanks Evan Shaw)
math: special cases for most functions and 386 hardware Sqrt (thanks Charles Dorian)
misc/dashboard: beginning of a build dashboard at godashboard.appspot.com.
misc/emacs: handling of new semicolon rules (thanks Austin Clements),
	empty buffer bug fix (thanks Kevin Ballard)
misc/kate: highlighting improvements (tahnks Evan Shaw)
os/signal: add signal names: signal.SIGHUP, etc (thanks David Symonds)
runtime: preliminary Windows support (thanks Hector Chu),
	preemption polling to reduce garbage collector pauses
scanner: new lightweight scanner package
template: bug fix involving spaces before a delimited block
test/bench: updated timings
time: new Format, Parse functions
</pre>

<h2 id="2010-01-05">2010-01-05</h2>

<pre>
This release is mainly bug fixes.  There are no language changes.

6prof: now works on 386
8a, 8l: add FCOMI, FCOMIP, FUCOMI, and FUCOMIP (thanks Evan Shaw)
big: fix ProbablyPrime on small numbers
container/vector: faster []-based implementation (thanks Jan Mercl)
crypto/tls: extensions and Next Protocol Negotiation
gob: one encoding bug fix, one decoding bug fix
image/jpeg: support for RST markers
image/png: support for transparent paletted images
misc/xcode: improved support (thanks Ken Friedenbach)
net: return nil Conn on error from Dial (thanks Roger Peppe)
regexp: add Regexp.NumSubexp (thanks Peter Froehlich)
syscall: add Nanosleep on FreeBSD (thanks Devon H. O'Dell)
template: can use map in .repeated section

There is now a public road map, in the repository and online
at <a href="http://golang.org/doc/devel/roadmap.html">http://golang.org/doc/devel/roadmap.html</a>.
</pre>

<h2 id="2009-12-22">2009-12-22</h2>

<pre>
Since the last release there has been one large syntactic change to
the language, already discussed extensively on this list: semicolons
are now implied between statement-ending tokens and newline characters.
See http://groups.google.com/group/golang-nuts/t/5ee32b588d10f2e9 for
details.

By default, gofmt now parses and prints the new lighter weight syntax.
To convert programs written in the old syntax, you can use:

	gofmt -oldparser -w *.go

Since everything was being reformatted anyway, we took the opportunity to
change the way gofmt does alignment.  Now gofmt uses tabs at the start
of a line for basic code alignment, but it uses spaces for alignment of
interior columns.  Thus, in an editor with a fixed-width font, you can
choose your own tab size to change the indentation, and no matter what
tab size you choose, columns will be aligned properly.


In addition to the syntax and formatting changes, there have been many
smaller fixes and updates:

6g,8g,5g: many bug fixes, better registerization,
   build process fix involving mkbuiltin (thanks Yongjian Xu),
   method expressions for concrete types
8l: support for Windows PE files (thanks Hector Chu)
bytes: more efficient Buffer handling
bytes, strings: new function Fields (thanks Andrey Mirtchovski)
cgo: handling of enums (thanks Moriyoshi Koizumi),
    handling of structs with bit fields, multiple files (thanks Devon H. O'Dell),
    installation of .so to non-standard locations
crypto/sha256: new package for SHA 256 (thanks Andy Davis)
encoding/binary: support for slices of fixed-size values (thanks Maxim Ushakov)
exp/vector: experimental alternate vector representation (thanks Jan Mercl)
fmt: %p for chan, map, slice types
gob: a couple more bug fixes
http: support for basic authentication (thanks Ivan Krasin)
image/jpeg: basic JPEG decoder
math: correct handling of Inf and NaN in Pow (thanks Charles Dorian)
misc/bash: completion file for bash (thanks Alex Ray)
os/signal: support for handling Unix signals (thanks David Symonds)
rand: Zipf-distributed random values (thanks William Josephson)
syscall: correct error return bug on 32-bit machines (thanks Christopher Wedgwood)
syslog: new package for writing to Unix syslog daemon (thanks Yves Junqueira)
template: will automatically invoke niladic methods
time: new ISO8601 format generator (thanks Ben Olive)
xgb: converted generator to new syntax (thanks Tor Andersson)
xml: better mapping of tag names to Go identifiers (thanks Kei Son),
    better handling of unexpected EOF (thanks Arvindh Rajesh Tamilmani)
</pre>

<h2 id="2009-12-09">2009-12-09</h2>

<pre>
Since the last release there are two changes to the language: 

* new builtin copy(dst, src) copies n = min(len(dst), len(src)) 
  elements to dst from src and returns n.  It works correctly 
  even if dst and src overlap.  bytes.Copy is gone. 
  Convert your programs using: 
      gofmt -w -r 'bytes.Copy(d, s) -&gt; copy(d, s)' *.go 

* new syntax x[lo:] is shorthand for x[lo:len(x)]. 
  Convert your programs using: 
      gofmt -w -r 'a[b:len(a)] -&gt; a[b:]' *.go 

In addition, there have been many smaller fixes and updates: 

* 6g/8g/5g: many bug fixes 
* 8g: fix 386 floating point stack bug (thanks Charles Dorian) 
* all.bash: now works even when $GOROOT has spaces (thanks Sergio Luis O. B. Correia), 
    starting to make build work with mingw (thanks Hector Chu), 
    FreeBSD support (thanks Devon O'Dell) 
* big: much faster on 386. 
* bytes: new function IndexByte, implemented in assembly 
    new function Runes (thanks Peter Froehlich), 
    performance tuning in bytes.Buffer. 
* codereview: various bugs fixed 
* container/vector: New is gone; just declare a Vector instead. 
    call Resize to set len and cap. 
* cgo: many bug fixes (thanks Eden Li) 
* crypto: added MD4 (thanks Chris Lennert), 
    added XTEA (thanks Adrian O'Grady). 
* crypto/tls: basic client 
* exp/iterable: new functions (thanks Michael Elkins) 
* exp/nacl: native client tree builds again 
* fmt: preliminary performance tuning 
* go/ast: more powerful Visitor (thanks Roger Peppe) 
* gob: a few bug fixes 
* gofmt: better handling of standard input, error reporting (thanks Fazlul Shahriar) 
    new -r flag for rewriting programs 
* gotest: support for Benchmark functions (thanks Trevor Strohman) 
* io: ReadFile, WriteFile, ReadDir now in separate package io/ioutil. 
* json: new Marshal function (thanks Michael Hoisie), 
    better white space handling (thanks Andrew Skiba), 
    decoding into native data structures (thanks Sergey Gromov), 
    handling of nil interface values (thanks Ross Light). 
* math: correct handling of sin/cos of large angles 
* net: better handling of Close (thanks Devon O'Dell and Christopher Wedgwood) 
    support for UDP broadcast (thanks Jonathan Wills), 
    support for empty packets 
* rand: top-level functions now safe to call from multiple goroutines 
(thanks Roger Peppe). 
* regexp: a few easy optimizations 
* rpc: better error handling, a few bug fixes 
* runtime: better signal handling on OS X, malloc fixes, 
    global channel lock is gone. 
* sync: RWMutex now allows concurrent readers (thanks P√©ter Szab√≥) 
* template: can use maps as data (thanks James Meneghello) 
* unicode: updated to Unicode 5.2. 
* websocket: new package (thanks Fumitoshi Ukai) 
* xgb: preliminary X Go Bindings (thanks Tor Andersson) 
* xml: fixed crash (thanks Vish Subramanian) 
* misc: bbedit config (thanks Anthony Starks), 
    kate config (thanks Evan Shaw) 
</pre>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               root/go1.4/doc/docs.html                                                                            0100644 0000000 0000000 00000017753 12600426225 013457  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Documentation",
	"Path": "/doc/"
}-->

<p>
The Go programming language is an open source project to make programmers more
productive.
</p>

<p>
Go is expressive, concise, clean, and efficient. Its concurrency
mechanisms make it easy to write programs that get the most out of multicore
and networked machines, while its novel type system enables flexible and
modular program construction. Go compiles quickly to machine code yet has the
convenience of garbage collection and the power of run-time reflection. It's a
fast, statically typed, compiled language that feels like a dynamically typed,
interpreted language.
</p>

<div id="manual-nav"></div>

<h2>Installing Go</h2>

<h3><a href="/doc/install">Getting Started</a></h3>
<p>
Instructions for downloading and installing the Go compilers, tools, and
libraries.
</p>


<h2 id="learning">Learning Go</h2>

<img class="gopher" src="/doc/gopher/doc.png"/>

<h3 id="go_tour"><a href="//tour.golang.org/">A Tour of Go</a></h3>
<p>
An interactive introduction to Go in three sections.
The first section covers basic syntax and data structures; the second discusses
methods and interfaces; and the third introduces Go's concurrency primitives.
Each section concludes with a few exercises so you can practice what you've
learned. You can <a href="//tour.golang.org/">take the tour online</a> or
<a href="//code.google.com/p/go-tour/">install it locally</a>.
</p>

<h3 id="code"><a href="code.html">How to write Go code</a></h3>
<p>
Also available as a
<a href="//www.youtube.com/watch?v=XCsL89YtqCs">screencast</a>, this doc
explains how to use the <a href="/cmd/go/">go command</a> to fetch, build, and
install packages, commands, and run tests.
</p>

<h3 id="effective_go"><a href="effective_go.html">Effective Go</a></h3>
<p>
A document that gives tips for writing clear, idiomatic Go code.
A must read for any new Go programmer. It augments the tour and
the language specification, both of which should be read first.
</p>

<h3 id="faq"><a href="/doc/faq">Frequently Asked Questions (FAQ)</a></h3>
<p>
Answers to common questions about Go.
</p>

<h3 id="wiki"><a href="/wiki">The Go Wiki</a></h3>
<p>A wiki maintained by the Go community.</p>

<h4 id="learn_more">More</h4>
<p>
See the <a href="/wiki/Learn">Learn</a> page at the <a href="/wiki">Wiki</a>
for more Go learning resources.
</p>


<h2 id="references">References</h2>

<h3 id="pkg"><a href="/pkg/">Package Documentation</a></h3>
<p>
The documentation for the Go standard library.
</p>

<h3 id="cmd"><a href="/doc/cmd">Command Documentation</a></h3>
<p>
The documentation for the Go tools.
</p>

<h3 id="spec"><a href="/ref/spec">Language Specification</a></h3>
<p>
The official Go Language specification.
</p>

<h3 id="go_mem"><a href="/ref/mem">The Go Memory Model</a></h3>
<p>
A document that specifies the conditions under which reads of a variable in
one goroutine can be guaranteed to observe values produced by writes to the
same variable in a different goroutine.
</p>

<h3 id="release"><a href="/doc/devel/release.html">Release History</a></h3>
<p>A summary of the changes between Go releases.</p>


<h2 id="articles">Articles</h2>

<h3 id="blog"><a href="//blog.golang.org/">The Go Blog</a></h3>
<p>The official blog of the Go project, featuring news and in-depth articles by
the Go team and guests.</p>

<h4>Codewalks</h4>
<p>
Guided tours of Go programs.
</p>
<ul>
<li><a href="/doc/codewalk/functions">First-Class Functions in Go</a></li>
<li><a href="/doc/codewalk/markov">Generating arbitrary text: a Markov chain algorithm</a></li>
<li><a href="/doc/codewalk/sharemem">Share Memory by Communicating</a></li>
<li><a href="/doc/articles/wiki/">Writing Web Applications</a> - building a simple web application.</li>
</ul>

<h4>Language</h4>
<ul>
<li><a href="/blog/json-rpc-tale-of-interfaces">JSON-RPC: a tale of interfaces</a></li>
<li><a href="/blog/gos-declaration-syntax">Go's Declaration Syntax</a></li>
<li><a href="/blog/defer-panic-and-recover">Defer, Panic, and Recover</a></li>
<li><a href="/blog/go-concurrency-patterns-timing-out-and">Go Concurrency Patterns: Timing out, moving on</a></li>
<li><a href="/blog/go-slices-usage-and-internals">Go Slices: usage and internals</a></li>
<li><a href="/blog/gif-decoder-exercise-in-go-interfaces">A GIF decoder: an exercise in Go interfaces</a></li>
<li><a href="/blog/error-handling-and-go">Error Handling and Go</a></li>
<li><a href="/blog/organizing-go-code">Organizing Go code</a></li>
</ul>

<h4>Packages</h4>
<ul>
<li><a href="/blog/json-and-go">JSON and Go</a> - using the <a href="/pkg/encoding/json/">json</a> package.</li>
<li><a href="/blog/gobs-of-data">Gobs of data</a> - the design and use of the <a href="/pkg/encoding/gob/">gob</a> package.</li>
<li><a href="/blog/laws-of-reflection">The Laws of Reflection</a> - the fundamentals of the <a href="/pkg/reflect/">reflect</a> package.</li>
<li><a href="/blog/go-image-package">The Go image package</a> - the fundamentals of the <a href="/pkg/image/">image</a> package.</li>
<li><a href="/blog/go-imagedraw-package">The Go image/draw package</a> - the fundamentals of the <a href="/pkg/image/draw/">image/draw</a> package.</li>
</ul>

<h4>Tools</h4>
<ul>
<li><a href="/doc/articles/go_command.html">About the Go command</a> - why we wrote it, what it is, what it's not, and how to use it.</li>
<li><a href="/blog/c-go-cgo">C? Go? Cgo!</a> - linking against C code with <a href="/cmd/cgo/">cgo</a>.</li>
<li><a href="/doc/gdb">Debugging Go Code with GDB</a></li>
<li><a href="/blog/godoc-documenting-go-code">Godoc: documenting Go code</a> - writing good documentation for <a href="/cmd/godoc/">godoc</a>.</li>
<li><a href="/blog/profiling-go-programs">Profiling Go Programs</a></li>
<li><a href="/doc/articles/race_detector.html">Data Race Detector</a> - a manual for the data race detector.</li>
<li><a href="/blog/race-detector">Introducing the Go Race Detector</a> - an introduction to the race detector.</li>
<li><a href="/doc/asm">A Quick Guide to Go's Assembler</a> - an introduction to the assembler used by Go.</li>
</ul>

<h4 id="articles_more">More</h4>
<p>
See the <a href="/wiki/Articles">Articles page</a> at the
<a href="/wiki">Wiki</a> for more Go articles.
</p>


<h2 id="talks">Talks</h2>

<img class="gopher" src="/doc/gopher/talks.png"/>

<h3 id="video_tour_of_go"><a href="http://research.swtch.com/gotour">A Video Tour of Go</a></h3>
<p>
Three things that make Go fast, fun, and productive:
interfaces, reflection, and concurrency. Builds a toy web crawler to
demonstrate these.
</p>

<h3 id="go_code_that_grows"><a href="//vimeo.com/53221560">Code that grows with grace</a></h3>
<p>
One of Go's key design goals is code adaptability; that it should be easy to take a simple design and build upon it in a clean and natural way. In this talk Andrew Gerrand describes a simple "chat roulette" server that matches pairs of incoming TCP connections, and then use Go's concurrency mechanisms, interfaces, and standard library to extend it with a web interface and other features. While the function of the program changes dramatically, Go's flexibility preserves the original design as it grows.
</p>

<h3 id="go_concurrency_patterns"><a href="//www.youtube.com/watch?v=f6kdp27TYZs">Go Concurrency Patterns</a></h3>
<p>
Concurrency is the key to designing high performance network services. Go's concurrency primitives (goroutines and channels) provide a simple and efficient means of expressing concurrent execution. In this talk we see how tricky concurrency problems can be solved gracefully with simple Go code.
</p>

<h3 id="advanced_go_concurrency_patterns"><a href="//www.youtube.com/watch?v=QDDwwePbDtw">Advanced Go Concurrency Patterns</a></h3>
<p>
This talk expands on the <i>Go Concurrency Patterns</i> talk to dive deeper into Go's concurrency primitives.
</p>

<h4 id="talks_more">More</h4>
<p>
See the <a href="/talks">Go Talks site</a> and <a href="/wiki/GoTalks">wiki page</a> for more Go talks.
</p>


<h2 id="nonenglish">Non-English Documentation</h2>

<p>
See the <a href="/wiki/NonEnglish">NonEnglish</a> page
at the <a href="/wiki">Wiki</a> for localized
documentation.
</p>
                     root/go1.4/doc/effective_go.html                                                                    0100644 0000000 0000000 00000343601 12600426225 015146  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Effective Go",
	"Template": true
}-->

<h2 id="introduction">Introduction</h2>

<p>
Go is a new language.  Although it borrows ideas from
existing languages,
it has unusual properties that make effective Go programs
different in character from programs written in its relatives.
A straightforward translation of a C++ or Java program into Go
is unlikely to produce a satisfactory result&mdash;Java programs
are written in Java, not Go.
On the other hand, thinking about the problem from a Go
perspective could produce a successful but quite different
program.
In other words,
to write Go well, it's important to understand its properties
and idioms.
It's also important to know the established conventions for
programming in Go, such as naming, formatting, program
construction, and so on, so that programs you write
will be easy for other Go programmers to understand.
</p>

<p>
This document gives tips for writing clear, idiomatic Go code.
It augments the <a href="/ref/spec">language specification</a>,
the <a href="//tour.golang.org/">Tour of Go</a>,
and <a href="/doc/code.html">How to Write Go Code</a>,
all of which you
should read first.
</p>

<h3 id="examples">Examples</h3>

<p>
The <a href="/src/">Go package sources</a>
are intended to serve not
only as the core library but also as examples of how to
use the language.
Moreover, many of the packages contain working, self-contained
executable examples you can run directly from the
<a href="//golang.org">golang.org</a> web site, such as
<a href="//golang.org/pkg/strings/#example_Map">this one</a> (if
necessary, click on the word "Example" to open it up).
If you have a question about how to approach a problem or how something
might be implemented, the documentation, code and examples in the
library can provide answers, ideas and
background.
</p>


<h2 id="formatting">Formatting</h2>

<p>
Formatting issues are the most contentious
but the least consequential.
People can adapt to different formatting styles
but it's better if they don't have to, and
less time is devoted to the topic
if everyone adheres to the same style.
The problem is how to approach this Utopia without a long
prescriptive style guide.
</p>

<p>
With Go we take an unusual
approach and let the machine
take care of most formatting issues.
The <code>gofmt</code> program
(also available as <code>go fmt</code>, which
operates at the package level rather than source file level)
reads a Go program
and emits the source in a standard style of indentation
and vertical alignment, retaining and if necessary
reformatting comments.
If you want to know how to handle some new layout
situation, run <code>gofmt</code>; if the answer doesn't
seem right, rearrange your program (or file a bug about <code>gofmt</code>),
don't work around it.
</p>

<p>
As an example, there's no need to spend time lining up
the comments on the fields of a structure.
<code>Gofmt</code> will do that for you.  Given the
declaration
</p>

<pre>
type T struct {
    name string // name of the object
    value int // its value
}
</pre>

<p>
<code>gofmt</code> will line up the columns:
</p>

<pre>
type T struct {
    name    string // name of the object
    value   int    // its value
}
</pre>

<p>
All Go code in the standard packages has been formatted with <code>gofmt</code>.
</p>


<p>
Some formatting details remain.  Very briefly:
</p>

<dl>
    <dt>Indentation</dt>
    <dd>We use tabs for indentation and <code>gofmt</code> emits them by default.
    Use spaces only if you must.
    </dd>
    <dt>Line length</dt>
    <dd>
    Go has no line length limit.  Don't worry about overflowing a punched card.
    If a line feels too long, wrap it and indent with an extra tab.
    </dd>
    <dt>Parentheses</dt>
    <dd>
    Go needs fewer parentheses than C and Java: control structures (<code>if</code>,
    <code>for</code>, <code>switch</code>) do not have parentheses in
    their syntax.
    Also, the operator precedence hierarchy is shorter and clearer, so
<pre>
x&lt;&lt;8 + y&lt;&lt;16
</pre>
    means what the spacing implies, unlike in the other languages.
    </dd>
</dl>

<h2 id="commentary">Commentary</h2>

<p>
Go provides C-style <code>/* */</code> block comments
and C++-style <code>//</code> line comments.
Line comments are the norm;
block comments appear mostly as package comments, but
are useful within an expression or to disable large swaths of code.
</p>

<p>
The program‚Äîand web server‚Äî<code>godoc</code> processes
Go source files to extract documentation about the contents of the
package.
Comments that appear before top-level declarations, with no intervening newlines,
are extracted along with the declaration to serve as explanatory text for the item.
The nature and style of these comments determines the
quality of the documentation <code>godoc</code> produces.
</p>

<p>
Every package should have a <i>package comment</i>, a block
comment preceding the package clause.
For multi-file packages, the package comment only needs to be
present in one file, and any one will do.
The package comment should introduce the package and
provide information relevant to the package as a whole.
It will appear first on the <code>godoc</code> page and
should set up the detailed documentation that follows.
</p>

<pre>
/*
Package regexp implements a simple library for regular expressions.

The syntax of the regular expressions accepted is:

    regexp:
        concatenation { '|' concatenation }
    concatenation:
        { closure }
    closure:
        term [ '*' | '+' | '?' ]
    term:
        '^'
        '$'
        '.'
        character
        '[' [ '^' ] character-ranges ']'
        '(' regexp ')'
*/
package regexp
</pre>

<p>
If the package is simple, the package comment can be brief.
</p>

<pre>
// Package path implements utility routines for
// manipulating slash-separated filename paths.
</pre>

<p>
Comments do not need extra formatting such as banners of stars.
The generated output may not even be presented in a fixed-width font, so don't depend
on spacing for alignment&mdash;<code>godoc</code>, like <code>gofmt</code>,
takes care of that.
The comments are uninterpreted plain text, so HTML and other
annotations such as <code>_this_</code> will reproduce <i>verbatim</i> and should
not be used.
One adjustment <code>godoc</code> does do is to display indented
text in a fixed-width font, suitable for program snippets.
The package comment for the
<a href="/pkg/fmt/"><code>fmt</code> package</a> uses this to good effect.
</p>

<p>
Depending on the context, <code>godoc</code> might not even
reformat comments, so make sure they look good straight up:
use correct spelling, punctuation, and sentence structure,
fold long lines, and so on.
</p>

<p>
Inside a package, any comment immediately preceding a top-level declaration
serves as a <i>doc comment</i> for that declaration.
Every exported (capitalized) name in a program should
have a doc comment.
</p>

<p>
Doc comments work best as complete sentences, which allow
a wide variety of automated presentations.
The first sentence should be a one-sentence summary that
starts with the name being declared.
</p>

<pre>
// Compile parses a regular expression and returns, if successful, a Regexp
// object that can be used to match against text.
func Compile(str string) (regexp *Regexp, err error) {
</pre>

<p>
If the name always begins the comment, the output of <code>godoc</code>
can usefully be run through <code>grep</code>.
Imagine you couldn't remember the name "Compile" but were looking for
the parsing function for regular expressions, so you ran
the command,
</p>

<pre>
$ godoc regexp | grep parse
</pre>

<p>
If all the doc comments in the package began, "This function...", <code>grep</code>
wouldn't help you remember the name. But because the package starts each
doc comment with the name, you'd see something like this,
which recalls the word you're looking for.
</p>

<pre>
$ godoc regexp | grep parse
    Compile parses a regular expression and returns, if successful, a Regexp
    parsed. It simplifies safe initialization of global variables holding
    cannot be parsed. It simplifies safe initialization of global variables
$
</pre>

<p>
Go's declaration syntax allows grouping of declarations.
A single doc comment can introduce a group of related constants or variables.
Since the whole declaration is presented, such a comment can often be perfunctory.
</p>

<pre>
// Error codes returned by failures to parse an expression.
var (
    ErrInternal      = errors.New("regexp: internal error")
    ErrUnmatchedLpar = errors.New("regexp: unmatched '('")
    ErrUnmatchedRpar = errors.New("regexp: unmatched ')'")
    ...
)
</pre>

<p>
Grouping can also indicate relationships between items,
such as the fact that a set of variables is protected by a mutex.
</p>

<pre>
var (
    countLock   sync.Mutex
    inputCount  uint32
    outputCount uint32
    errorCount  uint32
)
</pre>

<h2 id="names">Names</h2>

<p>
Names are as important in Go as in any other language.
They even have semantic effect:
the visibility of a name outside a package is determined by whether its
first character is upper case.
It's therefore worth spending a little time talking about naming conventions
in Go programs.
</p>


<h3 id="package-names">Package names</h3>

<p>
When a package is imported, the package name becomes an accessor for the
contents.  After
</p>

<pre>
import "bytes"
</pre>

<p>
the importing package can talk about <code>bytes.Buffer</code>.  It's
helpful if everyone using the package can use the same name to refer to
its contents, which implies that the package name should be good:
short, concise, evocative.  By convention, packages are given
lower case, single-word names; there should be no need for underscores
or mixedCaps.
Err on the side of brevity, since everyone using your
package will be typing that name.
And don't worry about collisions <i>a priori</i>.
The package name is only the default name for imports; it need not be unique
across all source code, and in the rare case of a collision the
importing package can choose a different name to use locally.
In any case, confusion is rare because the file name in the import
determines just which package is being used.
</p>

<p>
Another convention is that the package name is the base name of
its source directory;
the package in <code>src/encoding/base64</code>
is imported as <code>"encoding/base64"</code> but has name <code>base64</code>,
not <code>encoding_base64</code> and not <code>encodingBase64</code>.
</p>

<p>
The importer of a package will use the name to refer to its contents,
so exported names in the package can use that fact
to avoid stutter.
(Don't use the <code>import .</code> notation, which can simplify
tests that must run outside the package they are testing, but should otherwise be avoided.)
For instance, the buffered reader type in the <code>bufio</code> package is called <code>Reader</code>,
not <code>BufReader</code>, because users see it as <code>bufio.Reader</code>,
which is a clear, concise name.
Moreover,
because imported entities are always addressed with their package name, <code>bufio.Reader</code>
does not conflict with <code>io.Reader</code>.
Similarly, the function to make new instances of <code>ring.Ring</code>&mdash;which
is the definition of a <em>constructor</em> in Go&mdash;would
normally be called <code>NewRing</code>, but since
<code>Ring</code> is the only type exported by the package, and since the
package is called <code>ring</code>, it's called just <code>New</code>,
which clients of the package see as <code>ring.New</code>.
Use the package structure to help you choose good names.
</p>

<p>
Another short example is <code>once.Do</code>;
<code>once.Do(setup)</code> reads well and would not be improved by
writing <code>once.DoOrWaitUntilDone(setup)</code>.
Long names don't automatically make things more readable.
A helpful doc comment can often be more valuable than an extra long name.
</p>

<h3 id="Getters">Getters</h3>

<p>
Go doesn't provide automatic support for getters and setters.
There's nothing wrong with providing getters and setters yourself,
and it's often appropriate to do so, but it's neither idiomatic nor necessary
to put <code>Get</code> into the getter's name.  If you have a field called
<code>owner</code> (lower case, unexported), the getter method should be
called <code>Owner</code> (upper case, exported), not <code>GetOwner</code>.
The use of upper-case names for export provides the hook to discriminate
the field from the method.
A setter function, if needed, will likely be called <code>SetOwner</code>.
Both names read well in practice:
</p>
<pre>
owner := obj.Owner()
if owner != user {
    obj.SetOwner(user)
}
</pre>

<h3 id="interface-names">Interface names</h3>

<p>
By convention, one-method interfaces are named by
the method name plus an -er suffix or similar modification
to construct an agent noun: <code>Reader</code>,
<code>Writer</code>, <code>Formatter</code>,
<code>CloseNotifier</code> etc.
</p>

<p>
There are a number of such names and it's productive to honor them and the function
names they capture.
<code>Read</code>, <code>Write</code>, <code>Close</code>, <code>Flush</code>,
<code>String</code> and so on have
canonical signatures and meanings.  To avoid confusion,
don't give your method one of those names unless it
has the same signature and meaning.
Conversely, if your type implements a method with the
same meaning as a method on a well-known type,
give it the same name and signature;
call your string-converter method <code>String</code> not <code>ToString</code>.
</p>

<h3 id="mixed-caps">MixedCaps</h3>

<p>
Finally, the convention in Go is to use <code>MixedCaps</code>
or <code>mixedCaps</code> rather than underscores to write
multiword names.
</p>

<h2 id="semicolons">Semicolons</h2>

<p>
Like C, Go's formal grammar uses semicolons to terminate statements,
but unlike in C, those semicolons do not appear in the source.
Instead the lexer uses a simple rule to insert semicolons automatically
as it scans, so the input text is mostly free of them.
</p>

<p>
The rule is this. If the last token before a newline is an identifier
(which includes words like <code>int</code> and <code>float64</code>),
a basic literal such as a number or string constant, or one of the
tokens
</p>
<pre>
break continue fallthrough return ++ -- ) }
</pre>
<p>
the lexer always inserts a semicolon after the token.
This could be summarized as, &ldquo;if the newline comes
after a token that could end a statement, insert a semicolon&rdquo;.
</p>

<p>
A semicolon can also be omitted immediately before a closing brace,
so a statement such as
</p>
<pre>
    go func() { for { dst &lt;- &lt;-src } }()
</pre>
<p>
needs no semicolons.
Idiomatic Go programs have semicolons only in places such as
<code>for</code> loop clauses, to separate the initializer, condition, and
continuation elements.  They are also necessary to separate multiple
statements on a line, should you write code that way.
</p>

<p>
One consequence of the semicolon insertion rules
is that you cannot put the opening brace of a
control structure (<code>if</code>, <code>for</code>, <code>switch</code>,
or <code>select</code>) on the next line.  If you do, a semicolon
will be inserted before the brace, which could cause unwanted
effects.  Write them like this
</p>

<pre>
if i &lt; f() {
    g()
}
</pre>
<p>
not like this
</p>
<pre>
if i &lt; f()  // wrong!
{           // wrong!
    g()
}
</pre>


<h2 id="control-structures">Control structures</h2>

<p>
The control structures of Go are related to those of C but differ
in important ways.
There is no <code>do</code> or <code>while</code> loop, only a
slightly generalized
<code>for</code>;
<code>switch</code> is more flexible;
<code>if</code> and <code>switch</code> accept an optional
initialization statement like that of <code>for</code>;
<code>break</code> and <code>continue</code> statements
take an optional label to identify what to break or continue;
and there are new control structures including a type switch and a
multiway communications multiplexer, <code>select</code>.
The syntax is also slightly different:
there are no parentheses
and the bodies must always be brace-delimited.
</p>

<h3 id="if">If</h3>

<p>
In Go a simple <code>if</code> looks like this:
</p>
<pre>
if x &gt; 0 {
    return y
}
</pre>

<p>
Mandatory braces encourage writing simple <code>if</code> statements
on multiple lines.  It's good style to do so anyway,
especially when the body contains a control statement such as a
<code>return</code> or <code>break</code>.
</p>

<p>
Since <code>if</code> and <code>switch</code> accept an initialization
statement, it's common to see one used to set up a local variable.
</p>

<pre>
if err := file.Chmod(0664); err != nil {
    log.Print(err)
    return err
}
</pre>

<p id="else">
In the Go libraries, you'll find that
when an <code>if</code> statement doesn't flow into the next statement‚Äîthat is,
the body ends in <code>break</code>, <code>continue</code>,
<code>goto</code>, or <code>return</code>‚Äîthe unnecessary
<code>else</code> is omitted.
</p>

<pre>
f, err := os.Open(name)
if err != nil {
    return err
}
codeUsing(f)
</pre>

<p>
This is an example of a common situation where code must guard against a
sequence of error conditions.  The code reads well if the
successful flow of control runs down the page, eliminating error cases
as they arise.  Since error cases tend to end in <code>return</code>
statements, the resulting code needs no <code>else</code> statements.
</p>

<pre>
f, err := os.Open(name)
if err != nil {
    return err
}
d, err := f.Stat()
if err != nil {
    f.Close()
    return err
}
codeUsing(f, d)
</pre>


<h3 id="redeclaration">Redeclaration and reassignment</h3>

<p>
An aside: The last example in the previous section demonstrates a detail of how the
<code>:=</code> short declaration form works.
The declaration that calls <code>os.Open</code> reads,
</p>

<pre>
f, err := os.Open(name)
</pre>

<p>
This statement declares two variables, <code>f</code> and <code>err</code>.
A few lines later, the call to <code>f.Stat</code> reads,
</p>

<pre>
d, err := f.Stat()
</pre>

<p>
which looks as if it declares <code>d</code> and <code>err</code>.
Notice, though, that <code>err</code> appears in both statements.
This duplication is legal: <code>err</code> is declared by the first statement,
but only <em>re-assigned</em> in the second.
This means that the call to <code>f.Stat</code> uses the existing
<code>err</code> variable declared above, and just gives it a new value.
</p>

<p>
In a <code>:=</code> declaration a variable <code>v</code> may appear even
if it has already been declared, provided:
</p>

<ul>
<li>this declaration is in the same scope as the existing declaration of <code>v</code>
(if <code>v</code> is already declared in an outer scope, the declaration will create a new variable ¬ß),</li>
<li>the corresponding value in the initialization is assignable to <code>v</code>, and</li>
<li>there is at least one other variable in the declaration that is being declared anew.</li>
</ul>

<p>
This unusual property is pure pragmatism,
making it easy to use a single <code>err</code> value, for example,
in a long <code>if-else</code> chain.
You'll see it used often.
</p>

<p>
¬ß It's worth noting here that in Go the scope of function parameters and return values
is the same as the function body, even though they appear lexically outside the braces
that enclose the body.
</p>

<h3 id="for">For</h3>

<p>
The Go <code>for</code> loop is similar to&mdash;but not the same as&mdash;C's.
It unifies <code>for</code>
and <code>while</code> and there is no <code>do-while</code>.
There are three forms, only one of which has semicolons.
</p>
<pre>
// Like a C for
for init; condition; post { }

// Like a C while
for condition { }

// Like a C for(;;)
for { }
</pre>

<p>
Short declarations make it easy to declare the index variable right in the loop.
</p>
<pre>
sum := 0
for i := 0; i &lt; 10; i++ {
    sum += i
}
</pre>

<p>
If you're looping over an array, slice, string, or map,
or reading from a channel, a <code>range</code> clause can
manage the loop.
</p>
<pre>
for key, value := range oldMap {
    newMap[key] = value
}
</pre>

<p>
If you only need the first item in the range (the key or index), drop the second:
</p>
<pre>
for key := range m {
    if key.expired() {
        delete(m, key)
    }
}
</pre>

<p>
If you only need the second item in the range (the value), use the <em>blank identifier</em>, an underscore, to discard the first:
</p>
<pre>
sum := 0
for _, value := range array {
    sum += value
}
</pre>

<p>
The blank identifier has many uses, as described in <a href="#blank">a later section</a>.
</p>

<p>
For strings, the <code>range</code> does more work for you, breaking out individual
Unicode code points by parsing the UTF-8.
Erroneous encodings consume one byte and produce the
replacement rune U+FFFD.
(The name (with associated builtin type) <code>rune</code> is Go terminology for a
single Unicode code point.
See <a href="/ref/spec#Rune_literals">the language specification</a>
for details.)
The loop
</p>
<pre>
for pos, char := range "Êó•Êú¨\x80Ë™û" { // \x80 is an illegal UTF-8 encoding
    fmt.Printf("character %#U starts at byte position %d\n", char, pos)
}
</pre>
<p>
prints
</p>
<pre>
character U+65E5 'Êó•' starts at byte position 0
character U+672C 'Êú¨' starts at byte position 3
character U+FFFD 'ÔøΩ' starts at byte position 6
character U+8A9E 'Ë™û' starts at byte position 7
</pre>

<p>
Finally, Go has no comma operator and <code>++</code> and <code>--</code>
are statements not expressions.
Thus if you want to run multiple variables in a <code>for</code>
you should use parallel assignment (although that precludes <code>++</code> and <code>--</code>).
</p>
<pre>
// Reverse a
for i, j := 0, len(a)-1; i &lt; j; i, j = i+1, j-1 {
    a[i], a[j] = a[j], a[i]
}
</pre>

<h3 id="switch">Switch</h3>

<p>
Go's <code>switch</code> is more general than C's.
The expressions need not be constants or even integers,
the cases are evaluated top to bottom until a match is found,
and if the <code>switch</code> has no expression it switches on
<code>true</code>.
It's therefore possible&mdash;and idiomatic&mdash;to write an
<code>if</code>-<code>else</code>-<code>if</code>-<code>else</code>
chain as a <code>switch</code>.
</p>

<pre>
func unhex(c byte) byte {
    switch {
    case '0' &lt;= c &amp;&amp; c &lt;= '9':
        return c - '0'
    case 'a' &lt;= c &amp;&amp; c &lt;= 'f':
        return c - 'a' + 10
    case 'A' &lt;= c &amp;&amp; c &lt;= 'F':
        return c - 'A' + 10
    }
    return 0
}
</pre>

<p>
There is no automatic fall through, but cases can be presented
in comma-separated lists.
</p>
<pre>
func shouldEscape(c byte) bool {
    switch c {
    case ' ', '?', '&amp;', '=', '#', '+', '%':
        return true
    }
    return false
}
</pre>

<p>
Although they are not nearly as common in Go as some other C-like
languages, <code>break</code> statements can be used to terminate
a <code>switch</code> early.
Sometimes, though, it's necessary to break out of a surrounding loop,
not the switch, and in Go that can be accomplished by putting a label
on the loop and "breaking" to that label.
This example shows both uses.
</p>

<pre>
Loop:
	for n := 0; n &lt; len(src); n += size {
		switch {
		case src[n] &lt; sizeOne:
			if validateOnly {
				break
			}
			size = 1
			update(src[n])

		case src[n] &lt; sizeTwo:
			if n+1 &gt;= len(src) {
				err = errShortInput
				break Loop
			}
			if validateOnly {
				break
			}
			size = 2
			update(src[n] + src[n+1]&lt;&lt;shift)
		}
	}
</pre>

<p>
Of course, the <code>continue</code> statement also accepts an optional label
but it applies only to loops.
</p>

<p>
To close this section, here's a comparison routine for byte slices that uses two
<code>switch</code> statements:
</p>
<pre>
// Compare returns an integer comparing the two byte slices,
// lexicographically.
// The result will be 0 if a == b, -1 if a &lt; b, and +1 if a &gt; b
func Compare(a, b []byte) int {
    for i := 0; i &lt; len(a) &amp;&amp; i &lt; len(b); i++ {
        switch {
        case a[i] &gt; b[i]:
            return 1
        case a[i] &lt; b[i]:
            return -1
        }
    }
    switch {
    case len(a) &gt; len(b):
        return 1
    case len(a) &lt; len(b):
        return -1
    }
    return 0
}
</pre>

<h3 id="type_switch">Type switch</h3>

<p>
A switch can also be used to discover the dynamic type of an interface
variable.  Such a <em>type switch</em> uses the syntax of a type
assertion with the keyword <code>type</code> inside the parentheses.
If the switch declares a variable in the expression, the variable will
have the corresponding type in each clause.
It's also idiomatic to reuse the name in such cases, in effect declaring
a new variable with the same name but a different type in each case.
</p>
<pre>
var t interface{}
t = functionOfSomeType()
switch t := t.(type) {
default:
    fmt.Printf("unexpected type %T", t)       // %T prints whatever type t has
case bool:
    fmt.Printf("boolean %t\n", t)             // t has type bool
case int:
    fmt.Printf("integer %d\n", t)             // t has type int
case *bool:
    fmt.Printf("pointer to boolean %t\n", *t) // t has type *bool
case *int:
    fmt.Printf("pointer to integer %d\n", *t) // t has type *int
}
</pre>

<h2 id="functions">Functions</h2>

<h3 id="multiple-returns">Multiple return values</h3>

<p>
One of Go's unusual features is that functions and methods
can return multiple values.  This form can be used to
improve on a couple of clumsy idioms in C programs: in-band
error returns such as <code>-1</code> for <code>EOF</code>
and modifying an argument passed by address.
</p>

<p>
In C, a write error is signaled by a negative count with the
error code secreted away in a volatile location.
In Go, <code>Write</code>
can return a count <i>and</i> an error: &ldquo;Yes, you wrote some
bytes but not all of them because you filled the device&rdquo;.
The signature of the <code>Write</code> method on files from
package <code>os</code> is:
</p>

<pre>
func (file *File) Write(b []byte) (n int, err error)
</pre>

<p>
and as the documentation says, it returns the number of bytes
written and a non-nil <code>error</code> when <code>n</code>
<code>!=</code> <code>len(b)</code>.
This is a common style; see the section on error handling for more examples.
</p>

<p>
A similar approach obviates the need to pass a pointer to a return
value to simulate a reference parameter.
Here's a simple-minded function to
grab a number from a position in a byte slice, returning the number
and the next position.
</p>

<pre>
func nextInt(b []byte, i int) (int, int) {
    for ; i &lt; len(b) &amp;&amp; !isDigit(b[i]); i++ {
    }
    x := 0
    for ; i &lt; len(b) &amp;&amp; isDigit(b[i]); i++ {
        x = x*10 + int(b[i]) - '0'
    }
    return x, i
}
</pre>

<p>
You could use it to scan the numbers in an input slice <code>b</code> like this:
</p>

<pre>
    for i := 0; i &lt; len(b); {
        x, i = nextInt(b, i)
        fmt.Println(x)
    }
</pre>

<h3 id="named-results">Named result parameters</h3>

<p>
The return or result "parameters" of a Go function can be given names and
used as regular variables, just like the incoming parameters.
When named, they are initialized to the zero values for their types when
the function begins; if the function executes a <code>return</code> statement
with no arguments, the current values of the result parameters are
used as the returned values.
</p>

<p>
The names are not mandatory but they can make code shorter and clearer:
they're documentation.
If we name the results of <code>nextInt</code> it becomes
obvious which returned <code>int</code>
is which.
</p>

<pre>
func nextInt(b []byte, pos int) (value, nextPos int) {
</pre>

<p>
Because named results are initialized and tied to an unadorned return, they can simplify
as well as clarify.  Here's a version
of <code>io.ReadFull</code> that uses them well:
</p>

<pre>
func ReadFull(r Reader, buf []byte) (n int, err error) {
    for len(buf) &gt; 0 &amp;&amp; err == nil {
        var nr int
        nr, err = r.Read(buf)
        n += nr
        buf = buf[nr:]
    }
    return
}
</pre>

<h3 id="defer">Defer</h3>

<p>
Go's <code>defer</code> statement schedules a function call (the
<i>deferred</i> function) to be run immediately before the function
executing the <code>defer</code> returns.  It's an unusual but
effective way to deal with situations such as resources that must be
released regardless of which path a function takes to return.  The
canonical examples are unlocking a mutex or closing a file.
</p>

<pre>
// Contents returns the file's contents as a string.
func Contents(filename string) (string, error) {
    f, err := os.Open(filename)
    if err != nil {
        return "", err
    }
    defer f.Close()  // f.Close will run when we're finished.

    var result []byte
    buf := make([]byte, 100)
    for {
        n, err := f.Read(buf[0:])
        result = append(result, buf[0:n]...) // append is discussed later.
        if err != nil {
            if err == io.EOF {
                break
            }
            return "", err  // f will be closed if we return here.
        }
    }
    return string(result), nil // f will be closed if we return here.
}
</pre>

<p>
Deferring a call to a function such as <code>Close</code> has two advantages.  First, it
guarantees that you will never forget to close the file, a mistake
that's easy to make if you later edit the function to add a new return
path.  Second, it means that the close sits near the open,
which is much clearer than placing it at the end of the function.
</p>

<p>
The arguments to the deferred function (which include the receiver if
the function is a method) are evaluated when the <i>defer</i>
executes, not when the <i>call</i> executes.  Besides avoiding worries
about variables changing values as the function executes, this means
that a single deferred call site can defer multiple function
executions.  Here's a silly example.
</p>

<pre>
for i := 0; i &lt; 5; i++ {
    defer fmt.Printf("%d ", i)
}
</pre>

<p>
Deferred functions are executed in LIFO order, so this code will cause
<code>4 3 2 1 0</code> to be printed when the function returns.  A
more plausible example is a simple way to trace function execution
through the program.  We could write a couple of simple tracing
routines like this:
</p>

<pre>
func trace(s string)   { fmt.Println("entering:", s) }
func untrace(s string) { fmt.Println("leaving:", s) }

// Use them like this:
func a() {
    trace("a")
    defer untrace("a")
    // do something....
}
</pre>

<p>
We can do better by exploiting the fact that arguments to deferred
functions are evaluated when the <code>defer</code> executes.  The
tracing routine can set up the argument to the untracing routine.
This example:
</p>

<pre>
func trace(s string) string {
    fmt.Println("entering:", s)
    return s
}

func un(s string) {
    fmt.Println("leaving:", s)
}

func a() {
    defer un(trace("a"))
    fmt.Println("in a")
}

func b() {
    defer un(trace("b"))
    fmt.Println("in b")
    a()
}

func main() {
    b()
}
</pre>

<p>
prints
</p>

<pre>
entering: b
in b
entering: a
in a
leaving: a
leaving: b
</pre>

<p>
For programmers accustomed to block-level resource management from
other languages, <code>defer</code> may seem peculiar, but its most
interesting and powerful applications come precisely from the fact
that it's not block-based but function-based.  In the section on
<code>panic</code> and <code>recover</code> we'll see another
example of its possibilities.
</p>

<h2 id="data">Data</h2>

<h3 id="allocation_new">Allocation with <code>new</code></h3>

<p>
Go has two allocation primitives, the built-in functions
<code>new</code> and <code>make</code>.
They do different things and apply to different types, which can be confusing,
but the rules are simple.
Let's talk about <code>new</code> first.
It's a built-in function that allocates memory, but unlike its namesakes
in some other languages it does not <em>initialize</em> the memory,
it only <em>zeros</em> it.
That is,
<code>new(T)</code> allocates zeroed storage for a new item of type
<code>T</code> and returns its address, a value of type <code>*T</code>.
In Go terminology, it returns a pointer to a newly allocated zero value of type
<code>T</code>.
</p>

<p>
Since the memory returned by <code>new</code> is zeroed, it's helpful to arrange
when designing your data structures that the
zero value of each type can be used without further initialization.  This means a user of
the data structure can create one with <code>new</code> and get right to
work.
For example, the documentation for <code>bytes.Buffer</code> states that
"the zero value for <code>Buffer</code> is an empty buffer ready to use."
Similarly, <code>sync.Mutex</code> does not
have an explicit constructor or <code>Init</code> method.
Instead, the zero value for a <code>sync.Mutex</code>
is defined to be an unlocked mutex.
</p>

<p>
The zero-value-is-useful property works transitively. Consider this type declaration.
</p>

<pre>
type SyncedBuffer struct {
    lock    sync.Mutex
    buffer  bytes.Buffer
}
</pre>

<p>
Values of type <code>SyncedBuffer</code> are also ready to use immediately upon allocation
or just declaration.  In the next snippet, both <code>p</code> and <code>v</code> will work
correctly without further arrangement.
</p>

<pre>
p := new(SyncedBuffer)  // type *SyncedBuffer
var v SyncedBuffer      // type  SyncedBuffer
</pre>

<h3 id="composite_literals">Constructors and composite literals</h3>

<p>
Sometimes the zero value isn't good enough and an initializing
constructor is necessary, as in this example derived from
package <code>os</code>.
</p>

<pre>
func NewFile(fd int, name string) *File {
    if fd &lt; 0 {
        return nil
    }
    f := new(File)
    f.fd = fd
    f.name = name
    f.dirinfo = nil
    f.nepipe = 0
    return f
}
</pre>

<p>
There's a lot of boiler plate in there.  We can simplify it
using a <i>composite literal</i>, which is
an expression that creates a
new instance each time it is evaluated.
</p>

<pre>
func NewFile(fd int, name string) *File {
    if fd &lt; 0 {
        return nil
    }
    f := File{fd, name, nil, 0}
    return &amp;f
}
</pre>

<p>
Note that, unlike in C, it's perfectly OK to return the address of a local variable;
the storage associated with the variable survives after the function
returns.
In fact, taking the address of a composite literal
allocates a fresh instance each time it is evaluated,
so we can combine these last two lines.
</p>

<pre>
    return &amp;File{fd, name, nil, 0}
</pre>

<p>
The fields of a composite literal are laid out in order and must all be present.
However, by labeling the elements explicitly as <i>field</i><code>:</code><i>value</i>
pairs, the initializers can appear in any
order, with the missing ones left as their respective zero values.  Thus we could say
</p>

<pre>
    return &amp;File{fd: fd, name: name}
</pre>

<p>
As a limiting case, if a composite literal contains no fields at all, it creates
a zero value for the type.  The expressions <code>new(File)</code> and <code>&amp;File{}</code> are equivalent.
</p>

<p>
Composite literals can also be created for arrays, slices, and maps,
with the field labels being indices or map keys as appropriate.
In these examples, the initializations work regardless of the values of <code>Enone</code>,
<code>Eio</code>, and <code>Einval</code>, as long as they are distinct.
</p>

<pre>
a := [...]string   {Enone: "no error", Eio: "Eio", Einval: "invalid argument"}
s := []string      {Enone: "no error", Eio: "Eio", Einval: "invalid argument"}
m := map[int]string{Enone: "no error", Eio: "Eio", Einval: "invalid argument"}
</pre>

<h3 id="allocation_make">Allocation with <code>make</code></h3>

<p>
Back to allocation.
The built-in function <code>make(T, </code><i>args</i><code>)</code> serves
a purpose different from <code>new(T)</code>.
It creates slices, maps, and channels only, and it returns an <em>initialized</em>
(not <em>zeroed</em>)
value of type <code>T</code> (not <code>*T</code>).
The reason for the distinction
is that these three types represent, under the covers, references to data structures that
must be initialized before use.
A slice, for example, is a three-item descriptor
containing a pointer to the data (inside an array), the length, and the
capacity, and until those items are initialized, the slice is <code>nil</code>.
For slices, maps, and channels,
<code>make</code> initializes the internal data structure and prepares
the value for use.
For instance,
</p>

<pre>
make([]int, 10, 100)
</pre>

<p>
allocates an array of 100 ints and then creates a slice
structure with length 10 and a capacity of 100 pointing at the first
10 elements of the array.
(When making a slice, the capacity can be omitted; see the section on slices
for more information.)
In contrast, <code>new([]int)</code> returns a pointer to a newly allocated, zeroed slice
structure, that is, a pointer to a <code>nil</code> slice value.
</p>

<p>
These examples illustrate the difference between <code>new</code> and
<code>make</code>.
</p>

<pre>
var p *[]int = new([]int)       // allocates slice structure; *p == nil; rarely useful
var v  []int = make([]int, 100) // the slice v now refers to a new array of 100 ints

// Unnecessarily complex:
var p *[]int = new([]int)
*p = make([]int, 100, 100)

// Idiomatic:
v := make([]int, 100)
</pre>

<p>
Remember that <code>make</code> applies only to maps, slices and channels
and does not return a pointer.
To obtain an explicit pointer allocate with <code>new</code> or take the address
of a variable explicitly.
</p>

<h3 id="arrays">Arrays</h3>

<p>
Arrays are useful when planning the detailed layout of memory and sometimes
can help avoid allocation, but primarily
they are a building block for slices, the subject of the next section.
To lay the foundation for that topic, here are a few words about arrays.
</p>

<p>
There are major differences between the ways arrays work in Go and C.
In Go,
</p>
<ul>
<li>
Arrays are values. Assigning one array to another copies all the elements.
</li>
<li>
In particular, if you pass an array to a function, it
will receive a <i>copy</i> of the array, not a pointer to it.
<li>
The size of an array is part of its type.  The types <code>[10]int</code>
and <code>[20]int</code> are distinct.
</li>
</ul>

<p>
The value property can be useful but also expensive; if you want C-like behavior and efficiency,
you can pass a pointer to the array.
</p>

<pre>
func Sum(a *[3]float64) (sum float64) {
    for _, v := range *a {
        sum += v
    }
    return
}

array := [...]float64{7.0, 8.5, 9.1}
x := Sum(&amp;array)  // Note the explicit address-of operator
</pre>

<p>
But even this style isn't idiomatic Go.
Use slices instead.
</p>

<h3 id="slices">Slices</h3>

<p>
Slices wrap arrays to give a more general, powerful, and convenient
interface to sequences of data.  Except for items with explicit
dimension such as transformation matrices, most array programming in
Go is done with slices rather than simple arrays.
</p>
<p>
Slices hold references to an underlying array, and if you assign one
slice to another, both refer to the same array.
If a function takes a slice argument, changes it makes to
the elements of the slice will be visible to the caller, analogous to
passing a pointer to the underlying array.  A <code>Read</code>
function can therefore accept a slice argument rather than a pointer
and a count; the length within the slice sets an upper
limit of how much data to read.  Here is the signature of the
<code>Read</code> method of the <code>File</code> type in package
<code>os</code>:
</p>
<pre>
func (file *File) Read(buf []byte) (n int, err error)
</pre>
<p>
The method returns the number of bytes read and an error value, if
any.
To read into the first 32 bytes of a larger buffer
<code>buf</code>, <i>slice</i> (here used as a verb) the buffer.
</p>
<pre>
    n, err := f.Read(buf[0:32])
</pre>
<p>
Such slicing is common and efficient.  In fact, leaving efficiency aside for
the moment, the following snippet would also read the first 32 bytes of the buffer.
</p>
<pre>
    var n int
    var err error
    for i := 0; i &lt; 32; i++ {
        nbytes, e := f.Read(buf[i:i+1])  // Read one byte.
        if nbytes == 0 || e != nil {
            err = e
            break
        }
        n += nbytes
    }
</pre>
<p>
The length of a slice may be changed as long as it still fits within
the limits of the underlying array; just assign it to a slice of
itself.  The <i>capacity</i> of a slice, accessible by the built-in
function <code>cap</code>, reports the maximum length the slice may
assume.  Here is a function to append data to a slice.  If the data
exceeds the capacity, the slice is reallocated.  The
resulting slice is returned.  The function uses the fact that
<code>len</code> and <code>cap</code> are legal when applied to the
<code>nil</code> slice, and return 0.
</p>
<pre>
func Append(slice, data[]byte) []byte {
    l := len(slice)
    if l + len(data) &gt; cap(slice) {  // reallocate
        // Allocate double what's needed, for future growth.
        newSlice := make([]byte, (l+len(data))*2)
        // The copy function is predeclared and works for any slice type.
        copy(newSlice, slice)
        slice = newSlice
    }
    slice = slice[0:l+len(data)]
    for i, c := range data {
        slice[l+i] = c
    }
    return slice
}
</pre>
<p>
We must return the slice afterwards because, although <code>Append</code>
can modify the elements of <code>slice</code>, the slice itself (the run-time data
structure holding the pointer, length, and capacity) is passed by value.
</p>

<p>
The idea of appending to a slice is so useful it's captured by the
<code>append</code> built-in function.  To understand that function's
design, though, we need a little more information, so we'll return
to it later.
</p>

<h3 id="two_dimensional_slices">Two-dimensional slices</h3>

<p>
Go's arrays and slices are one-dimensional.
To create the equivalent of a 2D array or slice, it is necessary to define an array-of-arrays
or slice-of-slices, like this:
</p>

<pre>
type Transform [3][3]float64  // A 3x3 array, really an array of arrays.
type LinesOfText [][]byte     // A slice of byte slices.
</pre>

<p>
Because slices are variable-length, it is possible to have each inner
slice be a different length.
That can be a common situation, as in our <code>LinesOfText</code>
example: each line has an independent length.
</p>

<pre>
text := LinesOfText{
	[]byte("Now is the time"),
	[]byte("for all good gophers"),
	[]byte("to bring some fun to the party."),
}
</pre>

<p>
Sometimes it's necessary to allocate a 2D slice, a situation that can arise when
processing scan lines of pixels, for instance.
There are two ways to achieve this.
One is to allocate each slice independently; the other
is to allocate a single array and point the individual slices into it.
Which to use depends on your application.
If the slices might grow or shrink, they should be allocated independently
to avoid overwriting the next line; if not, it can be more efficient to construct
the object with a single allocation.
For reference, here are sketches of the two methods.
First, a line at a time:
</p>

<pre>
// Allocate the top-level slice.
picture := make([][]uint8, YSize) // One row per unit of y.
// Loop over the rows, allocating the slice for each row.
for i := range picture {
	picture[i] = make([]uint8, XSize)
}
</pre>

<p>
And now as one allocation, sliced into lines:
</p>

<pre>
// Allocate the top-level slice, the same as before.
picture := make([][]uint8, YSize) // One row per unit of y.
// Allocate one large slice to hold all the pixels.
pixels := make([]uint8, XSize*YSize) // Has type []uint8 even though picture is [][]uint8.
// Loop over the rows, slicing each row from the front of the remaining pixels slice.
for i := range picture {
	picture[i], pixels = pixels[:XSize], pixels[XSize:]
}
</pre>

<h3 id="maps">Maps</h3>

<p>
Maps are a convenient and powerful built-in data structure that associate
values of one type (the <em>key</em>) with values of another type
(the <em>element</em> or <em>value</em>)
The key can be of any type for which the equality operator is defined,
such as integers,
floating point and complex numbers,
strings, pointers, interfaces (as long as the dynamic type
supports equality), structs and arrays.
Slices cannot be used as map keys,
because equality is not defined on them.
Like slices, maps hold references to an underlying data structure.
If you pass a map to a function
that changes the contents of the map, the changes will be visible
in the caller.
</p>
<p>
Maps can be constructed using the usual composite literal syntax
with colon-separated key-value pairs,
so it's easy to build them during initialization.
</p>
<pre>
var timeZone = map[string]int{
    "UTC":  0*60*60,
    "EST": -5*60*60,
    "CST": -6*60*60,
    "MST": -7*60*60,
    "PST": -8*60*60,
}
</pre>
<p>
Assigning and fetching map values looks syntactically just like
doing the same for arrays and slices except that the index doesn't
need to be an integer.
</p>
<pre>
offset := timeZone["EST"]
</pre>
<p>
An attempt to fetch a map value with a key that
is not present in the map will return the zero value for the type
of the entries
in the map.  For instance, if the map contains integers, looking
up a non-existent key will return <code>0</code>.
A set can be implemented as a map with value type <code>bool</code>.
Set the map entry to <code>true</code> to put the value in the set, and then
test it by simple indexing.
</p>
<pre>
attended := map[string]bool{
    "Ann": true,
    "Joe": true,
    ...
}

if attended[person] { // will be false if person is not in the map
    fmt.Println(person, "was at the meeting")
}
</pre>
<p>
Sometimes you need to distinguish a missing entry from
a zero value.  Is there an entry for <code>"UTC"</code>
or is that the empty string because it's not in the map at all?
You can discriminate with a form of multiple assignment.
</p>
<pre>
var seconds int
var ok bool
seconds, ok = timeZone[tz]
</pre>
<p>
For obvious reasons this is called the &ldquo;comma ok&rdquo; idiom.
In this example, if <code>tz</code> is present, <code>seconds</code>
will be set appropriately and <code>ok</code> will be true; if not,
<code>seconds</code> will be set to zero and <code>ok</code> will
be false.
Here's a function that puts it together with a nice error report:
</p>
<pre>
func offset(tz string) int {
    if seconds, ok := timeZone[tz]; ok {
        return seconds
    }
    log.Println("unknown time zone:", tz)
    return 0
}
</pre>
<p>
To test for presence in the map without worrying about the actual value,
you can use the <a href="#blank">blank identifier</a> (<code>_</code>)
in place of the usual variable for the value.
</p>
<pre>
_, present := timeZone[tz]
</pre>
<p>
To delete a map entry, use the <code>delete</code>
built-in function, whose arguments are the map and the key to be deleted.
It's safe to do this even if the key is already absent
from the map.
</p>
<pre>
delete(timeZone, "PDT")  // Now on Standard Time
</pre>

<h3 id="printing">Printing</h3>

<p>
Formatted printing in Go uses a style similar to C's <code>printf</code>
family but is richer and more general. The functions live in the <code>fmt</code>
package and have capitalized names: <code>fmt.Printf</code>, <code>fmt.Fprintf</code>,
<code>fmt.Sprintf</code> and so on.  The string functions (<code>Sprintf</code> etc.)
return a string rather than filling in a provided buffer.
</p>
<p>
You don't need to provide a format string.  For each of <code>Printf</code>,
<code>Fprintf</code> and <code>Sprintf</code> there is another pair
of functions, for instance <code>Print</code> and <code>Println</code>.
These functions do not take a format string but instead generate a default
format for each argument. The <code>Println</code> versions also insert a blank
between arguments and append a newline to the output while
the <code>Print</code> versions add blanks only if the operand on neither side is a string.
In this example each line produces the same output.
</p>
<pre>
fmt.Printf("Hello %d\n", 23)
fmt.Fprint(os.Stdout, "Hello ", 23, "\n")
fmt.Println("Hello", 23)
fmt.Println(fmt.Sprint("Hello ", 23))
</pre>
<p>
The formatted print functions <code>fmt.Fprint</code>
and friends take as a first argument any object
that implements the <code>io.Writer</code> interface; the variables <code>os.Stdout</code>
and <code>os.Stderr</code> are familiar instances.
</p>
<p>
Here things start to diverge from C.  First, the numeric formats such as <code>%d</code>
do not take flags for signedness or size; instead, the printing routines use the
type of the argument to decide these properties.
</p>
<pre>
var x uint64 = 1&lt;&lt;64 - 1
fmt.Printf("%d %x; %d %x\n", x, x, int64(x), int64(x))
</pre>
<p>
prints
</p>
<pre>
18446744073709551615 ffffffffffffffff; -1 -1
</pre>
<p>
If you just want the default conversion, such as decimal for integers, you can use
the catchall format <code>%v</code> (for &ldquo;value&rdquo;); the result is exactly
what <code>Print</code> and <code>Println</code> would produce.
Moreover, that format can print <em>any</em> value, even arrays, slices, structs, and
maps.  Here is a print statement for the time zone map defined in the previous section.
</p>
<pre>
fmt.Printf("%v\n", timeZone)  // or just fmt.Println(timeZone)
</pre>
<p>
which gives output
</p>
<pre>
map[CST:-21600 PST:-28800 EST:-18000 UTC:0 MST:-25200]
</pre>
<p>
For maps the keys may be output in any order, of course.
When printing a struct, the modified format <code>%+v</code> annotates the
fields of the structure with their names, and for any value the alternate
format <code>%#v</code> prints the value in full Go syntax.
</p>
<pre>
type T struct {
    a int
    b float64
    c string
}
t := &amp;T{ 7, -2.35, "abc\tdef" }
fmt.Printf("%v\n", t)
fmt.Printf("%+v\n", t)
fmt.Printf("%#v\n", t)
fmt.Printf("%#v\n", timeZone)
</pre>
<p>
prints
</p>
<pre>
&amp;{7 -2.35 abc   def}
&amp;{a:7 b:-2.35 c:abc     def}
&amp;main.T{a:7, b:-2.35, c:"abc\tdef"}
map[string] int{"CST":-21600, "PST":-28800, "EST":-18000, "UTC":0, "MST":-25200}
</pre>
<p>
(Note the ampersands.)
That quoted string format is also available through <code>%q</code> when
applied to a value of type <code>string</code> or <code>[]byte</code>.
The alternate format <code>%#q</code> will use backquotes instead if possible.
(The <code>%q</code> format also applies to integers and runes, producing a
single-quoted rune constant.)
Also, <code>%x</code> works on strings, byte arrays and byte slices as well as
on integers, generating a long hexadecimal string, and with
a space in the format (<code>%&nbsp;x</code>) it puts spaces between the bytes.
</p>
<p>
Another handy format is <code>%T</code>, which prints the <em>type</em> of a value.
</p>
<pre>
fmt.Printf(&quot;%T\n&quot;, timeZone)
</pre>
<p>
prints
</p>
<pre>
map[string] int
</pre>
<p>
If you want to control the default format for a custom type, all that's required is to define
a method with the signature <code>String() string</code> on the type.
For our simple type <code>T</code>, that might look like this.
</p>
<pre>
func (t *T) String() string {
    return fmt.Sprintf("%d/%g/%q", t.a, t.b, t.c)
}
fmt.Printf("%v\n", t)
</pre>
<p>
to print in the format
</p>
<pre>
7/-2.35/"abc\tdef"
</pre>
<p>
(If you need to print <em>values</em> of type <code>T</code> as well as pointers to <code>T</code>,
the receiver for <code>String</code> must be of value type; this example used a pointer because
that's more efficient and idiomatic for struct types.
See the section below on <a href="#pointers_vs_values">pointers vs. value receivers</a> for more information.)
</p>

<p>
Our <code>String</code> method is able to call <code>Sprintf</code> because the
print routines are fully reentrant and can be wrapped this way.
There is one important detail to understand about this approach,
however: don't construct a <code>String</code> method by calling
<code>Sprintf</code> in a way that will recur into your <code>String</code>
method indefinitely.  This can happen if the <code>Sprintf</code>
call attempts to print the receiver directly as a string, which in
turn will invoke the method again.  It's a common and easy mistake
to make, as this example shows.
</p>

<pre>
type MyString string

func (m MyString) String() string {
    return fmt.Sprintf("MyString=%s", m) // Error: will recur forever.
}
</pre>

<p>
It's also easy to fix: convert the argument to the basic string type, which does not have the
method.
</p>

<pre>
type MyString string
func (m MyString) String() string {
    return fmt.Sprintf("MyString=%s", string(m)) // OK: note conversion.
}
</pre>

<p>
In the <a href="#initialization">initialization section</a> we'll see another technique that avoids this recursion.
</p>

<p>
Another printing technique is to pass a print routine's arguments directly to another such routine.
The signature of <code>Printf</code> uses the type <code>...interface{}</code>
for its final argument to specify that an arbitrary number of parameters (of arbitrary type)
can appear after the format.
</p>
<pre>
func Printf(format string, v ...interface{}) (n int, err error) {
</pre>
<p>
Within the function <code>Printf</code>, <code>v</code> acts like a variable of type
<code>[]interface{}</code> but if it is passed to another variadic function, it acts like
a regular list of arguments.
Here is the implementation of the
function <code>log.Println</code> we used above. It passes its arguments directly to
<code>fmt.Sprintln</code> for the actual formatting.
</p>
<pre>
// Println prints to the standard logger in the manner of fmt.Println.
func Println(v ...interface{}) {
    std.Output(2, fmt.Sprintln(v...))  // Output takes parameters (int, string)
}
</pre>
<p>
We write <code>...</code> after <code>v</code> in the nested call to <code>Sprintln</code> to tell the
compiler to treat <code>v</code> as a list of arguments; otherwise it would just pass
<code>v</code> as a single slice argument.
</p>
<p>
There's even more to printing than we've covered here.  See the <code>godoc</code> documentation
for package <code>fmt</code> for the details.
</p>
<p>
By the way, a <code>...</code> parameter can be of a specific type, for instance <code>...int</code>
for a min function that chooses the least of a list of integers:
</p>
<pre>
func Min(a ...int) int {
    min := int(^uint(0) >> 1)  // largest int
    for _, i := range a {
        if i &lt; min {
            min = i
        }
    }
    return min
}
</pre>

<h3 id="append">Append</h3>
<p>
Now we have the missing piece we needed to explain the design of
the <code>append</code> built-in function.  The signature of <code>append</code>
is different from our custom <code>Append</code> function above.
Schematically, it's like this:
</p>
<pre>
func append(slice []<i>T</i>, elements ...<i>T</i>) []<i>T</i>
</pre>
<p>
where <i>T</i> is a placeholder for any given type.  You can't
actually write a function in Go where the type <code>T</code>
is determined by the caller.
That's why <code>append</code> is built in: it needs support from the
compiler.
</p>
<p>
What <code>append</code> does is append the elements to the end of
the slice and return the result.  The result needs to be returned
because, as with our hand-written <code>Append</code>, the underlying
array may change.  This simple example
</p>
<pre>
x := []int{1,2,3}
x = append(x, 4, 5, 6)
fmt.Println(x)
</pre>
<p>
prints <code>[1 2 3 4 5 6]</code>.  So <code>append</code> works a
little like <code>Printf</code>, collecting an arbitrary number of
arguments.
</p>
<p>
But what if we wanted to do what our <code>Append</code> does and
append a slice to a slice?  Easy: use <code>...</code> at the call
site, just as we did in the call to <code>Output</code> above.  This
snippet produces identical output to the one above.
</p>
<pre>
x := []int{1,2,3}
y := []int{4,5,6}
x = append(x, y...)
fmt.Println(x)
</pre>
<p>
Without that <code>...</code>, it wouldn't compile because the types
would be wrong; <code>y</code> is not of type <code>int</code>.
</p>

<h2 id="initialization">Initialization</h2>

<p>
Although it doesn't look superficially very different from
initialization in C or C++, initialization in Go is more powerful.
Complex structures can be built during initialization and the ordering
issues among initialized objects, even among different packages, are handled
correctly.
</p>

<h3 id="constants">Constants</h3>

<p>
Constants in Go are just that&mdash;constant.
They are created at compile time, even when defined as
locals in functions,
and can only be numbers, characters (runes), strings or booleans.
Because of the compile-time restriction, the expressions
that define them must be constant expressions,
evaluatable by the compiler.  For instance,
<code>1&lt;&lt;3</code> is a constant expression, while
<code>math.Sin(math.Pi/4)</code> is not because
the function call to <code>math.Sin</code> needs
to happen at run time.
</p>

<p>
In Go, enumerated constants are created using the <code>iota</code>
enumerator.  Since <code>iota</code> can be part of an expression and
expressions can be implicitly repeated, it is easy to build intricate
sets of values.
</p>
{{code "/doc/progs/eff_bytesize.go" `/^type ByteSize/` `/^\)/`}}
<p>
The ability to attach a method such as <code>String</code> to any
user-defined type makes it possible for arbitrary values to format themselves
automatically for printing.
Although you'll see it most often applied to structs, this technique is also useful for
scalar types such as floating-point types like <code>ByteSize</code>.
</p>
{{code "/doc/progs/eff_bytesize.go" `/^func.*ByteSize.*String/` `/^}/`}}
<p>
The expression <code>YB</code> prints as <code>1.00YB</code>,
while <code>ByteSize(1e13)</code> prints as <code>9.09TB</code>.
</p>

<p>
The use here of <code>Sprintf</code>
to implement <code>ByteSize</code>'s <code>String</code> method is safe
(avoids recurring indefinitely) not because of a conversion but
because it calls <code>Sprintf</code> with <code>%f</code>,
which is not a string format: <code>Sprintf</code> will only call
the <code>String</code> method when it wants a string, and <code>%f</code>
wants a floating-point value.
</p>

<h3 id="variables">Variables</h3>

<p>
Variables can be initialized just like constants but the
initializer can be a general expression computed at run time.
</p>
<pre>
var (
    home   = os.Getenv("HOME")
    user   = os.Getenv("USER")
    gopath = os.Getenv("GOPATH")
)
</pre>

<h3 id="init">The init function</h3>

<p>
Finally, each source file can define its own niladic <code>init</code> function to
set up whatever state is required.  (Actually each file can have multiple
<code>init</code> functions.)
And finally means finally: <code>init</code> is called after all the
variable declarations in the package have evaluated their initializers,
and those are evaluated only after all the imported packages have been
initialized.
</p>
<p>
Besides initializations that cannot be expressed as declarations,
a common use of <code>init</code> functions is to verify or repair
correctness of the program state before real execution begins.
</p>

<pre>
func init() {
    if user == "" {
        log.Fatal("$USER not set")
    }
    if home == "" {
        home = "/home/" + user
    }
    if gopath == "" {
        gopath = home + "/go"
    }
    // gopath may be overridden by --gopath flag on command line.
    flag.StringVar(&amp;gopath, "gopath", gopath, "override default GOPATH")
}
</pre>

<h2 id="methods">Methods</h2>

<h3 id="pointers_vs_values">Pointers vs. Values</h3>
<p>
As we saw with <code>ByteSize</code>,
methods can be defined for any named type (except a pointer or an interface);
the receiver does not have to be a struct.
</p>
<p>
In the discussion of slices above, we wrote an <code>Append</code>
function.  We can define it as a method on slices instead.  To do
this, we first declare a named type to which we can bind the method, and
then make the receiver for the method a value of that type.
</p>
<pre>
type ByteSlice []byte

func (slice ByteSlice) Append(data []byte) []byte {
    // Body exactly the same as above
}
</pre>
<p>
This still requires the method to return the updated slice.  We can
eliminate that clumsiness by redefining the method to take a
<i>pointer</i> to a <code>ByteSlice</code> as its receiver, so the
method can overwrite the caller's slice.
</p>
<pre>
func (p *ByteSlice) Append(data []byte) {
    slice := *p
    // Body as above, without the return.
    *p = slice
}
</pre>
<p>
In fact, we can do even better.  If we modify our function so it looks
like a standard <code>Write</code> method, like this,
</p>
<pre>
func (p *ByteSlice) Write(data []byte) (n int, err error) {
    slice := *p
    // Again as above.
    *p = slice
    return len(data), nil
}
</pre>
<p>
then the type <code>*ByteSlice</code> satisfies the standard interface
<code>io.Writer</code>, which is handy.  For instance, we can
print into one.
</p>
<pre>
    var b ByteSlice
    fmt.Fprintf(&amp;b, "This hour has %d days\n", 7)
</pre>
<p>
We pass the address of a <code>ByteSlice</code>
because only <code>*ByteSlice</code> satisfies <code>io.Writer</code>.
The rule about pointers vs. values for receivers is that value methods
can be invoked on pointers and values, but pointer methods can only be
invoked on pointers.
</p>

<p>
This rule arises because pointer methods can modify the receiver; invoking
them on a value would cause the method to receive a copy of the value, so
any modifications would be discarded.
The language therefore disallows this mistake.
There is a handy exception, though. When the value is addressable, the
language takes care of the common case of invoking a pointer method on a
value by inserting the address operator automatically.
In our example, the variable <code>b</code> is addressable, so we can call
its <code>Write</code> method with just <code>b.Write</code>. The compiler
will rewrite that to <code>(&amp;b).Write</code> for us.
</p>

<p>
By the way, the idea of using <code>Write</code> on a slice of bytes
is central to the implementation of <code>bytes.Buffer</code>.
</p>

<h2 id="interfaces_and_types">Interfaces and other types</h2>

<h3 id="interfaces">Interfaces</h3>
<p>
Interfaces in Go provide a way to specify the behavior of an
object: if something can do <em>this</em>, then it can be used
<em>here</em>.  We've seen a couple of simple examples already;
custom printers can be implemented by a <code>String</code> method
while <code>Fprintf</code> can generate output to anything
with a <code>Write</code> method.
Interfaces with only one or two methods are common in Go code, and are
usually given a name derived from the method, such as <code>io.Writer</code>
for something that implements <code>Write</code>.
</p>
<p>
A type can implement multiple interfaces.
For instance, a collection can be sorted
by the routines in package <code>sort</code> if it implements
<code>sort.Interface</code>, which contains <code>Len()</code>,
<code>Less(i, j int) bool</code>, and <code>Swap(i, j int)</code>,
and it could also have a custom formatter.
In this contrived example <code>Sequence</code> satisfies both.
</p>
{{code "/doc/progs/eff_sequence.go" `/^type/` "$"}}

<h3 id="conversions">Conversions</h3>

<p>
The <code>String</code> method of <code>Sequence</code> is recreating the
work that <code>Sprint</code> already does for slices.  We can share the
effort if we convert the <code>Sequence</code> to a plain
<code>[]int</code> before calling <code>Sprint</code>.
</p>
<pre>
func (s Sequence) String() string {
    sort.Sort(s)
    return fmt.Sprint([]int(s))
}
</pre>
<p>
This method is another example of the conversion technique for calling
<code>Sprintf</code> safely from a <code>String</code> method.
Because the two types (<code>Sequence</code> and <code>[]int</code>)
are the same if we ignore the type name, it's legal to convert between them.
The conversion doesn't create a new value, it just temporarily acts
as though the existing value has a new type.
(There are other legal conversions, such as from integer to floating point, that
do create a new value.)
</p>
<p>
It's an idiom in Go programs to convert the
type of an expression to access a different
set of methods. As an example, we could use the existing
type <code>sort.IntSlice</code> to reduce the entire example
to this:
</p>
<pre>
type Sequence []int

// Method for printing - sorts the elements before printing
func (s Sequence) String() string {
    sort.IntSlice(s).Sort()
    return fmt.Sprint([]int(s))
}
</pre>
<p>
Now, instead of having <code>Sequence</code> implement multiple
interfaces (sorting and printing), we're using the ability of a data item to be
converted to multiple types (<code>Sequence</code>, <code>sort.IntSlice</code>
and <code>[]int</code>), each of which does some part of the job.
That's more unusual in practice but can be effective.
</p>

<h3 id="interface_conversions">Interface conversions and type assertions</h3>

<p>
<a href="#type_switch">Type switches</a> are a form of conversion: they take an interface and, for
each case in the switch, in a sense convert it to the type of that case.
Here's a simplified version of how the code under <code>fmt.Printf</code> turns a value into
a string using a type switch.
If it's already a string, we want the actual string value held by the interface, while if it has a
<code>String</code> method we want the result of calling the method.
</p>

<pre>
type Stringer interface {
    String() string
}

var value interface{} // Value provided by caller.
switch str := value.(type) {
case string:
    return str
case Stringer:
    return str.String()
}
</pre>

<p>
The first case finds a concrete value; the second converts the interface into another interface.
It's perfectly fine to mix types this way.
</p>

<p>
What if there's only one type we care about? If we know the value holds a <code>string</code>
and we just want to extract it?
A one-case type switch would do, but so would a <em>type assertion</em>.
A type assertion takes an interface value and extracts from it a value of the specified explicit type.
The syntax borrows from the clause opening a type switch, but with an explicit
type rather than the <code>type</code> keyword:
</p>

<pre>
value.(typeName)
</pre>

<p>
and the result is a new value with the static type <code>typeName</code>.
That type must either be the concrete type held by the interface, or a second interface
type that the value can be converted to.
To extract the string we know is in the value, we could write:
</p>

<pre>
str := value.(string)
</pre>

<p>
But if it turns out that the value does not contain a string, the program will crash with a run-time error.
To guard against that, use the "comma, ok" idiom to test, safely, whether the value is a string:
</p>

<pre>
str, ok := value.(string)
if ok {
    fmt.Printf("string value is: %q\n", str)
} else {
    fmt.Printf("value is not a string\n")
}
</pre>

<p>
If the type assertion fails, <code>str</code> will still exist and be of type string, but it will have
the zero value, an empty string.
</p>

<p>
As an illustration of the capability, here's an <code>if</code>-<code>else</code>
statement that's equivalent to the type switch that opened this section.
</p>

<pre>
if str, ok := value.(string); ok {
    return str
} else if str, ok := value.(Stringer); ok {
    return str.String()
}
</pre>

<h3 id="generality">Generality</h3>
<p>
If a type exists only to implement an interface
and has no exported methods beyond that interface,
there is no need to export the type itself.
Exporting just the interface makes it clear that
it's the behavior that matters, not the implementation,
and that other implementations with different properties
can mirror the behavior of the original type.
It also avoids the need to repeat the documentation
on every instance of a common method.
</p>
<p>
In such cases, the constructor should return an interface value
rather than the implementing type.
As an example, in the hash libraries
both <code>crc32.NewIEEE</code> and <code>adler32.New</code>
return the interface type <code>hash.Hash32</code>.
Substituting the CRC-32 algorithm for Adler-32 in a Go program
requires only changing the constructor call;
the rest of the code is unaffected by the change of algorithm.
</p>
<p>
A similar approach allows the streaming cipher algorithms
in the various <code>crypto</code> packages to be
separated from the block ciphers they chain together.
The <code>Block</code> interface
in the <code>crypto/cipher</code> package specifies the
behavior of a block cipher, which provides encryption
of a single block of data.
Then, by analogy with the <code>bufio</code> package,
cipher packages that implement this interface
can be used to construct streaming ciphers, represented
by the <code>Stream</code> interface, without
knowing the details of the block encryption.
</p>
<p>
The  <code>crypto/cipher</code> interfaces look like this:
</p>
<pre>
type Block interface {
    BlockSize() int
    Encrypt(src, dst []byte)
    Decrypt(src, dst []byte)
}

type Stream interface {
    XORKeyStream(dst, src []byte)
}
</pre>

<p>
Here's the definition of the counter mode (CTR) stream,
which turns a block cipher into a streaming cipher; notice
that the block cipher's details are abstracted away:
</p>

<pre>
// NewCTR returns a Stream that encrypts/decrypts using the given Block in
// counter mode. The length of iv must be the same as the Block's block size.
func NewCTR(block Block, iv []byte) Stream
</pre>
<p>
<code>NewCTR</code> applies not
just to one specific encryption algorithm and data source but to any
implementation of the <code>Block</code> interface and any
<code>Stream</code>.  Because they return
interface values, replacing CTR
encryption with other encryption modes is a localized change.  The constructor
calls must be edited, but because the surrounding code must treat the result only
as a <code>Stream</code>, it won't notice the difference.
</p>

<h3 id="interface_methods">Interfaces and methods</h3>
<p>
Since almost anything can have methods attached, almost anything can
satisfy an interface.  One illustrative example is in the <code>http</code>
package, which defines the <code>Handler</code> interface.  Any object
that implements <code>Handler</code> can serve HTTP requests.
</p>
<pre>
type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}
</pre>
<p>
<code>ResponseWriter</code> is itself an interface that provides access
to the methods needed to return the response to the client.
Those methods include the standard <code>Write</code> method, so an
<code>http.ResponseWriter</code> can be used wherever an <code>io.Writer</code>
can be used.
<code>Request</code> is a struct containing a parsed representation
of the request from the client.
</p>
<p>
For brevity, let's ignore POSTs and assume HTTP requests are always
GETs; that simplification does not affect the way the handlers are
set up.  Here's a trivial but complete implementation of a handler to
count the number of times the
page is visited.
</p>
<pre>
// Simple counter server.
type Counter struct {
    n int
}

func (ctr *Counter) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    ctr.n++
    fmt.Fprintf(w, "counter = %d\n", ctr.n)
}
</pre>
<p>
(Keeping with our theme, note how <code>Fprintf</code> can print to an
<code>http.ResponseWriter</code>.)
For reference, here's how to attach such a server to a node on the URL tree.
</p>
<pre>
import "net/http"
...
ctr := new(Counter)
http.Handle("/counter", ctr)
</pre>
<p>
But why make <code>Counter</code> a struct?  An integer is all that's needed.
(The receiver needs to be a pointer so the increment is visible to the caller.)
</p>
<pre>
// Simpler counter server.
type Counter int

func (ctr *Counter) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    *ctr++
    fmt.Fprintf(w, "counter = %d\n", *ctr)
}
</pre>
<p>
What if your program has some internal state that needs to be notified that a page
has been visited?  Tie a channel to the web page.
</p>
<pre>
// A channel that sends a notification on each visit.
// (Probably want the channel to be buffered.)
type Chan chan *http.Request

func (ch Chan) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    ch &lt;- req
    fmt.Fprint(w, "notification sent")
}
</pre>
<p>
Finally, let's say we wanted to present on <code>/args</code> the arguments
used when invoking the server binary.
It's easy to write a function to print the arguments.
</p>
<pre>
func ArgServer() {
    fmt.Println(os.Args)
}
</pre>
<p>
How do we turn that into an HTTP server?  We could make <code>ArgServer</code>
a method of some type whose value we ignore, but there's a cleaner way.
Since we can define a method for any type except pointers and interfaces,
we can write a method for a function.
The <code>http</code> package contains this code:
</p>
<pre>
// The HandlerFunc type is an adapter to allow the use of
// ordinary functions as HTTP handlers.  If f is a function
// with the appropriate signature, HandlerFunc(f) is a
// Handler object that calls f.
type HandlerFunc func(ResponseWriter, *Request)

// ServeHTTP calls f(c, req).
func (f HandlerFunc) ServeHTTP(w ResponseWriter, req *Request) {
    f(w, req)
}
</pre>
<p>
<code>HandlerFunc</code> is a type with a method, <code>ServeHTTP</code>,
so values of that type can serve HTTP requests.  Look at the implementation
of the method: the receiver is a function, <code>f</code>, and the method
calls <code>f</code>.  That may seem odd but it's not that different from, say,
the receiver being a channel and the method sending on the channel.
</p>
<p>
To make <code>ArgServer</code> into an HTTP server, we first modify it
to have the right signature.
</p>
<pre>
// Argument server.
func ArgServer(w http.ResponseWriter, req *http.Request) {
    fmt.Fprintln(w, os.Args)
}
</pre>
<p>
<code>ArgServer</code> now has same signature as <code>HandlerFunc</code>,
so it can be converted to that type to access its methods,
just as we converted <code>Sequence</code> to <code>IntSlice</code>
to access <code>IntSlice.Sort</code>.
The code to set it up is concise:
</p>
<pre>
http.Handle("/args", http.HandlerFunc(ArgServer))
</pre>
<p>
When someone visits the page <code>/args</code>,
the handler installed at that page has value <code>ArgServer</code>
and type <code>HandlerFunc</code>.
The HTTP server will invoke the method <code>ServeHTTP</code>
of that type, with <code>ArgServer</code> as the receiver, which will in turn call
<code>ArgServer</code> (via the invocation <code>f(c, req)</code>
inside <code>HandlerFunc.ServeHTTP</code>).
The arguments will then be displayed.
</p>
<p>
In this section we have made an HTTP server from a struct, an integer,
a channel, and a function, all because interfaces are just sets of
methods, which can be defined for (almost) any type.
</p>

<h2 id="blank">The blank identifier</h2>

<p>
We've mentioned the blank identifier a couple of times now, in the context of
<a href="#for"><code>for</code> <code>range</code> loops</a>
and <a href="#maps">maps</a>.
The blank identifier can be assigned or declared with any value of any type, with the
value discarded harmlessly.
It's a bit like writing to the Unix <code>/dev/null</code> file:
it represents a write-only value
to be used as a place-holder
where a variable is needed but the actual value is irrelevant.
It has uses beyond those we've seen already.
</p>

<h3 id="blank_assign">The blank identifier in multiple assignment</h3>

<p>
The use of a blank identifier in a <code>for</code> <code>range</code> loop is a
special case of a general situation: multiple assignment.
</p>

<p>
If an assignment requires multiple values on the left side,
but one of the values will not be used by the program,
a blank identifier on the left-hand-side of
the assignment avoids the need
to create a dummy variable and makes it clear that the
value is to be discarded.
For instance, when calling a function that returns
a value and an error, but only the error is important,
use the blank identifier to discard the irrelevant value.
</p>

<pre>
if _, err := os.Stat(path); os.IsNotExist(err) {
	fmt.Printf("%s does not exist\n", path)
}
</pre>

<p>
Occasionally you'll see code that discards the error value in order
to ignore the error; this is terrible practice. Always check error returns;
they're provided for a reason.
</p>

<pre>
// Bad! This code will crash if path does not exist.
fi, _ := os.Stat(path)
if fi.IsDir() {
    fmt.Printf("%s is a directory\n", path)
}
</pre>

<h3 id="blank_unused">Unused imports and variables</h3>

<p>
It is an error to import a package or to declare a variable without using it.
Unused imports bloat the program and slow compilation,
while a variable that is initialized but not used is at least
a wasted computation and perhaps indicative of a
larger bug.
When a program is under active development, however,
unused imports and variables often arise and it can
be annoying to delete them just to have the compilation proceed,
only to have them be needed again later.
The blank identifier provides a workaround.
</p>
<p>
This half-written program has two unused imports
(<code>fmt</code> and <code>io</code>)
and an unused variable (<code>fd</code>),
so it will not compile, but it would be nice to see if the
code so far is correct.
</p>
{{code "/doc/progs/eff_unused1.go" `/package/` `$`}}
<p>
To silence complaints about the unused imports, use a
blank identifier to refer to a symbol from the imported package.
Similarly, assigning the unused variable <code>fd</code>
to the blank identifier will silence the unused variable error.
This version of the program does compile.
</p>
{{code "/doc/progs/eff_unused2.go" `/package/` `$`}}

<p>
By convention, the global declarations to silence import errors
should come right after the imports and be commented,
both to make them easy to find and as a reminder to clean things up later.
</p>

<h3 id="blank_import">Import for side effect</h3>

<p>
An unused import like <code>fmt</code> or <code>io</code> in the
previous example should eventually be used or removed:
blank assignments identify code as a work in progress.
But sometimes it is useful to import a package only for its
side effects, without any explicit use.
For example, during its <code>init</code> function,
the <code><a href="/pkg/net/http/pprof/">net/http/pprof</a></code>
package registers HTTP handlers that provide
debugging information. It has an exported API, but
most clients need only the handler registration and
access the data through a web page.
To import the package only for its side effects, rename the package
to the blank identifier:
</p>
<pre>
import _ "net/http/pprof"
</pre>
<p>
This form of import makes clear that the package is being
imported for its side effects, because there is no other possible
use of the package: in this file, it doesn't have a name.
(If it did, and we didn't use that name, the compiler would reject the program.)
</p>

<h3 id="blank_implements">Interface checks</h3>

<p>
As we saw in the discussion of <a href="#interfaces_and_types">interfaces</a> above,
a type need not declare explicitly that it implements an interface.
Instead, a type implements the interface just by implementing the interface's methods.
In practice, most interface conversions are static and therefore checked at compile time.
For example, passing an <code>*os.File</code> to a function
expecting an <code>io.Reader</code> will not compile unless
<code>*os.File</code> implements the <code>io.Reader</code> interface.
</p>

<p>
Some interface checks do happen at run-time, though.
One instance is in the <code><a href="/pkg/encoding/json/">encoding/json</a></code>
package, which defines a <code><a href="/pkg/encoding/json/#Marshaler">Marshaler</a></code>
interface. When the JSON encoder receives a value that implements that interface,
the encoder invokes the value's marshaling method to convert it to JSON
instead of doing the standard conversion.
The encoder checks this property at run time with a <a href="#interface_conversions">type assertion</a> like:
</p>

<pre>
m, ok := val.(json.Marshaler)
</pre>

<p>
If it's necessary only to ask whether a type implements an interface, without
actually using the interface itself, perhaps as part of an error check, use the blank
identifier to ignore the type-asserted value:
</p>

<pre>
if _, ok := val.(json.Marshaler); ok {
    fmt.Printf("value %v of type %T implements json.Marshaler\n", val, val)
}
</pre>

<p>
One place this situation arises is when it is necessary to guarantee within the package implementing the type that
it actually satisfies the interface.
If a type‚Äîfor example,
<code><a href="/pkg/encoding/json/#RawMessage">json.RawMessage</a></code>‚Äîneeds
a custom JSON representation, it should implement
<code>json.Marshaler</code>, but there are no static conversions that would
cause the compiler to verify this automatically.
If the type inadvertently fails to satisfy the interface, the JSON encoder will still work,
but will not use the custom implementation.
To guarantee that the implementation is correct,
a global declaration using the blank identifier can be used in the package:
</p>
<pre>
var _ json.Marshaler = (*RawMessage)(nil)
</pre>
<p>
In this declaration, the assignment involving a conversion of a
<code>*RawMessage</code> to a <code>Marshaler</code>
requires that <code>*RawMessage</code> implements <code>Marshaler</code>,
and that property will be checked at compile time.
Should the <code>json.Marshaler</code> interface change, this package
will no longer compile and we will be on notice that it needs to be updated.
</p>

<p>
The appearance of the blank identifier in this construct indicates that
the declaration exists only for the type checking,
not to create a variable.
Don't do this for every type that satisfies an interface, though.
By convention, such declarations are only used
when there are no static conversions already present in the code,
which is a rare event.
</p>


<h2 id="embedding">Embedding</h2>

<p>
Go does not provide the typical, type-driven notion of subclassing,
but it does have the ability to &ldquo;borrow&rdquo; pieces of an
implementation by <em>embedding</em> types within a struct or
interface.
</p>
<p>
Interface embedding is very simple.
We've mentioned the <code>io.Reader</code> and <code>io.Writer</code> interfaces before;
here are their definitions.
</p>
<pre>
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}
</pre>
<p>
The <code>io</code> package also exports several other interfaces
that specify objects that can implement several such methods.
For instance, there is <code>io.ReadWriter</code>, an interface
containing both <code>Read</code> and <code>Write</code>.
We could specify <code>io.ReadWriter</code> by listing the
two methods explicitly, but it's easier and more evocative
to embed the two interfaces to form the new one, like this:
</p>
<pre>
// ReadWriter is the interface that combines the Reader and Writer interfaces.
type ReadWriter interface {
    Reader
    Writer
}
</pre>
<p>
This says just what it looks like: A <code>ReadWriter</code> can do
what a <code>Reader</code> does <em>and</em> what a <code>Writer</code>
does; it is a union of the embedded interfaces (which must be disjoint
sets of methods).
Only interfaces can be embedded within interfaces.
</p>
<p>
The same basic idea applies to structs, but with more far-reaching
implications.  The <code>bufio</code> package has two struct types,
<code>bufio.Reader</code> and <code>bufio.Writer</code>, each of
which of course implements the analogous interfaces from package
<code>io</code>.
And <code>bufio</code> also implements a buffered reader/writer,
which it does by combining a reader and a writer into one struct
using embedding: it lists the types within the struct
but does not give them field names.
</p>
<pre>
// ReadWriter stores pointers to a Reader and a Writer.
// It implements io.ReadWriter.
type ReadWriter struct {
    *Reader  // *bufio.Reader
    *Writer  // *bufio.Writer
}
</pre>
<p>
The embedded elements are pointers to structs and of course
must be initialized to point to valid structs before they
can be used.
The <code>ReadWriter</code> struct could be written as
</p>
<pre>
type ReadWriter struct {
    reader *Reader
    writer *Writer
}
</pre>
<p>
but then to promote the methods of the fields and to
satisfy the <code>io</code> interfaces, we would also need
to provide forwarding methods, like this:
</p>
<pre>
func (rw *ReadWriter) Read(p []byte) (n int, err error) {
    return rw.reader.Read(p)
}
</pre>
<p>
By embedding the structs directly, we avoid this bookkeeping.
The methods of embedded types come along for free, which means that <code>bufio.ReadWriter</code>
not only has the methods of <code>bufio.Reader</code> and <code>bufio.Writer</code>,
it also satisfies all three interfaces:
<code>io.Reader</code>,
<code>io.Writer</code>, and
<code>io.ReadWriter</code>.
</p>
<p>
There's an important way in which embedding differs from subclassing.  When we embed a type,
the methods of that type become methods of the outer type,
but when they are invoked the receiver of the method is the inner type, not the outer one.
In our example, when the <code>Read</code> method of a <code>bufio.ReadWriter</code> is
invoked, it has exactly the same effect as the forwarding method written out above;
the receiver is the <code>reader</code> field of the <code>ReadWriter</code>, not the
<code>ReadWriter</code> itself.
</p>
<p>
Embedding can also be a simple convenience.
This example shows an embedded field alongside a regular, named field.
</p>
<pre>
type Job struct {
    Command string
    *log.Logger
}
</pre>
<p>
The <code>Job</code> type now has the <code>Log</code>, <code>Logf</code>
and other
methods of <code>*log.Logger</code>.  We could have given the <code>Logger</code>
a field name, of course, but it's not necessary to do so.  And now, once
initialized, we can
log to the <code>Job</code>:
</p>
<pre>
job.Log("starting now...")
</pre>
<p>
The <code>Logger</code> is a regular field of the <code>Job</code> struct,
so we can initialize it in the usual way inside the constructor for <code>Job</code>, like this,
</p>
<pre>
func NewJob(command string, logger *log.Logger) *Job {
    return &amp;Job{command, logger}
}
</pre>
<p>
or with a composite literal,
</p>
<pre>
job := &amp;Job{command, log.New(os.Stderr, "Job: ", log.Ldate)}
</pre>
<p>
If we need to refer to an embedded field directly, the type name of the field,
ignoring the package qualifier, serves as a field name, as it did
in the <code>Read</code> method of our <code>ReaderWriter</code> struct.
Here, if we needed to access the
<code>*log.Logger</code> of a <code>Job</code> variable <code>job</code>,
we would write <code>job.Logger</code>,
which would be useful if we wanted to refine the methods of <code>Logger</code>.
</p>
<pre>
func (job *Job) Logf(format string, args ...interface{}) {
    job.Logger.Logf("%q: %s", job.Command, fmt.Sprintf(format, args...))
}
</pre>
<p>
Embedding types introduces the problem of name conflicts but the rules to resolve
them are simple.
First, a field or method <code>X</code> hides any other item <code>X</code> in a more deeply
nested part of the type.
If <code>log.Logger</code> contained a field or method called <code>Command</code>, the <code>Command</code> field
of <code>Job</code> would dominate it.
</p>
<p>
Second, if the same name appears at the same nesting level, it is usually an error;
it would be erroneous to embed <code>log.Logger</code> if the <code>Job</code> struct
contained another field or method called <code>Logger</code>.
However, if the duplicate name is never mentioned in the program outside the type definition, it is OK.
This qualification provides some protection against changes made to types embedded from outside; there
is no problem if a field is added that conflicts with another field in another subtype if neither field
is ever used.
</p>


<h2 id="concurrency">Concurrency</h2>

<h3 id="sharing">Share by communicating</h3>

<p>
Concurrent programming is a large topic and there is space only for some
Go-specific highlights here.
</p>
<p>
Concurrent programming in many environments is made difficult by the
subtleties required to implement correct access to shared variables.  Go encourages
a different approach in which shared values are passed around on channels
and, in fact, never actively shared by separate threads of execution.
Only one goroutine has access to the value at any given time.
Data races cannot occur, by design.
To encourage this way of thinking we have reduced it to a slogan:
</p>
<blockquote>
Do not communicate by sharing memory;
instead, share memory by communicating.
</blockquote>
<p>
This approach can be taken too far.  Reference counts may be best done
by putting a mutex around an integer variable, for instance.  But as a
high-level approach, using channels to control access makes it easier
to write clear, correct programs.
</p>
<p>
One way to think about this model is to consider a typical single-threaded
program running on one CPU. It has no need for synchronization primitives.
Now run another such instance; it too needs no synchronization.  Now let those
two communicate; if the communication is the synchronizer, there's still no need
for other synchronization.  Unix pipelines, for example, fit this model
perfectly.  Although Go's approach to concurrency originates in Hoare's
Communicating Sequential Processes (CSP),
it can also be seen as a type-safe generalization of Unix pipes.
</p>

<h3 id="goroutines">Goroutines</h3>

<p>
They're called <em>goroutines</em> because the existing
terms&mdash;threads, coroutines, processes, and so on&mdash;convey
inaccurate connotations.  A goroutine has a simple model: it is a
function executing concurrently with other goroutines in the same
address space.  It is lightweight, costing little more than the
allocation of stack space.
And the stacks start small, so they are cheap, and grow
by allocating (and freeing) heap storage as required.
</p>
<p>
Goroutines are multiplexed onto multiple OS threads so if one should
block, such as while waiting for I/O, others continue to run.  Their
design hides many of the complexities of thread creation and
management.
</p>
<p>
Prefix a function or method call with the <code>go</code>
keyword to run the call in a new goroutine.
When the call completes, the goroutine
exits, silently.  (The effect is similar to the Unix shell's
<code>&amp;</code> notation for running a command in the
background.)
</p>
<pre>
go list.Sort()  // run list.Sort concurrently; don't wait for it.
</pre>
<p>
A function literal can be handy in a goroutine invocation.
</p>
<pre>
func Announce(message string, delay time.Duration) {
    go func() {
        time.Sleep(delay)
        fmt.Println(message)
    }()  // Note the parentheses - must call the function.
}
</pre>
<p>
In Go, function literals are closures: the implementation makes
sure the variables referred to by the function survive as long as they are active.
</p>
<p>
These examples aren't too practical because the functions have no way of signaling
completion.  For that, we need channels.
</p>

<h3 id="channels">Channels</h3>

<p>
Like maps, channels are allocated with <code>make</code>, and
the resulting value acts as a reference to an underlying data structure.
If an optional integer parameter is provided, it sets the buffer size for the channel.
The default is zero, for an unbuffered or synchronous channel.
</p>
<pre>
ci := make(chan int)            // unbuffered channel of integers
cj := make(chan int, 0)         // unbuffered channel of integers
cs := make(chan *os.File, 100)  // buffered channel of pointers to Files
</pre>
<p>
Unbuffered channels combine communication&mdash;the exchange of a value&mdash;with
synchronization&mdash;guaranteeing that two calculations (goroutines) are in
a known state.
</p>
<p>
There are lots of nice idioms using channels.  Here's one to get us started.
In the previous section we launched a sort in the background. A channel
can allow the launching goroutine to wait for the sort to complete.
</p>
<pre>
c := make(chan int)  // Allocate a channel.
// Start the sort in a goroutine; when it completes, signal on the channel.
go func() {
    list.Sort()
    c &lt;- 1  // Send a signal; value does not matter.
}()
doSomethingForAWhile()
&lt;-c   // Wait for sort to finish; discard sent value.
</pre>
<p>
Receivers always block until there is data to receive.
If the channel is unbuffered, the sender blocks until the receiver has
received the value.
If the channel has a buffer, the sender blocks only until the
value has been copied to the buffer; if the buffer is full, this
means waiting until some receiver has retrieved a value.
</p>
<p>
A buffered channel can be used like a semaphore, for instance to
limit throughput.  In this example, incoming requests are passed
to <code>handle</code>, which sends a value into the channel, processes
the request, and then receives a value from the channel
to ready the &ldquo;semaphore&rdquo; for the next consumer.
The capacity of the channel buffer limits the number of
simultaneous calls to <code>process</code>.
</p>
<pre>
var sem = make(chan int, MaxOutstanding)

func handle(r *Request) {
    sem &lt;- 1    // Wait for active queue to drain.
    process(r)  // May take a long time.
    &lt;-sem       // Done; enable next request to run.
}

func Serve(queue chan *Request) {
    for {
        req := &lt;-queue
        go handle(req)  // Don't wait for handle to finish.
    }
}
</pre>

<p>
Once <code>MaxOutstanding</code> handlers are executing <code>process</code>,
any more will block trying to send into the filled channel buffer,
until one of the existing handlers finishes and receives from the buffer.
</p>

<p>
This design has a problem, though: <code>Serve</code>
creates a new goroutine for
every incoming request, even though only <code>MaxOutstanding</code>
of them can run at any moment.
As a result, the program can consume unlimited resources if the requests come in too fast.
We can address that deficiency by changing <code>Serve</code> to
gate the creation of the goroutines.
Here's an obvious solution, but beware it has a bug we'll fix subsequently:
</p>

<pre>
func Serve(queue chan *Request) {
    for req := range queue {
        sem &lt;- 1
        go func() {
            process(req) // Buggy; see explanation below.
            &lt;-sem
        }()
    }
}</pre>

<p>
The bug is that in a Go <code>for</code> loop, the loop variable
is reused for each iteration, so the <code>req</code>
variable is shared across all goroutines.
That's not what we want.
We need to make sure that <code>req</code> is unique for each goroutine.
Here's one way to do that, passing the value of <code>req</code> as an argument
to the closure in the goroutine:
</p>

<pre>
func Serve(queue chan *Request) {
    for req := range queue {
        sem &lt;- 1
        go func(req *Request) {
            process(req)
            &lt;-sem
        }(req)
    }
}</pre>

<p>
Compare this version with the previous to see the difference in how
the closure is declared and run.
Another solution is just to create a new variable with the same
name, as in this example:
</p>

<pre>
func Serve(queue chan *Request) {
    for req := range queue {
        req := req // Create new instance of req for the goroutine.
        sem &lt;- 1
        go func() {
            process(req)
            &lt;-sem
        }()
    }
}</pre>

<p>
It may seem odd to write
</p>

<pre>
req := req
</pre>

<p>
but it's a legal and idiomatic in Go to do this.
You get a fresh version of the variable with the same name, deliberately
shadowing the loop variable locally but unique to each goroutine.
</p>

<p>
Going back to the general problem of writing the server,
another approach that manages resources well is to start a fixed
number of <code>handle</code> goroutines all reading from the request
channel.
The number of goroutines limits the number of simultaneous
calls to <code>process</code>.
This <code>Serve</code> function also accepts a channel on which
it will be told to exit; after launching the goroutines it blocks
receiving from that channel.
</p>

<pre>
func handle(queue chan *Request) {
    for r := range queue {
        process(r)
    }
}

func Serve(clientRequests chan *Request, quit chan bool) {
    // Start handlers
    for i := 0; i &lt; MaxOutstanding; i++ {
        go handle(clientRequests)
    }
    &lt;-quit  // Wait to be told to exit.
}
</pre>

<h3 id="chan_of_chan">Channels of channels</h3>
<p>
One of the most important properties of Go is that
a channel is a first-class value that can be allocated and passed
around like any other.  A common use of this property is
to implement safe, parallel demultiplexing.
</p>
<p>
In the example in the previous section, <code>handle</code> was
an idealized handler for a request but we didn't define the
type it was handling.  If that type includes a channel on which
to reply, each client can provide its own path for the answer.
Here's a schematic definition of type <code>Request</code>.
</p>
<pre>
type Request struct {
    args        []int
    f           func([]int) int
    resultChan  chan int
}
</pre>
<p>
The client provides a function and its arguments, as well as
a channel inside the request object on which to receive the answer.
</p>
<pre>
func sum(a []int) (s int) {
    for _, v := range a {
        s += v
    }
    return
}

request := &amp;Request{[]int{3, 4, 5}, sum, make(chan int)}
// Send request
clientRequests &lt;- request
// Wait for response.
fmt.Printf("answer: %d\n", &lt;-request.resultChan)
</pre>
<p>
On the server side, the handler function is the only thing that changes.
</p>
<pre>
func handle(queue chan *Request) {
    for req := range queue {
        req.resultChan &lt;- req.f(req.args)
    }
}
</pre>
<p>
There's clearly a lot more to do to make it realistic, but this
code is a framework for a rate-limited, parallel, non-blocking RPC
system, and there's not a mutex in sight.
</p>

<h3 id="parallel">Parallelization</h3>
<p>
Another application of these ideas is to parallelize a calculation
across multiple CPU cores.  If the calculation can be broken into
separate pieces that can execute independently, it can be parallelized,
with a channel to signal when each piece completes.
</p>
<p>
Let's say we have an expensive operation to perform on a vector of items,
and that the value of the operation on each item is independent,
as in this idealized example.
</p>
<pre>
type Vector []float64

// Apply the operation to v[i], v[i+1] ... up to v[n-1].
func (v Vector) DoSome(i, n int, u Vector, c chan int) {
    for ; i &lt; n; i++ {
        v[i] += u.Op(v[i])
    }
    c &lt;- 1    // signal that this piece is done
}
</pre>
<p>
We launch the pieces independently in a loop, one per CPU.
They can complete in any order but it doesn't matter; we just
count the completion signals by draining the channel after
launching all the goroutines.
</p>
<pre>
const NCPU = 4  // number of CPU cores

func (v Vector) DoAll(u Vector) {
    c := make(chan int, NCPU)  // Buffering optional but sensible.
    for i := 0; i &lt; NCPU; i++ {
        go v.DoSome(i*len(v)/NCPU, (i+1)*len(v)/NCPU, u, c)
    }
    // Drain the channel.
    for i := 0; i &lt; NCPU; i++ {
        &lt;-c    // wait for one task to complete
    }
    // All done.
}

</pre>

<p>
The current implementation of the Go runtime
will not parallelize this code by default.
It dedicates only a single core to user-level processing.  An
arbitrary number of goroutines can be blocked in system calls, but
by default only one can be executing user-level code at any time.
It should be smarter and one day it will be smarter, but until it
is if you want CPU parallelism you must tell the run-time
how many goroutines you want executing code simultaneously.  There
are two related ways to do this.  Either run your job with environment
variable <code>GOMAXPROCS</code> set to the number of cores to use
or import the <code>runtime</code> package and call
<code>runtime.GOMAXPROCS(NCPU)</code>.
A helpful value might be <code>runtime.NumCPU()</code>, which reports the number
of logical CPUs on the local machine.
Again, this requirement is expected to be retired as the scheduling and run-time improve.
</p>

<p>
Be sure not to confuse the ideas of concurrency‚Äîstructuring a program
as independently executing components‚Äîand parallelism‚Äîexecuting
calculations in parallel for efficiency on multiple CPUs.
Although the concurrency features of Go can make some problems easy
to structure as parallel computations, Go is a concurrent language,
not a parallel one, and not all parallelization problems fit Go's model.
For a discussion of the distinction, see the talk cited in
<a href="//blog.golang.org/2013/01/concurrency-is-not-parallelism.html">this
blog post</a>.

<h3 id="leaky_buffer">A leaky buffer</h3>

<p>
The tools of concurrent programming can even make non-concurrent
ideas easier to express.  Here's an example abstracted from an RPC
package.  The client goroutine loops receiving data from some source,
perhaps a network.  To avoid allocating and freeing buffers, it keeps
a free list, and uses a buffered channel to represent it.  If the
channel is empty, a new buffer gets allocated.
Once the message buffer is ready, it's sent to the server on
<code>serverChan</code>.
</p>
<pre>
var freeList = make(chan *Buffer, 100)
var serverChan = make(chan *Buffer)

func client() {
    for {
        var b *Buffer
        // Grab a buffer if available; allocate if not.
        select {
        case b = &lt;-freeList:
            // Got one; nothing more to do.
        default:
            // None free, so allocate a new one.
            b = new(Buffer)
        }
        load(b)              // Read next message from the net.
        serverChan &lt;- b      // Send to server.
    }
}
</pre>
<p>
The server loop receives each message from the client, processes it,
and returns the buffer to the free list.
</p>
<pre>
func server() {
    for {
        b := &lt;-serverChan    // Wait for work.
        process(b)
        // Reuse buffer if there's room.
        select {
        case freeList &lt;- b:
            // Buffer on free list; nothing more to do.
        default:
            // Free list full, just carry on.
        }
    }
}
</pre>
<p>
The client attempts to retrieve a buffer from <code>freeList</code>;
if none is available, it allocates a fresh one.
The server's send to <code>freeList</code> puts <code>b</code> back
on the free list unless the list is full, in which case the
buffer is dropped on the floor to be reclaimed by
the garbage collector.
(The <code>default</code> clauses in the <code>select</code>
statements execute when no other case is ready,
meaning that the <code>selects</code> never block.)
This implementation builds a leaky bucket free list
in just a few lines, relying on the buffered channel and
the garbage collector for bookkeeping.
</p>

<h2 id="errors">Errors</h2>

<p>
Library routines must often return some sort of error indication to
the caller.
As mentioned earlier, Go's multivalue return makes it
easy to return a detailed error description alongside the normal
return value.
It is good style to use this feature to provide detailed error information.
For example, as we'll see, <code>os.Open</code> doesn't
just return a <code>nil</code> pointer on failure, it also returns an
error value that describes what went wrong.
</p>

<p>
By convention, errors have type <code>error</code>,
a simple built-in interface.
</p>
<pre>
type error interface {
    Error() string
}
</pre>
<p>
A library writer is free to implement this interface with a
richer model under the covers, making it possible not only
to see the error but also to provide some context.
As mentioned, alongside the usual <code>*os.File</code>
return value, <code>os.Open</code> also returns an
error value.
If the file is opened successfully, the error will be <code>nil</code>,
but when there is a problem, it will hold an
<code>os.PathError</code>:
</p>
<pre>
// PathError records an error and the operation and
// file path that caused it.
type PathError struct {
    Op string    // "open", "unlink", etc.
    Path string  // The associated file.
    Err error    // Returned by the system call.
}

func (e *PathError) Error() string {
    return e.Op + " " + e.Path + ": " + e.Err.Error()
}
</pre>
<p>
<code>PathError</code>'s <code>Error</code> generates
a string like this:
</p>
<pre>
open /etc/passwx: no such file or directory
</pre>
<p>
Such an error, which includes the problematic file name, the
operation, and the operating system error it triggered, is useful even
if printed far from the call that caused it;
it is much more informative than the plain
"no such file or directory".
</p>

<p>
When feasible, error strings should identify their origin, such as by having
a prefix naming the operation or package that generated the error.  For example, in package
<code>image</code>, the string representation for a decoding error due to an
unknown format is "image: unknown format".
</p>

<p>
Callers that care about the precise error details can
use a type switch or a type assertion to look for specific
errors and extract details.  For <code>PathErrors</code>
this might include examining the internal <code>Err</code>
field for recoverable failures.
</p>

<pre>
for try := 0; try &lt; 2; try++ {
    file, err = os.Create(filename)
    if err == nil {
        return
    }
    if e, ok := err.(*os.PathError); ok &amp;&amp; e.Err == syscall.ENOSPC {
        deleteTempFiles()  // Recover some space.
        continue
    }
    return
}
</pre>

<p>
The second <code>if</code> statement here is another <a href="#interface_conversions">type assertion</a>.
If it fails, <code>ok</code> will be false, and <code>e</code>
will be <code>nil</code>.
If it succeeds,  <code>ok</code> will be true, which means the
error was of type <code>*os.PathError</code>, and then so is <code>e</code>,
which we can examine for more information about the error.
</p>

<h3 id="panic">Panic</h3>

<p>
The usual way to report an error to a caller is to return an
<code>error</code> as an extra return value.  The canonical
<code>Read</code> method is a well-known instance; it returns a byte
count and an <code>error</code>.  But what if the error is
unrecoverable?  Sometimes the program simply cannot continue.
</p>

<p>
For this purpose, there is a built-in function <code>panic</code>
that in effect creates a run-time error that will stop the program
(but see the next section).  The function takes a single argument
of arbitrary type&mdash;often a string&mdash;to be printed as the
program dies.  It's also a way to indicate that something impossible has
happened, such as exiting an infinite loop.
</p>


<pre>
// A toy implementation of cube root using Newton's method.
func CubeRoot(x float64) float64 {
    z := x/3   // Arbitrary initial value
    for i := 0; i &lt; 1e6; i++ {
        prevz := z
        z -= (z*z*z-x) / (3*z*z)
        if veryClose(z, prevz) {
            return z
        }
    }
    // A million iterations has not converged; something is wrong.
    panic(fmt.Sprintf("CubeRoot(%g) did not converge", x))
}
</pre>

<p>
This is only an example but real library functions should
avoid <code>panic</code>.  If the problem can be masked or worked
around, it's always better to let things continue to run rather
than taking down the whole program.  One possible counterexample
is during initialization: if the library truly cannot set itself up,
it might be reasonable to panic, so to speak.
</p>

<pre>
var user = os.Getenv("USER")

func init() {
    if user == "" {
        panic("no value for $USER")
    }
}
</pre>

<h3 id="recover">Recover</h3>

<p>
When <code>panic</code> is called, including implicitly for run-time
errors such as indexing a slice out of bounds or failing a type
assertion, it immediately stops execution of the current function
and begins unwinding the stack of the goroutine, running any deferred
functions along the way.  If that unwinding reaches the top of the
goroutine's stack, the program dies.  However, it is possible to
use the built-in function <code>recover</code> to regain control
of the goroutine and resume normal execution.
</p>

<p>
A call to <code>recover</code> stops the unwinding and returns the
argument passed to <code>panic</code>.  Because the only code that
runs while unwinding is inside deferred functions, <code>recover</code>
is only useful inside deferred functions.
</p>

<p>
One application of <code>recover</code> is to shut down a failing goroutine
inside a server without killing the other executing goroutines.
</p>

<pre>
func server(workChan &lt;-chan *Work) {
    for work := range workChan {
        go safelyDo(work)
    }
}

func safelyDo(work *Work) {
    defer func() {
        if err := recover(); err != nil {
            log.Println("work failed:", err)
        }
    }()
    do(work)
}
</pre>

<p>
In this example, if <code>do(work)</code> panics, the result will be
logged and the goroutine will exit cleanly without disturbing the
others.  There's no need to do anything else in the deferred closure;
calling <code>recover</code> handles the condition completely.
</p>

<p>
Because <code>recover</code> always returns <code>nil</code> unless called directly
from a deferred function, deferred code can call library routines that themselves
use <code>panic</code> and <code>recover</code> without failing.  As an example,
the deferred function in <code>safelyDo</code> might call a logging function before
calling <code>recover</code>, and that logging code would run unaffected
by the panicking state.
</p>

<p>
With our recovery pattern in place, the <code>do</code>
function (and anything it calls) can get out of any bad situation
cleanly by calling <code>panic</code>.  We can use that idea to
simplify error handling in complex software.  Let's look at an
idealized version of a <code>regexp</code> package, which reports
parsing errors by calling <code>panic</code> with a local
error type.  Here's the definition of <code>Error</code>,
an <code>error</code> method, and the <code>Compile</code> function.
</p>

<pre>
// Error is the type of a parse error; it satisfies the error interface.
type Error string
func (e Error) Error() string {
    return string(e)
}

// error is a method of *Regexp that reports parsing errors by
// panicking with an Error.
func (regexp *Regexp) error(err string) {
    panic(Error(err))
}

// Compile returns a parsed representation of the regular expression.
func Compile(str string) (regexp *Regexp, err error) {
    regexp = new(Regexp)
    // doParse will panic if there is a parse error.
    defer func() {
        if e := recover(); e != nil {
            regexp = nil    // Clear return value.
            err = e.(Error) // Will re-panic if not a parse error.
        }
    }()
    return regexp.doParse(str), nil
}
</pre>

<p>
If <code>doParse</code> panics, the recovery block will set the
return value to <code>nil</code>&mdash;deferred functions can modify
named return values.  It will then check, in the assignment
to <code>err</code>, that the problem was a parse error by asserting
that it has the local type <code>Error</code>.
If it does not, the type assertion will fail, causing a run-time error
that continues the stack unwinding as though nothing had interrupted
it.
This check means that if something unexpected happens, such
as an index out of bounds, the code will fail even though we
are using <code>panic</code> and <code>recover</code> to handle
parse errors.
</p>

<p>
With error handling in place, the <code>error</code> method (because it's a
method bound to a type, it's fine, even natural, for it to have the same name
as the builtin <code>error</code> type)
makes it easy to report parse errors without worrying about unwinding
the parse stack by hand:
</p>

<pre>
if pos == 0 {
    re.error("'*' illegal at start of expression")
}
</pre>

<p>
Useful though this pattern is, it should be used only within a package.
<code>Parse</code> turns its internal <code>panic</code> calls into
<code>error</code> values; it does not expose <code>panics</code>
to its client.  That is a good rule to follow.
</p>

<p>
By the way, this re-panic idiom changes the panic value if an actual
error occurs.  However, both the original and new failures will be
presented in the crash report, so the root cause of the problem will
still be visible.  Thus this simple re-panic approach is usually
sufficient&mdash;it's a crash after all&mdash;but if you want to
display only the original value, you can write a little more code to
filter unexpected problems and re-panic with the original error.
That's left as an exercise for the reader.
</p>


<h2 id="web_server">A web server</h2>

<p>
Let's finish with a complete Go program, a web server.
This one is actually a kind of web re-server.
Google provides a service at
<a href="http://chart.apis.google.com">http://chart.apis.google.com</a>
that does automatic formatting of data into charts and graphs.
It's hard to use interactively, though,
because you need to put the data into the URL as a query.
The program here provides a nicer interface to one form of data: given a short piece of text,
it calls on the chart server to produce a QR code, a matrix of boxes that encode the
text.
That image can be grabbed with your cell phone's camera and interpreted as,
for instance, a URL, saving you typing the URL into the phone's tiny keyboard.
</p>
<p>
Here's the complete program.
An explanation follows.
</p>
{{code "/doc/progs/eff_qr.go" `/package/` `$`}}
<p>
The pieces up to <code>main</code> should be easy to follow.
The one flag sets a default HTTP port for our server.  The template
variable <code>templ</code> is where the fun happens. It builds an HTML template
that will be executed by the server to display the page; more about
that in a moment.
</p>
<p>
The <code>main</code> function parses the flags and, using the mechanism
we talked about above, binds the function <code>QR</code> to the root path
for the server.  Then <code>http.ListenAndServe</code> is called to start the
server; it blocks while the server runs.
</p>
<p>
<code>QR</code> just receives the request, which contains form data, and
executes the template on the data in the form value named <code>s</code>.
</p>
<p>
The template package <code>html/template</code> is powerful;
this program just touches on its capabilities.
In essence, it rewrites a piece of HTML text on the fly by substituting elements derived
from data items passed to <code>templ.Execute</code>, in this case the
form value.
Within the template text (<code>templateStr</code>),
double-brace-delimited pieces denote template actions.
The piece from <code>{{html "{{if .}}"}}</code>
to <code>{{html "{{end}}"}}</code> executes only if the value of the current data item, called <code>.</code> (dot),
is non-empty.
That is, when the string is empty, this piece of the template is suppressed.
</p>
<p>
The two snippets <code>{{html "{{.}}"}}</code> say to show the data presented to
the template‚Äîthe query string‚Äîon the web page.
The HTML template package automatically provides appropriate escaping so the
text is safe to display.
</p>
<p>
The rest of the template string is just the HTML to show when the page loads.
If this is too quick an explanation, see the <a href="/pkg/html/template/">documentation</a>
for the template package for a more thorough discussion.
</p>
<p>
And there you have it: a useful web server in a few lines of code plus some
data-driven HTML text.
Go is powerful enough to make a lot happen in a few lines.
</p>

<!--
TODO
<pre>
verifying implementation
type Color uint32

// Check that Color implements image.Color and image.Image
var _ image.Color = Black
var _ image.Image = Black
</pre>
-->

                                                                                                                               root/go1.4/doc/gccgo_contribute.html                                                                0100644 0000000 0000000 00000010472 12600426226 016037  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Contributing to the gccgo frontend"
}-->

<h2>Introduction</h2>

<p>
These are some notes on contributing to the gccgo frontend for GCC.
For information on contributing to parts of Go other than gccgo,
see <a href="/doc/contribute.html">Contributing to the Go project</a>.  For
information on building gccgo for yourself,
see <a href="/doc/gccgo_install.html">Setting up and using gccgo</a>.
For more of the gritty details on the process of doing development
with the gccgo frontend,
see <a href="https://code.google.com/p/gofrontend/source/browse/HACKING">the
file HACKING</a> in the gofrontend repository.
</p>

<h2>Legal Prerequisites</h2>

<p>
You must follow the <a href="/doc/contribute.html#copyright">Go copyright
rules</a> for all changes to the gccgo frontend and the associated
libgo library.  Code that is part of GCC rather than gccgo must follow
the general <a href="http://gcc.gnu.org/contribute.html">GCC
contribution rules</a>.
</p>

<h2>Code</h2>

<p>
The master sources for the gccgo frontend may be found at
<a href="//code.google.com/p/gofrontend">http://code.google.com/p/gofrontend</a>.
The master sources are not buildable by themselves, but only in
conjunction with GCC (in the future, other compilers may be
supported).  Changes made to the gccgo frontend are also applied to
the GCC source code repository hosted at <code>gcc.gnu.org</code>.  In
the <code>gofrontend</code> repository, the <code>go</code> directory
is mirrored to the <code>gcc/go/gofrontend</code> directory in the GCC
repository, and the <code>gofrontend</code> <code>libgo</code>
directory is mirrored to the GCC <code>libgo</code> directory.  In
addition, the <code>test</code> directory
from <a href="//code.google.com/p/go">the main Go repository</a>
is mirrored to the <code>gcc/testsuite/go.test/test</code> directory
in the GCC repository.
</p>

<p>
Changes to these directories always flow from the master sources to
the GCC repository.  The files should never be changed in the GCC
repository except by changing them in the master sources and mirroring
them.
</p>

<p>
The gccgo frontend is written in C++.  It follows the GNU coding
standards to the extent that they apply to C++.  In writing code for
the frontend, follow the formatting of the surrounding code.  Although
the frontend is currently tied to the rest of the GCC codebase, we
plan to make it more independent.  Eventually all GCC-specific code
will migrate out of the frontend proper and into GCC proper.  In the
GCC sources this will generally mean moving code
from <code>gcc/go/gofrontend</code> to <code>gcc/go</code>.
</p>

<p>
The run-time library for gccgo is mostly the same as the library
in <a href="//code.google.com/p/go">the main Go repository</a>.
The library code in the Go repository is periodically merged into
the <code>libgo/go</code> directory of the <code>gofrontend</code> and
then the GCC repositories, using the shell
script <code>libgo/merge.sh</code>.  Accordingly, most library changes
should be made in the main Go repository.  The files outside
of <code>libgo/go</code> are gccgo-specific; that said, some of the
files in <code>libgo/runtime</code> are based on files
in <code>src/runtime</code> in the main Go repository.
</p>

<h2>Testing</h2>

<p>
All patches must be tested.  A patch that introduces new failures is
not acceptable.
</p>

<p>
To run the gccgo test suite, run <code>make check-go</code> in your
build directory.  This will run various tests
under <code>gcc/testsuite/go.*</code> and will also run
the <code>libgo</code> testsuite.  This copy of the tests from the
main Go repository is run using the DejaGNU script found
in <code>gcc/testsuite/go.test/go-test.exp</code>.
</p>

<p>
Most new tests should be submitted to the main Go repository for later
mirroring into the GCC repository.  If there is a need for specific
tests for gccgo, they should go in
the <code>gcc/testsuite/go.go-torture</code>
or <code>gcc/testsuite/go.dg</code> directories in the GCC repository.
</p>

<h2>Submitting Changes</h2>

<p>
Changes to the Go frontend should follow the same process as for the
main Go repository, only for the <code>gofrontend</code> project and
the<code>gofrontend-dev@googlegroups.com</code> mailing list 
rather than the <code>go</code> project and the
<code>golang-dev@googlegroups.com</code> mailing list.  Those changes
will then be merged into the GCC sources.
</p>
                                                                                                                                                                                                      root/go1.4/doc/gccgo_install.html                                                                   0100644 0000000 0000000 00000041166 12600426226 015333  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Setting up and using gccgo",
	"Path": "/doc/install/gccgo"
}-->

<p>
This document explains how to use gccgo, a compiler for
the Go language.  The gccgo compiler is a new frontend
for GCC, the widely used GNU compiler.  Although the
frontend itself is under a BSD-style license, gccgo is
normally used as part of GCC and is then covered by
the <a href="http://www.gnu.org/licenses/gpl.html">GNU General Public
License</a> (the license covers gccgo itself as part of GCC; it
does not cover code generated by gccgo).
</p>

<p>
Note that gccgo is not the <code>gc</code> compiler; see
the <a href="/doc/install.html">Installing Go</a> instructions for that
compiler.
</p>

<h2 id="Releases">Releases</h2>

<p>
The simplest way to install gccgo is to install a GCC binary release
built to include Go support.  GCC binary releases are available from
<a href="http://gcc.gnu.org/install/binaries.html">various
websites</a> and are typically included as part of GNU/Linux
distributions.  We expect that most people who build these binaries
will include Go support.
</p>

<p>
The GCC 4.7.1 release and all later 4.7 releases include a complete
<a href="/doc/go1.html">Go 1</a> compiler and libraries.
</p>

<p>
Due to timing, the GCC 4.8.0 and 4.8.1 releases are close to but not
identical to Go 1.1.  The GCC 4.8.2 release includes a complete Go
1.1.2 implementation.
</p>

<p>
The GCC 4.9 releases include a complete Go 1.2 implementation.
</p>

<h2 id="Source_code">Source code</h2>

<p>
If you cannot use a release, or prefer to build gccgo for
yourself, 
the gccgo source code is accessible via Subversion.  The
GCC web site
has <a href="http://gcc.gnu.org/svn.html">instructions for getting the
GCC source code</a>.  The gccgo source code is included.  As a
convenience, a stable version of the Go support is available in
a branch of the main GCC code
repository: <code>svn://gcc.gnu.org/svn/gcc/branches/gccgo</code>.
This branch is periodically updated with stable Go compiler sources.
</p>

<p>
Note that although <code>gcc.gnu.org</code> is the most convenient way
to get the source code for the Go frontend, it is not where the master
sources live.  If you want to contribute changes to the Go frontend
compiler, see <a href="/doc/gccgo_contribute.html">Contributing to
gccgo</a>.
</p>


<h2 id="Building">Building</h2>

<p>
Building gccgo is just like building GCC
with one or two additional options.  See
the <a href="http://gcc.gnu.org/install/">instructions on the gcc web
site</a>.  When you run <code>configure</code>, add the
option <code>--enable-languages=c,c++,go</code> (along with other
languages you may want to build).  If you are targeting a 32-bit x86,
then you will want to build gccgo to default to
supporting locked compare and exchange instructions; do this by also
using the <code>configure</code> option <code>--with-arch=i586</code>
(or a newer architecture, depending on where you need your programs to
run).  If you are targeting a 64-bit x86, but sometimes want to use
the <code>-m32</code> option, then use the <code>configure</code>
option <code>--with-arch-32=i586</code>.
</p>

<h3 id="Gold">Gold</h3>

<p>
On x86 GNU/Linux systems the gccgo compiler is able to
use a small discontiguous stack for goroutines.  This permits programs
to run many more goroutines, since each goroutine can use a relatively
small stack.  Doing this requires using the gold linker version 2.22
or later.  You can either install GNU binutils 2.22 or later, or you
can build gold yourself.
</p>

<p>
To build gold yourself, build the GNU binutils,
using <code>--enable-gold=default</code> when you run
the <code>configure</code> script.  Before building, you must install
the flex and bison packages.  A typical sequence would look like
this (you can replace <code>/opt/gold</code> with any directory to
which you have write access):
</p>

<pre>
cvs -z 9 -d :pserver:anoncvs@sourceware.org:/cvs/src login
[password is "anoncvs"]
[The next command will create a directory named src, not binutils]
cvs -z 9 -d :pserver:anoncvs@sourceware.org:/cvs/src co binutils
mkdir binutils-objdir
cd binutils-objdir
../src/configure --enable-gold=default --prefix=/opt/gold
make
make install
</pre>

<p>
However you install gold, when you configure gccgo, use the
option <code>--with-ld=<var>GOLD_BINARY</var></code>.
</p>

<h3 id="Prerequisites">Prerequisites</h3>

<p>
A number of prerequisites are required to build GCC, as
described on
the <a href="http://gcc.gnu.org/install/prerequisites.html">gcc web
site</a>.  It is important to install all the prerequisites before
running the gcc <code>configure</code> script.
The prerequisite libraries can be conveniently downloaded using the
script <code>contrib/download_prerequisites</code> in the GCC sources.

<h3 id="Build_commands">Build commands</h3>

<p>
Once all the prerequisites are installed, then a typical build and
install sequence would look like this (only use
the <code>--with-ld</code> option if you are using the gold linker as
described above):
</p>

<pre>
svn checkout svn://gcc.gnu.org/svn/gcc/branches/gccgo gccgo
mkdir objdir
cd objdir
../gccgo/configure --prefix=/opt/gccgo --enable-languages=c,c++,go --with-ld=/opt/gold/bin/ld
make
make install
</pre>

<h3 id="Ubuntu">A note on Ubuntu</h3>

<p>
Current versions of Ubuntu and versions of GCC before 4.8 disagree on
where system libraries and header files are found.  This is not a
gccgo issue.  When building older versions of GCC, setting these
environment variables while configuring and building gccgo may fix the
problem.
</p>

<pre>
LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu
CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu
export LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
</pre>

<h2 id="Using_gccgo">Using gccgo</h2>

<p>
The gccgo compiler works like other gcc frontends.  The gccgo
installation does not currently include a version of
the <code>go</code> command.  However if you have the <code>go</code>
command from an installation of the <code>gc</code> compiler, you can
use it with gccgo by passing the option <code>-compiler gccgo</code>
to <code>go build</code> or <code>go install</code> or <code>go
test</code>.
</p>

<p>
To compile a file without using the <code>go</code> command:
</p>

<pre>
gccgo -c file.go
</pre>

<p>
That produces <code>file.o</code>. To link files together to form an
executable:
</p>

<pre>
gccgo -o file file.o
</pre>

<p>
To run the resulting file, you will need to tell the program where to
find the compiled Go packages.  There are a few ways to do this:
</p>

<ul>
<li>
<p>
Set the <code>LD_LIBRARY_PATH</code> environment variable:
</p>

<pre>
LD_LIBRARY_PATH=${prefix}/lib/gcc/MACHINE/VERSION
[or]
LD_LIBRARY_PATH=${prefix}/lib64/gcc/MACHINE/VERSION
export LD_LIBRARY_PATH
</pre>

<p>
Here <code>${prefix}</code> is the <code>--prefix</code> option used
when building gccgo.  For a binary install this is
normally <code>/usr</code>.  Whether to use <code>lib</code>
or <code>lib64</code> depends on the target.
Typically <code>lib64</code> is correct for x86_64 systems,
and <code>lib</code> is correct for other systems.  The idea is to
name the directory where <code>libgo.so</code> is found.
</p>

</li>

<li>
<p>
Passing a <code>-Wl,-R</code> option when you link:
</p>

<pre>
gccgo -o file file.o -Wl,-R,${prefix}/lib/gcc/MACHINE/VERSION
[or]
gccgo -o file file.o -Wl,-R,${prefix}/lib64/gcc/MACHINE/VERSION
</pre>
</li>

<li>
<p>
Use the <code>-static-libgo</code> option to link statically against
the compiled packages.
</p>
</li>

<li>
<p>
Use the <code>-static</code> option to do a fully static link (the
default for the <code>gc</code> compiler).
</p>
</li>
</ul>

<h2 id="Options">Options</h2>

<p>
The gccgo compiler supports all GCC options
that are language independent, notably the <code>-O</code>
and <code>-g</code> options.
</p>

<p>
The <code>-fgo-prefix=PREFIX</code> option may be used to set a unique
prefix for the package being compiled.  This option is intended for
use with large programs that contain many packages, in order to allow
multiple packages to use the same identifier as the package name.
The <code>PREFIX</code> may be any string; a good choice for the
string is the directory where the package will be installed.
</p>

<p>
The <code>-I</code> and <code>-L</code> options, which are synonyms
for the compiler, may be used to set the search path for finding
imports.
</p>

<h2 id="Imports">Imports</h2>

<p>
When you compile a file that exports something, the export
information will be stored directly in the object file.  When
you import a package, you must tell gccgo how to
find the file.

<p>
When you import the package <var>FILE</var> with gccgo,
it will look for the import data in the following files, and use the
first one that it finds.

<ul>
<li><code><var>FILE</var>.gox</code>
<li><code>lib<var>FILE</var>.so</code>
<li><code>lib<var>FILE</var>.a</code>
<li><code><var>FILE</var>.o</code>
</ul>

<p>
<code><var>FILE</var>.gox</code>, when used, will typically contain
nothing but export data. This can be generated from
<code><var>FILE</var>.o</code> via
</p>

<pre>
objcopy -j .go_export FILE.o FILE.gox
</pre>

<p>
The gccgo compiler will look in the current
directory for import files.  In more complex scenarios you
may pass the <code>-I</code> or <code>-L</code> option to
gccgo.  Both options take directories to search. The
<code>-L</code> option is also passed to the linker.
</p>

<p>
The gccgo compiler does not currently (2013-06-20) record
the file name of imported packages in the object file. You must
arrange for the imported data to be linked into the program.
</p>

<pre>
gccgo -c mypackage.go              # Exports mypackage
gccgo -c main.go                   # Imports mypackage
gccgo -o main main.o mypackage.o   # Explicitly links with mypackage.o
</pre>

<h2 id="Debugging">Debugging</h2>

<p>
If you use the <code>-g</code> option when you compile, you can run
<code>gdb</code> on your executable.  The debugger has only limited
knowledge about Go.  You can set breakpoints, single-step,
etc.  You can print variables, but they will be printed as though they
had C/C++ types.  For numeric types this doesn't matter.  Go strings
and interfaces will show up as two-element structures.  Go
maps and channels are always represented as C pointers to run-time
structures.
</p>

<h2 id="C_Interoperability">C Interoperability</h2>

<p>
When using gccgo there is limited interoperability with C,
or with C++ code compiled using <code>extern "C"</code>.
</p>

<h3 id="Types">Types</h3>

<p>
Basic types map directly: an <code>int</code> in Go is an <code>int</code>
in C, an <code>int32</code> is an <code>int32_t</code>,
etc.  Go <code>byte</code> is equivalent to C <code>unsigned
char</code>.
Pointers in Go are pointers in C. A Go <code>struct</code> is the same as C
<code>struct</code> with the same fields and types.
</p>

<p>
The Go <code>string</code> type is currently defined as a two-element
structure (this is <b style="color: red;">subject to change</b>):
</p>

<pre>
struct __go_string {
  const unsigned char *__data;
  int __length;
};
</pre>

<p>
You can't pass arrays between C and Go. However, a pointer to an
array in Go is equivalent to a C pointer to the
equivalent of the element type.
For example, Go <code>*[10]int</code> is equivalent to C <code>int*</code>,
assuming that the C pointer does point to 10 elements.
</p>

<p>
A slice in Go is a structure.  The current definition is
(this is <b style="color: red;">subject to change</b>):
</p>

<pre>
struct __go_slice {
  void *__values;
  int __count;
  int __capacity;
};
</pre>

<p>
The type of a Go function is a pointer to a struct (this is
<b style="color: red;">subject to change</b>).  The first field in the
struct points to the code of the function, which will be equivalent to
a pointer to a C function whose parameter types are equivalent, with
an additional trailing parameter.  The trailing parameter is the
closure, and the argument to pass is a pointer to the Go function
struct.

When a Go function returns more than one value, the C function returns
a struct.  For example, these functions are roughly equivalent:
</p>

<pre>
func GoFunction(int) (int, float64)
struct { int i; float64 f; } CFunction(int, void*)
</pre>

<p>
Go <code>interface</code>, <code>channel</code>, and <code>map</code>
types have no corresponding C type (<code>interface</code> is a
two-element struct and <code>channel</code> and <code>map</code> are
pointers to structs in C, but the structs are deliberately undocumented). C
<code>enum</code> types correspond to some integer type, but precisely
which one is difficult to predict in general; use a cast. C <code>union</code>
types have no corresponding Go type. C <code>struct</code> types containing
bitfields have no corresponding Go type. C++ <code>class</code> types have
no corresponding Go type.
</p>

<p>
Memory allocation is completely different between C and Go, as Go uses
garbage collection. The exact guidelines in this area are undetermined,
but it is likely that it will be permitted to pass a pointer to allocated
memory from C to Go. The responsibility of eventually freeing the pointer
will remain with C side, and of course if the C side frees the pointer
while the Go side still has a copy the program will fail. When passing a
pointer from Go to C, the Go function must retain a visible copy of it in
some Go variable. Otherwise the Go garbage collector may delete the
pointer while the C function is still using it.
</p>

<h3 id="Function_names">Function names</h3>

<p>
Go code can call C functions directly using a Go extension implemented
in gccgo: a function declaration may be preceded by
<code>//extern NAME</code>.  For example, here is how the C function
<code>open</code> can be declared in Go:
</p>

<pre>
//extern open
func c_open(name *byte, mode int, perm int) int
</pre>

<p>
The C function naturally expects a NUL-terminated string, which in
Go is equivalent to a pointer to an array (not a slice!) of
<code>byte</code> with a terminating zero byte. So a sample call
from Go would look like (after importing the <code>syscall</code> package):
</p>

<pre>
var name = [4]byte{'f', 'o', 'o', 0};
i := c_open(&amp;name[0], syscall.O_RDONLY, 0);
</pre>

<p>
(this serves as an example only, to open a file in Go please use Go's
<code>os.Open</code> function instead).
</p>

<p>
Note that if the C function can block, such as in a call
to <code>read</code>, calling the C function may block the Go program.
Unless you have a clear understanding of what you are doing, all calls
between C and Go should be implemented through cgo or SWIG, as for
the <code>gc</code> compiler.
</p>

<p>
The name of Go functions accessed from C is subject to change. At present
the name of a Go function that does not have a receiver is
<code>prefix.package.Functionname</code>. The prefix is set by
the <code>-fgo-prefix</code> option used when the package is compiled;
if the option is not used, the default is <code>go</code>.
To call the function from C you must set the name using
a GCC extension.
</p>

<pre>
extern int go_function(int) __asm__ ("myprefix.mypackage.Function");
</pre>

<h3 id="Automatic_generation_of_Go_declarations_from_C_source_code">
Automatic generation of Go declarations from C source code</h3>

<p>
The Go version of GCC supports automatically generating
Go declarations from C code. The facility is rather awkward, and most
users should use the <a href="/cmd/cgo">cgo</a> program with
the <code>-gccgo</code> option instead.
</p>

<p>
Compile your C code as usual, and add the option
<code>-fdump-go-spec=<var>FILENAME</var></code>.  This will create the
file <code><var>FILENAME</var></code> as a side effect of the
compilation.  This file will contain Go declarations for the types,
variables and functions declared in the C code.  C types that can not
be represented in Go will be recorded as comments in the Go code.  The
generated file will not have a <code>package</code> declaration, but
can otherwise be compiled directly by gccgo.
</p>

<p>
This procedure is full of unstated caveats and restrictions and we make no
guarantee that it will not change in the future. It is more useful as a
starting point for real Go code than as a regular procedure.
</p>

<h2 id="RTEMS_Port">RTEMS Port</h2>
<p>
The gccgo compiler has been ported to <a href="http://www.rtems.com/">
<code>RTEMS</code></a>. <code>RTEMS</code> is a real-time executive
that provides a high performance environment for embedded applications
on a range of processors and embedded hardware. The current gccgo
port is for x86. The goal is to extend the port to most of the
<a href="http://www.rtems.org/wiki/index.php/SupportedCPUs">
architectures supported by <code>RTEMS</code></a>. For more information on the port,
as well as instructions on how to install it, please see this
<a href="http://www.rtems.org/wiki/index.php/GCCGoRTEMS"><code>RTEMS</code> Wiki page</a>.
                                                                                                                                                                                                                                                                                                                                                                                                          root/go1.4/doc/go-logo-black.png                                                                    0100644 0000000 0000000 00000021213 12600426226 014747  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        âPNG

   IHDR   ‹   M   Õ`
g   sRGB ÆŒÈ   bKGD ˇ ˇ ˇ†Ωßì  "3IDATx⁄Ìùwê›Wu«øoﬂ€ﬁWªZÌÆVñdK∂åe„cƒ)ÑdBHO&ì˙3LfR'ìL2)!çûÑêòjà;∂±¡≤åe∞ö’ªV€˚æ}ÔÂè˚9sè^ﬁj€€’.˘›ô7Øˇ Ω˜{ ˜ú{nZIK⁄Í∂î§6IÖ¢œ´$5∫ZR≥§YIπ5r›iI%>oî‘%ir!◊öJ∆?i´‹2 j≥§vÄóóT…§ÆaÚûë4-ÈﬂÁ◊=]'i1ÃÛú7ü¥§ï[ÉkØjIíÍ%›¬º€Ëj—fïlÒ~P“Ä§Ò5p_’íf∏øVIY¥€I'$ΩL“FI/J:≈˜câÜK⁄J∑:ISN#ıHzπ§%µ`~5∏òíÕòk¶ ˙%=-ÈIIG%ñt§êW≤’pª%5!à∂£—f ﬂ)Iw#∆$Ωƒ==%È@∏§≠T´@3IRßZµ§ c&◊&&tMVêtëˇ50©ø"ÈYI'%=.Èπæ˛JÑ@A“ù Ìû;$ùïtΩ§≠Ä
¸∂4Zñœ^.iè§í>*ÈÖƒ§LZπÅf°M“´—=|◊ŒÁ)¥‹9Iß%}áâ9ÅV¨@„˝«ÌíÙhìm ˆ…‘Ãõ%Ì‰:ÆGXlà≠äjI#\O^“AÄˆ,˜q≥¯míÜ"G¯.\“ Êﬂl`æ^“Îò¥¯5U¯jiI}íûêÙy4«>|ªèZ&«Ã ºÎ%›&È7%=_fa—*È{yﬂ&È^√ıòøòã‹√>7 ˆÒõûA~∑Å«FI«¿%≠≠ÛfIØb2Œ¢j dìÒyIüDªòú” ¨`VABT¢m*≈¥§ÔëÙÊ2ÆûÛÓÃiIª8Á.ÓcƒiÓzﬁW;q‡kÂXòôáÿÀW‚À'HZ“ñ⁄™ ÿ›ín«Ñ¨dı≠ èJzê	;≈ˇÛ¬AtK∫è„◊;¿S¯ê;∆rZ æçˆjÆ∑3áWçP®CPÒ»qØu‹˜˜îÑ¥Éòú3âÜK⁄r⁄.¿∂ãIg¶c~€EIˇ"ÈKíæÌ4Z1€8ÀÁï /Ö)÷Ëààz˛◊Ç_5∏LA—âÄÿÑÍ XuäÓn¥XösO®&¸ iÄô‘Õ\Ô˜⁄œqo‰\¿%m©Ì&I˜‡ÁTaru∏d¬_)0ãC¸ÁJZ©‡M:ÛRÄ0Á¸≠# ñÿ“L˛Q`"w`Ún‘cÄ• ÿr\À$ ⁄Ë6sΩiÄπèœû·∏Ê≥ˆ#ênít8\“€R¯&∑„∑â`R˛ú§wK˙&ÆPÇ§®QåapÃçíÓb“v)2Ç¶+˘›®b…ë~·=ínE˚4JÍhäxZ·>éI˙ﬁ[à Ö˘IøœuuÛ€.Á”ç¢IS	‡í∂ÿ÷.È˚ G'©ûâzQ“üI˙/Õ§Œ;’Á¿0ôr+Á·∏rKÔ:Æã∏ˆ^Á∑5bN:_lúså(ƒ—>IsñœÑ_◊ÓÃ⁄œ!xﬁãpx‡Â∏ávÃ‡⁄pI[L´W`	_èvj¬kóÙIÔQHmZl´D} oL1n'g∫eÇ»ã5)3ÄÎnàë˚ƒ«ÆLµ¸vT“◊%}!rœñ∂v †·s†=†ê‚’BﬂÃ‡”U°≠´¿%m°≠Y“Ø ©ªè˚%}
m±¶^ZÀ4VVÅfofÇöñ46∏§G¥¯ØfÑƒ)ƒ€f9Ô,◊0≈π∆|B!=Î ◊f6ÖÄ1ç\Õg˚$˝«9Åø÷èP™É\9+i8\““∫blÊª53QüP†ËˇMã_FSØ»˙yˇ∞ÄO8é∂…3a¯˝Ã"œ”äV˛~I◊*2ë∆0ûxó$}V“¢igı±ä+R /À˚Á8O?øÈC„›ŒÎoJöM ó¥˘Z>œ[ÿ=c˛[“˚%}câƒãÖ ÃáÀ+∞yòd9 gÚ¨B,ÔË<ƒHﬁù£ÛÕh‰<@üA„‰05îÙœh–ú3eEœÊÉŒpMi4o^!MmàÎ<«o{‹ˇFÕ∂MZ“Êj’
1™◊)0í’L≤ˇÄπ∞Ã„Á›s¿∏M1-ÃÄ3â∆˚¥M‹¥íêÙF¥ N*¨>®Ü§π ÈCh:ï Xqõq~Â¨{mÇ°Ç◊õ∞“ê+„	‡í6ü)v∑§ü¬'©v~ŒGò®K]ç]Ä§ö‰Ã∆&˜ô}_+Èã∫ÚjÅ¥ªû6¸µ∑8Æés¶—Æg$}M}†§Ÿ–¬<ö‘Ã…¬,Ω wÅØ~4^}∏§Õ’%˝ZÌ@êE√¸#d¬r◊¶Ÿ“3_©ìiiT&Ï_Î Ås3õ0Åﬂ¿1j zNíI4Œª%}Õ˝œÏπ^˚åz-&kM÷ q.*ÊUÓO ó¥R-#Èô¸w0i'q>äü≥‹f⁄»íú‡Ì
)`∆Óô9˘iÃ¿‹<~a≥BÊØ)Æ6Hs˝Á√EÓÂkEÑÕRÍßTpùi≈@~N1›k!1!òÿpI+n?'Èµí^Å‘Uà±˝=f§e…ßµÙ‚\ëü¯Àòîª‹˜ g
Û¯öYÖE´?§êOÒ<çY7†√˚'ÖkZåi<ä…›·˙§ ∂qÆ/ziñ¥µ—*ú	µ⁄Õ|•7J˙y≈e1YÖè)2ä≥EœKΩW+Ù æU° œΩä´Xr
!á√äÙ{©6≠@øˇî3ò«åcÚ3¯øÛÂ*HT T≥>g∏qﬁŒ˝\∏µ◊ÚWËØíÙNÖ‘ß:Äè+¥≥%¥Y° ˇII…§˛ó/˚Òüòñ9◊9õ2HÆ≈üÍ•?%}K!˝ Êp∂Ã}ó„˘Ä◊abc˙>›	‡ÆnK_¡úÒûÄÛ%¥ƒr[çB‹ÎWò¥„L‘èJ˙ Zh§Ã˜mD≈W$=¶PØ‰
ﬂVŒˇº¬™˛y æE°Ü»€Òù˙∏ﬁfÖ¨ë3h…Á— È%òïUÙ◊õ8Ô0¬™`ÔWX|ö¥u
Œ "¿-‰÷∂*¨¬û∆π?)Èwô¸F\‘,„|Ûµ'¸∑bbnV\û3ﬂÑˇ>zˇ)Öz'è≤ár;∑Aû‘Æ¿µ7s≠PX∂≥–”üTäëJ⁄˙h9≈|æ¬2¥[ælÄˇcELüV»ˆ?´òœ8µÇ˜5ÊÓÔ‡),Pp‹ ‡:ÒïÓF(«Ô˚G¿'->%læ÷
®PL¥∂∞Ä0c?Q M⁄˙iF™Ta.∂Ÿö2´§ıKòëõ„SüƒúÀiu∞⁄äÍÖÄ-√$ø≤bB£ä{8®êÈî„ïlæ‹y†€épîœf∞æ†ê ùh∏u‘å–®D€ÙÚ˘≠<ûU†•3ò4¯<Öy»äfHíüuæ‡8˘a≈Ïx#2∆¥∂Jç∑†Õﬁà&Î§ÍÀ“}3r∫ÃVÜ˘Ω£
IYÖÅì _¯sKù;‹⁄h€™Gä∂ ¡;boa0õÙõÙ]|>ÃcLÅ∆ˇz»
NB◊aä˝±‚ÍÊChµ⁄¬@]≠ZaÕŸ˝ÙSçb–˚òB˝îG@åîŸî4Î –^£Pb¢ü◊Ã 'V(‹’%=,I∑í…≤õÅ€ä4ÏVHz@≤e$‹x5)ƒö™òlLÇc
z)SÕRó2¯<?éV∞ú¿ <WÇîò–⁄Ÿ¡F
¨‰õ:Ê3!4ûpñ›ë-ÛπÕúüD^áYyÄ˜3Ù·W5GFN∏ÂÉ(Á˙≤]qµoßbyΩB09†*˘ŒÚÔjô ≥ä‡&˛˜"ÄáT8ÑΩ	>Kˆ∏ÊÆdeı+*_èøëfÚ|ñ„ -Â*ÀÎ•Ü ™tyŒaÆÑ…\•Xø$É∂QÈ≈¨ıòí[b]£XÙ…#ò‘© õ◊rv˛Ñ_}_IÛi∆0\âŒÀ(&Æ◊dCg†H”…Õtx‹´∏9E/ø„wä	∫BcŸ∂L9≈là~'ïk≤æ¢@5úÁI™ö≤á)Œ”©êE≤€ÜÔSXj#≈X_ﬂÁ‹Á≈Û&∑ Ç√OzøN≠Ia…Ãû•PJÆÉ>x“°ú˜+$&w)÷…#îûƒw2¡µ\ﬂ9_D6Yø4C–‘sæ;›XŒ`ŒN\…w¯ˇB>ÿñI≠ä1-€P¢U1∆UßXëw≠R´X√£5“…Lº¥”$cØM!c„$ì¸úB†w¬˘G¯˝)¥òïœ>•+Ø˝ZêV\xyÊd-`öÅE˚Ñ._{f>‰à˛o¯¡&‚Ï@^ú¶÷Àq7*§o›D_∑8sªèÎÌ·˜óW|ﬂ†ê÷M?UÛ€Ò?œ(b].¡SòCp41Ó≥‹«V0tax^“ˇ\i‹æ[gK&∫ÛÍÆµH§å\q:≥ŒM¶GfT1Ëµhò@gP”…{ËÖ8÷~sR1:ËµbˇË‹&E©Vx_°êîºQqCƒÛ
Ÿ$£nBY	ÅÅ9&m˛
Ê°úÊ5S1≈5< ¿⁄—j8]üˆÒﬂVI?ÜPz	Õµìc¥¢©«ÈˇS∞ÅOqåú ìãZÍõË7€Æ°P…‹yÑ˚òè[œ+„¥JãbΩämÄ´…ÌÆ√¨ næh‚O1INüI>ª¿@?ÀD}âﬂüÁ7ñ•Q¨uNπ◊Ní”Ã+’j—˜√hZNd¡Yí	7'¨ûá˘W∆ e8ûe≈[IÔõxøëælSX&3Ñ…’âœÒü≥	S∫°ÿÈ|ÿ-
©]Ìí~Tq}[}æü˚{Çbr˚—6Ûÿ§∑¨Å)ÌeÃmÔÅßKˇ≠K¿ŸŒ&]ò@Õ<¨ otlÜN…:6ÆC1~UÀ≥˘L'ëàgõ‘ß∞Hq s™ë	”W4ó”VìÌ≥I¸
´,ÿ=•P¯w∏W´ÚÒ7´Á_·àìüóÙV>Ô°üå$ÂX∆¬àãÙµ	∏¨bp∏ãÒ3ÇE
Kq>„XÄQ} †ncÃæ ˜W˘rKKô«”úoáb:◊NÓe=åñÀØ¿U2H7s3ˆ>„4ï-Ó´qÊ_¡i∏¨bÅ#CRˆq¥‘#ÄÌºbåfÆ8Õ˘¢˜≥Z_ÕjÑºŒiñ˛Œªä´RY¡&n˙ı≠
Î÷)n¡d g\™Iœæ[±ø’ÛüvñI?ÕB!ˇÆPLµçˇﬂÆP÷nˇ;…}›™k¸'7N˘¯BpÌ‰^;Ò%Mxû§œRL¥^3Ä≥Õ‘Õ‘ÈAì\Î»
K?2©g_€‘°éŒ≠v>@ùÎSHú˝
e‹Fâ&Ù›ŸJ±ï5í~ò…⁄´XMÍ¨§?Âπ‡êB	¶Fá—åﬂCø60F} m‹i∆&Öÿ‘^∆ŒV[O)I›ÄV8√o∫˘ˇ d·íAÊE'cjæ∑U€˙ÄõÏ+ŸÆEÿè°·63õò˝òæ_[»¡ 	∏J'π¨“≠mfg%±-*o€Ÿ∆∂X£3˝Ï7S‹X=É;¬`Ã*,(|Ü9IßúY£·áÇ.œ]µ˙˙À’úçÙë-mEˇ4Øè
I…á0ùÎù?Wät⁄`õa7ùÈùqæ◊~wéqŸs¯◊sJ±º¯v∆rê	˙éq˝Ç!√v+drÙpÏ<c[á&º∞¬`´@8t`˙ÓTXtS∆ô∑[®@_,‡ÍylR‹>∂¿vÑ¨ÁÛv«Ù5⁄Äe{A8m)%ìpSaT!É‚,Â$ØœŒ!ô◊J≥ıkgÓÃÚ>ÀuO,rÕÌa“ZYÅßa*pÍôâ“éêöDÉ<»§-(&&ß‹uô ∏À1ú['ÍV∫qÈ·8ˇ„ôV¨œhAˇ]
9èΩé\˙ñB‹Õñˇ<!’∆˘é@ƒ»Öa^D{>ã‡XA3ﬂz∏èkú∆üBÎ‰>^ÃXŒ∏mnÄÔ‚§Õ®Q≥Õ[∑≤}’é›2ü°√utÉb˝ø17êXè1®ìŒ◊Â5 ◊KX"_¬?úq¶ÚL	a÷ÈLÍ;7$¥¨√L¥3 ÌQ≈¨ïæ∆ΩåèM‘	≈d^+UPÌÃ–Ç.P[ÚF&÷G¨t1~˚ê˛ÔA¬W8À"PMÉøù„_£∏IF⁄"É˜^4Ê@WÄÂ‹¡ıü`æ|ô{>µ
Ûa8ËULàÿ∆ıZ9ÙgäòËEŒ¢Ë7 %má»Kh1´RT¡ˇßCx\1Mi ∞4“ô/08ı¸Ó, “⁄ D_(›ûΩ¬†Oóêò÷_’Ù¡HÅq&ˆµÄßK±Œa˝ﬁä÷åI◊»ø ò¨¯kÚçdò•Õ§”¸≈|ÁÚoVX~F°‹¬QG*çÈÚ‰ËFGDMCÂﬂå–Õ†Í0-ûˆ^Ói6Úìí˛¡1”‡Y¥Ù*ˇ⁄∂bk¢G!Q¿‚∂˜Aùu¶Ì$Çß©ÄªY“ü(f=[ºƒ®ﬁçé4'x¥Û˘i≈%"ßù√<5%>∞NâäÖƒ|Í‹D3Ç®≥»§Á4øπËBÌé:∑∞GûˇèÒ}Œ˚I˙CÃ¨Ìòa>orçÒ∞B}ê&≈FØ$ÓG#
_ÎS‹œÒ9k£ä+ƒ€ñ Y&Œ7÷ΩpA6\Bh‘†Åﬂ•∏ÖTZqèÅVÊZv«µäsﬂ∆Ω‹Æòhû„ûŒC
}f)◊ìqÏa∂Òoq≤8¿}®N´H‘O'‚ˇg\¨bVˇöØ3“≈Ñ¥L
å6#®⁄öÕí∏ËR¸œZŒôí„òp›LæSä´Ü0Øq˛◊`ùò˘7»xùPX˘<Œ±≥Œó∂t4øﬂZ©‘®≈î4/ T~Mk{∫Â—`∑Òªg±zˆr¸ª–“FúòIzûk~íl)µGJ˙u¢Ÿn£ot˝VáØYâü˙Õ•Nö›‹ÃwPëO£±^∆Äös›ÍÃë©ÔRp’9”ØE1«“§ﬁY>œ3∂ãL/˝aº±[y7©gùoóV[¶ ( ±úŒß9Á)Ö∏S7ø˚∞b‹Îc|vøB-ê*gùÙ(èˇ
p˚ÂˇY≈‚•Â6œz ’ôi=‡@föÌ®§øÂª√Ùy'}r}h¬©
°Ò®HÂnÙÁ;ò—Œ{—»£Ö'ôè.GJøP‰w<√Û°"J{pï&}Jóg<§»F⁄n&ñjS•ÀóŒú©µA1xkåTáãªlb¿á◊û’9PŒ*nﬁós ô¬¥*æÆoœ„Ÿ÷HCh¶„
©bÕ.,2Ä8ƒyN Q/a™üw~X=yäcX~ÁîBp¯úﬂh5˝Wj‚ﬁ"È∑°–Ûò ≠N√õπ˙Æ„ß6søog\W¨«˘X˘¥oÂ¸UN u:?za˚gZ˙¨
¨6ıûV‹ï“bKV måüp jb¿Æw‰ç%%è∏0≈àsæ7”…◊∏P∆∂é„‘:F-Ô@ek≈ºì=(˙§ΩÄ∆≤∆«ôD«Û6;ú9^çU±èÛrˇmæÔ+7À§ŸÌn>„& ~X“ﬂqåi≈4$s!¶À<n7I˙U∂#‹ˇl9ÖE≤Áπ«#ä9ò-äÒJÁãNXâåí4ÏÂä˚äß∑ÕöD–*¨Ü?º∞-p´e 5 3¯ Œ«GÒ>Áì8≠∏mï£ïM”ôyhiHuäy}f⁄ô©∑¡—ÚY«∫Â1É.qm'∏∂}
©RÉ\üì‚'êò≥0&xl"vµëAQ¨C?È¸¨Cs<3Á2Î€ù¶∞≠q?ŒkØÒRs∞®ÀmØd|†è^†/~ZqΩ€QHío m◊ ‘BqD1l\a]‡J0Ÿ◊*‰önVÃ&πè±´¸g˘ÆOóoiµÊgAÓ6≈MÏv‚µπÑôÄdB±vEÖÉ≠∏‰l¥”>VT#•∏äŸñTåª	nÀléqG–T{1˘6+:78∑ ’}ˇc˚0Õ9‚4V•"Wä·,Ñ˝jB≥ îc4˝(¨‰ò#wl{›rõdµ¯òoB∏Xb¯èª˘µs/c|¿…±öñ©‘ Ì8ßôÙÂlıúÁÕäãÑ[pF≥[é+ƒCˇ±∞^ ∑E!%f3 K)&#õ©vüY6J££ò+‹‰…∫kØsæõ˜õ*•€È®ãtö±|È‘ºr¥ˆ®bñºô©’∞Ä˝\œ9&ÿ8ámá€Á¿2\@Â")jR∏™ yìb`¸A&©æ˝~ Â õ	/cﬂ·é=Iü[“◊$˝9‡øDø˙]L‹úËq!Ç:∆Îø ¨ë€†˚w#,∂(næ±Aù·˘ÇBÓÈÀéX¿ç{'ö»Lßn4„Ã<À7¥-fÎ‹d≠eBÂÄ1GZúT‹´yí…(e+ƒcı?≤Œè21Â»cÖÆb¢ÚqÑ√ÏÄµí≠í…y#æk´ª¶q¸æºõ•ÅÂÀ8¶∂2˚◊KÌb7cö˝)V@•læuavn¢oßCëÛe∫ÓzÆ˘µŒGõQåΩŸ^rÉ¯m∞ë_/w,i5Zü§≈9g@,òŸ†òöîßS1®'n:›Vd]®¬ös∞Y>~cÀ|Ë¸¶ãúmîã\Ô¥bv}Õ*ÅÍJÕ Ï‡æõËÉ«	s@ÛI”À1'≠ˇZ\®„ùå«9˙N¥€4BË˝h©ë9XÓjÓadìe–ú‡ıögAÁ[æ˜nLI¸ñÌt◊w
·˙íBÏÚÖrõ‡´8€Ur6|+*}ø3Nπ…1ÌÊ)« +VÁı&_)s«÷uYû°Ø]ò)"ZÜxÿ>bvÕs-8ù∫ `´Á∫nA8ŸÍ+—6éê23›ÿL[µº‘fñG'ˆ'0±G◊7(.&¬Ã‹Øò,=◊Ω‘—ÔØP‹˘Ù"s¢FÀ[…m!†õ7òÊ˙áqqÓ‡ù Û†Bj€È`EWù•Ã”πèIπÈ¢˜ññ‘ ƒ°É≤Œü≤Eç>!ÿ4\5Ô}T3Ul-ù•6MÃ√Æ•f+/vC⁄Ã(∆–∑√HkKﬂöq~ÒRù˛≈up%˝àBÊºùˇUX-B;¸⁄);œ9gl7⁄¶›ë'€ﬂÍ!(*¯˝®b)Ú6ÖÂCõ ò≈JÓô†ø§Î˚ºBZ€»J‡’n∂‹ﬁJ’•‹u•úÜ4ì≥Vó◊ŸHó #¶›˚¬‘RÀ—nX¡mï-äKöùp±Í\VØ§ NÖ%ú∑˙ˇ≠úc∂3ÕÍîºõI;üfJ;∏¿mQ‹˚9Æ∑îsˇ+îpäk±4b‚nDÀmW,JÙ‹õ”¸v7Ê@>æís5Z —¯f6„h„,Éîw>«`	z≤Ñ…Z™Ù›◊¨LÅ≈)–h'¯nfúYŒáÀ∫…∫ma[˜ﬁ‡:ÉZgÜ ?ßêÌøê§t[d|6–|y#√æ≈πG‹ºiV¨_“¨#ùtsπ"È^4Ê.X‹Á·@™ç”á_Üp˚íb}≠'¿˘T,{]_<ìFW0=µ6Ù:mñU3ãv€•∏¶≠S≤O1?3ÌHìúæ+ç˜}™!HRÎ’h†£hçÁ◊I˙ƒÿbvd2† & !H)∆ç∂≈≤SŒTBº°PÉ ∞ÇFñQíAÉvpûßËªO¿'L¨∆@ñõÆˆÎ≠lêã”aF-öx≤rñäd˘úF0ç)ÓÍbŸÌUE;∑@ÅiãW≠ﬁª¯Ïå‚ K¶íÙ7
9õ√Œ‹üã–≤<Ÿ.≈Eò¿Á≤ Ω-dùv`h·ú∂Ã®ëy∂$„Ê¢ôÿ÷wßV3ÄÌ˜ ÔKZŸ2{+8#5íVﬁVêÓs€ k[è—Ÿ-N”ôÔ6±@gy•¶enÄpÿ°∏ü¡N≈dÄÉê#Dñöñ+·ØY(∆ó|?ÜiXÅ˙¢‚∫øìäÈy#Ó<∑‰‚ùä+≈ÕUÈÊZ∂*Æîb∏Á´
%!ˆ≠∂?ülÊ±>öÖ8ÓCªô©nƒ√ìÃÍGN87ÂL≤J«‰˚∆VŒ›»©]
ôˇõôîo„<VXwÒ¥bEÄ7Åã„û•¸ÔÖEiŒ}¶Òu‹ß≠&∞MGÛe”äYD„h»3
… € £qc yÕˆAÖ‡ˆ™˚˘	‡÷G≥‰Á≥Í˝N®◊1Ÿab	Äi¨HÛÿˆ≈∆Ú⁄fbhoƒY&o†∏Èó/)VÀ-“|ï]o•#L[∑(Ø}H1¥1‡¸Rø±â◊[◊(ˆÚø&◊—†ˇ
:ò .i•öiä6≈
®u¶R⁄≈jtÒ`9ç”%Ã˝z≈8îe\ºü™QqaËYÙ4‚cä	»Ài}äY(∂éqD!˘π†X∂û˚±’}
Enk∏vqµä+⁄Î–ƒGV|”¯™ïˆH ∑>ìås¸m-üO£B¶∆≠òLmH˘£äy£Ω∫|·VGÆ§1Wﬂ∏nòê€w˛Ö…˚åbVN™à [l€ßê/i%Ú2ò™˚J´+îV®uª¡∞ì◊ªì'Úêœ §û‰∫“UfΩ¿≠n ≥Ëí‚÷ƒ>}´CaâåeÈ\èÈ7åüe°ò:Ö¡~¿ªﬂÈïäÖdÕˇ≥µi9Ö8’≥êCE◊∂úvQaç‹ÕPwbˆ]T®±ÛÉ
	Ÿ”ä+H∂“j≈-∂L∏Cÿå(≥xW=ƒî n˝¯pY&“¥ï»X»ZÖ≤‰waF=¶òÍU…‰õ‡ØU»{ºfªyŒ8PN LÛwÊ˝JÜø¨ê_€¶∏ØﬁΩä°Ö[xòôleáùü9©X‡Jô/(,”âÁ&Ä[?mòI5ÜØf˚⁄9©∏r~
ˆoÛÒA¥üÌàc˚S≥◊¢òÚ’≤ê~≠r¨Ã`≥åêÌòÜó–‚[πÛ◊ù&Ùf£≠‚∞Õõ÷%v*Ñ*>©3∫ñ1ïÃ„5Ÿ¸J+ªë…ÙIø·|öJg⁄YÜ˜∫>çÊ≤Û}
Á¶·û-˜Ù	éuXa-ÿ7¥2±Uøßü˘]Ôƒ7Î@9 u˜µÇƒñ¿ÏA#·√>©XkÕ1`I[õ>õmu?mÁ“ÌòÇñ*g…º∂f–ä ŸŒ6∂En;&ò≈≥Ü˘˛)¥À!&ÍW´Ü≠TÜmÄ9.)ñ^ÿ¨ò[kÙ˛Ig>>¯F/?)Ú%¸µB∏§-«i¬Ô:â∂∫ïœáùôïh£ä¡aKq⁄»ƒ<ÃgO(ñô0SÛE¿w@1”c•€&≈ï˚Y4ñÖ∆.REÿ*˝*ÑÂêÓ¡Ñ|
ì{Õ&Æ'Ä[˚Õ‚p„äªΩ^B⁄w+ÆwÛ‡¥¸Bcı¨Û>€s ÕÇ∆œ·∑}[qcï’ö¥ŒÎR`[áh¸◊V9‘°≈˜¸ ◊˝yLÁ5øB$Ò·÷WkRXx⁄ÖˆÃD+l¥IquFpU,7ûEsΩ Œ†È*Æ≤æ⁄¬•S”6é±UÊ=‹ÎaÃEÓa]≠mL ∑æöïå∏◊ÅØïáI€î~TÅˆ∑Ù++wn>Ÿ9&¨ë*3kl^Ô7nY5„Îy ¿≠_M◊≠Hõg´çΩÄ3©∏WvØ≠ä◊X“ÖIK⁄ÚZE“IKZ“íñ¥§%ÌÍ¥ˇg_O˛Ía
‰    IENDÆB`Ç                                                                                                                                                                                                                                                                                                                                                                                     root/go1.4/doc/go-logo-blue.png                                                                     0100644 0000000 0000000 00000022220 12600426226 014621  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        âPNG

   IHDR   À   K   ﬁKsÎ   sRGB ÆŒÈ   bKGD ˇ ˇ ˇ†Ωßì  $8IDATx⁄Ìù	òT’±«ÈYÄôF@QP¡‹‚JDÉw}—ƒ%ö∏«g4Ó…ÀbÃS„nÚb¢1j¢ß’∏≈˜`@Q\ÿdDÅWˇs~wÊL€3ÃÕÃ ˜~ﬂ˘n˜ÌÓ€∑oWù™˙◊øÍ¥jïnÈˆ5›∂:8[¥’¡Æ4zûIÔJ∫•[›JìÏÀ¬ﬁ•7%›÷Æ¿myP6zÓ÷πÎg¥KˇÕtk
ak\õ∫›ô-j>EJæ;VÏÍ◊≤ªˆ”3›ö–ù	q@ÆR$ØÛZ&ü¿6Õu∫÷˘Öﬂ:\[Íä•[”(M©‹¨L¨ E6JLX5ÉWh&oÀ"%µkh#•…£,õÿ®Lcótk2Î¬„N&åùLË∫òÄJ7≥«€€˛66G0KõcG12π.£=Ô*WÃÆ≥}ÓÔI∑tk¨+S5ÛVÔ≥≠â[∂¥±ó)»q∂ø“∆•ˆ¯w6Æ±«∞˜üaè˜≥«€cÖö|óU´∂2Ÿ2m∞ÜRË^∂ﬂ”∆¶ˆ∫,aQ™8È∂&≥r±	QqtL
r¥çˇ±„ø∑qß=~⁄Ú∏	ˆ|∂=ügcëç7Ï¯∂ˇëçæˆ∏¢©ª≥tŸo⁄8ƒ∆·6ˆ±Òﬂv\œœ∑qåçKÇÇªslêΩ&≈nﬂãtkŸJÇUÒV§∑Â¶⁄˛œ6≤1‘∆p3lÃ≤˜øg5≈Oî¢ÿxÀ∆*;˛¨ÌØ∞◊~ú†PÖûΩÌ|f≤√u∫cmˇkøµq
Ò€è¥ÒÄçmÙ≥Ò/?`øk¥Ìo∂qû}æ¨éÔiõJH∫Â∫/mm¥±—≈‰$7ÿ„{mˇ∞ça6^6°íRå∞ÒÇΩv£çìÉBπ£Ïµ√Q¶WÌ¯$€è∑˝õ∂ø∞∞mNÃTA|t√îŸ±ÒR¯n7ŒéΩ#≈Êÿ±ªÏ:/∂qJ∞*ŸGl,∞!•˘f´4ïétã¨äK‡-lúÃ,,%˘7'Åz•˘Ω	\Ø‡Êx◊gkΩp◊ûBõùccæçOl|*≈+‚U,p7Ô${~≠}ﬂ„RPR–œlºoc™óı˚»∆
Kπ˛—ˆ[˛d˚Àm‹m„ÀﬁÏRIH∑˙*å˝ª6Æ∑Òò	·£∂∆∆ã6ﬁF»‰ÆÏF–\n£≥ΩØúœö¬∏oÿÛ´ÏÒ@⁄XÑ—-ë €kõØË‡c©m§ç´Ï|áÔrRÊÈˆ|∫=œ∆A9ú¨∆BV◊≤Ã∆t¨ﬂÛˆ]Á<€Î}w⁄æc*	ÈV´EQ +kbÇr¢=÷å˚®=~Ãm∞=~≈ˆØ€ÛgÌµo	*∂—ÅX°8°¡(Áb˚J{m[{|∂Ìﬂµ˝!v…Æ≤Á_au«4“=L∆`jwÑ≈NO…RÿkS7Ÿòc«?Â˚VÜ«n¶ΩnÆ†≥8 ¯‡VpRòóÌ¯ãˆ˙BîG1÷ÓµX›4fI7/›l¸ƒB·°‹®±&Løµ±)≥z&_ê  k£XÁl‹ØUAaú,À*fˆ_*qŸâ¨ .¡=t∞s»%úMº±ê˝b\™Â†r≤.p±‰ûÕÂöÊ·ñÕ¡=\¨ëõ"ó.˙M˙ΩõªRAYè˘ƒˇ∑ùœóX~ƒÚOkíùlØDú˝v»∆W8…>◊≈v|¨äŒ†e˜C≤«À´ÇÎì<>£ÅÆWÜÛÔd„Z;Ô=\üπuNnﬁ";˛πî“^[¬w(Fôi„Ù  8)ŸÓˆæû6~Ç"ôbxÀ2%Xù√[üáÏxy§†©∞¨ÔÆWÑ&ùf„6ê¢◊Ñ^ŸòfèØ7Aj√˚ä·…	¥[≈«Ì};4>^Å~,ã∑.}xç≤Xù…Ò<éÖ¯ ã∞às.Fqd)ÏÀ]¨å¨√æÇó£sáœœ	‡ÖWÏ/ÇÖräa∂Jï$›ZÂXác»?<ocå	äÂm¥SïÒÆiÅ≤u°S:◊∏sßŸÛ'qç∞&n1ä3=·e’”™(&Í Ñ}?◊gv˛ˆPñ•ƒbjØÆ≈e¯≠eRûpùÆ+p≥¡ﬂÓÛ `»MÙ÷HJ8ÊAI*%ÎµÎUÉ∂rÜçø⁄±QrI‰vô–<hJqX¸ﬁ’ÉûFRî@∫ˆ¸Rp%1  jTÃ]ø∫sG•…F%4ˇê4èX‹·>·ú≥ÉµqJ*ˆ©fAGâ€ãÊ"e∑—≈ø4≤~Ô√|\1ËwäØ%›÷_ã¢Yˆ8Ÿvüáê≤(∏ﬂ¨!B1™¢s_ä/!VYÇõ$7Á ˙*µΩø<ÄŸ'lºiæ,∏ZN¿¡[ˆ|d»¬ªCmlê1W£g>8/ÅñX…ùQí1∏ùÜ¢e&w≤ZøO•$çQ†≠{·ù… ƒ+≥˝SπQç8Ô¡ùsâ%hH∞\Æç	‡™(n—,æs~X6õ…°“Ÿ1{.Ó·À Z_‡&=ãrõRŒYbŸjπ∆6|G
cDP'KÛø}Å˝,)µ≤˚©ƒ¨Áä¢`›[†Î˛bÇÚ∂xXñ3‰>Â‡ÎÅ®µã?cè∞sÕéêØïƒü⁄Ò˛∏˘Æ±(	$–øQÆ'∏Jnñ}œ‚¿AÛzÀã∏Àml≈^E´qÈä»	áól%˘≥.ﬁ] ‹,Ì¢Tj÷ÔXEÇ"A˛?ËÔÿc„nπ3@G¬ﬂ–Û*>BàPÏÍ>±±äòÖÑdˆs‘√Ú©`Ãx[Ÿ'ÌOcIƒò/K`„{œQ∂Ô ˜ó◊á‡à['Ö,	.ôÎ)˛Ä√{]˘ó∂ó;æ1˜"›æ>®◊±¿ÆìåõD|*µ)çRî§®J’ë¡çÚyå…∏K”@¡íÀÌ˘,Wîï/Ç:ÛwE	—èp√4˚KyvÕqﬂäÎcEFäΩ91ã%5›4‚ñŸ‰]Ü÷≈<N∑&ù·≥M©$…˛çs»wÿlÍ≈*ÅÜﬂ¶·ÁØcll#Õd!q≈å‡ƒ€®ñÎl§ªèÌüÖ9√Æo*Jß _…»›Éep_˘ç∏'˙≠›Ì;ÿ˘f`µ∆ë‡¸»é›íJiàÙG7Â˜õˆP®˚ò¨µÇ⁄S$g‰]Q#æ£ò	@≥ı…‚_E0qbU4.≤◊h9Ø†+ihÔπ…é".ôÚ9£ò´dM3ÍXRÂPn§ƒ`<÷v
~t*≠-ï Ævfl¨äŒ˝ç$ã`® €#J?í-ç˝˘∆˜’πïÏy÷≠≤$—DLc%ÁÏ…}1”≥úˇÆ"∞ùxà=Œ⁄ıÕÂ´ÆQ]-èV£,*?ÖÂz•\ÚVôÊVö7^(™Kÿ4c“œ*ˆ≈ã£ ëˇØdûfjcﬁzj∫êü”íº»ö
DTõØ†πPÙedŸ«oàê˘˝ÿ
ÂX>çÓX:πB/Àæ‹:∑WmTõ∏h‡}…Ûø(9î∆[@=ØN%∂[ò(£^L¸Pœ8_I§h"F
˛Ç°_'…ñÅåÍ7‰|{;ˇ.ê≠Œ™∂-7‘Æ’Ñ◊Ω¡–sU3nMß4?‹Ï∑êR«ô≥B~≈Y{˜ÃR…\g\3◊W®Ü‡(ób„JrÚ˚mÔúççQ§÷ÖrnjcÍt'…{Ï*∫5%˝©õ1¶sˆ\»‚ÜZé⁄îNg⁄3=NM˛$;&"¶`ÌªRIlQJ·V˜z‘U*Ózre7ÆáP¥éZ´^h"∫˜qg∂M\;Ç˛¢fû§(™ç˘_\Øq‘Ùk<|,+Xû
4}Ùn¢ÿ•∏†ß†,ˇ§∆EÒë‡ÈæMçV¶[û 4ﬂ±†Æ3ÆH_ÍIŒ°©É5Pp∑¿æ√˛¿?áb*üÅè„µﬁö(FŸ[mâ(döJÓ‡∞§wV§XÂÕ9YhÜ∑aÆêg&À™»%öäeQ—òb†÷ƒ™$ﬂÅ Ì†›ﬂÇz_ä`âNgµ0Ó)5ÁH%∂¿Ò≈ÍfπH(K°ól∆,∫ßΩ∂wË_%Ù»]ár3¥Õvˇ±˜ºN≈ﬁ\Ú"I∆)Xﬂ¸´A≤ü•; ?
l˚±¬Ûì‹‡zM‡◊Zh*≤§|ˇ~ #®ÔkXïô*iﬁ!i¡Tò	´™¡^k&£õHB.Öe¨˚uëxc©§Ø°Ø[ãán	˛Ô∫Ÿ≠§⁄˘ÍØÖ2¸éﬁT≤œÿÒ°pœ—(Atì«m?ÉÇ¶aˆ¸	\ß˜Ω√s†¨Û£kü;”ÜNäûX≤3´"tg(I«ΩﬁﬂﬂΩ¯´AùBüIÚ$1·1û8‰Ó$.ñΩ∑"°–‰N.¢©êº|ï∏aìƒ…ƒ"òπ°PvnÏñÛùvÔîàÙh›@Z#Õµ1¢∑∏M◊[∏8˜á,ﬂ≈¸ ëÈJA†⁄0 qsJ’òÄé%ù1›ÿ8¡∆Åˆ⁄E4çDj
‡üçÄéf∆I≥π1P…«c=$‘ñ{êÎ·gWëèß3JGh#≠sÛ
π¬åãQD¿zU`·˙B¶ÂPYv»}o|éöµÌ˘gÒ»J÷†∂$J¿l›(÷Ë4æª„ıT]˛,7—I„,&ã10~ï$Ωé⁄˙v¸ô∆YëöIVx`•‘–[“‘âÓ?Œ~◊«Q°◊ÖÕÂñ∂¥ò°,‡¯N. ^bƒä$≤πsâ~ÆÓÖˆ>eâ’·¬–+{;yÇ«‡)
ÇÔõ$LdvOˇ¨	‰˛≈[ïcÈiu=≈õÍfNß¥KûÎMbê‚⁄%äy∫ÖR[w$πÇ)PY>¥«ó%ÌR…Ûî–¿ª8Ü§kë÷ç·÷úÔµ}€L∑««°®ºÓá@è±∞º(ïÑ˜{Ù!{Ç¬+QYÿÁO–ƒ+c#cîLûâS˜|gª˝Ôj9ªê.ö„C¬‘mﬂ¯π’ö"MÌ≈-Fô·2 ,ï‡˚Íi%˝%≥÷-Ã‚˜ÄÇ<àøÇ∞+S¸:tç…∏Do—QÒe\ÖWBì9•Óv¨çhÂv¨´‹§˙˛Ÿ˘°Tó´uÊTÏ˝€bÌ^©Fu|˝Œ0KªäZÚ!5b/|˙÷—„L5_Ã∑;ÍZ$9Àzªoã;≈˝{ï¸Õ,w Û∫‰⁄®§jÒøÕπÒÇ3˜”çIR7ú&=¯æÇ+°£¶Æ;{†=>ÖIkÌ™"5∑Qc°L∞ıâ4Cnec∑ ∞™¯Ûu‰ßRqÉfx;vhÁ„ÜON&pÕ{8∂ÇÀ[Ì˘e¥˝¥πÓÙ@ﬂPáã»◊Ì¶ôö≤∏.ÂNÑq-O"t\yîrÿ¯‡Í∆≤sP‡lYMÂ “UﬁÁ. ¢¯B…JUMû ·ÚO∏u¢Ú;&òQ‘Ω»}1˙ΩGŸÊS˚1Ü\ŒƒP„Åâœ¬D„T∂\Ií2À{ßê›Ñ	Î@¡∫ÖÜlœ)Fì¶⁄&…™xK∂‡D% «&ˇY#–ûl≥+ñ¢"ßn7{.·=ƒB›Fn∑ÁBÖ∏œˇ≥ˇo{mq¬´Iº "û†A€À›≤Ú”Ïv≤|GI5Ω<‡Ò	R¥∫{—\ã‡0ÛÔäÎ8ç¶KCìÔ5\ÃhÂ4íˇ∑muëWV÷>˚#É˙*¡wÌÿB mï£Yhüôk«Ê£zn
‚Ê—ıqA“µ%TD˙¶v´pG’∂h,”ƒ
ØÛﬂ˘"ˇÈÁRÚ…H‰é4
ø∆ûèß¥yÚÒp‚˙µj©VeP„i£1x^–ˆ∏L«Ñ6ûaöÂÜ?â"®…Û,ƒòˇq¸©S¯£GÛòUqB°Æë€ °hn◊±±HKú<Ã…œ\àÎ5/Í%|rIRï†'s_ÇÔ{©k«94„Œ$Î?ÚÂ{˛4Ä≈‘M†%ÍRÍVñŸ{TüPÚá”£Î¿ë3A†&„Ω
ËqM“¢–r`≥}»1˘˛Å∂ˇî˚ÙnË†Ôˆm2Ò’@∞VÂ(evŸŒﬁ≥?‘≈†&Ê_ªø`∆y4g’|£®ß ¬≈_≥„¢}_|Qw§=ÔÅãV∆Ã⁄ú±V1œ¥nh^ ∫wõ$»NubÕm]ºØ≈î? *÷&pø≤µÂîˇ—>7WiO£≈[Í<ú)àSrùΩÁj{¨5N~&%ßû≈s¯?§÷^äs +/∂∞‚;¶˝3ú[	@°ÜﬂT¸⁄XÂ ıª„~ypf6H‰±âÖ-ÿw◊° ®‘UCÆ0r¸Â˝ôUŒ±πä™∑ªiöƒ
ô—f0cÕ]ö1Vﬂ¿íÿb9>Æ∞Ûπ>uıújj¨<j‘PŸØ™˜o«÷ßä/$]€‡>¯ëmàMäx\LSâ—ÃÓ+ò8≤XO9n‰Wàò†`j÷Ω?ä6+∞˜öLH†!àˇÖÄ{‹6Z?≤7î˚!M=L¸%u,B∫,◊î˝ËﬂY°Ãÿˇø≥hﬁ-Ö˘_Œ[T‡ˇCtûûabˆÂ
\ÒpWﬂ!1Ÿ°ê¡Q|)√˙Ú} —≥)Ë±Y*{7iÈ‡h}åQö≈ò˝¶ƒ…Wßç	»lnº=ÈÓp5ü—È“úkñÁÉls&ç÷Ãƒ;’	ª|¨aÍHz–Ó‘íò¬÷≤Jb^Å’˝Nÿ˚˚ﬁ6˙∂ãU-ü†∏AÆÕœI6V)híOä>€®¸ÚÄRy⁄˛$>ÖﬁXp4Va3‚9çJXÃrôÔµ„ﬁ•(ägßà π´hùöÉ˚Œé˙Ôß±†–≠4¡kü JÖà˝"ÜE9ä˙”¿;Û≠gWb«È¢Wv@å∑ó†]L—„5f†◊¢@z3ﬁ[hÚC(Oø`U\?®ßÿ9{†V¥¢ˆÍ¡ñêU%æ*Y}\‚WÈmıßíÎπ;3¥fÿøê∑iÁ{É8`.«;øos|
-Uìï≤§”}qqÑH©Ü¸ºÒ™ñˆV©;-KÉ>36¨k‚◊TŸÇ^∆ÒD–*M{~œ%0f`Qn WëÙ>E;ÖyyòQ›O»ö€±–°@RÖ ˝∂%(<*˙<Ù{Xî'B≥>∑iAî4™(á™ëtü¬1ó p.Åí‚ä˚Ìπômü=∆l2≤í˚hSﬂ˙åñ† âw¶]ÏÙ•f‰7‰^ƒäN¶ÈÙ4Óa“S˜öœ≠åf˙9P0>c2:ÑÔØÃ–ÔN,ß/Ô<V„ÍBIqmô¯‹4A‡¡∫Âü®¢ Iπuä˜d¢ÍN≤óà∫C3n)ÀﬂîÙ√=?ÎÒö&;6ïœ£lx√Of>†óÁ£ñ≥ fU„›ÕèQÍî.4í†‘—æ¥Op´òπ± TBaˆÄ¥∑+≥ïet›F2m·¢]ãIxÆNÒí∫ãh≈´xî¿ÊÕ`%:±ﬂè@Ÿ`O≠6ï}",Ü„ãñ¶2À.EàÊ‚¢$-Ló≥_bﬂ]Qà”g¨)2k=64êÛË’(ﬂp _óA◊ê0-ﬁS"ÙT@V≤/-¿§ô¡µz4k(ﬁ¬34¶XØKñs>Û+;˛>3Q˘b-åtb·≈«>ªŸt◊smO1…O√¢=Yﬂf‰JL∆pû(‰Bó‘?6Áf&,ŒÃ⁄Ï’%¯f¸,YÇg5àˆ=qw@¯è¿U“˙$WÑ“XøÔ˝ M√C«O)ô)z˜‚ú∆tã˜ÔaçB_K˛.ÿ›@·è™_ó]ÉcE_°KÉPäC®?ÈÇu8A˘àÍ•ﬁ|.‰‘ÄÄπM(¯Zõ
zÔoÁÑóÒπñdq¢Wa
Ô‡”èd ˝∑fÇÄÇE±Q!Û)  ˚È^ﬁÊπ∑πˇ”Bb’w‘/.‘M)é;Ü◊v”õ 3ù4sn]_§ƒnƒ÷–[∫2Ô⁄Ú8ÒÅL‹ÓÍ®nCAÛ’jÄöa{0‚±‡¯<Õ@™ÀÌπm6É´ÇŒœ¯âe®jE ™R‹ªOóT›Uì·c±ÆÒÜßV\D¸\≥bÅ±öV,\%îY∑€Ä”ÍΩb;áïSáñ˘Ú2ƒÉô°G±‚◊≠()ìÉõ¡Ω<0ÈcœO“Ôzú>ËÔßŸ≥
ôÃM˙îÖI^Ä±=‰M®›Ø¥î^A…P™3k3^X◊))J[°w®Ù$»”Ñè£¶÷v¸Lñoæ«é€¨Ì¥˚Û,Ÿ¸|•¡¨3¯îç◊∏ëãH¬}Næañ#üÛûOÿNF{,@«ç†w¢≈|8Údò≠ø‡zœUÁDZ*·á‘≤Ïâ•nO<◊°ñ˚Q
•/‹Ø¡’Î#˙º»!‰îTIYûÙ¸Z3◊+.mˆ.¯SPÑQœˇV4a»≈±≈ä<M¶{ï„:ﬁMp=k4 ´⁄Ωp≤‰sw?4π€Æ°ñWÎI.JZ{|h°ÍböÇÂèÈz¥.–ŸaFrÊÔäì‰ÄÌ´5 ˚ëôIÇèﬂ¨¯`$n¿§êºÙ	∂©amAˇ¯=÷ﬂl&¬¶ zÀ–—£*{˝FXÂ ”Ãç6ÔÛE{ÀBÈè	+Ze≠∑ïW^{Õ+…NMÚ≈L}†Xlé{∞5`e	Õ$'»nµ∫‡⁄ﬂÒsä;“g'™v’T˘F∑3™ëß`‹√åäGÆ◊íÿ6XQÀ7y–˙+`µìœ∂˛~ëf/ìJP∞}M≤íV&]≈”r´Æπ!7BuA‹#q„^ÄE 7z„uJQ"xOdƒ#	… ~Ã<ˇ‚∆é"¿˝|íã´O÷úâkí‘mø<8Ùi$H‘Çªd¶ÎGQ÷˛Pˆ7Uå~∂Ø5Úˇ˝¢Ü	Jp	eÈIYjÎdI£eÊæ‚÷6Âã8\Äîæ%$ A˚Ô¿H2˚Ek¯1[w¬uô˙ˇ˙ÔpÒ÷Xû=b≤¶Ë¯‚ÌâUÃ7ùxÁ:îjç⁄/ë∏›$0|≤ªàÃ¿⁄-¬˛kCóŒhI
SDRÌ~Y78ˇá|ÃpnËà˜ïd˘«É2ΩôøÏ∆Ü4)‰„F‚πiﬂ	±Ä€N¬n«6≈Ì…‘‰Y˘Ñ[ÙãÎß‡w®]©⁄k#∂u}âïµ)P√gOw˜bA†£xÂW±Y∑ê‹Ù¬◊∂Å=±QO‹«°&ﬁÛ#±–+pa∑	q†wì€Ê¸˛}∆H∆™‹í⁄5ãœ?µ#6˝e`∏Ñ2Obπú?R–Æ’∫∫¡ïjÀ∫ ßÑ?≈Èá›ÅõÒZø`	úu!™‚¯≈êıG˝Y]ÚaˆI·Tn7¬vÙ¢2.ôá∑§àj–ßJ\ß‰≠õjväj0*HÆ›E≠Õ,¶Ø>$F¡Îé4‘≤Du@˙lG‚ß}IV√ÇM ı˙<X	Ôt´I„©ëó´c<Kdœ!÷zÄxÆÕÍV'ŒmÎZ≥»Õ	D∏2†á~¢ΩÔDÎ?æÉgÒBàk]ª‹‚πuŒãnJ3˜°Ë«ÌjE¸zÌ…ó√ÆµŸ›m≈üŸë°Lû(YÕ6C&∑5 ‘!T%˙ T∞¶πSnrï!n™¢]dÚ≈YMi∆âk ∆Û‚ﬁÑ”49∞®}¬∑#.`9π≠vâSrñ…€0¿‘û∆ﬁü>Zpâì`^Ñ ›‚ÖéÚTSvÖ`96‰Ä¸zè*ÆRmÃÈıµ∂LlU÷é‹1îf"Á-◊√‰N Èø |≥i}ªÍØÅ~›Õÿh™∂˛¯fê47"@.ÓB(¿ä™˚ NVDÕ®†ôCQN‚1÷q5î£9£ñâ•úÊr7$´
— 	ß⁄ ;Üﬂ[Ω&I#ª¥hÈ¬§uTà›fËÈ°ã•ØQ`≤_]¿˜∂úµÌá†®ØÚ ÷ï¸v\µô[	üËºíBªûX;±Cîózõ≤Çß·°-lf_∆}[à-[∆ˇX† ﬂµ™‡–LÄx°~z[öF»]Í¿±2ø8±,IAS}:ø7WëV#2—Ã–ûZ>Ù+Yj˙18f›ì…Ä})˜´M}Ñ$gÒÿéús+&.YÑE®Ω’µä3:ë`;ÅÊÔ·¸˚´≥J»ù≤iX∞»ì4Yâ´äY]Ç⁄3@ÒÓöàì®XWÊ1ƒoœﬁ(sﬂ+Í∫.[πÑ∏¿W*nB†ù°ˆ#ìßˇÔÂo÷çâ§∆=Í*:ù≠Âª#®—jWS2‹1¯Êﬁ∑™oÕ%=Çö=Ê˜√—çBW¿h>?XuWT◊Ñì∏±$~1œ	DOœ8>éäL)C\ \ÇGPñ$U°UBvº¢Ê˝–f^`Äπ’kÃxÏ˚πΩ‘÷9+¬üXTO∏FuÜ__6ıé ÜÜOA°‘¸·Æ–ï&î¡Ú^Â™JÛı ÁÚXÿª^¢Î˜â™¯*B∏&√˘¡ÚñøÁ@‰-Hy{¿fû —s!3ˇA¥ì™HrA E—˙Ù•x}~M|v!0x™6ﬂéVg+t œıXS‰±Ÿg ƒ’™≠b/›Ú∂mB^'DIJ"™ÕJ‡ÚﬂÜÖM}¬s„Píÿ‹µ	JŒ¬£ÌA¸:∑Hâ;—Wº0ŒÜs;◊s—6ß◊Vy‘’ø*Ó›l»∞1ıG«ëÎZàÄÎ\ñ{©bû'.WIGv g#E;?î ˚<ÿUjÌjœ«bMD))ÛC‚π]âaS·Yﬂ6∫÷î·Õâ8hK®Lº°⁄Æ R-âfÁÆ,ìrD]ïÃnØGΩ∆/¢Á/º7ﬂD‹,ò;X4:8÷Ä„kãÉ∏Üìix±
Öô‚œ“Ë¬u∑Üp©$oO‚≥Ô¢,gÚ˛;XKÊ…¿⁄ˆ=ñaQÔ ¬HôTr÷+%©Ån¸rë3˝∫ú<«lr
Çº’‹nCÚAä'*ÿ¢úÿß◊¶=.õˆóG}—¶A_ë2Œãé˙r‡ÕCe§ã◊â©PBœ,,¡¢–x€ıèVÚ∑B‡Óìüª¡Æ>÷Ú%QÀ•IaÂ/œ≈˚4∞ú}Ü€)UnìJŒ˙´0≈‰âˆîp¡ˇZı,^L|±-(÷v†É•¡µÚ0rçò04≈ì˚„FàŸ¸(ÂÉC'Ø4(‡õIè∞5J¿íX—ûzÚ,Áæ/îR˚ÑÙÆ@„¢ıÖŒSP_Óúî6Ã!œ≥ûó≥Ω„ÕÈ∂ûZÑø73|B\BùÃóaÜÉŸ“ª@“L⁄HÌC[n⁄N¥“b¶á√»ùA∫âr|≠Â\äª‚Ü|çahÒRË¯Ë)¸s` œáu,7ÌP"¯[éÊ}ﬁÇ|î¨ Ä7ûí’ÌÏîaM∑ıSi⁄ê[¯¬ºã≤¡[A›˛≠–`‘ﬁÁ∫›Ù¢FòΩÈô©   ]∑T≥æùÁ˝@Fu7€Û^¢!%ä[≤Vè∏´år‚≈ÙS´¶˜Bs;5ÈÛãM1{ë¶wS±A‚ñsΩÈ∫/Óff]»ó•€⁄çS™Ñﬁ’œhZ!e˘åòe1……/a◊ä\yïù{“eÛ †◊[ÄöGP{Û~‘;·m¯ZWRc”'·y5V´ªw˙2Ù≠©ﬁCæ/È%∞~ŸJ@
Ê‰n˙rudÿ9ﬁxI≈Ë˛1Á-EQ◊[®8õâP$ÁJ0nÑÿâ¬ÒëΩæ2™–\˘BÖ&Q˚˛xh[Î˜˜B*ı>≥ÙT^›˛∂–]«”àä…Ë¬*nU]¨Á€:Õ£˜Ò,˙LBÈ'‡b}»R‡”°˝?ÜßıBÓV≠»©í¨Á ‚"eq	’£í ˛r˙Ò~¬¨ªÇôyv“◊8™Á@<Ún†™∏ƒ•y£∫R‘øG≤ Ω‚Uçe%£ ŒIñ^Õwè‡Ñ:Á˚ò‰M,‹t,»”J∏Ü˛ræuÔ˘…˙ò©¢§[mnX)ôı˝Ï±÷Ö
¸:'X˜)µ˜s¬Í∫R%	(j…G–Bﬁ	πøf C‰m.	Aºèkä÷ãÇÛvÉ“$¯Ÿ
˝|ŸÔΩaµ≥*ÙM¥≈O™C˘ß∏^4xWÉ÷T"›ææ–qN‚≤ê±ˆ0Õ4|ÛÌèâ]®/&.òå0&Ωô˘;C±î/ﬁhm+?x[Íçˆ›-O˘e<.Õ$úµÜ›màKzá\ãkõJB∫’W–≥´ìù◊˘U|’t„u\≥˜£ûdÉ…ù<JüÇk)œ~Ñû÷¿Ø2V# _€÷íò,i#€>Ù†s"ÄÓ(1>ø≤Tò≤µ}mÈˆ5∂2¢•@9ä˚È¯®∏„Í–5∆óœˆ£:Ò(∆…ÙËNÕK“÷í\œ˙_[ﬂ]∞{ëUÕ-PqÀT_´≤	I»Æ‰`¥T]yÙU  Â°6$ÂJ’!€ôÇq…"*wÍ;∂†8Y˚±æ3bö›Æ”bÚÑ)ÆùnçùlK[µ5j2…)wŒÁÇ•3S∫5j¢-˙ö˛Æé…öó…ˆˇ£Õ‚7£–9    IENDÆB`Ç                                                                                                                                                                                                                                                                                                                                                                                root/go1.4/doc/go-logo-white.png                                                                    0100644 0000000 0000000 00000051735 12600426226 015027  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        âPNG

   IHDR  L   Ÿ   “Po  S§IDATx⁄Ì}q‰¿÷Û•0L¡L¡L¡L¡öBSh
M¡¸ˇ˜÷Œ~ZEßÌôºÊ!UMmí›d3~µZGGÁ?ˇ1√0√¯Ï˚ﬁ˝ˇ◊≈G¬0√0#&L&KÜaÜa&UÜaÜa&MÜaÜa&LÜaÜa&LÜaÜa&NÜaÜaÔCò√0„]Ωãï√Ñ…0√0Nê&„¢›˘HÜaÔ∏ Zm2nπ^z	√0„Ì¿÷ÁÜ!”Ë#aÜaò@>ßm¬‘Yï4√0º∏ö†˘ú∆?´˚ÛÁ`Û∑aÜÒˆãÎwV%¨R¸¸π˝jÚ‰ÛgÜaxq˝¬V˝/∂øznªO|ˇGa≤‹0√0Ä4›¨$∞ítÙ¯hˇ¸y˝ƒ˜@ò|Ó√0ï¶≥$ˇøèæ÷Ÿ@¸Á˜´Æ	√0√¬JeÂE¢¢Î«=|ﬁ—øÌº?a˙Û}›ı|^?˜—4√0åˇ[$Øe/>∆œ˘Ôz·øπÿ@¸î◊¬@dÿÁœ0√xOıA®@ˇ]$'zçR_õˇº{z N˛gï„«Øçœù…ØaÜÒnã!´C#¸y%@°πÒR‰
Ê?e:¶ﬂ=˜G_ª^Ù˘¿ä£è¶aÜÒäJ¡J+(I#¢ÈI∫•ıœÎøü'¯¸˙˙Ô◊2|úà`ç±'∆ÑÈwÆáÆ·I˙ÄÎßßkeƒ2≠è™aÜÒÍ¿IRﬁ¢‘£»—_K@Ü˛˚*^^õxU¯yW‚4êÍ‰Eˆ˚	QwUà®s±∆|¸™ã®>Æ§(é@öz"[ü_√0„W…“¬DÂ∂Å§ô»“J$im§à$]_;|úAy‚ÖKuVô>wM†ˇ“(Øˆ†!ôΩíùIºz¯˛ä„BjS$|D‚‰3dÜa<2aÍ©‹∆ÍëRëÆ‰Hë§≥diá«‰ÈJ∆"qÉƒ∑ùPåêœT.cÔŸ@¶˝^◊Ø≠Ù}|ÌLt-è[«>(√0√¯±Û`!Ì@@—“]ï§|#IblÙ±˙<ìWä‚&M«Ñ	$ùì ∆Wei&rÉæ3EÜò)¢ç_œ†@ÕDﬁLö√0åﬂS‡kËAô©Ü§Rî aRDâ®?7¡ø)ÇXUa«hÇ¡g˙ÔπÌ@EÍ¿_4ëçœy"É˛Á<¡yæû£>fœZ•Ô…Ù}	˛+â◊øøã09¸‘0√’•†´iÑÖ3	E)ãE3˘a¬ƒÑ™‚LãvÅüü“TËg°È¸ÚÓÁôﬂ*ie5$LËE[…óV·E“\˛¸º¸Á‹!æû≥J?o'Çç%M›7+7Üaò ÈÒ!æ∆Fn’Úü•B‰H®DdÜM¡≥≤\`°º.‘ª cLúÆÔX¬	å˙˘ºF8Ê|Æô•Ä$PÜ÷¿¯?ì¡õ£‡úÔ‚cπŒ‰∆0√¯^¬Dä“$å€LíT$Ä"L®eZËV QÍ…s§"F°XÏ§NZ∏Ø™ƒ
Ô≠√Û›iö®m$ﬂê*´nD^6qæS„Î◊üÉÂ>$Kx^ÀÜ#(îWE±¿ˇq˝9ˆ2Üa_KíxÑïﬁ"I™Tñrïexë\(kß£˘p‹ éŸ>¯Ûí?a]°«√õúÛA$Æ„ã÷9ôÌÙ'´=x2¸õùæûâtØp]`ó›jÜüµq∫æá—wπaÜÒ’§©›oìËLbÖ©•$ï¿£t˝]éh⁄vDû.TÚI∞03a¬Œ.Ù˘ï=Mt^yNﬂ ≠˛ä◊¿Xœ!¢µëßu7*‚Ñ~$Ù¨!©S›ìT*õ˙√0å/[@/ÇêdÍN¥òÒbïÿä J+‰ÙtD÷z∫ä√W9-∫¢µêèÜwµÿÛ«◊ﬂy|±så*‚ Ã‹ÖE:ß% B¨*E›é5à~ÿ≈ÒﬂD…nÇÎéì·Q-‰8âøAôæ”√0åØRï:JR^¢ƒ^•å2)¬º–hãK†n]xˆzX»s3Äb¬ÑI•ÅÔç≈{Éé≠À≥üﬂÄOA
˙"Òô hQwcîèÖ$Îà0)≈™Bô5ì2…◊ˇ|,µZe2√0Ó&K\Ê°*5^πAñ™0X'kq·]® ùà4Ë»«‘—p›âÇ◊†|-Œ®r§gW%Ñ™‘ã“ü”ïîõ,¸FïLÛ•1ﬂØû›E{¶∏ƒã•ª+1ﬂÖGÌJ∂wÀÜaü%Lúÿuæ©èK√ßT!e{ íÛ!3RΩƒÔä$èIﬂH˛~†Ç¥î¶ˇ˝ﬁ/§ é‘UàiÏ)Pñ
)u9™Ç ÌÅ_âKo-“TE7^Dÿ·Q„πÇ6Üaw-¶úΩ√#*"U©–ÓæäEï•˛_$=ó÷…TCu∫à˜ê(J‡¨¬¥	”p˜Á∏YV+î‡j#u]Õ˙€ƒq€Çí'á2xÔû&&?â¶JeC&eËôsYŒ0√∏YuË…Ëãsø8µ9"LJQ¬Æ¶û‹äœOèô<9Ωx/˘$Qj©LO_ñ#É7üﬂ»w∂∑À§(oâCK[DKï≥ ≈ïb"ê‡˝%ÓibÜaú]D9sg£M2ÌËsF…yJ∫í8œ©c≤ÙEƒè‡ãò)wq¬E˙)&ëQ5@óœoKAŸ≠‹8˘åz«^®≥?Sïˇ
Ω<◊◊2æóÂ+"¢$|√0„ı‘%Œ›Y®ì-	Ö)•ô*öˇŒ#SÕgˇr0Bπ©‹P~k¶ÒYHÍ,DC¸  [d“ØçrGD«Ú»ìÑH"
‡V∞"∆˛•J›öˇS Ô<∂ùâía∆{•Õ√π]*§0—DyÂs…4ùæèàÕWø°^aX90yüQE*òÖ˚GWöht*àXnÂ\•=Ëh€Öi{ªÅ¿lB˘…Dl*•±+c˛ëÍaı˙€x√˝“ªªŒ0„ΩSGaÖ+çùàÜÊÊFjwUi¯iR!L‚W¬în KG$‡⁄·˜ Ç ƒkp.3ëô£ú™[…ìîÑ]Ó∞ï∆æQﬂNîˇ∞¥òŒÑX™Ê√0„=‘•é¬(W ;ãPñr#&Ä≥m∞ÓÚÔGçDaSæ√k£êΩ≥JFQÖπ∫êù3‰Èå—GôL§xÕî‹]ƒxìD™{∞î2®JˇîÊ¸d0√0x1≈∂ÚïÜÃÆAt@Àß¥¿Ï∑Nyïn˝≈‚ﬂ—8îΩüâ™G·_˙,Y⁄}qmRÆ¬º_bQO¯∫∂ÜUÇØ· Â»nGDû#&ä®¢É/” ﬂ-Ë∂€)ì+Ω‚ÿ√0„Îî•ë⁄ Á†Ω<ãÑÂÎk°Œ´0|ÚFeD¶f)DÑm‚{ªE]:˙wó›#r©zw¬ch≤»O⁄D∆Q´[ÌË±˘O@§Ω”ÒÁ¡˚úÇÒ*µ1‘π5^•Ä¬4∏‘fÜa¸áJ4\Ü[>•"‘•Ûﬂ∫3J—g…¿…€Qæ–*LÍıÑGÊà0]Ïº*¬4K¨¬lÅA˚9™"HØ©.ÚâÄ—Sg˛›&:ﬂÿ«§ì ‘⁄‡˜uà•aÜ…“?≥’–‹› S*Aj˜CÑ7ä– A‰H≠†zî•π£‘˙àÁé¡ıÖ§Q≈Dƒ®6íµ[%πÖ’"°&)ı«„tçòÃZxÖé»ÌƒË∆;˚IaÜa¬‘¡.~¢|•|"WâÀ”#®,¥(ê#5Äy8ì«eøÉ0m@∫¶<ø ”)ptkt¿’™⁄FÆBo◊N≥NÃÏNîR?îÁî:
ü˜ˇ‘Lji´£o£‰oó‰√0ﬁ\]Í)c©5#
+Ãè:J¢1à7â2‘-o˛<=ö9ò<^£8œU$jﬂ€˝vçç®‘…6Y! Û»{v·· Å ‘”Ëõ"T¶]tt*¬T®§wÌ∞stÄa∆ì•Î∂6Ã‹•Q∂…ÿ˜†d°£V˙+a‚Q.∑éÌPÑÈ—Jë0C€|´ì≠dE™LÖ2÷$∫ëúí&58˘@%†kN%é/‰kRÑ©R‹AπñZœ®bÜa∆k*K#,¢â:•J#.`ÉÃCvæò‘éÑØú$LµXπ<J¬≥P”&Í
Ãı®Â_⁄ÇRÀù·œ	 p ƒ:M<é:,©ÏzÅ“ V÷ ’˝ËX∏$gÜÒÜDâÀpÏÎhï‡pÄiz∂vkJ˜N+p/a⁄∏5˛ASOIÌIxñŒ™g*ªà«¶`ä˚ÇD©Eb[D7˙˜AûWG·ñÖﬁs4“e;H(ˇ_DÜüÜaÔ©,ÕD÷Q¬Øc	Æ{∞˜u¶Ì¸™np™ıvcIéì™"I§xs$ƒx{jêØ¥d#ìíî†$Ü}o ›R‰Íå‚_üï47  µabØè‘»`Üa¸‹b⁄—BöNxï
çó–[Ú(ÔÌÂ•É<†rêZΩù6[a$ä¶;âÓ∆(W©ä–∆Lüot]Lp-Mä}Ê˙PQ!bˆh’‡Û,ÊÕU"êSÍ˝1√x}≤Ñ-›≥PïJ∞ÛF»˙H]p˜,`ù∞–ç£º°´Ú€¶˜FhjƒADmÙ<NÑUöÇ„BZî˜‹ñgÈƒ˜ÆbTJ¶sÀ>Æ´r∫	5[]2√x≤4íŸ9¡bë•
!ñOYÇæoXE{y‰„©ç¸•˘7èxñfhÂ†ç˛ågg#œ*ë¶∏Wõ}´#Ó‡˚ÍÑS%πï¥ÎuŒ◊B˛Û^Mò√0ﬁÄ,·Ÿï∫·‘†RÎõèFú¸6a:ÎçÅíwäë•Vhe—ˇÙ1†Û‹ëáßÇø*5ÎïJR‹Vèî?fÚo§z_ZDÌœqP„{
¶DÂ…,¶b¬dÜÒ>di-Â9FäÂä+YÍΩùÍ∂‚è¡„ínààSÖÆ¨ÓßI•i3ìThˆ_+|≤ÇØm£§Ó´Èy∏G˙Ã˘m}-*€Ap%óπqÅ}YÖ“ﬁMò√0ﬁÄ,]†#l OK4ΩK0mt˝DIn$¬¥ùò◊äH_ŸAuc.∆‡\8&≈[@êTö≠∑sG‰oìÜ£∏Rû¢*fõË‹Ñzÿ˚âbÜÒ∫Ñ©æ%Uz„@¬»G›Yﬂì∏›q˘uiÇóØ\Po,/"YJDòJ0LWüë<&"P”£emùP;hh`?Vsk£‹˙PçÜa∆◊âRº◊†4QÖvxÜ‚V2˜ÁﬂO¡Xå[…ÃÈﬁ{'rñJPn›Ô°“ø√r’Úh≥è∆ß–f!âêMıûUó Ákç~≤Üaº&YBœá3™2E„r˜ä≥≤˛ºß˘é† (È˚:ól¸Ö˜2@4ƒB™Ÿ*<i –^‡œ
iÂ*K_°à˝a„o∞Ï∆ÉL^≠Mxf(aõ0ÜaºY†Ñí®º¢é,≤Ã˚∫<À{>Z¥…◊≤‹87Óà8˝®w	»ÏHÊDfoVL–øT©ÙÜƒiÅ!πá§˘÷ÔO^€a«˚ô®ÙZÈò‘ > ¶úÆÉw√0å◊QP&Ël[°<ë•—˝ıÁ<)Yº¥q ü⁄>È_⁄£≈ûÊ¬ÒLøxsäHÒÆ†¥a'‹Cqªà§¸Ü∫tD†àp<Tl∆´·íúa∆%ÏñöD(Â&íûˇ˙3–ßÚäÊ÷?«(SÍÔQñÍYÊ	BOD8Q◊cJJî±Ö RÜÎ†keÒXíGÚ6ë∫‘°—1aEC?=CŒ0„E»¿@^µ{ﬁƒÇπ>Jª¯£º=g¬([ùqWEß˚	“@Ò#Œ‘È∂#N*ç4¡9jÃΩi\…ë·®b◊(çÖåﬂUåyŸ>¶ı´; √0åﬂ[,zJvŒ¢hØ#.6è¶‹K.Çu”&“æèî•o2$_éµô…å\‡=18v%™à÷˙ÑÑ‡œ=&<^âÜÈÓ‘¿9Tx}8Œ∏kÜÒdi¶n8ÂÀÿ)6`Å2‹∑Œ˚Ib© † (RîOzöP©π*2›wΩ7z°Z¬πIïÃ…y∞¡¬˝sÖ¡√„≥í%5éﬂ ≤®6Ê…¶7—aÖ…0„»“JVk–F^°;Ë)rñæp!ùar=ì†5¯ª®ó†ÙÛ›Ñ	Gû$Xÿ—πâ\°îÌ–‹}◊‚G:œîh˝⁄@£o6 »Öî'Vb±≥Œ˛%√0å'&XbZÉáˇFJSÅÿÄ.'ÒJ§â—nAâmπ¡^1§ÚªîPJ1H∑íôôSª’L@$I+éºy6eÒ‡û†”≥'2åÑ7%ñïƒÏÓ8√0åÁ_&(≈eAêqZ∏◊R7¯„'<FWn¶ÄB.«ÂìÂ∏v/˜åe9RîŸƒHõ$¢"6Rq§Ê3M@ñ^Ö(± ‘¡π/‚æ»Ùıñ±ﬂÍía?∂√˜√ÊÎèÈ ø≠ŒÎnMÒ~R¬ó`<à"-¨gRØøP)ÅÒXõSÚ«Ö‚ˇî·û˝˛>Ø˛‰N∏ïT∑zbdå’%√0å'] pnX3∞îc°n∏À+t˝(dòIïuÈñ—(◊ë!?Aòz"J)à("&b£R#6Ã\é}ïÕa*p˛8á)äï∏ﬁ;6{Üa<·¢–QyfJ2Xzò∞õÎ’U?(eÕçÃ•hF˘'»¥√œ‘ˆ_iºßµÛÃ∏˛∂Òœ50ºÍ˘ qôí–’^ÂQª˜…O√0åÁY.4;,5)π§∞≤©˜S«i; K€IeÈÔ‚˘ù« ≠3µ˛gQj€à·è
~´J±Ø‹Ÿ¡µﬁÈﬁ;ïÈî¬X`‹ç’%√0å'[0∞Pï_ˆ¿Ø4Ò‚˛j]p‚k”	˜≠ “Ù›
ç=ôaaWÛ·î∫T≈®îÑÒØöÊNõäî„™Pïä»e‚k£X]2√x2"gòa—T%•çB˘wBΩÉ˘˛œ˚\Ç$Ô{qÌîÍè»⁄'~g4-œîÿæB6:Ô<Úd•ËÄ®oó<ÁúY5!⁄¿ÙΩäú2>ﬂˇÀ*Ûì»0„	 ¯| ∞ÜeÃñYà,uÔ“©ùq3Ö<Œçq1äTUÚgÆ;˚¬)π;‹TlDj‘
óÔ:÷è¥πot<gë«≈'úhÜÒm¸w<Ñü9â¯ì¿µµº4<7Õ
õè¶Õø‚5(M	ºG#âôÇ3Ñ(iﬂÓHã¸ àÚﬂÃ¥¯s	vÖ˜˜œ ›˜¨Ò8îéC•cñ∫„˛fm˘…n∆[π''°)[@î2(Krq«,,1&É}.ù Q|_ˇÍòºëÃç~õE¯qp^&Ç◊Qåƒ+õΩoô∑«DiQˆ/ÜÒZä÷´ämê•‹ Júµ3∂HÊ˙ÆÑô” -˜?ÓÔ°ÅDe√ïJàúªÑ™Sæu ÛÖGk¶å≤Bä›÷µ]Ô'ó„√x]ÚÙËÍÃÔFmÂπAò
ÖRNÔ…k¶ØÀO_∑§.e—≈ï©åƒ°ãÖÜ) Joêπ’√«Ë_¬®Ö$“—•Î1Ì}ﬂÜa<0ë≈c¶ÏÂµ`ØÕh¬Ù9≤˝√™ROÂD„;u<r8iÇÛ?c˘+Q>A~9ø*ã!ƒj5w∆ﬂ3ÜaO∞S&co•á<O•ˇ'`èÀ&LΩ¿˜Pƒ“Z¶º≠-Å≤B0ÂƒÁˇåﬁ¯>ˇ”JìI•Ã]‹…Ê{∆0„¡—	|+[0Õævƒ˘AˇTÁ’ê"∫ıxJ•◊ Y[ot;A{qÏ
tn˛•Î1u≤∑aÔ∑0=√Ô#∫µ≤ËËŸDÓNçrvLúûÜ£ßÜÛ°uA¢'SWﬂÀ˘ïZÔCƒtê_µ@0ÂBÜ˘‹â≥‚ºE√0åw⁄Åé6¯[âÚìàQ%£Pñˆ †≤@)f∞≤Ù4$	MﬁΩ» ê‚Œ™aZ(≈ª£kˇ%Gü0ÈÑè±3nï)ëü)
|›pÊ¢ØX√0^ñ—¢Ñ•≠±™ˇ©2V0ÎåG9Ã§*©DoÙ≥¨∑Üz!x≤t5y/¥®s))ìØâœ}uQ©-ów8¶¥9¬a≈X∂Foÿ&ÚóÆ;J¿0åó›e¢qˆ˙Á$võ,.ò¶<¡Á‹µ~'adi$eaoê¶‘•˛l7‘≥ÊVΩÿè&ÔDJQﬁõ"å I‰-Ò´{ÒcŸë¢6¿˝<—ú∏Be8•0]?}oÜÒ
‰…≈ı5¡wò∏É_aQ·cq5Œ‚8â·´«∞ãö~˜∆@U4ÄﬂlÚ}∑¿ 'K®.qÓõªw˙zIﬁów:ø¢t¢§ˆ$ ◊—ΩÑ√xmˆ6„qâë°éT£<ì I∏£ú‡aô®§°∆#$íÍ3MÜüøz6û…1–¬Ysw°Œ®˛ûﬂ¡DÈ◊Æ˜Y‚s_)hákíGﬂºÀÿìKp?q¿kì7ó≤˜ F =aÉØV√0fWH¶WTçê am"ıg!ïh•°£ôú"⁄±aJD∂“W=@e©ˇÛ˚ÓbÁÀπ0µ’˜ÍóÒÌÍRO√~3µº„Ã∏D◊hÜ` I%ìøzí7ﬂG˘Dd)5|Ä—˝µbËßa∆O™E^z›]˜∞#ú°å∂PZÒLDH“ÃÙµBd©ä≤V”ﬂ+<4˘µ|≈BDIƒ®†%Ò Áí•ë»[f”˘j˝≤‘ÅBä◊2óäò¨o‰q·>Íﬁ1F"x÷åéÂAüÂ`–.Á.]Ô-ó‰√¯÷≈`$24
&´GLJP)J9bØG•∑"îö(—w	⁄∏€ÔM¸=z;
ï°6≤aÆ%ôU∫{vÁæjM]©µ=Sd!≥˜B™	Œ	Ïπ˜F«Ú"éÌL*q%•ôáT◊@]2Y2„ÊÖUy#ÆJ—ﬁ¢ëÜÜÆ¢d∆]@\z»¢4V®\yçäxmBY⁄É<#˛≥Põˆßìì©ÆÉÏùBæï®+ÆÄ)up)ÓÈ¯ë|võP9˘òPUù(kÈüÎÈùŒØ(≈ı¬øîË˘°)–ﬂ4√fœqÜa$KB*å@&°≠¢D∂RÈÏà‡C≠)ãû†Y®e∏R¿ÜÓAÓJ)~¯ ¶*õ¡CûSùwë√‰nR3‚ZfÀ¸,	Ë?˝~•j^ΩÂ¿‹ùEf¶x/¢Æ{∑^ºˇûÜT'Qä+¡p›î(ø∆´ëûÉ”	ø–ò®qú¬LJ–L•1.ìµºCJ˝·Ø%—J)F∏üaa·ﬁÃÛXÆªÙDjÿ∑¸©\P*=ºï
Ü¯tÎ‚¯l]S#0.ü˘ôÅQX;Å¸ƒ˚·ΩõÓåƒ2Û?uax≥Á`«vÄ◊
®k†⁄≤∫Ñ•Oó‚„ET!|òc˝æßá∆¶GÂ	:Í(K'⁄Ò#à;“ä0T£Á®^§B;Ôç&∑Ø‘-4S`e§†ıÍ~∑≤!R«9PØF‘ù·¯õäÕOêÆØ&Ltﬂt‚„ë^¨®üyﬂ∞iôDô®
’Øu®€YK›+>˚B^/d	)KmJ€;mLÆœú¡ùqÜÒDÖ`lÇ
gƒ.ôôÇ⁄ÿ7§»◊¯Uô+ÚqÈ´ú¯w‹çñÈgTÒ˘jF
\éÒ÷≈ˆßU·®ÀØÃâ√c0<¬ı˙$˜UGÍﬂ;£ü¡™È
i›Ωø‰,Óùl.
ïƒ?D<[ÈËûq<;AD˘˘òÖbªë?ü?sû√$Ê?Ò,&°^\Ñ7®“©YˆÔÈÊüÛÙ⁄(çEØ#ct=¯Z¸BQÎæ˙ôôä.Ayp&ˇS≥[Âﬁ“‘O_G‰õEG?–+)KˇÑ>Ú{~Ä˚∂£ÜÑâ≤ªT\D¥ô¯á0›ô§ŒÒ‹ÏPÉÊÑ••øô@¡3ÂÚLÁË≥Dò:L9£mÜ!∆õ(y≥jΩÉw…Íía‘âRæF(Ô‡nt 	x"Ç3ã ≈Ö|4¯ûπd÷*ì"EhÚâÂ%°R%j∆ñ|4ìG$≤ã eœ§v$∫ÉvÚî	ˆa:›•ßJ4ØBúJ4®$Ò=ÖébÕ¡híÂ÷Œ)"»¶Y\¯‚‡‘âÇ]/~ÜH¸«Mò*«aT»NÁx|áô{Üqv·Bc hÌE6–BÛ»î“µÕg
>L"_( äÚá 	ﬂOiùñT…_îagõiqI∏„•‹%ÙO˝„%‚›·w/‰≠N±T90…º'¬TyP\*HgÎô4O—˜â{∫ﬁãÚóö≥∏¶K–ïñ©˘!Ù5ÆÅ1(çs≤w¶.ÆLÕ›;•ÜÍè[,]≤ôõÔ'ç4∫3Œx◊õ™'ø»tâÕ‘∂@˜‘"#ﬁ≠ŒB	Zå“≠Œ≤#ﬂPJ`ı†ÑVE∑7∑0¬cp¯`y˜,¨\vù‚‘–D!ÖóU¶ªœ≈Où√≥oX,˘~^ÑÇìN(§\¢Iç2› ﬁ95≥˛Ï©3s¡‹0™{˘ä∞'Æwdg`µÅ?∑ {-	r|ı/Y]2ﬁB=∫CZq±ü _*\q	î†L√/’0◊|¬¸\ìÁëZT£>8∞Î˙#Â+u"{©;lÈÿ9¬ŒŸ0+-‰[p.±$á^Ø·QÜﬂË∏#Öx°r∂öòõá*àK“÷Ò>^@Y£—¥—P~5•nU°Ï&P˘v)ÌÅ/¥l+m>ä~]HπMòåWﬁa†?4Hí"DÈ S(ùLêÆ√tÀ¥5‚[“ô®µ„k¬éè£Æ…–ó_ßl‰œ¬Oë)Doß|òExW~ù4}¶ÀI\á=Ω?U6¿ó“*U+ÂàΩ+Iî∑◊? oF∞¸‹	≤ÃSÕ°"5∞ËR‹ø R/¶ÅFj–DQEGÒ›#èûróbº‘Õ—âEæ;hØüÉ]ßöOñP=»™'w´ëíµÎ´Ó±v?¨ä±}$/VÔ‡µá"ˆ∏ÛÕ‰U‚Ø1aö»∑t7a˙
Ç|g9∞#uÆ«gıTü9‚@«÷=∫Q7{òr∞Ò»"@î◊1ö[¸GX∏WÒH.≈md2øºÛfFd–·Üy%ü◊«0ö…·∂…Cvçá#≈AönÏ»ëPÕ]hìqkz´≠>Ú3î¢£‰|5]º%+ì˜)I‚.ºù|ﬁË<YÍ)u∏àAøEî„ê8*¢‚ÃzÀﬂ´0˙;&m£ËL√˚y"o‡$|Å+ÂM‚æ)¬ø”–TeñﬂDôk#óÀq€…Œ≈ø^&q¨P,
-ﬁY®»X6g•Îfœ⁄ãﬁSΩò_91≈M¶∫f8†í=bΩük∆#,=ÌºÜ†#ç}FS√{Â≠'…Q>Pä"üAd3ô:'·õZ®ãÁ"‚PUs˝5”$¸J€¡Î˙ê_>õµsO^P„ÔgÃ©	<~çõ©‘e∆>°*JRõˆl"Ìº6H“&T\E™Í	Ç¥ì˘~d’áÛÖö'í¯ˇ6™õ)£	œˇìIÙ|O]®+n¶ç'ñ?ƒ®∞ Bd©3Y2~L]80]œd‘Tµ˝E¥ﬁGfÏïvaÈ â∫%≈oî,]Ö*ÑR/ó»∫ÉLßÀ;>‡Lò˛ñúê–◊`∑ÀD`√ÁÔX(o$RÿŸ«[\N¬˜´àK4‚&”˘î÷"i‘‡MØ-hº(Jlh˙†;nd0—˘ŒTÇ_Ä`f⁄xΩu&P†rˆ˘¬9G™c&‚>;®“¯Œ]3ñäÜ~¢|•Ï)G≠ñÑ2bπLyX…B5ΩTV~å£]0fa˜ñ"FªöY˜‚]S—û∆{I¡∆Éw"HUxáî Õ¯™Bë€≈˜WÒï`˛‡=ÿ`∂X/ èq¨™h“®¡1¿R<¡≠k‡…oƒGJN_Å§+Â1;ìîiﬂ0Œ>Ïª†’ú[6◊É—â⁄b[9Dπ—•r4Æ£úúc¶∫»fn◊ıï`|Ú>¬¨•ï›—¥téXU
∫*O|á⁄Ñe†?˜H•°øU(6U◊7a`WDq*P4&d;©<Ìç∆∑†ÇW´otÓ·XU·â‚P M®Ÿ∏â≥üÊ£ 9–fdÑÁ¯uÌŸØ˙ƒê,ç>÷∆ôá˙ T°h\˚Öé‘†£	˜9≈ëOê£‹v‰ÓñïÃ∂ÿû€}eâ√0ÄÃ‰£ÿ»†ºû•Ç°†≠“ƒ7ë§•Çˇê<§ pf·)ÂI}m]´QF?ˆ¿´rÜE•9,ãˆ§¨"Ë˙ºÃ¢$X„áÿO3CÁ›Â›Ô%±^¡∞ÒÅﬁÉàòdÔíÿó „ÑÛâŒ(EÈ‰ê tbûŸQıQ8cR7∑‰3yõx«Ï+ƒ¯!≤§îòêçç;‚ƒ¢ÒiUIî‚:hƒPßj∑ûI)Q%≈Mt§©‡@&h|éû˚>§≠Òı£R]!Ú“C3GRVÉtKP2¨¬ ˛ˆyKÅgi†ƒÙô™E˚4$
ıöFÁN$	≥èh< =Î¡ﬂ• Å“S^∑v≠¬ßT)ÿm¢L¢ﬁ5i„ó»íJtnudaztﬂ"˜_•:–B4”Ê(ãéæ"⁄·YAâÃ⁄ï6Uï wõ K†˛lÇtÒÇ® q[–◊Rûû9©hN\&ou¨∏¸Ü›wùï•<aÂÀbÆg2Ãv1Ú#gF?π^˜"ÍD¢)ñ‘‘L¥ıd€}nÃ∂∫ïEù*¯˘zr‰˛Ãqm‘3æÎA}Á˜¥pf·’i]Á3n~æ˘=‚XïÜü…ÃΩ“ƒÂˆ‰®ëE†k√,ûÉüçôMkêüÑ1EˆZH<4öºúe∆çt‹ñ SY2ö¸ùπ$Ø—.HÛÊ„\%ﬂkœu˝∞∫ÙÇ — H—$2~‘l¥ñØË» ›"AY¯	é>ÙR∑2…Òò⁄ÍÙ’Á›!^ûÒﬁªÁ}R;ynt¡m∞(c≤˚G~ıq§Á JŸ5—nΩû¯˚
ﬁ¡Dƒq;(MF•ıÖFÑ‡Ïî⁄5	ü7g:Ê*˘ñFAñ∞óƒ{]©…$ådY®Ù◊y˝˚ßáπK#\∑™‹ôDi◊æ≥çÁYL∫ ≥h¢á¬“•F©¨ıyãïF€o$eUb€Ñ¨øÚ‰mxÄõÌ?·µ}˛jÑ)(ëa©f•jÂùaÍµÀß„5æúxRii	|7 ≤Â9’∞±?S˝[Ï^ZiQúDW.†Ëπ‚êYÙ\Md»ﬁNFÙ4˙d¬ºû?ß ç*cä≈g¯⁄‰Ò'”@8ú2%€"˛ï∞˛Ô:¯éMàÒu§àÛ$|F3±S`¨N˛°£“X	JeG≥òé¸EÖ‘£ÖÇ¡ıbó≤ûı=5rä‰\iÅ‹ÉÅJmÕ›≠dÌìÑÈ∫ !i+ıÖï‰ï6N‹2ø–≥´R*˛¬°Åú∏àgÊÖB"")Ix´»4:Ró
®=|˙î:2ÅØ0TC.7Ù™,;µ^˘^∫ë(ubΩú©˙PIùUMXŒMpû¨,˝ÙÓY#ˆMbî«,vu‹öøäº¢r0 ∂û:y÷Ñ}‘’V»§àä—J>3¯"AœÆ)u(x`_NõéÊû·ªQÑ©íü∞Á∞Ô8∂B1Äƒ,Ç‰)Â%âgˇå,ûmZÙQíÅÍ—≥v]OYÄø«tB]¬íû".òMùqÖR‹ï©ùsÊZ¯0+ÚÕU•û¸aJX»Dí˜É¯Ÿ√»øê—√äÛH™ô+ìµ˛ï–¢RZn‰’ì$©6ïQ¯[+¯ë'ygxo=TMêûC†^∑l ~ÍwΩÖQ∑.∫=âÓÔy*›?ô‚™’9AÈ©ªgÉqvqœ2lçO‰Ô©çÚ·xπªn%
üè∆âÃÆªàEu$-5:Ûÿüa%ei†ƒˇ≤€F(´Â`Ó]°Œ¨I<Wﬂ~∞Æß≈Û5πô)©ÍÛÜ˙¡„OÓ€)w‚$aK:™UÄ„Jª5_iÜ√∂ZÛoÌBSdÎâ—˘Ä≠§àaâ√]F˚’çç xë∞H¬ﬂ–∞¯ù>@∏&—Q∂â—XÓI†8|⁄∑ra©¨1ÇÍ≤6¬7"{U|mÂπô6òrwñ,¡˚ò)Cgœ¥,öH“A˙w!„ıÖ<TÑ‚ÔÅcoJ%0≥ÂFﬁ®ºÒsà«lı"3p&rø>;&©+vî˚…ˇüùezPp+˙îÃÓÈ0Àç∆“HØ>€ëñ≈Æ.ã]ÕÀ"ªàsã˙[wÄÜ	”™Aó∆g†Æ‹‰Ã‚ﬁ]·ÅâùU< ˙B&ﬁÀ¯)à«ÿI√+ï‚æ˝>É„∂êgàU•z …•˛Lj“JÔKçX:ú}áaªtÃG1[M	XEY0ΩgÍÄÎ`›ËØˆ“hrŸƒì®'&gÔæ	•¨%∂±∞ùenxÏ*ÕbƒcÌl>8ÿ£àMè|D+µ“F•≥h∞ÎWΩÿ#¥ü3‚¡B5z5âô¿|·ﬂRZªÂÁâÆßëTÕÅ:Eì»S9cÏ•aee=„°9Qä+BqQ];;=Ã◊ñ∫Ù≈s‚:"y3æ˝û¨0q~⁄*¬bˇ~7∞º°m®˛j®mdb†Û\(∞I”L◊¡*…UW‹(”ıkÀâJé™p%IéDx˚˘ïp¨qx;Wt&
É]É“q!ø‹LQ^Ûh'0àÈ≈∏ÛL"∂“üëè(7º=≠ÙÍ‹E∆ÓLﬁÄï‰Eº˘˛	o;K m[5≤"ÙìR˚H˛Ñ^ê#&EYÃ+Ãb£ëÑ ©ºIî–Æˇ˜a©9HÚÆÜΩ3ïdÜüT@•¡Ú˙BíòmWaS6í	w$œIV-¡YéHÍà‡a’`°ç¢J
/b#úÇxáÚí&Q
¬<W˘µr@,—C≥ÄÒxDÛ∏ügØ^ﬂV*ßV—mπâ{Øê—ˇ¬6Ô~†'íh#øP3»Œ8*"tÙwYtçé7]'Ë8®ë;–LòE}
<E=©æ´h^i·KÙ@,¡Xé](
*P5*oëœí»ªr9(mMA'‹ﬁt‹HïXa˙ÆiPS$6C{|VJˇ¨Øæ÷Dú√ |£ú·îÑ2Q∫˛00t@Çí•34$aÓV	‚¨&f∏ˆ'´rÁ‹@*n
îB~F†2æeî <àŸ≥p∂?7ZÁœ¨K`∫V;‹UîVÚOçÙB„õ€çá%m9ö@Rè|<ßà5ﬁ†6 ÷*¥NÂ≤l°)òe!dñ>Ø±ÖiÉE∫ku%~ÈZû(ç∞CˇUØ¸N +∂ë±˝™ÀÅo)âEi…‰
 "O∫œA'≤Í⁄KˇzV‹ø&Ôë"Æ˜b4RK›gïå¯Û€é@ÅåÏèJi∑¥·∑˛Æàâ«IÏû* P}ÔŒﬁ0~Ú¡F
À(¶⁄´Üà*ùK–’TDgYT⁄⁄ìË[≠∆U|}#ïk:Ú:RÀ(1{{±±u«=¬}œ›á?©dä„¡—UÌØÑ	Û}·©‚Ê\QH‘%XàÄ´ª˘ΩKAπu†„è	ﬁ3$°'1dô;±7‡òô∑{`√Å^HE™ü$B€âGLéx‡q¿V◊2qöO†Òı<äàâÖíöÛ¡`’*FnlÅ·∂˝6lAà´Q2©˚ìRù”¡\5ﬁı‚É}TùGz÷>@ÅØ=ï^Él∏E™4ÔU$zÛ˘û…wƒ&oÂcÂÚP&?ŒéœQ∫ÁQ`ì0 9⁄8m‚8woÎY∆∞Ex¢øœÅYîM·≥hëΩàYO›n_ëÒ\˜SîC6ìB∫ä+SßR∫A⁄¸>∑~Ôv@íxá „?6R&∆¿óÖ≥¨J@Ú∂Ä¢á©;πBˇÔ;™8õOÖ˚ViÄ◊Îv@™W*ﬂ¸¸˛Û;‡h'5H8s„ÿÚw¬;nò˘Z2:Qõ∫øíòIàYKxœ-Í~«á<>‘'—NZ…ˇ)EÿÌÅÌ¡}îE$öoéi_ıêÇT/&Æœ$Ésw®©S¥8’ï†≠ö•r†Úl"ÀLë:T–zÒÏhúÉYÙﬁ,Í›Y?PkÕœÓÎhN\M6ô¢`2˜ñü¨P ˙î`"V¨;EÃ´´î8é◊‹ÇAïÔX!¢Á– b~f1#.â®Ü*|b¯ºöﬁ÷ˇKÑ§£ÜÖnúâjÀ3µáv¡NÜªE.AWâ…ëÒ„eë`°ÏY˘§çz/z2A.¥¿–‘‹Hàﬂn Bıé“Ÿ-Â5V◊"K9bôÏCõ;ÀY¸,ûá3Ã61”l∫7ˆ’	ìòß≤Í∂`2AIﬁÍzúD$À¸.#MzòÊ∆1iJ"®txÖ)&j·6w'—ªë=¶àƒÀ[-8∂ ÿ1cl=G\oaô¥ÛÓŒ≤„ì;hŒòhF·@Û˘≈ceò$J_Œ"∑®4ÜƒÓ'M’g¸D[√O¥S	˛Ã∞≈ÖJÖÿ©ë®NO¥ ‚É≥¨2ï_r` èçYxó¸å—œcåâ©DPv"G•Ô¿◊&?c7`¸X*J	ëÇÓiT>VPó÷w
N§0Z&¬u“.T1 4êC)9?-ìZ’ø„çsËR≤∂èrÀnﬁ0æB•ñ˚ûr^‘kamãx®,î0]ƒ{ÌıúFΩ¨º◊\ΩÈªH 2ï”Tá"vk†,œ"·{'u,qŸŒÀ¨B+·|Œ"ÿ∂k¿	“´xÏnUóﬁ@âË)?i%Cwÿ⁄(áF#3ÿ/3©uîêÖ‘êL}P∂nmOÔ‰´ö!»KÃ.Zâ+Â6S®ÛJÈÏ^”ø£‘a'I–Eê¢àMdf\©„É)Hz?Í›ùûg[Ï?£mçdÎ"ÛqÜ÷L©«)c(±„v¶2…,¸q¡Õ‰ë¿9r ç]2ó„Ωø÷1J‡[‚¡oﬂ,BŸzâà¥öìâÛÎ∂ìÍf¬2¿54®ÿàØY…ﬂïßw2Û¸∏Õ˛oxn∫øìËÜ√¶åÖRº9:`£k¡#fìœü˙›˜x⁄˝(:iF1
À;+ï≤»aIAßßö=∂†GÂØ#¢s/∏$ïDπK3= 9¥u¢yd”∆FU®£R…D„FjﬂÓPu:⁄´4Ú£RÊ≤∞€Ì7•}ÉJ¬(Æ£B«òUà[BCÒ~ù∞¡G®äçæ¡søóBe"û,!ÀqØÆÊYè´à»A0ÌN±Eò˜G%√§ÏˇÍﬁÕpø]ıÑè{—“ uu$B¨-TüÈÜœbdÉ⁄çÓçá¡Qõ˝v'ŸŸÓ¸OØW‰h/ÃƒrF¢ÓªïZàì-î˙;Sáw∏‚º®ÿ≠≈©•,…Z©Û)"ÆU§äg.∏y‰CÆﬁD˜è
 fB\O*KxàZÌí‹gj$ö˜áobèáÖ*g˜fœÌ€ŒdNpúvPù£¨4Ù9e8O„ª›4ñ—`ó◊ZH~avŸ ä *ÉP–ú9P¢zO	≤¨då¢¥√©’%ÆAÄ"?—.d¸®Aı=DG
SF ïî.õ%
˝ÈœI<é¥`°åæRÊ.j3EÄ\ƒÖâ˛Æ;{›F·≤löv=ê;Rw:∑ÛAi˜Ùåæ]TyÑN˜S"ÚùOﬁïÅxVDõ∞éJH¨/"#h€?|MÇÏΩãŸõè!™æ‹G\:W¶ÔâÏê;¬⁄–ø√AΩ‹*è?_Æäv∆‚Ô:ê∑˚Ω1ı=Z0»;Q/ßLœ¬≠T†U¯	˙˙BJQ	M£‰j67◊ÉÚ◊Ø——øﬂn FÌﬁg .Ar4ëZ4ÌˇŒ>úhÅ[w=0s$ﬂP/>∆ü9ëR’9ÍÈ:Aµ©ªól¥òÀU¢t=»û*{<+Æª5∏ÚÖï„IÑûr˛™iˇ8:ßeÚÓ»tﬂú—	Áf¶2“≤Îë?ä4≠T>\~rºÃ`‹Ñ&Rògä◊»pÃ6—í≈5±‚tç∑\òç«=/"£™£—&z°ù?ﬁ@ËRfÈÖÇËí0	Fñ9SàMπYÏR≤(∞˜†2¥¥≈oû°≥e≤œ™Hºÿ†äìâ¥‰”öëÈÈﬂL¡˜pÎ˛ ïâ‘¿>àO∏4 ˝w>;Äÿå"Ÿ<endnÁM≈%
Ω}≥rÕD]g;(	%0Q=sÌ L®zv≠ÎŒ«dáÉ\∑@qÃ‘Ÿó@IΩº¡9Ì»Œ∞íZΩäg¯Ñ»≤˜,Sá‘*´∆èìTÍ‚aá÷√¬◊QÕ_)<ì”y˘A√5K£VÇé¨®ÂWô∞kP;è¶ﬁﬂ”yvFE⁄O¥¸ó‡Ô
)iãPÖÚ˛Ô@ÀïJ[ã0πè˚«yZLñ&í‡ÒÁı‘)√¶˙ã ‚Õí⁄w/>‘«”x—éæK†.]é¬'_º◊ì…˜_«3ëï3di%Öz$Ú⁄®Í¯CDïê∏≈=ä¡xYRåõò‡˘ø–fµ±≈y2ãËÏn¥Ëb|˚. G¿pyw˘\˛ö)+h	vY(89h…f2îÑ!Ôz‚wTSi¥ÊÔª¬|OF—v¢3m;VlKûÈœÂ3Vœï‘a\—Kˇf$’	ÚD›h3<¸«@È:√|N÷?=†˙óı°ò9HíÊybTÖ0kÈ≠B}F"∫“s`%œÀQ≥ñóÒŸ≈ÑÈ“R%†óhc≈j??≤Ë§LÔ‡]¢“9W8ËuÈ¯Y§‚':ô≤πzì%„´K
Lê&RfazûÈ∆/Ç¸§†ÙUÇ¸î“»*¢t¶û∑†Vìu°nØ"~v›?Õ<öèvKwéR0òœE*Oè-œ¬‰Œ]}ú>QPb/å”<7ΩgÂLıÿç“(/Ö3ü•ùq\
^Eg£Íö+ú	¯ˇﬁ&¿ﬁ3ffqzs"‚1aâ&|ÆÙ¥	Ò⁄?˘Ïƒê∫¯À√õ76õ®CÚÚ¬kLœ±B˛%E8yÑ?W±áœÊÂ®√—0‰Æ¨ûvı‹5∂
o–*ÍÏ†ò•ÆºÎ°ò≠W$Hï‘¯Ô∑FÈ,ös)D≠ü±ù©Ú=(„≠˚ø3éíH|˛@.»÷ë˙ßºeÉP;j√WÅâ≤ç÷§ıøQ˚Â˚¨£&Á®r‹Fƒ|‹É·∫G_€_l6WTC±ÙRÔ÷&ΩÎ¶a·¶Ä˝‹à,Ù·p˙4Á0ÍÇ„ÆØKG/Z©ËH}^‡\\∏tW⁄P÷ÉÊõ—L¿8ÀÊq1Â†ƒ9´ëû|¬§ lE®<≠WDH›µ·;⁄Óx’ì_€πX’\È¡»ù^©>„—Hå@ºú=º•ßSãlú˛™≤ÿ≥/Ù¥`&∫.ÛAêh›?◊Ìˆ7öwp=˚øÛ¯VRu9üC*k@ñÚWvP~ÎÒÔn(Æ"&†œ∞L∂®‹˜ØÊ≥	6^h€(¢,©í⁄—Ø∆êJﬁ'Ù-πg4o‡ûL∏3ïÕñ†ı5æ"Â)RÂ≥|†Âì©Óz@Âôø+çÔŸÇüìhg≥ârX•[˘¢∏v>S b∑úaÿ)5’"ºd£ËJ‰¨©0‘”∆»õ…íjúerßÓÆ+—¢s˚™dÛ†áÒJX¨.©gX´+n¶Ú[OjÈu≥2‹∞)≈8çE¯'3ï„)…+ïÿ_M1T—/úﬂ»r±	¬§ ¨W"5Ç¬8ô,g/Œqˇ8/km¯âÚA+tÎÎëZTïËåítñDïüGÏô
Q.Aé«,¸;˘|∫ÔÆóãú+&D#ë•ãày∏ºzôÏ‹ñ¬±%ÿ
eò9POï‰^hìw°gÿDe*—[uûE•∏,Tz"æ˝˜·eC>ˇhZVŸ\ô∫S_¶;.N."/â‹∫,<¢ÖÆﬁ®NîùÂgõqZ]Z˛£$ZÙ”i*'àIÎÎ•°E*Q>¯˘gÆL	ºI‹¥t9rÍw˘ré [¢L√D®ØÀA¿¢&_GòF2%∑b .&¶+2¨ŒŸ´JÉP!r£ãµ’Aª°†ºëòÖñôÅxˇ±áÀoYtı‚3ü9ﬂæ·˙°˚Ç+<A_Ç4Ùç3~Œ’í∑IG7æñŸO˚«¡Ö*Â∫Eîn1hüU|™¯¯L)/˙˝IÛ*œc¶ÓÆ±·„π¸÷¢qPÓ®å ˝FN¬ˇq≤‘CY≠6"£˜,”[ï·»?7–¬πârw~ z†,Õ¬«7pä˙ÍR>+Eñj@¯ï¢—+Ov.˘¯Œ¬+ªd75≤Ì0: 	Sœ˛——∆Õã.tÏpƒ¸åiïÂÓÒ+uΩï†∆ØR≥W·Yƒ˚ö©-x†éóÀO/™‰∞ãÅøB9Rc1Tê„Mªaﬂ%_Nñ⁄!s€x4∞–»ô.Rñ^ı<6bLföª∂—3¢ä“y+Á¨àπÇóØ˛uqå YîıÖ[‚≥¯)KÂ¡y≈£Bâ ^RÏç¸_ºl⁄%¸Ñ2Ó!LóÉ4fì\O*M-Â)üx©üøà›«,FaD%®€po›ù˝@4Áu Ôåè·èª(ºÒùfä=Äz€—b]ﬁÑöö(Ÿx›+&·¡Î(ña&í4}ü¡*î§Óﬂ√Løìäçÿ…ê~Ìﬁ¬ ŸÒKØ¡Ûä˝J\~KTB„¯e€H"ì◊µ∑HΩ7~FÍûa—ûËÇûÉyl©Òy§Lqã/ŒÖ1y$"—Spú"	ß‘¢ØæinPr∫`<Œ∆SfÏK`“ÛX˜UO°Æ+-Ë≠‡“D˜‹¬DøU"~∂q(Aÿ%hZ©≈ºπXELC=PçAØÉòÕw˘¢Î ªè∑ j£9hõàÈ1¡˛$iÏi¸—ƒ=®j¡,BIπ$∑Sö˚ı„˘cåÿ¿é“˜"r@‘¨ØQ$·Dp8QZö)EÈ©ßáŸ†:Ü~˚¢“óÉWOâ◊=ëƒ®Ïv	îB?hÒ'pFﬁ⁄XÃÕ∑ö¢Ó∏#ıd*ƒE®s:é´(¡d1ƒ∂ûòΩòhìÿ}√jyB{É,oBë«˜6<”Ω–»UBS˜Lû%ºO
ÍÂn“"FP⁄∞è¿kﬂ±ÿwD~X—È1√"@¸gûﬂLBÂR%ßKPí˙Ò]÷Q7ôhÀÔJgL ªwqÒ¢˜PﬁâJﬁä-ò5»Å•â¸KrSçJyRS∞z†ÍP)s)—0’rbHu°2˛∑®¥§2ŒçŒ»]tt°??K¿¢X1!bÂ≥,;ì0yÛò´]L]¿2Ê≈ÍíÒõ7¡EA˝‰.‰r@.j8(ì1‚`»˛L	—7¯”o8z1Ü#Q€3õU3¶ô”Ω#¬›≥O§DÙ¡˝3ãaŸIt™3{0z(ÒΩ¯˜=À¶¿ÙèﬂÀ
ã˛Ù,≥ŒÇF¥]DÕC+}úÇ`◊$îƒ*“◊≥IÏÜÒS7Gw«ÙÅ`jÕß“ÌøßvÏLå@Y∫‹¯≤˜Ëµ6ùÿY„‹+lÜÿƒê›L%äIÖUF◊Ëo¬T˚>˙1FdÜ˘|¬‰]P©˘Œ„I‰ËaRªjÿÔ@¶ˇ2ﬂ~˚úµ÷—≠;—à≠$≤∆≤àµIDövJÒN§(e √„´'6ﬁoÁ}i;/™≠æıP;öõvÁç⁄/rÔ˜ñ˜c<iÍ`°¿Er%¬ƒÜ_Ï˛ú`¡º<ª±˚‡˛ÍƒÊc†n)T"6ö≈∑5ìë˘ßTRÕyXvkvÅè%«·∑¶Ëπ,ŒeOIÈ<jã„äáI"Ä=~*~Ég√9>¿x~¬$æ÷*m]ŒÏÆo]0Œ|œ#ô…çßZ¸{Jã«1Qpb•$‚‘¶CÂı	Ûx∫†…£Õ&ÖTï√≥(KáR˛ƒ3‡BÜ‰“(‚{¬Œ±˛7ªΩ¢í¡ wlÚôEdÁÎ-bdP	éS]Ö8ú⁄e8„)è∞‰÷]<4Ø©=—«&;∆7 éËH§xlÅ¬ã„ã@∂+.jH∏wSÒCÑIM®OîCïIA ‘û∆‰Ω*œ“7æ«éæRÀ8Ó QÜ–BD‰€I”-C∑≈Êá+‚À/GUH)‹®t∑Aá#~ˇBÑÿœz„©HR≥l’0J?ú¡€0"ıÄE«ÅfÓà0md¯∆iÍ}ãùâóxƒ{®0ìÒΩI•`ßÉê·ïôÔ‘ı≈ƒπR«_¶ÙÒÒ÷Ææ/ ìä“ÖZgäúY»∑îicÄÊÏÖº~úﬁ^®n°QWûg<IjÌxènb$„âÔNïü©«~,/ZLêpu¡"uSÑ¿oﬂWBÖ‡„ïDè*Ÿ¥ªê–¬cÇ~È9àÑw•0·ÂIπÏœlF[üü}Ó≈XP˘m§AÂãËlÃ"à≤Ri°2l∫Á2√€≥d¸¸Õ|=Lö>sS∆ãﬂ7-j+-Íj1ﬂ)j √˘aî√aj-Çø‰*~ﬂ^¯ïí£T ¶‚aµ[#úr_Xˇä5ΩÔAƒId·c√cp=.¸ºAeµù%Hë‚eâ’¬?' KDz9…;”˝QÇ®t]AQú‚m¸ä:ƒ2oT.Û4å˜”ıﬁ¡2D	∫·6RÖ/bí˛Âdƒ≈MjÓ/=g∫†Ì|=9Oío≤î°[Í◊„;®‰ƒÔCïf3êéÓL◊ÔgŒÀçﬂ;RÆ“D¶ÌUt7&ä	("_iæ∂ì2˜7ó
‘]ØK∆è¶¶π⁄GŒ0öÑ©ß15(√Ò–◊LÉFØªˆQ(wó¡˘9”ã·ß#ç3A5bnf∞*√çQHÏOΩ˜Ädp¨@ø{°n…éâ˘Y¬tfÓ\Î9ƒÃ¬£¥“¯,ØVÍl‰è9b¢–”’_Kp^õåoªye˜iœºŸÙmçâÙ*®wÂtF-dÇ⁄
xs#Uàa'6ó∆±\ƒà¢U»≈uÇ•«‘P«VÎ1ûQò>≥ê≠éÜÉO@ÍG1gt
*ôÚ6URdë@.¬Y•^∑åØ%DÜa|œB(ºKXñÿD≈	$˙ﬁ	˝≥ÑÈ…R«â¯§∏Ãd‚ŒBE*¬À¬b7‹L¡;Ó4¸•ÎdÄNπË=pj5æóÓVøËgß$P Âdà√UgAñ"∫5(©VÍ e¬¥Ç™ıc9Z∆ã>∏]23å_Ω{XW»ReU>™‰˚¿.£VÍ˝√EpDÑ`ä˜HÑhY=Öf√’‡¯a”L#UU∆˙©¸"0∑O†∆l;ëËëﬁG◊öí®CßBz˘ÿ–∏ﬁ«ƒh¢nµ◊tπJú–]≈=≤Q™\Ω…ía∆s&Ã«Y≈ú∏ΩAû*µ[„¸∏Aµ~VM¯™cAÑ·è	)YÑŒTä„n©"⁄Ô±l3Q	Æ?öU
}…fMDò∂ –I‡,Jäßâr+≥´Aæ{Ô3R4¬9õAMöâ(e"MxNS@ yD–¸◊∑aÜÒuä
Á úfŒ†GcfÂÊb˘€*S†.±gi†2‹J,œÌAŸNe$Káƒ‚+ÉòÂôÅ¯é¬ÏΩiﬁ)h™’Â´J≈Ô›√Ô<ë2∂P	.QD¿J]rYﬁÇÒ/|^gPìÜÔV√0åoTRh—E∞‚÷(π∞è©5Ç≤K√‘Ìøò3$Dá•öVüË=„∞$åø*[ÈRq4ƒ˚´Œı'èœ(∆ºl§™0ëòh(Òßﬂõ(›°ö4aiÏm°≤\iÃ˜cMu≈e \Wøí√(√0^D]¬r\"Â‡hÏ&ÊaMa
º_ÈêkÃÉS∆ÔD]nô¸K<ˆdoÊ—˜UÈXçBÂ˘ïÙsAJF*W)µë€ÔŸ√t◊l¿F«b—≥H_(o	ïßï^LÇãP—ò≥~Åˇ∑ácgu…0„ô&XÄjüﬁÜ¡Ó‰ÂHT÷òÉ≈Ì“ñ=5¸Æ–√Ü¬”Se•ì†#¢â$ìáÙN∞Ëˇ”˜›‰Ëƒ1Î É©4¬6ïë}HihË:9{A&ô°ˇJE†·;âB•åØÛ†ﬁ¿ø7≥±€ﬁ%√0å◊QôÜÉôq{‡«·ŸaâFb‚8D%ß#W√£ ˝.#®nUê•*∆`Ï«oßrﬁH «¿AÜè≤ÿ˛˘=pÆZkîK%ÚÕD¶ßW'Ç-Uyt$èRODh¶î˘9àXDí•"<zQ”GAL{ö$Üaº aR”Ákê-î-¿ﬁïÆAñ.?Èc:Pï:Ë„A≥™Ï§‘•V™p{πÓUÕ~HaZ≈ºΩ5Q·=èÿ86T/Ü£éâ“$:3'"1+ïS´Ë~ã¢‘òìJç3√À£ù?√0„k»√yÎâ≤‹ô“ù{¸x@öæ•Ñ¡òPñò0©Q'úª£
˜Ä@]èÕÑˇﬂôﬂÛÅÆ5çf¶±˘KY´PÖXu®l€ãHÇ> ]¸9è9Q¡ì•°ÌˇY¶πâ8l⁄˘JÜa/Jò:1ïΩ6ïñü)Aó˚M.j"{P˚t∞_d.$âvÅ-†6p9n‰Rôü1i~ÊQ@ò–∑∂QôëØV‡PÖÈÖihd6±˙4Pin§¿‘+abU©^Ωh¸è8¡°¬¯≤±€0„≈’•û:Ürc˝ëô9ˇí4˘≤™Bø”óÃLS?CåÇÈA(§F‚øâ≥G˛Ãkzv¬4¬ı±BÑj„BeÀù‚z09äwæı§4a(ÂL^´"⁄ˇkPnŒçkªêWÀ}˝nc∑a∆k$A(p i£ˆ`Qå rÜÔrô•„≤ˇnJ]¯Yä_Ï@[≈UT#2®)U°-.‹h(Ò¸ÃF`≠ûx^°2dπT:({aÏôÍ%j††…ïºJ\B-BE⁄ÇÆP&«ï»“|6˙¡0√xu	ª¡éÊ«ïÊ
µÃ˜îø”QŸÂüú¯Ω¢$ÍK#¥0R,F·{°•ø
©! ç∫¨P,‡ıπvLù2≤?Ú¢K◊dÏ]¯ò∏ªl•6˝çJîLêUyéˇƒQ'ËùS∆˚xŒÍ¡åDÓûõÅ Olÿ7√0ﬁÉ0î‡ºﬂ©0ÌdÚÌ)è¶güJ†d\°í]P¢h±E≈ÛﬁX!·E4ãÙÓ*»¡^üëΩ[/pÕÙ‰w€DÄ%õ£g!ë…‘=◊
S/Ã‚3®Jâr¿ä0xo¢WÉsàôJ®\ı4áŒ%8√0å7"M∏£_∫‚ÍÛÂ6(À]H=`%°
{°4bFÿ rûTÊ”’´U©ƒRÉÓ∑"¶‘≥˙ƒ&Áô»Z«Cá_ÄdO@6è6ö”6ãcâ≥‹F30QYhM°ü©G[`ﬁÖ'çÕ›+ú”˛ôΩhÜa∆}ã*6ScPÏôí‹&¸LyÜF`ã#+xaÏ)¨∞≠Ë]¿$m&5≈MtV—E•¶J√s±‡w/v›tb(m´øà≤g!S=ñ’∏˚lÖØ'"kô~ûäzÿNê{LrOÙ;aJ¯≈~%√0å˜Tó∏¥µP;¯Ω‡s˘_2˘[0”fTÂ¨!RyN=î+˘ê8[i•p ≠a|ﬂÈÁ]?˛0ÓÖâˆ5rsÛ"\ ﬁt™ôt)»∆™§v’¿»Ω…ı3Äeæ	Ê"~YÁ¶aÜÒº
”ÖJ◊C≈‘¬,Ÿ3íÄ0≠‰oôD†aOÛÁ∫(ùﬁOOóÖ“∫ïw•b∏ëôΩà1)Y¥√_^¯∫È†4∂Ñ=™r.vÓ3Èò– 	Ø"§Jn™õï§Lùvck÷ùaÜÒû§i ’Ä≥òˆ∆¢”2Ño!	œJüs†aG£1.§íç‰≠I""@˘îTD¿.å›E,¨<lı-∏^ÆÁÔ®≥rfÏùIìG¬Z“≈è∆¥p¬wT,ÎcídÜa|0YèP∆™w¯óÍâE+Sπn¶Å™#ê¢Ê†V¯|ÅüµêG©¡QŸ:¨xp…máôa+u‚°∑Í-XPÚòAòå÷g<oªH›3U¢¯ë‚âŸPïf -DÈúaÜ!IN|è≤uˆ§©ıÔŸ\çÅé+(Ó¶ÎEÈNç¡@U®›TõëQi‘öãëîD2ˇö–_XQbí:BŸÍà∞l¡ı¥ƒlA∫∫*Ìï™UÅrsAîF¯…`Üa QB?N|/'À,≠≤ãÚ=±•¿4˚LmÊ=îŸH‰N@í‘º§tÔç≤Œ&Ê˛èb8ˆ‡Ú¬◊Ä.d‘()Ω6O£˘{GfÏJe¥,~+PâÆ≥
ç+¸˝*2≥FiÜa»±rÇ^†˝ Y"µQ;yrNÂîD	“©V[ê•2ñ6A⁄
®VâRªª≥…›/pmt"4ÚØ‚˜ÁﬂbI‘Ò∂ÁF˘›≤(£F^πMê‰B•â»w¢˜Ù7iﬁO√0å7 A7®J·	hd»~cYÓ,a⁄®+≠“¿÷Dä“J›nôU]OH¿vR™+\©SjÇN∞ßû˜U◊îËHÏ@ùT3„jpº71≥è…R¢q'{@ﬁ+åZ¡ÛW…NDú^2+À0√¯¬$TÑKÉ4› x‰_âöVAÇ2(>ÖåLãji§6o¬Ô¢ Éôåø3¯∫˛öºﬂÙöÍ“›—u4Q©§$VÜ≠‚¸rWÊ*T«*·ïf”%Pê6ëÿ=SáÊÂ]œ´aÜqíTâ£é∫”f·9õúÃeô˝†ıª
Ú¥äí]r®ÃƒE¸˛I§}Pí&2 Ô™,®î=ó∞‡öô!⁄D‹C!o“&T#ÂÅ„¿–~ˆJa•â∫ˇ¶±˚LÜaßU(Ú1q?≠[„&éÇè2s∂`$In|Ôò}£ÖïM‹uHÕbXÔ`oãVú†«Â›û"*ê°ï‘A4˛'ÍfK†m‘ı»„RV*·±m¢YpÉœ•aÜqa"‚ƒÈ⁄£ël7ÃÍRiÕQ˙r¶…∑∫°î	=Öj£‘o,	MDòTŒ”ﬂêÃ7Wï˛ôŸGÑŸ{Í®+†ˆy*bê1zŸ™Ëí[hîN"ı™êπ{yßú,√0„{ï¶éÜ‹v†2ù!LQæé ∆9Í∫;JsÊ=33uFe2çØ~V Lò0ÓQab)˛˛B§i§YÅkPí„Aº+ú#4ns9v%ÇÃ]ç3¯—|>√0åª¡é^ò≤}}çêÀ§∆K‘‘ßîÂ∂‡ÁnçÙËJÍ.¥©IâT,Õ≠ê˘48›˘‘5”ã/._rÍÕ◊êE…¥PJ<F@,3G*øç.øÜaüVïÑB–„-jÁåùîŒZ™”÷hﬂDGùö¶B©
Ïk…‰ãôÅ(a)n¥≤tZi‚zæFò5áÈŸ]‡#[©ú∂í˜©P˘n?√ˇ9—Ë_√0„€‘ÉYº≈…ÙG^£EyùéfÄ1ºIœBØLÂúÎ˜åÙ~˛zñ|‹M†:RËzj"@ır!O—"¿DÁèˇ™ëÆ”—Á“0√¯â≈;úFöó6
œõrK†8’¿ﬂtf≤=Á%±˘∑P{Ön™D™'bhEÈkïßé3´(≤¢ß·∂E:åq¢ﬁBJ£É'√0åGP–É2¿b¶S¡êü1à´Q+≈]HARj≈@ãk˜Í3‡˘⁄"rÖq.È!Q)l¢Ô1Y2√0~vQ˚Û'XN≈åÆ*∆X‰¿„T∆≠`wT	“øUûR¢ëâ•^¥æõ,˝Ïµ’úø'Ã„#yü>t/˙<Üaø©pﬁŒH
ÕLôFô2oJc¨Öö˘Üj˙ëVQÆY·„	î/ÏåöDI±«≤êœÙÔëÒàïΩeÜa∆s,l¥„®,Ç§Ü€˜≠≈RŸ§k∆Ï"|+HåF*€‰{·,)´ÜaÜa|+yÍDô‰J\OÃ⁄Yƒ∏ëôî¢ÅÂ¯˜+©G¸o'¯ù&*ŸòÜaÜÒ„Ñâ;üaŒÂÚâ^≥πrˇ∑°´eÏlC#±aÜa∆£'ÏtÍÈ’âytÕbk*@-S∞aÜa∆Sí(EÇ¨˙ÜaÜaÜÒ+πÜaÜa&LfáÜaÜaáD…G¡0√0√Ñ…0√0√0√0ûg£ÓÕ∫aÜaÜ	ìaÜaÜa<IÔ<,€0√0£Mòz‡ÜaÜa¥	”Õe‡ˇs≈1sy‘àÁ    IENDÆB`Ç                                   root/go1.4/doc/go1.1.html                                                                           0100644 0000000 0000000 00000116737 12600426226 013357  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Go 1.1 Release Notes",
	"Path":  "/doc/go1.1",
	"Template": true
}-->

<h2 id="introduction">Introduction to Go 1.1</h2>

<p>
The release of <a href="/doc/go1.html">Go version 1</a> (Go 1 or Go 1.0 for short)
in March of 2012 introduced a new period
of stability in the Go language and libraries.
That stability has helped nourish a growing community of Go users
and systems around the world.
Several "point" releases since
then‚Äî1.0.1, 1.0.2, and 1.0.3‚Äîhave been issued.
These point releases fixed known bugs but made
no non-critical changes to the implementation.
</p>

<p>
This new release, Go 1.1, keeps the <a href="/doc/go1compat.html">promise
of compatibility</a> but adds a couple of significant
(backwards-compatible, of course) language changes, has a long list
of (again, compatible) library changes, and
includes major work on the implementation of the compilers,
libraries, and run-time.
The focus is on performance.
Benchmarking is an inexact science at best, but we see significant,
sometimes dramatic speedups for many of our test programs.
We trust that many of our users' programs will also see improvements
just by updating their Go installation and recompiling.
</p>

<p>
This document summarizes the changes between Go 1 and Go 1.1.
Very little if any code will need modification to run with Go 1.1,
although a couple of rare error cases surface with this release
and need to be addressed if they arise.
Details appear below; see the discussion of
<a href="#int">64-bit ints</a> and <a href="#unicode_literals">Unicode literals</a>
in particular.
</p>

<h2 id="language">Changes to the language</h2>

<p>
<a href="/doc/go1compat.html">The Go compatibility document</a> promises
that programs written to the Go 1 language specification will continue to operate,
and those promises are maintained.
In the interest of firming up the specification, though, there are
details about some error cases that have been clarified.
There are also some new language features.
</p>

<h3 id="divzero">Integer division by zero</h3>

<p>
In Go 1, integer division by a constant zero produced a run-time panic:
</p>

<pre>
func f(x int) int {
	return x/0
}
</pre>

<p>
In Go 1.1, an integer division by constant zero is not a legal program, so it is a compile-time error.
</p>

<h3 id="unicode_literals">Surrogates in Unicode literals</h3>

<p>
The definition of string and rune literals has been refined to exclude surrogate halves from the
set of valid Unicode code points.
See the <a href="#unicode">Unicode</a> section for more information.
</p>

<h3 id="method_values">Method values</h3>

<p>
Go 1.1 now implements
<a href="/ref/spec#Method_values">method values</a>,
which are functions that have been bound to a specific receiver value.
For instance, given a
<a href="/pkg/bufio/#Writer"><code>Writer</code></a>
value <code>w</code>,
the expression
<code>w.Write</code>,
a method value, is a function that will always write to <code>w</code>; it is equivalent to
a function literal closing over <code>w</code>:
</p>

<pre>
func (p []byte) (n int, err error) {
	return w.Write(p)
}
</pre>

<p>
Method values are distinct from method expressions, which generate functions
from methods of a given type; the method expression <code>(*bufio.Writer).Write</code>
is equivalent to a function with an extra first argument, a receiver of type
<code>(*bufio.Writer)</code>:
</p>

<pre>
func (w *bufio.Writer, p []byte) (n int, err error) {
	return w.Write(p)
}
</pre>

<p>
<em>Updating</em>: No existing code is affected; the change is strictly backward-compatible.
</p>

<h3 id="return">Return requirements</h3>

<p>
Before Go 1.1, a function that returned a value needed an explicit "return"
or call to <code>panic</code> at
the end of the function; this was a simple way to make the programmer
be explicit about the meaning of the function. But there are many cases
where a final "return" is clearly unnecessary, such as a function with
only an infinite "for" loop.
</p>

<p>
In Go 1.1, the rule about final "return" statements is more permissive.
It introduces the concept of a
<a href="/ref/spec#Terminating_statements"><em>terminating statement</em></a>,
a statement that is guaranteed to be the last one a function executes.
Examples include
"for" loops with no condition and "if-else"
statements in which each half ends in a "return".
If the final statement of a function can be shown <em>syntactically</em> to
be a terminating statement, no final "return" statement is needed.
</p>

<p>
Note that the rule is purely syntactic: it pays no attention to the values in the
code and therefore requires no complex analysis.
</p>

<p>
<em>Updating</em>: The change is backward-compatible, but existing code
with superfluous "return" statements and calls to <code>panic</code> may
be simplified manually.
Such code can be identified by <code>go vet</code>.
</p>

<h2 id="impl">Changes to the implementations and tools</h2>

<h3 id="gccgo">Status of gccgo</h3>

<p>
The GCC release schedule does not coincide with the Go release schedule, so some skew is inevitable in
<code>gccgo</code>'s releases.
The 4.8.0 version of GCC shipped in March, 2013 and includes a nearly-Go 1.1 version of <code>gccgo</code>.
Its library is a little behind the release, but the biggest difference is that method values are not implemented.
Sometime around July 2013, we expect 4.8.2 of GCC to ship with a <code>gccgo</code>
providing a complete Go 1.1 implementaiton.
</p>

<h3 id="gc_flag">Command-line flag parsing</h3>

<p>
In the gc tool chain, the compilers and linkers now use the
same command-line flag parsing rules as the Go flag package, a departure
from the traditional Unix flag parsing. This may affect scripts that invoke
the tool directly.
For example,
<code>go tool 6c -Fw -Dfoo</code> must now be written
<code>go tool 6c -F -w -D foo</code>.
</p>

<h3 id="int">Size of int on 64-bit platforms</h3>

<p>
The language allows the implementation to choose whether the <code>int</code> type and
<code>uint</code> types are 32 or 64 bits. Previous Go implementations made <code>int</code>
and <code>uint</code> 32 bits on all systems. Both the gc and gccgo implementations
now make
<code>int</code> and <code>uint</code> 64 bits on 64-bit platforms such as AMD64/x86-64.
Among other things, this enables the allocation of slices with
more than 2 billion elements on 64-bit platforms.
</p>

<p>
<em>Updating</em>:
Most programs will be unaffected by this change.
Because Go does not allow implicit conversions between distinct
<a href="/ref/spec#Numeric_types">numeric types</a>,
no programs will stop compiling due to this change.
However, programs that contain implicit assumptions
that <code>int</code> is only 32 bits may change behavior.
For example, this code prints a positive number on 64-bit systems and
a negative one on 32-bit systems:
</p>

<pre>
x := ^uint32(0) // x is 0xffffffff
i := int(x)     // i is -1 on 32-bit systems, 0xffffffff on 64-bit
fmt.Println(i)
</pre>

<p>Portable code intending 32-bit sign extension (yielding <code>-1</code> on all systems)
would instead say:
</p>

<pre>
i := int(int32(x))
</pre>

<h3 id="heap">Heap size on 64-bit architectures</h3>

<p>
On 64-bit architectures, the maximum heap size has been enlarged substantially,
from a few gigabytes to several tens of gigabytes.
(The exact details depend on the system and may change.)
</p>

<p>
On 32-bit architectures, the heap size has not changed.
</p>

<p>
<em>Updating</em>:
This change should have no effect on existing programs beyond allowing them
to run with larger heaps.
</p>

<h3 id="unicode">Unicode</h3>

<p>
To make it possible to represent code points greater than 65535 in UTF-16,
Unicode defines <em>surrogate halves</em>,
a range of code points to be used only in the assembly of large values, and only in UTF-16.
The code points in that surrogate range are illegal for any other purpose.
In Go 1.1, this constraint is honored by the compiler, libraries, and run-time:
a surrogate half is illegal as a rune value, when encoded as UTF-8, or when
encoded in isolation as UTF-16.
When encountered, for example in converting from a rune to UTF-8, it is
treated as an encoding error and will yield the replacement rune,
<a href="/pkg/unicode/utf8/#RuneError"><code>utf8.RuneError</code></a>,
U+FFFD.
</p>

<p>
This program,
</p>

<pre>
import "fmt"

func main() {
    fmt.Printf("%+q\n", string(0xD800))
}
</pre>

<p>
printed <code>"\ud800"</code> in Go 1.0, but prints <code>"\ufffd"</code> in Go 1.1.
</p>

<p>
Surrogate-half Unicode values are now illegal in rune and string constants, so constants such as
<code>'\ud800'</code> and <code>"\ud800"</code> are now rejected by the compilers.
When written explicitly as UTF-8 encoded bytes,
such strings can still be created, as in <code>"\xed\xa0\x80"</code>.
However, when such a string is decoded as a sequence of runes, as in a range loop, it will yield only <code>utf8.RuneError</code>
values.
</p>

<p>
The Unicode byte order mark U+FEFF, encoded in UTF-8, is now permitted as the first
character of a Go source file.
Even though its appearance in the byte-order-free UTF-8 encoding is clearly unnecessary,
some editors add the mark as a kind of "magic number" identifying a UTF-8 encoded file.
</p>

<p>
<em>Updating</em>:
Most programs will be unaffected by the surrogate change.
Programs that depend on the old behavior should be modified to avoid the issue.
The byte-order-mark change is strictly backward-compatible.
</p>

<h3 id="race">Race detector</h3>

<p>
A major addition to the tools is a <em>race detector</em>, a way to
find bugs in programs caused by concurrent access of the same
variable, where at least one of the accesses is a write.
This new facility is built into the <code>go</code> tool.
For now, it is only available on Linux, Mac OS X, and Windows systems with
64-bit x86 processors.
To enable it, set the <code>-race</code> flag when building or testing your program
(for instance, <code>go test -race</code>).
The race detector is documented in <a href="/doc/articles/race_detector.html">a separate article</a>.
</p>

<h3 id="gc_asm">The gc assemblers</h3>

<p>
Due to the change of the <a href="#int"><code>int</code></a> to 64 bits and
a new internal <a href="//golang.org/s/go11func">representation of functions</a>,
the arrangement of function arguments on the stack has changed in the gc tool chain.
Functions written in assembly will need to be revised at least
to adjust frame pointer offsets.
</p>

<p>
<em>Updating</em>:
The <code>go vet</code> command now checks that functions implemented in assembly
match the Go function prototypes they implement.
</p>

<h3 id="gocmd">Changes to the go command</h3>

<p>
The <a href="/cmd/go/"><code>go</code></a> command has acquired several
changes intended to improve the experience for new Go users.
</p>

<p>
First, when compiling, testing, or running Go code, the <code>go</code> command will now give more detailed error messages,
including a list of paths searched, when a package cannot be located.
</p>

<pre>
$ go build foo/quxx
can't load package: package foo/quxx: cannot find package "foo/quxx" in any of:
        /home/you/go/src/pkg/foo/quxx (from $GOROOT)
        /home/you/src/foo/quxx (from $GOPATH)
</pre>

<p>
Second, the <code>go get</code> command no longer allows <code>$GOROOT</code>
as the default destination when downloading package source.
To use the <code>go get</code>
command, a <a href="/doc/code.html#GOPATH">valid <code>$GOPATH</code></a> is now required.
</p>

<pre>
$ GOPATH= go get code.google.com/p/foo/quxx
package code.google.com/p/foo/quxx: cannot download, $GOPATH not set. For more details see: go help gopath
</pre>

<p>
Finally, as a result of the previous change, the <code>go get</code> command will also fail
when <code>$GOPATH</code> and <code>$GOROOT</code> are set to the same value.
</p>

<pre>
$ GOPATH=$GOROOT go get code.google.com/p/foo/quxx
warning: GOPATH set to GOROOT (/home/you/go) has no effect
package code.google.com/p/foo/quxx: cannot download, $GOPATH must not be set to $GOROOT. For more details see: go help gopath
</pre>

<h3 id="gotest">Changes to the go test command</h3>

<p>
The <a href="/cmd/go/#hdr-Test_packages"><code>go test</code></a>
command no longer deletes the binary when run with profiling enabled,
to make it easier to analyze the profile.
The implementation sets the <code>-c</code> flag automatically, so after running,
</p>

<pre>
$ go test -cpuprofile cpuprof.out mypackage
</pre>

<p>
the file <code>mypackage.test</code> will be left in the directory where <code>go test</code> was run.
</p>

<p>
The <a href="/cmd/go/#hdr-Test_packages"><code>go test</code></a>
command can now generate profiling information
that reports where goroutines are blocked, that is,
where they tend to stall waiting for an event such as a channel communication.
The information is presented as a
<em>blocking profile</em>
enabled with the
<code>-blockprofile</code>
option of
<code>go test</code>.
Run <code>go help test</code> for more information.
</p>

<h3 id="gofix">Changes to the go fix command</h3>

<p>
The <a href="/cmd/fix/"><code>fix</code></a> command, usually run as
<code>go fix</code>, no longer applies fixes to update code from
before Go 1 to use Go 1 APIs.
To update pre-Go 1 code to Go 1.1, use a Go 1.0 tool chain
to convert the code to Go 1.0 first.
</p>

<h3 id="tags">Build constraints</h3>

<p>
The "<code>go1.1</code>" tag has been added to the list of default
<a href="/pkg/go/build/#hdr-Build_Constraints">build constraints</a>.
This permits packages to take advantage of the new features in Go 1.1 while
remaining compatible with earlier versions of Go.
</p>

<p>
To build a file only with Go 1.1 and above, add this build constraint:
</p>

<pre>
// +build go1.1
</pre>

<p>
To build a file only with Go 1.0.x, use the converse constraint:
</p>

<pre>
// +build !go1.1
</pre>

<h3 id="platforms">Additional platforms</h3>

<p>
The Go 1.1 tool chain adds experimental support for <code>freebsd/arm</code>,
<code>netbsd/386</code>, <code>netbsd/amd64</code>, <code>netbsd/arm</code>,
<code>openbsd/386</code> and <code>openbsd/amd64</code> platforms.
</p>

<p>
An ARMv6 or later processor is required for <code>freebsd/arm</code> or
<code>netbsd/arm</code>.
</p>

<p>
Go 1.1 adds experimental support for <code>cgo</code> on <code>linux/arm</code>.
</p>

<h3 id="crosscompile">Cross compilation</h3>

<p>
When cross-compiling, the <code>go</code> tool will disable <code>cgo</code>
support by default.
</p>

<p>
To explicitly enable <code>cgo</code>, set <code>CGO_ENABLED=1</code>.
</p>

<h2 id="performance">Performance</h2>

<p>
The performance of code compiled with the Go 1.1 gc tool suite should be noticeably
better for most Go programs.
Typical improvements relative to Go 1.0 seem to be about 30%-40%, sometimes
much more, but occasionally less or even non-existent.
There are too many small performance-driven tweaks through the tools and libraries
to list them all here, but the following major changes are worth noting:
</p>

<ul>
<li>The gc compilers generate better code in many cases, most noticeably for
floating point on the 32-bit Intel architecture.</li>
<li>The gc compilers do more in-lining, including for some operations
in the run-time such as <a href="/pkg/builtin/#append"><code>append</code></a>
and interface conversions.</li>
<li>There is a new implementation of Go maps with significant reduction in
memory footprint and CPU time.</li>
<li>The garbage collector has been made more parallel, which can reduce
latencies for programs running on multiple CPUs.</li>
<li>The garbage collector is also more precise, which costs a small amount of
CPU time but can reduce the size of the heap significantly, especially
on 32-bit architectures.</li>
<li>Due to tighter coupling of the run-time and network libraries, fewer
context switches are required on network operations.</li>
</ul>

<h2 id="library">Changes to the standard library</h2>

<h3 id="bufio_scanner">bufio.Scanner</h3>

<p>
The various routines to scan textual input in the
<a href="/pkg/bufio/"><code>bufio</code></a>
package,
<a href="/pkg/bufio/#Reader.ReadBytes"><code>ReadBytes</code></a>,
<a href="/pkg/bufio/#Reader.ReadString"><code>ReadString</code></a>
and particularly
<a href="/pkg/bufio/#Reader.ReadLine"><code>ReadLine</code></a>,
are needlessly complex to use for simple purposes.
In Go 1.1, a new type,
<a href="/pkg/bufio/#Scanner"><code>Scanner</code></a>,
has been added to make it easier to do simple tasks such as
read the input as a sequence of lines or space-delimited words.
It simplifies the problem by terminating the scan on problematic
input such as pathologically long lines, and having a simple
default: line-oriented input, with each line stripped of its terminator.
Here is code to reproduce the input a line at a time:
</p>

<pre>
scanner := bufio.NewScanner(os.Stdin)
for scanner.Scan() {
    fmt.Println(scanner.Text()) // Println will add back the final '\n'
}
if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading standard input:", err)
}
</pre>

<p>
Scanning behavior can be adjusted through a function to control subdividing the input
(see the documentation for <a href="/pkg/bufio/#SplitFunc"><code>SplitFunc</code></a>),
but for tough problems or the need to continue past errors, the older interface
may still be required.
</p>

<h3 id="net">net</h3>

<p>
The protocol-specific resolvers in the <a href="/pkg/net/"><code>net</code></a> package were formerly
lax about the network name passed in.
Although the documentation was clear
that the only valid networks for
<a href="/pkg/net/#ResolveTCPAddr"><code>ResolveTCPAddr</code></a>
are <code>"tcp"</code>,
<code>"tcp4"</code>, and <code>"tcp6"</code>, the Go 1.0 implementation silently accepted any string.
The Go 1.1 implementation returns an error if the network is not one of those strings.
The same is true of the other protocol-specific resolvers <a href="/pkg/net/#ResolveIPAddr"><code>ResolveIPAddr</code></a>,
<a href="/pkg/net/#ResolveUDPAddr"><code>ResolveUDPAddr</code></a>, and
<a href="/pkg/net/#ResolveUnixAddr"><code>ResolveUnixAddr</code></a>.
</p>

<p>
The previous implementation of
<a href="/pkg/net/#ListenUnixgram"><code>ListenUnixgram</code></a>
returned a
<a href="/pkg/net/#UDPConn"><code>UDPConn</code></a> as
a representation of the connection endpoint.
The Go 1.1 implementation instead returns a
<a href="/pkg/net/#UnixConn"><code>UnixConn</code></a>
to allow reading and writing
with its
<a href="/pkg/net/#UnixConn.ReadFrom"><code>ReadFrom</code></a>
and
<a href="/pkg/net/#UnixConn.WriteTo"><code>WriteTo</code></a>
methods.
</p>

<p>
The data structures
<a href="/pkg/net/#IPAddr"><code>IPAddr</code></a>,
<a href="/pkg/net/#TCPAddr"><code>TCPAddr</code></a>, and
<a href="/pkg/net/#UDPAddr"><code>UDPAddr</code></a>
add a new string field called <code>Zone</code>.
Code using untagged composite literals (e.g. <code>net.TCPAddr{ip, port}</code>)
instead of tagged literals (<code>net.TCPAddr{IP: ip, Port: port}</code>)
will break due to the new field.
The Go 1 compatibility rules allow this change: client code must use tagged literals to avoid such breakages.
</p>

<p>
<em>Updating</em>:
To correct breakage caused by the new struct field,
<code>go fix</code> will rewrite code to add tags for these types.
More generally, <code>go vet</code> will identify composite literals that
should be revised to use field tags.
</p>

<h3 id="reflect">reflect</h3>

<p>
The <a href="/pkg/reflect/"><code>reflect</code></a> package has several significant additions.
</p>

<p>
It is now possible to run a "select" statement using
the <code>reflect</code> package; see the description of
<a href="/pkg/reflect/#Select"><code>Select</code></a>
and
<a href="/pkg/reflect/#SelectCase"><code>SelectCase</code></a>
for details.
</p>

<p>
The new method
<a href="/pkg/reflect/#Value.Convert"><code>Value.Convert</code></a>
(or
<a href="/pkg/reflect/#Type"><code>Type.ConvertibleTo</code></a>)
provides functionality to execute a Go conversion or type assertion operation
on a
<a href="/pkg/reflect/#Value"><code>Value</code></a>
(or test for its possibility).
</p>

<p>
The new function
<a href="/pkg/reflect/#MakeFunc"><code>MakeFunc</code></a>
creates a wrapper function to make it easier to call a function with existing
<a href="/pkg/reflect/#Value"><code>Values</code></a>,
doing the standard Go conversions among the arguments, for instance
to pass an actual <code>int</code> to a formal <code>interface{}</code>.
</p>

<p>
Finally, the new functions
<a href="/pkg/reflect/#ChanOf"><code>ChanOf</code></a>,
<a href="/pkg/reflect/#MapOf"><code>MapOf</code></a>
and
<a href="/pkg/reflect/#SliceOf"><code>SliceOf</code></a>
construct new
<a href="/pkg/reflect/#Type"><code>Types</code></a>
from existing types, for example to construct the type <code>[]T</code> given
only <code>T</code>.
</p>


<h3 id="time">time</h3>
<p>
On FreeBSD, Linux, NetBSD, OS X and OpenBSD, previous versions of the
<a href="/pkg/time/"><code>time</code></a> package
returned times with microsecond precision.
The Go 1.1 implementation on these
systems now returns times with nanosecond precision.
Programs that write to an external format with microsecond precision
and read it back, expecting to recover the original value, will be affected
by the loss of precision.
There are two new methods of <a href="/pkg/time/#Time"><code>Time</code></a>,
<a href="/pkg/time/#Time.Round"><code>Round</code></a>
and
<a href="/pkg/time/#Time.Truncate"><code>Truncate</code></a>,
that can be used to remove precision from a time before passing it to
external storage.
</p>

<p>
The new method
<a href="/pkg/time/#Time.YearDay"><code>YearDay</code></a>
returns the one-indexed integral day number of the year specified by the time value.
</p>

<p>
The
<a href="/pkg/time/#Timer"><code>Timer</code></a>
type has a new method
<a href="/pkg/time/#Timer.Reset"><code>Reset</code></a>
that modifies the timer to expire after a specified duration.
</p>

<p>
Finally, the new function
<a href="/pkg/time/#ParseInLocation"><code>ParseInLocation</code></a>
is like the existing
<a href="/pkg/time/#Parse"><code>Parse</code></a>
but parses the time in the context of a location (time zone), ignoring
time zone information in the parsed string.
This function addresses a common source of confusion in the time API.
</p>

<p>
<em>Updating</em>:
Code that needs to read and write times using an external format with
lower precision should be modified to use the new methods.
</p>

<h3 id="exp_old">Exp and old subtrees moved to go.exp and go.text subrepositories</h3>

<p>
To make it easier for binary distributions to access them if desired, the <code>exp</code>
and <code>old</code> source subtrees, which are not included in binary distributions,
have been moved to the new <code>go.exp</code> subrepository at
<code>code.google.com/p/go.exp</code>. To access the <code>ssa</code> package,
for example, run
</p>

<pre>
$ go get code.google.com/p/go.exp/ssa
</pre>

<p>
and then in Go source,
</p>

<pre>
import "code.google.com/p/go.exp/ssa"
</pre>

<p>
The old package <code>exp/norm</code> has also been moved, but to a new repository
<code>go.text</code>, where the Unicode APIs and other text-related packages will
be developed.
</p>

<h3 id="new_packages">New packages</h3>

<p>
There are three new packages.
</p>

<ul>
<li>
The <a href="/pkg/go/format/"><code>go/format</code></a> package provides
a convenient way for a program to access the formatting capabilities of the
<a href="/cmd/go/#hdr-Run_gofmt_on_package_sources"><code>go fmt</code></a> command.
It has two functions,
<a href="/pkg/go/format/#Node"><code>Node</code></a> to format a Go parser
<a href="/pkg/go/ast/#Node"><code>Node</code></a>,
and
<a href="/pkg/go/format/#Source"><code>Source</code></a>
to reformat arbitrary Go source code into the standard format as provided by the
<a href="/cmd/go/#hdr-Run_gofmt_on_package_sources"><code>go fmt</code></a> command.
</li>

<li>
The <a href="/pkg/net/http/cookiejar/"><code>net/http/cookiejar</code></a> package provides the basics for managing HTTP cookies.
</li>

<li>
The <a href="/pkg/runtime/race/"><code>runtime/race</code></a> package provides low-level facilities for data race detection.
It is internal to the race detector and does not otherwise export any user-visible functionality.
</li>
</ul>

<h3 id="minor_library_changes">Minor changes to the library</h3>

<p>
The following list summarizes a number of minor changes to the library, mostly additions.
See the relevant package documentation for more information about each change.
</p>

<ul>
<li>
The <a href="/pkg/bytes/"><code>bytes</code></a> package has two new functions,
<a href="/pkg/bytes/#TrimPrefix"><code>TrimPrefix</code></a>
and
<a href="/pkg/bytes/#TrimSuffix"><code>TrimSuffix</code></a>,
with self-evident properties.
Also, the <a href="/pkg/bytes/#Buffer"><code>Buffer</code></a> type
has a new method
<a href="/pkg/bytes/#Buffer.Grow"><code>Grow</code></a> that
provides some control over memory allocation inside the buffer.
Finally, the
<a href="/pkg/bytes/#Reader"><code>Reader</code></a> type now has a
<a href="/pkg/strings/#Reader.WriteTo"><code>WriteTo</code></a> method
so it implements the
<a href="/pkg/io/#WriterTo"><code>io.WriterTo</code></a> interface.
</li>

<li>
The <a href="/pkg/compress/gzip/"><code>compress/gzip</code></a> package has
a new <a href="/pkg/compress/gzip/#Writer.Flush"><code>Flush</code></a>
method for its
<a href="/pkg/compress/gzip/#Writer"><code>Writer</code></a>
type that flushes its underlying <code>flate.Writer</code>.
</li>

<li>
The <a href="/pkg/crypto/hmac/"><code>crypto/hmac</code></a> package has a new function,
<a href="/pkg/crypto/hmac/#Equal"><code>Equal</code></a>, to compare two MACs.
</li>

<li>
The <a href="/pkg/crypto/x509/"><code>crypto/x509</code></a> package
now supports PEM blocks (see
<a href="/pkg/crypto/x509/#DecryptPEMBlock"><code>DecryptPEMBlock</code></a> for instance),
and a new function
<a href="/pkg/crypto/x509/#ParseECPrivateKey"><code>ParseECPrivateKey</code></a> to parse elliptic curve private keys.
</li>

<li>
The <a href="/pkg/database/sql/"><code>database/sql</code></a> package
has a new
<a href="/pkg/database/sql/#DB.Ping"><code>Ping</code></a>
method for its
<a href="/pkg/database/sql/#DB"><code>DB</code></a>
type that tests the health of the connection.
</li>

<li>
The <a href="/pkg/database/sql/driver/"><code>database/sql/driver</code></a> package
has a new
<a href="/pkg/database/sql/driver/#Queryer"><code>Queryer</code></a>
interface that a
<a href="/pkg/database/sql/driver/#Conn"><code>Conn</code></a>
may implement to improve performance.
</li>

<li>
The <a href="/pkg/encoding/json/"><code>encoding/json</code></a> package's
<a href="/pkg/encoding/json/#Decoder"><code>Decoder</code></a>
has a new method
<a href="/pkg/encoding/json/#Decoder.Buffered"><code>Buffered</code></a>
to provide access to the remaining data in its buffer,
as well as a new method
<a href="/pkg/encoding/json/#Decoder.UseNumber"><code>UseNumber</code></a>
to unmarshal a value into the new type
<a href="/pkg/encoding/json/#Number"><code>Number</code></a>,
a string, rather than a float64.
</li>

<li>
The <a href="/pkg/encoding/xml/"><code>encoding/xml</code></a> package
has a new function,
<a href="/pkg/encoding/xml/#EscapeText"><code>EscapeText</code></a>,
which writes escaped XML output,
and a method on
<a href="/pkg/encoding/xml/#Encoder"><code>Encoder</code></a>,
<a href="/pkg/encoding/xml/#Encoder.Indent"><code>Indent</code></a>,
to specify indented output.
</li>

<li>
In the <a href="/pkg/go/ast/"><code>go/ast</code></a> package, a
new type <a href="/pkg/go/ast/#CommentMap"><code>CommentMap</code></a>
and associated methods makes it easier to extract and process comments in Go programs.
</li>

<li>
In the <a href="/pkg/go/doc/"><code>go/doc</code></a> package,
the parser now keeps better track of stylized annotations such as <code>TODO(joe)</code>
throughout the code,
information that the <a href="/cmd/godoc/"><code>godoc</code></a>
command can filter or present according to the value of the <code>-notes</code> flag.
</li>

<li>
The undocumented and only partially implemented "noescape" feature of the
<a href="/pkg/html/template/"><code>html/template</code></a>
package has been removed; programs that depend on it will break.
</li>

<li>
The <a href="/pkg/image/jpeg/"><code>image/jpeg</code></a> package now
reads progressive JPEG files and handles a few more subsampling configurations.
</li>

<li>
The <a href="/pkg/io/"><code>io</code></a> package now exports the
<a href="/pkg/io/#ByteWriter"><code>io.ByteWriter</code></a> interface to capture the common
functionality of writing a byte at a time.
It also exports a new error, <a href="/pkg/io/#ErrNoProgress"><code>ErrNoProgress</code></a>,
used to indicate a <code>Read</code> implementation is looping without delivering data.
</li>

<li>
The <a href="/pkg/log/syslog/"><code>log/syslog</code></a> package now provides better support
for OS-specific logging features.
</li>

<li>
The <a href="/pkg/math/big/"><code>math/big</code></a> package's
<a href="/pkg/math/big/#Int"><code>Int</code></a> type
now has methods
<a href="/pkg/math/big/#Int.MarshalJSON"><code>MarshalJSON</code></a>
and
<a href="/pkg/math/big/#Int.UnmarshalJSON"><code>UnmarshalJSON</code></a>
to convert to and from a JSON representation.
Also,
<a href="/pkg/math/big/#Int"><code>Int</code></a>
can now convert directly to and from a <code>uint64</code> using
<a href="/pkg/math/big/#Int.Uint64"><code>Uint64</code></a>
and
<a href="/pkg/math/big/#Int.SetUint64"><code>SetUint64</code></a>,
while
<a href="/pkg/math/big/#Rat"><code>Rat</code></a>
can do the same with <code>float64</code> using
<a href="/pkg/math/big/#Rat.Float64"><code>Float64</code></a>
and
<a href="/pkg/math/big/#Rat.SetFloat64"><code>SetFloat64</code></a>.
</li>

<li>
The <a href="/pkg/mime/multipart/"><code>mime/multipart</code></a> package
has a new method for its
<a href="/pkg/mime/multipart/#Writer"><code>Writer</code></a>,
<a href="/pkg/mime/multipart/#Writer.SetBoundary"><code>SetBoundary</code></a>,
to define the boundary separator used to package the output.
The <a href="/pkg/mime/multipart/#Reader"><code>Reader</code></a> also now
transparently decodes any <code>quoted-printable</code> parts and removes
the <code>Content-Transfer-Encoding</code> header when doing so.
</li>

<li>
The
<a href="/pkg/net/"><code>net</code></a> package's
<a href="/pkg/net/#ListenUnixgram"><code>ListenUnixgram</code></a>
function has changed return types: it now returns a
<a href="/pkg/net/#UnixConn"><code>UnixConn</code></a>
rather than a
<a href="/pkg/net/#UDPConn"><code>UDPConn</code></a>, which was
clearly a mistake in Go 1.0.
Since this API change fixes a bug, it is permitted by the Go 1 compatibility rules.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package includes a new type,
<a href="/pkg/net/#Dialer"><code>Dialer</code></a>, to supply options to
<a href="/pkg/net/#Dialer.Dial"><code>Dial</code></a>.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package adds support for
link-local IPv6 addresses with zone qualifiers, such as <code>fe80::1%lo0</code>.
The address structures <a href="/pkg/net/#IPAddr"><code>IPAddr</code></a>,
<a href="/pkg/net/#UDPAddr"><code>UDPAddr</code></a>, and
<a href="/pkg/net/#TCPAddr"><code>TCPAddr</code></a>
record the zone in a new field, and functions that expect string forms of these addresses, such as
<a href="/pkg/net/#Dial"><code>Dial</code></a>,
<a href="/pkg/net/#ResolveIPAddr"><code>ResolveIPAddr</code></a>,
<a href="/pkg/net/#ResolveUDPAddr"><code>ResolveUDPAddr</code></a>, and
<a href="/pkg/net/#ResolveTCPAddr"><code>ResolveTCPAddr</code></a>,
now accept the zone-qualified form.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package adds
<a href="/pkg/net/#LookupNS"><code>LookupNS</code></a> to its suite of resolving functions.
<code>LookupNS</code> returns the <a href="/pkg/net/#NS">NS records</a> for a host name.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package adds protocol-specific
packet reading and writing methods to
<a href="/pkg/net/#IPConn"><code>IPConn</code></a>
(<a href="/pkg/net/#IPConn.ReadMsgIP"><code>ReadMsgIP</code></a>
and <a href="/pkg/net/#IPConn.WriteMsgIP"><code>WriteMsgIP</code></a>) and
<a href="/pkg/net/#UDPConn"><code>UDPConn</code></a>
(<a href="/pkg/net/#UDPConn.ReadMsgUDP"><code>ReadMsgUDP</code></a> and
<a href="/pkg/net/#UDPConn.WriteMsgUDP"><code>WriteMsgUDP</code></a>).
These are specialized versions of <a href="/pkg/net/#PacketConn"><code>PacketConn</code></a>'s
<code>ReadFrom</code> and <code>WriteTo</code> methods that provide access to out-of-band data associated
with the packets.
 </li>

 <li>
The <a href="/pkg/net/"><code>net</code></a> package adds methods to
<a href="/pkg/net/#UnixConn"><code>UnixConn</code></a> to allow closing half of the connection
(<a href="/pkg/net/#UnixConn.CloseRead"><code>CloseRead</code></a> and
<a href="/pkg/net/#UnixConn.CloseWrite"><code>CloseWrite</code></a>),
matching the existing methods of <a href="/pkg/net/#TCPConn"><code>TCPConn</code></a>.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package includes several new additions.
<a href="/pkg/net/http/#ParseTime"><code>ParseTime</code></a> parses a time string, trying
several common HTTP time formats.
The <a href="/pkg/net/http/#Request.PostFormValue"><code>PostFormValue</code></a> method of
<a href="/pkg/net/http/#Request"><code>Request</code></a> is like
<a href="/pkg/net/http/#Request.FormValue"><code>FormValue</code></a> but ignores URL parameters.
The <a href="/pkg/net/http/#CloseNotifier"><code>CloseNotifier</code></a> interface provides a mechanism
for a server handler to discover when a client has disconnected.
The <code>ServeMux</code> type now has a
<a href="/pkg/net/http/#ServeMux.Handler"><code>Handler</code></a> method to access a path's
<code>Handler</code> without executing it.
The <code>Transport</code> can now cancel an in-flight request with
<a href="/pkg/net/http/#Transport.CancelRequest"><code>CancelRequest</code></a>.
Finally, the Transport is now more aggressive at closing TCP connections when
a <a href="/pkg/net/http/#Response"><code>Response.Body</code></a> is closed before
being fully consumed.
</li>

<li>
The <a href="/pkg/net/mail/"><code>net/mail</code></a> package has two new functions,
<a href="/pkg/net/mail/#ParseAddress"><code>ParseAddress</code></a> and
<a href="/pkg/net/mail/#ParseAddressList"><code>ParseAddressList</code></a>,
to parse RFC 5322-formatted mail addresses into
<a href="/pkg/net/mail/#Address"><code>Address</code></a> structures.
</li>

<li>
The <a href="/pkg/net/smtp/"><code>net/smtp</code></a> package's
<a href="/pkg/net/smtp/#Client"><code>Client</code></a> type has a new method,
<a href="/pkg/net/smtp/#Client.Hello"><code>Hello</code></a>,
which transmits a <code>HELO</code> or <code>EHLO</code> message to the server.
</li>

<li>
The <a href="/pkg/net/textproto/"><code>net/textproto</code></a> package
has two new functions,
<a href="/pkg/net/textproto/#TrimBytes"><code>TrimBytes</code></a> and
<a href="/pkg/net/textproto/#TrimString"><code>TrimString</code></a>,
which do ASCII-only trimming of leading and trailing spaces.
</li>

<li>
The new method <a href="/pkg/os/#FileMode.IsRegular"><code>os.FileMode.IsRegular</code></a> makes it easy to ask if a file is a plain file.
</li>

<li>
The <a href="/pkg/os/signal/"><code>os/signal</code></a> package has a new function,
<a href="/pkg/os/signal/#Stop"><code>Stop</code></a>, which stops the package delivering
any further signals to the channel.
</li>

<li>
The <a href="/pkg/regexp/"><code>regexp</code></a> package
now supports Unix-original leftmost-longest matches through the
<a href="/pkg/regexp/#Regexp.Longest"><code>Regexp.Longest</code></a>
method, while
<a href="/pkg/regexp/#Regexp.Split"><code>Regexp.Split</code></a> slices
strings into pieces based on separators defined by the regular expression.
</li>

<li>
The <a href="/pkg/runtime/debug/"><code>runtime/debug</code></a> package
has three new functions regarding memory usage.
The <a href="/pkg/runtime/debug/#FreeOSMemory"><code>FreeOSMemory</code></a>
function triggers a run of the garbage collector and then attempts to return unused
memory to the operating system;
the <a href="/pkg/runtime/debug/#ReadGCStats"><code>ReadGCStats</code></a>
function retrieves statistics about the collector; and
<a href="/pkg/runtime/debug/#SetGCPercent"><code>SetGCPercent</code></a>
provides a programmatic way to control how often the collector runs,
including disabling it altogether.
</li>

<li>
The <a href="/pkg/sort/"><code>sort</code></a> package has a new function,
<a href="/pkg/sort/#Reverse"><code>Reverse</code></a>.
Wrapping the argument of a call to
<a href="/pkg/sort/#Sort"><code>sort.Sort</code></a>
with a call to <code>Reverse</code> causes the sort order to be reversed.
</li>

<li>
The <a href="/pkg/strings/"><code>strings</code></a> package has two new functions,
<a href="/pkg/strings/#TrimPrefix"><code>TrimPrefix</code></a>
and
<a href="/pkg/strings/#TrimSuffix"><code>TrimSuffix</code></a>
with self-evident properties, and the new method
<a href="/pkg/strings/#Reader.WriteTo"><code>Reader.WriteTo</code></a> so the
<a href="/pkg/strings/#Reader"><code>Reader</code></a>
type now implements the
<a href="/pkg/io/#WriterTo"><code>io.WriterTo</code></a> interface.
</li>

<li>
The <a href="/pkg/syscall/"><code>syscall</code></a> package's
<a href="/pkg/syscall/#Fchflags"><code>Fchflags</code></a> function on various BSDs
(including Darwin) has changed signature.
It now takes an int as the first parameter instead of a string.
Since this API change fixes a bug, it is permitted by the Go 1 compatibility rules.
</li>
<li>
The <a href="/pkg/syscall/"><code>syscall</code></a> package also has received many updates
to make it more inclusive of constants and system calls for each supported operating system.
</li>

<li>
The <a href="/pkg/testing/"><code>testing</code></a> package now automates the generation of allocation
statistics in tests and benchmarks using the new
<a href="/pkg/testing/#AllocsPerRun"><code>AllocsPerRun</code></a> function. And the
<a href="/pkg/testing/#B.ReportAllocs"><code>ReportAllocs</code></a>
method on <a href="/pkg/testing/#B"><code>testing.B</code></a> will enable printing of
memory allocation statistics for the calling benchmark. It also introduces the
<a href="/pkg/testing/#BenchmarkResult.AllocsPerOp"><code>AllocsPerOp</code></a> method of
<a href="/pkg/testing/#BenchmarkResult"><code>BenchmarkResult</code></a>.
There is also a new
<a href="/pkg/testing/#Verbose"><code>Verbose</code></a> function to test the state of the <code>-v</code>
command-line flag,
and a new
<a href="/pkg/testing/#B.Skip"><code>Skip</code></a> method of
<a href="/pkg/testing/#B"><code>testing.B</code></a> and
<a href="/pkg/testing/#T"><code>testing.T</code></a>
to simplify skipping an inappropriate test.
</li>

<li>
In the <a href="/pkg/text/template/"><code>text/template</code></a>
and
<a href="/pkg/html/template/"><code>html/template</code></a> packages,
templates can now use parentheses to group the elements of pipelines, simplifying the construction of complex pipelines.
Also, as part of the new parser, the
<a href="/pkg/text/template/parse/#Node"><code>Node</code></a> interface got two new methods to provide
better error reporting.
Although this violates the Go 1 compatibility rules,
no existing code should be affected because this interface is explicitly intended only to be used
by the
<a href="/pkg/text/template/"><code>text/template</code></a>
and
<a href="/pkg/html/template/"><code>html/template</code></a>
packages and there are safeguards to guarantee that.
</li>

<li>
The implementation of the <a href="/pkg/unicode/"><code>unicode</code></a> package has been updated to Unicode version 6.2.0.
</li>

<li>
In the <a href="/pkg/unicode/utf8/"><code>unicode/utf8</code></a> package,
the new function <a href="/pkg/unicode/utf8/#ValidRune"><code>ValidRune</code></a> reports whether the rune is a valid Unicode code point.
To be valid, a rune must be in range and not be a surrogate half.
</li>
</ul>
                                 root/go1.4/doc/go1.2.html                                                                           0100644 0000000 0000000 00000104267 12600426226 013353  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Go 1.2 Release Notes",
	"Path":  "/doc/go1.2",
	"Template": true
}-->

<h2 id="introduction">Introduction to Go 1.2</h2>

<p>
Since the release of <a href="/doc/go1.1.html">Go version 1.1</a> in April, 2013,
the release schedule has been shortened to make the release process more efficient.
This release, Go version 1.2 or Go 1.2 for short, arrives roughly six months after 1.1,
while 1.1 took over a year to appear after 1.0.
Because of the shorter time scale, 1.2 is a smaller delta than the step from 1.0 to 1.1,
but it still has some significant developments, including
a better scheduler and one new language feature.
Of course, Go 1.2 keeps the <a href="/doc/go1compat.html">promise
of compatibility</a>.
The overwhelming majority of programs built with Go 1.1 (or 1.0 for that matter)
will run without any changes whatsoever when moved to 1.2,
although the introduction of one restriction
to a corner of the language may expose already-incorrect code
(see the discussion of the <a href="#use_of_nil">use of nil</a>).
</p>

<h2 id="language">Changes to the language</h2>

<p>
In the interest of firming up the specification, one corner case has been clarified,
with consequences for programs.
There is also one new language feature.
</p>

<h3 id="use_of_nil">Use of nil</h3>

<p>
The language now specifies that, for safety reasons,
certain uses of nil pointers are guaranteed to trigger a run-time panic.
For instance, in Go 1.0, given code like
</p>

<pre>
type T struct {
    X [1<<24]byte
    Field int32
}

func main() {
    var x *T
    ...
}
</pre>

<p>
the <code>nil</code> pointer <code>x</code> could be used to access memory incorrectly:
the expression <code>x.Field</code> could access memory at address <code>1<<24</code>.
To prevent such unsafe behavior, in Go 1.2 the compilers now guarantee that any indirection through
a nil pointer, such as illustrated here but also in nil pointers to arrays, nil interface values,
nil slices, and so on, will either panic or return a correct, safe non-nil value.
In short, any expression that explicitly or implicitly requires evaluation of a nil address is an error.
The implementation may inject extra tests into the compiled program to enforce this behavior.
</p>

<p>
Further details are in the
<a href="//golang.org/s/go12nil">design document</a>.
</p>

<p>
<em>Updating</em>:
Most code that depended on the old behavior is erroneous and will fail when run.
Such programs will need to be updated by hand.
</p>

<h3 id="three_index">Three-index slices</h3>

<p>
Go 1.2 adds the ability to specify the capacity as well as the length when using a slicing operation
on an existing array or slice.
A slicing operation creates a new slice by describing a contiguous section of an already-created array or slice:
</p>

<pre>
var array [10]int
slice := array[2:4]
</pre>

<p>
The capacity of the slice is the maximum number of elements that the slice may hold, even after reslicing;
it reflects the size of the underlying array.
In this example, the capacity of the <code>slice</code> variable is 8.
</p>

<p>
Go 1.2 adds new syntax to allow a slicing operation to specify the capacity as well as the length.
A second
colon introduces the capacity value, which must be less than or equal to the capacity of the
source slice or array, adjusted for the origin. For instance,
</p>

<pre>
slice = array[2:4:7]
</pre>

<p>
sets the slice to have the same length as in the earlier example but its capacity is now only 5 elements (7-2).
It is impossible to use this new slice value to access the last three elements of the original array.
</p>

<p>
In this three-index notation, a missing first index (<code>[:i:j]</code>) defaults to zero but the other
two indices must always be specified explicitly.
It is possible that future releases of Go may introduce default values for these indices.
</p>

<p>
Further details are in the
<a href="//golang.org/s/go12slice">design document</a>.
</p>

<p>
<em>Updating</em>:
This is a backwards-compatible change that affects no existing programs.
</p>

<h2 id="impl">Changes to the implementations and tools</h2>

<h3 id="preemption">Pre-emption in the scheduler</h3>

<p>
In prior releases, a goroutine that was looping forever could starve out other
goroutines on the same thread, a serious problem when GOMAXPROCS
provided only one user thread.
In Go 1.2, this is partially addressed: The scheduler is invoked occasionally
upon entry to a function.
This means that any loop that includes a (non-inlined) function call can
be pre-empted, allowing other goroutines to run on the same thread.
</p>

<h3 id="thread_limit">Limit on the number of threads</h3>

<p>
Go 1.2 introduces a configurable limit (default 10,000) to the total number of threads
a single program may have in its address space, to avoid resource starvation
issues in some environments.
Note that goroutines are multiplexed onto threads so this limit does not directly
limit the number of goroutines, only the number that may be simultaneously blocked
in a system call.
In practice, the limit is hard to reach.
</p>

<p>
The new <a href="/pkg/runtime/debug/#SetMaxThreads"><code>SetMaxThreads</code></a> function in the
<a href="/pkg/runtime/debug/"><code>runtime/debug</code></a> package controls the thread count limit.
</p>

<p>
<em>Updating</em>:
Few functions will be affected by the limit, but if a program dies because it hits the
limit, it could be modified to call <code>SetMaxThreads</code> to set a higher count.
Even better would be to refactor the program to need fewer threads, reducing consumption
of kernel resources.
</p>

<h3 id="stack_size">Stack size</h3>

<p>
In Go 1.2, the minimum size of the stack when a goroutine is created has been lifted from 4KB to 8KB.
Many programs were suffering performance problems with the old size, which had a tendency
to introduce expensive stack-segment switching in performance-critical sections.
The new number was determined by empirical testing.
</p>

<p>
At the other end, the new function <a href="/pkg/runtime/debug/#SetMaxStack"><code>SetMaxStack</code></a>
in the <a href="/pkg/runtime/debug"><code>runtime/debug</code></a> package controls
the <em>maximum</em> size of a single goroutine's stack.
The default is 1GB on 64-bit systems and 250MB on 32-bit systems.
Before Go 1.2, it was too easy for a runaway recursion to consume all the memory on a machine.
</p>

<p>
<em>Updating</em>:
The increased minimum stack size may cause programs with many goroutines to use
more memory. There is no workaround, but plans for future releases
include new stack management technology that should address the problem better.
</p>

<h3 id="cgo_and_cpp">Cgo and C++</h3>

<p>
The <a href="/cmd/cgo/"><code>cgo</code></a> command will now invoke the C++
compiler to build any pieces of the linked-to library that are written in C++;
<a href="/cmd/cgo/">the documentation</a> has more detail.
</p>

<h3 id="go_tools_godoc">Godoc and vet moved to the go.tools subrepository</h3>

<p>
Both binaries are still included with the distribution, but the source code for the
godoc and vet commands has moved to the
<a href="//code.google.com/p/go.tools">go.tools</a> subrepository.
</p>

<p>
Also, the core of the godoc program has been split into a
<a href="https://code.google.com/p/go/source/browse/?repo=tools#hg%2Fgodoc">library</a>,
while the command itself is in a separate
<a href="https://code.google.com/p/go/source/browse/?repo=tools#hg%2Fcmd%2Fgodoc">directory</a>.
The move allows the code to be updated easily and the separation into a library and command
makes it easier to construct custom binaries for local sites and different deployment methods.
</p>

<p>
<em>Updating</em>:
Since godoc and vet are not part of the library,
no client Go code depends on the their source and no updating is required.
</p>

<p>
The binary distributions available from <a href="//golang.org">golang.org</a>
include these binaries, so users of these distributions are unaffected.
</p>

<p>
When building from source, users must use "go get" to install godoc and vet.
(The binaries will continue to be installed in their usual locations, not
<code>$GOPATH/bin</code>.)
</p>

<pre>
$ go get code.google.com/p/go.tools/cmd/godoc
$ go get code.google.com/p/go.tools/cmd/vet
</pre>

<h3 id="gccgo">Status of gccgo</h3>

<p>
We expect the future GCC 4.9 release to include gccgo with full
support for Go 1.2.
In the current (4.8.2) release of GCC, gccgo implements Go 1.1.2.
</p>

<h3 id="gc_changes">Changes to the gc compiler and linker</h3>

<p>
Go 1.2 has several semantic changes to the workings of the gc compiler suite.
Most users will be unaffected by them.
</p>

<p>
The <a href="/cmd/cgo/"><code>cgo</code></a> command now
works when C++ is included in the library being linked against.
See the <a href="/cmd/cgo/"><code>cgo</code></a> documentation
for details.
</p>

<p>
The gc compiler displayed a vestigial detail of its origins when
a program had no <code>package</code> clause: it assumed
the file was in package <code>main</code>.
The past has been erased, and a missing <code>package</code> clause
is now an error.
</p>

<p>
On the ARM, the toolchain supports "external linking", which
is a step towards being able to build shared libraries with the gc
tool chain and to provide dynamic linking support for environments
in which that is necessary.
</p>

<p>
In the runtime for the ARM, with <code>5a</code>, it used to be possible to refer
to the runtime-internal <code>m</code> (machine) and <code>g</code>
(goroutine) variables using <code>R9</code> and <code>R10</code> directly.
It is now necessary to refer to them by their proper names.
</p>

<p>
Also on the ARM, the <code>5l</code> linker (sic) now defines the
<code>MOVBS</code> and <code>MOVHS</code> instructions
as synonyms of <code>MOVB</code> and <code>MOVH</code>,
to make clearer the separation between signed and unsigned
sub-word moves; the unsigned versions already existed with a
<code>U</code> suffix.
</p>

<h3 id="cover">Test coverage</h3>

<p>
One major new feature of <a href="/pkg/go/"><code>go test</code></a> is
that it can now compute and, with help from a new, separately installed
"go tool cover" program, display test coverage results.
</p>

<p>
The cover tool is part of the
<a href="https://code.google.com/p/go/source/checkout?repo=tools"><code>go.tools</code></a>
subrepository.
It can be installed by running
</p>

<pre>
$ go get code.google.com/p/go.tools/cmd/cover
</pre>

<p>
The cover tool does two things.
First, when "go test" is given the <code>-cover</code> flag, it is run automatically 
to rewrite the source for the package and insert instrumentation statements.
The test is then compiled and run as usual, and basic coverage statistics are reported:
</p>

<pre>
$ go test -cover fmt
ok  	fmt	0.060s	coverage: 91.4% of statements
$
</pre>

<p>
Second, for more detailed reports, different flags to "go test" can create a coverage profile file,
which the cover program, invoked with "go tool cover", can then analyze.
</p>

<p>
Details on how to generate and analyze coverage statistics can be found by running the commands
</p>

<pre>
$ go help testflag
$ go tool cover -help
</pre>

<h3 id="go_doc">The go doc command is deleted</h3>

<p>
The "go doc" command is deleted.
Note that the <a href="/cmd/godoc/"><code>godoc</code></a> tool itself is not deleted,
just the wrapping of it by the <a href="/cmd/go/"><code>go</code></a> command.
All it did was show the documents for a package by package path,
which godoc itself already does with more flexibility.
It has therefore been deleted to reduce the number of documentation tools and,
as part of the restructuring of godoc, encourage better options in future.
</p>

<p>
<em>Updating</em>: For those who still need the precise functionality of running
</p>

<pre>
$ go doc
</pre>

<p>
in a directory, the behavior is identical to running
</p>

<pre>
$ godoc .
</pre>

<h3 id="gocmd">Changes to the go command</h3>

<p>
The <a href="/cmd/go/"><code>go get</code></a> command
now has a <code>-t</code> flag that causes it to download the dependencies
of the tests run by the package, not just those of the package itself.
By default, as before, dependencies of the tests are not downloaded.
</p>

<h2 id="performance">Performance</h2>

<p>
There are a number of significant performance improvements in the standard library; here are a few of them.
</p>

<ul> 

<li>
The <a href="/pkg/compress/bzip2/"><code>compress/bzip2</code></a>
decompresses about 30% faster.
</li>

<li>
The <a href="/pkg/crypto/des/"><code>crypto/des</code></a> package
is about five times faster.
</li>

<li>
The <a href="/pkg/encoding/json/"><code>encoding/json</code></a> package
encodes about 30% faster.
</li>

<li>
Networking performance on Windows and BSD systems is about 30% faster through the use
of an integrated network poller in the runtime, similar to what was done for Linux and OS X
in Go 1.1.
</li>

</ul>

<h2 id="library">Changes to the standard library</h2>


<h3 id="archive_tar_zip">The archive/tar and archive/zip packages</h3>

<p>
The
<a href="/pkg/archive/tar/"><code>archive/tar</code></a>
and
<a href="/pkg/archive/zip/"><code>archive/zip</code></a>
packages have had a change to their semantics that may break existing programs.
The issue is that they both provided an implementation of the
<a href="/pkg/os/#FileInfo"><code>os.FileInfo</code></a>
interface that was not compliant with the specification for that interface.
In particular, their <code>Name</code> method returned the full
path name of the entry, but the interface specification requires that
the method return only the base name (final path element).
</p>

<p>
<em>Updating</em>: Since this behavior was newly implemented and
a bit obscure, it is possible that no code depends on the broken behavior.
If there are programs that do depend on it, they will need to be identified
and fixed manually.
</p>

<h3 id="encoding">The new encoding package</h3>

<p>
There is a new package, <a href="/pkg/encoding/"><code>encoding</code></a>,
that defines a set of standard encoding interfaces that may be used to
build custom marshalers and unmarshalers for packages such as
<a href="/pkg/encoding/xml/"><code>encoding/xml</code></a>,
<a href="/pkg/encoding/json/"><code>encoding/json</code></a>,
and
<a href="/pkg/encoding/binary/"><code>encoding/binary</code></a>.
These new interfaces have been used to tidy up some implementations in
the standard library.
</p>

<p>
The new interfaces are called
<a href="/pkg/encoding/#BinaryMarshaler"><code>BinaryMarshaler</code></a>,
<a href="/pkg/encoding/#BinaryUnmarshaler"><code>BinaryUnmarshaler</code></a>,
<a href="/pkg/encoding/#TextMarshaler"><code>TextMarshaler</code></a>,
and
<a href="/pkg/encoding/#TextUnmarshaler"><code>TextUnmarshaler</code></a>.
Full details are in the <a href="/pkg/encoding/">documentation</a> for the package
and a separate <a href="//golang.org/s/go12encoding">design document</a>.
</p>

<h3 id="fmt_indexed_arguments">The fmt package</h3>

<p>
The <a href="/pkg/fmt/"><code>fmt</code></a> package's formatted print
routines such as <a href="/pkg/fmt/#Printf"><code>Printf</code></a>
now allow the data items to be printed to be accessed in arbitrary order
by using an indexing operation in the formatting specifications.
Wherever an argument is to be fetched from the argument list for formatting,
either as the value to be formatted or as a width or specification integer,
a new optional indexing notation <code>[</code><em>n</em><code>]</code>
fetches argument <em>n</em> instead.
The value of <em>n</em> is 1-indexed.
After such an indexing operating, the next argument to be fetched by normal
processing will be <em>n</em>+1.
</p>

<p>
For example, the normal <code>Printf</code> call
</p>

<pre>
fmt.Sprintf("%c %c %c\n", 'a', 'b', 'c')
</pre>

<p>
would create the string <code>"a b c"</code>, but with indexing operations like this,
</p>

<pre>
fmt.Sprintf("%[3]c %[1]c %c\n", 'a', 'b', 'c')
</pre>

<p>
the result is "<code>"c a b"</code>. The <code>[3]</code> index accesses the third formatting
argument, which is <code>'c'</code>, <code>[1]</code> accesses the first, <code>'a'</code>,
and then the next fetch accesses the argument following that one, <code>'b'</code>.
</p>

<p>
The motivation for this feature is programmable format statements to access
the arguments in different order for localization, but it has other uses:
</p>

<pre>
log.Printf("trace: value %v of type %[1]T\n", expensiveFunction(a.b[c]))
</pre>

<p>
<em>Updating</em>: The change to the syntax of format specifications
is strictly backwards compatible, so it affects no working programs.
</p>

<h3 id="text_template">The text/template and html/template packages</h3>

<p>
The
<a href="/pkg/text/template/"><code>text/template</code></a> package
has a couple of changes in Go 1.2, both of which are also mirrored in the
<a href="/pkg/html/template/"><code>html/template</code></a> package.
</p>

<p>
First, there are new default functions for comparing basic types.
The functions are listed in this table, which shows their names and
the associated familiar comparison operator.
</p>

<table cellpadding="0" summary="Template comparison functions">
<tr>
<th width="50"></th><th width="100">Name</th> <th width="50">Operator</th>
</tr>
<tr>
<td></td><td><code>eq</code></td> <td><code>==</code></td>
</tr>
<tr>
<td></td><td><code>ne</code></td> <td><code>!=</code></td>
</tr>
<tr>
<td></td><td><code>lt</code></td> <td><code>&lt;</code></td>
</tr>
<tr>
<td></td><td><code>le</code></td> <td><code>&lt;=</code></td>
</tr>
<tr>
<td></td><td><code>gt</code></td> <td><code>&gt;</code></td>
</tr>
<tr>
<td></td><td><code>ge</code></td> <td><code>&gt;=</code></td>
</tr>
</table>

<p>
These functions behave slightly differently from the corresponding Go operators.
First, they operate only on basic types (<code>bool</code>, <code>int</code>,
<code>float64</code>, <code>string</code>, etc.).
(Go allows comparison of arrays and structs as well, under some circumstances.)
Second, values can be compared as long as they are the same sort of value:
any signed integer value can be compared to any other signed integer value for example. (Go
does not permit comparing an <code>int8</code> and an <code>int16</code>).
Finally, the <code>eq</code> function (only) allows comparison of the first
argument with one or more following arguments. The template in this example,
</p>

<pre>
{{"{{"}}if eq .A 1 2 3 {{"}}"}} equal {{"{{"}}else{{"}}"}} not equal {{"{{"}}end{{"}}"}}
</pre>

<p>
reports "equal" if <code>.A</code> is equal to <em>any</em> of 1, 2, or 3.
</p>

<p>
The second change is that a small addition to the grammar makes "if else if" chains easier to write.
Instead of writing,
</p>

<pre>
{{"{{"}}if eq .A 1{{"}}"}} X {{"{{"}}else{{"}}"}} {{"{{"}}if eq .A 2{{"}}"}} Y {{"{{"}}end{{"}}"}} {{"{{"}}end{{"}}"}} 
</pre>

<p>
one can fold the second "if" into the "else" and have only one "end", like this:
</p>

<pre>
{{"{{"}}if eq .A 1{{"}}"}} X {{"{{"}}else if eq .A 2{{"}}"}} Y {{"{{"}}end{{"}}"}}
</pre>

<p>
The two forms are identical in effect; the difference is just in the syntax.
</p>

<p>
<em>Updating</em>: Neither the "else if" change nor the comparison functions
affect existing programs. Those that
already define functions called <code>eq</code> and so on through a function
map are unaffected because the associated function map will override the new
default function definitions.
</p>

<h3 id="new_packages">New packages</h3>

<p>
There are two new packages.
</p>

<ul>
<li>
The <a href="/pkg/encoding/"><code>encoding</code></a> package is
<a href="#encoding">described above</a>.
</li>
<li>
The <a href="/pkg/image/color/palette/"><code>image/color/palette</code></a> package
provides standard color palettes.
</li>
</ul>

<h3 id="minor_library_changes">Minor changes to the library</h3>

<p>
The following list summarizes a number of minor changes to the library, mostly additions.
See the relevant package documentation for more information about each change.
</p>

<ul>

<li>
The <a href="/pkg/archive/zip/"><code>archive/zip</code></a> package
adds the
<a href="/pkg/archive/zip/#File.DataOffset"><code>DataOffset</code></a> accessor
to return the offset of a file's (possibly compressed) data within the archive.
</li>

<li>
The <a href="/pkg/bufio/"><code>bufio</code></a> package
adds <a href="/pkg/bufio/#Reader.Reset"><code>Reset</code></a>
methods to <a href="/pkg/bufio/#Reader"><code>Reader</code></a> and
<a href="/pkg/bufio/#Writer"><code>Writer</code></a>.
These methods allow the <a href="/pkg/io/#Reader"><code>Readers</code></a>
and <a href="/pkg/io/#Writer"><code>Writers</code></a>
to be re-used on new input and output readers and writers, saving
allocation overhead. 
</li>

<li>
The <a href="/pkg/compress/bzip2/"><code>compress/bzip2</code></a>
can now decompress concatenated archives.
</li>

<li>
The <a href="/pkg/compress/flate/"><code>compress/flate</code></a>
package adds a <a href="/pkg/compress/flate/#Writer.Reset"><code>Reset</code></a> 
method on the <a href="/pkg/compress/flate/#Writer"><code>Writer</code></a>,
to make it possible to reduce allocation when, for instance, constructing an
archive to hold multiple compressed files.
</li>

<li>
The <a href="/pkg/compress/gzip/"><code>compress/gzip</code></a> package's
<a href="/pkg/compress/gzip/#Writer"><code>Writer</code></a> type adds a
<a href="/pkg/compress/gzip/#Writer.Reset"><code>Reset</code></a>
so it may be reused.
</li>

<li>
The <a href="/pkg/compress/zlib/"><code>compress/zlib</code></a> package's
<a href="/pkg/compress/zlib/#Writer"><code>Writer</code></a> type adds a
<a href="/pkg/compress/zlib/#Writer.Reset"><code>Reset</code></a>
so it may be reused.
</li>

<li>
The <a href="/pkg/container/heap/"><code>container/heap</code></a> package
adds a <a href="/pkg/container/heap/#Fix"><code>Fix</code></a>
method to provide a more efficient way to update an item's position in the heap.
</li>

<li>
The <a href="/pkg/container/list/"><code>container/list</code></a> package
adds the <a href="/pkg/container/list/#List.MoveBefore"><code>MoveBefore</code></a>
and
<a href="/pkg/container/list/#List.MoveAfter"><code>MoveAfter</code></a>
methods, which implement the obvious rearrangement.
</li>

<li>
The <a href="/pkg/crypto/cipher/"><code>crypto/cipher</code></a> package
adds the a new GCM mode (Galois Counter Mode), which is almost always
used with AES encryption.
</li>

<li>
The 
<a href="/pkg/crypto/md5/"><code>crypto/md5</code></a> package
adds a new <a href="/pkg/crypto/md5/#Sum"><code>Sum</code></a> function
to simplify hashing without sacrificing performance.
</li>

<li>
Similarly, the 
<a href="/pkg/crypto/md5/"><code>crypto/sha1</code></a> package
adds a new <a href="/pkg/crypto/sha1/#Sum"><code>Sum</code></a> function.
</li>

<li>
Also, the
<a href="/pkg/crypto/sha256/"><code>crypto/sha256</code></a> package
adds <a href="/pkg/crypto/sha256/#Sum256"><code>Sum256</code></a>
and <a href="/pkg/crypto/sha256/#Sum224"><code>Sum224</code></a> functions.
</li>

<li>
Finally, the <a href="/pkg/crypto/sha512/"><code>crypto/sha512</code></a> package
adds <a href="/pkg/crypto/sha512/#Sum512"><code>Sum512</code></a> and
<a href="/pkg/crypto/sha512/#Sum384"><code>Sum384</code></a> functions.
</li>

<li>
The <a href="/pkg/crypto/x509/"><code>crypto/x509</code></a> package
adds support for reading and writing arbitrary extensions.
</li>

<li>
The <a href="/pkg/crypto/tls/"><code>crypto/tls</code></a> package adds
support for TLS 1.1, 1.2 and AES-GCM.
</li>

<li>
The <a href="/pkg/database/sql/"><code>database/sql</code></a> package adds a
<a href="/pkg/database/sql/#DB.SetMaxOpenConns"><code>SetMaxOpenConns</code></a>
method on <a href="/pkg/database/sql/#DB"><code>DB</code></a> to limit the
number of open connections to the database.
</li>

<li>
The <a href="/pkg/encoding/csv/"><code>encoding/csv</code></a> package
now always allows trailing commas on fields.
</li>

<li>
The <a href="/pkg/encoding/gob/"><code>encoding/gob</code></a> package
now treats channel and function fields of structures as if they were unexported,
even if they are not. That is, it ignores them completely. Previously they would
trigger an error, which could cause unexpected compatibility problems if an
embedded structure added such a field.
The package also now supports the generic <code>BinaryMarshaler</code> and
<code>BinaryUnmarshaler</code> interfaces of the
<a href="/pkg/encoding/"><code>encoding</code></a> package
described above.
</li>

<li>
The <a href="/pkg/encoding/json/"><code>encoding/json</code></a> package
now will always escape ampersands as "\u0026" when printing strings.
It will now accept but correct invalid UTF-8 in
<a href="/pkg/encoding/json/#Marshal"><code>Marshal</code></a>
(such input was previously rejected).
Finally, it now supports the generic encoding interfaces of the
<a href="/pkg/encoding/"><code>encoding</code></a> package
described above.
</li>

<li>
The <a href="/pkg/encoding/xml/"><code>encoding/xml</code></a> package
now allows attributes stored in pointers to be marshaled.
It also supports the generic encoding interfaces of the
<a href="/pkg/encoding/"><code>encoding</code></a> package
described above through the new
<a href="/pkg/encoding/xml/#Marshaler"><code>Marshaler</code></a>,
<a href="/pkg/encoding/xml/#Unmarshaler"><code>Unmarshaler</code></a>,
and related
<a href="/pkg/encoding/xml/#MarshalerAttr"><code>MarshalerAttr</code></a> and
<a href="/pkg/encoding/xml/#UnmarshalerAttr"><code>UnmarshalerAttr</code></a>
interfaces.
The package also adds a
<a href="/pkg/encoding/xml/#Encoder.Flush"><code>Flush</code></a> method
to the
<a href="/pkg/encoding/xml/#Encoder"><code>Encoder</code></a>
type for use by custom encoders. See the documentation for
<a href="/pkg/encoding/xml/#Encoder.EncodeToken"><code>EncodeToken</code></a>
to see how to use it.
</li>

<li>
The <a href="/pkg/flag/"><code>flag</code></a> package now
has a <a href="/pkg/flag/#Getter"><code>Getter</code></a> interface
to allow the value of a flag to be retrieved. Due to the
Go 1 compatibility guidelines, this method cannot be added to the existing
<a href="/pkg/flag/#Value"><code>Value</code></a>
interface, but all the existing standard flag types implement it.
The package also now exports the <a href="/pkg/flag/#CommandLine"><code>CommandLine</code></a>
flag set, which holds the flags from the command line.
</li>

<li>
The <a href="/pkg/go/ast/"><code>go/ast</code></a> package's
<a href="/pkg/go/ast/#SliceExpr"><code>SliceExpr</code></a> struct
has a new boolean field, <code>Slice3</code>, which is set to true
when representing a slice expression with three indices (two colons).
The default is false, representing the usual two-index form.
</li>

<li>
The <a href="/pkg/go/build/"><code>go/build</code></a> package adds
the <code>AllTags</code> field
to the <a href="/pkg/go/build/#Package"><code>Package</code></a> type,
to make it easier to process build tags.
</li>

<li>
The <a href="/pkg/image/draw/"><code>image/draw</code></a> package now
exports an interface, <a href="/pkg/image/draw/#Drawer"><code>Drawer</code></a>,
that wraps the standard <a href="/pkg/image/draw/#Draw"><code>Draw</code></a> method.
The Porter-Duff operators now implement this interface, in effect binding an operation to
the draw operator rather than providing it explicitly.
Given a paletted image as its destination, the new
<a href="/pkg/image/draw/#FloydSteinberg"><code>FloydSteinberg</code></a>
implementation of the
<a href="/pkg/image/draw/#Drawer"><code>Drawer</code></a>
interface will use the Floyd-Steinberg error diffusion algorithm to draw the image.
To create palettes suitable for such processing, the new
<a href="/pkg/image/draw/#Quantizer"><code>Quantizer</code></a> interface
represents implementations of quantization algorithms that choose a palette
given a full-color image.
There are no implementations of this interface in the library.
</li>

<li>
The <a href="/pkg/image/gif/"><code>image/gif</code></a> package
can now create GIF files using the new
<a href="/pkg/image/gif/#Encode"><code>Encode</code></a>
and <a href="/pkg/image/gif/#EncodeAll"><code>EncodeAll</code></a>
functions.
Their options argument allows specification of an image
<a href="/pkg/image/draw/#Quantizer"><code>Quantizer</code></a> to use;
if it is <code>nil</code>, the generated GIF will use the 
<a href="/pkg/image/color/palette/#Plan9"><code>Plan9</code></a>
color map (palette) defined in the new
<a href="/pkg/image/color/palette/"><code>image/color/palette</code></a> package.
The options also specify a
<a href="/pkg/image/draw/#Drawer"><code>Drawer</code></a>
to use to create the output image;
if it is <code>nil</code>, Floyd-Steinberg error diffusion is used.
</li>

<li>
The <a href="/pkg/io/#Copy"><code>Copy</code></a> method of the
<a href="/pkg/io/"><code>io</code></a> package now prioritizes its
arguments differently.
If one argument implements <a href="/pkg/io/#WriterTo"><code>WriterTo</code></a>
and the other implements <a href="/pkg/io/#ReaderFrom"><code>ReaderFrom</code></a>,
<a href="/pkg/io/#Copy"><code>Copy</code></a> will now invoke
<a href="/pkg/io/#WriterTo"><code>WriterTo</code></a> to do the work,
so that less intermediate buffering is required in general.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package requires cgo by default
because the host operating system must in general mediate network call setup.
On some systems, though, it is possible to use the network without cgo, and useful
to do so, for instance to avoid dynamic linking.
The new build tag <code>netgo</code> (off by default) allows the construction of a
<code>net</code> package in pure Go on those systems where it is possible.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package adds a new field
<code>DualStack</code> to the <a href="/pkg/net/#Dialer"><code>Dialer</code></a>
struct for TCP connection setup using a dual IP stack as described in
<a href="http://tools.ietf.org/html/rfc6555">RFC 6555</a>.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package will no longer
transmit cookies that are incorrect according to
<a href="http://tools.ietf.org/html/rfc6265">RFC 6265</a>.
It just logs an error and sends nothing.
Also,
the <a href="/pkg/net/http/"><code>net/http</code></a> package's
<a href="/pkg/net/http/#ReadResponse"><code>ReadResponse</code></a>
function now permits the <code>*Request</code> parameter to be <code>nil</code>,
whereupon it assumes a GET request.
Finally, an HTTP server will now serve HEAD
requests transparently, without the need for special casing in handler code.
While serving a HEAD request, writes to a 
<a href="/pkg/net/http/#Handler"><code>Handler</code></a>'s
<a href="/pkg/net/http/#ResponseWriter"><code>ResponseWriter</code></a>
are absorbed by the
<a href="/pkg/net/http/#Server"><code>Server</code></a>
and the client receives an empty body as required by the HTTP specification.
</li>

<li>
The <a href="/pkg/os/exec/"><code>os/exec</code></a> package's 
<a href="/pkg/os/exec/#Cmd.StdinPipe"><code>Cmd.StdinPipe</code></a> method 
returns an <code>io.WriteCloser</code>, but has changed its concrete
implementation from <code>*os.File</code> to an unexported type that embeds
<code>*os.File</code>, and it is now safe to close the returned value.
Before Go 1.2, there was an unavoidable race that this change fixes.
Code that needs access to the methods of <code>*os.File</code> can use an
interface type assertion, such as <code>wc.(interface{ Sync() error })</code>.
</li>

<li>
The <a href="/pkg/runtime/"><code>runtime</code></a> package relaxes
the constraints on finalizer functions in
<a href="/pkg/runtime/#SetFinalizer"><code>SetFinalizer</code></a>: the
actual argument can now be any type that is assignable to the formal type of
the function, as is the case for any normal function call in Go.
</li>

<li>
The <a href="/pkg/sort/"><code>sort</code></a> package has a new
<a href="/pkg/sort/#Stable"><code>Stable</code></a> function that implements
stable sorting. It is less efficient than the normal sort algorithm, however.
</li>

<li>
The <a href="/pkg/strings/"><code>strings</code></a> package adds
an <a href="/pkg/strings/#IndexByte"><code>IndexByte</code></a>
function for consistency with the <a href="/pkg/bytes/"><code>bytes</code></a> package.
</li>

<li>
The <a href="/pkg/sync/atomic/"><code>sync/atomic</code></a> package
adds a new set of swap functions that atomically exchange the argument with the
value stored in the pointer, returning the old value.
The functions are
<a href="/pkg/sync/atomic/#SwapInt32"><code>SwapInt32</code></a>,
<a href="/pkg/sync/atomic/#SwapInt64"><code>SwapInt64</code></a>,
<a href="/pkg/sync/atomic/#SwapUint32"><code>SwapUint32</code></a>,
<a href="/pkg/sync/atomic/#SwapUint64"><code>SwapUint64</code></a>,
<a href="/pkg/sync/atomic/#SwapUintptr"><code>SwapUintptr</code></a>,
and
<a href="/pkg/sync/atomic/#SwapPointer"><code>SwapPointer</code></a>,
which swaps an <code>unsafe.Pointer</code>.
</li>

<li>
The <a href="/pkg/syscall/"><code>syscall</code></a> package now implements
<a href="/pkg/syscall/#Sendfile"><code>Sendfile</code></a> for Darwin.
</li>

<li>
The <a href="/pkg/testing/"><code>testing</code></a> package
now exports the <a href="/pkg/testing/#TB"><code>TB</code></a> interface.
It records the methods in common with the
<a href="/pkg/testing/#T"><code>T</code></a>
and
<a href="/pkg/testing/#B"><code>B</code></a> types,
to make it easier to share code between tests and benchmarks.
Also, the
<a href="/pkg/testing/#AllocsPerRun"><code>AllocsPerRun</code></a>
function now quantizes the return value to an integer (although it
still has type <code>float64</code>), to round off any error caused by
initialization and make the result more repeatable. 
</li>

<li>
The <a href="/pkg/text/template/"><code>text/template</code></a> package
now automatically dereferences pointer values when evaluating the arguments
to "escape" functions such as "html", to bring the behavior of such functions
in agreement with that of other printing functions such as "printf".
</li>

<li>
In the <a href="/pkg/time/"><code>time</code></a> package, the
<a href="/pkg/time/#Parse"><code>Parse</code></a> function
and
<a href="/pkg/time/#Time.Format"><code>Format</code></a>
method
now handle time zone offsets with seconds, such as in the historical
date "1871-01-01T05:33:02+00:34:08".
Also, pattern matching in the formats for those routines is stricter: a non-lowercase letter
must now follow the standard words such as "Jan" and "Mon".
</li>

<li>
The <a href="/pkg/unicode/"><code>unicode</code></a> package
adds <a href="/pkg/unicode/#In"><code>In</code></a>,
a nicer-to-use but equivalent version of the original
<a href="/pkg/unicode/#IsOneOf"><code>IsOneOf</code></a>,
to see whether a character is a member of a Unicode category.
</li>

</ul>
                                                                                                                                                                                                                                                                                                                                         root/go1.4/doc/go1.3.html                                                                           0100644 0000000 0000000 00000055115 12600426226 013351  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Go 1.3 Release Notes",
	"Path":  "/doc/go1.3",
	"Template": true
}-->

<h2 id="introduction">Introduction to Go 1.3</h2>

<p>
The latest Go release, version 1.3, arrives six months after 1.2,
and contains no language changes.
It focuses primarily on implementation work, providing 
precise garbage collection,
a major refactoring of the compiler tool chain that results in
faster builds, especially for large projects,
significant performance improvements across the board,
and support for DragonFly BSD, Solaris, Plan 9 and Google's Native Client architecture (NaCl).
It also has an important refinement to the memory model regarding synchronization.
As always, Go 1.3 keeps the <a href="/doc/go1compat.html">promise
of compatibility</a>,
and almost everything 
will continue to compile and run without change when moved to 1.3.
</p>

<h2 id="os">Changes to the supported operating systems and architectures</h2>

<h3 id="win2000">Removal of support for Windows 2000</h3>

<p>
Microsoft stopped supporting Windows 2000 in 2010.
Since it has <a href="https://codereview.appspot.com/74790043">implementation difficulties</a>
regarding exception handling (signals in Unix terminology),
as of Go 1.3 it is not supported by Go either.
</p>

<h3 id="dragonfly">Support for DragonFly BSD</h3>

<p>
Go 1.3 now includes experimental support for DragonFly BSD on the <code>amd64</code> (64-bit x86) and <code>386</code> (32-bit x86) architectures.
It uses DragonFly BSD 3.6 or above.
</p>

<h3 id="freebsd">Support for FreeBSD</h3>

<p>
It was not announced at the time, but since the release of Go 1.2, support for Go on FreeBSD
requires FreeBSD 8 or above.
</p>

<p>
As of Go 1.3, support for Go on FreeBSD requires that the kernel be compiled with the
<code>COMPAT_FREEBSD32</code> flag configured.
</p>

<p>
In concert with the switch to EABI syscalls for ARM platforms, Go 1.3 will run only on FreeBSD 10.
The x86 platforms, 386 and amd64, are unaffected.
</p>

<h3 id="nacl">Support for Native Client</h3>

<p>
Support for the Native Client virtual machine architecture has returned to Go with the 1.3 release.
It runs on the 32-bit Intel architectures (<code>GOARCH=386</code>) and also on 64-bit Intel, but using
32-bit pointers (<code>GOARCH=amd64p32</code>).
There is not yet support for Native Client on ARM.
Note that this is Native Client (NaCl), not Portable Native Client (PNaCl).
Details about Native Client are <a href="https://developers.google.com/native-client/dev/">here</a>;
how to set up the Go version is described <a href="//golang.org/wiki/NativeClient">here</a>.
</p>

<h3 id="netbsd">Support for NetBSD</h3>

<p>
As of Go 1.3, support for Go on NetBSD requires NetBSD 6.0 or above.
</p>

<h3 id="openbsd">Support for OpenBSD</h3>

<p>
As of Go 1.3, support for Go on OpenBSD requires OpenBSD 5.5 or above.
</p>

<h3 id="plan9">Support for Plan 9</h3>

<p>
Go 1.3 now includes experimental support for Plan 9 on the <code>386</code> (32-bit x86) architecture.
It requires the <code>Tsemacquire</code> syscall, which has been in Plan 9 since June, 2012.
</p>

<h3 id="solaris">Support for Solaris</h3>

<p>
Go 1.3 now includes experimental support for Solaris on the <code>amd64</code> (64-bit x86) architecture.
It requires illumos, Solaris 11 or above.
</p>

<h2 id="memory">Changes to the memory model</h2>

<p>
The Go 1.3 memory model <a href="https://codereview.appspot.com/75130045">adds a new rule</a>
concerning sending and receiving on buffered channels,
to make explicit that a buffered channel can be used as a simple
semaphore, using a send into the
channel to acquire and a receive from the channel to release.
This is not a language change, just a clarification about an expected property of communication.
</p>

<h2 id="impl">Changes to the implementations and tools</h2>

<h3 id="stacks">Stack</h3>

<p>
Go 1.3 has changed the implementation of goroutine stacks away from the old,
"segmented" model to a contiguous model.
When a goroutine needs more stack
than is available, its stack is transferred to a larger single block of memory.
The overhead of this transfer operation amortizes well and eliminates the old "hot spot"
problem when a calculation repeatedly steps across a segment boundary.
Details including performance numbers are in this
<a href="//golang.org/s/contigstacks">design document</a>.
</p>

<h3 id="garbage_collector">Changes to the garbage collector</h3>

<p>
For a while now, the garbage collector has been <em>precise</em> when examining
values in the heap; the Go 1.3 release adds equivalent precision to values on the stack.
This means that a non-pointer Go value such as an integer will never be mistaken for a
pointer and prevent unused memory from being reclaimed.
</p>

<p>
Starting with Go 1.3, the runtime assumes that values with pointer type
contain pointers and other values do not.
This assumption is fundamental to the precise behavior of both stack expansion
and garbage collection.
Programs that use <a href="/pkg/unsafe/">package unsafe</a>
to store integers in pointer-typed values are illegal and will crash if the runtime detects the behavior.
Programs that use <a href="/pkg/unsafe/">package unsafe</a> to store pointers
in integer-typed values are also illegal but more difficult to diagnose during execution.
Because the pointers are hidden from the runtime, a stack expansion or garbage collection
may reclaim the memory they point at, creating
<a href="//en.wikipedia.org/wiki/Dangling_pointer">dangling pointers</a>.
</p>

<p>
<em>Updating</em>: Code that uses <code>unsafe.Pointer</code> to convert
an integer-typed value held in memory into a pointer is illegal and must be rewritten.
Such code can be identified by <code>go vet</code>.
</p>

<h3 id="map">Map iteration</h3>

<p>
Iterations over small maps no longer happen in a consistent order.
Go 1 defines that &ldquo;<a href="//golang.org/ref/spec#For_statements">The iteration order over maps
is not specified and is not guaranteed to be the same from one iteration to the next.</a>&rdquo;
To keep code from depending on map iteration order,
Go 1.0 started each map iteration at a random index in the map.
A new map implementation introduced in Go 1.1 neglected to randomize
iteration for maps with eight or fewer entries, although the iteration order
can still vary from system to system.
This has allowed people to write Go 1.1 and Go 1.2 programs that
depend on small map iteration order and therefore only work reliably on certain systems.
Go 1.3 reintroduces random iteration for small maps in order to flush out these bugs.
</p>

<p>
<em>Updating</em>: If code assumes a fixed iteration order for small maps,
it will break and must be rewritten not to make that assumption.
Because only small maps are affected, the problem arises most often in tests.
</p>

<h3 id="liblink">The linker</h3>

<p>
As part of the general <a href="//golang.org/s/go13linker">overhaul</a> to
the Go linker, the compilers and linkers have been refactored.
The linker is still a C program, but now the instruction selection phase that
was part of the linker has been moved to the compiler through the creation of a new
library called <code>liblink</code>.
By doing instruction selection only once, when the package is first compiled,
this can speed up compilation of large projects significantly.
</p>

<p>
<em>Updating</em>: Although this is a major internal change, it should have no
effect on programs.
</p>

<h3 id="gccgo">Status of gccgo</h3>

<p>
GCC release 4.9 will contain the Go 1.2 (not 1.3) version of gccgo.
The release schedules for the GCC and Go projects do not coincide,
which means that 1.3 will be available in the development branch but
that the next GCC release, 4.10, will likely have the Go 1.4 version of gccgo.
</p>

<h3 id="gocmd">Changes to the go command</h3>

<p>
The <a href="/cmd/go/"><code>cmd/go</code></a> command has several new
features.
The <a href="/cmd/go/"><code>go run</code></a> and
<a href="/cmd/go/"><code>go test</code></a> subcommands
support a new <code>-exec</code> option to specify an alternate
way to run the resulting binary.
Its immediate purpose is to support NaCl.
</p>

<p>
The test coverage support of the <a href="/cmd/go/"><code>go test</code></a>
subcommand now automatically sets the coverage mode to <code>-atomic</code>
when the race detector is enabled, to eliminate false reports about unsafe
access to coverage counters.
</p>

<p>
The <a href="/cmd/go/"><code>go test</code></a> subcommand
now always builds the package, even if it has no test files.
Previously, it would do nothing if no test files were present.
</p>

<p>
The <a href="/cmd/go/"><code>go build</code></a> subcommand
supports a new <code>-i</code> option to install dependencies
of the specified target, but not the target itself.
</p>

<p>
Cross compiling with <a href="/cmd/cgo/"><code>cgo</code></a> enabled
is now supported.
The CC_FOR_TARGET and CXX_FOR_TARGET environment
variables are used when running all.bash to specify the cross compilers
for C and C++ code, respectively.
</p>

<p>
Finally, the go command now supports packages that import Objective-C
files (suffixed <code>.m</code>) through cgo.
</p>

<h3 id="cgo">Changes to cgo</h3>

<p>
The <a href="/cmd/cgo/"><code>cmd/cgo</code></a> command,
which processes <code>import "C"</code> declarations in Go packages,
has corrected a serious bug that may cause some packages to stop compiling.
Previously, all pointers to incomplete struct types translated to the Go type <code>*[0]byte</code>,
with the effect that the Go compiler could not diagnose passing one kind of struct pointer
to a function expecting another.
Go 1.3 corrects this mistake by translating each different
incomplete struct to a different named type.
</p>

<p>
Given the C declaration <code>typedef struct S T</code> for an incomplete <code>struct S</code>,
some Go code used this bug to refer to the types <code>C.struct_S</code> and <code>C.T</code> interchangeably.
Cgo now explicitly allows this use, even for completed struct types.
However, some Go code also used this bug to pass (for example) a <code>*C.FILE</code>
from one package to another.
This is not legal and no longer works: in general Go packages
should avoid exposing C types and names in their APIs.
</p>

<p>
<em>Updating</em>: Code confusing pointers to incomplete types or
passing them across package boundaries will no longer compile
and must be rewritten.
If the conversion is correct and must be preserved,
use an explicit conversion via <a href="/pkg/unsafe/#Pointer"><code>unsafe.Pointer</code></a>.
</p>

<h3 id="swig">SWIG 3.0 required for programs that use SWIG</h3>

<p>
For Go programs that use SWIG, SWIG version 3.0 is now required.
The <a href="/cmd/go"><code>cmd/go</code></a> command will now link the
SWIG generated object files directly into the binary, rather than
building and linking with a shared library.
</p>

<h3 id="gc_flag">Command-line flag parsing</h3>

<p>
In the gc tool chain, the assemblers now use the
same command-line flag parsing rules as the Go flag package, a departure
from the traditional Unix flag parsing.
This may affect scripts that invoke the tool directly.
For example,
<code>go tool 6a -SDfoo</code> must now be written
<code>go tool 6a -S -D foo</code>.
(The same change was made to the compilers and linkers in <a href="/doc/go1.1#gc_flag">Go 1.1</a>.)
</p>

<h3 id="godoc">Changes to godoc</h3>
<p>
When invoked with the <code>-analysis</code> flag, 
<a href="//godoc.org/golang.org/x/tools/cmd/godoc">godoc</a>
now performs sophisticated <a href="/lib/godoc/analysis/help.html">static
analysis</a> of the code it indexes.  
The results of analysis are presented in both the source view and the
package documentation view, and include the call graph of each package
and the relationships between 
definitions and references,
types and their methods,
interfaces and their implementations,
send and receive operations on channels,
functions and their callers, and
call sites and their callees.
</p>

<h3 id="misc">Miscellany</h3>

<p>
The program <code>misc/benchcmp</code> that compares
performance across benchmarking runs has been rewritten.
Once a shell and awk script in the main repository, it is now a Go program in the <code>go.tools</code> repo.
Documentation is <a href="//godoc.org/golang.org/x/tools/cmd/benchcmp">here</a>.
</p>

<p>
For the few of us that build Go distributions, the tool <code>misc/dist</code> has been
moved and renamed; it now lives in <code>misc/makerelease</code>, still in the main repository.
</p>

<h2 id="performance">Performance</h2>

<p>
The performance of Go binaries for this release has improved in many cases due to changes
in the runtime and garbage collection, plus some changes to libraries.
Significant instances include:
</p>

<ul> 

<li>
The runtime handles defers more efficiently, reducing the memory footprint by about two kilobytes
per goroutine that calls defer.
</li>

<li>
The garbage collector has been sped up, using a concurrent sweep algorithm,
better parallelization, and larger pages.
The cumulative effect can be a 50-70% reduction in collector pause time.
</li>

<li>
The race detector (see <a href="/doc/articles/race_detector.html">this guide</a>)
is now about 40% faster.
</li>

<li>
The regular expression package <a href="/pkg/regexp/"><code>regexp</code></a>
is now significantly faster for certain simple expressions due to the implementation of
a second, one-pass execution engine.
The choice of which engine to use is automatic;
the details are hidden from the user.
</li>

</ul>

<p>
Also, the runtime now includes in stack dumps how long a goroutine has been blocked,
which can be useful information when debugging deadlocks or performance issues.
</p>

<h2 id="library">Changes to the standard library</h2>

<h3 id="new_packages">New packages</h3>

<p>
A new package <a href="/pkg/debug/plan9obj/"><code>debug/plan9obj</code></a> was added to the standard library.
It implements access to Plan 9 <a href="http://plan9.bell-labs.com/magic/man2html/6/a.out">a.out</a> object files.
</p>

<h3 id="major_library_changes">Major changes to the library</h3>

<p>
A previous bug in <a href="/pkg/crypto/tls/"><code>crypto/tls</code></a>
made it possible to skip verification in TLS inadvertently.
In Go 1.3, the bug is fixed: one must specify either ServerName or
InsecureSkipVerify, and if ServerName is specified it is enforced.
This may break existing code that incorrectly depended on insecure
behavior.
</p>

<p>
There is an important new type added to the standard library: <a href="/pkg/sync/#Pool"><code>sync.Pool</code></a>.
It provides an efficient mechanism for implementing certain types of caches whose memory
can be reclaimed automatically by the system.
</p>

<p>
The <a href="/pkg/testing/"><code>testing</code></a> package's benchmarking helper,
<a href="/pkg/testing/#B"><code>B</code></a>, now has a
<a href="/pkg/testing/#B.RunParallel"><code>RunParallel</code></a> method
to make it easier to run benchmarks that exercise multiple CPUs.
</p>

<p>
<em>Updating</em>: The crypto/tls fix may break existing code, but such
code was erroneous and should be updated.
</p>

<h3 id="minor_library_changes">Minor changes to the library</h3>

<p>
The following list summarizes a number of minor changes to the library, mostly additions.
See the relevant package documentation for more information about each change.
</p>

<ul>

<li> In the <a href="/pkg/crypto/tls/"><code>crypto/tls</code></a> package,
a new <a href="/pkg/crypto/tls/#DialWithDialer"><code>DialWithDialer</code></a>
function lets one establish a TLS connection using an existing dialer, making it easier
to control dial options such as timeouts.
The package also now reports the TLS version used by the connection in the
<a href="/pkg/crypto/tls/#ConnectionState"><code>ConnectionState</code></a>
struct.
</li>

<li> The <a href="/pkg/crypto/x509/#CreateCertificate"><code>CreateCertificate</code></a>
function of the <a href="/pkg/crypto/tls/"><code>crypto/tls</code></a> package
now supports parsing (and elsewhere, serialization) of PKCS #10 certificate
signature requests.
</li>

<li>
The formatted print functions of the <code>fmt</code> package now define <code>%F</code>
as a synonym for <code>%f</code> when printing floating-point values.
</li>

<li>
The <a href="/pkg/math/big/"><code>math/big</code></a> package's
<a href="/pkg/math/big/#Int"><code>Int</code></a> and
<a href="/pkg/math/big/#Rat"><code>Rat</code></a> types
now implement
<a href="/pkg/encoding/#TextMarshaler"><code>encoding.TextMarshaler</code></a> and
<a href="/pkg/encoding/#TextUnmarshaler"><code>encoding.TextUnmarshaler</code></a>.
</li>

<li>
The complex power function, <a href="/pkg/math/cmplx/#Pow"><code>Pow</code></a>,
now specifies the behavior when the first argument is zero.
It was undefined before.
The details are in the <a href="/pkg/math/cmplx/#Pow">documentation for the function</a>.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package now exposes the
properties of a TLS connection used to make a client request in the new
<a href="/pkg/net/http/#Response"><code>Response.TLS</code></a> field.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package now
allows setting an optional server error logger
with <a href="/pkg/net/http/#Server"><code>Server.ErrorLog</code></a>.
The default is still that all errors go to stderr.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package now
supports disabling HTTP keep-alive connections on the server
with <a href="/pkg/net/http/#Server.SetKeepAlivesEnabled"><code>Server.SetKeepAlivesEnabled</code></a>.
The default continues to be that the server does keep-alive (reuses
connections for multiple requests) by default.
Only resource-constrained servers or those in the process of graceful
shutdown will want to disable them.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package adds an optional
<a href="/pkg/net/http/#Transport"><code>Transport.TLSHandshakeTimeout</code></a>
setting to cap the amount of time HTTP client requests will wait for
TLS handshakes to complete.
It's now also set by default
on <a href="/pkg/net/http#DefaultTransport"><code>DefaultTransport</code></a>.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package's
<a href="/pkg/net/http/#DefaultTransport"><code>DefaultTransport</code></a>,
used by the HTTP client code, now
enables <a href="http://en.wikipedia.org/wiki/Keepalive#TCP_keepalive">TCP
keep-alives</a> by default.
Other <a href="/pkg/net/http/#Transport"><code>Transport</code></a>
values with a nil <code>Dial</code> field continue to function the same
as before: no TCP keep-alives are used.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package
now enables <a href="http://en.wikipedia.org/wiki/Keepalive#TCP_keepalive">TCP
keep-alives</a> for incoming server requests when
<a href="/pkg/net/http/#ListenAndServe"><code>ListenAndServe</code></a>
or
<a href="/pkg/net/http/#ListenAndServeTLS"><code>ListenAndServeTLS</code></a>
are used.
When a server is started otherwise, TCP keep-alives are not enabled.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package now
provides an
optional <a href="/pkg/net/http/#Server"><code>Server.ConnState</code></a>
callback to hook various phases of a server connection's lifecycle
(see <a href="/pkg/net/http/#ConnState"><code>ConnState</code></a>).
This can be used to implement rate limiting or graceful shutdown.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package's HTTP
client now has an
optional <a href="/pkg/net/http/#Client"><code>Client.Timeout</code></a>
field to specify an end-to-end timeout on requests made using the
client.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package's
<a href="/pkg/net/http/#Request.ParseMultipartForm"><code>Request.ParseMultipartForm</code></a>
method will now return an error if the body's <code>Content-Type</code>
is not <code>mutipart/form-data</code>.
Prior to Go 1.3 it would silently fail and return <code>nil</code>.
Code that relies on the previous behavior should be updated.
</li>

<li> In the <a href="/pkg/net/"><code>net</code></a> package,
the <a href="/pkg/net/#Dialer"><code>Dialer</code></a> struct now
has a <code>KeepAlive</code> option to specify a keep-alive period for the connection.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package's 
<a href="/pkg/net/http/#Transport"><code>Transport</code></a>
now closes <a href="/pkg/net/http/#Request"><code>Request.Body</code></a>
consistently, even on error.
</li>

<li>
The <a href="/pkg/os/exec/"><code>os/exec</code></a> package now implements
what the documentation has always said with regard to relative paths for the binary.
In particular, it only calls <a href="/pkg/os/exec/#LookPath"><code>LookPath</code></a>
when the binary's file name contains no path separators.
</li>

<li>
The <a href="/pkg/reflect/#Value.SetMapIndex"><code>SetMapIndex</code></a>
function in the <a href="/pkg/reflect/"><code>reflect</code></a> package
no longer panics when deleting from a <code>nil</code> map.
</li>

<li>
If the main goroutine calls 
<a href="/pkg/runtime/#Goexit"><code>runtime.Goexit</code></a>
and all other goroutines finish execution, the program now always crashes,
reporting a detected deadlock.
Earlier versions of Go handled this situation inconsistently: most instances
were reported as deadlocks, but some trivial cases exited cleanly instead.
</li>

<li>
The runtime/debug package now has a new function
<a href="/pkg/runtime/debug/#WriteHeapDump"><code>debug.WriteHeapDump</code></a>
that writes out a description of the heap.
</li>

<li>
The <a href="/pkg/strconv/#CanBackquote"><code>CanBackquote</code></a>
function in the <a href="/pkg/strconv/"><code>strconv</code></a> package
now considers the <code>DEL</code> character, <code>U+007F</code>, to be
non-printing.
</li>

<li>
The <a href="/pkg/syscall/"><code>syscall</code></a> package now provides
<a href="/pkg/syscall/#SendmsgN"><code>SendmsgN</code></a>
as an alternate version of
<a href="/pkg/syscall/#Sendmsg"><code>Sendmsg</code></a>
that returns the number of bytes written.
</li>

<li>
On Windows, the <a href="/pkg/syscall/"><code>syscall</code></a> package now
supports the cdecl calling convention through the addition of a new function
<a href="/pkg/syscall/#NewCallbackCDecl"><code>NewCallbackCDecl</code></a>
alongside the existing function
<a href="/pkg/syscall/#NewCallback"><code>NewCallback</code></a>.
</li>

<li>
The <a href="/pkg/testing/"><code>testing</code></a> package now
diagnoses tests that call <code>panic(nil)</code>, which are almost always erroneous.
Also, tests now write profiles (if invoked with profiling flags) even on failure.
</li>

<li>
The <a href="/pkg/unicode/"><code>unicode</code></a> package and associated
support throughout the system has been upgraded from
Unicode 6.2.0 to <a href="http://www.unicode.org/versions/Unicode6.3.0/">Unicode 6.3.0</a>.
</li>

</ul>
                                                                                                                                                                                                                                                                                                                                                                                                                                                   root/go1.4/doc/go1.4.html                                                                           0100644 0000000 0000000 00000101371 12600426226 013346  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Go 1.4 Release Notes",
	"Path":  "/doc/go1.4",
	"Template": true
}-->

<h2 id="introduction">Introduction to Go 1.4</h2>

<p>
The latest Go release, version 1.4, arrives as scheduled six months after 1.3.
</p>

<p>
It contains only one tiny language change,
in the form of a backwards-compatible simple variant of <code>for</code>-<code>range</code> loop,
and a possibly breaking change to the compiler involving methods on pointers-to-pointers.
</p>

<p>
The release focuses primarily on implementation work, improving the garbage collector
and preparing the ground for a fully concurrent collector to be rolled out in the
next few releases.
Stacks are now contiguous, reallocated when necessary rather than linking on new
"segments";
this release therefore eliminates the notorious "hot stack split" problem.
There are some new tools available including support in the <code>go</code> command
for build-time source code generation.
The release also adds support for ARM processors on Android and Native Client (NaCl)
and for AMD64 on Plan 9.
</p>

<p>
As always, Go 1.4 keeps the <a href="/doc/go1compat.html">promise
of compatibility</a>,
and almost everything 
will continue to compile and run without change when moved to 1.4.
</p>

<h2 id="language">Changes to the language</h2>

<h3 id="forrange">For-range loops</h3>
<p>
Up until Go 1.3, <code>for</code>-<code>range</code> loop had two forms
</p>

<pre>
for i, v := range x {
	...
}
</pre>

<p>
and
</p>

<pre>
for i := range x {
	...
}
</pre>

<p>
If one was not interested in the loop values, only the iteration itself, it was still
necessary to mention a variable (probably the <a href="/ref/spec#Blank_identifier">blank identifier</a>, as in
<code>for</code> <code>_</code> <code>=</code> <code>range</code> <code>x</code>), because
the form
</p>

<pre>
for range x {
	...
}
</pre>

<p>
was not syntactically permitted.
</p>

<p>
This situation seemed awkward, so as of Go 1.4 the variable-free form is now legal.
The pattern arises rarely but the code can be cleaner when it does.
</p>

<p>
<em>Updating</em>: The change is strictly backwards compatible to existing Go
programs, but tools that analyze Go parse trees may need to be modified to accept
this new form as the
<code>Key</code> field of <a href="/pkg/go/ast/#RangeStmt"><code>RangeStmt</code></a>
may now be <code>nil</code>.
</p>

<h3 id="methodonpointertopointer">Method calls on **T</h3>

<p>
Given these declarations,
</p>

<pre>
type T int
func (T) M() {}
var x **T
</pre>

<p>
both <code>gc</code> and <code>gccgo</code> accepted the method call
</p>

<pre>
x.M()
</pre>

<p>
which is a double dereference of the pointer-to-pointer <code>x</code>.
The Go specification allows a single dereference to be inserted automatically,
but not two, so this call is erroneous according to the language definition.
It has therefore been disallowed in Go 1.4, which is a breaking change,
although very few programs will be affected.
</p>

<p>
<em>Updating</em>: Code that depends on the old, erroneous behavior will no longer
compile but is easy to fix by adding an explicit dereference.
</p>

<h2 id="os">Changes to the supported operating systems and architectures</h2>

<h3 id="android">Android</h3>

<p>
Go 1.4 can build binaries for ARM processors running the Android operating system.
It can also build a <code>.so</code> library that can be loaded by an Android application
using the supporting packages in the <a href="https://golang.org/x/mobile">mobile</a> subrepository.
A brief description of the plans for this experimental port are available
<a href="https://golang.org/s/go14android">here</a>.
</p>

<h3 id="naclarm">NaCl on ARM</h3>

<p>
The previous release introduced Native Client (NaCl) support for the 32-bit x86
(<code>GOARCH=386</code>)
and 64-bit x86 using 32-bit pointers (GOARCH=amd64p32).
The 1.4 release adds NaCl support for ARM (GOARCH=arm).
</p>

<h3 id="plan9amd64">Plan9 on AMD64</h3>

<p>
This release adds support for the Plan 9 operating system on AMD64 processors,
provided the kernel supports the <code>nsec</code> system call and uses 4K pages.
</p>

<h2 id="compatibility">Changes to the compatibility guidelines</h2>

<p>
The <a href="/pkg/unsafe/"><code>unsafe</code></a> package allows one
to defeat Go's type system by exploiting internal details of the implementation
or machine representation of data.
It was never explicitly specified what use of <code>unsafe</code> meant
with respect to compatibility as specified in the
<a href="go1compat.html">Go compatibility guidelines</a>.
The answer, of course, is that we can make no promise of compatibility
for code that does unsafe things.
</p>

<p>
We have clarified this situation in the documentation included in the release.
The <a href="go1compat.html">Go compatibility guidelines</a> and the
docs for the <a href="/pkg/unsafe/"><code>unsafe</code></a> package
are now explicit that unsafe code is not guaranteed to remain compatible.
</p>
  
<p>
<em>Updating</em>: Nothing technical has changed; this is just a clarification
of the documentation.
</p>


<h2 id="impl">Changes to the implementations and tools</h2>

<h3 id="runtime">Changes to the runtime</h3>

<p>
Prior to Go 1.4, the runtime (garbage collector, concurrency support, interface management,
maps, slices, strings, ...) was mostly written in C, with some assembler support.
In 1.4, much of the code has been translated to Go so that the garbage collector can scan
the stacks of programs in the runtime and get accurate information about what variables
are active.
This change was large but should have no semantic effect on programs.
</p>

<p>
This rewrite allows the garbage collector in 1.4 to be fully precise,
meaning that it is aware of the location of all active pointers in the program.
This means the heap will be smaller as there will be no false positives keeping non-pointers alive.
Other related changes also reduce the heap size, which is smaller by 10%-30% overall
relative to the previous release.
</p>

<p>
A consequence is that stacks are no longer segmented, eliminating the "hot split" problem.
When a stack limit is reached, a new, larger stack is allocated, all active frames for
the goroutine are copied there, and any pointers into the stack are updated.
Performance can be noticeably better in some cases and is always more predictable.
Details are available in <a href="https://golang.org/s/contigstacks">the design document</a>.
</p>

<p>
The use of contiguous stacks means that stacks can start smaller without triggering performance issues,
so the default starting size for a goroutine's stack in 1.4 has been reduced from 8192 bytes to 2048 bytes.
</p>

<p>
As preparation for the concurrent garbage collector scheduled for the 1.5 release,
writes to pointer values in the heap are now done by a function call,
called a write barrier, rather than directly from the function updating the value.
In this next release, this will permit the garbage collector to mediate writes to the heap while it is running.
This change has no semantic effect on programs in 1.4, but was
included in the release to test the compiler and the resulting performance.
</p>

<p>
The implementation of interface values has been modified.
In earlier releases, the interface contained a word that was either a pointer or a one-word
scalar value, depending on the type of the concrete object stored.
This implementation was problematical for the garbage collector,
so as of 1.4 interface values always hold a pointer.
In running programs, most interface values were pointers anyway,
so the effect is minimal, but programs that store integers (for example) in
interfaces will see more allocations.
</p>

<p>
As of Go 1.3, the runtime crashes if it finds a memory word that should contain
a valid pointer but instead contains an obviously invalid pointer (for example, the value 3).
Programs that store integers in pointer values may run afoul of this check and crash.
In Go 1.4, setting the <a href="/pkg/runtime/"><code>GODEBUG</code></a> variable
<code>invalidptr=0</code> disables
the crash as a workaround, but we cannot guarantee that future releases will be
able to avoid the crash; the correct fix is to rewrite code not to alias integers and pointers.
</p>

<h3 id="asm">Assembly</h3>

<p>
The language accepted by the assemblers <code>cmd/5a</code>, <code>cmd/6a</code>
and <code>cmd/8a</code> has had several changes,
mostly to make it easier to deliver type information to the runtime.
</p>

<p>
First, the <code>textflag.h</code> file that defines flags for <code>TEXT</code> directives
has been copied from the linker source directory to a standard location so it can be
included with the simple directive
</p>

<pre>
#include "textflag.h"
</pre>

<p>
The more important changes are in how assembler source can define the necessary
type information.
For most programs it will suffice to move data
definitions (<code>DATA</code> and <code>GLOBL</code> directives)
out of assembly into Go files
and to write a Go declaration for each assembly function.
The <a href="/doc/asm#runtime">assembly document</a> describes what to do.
</p>

<p>
<em>Updating</em>:
Assembly files that include <code>textflag.h</code> from its old
location will still work, but should be updated.
For the type information, most assembly routines will need no change,
but all should be examined.
Assembly source files that define data,
functions with non-empty stack frames, or functions that return pointers
need particular attention.
A description of the necessary (but simple) changes
is in the <a href="/doc/asm#runtime">assembly document</a>.
</p>

<p>
More information about these changes is in the <a href="/doc/asm">assembly document</a>.
</p>

<h3 id="gccgo">Status of gccgo</h3>

<p>
The release schedules for the GCC and Go projects do not coincide.
GCC release 4.9 contains the Go 1.2 version of gccgo.
The next release, GCC 5, will likely have the Go 1.4 version of gccgo.
</p>

<h3 id="internalpackages">Internal packages</h3>

<p>
Go's package system makes it easy to structure programs into components with clean boundaries,
but there are only two forms of access: local (unexported) and global (exported).
Sometimes one wishes to have components that are not exported,
for instance to avoid acquiring clients of interfaces to code that is part of a public repository
but not intended for use outside the program to which it belongs.
</p>

<p>
The Go language does not have the power to enforce this distinction, but as of Go 1.4 the
<a href="/cmd/go/"><code>go</code></a> command introduces
a mechanism to define "internal" packages that may not be imported by packages outside
the source subtree in which they reside.
</p>

<p>
To create such a package, place it in a directory named <code>internal</code> or in a subdirectory of a directory
named internal.
When the <code>go</code> command sees an import of a package with <code>internal</code> in its path,
it verifies that the package doing the import
is within the tree rooted at the parent of the <code>internal</code> directory.
For example, a package <code>.../a/b/c/internal/d/e/f</code>
can be imported only by code in the directory tree rooted at <code>.../a/b/c</code>.
It cannot be imported by code in <code>.../a/b/g</code> or in any other repository.
</p>

<p>
For Go 1.4, the internal package mechanism is enforced for the main Go repository;
from 1.5 and onward it will be enforced for any repository.
</p>

<p>
Full details of the mechanism are in
<a href="https://golang.org/s/go14internal">the design document</a>.
</p>

<h3 id="canonicalimports">Canonical import paths</h3>

<p>
Code often lives in repositories hosted by public services such as <code>github.com</code>,
meaning that the import paths for packages begin with the name of the hosting service,
<code>github.com/rsc/pdf</code> for example.
One can use
<a href="/cmd/go/#hdr-Remote_import_paths">an existing mechanism</a>
to provide a "custom" or "vanity" import path such as
<code>rsc.io/pdf</code>, but
that creates two valid import paths for the package.
That is a problem: one may inadvertently import the package through the two
distinct paths in a single program, which is wasteful;
miss an update to a package because the path being used is not recognized to be
out of date;
or break clients using the old path by moving the package to a different hosting service.
</p>

<p>
Go 1.4 introduces an annotation for package clauses in Go source that identify a canonical
import path for the package.
If an import is attempted using a path that is not canonical,
the <a href="/cmd/go/"><code>go</code></a> command
will refuse to compile the importing package.
</p>

<p>
The syntax is simple: put an identifying comment on the package line.
For our example, the package clause would read:
</p>

<pre>
package pdf // import "rsc.io/pdf"
</pre>

<p>
With this in place,
the <code>go</code> command will
refuse to compile a package that imports <code>github.com/rsc/pdf</code>, 
ensuring that the code can be moved without breaking users.
</p>

<p>
The check is at build time, not download time, so if <code>go</code> <code>get</code>
fails because of this check, the mis-imported package has been copied to the local machine
and should be removed manually.
</p>

<p>
To complement this new feature, a check has been added at update time to verify
that the local package's remote repository matches that of its custom import.
The <code>go</code> <code>get</code> <code>-u</code> command will fail to
update a package if its remote repository has changed since it was first
downloaded.
The new <code>-f</code> flag overrides this check.
</p>

<p>
Further information is in
<a href="https://golang.org/s/go14customimport">the design document</a>.
</p>

<h3 id="subrepo">Import paths for the subrepositories</h3>

<p>
The Go project subrepositories (<code>code.google.com/p/go.tools</code> and so on)
are now available under custom import paths replacing <code>code.google.com/p/go.</code> with <code>golang.org/x/</code>,
as in <code>golang.org/x/tools</code>.
We will add canonical import comments to the code around June 1, 2015,
at which point Go 1.4 and later will stop accepting the old <code>code.google.com</code> paths.
</p>

<p>
<em>Updating</em>: All code that imports from subrepositories should change
to use the new <code>golang.org</code> paths.
Go 1.0 and later can resolve and import the new paths, so updating will not break
compatibility with older releases.
Code that has not updated will stop compiling with Go 1.4 around June 1, 2015.
</p>

<h3 id="gogenerate">The go generate subcommand</h3>

<p>
The <a href="/cmd/go/"><code>go</code></a> command has a new subcommand,
<a href="/cmd/go/#hdr-Generate_Go_files_by_processing_source"><code>go generate</code></a>,
to automate the running of tools to generate source code before compilation.
For example, it can be used to run the <a href="/cmd/yacc"><code>yacc</code></a>
compiler-compiler on a <code>.y</code> file to produce the Go source file implementing the grammar,
or to automate the generation of <code>String</code> methods for typed constants using the new
<a href="http://godoc.org/golang.org/x/tools/cmd/stringer">stringer</a>
tool in the <code>golang.org/x/tools</code> subrepository.
</p>

<p>
For more information, see the 
<a href="https://golang.org/s/go1.4-generate">design document</a>.
</p>

<h3 id="filenames">Change to file name handling</h3>

<p>
Build constraints, also known as build tags, control compilation by including or excluding files
(see the documentation <a href="/pkg/go/build/"><code>/go/build</code></a>).
Compilation can also be controlled by the name of the file itself by "tagging" the file with
a suffix (before the <code>.go</code> or <code>.s</code> extension) with an underscore
and the name of the architecture or operating system.
For instance, the file <code>gopher_arm.go</code> will only be compiled if the target
processor is an ARM.
</p>

<p>
Before Go 1.4, a file called just <code>arm.go</code> was similarly tagged, but this behavior
can break sources when new architectures are added, causing files to suddenly become tagged.
In 1.4, therefore, a file will be tagged in this manner only if the tag (architecture or operating
system name) is preceded by an underscore.
</p>

<p>
<em>Updating</em>: Packages that depend on the old behavior will no longer compile correctly.
Files with names like <code>windows.go</code> or <code>amd64.go</code> should either
have explicit build tags added to the source or be renamed to something like
<code>os_windows.go</code> or <code>support_amd64.go</code>.
</p>

<h3 id="gocmd">Other changes to the go command</h3>

<p>
There were a number of minor changes to the
<a href="/cmd/go/"><code>cmd/go</code></a>
command worth noting.
</p>

<ul>

<li>
Unless <a href="/cmd/cgo/"><code>cgo</code></a> is being used to build the package,
the <code>go</code> command now refuses to compile C source files,
since the relevant C compilers
(<a href="/cmd/6c/"><code>6c</code></a> etc.)
are intended to be removed from the installation in some future release.
(They are used today only to build part of the runtime.)
It is difficult to use them correctly in any case, so any extant uses are likely incorrect,
so we have disabled them.
</li>

<li>
The <a href="/cmd/go/#hdr-Test_packages"><code>go</code> <code>test</code></a>
subcommand has a new flag, <code>-o</code>, to set the name of the resulting binary,
corresponding to the same flag in other subcommands.
The non-functional <code>-file</code> flag has been removed.
</li>

<li>
The <a href="/cmd/go/#hdr-Test_packages"><code>go</code> <code>test</code></a>
subcommand will compile and link all <code>*_test.go</code> files in the package,
even when there are no <code>Test</code> functions in them. 
It previously ignored such files.
</li>

<li>
The behavior of the
<a href="/cmd/go/#hdr-Test_packages"><code>go</code> <code>build</code></a>
subcommand's
<code>-a</code> flag has been changed for non-development installations.
For installations running a released distribution, the <code>-a</code> flag will no longer
rebuild the standard library and commands, to avoid overwriting the installation's files.
</li>

</ul>

<h3 id="pkg">Changes to package source layout</h3>

<p>
In the main Go source repository, the source code for the packages was kept in
the directory <code>src/pkg</code>, which made sense but differed from
other repositories, including the Go subrepositories.
In Go 1.4, the<code> pkg</code> level of the source tree is now gone, so for example
the <a href="/pkg/fmt/"><code>fmt</code></a> package's source, once kept in
directory <code>src/pkg/fmt</code>, now lives one level higher in <code>src/fmt</code>.
</p>

<p>
<em>Updating</em>: Tools like <code>godoc</code> that discover source code
need to know about the new location. All tools and services maintained by the Go team
have been updated.
</p>


<h3 id="swig">SWIG</h3>

<p>
Due to runtime changes in this release, Go 1.4 requires SWIG 3.0.3.
</p>

<h3 id="misc">Miscellany</h3>

<p>
The standard repository's top-level <code>misc</code> directory used to contain
Go support for editors and IDEs: plugins, initialization scripts and so on.
Maintaining these was becoming time-consuming
and needed external help because many of the editors listed were not used by
members of the core team.
It also required us to make decisions about which plugin was best for a given
editor, even for editors we do not use.
</p>

<p>
The Go community at large is much better suited to managing this information.
In Go 1.4, therefore, this support has been removed from the repository.
Instead, there is a curated, informative list of what's available on
a <a href="//golang.org/wiki/IDEsAndTextEditorPlugins">wiki page</a>.
</p>

<h2 id="performance">Performance</h2>

<p>
Most programs will run about the same speed or slightly faster in 1.4 than in 1.3;
some will be slightly slower.
There are many changes, making it hard to be precise about what to expect.
</p>

<p>
As mentioned above, much of the runtime was translated to Go from C,
which led to some reduction in heap sizes.
It also improved performance slightly because the Go compiler is better
at optimization, due to things like inlining, than the C compiler used to build
the runtime.
</p>

<p>
The garbage collector was sped up, leading to measurable improvements for
garbage-heavy programs.
On the other hand, the new write barriers slow things down again, typically
by about the same amount but, depending on their behavior, some programs
may be somewhat slower or faster.
</p>

<p>
Library changes that affect performance are documented below.
</p>

<h2 id="library">Changes to the standard library</h2>

<h3 id="new_packages">New packages</h3>

<p>
There are no new packages in this release.
</p>

<h3 id="major_library_changes">Major changes to the library</h3>

<h4 id="scanner">bufio.Scanner</h4>

<p>
The <a href="/pkg/bufio/#Scanner"><code>Scanner</code></a> type in the
<a href="/pkg/bufio/"><code>bufio</code></a> package
has had a bug fixed that may require changes to custom
<a href="/pkg/bufio/#SplitFunc"><code>split functions</code></a>. 
The bug made it impossible to generate an empty token at EOF; the fix
changes the end conditions seen by the split function.
Previously, scanning stopped at EOF if there was no more data.
As of 1.4, the split function will be called once at EOF after input is exhausted,
so the split function can generate a final empty token
as the documentation already promised.
</p>

<p>
<em>Updating</em>: Custom split functions may need to be modified to
handle empty tokens at EOF as desired.
</p>

<h4 id="syscall">syscall</h4>

<p>
The <a href="/pkg/syscall/"><code>syscall</code></a> package is now frozen except
for changes needed to maintain the core repository.
In particular, it will no longer be extended to support new or different system calls
that are not used by the core.
The reasons are described at length in <a href="https://golang.org/s/go1.4-syscall">a
separate document</a>.
</p>

<p>
A new subrepository, <a href="https://golang.org/x/sys">golang.org/x/sys</a>,
has been created to serve as the location for new developments to support system
calls on all kernels.
It has a nicer structure, with three packages that each hold the implementation of
system calls for one of
<a href="http://godoc.org/golang.org/x/sys/unix">Unix</a>,
<a href="http://godoc.org/golang.org/x/sys/windows">Windows</a> and
<a href="http://godoc.org/golang.org/x/sys/plan9">Plan 9</a>.
These packages will be curated more generously, accepting all reasonable changes
that reflect kernel interfaces in those operating systems.
See the documentation and the article mentioned above for more information.
</p>

<p>
<em>Updating</em>: Existing programs are not affected as the <code>syscall</code>
package is largely unchanged from the 1.3 release.
Future development that requires system calls not in the <code>syscall</code> package
should build on <code>golang.org/x/sys</code> instead.
</p>

<h3 id="minor_library_changes">Minor changes to the library</h3>

<p>
The following list summarizes a number of minor changes to the library, mostly additions.
See the relevant package documentation for more information about each change.
</p>

<ul>

<li>
The <a href="/pkg/archive/zip/"><code>archive/zip</code></a> package's
<a href="/pkg/archive/zip/#Writer"><code>Writer</code></a> now supports a
<a href="/pkg/archive/zip/#Writer.Flush"><code>Flush</code></a> method.
</li>

<li>
The <a href="/pkg/compress/flate/"><code>compress/flate</code></a>,
<a href="/pkg/compress/gzip/"><code>compress/gzip</code></a>,
and <a href="/pkg/compress/zlib/"><code>compress/zlib</code></a>
packages now support a <code>Reset</code> method
for the decompressors, allowing them to reuse buffers and improve performance.
The <a href="/pkg/compress/gzip/"><code>compress/gzip</code></a> package also has a
<a href="/pkg/compress/gzip/#Reader.Multistream"><code>Multistream</code></a> method to control support
for multistream files.
</li>

<li>
The <a href="/pkg/crypto/"><code>crypto</code></a> package now has a
<a href="/pkg/crypto/#Signer"><code>Signer</code></a> interface, implemented by the
<code>PrivateKey</code> types in
<a href="/pkg/crypto/ecdsa"><code>crypto/ecdsa</code></a> and
<a href="/pkg/crypto/rsa"><code>crypto/rsa</code></a>.
</li>

<li>
The <a href="/pkg/crypto/tls/"><code>crypto/tls</code></a> package
now supports ALPN as defined in <a href="http://tools.ietf.org/html/rfc7301">RFC 7301</a>.
</li>

<li>
The <a href="/pkg/crypto/tls/"><code>crypto/tls</code></a> package
now supports programmatic selection of server certificates
through the new <a href="/pkg/crypto/tls/#Config.CertificateForName"><code>CertificateForName</code></a> function
of the <a href="/pkg/crypo/tls/#Config"><code>Config</code></a> struct.
</li>

<li>
Also in the crypto/tls package, the server now supports 
<a href="https://tools.ietf.org/html/draft-ietf-tls-downgrade-scsv-00">TLS_FALLBACK_SCSV</a>
to help clients detect fallback attacks.
(The Go client does not support fallback at all, so it is not vulnerable to
those attacks.)
</li>

<li>
The <a href="/pkg/database/sql/"><code>database/sql</code></a> package can now list all registered
<a href="/pkg/database/sql/#Drivers"><code>Drivers</code></a>.
</li>

<li>
The <a href="/pkg/debug/dwarf/"><code>debug/dwarf</code></a> package now supports
<a href="/pkg/debug/dwarf/#UnspecifiedType"><code>UnspecifiedType</code></a>s.
</li>

<li>
In the <a href="/pkg/encoding/asn1/"><code>encoding/asn1</code></a> package,
optional elements with a default value will now only be omitted if they have that value.
</li>

<li>
The <a href="/pkg/encoding/csv/"><code>encoding/csv</code></a> package no longer
quotes empty strings but does quote the end-of-data marker <code>\.</code> (backslash dot).
This is permitted by the definition of CSV and allows it to work better with Postgres.
</li>

<li>
The <a href="/pkg/encoding/gob/"><code>encoding/gob</code></a> package has been rewritten to eliminate
the use of unsafe operations, allowing it to be used in environments that do not permit use of the
<a href="/pkg/unsafe/"><code>unsafe</code></a> package.
For typical uses it will be 10-30% slower, but the delta is dependent on the type of the data and
in some cases, especially involving arrays, it can be faster.
There is no functional change.
</li>

<li>
The <a href="/pkg/encoding/xml/"><code>encoding/xml</code></a> package's
<a href="/pkg/encoding/xml/#Decoder"><code>Decoder</code></a> can now report its input offset.
</li>

<li>
In the <a href="/pkg/fmt/"><code>fmt</code></a> package,
formatting of pointers to maps has changed to be consistent with that of pointers
to structs, arrays, and so on.
For instance, <code>&amp;map[string]int{"one":</code> <code>1}</code> now prints by default as
<code>&amp;map[one:</code> <code>1]</code> rather than as a hexadecimal pointer value.
</li>

<li>
The <a href="/pkg/image/"><code>image</code></a> package's
<a href="/pkg/image/#Image"><code>Image</code></a>
implementations like
<a href="/pkg/image/#RGBA"><code>RGBA</code></a> and
<a href="/pkg/image/#Gray"><code>Gray</code></a> have specialized
<a href="/pkg/image/#RGBA.RGBAAt"><code>RGBAAt</code></a> and
<a href="/pkg/image/#Gray.GrayAt"><code>GrayAt</code></a> methods alongside the general
<a href="/pkg/image/#Image.At"><code>At</code></a> method.
</li>

<li>
The <a href="/pkg/image/png/"><code>image/png</code></a> package now has an
<a href="/pkg/image/png/#Encoder"><code>Encoder</code></a>
type to control the compression level used for encoding.
</li>

<li>
The <a href="/pkg/math/"><code>math</code></a> package now has a
<a href="/pkg/math/#Nextafter32"><code>Nextafter32</code><a/> function.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package's
<a href="/pkg/net/http/#Request"><code>Request</code></a> type
has a new <a href="/pkg/net/http/#Request.BasicAuth"><code>BasicAuth</code></a> method
that returns the username and password from authenticated requests using the
HTTP Basic Authentication
Scheme.
</li>

<li>The <a href="/pkg/net/http/"><code>net/http</code></a> package's
<a href="/pkg/net/http/#Request"><code>Transport</code></a> type
has a new <a href="/pkg/net/http/#Transport.DialTLS"><code>DialTLS</code></a> hook
that allows customizing the behavior of outbound TLS connections.
</li>

<li>
The <a href="/pkg/net/http/httputil/"><code>net/http/httputil</code></a> package's
<a href="/pkg/net/http/httputil/#ReverseProxy"><code>ReverseProxy</code></a> type
has a new field,
<a href="/pkg/net/http/#ReverseProxy.ErrorLog"><code>ErrorLog</code></a>, that
provides user control of logging.
</li>

<li>
The <a href="/pkg/os/"><code>os</code></a> package
now implements symbolic links on the Windows operating system
through the <a href="/pkg/os/#Symlink"><code>Symlink</code></a> function.
Other operating systems already have this functionality.
There is also a new <a href="/pkg/os/#Unsetenv"><code>Unsetenv</code></a> function.
</li>

<li>
The <a href="/pkg/reflect/"><code>reflect</code></a> package's
<a href="/pkg/reflect/#Type"><code>Type</code></a> interface
has a new method, <a href="/pkg/reflect/#type.Comparable"><code>Comparable</code></a>,
that reports whether the type implements general comparisons.
</li>

<li>
Also in the <a href="/pkg/reflect/"><code>reflect</code></a> package, the
<a href="/pkg/reflect/#Value"><code>Value</code></a> interface is now three instead of four words
because of changes to the implementation of interfaces in the runtime.
This saves memory but has no semantic effect.
</li>

<li>
The <a href="/pkg/runtime/"><code>runtime</code></a> package
now implements monotonic clocks on Windows,
as it already did for the other systems.
</li>

<li>
The <a href="/pkg/runtime/"><code>runtime</code></a> package's
<a href="/pkg/runtime/#MemStats.Mallocs"><code>Mallocs</code></a> counter
now counts very small allocations that were missed in Go 1.3.
This may break tests using <a href="/pkg/runtime/#ReadMemStats"><code>ReadMemStats</code></a>
or <a href="/pkg/testing/#AllocsPerRun"><code>AllocsPerRun</code></a>
due to the more accurate answer.
</li>

<li>
In the <a href="/pkg/runtime/"><code>runtime</code></a> package,
an array <a href="/pkg/runtime/#MemStats.PauseEnd"><code>PauseEnd</code></a>
has been added to the
<a href="/pkg/runtime/#MemStats"><code>MemStats</code></a>
and <a href="/pkg/runtime/#GCStats"><code>GCStats</code></a> structs.
This array is a circular buffer of times when garbage collection pauses ended.
The corresponding pause durations are already recorded in
<a href="/pkg/runtime/#MemStats.PauseNs"><code>PauseNs</code></a>
</li>

<li>
The <a href="/pkg/runtime/race/"><code>runtime/race</code></a> package
now supports FreeBSD, which means the
<a href="/pkg/cmd/go/"><code>go</code></a> command's <code>-race</code>
flag now works on FreeBSD.
</li>

<li>
The <a href="/pkg/sync/atomic/"><code>sync/atomic</code></a> package
has a new type, <a href="/pkg/sync/atomic/#Value"><code>Value</code></a>.
<code>Value</code> provides an efficient mechanism for atomic loads and
stores of values of arbitrary type.
</li>

<li>
In the <a href="/pkg/syscall/"><code>syscall</code></a> package's
implementation on Linux, the
<a href="/pkg/syscall/#Setuid"><code>Setuid</code></a>
and <a href="/pkg/syscall/#Setgid"><code>Setgid</code></a> have been disabled
because those system calls operate on the calling thread, not the whole process, which is
different from other platforms and not the expected result.
</li>

<li>
The <a href="/pkg/testing/"><code>testing</code></a> package
has a new facility to provide more control over running a set of tests.
If the test code contains a function
<pre>
func TestMain(m *<a href="/pkg/testing/#M"><code>testing.M</code></a>) 
</pre>

that function will be called instead of running the tests directly.
The <code>M</code> struct contains methods to access and run the tests.
</li>

<li>
Also in the <a href="/pkg/testing/"><code>testing</code></a> package,
a new <a href="/pkg/testing/#Coverage"><code>Coverage</code></a>
function reports the current test coverage fraction,
enabling individual tests to report how much they are contributing to the
overall coverage.
</li>

<li>
The <a href="/pkg/text/scanner/"><code>text/scanner</code></a> package's
<a href="/pkg/text/scanner/#Scanner"><code>Scanner</code></a> type
has a new function,
<a href="/pkg/text/scanner/#Scanner.IsIdentRune"><code>IsIdentRune</code></a>,
allowing one to control the definition of an identifier when scanning.
</li>

<li>
The <a href="/pkg/text/template/"><code>text/template</code></a> package's boolean
functions <code>eq</code>, <code>lt</code>, and so on have been generalized to allow comparison
of signed and unsigned integers, simplifying their use in practice.
(Previously one could only compare values of the same signedness.)
All negative values compare less than all unsigned values.
</li>

<li>
The <code>time</code> package now uses the standard symbol for the micro prefix,
the micro symbol (U+00B5 '¬µ'), to print microsecond durations.
<a href="/pkg/time/#ParseDuration"><code>ParseDuration</code></a> still accepts <code>us</code>
but the package no longer prints microseconds as <code>us</code>.
<br>
<em>Updating</em>: Code that depends on the output format of durations
but does not use ParseDuration will need to be updated.
</li>

</ul>
                                                                                                                                                                                                                                                                       root/go1.4/doc/go1.html                                                                             0100644 0000000 0000000 00000213474 12600426226 013214  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Go 1 Release Notes",
	"Path":  "/doc/go1",
	"Template": true
}-->

<h2 id="introduction">Introduction to Go 1</h2>

<p>
Go version 1, Go 1 for short, defines a language and a set of core libraries
that provide a stable foundation for creating reliable products, projects, and
publications.
</p>

<p>
The driving motivation for Go 1 is stability for its users. People should be able to
write Go programs and expect that they will continue to compile and run without
change, on a time scale of years, including in production environments such as
Google App Engine. Similarly, people should be able to write books about Go, be
able to say which version of Go the book is describing, and have that version
number still be meaningful much later.
</p>

<p>
Code that compiles in Go 1 should, with few exceptions, continue to compile and
run throughout the lifetime of that version, even as we issue updates and bug
fixes such as Go version 1.1, 1.2, and so on. Other than critical fixes, changes
made to the language and library for subsequent releases of Go 1 may
add functionality but will not break existing Go 1 programs.
<a href="go1compat.html">The Go 1 compatibility document</a>
explains the compatibility guidelines in more detail.
</p>

<p>
Go 1 is a representation of Go as it used today, not a wholesale rethinking of
the language. We avoided designing new features and instead focused on cleaning
up problems and inconsistencies and improving portability. There are a number
changes to the Go language and packages that we had considered for some time and
prototyped but not released primarily because they are significant and
backwards-incompatible. Go 1 was an opportunity to get them out, which is
helpful for the long term, but also means that Go 1 introduces incompatibilities
for old programs. Fortunately, the <code>go</code> <code>fix</code> tool can
automate much of the work needed to bring programs up to the Go 1 standard.
</p>

<p>
This document outlines the major changes in Go 1 that will affect programmers
updating existing code; its reference point is the prior release, r60 (tagged as
r60.3). It also explains how to update code from r60 to run under Go 1.
</p>

<h2 id="language">Changes to the language</h2>

<h3 id="append">Append</h3>

<p>
The <code>append</code> predeclared variadic function makes it easy to grow a slice
by adding elements to the end.
A common use is to add bytes to the end of a byte slice when generating output.
However, <code>append</code> did not provide a way to append a string to a <code>[]byte</code>,
which is another common case.
</p>

{{code "/doc/progs/go1.go" `/greeting := ..byte/` `/append.*hello/`}}

<p>
By analogy with the similar property of <code>copy</code>, Go 1
permits a string to be appended (byte-wise) directly to a byte
slice, reducing the friction between strings and byte slices.
The conversion is no longer necessary:
</p>

{{code "/doc/progs/go1.go" `/append.*world/`}}

<p>
<em>Updating</em>:
This is a new feature, so existing code needs no changes.
</p>

<h3 id="close">Close</h3>

<p>
The <code>close</code> predeclared function provides a mechanism
for a sender to signal that no more values will be sent.
It is important to the implementation of <code>for</code> <code>range</code>
loops over channels and is helpful in other situations.
Partly by design and partly because of race conditions that can occur otherwise,
it is intended for use only by the goroutine sending on the channel,
not by the goroutine receiving data.
However, before Go 1 there was no compile-time checking that <code>close</code>
was being used correctly.
</p>

<p>
To close this gap, at least in part, Go 1 disallows <code>close</code> on receive-only channels.
Attempting to close such a channel is a compile-time error.
</p>

<pre>
    var c chan int
    var csend chan&lt;- int = c
    var crecv &lt;-chan int = c
    close(c)     // legal
    close(csend) // legal
    close(crecv) // illegal
</pre>

<p>
<em>Updating</em>:
Existing code that attempts to close a receive-only channel was
erroneous even before Go 1 and should be fixed.  The compiler will
now reject such code.
</p>

<h3 id="literals">Composite literals</h3>

<p>
In Go 1, a composite literal of array, slice, or map type can elide the
type specification for the elements' initializers if they are of pointer type.
All four of the initializations in this example are legal; the last one was illegal before Go 1.
</p>

{{code "/doc/progs/go1.go" `/type Date struct/` `/STOP/`}}

<p>
<em>Updating</em>:
This change has no effect on existing code, but the command
<code>gofmt</code> <code>-s</code> applied to existing source
will, among other things, elide explicit element types wherever permitted.
</p>


<h3 id="init">Goroutines during init</h3>

<p>
The old language defined that <code>go</code> statements executed during initialization created goroutines but that they did not begin to run until initialization of the entire program was complete.
This introduced clumsiness in many places and, in effect, limited the utility
of the <code>init</code> construct:
if it was possible for another package to use the library during initialization, the library
was forced to avoid goroutines.
This design was done for reasons of simplicity and safety but,
as our confidence in the language grew, it seemed unnecessary.
Running goroutines during initialization is no more complex or unsafe than running them during normal execution.
</p>

<p>
In Go 1, code that uses goroutines can be called from
<code>init</code> routines and global initialization expressions
without introducing a deadlock.
</p>

{{code "/doc/progs/go1.go" `/PackageGlobal/` `/^}/`}}

<p>
<em>Updating</em>:
This is a new feature, so existing code needs no changes,
although it's possible that code that depends on goroutines not starting before <code>main</code> will break.
There was no such code in the standard repository.
</p>

<h3 id="rune">The rune type</h3>

<p>
The language spec allows the <code>int</code> type to be 32 or 64 bits wide, but current implementations set <code>int</code> to 32 bits even on 64-bit platforms.
It would be preferable to have <code>int</code> be 64 bits on 64-bit platforms.
(There are important consequences for indexing large slices.)
However, this change would waste space when processing Unicode characters with
the old language because the <code>int</code> type was also used to hold Unicode code points: each code point would waste an extra 32 bits of storage if <code>int</code> grew from 32 bits to 64.
</p>

<p>
To make changing to 64-bit <code>int</code> feasible,
Go 1 introduces a new basic type, <code>rune</code>, to represent
individual Unicode code points.
It is an alias for <code>int32</code>, analogous to <code>byte</code>
as an alias for <code>uint8</code>.
</p>

<p>
Character literals such as <code>'a'</code>, <code>'Ë™û'</code>, and <code>'\u0345'</code>
now have default type <code>rune</code>,
analogous to <code>1.0</code> having default type <code>float64</code>.
A variable initialized to a character constant will therefore
have type <code>rune</code> unless otherwise specified.
</p>

<p>
Libraries have been updated to use <code>rune</code> rather than <code>int</code>
when appropriate. For instance, the functions <code>unicode.ToLower</code> and
relatives now take and return a <code>rune</code>.
</p>

{{code "/doc/progs/go1.go" `/STARTRUNE/` `/ENDRUNE/`}}

<p>
<em>Updating</em>:
Most source code will be unaffected by this because the type inference from
<code>:=</code> initializers introduces the new type silently, and it propagates
from there.
Some code may get type errors that a trivial conversion will resolve.
</p>

<h3 id="error">The error type</h3>

<p>
Go 1 introduces a new built-in type, <code>error</code>, which has the following definition:
</p>

<pre>
    type error interface {
        Error() string
    }
</pre>

<p>
Since the consequences of this type are all in the package library,
it is discussed <a href="#errors">below</a>.
</p>

<h3 id="delete">Deleting from maps</h3>

<p>
In the old language, to delete the entry with key <code>k</code> from map <code>m</code>, one wrote the statement,
</p>

<pre>
    m[k] = value, false
</pre>

<p>
This syntax was a peculiar special case, the only two-to-one assignment.
It required passing a value (usually ignored) that is evaluated but discarded,
plus a boolean that was nearly always the constant <code>false</code>.
It did the job but was odd and a point of contention.
</p>

<p>
In Go 1, that syntax has gone; instead there is a new built-in
function, <code>delete</code>.  The call
</p>

{{code "/doc/progs/go1.go" `/delete\(m, k\)/`}}

<p>
will delete the map entry retrieved by the expression <code>m[k]</code>.
There is no return value. Deleting a non-existent entry is a no-op.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will convert expressions of the form <code>m[k] = value,
false</code> into <code>delete(m, k)</code> when it is clear that
the ignored value can be safely discarded from the program and
<code>false</code> refers to the predefined boolean constant.
The fix tool
will flag other uses of the syntax for inspection by the programmer.
</p>

<h3 id="iteration">Iterating in maps</h3>

<p>
The old language specification did not define the order of iteration for maps,
and in practice it differed across hardware platforms.
This caused tests that iterated over maps to be fragile and non-portable, with the
unpleasant property that a test might always pass on one machine but break on another.
</p>

<p>
In Go 1, the order in which elements are visited when iterating
over a map using a <code>for</code> <code>range</code> statement
is defined to be unpredictable, even if the same loop is run multiple
times with the same map.
Code should not assume that the elements are visited in any particular order.
</p>

<p>
This change means that code that depends on iteration order is very likely to break early and be fixed long before it becomes a problem.
Just as important, it allows the map implementation to ensure better map balancing even when programs are using range loops to select an element from a map.
</p>

{{code "/doc/progs/go1.go" `/Sunday/` `/^	}/`}}

<p>
<em>Updating</em>:
This is one change where tools cannot help.  Most existing code
will be unaffected, but some programs may break or misbehave; we
recommend manual checking of all range statements over maps to
verify they do not depend on iteration order. There were a few such
examples in the standard repository; they have been fixed.
Note that it was already incorrect to depend on the iteration order, which
was unspecified. This change codifies the unpredictability.
</p>

<h3 id="multiple_assignment">Multiple assignment</h3>

<p>
The language specification has long guaranteed that in assignments
the right-hand-side expressions are all evaluated before any left-hand-side expressions are assigned.
To guarantee predictable behavior,
Go 1 refines the specification further.
</p>

<p>
If the left-hand side of the assignment
statement contains expressions that require evaluation, such as
function calls or array indexing operations, these will all be done
using the usual left-to-right rule before any variables are assigned
their value.  Once everything is evaluated, the actual assignments
proceed in left-to-right order.
</p>

<p>
These examples illustrate the behavior.
</p>

{{code "/doc/progs/go1.go" `/sa :=/` `/then sc.0. = 2/`}}

<p>
<em>Updating</em>:
This is one change where tools cannot help, but breakage is unlikely.
No code in the standard repository was broken by this change, and code
that depended on the previous unspecified behavior was already incorrect.
</p>

<h3 id="shadowing">Returns and shadowed variables</h3>

<p>
A common mistake is to use <code>return</code> (without arguments) after an assignment to a variable that has the same name as a result variable but is not the same variable.
This situation is called <em>shadowing</em>: the result variable has been shadowed by another variable with the same name declared in an inner scope.
</p>

<p>
In functions with named return values,
the Go 1 compilers disallow return statements without arguments if any of the named return values is shadowed at the point of the return statement.
(It isn't part of the specification, because this is one area we are still exploring;
the situation is analogous to the compilers rejecting functions that do not end with an explicit return statement.)
</p>

<p>
This function implicitly returns a shadowed return value and will be rejected by the compiler:
</p>

<pre>
    func Bug() (i, j, k int) {
        for i = 0; i &lt; 5; i++ {
            for j := 0; j &lt; 5; j++ { // Redeclares j.
                k += i*j
                if k > 100 {
                    return // Rejected: j is shadowed here.
                }
            }
        }
        return // OK: j is not shadowed here.
    }
</pre>

<p>
<em>Updating</em>:
Code that shadows return values in this way will be rejected by the compiler and will need to be fixed by hand.
The few cases that arose in the standard repository were mostly bugs.
</p>

<h3 id="unexported">Copying structs with unexported fields</h3>

<p>
The old language did not allow a package to make a copy of a struct value containing unexported fields belonging to a different package.
There was, however, a required exception for a method receiver;
also, the implementations of <code>copy</code> and <code>append</code> have never honored the restriction.
</p>

<p>
Go 1 will allow packages to copy struct values containing unexported fields from other packages.
Besides resolving the inconsistency,
this change admits a new kind of API: a package can return an opaque value without resorting to a pointer or interface.
The new implementations of <code>time.Time</code> and
<code>reflect.Value</code> are examples of types taking advantage of this new property.
</p>

<p>
As an example, if package <code>p</code> includes the definitions,
</p>

<pre>
    type Struct struct {
        Public int
        secret int
    }
    func NewStruct(a int) Struct {  // Note: not a pointer.
        return Struct{a, f(a)}
    }
    func (s Struct) String() string {
        return fmt.Sprintf("{%d (secret %d)}", s.Public, s.secret)
    }
</pre>

<p>
a package that imports <code>p</code> can assign and copy values of type
<code>p.Struct</code> at will.
Behind the scenes the unexported fields will be assigned and copied just
as if they were exported,
but the client code will never be aware of them. The code
</p>

<pre>
    import "p"

    myStruct := p.NewStruct(23)
    copyOfMyStruct := myStruct
    fmt.Println(myStruct, copyOfMyStruct)
</pre>

<p>
will show that the secret field of the struct has been copied to the new value.
</p>

<p>
<em>Updating</em>:
This is a new feature, so existing code needs no changes.
</p>

<h3 id="equality">Equality</h3>

<p>
Before Go 1, the language did not define equality on struct and array values.
This meant,
among other things, that structs and arrays could not be used as map keys.
On the other hand, Go did define equality on function and map values.
Function equality was problematic in the presence of closures
(when are two closures equal?)
while map equality compared pointers, not the maps' content, which was usually
not what the user would want.
</p>

<p>
Go 1 addressed these issues.
First, structs and arrays can be compared for equality and inequality
(<code>==</code> and <code>!=</code>),
and therefore be used as map keys,
provided they are composed from elements for which equality is also defined,
using element-wise comparison.
</p>

{{code "/doc/progs/go1.go" `/type Day struct/` `/Printf/`}}

<p>
Second, Go 1 removes the definition of equality for function values,
except for comparison with <code>nil</code>.
Finally, map equality is gone too, also except for comparison with <code>nil</code>.
</p>

<p>
Note that equality is still undefined for slices, for which the
calculation is in general infeasible.  Also note that the ordered
comparison operators (<code>&lt;</code> <code>&lt;=</code>
<code>&gt;</code> <code>&gt;=</code>) are still undefined for
structs and arrays.

<p>
<em>Updating</em>:
Struct and array equality is a new feature, so existing code needs no changes.
Existing code that depends on function or map equality will be
rejected by the compiler and will need to be fixed by hand.
Few programs will be affected, but the fix may require some
redesign.
</p>

<h2 id="packages">The package hierarchy</h2>

<p>
Go 1 addresses many deficiencies in the old standard library and
cleans up a number of packages, making them more internally consistent
and portable.
</p>

<p>
This section describes how the packages have been rearranged in Go 1.
Some have moved, some have been renamed, some have been deleted.
New packages are described in later sections.
</p>

<h3 id="hierarchy">The package hierarchy</h3>

<p>
Go 1 has a rearranged package hierarchy that groups related items
into subdirectories. For instance, <code>utf8</code> and
<code>utf16</code> now occupy subdirectories of <code>unicode</code>.
Also, <a href="#subrepo">some packages</a> have moved into
subrepositories of
<a href="//code.google.com/p/go"><code>code.google.com/p/go</code></a>
while <a href="#deleted">others</a> have been deleted outright.
</p>

<table class="codetable" frame="border" summary="Moved packages">
<colgroup align="left" width="60%"></colgroup>
<colgroup align="left" width="40%"></colgroup>
<tr>
<th align="left">Old path</th>
<th align="left">New path</th>
</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>asn1</td> <td>encoding/asn1</td></tr>
<tr><td>csv</td> <td>encoding/csv</td></tr>
<tr><td>gob</td> <td>encoding/gob</td></tr>
<tr><td>json</td> <td>encoding/json</td></tr>
<tr><td>xml</td> <td>encoding/xml</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>exp/template/html</td> <td>html/template</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>big</td> <td>math/big</td></tr>
<tr><td>cmath</td> <td>math/cmplx</td></tr>
<tr><td>rand</td> <td>math/rand</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>http</td> <td>net/http</td></tr>
<tr><td>http/cgi</td> <td>net/http/cgi</td></tr>
<tr><td>http/fcgi</td> <td>net/http/fcgi</td></tr>
<tr><td>http/httptest</td> <td>net/http/httptest</td></tr>
<tr><td>http/pprof</td> <td>net/http/pprof</td></tr>
<tr><td>mail</td> <td>net/mail</td></tr>
<tr><td>rpc</td> <td>net/rpc</td></tr>
<tr><td>rpc/jsonrpc</td> <td>net/rpc/jsonrpc</td></tr>
<tr><td>smtp</td> <td>net/smtp</td></tr>
<tr><td>url</td> <td>net/url</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>exec</td> <td>os/exec</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>scanner</td> <td>text/scanner</td></tr>
<tr><td>tabwriter</td> <td>text/tabwriter</td></tr>
<tr><td>template</td> <td>text/template</td></tr>
<tr><td>template/parse</td> <td>text/template/parse</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>utf8</td> <td>unicode/utf8</td></tr>
<tr><td>utf16</td> <td>unicode/utf16</td></tr>
</table>

<p>
Note that the package names for the old <code>cmath</code> and
<code>exp/template/html</code> packages have changed to <code>cmplx</code>
and <code>template</code>.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update all imports and package renames for packages that
remain inside the standard repository.  Programs that import packages
that are no longer in the standard repository will need to be edited
by hand.
</p>

<h3 id="exp">The package tree exp</h3>

<p>
Because they are not standardized, the packages under the <code>exp</code> directory will not be available in the
standard Go 1 release distributions, although they will be available in source code form
in <a href="//code.google.com/p/go/">the repository</a> for
developers who wish to use them.
</p>

<p>
Several packages have moved under <code>exp</code> at the time of Go 1's release:
</p>

<ul>
<li><code>ebnf</code></li>
<li><code>html</code><sup>&#8224;</sup></li>
<li><code>go/types</code></li>
</ul>

<p>
(<sup>&#8224;</sup>The <code>EscapeString</code> and <code>UnescapeString</code> types remain
in package <code>html</code>.)
</p>

<p>
All these packages are available under the same names, with the prefix <code>exp/</code>: <code>exp/ebnf</code> etc.
</p>

<p>
Also, the <code>utf8.String</code> type has been moved to its own package, <code>exp/utf8string</code>.
</p>

<p>
Finally, the <code>gotype</code> command now resides in <code>exp/gotype</code>, while
<code>ebnflint</code> is now in <code>exp/ebnflint</code>.
If they are installed, they now reside in <code>$GOROOT/bin/tool</code>.
</p>

<p>
<em>Updating</em>:
Code that uses packages in <code>exp</code> will need to be updated by hand,
or else compiled from an installation that has <code>exp</code> available.
The <code>go</code> <code>fix</code> tool or the compiler will complain about such uses.
</p>

<h3 id="old">The package tree old</h3>

<p>
Because they are deprecated, the packages under the <code>old</code> directory will not be available in the
standard Go 1 release distributions, although they will be available in source code form for
developers who wish to use them.
</p>

<p>
The packages in their new locations are:
</p>

<ul>
<li><code>old/netchan</code></li>
</ul>

<p>
<em>Updating</em>:
Code that uses packages now in <code>old</code> will need to be updated by hand,
or else compiled from an installation that has <code>old</code> available.
The <code>go</code> <code>fix</code> tool will warn about such uses.
</p>

<h3 id="deleted">Deleted packages</h3>

<p>
Go 1 deletes several packages outright:
</p>

<ul>
<li><code>container/vector</code></li>
<li><code>exp/datafmt</code></li>
<li><code>go/typechecker</code></li>
<li><code>old/regexp</code></li>
<li><code>old/template</code></li>
<li><code>try</code></li>
</ul>

<p>
and also the command <code>gotry</code>.
</p>

<p>
<em>Updating</em>:
Code that uses <code>container/vector</code> should be updated to use
slices directly.  See
<a href="//code.google.com/p/go-wiki/wiki/SliceTricks">the Go
Language Community Wiki</a> for some suggestions.
Code that uses the other packages (there should be almost zero) will need to be rethought.
</p>

<h3 id="subrepo">Packages moving to subrepositories</h3>

<p>
Go 1 has moved a number of packages into other repositories, usually sub-repositories of
<a href="//code.google.com/p/go/">the main Go repository</a>.
This table lists the old and new import paths:

<table class="codetable" frame="border" summary="Sub-repositories">
<colgroup align="left" width="40%"></colgroup>
<colgroup align="left" width="60%"></colgroup>
<tr>
<th align="left">Old</th>
<th align="left">New</th>
</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>crypto/bcrypt</td> <td>code.google.com/p/go.crypto/bcrypt</tr>
<tr><td>crypto/blowfish</td> <td>code.google.com/p/go.crypto/blowfish</tr>
<tr><td>crypto/cast5</td> <td>code.google.com/p/go.crypto/cast5</tr>
<tr><td>crypto/md4</td> <td>code.google.com/p/go.crypto/md4</tr>
<tr><td>crypto/ocsp</td> <td>code.google.com/p/go.crypto/ocsp</tr>
<tr><td>crypto/openpgp</td> <td>code.google.com/p/go.crypto/openpgp</tr>
<tr><td>crypto/openpgp/armor</td> <td>code.google.com/p/go.crypto/openpgp/armor</tr>
<tr><td>crypto/openpgp/elgamal</td> <td>code.google.com/p/go.crypto/openpgp/elgamal</tr>
<tr><td>crypto/openpgp/errors</td> <td>code.google.com/p/go.crypto/openpgp/errors</tr>
<tr><td>crypto/openpgp/packet</td> <td>code.google.com/p/go.crypto/openpgp/packet</tr>
<tr><td>crypto/openpgp/s2k</td> <td>code.google.com/p/go.crypto/openpgp/s2k</tr>
<tr><td>crypto/ripemd160</td> <td>code.google.com/p/go.crypto/ripemd160</tr>
<tr><td>crypto/twofish</td> <td>code.google.com/p/go.crypto/twofish</tr>
<tr><td>crypto/xtea</td> <td>code.google.com/p/go.crypto/xtea</tr>
<tr><td>exp/ssh</td> <td>code.google.com/p/go.crypto/ssh</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>image/bmp</td> <td>code.google.com/p/go.image/bmp</tr>
<tr><td>image/tiff</td> <td>code.google.com/p/go.image/tiff</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>net/dict</td> <td>code.google.com/p/go.net/dict</tr>
<tr><td>net/websocket</td> <td>code.google.com/p/go.net/websocket</tr>
<tr><td>exp/spdy</td> <td>code.google.com/p/go.net/spdy</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>encoding/git85</td> <td>code.google.com/p/go.codereview/git85</tr>
<tr><td>patch</td> <td>code.google.com/p/go.codereview/patch</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>exp/wingui</td> <td>code.google.com/p/gowingui</tr>
</table>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update imports of these packages to use the new import paths.
Installations that depend on these packages will need to install them using
a <code>go get</code> command.
</p>

<h2 id="major">Major changes to the library</h2>

<p>
This section describes significant changes to the core libraries, the ones that
affect the most programs.
</p>

<h3 id="errors">The error type and errors package</h3>

<p>
The placement of <code>os.Error</code> in package <code>os</code> is mostly historical: errors first came up when implementing package <code>os</code>, and they seemed system-related at the time.
Since then it has become clear that errors are more fundamental than the operating system.  For example, it would be nice to use <code>Errors</code> in packages that <code>os</code> depends on, like <code>syscall</code>.
Also, having <code>Error</code> in <code>os</code> introduces many dependencies on <code>os</code> that would otherwise not exist.
</p>

<p>
Go 1 solves these problems by introducing a built-in <code>error</code> interface type and a separate <code>errors</code> package (analogous to <code>bytes</code> and <code>strings</code>) that contains utility functions.
It replaces <code>os.NewError</code> with
<a href="/pkg/errors/#New"><code>errors.New</code></a>,
giving errors a more central place in the environment.
</p>

<p>
So the widely-used <code>String</code> method does not cause accidental satisfaction
of the <code>error</code> interface, the <code>error</code> interface uses instead
the name <code>Error</code> for that method:
</p>

<pre>
    type error interface {
        Error() string
    }
</pre>

<p>
The <code>fmt</code> library automatically invokes <code>Error</code>, as it already
does for <code>String</code>, for easy printing of error values.
</p>

{{code "/doc/progs/go1.go" `/START ERROR EXAMPLE/` `/END ERROR EXAMPLE/`}}

<p>
All standard packages have been updated to use the new interface; the old <code>os.Error</code> is gone.
</p>

<p>
A new package, <a href="/pkg/errors/"><code>errors</code></a>, contains the function
</p>

<pre>
func New(text string) error
</pre>

<p>
to turn a string into an error. It replaces the old <code>os.NewError</code>.
</p>

{{code "/doc/progs/go1.go" `/ErrSyntax/`}}
		
<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update almost all code affected by the change.
Code that defines error types with a <code>String</code> method will need to be updated
by hand to rename the methods to <code>Error</code>.
</p>

<h3 id="errno">System call errors</h3>

<p>
The old <code>syscall</code> package, which predated <code>os.Error</code>
(and just about everything else),
returned errors as <code>int</code> values.
In turn, the <code>os</code> package forwarded many of these errors, such
as <code>EINVAL</code>, but using a different set of errors on each platform.
This behavior was unpleasant and unportable.
</p>

<p>
In Go 1, the
<a href="/pkg/syscall/"><code>syscall</code></a>
package instead returns an <code>error</code> for system call errors.
On Unix, the implementation is done by a
<a href="/pkg/syscall/#Errno"><code>syscall.Errno</code></a> type
that satisfies <code>error</code> and replaces the old <code>os.Errno</code>.
</p>

<p>
The changes affecting <code>os.EINVAL</code> and relatives are
described <a href="#os">elsewhere</a>.

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update almost all code affected by the change.
Regardless, most code should use the <code>os</code> package
rather than <code>syscall</code> and so will be unaffected.
</p>

<h3 id="time">Time</h3>

<p>
Time is always a challenge to support well in a programming language.
The old Go <code>time</code> package had <code>int64</code> units, no
real type safety,
and no distinction between absolute times and durations.
</p>

<p>
One of the most sweeping changes in the Go 1 library is therefore a
complete redesign of the
<a href="/pkg/time/"><code>time</code></a> package.
Instead of an integer number of nanoseconds as an <code>int64</code>,
and a separate <code>*time.Time</code> type to deal with human
units such as hours and years,
there are now two fundamental types:
<a href="/pkg/time/#Time"><code>time.Time</code></a>
(a value, so the <code>*</code> is gone), which represents a moment in time;
and <a href="/pkg/time/#Duration"><code>time.Duration</code></a>,
which represents an interval.
Both have nanosecond resolution.
A <code>Time</code> can represent any time into the ancient
past and remote future, while a <code>Duration</code> can
span plus or minus only about 290 years.
There are methods on these types, plus a number of helpful
predefined constant durations such as <code>time.Second</code>.
</p>

<p>
Among the new methods are things like
<a href="/pkg/time/#Time.Add"><code>Time.Add</code></a>,
which adds a <code>Duration</code> to a <code>Time</code>, and
<a href="/pkg/time/#Time.Sub"><code>Time.Sub</code></a>,
which subtracts two <code>Times</code> to yield a <code>Duration</code>.
</p>

<p>
The most important semantic change is that the Unix epoch (Jan 1, 1970) is now
relevant only for those functions and methods that mention Unix:
<a href="/pkg/time/#Unix"><code>time.Unix</code></a>
and the <a href="/pkg/time/#Time.Unix"><code>Unix</code></a>
and <a href="/pkg/time/#Time.UnixNano"><code>UnixNano</code></a> methods
of the <code>Time</code> type.
In particular,
<a href="/pkg/time/#Now"><code>time.Now</code></a>
returns a <code>time.Time</code> value rather than, in the old
API, an integer nanosecond count since the Unix epoch.
</p>

{{code "/doc/progs/go1.go" `/sleepUntil/` `/^}/`}}

<p>
The new types, methods, and constants have been propagated through
all the standard packages that use time, such as <code>os</code> and
its representation of file time stamps.
</p>

<p>
<em>Updating</em>:
The <code>go</code> <code>fix</code> tool will update many uses of the old <code>time</code> package to use the new
types and methods, although it does not replace values such as <code>1e9</code>
representing nanoseconds per second.
Also, because of type changes in some of the values that arise,
some of the expressions rewritten by the fix tool may require
further hand editing; in such cases the rewrite will include
the correct function or method for the old functionality, but
may have the wrong type or require further analysis.
</p>

<h2 id="minor">Minor changes to the library</h2>

<p>
This section describes smaller changes, such as those to less commonly
used packages or that affect
few programs beyond the need to run <code>go</code> <code>fix</code>.
This category includes packages that are new in Go 1.
Collectively they improve portability, regularize behavior, and
make the interfaces more modern and Go-like.
</p>

<h3 id="archive_zip">The archive/zip package</h3>

<p>
In Go 1, <a href="/pkg/archive/zip/#Writer"><code>*zip.Writer</code></a> no
longer has a <code>Write</code> method. Its presence was a mistake.
</p>

<p>
<em>Updating</em>:
What little code is affected will be caught by the compiler and must be updated by hand.
</p>

<h3 id="bufio">The bufio package</h3>

<p>
In Go 1, <a href="/pkg/bufio/#NewReaderSize"><code>bufio.NewReaderSize</code></a>
and
<a href="/pkg/bufio/#NewWriterSize"><code>bufio.NewWriterSize</code></a>
functions no longer return an error for invalid sizes.
If the argument size is too small or invalid, it is adjusted.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update calls that assign the error to _.
Calls that aren't fixed will be caught by the compiler and must be updated by hand.
</p>

<h3 id="compress">The compress/flate, compress/gzip and compress/zlib packages</h3>

<p>
In Go 1, the <code>NewWriterXxx</code> functions in
<a href="/pkg/compress/flate"><code>compress/flate</code></a>,
<a href="/pkg/compress/gzip"><code>compress/gzip</code></a> and
<a href="/pkg/compress/zlib"><code>compress/zlib</code></a>
all return <code>(*Writer, error)</code> if they take a compression level,
and <code>*Writer</code> otherwise. Package <code>gzip</code>'s
<code>Compressor</code> and <code>Decompressor</code> types have been renamed
to <code>Writer</code> and <code>Reader</code>. Package <code>flate</code>'s
<code>WrongValueError</code> type has been removed.
</p>

<p>
<em>Updating</em>
Running <code>go</code> <code>fix</code> will update old names and calls that assign the error to _.
Calls that aren't fixed will be caught by the compiler and must be updated by hand.
</p>

<h3 id="crypto_aes_des">The crypto/aes and crypto/des packages</h3>

<p>
In Go 1, the <code>Reset</code> method has been removed. Go does not guarantee
that memory is not copied and therefore this method was misleading.
</p>

<p>
The cipher-specific types <code>*aes.Cipher</code>, <code>*des.Cipher</code>,
and <code>*des.TripleDESCipher</code> have been removed in favor of
<code>cipher.Block</code>.
</p>

<p>
<em>Updating</em>:
Remove the calls to Reset. Replace uses of the specific cipher types with
cipher.Block.
</p>

<h3 id="crypto_elliptic">The crypto/elliptic package</h3>

<p>
In Go 1, <a href="/pkg/crypto/elliptic/#Curve"><code>elliptic.Curve</code></a>
has been made an interface to permit alternative implementations. The curve
parameters have been moved to the
<a href="/pkg/crypto/elliptic/#CurveParams"><code>elliptic.CurveParams</code></a>
structure.
</p>

<p>
<em>Updating</em>:
Existing users of <code>*elliptic.Curve</code> will need to change to
simply <code>elliptic.Curve</code>. Calls to <code>Marshal</code>,
<code>Unmarshal</code> and <code>GenerateKey</code> are now functions
in <code>crypto/elliptic</code> that take an <code>elliptic.Curve</code>
as their first argument.
</p>

<h3 id="crypto_hmac">The crypto/hmac package</h3>

<p>
In Go 1, the hash-specific functions, such as <code>hmac.NewMD5</code>, have
been removed from <code>crypto/hmac</code>. Instead, <code>hmac.New</code> takes
a function that returns a <code>hash.Hash</code>, such as <code>md5.New</code>.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will perform the needed changes.
</p>

<h3 id="crypto_x509">The crypto/x509 package</h3>

<p>
In Go 1, the
<a href="/pkg/crypto/x509/#CreateCertificate"><code>CreateCertificate</code></a>
function and
<a href="/pkg/crypto/x509/#Certificate.CreateCRL"><code>CreateCRL</code></a>
method in <code>crypto/x509</code> have been altered to take an
<code>interface{}</code> where they previously took a <code>*rsa.PublicKey</code>
or <code>*rsa.PrivateKey</code>. This will allow other public key algorithms
to be implemented in the future.
</p>

<p>
<em>Updating</em>:
No changes will be needed.
</p>

<h3 id="encoding_binary">The encoding/binary package</h3>

<p>
In Go 1, the <code>binary.TotalSize</code> function has been replaced by
<a href="/pkg/encoding/binary/#Size"><code>Size</code></a>,
which takes an <code>interface{}</code> argument rather than
a <code>reflect.Value</code>.
</p>

<p>
<em>Updating</em>:
What little code is affected will be caught by the compiler and must be updated by hand.
</p>

<h3 id="encoding_xml">The encoding/xml package</h3>

<p>
In Go 1, the <a href="/pkg/encoding/xml/"><code>xml</code></a> package
has been brought closer in design to the other marshaling packages such
as <a href="/pkg/encoding/gob/"><code>encoding/gob</code></a>.
</p>

<p>
The old <code>Parser</code> type is renamed
<a href="/pkg/encoding/xml/#Decoder"><code>Decoder</code></a> and has a new
<a href="/pkg/encoding/xml/#Decoder.Decode"><code>Decode</code></a> method. An
<a href="/pkg/encoding/xml/#Encoder"><code>Encoder</code></a> type was also introduced.
</p>

<p>
The functions <a href="/pkg/encoding/xml/#Marshal"><code>Marshal</code></a>
and <a href="/pkg/encoding/xml/#Unmarshal"><code>Unmarshal</code></a>
work with <code>[]byte</code> values now. To work with streams,
use the new <a href="/pkg/encoding/xml/#Encoder"><code>Encoder</code></a>
and <a href="/pkg/encoding/xml/#Decoder"><code>Decoder</code></a> types.
</p>

<p>
When marshaling or unmarshaling values, the format of supported flags in
field tags has changed to be closer to the
<a href="/pkg/encoding/json"><code>json</code></a> package
(<code>`xml:"name,flag"`</code>). The matching done between field tags, field
names, and the XML attribute and element names is now case-sensitive.
The <code>XMLName</code> field tag, if present, must also match the name
of the XML element being marshaled.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update most uses of the package except for some calls to
<code>Unmarshal</code>. Special care must be taken with field tags,
since the fix tool will not update them and if not fixed by hand they will
misbehave silently in some cases. For example, the old
<code>"attr"</code> is now written <code>",attr"</code> while plain
<code>"attr"</code> remains valid but with a different meaning.
</p>

<h3 id="expvar">The expvar package</h3>

<p>
In Go 1, the <code>RemoveAll</code> function has been removed.
The <code>Iter</code> function and Iter method on <code>*Map</code> have
been replaced by
<a href="/pkg/expvar/#Do"><code>Do</code></a>
and
<a href="/pkg/expvar/#Map.Do"><code>(*Map).Do</code></a>.
</p>

<p>
<em>Updating</em>:
Most code using <code>expvar</code> will not need changing. The rare code that used
<code>Iter</code> can be updated to pass a closure to <code>Do</code> to achieve the same effect.
</p>

<h3 id="flag">The flag package</h3>

<p>
In Go 1, the interface <a href="/pkg/flag/#Value"><code>flag.Value</code></a> has changed slightly.
The <code>Set</code> method now returns an <code>error</code> instead of
a <code>bool</code> to indicate success or failure.
</p>

<p>
There is also a new kind of flag, <code>Duration</code>, to support argument
values specifying time intervals.
Values for such flags must be given units, just as <code>time.Duration</code>
formats them: <code>10s</code>, <code>1h30m</code>, etc.
</p>

{{code "/doc/progs/go1.go" `/timeout/`}}

<p>
<em>Updating</em>:
Programs that implement their own flags will need minor manual fixes to update their
<code>Set</code> methods.
The <code>Duration</code> flag is new and affects no existing code.
</p>


<h3 id="go">The go/* packages</h3>

<p>
Several packages under <code>go</code> have slightly revised APIs.
</p>

<p>
A concrete <code>Mode</code> type was introduced for configuration mode flags
in the packages
<a href="/pkg/go/scanner/"><code>go/scanner</code></a>,
<a href="/pkg/go/parser/"><code>go/parser</code></a>,
<a href="/pkg/go/printer/"><code>go/printer</code></a>, and
<a href="/pkg/go/doc/"><code>go/doc</code></a>.
</p>

<p>
The modes <code>AllowIllegalChars</code> and <code>InsertSemis</code> have been removed
from the <a href="/pkg/go/scanner/"><code>go/scanner</code></a> package. They were mostly
useful for scanning text other then Go source files. Instead, the
<a href="/pkg/text/scanner/"><code>text/scanner</code></a> package should be used
for that purpose.
</p>

<p>
The <a href="/pkg/go/scanner/#ErrorHandler"><code>ErrorHandler</code></a> provided
to the scanner's <a href="/pkg/go/scanner/#Scanner.Init"><code>Init</code></a> method is
now simply a function rather than an interface. The <code>ErrorVector</code> type has
been removed in favor of the (existing) <a href="/pkg/go/scanner/#ErrorList"><code>ErrorList</code></a>
type, and the <code>ErrorVector</code> methods have been migrated. Instead of embedding
an <code>ErrorVector</code> in a client of the scanner, now a client should maintain
an <code>ErrorList</code>.
</p>

<p>
The set of parse functions provided by the <a href="/pkg/go/parser/"><code>go/parser</code></a>
package has been reduced to the primary parse function
<a href="/pkg/go/parser/#ParseFile"><code>ParseFile</code></a>, and a couple of
convenience functions <a href="/pkg/go/parser/#ParseDir"><code>ParseDir</code></a>
and <a href="/pkg/go/parser/#ParseExpr"><code>ParseExpr</code></a>.
</p>

<p>
The <a href="/pkg/go/printer/"><code>go/printer</code></a> package supports an additional
configuration mode <a href="/pkg/go/printer/#Mode"><code>SourcePos</code></a>;
if set, the printer will emit <code>//line</code> comments such that the generated
output contains the original source code position information. The new type
<a href="/pkg/go/printer/#CommentedNode"><code>CommentedNode</code></a> can be
used to provide comments associated with an arbitrary
<a href="/pkg/go/ast/#Node"><code>ast.Node</code></a> (until now only
<a href="/pkg/go/ast/#File"><code>ast.File</code></a> carried comment information).
</p>

<p>
The type names of the <a href="/pkg/go/doc/"><code>go/doc</code></a> package have been
streamlined by removing the <code>Doc</code> suffix: <code>PackageDoc</code>
is now <code>Package</code>, <code>ValueDoc</code> is <code>Value</code>, etc.
Also, all types now consistently have a <code>Name</code> field (or <code>Names</code>,
in the case of type <code>Value</code>) and <code>Type.Factories</code> has become
<code>Type.Funcs</code>.
Instead of calling <code>doc.NewPackageDoc(pkg, importpath)</code>,
documentation for a package is created with:
</p>

<pre>
    doc.New(pkg, importpath, mode)
</pre>

<p>
where the new <code>mode</code> parameter specifies the operation mode:
if set to <a href="/pkg/go/doc/#AllDecls"><code>AllDecls</code></a>, all declarations
(not just exported ones) are considered.
The function <code>NewFileDoc</code> was removed, and the function
<code>CommentText</code> has become the method
<a href="/pkg/go/ast/#CommentGroup.Text"><code>Text</code></a> of
<a href="/pkg/go/ast/#CommentGroup"><code>ast.CommentGroup</code></a>.
</p>

<p>
In package <a href="/pkg/go/token/"><code>go/token</code></a>, the
<a href="/pkg/go/token/#FileSet"><code>token.FileSet</code></a> method <code>Files</code>
(which originally returned a channel of <code>*token.File</code>s) has been replaced
with the iterator <a href="/pkg/go/token/#FileSet.Iterate"><code>Iterate</code></a> that
accepts a function argument instead.
</p>

<p>
In package <a href="/pkg/go/build/"><code>go/build</code></a>, the API
has been nearly completely replaced.
The package still computes Go package information
but it does not run the build: the <code>Cmd</code> and <code>Script</code>
types are gone.
(To build code, use the new
<a href="/cmd/go/"><code>go</code></a> command instead.)
The <code>DirInfo</code> type is now named
<a href="/pkg/go/build/#Package"><code>Package</code></a>.
<code>FindTree</code> and <code>ScanDir</code> are replaced by
<a href="/pkg/go/build/#Import"><code>Import</code></a>
and
<a href="/pkg/go/build/#ImportDir"><code>ImportDir</code></a>.
</p>

<p>
<em>Updating</em>:
Code that uses packages in <code>go</code> will have to be updated by hand; the
compiler will reject incorrect uses. Templates used in conjunction with any of the
<code>go/doc</code> types may need manual fixes; the renamed fields will lead
to run-time errors.
</p>

<h3 id="hash">The hash package</h3>

<p>
In Go 1, the definition of <a href="/pkg/hash/#Hash"><code>hash.Hash</code></a> includes
a new method, <code>BlockSize</code>.  This new method is used primarily in the
cryptographic libraries.
</p>

<p>
The <code>Sum</code> method of the
<a href="/pkg/hash/#Hash"><code>hash.Hash</code></a> interface now takes a
<code>[]byte</code> argument, to which the hash value will be appended.
The previous behavior can be recreated by adding a <code>nil</code> argument to the call.
</p>

<p>
<em>Updating</em>:
Existing implementations of <code>hash.Hash</code> will need to add a
<code>BlockSize</code> method.  Hashes that process the input one byte at
a time can implement <code>BlockSize</code> to return 1.
Running <code>go</code> <code>fix</code> will update calls to the <code>Sum</code> methods of the various
implementations of <code>hash.Hash</code>.
</p>

<p>
<em>Updating</em>:
Since the package's functionality is new, no updating is necessary.
</p>

<h3 id="http">The http package</h3>

<p>
In Go 1 the <a href="/pkg/net/http/"><code>http</code></a> package is refactored,
putting some of the utilities into a
<a href="/pkg/net/http/httputil/"><code>httputil</code></a> subdirectory.
These pieces are only rarely needed by HTTP clients.
The affected items are:
</p>

<ul>
<li>ClientConn</li>
<li>DumpRequest</li>
<li>DumpRequestOut</li>
<li>DumpResponse</li>
<li>NewChunkedReader</li>
<li>NewChunkedWriter</li>
<li>NewClientConn</li>
<li>NewProxyClientConn</li>
<li>NewServerConn</li>
<li>NewSingleHostReverseProxy</li>
<li>ReverseProxy</li>
<li>ServerConn</li>
</ul>

<p>
The <code>Request.RawURL</code> field has been removed; it was a
historical artifact.
</p>

<p>
The <code>Handle</code> and <code>HandleFunc</code>
functions, and the similarly-named methods of <code>ServeMux</code>,
now panic if an attempt is made to register the same pattern twice.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update the few programs that are affected except for
uses of <code>RawURL</code>, which must be fixed by hand.
</p>

<h3 id="image">The image package</h3>

<p>
The <a href="/pkg/image/"><code>image</code></a> package has had a number of
minor changes, rearrangements and renamings.
</p>

<p>
Most of the color handling code has been moved into its own package,
<a href="/pkg/image/color/"><code>image/color</code></a>.
For the elements that moved, a symmetry arises; for instance,
each pixel of an
<a href="/pkg/image/#RGBA"><code>image.RGBA</code></a>
is a
<a href="/pkg/image/color/#RGBA"><code>color.RGBA</code></a>.
</p>

<p>
The old <code>image/ycbcr</code> package has been folded, with some
renamings, into the
<a href="/pkg/image/"><code>image</code></a>
and
<a href="/pkg/image/color/"><code>image/color</code></a>
packages.
</p>

<p>
The old <code>image.ColorImage</code> type is still in the <code>image</code>
package but has been renamed
<a href="/pkg/image/#Uniform"><code>image.Uniform</code></a>,
while <code>image.Tiled</code> has been removed.
</p>

<p>
This table lists the renamings.
</p>

<table class="codetable" frame="border" summary="image renames">
<colgroup align="left" width="50%"></colgroup>
<colgroup align="left" width="50%"></colgroup>
<tr>
<th align="left">Old</th>
<th align="left">New</th>
</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>image.Color</td> <td>color.Color</td></tr>
<tr><td>image.ColorModel</td> <td>color.Model</td></tr>
<tr><td>image.ColorModelFunc</td> <td>color.ModelFunc</td></tr>
<tr><td>image.PalettedColorModel</td> <td>color.Palette</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>image.RGBAColor</td> <td>color.RGBA</td></tr>
<tr><td>image.RGBA64Color</td> <td>color.RGBA64</td></tr>
<tr><td>image.NRGBAColor</td> <td>color.NRGBA</td></tr>
<tr><td>image.NRGBA64Color</td> <td>color.NRGBA64</td></tr>
<tr><td>image.AlphaColor</td> <td>color.Alpha</td></tr>
<tr><td>image.Alpha16Color</td> <td>color.Alpha16</td></tr>
<tr><td>image.GrayColor</td> <td>color.Gray</td></tr>
<tr><td>image.Gray16Color</td> <td>color.Gray16</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>image.RGBAColorModel</td> <td>color.RGBAModel</td></tr>
<tr><td>image.RGBA64ColorModel</td> <td>color.RGBA64Model</td></tr>
<tr><td>image.NRGBAColorModel</td> <td>color.NRGBAModel</td></tr>
<tr><td>image.NRGBA64ColorModel</td> <td>color.NRGBA64Model</td></tr>
<tr><td>image.AlphaColorModel</td> <td>color.AlphaModel</td></tr>
<tr><td>image.Alpha16ColorModel</td> <td>color.Alpha16Model</td></tr>
<tr><td>image.GrayColorModel</td> <td>color.GrayModel</td></tr>
<tr><td>image.Gray16ColorModel</td> <td>color.Gray16Model</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>ycbcr.RGBToYCbCr</td> <td>color.RGBToYCbCr</td></tr>
<tr><td>ycbcr.YCbCrToRGB</td> <td>color.YCbCrToRGB</td></tr>
<tr><td>ycbcr.YCbCrColorModel</td> <td>color.YCbCrModel</td></tr>
<tr><td>ycbcr.YCbCrColor</td> <td>color.YCbCr</td></tr>
<tr><td>ycbcr.YCbCr</td> <td>image.YCbCr</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>ycbcr.SubsampleRatio444</td> <td>image.YCbCrSubsampleRatio444</td></tr>
<tr><td>ycbcr.SubsampleRatio422</td> <td>image.YCbCrSubsampleRatio422</td></tr>
<tr><td>ycbcr.SubsampleRatio420</td> <td>image.YCbCrSubsampleRatio420</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>image.ColorImage</td> <td>image.Uniform</td></tr>
</table>

<p>
The image package's <code>New</code> functions
(<a href="/pkg/image/#NewRGBA"><code>NewRGBA</code></a>,
<a href="/pkg/image/#NewRGBA64"><code>NewRGBA64</code></a>, etc.)
take an <a href="/pkg/image/#Rectangle"><code>image.Rectangle</code></a> as an argument
instead of four integers.
</p>

<p>
Finally, there are new predefined <code>color.Color</code> variables
<a href="/pkg/image/color/#Black"><code>color.Black</code></a>,
<a href="/pkg/image/color/#White"><code>color.White</code></a>,
<a href="/pkg/image/color/#Opaque"><code>color.Opaque</code></a>
and
<a href="/pkg/image/color/#Transparent"><code>color.Transparent</code></a>.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update almost all code affected by the change.
</p>

<h3 id="log_syslog">The log/syslog package</h3>

<p>
In Go 1, the <a href="/pkg/log/syslog/#NewLogger"><code>syslog.NewLogger</code></a>
function returns an error as well as a <code>log.Logger</code>.
</p>

<p>
<em>Updating</em>:
What little code is affected will be caught by the compiler and must be updated by hand.
</p>

<h3 id="mime">The mime package</h3>

<p>
In Go 1, the <a href="/pkg/mime/#FormatMediaType"><code>FormatMediaType</code></a> function
of the <code>mime</code> package has  been simplified to make it
consistent with
<a href="/pkg/mime/#ParseMediaType"><code>ParseMediaType</code></a>.
It now takes <code>"text/html"</code> rather than <code>"text"</code> and <code>"html"</code>.
</p>

<p>
<em>Updating</em>:
What little code is affected will be caught by the compiler and must be updated by hand.
</p>

<h3 id="net">The net package</h3>

<p>
In Go 1, the various <code>SetTimeout</code>,
<code>SetReadTimeout</code>, and <code>SetWriteTimeout</code> methods
have been replaced with
<a href="/pkg/net/#IPConn.SetDeadline"><code>SetDeadline</code></a>,
<a href="/pkg/net/#IPConn.SetReadDeadline"><code>SetReadDeadline</code></a>, and
<a href="/pkg/net/#IPConn.SetWriteDeadline"><code>SetWriteDeadline</code></a>,
respectively.  Rather than taking a timeout value in nanoseconds that
apply to any activity on the connection, the new methods set an
absolute deadline (as a <code>time.Time</code> value) after which
reads and writes will time out and no longer block.
</p>

<p>
There are also new functions
<a href="/pkg/net/#DialTimeout"><code>net.DialTimeout</code></a>
to simplify timing out dialing a network address and
<a href="/pkg/net/#ListenMulticastUDP"><code>net.ListenMulticastUDP</code></a>
to allow multicast UDP to listen concurrently across multiple listeners.
The <code>net.ListenMulticastUDP</code> function replaces the old
<code>JoinGroup</code> and <code>LeaveGroup</code> methods.
</p>

<p>
<em>Updating</em>:
Code that uses the old methods will fail to compile and must be updated by hand.
The semantic change makes it difficult for the fix tool to update automatically.
</p>

<h3 id="os">The os package</h3>

<p>
The <code>Time</code> function has been removed; callers should use
the <a href="/pkg/time/#Time"><code>Time</code></a> type from the
<code>time</code> package.
</p>

<p>
The <code>Exec</code> function has been removed; callers should use
<code>Exec</code> from the <code>syscall</code> package, where available.
</p>

<p>
The <code>ShellExpand</code> function has been renamed to <a
href="/pkg/os/#ExpandEnv"><code>ExpandEnv</code></a>.
</p>

<p>
The <a href="/pkg/os/#NewFile"><code>NewFile</code></a> function
now takes a <code>uintptr</code> fd, instead of an <code>int</code>.
The <a href="/pkg/os/#File.Fd"><code>Fd</code></a> method on files now
also returns a <code>uintptr</code>.
</p>

<p>
There are no longer error constants such as <code>EINVAL</code>
in the <code>os</code> package, since the set of values varied with
the underlying operating system. There are new portable functions like
<a href="/pkg/os/#IsPermission"><code>IsPermission</code></a>
to test common error properties, plus a few new error values
with more Go-like names, such as
<a href="/pkg/os/#ErrPermission"><code>ErrPermission</code></a>
and
<a href="/pkg/os/#ErrNotExist"><code>ErrNotExist</code></a>.
</p>

<p>
The <code>Getenverror</code> function has been removed. To distinguish
between a non-existent environment variable and an empty string,
use <a href="/pkg/os/#Environ"><code>os.Environ</code></a> or
<a href="/pkg/syscall/#Getenv"><code>syscall.Getenv</code></a>.
</p>


<p>
The <a href="/pkg/os/#Process.Wait"><code>Process.Wait</code></a> method has
dropped its option argument and the associated constants are gone
from the package.
Also, the function <code>Wait</code> is gone; only the method of
the <code>Process</code> type persists.
</p>

<p>
The <code>Waitmsg</code> type returned by
<a href="/pkg/os/#Process.Wait"><code>Process.Wait</code></a>
has been replaced with a more portable
<a href="/pkg/os/#ProcessState"><code>ProcessState</code></a>
type with accessor methods to recover information about the
process.
Because of changes to <code>Wait</code>, the <code>ProcessState</code>
value always describes an exited process.
Portability concerns simplified the interface in other ways, but the values returned by the
<a href="/pkg/os/#ProcessState.Sys"><code>ProcessState.Sys</code></a> and
<a href="/pkg/os/#ProcessState.SysUsage"><code>ProcessState.SysUsage</code></a>
methods can be type-asserted to underlying system-specific data structures such as
<a href="/pkg/syscall/#WaitStatus"><code>syscall.WaitStatus</code></a> and
<a href="/pkg/syscall/#Rusage"><code>syscall.Rusage</code></a> on Unix.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will drop a zero argument to <code>Process.Wait</code>.
All other changes will be caught by the compiler and must be updated by hand.
</p>

<h4 id="os_fileinfo">The os.FileInfo type</h4>

<p>
Go 1 redefines the <a href="/pkg/os/#FileInfo"><code>os.FileInfo</code></a> type,
changing it from a struct to an interface:
</p>

<pre>
    type FileInfo interface {
        Name() string       // base name of the file
        Size() int64        // length in bytes
        Mode() FileMode     // file mode bits
        ModTime() time.Time // modification time
        IsDir() bool        // abbreviation for Mode().IsDir()
        Sys() interface{}   // underlying data source (can return nil)
    }
</pre>

<p>
The file mode information has been moved into a subtype called
<a href="/pkg/os/#FileMode"><code>os.FileMode</code></a>,
a simple integer type with <code>IsDir</code>, <code>Perm</code>, and <code>String</code>
methods.
</p>

<p>
The system-specific details of file modes and properties such as (on Unix)
i-number have been removed from <code>FileInfo</code> altogether.
Instead, each operating system's <code>os</code> package provides an
implementation of the <code>FileInfo</code> interface, which
has a <code>Sys</code> method that returns the
system-specific representation of file metadata.
For instance, to discover the i-number of a file on a Unix system, unpack
the <code>FileInfo</code> like this:
</p>

<pre>
    fi, err := os.Stat("hello.go")
    if err != nil {
        log.Fatal(err)
    }
    // Check that it's a Unix file.
    unixStat, ok := fi.Sys().(*syscall.Stat_t)
    if !ok {
        log.Fatal("hello.go: not a Unix file")
    }
    fmt.Printf("file i-number: %d\n", unixStat.Ino)
</pre>

<p>
Assuming (which is unwise) that <code>"hello.go"</code> is a Unix file,
the i-number expression could be contracted to
</p>

<pre>
    fi.Sys().(*syscall.Stat_t).Ino
</pre>

<p>
The vast majority of uses of <code>FileInfo</code> need only the methods
of the standard interface.
</p>

<p>
The <code>os</code> package no longer contains wrappers for the POSIX errors
such as <code>ENOENT</code>.
For the few programs that need to verify particular error conditions, there are
now the boolean functions
<a href="/pkg/os/#IsExist"><code>IsExist</code></a>,
<a href="/pkg/os/#IsNotExist"><code>IsNotExist</code></a>
and
<a href="/pkg/os/#IsPermission"><code>IsPermission</code></a>.
</p>

{{code "/doc/progs/go1.go" `/os\.Open/` `/}/`}}

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update code that uses the old equivalent of the current <code>os.FileInfo</code>
and <code>os.FileMode</code> API.
Code that needs system-specific file details will need to be updated by hand.
Code that uses the old POSIX error values from the <code>os</code> package
will fail to compile and will also need to be updated by hand.
</p>

<h3 id="os_signal">The os/signal package</h3>

<p>
The <code>os/signal</code> package in Go 1 replaces the
<code>Incoming</code> function, which returned a channel
that received all incoming signals,
with the selective <code>Notify</code> function, which asks
for delivery of specific signals on an existing channel.
</p>

<p>
<em>Updating</em>:
Code must be updated by hand.
A literal translation of
</p>
<pre>
c := signal.Incoming()
</pre>
<p>
is
</p>
<pre>
c := make(chan os.Signal)
signal.Notify(c) // ask for all signals
</pre>
<p>
but most code should list the specific signals it wants to handle instead:
</p>
<pre>
c := make(chan os.Signal)
signal.Notify(c, syscall.SIGHUP, syscall.SIGQUIT)
</pre>

<h3 id="path_filepath">The path/filepath package</h3>

<p>
In Go 1, the <a href="/pkg/path/filepath/#Walk"><code>Walk</code></a> function of the
<code>path/filepath</code> package
has been changed to take a function value of type
<a href="/pkg/path/filepath/#WalkFunc"><code>WalkFunc</code></a>
instead of a <code>Visitor</code> interface value.
<code>WalkFunc</code> unifies the handling of both files and directories.
</p>

<pre>
    type WalkFunc func(path string, info os.FileInfo, err error) error
</pre>

<p>
The <code>WalkFunc</code> function will be called even for files or directories that could not be opened;
in such cases the error argument will describe the failure.
If a directory's contents are to be skipped,
the function should return the value <a href="/pkg/path/filepath/#pkg-variables"><code>filepath.SkipDir</code></a>
</p>

{{code "/doc/progs/go1.go" `/STARTWALK/` `/ENDWALK/`}}

<p>
<em>Updating</em>:
The change simplifies most code but has subtle consequences, so affected programs
will need to be updated by hand.
The compiler will catch code using the old interface.
</p>

<h3 id="regexp">The regexp package</h3>

<p>
The <a href="/pkg/regexp/"><code>regexp</code></a> package has been rewritten.
It has the same interface but the specification of the regular expressions
it supports has changed from the old "egrep" form to that of
<a href="//code.google.com/p/re2/">RE2</a>.
</p>

<p>
<em>Updating</em>:
Code that uses the package should have its regular expressions checked by hand.
</p>

<h3 id="runtime">The runtime package</h3>

<p>
In Go 1, much of the API exported by package
<code>runtime</code> has been removed in favor of
functionality provided by other packages.
Code using the <code>runtime.Type</code> interface
or its specific concrete type implementations should
now use package <a href="/pkg/reflect/"><code>reflect</code></a>.
Code using <code>runtime.Semacquire</code> or <code>runtime.Semrelease</code>
should use channels or the abstractions in package <a href="/pkg/sync/"><code>sync</code></a>.
The <code>runtime.Alloc</code>, <code>runtime.Free</code>,
and <code>runtime.Lookup</code> functions, an unsafe API created for
debugging the memory allocator, have no replacement.
</p>

<p>
Before, <code>runtime.MemStats</code> was a global variable holding
statistics about memory allocation, and calls to <code>runtime.UpdateMemStats</code>
ensured that it was up to date.
In Go 1, <code>runtime.MemStats</code> is a struct type, and code should use
<a href="/pkg/runtime/#ReadMemStats"><code>runtime.ReadMemStats</code></a>
to obtain the current statistics.
</p>

<p>
The package adds a new function,
<a href="/pkg/runtime/#NumCPU"><code>runtime.NumCPU</code></a>, that returns the number of CPUs available
for parallel execution, as reported by the operating system kernel.
Its value can inform the setting of <code>GOMAXPROCS</code>.
The <code>runtime.Cgocalls</code> and <code>runtime.Goroutines</code> functions
have been renamed to <code>runtime.NumCgoCall</code> and <code>runtime.NumGoroutine</code>.
</p>

<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update code for the function renamings.
Other code will need to be updated by hand.
</p>

<h3 id="strconv">The strconv package</h3>

<p>
In Go 1, the
<a href="/pkg/strconv/"><code>strconv</code></a>
package has been significantly reworked to make it more Go-like and less C-like,
although <code>Atoi</code> lives on (it's similar to
<code>int(ParseInt(x, 10, 0))</code>, as does
<code>Itoa(x)</code> (<code>FormatInt(int64(x), 10)</code>).
There are also new variants of some of the functions that append to byte slices rather than
return strings, to allow control over allocation.
</p>

<p>
This table summarizes the renamings; see the
<a href="/pkg/strconv/">package documentation</a>
for full details.
</p>

<table class="codetable" frame="border" summary="strconv renames">
<colgroup align="left" width="50%"></colgroup>
<colgroup align="left" width="50%"></colgroup>
<tr>
<th align="left">Old call</th>
<th align="left">New call</th>
</tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Atob(x)</td> <td>ParseBool(x)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Atof32(x)</td> <td>ParseFloat(x, 32)¬ß</td></tr>
<tr><td>Atof64(x)</td> <td>ParseFloat(x, 64)</td></tr>
<tr><td>AtofN(x, n)</td> <td>ParseFloat(x, n)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Atoi(x)</td> <td>Atoi(x)</td></tr>
<tr><td>Atoi(x)</td> <td>ParseInt(x, 10, 0)¬ß</td></tr>
<tr><td>Atoi64(x)</td> <td>ParseInt(x, 10, 64)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Atoui(x)</td> <td>ParseUint(x, 10, 0)¬ß</td></tr>
<tr><td>Atoui64(x)</td> <td>ParseUint(x, 10, 64)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Btoi64(x, b)</td> <td>ParseInt(x, b, 64)</td></tr>
<tr><td>Btoui64(x, b)</td> <td>ParseUint(x, b, 64)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Btoa(x)</td> <td>FormatBool(x)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Ftoa32(x, f, p)</td> <td>FormatFloat(float64(x), f, p, 32)</td></tr>
<tr><td>Ftoa64(x, f, p)</td> <td>FormatFloat(x, f, p, 64)</td></tr>
<tr><td>FtoaN(x, f, p, n)</td> <td>FormatFloat(x, f, p, n)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Itoa(x)</td> <td>Itoa(x)</td></tr>
<tr><td>Itoa(x)</td> <td>FormatInt(int64(x), 10)</td></tr>
<tr><td>Itoa64(x)</td> <td>FormatInt(x, 10)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Itob(x, b)</td> <td>FormatInt(int64(x), b)</td></tr>
<tr><td>Itob64(x, b)</td> <td>FormatInt(x, b)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Uitoa(x)</td> <td>FormatUint(uint64(x), 10)</td></tr>
<tr><td>Uitoa64(x)</td> <td>FormatUint(x, 10)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Uitob(x, b)</td> <td>FormatUint(uint64(x), b)</td></tr>
<tr><td>Uitob64(x, b)</td> <td>FormatUint(x, b)</td></tr>
</table>
		
<p>
<em>Updating</em>:
Running <code>go</code> <code>fix</code> will update almost all code affected by the change.
<br>
¬ß <code>Atoi</code> persists but <code>Atoui</code> and <code>Atof32</code> do not, so
they may require
a cast that must be added by hand; the <code>go</code> <code>fix</code> tool will warn about it.
</p>


<h3 id="templates">The template packages</h3>

<p>
The <code>template</code> and <code>exp/template/html</code> packages have moved to 
<a href="/pkg/text/template/"><code>text/template</code></a> and
<a href="/pkg/html/template/"><code>html/template</code></a>.
More significant, the interface to these packages has been simplified.
The template language is the same, but the concept of "template set" is gone
and the functions and methods of the packages have changed accordingly,
often by elimination.
</p>

<p>
Instead of sets, a <code>Template</code> object
may contain multiple named template definitions,
in effect constructing
name spaces for template invocation.
A template can invoke any other template associated with it, but only those
templates associated with it.
The simplest way to associate templates is to parse them together, something
made easier with the new structure of the packages.
</p>

<p>
<em>Updating</em>:
The imports will be updated by fix tool.
Single-template uses will be otherwise be largely unaffected.
Code that uses multiple templates in concert will need to be updated by hand.
The <a href="/pkg/text/template/#pkg-examples">examples</a> in
the documentation for <code>text/template</code> can provide guidance.
</p>

<h3 id="testing">The testing package</h3>

<p>
The testing package has a type, <code>B</code>, passed as an argument to benchmark functions.
In Go 1, <code>B</code> has new methods, analogous to those of <code>T</code>, enabling
logging and failure reporting.
</p>

{{code "/doc/progs/go1.go" `/func.*Benchmark/` `/^}/`}}

<p>
<em>Updating</em>:
Existing code is unaffected, although benchmarks that use <code>println</code>
or <code>panic</code> should be updated to use the new methods.
</p>

<h3 id="testing_script">The testing/script package</h3>

<p>
The testing/script package has been deleted. It was a dreg.
</p>

<p>
<em>Updating</em>:
No code is likely to be affected.
</p>

<h3 id="unsafe">The unsafe package</h3>

<p>
In Go 1, the functions
<code>unsafe.Typeof</code>, <code>unsafe.Reflect</code>,
<code>unsafe.Unreflect</code>, <code>unsafe.New</code>, and
<code>unsafe.NewArray</code> have been removed;
they duplicated safer functionality provided by
package <a href="/pkg/reflect/"><code>reflect</code></a>.
</p>

<p>
<em>Updating</em>:
Code using these functions must be rewritten to use
package <a href="/pkg/reflect/"><code>reflect</code></a>.
The changes to <a href="//golang.org/change/2646dc956207">encoding/gob</a> and the <a href="//code.google.com/p/goprotobuf/source/detail?r=5340ad310031">protocol buffer library</a>
may be helpful as examples.
</p>

<h3 id="url">The url package</h3>

<p>
In Go 1 several fields from the <a href="/pkg/net/url/#URL"><code>url.URL</code></a> type
were removed or replaced.
</p>

<p>
The <a href="/pkg/net/url/#URL.String"><code>String</code></a> method now
predictably rebuilds an encoded URL string using all of <code>URL</code>'s
fields as necessary. The resulting string will also no longer have
passwords escaped.
</p>

<p>
The <code>Raw</code> field has been removed. In most cases the <code>String</code>
method may be used in its place.
</p>

<p>
The old <code>RawUserinfo</code> field is replaced by the <code>User</code>
field, of type <a href="/pkg/net/url/#Userinfo"><code>*net.Userinfo</code></a>.
Values of this type may be created using the new <a href="/pkg/net/url/#User"><code>net.User</code></a>
and <a href="/pkg/net/url/#UserPassword"><code>net.UserPassword</code></a>
functions. The <code>EscapeUserinfo</code> and <code>UnescapeUserinfo</code>
functions are also gone.
</p>

<p>
The <code>RawAuthority</code> field has been removed. The same information is
available in the <code>Host</code> and <code>User</code> fields.
</p>

<p>
The <code>RawPath</code> field and the <code>EncodedPath</code> method have
been removed. The path information in rooted URLs (with a slash following the
schema) is now available only in decoded form in the <code>Path</code> field.
Occasionally, the encoded data may be required to obtain information that
was lost in the decoding process. These cases must be handled by accessing
the data the URL was built from.
</p>

<p>
URLs with non-rooted paths, such as <code>"mailto:dev@golang.org?subject=Hi"</code>,
are also handled differently. The <code>OpaquePath</code> boolean field has been
removed and a new <code>Opaque</code> string field introduced to hold the encoded
path for such URLs. In Go 1, the cited URL parses as:
</p>

<pre>
    URL{
        Scheme: "mailto",
        Opaque: "dev@golang.org",
        RawQuery: "subject=Hi",
    }
</pre>

<p>
A new <a href="/pkg/net/url/#URL.RequestURI"><code>RequestURI</code></a> method was
added to <code>URL</code>.
</p>

<p>
The <code>ParseWithReference</code> function has been renamed to <code>ParseWithFragment</code>.
</p>

<p>
<em>Updating</em>:
Code that uses the old fields will fail to compile and must be updated by hand.
The semantic changes make it difficult for the fix tool to update automatically.
</p>

<h2 id="cmd_go">The go command</h2>

<p>
Go 1 introduces the <a href="/cmd/go/">go command</a>, a tool for fetching,
building, and installing Go packages and commands. The <code>go</code> command
does away with makefiles, instead using Go source code to find dependencies and
determine build conditions. Most existing Go programs will no longer require
makefiles to be built.
</p>

<p>
See <a href="/doc/code.html">How to Write Go Code</a> for a primer on the
<code>go</code> command and the <a href="/cmd/go/">go command documentation</a>
for the full details.
</p>

<p>
<em>Updating</em>:
Projects that depend on the Go project's old makefile-based build
infrastructure (<code>Make.pkg</code>, <code>Make.cmd</code>, and so on) should
switch to using the <code>go</code> command for building Go code and, if
necessary, rewrite their makefiles to perform any auxiliary build tasks.
</p>

<h2 id="cmd_cgo">The cgo command</h2>

<p>
In Go 1, the <a href="/cmd/cgo">cgo command</a>
uses a different <code>_cgo_export.h</code>
file, which is generated for packages containing <code>//export</code> lines.
The <code>_cgo_export.h</code> file now begins with the C preamble comment,
so that exported function definitions can use types defined there.
This has the effect of compiling the preamble multiple times, so a
package using <code>//export</code> must not put function definitions
or variable initializations in the C preamble.
</p>

<h2 id="releases">Packaged releases</h2>

<p>
One of the most significant changes associated with Go 1 is the availability
of prepackaged, downloadable distributions.
They are available for many combinations of architecture and operating system
(including Windows) and the list will grow.
Installation details are described on the
<a href="/doc/install">Getting Started</a> page, while
the distributions themselves are listed on the
<a href="https://golang.org/dl/">downloads page</a>.
                                                                                                                                                                                                    root/go1.4/doc/go1compat.html                                                                       0100644 0000000 0000000 00000015234 12600426226 014412  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Go 1 and the Future of Go Programs",
	"Path":  "/doc/go1compat"
}-->

<h2 id="introduction">Introduction</h2>
<p>
The release of Go version 1, Go 1 for short, is a major milestone
in the development of the language. Go 1 is a stable platform for
the growth of programs and projects written in Go.
</p>

<p>
Go 1 defines two things: first, the specification of the language;
and second, the specification of a set of core APIs, the "standard
packages" of the Go library. The Go 1 release includes their
implementation in the form of two compiler suites (gc and gccgo),
and the core libraries themselves.
</p>

<p>
It is intended that programs written to the Go 1 specification will
continue to compile and run correctly, unchanged, over the lifetime
of that specification. At some indefinite point, a Go 2 specification
may arise, but until that time, Go programs that work today should
continue to work even as future "point" releases of Go 1 arise (Go
1.1, Go 1.2, etc.).
</p>

<p>
Compatibility is at the source level. Binary compatibility for
compiled packages is not guaranteed between releases. After a point
release, Go source will need to be recompiled to link against the
new release.
</p>

<p>
The APIs may grow, acquiring new packages and features, but not in
a way that breaks existing Go 1 code.
</p>

<h2 id="expectations">Expectations</h2>

<p>
Although we expect that the vast majority of programs will maintain
this compatibility over time, it is impossible to guarantee that
no future change will break any program. This document is an attempt
to set expectations for the compatibility of Go 1 software in the
future. There are a number of ways in which a program that compiles
and runs today may fail to do so after a future point release. They
are all unlikely but worth recording.
</p>

<ul>
<li>
Security. A security issue in the specification or implementation
may come to light whose resolution requires breaking compatibility.
We reserve the right to address such security issues.
</li>

<li>
Unspecified behavior. The Go specification tries to be explicit
about most properties of the language, but there are some aspects
that are undefined. Programs that depend on such unspecified behavior
may break in future releases.
</li>

<li>
Specification errors. If it becomes necessary to address an
inconsistency or incompleteness in the specification, resolving the
issue could affect the meaning or legality of existing programs.
We reserve the right to address such issues, including updating the
implementations. Except for security issues, no incompatible changes
to the specification would be made.
</li>

<li>
Bugs. If a compiler or library has a bug that violates the
specification, a program that depends on the buggy behavior may
break if the bug is fixed. We reserve the right to fix such bugs.
</li>

<li>
Struct literals. For the addition of features in later point
releases, it may be necessary to add fields to exported structs in
the API. Code that uses unkeyed struct literals (such as pkg.T{3,
"x"}) to create values of these types would fail to compile after
such a change. However, code that uses keyed literals (pkg.T{A:
3, B: "x"}) will continue to compile after such a change. We will
update such data structures in a way that allows keyed struct
literals to remain compatible, although unkeyed literals may fail
to compile. (There are also more intricate cases involving nested
data structures or interfaces, but they have the same resolution.)
We therefore recommend that composite literals whose type is defined
in a separate package should use the keyed notation.
</li>

<li>
Dot imports. If a program imports a standard package
using <code>import . "path"</code>, additional names defined in the
imported package in future releases may conflict with other names
defined in the program.  We do not recommend the use of <code>import .</code>
outside of tests, and using it may cause a program to fail
to compile in future releases.
</li>

<li>
Use of package <code>unsafe</code>. Packages that import
<a href="/pkg/unsafe/"><code>unsafe</code></a>
may depend on internal properties of the Go implementation.
We reserve the right to make changes to the implementation
that may break such programs.
</li>

</ul>

<p>
Of course, for all of these possibilities, should they arise, we
would endeavor whenever feasible to update the specification,
compilers, or libraries without affecting existing code.
</p>

<p>
These same considerations apply to successive point releases. For
instance, code that runs under Go 1.2 should be compatible with Go
1.2.1, Go 1.3, Go 1.4, etc., although not necessarily with Go 1.1
since it may use features added only in Go 1.2
</p>

<p>
Features added between releases, available in the source repository
but not part of the numbered binary releases, are under active
development. No promise of compatibility is made for software using
such features until they have been released.
</p>

<p>
Finally, although it is not a correctness issue, it is possible
that the performance of a program may be affected by
changes in the implementation of the compilers or libraries upon
which it depends.
No guarantee can be made about the performance of a
given program between releases.
</p>

<p>
Although these expectations apply to Go 1 itself, we hope similar
considerations would be made for the development of externally
developed software based on Go 1.
</p>

<h2 id="subrepos">Sub-repositories</h2>

<p>
Code in sub-repositories of the main go tree, such as
<a href="//golang.org/x/net">golang.org/x/net</a>,
may be developed under
looser compatibility requirements. However, the sub-repositories
will be tagged as appropriate to identify versions that are compatible
with the Go 1 point releases.
</p>

<h2 id="operating_systems">Operating systems</h2>

<p>
It is impossible to guarantee long-term compatibility with operating
system interfaces, which are changed by outside parties.
The <a href="/pkg/syscall/"><code>syscall</code></a> package
is therefore outside the purview of the guarantees made here.
As of Go version 1.4, the <code>syscall</code> package is frozen.
Any evolution of the system call interface must be supported elsewhere,
such as in the
<a href="//golang.org/x/sys">go.sys</a> subrepository.
For details and background, see
<a href="//golang.org/s/go1.4-syscall">this document</a>.
</p>

<h2 id="tools">Tools</h2>

<p>
Finally, the Go tool chain (compilers, linkers, build tools, and so
on) are under active development and may change behavior. This
means, for instance, that scripts that depend on the location and
properties of the tools may be broken by a point release.
</p>

<p>
These caveats aside, we believe that Go 1 will be a firm foundation
for the development of Go and its ecosystem.
</p>
                                                                                                                                                                                                                                                                                                                                                                    root/go1.4/doc/go_faq.html                                                                          0100644 0000000 0000000 00000210145 12600426226 013752  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Frequently Asked Questions (FAQ)",
	"Path": "/doc/faq"
}-->

<h2 id="Origins">Origins</h2>

<h3 id="What_is_the_purpose_of_the_project">
What is the purpose of the project?</h3>

<p>
No major systems language has emerged in over a decade, but over that time
the computing landscape has changed tremendously. There are several trends:
</p>

<ul>
<li>
Computers are enormously quicker but software development is not faster.
<li>
Dependency management is a big part of software development today but the
&ldquo;header files&rdquo; of languages in the C tradition are antithetical to clean
dependency analysis&mdash;and fast compilation.
<li>
There is a growing rebellion against cumbersome type systems like those of
Java and C++, pushing people towards dynamically typed languages such as
Python and JavaScript.
<li>
Some fundamental concepts such as garbage collection and parallel computation
are not well supported by popular systems languages.
<li>
The emergence of multicore computers has generated worry and confusion.
</ul>

<p>
We believe it's worth trying again with a new language, a concurrent,
garbage-collected language with fast compilation. Regarding the points above:
</p>

<ul>
<li>
It is possible to compile a large Go program in a few seconds on a single computer.
<li>
Go provides a model for software construction that makes dependency
analysis easy and avoids much of the overhead of C-style include files and
libraries.
<li>
Go's type system has no hierarchy, so no time is spent defining the
relationships between types. Also, although Go has static types the language
attempts to make types feel lighter weight than in typical OO languages.
<li>
Go is fully garbage-collected and provides fundamental support for
concurrent execution and communication.
<li>
By its design, Go proposes an approach for the construction of system
software on multicore machines.
</ul>

<p>
A much more expansive answer to this question is available in the article,
<a href="//talks.golang.org/2012/splash.article">Go at Google:
Language Design in the Service of Software Engineering</a>.

<h3 id="What_is_the_status_of_the_project">
What is the status of the project?</h3>

<p>
Go became a public open source project on November 10, 2009.
After a couple of years of very active design and development, stability was called for and
Go 1 was <a href="//blog.golang.org/2012/03/go-version-1-is-released.html">released</a>
on March 28, 2012.
Go 1, which includes a <a href="/ref/spec">language specification</a>,
<a href="/pkg/">standard libraries</a>,
and <a href="/cmd/go/">custom tools</a>,
provides a stable foundation for creating reliable products, projects, and publications.
</p>

<p>
With that stability established, we are using Go to develop programs, products, and tools rather than
actively changing the language and libraries.
In fact, the purpose of Go 1 is to provide <a href="/doc/go1compat.html">long-term stability</a>.
Backwards-incompatible changes will not be made to any Go 1 point release.
We want to use what we have to learn how a future version of Go might look, rather than to play with
the language underfoot.
</p>

<p>
Of course, development will continue on Go itself, but the focus will be on performance, reliability,
portability and the addition of new functionality such as improved support for internationalization.
</p>

<p>
There may well be a Go 2 one day, but not for a few years and it will be influenced by what we learn using Go 1 as it is today.
</p>

<h3 id="What_is_the_origin_of_the_name">
What is the origin of the name?</h3>

<p>
&ldquo;Ogle&rdquo; would be a good name for a Go debugger.
</p>

<h3 id="Whats_the_origin_of_the_mascot">
What's the origin of the mascot?</h3>

<p>
The mascot and logo were designed by
<a href="http://reneefrench.blogspot.com">Ren√©e French</a>, who also designed
<a href="http://plan9.bell-labs.com/plan9/glenda.html">Glenda</a>,
the Plan 9 bunny.
The gopher is derived from one she used for an <a href="http://wfmu.org/">WFMU</a>
T-shirt design some years ago.
The logo and mascot are covered by the
<a href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0</a>
license.
</p>

<h3 id="history">
What is the history of the project?</h3>
<p>
Robert Griesemer, Rob Pike and Ken Thompson started sketching the
goals for a new language on the white board on September 21, 2007.
Within a few days the goals had settled into a plan to do something
and a fair idea of what it would be.  Design continued part-time in
parallel with unrelated work.  By January 2008, Ken had started work
on a compiler with which to explore ideas; it generated C code as its
output.  By mid-year the language had become a full-time project and
had settled enough to attempt a production compiler.  In May 2008,
Ian Taylor independently started on a GCC front end for Go using the
draft specification.  Russ Cox joined in late 2008 and helped move the language
and libraries from prototype to reality.
</p>

<p>
Go became a public open source project on November 10, 2009.
Many people from the community have contributed ideas, discussions, and code.
</p>

<h3 id="creating_a_new_language">
Why are you creating a new language?</h3>
<p>
Go was born out of frustration with existing languages and
environments for systems programming.  Programming had become too
difficult and the choice of languages was partly to blame.  One had to
choose either efficient compilation, efficient execution, or ease of
programming; all three were not available in the same mainstream
language.  Programmers who could were choosing ease over
safety and efficiency by moving to dynamically typed languages such as
Python and JavaScript rather than C++ or, to a lesser extent, Java.
</p>

<p>
Go is an attempt to combine the ease of programming of an interpreted,
dynamically typed
language with the efficiency and safety of a statically typed, compiled language.
It also aims to be modern, with support for networked and multicore
computing.  Finally, it is intended to be <i>fast</i>: it should take
at most a few seconds to build a large executable on a single computer.
To meet these goals required addressing a number of
linguistic issues: an expressive but lightweight type system;
concurrency and garbage collection; rigid dependency specification;
and so on.  These cannot be addressed well by libraries or tools; a new
language was called for.
</p>

<p>
The article <a href="//talks.golang.org/2012/splash.article">Go at Google</a>
discusses the background and motivation behind the design of the Go language,
as well as providing more detail about many of the answers presented in this FAQ.
</p>

<h3 id="ancestors">
What are Go's ancestors?</h3>
<p>
Go is mostly in the C family (basic syntax),
with significant input from the Pascal/Modula/Oberon
family (declarations, packages),
plus some ideas from languages
inspired by Tony Hoare's CSP,
such as Newsqueak and Limbo (concurrency).
However, it is a new language across the board.
In every respect the language was designed by thinking
about what programmers do and how to make programming, at least the
kind of programming we do, more effective, which means more fun.
</p>

<h3 id="principles">
What are the guiding principles in the design?</h3>
<p>
Programming today involves too much bookkeeping, repetition, and
clerical work.  As Dick Gabriel says, &ldquo;Old programs read
like quiet conversations between a well-spoken research worker and a
well-studied mechanical colleague, not as a debate with a compiler.
Who'd have guessed sophistication bought such noise?&rdquo;
The sophistication is worthwhile&mdash;no one wants to go back to
the old languages&mdash;but can it be more quietly achieved?
</p>
<p>
Go attempts to reduce the amount of typing in both senses of the word.
Throughout its design, we have tried to reduce clutter and
complexity.  There are no forward declarations and no header files;
everything is declared exactly once.  Initialization is expressive,
automatic, and easy to use.  Syntax is clean and light on keywords.
Stuttering (<code>foo.Foo* myFoo = new(foo.Foo)</code>) is reduced by
simple type derivation using the <code>:=</code>
declare-and-initialize construct.  And perhaps most radically, there
is no type hierarchy: types just <i>are</i>, they don't have to
announce their relationships.  These simplifications allow Go to be
expressive yet comprehensible without sacrificing, well, sophistication.
</p>
<p>
Another important principle is to keep the concepts orthogonal.
Methods can be implemented for any type; structures represent data while
interfaces represent abstraction; and so on.  Orthogonality makes it
easier to understand what happens when things combine.
</p>

<h2 id="Usage">Usage</h2>

<h3 id="Is_Google_using_go_internally"> Is Google using Go internally?</h3>

<p>
Yes. There are now several Go programs deployed in
production inside Google.  A public example is the server behind
<a href="//golang.org">golang.org</a>.
It's just the <a href="/cmd/godoc"><code>godoc</code></a>
document server running in a production configuration on
<a href="https://developers.google.com/appengine/">Google App Engine</a>.
</p>

<p>
Other examples include the <a href="//code.google.com/p/vitess/">Vitess</a>
system for large-scale SQL installations and Google's download server, <code>dl.google.com</code>,
which delivers Chrome binaries and other large installables such as <code>apt-get</code>
packages.
</p>

<h3 id="Do_Go_programs_link_with_Cpp_programs">
Do Go programs link with C/C++ programs?</h3>

<p>
There are two Go compiler implementations, <code>gc</code>
(the <code>6g</code> program and friends) and <code>gccgo</code>.
<code>Gc</code> uses a different calling convention and linker and can
therefore only be linked with C programs using the same convention.
There is such a C compiler but no C++ compiler.
<code>Gccgo</code> is a GCC front-end that can, with care, be linked with
GCC-compiled C or C++ programs.
</p>

<p>
The <a href="/cmd/cgo/">cgo</a> program provides the mechanism for a
&ldquo;foreign function interface&rdquo; to allow safe calling of
C libraries from Go code. SWIG extends this capability to C++ libraries.
</p>


<h3 id="Does_Go_support_Google_protocol_buffers">
Does Go support Google's protocol buffers?</h3>

<p>
A separate open source project provides the necessary compiler plugin and library.
It is available at
<a href="//code.google.com/p/goprotobuf/">code.google.com/p/goprotobuf/</a>
</p>


<h3 id="Can_I_translate_the_Go_home_page">
Can I translate the Go home page into another language?</h3>

<p>
Absolutely. We encourage developers to make Go Language sites in their own languages.
However, if you choose to add the Google logo or branding to your site
(it does not appear on <a href="//golang.org/">golang.org</a>),
you will need to abide by the guidelines at
<a href="//www.google.com/permissions/guidelines.html">www.google.com/permissions/guidelines.html</a>
</p>

<h2 id="Design">Design</h2>

<h3 id="unicode_identifiers">
What's up with Unicode identifiers?</h3>

<p>
It was important to us to extend the space of identifiers from the
confines of ASCII.  Go's rule&mdash;identifier characters must be
letters or digits as defined by Unicode&mdash;is simple to understand
and to implement but has restrictions.  Combining characters are
excluded by design, for instance.
Until there
is an agreed external definition of what an identifier might be,
plus a definition of canonicalization of identifiers that guarantees
no ambiguity, it seemed better to keep combining characters out of
the mix.  Thus we have a simple rule that can be expanded later
without breaking programs, one that avoids bugs that would surely arise
from a rule that admits ambiguous identifiers.
</p>

<p>
On a related note, since an exported identifier must begin with an
upper-case letter, identifiers created from &ldquo;letters&rdquo;
in some languages can, by definition, not be exported.  For now the
only solution is to use something like <code>XÊó•Êú¨Ë™û</code>, which
is clearly unsatisfactory; we are considering other options.  The
case-for-visibility rule is unlikely to change however; it's one
of our favorite features of Go.
</p>

<h3 id="Why_doesnt_Go_have_feature_X">Why does Go not have feature X?</h3>

<p>
Every language contains novel features and omits someone's favorite
feature. Go was designed with an eye on felicity of programming, speed of
compilation, orthogonality of concepts, and the need to support features
such as concurrency and garbage collection. Your favorite feature may be
missing because it doesn't fit, because it affects compilation speed or
clarity of design, or because it would make the fundamental system model
too difficult.
</p>

<p>
If it bothers you that Go is missing feature <var>X</var>,
please forgive us and investigate the features that Go does have. You might find that
they compensate in interesting ways for the lack of <var>X</var>.
</p>

<h3 id="generics">
Why does Go not have generic types?</h3>
<p>
Generics may well be added at some point.  We don't feel an urgency for
them, although we understand some programmers do.
</p>

<p>
Generics are convenient but they come at a cost in
complexity in the type system and run-time.  We haven't yet found a
design that gives value proportionate to the complexity, although we
continue to think about it.  Meanwhile, Go's built-in maps and slices,
plus the ability to use the empty interface to construct containers
(with explicit unboxing) mean in many cases it is possible to write
code that does what generics would enable, if less smoothly.
</p>

<p>
This remains an open issue.
</p>

<h3 id="exceptions">
Why does Go not have exceptions?</h3>
<p>
We believe that coupling exceptions to a control
structure, as in the <code>try-catch-finally</code> idiom, results in
convoluted code.  It also tends to encourage programmers to label
too many ordinary errors, such as failing to open a file, as
exceptional.
</p>

<p>
Go takes a different approach.  For plain error handling, Go's multi-value
returns make it easy to report an error without overloading the return value.
<a href="/doc/articles/error_handling.html">A canonical error type, coupled
with Go's other features</a>, makes error handling pleasant but quite different
from that in other languages.
</p>

<p>
Go also has a couple
of built-in functions to signal and recover from truly exceptional
conditions.  The recovery mechanism is executed only as part of a
function's state being torn down after an error, which is sufficient
to handle catastrophe but requires no extra control structures and,
when used well, can result in clean error-handling code.
</p>

<p>
See the <a href="/doc/articles/defer_panic_recover.html">Defer, Panic, and Recover</a> article for details.
</p>

<h3 id="assertions">
Why does Go not have assertions?</h3>

<p>
Go doesn't provide assertions. They are undeniably convenient, but our
experience has been that programmers use them as a crutch to avoid thinking
about proper error handling and reporting. Proper error handling means that
servers continue operation after non-fatal errors instead of crashing.
Proper error reporting means that errors are direct and to the point,
saving the programmer from interpreting a large crash trace. Precise
errors are particularly important when the programmer seeing the errors is
not familiar with the code.
</p>

<p>
We understand that this is a point of contention. There are many things in
the Go language and libraries that differ from modern practices, simply
because we feel it's sometimes worth trying a different approach.
</p>

<h3 id="csp">
Why build concurrency on the ideas of CSP?</h3>
<p>
Concurrency and multi-threaded programming have a reputation
for difficulty.  We believe this is due partly to complex
designs such as pthreads and partly to overemphasis on low-level details
such as mutexes, condition variables, and memory barriers.
Higher-level interfaces enable much simpler code, even if there are still
mutexes and such under the covers.
</p>

<p>
One of the most successful models for providing high-level linguistic support
for concurrency comes from Hoare's Communicating Sequential Processes, or CSP.
Occam and Erlang are two well known languages that stem from CSP.
Go's concurrency primitives derive from a different part of the family tree
whose main contribution is the powerful notion of channels as first class objects.
Experience with several earlier languages has shown that the CSP model
fits well into a procedural language framework.
</p>

<h3 id="goroutines">
Why goroutines instead of threads?</h3>
<p>
Goroutines are part of making concurrency easy to use.  The idea, which has
been around for a while, is to multiplex independently executing
functions&mdash;coroutines&mdash;onto a set of threads.
When a coroutine blocks, such as by calling a blocking system call,
the run-time automatically moves other coroutines on the same operating
system thread to a different, runnable thread so they won't be blocked.
The programmer sees none of this, which is the point.
The result, which we call goroutines, can be very cheap: they have little
overhead beyond the memory for the stack, which is just a few kilobytes.
</p>

<p>
To make the stacks small, Go's run-time uses resizable, bounded stacks.  A newly
minted goroutine is given a few kilobytes, which is almost always enough.
When it isn't, the run-time grows (and shrinks) the memory for storing
the stack automatically, allowing many goroutines to live in a modest
amount of memory.
The CPU overhead averages about three cheap instructions per function call.
It is practical to create hundreds of thousands of goroutines in the same
address space.
If goroutines were just threads, system resources would
run out at a much smaller number.
</p>

<h3 id="atomic_maps">
Why are map operations not defined to be atomic?</h3>

<p>
After long discussion it was decided that the typical use of maps did not require
safe access from multiple goroutines, and in those cases where it did, the map was
probably part of some larger data structure or computation that was already
synchronized.  Therefore requiring that all map operations grab a mutex would slow
down most programs and add safety to few.  This was not an easy decision,
however, since it means uncontrolled map access can crash the program.
</p>

<p>
The language does not preclude atomic map updates.  When required, such
as when hosting an untrusted program, the implementation could interlock
map access.
</p>

<h3 id="language_changes">
Will you accept my language change?</h3>

<p>
People often suggest improvements to the language‚Äîthe
<a href="//groups.google.com/group/golang-nuts">mailing list</a>
contains a rich history of such discussions‚Äîbut very few of these changes have
been accepted.
</p>

<p>
Although Go is an open source project, the language and libraries are protected
by a <a href="/doc/go1compat.html">compatibility promise</a> that prevents
changes that break existing programs.
If your proposal violates the Go 1 specification we cannot even entertain the
idea, regardless of its merit.
A future major release of Go may be incompatible with Go 1, but we're not ready
to start talking about what that might be.
</p>

<p>
Even if your proposal is compatible with the Go 1 spec, it might
not be in the spirit of Go's design goals.
The article <i><a href="//talks.golang.org/2012/splash.article">Go
at Google: Language Design in the Service of Software Engineering</a></i>
explains Go's origins and the motivation behind its design.
</p>

<h2 id="types">Types</h2>

<h3 id="Is_Go_an_object-oriented_language">
Is Go an object-oriented language?</h3>

<p>
Yes and no. Although Go has types and methods and allows an
object-oriented style of programming, there is no type hierarchy.
The concept of &ldquo;interface&rdquo; in Go provides a different approach that
we believe is easy to use and in some ways more general. There are
also ways to embed types in other types to provide something
analogous&mdash;but not identical&mdash;to subclassing.
Moreover, methods in Go are more general than in C++ or Java:
they can be defined for any sort of data, even built-in types such
as plain, &ldquo;unboxed&rdquo; integers.
They are not restricted to structs (classes).
</p>

<p>
Also, the lack of type hierarchy makes &ldquo;objects&rdquo; in Go feel much more
lightweight than in languages such as C++ or Java.
</p>

<h3 id="How_do_I_get_dynamic_dispatch_of_methods">
How do I get dynamic dispatch of methods?</h3>

<p>
The only way to have dynamically dispatched methods is through an
interface. Methods on a struct or any other concrete type are always resolved statically.
</p>

<h3 id="inheritance">
Why is there no type inheritance?</h3>
<p>
Object-oriented programming, at least in the best-known languages,
involves too much discussion of the relationships between types,
relationships that often could be derived automatically.  Go takes a
different approach.
</p>

<p>
Rather than requiring the programmer to declare ahead of time that two
types are related, in Go a type automatically satisfies any interface
that specifies a subset of its methods.  Besides reducing the
bookkeeping, this approach has real advantages.  Types can satisfy
many interfaces at once, without the complexities of traditional
multiple inheritance.
Interfaces can be very lightweight&mdash;an interface with
one or even zero methods can express a useful concept.
Interfaces can be added after the fact if a new idea comes along
or for testing&mdash;without annotating the original types.
Because there are no explicit relationships between types
and interfaces, there is no type hierarchy to manage or discuss.
</p>

<p>
It's possible to use these ideas to construct something analogous to
type-safe Unix pipes.  For instance, see how <code>fmt.Fprintf</code>
enables formatted printing to any output, not just a file, or how the
<code>bufio</code> package can be completely separate from file I/O,
or how the <code>image</code> packages generate compressed
image files.  All these ideas stem from a single interface
(<code>io.Writer</code>) representing a single method
(<code>Write</code>).  And that's only scratching the surface.
Go's interfaces have a profound influence on how programs are structured.
</p>

<p>
It takes some getting used to but this implicit style of type
dependency is one of the most productive things about Go.
</p>

<h3 id="methods_on_basics">
Why is <code>len</code> a function and not a method?</h3>
<p>
We debated this issue but decided
implementing <code>len</code> and friends as functions was fine in practice and
didn't complicate questions about the interface (in the Go type sense)
of basic types.
</p>

<h3 id="overloading">
Why does Go not support overloading of methods and operators?</h3>
<p>
Method dispatch is simplified if it doesn't need to do type matching as well.
Experience with other languages told us that having a variety of
methods with the same name but different signatures was occasionally useful
but that it could also be confusing and fragile in practice.  Matching only by name
and requiring consistency in the types was a major simplifying decision
in Go's type system.
</p>

<p>
Regarding operator overloading, it seems more a convenience than an absolute
requirement.  Again, things are simpler without it.
</p>

<h3 id="implements_interface">
Why doesn't Go have "implements" declarations?</h3>

<p>
A Go type satisfies an interface by implementing the methods of that interface,
nothing more.  This property allows interfaces to be defined and used without
having to modify existing code.  It enables a kind of structural typing that
promotes separation of concerns and improves code re-use, and makes it easier
to build on patterns that emerge as the code develops.
The semantics of interfaces is one of the main reasons for Go's nimble,
lightweight feel.
</p>

<p>
See the <a href="#inheritance">question on type inheritance</a> for more detail.
</p>

<h3 id="guarantee_satisfies_interface">
How can I guarantee my type satisfies an interface?</h3>

<p>
You can ask the compiler to check that the type <code>T</code> implements the
interface <code>I</code> by attempting an assignment:
</p>

<pre>
type T struct{}
var _ I = T{}   // Verify that T implements I.
</pre>

<p>
If <code>T</code> doesn't implement <code>I</code>, the mistake will be caught
at compile time.
</p>

<p>
If you wish the users of an interface to explicitly declare that they implement
it, you can add a method with a descriptive name to the interface's method set.
For example:
</p>

<pre>
type Fooer interface {
    Foo()
    ImplementsFooer()
}
</pre>

<p>
A type must then implement the <code>ImplementsFooer</code> method to be a
<code>Fooer</code>, clearly documenting the fact and announcing it in
<a href="/cmd/godoc/">godoc</a>'s output.
</p>

<pre>
type Bar struct{}
func (b Bar) ImplementsFooer() {}
func (b Bar) Foo() {}
</pre>

<p>
Most code doesn't make use of such constraints, since they limit the utility of
the interface idea. Sometimes, though, they're necessary to resolve ambiguities
among similar interfaces.
</p>

<h3 id="t_and_equal_interface">
Why doesn't type T satisfy the Equal interface?</h3>

<p>
Consider this simple interface to represent an object that can compare
itself with another value:
</p>

<pre>
type Equaler interface {
    Equal(Equaler) bool
}
</pre>

<p>
and this type, <code>T</code>:
</p>

<pre>
type T int
func (t T) Equal(u T) bool { return t == u } // does not satisfy Equaler
</pre>

<p>
Unlike the analogous situation in some polymorphic type systems,
<code>T</code> does not implement <code>Equaler</code>.
The argument type of <code>T.Equal</code> is <code>T</code>,
not literally the required type <code>Equaler</code>.
</p>

<p>
In Go, the type system does not promote the argument of
<code>Equal</code>; that is the programmer's responsibility, as
illustrated by the type <code>T2</code>, which does implement
<code>Equaler</code>:
</p>

<pre>
type T2 int
func (t T2) Equal(u Equaler) bool { return t == u.(T2) }  // satisfies Equaler
</pre>

<p>
Even this isn't like other type systems, though, because in Go <em>any</em>
type that satisfies <code>Equaler</code> could be passed as the
argument to <code>T2.Equal</code>, and at run time we must
check that the argument is of type <code>T2</code>.
Some languages arrange to make that guarantee at compile time.
</p>

<p>
A related example goes the other way:
</p>

<pre>
type Opener interface {
   Open() Reader
}

func (t T3) Open() *os.File
</pre>

<p>
In Go, <code>T3</code> does not satisfy <code>Opener</code>,
although it might in another language.
</p>

<p>
While it is true that Go's type system does less for the programmer
in such cases, the lack of subtyping makes the rules about
interface satisfaction very easy to state: are the function's names
and signatures exactly those of the interface?
Go's rule is also easy to implement efficiently.
We feel these benefits offset the lack of
automatic type promotion. Should Go one day adopt some form of generic
typing, we expect there would be a way to express the idea of these
examples and also have them be statically checked.
</p>

<h3 id="convert_slice_of_interface">
Can I convert a []T to an []interface{}?</h3>

<p>
Not directly, because they do not have the same representation in memory.
It is necessary to copy the elements individually to the destination
slice. This example converts a slice of <code>int</code> to a slice of
<code>interface{}</code>:
</p>

<pre>
t := []int{1, 2, 3, 4}
s := make([]interface{}, len(t))
for i, v := range t {
    s[i] = v
}
</pre>

<h3 id="nil_error">
Why is my nil error value not equal to nil?
</h3>

<p>
Under the covers, interfaces are implemented as two elements, a type and a value.
The value, called the interface's dynamic value,
is an arbitrary concrete value and the type is that of the value.
For the <code>int</code> value 3, an interface value contains,
schematically, (<code>int</code>, <code>3</code>).
</p>

<p>
An interface value is <code>nil</code> only if the inner value and type are both unset,
(<code>nil</code>, <code>nil</code>).
In particular, a <code>nil</code> interface will always hold a <code>nil</code> type.
If we store a pointer of type <code>*int</code> inside
an interface value, the inner type will be <code>*int</code> regardless of the value of the pointer:
(<code>*int</code>, <code>nil</code>).
Such an interface value will therefore be non-<code>nil</code>
<em>even when the pointer inside is</em> <code>nil</code>.
</p>

<p>
This situation can be confusing, and often arises when a <code>nil</code> value is
stored inside an interface value such as an <code>error</code> return:
</p>

<pre>
func returnsError() error {
	var p *MyError = nil
	if bad() {
		p = ErrBad
	}
	return p // Will always return a non-nil error.
}
</pre>

<p>
If all goes well, the function returns a <code>nil</code> <code>p</code>,
so the return value is an <code>error</code> interface
value holding (<code>*MyError</code>, <code>nil</code>).
This means that if the caller compares the returned error to <code>nil</code>,
it will always look as if there was an error even if nothing bad happened.
To return a proper <code>nil</code> <code>error</code> to the caller,
the function must return an explicit <code>nil</code>:
</p>


<pre>
func returnsError() error {
	if bad() {
		return ErrBad
	}
	return nil
}
</pre>

<p>
It's a good idea for functions
that return errors always to use the <code>error</code> type in
their signature (as we did above) rather than a concrete type such
as <code>*MyError</code>, to help guarantee the error is
created correctly. As an example,
<a href="/pkg/os/#Open"><code>os.Open</code></a>
returns an <code>error</code> even though, if not <code>nil</code>,
it's always of concrete type
<a href="/pkg/os/#PathError"><code>*os.PathError</code></a>.
</p>

<p>
Similar situations to those described here can arise whenever interfaces are used.
Just keep in mind that if any concrete value
has been stored in the interface, the interface will not be <code>nil</code>.
For more information, see
<a href="/doc/articles/laws_of_reflection.html">The Laws of Reflection</a>.
</p>


<h3 id="unions">
Why are there no untagged unions, as in C?</h3>

<p>
Untagged unions would violate Go's memory safety
guarantees.
</p>

<h3 id="variant_types">
Why does Go not have variant types?</h3>

<p>
Variant types, also known as algebraic types, provide a way to specify
that a value might take one of a set of other types, but only those
types. A common example in systems programming would specify that an
error is, say, a network error, a security error or an application
error and allow the caller to discriminate the source of the problem
by examining the type of the error. Another example is a syntax tree
in which each node can be a different type: declaration, statement,
assignment and so on.
</p>

<p>
We considered adding variant types to Go, but after discussion
decided to leave them out because they overlap in confusing ways
with interfaces. What would happen if the elements of a variant type
were themselves interfaces?
</p>

<p>
Also, some of what variant types address is already covered by the
language. The error example is easy to express using an interface
value to hold the error and a type switch to discriminate cases.  The
syntax tree example is also doable, although not as elegantly.
</p>

<h2 id="values">Values</h2>

<h3 id="conversions">
Why does Go not provide implicit numeric conversions?</h3>
<p>
The convenience of automatic conversion between numeric types in C is
outweighed by the confusion it causes.  When is an expression unsigned?
How big is the value?  Does it overflow?  Is the result portable, independent
of the machine on which it executes?
It also complicates the compiler; &ldquo;the usual arithmetic conversions&rdquo;
are not easy to implement and inconsistent across architectures.
For reasons of portability, we decided to make things clear and straightforward
at the cost of some explicit conversions in the code.
The definition of constants in Go&mdash;arbitrary precision values free
of signedness and size annotations&mdash;ameliorates matters considerably,
though.
</p>

<p>
A related detail is that, unlike in C, <code>int</code> and <code>int64</code>
are distinct types even if <code>int</code> is a 64-bit type.  The <code>int</code>
type is generic; if you care about how many bits an integer holds, Go
encourages you to be explicit.
</p>

<p>
A blog post, title <a href="http://blog.golang.org/constants">Constants</a>,
explores this topic in more detail.
</p>

<h3 id="builtin_maps">
Why are maps built in?</h3>
<p>
The same reason strings are: they are such a powerful and important data
structure that providing one excellent implementation with syntactic support
makes programming more pleasant.  We believe that Go's implementation of maps
is strong enough that it will serve for the vast majority of uses.
If a specific application can benefit from a custom implementation, it's possible
to write one but it will not be as convenient syntactically; this seems a reasonable tradeoff.
</p>

<h3 id="map_keys">
Why don't maps allow slices as keys?</h3>
<p>
Map lookup requires an equality operator, which slices do not implement.
They don't implement equality because equality is not well defined on such types;
there are multiple considerations involving shallow vs. deep comparison, pointer vs.
value comparison, how to deal with recursive types, and so on.
We may revisit this issue&mdash;and implementing equality for slices
will not invalidate any existing programs&mdash;but without a clear idea of what
equality of slices should mean, it was simpler to leave it out for now.
</p>

<p>
In Go 1, unlike prior releases, equality is defined for structs and arrays, so such
types can be used as map keys. Slices still do not have a definition of equality, though.
</p>

<h3 id="references">
Why are maps, slices, and channels references while arrays are values?</h3>
<p>
There's a lot of history on that topic.  Early on, maps and channels
were syntactically pointers and it was impossible to declare or use a
non-pointer instance.  Also, we struggled with how arrays should work.
Eventually we decided that the strict separation of pointers and
values made the language harder to use.  Changing these
types to act as references to the associated, shared data structures resolved
these issues. This change added some regrettable complexity to the
language but had a large effect on usability: Go became a more
productive, comfortable language when it was introduced.
</p>

<h2 id="Writing_Code">Writing Code</h2>

<h3 id="How_are_libraries_documented">
How are libraries documented?</h3>

<p>
There is a program, <code>godoc</code>, written in Go, that extracts
package documentation from the source code. It can be used on the
command line or on the web. An instance is running at
<a href="/pkg/">golang.org/pkg/</a>.
In fact, <code>godoc</code> implements the full site at
<a href="/">golang.org/</a>.
</p>

<h3 id="Is_there_a_Go_programming_style_guide">
Is there a Go programming style guide?</h3>

<p>
Eventually, there may be a small number of rules to guide things
like naming, layout, and file organization.
The document <a href="effective_go.html">Effective Go</a>
contains some style advice.
More directly, the program <code>gofmt</code> is a pretty-printer
whose purpose is to enforce layout rules; it replaces the usual
compendium of do's and don'ts that allows interpretation.
All the Go code in the repository has been run through <code>gofmt</code>.
</p>

<p>
The document titled
<a href="//golang.org/s/comments">Go Code Review Comments</a>
is a collection of very short essays about details of Go idiom that are often
missed by programmers.
It is a handy reference for people doing code reviews for Go projects.
</p>

<h3 id="How_do_I_submit_patches_to_the_Go_libraries">
How do I submit patches to the Go libraries?</h3>

<p>
The library sources are in the <code>src</code> directory of the repository.
If you want to make a significant change, please discuss on the mailing list before embarking.
</p>

<p>
See the document
<a href="contribute.html">Contributing to the Go project</a>
for more information about how to proceed.
</p>

<h3 id="git_https">
Why does "go get" use HTTPS when cloning a repository?</h3>

<p>
Companies often permit outgoing traffic only on the standard TCP ports 80 (HTTP)
and 443 (HTTPS), blocking outgoing traffic on other ports, including TCP port 9418 
(git) and TCP port 22 (SSH).
When using HTTPS instead of HTTP, <code>git</code> enforces certificate validation by
default, providing protection against man-in-the-middle, eavesdropping and tampering attacks.
The <code>go get</code> command therefore uses HTTPS for safety.
</p>

<p>
If you use <code>git</code> and prefer to push changes through SSH using your existing key 
it's easy to work around this. For GitHub, try one of these solutions:
</p>
<ul>
<li>Manually clone the repository in the expected package directory:
<pre>
$ cd $GOPATH/src/github.com/username
$ git clone git@github.com:username/package.git
</pre>
</li>
<li>Force <code>git push</code> to use the <code>SSH</code> protocol by appending
these two lines to <code>~/.gitconfig</code>:
<pre>
[url "git@github.com:"]
	pushInsteadOf = https://github.com/
</pre>
</li>
</ul>

<h3 id="get_version">
How should I manage package versions using "go get"?</h3>

<p>
"Go get" does not have any explicit concept of package versions.
Versioning is a source of significant complexity, especially in large code bases,
and we are unaware of any approach that works well at scale in a large enough
variety of situations to be appropriate to force on all Go users.
What "go get" and the larger Go toolchain do provide is isolation of
packages with different import paths.
For example, the standard library's <code>html/template</code> and <code>text/template</code>
coexist even though both are "package template".
This observation leads to some advice for package authors and package users.
</p>

<p>
Packages intended for public use should try to maintain backwards compatibility as they evolve.
The <a href="/doc/go1compat.html">Go 1 compatibility guidelines</a> are a good reference here:
don't remove exported names, encourage tagged composite literals, and so on.
If different functionality is required, add a new name instead of changing an old one.
If a complete break is required, create a new package with a new import path.</p>

<p>
If you're using an externally supplied package and worry that it might change in
unexpected ways, the simplest solution is to copy it to your local repository.
(This is the approach Google takes internally.)
Store the copy under a new import path that identifies it as a local copy.
For example, you might copy "original.com/pkg" to "you.com/external/original.com/pkg".
Keith Rarick's <a href="https://github.com/kr/goven">goven</a> is one tool to help automate this process.
</p>

<h2 id="Pointers">Pointers and Allocation</h2>

<h3 id="pass_by_value">
When are function parameters passed by value?</h3>

<p>
As in all languages in the C family, everything in Go is passed by value.
That is, a function always gets a copy of the
thing being passed, as if there were an assignment statement assigning the
value to the parameter.  For instance, passing an <code>int</code> value
to a function makes a copy of the <code>int</code>, and passing a pointer
value makes a copy of the pointer, but not the data it points to.
(See the next section for a discussion of how this affects method receivers.)
</p>

<p>
Map and slice values behave like pointers: they are descriptors that
contain pointers to the underlying map or slice data.  Copying a map or
slice value doesn't copy the data it points to.  Copying an interface value
makes a copy of the thing stored in the interface value.  If the interface
value holds a struct, copying the interface value makes a copy of the
struct.  If the interface value holds a pointer, copying the interface value
makes a copy of the pointer, but again not the data it points to.
</p>

<h3 id="pointer_to_interface">
When should I use a pointer to an interface?</h3>

<p>
Almost never. Pointers to interface values arise only in rare, tricky situations involving
disguising an interface value's type for delayed evaluation.
</p>

<p>
It is however a common mistake to pass a pointer to an interface value
to a function expecting an interface. The compiler will complain about this
error but the situation can still be confusing, because sometimes a
<a href="#different_method_sets">pointer
is necessary to satisfy an interface</a>.
The insight is that although a pointer to a concrete type can satisfy
an interface, with one exception <em>a pointer to an interface can never satisfy an interface</em>.
</p>

<p>
Consider the variable declaration,
</p>

<pre>
var w io.Writer
</pre>

<p>
The printing function <code>fmt.Fprintf</code> takes as its first argument
a value that satisfies <code>io.Writer</code>‚Äîsomething that implements
the canonical <code>Write</code> method. Thus we can write
</p>

<pre>
fmt.Fprintf(w, "hello, world\n")
</pre>

<p>
If however we pass the address of <code>w</code>, the program will not compile.
</p>

<pre>
fmt.Fprintf(&amp;w, "hello, world\n") // Compile-time error.
</pre>

<p>
The one exception is that any value, even a pointer to an interface, can be assigned to
a variable of empty interface type (<code>interface{}</code>).
Even so, it's almost certainly a mistake if the value is a pointer to an interface;
the result can be confusing.
</p>

<h3 id="methods_on_values_or_pointers">
Should I define methods on values or pointers?</h3>

<pre>
func (s *MyStruct) pointerMethod() { } // method on pointer
func (s MyStruct)  valueMethod()   { } // method on value
</pre>

<p>
For programmers unaccustomed to pointers, the distinction between these
two examples can be confusing, but the situation is actually very simple.
When defining a method on a type, the receiver (<code>s</code> in the above
examples) behaves exactly as if it were an argument to the method.
Whether to define the receiver as a value or as a pointer is the same
question, then, as whether a function argument should be a value or
a pointer.
There are several considerations.
</p>

<p>
First, and most important, does the method need to modify the
receiver?
If it does, the receiver <em>must</em> be a pointer.
(Slices and maps act as references, so their story is a little
more subtle, but for instance to change the length of a slice
in a method the receiver must still be a pointer.)
In the examples above, if <code>pointerMethod</code> modifies
the fields of <code>s</code>,
the caller will see those changes, but <code>valueMethod</code>
is called with a copy of the caller's argument (that's the definition
of passing a value), so changes it makes will be invisible to the caller.
</p>

<p>
By the way, pointer receivers are identical to the situation in Java,
although in Java the pointers are hidden under the covers; it's Go's
value receivers that are unusual.
</p>

<p>
Second is the consideration of efficiency. If the receiver is large,
a big <code>struct</code> for instance, it will be much cheaper to
use a pointer receiver.
</p>

<p>
Next is consistency. If some of the methods of the type must have
pointer receivers, the rest should too, so the method set is
consistent regardless of how the type is used.
See the section on <a href="#different_method_sets">method sets</a>
for details.
</p>

<p>
For types such as basic types, slices, and small <code>structs</code>,
a value receiver is very cheap so unless the semantics of the method
requires a pointer, a value receiver is efficient and clear.
</p>


<h3 id="new_and_make">
What's the difference between new and make?</h3>

<p>
In short: <code>new</code> allocates memory, <code>make</code> initializes
the slice, map, and channel types.
</p>

<p>
See the <a href="/doc/effective_go.html#allocation_new">relevant section
of Effective Go</a> for more details.
</p>

<h3 id="q_int_sizes">
What is the size of an <code>int</code> on a 64 bit machine?</h3>

<p>
The sizes of <code>int</code> and <code>uint</code> are implementation-specific
but the same as each other on a given platform.
For portability, code that relies on a particular
size of value should use an explicitly sized type, like <code>int64</code>.
Prior to Go 1.1, the 64-bit Go compilers (both gc and gccgo) used
a 32-bit representation for <code>int</code>. As of Go 1.1 they use
a 64-bit representation.
On the other hand, floating-point scalars and complex
numbers are always sized: <code>float32</code>, <code>complex64</code>,
etc., because programmers should be aware of precision when using
floating-point numbers.
The default size of a floating-point constant is <code>float64</code>.
</p>

<h3 id="stack_or_heap">
How do I know whether a variable is allocated on the heap or the stack?</h3>

<p>
From a correctness standpoint, you don't need to know.
Each variable in Go exists as long as there are references to it.
The storage location chosen by the implementation is irrelevant to the
semantics of the language.
</p>

<p>
The storage location does have an effect on writing efficient programs.
When possible, the Go compilers will allocate variables that are
local to a function in that function's stack frame.  However, if the
compiler cannot prove that the variable is not referenced after the
function returns, then the compiler must allocate the variable on the
garbage-collected heap to avoid dangling pointer errors.
Also, if a local variable is very large, it might make more sense
to store it on the heap rather than the stack.
</p>

<p>
In the current compilers, if a variable has its address taken, that variable
is a candidate for allocation on the heap. However, a basic <em>escape
analysis</em> recognizes some cases when such variables will not
live past the return from the function and can reside on the stack.
</p>

<h3 id="Why_does_my_Go_process_use_so_much_virtual_memory">
Why does my Go process use so much virtual memory?</h3>

<p>
The Go memory allocator reserves a large region of virtual memory as an arena
for allocations. This virtual memory is local to the specific Go process; the
reservation does not deprive other processes of memory.
</p>

<p>
To find the amount of actual memory allocated to a Go process, use the Unix
<code>top</code> command and consult the <code>RES</code> (Linux) or
<code>RSIZE</code> (Mac OS X) columns.
<!-- TODO(adg): find out how this works on Windows -->
</p>

<h2 id="Concurrency">Concurrency</h2>

<h3 id="What_operations_are_atomic_What_about_mutexes">
What operations are atomic? What about mutexes?</h3>

<p>
We haven't fully defined it all yet, but some details about atomicity are
available in the <a href="/ref/mem">Go Memory Model specification</a>.
</p>

<p>
Regarding mutexes, the <a href="/pkg/sync">sync</a>
package implements them, but we hope Go programming style will
encourage people to try higher-level techniques. In particular, consider
structuring your program so that only one goroutine at a time is ever
responsible for a particular piece of data.
</p>

<p>
Do not communicate by sharing memory. Instead, share memory by communicating.
</p>

<p>
See the <a href="/doc/codewalk/sharemem/">Share Memory By Communicating</a> code walk and its <a href="//blog.golang.org/2010/07/share-memory-by-communicating.html">associated article</a> for a detailed discussion of this concept.
</p>

<h3 id="Why_no_multi_CPU">
Why doesn't my multi-goroutine program use multiple CPUs?</h3>

<p>
You must set the <code>GOMAXPROCS</code> shell environment variable
or use the similarly-named <a href="/pkg/runtime/#GOMAXPROCS"><code>function</code></a>
of the runtime package to allow the
run-time support to utilize more than one OS thread.
</p>

<p>
Programs that perform parallel computation should benefit from an increase in
<code>GOMAXPROCS</code>.
However, be aware that
<a href="//blog.golang.org/2013/01/concurrency-is-not-parallelism.html">concurrency
is not parallelism</a>.
</p>

<h3 id="Why_GOMAXPROCS">
Why does using <code>GOMAXPROCS</code> &gt; 1 sometimes make my program
slower?</h3>

<p>
It depends on the nature of your program.
Problems that are intrinsically sequential cannot be sped up by adding
more goroutines.
Concurrency only becomes parallelism when the problem is
intrinsically parallel.
</p>

<p>
In practical terms, programs that spend more time
communicating on channels than doing computation
will experience performance degradation when using
multiple OS threads.
This is because sending data between threads involves switching
contexts, which has significant cost.
For instance, the <a href="/ref/spec#An_example_package">prime sieve example</a>
from the Go specification has no significant parallelism although it launches many
goroutines; increasing <code>GOMAXPROCS</code> is more likely to slow it down than
to speed it up.
</p>

<p>
Go's goroutine scheduler is not as good as it needs to be. In the future, it
should recognize such cases and optimize its use of OS threads. For now,
<code>GOMAXPROCS</code> should be set on a per-application basis.
</p>

<p>
For more detail on this topic see the talk entitled,
<a href="//blog.golang.org/2013/01/concurrency-is-not-parallelism.html">Concurrency
is not Parallelism</a>.

<h2 id="Functions_methods">Functions and Methods</h2>

<h3 id="different_method_sets">
Why do T and *T have different method sets?</h3>

<p>
From the <a href="/ref/spec#Types">Go Spec</a>:
</p>

<blockquote>
The method set of any other named type <code>T</code> consists of all methods
with receiver type <code>T</code>. The method set of the corresponding pointer
type <code>*T</code> is the set of all methods with receiver <code>*T</code> or
<code>T</code> (that is, it also contains the method set of <code>T</code>).
</blockquote>

<p>
If an interface value contains a pointer <code>*T</code>,
a method call can obtain a value by dereferencing the pointer,
but if an interface value contains a value <code>T</code>,
there is no useful way for a method call to obtain a pointer.
</p>

<p>
Even in cases where the compiler could take the address of a value
to pass to the method, if the method modifies the value the changes
will be lost in the caller.
As a common example, this code:
</p>

<pre>
var buf bytes.Buffer
io.Copy(buf, os.Stdin)
</pre>

<p>
would copy standard input into a <i>copy</i> of <code>buf</code>,
not into <code>buf</code> itself.
This is almost never the desired behavior.
</p>

<h3 id="closures_and_goroutines">
What happens with closures running as goroutines?</h3>

<p>
Some confusion may arise when using closures with concurrency.
Consider the following program:
</p>

<pre>
func main() {
    done := make(chan bool)

    values := []string{"a", "b", "c"}
    for _, v := range values {
        go func() {
            fmt.Println(v)
            done &lt;- true
        }()
    }

    // wait for all goroutines to complete before exiting
    for _ = range values {
        &lt;-done
    }
}
</pre>

<p>
One might mistakenly expect to see <code>a, b, c</code> as the output.
What you'll probably see instead is <code>c, c, c</code>.  This is because
each iteration of the loop uses the same instance of the variable <code>v</code>, so
each closure shares that single variable. When the closure runs, it prints the
value of <code>v</code> at the time <code>fmt.Println</code> is executed,
but <code>v</code> may have been modified since the goroutine was launched.
To help detect this and other problems before they happen, run
<a href="/cmd/go/#hdr-Run_go_tool_vet_on_packages"><code>go vet</code></a>.
</p>

<p>
To bind the current value of <code>v</code> to each closure as it is launched, one
must modify the inner loop to create a new variable each iteration.
One way is to pass the variable as an argument to the closure:
</p>

<pre>
    for _, v := range values {
        go func(<b>u</b> string) {
            fmt.Println(<b>u</b>)
            done &lt;- true
        }(<b>v</b>)
    }
</pre>

<p>
In this example, the value of <code>v</code> is passed as an argument to the
anonymous function. That value is then accessible inside the function as
the variable <code>u</code>.
</p>

<p>
Even easier is just to create a new variable, using a declaration style that may
seem odd but works fine in Go:
</p>

<pre>
    for _, v := range values {
        <b>v := v</b> // create a new 'v'.
        go func() {
            fmt.Println(<b>v</b>)
            done &lt;- true
        }()
    }
</pre>

<h2 id="Control_flow">Control flow</h2>

<h3 id="Does_Go_have_a_ternary_form">
Does Go have the <code>?:</code> operator?</h3>

<p>
There is no ternary form in Go. You may use the following to achieve the same
result:
</p>

<pre>
if expr {
    n = trueVal
} else {
    n = falseVal
}
</pre>

<h2 id="Packages_Testing">Packages and Testing</h2>

<h3 id="How_do_I_create_a_multifile_package">
How do I create a multifile package?</h3>

<p>
Put all the source files for the package in a directory by themselves.
Source files can refer to items from different files at will; there is
no need for forward declarations or a header file.
</p>

<p>
Other than being split into multiple files, the package will compile and test
just like a single-file package.
</p>

<h3 id="How_do_I_write_a_unit_test">
How do I write a unit test?</h3>

<p>
Create a new file ending in <code>_test.go</code> in the same directory
as your package sources. Inside that file, <code>import "testing"</code>
and write functions of the form
</p>

<pre>
func TestFoo(t *testing.T) {
    ...
}
</pre>

<p>
Run <code>go test</code> in that directory.
That script finds the <code>Test</code> functions,
builds a test binary, and runs it.
</p>

<p>See the <a href="/doc/code.html">How to Write Go Code</a> document,
the <a href="/pkg/testing/"><code>testing</code></a> package
and the <a href="/cmd/go/#hdr-Test_packages"><code>go test</code></a> subcommand for more details.
</p>

<h3 id="testing_framework">
Where is my favorite helper function for testing?</h3>

<p>
Go's standard <a href="/pkg/testing/"><code>testing</code></a> package makes it easy to write unit tests, but it lacks
features provided in other language's testing frameworks such as assertion functions.
An <a href="#assertions">earlier section</a> of this document explained why Go
doesn't have assertions, and
the same arguments apply to the use of <code>assert</code> in tests.
Proper error handling means letting other tests run after one has failed, so
that the person debugging the failure gets a complete picture of what is
wrong. It is more useful for a test to report that
<code>isPrime</code> gives the wrong answer for 2, 3, 5, and 7 (or for
2, 4, 8, and 16) than to report that <code>isPrime</code> gives the wrong
answer for 2 and therefore no more tests were run. The programmer who
triggers the test failure may not be familiar with the code that fails.
Time invested writing a good error message now pays off later when the
test breaks.
</p>

<p>
A related point is that testing frameworks tend to develop into mini-languages
of their own, with conditionals and controls and printing mechanisms,
but Go already has all those capabilities; why recreate them?
We'd rather write tests in Go; it's one fewer language to learn and the
approach keeps the tests straightforward and easy to understand.
</p>

<p>
If the amount of extra code required to write
good errors seems repetitive and overwhelming, the test might work better if
table-driven, iterating over a list of inputs and outputs defined
in a data structure (Go has excellent support for data structure literals).
The work to write a good test and good error messages will then be amortized over many
test cases. The standard Go library is full of illustrative examples, such as in
<a href="/src/fmt/fmt_test.go">the formatting tests for the <code>fmt</code> package</a>.
</p>


<h2 id="Implementation">Implementation</h2>

<h3 id="What_compiler_technology_is_used_to_build_the_compilers">
What compiler technology is used to build the compilers?</h3>

<p>
<code>Gccgo</code> has a front end written in C++, with a recursive descent parser coupled to the
standard GCC back end. <code>Gc</code> is written in C using
<code>yacc</code>/<code>bison</code> for the parser.
Although it's a new program, it fits in the Plan 9 C compiler suite
(<a href="http://plan9.bell-labs.com/sys/doc/compiler.html">http://plan9.bell-labs.com/sys/doc/compiler.html</a>)
and uses a variant of the Plan 9 loader to generate ELF/Mach-O/PE binaries.
</p>

<p>
We considered using LLVM for <code>gc</code> but we felt it was too large and
slow to meet our performance goals.
</p>

<p>
We also considered writing <code>gc</code>, the original Go compiler, in Go itself but
elected not to do so because of the difficulties of bootstrapping and
especially of open source distribution&mdash;you'd need a Go compiler to
set up a Go environment. <code>Gccgo</code>, which came later, makes it possible to
consider writing a compiler in Go.
A plan to do that by machine translation of the existing compiler is under development.
<a href="http://golang.org/s/go13compiler">A separate document</a>
explains the reason for this approach.
</p>

<p>
That plan aside,
Go is a
fine language in which to implement a self-hosting compiler: a native lexer and
parser are already available in the <a href="/pkg/go/"><code>go</code></a> package
and a separate type checking
<a href="http://godoc.org/golang.org/x/tools/go/types">package</a>
has also been written.
</p>

<h3 id="How_is_the_run_time_support_implemented">
How is the run-time support implemented?</h3>

<p>
Again due to bootstrapping issues, the run-time code was originally written mostly in C (with a
tiny bit of assembler) although much of it has been translated to Go since then
and one day all of it might be (except for the assembler bits).
<code>Gccgo</code>'s run-time support uses <code>glibc</code>.
<code>Gc</code> uses a custom C library to keep the footprint under
control; it is
compiled with a version of the Plan 9 C compiler that supports
resizable stacks for goroutines.
The <code>gccgo</code> compiler implements these on Linux only,
using a technique called segmented stacks,
supported by recent modifications to the gold linker.
</p>

<h3 id="Why_is_my_trivial_program_such_a_large_binary">
Why is my trivial program such a large binary?</h3>

<p>
The linkers in the gc tool chain (<code>5l</code>, <code>6l</code>, and <code>8l</code>)
do static linking.  All Go binaries therefore include the Go
run-time, along with the run-time type information necessary to support dynamic
type checks, reflection, and even panic-time stack traces.
</p>

<p>
A simple C "hello, world" program compiled and linked statically using gcc
on Linux is around 750 kB,
including an implementation of <code>printf</code>.
An equivalent Go program using <code>fmt.Printf</code>
is around 1.9 MB, but
that includes more powerful run-time support and type information.
</p>

<h3 id="unused_variables_and_imports">
Can I stop these complaints about my unused variable/import?</h3>

<p>
The presence of an unused variable may indicate a bug, while
unused imports just slow down compilation,
an effect that can become substantial as a program accumulates
code and programmers over time.
For these reasons, Go refuses to compile programs with unused
variables or imports,
trading short-term convenience for long-term build speed and
program clarity.
</p>

<p>
Still, when developing code, it's common to create these situations
temporarily and it can be annoying to have to edit them out before the
program will compile.
</p>

<p>
Some have asked for a compiler option to turn those checks off
or at least reduce them to warnings.
Such an option has not been added, though,
because compiler options should not affect the semantics of the
language and because the Go compiler does not report warnings, only
errors that prevent compilation.
</p>

<p>
There are two reasons for having no warnings.  First, if it's worth
complaining about, it's worth fixing in the code.  (And if it's not
worth fixing, it's not worth mentioning.) Second, having the compiler
generate warnings encourages the implementation to warn about weak
cases that can make compilation noisy, masking real errors that
<em>should</em> be fixed.
</p>

<p>
It's easy to address the situation, though.  Use the blank identifier
to let unused things persist while you're developing.
</p>

<pre>
import "unused"

// This declaration marks the import as used by referencing an
// item from the package.
var _ = unused.Item  // TODO: Delete before committing!

func main() {
    debugData := debug.Profile()
    _ = debugData // Used only during debugging.
    ....
}
</pre>

<p>
Nowadays, most Go programmers use a tool,
<a href="http://godoc.org/golang.org/x/tools/cmd/goimports">goimports</a>,
which automatically rewrites a Go source file to have the correct imports,
eliminating the unused imports issue in practice.
This program is easily connected to most editors to run automatically when a Go source file is written.
</p>

<h2 id="Performance">Performance</h2>

<h3 id="Why_does_Go_perform_badly_on_benchmark_x">
Why does Go perform badly on benchmark X?</h3>

<p>
One of Go's design goals is to approach the performance of C for comparable
programs, yet on some benchmarks it does quite poorly, including several
in <a href="/test/bench/shootout/">test/bench/shootout</a>. The slowest depend on libraries
for which versions of comparable performance are not available in Go.
For instance, <a href="/test/bench/shootout/pidigits.go">pidigits.go</a>
depends on a multi-precision math package, and the C
versions, unlike Go's, use <a href="http://gmplib.org/">GMP</a> (which is
written in optimized assembler).
Benchmarks that depend on regular expressions
(<a href="/test/bench/shootout/regex-dna.go">regex-dna.go</a>, for instance) are
essentially comparing Go's native <a href="/pkg/regexp">regexp package</a> to
mature, highly optimized regular expression libraries like PCRE.
</p>

<p>
Benchmark games are won by extensive tuning and the Go versions of most
of the benchmarks need attention.  If you measure comparable C
and Go programs
(<a href="/test/bench/shootout/reverse-complement.go">reverse-complement.go</a> is one example), you'll see the two
languages are much closer in raw performance than this suite would
indicate.
</p>

<p>
Still, there is room for improvement. The compilers are good but could be
better, many libraries need major performance work, and the garbage collector
isn't fast enough yet. (Even if it were, taking care not to generate unnecessary
garbage can have a huge effect.)
</p>

<p>
In any case, Go can often be very competitive.
There has been significant improvement in the performance of many programs
as the language and tools have developed.
See the blog post about
<a href="//blog.golang.org/2011/06/profiling-go-programs.html">profiling
Go programs</a> for an informative example.

<h2 id="change_from_c">Changes from C</h2>

<h3 id="different_syntax">
Why is the syntax so different from C?</h3>
<p>
Other than declaration syntax, the differences are not major and stem
from two desires.  First, the syntax should feel light, without too
many mandatory keywords, repetition, or arcana.  Second, the language
has been designed to be easy to analyze
and can be parsed without a symbol table.  This makes it much easier
to build tools such as debuggers, dependency analyzers, automated
documentation extractors, IDE plug-ins, and so on.  C and its
descendants are notoriously difficult in this regard.
</p>

<h3 id="declarations_backwards">
Why are declarations backwards?</h3>
<p>
They're only backwards if you're used to C. In C, the notion is that a
variable is declared like an expression denoting its type, which is a
nice idea, but the type and expression grammars don't mix very well and
the results can be confusing; consider function pointers.  Go mostly
separates expression and type syntax and that simplifies things (using
prefix <code>*</code> for pointers is an exception that proves the rule).  In C,
the declaration
</p>
<pre>
    int* a, b;
</pre>
<p>
declares <code>a</code> to be a pointer but not <code>b</code>; in Go
</p>
<pre>
    var a, b *int
</pre>
<p>
declares both to be pointers.  This is clearer and more regular.
Also, the <code>:=</code> short declaration form argues that a full variable
declaration should present the same order as <code>:=</code> so
</p>
<pre>
    var a uint64 = 1
</pre>
<p>
has the same effect as
</p>
<pre>
    a := uint64(1)
</pre>
<p>
Parsing is also simplified by having a distinct grammar for types that
is not just the expression grammar; keywords such as <code>func</code>
and <code>chan</code> keep things clear.
</p>

<p>
See the article about
<a href="/doc/articles/gos_declaration_syntax.html">Go's Declaration Syntax</a>
for more details.
</p>

<h3 id="no_pointer_arithmetic">
Why is there no pointer arithmetic?</h3>
<p>
Safety.  Without pointer arithmetic it's possible to create a
language that can never derive an illegal address that succeeds
incorrectly.  Compiler and hardware technology have advanced to the
point where a loop using array indices can be as efficient as a loop
using pointer arithmetic.  Also, the lack of pointer arithmetic can
simplify the implementation of the garbage collector.
</p>

<h3 id="inc_dec">
Why are <code>++</code> and <code>--</code> statements and not expressions?  And why postfix, not prefix?</h3>
<p>
Without pointer arithmetic, the convenience value of pre- and postfix
increment operators drops.  By removing them from the expression
hierarchy altogether, expression syntax is simplified and the messy
issues around order of evaluation of <code>++</code> and <code>--</code>
(consider <code>f(i++)</code> and <code>p[i] = q[++i]</code>)
are eliminated as well.  The simplification is
significant.  As for postfix vs. prefix, either would work fine but
the postfix version is more traditional; insistence on prefix arose
with the STL, a library for a language whose name contains, ironically, a
postfix increment.
</p>

<h3 id="semicolons">
Why are there braces but no semicolons? And why can't I put the opening
brace on the next line?</h3>
<p>
Go uses brace brackets for statement grouping, a syntax familiar to
programmers who have worked with any language in the C family.
Semicolons, however, are for parsers, not for people, and we wanted to
eliminate them as much as possible.  To achieve this goal, Go borrows
a trick from BCPL: the semicolons that separate statements are in the
formal grammar but are injected automatically, without lookahead, by
the lexer at the end of any line that could be the end of a statement.
This works very well in practice but has the effect that it forces a
brace style.  For instance, the opening brace of a function cannot
appear on a line by itself.
</p>

<p>
Some have argued that the lexer should do lookahead to permit the
brace to live on the next line.  We disagree.  Since Go code is meant
to be formatted automatically by
<a href="/cmd/gofmt/"><code>gofmt</code></a>,
<i>some</i> style must be chosen.  That style may differ from what
you've used in C or Java, but Go is a new language and
<code>gofmt</code>'s style is as good as any other.  More
important&mdash;much more important&mdash;the advantages of a single,
programmatically mandated format for all Go programs greatly outweigh
any perceived disadvantages of the particular style.
Note too that Go's style means that an interactive implementation of
Go can use the standard syntax one line at a time without special rules.
</p>

<h3 id="garbage_collection">
Why do garbage collection?  Won't it be too expensive?</h3>
<p>
One of the biggest sources of bookkeeping in systems programs is
memory management.  We feel it's critical to eliminate that
programmer overhead, and advances in garbage collection
technology in the last few years give us confidence that we can
implement it with low enough overhead and no significant
latency.
</p>

<p>
Another point is that a large part of the difficulty of concurrent
and multi-threaded programming is memory management;
as objects get passed among threads it becomes cumbersome
to guarantee they become freed safely.
Automatic garbage collection makes concurrent code far easier to write.
Of course, implementing garbage collection in a concurrent environment is
itself a challenge, but meeting it once rather than in every
program helps everyone.
</p>

<p>
Finally, concurrency aside, garbage collection makes interfaces
simpler because they don't need to specify how memory is managed across them.
</p>

<p>
The current implementation is a parallel mark-and-sweep
collector but a future version might take a different approach.
</p>

<p>
On the topic of performance, keep in mind that Go gives the programmer
considerable control over memory layout and allocation, much more than
is typical in garbage-collected languages. A careful programmer can reduce
the garbage collection overhead dramatically by using the language well;
see the article about
<a href="//blog.golang.org/2011/06/profiling-go-programs.html">profiling
Go programs</a> for a worked example, including a demonstration of Go's
profiling tools.
</p>
                                                                                                                                                                                                                                                                                                                                                                                                                           root/go1.4/doc/go_mem.html                                                                          0100644 0000000 0000000 00000032252 12600426226 013762  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "The Go Memory Model",
	"Subtitle": "Version of May 31, 2014",
	"Path": "/ref/mem"
}-->

<style>
p.rule {
  font-style: italic;
}
span.event {
  font-style: italic;
}
</style>

<h2>Introduction</h2>

<p>
The Go memory model specifies the conditions under which
reads of a variable in one goroutine can be guaranteed to
observe values produced by writes to the same variable in a different goroutine.
</p>


<h2>Advice</h2>

<p>
Programs that modify data being simultaneously accessed by multiple goroutines
must serialize such access.
</p>

<p>
To serialize access, protect the data with channel operations or other synchronization primitives
such as those in the <a href="/pkg/sync/"><code>sync</code></a>
and <a href="/pkg/sync/atomic/"><code>sync/atomic</code></a> packages.
</p>

<p>
If you must read the rest of this document to understand the behavior of your program,
you are being too clever.
</p>

<p>
Don't be clever.
</p>

<h2>Happens Before</h2>

<p>
Within a single goroutine, reads and writes must behave
as if they executed in the order specified by the program.
That is, compilers and processors may reorder the reads and writes
executed within a single goroutine only when the reordering
does not change the behavior within that goroutine
as defined by the language specification.
Because of this reordering, the execution order observed
by one goroutine may differ from the order perceived
by another.  For example, if one goroutine
executes <code>a = 1; b = 2;</code>, another might observe
the updated value of <code>b</code> before the updated value of <code>a</code>.
</p>

<p>
To specify the requirements of reads and writes, we define
<i>happens before</i>, a partial order on the execution
of memory operations in a Go program.  If event <span class="event">e<sub>1</sub></span> happens
before event <span class="event">e<sub>2</sub></span>, then we say that <span class="event">e<sub>2</sub></span> happens after <span class="event">e<sub>1</sub></span>.
Also, if <span class="event">e<sub>1</sub></span> does not happen before <span class="event">e<sub>2</sub></span> and does not happen
after <span class="event">e<sub>2</sub></span>, then we say that <span class="event">e<sub>1</sub></span> and <span class="event">e<sub>2</sub></span> happen concurrently.
</p>

<p class="rule">
Within a single goroutine, the happens-before order is the
order expressed by the program.
</p>

<p>
A read <span class="event">r</span> of a variable <code>v</code> is <i>allowed</i> to observe a write <span class="event">w</span> to <code>v</code>
if both of the following hold:
</p>

<ol>
<li><span class="event">r</span> does not happen before <span class="event">w</span>.</li>
<li>There is no other write <span class="event">w'</span> to <code>v</code> that happens
    after <span class="event">w</span> but before <span class="event">r</span>.</li>
</ol>

<p>
To guarantee that a read <span class="event">r</span> of a variable <code>v</code> observes a
particular write <span class="event">w</span> to <code>v</code>, ensure that <span class="event">w</span> is the only
write <span class="event">r</span> is allowed to observe.
That is, <span class="event">r</span> is <i>guaranteed</i> to observe <span class="event">w</span> if both of the following hold:
</p>

<ol>
<li><span class="event">w</span> happens before <span class="event">r</span>.</li>
<li>Any other write to the shared variable <code>v</code>
either happens before <span class="event">w</span> or after <span class="event">r</span>.</li>
</ol>

<p>
This pair of conditions is stronger than the first pair;
it requires that there are no other writes happening
concurrently with <span class="event">w</span> or <span class="event">r</span>.
</p>

<p>
Within a single goroutine,
there is no concurrency, so the two definitions are equivalent:
a read <span class="event">r</span> observes the value written by the most recent write <span class="event">w</span> to <code>v</code>.
When multiple goroutines access a shared variable <code>v</code>,
they must use synchronization events to establish
happens-before conditions that ensure reads observe the
desired writes.
</p>

<p>
The initialization of variable <code>v</code> with the zero value
for <code>v</code>'s type behaves as a write in the memory model.
</p>

<p>
Reads and writes of values larger than a single machine word
behave as multiple machine-word-sized operations in an
unspecified order.
</p>

<h2>Synchronization</h2>

<h3>Initialization</h3>

<p>
Program initialization runs in a single goroutine,
but that goroutine may create other goroutines,
which run concurrently.
</p>

<p class="rule">
If a package <code>p</code> imports package <code>q</code>, the completion of
<code>q</code>'s <code>init</code> functions happens before the start of any of <code>p</code>'s.
</p>

<p class="rule">
The start of the function <code>main.main</code> happens after
all <code>init</code> functions have finished.
</p>

<h3>Goroutine creation</h3>

<p class="rule">
The <code>go</code> statement that starts a new goroutine
happens before the goroutine's execution begins.
</p>

<p>
For example, in this program:
</p>

<pre>
var a string

func f() {
	print(a)
}

func hello() {
	a = "hello, world"
	go f()
}
</pre>

<p>
calling <code>hello</code> will print <code>"hello, world"</code>
at some point in the future (perhaps after <code>hello</code> has returned).
</p>

<h3>Goroutine destruction</h3>

<p>
The exit of a goroutine is not guaranteed to happen before
any event in the program.  For example, in this program:
</p>

<pre>
var a string

func hello() {
	go func() { a = "hello" }()
	print(a)
}
</pre>

<p>
the assignment to <code>a</code> is not followed by
any synchronization event, so it is not guaranteed to be
observed by any other goroutine.
In fact, an aggressive compiler might delete the entire <code>go</code> statement.
</p>

<p>
If the effects of a goroutine must be observed by another goroutine,
use a synchronization mechanism such as a lock or channel
communication to establish a relative ordering.
</p>

<h3>Channel communication</h3>

<p>
Channel communication is the main method of synchronization
between goroutines.  Each send on a particular channel
is matched to a corresponding receive from that channel,
usually in a different goroutine.
</p>

<p class="rule">
A send on a channel happens before the corresponding
receive from that channel completes.
</p>

<p>
This program:
</p>

<pre>
var c = make(chan int, 10)
var a string

func f() {
	a = "hello, world"
	c &lt;- 0
}

func main() {
	go f()
	&lt;-c
	print(a)
}
</pre>

<p>
is guaranteed to print <code>"hello, world"</code>.  The write to <code>a</code>
happens before the send on <code>c</code>, which happens before
the corresponding receive on <code>c</code> completes, which happens before
the <code>print</code>.
</p>

<p class="rule">
The closing of a channel happens before a receive that returns a zero value
because the channel is closed.
</p>

<p>
In the previous example, replacing
<code>c &lt;- 0</code> with <code>close(c)</code>
yields a program with the same guaranteed behavior.
</p>

<p class="rule">
A receive from an unbuffered channel happens before
the send on that channel completes.
</p>

<p>
This program (as above, but with the send and receive statements swapped and
using an unbuffered channel):
</p>

<pre>
var c = make(chan int)
var a string

func f() {
	a = "hello, world"
	&lt;-c
}
</pre>

<pre>
func main() {
	go f()
	c &lt;- 0
	print(a)
}
</pre>

<p>
is also guaranteed to print <code>"hello, world"</code>.  The write to <code>a</code>
happens before the receive on <code>c</code>, which happens before
the corresponding send on <code>c</code> completes, which happens
before the <code>print</code>.
</p>

<p>
If the channel were buffered (e.g., <code>c = make(chan int, 1)</code>)
then the program would not be guaranteed to print
<code>"hello, world"</code>.  (It might print the empty string,
crash, or do something else.)
</p>

<p class="rule">
The <i>k</i>th receive on a channel with capacity <i>C</i> happens before the <i>k</i>+<i>C</i>th send from that channel completes.
</p>

<p>
This rule generalizes the previous rule to buffered channels.
It allows a counting semaphore to be modeled by a buffered channel:
the number of items in the channel corresponds to the number of active uses,
the capacity of the channel corresponds to the maximum number of simultaneous uses,
sending an item acquires the semaphore, and receiving an item releases
the semaphore.
This is a common idiom for limiting concurrency.
</p>

<p>
This program starts a goroutine for every entry in the work list, but the
goroutines coordinate using the <code>limit</code> channel to ensure
that at most three are running work functions at a time.
</p>

<pre>
var limit = make(chan int, 3)

func main() {
	for _, w := range work {
		go func() {
			limit <- 1
			w()
			<-limit
		}()
	}
	select{}
}
</pre>

<h3>Locks</h3>

<p>
The <code>sync</code> package implements two lock data types,
<code>sync.Mutex</code> and <code>sync.RWMutex</code>.
</p>

<p class="rule">
For any <code>sync.Mutex</code> or <code>sync.RWMutex</code> variable <code>l</code> and <i>n</i> &lt; <i>m</i>,
call <i>n</i> of <code>l.Unlock()</code> happens before call <i>m</i> of <code>l.Lock()</code> returns.
</p>

<p>
This program:
</p>

<pre>
var l sync.Mutex
var a string

func f() {
	a = "hello, world"
	l.Unlock()
}

func main() {
	l.Lock()
	go f()
	l.Lock()
	print(a)
}
</pre>

<p>
is guaranteed to print <code>"hello, world"</code>.
The first call to <code>l.Unlock()</code> (in <code>f</code>) happens
before the second call to <code>l.Lock()</code> (in <code>main</code>) returns,
which happens before the <code>print</code>.
</p>

<p class="rule">
For any call to <code>l.RLock</code> on a <code>sync.RWMutex</code> variable <code>l</code>,
there is an <i>n</i> such that the <code>l.RLock</code> happens (returns) after call <i>n</i> to
<code>l.Unlock</code> and the matching <code>l.RUnlock</code> happens
before call <i>n</i>+1 to <code>l.Lock</code>.
</p>

<h3>Once</h3>

<p>
The <code>sync</code> package provides a safe mechanism for
initialization in the presence of multiple goroutines
through the use of the <code>Once</code> type.
Multiple threads can execute <code>once.Do(f)</code> for a particular <code>f</code>,
but only one will run <code>f()</code>, and the other calls block
until <code>f()</code> has returned.
</p>

<p class="rule">
A single call of <code>f()</code> from <code>once.Do(f)</code> happens (returns) before any call of <code>once.Do(f)</code> returns.
</p>

<p>
In this program:
</p>

<pre>
var a string
var once sync.Once

func setup() {
	a = "hello, world"
}

func doprint() {
	once.Do(setup)
	print(a)
}

func twoprint() {
	go doprint()
	go doprint()
}
</pre>

<p>
calling <code>twoprint</code> causes <code>"hello, world"</code> to be printed twice.
The first call to <code>doprint</code> runs <code>setup</code> once.
</p>

<h2>Incorrect synchronization</h2>

<p>
Note that a read <span class="event">r</span> may observe the value written by a write <span class="event">w</span>
that happens concurrently with <span class="event">r</span>.
Even if this occurs, it does not imply that reads happening after <span class="event">r</span>
will observe writes that happened before <span class="event">w</span>.
</p>

<p>
In this program:
</p>

<pre>
var a, b int

func f() {
	a = 1
	b = 2
}

func g() {
	print(b)
	print(a)
}

func main() {
	go f()
	g()
}
</pre>

<p>
it can happen that <code>g</code> prints <code>2</code> and then <code>0</code>.
</p>

<p>
This fact invalidates a few common idioms.
</p>

<p>
Double-checked locking is an attempt to avoid the overhead of synchronization.
For example, the <code>twoprint</code> program might be
incorrectly written as:
</p>

<pre>
var a string
var done bool

func setup() {
	a = "hello, world"
	done = true
}

func doprint() {
	if !done {
		once.Do(setup)
	}
	print(a)
}

func twoprint() {
	go doprint()
	go doprint()
}
</pre>

<p>
but there is no guarantee that, in <code>doprint</code>, observing the write to <code>done</code>
implies observing the write to <code>a</code>.  This
version can (incorrectly) print an empty string
instead of <code>"hello, world"</code>.
</p>

<p>
Another incorrect idiom is busy waiting for a value, as in:
</p>

<pre>
var a string
var done bool

func setup() {
	a = "hello, world"
	done = true
}

func main() {
	go setup()
	for !done {
	}
	print(a)
}
</pre>

<p>
As before, there is no guarantee that, in <code>main</code>,
observing the write to <code>done</code>
implies observing the write to <code>a</code>, so this program could
print an empty string too.
Worse, there is no guarantee that the write to <code>done</code> will ever
be observed by <code>main</code>, since there are no synchronization
events between the two threads.  The loop in <code>main</code> is not
guaranteed to finish.
</p>

<p>
There are subtler variants on this theme, such as this program.
</p>

<pre>
type T struct {
	msg string
}

var g *T

func setup() {
	t := new(T)
	t.msg = "hello, world"
	g = t
}

func main() {
	go setup()
	for g == nil {
	}
	print(g.msg)
}
</pre>

<p>
Even if <code>main</code> observes <code>g != nil</code> and exits its loop,
there is no guarantee that it will observe the initialized
value for <code>g.msg</code>.
</p>

<p>
In all these examples, the solution is the same:
use explicit synchronization.
</p>
                                                                                                                                                                                                                                                                                                                                                      root/go1.4/doc/go_spec.html                                                                         0100644 0000000 0000000 00000574241 12600426226 014147  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "The Go Programming Language Specification",
	"Subtitle": "Version of November 11, 2014",
	"Path": "/ref/spec"
}-->

<!--
TODO
[ ] need language about function/method calls and parameter passing rules
[ ] last paragraph of #Assignments (constant promotion) should be elsewhere
    and mention assignment to empty interface.
[ ] need to say something about "scope" of selectors?
[ ] clarify what a field name is in struct declarations
    (struct{T} vs struct {T T} vs struct {t T})
[ ] need explicit language about the result type of operations
[ ] should probably write something about evaluation order of statements even
	though obvious
[ ] in Selectors section, clarify what receiver value is passed in method invocations
-->


<h2 id="Introduction">Introduction</h2>

<p>
This is a reference manual for the Go programming language. For
more information and other documents, see <a href="/">golang.org</a>.
</p>

<p>
Go is a general-purpose language designed with systems programming
in mind. It is strongly typed and garbage-collected and has explicit
support for concurrent programming.  Programs are constructed from
<i>packages</i>, whose properties allow efficient management of
dependencies. The existing implementations use a traditional
compile/link model to generate executable binaries.
</p>

<p>
The grammar is compact and regular, allowing for easy analysis by
automatic tools such as integrated development environments.
</p>

<h2 id="Notation">Notation</h2>
<p>
The syntax is specified using Extended Backus-Naur Form (EBNF):
</p>

<pre class="grammar">
Production  = production_name "=" [ Expression ] "." .
Expression  = Alternative { "|" Alternative } .
Alternative = Term { Term } .
Term        = production_name | token [ "‚Ä¶" token ] | Group | Option | Repetition .
Group       = "(" Expression ")" .
Option      = "[" Expression "]" .
Repetition  = "{" Expression "}" .
</pre>

<p>
Productions are expressions constructed from terms and the following
operators, in increasing precedence:
</p>
<pre class="grammar">
|   alternation
()  grouping
[]  option (0 or 1 times)
{}  repetition (0 to n times)
</pre>

<p>
Lower-case production names are used to identify lexical tokens.
Non-terminals are in CamelCase. Lexical tokens are enclosed in
double quotes <code>""</code> or back quotes <code>``</code>.
</p>

<p>
The form <code>a ‚Ä¶ b</code> represents the set of characters from
<code>a</code> through <code>b</code> as alternatives. The horizontal
ellipsis <code>‚Ä¶</code> is also used elsewhere in the spec to informally denote various
enumerations or code snippets that are not further specified. The character <code>‚Ä¶</code>
(as opposed to the three characters <code>...</code>) is not a token of the Go
language.
</p>

<h2 id="Source_code_representation">Source code representation</h2>

<p>
Source code is Unicode text encoded in
<a href="http://en.wikipedia.org/wiki/UTF-8">UTF-8</a>. The text is not
canonicalized, so a single accented code point is distinct from the
same character constructed from combining an accent and a letter;
those are treated as two code points.  For simplicity, this document
will use the unqualified term <i>character</i> to refer to a Unicode code point
in the source text.
</p>
<p>
Each code point is distinct; for instance, upper and lower case letters
are different characters.
</p>
<p>
Implementation restriction: For compatibility with other tools, a
compiler may disallow the NUL character (U+0000) in the source text.
</p>
<p>
Implementation restriction: For compatibility with other tools, a
compiler may ignore a UTF-8-encoded byte order mark
(U+FEFF) if it is the first Unicode code point in the source text.
A byte order mark may be disallowed anywhere else in the source.
</p>

<h3 id="Characters">Characters</h3>

<p>
The following terms are used to denote specific Unicode character classes:
</p>
<pre class="ebnf">
newline        = /* the Unicode code point U+000A */ .
unicode_char   = /* an arbitrary Unicode code point except newline */ .
unicode_letter = /* a Unicode code point classified as "Letter" */ .
unicode_digit  = /* a Unicode code point classified as "Decimal Digit" */ .
</pre>

<p>
In <a href="http://www.unicode.org/versions/Unicode6.3.0/">The Unicode Standard 6.3</a>,
Section 4.5 "General Category"
defines a set of character categories.  Go treats
those characters in category Lu, Ll, Lt, Lm, or Lo as Unicode letters,
and those in category Nd as Unicode digits.
</p>

<h3 id="Letters_and_digits">Letters and digits</h3>

<p>
The underscore character <code>_</code> (U+005F) is considered a letter.
</p>
<pre class="ebnf">
letter        = unicode_letter | "_" .
decimal_digit = "0" ‚Ä¶ "9" .
octal_digit   = "0" ‚Ä¶ "7" .
hex_digit     = "0" ‚Ä¶ "9" | "A" ‚Ä¶ "F" | "a" ‚Ä¶ "f" .
</pre>

<h2 id="Lexical_elements">Lexical elements</h2>

<h3 id="Comments">Comments</h3>

<p>
There are two forms of comments:
</p>

<ol>
<li>
<i>Line comments</i> start with the character sequence <code>//</code>
and stop at the end of the line. A line comment acts like a newline.
</li>
<li>
<i>General comments</i> start with the character sequence <code>/*</code>
and continue through the character sequence <code>*/</code>. A general
comment containing one or more newlines acts like a newline, otherwise it acts
like a space.
</li>
</ol>

<p>
Comments do not nest.
</p>


<h3 id="Tokens">Tokens</h3>

<p>
Tokens form the vocabulary of the Go language.
There are four classes: <i>identifiers</i>, <i>keywords</i>, <i>operators
and delimiters</i>, and <i>literals</i>.  <i>White space</i>, formed from
spaces (U+0020), horizontal tabs (U+0009),
carriage returns (U+000D), and newlines (U+000A),
is ignored except as it separates tokens
that would otherwise combine into a single token. Also, a newline or end of file
may trigger the insertion of a <a href="#Semicolons">semicolon</a>.
While breaking the input into tokens,
the next token is the longest sequence of characters that form a
valid token.
</p>

<h3 id="Semicolons">Semicolons</h3>

<p>
The formal grammar uses semicolons <code>";"</code> as terminators in
a number of productions. Go programs may omit most of these semicolons
using the following two rules:
</p>

<ol>
<li>
<p>
When the input is broken into tokens, a semicolon is automatically inserted
into the token stream at the end of a non-blank line if the line's final
token is
</p>
<ul>
	<li>an
	    <a href="#Identifiers">identifier</a>
	</li>

	<li>an
	    <a href="#Integer_literals">integer</a>,
	    <a href="#Floating-point_literals">floating-point</a>,
	    <a href="#Imaginary_literals">imaginary</a>,
	    <a href="#Rune_literals">rune</a>, or
	    <a href="#String_literals">string</a> literal
	</li>

	<li>one of the <a href="#Keywords">keywords</a>
	    <code>break</code>,
	    <code>continue</code>,
	    <code>fallthrough</code>, or
	    <code>return</code>
	</li>

	<li>one of the <a href="#Operators_and_Delimiters">operators and delimiters</a>
	    <code>++</code>,
	    <code>--</code>,
	    <code>)</code>,
	    <code>]</code>, or
	    <code>}</code>
	</li>
</ul>
</li>

<li>
To allow complex statements to occupy a single line, a semicolon
may be omitted before a closing <code>")"</code> or <code>"}"</code>.
</li>
</ol>

<p>
To reflect idiomatic use, code examples in this document elide semicolons
using these rules.
</p>


<h3 id="Identifiers">Identifiers</h3>

<p>
Identifiers name program entities such as variables and types.
An identifier is a sequence of one or more letters and digits.
The first character in an identifier must be a letter.
</p>
<pre class="ebnf">
identifier = letter { letter | unicode_digit } .
</pre>
<pre>
a
_x9
ThisVariableIsExported
Œ±Œ≤
</pre>

<p>
Some identifiers are <a href="#Predeclared_identifiers">predeclared</a>.
</p>


<h3 id="Keywords">Keywords</h3>

<p>
The following keywords are reserved and may not be used as identifiers.
</p>
<pre class="grammar">
break        default      func         interface    select
case         defer        go           map          struct
chan         else         goto         package      switch
const        fallthrough  if           range        type
continue     for          import       return       var
</pre>

<h3 id="Operators_and_Delimiters">Operators and Delimiters</h3>

<p>
The following character sequences represent <a href="#Operators">operators</a>, delimiters, and other special tokens:
</p>
<pre class="grammar">
+    &amp;     +=    &amp;=     &amp;&amp;    ==    !=    (    )
-    |     -=    |=     ||    &lt;     &lt;=    [    ]
*    ^     *=    ^=     &lt;-    &gt;     &gt;=    {    }
/    &lt;&lt;    /=    &lt;&lt;=    ++    =     :=    ,    ;
%    &gt;&gt;    %=    &gt;&gt;=    --    !     ...   .    :
     &amp;^          &amp;^=
</pre>

<h3 id="Integer_literals">Integer literals</h3>

<p>
An integer literal is a sequence of digits representing an
<a href="#Constants">integer constant</a>.
An optional prefix sets a non-decimal base: <code>0</code> for octal, <code>0x</code> or
<code>0X</code> for hexadecimal.  In hexadecimal literals, letters
<code>a-f</code> and <code>A-F</code> represent values 10 through 15.
</p>
<pre class="ebnf">
int_lit     = decimal_lit | octal_lit | hex_lit .
decimal_lit = ( "1" ‚Ä¶ "9" ) { decimal_digit } .
octal_lit   = "0" { octal_digit } .
hex_lit     = "0" ( "x" | "X" ) hex_digit { hex_digit } .
</pre>

<pre>
42
0600
0xBadFace
170141183460469231731687303715884105727
</pre>

<h3 id="Floating-point_literals">Floating-point literals</h3>
<p>
A floating-point literal is a decimal representation of a
<a href="#Constants">floating-point constant</a>.
It has an integer part, a decimal point, a fractional part,
and an exponent part.  The integer and fractional part comprise
decimal digits; the exponent part is an <code>e</code> or <code>E</code>
followed by an optionally signed decimal exponent.  One of the
integer part or the fractional part may be elided; one of the decimal
point or the exponent may be elided.
</p>
<pre class="ebnf">
float_lit = decimals "." [ decimals ] [ exponent ] |
            decimals exponent |
            "." decimals [ exponent ] .
decimals  = decimal_digit { decimal_digit } .
exponent  = ( "e" | "E" ) [ "+" | "-" ] decimals .
</pre>

<pre>
0.
72.40
072.40  // == 72.40
2.71828
1.e+0
6.67428e-11
1E6
.25
.12345E+5
</pre>

<h3 id="Imaginary_literals">Imaginary literals</h3>
<p>
An imaginary literal is a decimal representation of the imaginary part of a
<a href="#Constants">complex constant</a>.
It consists of a
<a href="#Floating-point_literals">floating-point literal</a>
or decimal integer followed
by the lower-case letter <code>i</code>.
</p>
<pre class="ebnf">
imaginary_lit = (decimals | float_lit) "i" .
</pre>

<pre>
0i
011i  // == 11i
0.i
2.71828i
1.e+0i
6.67428e-11i
1E6i
.25i
.12345E+5i
</pre>


<h3 id="Rune_literals">Rune literals</h3>

<p>
A rune literal represents a <a href="#Constants">rune constant</a>,
an integer value identifying a Unicode code point.
A rune literal is expressed as one or more characters enclosed in single quotes.
Within the quotes, any character may appear except single
quote and newline. A single quoted character represents the Unicode value
of the character itself,
while multi-character sequences beginning with a backslash encode
values in various formats.
</p>
<p>
The simplest form represents the single character within the quotes;
since Go source text is Unicode characters encoded in UTF-8, multiple
UTF-8-encoded bytes may represent a single integer value.  For
instance, the literal <code>'a'</code> holds a single byte representing
a literal <code>a</code>, Unicode U+0061, value <code>0x61</code>, while
<code>'√§'</code> holds two bytes (<code>0xc3</code> <code>0xa4</code>) representing
a literal <code>a</code>-dieresis, U+00E4, value <code>0xe4</code>.
</p>
<p>
Several backslash escapes allow arbitrary values to be encoded as
ASCII text.  There are four ways to represent the integer value
as a numeric constant: <code>\x</code> followed by exactly two hexadecimal
digits; <code>\u</code> followed by exactly four hexadecimal digits;
<code>\U</code> followed by exactly eight hexadecimal digits, and a
plain backslash <code>\</code> followed by exactly three octal digits.
In each case the value of the literal is the value represented by
the digits in the corresponding base.
</p>
<p>
Although these representations all result in an integer, they have
different valid ranges.  Octal escapes must represent a value between
0 and 255 inclusive.  Hexadecimal escapes satisfy this condition
by construction. The escapes <code>\u</code> and <code>\U</code>
represent Unicode code points so within them some values are illegal,
in particular those above <code>0x10FFFF</code> and surrogate halves.
</p>
<p>
After a backslash, certain single-character escapes represent special values:
</p>
<pre class="grammar">
\a   U+0007 alert or bell
\b   U+0008 backspace
\f   U+000C form feed
\n   U+000A line feed or newline
\r   U+000D carriage return
\t   U+0009 horizontal tab
\v   U+000b vertical tab
\\   U+005c backslash
\'   U+0027 single quote  (valid escape only within rune literals)
\"   U+0022 double quote  (valid escape only within string literals)
</pre>
<p>
All other sequences starting with a backslash are illegal inside rune literals.
</p>
<pre class="ebnf">
rune_lit         = "'" ( unicode_value | byte_value ) "'" .
unicode_value    = unicode_char | little_u_value | big_u_value | escaped_char .
byte_value       = octal_byte_value | hex_byte_value .
octal_byte_value = `\` octal_digit octal_digit octal_digit .
hex_byte_value   = `\` "x" hex_digit hex_digit .
little_u_value   = `\` "u" hex_digit hex_digit hex_digit hex_digit .
big_u_value      = `\` "U" hex_digit hex_digit hex_digit hex_digit
                           hex_digit hex_digit hex_digit hex_digit .
escaped_char     = `\` ( "a" | "b" | "f" | "n" | "r" | "t" | "v" | `\` | "'" | `"` ) .
</pre>

<pre>
'a'
'√§'
'Êú¨'
'\t'
'\000'
'\007'
'\377'
'\x07'
'\xff'
'\u12e4'
'\U00101234'
'aa'         // illegal: too many characters
'\xa'        // illegal: too few hexadecimal digits
'\0'         // illegal: too few octal digits
'\uDFFF'     // illegal: surrogate half
'\U00110000' // illegal: invalid Unicode code point
</pre>


<h3 id="String_literals">String literals</h3>

<p>
A string literal represents a <a href="#Constants">string constant</a>
obtained from concatenating a sequence of characters. There are two forms:
raw string literals and interpreted string literals.
</p>
<p>
Raw string literals are character sequences between back quotes
<code>``</code>.  Within the quotes, any character is legal except
back quote. The value of a raw string literal is the
string composed of the uninterpreted (implicitly UTF-8-encoded) characters
between the quotes;
in particular, backslashes have no special meaning and the string may
contain newlines.
Carriage return characters ('\r') inside raw string literals
are discarded from the raw string value.
</p>
<p>
Interpreted string literals are character sequences between double
quotes <code>&quot;&quot;</code>. The text between the quotes,
which may not contain newlines, forms the
value of the literal, with backslash escapes interpreted as they
are in <a href="#Rune_literals">rune literals</a> (except that <code>\'</code> is illegal and
<code>\"</code> is legal), with the same restrictions.
The three-digit octal (<code>\</code><i>nnn</i>)
and two-digit hexadecimal (<code>\x</code><i>nn</i>) escapes represent individual
<i>bytes</i> of the resulting string; all other escapes represent
the (possibly multi-byte) UTF-8 encoding of individual <i>characters</i>.
Thus inside a string literal <code>\377</code> and <code>\xFF</code> represent
a single byte of value <code>0xFF</code>=255, while <code>√ø</code>,
<code>\u00FF</code>, <code>\U000000FF</code> and <code>\xc3\xbf</code> represent
the two bytes <code>0xc3</code> <code>0xbf</code> of the UTF-8 encoding of character
U+00FF.
</p>

<pre class="ebnf">
string_lit             = raw_string_lit | interpreted_string_lit .
raw_string_lit         = "`" { unicode_char | newline } "`" .
interpreted_string_lit = `"` { unicode_value | byte_value } `"` .
</pre>

<pre>
`abc`  // same as "abc"
`\n
\n`    // same as "\\n\n\\n"
"\n"
""
"Hello, world!\n"
"Êó•Êú¨Ë™û"
"\u65e5Êú¨\U00008a9e"
"\xff\u00FF"
"\uD800"       // illegal: surrogate half
"\U00110000"   // illegal: invalid Unicode code point
</pre>

<p>
These examples all represent the same string:
</p>

<pre>
"Êó•Êú¨Ë™û"                                 // UTF-8 input text
`Êó•Êú¨Ë™û`                                 // UTF-8 input text as a raw literal
"\u65e5\u672c\u8a9e"                    // the explicit Unicode code points
"\U000065e5\U0000672c\U00008a9e"        // the explicit Unicode code points
"\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e"  // the explicit UTF-8 bytes
</pre>

<p>
If the source code represents a character as two code points, such as
a combining form involving an accent and a letter, the result will be
an error if placed in a rune literal (it is not a single code
point), and will appear as two code points if placed in a string
literal.
</p>


<h2 id="Constants">Constants</h2>

<p>There are <i>boolean constants</i>,
<i>rune constants</i>,
<i>integer constants</i>,
<i>floating-point constants</i>, <i>complex constants</i>,
and <i>string constants</i>. Rune, integer, floating-point,
and complex constants are
collectively called <i>numeric constants</i>.
</p>

<p>
A constant value is represented by a
<a href="#Rune_literals">rune</a>,
<a href="#Integer_literals">integer</a>,
<a href="#Floating-point_literals">floating-point</a>,
<a href="#Imaginary_literals">imaginary</a>,
or
<a href="#String_literals">string</a> literal,
an identifier denoting a constant,
a <a href="#Constant_expressions">constant expression</a>,
a <a href="#Conversions">conversion</a> with a result that is a constant, or
the result value of some built-in functions such as
<code>unsafe.Sizeof</code> applied to any value,
<code>cap</code> or <code>len</code> applied to
<a href="#Length_and_capacity">some expressions</a>,
<code>real</code> and <code>imag</code> applied to a complex constant
and <code>complex</code> applied to numeric constants.
The boolean truth values are represented by the predeclared constants
<code>true</code> and <code>false</code>. The predeclared identifier
<a href="#Iota">iota</a> denotes an integer constant.
</p>

<p>
In general, complex constants are a form of
<a href="#Constant_expressions">constant expression</a>
and are discussed in that section.
</p>

<p>
Numeric constants represent values of arbitrary precision and do not overflow.
</p>

<p>
Constants may be <a href="#Types">typed</a> or <i>untyped</i>.
Literal constants, <code>true</code>, <code>false</code>, <code>iota</code>,
and certain <a href="#Constant_expressions">constant expressions</a>
containing only untyped constant operands are untyped.
</p>

<p>
A constant may be given a type explicitly by a <a href="#Constant_declarations">constant declaration</a>
or <a href="#Conversions">conversion</a>, or implicitly when used in a
<a href="#Variable_declarations">variable declaration</a> or an
<a href="#Assignments">assignment</a> or as an
operand in an <a href="#Expressions">expression</a>.
It is an error if the constant value
cannot be represented as a value of the respective type.
For instance, <code>3.0</code> can be given any integer or any
floating-point type, while <code>2147483648.0</code> (equal to <code>1&lt;&lt;31</code>)
can be given the types <code>float32</code>, <code>float64</code>, or <code>uint32</code> but
not <code>int32</code> or <code>string</code>.
</p>

<p>
An untyped constant has a <i>default type</i> which is the type to which the
constant is implicitly converted in contexts where a typed value is required,
for instance, in a <a href="#Short_variable_declarations">short variable declaration</a>
such as <code>i := 0</code> where there is no explicit type.
The default type of an untyped constant is <code>bool</code>, <code>rune</code>,
<code>int</code>, <code>float64</code>, <code>complex128</code> or <code>string</code>
respectively, depending on whether it is a boolean, rune, integer, floating-point,
complex, or string constant.
</p>

<p>
There are no constants denoting the IEEE-754 infinity and not-a-number values,
but the <a href="/pkg/math/"><code>math</code> package</a>'s
<a href="/pkg/math/#Inf">Inf</a>,
<a href="/pkg/math/#NaN">NaN</a>,
<a href="/pkg/math/#IsInf">IsInf</a>, and
<a href="/pkg/math/#IsNaN">IsNaN</a>
functions return and test for those values at run time.
</p>

<p>
Implementation restriction: Although numeric constants have arbitrary
precision in the language, a compiler may implement them using an
internal representation with limited precision.  That said, every
implementation must:
</p>
<ul>
	<li>Represent integer constants with at least 256 bits.</li>

	<li>Represent floating-point constants, including the parts of
	    a complex constant, with a mantissa of at least 256 bits
	    and a signed exponent of at least 32 bits.</li>

	<li>Give an error if unable to represent an integer constant
	    precisely.</li>

	<li>Give an error if unable to represent a floating-point or
	    complex constant due to overflow.</li>

	<li>Round to the nearest representable constant if unable to
	    represent a floating-point or complex constant due to limits
	    on precision.</li>
</ul>
<p>
These requirements apply both to literal constants and to the result
of evaluating <a href="#Constant_expressions">constant
expressions</a>.
</p>

<h2 id="Variables">Variables</h2>

<p>
A variable is a storage location for holding a <i>value</i>.
The set of permissible values is determined by the
variable's <i><a href="#Types">type</a></i>.
</p>

<p>
A <a href="#Variable_declarations">variable declaration</a>
or, for function parameters and results, the signature
of a <a href="#Function_declarations">function declaration</a>
or <a href="#Function_literals">function literal</a> reserves
storage for a named variable.

Calling the built-in function <a href="#Allocation"><code>new</code></a>
or taking the address of a <a href="#Composite_literals">composite literal</a>
allocates storage for a variable at run time.
Such an anonymous variable is referred to via a (possibly implicit)
<a href="#Address_operators">pointer indirection</a>.
</p>

<p>
<i>Structured</i> variables of <a href="#Array_types">array</a>, <a href="#Slice_types">slice</a>,
and <a href="#Struct_types">struct</a> types have elements and fields that may
be <a href="#Address_operators">addressed</a> individually. Each such element
acts like a variable.
</p>

<p>
The <i>static type</i> (or just <i>type</i>) of a variable is the	
type given in its declaration, the type provided in the
<code>new</code> call or composite literal, or the type of
an element of a structured variable.
Variables of interface type also have a distinct <i>dynamic type</i>,
which is the concrete type of the value assigned to the variable at run time
(unless the value is the predeclared identifier <code>nil</code>,
which has no type).
The dynamic type may vary during execution but values stored in interface
variables are always <a href="#Assignability">assignable</a>
to the static type of the variable.	
</p>	

<pre>
var x interface{}  // x is nil and has static type interface{}
var v *T           // v has value nil, static type *T
x = 42             // x has value 42 and dynamic type int
x = v              // x has value (*T)(nil) and dynamic type *T
</pre>

<p>
A variable's value is retrieved by referring to the variable in an
<a href="#Expressions">expression</a>; it is the most recent value
<a href="#Assignments">assigned</a> to the variable.
If a variable has not yet been assigned a value, its value is the
<a href="#The_zero_value">zero value</a> for its type.
</p>


<h2 id="Types">Types</h2>

<p>
A type determines the set of values and operations specific to values of that
type. Types may be <i>named</i> or <i>unnamed</i>. Named types are specified
by a (possibly <a href="#Qualified_identifiers">qualified</a>)
<a href="#Type_declarations"><i>type name</i></a>; unnamed types are specified
using a <i>type literal</i>, which composes a new type from existing types.
</p>

<pre class="ebnf">
Type      = TypeName | TypeLit | "(" Type ")" .
TypeName  = identifier | QualifiedIdent .
TypeLit   = ArrayType | StructType | PointerType | FunctionType | InterfaceType |
	    SliceType | MapType | ChannelType .
</pre>

<p>
Named instances of the boolean, numeric, and string types are
<a href="#Predeclared_identifiers">predeclared</a>.
<i>Composite types</i>&mdash;array, struct, pointer, function,
interface, slice, map, and channel types&mdash;may be constructed using
type literals.
</p>

<p>
Each type <code>T</code> has an <i>underlying type</i>: If <code>T</code>
is one of the predeclared boolean, numeric, or string types, or a type literal,
the corresponding underlying
type is <code>T</code> itself. Otherwise, <code>T</code>'s underlying type
is the underlying type of the type to which <code>T</code> refers in its
<a href="#Type_declarations">type declaration</a>.
</p>

<pre>
   type T1 string
   type T2 T1
   type T3 []T1
   type T4 T3
</pre>

<p>
The underlying type of <code>string</code>, <code>T1</code>, and <code>T2</code>
is <code>string</code>. The underlying type of <code>[]T1</code>, <code>T3</code>,
and <code>T4</code> is <code>[]T1</code>.
</p>

<h3 id="Method_sets">Method sets</h3>
<p>
A type may have a <i>method set</i> associated with it.
The method set of an <a href="#Interface_types">interface type</a> is its interface.
The method set of any other type <code>T</code> consists of all
<a href="#Method_declarations">methods</a> declared with receiver type <code>T</code>.
The method set of the corresponding <a href="#Pointer_types">pointer type</a> <code>*T</code>
is the set of all methods declared with receiver <code>*T</code> or <code>T</code>
(that is, it also contains the method set of <code>T</code>).
Further rules apply to structs containing anonymous fields, as described
in the section on <a href="#Struct_types">struct types</a>.
Any other type has an empty method set.
In a method set, each method must have a
<a href="#Uniqueness_of_identifiers">unique</a>
non-<a href="#Blank_identifier">blank</a> <a href="#MethodName">method name</a>.
</p>

<p>
The method set of a type determines the interfaces that the
type <a href="#Interface_types">implements</a>
and the methods that can be <a href="#Calls">called</a>
using a receiver of that type.
</p>

<h3 id="Boolean_types">Boolean types</h3>

<p>
A <i>boolean type</i> represents the set of Boolean truth values
denoted by the predeclared constants <code>true</code>
and <code>false</code>. The predeclared boolean type is <code>bool</code>.
</p>

<h3 id="Numeric_types">Numeric types</h3>

<p>
A <i>numeric type</i> represents sets of integer or floating-point values.
The predeclared architecture-independent numeric types are:
</p>

<pre class="grammar">
uint8       the set of all unsigned  8-bit integers (0 to 255)
uint16      the set of all unsigned 16-bit integers (0 to 65535)
uint32      the set of all unsigned 32-bit integers (0 to 4294967295)
uint64      the set of all unsigned 64-bit integers (0 to 18446744073709551615)

int8        the set of all signed  8-bit integers (-128 to 127)
int16       the set of all signed 16-bit integers (-32768 to 32767)
int32       the set of all signed 32-bit integers (-2147483648 to 2147483647)
int64       the set of all signed 64-bit integers (-9223372036854775808 to 9223372036854775807)

float32     the set of all IEEE-754 32-bit floating-point numbers
float64     the set of all IEEE-754 64-bit floating-point numbers

complex64   the set of all complex numbers with float32 real and imaginary parts
complex128  the set of all complex numbers with float64 real and imaginary parts

byte        alias for uint8
rune        alias for int32
</pre>

<p>
The value of an <i>n</i>-bit integer is <i>n</i> bits wide and represented using
<a href="http://en.wikipedia.org/wiki/Two's_complement">two's complement arithmetic</a>.
</p>

<p>
There is also a set of predeclared numeric types with implementation-specific sizes:
</p>

<pre class="grammar">
uint     either 32 or 64 bits
int      same size as uint
uintptr  an unsigned integer large enough to store the uninterpreted bits of a pointer value
</pre>

<p>
To avoid portability issues all numeric types are distinct except
<code>byte</code>, which is an alias for <code>uint8</code>, and
<code>rune</code>, which is an alias for <code>int32</code>.
Conversions
are required when different numeric types are mixed in an expression
or assignment. For instance, <code>int32</code> and <code>int</code>
are not the same type even though they may have the same size on a
particular architecture.


<h3 id="String_types">String types</h3>

<p>
A <i>string type</i> represents the set of string values.
A string value is a (possibly empty) sequence of bytes.
Strings are immutable: once created,
it is impossible to change the contents of a string.
The predeclared string type is <code>string</code>.
</p>

<p>
The length of a string <code>s</code> (its size in bytes) can be discovered using
the built-in function <a href="#Length_and_capacity"><code>len</code></a>.
The length is a compile-time constant if the string is a constant.
A string's bytes can be accessed by integer <a href="#Index_expressions">indices</a>
0 through <code>len(s)-1</code>.
It is illegal to take the address of such an element; if
<code>s[i]</code> is the <code>i</code>'th byte of a
string, <code>&amp;s[i]</code> is invalid.
</p>


<h3 id="Array_types">Array types</h3>

<p>
An array is a numbered sequence of elements of a single
type, called the element type.
The number of elements is called the length and is never
negative.
</p>

<pre class="ebnf">
ArrayType   = "[" ArrayLength "]" ElementType .
ArrayLength = Expression .
ElementType = Type .
</pre>

<p>
The length is part of the array's type; it must evaluate to a
non-negative <a href="#Constants">constant</a> representable by a value
of type <code>int</code>.
The length of array <code>a</code> can be discovered
using the built-in function <a href="#Length_and_capacity"><code>len</code></a>.
The elements can be addressed by integer <a href="#Index_expressions">indices</a>
0 through <code>len(a)-1</code>.
Array types are always one-dimensional but may be composed to form
multi-dimensional types.
</p>

<pre>
[32]byte
[2*N] struct { x, y int32 }
[1000]*float64
[3][5]int
[2][2][2]float64  // same as [2]([2]([2]float64))
</pre>

<h3 id="Slice_types">Slice types</h3>

<p>
A slice is a descriptor for a contiguous segment of an <i>underlying array</i> and
provides access to a numbered sequence of elements from that array.
A slice type denotes the set of all slices of arrays of its element type.
The value of an uninitialized slice is <code>nil</code>.
</p>

<pre class="ebnf">
SliceType = "[" "]" ElementType .
</pre>

<p>
Like arrays, slices are indexable and have a length.  The length of a
slice <code>s</code> can be discovered by the built-in function
<a href="#Length_and_capacity"><code>len</code></a>; unlike with arrays it may change during
execution.  The elements can be addressed by integer <a href="#Index_expressions">indices</a>
0 through <code>len(s)-1</code>.  The slice index of a
given element may be less than the index of the same element in the
underlying array.
</p>
<p>
A slice, once initialized, is always associated with an underlying
array that holds its elements.  A slice therefore shares storage
with its array and with other slices of the same array; by contrast,
distinct arrays always represent distinct storage.
</p>
<p>
The array underlying a slice may extend past the end of the slice.
The <i>capacity</i> is a measure of that extent: it is the sum of
the length of the slice and the length of the array beyond the slice;
a slice of length up to that capacity can be created by
<a href="#Slice_expressions"><i>slicing</i></a> a new one from the original slice.
The capacity of a slice <code>a</code> can be discovered using the
built-in function <a href="#Length_and_capacity"><code>cap(a)</code></a>.
</p>

<p>
A new, initialized slice value for a given element type <code>T</code> is
made using the built-in function
<a href="#Making_slices_maps_and_channels"><code>make</code></a>,
which takes a slice type
and parameters specifying the length and optionally the capacity.
A slice created with <code>make</code> always allocates a new, hidden array
to which the returned slice value refers. That is, executing
</p>

<pre>
make([]T, length, capacity)
</pre>

<p>
produces the same slice as allocating an array and <a href="#Slice_expressions">slicing</a>
it, so these two expressions are equivalent:
</p>

<pre>
make([]int, 50, 100)
new([100]int)[0:50]
</pre>

<p>
Like arrays, slices are always one-dimensional but may be composed to construct
higher-dimensional objects.
With arrays of arrays, the inner arrays are, by construction, always the same length;
however with slices of slices (or arrays of slices), the inner lengths may vary dynamically.
Moreover, the inner slices must be initialized individually.
</p>

<h3 id="Struct_types">Struct types</h3>

<p>
A struct is a sequence of named elements, called fields, each of which has a
name and a type. Field names may be specified explicitly (IdentifierList) or
implicitly (AnonymousField).
Within a struct, non-<a href="#Blank_identifier">blank</a> field names must
be <a href="#Uniqueness_of_identifiers">unique</a>.
</p>

<pre class="ebnf">
StructType     = "struct" "{" { FieldDecl ";" } "}" .
FieldDecl      = (IdentifierList Type | AnonymousField) [ Tag ] .
AnonymousField = [ "*" ] TypeName .
Tag            = string_lit .
</pre>

<pre>
// An empty struct.
struct {}

// A struct with 6 fields.
struct {
	x, y int
	u float32
	_ float32  // padding
	A *[]int
	F func()
}
</pre>

<p>
A field declared with a type but no explicit field name is an <i>anonymous field</i>,
also called an <i>embedded</i> field or an embedding of the type in the struct.
An embedded type must be specified as
a type name <code>T</code> or as a pointer to a non-interface type name <code>*T</code>,
and <code>T</code> itself may not be
a pointer type. The unqualified type name acts as the field name.
</p>

<pre>
// A struct with four anonymous fields of type T1, *T2, P.T3 and *P.T4
struct {
	T1        // field name is T1
	*T2       // field name is T2
	P.T3      // field name is T3
	*P.T4     // field name is T4
	x, y int  // field names are x and y
}
</pre>

<p>
The following declaration is illegal because field names must be unique
in a struct type:
</p>

<pre>
struct {
	T     // conflicts with anonymous field *T and *P.T
	*T    // conflicts with anonymous field T and *P.T
	*P.T  // conflicts with anonymous field T and *T
}
</pre>

<p>
A field or <a href="#Method_declarations">method</a> <code>f</code> of an
anonymous field in a struct <code>x</code> is called <i>promoted</i> if
<code>x.f</code> is a legal <a href="#Selectors">selector</a> that denotes
that field or method <code>f</code>.
</p>

<p>
Promoted fields act like ordinary fields
of a struct except that they cannot be used as field names in
<a href="#Composite_literals">composite literals</a> of the struct.
</p>

<p>
Given a struct type <code>S</code> and a type named <code>T</code>,
promoted methods are included in the method set of the struct as follows:
</p>
<ul>
	<li>
	If <code>S</code> contains an anonymous field <code>T</code>,
	the <a href="#Method_sets">method sets</a> of <code>S</code>
	and <code>*S</code> both include promoted methods with receiver
	<code>T</code>. The method set of <code>*S</code> also
	includes promoted methods with receiver <code>*T</code>.
	</li>

	<li>
	If <code>S</code> contains an anonymous field <code>*T</code>,
	the method sets of <code>S</code> and <code>*S</code> both
	include promoted methods with receiver <code>T</code> or
	<code>*T</code>.
	</li>
</ul>

<p>
A field declaration may be followed by an optional string literal <i>tag</i>,
which becomes an attribute for all the fields in the corresponding
field declaration. The tags are made
visible through a <a href="/pkg/reflect/#StructTag">reflection interface</a>
and take part in <a href="#Type_identity">type identity</a> for structs
but are otherwise ignored.
</p>

<pre>
// A struct corresponding to the TimeStamp protocol buffer.
// The tag strings define the protocol buffer field numbers.
struct {
	microsec  uint64 "field 1"
	serverIP6 uint64 "field 2"
	process   string "field 3"
}
</pre>

<h3 id="Pointer_types">Pointer types</h3>

<p>
A pointer type denotes the set of all pointers to <a href="#Variables">variables</a> of a given
type, called the <i>base type</i> of the pointer.
The value of an uninitialized pointer is <code>nil</code>.
</p>

<pre class="ebnf">
PointerType = "*" BaseType .
BaseType    = Type .
</pre>

<pre>
*Point
*[4]int
</pre>

<h3 id="Function_types">Function types</h3>

<p>
A function type denotes the set of all functions with the same parameter
and result types. The value of an uninitialized variable of function type
is <code>nil</code>.
</p>

<pre class="ebnf">
FunctionType   = "func" Signature .
Signature      = Parameters [ Result ] .
Result         = Parameters | Type .
Parameters     = "(" [ ParameterList [ "," ] ] ")" .
ParameterList  = ParameterDecl { "," ParameterDecl } .
ParameterDecl  = [ IdentifierList ] [ "..." ] Type .
</pre>

<p>
Within a list of parameters or results, the names (IdentifierList)
must either all be present or all be absent. If present, each name
stands for one item (parameter or result) of the specified type and
all non-<a href="#Blank_identifier">blank</a> names in the signature
must be <a href="#Uniqueness_of_identifiers">unique</a>.
If absent, each type stands for one item of that type.
Parameter and result
lists are always parenthesized except that if there is exactly
one unnamed result it may be written as an unparenthesized type.
</p>

<p>
The final parameter in a function signature may have
a type prefixed with <code>...</code>.
A function with such a parameter is called <i>variadic</i> and
may be invoked with zero or more arguments for that parameter.
</p>

<pre>
func()
func(x int) int
func(a, _ int, z float32) bool
func(a, b int, z float32) (bool)
func(prefix string, values ...int)
func(a, b int, z float64, opt ...interface{}) (success bool)
func(int, int, float64) (float64, *[]int)
func(n int) func(p *T)
</pre>


<h3 id="Interface_types">Interface types</h3>

<p>
An interface type specifies a <a href="#Method_sets">method set</a> called its <i>interface</i>.
A variable of interface type can store a value of any type with a method set
that is any superset of the interface. Such a type is said to
<i>implement the interface</i>.
The value of an uninitialized variable of interface type is <code>nil</code>.
</p>

<pre class="ebnf">
InterfaceType      = "interface" "{" { MethodSpec ";" } "}" .
MethodSpec         = MethodName Signature | InterfaceTypeName .
MethodName         = identifier .
InterfaceTypeName  = TypeName .
</pre>

<p>
As with all method sets, in an interface type, each method must have a
<a href="#Uniqueness_of_identifiers">unique</a>
non-<a href="#Blank_identifier">blank</a> name.
</p>

<pre>
// A simple File interface
interface {
	Read(b Buffer) bool
	Write(b Buffer) bool
	Close()
}
</pre>

<p>
More than one type may implement an interface.
For instance, if two types <code>S1</code> and <code>S2</code>
have the method set
</p>

<pre>
func (p T) Read(b Buffer) bool { return ‚Ä¶ }
func (p T) Write(b Buffer) bool { return ‚Ä¶ }
func (p T) Close() { ‚Ä¶ }
</pre>

<p>
(where <code>T</code> stands for either <code>S1</code> or <code>S2</code>)
then the <code>File</code> interface is implemented by both <code>S1</code> and
<code>S2</code>, regardless of what other methods
<code>S1</code> and <code>S2</code> may have or share.
</p>

<p>
A type implements any interface comprising any subset of its methods
and may therefore implement several distinct interfaces. For
instance, all types implement the <i>empty interface</i>:
</p>

<pre>
interface{}
</pre>

<p>
Similarly, consider this interface specification,
which appears within a <a href="#Type_declarations">type declaration</a>
to define an interface called <code>Locker</code>:
</p>

<pre>
type Locker interface {
	Lock()
	Unlock()
}
</pre>

<p>
If <code>S1</code> and <code>S2</code> also implement
</p>

<pre>
func (p T) Lock() { ‚Ä¶ }
func (p T) Unlock() { ‚Ä¶ }
</pre>

<p>
they implement the <code>Locker</code> interface as well
as the <code>File</code> interface.
</p>

<p>
An interface <code>T</code> may use a (possibly qualified) interface type
name <code>E</code> in place of a method specification. This is called
<i>embedding</i> interface <code>E</code> in <code>T</code>; it adds
all (exported and non-exported) methods of <code>E</code> to the interface
<code>T</code>.
</p>

<pre>
type ReadWriter interface {
	Read(b Buffer) bool
	Write(b Buffer) bool
}

type File interface {
	ReadWriter  // same as adding the methods of ReadWriter
	Locker      // same as adding the methods of Locker
	Close()
}

type LockedFile interface {
	Locker
	File        // illegal: Lock, Unlock not unique
	Lock()      // illegal: Lock not unique
}
</pre>

<p>
An interface type <code>T</code> may not embed itself
or any interface type that embeds <code>T</code>, recursively.
</p>

<pre>
// illegal: Bad cannot embed itself
type Bad interface {
	Bad
}

// illegal: Bad1 cannot embed itself using Bad2
type Bad1 interface {
	Bad2
}
type Bad2 interface {
	Bad1
}
</pre>

<h3 id="Map_types">Map types</h3>

<p>
A map is an unordered group of elements of one type, called the
element type, indexed by a set of unique <i>keys</i> of another type,
called the key type.
The value of an uninitialized map is <code>nil</code>.
</p>

<pre class="ebnf">
MapType     = "map" "[" KeyType "]" ElementType .
KeyType     = Type .
</pre>

<p>
The <a href="#Comparison_operators">comparison operators</a>
<code>==</code> and <code>!=</code> must be fully defined
for operands of the key type; thus the key type must not be a function, map, or
slice.
If the key type is an interface type, these
comparison operators must be defined for the dynamic key values;
failure will cause a <a href="#Run_time_panics">run-time panic</a>.

</p>

<pre>
map[string]int
map[*T]struct{ x, y float64 }
map[string]interface{}
</pre>

<p>
The number of map elements is called its length.
For a map <code>m</code>, it can be discovered using the
built-in function <a href="#Length_and_capacity"><code>len</code></a>
and may change during execution. Elements may be added during execution
using <a href="#Assignments">assignments</a> and retrieved with
<a href="#Index_expressions">index expressions</a>; they may be removed with the
<a href="#Deletion_of_map_elements"><code>delete</code></a> built-in function.
</p>
<p>
A new, empty map value is made using the built-in
function <a href="#Making_slices_maps_and_channels"><code>make</code></a>,
which takes the map type and an optional capacity hint as arguments:
</p>

<pre>
make(map[string]int)
make(map[string]int, 100)
</pre>

<p>
The initial capacity does not bound its size:
maps grow to accommodate the number of items
stored in them, with the exception of <code>nil</code> maps.
A <code>nil</code> map is equivalent to an empty map except that no elements
may be added.

<h3 id="Channel_types">Channel types</h3>

<p>
A channel provides a mechanism for
<a href="#Go_statements">concurrently executing functions</a>
to communicate by
<a href="#Send_statements">sending</a> and
<a href="#Receive_operator">receiving</a>
values of a specified element type.
The value of an uninitialized channel is <code>nil</code>.
</p>

<pre class="ebnf">
ChannelType = ( "chan" | "chan" "&lt;-" | "&lt;-" "chan" ) ElementType .
</pre>

<p>
The optional <code>&lt;-</code> operator specifies the channel <i>direction</i>,
<i>send</i> or <i>receive</i>. If no direction is given, the channel is
<i>bidirectional</i>.
A channel may be constrained only to send or only to receive by
<a href="#Conversions">conversion</a> or <a href="#Assignments">assignment</a>.
</p>

<pre>
chan T          // can be used to send and receive values of type T
chan&lt;- float64  // can only be used to send float64s
&lt;-chan int      // can only be used to receive ints
</pre>

<p>
The <code>&lt;-</code> operator associates with the leftmost <code>chan</code>
possible:
</p>

<pre>
chan&lt;- chan int    // same as chan&lt;- (chan int)
chan&lt;- &lt;-chan int  // same as chan&lt;- (&lt;-chan int)
&lt;-chan &lt;-chan int  // same as &lt;-chan (&lt;-chan int)
chan (&lt;-chan int)
</pre>

<p>
A new, initialized channel
value can be made using the built-in function
<a href="#Making_slices_maps_and_channels"><code>make</code></a>,
which takes the channel type and an optional <i>capacity</i> as arguments:
</p>

<pre>
make(chan int, 100)
</pre>

<p>
The capacity, in number of elements, sets the size of the buffer in the channel.
If the capacity is zero or absent, the channel is unbuffered and communication
succeeds only when both a sender and receiver are ready. Otherwise, the channel
is buffered and communication succeeds without blocking if the buffer
is not full (sends) or not empty (receives).
A <code>nil</code> channel is never ready for communication.
</p>

<p>
A channel may be closed with the built-in function
<a href="#Close"><code>close</code></a>.
The multi-valued assignment form of the
<a href="#Receive_operator">receive operator</a>
reports whether a received value was sent before
the channel was closed.
</p>

<p>
A single channel may be used in
<a href="#Send_statements">send statements</a>,
<a href="#Receive_operator">receive operations</a>,
and calls to the built-in functions
<a href="#Length_and_capacity"><code>cap</code></a> and
<a href="#Length_and_capacity"><code>len</code></a>
by any number of goroutines without further synchronization.
Channels act as first-in-first-out queues.
For example, if one goroutine sends values on a channel
and a second goroutine receives them, the values are
received in the order sent.
</p>

<h2 id="Properties_of_types_and_values">Properties of types and values</h2>

<h3 id="Type_identity">Type identity</h3>

<p>
Two types are either <i>identical</i> or <i>different</i>.
</p>

<p>
Two <a href="#Types">named types</a> are identical if their type names originate in the same
<a href="#Type_declarations">TypeSpec</a>.
A named and an <a href="#Types">unnamed type</a> are always different. Two unnamed types are identical
if the corresponding type literals are identical, that is, if they have the same
literal structure and corresponding components have identical types. In detail:
</p>

<ul>
	<li>Two array types are identical if they have identical element types and
	    the same array length.</li>

	<li>Two slice types are identical if they have identical element types.</li>

	<li>Two struct types are identical if they have the same sequence of fields,
	    and if corresponding fields have the same names, and identical types,
	    and identical tags.
	    Two anonymous fields are considered to have the same name. Lower-case field
	    names from different packages are always different.</li>

	<li>Two pointer types are identical if they have identical base types.</li>

	<li>Two function types are identical if they have the same number of parameters
	    and result values, corresponding parameter and result types are
	    identical, and either both functions are variadic or neither is.
	    Parameter and result names are not required to match.</li>

	<li>Two interface types are identical if they have the same set of methods
	    with the same names and identical function types. Lower-case method names from
	    different packages are always different. The order of the methods is irrelevant.</li>

	<li>Two map types are identical if they have identical key and value types.</li>

	<li>Two channel types are identical if they have identical value types and
	    the same direction.</li>
</ul>

<p>
Given the declarations
</p>

<pre>
type (
	T0 []string
	T1 []string
	T2 struct{ a, b int }
	T3 struct{ a, c int }
	T4 func(int, float64) *T0
	T5 func(x int, y float64) *[]string
)
</pre>

<p>
these types are identical:
</p>

<pre>
T0 and T0
[]int and []int
struct{ a, b *T5 } and struct{ a, b *T5 }
func(x int, y float64) *[]string and func(int, float64) (result *[]string)
</pre>

<p>
<code>T0</code> and <code>T1</code> are different because they are named types
with distinct declarations; <code>func(int, float64) *T0</code> and
<code>func(x int, y float64) *[]string</code> are different because <code>T0</code>
is different from <code>[]string</code>.
</p>


<h3 id="Assignability">Assignability</h3>

<p>
A value <code>x</code> is <i>assignable</i> to a <a href="#Variables">variable</a> of type <code>T</code>
("<code>x</code> is assignable to <code>T</code>") in any of these cases:
</p>

<ul>
<li>
<code>x</code>'s type is identical to <code>T</code>.
</li>
<li>
<code>x</code>'s type <code>V</code> and <code>T</code> have identical
<a href="#Types">underlying types</a> and at least one of <code>V</code>
or <code>T</code> is not a <a href="#Types">named type</a>.
</li>
<li>
<code>T</code> is an interface type and
<code>x</code> <a href="#Interface_types">implements</a> <code>T</code>.
</li>
<li>
<code>x</code> is a bidirectional channel value, <code>T</code> is a channel type,
<code>x</code>'s type <code>V</code> and <code>T</code> have identical element types,
and at least one of <code>V</code> or <code>T</code> is not a named type.
</li>
<li>
<code>x</code> is the predeclared identifier <code>nil</code> and <code>T</code>
is a pointer, function, slice, map, channel, or interface type.
</li>
<li>
<code>x</code> is an untyped <a href="#Constants">constant</a> representable
by a value of type <code>T</code>.
</li>
</ul>


<h2 id="Blocks">Blocks</h2>

<p>
A <i>block</i> is a possibly empty sequence of declarations and statements
within matching brace brackets.
</p>

<pre class="ebnf">
Block = "{" StatementList "}" .
StatementList = { Statement ";" } .
</pre>

<p>
In addition to explicit blocks in the source code, there are implicit blocks:
</p>

<ol>
	<li>The <i>universe block</i> encompasses all Go source text.</li>

	<li>Each <a href="#Packages">package</a> has a <i>package block</i> containing all
	    Go source text for that package.</li>

	<li>Each file has a <i>file block</i> containing all Go source text
	    in that file.</li>

	<li>Each <a href="#If_statements">"if"</a>,
	    <a href="#For_statements">"for"</a>, and
	    <a href="#Switch_statements">"switch"</a>
	    statement is considered to be in its own implicit block.</li>

	<li>Each clause in a <a href="#Switch_statements">"switch"</a>
	    or <a href="#Select_statements">"select"</a> statement
	    acts as an implicit block.</li>
</ol>

<p>
Blocks nest and influence <a href="#Declarations_and_scope">scoping</a>.
</p>


<h2 id="Declarations_and_scope">Declarations and scope</h2>

<p>
A <i>declaration</i> binds a non-<a href="#Blank_identifier">blank</a> identifier to a
<a href="#Constant_declarations">constant</a>,
<a href="#Type_declarations">type</a>,
<a href="#Variable_declarations">variable</a>,
<a href="#Function_declarations">function</a>,
<a href="#Labeled_statements">label</a>, or
<a href="#Import_declarations">package</a>.
Every identifier in a program must be declared.
No identifier may be declared twice in the same block, and
no identifier may be declared in both the file and package block.
</p>

<p>
The <a href="#Blank_identifier">blank identifier</a> may be used like any other identifier
in a declaration, but it does not introduce a binding and thus is not declared.
In the package block, the identifier <code>init</code> may only be used for
<a href="#Package_initialization"><code>init</code> function</a> declarations,
and like the blank identifier it does not introduce a new binding.
</p>

<pre class="ebnf">
Declaration   = ConstDecl | TypeDecl | VarDecl .
TopLevelDecl  = Declaration | FunctionDecl | MethodDecl .
</pre>

<p>
The <i>scope</i> of a declared identifier is the extent of source text in which
the identifier denotes the specified constant, type, variable, function, label, or package.
</p>

<p>
Go is lexically scoped using <a href="#Blocks">blocks</a>:
</p>

<ol>
	<li>The scope of a <a href="#Predeclared_identifiers">predeclared identifier</a> is the universe block.</li>

	<li>The scope of an identifier denoting a constant, type, variable,
	    or function (but not method) declared at top level (outside any
	    function) is the package block.</li>

	<li>The scope of the package name of an imported package is the file block
	    of the file containing the import declaration.</li>

	<li>The scope of an identifier denoting a method receiver, function parameter,
	    or result variable is the function body.</li>

	<li>The scope of a constant or variable identifier declared
	    inside a function begins at the end of the ConstSpec or VarSpec
	    (ShortVarDecl for short variable declarations)
	    and ends at the end of the innermost containing block.</li>

	<li>The scope of a type identifier declared inside a function
	    begins at the identifier in the TypeSpec
	    and ends at the end of the innermost containing block.</li>
</ol>

<p>
An identifier declared in a block may be redeclared in an inner block.
While the identifier of the inner declaration is in scope, it denotes
the entity declared by the inner declaration.
</p>

<p>
The <a href="#Package_clause">package clause</a> is not a declaration; the package name
does not appear in any scope. Its purpose is to identify the files belonging
to the same <a href="#Packages">package</a> and to specify the default package name for import
declarations.
</p>


<h3 id="Label_scopes">Label scopes</h3>

<p>
Labels are declared by <a href="#Labeled_statements">labeled statements</a> and are
used in the <a href="#Break_statements">"break"</a>,
<a href="#Continue_statements">"continue"</a>, and
<a href="#Goto_statements">"goto"</a> statements.
It is illegal to define a label that is never used.
In contrast to other identifiers, labels are not block scoped and do
not conflict with identifiers that are not labels. The scope of a label
is the body of the function in which it is declared and excludes
the body of any nested function.
</p>


<h3 id="Blank_identifier">Blank identifier</h3>

<p>
The <i>blank identifier</i> is represented by the underscore character <code>_</code>.
It serves as an anonymous placeholder instead of a regular (non-blank)
identifier and has special meaning in <a href="#Declarations_and_scope">declarations</a>,
as an <a href="#Operands">operand</a>, and in <a href="#Assignments">assignments</a>.
</p>


<h3 id="Predeclared_identifiers">Predeclared identifiers</h3>

<p>
The following identifiers are implicitly declared in the
<a href="#Blocks">universe block</a>:
</p>
<pre class="grammar">
Types:
	bool byte complex64 complex128 error float32 float64
	int int8 int16 int32 int64 rune string
	uint uint8 uint16 uint32 uint64 uintptr

Constants:
	true false iota

Zero value:
	nil

Functions:
	append cap close complex copy delete imag len
	make new panic print println real recover
</pre>


<h3 id="Exported_identifiers">Exported identifiers</h3>

<p>
An identifier may be <i>exported</i> to permit access to it from another package.
An identifier is exported if both:
</p>
<ol>
	<li>the first character of the identifier's name is a Unicode upper case
	letter (Unicode class "Lu"); and</li>
	<li>the identifier is declared in the <a href="#Blocks">package block</a>
	or it is a <a href="#Struct_types">field name</a> or
	<a href="#MethodName">method name</a>.</li>
</ol>
<p>
All other identifiers are not exported.
</p>


<h3 id="Uniqueness_of_identifiers">Uniqueness of identifiers</h3>

<p>
Given a set of identifiers, an identifier is called <i>unique</i> if it is
<i>different</i> from every other in the set.
Two identifiers are different if they are spelled differently, or if they
appear in different <a href="#Packages">packages</a> and are not
<a href="#Exported_identifiers">exported</a>. Otherwise, they are the same.
</p>

<h3 id="Constant_declarations">Constant declarations</h3>

<p>
A constant declaration binds a list of identifiers (the names of
the constants) to the values of a list of <a href="#Constant_expressions">constant expressions</a>.
The number of identifiers must be equal
to the number of expressions, and the <i>n</i>th identifier on
the left is bound to the value of the <i>n</i>th expression on the
right.
</p>

<pre class="ebnf">
ConstDecl      = "const" ( ConstSpec | "(" { ConstSpec ";" } ")" ) .
ConstSpec      = IdentifierList [ [ Type ] "=" ExpressionList ] .

IdentifierList = identifier { "," identifier } .
ExpressionList = Expression { "," Expression } .
</pre>

<p>
If the type is present, all constants take the type specified, and
the expressions must be <a href="#Assignability">assignable</a> to that type.
If the type is omitted, the constants take the
individual types of the corresponding expressions.
If the expression values are untyped <a href="#Constants">constants</a>,
the declared constants remain untyped and the constant identifiers
denote the constant values. For instance, if the expression is a
floating-point literal, the constant identifier denotes a floating-point
constant, even if the literal's fractional part is zero.
</p>

<pre>
const Pi float64 = 3.14159265358979323846
const zero = 0.0         // untyped floating-point constant
const (
	size int64 = 1024
	eof        = -1  // untyped integer constant
)
const a, b, c = 3, 4, "foo"  // a = 3, b = 4, c = "foo", untyped integer and string constants
const u, v float32 = 0, 3    // u = 0.0, v = 3.0
</pre>

<p>
Within a parenthesized <code>const</code> declaration list the
expression list may be omitted from any but the first declaration.
Such an empty list is equivalent to the textual substitution of the
first preceding non-empty expression list and its type if any.
Omitting the list of expressions is therefore equivalent to
repeating the previous list.  The number of identifiers must be equal
to the number of expressions in the previous list.
Together with the <a href="#Iota"><code>iota</code> constant generator</a>
this mechanism permits light-weight declaration of sequential values:
</p>

<pre>
const (
	Sunday = iota
	Monday
	Tuesday
	Wednesday
	Thursday
	Friday
	Partyday
	numberOfDays  // this constant is not exported
)
</pre>


<h3 id="Iota">Iota</h3>

<p>
Within a <a href="#Constant_declarations">constant declaration</a>, the predeclared identifier
<code>iota</code> represents successive untyped integer <a href="#Constants">
constants</a>. It is reset to 0 whenever the reserved word <code>const</code>
appears in the source and increments after each <a href="#ConstSpec">ConstSpec</a>.
It can be used to construct a set of related constants:
</p>

<pre>
const (  // iota is reset to 0
	c0 = iota  // c0 == 0
	c1 = iota  // c1 == 1
	c2 = iota  // c2 == 2
)

const (
	a = 1 &lt;&lt; iota  // a == 1 (iota has been reset)
	b = 1 &lt;&lt; iota  // b == 2
	c = 1 &lt;&lt; iota  // c == 4
)

const (
	u         = iota * 42  // u == 0     (untyped integer constant)
	v float64 = iota * 42  // v == 42.0  (float64 constant)
	w         = iota * 42  // w == 84    (untyped integer constant)
)

const x = iota  // x == 0 (iota has been reset)
const y = iota  // y == 0 (iota has been reset)
</pre>

<p>
Within an ExpressionList, the value of each <code>iota</code> is the same because
it is only incremented after each ConstSpec:
</p>

<pre>
const (
	bit0, mask0 = 1 &lt;&lt; iota, 1&lt;&lt;iota - 1  // bit0 == 1, mask0 == 0
	bit1, mask1                           // bit1 == 2, mask1 == 1
	_, _                                  // skips iota == 2
	bit3, mask3                           // bit3 == 8, mask3 == 7
)
</pre>

<p>
This last example exploits the implicit repetition of the
last non-empty expression list.
</p>


<h3 id="Type_declarations">Type declarations</h3>

<p>
A type declaration binds an identifier, the <i>type name</i>, to a new type
that has the same <a href="#Types">underlying type</a> as an existing type,
and operations defined for the existing type are also defined for the new type.
The new type is <a href="#Type_identity">different</a> from the existing type.
</p>

<pre class="ebnf">
TypeDecl     = "type" ( TypeSpec | "(" { TypeSpec ";" } ")" ) .
TypeSpec     = identifier Type .
</pre>

<pre>
type IntArray [16]int

type (
	Point struct{ x, y float64 }
	Polar Point
)

type TreeNode struct {
	left, right *TreeNode
	value *Comparable
}

type Block interface {
	BlockSize() int
	Encrypt(src, dst []byte)
	Decrypt(src, dst []byte)
}
</pre>

<p>
The declared type does not inherit any <a href="#Method_declarations">methods</a>
bound to the existing type, but the <a href="#Method_sets">method set</a>
of an interface type or of elements of a composite type remains unchanged:
</p>

<pre>
// A Mutex is a data type with two methods, Lock and Unlock.
type Mutex struct         { /* Mutex fields */ }
func (m *Mutex) Lock()    { /* Lock implementation */ }
func (m *Mutex) Unlock()  { /* Unlock implementation */ }

// NewMutex has the same composition as Mutex but its method set is empty.
type NewMutex Mutex

// The method set of the <a href="#Pointer_types">base type</a> of PtrMutex remains unchanged,
// but the method set of PtrMutex is empty.
type PtrMutex *Mutex

// The method set of *PrintableMutex contains the methods
// Lock and Unlock bound to its anonymous field Mutex.
type PrintableMutex struct {
	Mutex
}

// MyBlock is an interface type that has the same method set as Block.
type MyBlock Block
</pre>

<p>
A type declaration may be used to define a different boolean, numeric, or string
type and attach methods to it:
</p>

<pre>
type TimeZone int

const (
	EST TimeZone = -(5 + iota)
	CST
	MST
	PST
)

func (tz TimeZone) String() string {
	return fmt.Sprintf("GMT+%dh", tz)
}
</pre>


<h3 id="Variable_declarations">Variable declarations</h3>

<p>
A variable declaration creates one or more variables, binds corresponding
identifiers to them, and gives each a type and an initial value.
</p>

<pre class="ebnf">
VarDecl     = "var" ( VarSpec | "(" { VarSpec ";" } ")" ) .
VarSpec     = IdentifierList ( Type [ "=" ExpressionList ] | "=" ExpressionList ) .
</pre>

<pre>
var i int
var U, V, W float64
var k = 0
var x, y float32 = -1, -2
var (
	i       int
	u, v, s = 2.0, 3.0, "bar"
)
var re, im = complexSqrt(-1)
var _, found = entries[name]  // map lookup; only interested in "found"
</pre>

<p>
If a list of expressions is given, the variables are initialized
with the expressions following the rules for <a href="#Assignments">assignments</a>.
Otherwise, each variable is initialized to its <a href="#The_zero_value">zero value</a>.
</p>

<p>
If a type is present, each variable is given that type.
Otherwise, each variable is given the type of the corresponding
initialization value in the assignment.
If that value is an untyped constant, it is first
<a href="#Conversions">converted</a> to its <a href="#Constants">default type</a>;
if it is an untyped boolean value, it is first converted to type <code>bool</code>.
The predeclared value <code>nil</code> cannot be used to initialize a variable
with no explicit type.
</p>

<pre>
var d = math.Sin(0.5)  // d is int64
var i = 42             // i is int
var t, ok = x.(T)      // t is T, ok is bool
var n = nil            // illegal
</pre>

<p>
Implementation restriction: A compiler may make it illegal to declare a variable
inside a <a href="#Function_declarations">function body</a> if the variable is
never used.
</p>

<h3 id="Short_variable_declarations">Short variable declarations</h3>

<p>
A <i>short variable declaration</i> uses the syntax:
</p>

<pre class="ebnf">
ShortVarDecl = IdentifierList ":=" ExpressionList .
</pre>

<p>
It is shorthand for a regular <a href="#Variable_declarations">variable declaration</a>
with initializer expressions but no types:
</p>

<pre class="grammar">
"var" IdentifierList = ExpressionList .
</pre>

<pre>
i, j := 0, 10
f := func() int { return 7 }
ch := make(chan int)
r, w := os.Pipe(fd)  // os.Pipe() returns two values
_, y, _ := coord(p)  // coord() returns three values; only interested in y coordinate
</pre>

<p>
Unlike regular variable declarations, a short variable declaration may redeclare variables provided they
were originally declared earlier in the same block with the same type, and at
least one of the non-<a href="#Blank_identifier">blank</a> variables is new.  As a consequence, redeclaration
can only appear in a multi-variable short declaration.
Redeclaration does not introduce a new
variable; it just assigns a new value to the original.
</p>

<pre>
field1, offset := nextField(str, 0)
field2, offset := nextField(str, offset)  // redeclares offset
a, a := 1, 2                              // illegal: double declaration of a or no new variable if a was declared elsewhere
</pre>

<p>
Short variable declarations may appear only inside functions.
In some contexts such as the initializers for
<a href="#If_statements">"if"</a>,
<a href="#For_statements">"for"</a>, or
<a href="#Switch_statements">"switch"</a> statements,
they can be used to declare local temporary variables.
</p>

<h3 id="Function_declarations">Function declarations</h3>

<p>
A function declaration binds an identifier, the <i>function name</i>,
to a function.
</p>

<pre class="ebnf">
FunctionDecl = "func" FunctionName ( Function | Signature ) .
FunctionName = identifier .
Function     = Signature FunctionBody .
FunctionBody = Block .
</pre>

<p>
If the function's <a href="#Function_types">signature</a> declares
result parameters, the function body's statement list must end in
a <a href="#Terminating_statements">terminating statement</a>.
</p>

<pre>
func findMarker(c &lt;-chan int) int {
	for i := range c {
		if x := &lt;-c; isMarker(x) {
			return x
		}
	}
	// invalid: missing return statement.
}
</pre>

<p>
A function declaration may omit the body. Such a declaration provides the
signature for a function implemented outside Go, such as an assembly routine.
</p>

<pre>
func min(x int, y int) int {
	if x &lt; y {
		return x
	}
	return y
}

func flushICache(begin, end uintptr)  // implemented externally
</pre>

<h3 id="Method_declarations">Method declarations</h3>

<p>
A method is a <a href="#Function_declarations">function</a> with a <i>receiver</i>.
A method declaration binds an identifier, the <i>method name</i>, to a method,
and associates the method with the receiver's <i>base type</i>.
</p>

<pre class="ebnf">
MethodDecl   = "func" Receiver MethodName ( Function | Signature ) .
Receiver     = Parameters .
</pre>

<p>
The receiver is specified via an extra parameter section preceeding the method
name. That parameter section must declare a single parameter, the receiver.
Its type must be of the form <code>T</code> or <code>*T</code> (possibly using
parentheses) where <code>T</code> is a type name. The type denoted by <code>T</code> is called
the receiver <i>base type</i>; it must not be a pointer or interface type and
it must be declared in the same package as the method.
The method is said to be <i>bound</i> to the base type and the method name
is visible only within selectors for that type.
</p>

<p>
A non-<a href="#Blank_identifier">blank</a> receiver identifier must be
<a href="#Uniqueness_of_identifiers">unique</a> in the method signature.
If the receiver's value is not referenced inside the body of the method,
its identifier may be omitted in the declaration. The same applies in
general to parameters of functions and methods.
</p>

<p>
For a base type, the non-blank names of methods bound to it must be unique.
If the base type is a <a href="#Struct_types">struct type</a>,
the non-blank method and field names must be distinct.
</p>

<p>
Given type <code>Point</code>, the declarations
</p>

<pre>
func (p *Point) Length() float64 {
	return math.Sqrt(p.x * p.x + p.y * p.y)
}

func (p *Point) Scale(factor float64) {
	p.x *= factor
	p.y *= factor
}
</pre>

<p>
bind the methods <code>Length</code> and <code>Scale</code>,
with receiver type <code>*Point</code>,
to the base type <code>Point</code>.
</p>

<p>
The type of a method is the type of a function with the receiver as first
argument.  For instance, the method <code>Scale</code> has type
</p>

<pre>
func(p *Point, factor float64)
</pre>

<p>
However, a function declared this way is not a method.
</p>


<h2 id="Expressions">Expressions</h2>

<p>
An expression specifies the computation of a value by applying
operators and functions to operands.
</p>

<h3 id="Operands">Operands</h3>

<p>
Operands denote the elementary values in an expression. An operand may be a
literal, a (possibly <a href="#Qualified_identifiers">qualified</a>)
non-<a href="#Blank_identifier">blank</a> identifier denoting a
<a href="#Constant_declarations">constant</a>,
<a href="#Variable_declarations">variable</a>, or
<a href="#Function_declarations">function</a>,
a <a href="#Method_expressions">method expression</a> yielding a function,
or a parenthesized expression.
</p>

<p>
The <a href="#Blank_identifier">blank identifier</a> may appear as an
operand only on the left-hand side of an <a href="#Assignments">assignment</a>.
</p>

<pre class="ebnf">
Operand     = Literal | OperandName | MethodExpr | "(" Expression ")" .
Literal     = BasicLit | CompositeLit | FunctionLit .
BasicLit    = int_lit | float_lit | imaginary_lit | rune_lit | string_lit .
OperandName = identifier | QualifiedIdent.
</pre>

<h3 id="Qualified_identifiers">Qualified identifiers</h3>

<p>
A qualified identifier is an identifier qualified with a package name prefix.
Both the package name and the identifier must not be
<a href="#Blank_identifier">blank</a>.
</p>

<pre class="ebnf">
QualifiedIdent = PackageName "." identifier .
</pre>

<p>
A qualified identifier accesses an identifier in a different package, which
must be <a href="#Import_declarations">imported</a>.
The identifier must be <a href="#Exported_identifiers">exported</a> and
declared in the <a href="#Blocks">package block</a> of that package.
</p>

<pre>
math.Sin	// denotes the Sin function in package math
</pre>

<h3 id="Composite_literals">Composite literals</h3>

<p>
Composite literals construct values for structs, arrays, slices, and maps
and create a new value each time they are evaluated.
They consist of the type of the value
followed by a brace-bound list of composite elements. An element may be
a single expression or a key-value pair.
</p>

<pre class="ebnf">
CompositeLit  = LiteralType LiteralValue .
LiteralType   = StructType | ArrayType | "[" "..." "]" ElementType |
                SliceType | MapType | TypeName .
LiteralValue  = "{" [ ElementList [ "," ] ] "}" .
ElementList   = Element { "," Element } .
Element       = [ Key ":" ] Value .
Key           = FieldName | ElementIndex .
FieldName     = identifier .
ElementIndex  = Expression .
Value         = Expression | LiteralValue .
</pre>

<p>
The LiteralType must be a struct, array, slice, or map type
(the grammar enforces this constraint except when the type is given
as a TypeName).
The types of the expressions must be <a href="#Assignability">assignable</a>
to the respective field, element, and key types of the LiteralType;
there is no additional conversion.
The key is interpreted as a field name for struct literals,
an index for array and slice literals, and a key for map literals.
For map literals, all elements must have a key. It is an error
to specify multiple elements with the same field name or
constant key value.
</p>

<p>
For struct literals the following rules apply:
</p>
<ul>
	<li>A key must be a field name declared in the LiteralType.
	</li>
	<li>An element list that does not contain any keys must
	    list an element for each struct field in the
	    order in which the fields are declared.
	</li>
	<li>If any element has a key, every element must have a key.
	</li>
	<li>An element list that contains keys does not need to
	    have an element for each struct field. Omitted fields
	    get the zero value for that field.
	</li>
	<li>A literal may omit the element list; such a literal evaluates
	    to the zero value for its type.
	</li>
	<li>It is an error to specify an element for a non-exported
	    field of a struct belonging to a different package.
	</li>
</ul>

<p>
Given the declarations
</p>
<pre>
type Point3D struct { x, y, z float64 }
type Line struct { p, q Point3D }
</pre>

<p>
one may write
</p>

<pre>
origin := Point3D{}                            // zero value for Point3D
line := Line{origin, Point3D{y: -4, z: 12.3}}  // zero value for line.q.x
</pre>

<p>
For array and slice literals the following rules apply:
</p>
<ul>
	<li>Each element has an associated integer index marking
	    its position in the array.
	</li>
	<li>An element with a key uses the key as its index; the
	    key must be a constant integer expression.
	</li>
	<li>An element without a key uses the previous element's index plus one.
	    If the first element has no key, its index is zero.
	</li>
</ul>

<p>
<a href="#Address_operators">Taking the address</a> of a composite literal
generates a pointer to a unique <a href="#Variables">variable</a> initialized
with the literal's value.
</p>
<pre>
var pointer *Point3D = &amp;Point3D{y: 1000}
</pre>

<p>
The length of an array literal is the length specified in the LiteralType.
If fewer elements than the length are provided in the literal, the missing
elements are set to the zero value for the array element type.
It is an error to provide elements with index values outside the index range
of the array. The notation <code>...</code> specifies an array length equal
to the maximum element index plus one.
</p>

<pre>
buffer := [10]string{}             // len(buffer) == 10
intSet := [6]int{1, 2, 3, 5}       // len(intSet) == 6
days := [...]string{"Sat", "Sun"}  // len(days) == 2
</pre>

<p>
A slice literal describes the entire underlying array literal.
Thus, the length and capacity of a slice literal are the maximum
element index plus one. A slice literal has the form
</p>

<pre>
[]T{x1, x2, ‚Ä¶ xn}
</pre>

<p>
and is shorthand for a slice operation applied to an array:
</p>

<pre>
tmp := [n]T{x1, x2, ‚Ä¶ xn}
tmp[0 : n]
</pre>

<p>
Within a composite literal of array, slice, or map type <code>T</code>,
elements that are themselves composite literals may elide the respective
literal type if it is identical to the element type of <code>T</code>.
Similarly, elements that are addresses of composite literals may elide
the <code>&amp;T</code> when the element type is <code>*T</code>.
</p>

<pre>
[...]Point{{1.5, -3.5}, {0, 0}}   // same as [...]Point{Point{1.5, -3.5}, Point{0, 0}}
[][]int{{1, 2, 3}, {4, 5}}        // same as [][]int{[]int{1, 2, 3}, []int{4, 5}}

[...]*Point{{1.5, -3.5}, {0, 0}}  // same as [...]*Point{&amp;Point{1.5, -3.5}, &amp;Point{0, 0}}
</pre>

<p>
A parsing ambiguity arises when a composite literal using the
TypeName form of the LiteralType appears as an operand between the
<a href="#Keywords">keyword</a> and the opening brace of the block
of an "if", "for", or "switch" statement, and the composite literal
is not enclosed in parentheses, square brackets, or curly braces.
In this rare case, the opening brace of the literal is erroneously parsed
as the one introducing the block of statements. To resolve the ambiguity,
the composite literal must appear within parentheses.
</p>

<pre>
if x == (T{a,b,c}[i]) { ‚Ä¶ }
if (x == T{a,b,c}[i]) { ‚Ä¶ }
</pre>

<p>
Examples of valid array, slice, and map literals:
</p>

<pre>
// list of prime numbers
primes := []int{2, 3, 5, 7, 9, 2147483647}

// vowels[ch] is true if ch is a vowel
vowels := [128]bool{'a': true, 'e': true, 'i': true, 'o': true, 'u': true, 'y': true}

// the array [10]float32{-1, 0, 0, 0, -0.1, -0.1, 0, 0, 0, -1}
filter := [10]float32{-1, 4: -0.1, -0.1, 9: -1}

// frequencies in Hz for equal-tempered scale (A4 = 440Hz)
noteFrequency := map[string]float32{
	"C0": 16.35, "D0": 18.35, "E0": 20.60, "F0": 21.83,
	"G0": 24.50, "A0": 27.50, "B0": 30.87,
}
</pre>


<h3 id="Function_literals">Function literals</h3>

<p>
A function literal represents an anonymous <a href="#Function_declarations">function</a>.
</p>

<pre class="ebnf">
FunctionLit = "func" Function .
</pre>

<pre>
func(a, b int, z float64) bool { return a*b &lt; int(z) }
</pre>

<p>
A function literal can be assigned to a variable or invoked directly.
</p>

<pre>
f := func(x, y int) int { return x + y }
func(ch chan int) { ch &lt;- ACK }(replyChan)
</pre>

<p>
Function literals are <i>closures</i>: they may refer to variables
defined in a surrounding function. Those variables are then shared between
the surrounding function and the function literal, and they survive as long
as they are accessible.
</p>


<h3 id="Primary_expressions">Primary expressions</h3>

<p>
Primary expressions are the operands for unary and binary expressions.
</p>

<pre class="ebnf">
PrimaryExpr =
	Operand |
	Conversion |
	PrimaryExpr Selector |
	PrimaryExpr Index |
	PrimaryExpr Slice |
	PrimaryExpr TypeAssertion |
	PrimaryExpr Arguments .

Selector       = "." identifier .
Index          = "[" Expression "]" .
Slice          = "[" ( [ Expression ] ":" [ Expression ] ) |
                     ( [ Expression ] ":" Expression ":" Expression )
                 "]" .
TypeAssertion  = "." "(" Type ")" .
Arguments      = "(" [ ( ExpressionList | Type [ "," ExpressionList ] ) [ "..." ] [ "," ] ] ")" .
</pre>


<pre>
x
2
(s + ".txt")
f(3.1415, true)
Point{1, 2}
m["foo"]
s[i : j + 1]
obj.color
f.p[i].x()
</pre>


<h3 id="Selectors">Selectors</h3>

<p>
For a <a href="#Primary_expressions">primary expression</a> <code>x</code>
that is not a <a href="#Package_clause">package name</a>, the
<i>selector expression</i>
</p>

<pre>
x.f
</pre>

<p>
denotes the field or method <code>f</code> of the value <code>x</code>
(or sometimes <code>*x</code>; see below).
The identifier <code>f</code> is called the (field or method) <i>selector</i>;
it must not be the <a href="#Blank_identifier">blank identifier</a>.
The type of the selector expression is the type of <code>f</code>.
If <code>x</code> is a package name, see the section on
<a href="#Qualified_identifiers">qualified identifiers</a>.
</p>

<p>
A selector <code>f</code> may denote a field or method <code>f</code> of
a type <code>T</code>, or it may refer
to a field or method <code>f</code> of a nested
<a href="#Struct_types">anonymous field</a> of <code>T</code>.
The number of anonymous fields traversed
to reach <code>f</code> is called its <i>depth</i> in <code>T</code>.
The depth of a field or method <code>f</code>
declared in <code>T</code> is zero.
The depth of a field or method <code>f</code> declared in
an anonymous field <code>A</code> in <code>T</code> is the
depth of <code>f</code> in <code>A</code> plus one.
</p>

<p>
The following rules apply to selectors:
</p>

<ol>
<li>
For a value <code>x</code> of type <code>T</code> or <code>*T</code>
where <code>T</code> is not a pointer or interface type,
<code>x.f</code> denotes the field or method at the shallowest depth
in <code>T</code> where there
is such an <code>f</code>.
If there is not exactly <a href="#Uniqueness_of_identifiers">one <code>f</code></a>
with shallowest depth, the selector expression is illegal.
</li>

<li>
For a value <code>x</code> of type <code>I</code> where <code>I</code>
is an interface type, <code>x.f</code> denotes the actual method with name
<code>f</code> of the dynamic value of <code>x</code>.
If there is no method with name <code>f</code> in the
<a href="#Method_sets">method set</a> of <code>I</code>, the selector
expression is illegal.
</li>

<li>
As an exception, if the type of <code>x</code> is a named pointer type
and <code>(*x).f</code> is a valid selector expression denoting a field
(but not a method), <code>x.f</code> is shorthand for <code>(*x).f</code>.
</li>

<li>
In all other cases, <code>x.f</code> is illegal.
</li>

<li>
If <code>x</code> is of pointer type and has the value
<code>nil</code> and <code>x.f</code> denotes a struct field,
assigning to or evaluating <code>x.f</code>
causes a <a href="#Run_time_panics">run-time panic</a>.
</li>

<li>
If <code>x</code> is of interface type and has the value
<code>nil</code>, <a href="#Calls">calling</a> or
<a href="#Method_values">evaluating</a> the method <code>x.f</code>
causes a <a href="#Run_time_panics">run-time panic</a>.
</li>
</ol>

<p>
For example, given the declarations:
</p>

<pre>
type T0 struct {
	x int
}

func (*T0) M0()

type T1 struct {
	y int
}

func (T1) M1()

type T2 struct {
	z int
	T1
	*T0
}

func (*T2) M2()

type Q *T2

var t T2     // with t.T0 != nil
var p *T2    // with p != nil and (*p).T0 != nil
var q Q = p
</pre>

<p>
one may write:
</p>

<pre>
t.z          // t.z
t.y          // t.T1.y
t.x          // (*t.TO).x

p.z          // (*p).z
p.y          // (*p).T1.y
p.x          // (*(*p).T0).x

q.x          // (*(*q).T0).x        (*q).x is a valid field selector

p.M2()       // p.M2()              M2 expects *T2 receiver
p.M1()       // ((*p).T1).M1()      M1 expects T1 receiver
p.M0()       // ((&(*p).T0)).M0()   M0 expects *T0 receiver, see section on Calls
</pre>

<p>
but the following is invalid:
</p>

<pre>
q.M0()       // (*q).M0 is valid but not a field selector
</pre>


<h3 id="Method_expressions">Method expressions</h3>

<p>
If <code>M</code> is in the <a href="#Method_sets">method set</a> of type <code>T</code>,
<code>T.M</code> is a function that is callable as a regular function
with the same arguments as <code>M</code> prefixed by an additional
argument that is the receiver of the method.
</p>

<pre class="ebnf">
MethodExpr    = ReceiverType "." MethodName .
ReceiverType  = TypeName | "(" "*" TypeName ")" | "(" ReceiverType ")" .
</pre>

<p>
Consider a struct type <code>T</code> with two methods,
<code>Mv</code>, whose receiver is of type <code>T</code>, and
<code>Mp</code>, whose receiver is of type <code>*T</code>.
</p>

<pre>
type T struct {
	a int
}
func (tv  T) Mv(a int) int         { return 0 }  // value receiver
func (tp *T) Mp(f float32) float32 { return 1 }  // pointer receiver

var t T
</pre>

<p>
The expression
</p>

<pre>
T.Mv
</pre>

<p>
yields a function equivalent to <code>Mv</code> but
with an explicit receiver as its first argument; it has signature
</p>

<pre>
func(tv T, a int) int
</pre>

<p>
That function may be called normally with an explicit receiver, so
these five invocations are equivalent:
</p>

<pre>
t.Mv(7)
T.Mv(t, 7)
(T).Mv(t, 7)
f1 := T.Mv; f1(t, 7)
f2 := (T).Mv; f2(t, 7)
</pre>

<p>
Similarly, the expression
</p>

<pre>
(*T).Mp
</pre>

<p>
yields a function value representing <code>Mp</code> with signature
</p>

<pre>
func(tp *T, f float32) float32
</pre>

<p>
For a method with a value receiver, one can derive a function
with an explicit pointer receiver, so
</p>

<pre>
(*T).Mv
</pre>

<p>
yields a function value representing <code>Mv</code> with signature
</p>

<pre>
func(tv *T, a int) int
</pre>

<p>
Such a function indirects through the receiver to create a value
to pass as the receiver to the underlying method;
the method does not overwrite the value whose address is passed in
the function call.
</p>

<p>
The final case, a value-receiver function for a pointer-receiver method,
is illegal because pointer-receiver methods are not in the method set
of the value type.
</p>

<p>
Function values derived from methods are called with function call syntax;
the receiver is provided as the first argument to the call.
That is, given <code>f := T.Mv</code>, <code>f</code> is invoked
as <code>f(t, 7)</code> not <code>t.f(7)</code>.
To construct a function that binds the receiver, use a
<a href="#Function_literals">function literal</a> or
<a href="#Method_values">method value</a>.
</p>

<p>
It is legal to derive a function value from a method of an interface type.
The resulting function takes an explicit receiver of that interface type.
</p>

<h3 id="Method_values">Method values</h3>

<p>
If the expression <code>x</code> has static type <code>T</code> and
<code>M</code> is in the <a href="#Method_sets">method set</a> of type <code>T</code>,
<code>x.M</code> is called a <i>method value</i>.
The method value <code>x.M</code> is a function value that is callable
with the same arguments as a method call of <code>x.M</code>.
The expression <code>x</code> is evaluated and saved during the evaluation of the
method value; the saved copy is then used as the receiver in any calls,
which may be executed later.
</p>

<p>
The type <code>T</code> may be an interface or non-interface type.
</p>

<p>
As in the discussion of <a href="#Method_expressions">method expressions</a> above,
consider a struct type <code>T</code> with two methods,
<code>Mv</code>, whose receiver is of type <code>T</code>, and
<code>Mp</code>, whose receiver is of type <code>*T</code>.
</p>

<pre>
type T struct {
	a int
}
func (tv  T) Mv(a int) int         { return 0 }  // value receiver
func (tp *T) Mp(f float32) float32 { return 1 }  // pointer receiver

var t T
var pt *T
func makeT() T
</pre>

<p>
The expression
</p>

<pre>
t.Mv
</pre>

<p>
yields a function value of type
</p>

<pre>
func(int) int
</pre>

<p>
These two invocations are equivalent:
</p>

<pre>
t.Mv(7)
f := t.Mv; f(7)
</pre>

<p>
Similarly, the expression
</p>

<pre>
pt.Mp
</pre>

<p>
yields a function value of type
</p>

<pre>
func(float32) float32
</pre>

<p>
As with <a href="#Selectors">selectors</a>, a reference to a non-interface method with a value receiver
using a pointer will automatically dereference that pointer: <code>pt.Mv</code> is equivalent to <code>(*pt).Mv</code>.
</p>

<p>
As with <a href="#Calls">method calls</a>, a reference to a non-interface method with a pointer receiver
using an addressable value will automatically take the address of that value: <code>t.Mp</code> is equivalent to <code>(&amp;t).Mp</code>.
</p>

<pre>
f := t.Mv; f(7)   // like t.Mv(7)
f := pt.Mp; f(7)  // like pt.Mp(7)
f := pt.Mv; f(7)  // like (*pt).Mv(7)
f := t.Mp; f(7)   // like (&amp;t).Mp(7)
f := makeT().Mp   // invalid: result of makeT() is not addressable
</pre>

<p>
Although the examples above use non-interface types, it is also legal to create a method value
from a value of interface type.
</p>

<pre>
var i interface { M(int) } = myVal
f := i.M; f(7)  // like i.M(7)
</pre>


<h3 id="Index_expressions">Index expressions</h3>

<p>
A primary expression of the form
</p>

<pre>
a[x]
</pre>

<p>
denotes the element of the array, pointer to array, slice, string or map <code>a</code> indexed by <code>x</code>.
The value <code>x</code> is called the <i>index</i> or <i>map key</i>, respectively.
The following rules apply:
</p>

<p>
If <code>a</code> is not a map:
</p>
<ul>
	<li>the index <code>x</code> must be of integer type or untyped;
	    it is <i>in range</i> if <code>0 &lt;= x &lt; len(a)</code>,
	    otherwise it is <i>out of range</i></li>
	<li>a <a href="#Constants">constant</a> index must be non-negative
	    and representable by a value of type <code>int</code>
</ul>

<p>
For <code>a</code> of <a href="#Array_types">array type</a> <code>A</code>:
</p>
<ul>
	<li>a <a href="#Constants">constant</a> index must be in range</li>
	<li>if <code>x</code> is out of range at run time,
	    a <a href="#Run_time_panics">run-time panic</a> occurs</li>
	<li><code>a[x]</code> is the array element at index <code>x</code> and the type of
	    <code>a[x]</code> is the element type of <code>A</code></li>
</ul>

<p>
For <code>a</code> of <a href="#Pointer_types">pointer</a> to array type:
</p>
<ul>
	<li><code>a[x]</code> is shorthand for <code>(*a)[x]</code></li>
</ul>

<p>
For <code>a</code> of <a href="#Slice_types">slice type</a> <code>S</code>:
</p>
<ul>
	<li>if <code>x</code> is out of range at run time,
	    a <a href="#Run_time_panics">run-time panic</a> occurs</li>
	<li><code>a[x]</code> is the slice element at index <code>x</code> and the type of
	    <code>a[x]</code> is the element type of <code>S</code></li>
</ul>

<p>
For <code>a</code> of <a href="#String_types">string type</a>:
</p>
<ul>
	<li>a <a href="#Constants">constant</a> index must be in range
	    if the string <code>a</code> is also constant</li>
	<li>if <code>x</code> is out of range at run time,
	    a <a href="#Run_time_panics">run-time panic</a> occurs</li>
	<li><code>a[x]</code> is the non-constant byte value at index <code>x</code> and the type of
	    <code>a[x]</code> is <code>byte</code></li>
	<li><code>a[x]</code> may not be assigned to</li>
</ul>

<p>
For <code>a</code> of <a href="#Map_types">map type</a> <code>M</code>:
</p>
<ul>
	<li><code>x</code>'s type must be
	    <a href="#Assignability">assignable</a>
	    to the key type of <code>M</code></li>
	<li>if the map contains an entry with key <code>x</code>,
	    <code>a[x]</code> is the map value with key <code>x</code>
	    and the type of <code>a[x]</code> is the value type of <code>M</code></li>
	<li>if the map is <code>nil</code> or does not contain such an entry,
	    <code>a[x]</code> is the <a href="#The_zero_value">zero value</a>
	    for the value type of <code>M</code></li>
</ul>

<p>
Otherwise <code>a[x]</code> is illegal.
</p>

<p>
An index expression on a map <code>a</code> of type <code>map[K]V</code>
used in an <a href="#Assignments">assignment</a> or initialization of the special form
</p>

<pre>
v, ok = a[x]
v, ok := a[x]
var v, ok = a[x]
</pre>

<p>
yields an additional untyped boolean value. The value of <code>ok</code> is
<code>true</code> if the key <code>x</code> is present in the map, and
<code>false</code> otherwise.
</p>

<p>
Assigning to an element of a <code>nil</code> map causes a
<a href="#Run_time_panics">run-time panic</a>.
</p>


<h3 id="Slice_expressions">Slice expressions</h3>

<p>
Slice expressions construct a substring or slice from a string, array, pointer
to array, or slice. There are two variants: a simple form that specifies a low
and high bound, and a full form that also specifies a bound on the capacity.
</p>

<h4>Simple slice expressions</h4>

<p>
For a string, array, pointer to array, or slice <code>a</code>, the primary expression
</p>

<pre>
a[low : high]
</pre>

<p>
constructs a substring or slice. The <i>indices</i> <code>low</code> and
<code>high</code> select which elements of operand <code>a</code> appear
in the result. The result has indices starting at 0 and length equal to
<code>high</code>&nbsp;-&nbsp;<code>low</code>.
After slicing the array <code>a</code>
</p>

<pre>
a := [5]int{1, 2, 3, 4, 5}
s := a[1:4]
</pre>

<p>
the slice <code>s</code> has type <code>[]int</code>, length 3, capacity 4, and elements
</p>

<pre>
s[0] == 2
s[1] == 3
s[2] == 4
</pre>

<p>
For convenience, any of the indices may be omitted. A missing <code>low</code>
index defaults to zero; a missing <code>high</code> index defaults to the length of the
sliced operand:
</p>

<pre>
a[2:]  // same as a[2 : len(a)]
a[:3]  // same as a[0 : 3]
a[:]   // same as a[0 : len(a)]
</pre>

<p>
If <code>a</code> is a pointer to an array, <code>a[low : high]</code> is shorthand for
<code>(*a)[low : high]</code>.
</p>

<p>
For arrays or strings, the indices are <i>in range</i> if
<code>0</code> &lt;= <code>low</code> &lt;= <code>high</code> &lt;= <code>len(a)</code>,
otherwise they are <i>out of range</i>.
For slices, the upper index bound is the slice capacity <code>cap(a)</code> rather than the length.
A <a href="#Constants">constant</a> index must be non-negative and representable by a value of type
<code>int</code>; for arrays or constant strings, constant indices must also be in range.
If both indices are constant, they must satisfy <code>low &lt;= high</code>.
If the indices are out of range at run time, a <a href="#Run_time_panics">run-time panic</a> occurs.
</p>

<p>
Except for <a href="#Constants">untyped strings</a>, if the sliced operand is a string or slice,
the result of the slice operation is a non-constant value of the same type as the operand.
For untyped string operands the result is a non-constant value of type <code>string</code>.
If the sliced operand is an array, it must be <a href="#Address_operators">addressable</a>
and the result of the slice operation is a slice with the same element type as the array.
</p>

<p>
If the sliced operand of a valid slice expression is a <code>nil</code> slice, the result
is a <code>nil</code> slice. Otherwise, the result shares its underlying array with the
operand.
</p>

<h4>Full slice expressions</h4>

<p>
For an array, pointer to array, or slice <code>a</code> (but not a string), the primary expression
</p>

<pre>
a[low : high : max]
</pre>

<p>
constructs a slice of the same type, and with the same length and elements as the simple slice
expression <code>a[low : high]</code>. Additionally, it controls the resulting slice's capacity
by setting it to <code>max - low</code>. Only the first index may be omitted; it defaults to 0.
After slicing the array <code>a</code>
</p>

<pre>
a := [5]int{1, 2, 3, 4, 5}
t := a[1:3:5]
</pre>

<p>
the slice <code>t</code> has type <code>[]int</code>, length 2, capacity 4, and elements
</p>

<pre>
t[0] == 2
t[1] == 3
</pre>

<p>
As for simple slice expressions, if <code>a</code> is a pointer to an array,
<code>a[low : high : max]</code> is shorthand for <code>(*a)[low : high : max]</code>.
If the sliced operand is an array, it must be <a href="#Address_operators">addressable</a>.
</p>

<p>
The indices are <i>in range</i> if <code>0 &lt;= low &lt;= high &lt;= max &lt;= cap(a)</code>,
otherwise they are <i>out of range</i>.
A <a href="#Constants">constant</a> index must be non-negative and representable by a value of type
<code>int</code>; for arrays, constant indices must also be in range.
If multiple indices are constant, the constants that are present must be in range relative to each
other.
If the indices are out of range at run time, a <a href="#Run_time_panics">run-time panic</a> occurs.
</p>

<h3 id="Type_assertions">Type assertions</h3>

<p>
For an expression <code>x</code> of <a href="#Interface_types">interface type</a>
and a type <code>T</code>, the primary expression
</p>

<pre>
x.(T)
</pre>

<p>
asserts that <code>x</code> is not <code>nil</code>
and that the value stored in <code>x</code> is of type <code>T</code>.
The notation <code>x.(T)</code> is called a <i>type assertion</i>.
</p>
<p>
More precisely, if <code>T</code> is not an interface type, <code>x.(T)</code> asserts
that the dynamic type of <code>x</code> is <a href="#Type_identity">identical</a>
to the type <code>T</code>.
In this case, <code>T</code> must <a href="#Method_sets">implement</a> the (interface) type of <code>x</code>;
otherwise the type assertion is invalid since it is not possible for <code>x</code>
to store a value of type <code>T</code>.
If <code>T</code> is an interface type, <code>x.(T)</code> asserts that the dynamic type
of <code>x</code> implements the interface <code>T</code>.
</p>
<p>
If the type assertion holds, the value of the expression is the value
stored in <code>x</code> and its type is <code>T</code>. If the type assertion is false,
a <a href="#Run_time_panics">run-time panic</a> occurs.
In other words, even though the dynamic type of <code>x</code>
is known only at run time, the type of <code>x.(T)</code> is
known to be <code>T</code> in a correct program.
</p>

<pre>
var x interface{} = 7  // x has dynamic type int and value 7
i := x.(int)           // i has type int and value 7

type I interface { m() }
var y I
s := y.(string)        // illegal: string does not implement I (missing method m)
r := y.(io.Reader)     // r has type io.Reader and y must implement both I and io.Reader
</pre>

<p>
A type assertion used in an <a href="#Assignments">assignment</a> or initialization of the special form
</p>

<pre>
v, ok = x.(T)
v, ok := x.(T)
var v, ok = x.(T)
</pre>

<p>
yields an additional untyped boolean value. The value of <code>ok</code> is <code>true</code>
if the assertion holds. Otherwise it is <code>false</code> and the value of <code>v</code> is
the <a href="#The_zero_value">zero value</a> for type <code>T</code>.
No run-time panic occurs in this case.
</p>


<h3 id="Calls">Calls</h3>

<p>
Given an expression <code>f</code> of function type
<code>F</code>,
</p>

<pre>
f(a1, a2, ‚Ä¶ an)
</pre>

<p>
calls <code>f</code> with arguments <code>a1, a2, ‚Ä¶ an</code>.
Except for one special case, arguments must be single-valued expressions
<a href="#Assignability">assignable</a> to the parameter types of
<code>F</code> and are evaluated before the function is called.
The type of the expression is the result type
of <code>F</code>.
A method invocation is similar but the method itself
is specified as a selector upon a value of the receiver type for
the method.
</p>

<pre>
math.Atan2(x, y)  // function call
var pt *Point
pt.Scale(3.5)     // method call with receiver pt
</pre>

<p>
In a function call, the function value and arguments are evaluated in
<a href="#Order_of_evaluation">the usual order</a>.
After they are evaluated, the parameters of the call are passed by value to the function
and the called function begins execution.
The return parameters of the function are passed by value
back to the calling function when the function returns.
</p>

<p>
Calling a <code>nil</code> function value
causes a <a href="#Run_time_panics">run-time panic</a>.
</p>

<p>
As a special case, if the return values of a function or method
<code>g</code> are equal in number and individually
assignable to the parameters of another function or method
<code>f</code>, then the call <code>f(g(<i>parameters_of_g</i>))</code>
will invoke <code>f</code> after binding the return values of
<code>g</code> to the parameters of <code>f</code> in order.  The call
of <code>f</code> must contain no parameters other than the call of <code>g</code>,
and <code>g</code> must have at least one return value.
If <code>f</code> has a final <code>...</code> parameter, it is
assigned the return values of <code>g</code> that remain after
assignment of regular parameters.
</p>

<pre>
func Split(s string, pos int) (string, string) {
	return s[0:pos], s[pos:]
}

func Join(s, t string) string {
	return s + t
}

if Join(Split(value, len(value)/2)) != value {
	log.Panic("test fails")
}
</pre>

<p>
A method call <code>x.m()</code> is valid if the <a href="#Method_sets">method set</a>
of (the type of) <code>x</code> contains <code>m</code> and the
argument list can be assigned to the parameter list of <code>m</code>.
If <code>x</code> is <a href="#Address_operators">addressable</a> and <code>&amp;x</code>'s method
set contains <code>m</code>, <code>x.m()</code> is shorthand
for <code>(&amp;x).m()</code>:
</p>

<pre>
var p Point
p.Scale(3.5)
</pre>

<p>
There is no distinct method type and there are no method literals.
</p>

<h3 id="Passing_arguments_to_..._parameters">Passing arguments to <code>...</code> parameters</h3>

<p>
If <code>f</code> is <a href="#Function_types">variadic</a> with a final
parameter <code>p</code> of type <code>...T</code>, then within <code>f</code>
the type of <code>p</code> is equivalent to type <code>[]T</code>.
If <code>f</code> is invoked with no actual arguments for <code>p</code>,
the value passed to <code>p</code> is <code>nil</code>.
Otherwise, the value passed is a new slice
of type <code>[]T</code> with a new underlying array whose successive elements
are the actual arguments, which all must be <a href="#Assignability">assignable</a>
to <code>T</code>. The length and capacity of the slice is therefore
the number of arguments bound to <code>p</code> and may differ for each
call site.
</p>

<p>
Given the function and calls
</p>
<pre>
func Greeting(prefix string, who ...string)
Greeting("nobody")
Greeting("hello:", "Joe", "Anna", "Eileen")
</pre>

<p>
within <code>Greeting</code>, <code>who</code> will have the value
<code>nil</code> in the first call, and
<code>[]string{"Joe", "Anna", "Eileen"}</code> in the second.
</p>

<p>
If the final argument is assignable to a slice type <code>[]T</code>, it may be
passed unchanged as the value for a <code>...T</code> parameter if the argument
is followed by <code>...</code>. In this case no new slice is created.
</p>

<p>
Given the slice <code>s</code> and call
</p>

<pre>
s := []string{"James", "Jasmine"}
Greeting("goodbye:", s...)
</pre>

<p>
within <code>Greeting</code>, <code>who</code> will have the same value as <code>s</code>
with the same underlying array.
</p>


<h3 id="Operators">Operators</h3>

<p>
Operators combine operands into expressions.
</p>

<pre class="ebnf">
Expression = UnaryExpr | Expression binary_op UnaryExpr .
UnaryExpr  = PrimaryExpr | unary_op UnaryExpr .

binary_op  = "||" | "&amp;&amp;" | rel_op | add_op | mul_op .
rel_op     = "==" | "!=" | "&lt;" | "&lt;=" | ">" | ">=" .
add_op     = "+" | "-" | "|" | "^" .
mul_op     = "*" | "/" | "%" | "&lt;&lt;" | "&gt;&gt;" | "&amp;" | "&amp;^" .

unary_op   = "+" | "-" | "!" | "^" | "*" | "&amp;" | "&lt;-" .
</pre>

<p>
Comparisons are discussed <a href="#Comparison_operators">elsewhere</a>.
For other binary operators, the operand types must be <a href="#Type_identity">identical</a>
unless the operation involves shifts or untyped <a href="#Constants">constants</a>.
For operations involving constants only, see the section on
<a href="#Constant_expressions">constant expressions</a>.
</p>

<p>
Except for shift operations, if one operand is an untyped <a href="#Constants">constant</a>
and the other operand is not, the constant is <a href="#Conversions">converted</a>
to the type of the other operand.
</p>

<p>
The right operand in a shift expression must have unsigned integer type
or be an untyped constant that can be converted to unsigned integer type.
If the left operand of a non-constant shift expression is an untyped constant,
the type of the constant is what it would be if the shift expression were
replaced by its left operand alone.
</p>

<pre>
var s uint = 33
var i = 1&lt;&lt;s           // 1 has type int
var j int32 = 1&lt;&lt;s     // 1 has type int32; j == 0
var k = uint64(1&lt;&lt;s)   // 1 has type uint64; k == 1&lt;&lt;33
var m int = 1.0&lt;&lt;s     // 1.0 has type int
var n = 1.0&lt;&lt;s != i    // 1.0 has type int; n == false if ints are 32bits in size
var o = 1&lt;&lt;s == 2&lt;&lt;s   // 1 and 2 have type int; o == true if ints are 32bits in size
var p = 1&lt;&lt;s == 1&lt;&lt;33  // illegal if ints are 32bits in size: 1 has type int, but 1&lt;&lt;33 overflows int
var u = 1.0&lt;&lt;s         // illegal: 1.0 has type float64, cannot shift
var u1 = 1.0&lt;&lt;s != 0   // illegal: 1.0 has type float64, cannot shift
var u2 = 1&lt;&lt;s != 1.0   // illegal: 1 has type float64, cannot shift
var v float32 = 1&lt;&lt;s   // illegal: 1 has type float32, cannot shift
var w int64 = 1.0&lt;&lt;33  // 1.0&lt;&lt;33 is a constant shift expression
</pre>

<h3 id="Operator_precedence">Operator precedence</h3>
<p>
Unary operators have the highest precedence.
As the  <code>++</code> and <code>--</code> operators form
statements, not expressions, they fall
outside the operator hierarchy.
As a consequence, statement <code>*p++</code> is the same as <code>(*p)++</code>.
<p>
There are five precedence levels for binary operators.
Multiplication operators bind strongest, followed by addition
operators, comparison operators, <code>&amp;&amp;</code> (logical AND),
and finally <code>||</code> (logical OR):
</p>

<pre class="grammar">
Precedence    Operator
    5             *  /  %  &lt;&lt;  &gt;&gt;  &amp;  &amp;^
    4             +  -  |  ^
    3             ==  !=  &lt;  &lt;=  &gt;  &gt;=
    2             &amp;&amp;
    1             ||
</pre>

<p>
Binary operators of the same precedence associate from left to right.
For instance, <code>x / y * z</code> is the same as <code>(x / y) * z</code>.
</p>

<pre>
+x
23 + 3*x[i]
x &lt;= f()
^a &gt;&gt; b
f() || g()
x == y+1 &amp;&amp; &lt;-chanPtr &gt; 0
</pre>


<h3 id="Arithmetic_operators">Arithmetic operators</h3>
<p>
Arithmetic operators apply to numeric values and yield a result of the same
type as the first operand. The four standard arithmetic operators (<code>+</code>,
<code>-</code>,  <code>*</code>, <code>/</code>) apply to integer,
floating-point, and complex types; <code>+</code> also applies
to strings. All other arithmetic operators apply to integers only.
</p>

<pre class="grammar">
+    sum                    integers, floats, complex values, strings
-    difference             integers, floats, complex values
*    product                integers, floats, complex values
/    quotient               integers, floats, complex values
%    remainder              integers

&amp;    bitwise AND            integers
|    bitwise OR             integers
^    bitwise XOR            integers
&amp;^   bit clear (AND NOT)    integers

&lt;&lt;   left shift             integer &lt;&lt; unsigned integer
&gt;&gt;   right shift            integer &gt;&gt; unsigned integer
</pre>

<p>
Strings can be concatenated using the <code>+</code> operator
or the <code>+=</code> assignment operator:
</p>

<pre>
s := "hi" + string(c)
s += " and good bye"
</pre>

<p>
String addition creates a new string by concatenating the operands.
</p>
<p>
For two integer values <code>x</code> and <code>y</code>, the integer quotient
<code>q = x / y</code> and remainder <code>r = x % y</code> satisfy the following
relationships:
</p>

<pre>
x = q*y + r  and  |r| &lt; |y|
</pre>

<p>
with <code>x / y</code> truncated towards zero
(<a href="http://en.wikipedia.org/wiki/Modulo_operation">"truncated division"</a>).
</p>

<pre>
 x     y     x / y     x % y
 5     3       1         2
-5     3      -1        -2
 5    -3      -1         2
-5    -3       1        -2
</pre>

<p>
As an exception to this rule, if the dividend <code>x</code> is the most
negative value for the int type of <code>x</code>, the quotient
<code>q = x / -1</code> is equal to <code>x</code> (and <code>r = 0</code>).
</p>

<pre>
			 x, q
int8                     -128
int16                  -32768
int32             -2147483648
int64    -9223372036854775808
</pre>

<p>
If the divisor is a <a href="#Constants">constant</a>, it must not be zero.
If the divisor is zero at run time, a <a href="#Run_time_panics">run-time panic</a> occurs.
If the dividend is non-negative and the divisor is a constant power of 2,
the division may be replaced by a right shift, and computing the remainder may
be replaced by a bitwise AND operation:
</p>

<pre>
 x     x / 4     x % 4     x &gt;&gt; 2     x &amp; 3
 11      2         3         2          3
-11     -2        -3        -3          1
</pre>

<p>
The shift operators shift the left operand by the shift count specified by the
right operand. They implement arithmetic shifts if the left operand is a signed
integer and logical shifts if it is an unsigned integer.
There is no upper limit on the shift count. Shifts behave
as if the left operand is shifted <code>n</code> times by 1 for a shift
count of <code>n</code>.
As a result, <code>x &lt;&lt; 1</code> is the same as <code>x*2</code>
and <code>x &gt;&gt; 1</code> is the same as
<code>x/2</code> but truncated towards negative infinity.
</p>

<p>
For integer operands, the unary operators
<code>+</code>, <code>-</code>, and <code>^</code> are defined as
follows:
</p>

<pre class="grammar">
+x                          is 0 + x
-x    negation              is 0 - x
^x    bitwise complement    is m ^ x  with m = "all bits set to 1" for unsigned x
                                      and  m = -1 for signed x
</pre>

<p>
For floating-point and complex numbers,
<code>+x</code> is the same as <code>x</code>,
while <code>-x</code> is the negation of <code>x</code>.
The result of a floating-point or complex division by zero is not specified beyond the
IEEE-754 standard; whether a <a href="#Run_time_panics">run-time panic</a>
occurs is implementation-specific.
</p>

<h3 id="Integer_overflow">Integer overflow</h3>

<p>
For unsigned integer values, the operations <code>+</code>,
<code>-</code>, <code>*</code>, and <code>&lt;&lt;</code> are
computed modulo 2<sup><i>n</i></sup>, where <i>n</i> is the bit width of
the <a href="#Numeric_types">unsigned integer</a>'s type.
Loosely speaking, these unsigned integer operations
discard high bits upon overflow, and programs may rely on ``wrap around''.
</p>
<p>
For signed integers, the operations <code>+</code>,
<code>-</code>, <code>*</code>, and <code>&lt;&lt;</code> may legally
overflow and the resulting value exists and is deterministically defined
by the signed integer representation, the operation, and its operands.
No exception is raised as a result of overflow. A
compiler may not optimize code under the assumption that overflow does
not occur. For instance, it may not assume that <code>x &lt; x + 1</code> is always true.
</p>


<h3 id="Comparison_operators">Comparison operators</h3>

<p>
Comparison operators compare two operands and yield an untyped boolean value.
</p>

<pre class="grammar">
==    equal
!=    not equal
&lt;     less
&lt;=    less or equal
&gt;     greater
&gt;=    greater or equal
</pre>

<p>
In any comparison, the first operand
must be <a href="#Assignability">assignable</a>
to the type of the second operand, or vice versa.
</p>
<p>
The equality operators <code>==</code> and <code>!=</code> apply
to operands that are <i>comparable</i>.
The ordering operators <code>&lt;</code>, <code>&lt;=</code>, <code>&gt;</code>, and <code>&gt;=</code>
apply to operands that are <i>ordered</i>.
These terms and the result of the comparisons are defined as follows:
</p>

<ul>
	<li>
	Boolean values are comparable.
	Two boolean values are equal if they are either both
	<code>true</code> or both <code>false</code>.
	</li>

	<li>
	Integer values are comparable and ordered, in the usual way.
	</li>

	<li>
	Floating point values are comparable and ordered,
	as defined by the IEEE-754 standard.
	</li>

	<li>
	Complex values are comparable.
	Two complex values <code>u</code> and <code>v</code> are
	equal if both <code>real(u) == real(v)</code> and
	<code>imag(u) == imag(v)</code>.
	</li>

	<li>
	String values are comparable and ordered, lexically byte-wise.
	</li>

	<li>
	Pointer values are comparable.
	Two pointer values are equal if they point to the same variable or if both have value <code>nil</code>.
	Pointers to distinct <a href="#Size_and_alignment_guarantees">zero-size</a> variables may or may not be equal.
	</li>

	<li>
	Channel values are comparable.
	Two channel values are equal if they were created by the same call to
	<a href="#Making_slices_maps_and_channels"><code>make</code></a>
	or if both have value <code>nil</code>.
	</li>

	<li>
	Interface values are comparable.
	Two interface values are equal if they have <a href="#Type_identity">identical</a> dynamic types
	and equal dynamic values or if both have value <code>nil</code>.
	</li>

	<li>
	A value <code>x</code> of non-interface type <code>X</code> and
	a value <code>t</code> of interface type <code>T</code> are comparable when values
	of type <code>X</code> are comparable and
	<code>X</code> implements <code>T</code>.
	They are equal if <code>t</code>'s dynamic type is identical to <code>X</code>
	and <code>t</code>'s dynamic value is equal to <code>x</code>.
	</li>

	<li>
	Struct values are comparable if all their fields are comparable.
	Two struct values are equal if their corresponding
	non-<a href="#Blank_identifier">blank</a> fields are equal.
	</li>

	<li>
	Array values are comparable if values of the array element type are comparable.
	Two array values are equal if their corresponding elements are equal.
	</li>
</ul>

<p>
A comparison of two interface values with identical dynamic types
causes a <a href="#Run_time_panics">run-time panic</a> if values
of that type are not comparable.  This behavior applies not only to direct interface
value comparisons but also when comparing arrays of interface values
or structs with interface-valued fields.
</p>

<p>
Slice, map, and function values are not comparable.
However, as a special case, a slice, map, or function value may
be compared to the predeclared identifier <code>nil</code>.
Comparison of pointer, channel, and interface values to <code>nil</code>
is also allowed and follows from the general rules above.
</p>

<pre>
const c = 3 &lt; 4            // c is the untyped bool constant true

type MyBool bool
var x, y int
var (
	// The result of a comparison is an untyped bool.
	// The usual assignment rules apply.
	b3        = x == y // b3 has type bool
	b4 bool   = x == y // b4 has type bool
	b5 MyBool = x == y // b5 has type MyBool
)
</pre>

<h3 id="Logical_operators">Logical operators</h3>

<p>
Logical operators apply to <a href="#Boolean_types">boolean</a> values
and yield a result of the same type as the operands.
The right operand is evaluated conditionally.
</p>

<pre class="grammar">
&amp;&amp;    conditional AND    p &amp;&amp; q  is  "if p then q else false"
||    conditional OR     p || q  is  "if p then true else q"
!     NOT                !p      is  "not p"
</pre>


<h3 id="Address_operators">Address operators</h3>

<p>
For an operand <code>x</code> of type <code>T</code>, the address operation
<code>&amp;x</code> generates a pointer of type <code>*T</code> to <code>x</code>.
The operand must be <i>addressable</i>,
that is, either a variable, pointer indirection, or slice indexing
operation; or a field selector of an addressable struct operand;
or an array indexing operation of an addressable array.
As an exception to the addressability requirement, <code>x</code> may also be a
(possibly parenthesized)
<a href="#Composite_literals">composite literal</a>.
If the evaluation of <code>x</code> would cause a <a href="#Run_time_panics">run-time panic</a>,
then the evaluation of <code>&amp;x</code> does too.
</p>

<p>
For an operand <code>x</code> of pointer type <code>*T</code>, the pointer
indirection <code>*x</code> denotes the <a href="#Variables">variable</a> of type <code>T</code> pointed
to by <code>x</code>.
If <code>x</code> is <code>nil</code>, an attempt to evaluate <code>*x</code>
will cause a <a href="#Run_time_panics">run-time panic</a>.
</p>

<pre>
&amp;x
&amp;a[f(2)]
&amp;Point{2, 3}
*p
*pf(x)

var x *int = nil
*x   // causes a run-time panic
&amp;*x  // causes a run-time panic
</pre>


<h3 id="Receive_operator">Receive operator</h3>

<p>
For an operand <code>ch</code> of <a href="#Channel_types">channel type</a>,
the value of the receive operation <code>&lt;-ch</code> is the value received
from the channel <code>ch</code>. The channel direction must permit receive operations,
and the type of the receive operation is the element type of the channel.
The expression blocks until a value is available.
Receiving from a <code>nil</code> channel blocks forever.
A receive operation on a <a href="#Close">closed</a> channel can always proceed
immediately, yielding the element type's <a href="#The_zero_value">zero value</a>
after any previously sent values have been received.
</p>

<pre>
v1 := &lt;-ch
v2 = &lt;-ch
f(&lt;-ch)
&lt;-strobe  // wait until clock pulse and discard received value
</pre>

<p>
A receive expression used in an <a href="#Assignments">assignment</a> or initialization of the special form
</p>

<pre>
x, ok = &lt;-ch
x, ok := &lt;-ch
var x, ok = &lt;-ch
</pre>

<p>
yields an additional untyped boolean result reporting whether the
communication succeeded. The value of <code>ok</code> is <code>true</code>
if the value received was delivered by a successful send operation to the
channel, or <code>false</code> if it is a zero value generated because the
channel is closed and empty.
</p>


<h3 id="Conversions">Conversions</h3>

<p>
Conversions are expressions of the form <code>T(x)</code>
where <code>T</code> is a type and <code>x</code> is an expression
that can be converted to type <code>T</code>.
</p>

<pre class="ebnf">
Conversion = Type "(" Expression [ "," ] ")" .
</pre>

<p>
If the type starts with the operator <code>*</code> or <code>&lt;-</code>,
or if the type starts with the keyword <code>func</code>
and has no result list, it must be parenthesized when
necessary to avoid ambiguity:
</p>

<pre>
*Point(p)        // same as *(Point(p))
(*Point)(p)      // p is converted to *Point
&lt;-chan int(c)    // same as &lt;-(chan int(c))
(&lt;-chan int)(c)  // c is converted to &lt;-chan int
func()(x)        // function signature func() x
(func())(x)      // x is converted to func()
(func() int)(x)  // x is converted to func() int
func() int(x)    // x is converted to func() int (unambiguous)
</pre>

<p>
A <a href="#Constants">constant</a> value <code>x</code> can be converted to
type <code>T</code> in any of these cases:
</p>

<ul>
	<li>
	<code>x</code> is representable by a value of type <code>T</code>.
	</li>
	<li>
	<code>x</code> is a floating-point constant,
	<code>T</code> is a floating-point type,
	and <code>x</code> is representable by a value
	of type <code>T</code> after rounding using
	IEEE 754 round-to-even rules.
	The constant <code>T(x)</code> is the rounded value.
	</li>
	<li>
	<code>x</code> is an integer constant and <code>T</code> is a
	<a href="#String_types">string type</a>.
	The <a href="#Conversions_to_and_from_a_string_type">same rule</a>
	as for non-constant <code>x</code> applies in this case.
	</li>
</ul>

<p>
Converting a constant yields a typed constant as result.
</p>

<pre>
uint(iota)               // iota value of type uint
float32(2.718281828)     // 2.718281828 of type float32
complex128(1)            // 1.0 + 0.0i of type complex128
float32(0.49999999)      // 0.5 of type float32
string('x')              // "x" of type string
string(0x266c)           // "‚ô¨" of type string
MyString("foo" + "bar")  // "foobar" of type MyString
string([]byte{'a'})      // not a constant: []byte{'a'} is not a constant
(*int)(nil)              // not a constant: nil is not a constant, *int is not a boolean, numeric, or string type
int(1.2)                 // illegal: 1.2 cannot be represented as an int
string(65.0)             // illegal: 65.0 is not an integer constant
</pre>

<p>
A non-constant value <code>x</code> can be converted to type <code>T</code>
in any of these cases:
</p>

<ul>
	<li>
	<code>x</code> is <a href="#Assignability">assignable</a>
	to <code>T</code>.
	</li>
	<li>
	<code>x</code>'s type and <code>T</code> have identical
	<a href="#Types">underlying types</a>.
	</li>
	<li>
	<code>x</code>'s type and <code>T</code> are unnamed pointer types
	and their pointer base types have identical underlying types.
	</li>
	<li>
	<code>x</code>'s type and <code>T</code> are both integer or floating
	point types.
	</li>
	<li>
	<code>x</code>'s type and <code>T</code> are both complex types.
	</li>
	<li>
	<code>x</code> is an integer or a slice of bytes or runes
	and <code>T</code> is a string type.
	</li>
	<li>
	<code>x</code> is a string and <code>T</code> is a slice of bytes or runes.
	</li>
</ul>

<p>
Specific rules apply to (non-constant) conversions between numeric types or
to and from a string type.
These conversions may change the representation of <code>x</code>
and incur a run-time cost.
All other conversions only change the type but not the representation
of <code>x</code>.
</p>

<p>
There is no linguistic mechanism to convert between pointers and integers.
The package <a href="#Package_unsafe"><code>unsafe</code></a>
implements this functionality under
restricted circumstances.
</p>

<h4>Conversions between numeric types</h4>

<p>
For the conversion of non-constant numeric values, the following rules apply:
</p>

<ol>
<li>
When converting between integer types, if the value is a signed integer, it is
sign extended to implicit infinite precision; otherwise it is zero extended.
It is then truncated to fit in the result type's size.
For example, if <code>v := uint16(0x10F0)</code>, then <code>uint32(int8(v)) == 0xFFFFFFF0</code>.
The conversion always yields a valid value; there is no indication of overflow.
</li>
<li>
When converting a floating-point number to an integer, the fraction is discarded
(truncation towards zero).
</li>
<li>
When converting an integer or floating-point number to a floating-point type,
or a complex number to another complex type, the result value is rounded
to the precision specified by the destination type.
For instance, the value of a variable <code>x</code> of type <code>float32</code>
may be stored using additional precision beyond that of an IEEE-754 32-bit number,
but float32(x) represents the result of rounding <code>x</code>'s value to
32-bit precision. Similarly, <code>x + 0.1</code> may use more than 32 bits
of precision, but <code>float32(x + 0.1)</code> does not.
</li>
</ol>

<p>
In all non-constant conversions involving floating-point or complex values,
if the result type cannot represent the value the conversion
succeeds but the result value is implementation-dependent.
</p>

<h4 id="Conversions_to_and_from_a_string_type">Conversions to and from a string type</h4>

<ol>
<li>
Converting a signed or unsigned integer value to a string type yields a
string containing the UTF-8 representation of the integer. Values outside
the range of valid Unicode code points are converted to <code>"\uFFFD"</code>.

<pre>
string('a')       // "a"
string(-1)        // "\ufffd" == "\xef\xbf\xbd"
string(0xf8)      // "\u00f8" == "√∏" == "\xc3\xb8"
type MyString string
MyString(0x65e5)  // "\u65e5" == "Êó•" == "\xe6\x97\xa5"
</pre>
</li>

<li>
Converting a slice of bytes to a string type yields
a string whose successive bytes are the elements of the slice.

<pre>
string([]byte{'h', 'e', 'l', 'l', '\xc3', '\xb8'})   // "hell√∏"
string([]byte{})                                     // ""
string([]byte(nil))                                  // ""

type MyBytes []byte
string(MyBytes{'h', 'e', 'l', 'l', '\xc3', '\xb8'})  // "hell√∏"
</pre>
</li>

<li>
Converting a slice of runes to a string type yields
a string that is the concatenation of the individual rune values
converted to strings.

<pre>
string([]rune{0x767d, 0x9d6c, 0x7fd4})   // "\u767d\u9d6c\u7fd4" == "ÁôΩÈµ¨Áøî"
string([]rune{})                         // ""
string([]rune(nil))                      // ""

type MyRunes []rune
string(MyRunes{0x767d, 0x9d6c, 0x7fd4})  // "\u767d\u9d6c\u7fd4" == "ÁôΩÈµ¨Áøî"
</pre>
</li>

<li>
Converting a value of a string type to a slice of bytes type
yields a slice whose successive elements are the bytes of the string.

<pre>
[]byte("hell√∏")   // []byte{'h', 'e', 'l', 'l', '\xc3', '\xb8'}
[]byte("")        // []byte{}

MyBytes("hell√∏")  // []byte{'h', 'e', 'l', 'l', '\xc3', '\xb8'}
</pre>
</li>

<li>
Converting a value of a string type to a slice of runes type
yields a slice containing the individual Unicode code points of the string.

<pre>
[]rune(MyString("ÁôΩÈµ¨Áøî"))  // []rune{0x767d, 0x9d6c, 0x7fd4}
[]rune("")                 // []rune{}

MyRunes("ÁôΩÈµ¨Áøî")           // []rune{0x767d, 0x9d6c, 0x7fd4}
</pre>
</li>
</ol>


<h3 id="Constant_expressions">Constant expressions</h3>

<p>
Constant expressions may contain only <a href="#Constants">constant</a>
operands and are evaluated at compile time.
</p>

<p>
Untyped boolean, numeric, and string constants may be used as operands
wherever it is legal to use an operand of boolean, numeric, or string type,
respectively.
Except for shift operations, if the operands of a binary operation are
different kinds of untyped constants, the operation and, for non-boolean operations, the result use
the kind that appears later in this list: integer, rune, floating-point, complex.
For example, an untyped integer constant divided by an
untyped complex constant yields an untyped complex constant.
</p>

<p>
A constant <a href="#Comparison_operators">comparison</a> always yields
an untyped boolean constant.  If the left operand of a constant
<a href="#Operators">shift expression</a> is an untyped constant, the
result is an integer constant; otherwise it is a constant of the same
type as the left operand, which must be of
<a href="#Numeric_types">integer type</a>.
Applying all other operators to untyped constants results in an untyped
constant of the same kind (that is, a boolean, integer, floating-point,
complex, or string constant).
</p>

<pre>
const a = 2 + 3.0          // a == 5.0   (untyped floating-point constant)
const b = 15 / 4           // b == 3     (untyped integer constant)
const c = 15 / 4.0         // c == 3.75  (untyped floating-point constant)
const Œò float64 = 3/2      // Œò == 1.0   (type float64, 3/2 is integer division)
const Œ† float64 = 3/2.     // Œ† == 1.5   (type float64, 3/2. is float division)
const d = 1 &lt;&lt; 3.0         // d == 8     (untyped integer constant)
const e = 1.0 &lt;&lt; 3         // e == 8     (untyped integer constant)
const f = int32(1) &lt;&lt; 33   // illegal    (constant 8589934592 overflows int32)
const g = float64(2) &gt;&gt; 1  // illegal    (float64(2) is a typed floating-point constant)
const h = "foo" &gt; "bar"    // h == true  (untyped boolean constant)
const j = true             // j == true  (untyped boolean constant)
const k = 'w' + 1          // k == 'x'   (untyped rune constant)
const l = "hi"             // l == "hi"  (untyped string constant)
const m = string(k)        // m == "x"   (type string)
const Œ£ = 1 - 0.707i       //            (untyped complex constant)
const Œî = Œ£ + 2.0e-4       //            (untyped complex constant)
const Œ¶ = iota*1i - 1/1i   //            (untyped complex constant)
</pre>

<p>
Applying the built-in function <code>complex</code> to untyped
integer, rune, or floating-point constants yields
an untyped complex constant.
</p>

<pre>
const ic = complex(0, c)   // ic == 3.75i  (untyped complex constant)
const iŒò = complex(0, Œò)   // iŒò == 1i     (type complex128)
</pre>

<p>
Constant expressions are always evaluated exactly; intermediate values and the
constants themselves may require precision significantly larger than supported
by any predeclared type in the language. The following are legal declarations:
</p>

<pre>
const Huge = 1 &lt;&lt; 100         // Huge == 1267650600228229401496703205376  (untyped integer constant)
const Four int8 = Huge &gt;&gt; 98  // Four == 4                                (type int8)
</pre>

<p>
The divisor of a constant division or remainder operation must not be zero:
</p>

<pre>
3.14 / 0.0   // illegal: division by zero
</pre>

<p>
The values of <i>typed</i> constants must always be accurately representable as values
of the constant type. The following constant expressions are illegal:
</p>

<pre>
uint(-1)     // -1 cannot be represented as a uint
int(3.14)    // 3.14 cannot be represented as an int
int64(Huge)  // 1267650600228229401496703205376 cannot be represented as an int64
Four * 300   // operand 300 cannot be represented as an int8 (type of Four)
Four * 100   // product 400 cannot be represented as an int8 (type of Four)
</pre>

<p>
The mask used by the unary bitwise complement operator <code>^</code> matches
the rule for non-constants: the mask is all 1s for unsigned constants
and -1 for signed and untyped constants.
</p>

<pre>
^1         // untyped integer constant, equal to -2
uint8(^1)  // illegal: same as uint8(-2), -2 cannot be represented as a uint8
^uint8(1)  // typed uint8 constant, same as 0xFF ^ uint8(1) = uint8(0xFE)
int8(^1)   // same as int8(-2)
^int8(1)   // same as -1 ^ int8(1) = -2
</pre>

<p>
Implementation restriction: A compiler may use rounding while
computing untyped floating-point or complex constant expressions; see
the implementation restriction in the section
on <a href="#Constants">constants</a>.  This rounding may cause a
floating-point constant expression to be invalid in an integer
context, even if it would be integral when calculated using infinite
precision.
</p>


<h3 id="Order_of_evaluation">Order of evaluation</h3>

<p>
At package level, <a href="#Package_initialization">initialization dependencies</a>
determine the evaluation order of individual initialization expressions in
<a href="#Variable_declarations">variable declarations</a>.
Otherwise, when evaluating the <a href="#Operands">operands</a> of an
expression, assignment, or
<a href="#Return_statements">return statement</a>,
all function calls, method calls, and
communication operations are evaluated in lexical left-to-right
order.
</p>

<p>
For example, in the (function-local) assignment
</p>
<pre>
y[f()], ok = g(h(), i()+x[j()], &lt;-c), k()
</pre>
<p>
the function calls and communication happen in the order
<code>f()</code>, <code>h()</code>, <code>i()</code>, <code>j()</code>,
<code>&lt;-c</code>, <code>g()</code>, and <code>k()</code>.
However, the order of those events compared to the evaluation
and indexing of <code>x</code> and the evaluation
of <code>y</code> is not specified.
</p>

<pre>
a := 1
f := func() int { a++; return a }
x := []int{a, f()}            // x may be [1, 2] or [2, 2]: evaluation order between a and f() is not specified
m := map[int]int{a: 1, a: 2}  // m may be {2: 1} or {2: 2}: evaluation order between the two map assignments is not specified
n := map[int]int{a: f()}      // n may be {2: 3} or {3: 3}: evaluation order between the key and the value is not specified
</pre>

<p>
At package level, initialization dependencies override the left-to-right rule
for individual initialization expressions, but not for operands within each
expression:
</p>

<pre>
var a, b, c = f() + v(), g(), sqr(u()) + v()

func f() int        { return c }
func g() int        { return a }
func sqr(x int) int { return x*x }

// functions u and v are independent of all other variables and functions
</pre>

<p>
The function calls happen in the order
<code>u()</code>, <code>sqr()</code>, <code>v()</code>,
<code>f()</code>, <code>v()</code>, and <code>g()</code>.
</p>

<p>
Floating-point operations within a single expression are evaluated according to
the associativity of the operators.  Explicit parentheses affect the evaluation
by overriding the default associativity.
In the expression <code>x + (y + z)</code> the addition <code>y + z</code>
is performed before adding <code>x</code>.
</p>

<h2 id="Statements">Statements</h2>

<p>
Statements control execution.
</p>

<pre class="ebnf">
Statement =
	Declaration | LabeledStmt | SimpleStmt |
	GoStmt | ReturnStmt | BreakStmt | ContinueStmt | GotoStmt |
	FallthroughStmt | Block | IfStmt | SwitchStmt | SelectStmt | ForStmt |
	DeferStmt .

SimpleStmt = EmptyStmt | ExpressionStmt | SendStmt | IncDecStmt | Assignment | ShortVarDecl .
</pre>

<h3 id="Terminating_statements">Terminating statements</h3>

<p>
A terminating statement is one of the following:
</p>

<ol>
<li>
	A <a href="#Return_statements">"return"</a> or
    	<a href="#Goto_statements">"goto"</a> statement.
	<!-- ul below only for regular layout -->
	<ul> </ul>
</li>

<li>
	A call to the built-in function
	<a href="#Handling_panics"><code>panic</code></a>.
	<!-- ul below only for regular layout -->
	<ul> </ul>
</li>

<li>
	A <a href="#Blocks">block</a> in which the statement list ends in a terminating statement.
	<!-- ul below only for regular layout -->
	<ul> </ul>
</li>

<li>
	An <a href="#If_statements">"if" statement</a> in which:
	<ul>
	<li>the "else" branch is present, and</li>
	<li>both branches are terminating statements.</li>
	</ul>
</li>

<li>
	A <a href="#For_statements">"for" statement</a> in which:
	<ul>
	<li>there are no "break" statements referring to the "for" statement, and</li>
	<li>the loop condition is absent.</li>
	</ul>
</li>

<li>
	A <a href="#Switch_statements">"switch" statement</a> in which:
	<ul>
	<li>there are no "break" statements referring to the "switch" statement,</li>
	<li>there is a default case, and</li>
	<li>the statement lists in each case, including the default, end in a terminating
	    statement, or a possibly labeled <a href="#Fallthrough_statements">"fallthrough"
	    statement</a>.</li>
	</ul>
</li>

<li>
	A <a href="#Select_statements">"select" statement</a> in which:
	<ul>
	<li>there are no "break" statements referring to the "select" statement, and</li>
	<li>the statement lists in each case, including the default if present,
	    end in a terminating statement.</li>
	</ul>
</li>

<li>
	A <a href="#Labeled_statements">labeled statement</a> labeling
	a terminating statement.
</li>
</ol>

<p>
All other statements are not terminating.
</p>

<p>
A <a href="#Blocks">statement list</a> ends in a terminating statement if the list
is not empty and its final statement is terminating.
</p>


<h3 id="Empty_statements">Empty statements</h3>

<p>
The empty statement does nothing.
</p>

<pre class="ebnf">
EmptyStmt = .
</pre>


<h3 id="Labeled_statements">Labeled statements</h3>

<p>
A labeled statement may be the target of a <code>goto</code>,
<code>break</code> or <code>continue</code> statement.
</p>

<pre class="ebnf">
LabeledStmt = Label ":" Statement .
Label       = identifier .
</pre>

<pre>
Error: log.Panic("error encountered")
</pre>


<h3 id="Expression_statements">Expression statements</h3>

<p>
With the exception of specific built-in functions,
function and method <a href="#Calls">calls</a> and
<a href="#Receive_operator">receive operations</a>
can appear in statement context. Such statements may be parenthesized.
</p>

<pre class="ebnf">
ExpressionStmt = Expression .
</pre>

<p>
The following built-in functions are not permitted in statement context:
</p>

<pre>
append cap complex imag len make new real
unsafe.Alignof unsafe.Offsetof unsafe.Sizeof
</pre>

<pre>
h(x+y)
f.Close()
&lt;-ch
(&lt;-ch)
len("foo")  // illegal if len is the built-in function
</pre>


<h3 id="Send_statements">Send statements</h3>

<p>
A send statement sends a value on a channel.
The channel expression must be of <a href="#Channel_types">channel type</a>,
the channel direction must permit send operations,
and the type of the value to be sent must be <a href="#Assignability">assignable</a>
to the channel's element type.
</p>

<pre class="ebnf">
SendStmt = Channel "&lt;-" Expression .
Channel  = Expression .
</pre>

<p>
Both the channel and the value expression are evaluated before communication
begins. Communication blocks until the send can proceed.
A send on an unbuffered channel can proceed if a receiver is ready.
A send on a buffered channel can proceed if there is room in the buffer.
A send on a closed channel proceeds by causing a <a href="#Run_time_panics">run-time panic</a>.
A send on a <code>nil</code> channel blocks forever.
</p>

<pre>
ch &lt;- 3  // send value 3 to channel ch
</pre>


<h3 id="IncDec_statements">IncDec statements</h3>

<p>
The "++" and "--" statements increment or decrement their operands
by the untyped <a href="#Constants">constant</a> <code>1</code>.
As with an assignment, the operand must be <a href="#Address_operators">addressable</a>
or a map index expression.
</p>

<pre class="ebnf">
IncDecStmt = Expression ( "++" | "--" ) .
</pre>

<p>
The following <a href="#Assignments">assignment statements</a> are semantically
equivalent:
</p>

<pre class="grammar">
IncDec statement    Assignment
x++                 x += 1
x--                 x -= 1
</pre>


<h3 id="Assignments">Assignments</h3>

<pre class="ebnf">
Assignment = ExpressionList assign_op ExpressionList .

assign_op = [ add_op | mul_op ] "=" .
</pre>

<p>
Each left-hand side operand must be <a href="#Address_operators">addressable</a>,
a map index expression, or (for <code>=</code> assignments only) the
<a href="#Blank_identifier">blank identifier</a>.
Operands may be parenthesized.
</p>

<pre>
x = 1
*p = f()
a[i] = 23
(k) = &lt;-ch  // same as: k = &lt;-ch
</pre>

<p>
An <i>assignment operation</i> <code>x</code> <i>op</i><code>=</code>
<code>y</code> where <i>op</i> is a binary arithmetic operation is equivalent
to <code>x</code> <code>=</code> <code>x</code> <i>op</i>
<code>y</code> but evaluates <code>x</code>
only once.  The <i>op</i><code>=</code> construct is a single token.
In assignment operations, both the left- and right-hand expression lists
must contain exactly one single-valued expression, and the left-hand
expression must not be the blank identifier.
</p>

<pre>
a[i] &lt;&lt;= 2
i &amp;^= 1&lt;&lt;n
</pre>

<p>
A tuple assignment assigns the individual elements of a multi-valued
operation to a list of variables.  There are two forms.  In the
first, the right hand operand is a single multi-valued expression
such as a function call, a <a href="#Channel_types">channel</a> or
<a href="#Map_types">map</a> operation, or a <a href="#Type_assertions">type assertion</a>.
The number of operands on the left
hand side must match the number of values.  For instance, if
<code>f</code> is a function returning two values,
</p>

<pre>
x, y = f()
</pre>

<p>
assigns the first value to <code>x</code> and the second to <code>y</code>.
In the second form, the number of operands on the left must equal the number
of expressions on the right, each of which must be single-valued, and the
<i>n</i>th expression on the right is assigned to the <i>n</i>th
operand on the left:
</p>

<pre>
one, two, three = '‰∏Ä', '‰∫å', '‰∏â'
</pre>

<p>
The <a href="#Blank_identifier">blank identifier</a> provides a way to
ignore right-hand side values in an assignment:
</p>

<pre>
_ = x       // evaluate x but ignore it
x, _ = f()  // evaluate f() but ignore second result value
</pre>

<p>
The assignment proceeds in two phases.
First, the operands of <a href="#Index_expressions">index expressions</a>
and <a href="#Address_operators">pointer indirections</a>
(including implicit pointer indirections in <a href="#Selectors">selectors</a>)
on the left and the expressions on the right are all
<a href="#Order_of_evaluation">evaluated in the usual order</a>.
Second, the assignments are carried out in left-to-right order.
</p>

<pre>
a, b = b, a  // exchange a and b

x := []int{1, 2, 3}
i := 0
i, x[i] = 1, 2  // set i = 1, x[0] = 2

i = 0
x[i], i = 2, 1  // set x[0] = 2, i = 1

x[0], x[0] = 1, 2  // set x[0] = 1, then x[0] = 2 (so x[0] == 2 at end)

x[1], x[3] = 4, 5  // set x[1] = 4, then panic setting x[3] = 5.

type Point struct { x, y int }
var p *Point
x[2], p.x = 6, 7  // set x[2] = 6, then panic setting p.x = 7

i = 2
x = []int{3, 5, 7}
for i, x[i] = range x {  // set i, x[2] = 0, x[0]
	break
}
// after this loop, i == 0 and x == []int{3, 5, 3}
</pre>

<p>
In assignments, each value must be <a href="#Assignability">assignable</a>
to the type of the operand to which it is assigned, with the following special cases:
</p>

<ol>
<li>
	Any typed value may be assigned to the blank identifier.
</li>

<li>
	If an untyped constant
	is assigned to a variable of interface type or the blank identifier,
	the constant is first <a href="#Conversions">converted</a> to its
	 <a href="#Constants">default type</a>.
</li>

<li>
	If an untyped boolean value is assigned to a variable of interface type or
	the blank identifier, it is first converted to type <code>bool</code>.
</li>
</ol>

<h3 id="If_statements">If statements</h3>

<p>
"If" statements specify the conditional execution of two branches
according to the value of a boolean expression.  If the expression
evaluates to true, the "if" branch is executed, otherwise, if
present, the "else" branch is executed.
</p>

<pre class="ebnf">
IfStmt = "if" [ SimpleStmt ";" ] Expression Block [ "else" ( IfStmt | Block ) ] .
</pre>

<pre>
if x &gt; max {
	x = max
}
</pre>

<p>
The expression may be preceded by a simple statement, which
executes before the expression is evaluated.
</p>

<pre>
if x := f(); x &lt; y {
	return x
} else if x &gt; z {
	return z
} else {
	return y
}
</pre>


<h3 id="Switch_statements">Switch statements</h3>

<p>
"Switch" statements provide multi-way execution.
An expression or type specifier is compared to the "cases"
inside the "switch" to determine which branch
to execute.
</p>

<pre class="ebnf">
SwitchStmt = ExprSwitchStmt | TypeSwitchStmt .
</pre>

<p>
There are two forms: expression switches and type switches.
In an expression switch, the cases contain expressions that are compared
against the value of the switch expression.
In a type switch, the cases contain types that are compared against the
type of a specially annotated switch expression.
</p>

<h4 id="Expression_switches">Expression switches</h4>

<p>
In an expression switch,
the switch expression is evaluated and
the case expressions, which need not be constants,
are evaluated left-to-right and top-to-bottom; the first one that equals the
switch expression
triggers execution of the statements of the associated case;
the other cases are skipped.
If no case matches and there is a "default" case,
its statements are executed.
There can be at most one default case and it may appear anywhere in the
"switch" statement.
A missing switch expression is equivalent to the boolean value
<code>true</code>.
</p>

<pre class="ebnf">
ExprSwitchStmt = "switch" [ SimpleStmt ";" ] [ Expression ] "{" { ExprCaseClause } "}" .
ExprCaseClause = ExprSwitchCase ":" StatementList .
ExprSwitchCase = "case" ExpressionList | "default" .
</pre>

<p>
In a case or default clause, the last non-empty statement
may be a (possibly <a href="#Labeled_statements">labeled</a>)
<a href="#Fallthrough_statements">"fallthrough" statement</a> to
indicate that control should flow from the end of this clause to
the first statement of the next clause.
Otherwise control flows to the end of the "switch" statement.
A "fallthrough" statement may appear as the last statement of all
but the last clause of an expression switch.
</p>

<p>
The expression may be preceded by a simple statement, which
executes before the expression is evaluated.
</p>

<pre>
switch tag {
default: s3()
case 0, 1, 2, 3: s1()
case 4, 5, 6, 7: s2()
}

switch x := f(); {  // missing switch expression means "true"
case x &lt; 0: return -x
default: return x
}

switch {
case x &lt; y: f1()
case x &lt; z: f2()
case x == 4: f3()
}
</pre>

<h4 id="Type_switches">Type switches</h4>

<p>
A type switch compares types rather than values. It is otherwise similar
to an expression switch. It is marked by a special switch expression that
has the form of a <a href="#Type_assertions">type assertion</a>
using the reserved word <code>type</code> rather than an actual type:
</p>

<pre>
switch x.(type) {
// cases
}
</pre>

<p>
Cases then match actual types <code>T</code> against the dynamic type of the
expression <code>x</code>. As with type assertions, <code>x</code> must be of
<a href="#Interface_types">interface type</a>, and each non-interface type
<code>T</code> listed in a case must implement the type of <code>x</code>.
</p>

<pre class="ebnf">
TypeSwitchStmt  = "switch" [ SimpleStmt ";" ] TypeSwitchGuard "{" { TypeCaseClause } "}" .
TypeSwitchGuard = [ identifier ":=" ] PrimaryExpr "." "(" "type" ")" .
TypeCaseClause  = TypeSwitchCase ":" StatementList .
TypeSwitchCase  = "case" TypeList | "default" .
TypeList        = Type { "," Type } .
</pre>

<p>
The TypeSwitchGuard may include a
<a href="#Short_variable_declarations">short variable declaration</a>.
When that form is used, the variable is declared at the beginning of
the <a href="#Blocks">implicit block</a> in each clause.
In clauses with a case listing exactly one type, the variable
has that type; otherwise, the variable has the type of the expression
in the TypeSwitchGuard.
</p>

<p>
The type in a case may be <a href="#Predeclared_identifiers"><code>nil</code></a>;
that case is used when the expression in the TypeSwitchGuard
is a <code>nil</code> interface value.
</p>

<p>
Given an expression <code>x</code> of type <code>interface{}</code>,
the following type switch:
</p>

<pre>
switch i := x.(type) {
case nil:
	printString("x is nil")                // type of i is type of x (interface{})
case int:
	printInt(i)                            // type of i is int
case float64:
	printFloat64(i)                        // type of i is float64
case func(int) float64:
	printFunction(i)                       // type of i is func(int) float64
case bool, string:
	printString("type is bool or string")  // type of i is type of x (interface{})
default:
	printString("don't know the type")     // type of i is type of x (interface{})
}
</pre>

<p>
could be rewritten:
</p>

<pre>
v := x  // x is evaluated exactly once
if v == nil {
	i := v                                 // type of i is type of x (interface{})
	printString("x is nil")
} else if i, isInt := v.(int); isInt {
	printInt(i)                            // type of i is int
} else if i, isFloat64 := v.(float64); isFloat64 {
	printFloat64(i)                        // type of i is float64
} else if i, isFunc := v.(func(int) float64); isFunc {
	printFunction(i)                       // type of i is func(int) float64
} else {
	_, isBool := v.(bool)
	_, isString := v.(string)
	if isBool || isString {
		i := v                         // type of i is type of x (interface{})
		printString("type is bool or string")
	} else {
		i := v                         // type of i is type of x (interface{})
		printString("don't know the type")
	}
}
</pre>

<p>
The type switch guard may be preceded by a simple statement, which
executes before the guard is evaluated.
</p>

<p>
The "fallthrough" statement is not permitted in a type switch.
</p>

<h3 id="For_statements">For statements</h3>

<p>
A "for" statement specifies repeated execution of a block. The iteration is
controlled by a condition, a "for" clause, or a "range" clause.
</p>

<pre class="ebnf">
ForStmt = "for" [ Condition | ForClause | RangeClause ] Block .
Condition = Expression .
</pre>

<p>
In its simplest form, a "for" statement specifies the repeated execution of
a block as long as a boolean condition evaluates to true.
The condition is evaluated before each iteration.
If the condition is absent, it is equivalent to the boolean value
<code>true</code>.
</p>

<pre>
for a &lt; b {
	a *= 2
}
</pre>

<p>
A "for" statement with a ForClause is also controlled by its condition, but
additionally it may specify an <i>init</i>
and a <i>post</i> statement, such as an assignment,
an increment or decrement statement. The init statement may be a
<a href="#Short_variable_declarations">short variable declaration</a>, but the post statement must not.
Variables declared by the init statement are re-used in each iteration.
</p>

<pre class="ebnf">
ForClause = [ InitStmt ] ";" [ Condition ] ";" [ PostStmt ] .
InitStmt = SimpleStmt .
PostStmt = SimpleStmt .
</pre>

<pre>
for i := 0; i &lt; 10; i++ {
	f(i)
}
</pre>

<p>
If non-empty, the init statement is executed once before evaluating the
condition for the first iteration;
the post statement is executed after each execution of the block (and
only if the block was executed).
Any element of the ForClause may be empty but the
<a href="#Semicolons">semicolons</a> are
required unless there is only a condition.
If the condition is absent, it is equivalent to the boolean value
<code>true</code>.
</p>

<pre>
for cond { S() }    is the same as    for ; cond ; { S() }
for      { S() }    is the same as    for true     { S() }
</pre>

<p>
A "for" statement with a "range" clause
iterates through all entries of an array, slice, string or map,
or values received on a channel. For each entry it assigns <i>iteration values</i>
to corresponding <i>iteration variables</i> if present and then executes the block.
</p>

<pre class="ebnf">
RangeClause = [ ExpressionList "=" | IdentifierList ":=" ] "range" Expression .
</pre>

<p>
The expression on the right in the "range" clause is called the <i>range expression</i>,
which may be an array, pointer to an array, slice, string, map, or channel permitting
<a href="#Receive_operator">receive operations</a>.
As with an assignment, if present the operands on the left must be
<a href="#Address_operators">addressable</a> or map index expressions; they
denote the iteration variables. If the range expression is a channel, at most
one iteration variable is permitted, otherwise there may be up to two.
If the last iteration variable is the <a href="#Blank_identifier">blank identifier</a>,
the range clause is equivalent to the same clause without that identifier.
</p>

<p>
The range expression is evaluated once before beginning the loop,
with one exception: if the range expression is an array or a pointer to an array
and at most one iteration variable is present, only the range expression's
length is evaluated; if that length is constant,
<a href="#Length_and_capacity">by definition</a>
the range expression itself will not be evaluated.
</p>

<p>
Function calls on the left are evaluated once per iteration.
For each iteration, iteration values are produced as follows
if the respective iteration variables are present:
</p>

<pre class="grammar">
Range expression                          1st value          2nd value

array or slice  a  [n]E, *[n]E, or []E    index    i  int    a[i]       E
string          s  string type            index    i  int    see below  rune
map             m  map[K]V                key      k  K      m[k]       V
channel         c  chan E, &lt;-chan E       element  e  E
</pre>

<ol>
<li>
For an array, pointer to array, or slice value <code>a</code>, the index iteration
values are produced in increasing order, starting at element index 0.
If at most one iteration variable is present, the range loop produces
iteration values from 0 up to <code>len(a)-1</code> and does not index into the array
or slice itself. For a <code>nil</code> slice, the number of iterations is 0.
</li>

<li>
For a string value, the "range" clause iterates over the Unicode code points
in the string starting at byte index 0.  On successive iterations, the index value will be the
index of the first byte of successive UTF-8-encoded code points in the string,
and the second value, of type <code>rune</code>, will be the value of
the corresponding code point.  If the iteration encounters an invalid
UTF-8 sequence, the second value will be <code>0xFFFD</code>,
the Unicode replacement character, and the next iteration will advance
a single byte in the string.
</li>

<li>
The iteration order over maps is not specified
and is not guaranteed to be the same from one iteration to the next.
If map entries that have not yet been reached are removed during iteration,
the corresponding iteration values will not be produced. If map entries are
created during iteration, that entry may be produced during the iteration or
may be skipped. The choice may vary for each entry created and from one
iteration to the next.
If the map is <code>nil</code>, the number of iterations is 0.
</li>

<li>
For channels, the iteration values produced are the successive values sent on
the channel until the channel is <a href="#Close">closed</a>. If the channel
is <code>nil</code>, the range expression blocks forever.
</li>
</ol>

<p>
The iteration values are assigned to the respective
iteration variables as in an <a href="#Assignments">assignment statement</a>.
</p>

<p>
The iteration variables may be declared by the "range" clause using a form of
<a href="#Short_variable_declarations">short variable declaration</a>
(<code>:=</code>).
In this case their types are set to the types of the respective iteration values
and their <a href="#Declarations_and_scope">scope</a> is the block of the "for"
statement; they are re-used in each iteration.
If the iteration variables are declared outside the "for" statement,
after execution their values will be those of the last iteration.
</p>

<pre>
var testdata *struct {
	a *[7]int
}
for i, _ := range testdata.a {
	// testdata.a is never evaluated; len(testdata.a) is constant
	// i ranges from 0 to 6
	f(i)
}

var a [10]string
for i, s := range a {
	// type of i is int
	// type of s is string
	// s == a[i]
	g(i, s)
}

var key string
var val interface {}  // value type of m is assignable to val
m := map[string]int{"mon":0, "tue":1, "wed":2, "thu":3, "fri":4, "sat":5, "sun":6}
for key, val = range m {
	h(key, val)
}
// key == last map key encountered in iteration
// val == map[key]

var ch chan Work = producer()
for w := range ch {
	doWork(w)
}

// empty a channel
for range ch {}
</pre>


<h3 id="Go_statements">Go statements</h3>

<p>
A "go" statement starts the execution of a function call
as an independent concurrent thread of control, or <i>goroutine</i>,
within the same address space.
</p>

<pre class="ebnf">
GoStmt = "go" Expression .
</pre>

<p>
The expression must be a function or method call; it cannot be parenthesized.
Calls of built-in functions are restricted as for
<a href="#Expression_statements">expression statements</a>.
</p>

<p>
The function value and parameters are
<a href="#Calls">evaluated as usual</a>
in the calling goroutine, but
unlike with a regular call, program execution does not wait
for the invoked function to complete.
Instead, the function begins executing independently
in a new goroutine.
When the function terminates, its goroutine also terminates.
If the function has any return values, they are discarded when the
function completes.
</p>

<pre>
go Server()
go func(ch chan&lt;- bool) { for { sleep(10); ch &lt;- true; }} (c)
</pre>


<h3 id="Select_statements">Select statements</h3>

<p>
A "select" statement chooses which of a set of possible
<a href="#Send_statements">send</a> or
<a href="#Receive_operator">receive</a>
operations will proceed.
It looks similar to a
<a href="#Switch_statements">"switch"</a> statement but with the
cases all referring to communication operations.
</p>

<pre class="ebnf">
SelectStmt = "select" "{" { CommClause } "}" .
CommClause = CommCase ":" StatementList .
CommCase   = "case" ( SendStmt | RecvStmt ) | "default" .
RecvStmt   = [ ExpressionList "=" | IdentifierList ":=" ] RecvExpr .
RecvExpr   = Expression .
</pre>

<p>
A case with a RecvStmt may assign the result of a RecvExpr to one or
two variables, which may be declared using a
<a href="#Short_variable_declarations">short variable declaration</a>.
The RecvExpr must be a (possibly parenthesized) receive operation.
There can be at most one default case and it may appear anywhere
in the list of cases.
</p>

<p>
Execution of a "select" statement proceeds in several steps:
</p>

<ol>
<li>
For all the cases in the statement, the channel operands of receive operations
and the channel and right-hand-side expressions of send statements are
evaluated exactly once, in source order, upon entering the "select" statement.
The result is a set of channels to receive from or send to,
and the corresponding values to send.
Any side effects in that evaluation will occur irrespective of which (if any)
communication operation is selected to proceed.
Expressions on the left-hand side of a RecvStmt with a short variable declaration
or assignment are not yet evaluated.
</li>

<li>
If one or more of the communications can proceed,
a single one that can proceed is chosen via a uniform pseudo-random selection.
Otherwise, if there is a default case, that case is chosen.
If there is no default case, the "select" statement blocks until
at least one of the communications can proceed.
</li>

<li>
Unless the selected case is the default case, the respective communication
operation is executed.
</li>

<li>
If the selected case is a RecvStmt with a short variable declaration or
an assignment, the left-hand side expressions are evaluated and the
received value (or values) are assigned.
</li>

<li>
The statement list of the selected case is executed.
</li>
</ol>

<p>
Since communication on <code>nil</code> channels can never proceed,
a select with only <code>nil</code> channels and no default case blocks forever.
</p>

<pre>
var a []int
var c, c1, c2, c3, c4 chan int
var i1, i2 int
select {
case i1 = &lt;-c1:
	print("received ", i1, " from c1\n")
case c2 &lt;- i2:
	print("sent ", i2, " to c2\n")
case i3, ok := (&lt;-c3):  // same as: i3, ok := &lt;-c3
	if ok {
		print("received ", i3, " from c3\n")
	} else {
		print("c3 is closed\n")
	}
case a[f()] = &lt;-c4:
	// same as:
	// case t := &lt;-c4
	//	a[f()] = t
default:
	print("no communication\n")
}

for {  // send random sequence of bits to c
	select {
	case c &lt;- 0:  // note: no statement, no fallthrough, no folding of cases
	case c &lt;- 1:
	}
}

select {}  // block forever
</pre>


<h3 id="Return_statements">Return statements</h3>

<p>
A "return" statement in a function <code>F</code> terminates the execution
of <code>F</code>, and optionally provides one or more result values.
Any functions <a href="#Defer_statements">deferred</a> by <code>F</code>
are executed before <code>F</code> returns to its caller.
</p>

<pre class="ebnf">
ReturnStmt = "return" [ ExpressionList ] .
</pre>

<p>
In a function without a result type, a "return" statement must not
specify any result values.
</p>
<pre>
func noResult() {
	return
}
</pre>

<p>
There are three ways to return values from a function with a result
type:
</p>

<ol>
	<li>The return value or values may be explicitly listed
		in the "return" statement. Each expression must be single-valued
		and <a href="#Assignability">assignable</a>
		to the corresponding element of the function's result type.
<pre>
func simpleF() int {
	return 2
}

func complexF1() (re float64, im float64) {
	return -7.0, -4.0
}
</pre>
	</li>
	<li>The expression list in the "return" statement may be a single
		call to a multi-valued function. The effect is as if each value
		returned from that function were assigned to a temporary
		variable with the type of the respective value, followed by a
		"return" statement listing these variables, at which point the
		rules of the previous case apply.
<pre>
func complexF2() (re float64, im float64) {
	return complexF1()
}
</pre>
	</li>
	<li>The expression list may be empty if the function's result
		type specifies names for its <a href="#Function_types">result parameters</a>.
		The result parameters act as ordinary local variables
		and the function may assign values to them as necessary.
		The "return" statement returns the values of these variables.
<pre>
func complexF3() (re float64, im float64) {
	re = 7.0
	im = 4.0
	return
}

func (devnull) Write(p []byte) (n int, _ error) {
	n = len(p)
	return
}
</pre>
	</li>
</ol>

<p>
Regardless of how they are declared, all the result values are initialized to
the <a href="#The_zero_value">zero values</a> for their type upon entry to the
function. A "return" statement that specifies results sets the result parameters before
any deferred functions are executed.
</p>

<p>
Implementation restriction: A compiler may disallow an empty expression list
in a "return" statement if a different entity (constant, type, or variable)
with the same name as a result parameter is in
<a href="#Declarations_and_scope">scope</a> at the place of the return.
</p>

<pre>
func f(n int) (res int, err error) {
	if _, err := f(n-1); err != nil {
		return  // invalid return statement: err is shadowed
	}
	return
}
</pre>

<h3 id="Break_statements">Break statements</h3>

<p>
A "break" statement terminates execution of the innermost
<a href="#For_statements">"for"</a>,
<a href="#Switch_statements">"switch"</a>, or
<a href="#Select_statements">"select"</a> statement
within the same function.
</p>

<pre class="ebnf">
BreakStmt = "break" [ Label ] .
</pre>

<p>
If there is a label, it must be that of an enclosing
"for", "switch", or "select" statement,
and that is the one whose execution terminates.
</p>

<pre>
OuterLoop:
	for i = 0; i &lt; n; i++ {
		for j = 0; j &lt; m; j++ {
			switch a[i][j] {
			case nil:
				state = Error
				break OuterLoop
			case item:
				state = Found
				break OuterLoop
			}
		}
	}
</pre>

<h3 id="Continue_statements">Continue statements</h3>

<p>
A "continue" statement begins the next iteration of the
innermost <a href="#For_statements">"for" loop</a> at its post statement.
The "for" loop must be within the same function.
</p>

<pre class="ebnf">
ContinueStmt = "continue" [ Label ] .
</pre>

<p>
If there is a label, it must be that of an enclosing
"for" statement, and that is the one whose execution
advances.
</p>

<pre>
RowLoop:
	for y, row := range rows {
		for x, data := range row {
			if data == endOfRow {
				continue RowLoop
			}
			row[x] = data + bias(x, y)
		}
	}
</pre>

<h3 id="Goto_statements">Goto statements</h3>

<p>
A "goto" statement transfers control to the statement with the corresponding label
within the same function.
</p>

<pre class="ebnf">
GotoStmt = "goto" Label .
</pre>

<pre>
goto Error
</pre>

<p>
Executing the "goto" statement must not cause any variables to come into
<a href="#Declarations_and_scope">scope</a> that were not already in scope at the point of the goto.
For instance, this example:
</p>

<pre>
	goto L  // BAD
	v := 3
L:
</pre>

<p>
is erroneous because the jump to label <code>L</code> skips
the creation of <code>v</code>.
</p>

<p>
A "goto" statement outside a <a href="#Blocks">block</a> cannot jump to a label inside that block.
For instance, this example:
</p>

<pre>
if n%2 == 1 {
	goto L1
}
for n &gt; 0 {
	f()
	n--
L1:
	f()
	n--
}
</pre>

<p>
is erroneous because the label <code>L1</code> is inside
the "for" statement's block but the <code>goto</code> is not.
</p>

<h3 id="Fallthrough_statements">Fallthrough statements</h3>

<p>
A "fallthrough" statement transfers control to the first statement of the
next case clause in a <a href="#Expression_switches">expression "switch" statement</a>.
It may be used only as the final non-empty statement in such a clause.
</p>

<pre class="ebnf">
FallthroughStmt = "fallthrough" .
</pre>


<h3 id="Defer_statements">Defer statements</h3>

<p>
A "defer" statement invokes a function whose execution is deferred
to the moment the surrounding function returns, either because the
surrounding function executed a <a href="#Return_statements">return statement</a>,
reached the end of its <a href="#Function_declarations">function body</a>,
or because the corresponding goroutine is <a href="#Handling_panics">panicking</a>.
</p>

<pre class="ebnf">
DeferStmt = "defer" Expression .
</pre>

<p>
The expression must be a function or method call; it cannot be parenthesized.
Calls of built-in functions are restricted as for
<a href="#Expression_statements">expression statements</a>.
</p>

<p>
Each time a "defer" statement
executes, the function value and parameters to the call are
<a href="#Calls">evaluated as usual</a>
and saved anew but the actual function is not invoked.
Instead, deferred functions are invoked immediately before
the surrounding function returns, in the reverse order
they were deferred.
If a deferred function value evaluates
to <code>nil</code>, execution <a href="#Handling_panics">panics</a>
when the function is invoked, not when the "defer" statement is executed.
</p>

<p>
For instance, if the deferred function is
a <a href="#Function_literals">function literal</a> and the surrounding
function has <a href="#Function_types">named result parameters</a> that
are in scope within the literal, the deferred function may access and modify
the result parameters before they are returned.
If the deferred function has any return values, they are discarded when
the function completes.
(See also the section on <a href="#Handling_panics">handling panics</a>.)
</p>

<pre>
lock(l)
defer unlock(l)  // unlocking happens before surrounding function returns

// prints 3 2 1 0 before surrounding function returns
for i := 0; i &lt;= 3; i++ {
	defer fmt.Print(i)
}

// f returns 1
func f() (result int) {
	defer func() {
		result++
	}()
	return 0
}
</pre>

<h2 id="Built-in_functions">Built-in functions</h2>

<p>
Built-in functions are
<a href="#Predeclared_identifiers">predeclared</a>.
They are called like any other function but some of them
accept a type instead of an expression as the first argument.
</p>

<p>
The built-in functions do not have standard Go types,
so they can only appear in <a href="#Calls">call expressions</a>;
they cannot be used as function values.
</p>

<h3 id="Close">Close</h3>

<p>
For a channel <code>c</code>, the built-in function <code>close(c)</code>
records that no more values will be sent on the channel.
It is an error if <code>c</code> is a receive-only channel.
Sending to or closing a closed channel causes a <a href="#Run_time_panics">run-time panic</a>.
Closing the nil channel also causes a <a href="#Run_time_panics">run-time panic</a>.
After calling <code>close</code>, and after any previously
sent values have been received, receive operations will return
the zero value for the channel's type without blocking.
The multi-valued <a href="#Receive_operator">receive operation</a>
returns a received value along with an indication of whether the channel is closed.
</p>


<h3 id="Length_and_capacity">Length and capacity</h3>

<p>
The built-in functions <code>len</code> and <code>cap</code> take arguments
of various types and return a result of type <code>int</code>.
The implementation guarantees that the result always fits into an <code>int</code>.
</p>

<pre class="grammar">
Call      Argument type    Result

len(s)    string type      string length in bytes
          [n]T, *[n]T      array length (== n)
          []T              slice length
          map[K]T          map length (number of defined keys)
          chan T           number of elements queued in channel buffer

cap(s)    [n]T, *[n]T      array length (== n)
          []T              slice capacity
          chan T           channel buffer capacity
</pre>

<p>
The capacity of a slice is the number of elements for which there is
space allocated in the underlying array.
At any time the following relationship holds:
</p>

<pre>
0 &lt;= len(s) &lt;= cap(s)
</pre>

<p>
The length of a <code>nil</code> slice, map or channel is 0.
The capacity of a <code>nil</code> slice or channel is 0.
</p>

<p>
The expression <code>len(s)</code> is <a href="#Constants">constant</a> if
<code>s</code> is a string constant. The expressions <code>len(s)</code> and
<code>cap(s)</code> are constants if the type of <code>s</code> is an array
or pointer to an array and the expression <code>s</code> does not contain
<a href="#Receive_operator">channel receives</a> or (non-constant)
<a href="#Calls">function calls</a>; in this case <code>s</code> is not evaluated.
Otherwise, invocations of <code>len</code> and <code>cap</code> are not
constant and <code>s</code> is evaluated.
</p>

<pre>
const (
	c1 = imag(2i)                    // imag(2i) = 2.0 is a constant
	c2 = len([10]float64{2})         // [10]float64{2} contains no function calls
	c3 = len([10]float64{c1})        // [10]float64{c1} contains no function calls
	c4 = len([10]float64{imag(2i)})  // imag(2i) is a constant and no function call is issued
	c5 = len([10]float64{imag(z)})   // invalid: imag(x) is a (non-constant) function call
)
var z complex128
</pre>

<h3 id="Allocation">Allocation</h3>

<p>
The built-in function <code>new</code> takes a type <code>T</code>,
allocates storage for a <a href="#Variables">variable</a> of that type
at run time, and returns a value of type <code>*T</code>
<a href="#Pointer_types">pointing</a> to it.
The variable is initialized as described in the section on
<a href="#The_zero_value">initial values</a>.
</p>

<pre class="grammar">
new(T)
</pre>

<p>
For instance
</p>

<pre>
type S struct { a int; b float64 }
new(S)
</pre>

<p>
allocates storage for a variable of type <code>S</code>,
initializes it (<code>a=0</code>, <code>b=0.0</code>),
and returns a value of type <code>*S</code> containing the address
of the location.
</p>

<h3 id="Making_slices_maps_and_channels">Making slices, maps and channels</h3>

<p>
The built-in function <code>make</code> takes a type <code>T</code>,
which must be a slice, map or channel type,
optionally followed by a type-specific list of expressions.
It returns a value of type <code>T</code> (not <code>*T</code>).
The memory is initialized as described in the section on
<a href="#The_zero_value">initial values</a>.
</p>

<pre class="grammar">
Call             Type T     Result

make(T, n)       slice      slice of type T with length n and capacity n
make(T, n, m)    slice      slice of type T with length n and capacity m

make(T)          map        map of type T
make(T, n)       map        map of type T with initial space for n elements

make(T)          channel    unbuffered channel of type T
make(T, n)       channel    buffered channel of type T, buffer size n
</pre>


<p>
The size arguments <code>n</code> and <code>m</code> must be of integer type or untyped.
A <a href="#Constants">constant</a> size argument must be non-negative and
representable by a value of type <code>int</code>.
If both <code>n</code> and <code>m</code> are provided and are constant, then
<code>n</code> must be no larger than <code>m</code>.
If <code>n</code> is negative or larger than <code>m</code> at run time,
a <a href="#Run_time_panics">run-time panic</a> occurs.
</p>

<pre>
s := make([]int, 10, 100)       // slice with len(s) == 10, cap(s) == 100
s := make([]int, 1e3)           // slice with len(s) == cap(s) == 1000
s := make([]int, 1&lt;&lt;63)         // illegal: len(s) is not representable by a value of type int
s := make([]int, 10, 0)         // illegal: len(s) > cap(s)
c := make(chan int, 10)         // channel with a buffer size of 10
m := make(map[string]int, 100)  // map with initial space for 100 elements
</pre>


<h3 id="Appending_and_copying_slices">Appending to and copying slices</h3>

<p>
The built-in functions <code>append</code> and <code>copy</code> assist in
common slice operations.
For both functions, the result is independent of whether the memory referenced
by the arguments overlaps.
</p>

<p>
The <a href="#Function_types">variadic</a> function <code>append</code>
appends zero or more values <code>x</code>
to <code>s</code> of type <code>S</code>, which must be a slice type, and
returns the resulting slice, also of type <code>S</code>.
The values <code>x</code> are passed to a parameter of type <code>...T</code>
where <code>T</code> is the <a href="#Slice_types">element type</a> of
<code>S</code> and the respective
<a href="#Passing_arguments_to_..._parameters">parameter passing rules</a> apply.
As a special case, <code>append</code> also accepts a first argument
assignable to type <code>[]byte</code> with a second argument of
string type followed by <code>...</code>. This form appends the
bytes of the string.
</p>

<pre class="grammar">
append(s S, x ...T) S  // T is the element type of S
</pre>

<p>
If the capacity of <code>s</code> is not large enough to fit the additional
values, <code>append</code> allocates a new, sufficiently large underlying
array that fits both the existing slice elements and the additional values.
Otherwise, <code>append</code> re-uses the underlying array.
</p>

<pre>
s0 := []int{0, 0}
s1 := append(s0, 2)                // append a single element     s1 == []int{0, 0, 2}
s2 := append(s1, 3, 5, 7)          // append multiple elements    s2 == []int{0, 0, 2, 3, 5, 7}
s3 := append(s2, s0...)            // append a slice              s3 == []int{0, 0, 2, 3, 5, 7, 0, 0}
s4 := append(s3[3:6], s3[2:]...)   // append overlapping slice    s4 == []int{3, 5, 7, 2, 3, 5, 7, 0, 0}

var t []interface{}
t = append(t, 42, 3.1415, "foo")                                  t == []interface{}{42, 3.1415, "foo"}

var b []byte
b = append(b, "bar"...)            // append string contents      b == []byte{'b', 'a', 'r' }
</pre>

<p>
The function <code>copy</code> copies slice elements from
a source <code>src</code> to a destination <code>dst</code> and returns the
number of elements copied.
Both arguments must have <a href="#Type_identity">identical</a> element type <code>T</code> and must be
<a href="#Assignability">assignable</a> to a slice of type <code>[]T</code>.
The number of elements copied is the minimum of
<code>len(src)</code> and <code>len(dst)</code>.
As a special case, <code>copy</code> also accepts a destination argument assignable
to type <code>[]byte</code> with a source argument of a string type.
This form copies the bytes from the string into the byte slice.
</p>

<pre class="grammar">
copy(dst, src []T) int
copy(dst []byte, src string) int
</pre>

<p>
Examples:
</p>

<pre>
var a = [...]int{0, 1, 2, 3, 4, 5, 6, 7}
var s = make([]int, 6)
var b = make([]byte, 5)
n1 := copy(s, a[0:])            // n1 == 6, s == []int{0, 1, 2, 3, 4, 5}
n2 := copy(s, s[2:])            // n2 == 4, s == []int{2, 3, 4, 5, 4, 5}
n3 := copy(b, "Hello, World!")  // n3 == 5, b == []byte("Hello")
</pre>


<h3 id="Deletion_of_map_elements">Deletion of map elements</h3>

<p>
The built-in function <code>delete</code> removes the element with key
<code>k</code> from a <a href="#Map_types">map</a> <code>m</code>. The
type of <code>k</code> must be <a href="#Assignability">assignable</a>
to the key type of <code>m</code>.
</p>

<pre class="grammar">
delete(m, k)  // remove element m[k] from map m
</pre>

<p>
If the map <code>m</code> is <code>nil</code> or the element <code>m[k]</code>
does not exist, <code>delete</code> is a no-op.
</p>


<h3 id="Complex_numbers">Manipulating complex numbers</h3>

<p>
Three functions assemble and disassemble complex numbers.
The built-in function <code>complex</code> constructs a complex
value from a floating-point real and imaginary part, while
<code>real</code> and <code>imag</code>
extract the real and imaginary parts of a complex value.
</p>

<pre class="grammar">
complex(realPart, imaginaryPart floatT) complexT
real(complexT) floatT
imag(complexT) floatT
</pre>

<p>
The type of the arguments and return value correspond.
For <code>complex</code>, the two arguments must be of the same
floating-point type and the return type is the complex type
with the corresponding floating-point constituents:
<code>complex64</code> for <code>float32</code>,
<code>complex128</code> for <code>float64</code>.
The <code>real</code> and <code>imag</code> functions
together form the inverse, so for a complex value <code>z</code>,
<code>z</code> <code>==</code> <code>complex(real(z),</code> <code>imag(z))</code>.
</p>

<p>
If the operands of these functions are all constants, the return
value is a constant.
</p>

<pre>
var a = complex(2, -2)             // complex128
var b = complex(1.0, -1.4)         // complex128
x := float32(math.Cos(math.Pi/2))  // float32
var c64 = complex(5, -x)           // complex64
var im = imag(b)                   // float64
var rl = real(c64)                 // float32
</pre>

<h3 id="Handling_panics">Handling panics</h3>

<p> Two built-in functions, <code>panic</code> and <code>recover</code>,
assist in reporting and handling <a href="#Run_time_panics">run-time panics</a>
and program-defined error conditions.
</p>

<pre class="grammar">
func panic(interface{})
func recover() interface{}
</pre>

<p>
While executing a function <code>F</code>,
an explicit call to <code>panic</code> or a <a href="#Run_time_panics">run-time panic</a>
terminates the execution of <code>F</code>.
Any functions <a href="#Defer_statements">deferred</a> by <code>F</code>
are then executed as usual.
Next, any deferred functions run by <code>F's</code> caller are run,
and so on up to any deferred by the top-level function in the executing goroutine.
At that point, the program is terminated and the error
condition is reported, including the value of the argument to <code>panic</code>.
This termination sequence is called <i>panicking</i>.
</p>

<pre>
panic(42)
panic("unreachable")
panic(Error("cannot parse"))
</pre>

<p>
The <code>recover</code> function allows a program to manage behavior
of a panicking goroutine.
Suppose a function <code>G</code> defers a function <code>D</code> that calls
<code>recover</code> and a panic occurs in a function on the same goroutine in which <code>G</code>
is executing.
When the running of deferred functions reaches <code>D</code>,
the return value of <code>D</code>'s call to <code>recover</code> will be the value passed to the call of <code>panic</code>.
If <code>D</code> returns normally, without starting a new
<code>panic</code>, the panicking sequence stops. In that case,
the state of functions called between <code>G</code> and the call to <code>panic</code>
is discarded, and normal execution resumes.
Any functions deferred by <code>G</code> before <code>D</code> are then run and <code>G</code>'s
execution terminates by returning to its caller.
</p>

<p>
The return value of <code>recover</code> is <code>nil</code> if any of the following conditions holds:
</p>
<ul>
<li>
<code>panic</code>'s argument was <code>nil</code>;
</li>
<li>
the goroutine is not panicking;
</li>
<li>
<code>recover</code> was not called directly by a deferred function.
</li>
</ul>

<p>
The <code>protect</code> function in the example below invokes
the function argument <code>g</code> and protects callers from
run-time panics raised by <code>g</code>.
</p>

<pre>
func protect(g func()) {
	defer func() {
		log.Println("done")  // Println executes normally even if there is a panic
		if x := recover(); x != nil {
			log.Printf("run time panic: %v", x)
		}
	}()
	log.Println("start")
	g()
}
</pre>


<h3 id="Bootstrapping">Bootstrapping</h3>

<p>
Current implementations provide several built-in functions useful during
bootstrapping. These functions are documented for completeness but are not
guaranteed to stay in the language. They do not return a result.
</p>

<pre class="grammar">
Function   Behavior

print      prints all arguments; formatting of arguments is implementation-specific
println    like print but prints spaces between arguments and a newline at the end
</pre>


<h2 id="Packages">Packages</h2>

<p>
Go programs are constructed by linking together <i>packages</i>.
A package in turn is constructed from one or more source files
that together declare constants, types, variables and functions
belonging to the package and which are accessible in all files
of the same package. Those elements may be
<a href="#Exported_identifiers">exported</a> and used in another package.
</p>

<h3 id="Source_file_organization">Source file organization</h3>

<p>
Each source file consists of a package clause defining the package
to which it belongs, followed by a possibly empty set of import
declarations that declare packages whose contents it wishes to use,
followed by a possibly empty set of declarations of functions,
types, variables, and constants.
</p>

<pre class="ebnf">
SourceFile       = PackageClause ";" { ImportDecl ";" } { TopLevelDecl ";" } .
</pre>

<h3 id="Package_clause">Package clause</h3>

<p>
A package clause begins each source file and defines the package
to which the file belongs.
</p>

<pre class="ebnf">
PackageClause  = "package" PackageName .
PackageName    = identifier .
</pre>

<p>
The PackageName must not be the <a href="#Blank_identifier">blank identifier</a>.
</p>

<pre>
package math
</pre>

<p>
A set of files sharing the same PackageName form the implementation of a package.
An implementation may require that all source files for a package inhabit the same directory.
</p>

<h3 id="Import_declarations">Import declarations</h3>

<p>
An import declaration states that the source file containing the declaration
depends on functionality of the <i>imported</i> package
(<a href="#Program_initialization_and_execution">¬ßProgram initialization and execution</a>)
and enables access to <a href="#Exported_identifiers">exported</a> identifiers
of that package.
The import names an identifier (PackageName) to be used for access and an ImportPath
that specifies the package to be imported.
</p>

<pre class="ebnf">
ImportDecl       = "import" ( ImportSpec | "(" { ImportSpec ";" } ")" ) .
ImportSpec       = [ "." | PackageName ] ImportPath .
ImportPath       = string_lit .
</pre>

<p>
The PackageName is used in <a href="#Qualified_identifiers">qualified identifiers</a>
to access exported identifiers of the package within the importing source file.
It is declared in the <a href="#Blocks">file block</a>.
If the PackageName is omitted, it defaults to the identifier specified in the
<a href="#Package_clause">package clause</a> of the imported package.
If an explicit period (<code>.</code>) appears instead of a name, all the
package's exported identifiers declared in that package's
<a href="#Blocks">package block</a> will be declared in the importing source
file's file block and must be accessed without a qualifier.
</p>

<p>
The interpretation of the ImportPath is implementation-dependent but
it is typically a substring of the full file name of the compiled
package and may be relative to a repository of installed packages.
</p>

<p>
Implementation restriction: A compiler may restrict ImportPaths to
non-empty strings using only characters belonging to
<a href="http://www.unicode.org/versions/Unicode6.3.0/">Unicode's</a>
L, M, N, P, and S general categories (the Graphic characters without
spaces) and may also exclude the characters
<code>!"#$%&amp;'()*,:;&lt;=&gt;?[\]^`{|}</code>
and the Unicode replacement character U+FFFD.
</p>

<p>
Assume we have compiled a package containing the package clause
<code>package math</code>, which exports function <code>Sin</code>, and
installed the compiled package in the file identified by
<code>"lib/math"</code>.
This table illustrates how <code>Sin</code> is accessed in files
that import the package after the
various types of import declaration.
</p>

<pre class="grammar">
Import declaration          Local name of Sin

import   "lib/math"         math.Sin
import m "lib/math"         m.Sin
import . "lib/math"         Sin
</pre>

<p>
An import declaration declares a dependency relation between
the importing and imported package.
It is illegal for a package to import itself, directly or indirectly,
or to directly import a package without
referring to any of its exported identifiers. To import a package solely for
its side-effects (initialization), use the <a href="#Blank_identifier">blank</a>
identifier as explicit package name:
</p>

<pre>
import _ "lib/math"
</pre>


<h3 id="An_example_package">An example package</h3>

<p>
Here is a complete Go package that implements a concurrent prime sieve.
</p>

<pre>
package main

import "fmt"

// Send the sequence 2, 3, 4, ‚Ä¶ to channel 'ch'.
func generate(ch chan&lt;- int) {
	for i := 2; ; i++ {
		ch &lt;- i  // Send 'i' to channel 'ch'.
	}
}

// Copy the values from channel 'src' to channel 'dst',
// removing those divisible by 'prime'.
func filter(src &lt;-chan int, dst chan&lt;- int, prime int) {
	for i := range src {  // Loop over values received from 'src'.
		if i%prime != 0 {
			dst &lt;- i  // Send 'i' to channel 'dst'.
		}
	}
}

// The prime sieve: Daisy-chain filter processes together.
func sieve() {
	ch := make(chan int)  // Create a new channel.
	go generate(ch)       // Start generate() as a subprocess.
	for {
		prime := &lt;-ch
		fmt.Print(prime, "\n")
		ch1 := make(chan int)
		go filter(ch, ch1, prime)
		ch = ch1
	}
}

func main() {
	sieve()
}
</pre>

<h2 id="Program_initialization_and_execution">Program initialization and execution</h2>

<h3 id="The_zero_value">The zero value</h3>
<p>
When storage is allocated for a <a href="#Variables">variable</a>,
either through a declaration or a call of <code>new</code>, or when
a new value is created, either through a composite literal or a call
of <code>make</code>,
and no explicit initialization is provided, the variable or value is
given a default value.  Each element of such a variable or value is
set to the <i>zero value</i> for its type: <code>false</code> for booleans,
<code>0</code> for integers, <code>0.0</code> for floats, <code>""</code>
for strings, and <code>nil</code> for pointers, functions, interfaces, slices, channels, and maps.
This initialization is done recursively, so for instance each element of an
array of structs will have its fields zeroed if no value is specified.
</p>
<p>
These two simple declarations are equivalent:
</p>

<pre>
var i int
var i int = 0
</pre>

<p>
After
</p>

<pre>
type T struct { i int; f float64; next *T }
t := new(T)
</pre>

<p>
the following holds:
</p>

<pre>
t.i == 0
t.f == 0.0
t.next == nil
</pre>

<p>
The same would also be true after
</p>

<pre>
var t T
</pre>

<h3 id="Package_initialization">Package initialization</h3>

<p>
Within a package, package-level variables are initialized in
<i>declaration order</i> but after any of the variables
they <i>depend</i> on.
</p>

<p>
More precisely, a package-level variable is considered <i>ready for
initialization</i> if it is not yet initialized and either has
no <a href="#Variable_declarations">initialization expression</a> or
its initialization expression has no dependencies on uninitialized variables.
Initialization proceeds by repeatedly initializing the next package-level
variable that is earliest in declaration order and ready for initialization,
until there are no variables ready for initialization.
</p>

<p>
If any variables are still uninitialized when this
process ends, those variables are part of one or more initialization cycles,
and the program is not valid.
</p>

<p>
The declaration order of variables declared in multiple files is determined
by the order in which the files are presented to the compiler: Variables
declared in the first file are declared before any of the variables declared
in the second file, and so on.
</p>

<p>
Dependency analysis does not rely on the actual values of the
variables, only on lexical <i>references</i> to them in the source,
analyzed transitively. For instance, if a variable <code>x</code>'s
initialization expression refers to a function whose body refers to
variable <code>y</code> then <code>x</code> depends on <code>y</code>.
Specifically:
</p>

<ul>
<li>
A reference to a variable or function is an identifier denoting that
variable or function.
</li>

<li>
A reference to a method <code>m</code> is a
<a href="#Method_values">method value</a> or
<a href="#Method_expressions">method expression</a> of the form
<code>t.m</code>, where the (static) type of <code>t</code> is
not an interface type, and the method <code>m</code> is in the
<a href="#Method_sets">method set</a> of <code>t</code>.
It is immaterial whether the resulting function value
<code>t.m</code> is invoked.
</li>

<li>
A variable, function, or method <code>x</code> depends on a variable
<code>y</code> if <code>x</code>'s initialization expression or body
(for functions and methods) contains a reference to <code>y</code>
or to a function or method that depends on <code>y</code>.
</li>
</ul>

<p>
Dependency analysis is performed per package; only references referring
to variables, functions, and methods declared in the current package
are considered.
</p>

<p>
For example, given the declarations
</p>

<pre>
var (
	a = c + b
	b = f()
	c = f()
	d = 3
)

func f() int {
	d++
	return d
}
</pre>

<p>
the initialization order is <code>d</code>, <code>b</code>, <code>c</code>, <code>a</code>.
</p>

<p>
Variables may also be initialized using functions named <code>init</code>
declared in the package block, with no arguments and no result parameters.
</p>

<pre>
func init() { ‚Ä¶ }
</pre>

<p>
Multiple such functions may be defined, even within a single
source file. The <code>init</code> identifier is not
<a href="#Declarations_and_scope">declared</a> and thus
<code>init</code> functions cannot be referred to from anywhere
in a program.
</p>

<p>
A package with no imports is initialized by assigning initial values
to all its package-level variables followed by calling all <code>init</code>
functions in the order they appear in the source, possibly in multiple files,
as presented to the compiler.
If a package has imports, the imported packages are initialized
before initializing the package itself. If multiple packages import
a package, the imported package will be initialized only once.
The importing of packages, by construction, guarantees that there
can be no cyclic initialization dependencies.
</p>

<p>
Package initialization&mdash;variable initialization and the invocation of
<code>init</code> functions&mdash;happens in a single goroutine,
sequentially, one package at a time.
An <code>init</code> function may launch other goroutines, which can run
concurrently with the initialization code. However, initialization
always sequences
the <code>init</code> functions: it will not invoke the next one
until the previous one has returned.
</p>

<p>
To ensure reproducible initialization behavior, build systems are encouraged
to present multiple files belonging to the same package in lexical file name
order to a compiler.
</p>


<h3 id="Program_execution">Program execution</h3>
<p>
A complete program is created by linking a single, unimported package
called the <i>main package</i> with all the packages it imports, transitively.
The main package must
have package name <code>main</code> and
declare a function <code>main</code> that takes no
arguments and returns no value.
</p>

<pre>
func main() { ‚Ä¶ }
</pre>

<p>
Program execution begins by initializing the main package and then
invoking the function <code>main</code>.
When that function invocation returns, the program exits.
It does not wait for other (non-<code>main</code>) goroutines to complete.
</p>

<h2 id="Errors">Errors</h2>

<p>
The predeclared type <code>error</code> is defined as
</p>

<pre>
type error interface {
	Error() string
}
</pre>

<p>
It is the conventional interface for representing an error condition,
with the nil value representing no error.
For instance, a function to read data from a file might be defined:
</p>

<pre>
func Read(f *File, b []byte) (n int, err error)
</pre>

<h2 id="Run_time_panics">Run-time panics</h2>

<p>
Execution errors such as attempting to index an array out
of bounds trigger a <i>run-time panic</i> equivalent to a call of
the built-in function <a href="#Handling_panics"><code>panic</code></a>
with a value of the implementation-defined interface type <code>runtime.Error</code>.
That type satisfies the predeclared interface type
<a href="#Errors"><code>error</code></a>.
The exact error values that
represent distinct run-time error conditions are unspecified.
</p>

<pre>
package runtime

type Error interface {
	error
	// and perhaps other methods
}
</pre>

<h2 id="System_considerations">System considerations</h2>

<h3 id="Package_unsafe">Package <code>unsafe</code></h3>

<p>
The built-in package <code>unsafe</code>, known to the compiler,
provides facilities for low-level programming including operations
that violate the type system. A package using <code>unsafe</code>
must be vetted manually for type safety and may not be portable.
The package provides the following interface:
</p>

<pre class="grammar">
package unsafe

type ArbitraryType int  // shorthand for an arbitrary Go type; it is not a real type
type Pointer *ArbitraryType

func Alignof(variable ArbitraryType) uintptr
func Offsetof(selector ArbitraryType) uintptr
func Sizeof(variable ArbitraryType) uintptr
</pre>

<p>
A <code>Pointer</code> is a <a href="#Pointer_types">pointer type</a> but a <code>Pointer</code>
value may not be <a href="#Address_operators">dereferenced</a>.
Any pointer or value of <a href="#Types">underlying type</a> <code>uintptr</code> can be converted to
a <code>Pointer</code> type and vice versa.
The effect of converting between <code>Pointer</code> and <code>uintptr</code> is implementation-defined.
</p>

<pre>
var f float64
bits = *(*uint64)(unsafe.Pointer(&amp;f))

type ptr unsafe.Pointer
bits = *(*uint64)(ptr(&amp;f))

var p ptr = nil
</pre>

<p>
The functions <code>Alignof</code> and <code>Sizeof</code> take an expression <code>x</code>
of any type and return the alignment or size, respectively, of a hypothetical variable <code>v</code>
as if <code>v</code> was declared via <code>var v = x</code>.
</p>
<p>
The function <code>Offsetof</code> takes a (possibly parenthesized) <a href="#Selectors">selector</a>
<code>s.f</code>, denoting a field <code>f</code> of the struct denoted by <code>s</code>
or <code>*s</code>, and returns the field offset in bytes relative to the struct's address.
If <code>f</code> is an <a href="#Struct_types">embedded field</a>, it must be reachable
without pointer indirections through fields of the struct.
For a struct <code>s</code> with field <code>f</code>:
</p>

<pre>
uintptr(unsafe.Pointer(&amp;s)) + unsafe.Offsetof(s.f) == uintptr(unsafe.Pointer(&amp;s.f))
</pre>

<p>
Computer architectures may require memory addresses to be <i>aligned</i>;
that is, for addresses of a variable to be a multiple of a factor,
the variable's type's <i>alignment</i>.  The function <code>Alignof</code>
takes an expression denoting a variable of any type and returns the
alignment of the (type of the) variable in bytes.  For a variable
<code>x</code>:
</p>

<pre>
uintptr(unsafe.Pointer(&amp;x)) % unsafe.Alignof(x) == 0
</pre>

<p>
Calls to <code>Alignof</code>, <code>Offsetof</code>, and
<code>Sizeof</code> are compile-time constant expressions of type <code>uintptr</code>.
</p>

<h3 id="Size_and_alignment_guarantees">Size and alignment guarantees</h3>

<p>
For the <a href="#Numeric_types">numeric types</a>, the following sizes are guaranteed:
</p>

<pre class="grammar">
type                                 size in bytes

byte, uint8, int8                     1
uint16, int16                         2
uint32, int32, float32                4
uint64, int64, float64, complex64     8
complex128                           16
</pre>

<p>
The following minimal alignment properties are guaranteed:
</p>
<ol>
<li>For a variable <code>x</code> of any type: <code>unsafe.Alignof(x)</code> is at least 1.
</li>

<li>For a variable <code>x</code> of struct type: <code>unsafe.Alignof(x)</code> is the largest of
   all the values <code>unsafe.Alignof(x.f)</code> for each field <code>f</code> of <code>x</code>, but at least 1.
</li>

<li>For a variable <code>x</code> of array type: <code>unsafe.Alignof(x)</code> is the same as
   <code>unsafe.Alignof(x[0])</code>, but at least 1.
</li>
</ol>

<p>
A struct or array type has size zero if it contains no fields (or elements, respectively) that have a size greater than zero. Two distinct zero-size variables may have the same address in memory.
</p>
                                                                                                                                                                                                                                                                                                                                                               root/go1.4/doc/gopher/                                                                              0040755 0000000 0000000 00000000000 12600426226 013114  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        root/go1.4/doc/gopher/README                                                                        0100644 0000000 0000000 00000000335 12600426226 013772  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        The Go gopher was designed by Renee French. (http://reneefrench.blogspot.com/)
The design is licensed under the Creative Commons 3.0 Attributions license.
Read this article for more details: http://blog.golang.org/gopher
                                                                                                                                                                                                                                                                                                   root/go1.4/doc/gopher/appenginegopher.jpg                                                           0100644 0000000 0000000 00000411312 12600426226 016770  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ˇÿˇ‡ JFIF ÑÑ  ˇ·æExif  MM *                  b       j(       1       r2       êái       §   – âT,  ' âT,  'Adobe Photoshop CS2 Macintosh 2011:04:07 18:12:56  †    ˇˇ  †      ó†      Ö                          &(             .      à       H      H   ˇÿˇ‡ JFIF   H H  ˇÌ Adobe_CM ˇÓ Adobe dÄ   ˇ€ Ñ 			
ˇ¿  e †" ˇ›  
ˇƒ?          	
         	
 3 !1AQa"qÅ2ë°±B#$R¡b34rÇ—C%íS·Òcs5¢≤É&DìTdE¬£t6“U‚eÚ≥Ñ√”u„ÛF'î§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ7GWgwáóß∑«◊Á˜ 5 !1AQaq"2Åë°±B#¡R—3$b·rÇíCScs4Ò%¢≤É&5¬“DìT£dEU6te‚Ú≥Ñ√”u„ÛFî§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ'7GWgwáóß∑«ˇ⁄   ? ı*i™äôM,mUT– Î`kZ—µåcÌk’4íIJI$íRíI+/˘9w3Ω_mÆcdÌû¯o“))2√w÷Û…´ÍÊ0œ‰°kçX-?§o≥$6À3‹€+ÿÊ`Uu_È≤q‘+eˇ Y_Íe”f7C≠Á”∆∏YòZ}∂Â–Ë}=7Û™ƒªÙπøˆ™∫±øAìº÷µç`kD5£@ ÏSäÓÖ’2öhuº£πƒ∫¨&◊âPò«duˇ ÓESÎˇ V:5]3. ¨Ã≥ìsNm˜eË˛±Ìfu◊±õ˝=ñzNø—ÆùPÎÃc˙QcÃ1ÿ∑#[Â%5›ıGÍ´á¸èÇ<€èSO˘ÃcT]ıO•µÆñe‡∏˝ceﬁ∆¥è¢Ê„:◊·ª˙ñ„YWÚÆ;ú˙+sƒ9ÃipÛ#TDî‚9øZ˙x&∑Q÷Ëh$6œ’2πñèR∂ŸÅìfœ¯ôZ%Y∞êÃL⁄ÔÈôVø”™¨⁄˝6Ω˙mÆå ÕΩ?&À7˛é¨|ªm˛B◊C»∆« °¯˘52˙,l™∆á1√¡Ï|µ…)"Kü•ŸüW.uyvø+†ºÕVÎpß¸eÆó‰tÔÙY÷~õ˛÷˙òˇ ≠Sæ◊5Õi§H#PAIK§íI)I$íJˇ–ıTíI%)$ñOS˙ÀÅ”Ú>ƒ ÔœœÜ∏·aVnµ≠q_Ù)∆Ø›ÙÚn•%'Î=Sˆ^¨ ]ïìk€N&#kÆπˇ Õ‘◊ŸÏ≠∫:€Ìˇ è]◊ÉYLÈ˘WıÏ◊lf[≈7e„b÷ÿ∆«∂óbT◊‘◊˛ó+"øµ;”À…˙Œb„·˙äÆw\qÎ˝Ó°”s∞±Z˚i£’mNÃΩ¨ßŸáëîÔf'Ì/•Ù=U£◊3Ÿã’∫ŸXÏŒ¢¡nÏ
`‹Ïk[µ÷˚›]4Uˆ⁄1?X ∂öùÆø”˛â%;©.s5˝a¥æ∑’±˙£”≈ÿÁÀá±èÍ]Ié©Ô˙~Ã~ùEü´%∂˝N»m9ßıNΩYh5‰dcÁfTAˇ ∆fµÿˇ ˆ≈))Í≤∫ˇ B√ßô‘qqü˚∂ﬂ[˘∂=´+≠}k˙≠wJÕ∆gW√}óc€[ZÀÿ‚KòÊÄ=79¢g}OvK∞∫]X¯Y≠’ÿn«˚¸oñ„_V=÷{>∂-ÙîÛÙ}w˙©ËW=Nâ⁄Ÿ‘ò1«’˝s˙•g—Îc˙˜1ü˘ÒÕ[K'?Î&.aÈÿ’]‘∫ê€ø°Œ¨8ncÚÓ±’ca±ﬂ˜f˙ˇ ‡“Sc≠Ù\ÁÏ¡ÍŸOõM’ÿ~ÍﬁÂyryuıû°_≠õıG!√V’ìïSÏ¸pÆ•Øˇ Ø¨qù“:v]8Y=7´}VÃΩ€™8.u¯Æx˜©«∆vfKù>˙ˇ fXíûø™õüã“¸”ø[ŒèÙ59æé;øÊQgµˇ £»ƒ≈Œ•R»≈o’sV^ΩäÎÉ3pµ’ˆãõÉ?—YVEª≤±¢}ü’æ™©∫ø”÷¬ŒÀÈ¢ﬁµe¨Î˝30V◊u<6É}U÷_HıpÈﬂVF.3ùmŸ·l∫ºãÚˇ …ﬁüÛz_Y≥˙s~¨e‰ﬁ◊ÂÙ¸ä6=ÿ•é&¨Ä)ıÍ≤«≤üOmﬁß≠øŸ_ÈRS≤íÊpæ±uÃ.üK∫ˇ EÀ®‘ ŸïóC©…nËª%ÿ¯ó?)¥Ó˝+˝*.Ùÿ∫\¨|ÃzÚ±lm‘\–˙ÏañπßªJJJíI$ßˇ—ıTíI%5˙ém}?ßÂg⁄´ƒ¶Àﬁ%µµ÷∫?Õ\Œ/Qg’o®ø∑≤´~^]ı◊õö}≠}π9EüŒ=çŸ]u>ÊPœgË±Í]N^-9ò∑bd7}∫´[‚«Ç«∑¸◊.:ŒµÖ—:ﬂW~¥V«[âÜˆc⁄3È°õiÙ,{û÷Ê9å•ó„>œ[Ì/ﬂGÊ$¶øK˙¡X«ˇ ûôò~õ©`Ë7‘kΩLãﬁ⁄-ΩπWOø*ÔK˝¶«£-i_ëÖıS˘Ωôs2∑fı,€‰˚+ˆ;*Í⁄ÊøÏî=Ï√È]6ß≥’±ı‚”ˇ jÛ+Øıjå0ˇ ´Ω#∆=Ω'Ã‹∫È{lkrÏmXÃıYw”˚gT{œU˙ì≠π’f\Z’æ±—Üe¿c`Ym8¯ﬁÛµ≠∑;‹ü¯ÃÀS£ı_Í•Ìs:Ô÷g˛ªh‹œ\á∑§˙å£∂µîU{?√[ML˝/©Ë~è˘Ó≠$íSO©Ùéù’±∆>}-πç!ıªP˙ﬁ>ç¥\Õ∂—k“Tıü–ÚÛ1sØ˙Ω‘≠vM¯Ï‡Ê<◊‚ìÈ˛ôÃˆ;/ﬂ–dªÙ~Æ¸|èÀÀæ¥}i˙Ÿ÷~π]—˙feÿm´)¯X¥Qq°§±ﬁè©m¨u[›k´ı?I¸ﬂÛu.ßÍøRÍΩI›˛∞ÈÍΩ3™Êt´ú%Ï˚%πzæèËlÙÌ¶ès–WjJzœ¨ΩG3¶êﬁß’.∏∂◊
Åª'5’X˙˝F‚b’mª?”z5´]£·t|!áÜAq≤Î¨;≠∫◊=ïïw“ª"Á9g˛ãY˝H–>∏ÙAtov.x«û}I¡.€ˇ XıVÚJR£‘ÈÈı;§ı/F÷Â¥è≤ÿ‡·˚’∂[fÊ;‹Àj˜‘ˇ †ÆX^„X‡†OÊØõißˆ«UÃ]Í?a…Ÿm÷]í«πœπüˆïÃg∫ßªË¡ÏÙÎØßJJ}oÌùÏ˚ã≠ª+¢Ì≥;è◊˙uÅŒß:›ﬁçvulÈæ∑‰ˇ ;ïˆ/≥›Í}¢üCUò∏∏Á¶«≠–~∞∂ﬂJ©›UycÆ»«ßo—≈ÍxﬁæS[ø”´"úè˚ò±>•_üô’∫]˝G{Ú¨Ë¨Ωƒ∏=á*:uó9”Í]v;/∑›Ô˛q[¨ÿ≈Õ˜tV∂Íâ˛Àªˇ GQÑ˙øÎ©)…Ë?\˛∞tˇ ≠¥˝JÍ8Ï»£ﬂdÆˆ5ﬂh,c7„e‹}[+~¸`Àoˆ}“.Ø†Tp:Á[ÈUÄ0⁄˙sÒô.;XµπU4<üNøµa›ê Îˆ~∞∞n˙«”˙w_ÍΩw•Ág˙ÿt4_V%¨ÿÍ~“Ïñ_~]t;üM∏>ØÛü‘˝
È~ØtÎÈ˚OUÕ{,ÍUÃ∂„Q&∂T∆Ïƒ≈•Œ€æ∫k.©±û≠◊]bJvI$îˇ ˇ“ıTíI%)s˝WÏÿX)Í}CcznF#∞ÓæÌæï66∆‰c˙œ≥€Uy[Æg™ˇ —˙Ùc’¸Â¥ÆÅb˝b©πÙlKOË/Íıòxx¶åºÍò˘¸ﬂ¥‚–ÙîáÎçÏ«©î’L•’
⁄◊zw‰˙Â°ûﬂ˚Uè˛z•ˆåﬁï’∫5ïıNõüfnt∫Àœ[È÷êÔ6∫ﬂ±ÿˇ ¯ØÙjﬁB√È´≠t,
Ë»¬›ˆúl:X«d„<7Ì8Ìe^ü©ë_ßVV'¸=gˇ µ6+m]^ä:ˇ ’ÏäéS™"ã‹	¶˙ßwŸ3ÿπ¨eﬂEﬂ“p2=_—ˇ J≈Ω)∑—z∆/Y¿ff<±“k»«x" .fó‚dV‡◊◊}˙[õˇ 	¸€’ı∆uEyñu'’ùıw¨±π„ø;!¨;YˆëÑÀjΩåf˙È∫ˇ Ÿ›B™ﬂ˛˘µÆΩk”sF./S∏¥·∑=ÑâˆÓßˆfkiw¸f_˝q%6~±ˇ ãO´üXsœP…7„dºEœ∆sZ,Ä◊X€´πª⁄÷ˇ Éÿ®`ü´]':õÿˆ`}_˙º.£˚_˝':¯˚mî˚ﬁ¸ø≤cµÙ7¸Ì˘Q˙,e°ïı´+Ì?YúŒè”l±µW“p]ª;1ˆ(¿˚^ˇ —zˆ}/≤Ï∑Ï˛ª/Ùk˝*≠◊ø≈øW˙≈áE∑‰„t€ÒXk¬Èt1«öÀúÔJÃù€Ï»s}["¨vU˙/Ê?¬$¶ˇ S˙·ıgÆ6É–˙ïnÎ87'´C®<Sf´ô]5˛ΩE∂„9¸ÂïX∫ûè÷pzŒ  ƒq§≤˙,.¶÷˚m∆ §˚©æß}6€£^WÅ˛$∫À≤Z:ñv5X‹Ωÿ˚Ï∞ˇ %≠∂¨v7wÔÔˇ ≠Æõ©t7túÏK3Û-⁄ÊbcuÏsËÊ“‚[ˆ|^ÆÍöqzñŒ«¢ü¥eQ˙;?û˛w÷IOxπ˛ª—æ¶PÁuæµÖälné∂ √çé?Eûè˝´Ωˇ F∂zv⁄≥≤:O¯À©Ìf7\∆Ã¢eÔ}5„_˝Jˆ„g„m’ßƒË?XYî3Ó∆∆ø®¥ª“ŒÍñÂöZ˝ª˛ÀÅèÉ”∞Í˙ˆüÏ∂√$§¯π7t¨,Ô¨ΩYÖΩG´>∂bÙ˘v÷áU“zUl›oÎvæ«€ìÈ≥˘¸õˇ ¿–•‘«Fˇ YòWº9Ùt€j∂¡0ÎüSõc€∫?û…±h·t-ô¨Í}O!›G©T⁄msEuP€ΩòXå.m;ô˙7ﬂmôè´ÙO ÙøF®W‘h˙œ÷[âàˆŸ“zQ´.ÎöÁëx}übf;ô∂ªpqr1m∫Î∑˛õ3öõ´!%-◊˛≥Ù+˙6^Q∆ÕŒÕ©¯∏îQk-{ÓΩøg«kÖov∆:Î∫€6T∫J6-8¿Ó÷⁄¡Ò⁄'Y_[e}?¿”ˆj≥±/Õ¥	ÙË¶ÍÚ¨ΩÕˇ F«”_¨ˇ 4˙ôBï¥"G	)tíI%?ˇ”ıTíI%)b}kòòYÖ¡á®aŸ∏ˆ\Ãøˆ_2’∂±~π{æ¨Á“ÍYìX∆°øŸn&/˘π7Tíù•À]á‘1˛≥‰Wıp’ãøgu*ov=˜‹˜Qãµï∏;
˚âñÏ¨∫?ù˝Øçî∫ïâ”òk˙◊÷Cıu∏¯V÷g_Oı∫=?Ï]E÷◊íS6u~∂ÕÃ…ËY±§ç¯∑„[Ság2Ãºéùëˇ nb÷£ˆÔ≠EÕ≈ÈµtˆH¸Îõc¿üsõÖ”Ωv[Ì¸◊uu¥íJyé£ıK/!ò˘ˇ mv_\√»Ø+¸èeg∂‹*±Ík€âáêœ¶Í˝lΩ˛çó‰d˙®b}`˙Ÿ’Ne+Ï+N5∑ee+42«µïbc˙ó7“∂∑ˇ 9é∫•«t≥“˙-˝~Æ≥ôNC∫¶FH¶˚«∫ó2Ø≥€Mn;Óe¥◊ÌÙø‚˛öJK“zü◊¨·m¡ù*Í±Úo≈∂ø÷1›ª«cÔeøØ∑Ùõ74£éﬁ©ı úK:ñ.>Fß"«‰b˙ß&€Ì≈±¯ı„⁄F>=Xüh™Àn˛ëÎ˙uU˙?“(}\˙À—zu‘ı<èŸ∑[óïù]y≠v;üFE÷_èv?ÆÎÔØ¸¶eü£Ù÷«’&Z:#-∂ß–ro …eV{k»»ø*çÌ¸«:õk~ƒî«˛n‰·«Ï>•v`Ç0Ìh ≈ i≤∫n, «Ø˜)ƒŒ««Ø˝
Ng◊V8Ü€”.i·Ê´Í#„WØïª˛›[i$ßÙ.£ûcÆu¥c¿›ÅáY∆«~ék€îMπ9ô5ªÛ?j´œÿ÷&≠µÙÔ≠“⁄€N'P¿Ø0mkl¡}ˆ˝ô≠o±õÒsΩJkˇ Gâ˙5∏±~∞Ô9Ωµ“û§É—çõÎˇ ‡¢Jv\÷Ω•ÆÕpá4Í=ä∆˙óc¨˙•—‹ÓF-˘5çcËµYÎ˝JŒõ“Ø»†Â∫)¬®«ø&‚(√´‹Ê{]ëe~ßª˘¥~ïÄŒõ”1:unﬁÃ:k°Ø"Ömm{»ø∑rJm$íI)ˇ‘€…ø?'7Îp8˝o†⁄Œú«˚qÒOßôíÕ’Ÿ∑;ˆéEπ˛É◊£“≈¶´1_uù ∆Î˝''$∑;ß2õ2⁄√èìçë•Yxè˛˚◊∫∑kÍ‚_≤œFﬂRΩûÜVB≈f/Y{*¡Ø≠∫™v5î‰d·b–∆ãzóK/Í÷WS?—ø"Î√oIOh∞≥üWU˙≈ã”X[e=&3ÛÄÉ∂ÁW“ÒÏ˜}?}˘ˇ CÙeƒ≥¸-k}RŒ:Y“pmiÂØÍôÔi˛ª-≈±è˛⁄‘¿Ë}^∂z5Yç–0⁄Iù&∫ﬁÁ8Ü7’ª/;“¸ﬂ†ŒõÍ}÷íS•÷∫÷C¿~~{»¨ Î`›e∂;˘º|zˇ ¬ﬂoÊ∑˛πgË∑Ω°ag4ﬂ’:´WRÍ=JÚˆQM{æ…Ç◊˝W´mπ7Vﬂ“Âd_≥Ùä¬˙Â–i≈˙ß’Ú›}˘πÊê~◊íÁµç}VzT2¶SçãSΩ?“3ä}o˛¢Ï“RíI$î§+1q≠∂ª≠©ñ[Iö¨sAs	ˇ FÁÃ˛ *I)g5Æç¿2$L›:I$•$íI)K2 øÁèL™˝≠-ÿªå‹_âÍ6°˘÷”äÀ?Î6€ˇ ∑Ul˛õÉ‘©m9µX«ãk2ZˆXﬂÊÔ¢ÍÀ-¢˙ˇ 2Í^ÀXíúø¨F‹lÓô’,¶ÃûùÄ˚]ì] Ωıæ∆
1˙áŸÿ◊YìV-o ™ÍÍ˝%j˚Oßg†∂1ÚqÚ©fF-¨æã◊mncáãÕÕr‰˛¨uo¨≠Ëîu∂û±àÁﬁÀ=6ÜÊT ,ªèÿ6’‘˜zﬂÈ˝õ/˝y∂+;',u/™ô¯Ùfó∏Át˜ïd8‹ÏA]E∂⁄œ≥˝´¸U95˛ç%;˝G®UÅ@±Ìu∂ÿ·V>=pl∂◊YM[ã[ÙZÁΩÔw•ML≤˚Ω:j±ÎãX:éu˜’~vF?T™Î®gKÈ‚óπè≠€(ä.£"Ï¨{=K∫áP∑ßÙ˝ñ~é∫ñáR«ÍôOºõôGUŒ«•∏n{˛≈Ç?M‘skæ⁄õª+/“≈¬˚]òÿ˛Ö∂„z·~—“‡tÏõé1∞im7≥FÆ?È-y˝%÷ø¸%÷ª’≥¸"Jˇ’ıTó ©$ßÍ§ó ©$ßÈ?≠ü`ˇ õ}Gˆè´ˆ/AﬁøŸˆ˙ª;˙>ØË˜ˇ ]kØïRIO’I/ïRIO’I/ïRIO’I/ïRIO’I/ïRIO’I/ïRIO—_Q’úq[ã€Îe√ú›§˛µì˘Å÷mˇ =≠Ãˇ Uü∑ˇ gz—Ï˚w°ªoÚ>’Ó⁄ænI%?G}Wˇ ö€2Êˆ…ñ}£È˙õv˛©˝+ÙﬂcÙ†l˝O“˛à∑ ©$ßˇŸˇÌ4öPhotoshop 3.0 8BIM%                     8BIMÍ     <?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.print.PageFormat.PMHorizontalRes</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMHorizontalRes</key>
				<real>72</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMOrientation</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMOrientation</key>
				<integer>1</integer>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMScaling</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMScaling</key>
				<real>1</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMVerticalRes</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMVerticalRes</key>
				<real>72</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMVerticalScaling</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMVerticalScaling</key>
				<real>1</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.subTicket.paper_info_ticket</key>
	<dict>
		<key>PMPPDPaperCodeName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>PMPPDPaperCodeName</key>
					<string>Letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>PMTiogaPaperName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>PMTiogaPaperName</key>
					<string>na-letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PageFormat.PMAdjustedPageRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PageFormat.PMAdjustedPageRect</key>
					<array>
						<integer>0</integer>
						<integer>0</integer>
						<real>734</real>
						<real>576</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PageFormat.PMAdjustedPaperRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PageFormat.PMAdjustedPaperRect</key>
					<array>
						<real>-18</real>
						<real>-18</real>
						<real>774</real>
						<real>594</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.PMPaperName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.PMPaperName</key>
					<string>na-letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
					<array>
						<integer>0</integer>
						<integer>0</integer>
						<real>734</real>
						<real>576</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
					<array>
						<real>-18</real>
						<real>-18</real>
						<real>774</real>
						<real>594</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
					<string>US Letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.ticket.APIVersion</key>
		<string>00.20</string>
		<key>com.apple.print.ticket.type</key>
		<string>com.apple.print.PaperInfoTicket</string>
	</dict>
	<key>com.apple.print.ticket.APIVersion</key>
	<string>00.20</string>
	<key>com.apple.print.ticket.type</key>
	<string>com.apple.print.PageFormatTicket</string>
</dict>
</plist>
8BIMÈ     x    H H    ﬁ@ˇÓˇÓRg(¸    H H    ÿ(    d       ˇ              h ê                                8BIMÌ     Éˇ}  Éˇ}  8BIM&               ?Ä  8BIM        8BIM        8BIMÛ     	         8BIM
       8BIM'     
        8BIMÙ      5    -        8BIM˜       ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇË  8BIM          @  @    8BIM         8BIM    a             Ö  ó    A p p   E n g i n e   G o p h e r   v 3 - 2                                ó  Ö                                            null      boundsObjc         Rct1       Top long        Leftlong        Btomlong  Ö    Rghtlong  ó   slicesVlLs   Objc        slice      sliceIDlong       groupIDlong       originenum   ESliceOrigin   autoGenerated    Typeenum   
ESliceType    Img    boundsObjc         Rct1       Top long        Leftlong        Btomlong  Ö    Rghtlong  ó   urlTEXT         nullTEXT         MsgeTEXT        altTagTEXT        cellTextIsHTMLbool   cellTextTEXT        	horzAlignenum   ESliceHorzAlign   default   	vertAlignenum   ESliceVertAlign   default   bgColorTypeenum   ESliceBGColorType    None   	topOutsetlong       
leftOutsetlong       bottomOutsetlong       rightOutsetlong     8BIM(        ?      8BIM        8BIM    §      †   e  ‡  Ω`  à  ˇÿˇ‡ JFIF   H H  ˇÌ Adobe_CM ˇÓ Adobe dÄ   ˇ€ Ñ 			
ˇ¿  e †" ˇ›  
ˇƒ?          	
         	
 3 !1AQa"qÅ2ë°±B#$R¡b34rÇ—C%íS·Òcs5¢≤É&DìTdE¬£t6“U‚eÚ≥Ñ√”u„ÛF'î§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ7GWgwáóß∑«◊Á˜ 5 !1AQaq"2Åë°±B#¡R—3$b·rÇíCScs4Ò%¢≤É&5¬“DìT£dEU6te‚Ú≥Ñ√”u„ÛFî§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ'7GWgwáóß∑«ˇ⁄   ? ı*i™äôM,mUT– Î`kZ—µåcÌk’4íIJI$íRíI+/˘9w3Ω_mÆcdÌû¯o“))2√w÷Û…´ÍÊ0œ‰°kçX-?§o≥$6À3‹€+ÿÊ`Uu_È≤q‘+eˇ Y_Íe”f7C≠Á”∆∏YòZ}∂Â–Ë}=7Û™ƒªÙπøˆ™∫±øAìº÷µç`kD5£@ ÏSäÓÖ’2öhuº£πƒ∫¨&◊âPò«duˇ ÓESÎˇ V:5]3. ¨Ã≥ìsNm˜eË˛±Ìfu◊±õ˝=ñzNø—ÆùPÎÃc˙QcÃ1ÿ∑#[Â%5›ıGÍ´á¸èÇ<€èSO˘ÃcT]ıO•µÆñe‡∏˝ceﬁ∆¥è¢Ê„:◊·ª˙ñ„YWÚÆ;ú˙+sƒ9ÃipÛ#TDî‚9øZ˙x&∑Q÷Ëh$6œ’2πñèR∂ŸÅìfœ¯ôZ%Y∞êÃL⁄ÔÈôVø”™¨⁄˝6Ω˙mÆå ÕΩ?&À7˛é¨|ªm˛B◊C»∆« °¯˘52˙,l™∆á1√¡Ï|µ…)"Kü•ŸüW.uyvø+†ºÕVÎpß¸eÆó‰tÔÙY÷~õ˛÷˙òˇ ≠Sæ◊5Õi§H#PAIK§íI)I$íJˇ–ıTíI%)$ñOS˙ÀÅ”Ú>ƒ ÔœœÜ∏·aVnµ≠q_Ù)∆Ø›ÙÚn•%'Î=Sˆ^¨ ]ïìk€N&#kÆπˇ Õ‘◊ŸÏ≠∫:€Ìˇ è]◊ÉYLÈ˘WıÏ◊lf[≈7e„b÷ÿ∆«∂óbT◊‘◊˛ó+"øµ;”À…˙Œb„·˙äÆw\qÎ˝Ó°”s∞±Z˚i£’mNÃΩ¨ßŸáëîÔf'Ì/•Ù=U£◊3Ÿã’∫ŸXÏŒ¢¡nÏ
`‹Ïk[µ÷˚›]4Uˆ⁄1?X ∂öùÆø”˛â%;©.s5˝a¥æ∑’±˙£”≈ÿÁÀá±èÍ]Ié©Ô˙~Ã~ùEü´%∂˝N»m9ßıNΩYh5‰dcÁfTAˇ ∆fµÿˇ ˆ≈))Í≤∫ˇ B√ßô‘qqü˚∂ﬂ[˘∂=´+≠}k˙≠wJÕ∆gW√}óc€[ZÀÿ‚KòÊÄ=79¢g}OvK∞∫]X¯Y≠’ÿn«˚¸oñ„_V=÷{>∂-ÙîÛÙ}w˙©ËW=Nâ⁄Ÿ‘ò1«’˝s˙•g—Îc˙˜1ü˘ÒÕ[K'?Î&.aÈÿ’]‘∫ê€ø°Œ¨8ncÚÓ±’ca±ﬂ˜f˙ˇ ‡“Sc≠Ù\ÁÏ¡ÍŸOõM’ÿ~ÍﬁÂyryuıû°_≠õıG!√V’ìïSÏ¸pÆ•Øˇ Ø¨qù“:v]8Y=7´}VÃΩ€™8.u¯Æx˜©«∆vfKù>˙ˇ fXíûø™õüã“¸”ø[ŒèÙ59æé;øÊQgµˇ £»ƒ≈Œ•R»≈o’sV^ΩäÎÉ3pµ’ˆãõÉ?—YVEª≤±¢}ü’æ™©∫ø”÷¬ŒÀÈ¢ﬁµe¨Î˝30V◊u<6É}U÷_HıpÈﬂVF.3ùmŸ·l∫ºãÚˇ …ﬁüÛz_Y≥˙s~¨e‰ﬁ◊ÂÙ¸ä6=ÿ•é&¨Ä)ıÍ≤«≤üOmﬁß≠øŸ_ÈRS≤íÊpæ±uÃ.üK∫ˇ EÀ®‘ ŸïóC©…nËª%ÿ¯ó?)¥Ó˝+˝*.Ùÿ∫\¨|ÃzÚ±lm‘\–˙ÏañπßªJJJíI$ßˇ—ıTíI%5˙ém}?ßÂg⁄´ƒ¶Àﬁ%µµ÷∫?Õ\Œ/Qg’o®ø∑≤´~^]ı◊õö}≠}π9EüŒ=çŸ]u>ÊPœgË±Í]N^-9ò∑bd7}∫´[‚«Ç«∑¸◊.:ŒµÖ—:ﬂW~¥V«[âÜˆc⁄3È°õiÙ,{û÷Ê9å•ó„>œ[Ì/ﬂGÊ$¶øK˙¡X«ˇ ûôò~õ©`Ë7‘kΩLãﬁ⁄-ΩπWOø*ÔK˝¶«£-i_ëÖıS˘Ωôs2∑fı,€‰˚+ˆ;*Í⁄ÊøÏî=Ï√È]6ß≥’±ı‚”ˇ jÛ+Øıjå0ˇ ´Ω#∆=Ω'Ã‹∫È{lkrÏmXÃıYw”˚gT{œU˙ì≠π’f\Z’æ±—Üe¿c`Ym8¯ﬁÛµ≠∑;‹ü¯ÃÀS£ı_Í•Ìs:Ô÷g˛ªh‹œ\á∑§˙å£∂µîU{?√[ML˝/©Ë~è˘Ó≠$íSO©Ùéù’±∆>}-πç!ıªP˙ﬁ>ç¥\Õ∂—k“Tıü–ÚÛ1sØ˙Ω‘≠vM¯Ï‡Ê<◊‚ìÈ˛ôÃˆ;/ﬂ–dªÙ~Æ¸|èÀÀæ¥}i˙Ÿ÷~π]—˙feÿm´)¯X¥Qq°§±ﬁè©m¨u[›k´ı?I¸ﬂÛu.ßÍøRÍΩI›˛∞ÈÍΩ3™Êt´ú%Ï˚%πzæèËlÙÌ¶ès–WjJzœ¨ΩG3¶êﬁß’.∏∂◊
Åª'5’X˙˝F‚b’mª?”z5´]£·t|!áÜAq≤Î¨;≠∫◊=ïïw“ª"Á9g˛ãY˝H–>∏ÙAtov.x«û}I¡.€ˇ XıVÚJR£‘ÈÈı;§ı/F÷Â¥è≤ÿ‡·˚’∂[fÊ;‹Àj˜‘ˇ †ÆX^„X‡†OÊØõißˆ«UÃ]Í?a…Ÿm÷]í«πœπüˆïÃg∫ßªË¡ÏÙÎØßJJ}oÌùÏ˚ã≠ª+¢Ì≥;è◊˙uÅŒß:›ﬁçvulÈæ∑‰ˇ ;ïˆ/≥›Í}¢üCUò∏∏Á¶«≠–~∞∂ﬂJ©›UycÆ»«ßo—≈ÍxﬁæS[ø”´"úè˚ò±>•_üô’∫]˝G{Ú¨Ë¨Ωƒ∏=á*:uó9”Í]v;/∑›Ô˛q[¨ÿ≈Õ˜tV∂Íâ˛Àªˇ GQÑ˙øÎ©)…Ë?\˛∞tˇ ≠¥˝JÍ8Ï»£ﬂdÆˆ5ﬂh,c7„e‹}[+~¸`Àoˆ}“.Ø†Tp:Á[ÈUÄ0⁄˙sÒô.;XµπU4<üNøµa›ê Îˆ~∞∞n˙«”˙w_ÍΩw•Ág˙ÿt4_V%¨ÿÍ~“Ïñ_~]t;üM∏>ØÛü‘˝
È~ØtÎÈ˚OUÕ{,ÍUÃ∂„Q&∂T∆Ïƒ≈•Œ€æ∫k.©±û≠◊]bJvI$îˇ ˇ“ıTíI%)s˝WÏÿX)Í}CcznF#∞ÓæÌæï66∆‰c˙œ≥€Uy[Æg™ˇ —˙Ùc’¸Â¥ÆÅb˝b©πÙlKOË/Íıòxx¶åºÍò˘¸ﬂ¥‚–ÙîáÎçÏ«©î’L•’
⁄◊zw‰˙Â°ûﬂ˚Uè˛z•ˆåﬁï’∫5ïıNõüfnt∫Àœ[È÷êÔ6∫ﬂ±ÿˇ ¯ØÙjﬁB√È´≠t,
Ë»¬›ˆúl:X«d„<7Ì8Ìe^ü©ë_ßVV'¸=gˇ µ6+m]^ä:ˇ ’ÏäéS™"ã‹	¶˙ßwŸ3ÿπ¨eﬂEﬂ“p2=_—ˇ J≈Ω)∑—z∆/Y¿ff<±“k»«x" .fó‚dV‡◊◊}˙[õˇ 	¸€’ı∆uEyñu'’ùıw¨±π„ø;!¨;YˆëÑÀjΩåf˙È∫ˇ Ÿ›B™ﬂ˛˘µÆΩk”sF./S∏¥·∑=ÑâˆÓßˆfkiw¸f_˝q%6~±ˇ ãO´üXsœP…7„dºEœ∆sZ,Ä◊X€´πª⁄÷ˇ Éÿ®`ü´]':õÿˆ`}_˙º.£˚_˝':¯˚mî˚ﬁ¸ø≤cµÙ7¸Ì˘Q˙,e°ïı´+Ì?YúŒè”l±µW“p]ª;1ˆ(¿˚^ˇ —zˆ}/≤Ï∑Ï˛ª/Ùk˝*≠◊ø≈øW˙≈áE∑‰„t€ÒXk¬Èt1«öÀúÔJÃù€Ï»s}["¨vU˙/Ê?¬$¶ˇ S˙·ıgÆ6É–˙ïnÎ87'´C®<Sf´ô]5˛ΩE∂„9¸ÂïX∫ûè÷pzŒ  ƒq§≤˙,.¶÷˚m∆ §˚©æß}6€£^WÅ˛$∫À≤Z:ñv5X‹Ωÿ˚Ï∞ˇ %≠∂¨v7wÔÔˇ ≠Æõ©t7túÏK3Û-⁄ÊbcuÏsËÊ“‚[ˆ|^ÆÍöqzñŒ«¢ü¥eQ˙;?û˛w÷IOxπ˛ª—æ¶PÁuæµÖälné∂ √çé?Eûè˝´Ωˇ F∂zv⁄≥≤:O¯À©Ìf7\∆Ã¢eÔ}5„_˝Jˆ„g„m’ßƒË?XYî3Ó∆∆ø®¥ª“ŒÍñÂöZ˝ª˛ÀÅèÉ”∞Í˙ˆüÏ∂√$§¯π7t¨,Ô¨ΩYÖΩG´>∂bÙ˘v÷áU“zUl›oÎvæ«€ìÈ≥˘¸õˇ ¿–•‘«Fˇ YòWº9Ùt€j∂¡0ÎüSõc€∫?û…±h·t-ô¨Í}O!›G©T⁄msEuP€ΩòXå.m;ô˙7ﬂmôè´ÙO ÙøF®W‘h˙œ÷[âàˆŸ“zQ´.ÎöÁëx}übf;ô∂ªpqr1m∫Î∑˛õ3öõ´!%-◊˛≥Ù+˙6^Q∆ÕŒÕ©¯∏îQk-{ÓΩøg«kÖov∆:Î∫€6T∫J6-8¿Ó÷⁄¡Ò⁄'Y_[e}?¿”ˆj≥±/Õ¥	ÙË¶ÍÚ¨ΩÕˇ F«”_¨ˇ 4˙ôBï¥"G	)tíI%?ˇ”ıTíI%)b}kòòYÖ¡á®aŸ∏ˆ\Ãøˆ_2’∂±~π{æ¨Á“ÍYìX∆°øŸn&/˘π7Tíù•À]á‘1˛≥‰Wıp’ãøgu*ov=˜‹˜Qãµï∏;
˚âñÏ¨∫?ù˝Øçî∫ïâ”òk˙◊÷Cıu∏¯V÷g_Oı∫=?Ï]E÷◊íS6u~∂ÕÃ…ËY±§ç¯∑„[Ság2Ãºéùëˇ nb÷£ˆÔ≠EÕ≈ÈµtˆH¸Îõc¿üsõÖ”Ωv[Ì¸◊uu¥íJyé£ıK/!ò˘ˇ mv_\√»Ø+¸èeg∂‹*±Ík€âáêœ¶Í˝lΩ˛çó‰d˙®b}`˙Ÿ’Ne+Ï+N5∑ee+42«µïbc˙ó7“∂∑ˇ 9é∫•«t≥“˙-˝~Æ≥ôNC∫¶FH¶˚«∫ó2Ø≥€Mn;Óe¥◊ÌÙø‚˛öJK“zü◊¨·m¡ù*Í±Úo≈∂ø÷1›ª«cÔeøØ∑Ùõ74£éﬁ©ı úK:ñ.>Fß"«‰b˙ß&€Ì≈±¯ı„⁄F>=Xüh™Àn˛ëÎ˙uU˙?“(}\˙À—zu‘ı<èŸ∑[óïù]y≠v;üFE÷_èv?ÆÎÔØ¸¶eü£Ù÷«’&Z:#-∂ß–ro …eV{k»»ø*çÌ¸«:õk~ƒî«˛n‰·«Ï>•v`Ç0Ìh ≈ i≤∫n, «Ø˜)ƒŒ««Ø˝
Ng◊V8Ü€”.i·Ê´Í#„WØïª˛›[i$ßÙ.£ûcÆu¥c¿›ÅáY∆«~ék€îMπ9ô5ªÛ?j´œÿ÷&≠µÙÔ≠“⁄€N'P¿Ø0mkl¡}ˆ˝ô≠o±õÒsΩJkˇ Gâ˙5∏±~∞Ô9Ωµ“û§É—çõÎˇ ‡¢Jv\÷Ω•ÆÕpá4Í=ä∆˙óc¨˙•—‹ÓF-˘5çcËµYÎ˝JŒõ“Ø»†Â∫)¬®«ø&‚(√´‹Ê{]ëe~ßª˘¥~ïÄŒõ”1:unﬁÃ:k°Ø"Ömm{»ø∑rJm$íI)ˇ‘€…ø?'7Îp8˝o†⁄Œú«˚qÒOßôíÕ’Ÿ∑;ˆéEπ˛É◊£“≈¶´1_uù ∆Î˝''$∑;ß2õ2⁄√èìçë•Yxè˛˚◊∫∑kÍ‚_≤œFﬂRΩûÜVB≈f/Y{*¡Ø≠∫™v5î‰d·b–∆ãzóK/Í÷WS?—ø"Î√oIOh∞≥üWU˙≈ã”X[e=&3ÛÄÉ∂ÁW“ÒÏ˜}?}˘ˇ CÙeƒ≥¸-k}RŒ:Y“pmiÂØÍôÔi˛ª-≈±è˛⁄‘¿Ë}^∂z5Yç–0⁄Iù&∫ﬁÁ8Ü7’ª/;“¸ﬂ†ŒõÍ}÷íS•÷∫÷C¿~~{»¨ Î`›e∂;˘º|zˇ ¬ﬂoÊ∑˛πgË∑Ω°ag4ﬂ’:´WRÍ=JÚˆQM{æ…Ç◊˝W´mπ7Vﬂ“Âd_≥Ùä¬˙Â–i≈˙ß’Ú›}˘πÊê~◊íÁµç}VzT2¶SçãSΩ?“3ä}o˛¢Ï“RíI$î§+1q≠∂ª≠©ñ[Iö¨sAs	ˇ FÁÃ˛ *I)g5Æç¿2$L›:I$•$íI)K2 øÁèL™˝≠-ÿªå‹_âÍ6°˘÷”äÀ?Î6€ˇ ∑Ul˛õÉ‘©m9µX«ãk2ZˆXﬂÊÔ¢ÍÀ-¢˙ˇ 2Í^ÀXíúø¨F‹lÓô’,¶ÃûùÄ˚]ì] Ωıæ∆
1˙áŸÿ◊YìV-o ™ÍÍ˝%j˚Oßg†∂1ÚqÚ©fF-¨æã◊mncáãÕÕr‰˛¨uo¨≠Ëîu∂û±àÁﬁÀ=6ÜÊT ,ªèÿ6’‘˜zﬂÈ˝õ/˝y∂+;',u/™ô¯Ùfó∏Át˜ïd8‹ÏA]E∂⁄œ≥˝´¸U95˛ç%;˝G®UÅ@±Ìu∂ÿ·V>=pl∂◊YM[ã[ÙZÁΩÔw•ML≤˚Ω:j±ÎãX:éu˜’~vF?T™Î®gKÈ‚óπè≠€(ä.£"Ï¨{=K∫áP∑ßÙ˝ñ~é∫ñáR«ÍôOºõôGUŒ«•∏n{˛≈Ç?M‘skæ⁄õª+/“≈¬˚]òÿ˛Ö∂„z·~—“‡tÏõé1∞im7≥FÆ?È-y˝%÷ø¸%÷ª’≥¸"Jˇ’ıTó ©$ßÍ§ó ©$ßÈ?≠ü`ˇ õ}Gˆè´ˆ/AﬁøŸˆ˙ª;˙>ØË˜ˇ ]kØïRIO’I/ïRIO’I/ïRIO’I/ïRIO’I/ïRIO’I/ïRIO—_Q’úq[ã€Îe√ú›§˛µì˘Å÷mˇ =≠Ãˇ Uü∑ˇ gz—Ï˚w°ªoÚ>’Ó⁄ænI%?G}Wˇ ö€2Êˆ…ñ}£È˙õv˛©˝+ÙﬂcÙ†l˝O“˛à∑ ©$ßˇŸ8BIM!     U       A d o b e   P h o t o s h o p    A d o b e   P h o t o s h o p   C S 2    8BIM          ˇ·:≤http://ns.adobe.com/xap/1.0/ <?xpacket begin="Ôªø" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="3.1.1-111">
   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <rdf:Description rdf:about=""
            xmlns:xapMM="http://ns.adobe.com/xap/1.0/mm/"
            xmlns:stRef="http://ns.adobe.com/xap/1.0/sType/ResourceRef#">
         <xapMM:DocumentID>uuid:7CE6CFD65DFC11E0BCFAEDCC75B07363</xapMM:DocumentID>
         <xapMM:InstanceID>uuid:4953275A5EF111E0BCFAEDCC75B07363</xapMM:InstanceID>
         <xapMM:DerivedFrom rdf:parseType="Resource">
            <stRef:instanceID>uuid:7CE6CFD55DFC11E0BCFAEDCC75B07363</stRef:instanceID>
            <stRef:documentID>uuid:7CE6CFD55DFC11E0BCFAEDCC75B07363</stRef:documentID>
         </xapMM:DerivedFrom>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:xap="http://ns.adobe.com/xap/1.0/">
         <xap:CreateDate>2011-04-07T18:12:56-07:00</xap:CreateDate>
         <xap:ModifyDate>2011-04-07T18:12:56-07:00</xap:ModifyDate>
         <xap:MetadataDate>2011-04-07T18:12:56-07:00</xap:MetadataDate>
         <xap:CreatorTool>Adobe Photoshop CS2 Macintosh</xap:CreatorTool>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:dc="http://purl.org/dc/elements/1.1/">
         <dc:format>image/jpeg</dc:format>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/">
         <photoshop:ColorMode>1</photoshop:ColorMode>
         <photoshop:History/>
         <photoshop:ICCProfile>Dot Gain 20%</photoshop:ICCProfile>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:tiff="http://ns.adobe.com/tiff/1.0/">
         <tiff:Orientation>1</tiff:Orientation>
         <tiff:XResolution>8999980/10000</tiff:XResolution>
         <tiff:YResolution>8999980/10000</tiff:YResolution>
         <tiff:ResolutionUnit>2</tiff:ResolutionUnit>
         <tiff:NativeDigest>256,257,258,259,262,274,277,284,530,531,282,283,296,301,318,319,529,532,306,270,271,272,305,315,33432;A5AFE4F036AAF0AABA261C5207BB848B</tiff:NativeDigest>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:exif="http://ns.adobe.com/exif/1.0/">
         <exif:PixelXDimension>1431</exif:PixelXDimension>
         <exif:PixelYDimension>901</exif:PixelYDimension>
         <exif:ColorSpace>-1</exif:ColorSpace>
         <exif:NativeDigest>36864,40960,40961,37121,37122,40962,40963,37510,40964,36867,36868,33434,33437,34850,34852,34855,34856,37377,37378,37379,37380,37381,37382,37383,37384,37385,37386,37396,41483,41484,41486,41487,41488,41492,41493,41495,41728,41729,41730,41985,41986,41987,41988,41989,41990,41991,41992,41993,41994,41995,41996,42016,0,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20,22,23,24,25,26,27,28,30;930B5231C9F210D213E2C6E624742838</exif:NativeDigest>
      </rdf:Description>
   </rdf:RDF>
</x:xmpmeta>
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                            
<?xpacket end="w"?>ˇ‚†ICC_PROFILE   êADBE  prtrGRAYXYZ œ        acspAPPL    none                 ˆ÷     ”-ADBE                                               cprt   ¿   2desc   Ù   gwtpt  \   bkpt  p   kTRC  Ñ  text    Copyright 1999 Adobe Systems Incorporated   desc       Dot Gain 20%                                                                                XYZ       ˆ÷     ”-XYZ                 curv             0 @ P a  † ≈ ÏDu®ﬁRê–Y°Ï9à⁄.Öﬁ9ñˆWª"äÙ	a	–
A
¥)†ïíñ£,∏E‘e¯ç$ΩWÙí2‘x∆o»v'⁄éD¸ µ!q"."Ì#≠$p%4%˘&¡'ä(U)")*¿+í,e-:..Í/ƒ0†1}2\3=455È6–7π8§9ê:~;m<^=Q>E?;@3A,B&C"D EF G#H'I-J4K<LGMSN`OoPQëR•S∫T—UÈWXY:ZX[x\ô]º^‡`a-bVcÄd¨eŸgh8iijùk—mn?oxp≤qÓs+tju™vÏx/ytz∫|}J~ï·Å.Ç|ÉÕÖÜqá≈âärãÀç%éÅè›ë<íõì˝ï_ñ√ò(ôèö˜ú`ùÀü7†•¢£Ö§ˆ¶ißﬁ©T™À¨D≠æØ9∞∂≤4≥¥µ4∂∑∏:πøªEºÕæVø‡¡l¬˘ƒá∆«®…; ŒÃcÕ˙œí—+“≈‘a’˛◊úŸ<⁄›‹ﬁ#ﬂ»·n„‰øÊiËÈ¡ÎoÌÓ–ÇÚ5ÛÍı†˜W˘˙ ¸Ö˛AˇˇˇÓ Adobe d     ˇ€ C 

ˇ¿ Öó ˇ›  ≥ˇƒ “            	
 s !1AQa"qÅ2ë°±B#¡R—·3b$rÇÒ%C4Sí¢≤cs¬5D'ì£≥6Tdt√“‚&É	
ÑîEF§¥V”U(Ú„Ûƒ‘‰ÙeuÖï•µ≈’ÂıfvÜñ¶∂∆÷Êˆ7GWgwáóß∑«◊Á˜8HXhxàò®∏»ÿË¯)9IYiyâô©π…ŸÈ˘*:JZjzäö™∫ ⁄Í˙ˇ⁄   ? ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ66IR%/#Q‘ìAë]gÛg z-E˛´i™&Vo˘gˇ Ö»πˇ 9u‰}:¢⁄[ãÊÔàHWÜsΩ{˛s~CU—4ê<ÊZˇ …(ï‰ˆsçk˛rªœzë>ï‹vhfP√L&ì˛"áÁúoÎıçbÙÉŸgt1îIqÊ›bÁyÔÆdØÛLÁı∂í˛‚SY%v#≈âƒ	ÆÁ6,ó≥∆y$éßƒ1&/0ÍPÔ‘ÎOÂëá¸mÉ°ÛÔò`˛ÎSΩOın$© €ÛãŒ6ﬂ›Î7ﬂM√ü¯ì5∂ˇ úáÛÂ∑ÿ’Á?ÎÑ˘8çáVüÛïﬁ~∑˚w±Ã?ÀÇ/¯—lÁ3º·ˇ HÇ∆aÔ©ˇ Ñõ˛5…á¸Á†î˙Óëû>úÃüÒ4ó$∫¸ÊÓç%>Ω•‹≈„È∫Iˇ Ù2S¶ˇ Œ^yÓû¥∑6’ˇ ~¿O¸ò3døJ¸ıÚN®@∂÷-A=ØÈ˘/È‰«O’¨ıı,gätÒç’«ﬁÑ‡¨Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸO"∆•‹ÖQ‘ùÜEuØÕ*hµÜ´i´Î+7¸ãå≥ˇ ¬‰Xˇ ú∂Ú.ûHÇyÔæ!o¯î˛Ç‰Xˇ ú‡≥Jç+IñOûeO¯H“o¯ûB5è˘ÃÔ6]’lmÏÌ±Œﬂ|è√˛I‰#Xˇ úàÛﬁ´_[Vö5=†„∆ﬂŸ	’<≈©j«ñ£u=…=Âëü˛&ÕÖÍ•ç ©9&—?,ºœÆSÙnów2ü⁄∞_˘¿'¸6t˛qœùÃ0X°Ô<¿ü¯]≥§h?ÛÑ Z’]õ∫€ƒ»…Yˇ ‰÷~~Œ9Ë>BÚ¿÷4fπíÂ.#GiùXp`Í~H«˜ûû%ˇ 8£˘mÂè:Ÿj?ßÏñÍÊ÷X¯≥;≠Eoáånãˆ¢lÙÛèûDåQt{ßëˇ â>/ˇ *#»ˇ ıf¥ˇ ÄÕˇ *#»ˇ ıf¥ˇ Äƒ_˛q˜»Æ(t{£ê˝MÅ•ˇ úmÚΩtò« IG¸F\?¸‚∑ê%5{'˙∑‹Œ y_∞óQˇ ´9ˇ ç’¶Ô˛p´ ≤oÂ¸7çøÊH¬kø˘¡Ì=øﬁ]^dˇ ^o¯ã≈Ñ7øÛÉ˙äWÍöºxzê≤ƒ^\è_ˇ Œ˘∆ﬁ¶ﬁk)«˘2∫ü˘)è¯lçj_Ûå~±ﬂÙo¨æ1M¬˙úˇ ·r+™~T˘ØK©º“ocQ˚^Éïˇ ÉUe»Õ≈¥∂ÕÈŒçéÃ?qÀ∂ªö’ƒ∂Ó—∏Ë»JüΩri°~x˘”C†≤’ÆJØEï˝Uˇ Å∏ıFtﬂ-Œiyä»Ñ÷m-Ô£Y+ˇ ¡/©¸ëŒ◊‰o˘ ü(yôñﬁÍV”.õn7TO˘7Xø‰o•ùÇ)ídD¡—ÖC)® ˜õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕîÃc@7$Á5Ûè¸‰_ì<¨Õ≈Ú‹‹/X≠G™’.øπS˛º´úwÃüÛõ“S@“¿§∫íøÚF…¸Êˇ ¸Âûıä®æëüŸ∂çS˛J0yø‰¶sÕcÕzæ∂≈µK€ã¢ﬂ“ªˇ ƒÿ·Z©c@*NHÙoÀo2ÎT˝¶]Œßˆñ„ˇ «á¸6Nt˘≈_>jT/fñ™{œ2¯X⁄Y?·2q£ˇ Œk–Íöù¥"yO¸?’Úo£ˇ Œ˘r‹Ü‘oÆÓHÏú"Sˇ +√‰„Gˇ úgÚóB∫jŒ„ˆßë‰ˇ ÑgÙˇ ·2s£˘;E—@eçµ≠:zP¢ΩaælŸÕ?Á$tœ“>B’c•Lq§√˛y»í¯Ul·ÛÑZóß≠Ívˇ }jí”˛1ø˘üû¬Õõ6lŸ≥fÕõ6l}•ZjÈﬁ√È·"sÉêÕgÚ…≈M÷ël¨›L*a?}πã9ˆøˇ 8cÂ[–[L∏∫≤s–r†ˇ c"˙üÚ[9_öÁºÀßìF∏∑‘PtSXd?ÏdÂ¸óŒ%Ê?*jæZπ6Z’¨∂ìèŸïJ‘2≤Î˛R|8y‰Õﬂ3y%áËKŸ#Ñò„àˇ œ9"ˇ ¨ú_¸¨Ù7ëˇ Á5-'„oÊª&Å˙Ì~$˘¥}Dˇ a$øÍÁ|ÚüÊÉÊË˝]
ˆ≠™Ué?◊Ö∏ üÏì$9≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥`MWW≥“-⁄˜Qö;kx≈ZIX*èõ6Ÿ¿ø0Á1Ù]'ïØñ!:ï¿€’z«>ﬂÓÈ‡c_¯≥<ŸÁøŒØ4˘‹≤Í◊Øıfˇ èxøwˆÙ”˚œ˘Ídlâiz=Ê≠:⁄i–Is;tHêªˆ(	Œ±Â˘≈;kad∏Ç=>#ﬁÊJ5?„^¨üjô‘ºøˇ 8Ce≠Íí {•ºa¸åîÕˇ &◊:>áˇ 8ª‰M&ål”è⁄∏ëﬂ˛ã˛I‰ˇ FÚnã¢ ∫]çµ≠:zP¢ΩV∏qõ6lŸ≥fÕëˇ Ã-7Ùüó5;W÷≥ù ˜1∑«<eˇ 8è®˝SœPEZ}fﬁxæÂıøÊN{∑6lŸ≥fÕõ6lŸ≥fÕõµﬂ.iﬁ`∂6ZΩ¥WVÌ’%@√Ê9}ñˇ )sÇ˘Ô˛pœF‘π\ybÂÙ˘é‚+$?%oÔ£ˇ Çõ˝\Û◊ùˇ  ºﬂ‰˛R_Y4÷À˛Ô∂˝Ït˛f·˚»ˇ Á¨iêk©≠$YÌ›¢ïUêï`…e‹g\ÚW¸ÂGú|∑∆+ô◊R∂_ÿ∫öü‰‹/‰cI˛ÆwØ%ˇ Œa˘_X„µ∫\ÊÄñ§Uˇ å±éc˝ú+˛∂v≠Ãvª ª“Æb∫Ä˛‹.¬∞~lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÿ\◊Ù˝ŸØı[àÌmì´ ¡GÀ‚Íﬂ‰˝¨ÛóÊ?¸Êe•Ø;?'[˝bM«÷ÆX«˘QA…'¸ÙÙø‘lÛGú<ˇ Æy „Îzı‹óN	*¨hâ_˜‘KH„ˇ `∏#…ñaÛ¥æñÖg$ÍR8ƒøÎÃÙå´Àü˘9È?Àˇ ˘√@∑>n∫7Rı6ˆ‰§cŸÊ?Ωì˝á£ûÇÚÁî¥ü,€ãM“HGQØª∑⁄vˇ )Àa∂lŸ≥fÕõ6lŸ≥ceçeSn¨?#ü=ˇ &úË?ò∫t-±ä¯€üˆE≠ø„|˙õ6lŸ≥fÕõ6lŸ≥fÕõ6lÇy◊Ú; ^q‰˙ùÑkpﬂÓ¯u%|K«OS˛z¨ô¿¸Èˇ 8Sy)¸≠|≥ØQ–‡ˇ %ö:∆Á˝h‚ŒÊÔÀ?1yA Îñ[(4ı
Úåˇ ´<|¢o¯<'—µÎ˝qw•‹Kk:Ùx]ëø‡êåÏ˛Mˇ úøÛ^ã∆-]b’ LÉ”ñû”D8ˇ »»ü;ØìÁ,¸üØÒä˛I4ªÉ⁄‡U+˛LÒÚJï/•ùÉN‘Ìu8VÍ∆hÓ nèSÚd™‡úŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6’µã=ŸÔµ)£∂∂åU§ïÇ®ˇ dŸÁÃø˘Ãõ;>v^MáÎRÓ>µ0+>1C…/˙“zk˛CÁò|€ÁçgÕ◊&˜]∫íÍ^‹œ¬µÌk˚∏◊˝E\8Ú‰˜ô|ˆ‡h∂åmÎF∏ì‡ÖÁ´}∫,^£ˇ ìû°¸πˇ úA–4.~cs™]äLÇ∞)ˇ åno˘Í‹˝ıù‚Œ ñ⁄“4ÜTE
™<W·\[6lŸ≥fÕõ6lŸ≥fÕü<ºﬁø·ﬂÃ´ô¬ﬂWıáÀ÷ıó˛>ÜÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ll∞§»cïC£
aPG∏Œ]Á?˘∆è%˘£îÜœÍ7-_ﬁ⁄Ox®–7¸äÂú'Œ_ÛÜÓü o.›E®D7…˚ô~B•°˘˙π√¸Õ‰ùk Ú˙›î÷çZ"ß˝I?ªˆây{Õö∑ó&˙Œçw5§ΩÃNVøÎ¯_˝ñvø&ˇ ŒeyìK„Ω:ú"Ä∏˝ÃøqÉ»üˆY›|õˇ 9M‰œ1Òä{Ü”ÆÏ]+_i◊î?nô÷m/!ºçg∂ëeâ≈U—É)‰≤ÌäÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕåûx‡Fñf	Yò– :ñc–g¸–ˇ ú∫—¥v>WQ©ﬁäÉ)$[°ˇ X|WÛœåÒvyKœò˙ÔùÓ~∑Ø]<‰R>ëß¸bâ~ˇ [Ì∑Ì6	ÚÂ?òº˘7•°⁄≥ƒw¯bOıÂm´˛Bsì¸åıWÂØ¸‚.ÉÂÓûbo“ó¢áÅ`Sˇ æ‘ﬂÛ€‡o˜Œw{{xÌ£X`Ué4UP  vUS6lŸ≥fÕõ6lŸ≥fÕõ6x˛rvƒÿyˇ Q+∑®aî≤ä:ˇ √ÚœxhW¢ˇ O∂ºâ°éO¯%É≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÿçÂî±5Ω‹i4-≥#®e?5oá9/úøÁºôÊ.R€@⁄m√oŒ‘ÒZ˚¿¸·ß¸cXÛÖyÀ˛pﬂÃ∫W)¥)°‘·¢◊“ñüÍH}#ˇ #ˇ ÿÁÛïµ_.Õı]b“kIñT+_ıyl√˝\Âè<ÎûVó÷–Ôg¥j‘à‹Ö?Î«˝€ˇ ≥\Ó>Lˇ ú—÷¨x√ÊKHØ„Ô,_∫ìÊW‚Öˇ ÿ§Y›¸óˇ 9#‰œ5qé+¡grﬂÓ´±È¯		07˚sß#¨äe"†ç¡y≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fŒc˘©ˇ 9ÂÔÀıki_ÎöòZ¬A ˇ ≈Ú}ò˙ﬂº˛XÛ«ôøû~c¸¡ê¶°7£aZ≠¨5X«á©˚S?˘R∞T»◊î<ç¨˘¬ÏXhV≤]M∑.#·PjY˜qØ˙Ìû©¸∞ˇ ú=”tÆﬁoê_\ä´∆HÖO˘m…?¸ìè¸óœDYX¡a
Z⁄Fê¡‚âÖU
´Æ-õ6lŸ≥fÕõ6lŸ≥fÕõ6lÒ¸Ê]á’¸ÂÙ⁄‚ &˙U•è˛4\ıg‰Ìˇ ◊¸ü£‹Rl†SÛTXœ¸G&≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥`]OJ¥’!6∫Ñ1‹@›RTß˝ãÇπ«ºÂˇ 8ìÂ{î∫z…•‹Î¨u˜ÇNK˛∆&ã8Gúˇ Á¸Ÿ°ÚõJÙµKqøÓè	iÔø™9%Œ5´h∑∫<Ê”RÇ[i◊™JÖ±pH<õ˘ØÊo&∞˝	,1˝—<‚?Û¬NQˇ ¬ÚœB˛_Œh√3%Øú-}–}fÿøÎIn‹úœ'ì˛1Á§¥0È˛`¥MCI∏éÍ÷O≥$l|ø…a˚Jﬂ·ÜlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ∞≥Ã~f”ºµd˙û±:[Z«ˆùÕ>J£Ì;∑Ï¢|mûE¸›ˇ úµ‘uÔSLÚó;UkÉ¥ÚÚ)˛Û°ˇ '˜øÂßÿŒmms©\,0#œs3QUAgv> Uùõ=#˘Sˇ 8{u}√QÛ´õh¥å˛Òø„<øfıîüÂDŸÍè.ycLÚ’¢È⁄5ºv∂…—#ﬂ˘ò˝ßÚﬂ‚√<Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûDˇ ú‡≤·©È7î˛Ú	£Ø˙é≠ˇ 3≥µŒ2_˝s»aÔñ3˛∆Y ˇ ÖŒ£õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ∞≥_Ú∆ôÊ¶±k‹'ˆe@‘ˇ WóŸ?Â.pˇ ;ˇ ŒyTÂ?ógìMú‘à⁄≤√_ìüY?‰kˇ ©ûh¸∆¸óÛ'Â˚◊W∑ÂhMÊ/é&¯ˇ ›líUF¬ø"~cÎ~Fº⁄√B«Ì∆wéA¸≤≈ˆ_˝o∂ø∞Àû—¸úˇ úé—ˇ 0X]R«Y•=oÜC¸÷“µˇ õ˜øÒìÌÁ]Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸœ?7ø;4èÀkNWGÎå´XmP¸M˛\á˝’˘µ˛ÎWœ~b˛gÎ^æ7˙‘≈îÈBµDÏ≈¸I€˜è˚Má?ï?ëz˜Ê4°ÏìÍ˙röIw(<>“ƒ:Õ'˘)ˇ ø3⁄_ñíæ_¸ªÑ2/RıÖ$∫ñÜVÒ
›Qˇ ≈qˇ ≥Áˆ≤{õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ2ˇ ŒpYr”¥ã∫w<—◊˝uFˇ ôY)ˇ ú;Ω˙«í}*ˇ qy2}‚9ÊfwŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6%wi‰Oorã,2Æé+’Y[·aûc¸‰ˇ úEäq&Ø‰p#ìv{?Ã,çˆ¸S'¡¸éüc<≠wiu•\µΩ =Ω‘FV]}æ“≤Á•ˇ #ˇ Á,€”–¸ÓÂ‚Ÿbæ;≤¯-ﬂÛØ¸_ˆˇ ﬂºøº_W€‹Gsœ,ë8¨§ Ùea≥)≈3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÊøû_ú∂øñ⁄W®ºe’nA[hèy•ÔË«ˇ %˜k˚Lû◊µÎÔ0_K™jíµ≈‹Ì…›∫ìˇ ™˝ïE¯U~œD~EŒ+>™±k˛sFé‘—‚≥5Wê~À‹˛‘qü˜◊˜è˚|?o÷÷VPX¬ñ∂ë¨0D°QU¢™Æ 1lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6l‡_Ûö^∑îmÓ;√}˙9ó˛i¬ﬂ˘¬;Œz•k˛˚ªWˇ ÉçW˛eg£ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥g5¸ﬂ¸â—ø1ÌÃìm™¢“+§ÌˆRuˇ wEˇ üÓ∑\ÁÊÂ÷±‰=@Èö‹&7‹«"Ôã˛¸Öˇ h√ßÌ™‰ÁÚG˛rR¸Ωït˚ÓWö#ä~(´÷Kbﬂ–ˇ vˇ ‰?«ûﬂÚøötÔ4ÿG´h”≠≈§£·eÏ{£Ø⁄Iˆëæ%√\Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6C5?4¥œÀ≠)µ=DÛô™∂Gïˇ ïï˝€'Ï/˘\æ}y◊ŒöèúıIµ≠^OR‚c–}îQˆ"âf4˝ü¯&¯Ÿõ=ˇ 8π˘&ÙºÈÊ8´£Y@„ØÖ‹äg˛Y◊˛{æÛ’˘≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ ú≥¥ı¸ÖvÙØ£4ˇ %?˘ôúﬂ˛prÛ˛;Vß˛]ú…u9Í¨Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ∞áŒæF“|Èßæï≠¿&Å∑S——ªIıG_˘µπ.x_ÛóÚ'U¸∑π2µn¥âë\®È^ëNøÓπ·$˝è⁄D(¸¨¸‹÷?.o˛∑¶?;iıÌúüN@?‚ÿï~%ˇ )9&{«ÚﬂÛ7H¸¡”WS—‰‹PMS‘âøíEˇ à?ÿŸ…flŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ!ﬂööZWÂﬁò⁄ñ¶‹•jà R9 ˇ  ø ã˛ÏìÏ«˛∑o˛a˛aÍû}’d÷5w´∑√kˆ"J¸1Dø ?‡ùæ6Œπˇ 8›ˇ 8˛iñ?3yé2∫Dgî0∞ß÷~”À≤˘ˆ>«<ˆÇ"¢ÖPÅ@@2ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fŒmˇ 9mıè Í…·?¸ëø¸kú˛päÁéµ©€ˇ =™?¸Òˇ ôôÏŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥`]SKµ’≠d∞øâ'∂ôJIä´ŸÜx≥ÛÎ˛qÆÁ…fMsÀ·Ó4BjÎˆ§∑ˇ _ºê,ø±˛Ìˇ ~?'ÚOûu_%j)´ËìgMàÍÆøµ©˚q∑¸‹º_‚œx~N~uÈôV<‡"N%Ω´◊˛,ã˝˘7Ï˝ô? Ëπ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕú˜ÛÉÛ£J¸∂±ınàüQïO’ÌT¸LûO˜‹*~”ˇ ±èìgÉ|ÒÁùWŒ⁄îöæµ)ñwŸ@Ÿf(ìˆ#_˘ππ?≈ùã˛q€˛q∆O5º~cÛ,f=O(°jÜ∏#ø˘6ﬂÂªæ |?{>RXaPë†
™¢Ä≤™®Ë£õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÑ˛wCÎy+Y_)õ˛yˇ ∆πÊ˘¬ÀÇûn∫ã≥ÿI¯I{S6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≤§çdRé+"†ÉÿÁíøÁ ÁÕàóÃûMàµ∏´‹Y†©NÌ-™˛‘ÕÏ∫˛Å<Â†yÇ˚À◊±jöTÕowrGC∏ˆˇ )[Ï≤7¬À∂{õÚ'Û˛«Û‹X^Ò∂◊"ZºU¢ Y≠Îˇ €è¸§¯≥ÆÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fŒ)˘„ˇ 9%ß˘$“trózÂ(Vµéjz}©?ñˇ =8~ﬂâµˇ 0_yÇˆ]OUôÓ.Ê<ûG5'˛iU˝î_Ög=ˇ 8ˇ ˇ 8æ˙è•Ê?8ƒR◊gÇÕ≈ù÷Kï˝òøñµ'˚≥˜û∏é5âDqÄ®†  † t c≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ"ﬂöë|ß¨ Íl.zˇ ∆'œ#Œø;¸÷s¯hŒ{ã6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ5ˇ ŒAˇ Œ1¶±Í˘ì æ›Á¥QA/ví˚3ˇ 4foŸ˝Ô˜ûJ¥ºª“.ñ‚ŸﬁﬁÓ›Í¨§´£©ˇ ÇVSû’¸Äˇ úé∑Û≤&áØ2¡Æ(¢∂ ó ¥ùíÁãˆæ‹_¥ë˜LŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ±ÎË, {ª…"RŒÓB™Å˚LÕ≤Áî?;?Á,§ºı4_$3GÎ%ı(Õ‚-TÔˇ ≈Õ˚œ˜ﬂ∑ûk≤≤ª’Æí⁄’‚Ów¢¢ÇŒÏ}æ”1œa~DŒ.€˘s”◊ºÿã>¶(—[Ï—¬{3˛Ã”è˘ÏÛoè=õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥dCÛÇÏZy?YòöR∆‡},åÉÒlÚè¸·•´KÁ9e·ä∆ROÖ^$ˇ ç≥€π≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6l‡øÛê_Ûç˘≈d◊¸∫´¥£îëÙKäxˆKèÂìÏ…ˆe˛uÒ|]iWF)C€›€Ω5WGSˇ éçû¬ˇ úyˇ úîèÃÇ?-˘¶@ö®¢¡p‘?ÇIŸ.‰ˇ ¸d˚~àÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸœ4?<ºΩ˘yMB_^¸ä•§D~…ìˆaOÚ‰ˇ `Øû0¸‘¸Ò◊ø1¶+~˛Üû¶±⁄DO¶)—§˝©§ˇ -ˇ Áö&˛]~WÎ~ΩZ,%ïHıf}¢åx…'¸Eîç˚+ûﬁ¸°¸ä—. @>≥™:“[ßˇ i!_˜L_Ô˛ÏvŒìõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fŒkˇ 9#p`Ú¨√bcç‡•â?„l·?ÛÑ6¡µùR„∫Z∆üOÀ˛eÁ∞3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ç~}ˇ Œ=⁄~`@⁄¶ñﬂ]â~Ë≥Å“)ˇ Àˇ }Õ˚?a˛±·ÕSJº—o$∞øçÌÓÌﬂã£ä2∞ˇ ?á=Sˇ 8Ûˇ 98/=/,˘∆jO≤[ﬁ9Ÿˇ ñ+ñ?Óœ‰õ˝Ÿ˛Ï¯˛)=?õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6%yyî/stÎ1©gw!U@ÍÃÕ≤ÆyGÛõ˛rﬁYÃö?ëÿ«™ΩÒÃ*7ÿ_¯π˛?‰T˚yÊg{çF‡≥óûÊf‹öªª1˙Y›ézÚè˛qP÷Jj^q-cg≥e⁄gÒg¸≥Ø¸ñˇ &?µû∂Ú˜ó4ˇ .Y¶ô§@ñ÷ë}îåP¨{≥∑Ì;|m˚Xcõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕúü˛rù¯~_Í>Ìn?‰¥Y…?Á#≠÷≤˛€ºÕˇ 4Á¨ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ úè¸°—º’£\k◊.∂zÜüH.i≥"^Ñ‡o"ü˜WÌ£˝ü⁄F~wø…_˘ MC B=#Ã|Ô¥ëEI+Y°‰ñ˛˙%ˇ }øƒøÓ∑ˇ uÁ±ºπÊm;Ã∂I©ËÛ•Õ¨üe–◊~Í√Ì#ØÌ#¸kÜy≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ Îz›ûÖg.ß© ∞Z@•‰ëÕ ¯ˇ *˝¶oÖs¬ˇ ûüÛêˇ òóadZ€CâækFîéì\”Ø˘}àˇ  è!üó_ñzœüÔ∆ù¢≈ î2Ã€Gü⁄ïˇ ‚(ø˛ Á∂ˇ ) t/À»ñx‘]Í§|wR(®=≈∫oË'˙øºo€ì:vlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ…?Á*ˇ Ú_ÍÎ€ˇ …Ë≥ïŒˇ ≠ˇ ©k˙ÁœXfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ5Œf~b}GO∑ÚÖ£“k¬'∏°È›!ˇ å≥/?˘„˛VFÁˇ Á¥ﬂ8˘bÎTÛ
:µÛ≥ë5é™”ßÏ∑©/$‚ÍÀ∆/Ú≥ñ˛l˛EÎüó3∫_¨Èåi‹`5Ë≤Ø˚¶OÚ[·o˜[æ~_~fÎ~BΩ˙ˆá9J”‘â∑äA¸≤«ﬂ˝Ôˆ=ß˘Cˇ 9°˛`™Y»EéØMÌ‰mú˜6“ª„˜ø‰≤¸y’ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕÄuΩr«C¥ìP’'KkXÖZI ˛≠¸™ø~Œx[ÛÛÛ‚ÁÛÛÍV<°–Ì⁄±Fv20€ÎÊˇ }«˛Î_ÚŸ∞ãÚwÚwR¸ ‘æ≠mXl! ‹‹ë≤‰OÁôˇ a?Ÿ7¡û¯Úgí¥ø&È—È,"x˙˜go⁄íW˝π˘ø‡~<Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6r_˘ ï-˘®S≥[ü˘-rè˘¡∑ÁZ^Â-è‹gœXÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥`}B˛:⁄[€∑¡4í9Ë™£ì±ˇ UsÁÆ´w®~qy‡ò™%‘ÆF˛ú#eØ¥ÈŒOˆmüA4-€C∞∑“¨WÖµ¨kc¸ïE ˛l{eÙ/kuÀÄ´£Ä ¿ıVVŸÜysÛè˛qæ¶≠‰ov{?ı#…ô?ÿIˆcœ.›Z›iw-¬=Ω‘FV]xÉFF\Ù?‰Ô¸ÂµÊèÈÈ>sÂwf>ªÃÉ˛.ÒüÂ}ˇ s÷⁄.πcÆZG®is%Õ¨¢©$f†ˇ oÛ/⁄\õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥`MWW¥“-û˚Qö;{h≈^I*ÅÓÕûr¸Ãˇ ú»≥≤Áe‰ÿ~µ(®˙‘¿àáºP¸2K˛¥ûöˇ í˘Ê?8y˚[Ûçœ◊5Îπ.ûøcD_h¢ZG˚√ èÀkØÃMr=÷EÑq2À#~ÃjT;*˛€¸k¡?‚+üA¸ï‰Õ7…∫\Z.èßmÎ˚N«ÌÀ+~‹è˚M˛≈~8yõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÀ?Á'‚2~_Íî˝ë˚¶ã8ﬂ¸‡ÛRˇ X^Ê‹“g≠ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥œüÛò_òﬂ°tH¸±hÙ∫‘œ)hwXÔˇ #‰¯? Dôr9ˇ 8a˘u≈.|Ávªµm≠k‡7∏î}<aVˇ &eœSfÕú˜ÛSÚ?A¸≈Äõ¯˝AE#ªàPS¢…⁄hˇ »˘Ê…û)¸–¸ô◊ø.Æ8jë˙ñni‘`òﬂÿü˜TüÒ\üÏ9Ø≈Åˇ -?6µœÀÀø¨ËÚ÷ Ànı1H? OŸÂï>?ˆ?{èÚóÛìH¸…≤3ÈÁ—Ωà^Ÿ»ÊüÂ/˚Ú˚2Ø˚>‰˜6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ç˛oŒLhûEÁßÈÙ‘uuÿƒç˚∏œ¸ºJ?hæS˜üœÈÁé¸ˇ ˘°ØyÚÁÎZÌÀH†’!_Ü$ˇ åqá˝õrëøiÒ˛@¸©Ûü'Ùt;Ví0hÛø√Ø)€˝Çsì¸åÙ]ü¸‚VëÂü/Íñ≥+júVsºajê∆‚7dd_∑+#~‘ç√˛*Œeˇ 87ßÁÑ_Áµù‚/ˇ ÁπÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6s_˘…˝O Í¬ï§qü∫Xõ8W¸·¥÷5HÎ±∂å”‰ˇ Ûvzˇ 6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕâ‹\GmO3é5,ÃM  Uò¸Ü|ÙÛ∆ª}˘ªÁf{ YØg[{U?≥<"Â¸£çfó˝i3ﬂ>SÚ’Øñ4´]ƒRﬁ“%ç|M>”∑˘R7'Úõ≥fÕÅu=.◊U∂í∆˛$û⁄e‚Ò»°ïÅÏ Ÿ‰?œo˘≈©<ºíÎ˛Q6ûµy≠MY‚Y‚?jXWˆó˚ÿˇ ‚≈Â√É˘[Õ:áïµµ}"S‹™√°¥éø∑˝óF˚YÙÚoÛr«Û+I∞Ù4[´zÓåiö?›m˛√Ì#d˚6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6l®j˙uºóó≤,6Ò)wë»UUYòÁèˇ ;ˇ Á*nı÷ìEÚ{Ω∂ù∫…r*≤À„È~‘ˇ …gˇ ä˛∆yˇ J“o5õ§±”‚{ã©öâ`≥1˘ıOÂ/¸·Ù6·5?;∞ñ]ôl£oÄÃD´˝Á¸cã‡ˇ ã$œKÈ⁄m∂õYÿƒê[ƒ8§q®UQ‡™ª	Êã¨È7êuı-Â_Ωs√_Ûäó>èüÏˇ ª·?‰îçˇ Áæ3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6sˇ œ¯Ω_"Î
7•±o¯V˛Áo˘¬YiÊ=B?Ê≤Ø›,_ÛV{'6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕú/˛r€Û¸9Â±¢ZΩ/5bc4;¨+˝˚œOÜı^OÂŒ}ˇ 8c˘uıãõü9]ß¡m≠j?má˙D£˝H ƒøÒñOÂœZÊÕõ6lŸ„ﬂ˘ »%–›¸ﬂÂÿ∏ÿH’ªÅ—1?ﬂ∆£§7€_˜Sˇ ≈o˚æ1˘e˘â‰jkO5
xÕh≤∆ºâø‚Hﬂ±'œ¢æVÛ-óôÙ€}gLR÷È°Ó?ô˘]‡u˝ó\4Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6‘µ+}2⁄KÎŸhºí9¢™®´3üÁﬂÁÌﬂÊ—”ÙÚ–hP∑Ó„Ëf#§Ûˇ Ã®ø›Òì"ñ_ïö«Ê†4˝!)PÕ;◊”âOÌ;wc˚Ø∆ˇ ÍÚe˜OÂg‰Êâ˘siËÈë˙óé öÍ@=Gˆˇ ä‚˛Xì˝ó7¯≤uõ4bThœF}˘Û„ÚŒõ˘Ö¶!ÿ≠”≈ˇ ≤Cˇ g–úŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕêøŒò}o%ÎIˇ .3üπÚﬂ¸·|¸<·q~›ÑΩ¸$ÄÁ∂3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lƒÄ*v>|~p˘∂ÁÛCŒ≤~é¨±º´gdÉ∫ÜÙ—á¸fëöo˘ÈûËÚî-¸ù°⁄h6î)kR√ˆú¸R…ˇ =$f|?Õõ6lŸ±+À8oa{[îY!ïJ:0®ea≈ïáÚ∞œüüï2~]kÔg'Mπ¨∂éw¯+ÒD«˘‡oÅø»Ù‰˝ºÈÛáøö¶j/‰ÎÁˇ EΩ&Kjü≥0c⁄x◊˛FGˇ g±3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6xÔ˛r”Ûïık÷Ú^ì%,≠X}mîˇ y(ˇ tˇ ∆;⁄ˇ ãˇ „Á"¸©¸∞‘?1uÑ“l~Vèq9X£ÆÌ˛S∑Ÿâ?mˇ …ÊÀÙ…H”<ó¶E£h—Ì„ìª;~‘≤∑Ì»ˇ ÛjÒN+áŸ≥fœûza:Êl`¸"ﬂZ„Ùé?Ò˙õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≤9˘ïoıè,j–“ºÏnG¸í|Òﬂ¸‚˛óû?ﬂñ≥Ø¸Eˇ „L˜>lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕúø˛rGœ·/']…ÒªΩˇ DÜáz»™√˝H≠_Á„ûˇ ú8Ú’ıÈº«rµÉLJG^ÜiAU?ÛŒ/Pˇ ¨Ò∂{C6lŸ≥fÕõ9g¸‰èÂ˙y√ W&5≠ÌÇõ®ÄVhˇ Á¨<æ˜Áß¸π‡ù'TüIºáQ¥n“$±∞Ï»y©˚∆}6ÚæøòtªMb€˚´∏ReˆÊ°∏¸◊Ï·ûlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ!úﬁ_"yfÔXRœJ‹Û?√œá≈+ëgŒÇfΩûßî≥Ã˛Âôò˝ÏÃŸÙ7Ú;Ú¬Àﬂ/C`T}~p%ª~ÊB?ªØÚ@?vüÏüˆ€:lŸ≥gœ_Œ»Œâ˘â©J61ﬁ≠¿ˇ e¬„˛7œ° ≤¢»õ´ G»„≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥bs‹≈n9LÍã‚ƒ¯·%ÔÊólkıΩNŒ*uÁq?ã·ﬂÁœëÌ?º÷-O˙èœ˛M¬Kœ˘ _ [l5)ˇ "	èÎçF‹ˇ Œa˘"±ı…‘Ñ˘8Ò·Eœ¸Ê«ñh,oüÊ"_˘öÿ[qˇ 9¡¶Ø˜DÌ˛¥ ø©$¬Ÿˇ Á9øπ—E? ∫˛êa|øÛúô∫“`S˛TÃ„D¿íˇ Œm˘Äˇ wßYØÃ»„u¿“Œk˘•Å	e`æ¶üÚ[µO˘Ã/6j6≥YKob#ù6"9+≈á•f9ÀºÅÁªˇ #j—Î∫PçÆbWP%îáRç…Uê˜˛lÍˇ ŒcyŸÕTY' ˇ ç•lˇ Ûó>{nì€Ø ˛8ãŒX˘¯öã»á∞∑ã˛hƒO¸ÂWÊˇ •Ç“<?ıK7˝WÊ˝\˛ë·ˇ ™YøËjø0?Í‡øÙè˝RÕˇ CU˘Åˇ Wˇ §xÍñ=Á+º˛¢Ü˙3Û∑á˛©‚…ˇ 9iÁ’ ®[‹€«¸Gˇ 9}ÁîÎ%´|‡Ò´.
ã˛s+Œâˆ£±ú/ˇ Ã∏:˘Õo5/˜ñV˛¬Qˇ 3∞|Ûõ⁄–˛˚Kµoı]◊ıÛ√+o˘Œ9á˚—¢©‰\ëˇ Å∞÷€˛sáNo˜£Hù?‘ô[˛$ë·µß¸Ê∑ï§⁄‚ ˙?í∆√˛O.ZŒ^˘Ô$πá˝x	ˇ ìFL<≤ˇ úñÚﬂŸ’Q	Ì$Rß¸N:a˝èÁìÔ∂∑÷,I=åËßÓv\êŸk⁄}˛ˆó0Õˇ ‰Vˇ àúõ6lŸ≥fÕõ6lŸ≥fÕõ6xõ˛sœü¶¸»öªV€JN-NÜi(Úˇ ¿'•˘/Íg§?Áºâ˛Úç•¨´∆ÓË}jr U˛1EÈ«˛≤ÁIÕõ6lŸ≥f t
∞™ëBqü5ø4|§|•Ê]CD°€Œﬁùﬂm˚»?‰ì¶z«˛pÎÕˇ •º≠&è+Vm2b†≈r÷Xˇ ‰ß¨øÏsºÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ<sˇ 9üÁÉ¨€yb˝ÕÇz“Å˛˝î| ˇ ∆88Òˇ åÕëØ˘≈ è3y≠uÖÂi•(∏jÙ2ì∆Ÿ‡˘Mˇ <s›y≥fÕõ<+ˇ 9w¶˝Sœ2ÕJ´h%˚ó–ˇ ô9ÏèÀùLjû[“Ô´S5ú~f5Âˇ í,Ÿ≥fÕõ6lŸ≥fÕõ6lŸL¡EX–Á#⁄øÊ?ñÙj˛ë‘Ï‡#ˆ^tˇ ÀñBµo˘ ?!i’P7;Cçˇ Qcˇ á»v´ˇ 9ØÂ»	7ót/¬0·Âo¯LàjÛúÔQßÈ∆;fg¸!ˇ âdSQˇ úƒÛ≠’}™[””Ñí?‰sÀë}G˛r;œ∑‰˙ö¥®hñ8ˇ ‰“!»Œ°˘ìÊmDìy™ﬁÀ^Õq!<ÈÑ7ì\ûS»“b^#ä√m,Êë#9POÍ√k_$k∑üÔ6ùw-í	˛"òsk˘/Á;™¥k⁄ÌØ¸L.[Œ8˘˙„Ïi2äˇ ;∆øÒ9-ˇ Á|˝-X«ö‚/¯’€aˇ ú=ÛºÉ‚â˛¥ˇ ÛB6É˛p∑Õœ˝ÂÕÇœI¸»¡—Œ˘àˇ y®Yó™ÊZ‡òˇ ÁuÉNz•∞Ò§nÊú]Áµ
¸Zº {@«˛fcˇ ËGoÍÒ˝#∑˝U≈„ˇ úîÔ&¥£Ÿmâ˝s‡»ˇ ÁÌá€÷ú¸≠Äˇ ô¯∫Œi¿|Zºƒ˚@£˛fTŒi4ﬂUπØ¸cOÎóˇ BA§’÷Á˛E¶o˙#˛Æ∑?Ú-3–êiıuπˇ ëiåo˘¡˝,üáV∏ﬁ$?Ò∂"ˇ ÛÉ∂DûÃ†v≠∫ü˘ö04øÛÉi∑ß≠üz⁄ˇ ◊¸/¸‡Âÿ˛ÔYå¸Ìàˇ ôÕÄÊˇ ú!÷˜Z•≥Ú£q˙π·|ˇ ÛÖiAXØlÊ“è˘íp≤„˛pÁŒ—}Ég'˙≥¯ﬁ4¬Àü˘≈?CR∂Q…O‰∏ã˛7t¬{Ø˘«_>[}Ω"cO‰hﬂ˛Mªa5ÔÂõÏ∑üGæP;ãy˚’NﬁyoS≤ˇ z≠'ÜüœØ¸Ip∏Ç6=s+5ÑaæüÁkNß‘ØÓ†ß˚Óg_¯ãd£N¸˛ÛŒüOGXπjøHó˛O¨ô,”?Á/|ÒiO^Kk†?ﬂ∞ˇ &9/“øÁ7ı jZLéÊZ?¬Eü&zG¸ÊØñÆ(∫ÖïÂ±=‘$ä>ûqø¸&MÙo˘…!Íî©,ftxˇ ·›=?¯|ùh˛m—ı†ó{ot˚ÊT¯É6ÊÕõ6lŸ≥fÕÑ^{ÛdQ—/5€™¥âú˚Mˆbè˛zHQ?ŸgÖˇ %|©?ÊOù·:Öfå ◊∑å{™∑®¡ø„4ÃëœL˙õ6lŸ≥fÕõ6y˛s[ V‘Ï<…¸QõyH˛x˛8…˜xﬂè¸Ò»Ø¸‚?õˇ By¡t˘Zêjq4√ö˛˙ˇ ÒØ¸eœsÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕâ^]«gó3∑¢VwcŸTrc˜gÃø:˘ñ_3ÎW∫‹ıÂw;ÀCŸI¯˝ÇqLˆè¸‚oìFÅ‰¯ÔÂZ\jén˜‡?wnøÍ_U„.våŸ≥fÕûEˇ úﬂ“Lzûï©Å¥∞K	?ÒçñAˇ 'Û≥ˇ Œ1Íˇ §¸Ößj	 oˆ?˘'√:ûlŸ≥fÕõ6lŸ≥ceï!S$å‰ì@>úÑ˘ÉÛª…∫V˚V∂ÊΩR&ı[˛ﬂ’lÁÔ¸ÊïlÍ∫mΩ›Îáä∆á˝îçÍ…,ÁzÁ¸Ê÷∑=WI”≠≠ÅËfgîˇ ¬˝]Äk_Ûì>|’jRkt?≥nâ¸:Ø´ˇ %2	´˘ªX÷I:ùıÕ—=}Y]ˇ ‚lp£4Ø'Î:Ωùcss_˜‘.ˇ Ò91“øÁº˘©S““•åÛ2E¯LËﬂπ/“ˇ Á|ÂuCu%ù®ÔŒVc˜EØ¸6JÙœ˘¡€Ü°‘5Ñ_ø·ûHˇ ‚)”øÁ
<∑ÌıÏ«¡qè˘7)ˇ Ü…5á¸‚gêÌiÍZÕpG˚Úwˇ ôF,ëÿ˛Ay ûñèli˛¸S'¸ûi2Ce‰.ÿSÍöeúTÈ¬ﬁ1˙ì`¥Ü‹qÖÇÄ?V+õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6l{Â˝:˚kªX&˝˘∑¸Ir;®~Ny:˛¶„G≤$˜XﬂCë≠G˛qw»7ªç8¬ﬁ1M*ˇ ¬˙åüπ‘øÁºßqΩ•ÕÌπÊé>Áãó¸>DıO˘¡÷‹È⁄¿>4Òºrˇ ÃºáÍøÛÜûp¥©¥ñŒÈ{ëïæÈcEˇ á»f≠ˇ 8ÒÁΩ.æ∂ì4ÄwÑ¨øÚa§lÑÍû^‘¥ì«QµûŸº%çì˛&´ÄQŸe$–åïhö˛k–®4ÌVÓ%’fO˘'8ˇ ·s¢h?Ûòt”®∑¶⁄˝_V.-ˇ naˇ àgIÚ˜¸ÊÓü-\”%Ñ˜{yAˇ "ÂÙO¸;gOÚÁ¸‰áëµ⁄,Zí[»b‰ø·‰è¸îŒãeo}û“Tö&ËÒ∞e?Ïól_6lŸ≥gñÁ4¸ˇ ≈-<üj€∑˙U»©oˇ eÍHÀ˛LMíè˘√ﬂ ˛ÖÚÙûaπZ\ÍèTØQd¨Ú2OQˇ  OK;ˆlŸ≥fÕõ6lŸÀˇ Á$¸°˛&ÚUÚFºß≥Ó?≈ºü|UœËöº⁄5ıæßji=¨©2ÚëÉØ¸G>úh:ƒ:’Öæ©jk‘I2™Í‚X;6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕúØ˛rkÕ_·Ô$_n3^Ò¥O˘Î˝Ô˝;¨Ÿ·/h≥köç∂ïmº◊sG
¸›Ç∆ŸÙÁJ”a“Ì!”Ìám„Hêx* ãˇ 
∏+6lŸ≥güÁ4¥_≠y^◊QQV¥ªP}ñEeo¯uãŒkX–u)çMµ–îïˇ ƒ†|ÙnlŸ≥fÕõ6S0PYç ‹ìêO4~zy7À<ñˇ SÖ•^±¬}WØá=N?Ï¯Á#Û7¸Ê÷õ(Ù:[É–=√à◊ÁÈ«Î;¡GúßÃüÛñ~v÷*∂”Eß∆{[∆+O¯…7¨ˇ <sòkûo÷5ˆ/´ﬁ‹]ìøÔ•g@cAÖñˆÚ‹8äiÙUìÙõË?ë~t◊hl¥õêç—•_E‡ÆY—t/˘√5^Qµ+ãK5=G&ë«˚◊”ˇ íπ–tO˘¬=[S∏∏=ƒ(ë¯¨ûhﬂÛãæC”(∆¿‹∏˝©Âvˇ Ñë¬dÁHÚó¥j~ç”m-»Ô(ß˛/,>õô≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f∆ÀJ•$P zÇ*Dıø /)ku7˙M§åz∞âQø‰d\˛9˛πˇ 8Å‰≠B¶ÕnlXÙÙ•‰?‡nﬂÒ,Á:ˇ ¸·⁄U¥]V9<‚"üÚR#/¸öŒiÊ˘∆/=hµo®}n1˚VŒ≤…?Üo˘%úﬂT—o¥ô=Fﬁ[iñTd?.—º≈©hí˙˙U‘÷íıÂåá˛ÆuO+ŒX˘◊D‚óSE®¬?fÂ*∆XΩ)?‡˘ÁcÚü¸ÊûÖ{∆-~Œk=^"&èÈ˛ÓUˇ cô⁄|´˘èÂÔ6(m˛¶"º¿q˛¥/∆Uˇ dô#Õà_ﬂCß€Àyt¬8 FëÿÙUQ…€˝äÁœ;â/8<Ùx‘I™]Q{˙péüÚ"Ÿ?·3ËVó¶¡•⁄Caf°-Ì„X£QŸPpAˇ 0NlŸ≥fÕõ6lÿ…°I—¢îGXÑàœôˇ òW*Î˜⁄◊˝wEØtØ([˝úE=ãˇ 8ãÊˇ ”~Pt≠YÙ…ZwÙ€˜–ü¯gç„vÏŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûOˇ ú›Û/)¥ø/°ŸK©˙«—á˛!>@Á<±˙gŒ–›:÷->).Oá*z1√Àœ˝Ü{ª6lŸ≥f»Áﬂóˇ Oy'U¥Q…“:éıÑãçø‰_ÛW¸·èò~£Êõç-Õ˙’®<^"$_˘$fœjfÕõ6ld”$eïÇ"äñc@π9ÀºÂˇ 93‰ø,rà›˝z·k˚ªAÍoˇ ™∂ˇ ÚW8wõøÁ4ı´ŒQyvŒ+(˚I1ıd˘Ö¯!_ˆK.q4˛gyìÕd˛ö‘'∏C˛Î.V?˘ø·2=ki5‹ÇdiemÇ†,O…W|Ë˛Xˇ únÛ«ò(ÒiÔm~›—¯˝˜¸Y÷|µˇ 8C+Qı˝QW∆;XÎˇ %¶„ˇ &3©ys˛qc»⁄5KGΩê~’ÃÖø‰özpˇ …<ÈZ7ñtΩ=-*“DÈHcTˇ à√,Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕÅµ2◊Qà¡}sƒz§äO˚g5Û?¸„/ëı˙±±˙úßˆÌX«ˇ $˛(?‰ñr5Œ\FO.jK'ÑWHTˇ »ËyÉˇ "W8œõ#<·Â^O®È“¥+÷XG™î˛bÛ·ˇ =8d9^(Íj4 ÁQÚ_¸‰∑ú¸Ø∆1wıÎeßÓÆ¡ìoij≥Ø¸ç„˛NwÔ#ˇ Œdy{V„òaìLú–ΩÜøÎ ıS˛E7˙¯ü¸ÂÊÂÇ˘N=?B∫äÂµÜ·Œ)FõtÈÕΩ8∏ˇ +Iëü˘¬ﬂ UÆ¸·tª
⁄€W«g∏ê…8ïø„*Á´3fÕõ6lŸ≥fÕõ<mˇ 9£Â®k÷û`âi¸>úÑø!⁄ß˝h^5ˇ ûx[ˇ 8wÊˇ —>j}V§:ú% ÌÍ≈Y£ˇ í~∫ˇ ≤œmÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕü?øÁ&º√˙kœZÅSXÌJ[/∑¶†Iˇ %Ω\ÌÛÑ~]Ùt›O\qºÛ%∫h◊‘z¨”ß¸zg6lŸ≥fƒÓ-“Ê'ÇQ 9´‹B3Áèñn$¸µÛ¸^π*4€ÛÑ˜èëÇFˇ e3g— A3fÕë:~gyw…q˙öÌÏVÔJà´ Fˇ RÂ!ˇ [èÛ«ûøÁ5d~V˛R≤7‚ÔsÛKxœ˛ŒVˇ åy¿|ﬂ˘ôÊ/89}r˙kÖ&¢2‹cÍ¡ó˛	ÙmP◊'öU¥∑Sûâ
3üπŒ…Â˘ƒ6Î!e’:\'ﬁ∑9)Ì5_ˆ2Kvœ)ˇ Œ˘KH„&™”Íré¢FÙ„ˇ ëP—ˇ ‡Ê|Î˙îtè.«ËËˆpZ%)˚®’Iˇ YîroˆXmõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≤Á…œ*yº3j˙|/3ªêzr|˝X∏;≥Âú#ŒﬂÛÖrü óıÍDc[àá¸JˆyÁˇ 9˛Wyè…éW]±ñÎA-9D’ö>Qˇ ±ÂÀ"πËØ…?˘ x<üß€˘sZ±PÄIÌ∂qR]öXúÒïã7&dtˇ Q≥’æQÛ÷ãÁoÆËWq›E˚AOƒæ“ƒ‘í3˛∫·ÓlŸ≥fÕõ6lŸ≥ëˇ ŒR˘C¸E‰´ôc^SÈÏ∑i„D¯fˇ í#ˇ ∞œ˘[_õÀ⁄≠¶±o˝Ì§—Ãè«˝óŸœßn°£mÌ≥rÜx÷DoaÕO¸	¡≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fƒÆÆR÷'∏î—#RÏ| é|æ◊uG’ıùJ_∑s4ì7Õÿπˇ âgæ?ÁÙ–ﬁE”Pä=¬5√{˙¨“'¸íÙÛßfÕõ6lŸ≥ƒøÛòûN:GöSZâi©b{z±£˛E˙/˛À=1˘	ÁQÊˇ (Xﬂ;r∏Ö>≠?è©¡Vˇ åâ¬_˘Èù òøû~XÚhı;ë-ËZ¡Gó˝ö◊å_ÛŸ”<ª˘áˇ 9mÊ_1∂—)§Ÿöè›ûS˛TÁÏœOı€8ï≈ƒ◊í¥”ªK4Ü¨ÃK3‚«‚cù7»üÛçûoÛwñ€Í6mCÎ]V0GäEOYˇ ‰_ÚÛ–æHˇ ú<Ú÷è∆mvI5KÅBT˛Í*ˇ ∆8œ®ﬂÏÂˇ aù∑E–4˝i•[Ek Ëê†A˜ ¡˘≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6biπÈêÔ2~qyKÀu]OT∂éEÎø®ˇ Ú*RO¯\ÊöÁ¸ÊoîÏâ]>ª÷EçO˚)[‘ˇ íY’?Á8oëßi Ïfôü˛4ã˛%ëõﬂ˘Ãﬂ8Ãså#⁄'?Ò9[
Âˇ ú∂Û„˝õòÂ∆¡±ëˇ ŒY˘ız›¬ﬂ;xˇ „U:◊˛sŒ–üﬁ}N_ı·#˛M»òomˇ 9±ÊT˛˛¬≈ˇ ’Ø¸Õ|:±ˇ ú‚πRÊéå;òÓ
˛‰õMˇ ú⁄Ú¸§Ì>Óı1ò‰˛	°…~ëˇ 9W‰=DÖ{◊µc⁄x\√F≤'¸6NÙOÃo-Î¥f•ip«ˆRd-ˇ "˘sˇ Ö…lŸ≥fÕåûﬁ;à⁄ï^7e`#¡îıŒ3˘Éˇ 8•Â_3Ú∏”PÈWçø(b'¸ªc»ñá<√˘èˇ 8ÛÊü#r∏∏ÉÎvø÷mÍ ¸ZüﬁC˛Õ}?¯≥ Zø†›%˛ïq%≠ÃfHò©˘m’|WÏÁ¶ˇ +?Á1™SOÛºtË¢ˆ¸n _¯úÚ'==§Íˆz≈≤_È”%≈¥¢©$lHˆe¡y≥fÕõ6lŸ±Î(Ø≠‰¥∏^pÃç©Ó¨8≤ˇ ¿ÁÃü7˘v_-Í˜ö4ˇ ﬁZNÒ‚—_˝ö¸YÏ/˘«?Œ]|ùkeÆÍ÷óV,÷¸gïQä/≈*ª
ß§Î¸ÛŒé?:ºñO≠X◊˛3ßÎÆ¥¸ŒÚµÊ÷˙µãüs‚x}ioxºÌeIW≈0ˇ Ö≈ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ#^h¸ÃÚﬂï™5≠FﬁŸ«Ï3É'¸âNRˇ ¬g+◊øÁ2|£bJÈÒ]_0ËUhŸLÀ'¸í»6ßˇ 9√tƒç;Hçc,Âø·R8ˇ ‚Y∫ˇ ú”Ûdá˜ñèı$o˘ùÄøËr<Î¸ñ_Ú%øÍÆ/oˇ 9ùÁˇ ºÇ¬AÔÉ˛#6/¨ŒcÎzæôu•‹X[!∫ÇH}HŸ‘Ø51Û
ÊJÒÂ¸ŸÁ‹˜GëÁ%ºÑñ∫Xª{O´√*'âîQGˆ„«˚?œù[BÛvèØØ="ˆﬁÏRøπï\èòCU√lŸ≥fÕõ9_¸‰üÂ·ÛüîÁ[dÂ}`~µ O˚Ëá¸dáó˝©<Û_¸„OÁeßÂÂÕÂû∂Œ4ª§ı,Vd˚<W˛.O›∑˘K/á~hŒXÎﬁgÁe†WJ”ÕG%5ù«˘SÓø’á‚ˇ ã_8ÑQO8H’Ê∏ï∂ fcˇ ÃŸ‹ˇ .øÁ<√Ê~`a•Z9N√˛1}òøÁ´s_˜÷zs»ëûUÚ8Y4ÀEíÌ„ÊzI-|Uõ·ã˛x¨y>Õõ6lŸ≥fÕõ1 
ùÜ$o!˛fp∂¡‘üò≈sfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥dGœõ[ÚBW\Ωé)iQ
¸rüî)…ˇ Ÿ7ˇ +<ıÁo˘ÕkôKAÂKâ:	Óæ&˘¨û˛ Y?’ŒÊœÕü4y∞ü”åÛFﬂÓ†‹#ˇ ë1pã˛"9≤’K(©=ÜŸy?Zæ¥∞∫ò˜‹.ﬂÒ√x?(|·8¨z5˘˛]§≠qÔ˘3Á4Î¢ﬂ˝ÓR·m◊ÂÔòÌn4ªÿ«ã[»‚òIqk-≥pù6`A¸q,Ÿ≥dóÀˇ ô>dÚÒ¢u+´u≤≤∑˘ƒ«ˇ ùGÀ?Ûòûo”(öö€Í1é¶DÙﬂ˛	ˇ g_Úß¸Ê_ñ5"±Î0O¶»iVß≠¸_Ωˇ íŸ|µÁ]ÃÒz⁄%Ïk‘˙N	Îß€OˆkáY≥fÕòäÏsç˛hŒ/˘sŒ\Ô,iöìT˙ê®Ù‹ˇ ≈÷ˇ 
ˇ ≥è”ÊÁûC¸«¸°ÛÂı«•¨¿~Æ∆ë‹GVâˇ ’ìˆ[˛+ìÑü‰Â~[˛mkøó∑_X—¶˝√e∑zò§ˇ ]?eø‚ƒ„'˘YÌè ?œmÛª}[TE¨ñíãnØª£ˇ W„_˜b.túŸ≥fÕõ9WÊè¸‰oóˇ /Æ_K∫IÓu$UoF4‚ a…9M'‚‚øW<˝ÊØ˘ÃØ4ÍEìFÜ:#–Òıdˇ Éó˜_ÚC9nπ˘±ÊΩpü“:≠‹äz®ïï?‰\|#ˇ Ö»¨í4å]…f=I58‹Ÿ±{KÈÏﬂ’µë‚q˚H≈Oﬁπ9ÚÔÁﬂùtøT’gt_ÿúâñûøı)˛«;ìˇ Á6.¢+ôÙÙï:mO˘˙2ñFˇ ë±Á†|â˘¡Âü<(-‚<Ù©ÇOÇQˇ <üvˇ Z>i˛VLÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f$S”8øÊg¸Â?ñ¸¢^œM?•u®)ü¯∂„‚_ˆ1,üÂpœ1˘Î˛r?Œn-›õ+FØÓmkßÉ…_ZOˆRqˇ '9ãª9,ƒñ;ízúnXöŒ⁄˘kTª∂¥∏î‰â€˛"∏3¸Ê˙∂^ˇ “<üÛF#?ìµ´qY¨.êïè÷∏W5ºê2´!`GÎƒÛbê\In‚XYíE5§Ç>DgMÚW¸‰Gût#µ¥º{‰b`π∑"MèÔˇ ’Tó=„ÂπµÙÎyu®„áPx’¶é"J+ù )m˛≥ÜY≥f íEçKπ
™	$ö sûn¸‚ˇ ú∑µ“LöOì8]]èÖÆÿV$=˝ˇ wø˘‹ˇ ∆\ÚƒÔq#M!´ªc@7&ßa∂v/ Ø˘∆0y–%ˆ†ô•µíU˝„è¯¶Ö∑ˇ ~I¡?ó‘œ\~]˛Nys»1—Ìá÷iFπñè3œOÿ_Ú"‡ü‰‰€6lŸ≥fÕâ‹›Ekö·÷8‘Uô» vm≥òyØ˛rg…]-^˝reØ¡hæØO¯∑·É˛JÁ#Û/¸ÊÏÕTÚ˛ñ™;Iu!o˘#˘?ú«Yˇ ú¢ÛÊ¶¸÷¸Z®5	H£Ôey˚'»Æß˘µÊ›O˝Î’Ô\¬wQˇ å´ëÎùfˆË÷‚‚Y˘nÕˇ 8±;ìñÆÀ∏$iÊJÃ÷⁄ÍxèäHÀˇ líiùr”)ı]b–<≠ ˇ Åõ‘\õËÛó~w”àR[ﬂ(Í&ÑŸ[˙“|πˇ 9ªk!	Øioåñ“ˇ íR˙Úu≥ØyOÛˇ …ûg+û£S∑˚™‚∞µîzºQœ¸cwŒÇ¨SPweÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f»óÊÊßó¸ÖoÎÎó"9V8S‚ïˇ „C∑˘o∆?ÚÛ…ˇ ô_Ûñﬁ`Û{M ~ä±;rCYÿï7˚´˛x¸_Òkg∏∏íÊFövi$sVf$íOvc◊™XÖQRv gIÚw¸„øú¸‘[k∂∑o˜m—Ùñû!_˜Œ?‘â≥¥y_˛pé›)'òµ7sﬁ;T
?‰t‹Îˇ "W:ñÅˇ 8”‰]∫r‹∏˝´ñik˛¡œ•ˇ $Ú{•˘cJ“@]:ŒﬁÿûîHüÒ\3Õõ6º”≠ØW”ªâ&CŸ‘0˚õ!∫Á‰gíµ∫˝oI∂›Z$Ùõ˛
ﬂ“9Ã¸Àˇ 8[ÂÀ–_Fªπ±êÙW§…ˇ ﬁúøÚ[8˜õøÁ¸·°ÜóOXµ8G˚·∏Ω=·óá¸m&qÌSHº“gkMF	-ß^± Ö±pÕõ≥æû∆U∏¥ë·ôU„b¨˘,øŒ√‰è˘ ˇ 7ywå7Ú.´j?f„˚ ìpü„/≠ûåÚ¸Âî¸÷VﬁÊS¶^∂ﬁù…	ˇ "Á˚Ø˘È7˘9◊—’‘:TäÇ:óõ6l©Èv∫≠¥ñWÒ$ˆ“é/äXî≠ûQ¸Ëˇ úIñ»I¨y 4∞ä≥ŸWQﬂÍÆwï‚ó˝ÔÚ4üg<Ÿiwu§›-≈≥ΩΩ‘Ue%]O¸≤Á∞!øÁ(`Ûß†y±÷L—bπŸcòˆY?f)œ¸ãóˆx?¿ﬁâÕõ6lŸÁ˘ÃüÀü“Z\>m¥Jœ`DS”º.~ˇ û37¸œ¸π„úú~Y˛OÎòœ2h~ç-∏˙¶YÒÁ^à#Åæ g`“ˇ Á5I :é´oàä'ìÒvÉ$ñﬂÛÉ˙ZèÙçZ·œ˘"ˇ ƒöLÁ	<øMµ ¸£ˇ ö0Á¸‡ıÉı]^d=π¿≠ˇ í<âÎ?ÛÑ˛`∑¥ÕB÷ÊùÅ‚'ù·≥ö˘£ÚŒû[%Êô,êØY §ÀOËÛeˇ f´ú˝—êï`CBQéÇy-›eÖäHÜ™ hA’áLÔøïÛñ⁄øóŸ4ˇ 4Ú‘¨6∑¸|F<yÆ¥üºˇ ãg={Âo6iûj±MWEù.mdË zËÎˆ£u˝§ã≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ∞üÕæo”<•ß…´ÎS,±u'´Ÿé4˚RHﬂ≤ãû(¸„ˇ úï÷<ÙœßÈ•¥˝ÌÈ)§íèô±ˇ |ßÓˇ õ‘˚Y∆∞˚ ^D÷¸ﬂqıM“[π⁄(>ˇ åíµ#è˝õg~Úo¸·EÌ¿Yºœ~∂‡Óa∂€‰”I∆5oıcó;óÁ|ã¢Ä~°ıπÌ›;I_˘Á¡ˇ $≥†i~T“4êN≤∑∂˝ı'¸AFÊÕà]X[›é71$´‡Í√d[W¸ûÚÜØ_ÆilOÌ,Jçˇ ˇ Üœ1ŒN˛\˘#»±Ao°√$:Ω—Ê#YYë"jGY}G¯€‡ã„_˜c~∆y„=9ˇ 8â˘=ıŸˇ ∆˙¨∏ÅäŸ+µ ¯dπˇ V/±¸[Õø›YÎåŸ≥aOöºŸ¶˘R¬M[YùmÌb≥u'≤"˝ßëøe‚œ~uŒGjû~w”¥ÓVZ%iÈGî5À/o¯•w¸ﬁß⁄Œs‰ﬂ$jﬁræ]/C∑kâ€sMï˚ÚY√îﬂÒ,ˆWÂ¸‚ˆç‰¿öé≥«Q’Ü·ò~Ê#ˇ ƒﬂmó˝˝/≈¸âv‹Ÿ≥fÕõ6sØ=Œ@yG…º¢ΩºYÓó˝—m˚◊ØÚ∑›«ˇ =dLÛ˜ùÁ45´˛P˘j÷;é¬Y{/Ã.–ß¸ﬂÎgÛ?ûµœ4…ÍÎw≥›ö‘	ïÍG˝⁄∞\"À ìA◊%Âgöu–M“ÓÊC—ƒL˛F8Xˇ ·≤s•ˇ Œ'yÚ¯í÷+`ﬂ”ßÍà Ÿ%≥ˇ ú(Û4ÄõÎΩî»ﬂÛ)0≈Á5R>-Z‹húˇ ∆ŸRŒj¿~ÔU∑'ﬁ'≈∞™˚˛pØÕQ
€]ÿÕÏ^E?å$√d_Uˇ úYÛÓû-ä‹(Ô—∑¸+2?¸.A5ﬂ ˘É@ØÈ]>Íÿ⁄í'ˇ «á¸6f…áì?7|œ‰÷°ØÂé˛ÈcŒ#ˇ <d‰É˝èœC˘˛sF÷„ç∑õ≠ªùç≈µY>o~ı?ÁõÀ˛¶z'Àûi“¸Àj/Ù[òÆÌœÌF¿–ˇ +è¥ç˛K¸Xiõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ±ìœºm4Ã4ôò– :≥1ËyìÛã˛rÍ+C&ì‰~2À∫ΩÎ
¢ü˘vçøºˇ å≤~Ô˘O∑ûT’u{Ω^ÂÔµû‚ÊS…‰ëã1>Ïÿùïî˜”%≠§o4Ú(à•ôèÇ™¸Mùˇ ÚÁ˛pÛZ÷B^yû_—∂Õø¢¥y»˜ˇ uA˛œ‘Êã=/‰_…è+y%U¥ã$˙¬ˇ «ƒøºî˚˙Øˆ?Áó¶ø‰‰ﬂ6lŸ≥fÕõ6lÿQÊO(È>fÄ⁄kVê›√ÿJÄëÓçˆëø F\Û◊Ê¸·ç•¿{ø'‹õy7?V∏%êˇ ìˇ ﬁGˇ ==_ı◊<ÕÁ"k^N∫˙ñΩk%¨ªÒ,*¨ÌE*÷9˝F¬òyWÕzH„cÊª{bvB}+®áÛG2¸Öˇ }],ü‰<y—nˇ Áøƒ6ß?.µµk3÷iËﬂO˛Îı¸YËìús_Úﬁ•ÂÎìc´€Kipø±*ï?5Ø⁄_Úó·…wÂ◊Áóô¸ÜÍöm…ñ»Ìg´ƒG˘^Pˇ œLıóÂo¸‰˜ó|ËR Ù˛å‘⁄É“ôá¶Á˛)ü·S˛§ûõˇ /<ÏY≥fÕú[ÛÀ˛qøOÛ⁄I™È-5¿+À§s”ˆn)“OÂüÌø9˛«â5Ì˚À˜≤Èö¨/owqx‹PÉˇ +~À/¬ﬂ≥ûíˇ úyˇ úúkcñ<„5aŸ-ÔÓøÀ”ÿ˛Iˇ c˝€|iÎ C
ç¡Õõ6l	¨i6˙≈ú˙mÍâ-Æch§S›Xql˘´Áﬂ(\y?[ª–nÍ^÷R°øô≈üÛ“2Øíè»ÃO7ö≠Øfn67Í˜>õë˚√ˇ d·/˙™ﬂÕüCAÆ„6lŸ≥d;Œˇ î>YÛ™0÷l£yà⁄t%ÛŸ(Õ˛´ÛOÚsÀﬂö?Ûà∫øó’ı,;jvKRb"ó
=ï~è˘Á∆O¯´<ˇ $mpUîêA é«%øñøö:«ÂÓ¢5"O›±hüNU˛Y˘øíE¯”˛=Ò˘g˘ô•˛aik™ÈMFY°cÒƒˇ »ˇ Û.O≥"ˇ ≤UñÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÿEÁo:iﬁL“Ê÷µy=;xGAˆùèÿä%˝©ˆ‡õ‡Vœüˇ öˇ õ:ØÊ6§oµ1€FH∑∑SDß˛'#ª%˝ØÚSä,2$∏ëaÖY‰rUA$ì∞UQˆòÁßˇ 'ˇ Á⁄·c’ºÒTCFK4b?ÂÍE˚ÒÜ?è˘‰_±û§—¥KŸ,t»#∂∂åQcâB®˙ø˘X76lŸ≥f¬7˘™À öUŒ∑©7kT.ﬁ$ÙH”¸πä'˘Mü8ºıÁ+ﬂ9Î:Ó¢k5√‘-vEGë|?ﬂk?)..0uË4[z¨?ﬁ\J˜q)˝„ˇ ¨ﬂ›«ˇ :Á—mHµ—¨·”l#Z€¢«/@™(0^lŸ¸»¸ “/Ù∆’uwÎUä˚rø˚Ó5ˇ âøÿO⁄œ~h˛lkò∫ÅΩ’åO°nÑ˙q)˛_Êê˛‹≠Ò?˘)≈ÛÚkÚV¸»úN+k§F‘ñÂáZ}®Ì◊˝Ÿ'¸$∑¸çÓ?#yGÚEÇÈzÖ∑WëøﬂìI’ﬂ˛#˚W$9≥fÕõ,…
e`à¢•ò– ;ìúGÛ˛rÀÀ^Y/k£◊VΩZè›Bß¸´èãü¸ÒY?◊\Û'üˇ Á ºŸÁR—]›k6ˇ è{j∆îs_V_˘ËÏø‰Á6ÀU,B®©=u/#Œ5˘√Õ°fK_®⁄5≠wX¡)wˇ ë|? ŒÛÂ˘√O/ò.¶‘%Q?s¸)iõ˛F¶v?-˛ZyoÀ ~á”≠≠ÿ~⁄∆ˇ »ÁÂ)ˇ É….lŸ≥fÕòÄE‡‰3Ãˇ ì^QÛ0o“zeªH›dEÙ‰ˇ ë∞zoˇ úgŒÛÖ•ÚÕ˚€øQ»Êü!,|dA˛≤Kúœ?ëælÚW)uK'kUˇ èà?y<Y”‚è˛{,y√,˘≥UÚΩ–ø—.d¥∏_⁄ç©Q¸ÆøbDˇ !’ó=I˘Wˇ 9ák|SNÛ¨b⁄cEqÈìˇ ≈ˆ¢ˇ ^>Qˇ ëÁ§ÏØ`æÖ.≠$Y†êGF¨Ì+/¬√Õõ6lŸ≥fÕõ6lŸ≥fÕõ
<◊ÊÕ7 ö|∫æ≥2€⁄ƒ7c‘üŸD_¥Ú7Ï¢Ááˇ :ˇ Á!ıOÃ)Z∆”ïûàß·ÄäJt{ñ_µ˛L_›ß˘mÒÁ"Œ≠˘Gˇ 8ÔÆ˛`≤ﬁ06:Mwπëwq‹[G˙øÎ¸1óÀ·œe~\˛Py{Ú˛çn>∞EÊJ4ØÛìˆ˛+èÑ‰‰”6lŸ≥fÕõ6lŸ≥fÕÖ⁄ˇ ó4Ô0⁄>ü´€«uj˝RE®ˇ X++ØƒπÂ_Õœ˘ƒ+ù<>ß‰¢◊0⁄ÕÕdQˇ I˛ÓÒ[˛˜¸©[<’qo%ºçÍ—»Ñ´+#™≤ù¡…êˇ 0µè"Í™hs§ÿ:“Eˇ }ÕÌØ¸2˛√+g¥ºÉ˘âÂOœ,ÿjñ—5ÏkY¨Êä¯Õm&œÈˇ ≈ëí?€„ÚÊôøÛÜ¨ÅÔºï1aπ˙•√oÚÇ„˛4õ˛Ggôµ≠˚C∫}?TÇKk®Õ9´ø∑Ú∂uø ?˘…Ìo…E4˝T∂•§ç∏9˝Ïc˛(ïøeﬂR|»—g≤¸ëÁÌŒ÷#R–Æx∂Ω˘&èÌ#ˇ ƒøcí‰É6lŸŒ9?%4œÃ´ß
ü´‹Å∏ˇ äÂˇ ~@ﬂÀ˚m? Wõº£©yGRóF÷"0›Bwò~Ãë∑Ì∆ˇ ≤ŸË˘∆ø˘»∆”Z/)y¶ZŸö%≠ÀüÓœEÇfˇ |ˇ æ‰ˇ t˝Ü˝◊˜^ªÕõ6lÚ˜¸ÊÂﬂ≠∑úm‚äñ◊T≤MmÂoı_îG˛2EûLœ~Œ3˛aˇ å|©
\?+Ì:ñ”W©
?q/¸ÙãˆøjDì:∆lŸ≥fÕúsÛø˛qœMÛÙO©i°,ı¿*%â5?b‰/Ì,ˇ mkö¸9·›wAΩ–/e“ıHöﬁÓ„$n7¯´}•e¯Y~%√ÔÀÃùGÚ˚WèX”Z´ˆfÑüÜXÎÒFˇ Û-ˇ a˛,˙‰ˇ 6ÿy∑KÉ[“ü‘∂∏^C≈OGç«Ï…|á9≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lNÊÊ;hûyÿ$Q©gf4
†rfc¸™3¿?üﬂús~bÎÍÏÀ£⁄ñ—ÙÂŸÆ]ﬂí˛œ˚Ó>)¸¸π•ïî◊”«kjç,Ú∞DEff<UU{≥˜‰¸„ÕØë McXUü]ëkS∫€É˛Îá˛-ˇ ~M˛¬?É‚ìµÊÕõ6lŸ≥gå?Á-ø6øOÍc zlï∞”ﬁ≥ï;I?BøÍ€}è¯ÀÍ*güÿ"Xö :ìû˝ˇ úv¸¶_À˝M⁄´_ñ‰˜]øumˇ <Uæ?¯µ§ˇ ':ÆlŸ¸Œ¸Õ“ˇ /4¶’uF‰Ê´*~9^üa<˝˘'Ÿçÿ´xÛÛTÛÓ®˙∆∞¸ù∂é1ˆ"OŸä%Ï£˛	€‚lÈˇ êÛé˘Ÿì]◊√A¢)™/G∏#≤wH?û_⁄˚:{WM”m¥ÀhÏlbH-°Pë∆ÄUT`úŸ≥fÕúwÛO˛rwÀﬁJÁedF•©≠G•‚˘˛%_¯«9?õÜy'ÛÛ≥Ãæ~êçV‰••j∂∞’"J÷S˛T¨˘ÕùüÚø˛qsÃ^q	{®è—zkPáïO™„˛)∑¯[˝úæöˇ /<ıoÂÔ‰Wïºä´&ùj%ºng£À_Ú	!ˇ û(ô–3fÕõ6lŸ≥fÕõ1 ä¡ŒM˘ãˇ 8œÂ_9∏ä—◊Ìø≠l ˇ ≈∞u'˘\}9?‚ÃÚwÊw‰ô<ÄZ‚Í/≠i¿Ìu % ˇ ãóÌ¡˛œ‡˛Y9Æt/ ØŒ˝wÚÊqı	=}=çd¥îüMºZ?˜ÃøÂß˚5|ˆÔÂèÊÊâ˘ãgıù&N7≠lÙFOÛ/Ì«¸≤ß¿ﬂÎ|95Õõ6lŸ≥fÕõ6lŸ≥f»˜û¸˜¶y#KìY÷d·{*çﬁG?f(óˆùøÊˆ¯<˘≥˘ª™˛dj&Ú¸ò≠#$[€)¯#_¯ﬁVˇ vKˇ N+êàay›bâK»‰*™äíN¡UGRs’ˇ ëﬂÛä	 è\Ûºa‰4h¨OŸ_ª˛fˇ ä>œ˚˜ó˜kÍ¢HêG
ä UÄ–éÕõ6lŸ≥fÕõ6lŸ≥fÕõ9WÁ'¸„Óè˘â]†z¬Ø¡r£gßŸKîﬁ/˘ﬁß˙øx{ŒûG’|ô®>ì≠¬a∏M¡ÍÆΩ§â˙<mˇ 6∑¬˝Zº—/"‘¥…ûﬁÍ‰í!°¸˛“˝ñ˝¨˜G‰/ÁÂßÊ-Ø‘o¯¡Æ@µí1≤ £˝ﬂ¸Ãè˝◊˛¶Mº˚˘g°yÓ”ÍzÌ∫ÀA˚πW·ñ3„øi’˛Ìøm<c˘√ˇ 8·≠y Ω˝≠oÙqøÆãÒF<.cc˛2ØÓø„ÿŒ}‰ﬂ;ÍﬁMøMSCù†ùz”uuˇ } üfD? ﬂÏ~,˜‰ØÁ˛ó˘è¥î-¶≥÷Krvp>‘ñÃ~⁄2yÌr_ﬁgUÕõ6sÔŒO…Õ;Û+M6˜áPÑmrËëˇ û˝¥ˇ füxÕ^V‘<≠®Õ£ÍÒn‡n,ß°˛WF˝∏‹|Hˇ ¥πÈˇ ˘≈œœ„z"ÚgòÂ¨‡≤ùœ⁄Ï⁄»«ˆ◊˝–ﬂ∑˝◊⁄·œ”˘≥f¬Ø5yr€Ã⁄U÷ã|+owDﬁ"£·uˇ *6¯”¸•œö~eÚ˝œóu+ù¯q∏¥ï¢öör_Ú[Ì/˘9”?Áˇ 0ˇ ¬>kä⁄·¯ÿÍt∂ñΩ˛è'˚~ÚRWœzÊÕõ6lŸ≥èˇ ŒC˛G√˘É¶õ˝=ÎñàLL6ıTnm§?ÚeøbOÚÛ¡”B;E*îë	VV çä∞Ò‹ˇ Á?6õ ⁄–Úˆ†Ù”57
µ;G9¯cìŸf˛ÊO˘‰ﬂ±ûﬁÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÛ¸ÊÊô“¨#ÚvûÙπæ_R‰É∫¬¡¸˜u¯ø‚®¯˝ôs«yÎÔ˘ƒœ…e”ÌìŒ⁄ƒu∫∏Sı$aˆ#;è¯…7˚Ø˘a¯ø›ø•≥fÕõ6lŸ≥ôŒ@˛j/Â˜óûkvSº¨6£∏b>9ˇ ’Å~/¯…ÈØÌgœ©$iªíÃƒíI©$˜9Ë˘ƒø _Ò™|”©%t˝9«¢m%«⁄_ˆ6ˇ ﬁ∆OK¸ºˆñlÿAÁØ;ÈﬁJ“f÷ıg„#ei‹˝àbµ#ˇ ÕÌ+gœoÃœÃùKÛVìW’ÉÏ√?Q◊·ç?„wˇ v?≈ùG˛q«˛qÂº·*yãÃ1ï—bo›∆v7?ÏYO€o˜g˜k˚|}©¿ã*4UTP 6UUcÛfÕõ#ûz¸¬—|èduv·aèpà7íC¸ê«ˆùø·WˆŸs∆ˇ õÛì˙ÁùÿiE¥›%∂‡ç˚Ÿ¸_2ÙVˇ }G;Kú[6Hºè‰cŒ˜√L–†3K±vËëØÛÕ'ŸEˇ Üoÿ‰ŸÏˇ  /˘∆}»·/ı ∫éÆ7ı]wˇ óxõ√˝˙ˇ º˛_OÏÁcÕõ6lŸ≥fÕõ6lŸ≥f í5ëJ8¨ äÇcûy¸‡ˇ úK”µ·&©Â7Ê¨÷Áh$?‰À;ˇ ´˚üÚÌÁêµÔ/ﬂ˘~ÚM7VÅÌÆ‚4h‰#ﬂ¸•?≤Î∑Ï„ºªÊ=CÀó±ÍöDÔmw	™∫˝’ª27Ì#|-˚YÓ»Ø˘»[Ã(WM‘x⁄Î±Ø≈hì÷Kzˇ √√ˆìÌ/4˚=ã6lŸ≥fÕõ6lŸ≥f¬Ø4˘¢√ ⁄l˙Œ≠ Ü“›y3w? àøµ#∑¬ã˚Mü??7ˇ 6µÃçTﬂ]V+8â[kp~”ƒˇ 4œ˛Ìì˝èÿU»fùß\jWŸYF”\L¡#çYò˝ïUœn~AŒ9⁄˘$÷uµKçu≈GÌ%∏?±ÛM˛¸õ˝Ñ_&ì∑ÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lâ˛d˛YÈ?ò:kiöº{äòfP=Hü˘„o¯ö}â?k<˘õ˘e™~^Íç•j´U5hfQJüŒûˇ Ô»˛‘m˛≈ö;§j˜z=‹Zéü+AuáéD4*√¸ˇ Ÿgæ?"?:≠ø2t M∆-b’@πÑlaqˇ }?¸íÉ˘˙|ë¨äQ¿eaB‡ÉÿÁóø=Áq&Ω‰à¬…ªKbΩ˘û”˘[˛]˛œ˚Áè˜mÂãKªΩ"Èn-›ÌÓÌﬁ™ J∫:ü¯%e9Ì_˘«ﬂ˘»∏<Óâ°kÃ∞Îà>ŸV‡⁄OÂü˝˘Ì}∏øi#Óô≥fŒU˘˘˘'o˘è¶z∂°c÷≠TõyN‹«Sm+æﬂˆ˝’'≈ˆ}N^
ª¥∫“nﬁﬁ·^ﬁÓ› ≤ö´#©˚’ï≥‹Ûçﬂù´Á›7Ù^®„Ù›íèRªz—èÖn¸øŸü¸øè˝Ÿ≈{>lŸ≥»øÛôﬂóøTΩ∂ÛÖ™~ÓË{í;H£˜¯…¥Û≈õ<Ã¨TÜSB7g—o»ÔÃÁØ+Zjí7+¥_BÁ«’è·f?ÒïxMˇ =2{õ6lŸ≥fœŒ_˛TÆë~ûp”íñ◊Õ¬‰(Ÿg•V_˙8QÒ≈®Õ˛Ìœ8´ ÉB:˙˘˘â˛;Úµµ¸Ì ˙Ù{üQ ˝Á¸ˆèÑøÎ3gEÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6‘ı4ÀYØÓÿ$Ò¥í1Ï®9ª¿å˘´Áˇ 8\y«\ª◊ÆÎŒÍB ßˆP|0≈ˇ <‚
ô ¸å¸∑>Û5æô(?Rã˜˜Dæêä•|fr±≥Â˚9ÙFRX¢PàÄ*® ÇÅéÕõ6lŸ≥c'û;x⁄iò$h•ôò– Yò¯˘·˘Â˘ù'Êò¶‘ü®CXmTˆçO˜î˛yõ˜ç˛≈?c"æPÚµÁöı[mN^WR_^Fˇ "4‰Ô˛JÁ“%yFœ E∂Öß
AjÅAÓÕˆ§ïˇ Àë˘;aﬁl®j˙uºó∑í,V°yç™éLÃ}ÜxÛﬂÛé„Û#W/d“mI[Xé’µ<ã˛˝ó˛Iß˛fcO˘«ü»Ÿ0ıØÍ*…°⁄0ı[°ï«≈ıh€˛O8˚	˛[Æ{∫““8R⁄Ÿ(bPàä(™†QUTtUÆlŸ≥g¸Ïˇ úî”|à$“¥û7∫ÿÿ•k'∆·ó´ˇ ≈Ò;G˚^,Û_õıO6_>©≠‹=ÕÃùÿÏ£˘#O≥/Ú'√Ñ˘≥ß˛K˛Djüô7>∂ˆ∫DMInHÎ„∏ˇ vKˇ 	Ì˛ ?π¸ó‰m'…zziZª¨Ì˛¸ï˛‘éÊ’‚∏}õ6lŸ≥fÕõ6lŸ≥fÕõ6lÑ˛h˛Qhøò∂_U’c·rÄ˙7(©˘˛‹œ|-˛K¸y·Ãﬂ ›_ÚÛQ:~¨ïç™aùªïGÌ!Ï√ˆ„oç?’‚Õ≤Ωû∆d∫µväxò2:X}ñV{w˛q„˛r/=¬∫&¥Àπ
Ïvp£¨â·2ˇ ªbˇ ûë¸÷>·õ6lŸ≥fÕõ6lÿŸ$Xî…!
ä	$ö RNx?˛r3ÛÆO?Íü£ÙÁ#D≤b"oU«¬◊/ˇ á˘c¯æ‘èúÇ(ûgX¢RŒƒP*I= 9Ìˇ ˘«»(¸ëj∫Ó¥Åµ…◊e;˝]vøÒsèÔü˛y'√œ‘ÓY≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lã~c˛\Èû“§—ıeÿ¸QJ«˛Ã±ü¯í˛⁄¸-ü>?0|Ö®˘WóD’VíG∫8˚2!˚G˛K¬∑$oâp?íº„®y;UÉ[“_ÖƒZ~À©˚qH?j9·o˘´>â~\˘˙√œz4:Êöhí
I?rÔ!uˇ áN/˚Y&Œˇ 9ˇ 8ÂúcìÃ^Eã[AY#pèeπ˛I?›übOŸtÒx7ZU’G;{ªi=’—–ˇ ¡#£èˆ9Ó˘«_œà¸˝g˙'VeMvŸ>.ÄNÉ˝ﬁÉ˝¯?›—ˇ œD¯>Ì9≥fœ8ŒV~HfŸ¸Â¢G˛ünøÈq®˛ˆ%ﬂ˛˝Å~ﬂÛ√ˇ æ/)yKÕWﬁT‘‡÷¥ßÙÓ≠ú2ûƒ~‘n?j9‡u˛\˙-˘qÁ€/=Ë∞k∫y¢ )$d‘« ˛ˆˇ T˝üÁN/˚Y&Õõ#?ô~JáŒæ_º–f†7üMèÏ»ø/˛∆E^_‰ÁÕãÎ)¨gí“ÂLsBÌ©Í¨ßã©ˇ U≥ºŒ~`˛ÑÛû]πjZÍãW†ùhˇ ‰l|„ˇ )˝,ˆî”«ÛïÇ(Óƒ¯·[y«EC≈ØÌAå…ˇ 5`˚=F⁄ıy⁄KÀ‚å¬‡åŸ≥f»ˇ ü¸üoÁÛA∫ß®ä´ŸqÒE'¸ÛïUÛÊ¶•ßÕ¶‹Àct•'Å⁄9ˆe<‡Üwo˘√ü;ù#ÃíË5-ıHœNﬁ¥@»üQzÀˇ û’Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6q˘Àü9 'MÖ∏œ™J!€Ø¶øΩú˛ƒﬂÒó<5û‹ˇ úAÚ –¸≤⁄‰ÎK≠U˘Çzàc%!Ïõ’ó˝WLÔ≥fÕõ6lŸÁØ˘ÀœÕ/–zJ˘R¡Èy©/)»;•∏4„ˇ G∆4ó˘≥∆Ïo˘ƒ ø—:s˘√PJ]_/`FÎ~)>w?‰R/˚˜=õ6y˛r€ÛúﬂN|ë£…˛èzÍ~‘Éu∂ˇ R/µ/¸[∫õ8ßÂ_Âµ˜Ê∑çeUèÌœ-*"àéC˛WÏ∆ø∑'˙!Â,X˘_MÉF“£Z[(T^Á˘ùœÌ;∑∆Ì˚MÜô≥f f
1†ís ˇ üøÛî•Lû]ÚTΩ*ìﬂ!ˇ Çé–ˇ ƒÆ?‰O˚˜<øaaw´›%≠§oqw;ÒTPY›è∑⁄f…∑õ¸ùk˘{n4ÌL•œô&P“D§4vh¬°d#iØd^ﬂ›[ß«˚«h›9ˆv»/»;üÃKØ“Äht(í8Ÿ•a˛Ëá˛fÀ˚ÎÁ∫tç"”G¥ãO”¢X-`Pë∆Çä†`ºŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕÑ^uÚNóÁ=6MZàKo'C—ëøfXüˆ$Oˆ-…>'Ê˜Â•˘m©õ+œﬁŸÀV∂∏ã"é«˘%O˜dÒ£+d/O‘.4€àÔl§hn!`Ò∫2∞5VSûˆ¸Ä¸ÏáÛLÙn «≠Z(çÉéÇÊ%˛Gˇ v/˚™OÚZ<ÍŸ≥fÕõ6lŸ≥fœ5ˇ Œ\˛pù*◊¸•IK´•x wHèŸÉ˝i˛‘üÒO¸fœÁ´?Áø$œ‹{ü˜Ç&Ùˆ√˛ﬂ˛Gæõ=Qõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ9«ÁóÂ∑ÊFå÷Í5K`^“cŸª¬Á˝ı7Ÿo‰n2~Œ|˚‘tÎç6Ê[ÿ⁄+à£ëP´)‚ ﬂ#ù?˛q◊Ûyø/µ¡„ü—≈cπêˇ ∫ÓG¸bˇ v≈\ˇ kÜ{Ì]C°H®#°yÁè˘…ø»ÛyØÀ—STÖy\DÉ˚ÙÌ®ÒÛˇ »‰¯~⁄ß/ ËZÂÊÉ}©¶»aª∂pÒ∫ı~µ?eóˆó·l˙˘9˘ßi˘è¢&ß#ªéë›Bÿíùø‚©>‹M˛«Ì£‰Î6lƒ(w<%ˇ 91˘;˛÷?Ii©«G‘¥`täOµ%ø≤˛‹?‰rO˜V!ˇ 8’˘∏|âÆã;Á¶ë®éjù£~ë\˚q˚ˇ ≈_˚≠3ﬁÄ◊qõ6lÒ'¸ÂÁÂˇ Ë2.Ωl¥µ’TªS†ô(≥»≈·/˘N“g≥ºö d∫µväxò::YO%uaˆYN’5€˝YÃ∫çÃ◊2˘K#9˚‹∂¡W˜2	Ì%xe6*G˚%ﬂ:ˇ Âﬂ¸ÂGö|Ø"C© u[ @dú˛¯ÆÁ˚Œ_Òó’\ˆ/ÂÁÊ>ëÁÌ8jö,ºîPIm$M¸íßoÚ[Ï?Ï6J3fÕûˇ ú∂Úh–|ﬁ⁄Ñ+H5Hƒ‚ù=A˚©«ﬁ´+∆\‰æY◊fÚ˛©k´€{i2Læ¸7ˆ_g>úÈ∑Òj6±^€ûPœ»á≈\sSˇ pFlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6x£˛s+ÃÁRÛT:B«ß[®#¬Izˇ ÚK–Œ¢i2Î÷˙m∞¨◊R§)˛≥∞Eˇ âg”≠IáF±∑”-E µâ"A˛J(E˝X76lŸL¡Af4rNy«ÛO˛s«FöM7 P•ÙËJµÃÑ˙ ˇ ≈Jîyˇ ◊ÂÀÍg÷øÁ$º˜™πg‘ﬁ=X¿˘_S˛	ù:ºËßê÷Ø´Ô;ü¿ú<“Á&|˚¶êF§”®˝ô£ç¡ˇ d…Í√‰'Œ~q‘<„™M≠ÍÓÍr+ƒQ@Q¡QˆQTa˜‰œÂƒøòc∑“ "‘VÂ«Ïƒß„ﬂ˘§¯bOÚﬂ>ãZ⁄≈i
[[®éî"*äUUTx*‚π≥ô˛˛k'ÂÁóﬁ{v•.Î™¯5>9È¸∞/≈ˇ =4˝¨˘ˇ wï»D5ÃÔ@7fws˜≥ªú˙	˘˘KÂŒÑ∂“mNÊí]»7¯©¬≠˛˚ÉÏØÛ?9?o:FlŸ≤§ëcRÓB™äív Á<oˇ 9ˇ 9%'òö_,˘ZBöX™Op¶ÜÊé3⁄€˛Oˇ ∆/Ô8wì¸ù©˘øQèG—a3‹ z≤´˚RJ˝4˝¶ˇ ç≥‘∑⁄áˇ 8·Â≥œ5^©ä)\~’>?I˜v∞u€ô∏#˝µÙ¸ë®jïƒó∑í4∑9yçK3LÃ}Œt/»ﬂ…ÀØÃù[“nQiVƒ5‘√√ˆaè˛.ó˛y˛K{˚F—Ì4[8¥›:%Ç÷›Gä¸˛&˝ØµÉ3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÛÔë4ﬂ<iRË∫≤rÜAUqˆ£qˆ&à˛Àß¸7ÿoÖ≥ÁßÊ?ÂÓ£‰-b]T_â>(‰·ñ3ˆ%è˝o⁄_ÿ~I˚8…~pøÚ~´∑•?ãv≠?eóˆ‚ê~‘r/¬ﬂÛV}¸ΩÛ’èûth5›4˛ÓaGB~(‰ﬁBˇ Â!ˇ Ç^/ˆ[$y≥fÕõ6lŸ≤;˘ÖÁ[_%hwZıÓÈnïT≠π¯bâ◊~#¸üµü7º√Ø]˘ÉPüV‘_‘∫∫ë§ëΩ…Ì‡´ˆQerw˘˘Pˇ òö˙[Œ“Ì)-”Î_Ç ûv¯„®ˇ ≥üAmÌ„∑ç`ÖBGÖUQ@ UQŸTcÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ.ˇ Œ_~P	¢x“£˝‚qKÂQ’~ÃW?4¯bó¸èMøaÛ…πÌè˘ƒØÕ3ÊMº∑~¸ØÙµ2NÔoˆcˇ ë˚ñˇ #—Œ˘õ<iˇ 9Y˘(<Ωv|›£G«Nªz\∆£h¶o˜`˛XÆ¸ﬂÒë9ü‰∑Êç«Â÷Ω§§µî¥äÍ!˚QìˆÄˇ ~E˝‰e€>àX_¡®[«yh‚[yëdç◊p √í≤ˇ ¨∏ælŸ¸¬Ú=üùÙ[ù
¸Q'_ÅÈSÉx¶_Úëø‡óí~÷|·Û/ón¸∑©\h˙äp∫µê∆„µGÌ/ä:¸hﬂ¥ôÌ/˘≈oÕCÊ›Ù-˚Ú‘¥∞®I;º=!ì¸¶OÓdˇ V6oÔ3∑ÊÕúÁ˛r»„o)›YDºØ-«÷m¸}H¡<¸eè‘ã˝û|ÒÕõ6lö~S~f^˛^kqj÷•ö‹êó0É¥ëÒ/˙Îˆ‚oŸÚyg—m+T∑’m!‘,úIoqÀéÖXrS˜`¨Ÿ≥œˇ ÛôæXáïÌıÑìO∏>Ã=7ˇ í¢Ò^}ˇ úeÛ÷¸ãß≥ö…j’øÁìR?˘#ÈgRÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6|÷¸◊◊éøÊ≠SR≠V[©xÚΩ8ø‰ö.L?Áºº5ü=Y≥ä«f≤\∑˚·›4ëÁæsfÕõ<„ˇ 9É˘•6ãcî¥Ÿ
O~ÜKñSB!Øã˛{∏~Ò\|>Ãô„úŸ≥fœuˇ Œ+~Zè*yiu[§¶°™Öô™7Xø„⁄?•[÷o¯…«ˆ3¥Ê∆O:[∆”L¡#@Yòö Ïƒ¯˘ﬂ˘„˘ô'ÊòÊ‘êü®√˚õT=¢SˆÈ¸Û7Ô[˝n±ùc˛pˇ Úò_‹∑ùu$¨Ãc≥V4üÓ…˛P˝àˇ ‚ﬁ_µzÔ6lŸ≥»ÛìøÛêGSí_'˘n_Ù4%.ÁC˝„µo˜Jˇ ª[˝⁄ﬂ˜ﬁo#˘#SÛÆ©ç£GÍ\Kπ'eEnY[ˆcO˘µ~6Uœy˛\˛[hîöÖYC$f[À«g‡91ˇ "ˇ ›qƒ§ffÒÊ˜ÊUœÊΩ6±5Vÿ~Ó⁄#˚)¯˙Ô˝‰üÂ∑ÚÒ¬?&˘J˚Õ⁄≠æá•ß;õó‚<uy¡#OçÛË∑ÂÁê¨<ã£¡°ÈÉ‡àU‹èäI˜ìI˛Sˇ ¬'˚+íLŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÕˇ =?(≠ˇ 1ÙV∑@´™[ˆíùæ/⁄Ö€˝ı7ŸoÂn~∆|˙æ≤ö¬y-.ë¢û(Ë¬ÖYOV*sÆŒ3˛n#k¢¬˝È§j,±ÀS¥rtä„€˘%ˇ ä˛/˜ZÁºsfÕõ6lŸ≥géÁ1ˇ 1Œß™√Â+G≠µÄœNÜgü¯√¡Jˇ Àûtä6ïÑqÇŒƒ ‰ì–˙˘˘füó˛[ÉOëG◊Á§◊M„#ÓÎ¸∞ØÓó˝V€ŒÖõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lB˛¬BﬁK;¥¡24r#nXqe?Î.|‰¸‹¸æõ»>bπ—$©ÖO©nÁˆ·m‚oıó˚∑ˇ ãÒ Ô=O‰o0⁄k∞‘§/Iî~‹MÃüc˛,‡ŸÙé∆ˆ¯#ª∂a$"»å:2∞‰å?÷\[ Î⁄¶Ωc>ï®†ñ÷Â9˜ı0˚Jﬂ≤ﬂ|„¸ŒÚ◊êıÎç
Ó¨"<¢êèÔ"oÓ•˙W·Âë]?g=ˇ 8u˘§o-§ÚV†ıñ‹≠±ì˚Ë?Áì∑®ü‰;˛ÃyÈºŸ≥gòøÁ1ˇ +Ö’¥~u∞Oﬁ¡∆∞T'å¯∆Á“oÚ^?Ÿè<Ò˘MÁ˘ºáÊ+]r*òQ∏NÉˆ·m•Où>4ˇ ã3ËıïÏ7–Gwj‚H&Etu‹2∞‰åæÃ∏∂lŸÛﬂ˛r#»_‡œ7][¬ºlÓœ÷≠È–,ÑÛAˇ •ı˝N9ÃÛfÕõ=Ωˇ 8{Ê«’¸¶˙dÌ M6vçk˛˚qÎG˜9ï’\ÓŸ≥d3ÛõD◊ìµk*Uö“GQ˛Tc◊è˛5œõŸÎˇ ˘¬\À§Íöa?‹\G0Òï
˙áœJÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ¸«®˛å”.Ôˇ Âû	eˇ ÄV¯◊>^ªó%õrMNzo˛pHÁ´jÑu0Éˇ §o˘0ôÎ|Ÿ≥fœü?Ûíz€Íﬁ{‘ŸçV[t5T?ÚSõg1Õõ6O?$/õœ~gµ“ùI¥CÎ\üìwÛ‘ÒÑ∆L˙.à±®DUE  ^l‡Ûó_ô·Ì	|πfÙΩ’AS™€Ø˜üÚ=øu˛ß≠ûDÚ?înºﬂ¨⁄ËV˜◊RÂJÖ_µ$≠˛LqÚvœ§ûYÚÌßñÙ€}N^÷±¨h;–~”ñÌÒª6ÊÕõ<Ûˇ 9K˘‰|µlﬁS–‰¶ßrüÈ)ﬁò}Ö?≥<Àˇ "‚¯˛”∆Ÿ‰//y~˜Ã7È:\fkªá	‰˜? ™>'oŸ_ã>Å˛M~PX~[iB“K®L]\Swo‰OÂÜ?˜Zˇ ≥oâ≥ëˇ Œc˛hKhºó`Ùí‡	Æ»=‹¬„#Ø™ˇ ‰§≥&y=∑ˇ 8£˘J<±£ˇ â5È©jH
«¯£_ıß˛ıˇ …Ùóˆ[;ŒlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥…ˇ Ûò?î¢_<iâEr±^™éçˆaπˇ g˝ÃüÂz_ŒŸÂº˜w¸‚ÁÊyÛèóüz¸µ-/å2TÓÒ”˝o¯Ùü¸∏˘~ﬁvlŸ≥fÕõ6˘«Ã–y_Hª÷Óˇ ∫¥Ö•#ƒÅ'˙“?_ı≥ÊÜ≥´‹k7≥ÍW≠Œ‚ÊGñFÒg<€;¸‚áÂÿÛGô∆´tú¨¥ê&5Iˇ FOˆ,≠7¸Úˇ +=œõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ÅŒ_˛^sÀÈÊ+T≠ﬁñjÙÍ–9§üÚ)¯K˛Jzπ‚åˆ˜¸‚üΩÂÜ—nïŒí‚1^¶´¡ˇ  }Hø’DŒÌõ8W¸ÂüÂêÛ/óˇ OŸ•oÙ†\–n–Ôó˛y|ø‰˙øœû9Úö.º´´⁄Îñ&ì⁄H≤ŸÄ˚q∑˘2'(€¸ñœ•^]◊≠º¡ß[Íˆ- ﬁÍ%ï≥T?Â/ŸoÚ∞«6l	¨i6⁄≈ú⁄mÚ	-Æch§S›Xql˘±˘É‰€è&k∑z›K[HB∑Û°¯·ó˛zF ŸÎ?˘√ˇ ÃSÆË2yrÌÎu•ëÈ◊©Å˛«¸âìî‰ß£ùˇ 6l‡üÛò>D˝7Â¥◊≠÷∑:SÚju0…Dó˛˝)?…_S<Mõ6lŸÎ˘¡¥q¥Êº[ÛzÁ©3fƒ/ÌñÍﬁ[w›dFCÚa«>ZÕâ⁄6Í§ÉÙg§ˇ Án Í˙≠Øg∂çˇ ‡è¸Õœ_fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ!øú∑F€…∫Ã†–˝Fqˇ åüÒ∂|›œbŒZÖ–ı;ûÔv©ˇ ∑¸ÕœHfÕõ6|Í¸¸≥{O<Î»(ZÈ§'Uˇ Ö|ÄfÕõ=©ˇ 8w‰E“<ª'òßZ\ÍnB‘C(ür˙è˛R˙yËÿŸ¶HQ•îÖDòùÄrN|·¸·ÛÙûzÛ-ﬁ≤I6ÂΩ;pf¯b˘s˛ıˇ Àë≥–ˇ ÛÜó“Œ9^'ÔnkomQ“5?æê∆IW”ˇ ûO¸˘ÈúŸ≥d#ÛáÛ6€ÚÔAóWñèrﬂª∂à˛‹§|?ÛÕ?ºó¸Ö˛f\˘›´Í◊ZÕ‰∫ç¸ç5’√ô$vÍÃ∆ß=≥ˇ 8Õ˘$æI”Fπ´G˛ÊØP0ﬁèƒ∞ˇ ì#˝©ˇ ÿ≈˚À∞Î⁄’∂áaq™ﬁ∑{XûY˘*9ß˘sÊüú¸”sÊΩbÔ\Ω˛˙ÓVêéºGÏFø‰∆úc_ıraˇ 8˝˘k˛=Û<6óÀOµˇ H∫(ß·ã˛{I∆?ı=F˝ú˙™Q@6 eÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ Î∫%Æªc>ï~û•µÃmã‚¨)ˇ ¸≠˚-ü6|˝‰Îü&ÎwzÊÔk!P‘ß4?Rè¯…W…‰?ÊÚ/ömu	çî«Í˜>õê9ü¯¬¸&ˇ aüDATnlŸ≥fÕõ<Áˇ 9£Á#a¢Zyv£ﬂ eî˜‹4!O˙Û:7¸ÚœÁøÁ<é<≠‰Îgïx›jÈr¯—«Ó˝åü˚6|Í˘≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõÍZ|:ï¥∂7J	„h‰S›Xpu˙TÁÃÔ;ybo+kWö≈K⁄LÒ‘˛“É˚∑ˇ ûëÒˆY–ˇ Áº‰|πÁ;h$j[ÍJm√ì|Pü¨®üÏ€=Ìõ4):4R®h‹e"†É±>p˛o˘ºèÊkÕá–GÁ=‚é/ü˝€ñçûíˇ ú1ÛŸ‘4õØ+\µe∞oZﬂRçG¸cü‚ˇ û˘Ë¸Ÿ≥gòÁ4?/Ñˆ∂æpµ_é-ÆH˛F<†ëø‘ìîÛ’3É~Gy˘#ÕVz£∑WoB„√“ì·v?Òâ∏Õˇ <ÛË∏ äéô≥`M_JÉW≥üNº^v˜1ºR/ä∏‡ﬂÅœôæmÚ‰˛Z’ÆÙ[ØÔm&xâÒ‚hØ˛´Ø∆∏Qõ6l˜ø¸‚Ôë$Úßî"íÌJ]Í.nùOUV`Cˇ <ïdˇ ZFŒªõ6biπœñöì∫òç¡ëøYœAˇ Œ˘ÿµ€Í_Û2<ˆFlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ ˇ û(_…:»^øSî˝¬πÛè=ïˇ 8J‡˘oP^‚¯üæ(ø¶z+6lŸ≥«ˇ Ûô˛C{MR€Õp)Ù.–[ÃGic∫-ˇ a¯W˛0göÛf¡:fü.•uç∞Â5ƒãs¡G¸œß>Z–°–4À]"€˚´HR˜°9≤˚Xeõ8ﬂ¸ÂOüOñ<•%î∆ÔT&Ÿ)‘FG+óˇ ë∫ˇ ûŸ‚O*˘vÁÃ∫•Æãd+=‹´¯GwoÚQ~6ˇ '>óywA∂Ú˛ùm§XØ{Xñ$ 8‘ˇ îﬂiø √Ÿ≤ôÇÃh‰ûŸÛÛ˛rÛQø0<ƒÚ[9:]ïaµà˜ó9ÿ»•âraˇ 8ü˘@<À©ü4jëÚ”¥˜í∞⁄I«ƒø4∑¯do¯≥”ˇ /=©ûyˇ ú Û…“Ù.[µ&‘§Â ÔòàjœIΩ?˘˘„˜o¸‚üÂ¯Ú«ïQùxﬁj§\=zà˙['¸ÔøÁ∂v|Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûaˇ ú—Ú û÷”ÕˆÀÒ¬Eµ¡—âhø‘ìúÛ’3…9Ù˛q√œ'ÕﬁN¥ñfÂwg˛â7çc”c˛º&ˇ _ñt¸Ÿ≥fÕõ<ˇ 9UÊÉÆyﬁÊ5áODµOöèR_˘-#Ø˚Ä˛_yaº”Øÿhã“Í·©Ÿ+Y[˝å\€>ò√Bã`* 
†t tÏŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f»Øüø44!€}g]πXôÖcâ~)dˇ åqã˝õqè˘ü<ÀÁ˘Õb˘ö,Z«cif˝Ïßﬂá˜ˇ ´˚Ôı≥êk_ú>o÷òµˆ≠v¿˛ J—Ø¸ãá”O¯\ >e’s7wº}WØ¸KÙoÕø6ËÃ«Vº@?dÃŒøÚ.RÒˇ ¬Á[ÚW¸Êføß2≈Ê;xµ:•ˇ Ó_˝_N?ıÛ”?óõæ^Û¸>¶âpÍ*ˆÚ|2ß˙—˛“ˇ ó8ˇ  …ûlŸ„?˘Õ)?Ã∫ÙKD‘ ‡Á∆Hhµˇ ë/¸y˙¬ˆ[àÆÌœ°uëÉ)‰ß˛>ù˘g[è^“Ì5h?ªªÇ9ó‰ÍüEpÀ6yó˛sW…"‚∆ÀÕ0/Ô-ﬂÍ”¸èÒ¬«⁄9yØ¸ˆŒˇ 8ˇ Á/üú¨/∏€Œˇ Võ√Ñøª´{G'ß/˚˙õ6l&Ûóñ`ÛNèw°›ˇ uwFOÚí>	?÷ç¯∫ˇ ´ü3ım2}*Óm>Ìx\[»ÒHæáÉ¯!û˝ˇ úuÛπÛwì¨Ó%nWVÉÍ≥xÚà å}ﬁIˇ ÷lÈô≥gã?Á3<¶4ﬂ3[ÎQ-#‘†èåê“7ˇ í-y˚6lÔüÛçøÛèÛy≤Í?2k——`nQ£˜°‘Ï)ˇ , ﬂﬁ7˚≥˚•ˇ vpˆ¿ÿtÕõ6y£S]+Iº‘—mÌÂîüıü¯gÀÚjjzÁ®?Á¥‚◊z≈˘
G@˚±ëœ¸õ\ıûlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ#ˇ òöwÈ/.jñ@TÕgpÄ{òÿ/„ü2Û’ˇ ÛÉ⁄†1ki?h&ÿâ#¯äg©sfÕõ¸Ô‰Î9i¶µÇ·iQ’|Q üÂ∆ˇ ˇ Õ9Û∑ÛÚˇ RÚ≠.ç™•cêÜT?bhœÚ∑¸#|Ò.Fsg[ˇ ú[Ú∑ÈÔ;⁄;ä√`Øvˇ 4bˇ íÚDsﬂ9≥gÖÁ,ºÌ˛!ÛsÈÒ5m¥§Î·Íé·æ|¯ƒﬂÒá$ˇ ÛÖ˛F⁄µ◊ö.±ÿß£	?ÔŸÔ∆8>˘Ôû√Õõ6q/˘ ﬂÃ£ÂO-˛â≥~7˙Ø(ÖÎÈ˛»2¬øÒëøì<[Âo-›˘õT∂—tıÂsw"∆ûøi€¸Ñ_çˇ …\˙I‰Ø(Ÿ˘CH∂–¥·H-P-iª7Y%oÚ‰~Nÿwû ˇ úöÛyÛ'ùo87(,iiˇ Ô∫˙øÙ“‰7ÚÁ oÊÔ0ÿËIZ]L™‰uèéfˇ cªg“€{xÌ£X!Pë∆°UG@ ¢®≈3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6‘5;]6#q}4véØ+ÑQ˛…»\ÇjÛêæD”X§⁄º√˝Ù_¯hE¬ËøÁ(/‰n?§È^Ê	Äˇ ìY*–?6<´ÊÈö•¨“âÍsˇ <‰·'¸.JÛfÕÑ^zÚ¥^k–Ôt9È∆Óå˚-Jƒˇ ÛŒN˛«>g^ZKe<ñ∑
RXùë‘ıßã/–s–ﬂÛÖæn6:Ìﬂó•o›_CÍ∆?‚»|?÷Ö‰Ø¸cœdfÕõ6lNÊ·-¢yÂ4H‘≥ N|¿ÛÆ˙Œ•u©ÀˆÓ¶ífØã±¯€;O¸·∑óF°ÊŸu'Kg`|B!_˘&”g∂≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ8∑ÁÔ¸‰5øÂ¸gH“x‹kí-hwH˝ô&˛i˚Æˆr|}OÎ∫ıˆΩw&£™Œ˜7Röºíìˇ 4®˝ï_Ög fÕõ6“ı[≠&Ê;Ì>WÇÊ‰íF≈YH˛V\ˆ¸„Á¸‰Ñ~t·†yà¨:»éA•¿¢\4fOµÚgzÕú?˛sÀ£SÚaøQY4˚àÂØ˘/˛é„˛
Toˆ9·º˜ø¸‚Ææuo"⁄FÊØg$∂«˝ãzë˝—Jô◊sd_ÛG ãÊø-j)û‚Ùˇ „"˛Úˇ #Q3ÊØ≈wVSÚ å˙Y˘eÊÒOñ¥ÌdöΩ≈∫?„ &ˇ í™˘&Õõ6xw˛rÔ…ÉCÛgÈHWçæ´ónû™~Íqˇ &Âo¯ÀáøÛÖæq6Z’Áó%o›ﬂEÎF?‚»æ–Î¬Ó«˛1g±sfŒˇ 9ïÂÒÂ(µ5Ö“1?‰H/ˇ %=Ò.—4˝vÂlt´y.Æ_§q)cˇ — œQ˛PŒ!-≥G™˘‡¨é(ÀdÜ™¸º øo˛1G4èˆ3”A¨0®H–UQ@ ÿ*®Ë?6lŸ…?Á)<‘∫í.‚IØŸmPxÛ<¶ˇ í	&x=πˇ 8oÂ”ßyFMJAFøπwS‚ëÅ
ˇ …Eõ;∆lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ)–8*¬†äü1ºÎ†∑óıªÌ!≈≠ƒ±í±Ÿ/≈ùC˛q#Õ£y“;I[åZå2[Ô”ê§—√E¡◊œufÕõ6lá˛g~VÈ?òöi”µT„"T√:ÅŒ&˛dÒS˛ÏèÏø˙‹Y|'˘°˘?Æ~]]˙§|Ì\ëÃ`ò‰?˜\üÕ¸_Î/≈ê|ıø¸·ñ}+-OÃ.ÛHñ—üd¨øM,_È‹ÿSÊﬂ0√ÂÕ&ÔY∏˛Ó“îè#íØ˚6¯sÊV£6£s-ÌÀröwiºYè6?G>ÉŒ>˘4yO…∂éºn.Î3xÛó„£{«ß˚Ëπ≥fœû_ü˛>vÛe›‰M Œ‹˝Zﬂ√”åëÕ„,úÂˇ gùã˛p√Ú‰sÁ;ƒÈ[kZè˙Hï·aVˇ åÀû´¬œ3ÎqËZ]ﬁ≠7ÿ¥ÇIç»RÙˇ Öœòóór^M%ÃÁî≤≥;›òÚc˜Á°ˇ Á
¸¨/uÀ›zE™ÿ¿"C˛\«®˘Eãˇ =3ÿ˘≥fÕõ6lŸ≥fÕõ6lŸ≥fÕÅ5}^”GµìP‘fK{XWì…!T|Œy_ÛG˛s‚g{$∆"àlo&Z≥{¡|(? õì≈IûrÛö5O1Nnıã©ÆÊ?µ+ñß˙º∂Eˇ %pØ6lü˘Û”Õ~Je]:Ò‰µ^∂Ûì$TUoä/˘‚—Á≠ø(?Á$ÙO?”ÆGË˝\Ï!v™HÂﬁ]π¯©∏…¸æß⁄Œøõ6x˛rw √À˛wΩÙ◊å7ºn”˛zﬁˇ …uó"ï~e>ZÛFõ´WäCrúœ˘}9ø‰ìæ}*Õõ6lŸ¸‰’éì‰˝^ÒMlÂU?Â:˙Iˇ ˘Ûs=}ˇ 8C£à¥≠ST#yÆ#Ñhì‘ˇ ±åÙ∂lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ü~w˛i≈˘s†I®-˛bbµå˜êè∂√˝˜
¸o˛∆?˜f|ˆ‘ı+ùRÊ[ÎÈkô‹ºí9©fcVcÅsfÕõ6lV⁄Ê[YR‚hÂçÉ#)°V™ √£)œ~ˇ Œ=˛nèÃMïŸV≤„ çπT~Ó·GÚÕ«‚˛YUˇ géu,â˛mh„YÚû≠cJó≥òØ˙ ¶Hˇ ·—sÊæzÁ˛pVı4˝[L'˚©¢ò¯»≠…ÖœMÊÕü8:|∏<πÁSNQ∆5∏ix$øøå}	&zá˛pœÃ?_Ú§˙cöΩÖ” <P%_˘)Îg}Õõ6pÔ˘ÀÔ)~òÚáÈ8÷≥iì,µÔÈøÓe{E#∆<ÚÂøö æb”ı∞h∂◊œÓÑôŸDŒπÙΩ:áSU"†é„/6Aˇ <4“˛K’ÌiSıWîxø“˛,˘«û¡ˇ ú#øéMS≥‚æ§7(Â®9që8™ñ˚\yBŸÈ<Ÿ≥fÕû$ˇ úª¸ƒ_0˘Ö4GÂi•åAÿŒ‘ıø‰R™E˛K˙π√¥Î	µò¨≠TºÛ∫«é•òE˙XÁ”$˘f/+h∂Z≠§	#ˆòﬁ?˚99>ÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6xì˛s…ßGÛJkQ- ’"OoV "î»øEˇ ŸÁ—uiÙ{ÿ5+6„qm*Kd!◊ÒÙª…æh∂ÛVëiÆY√w»^$˝∏œ˘Qø(€¸•√úŸ≥fÕûuˇ ú’Û'‘¸øe£!£ﬁ‹ë
ˇ ’I£ˇ ÅœÁ–ﬂ˘«-ˇ á¸ë¶[∞„,Ò}e¸k1ıñø(Ÿ˝ét|Ÿ¡ˇ Á1|‘tØ)«§∆‘óRùPè¯Æ/ﬂIˇ %=ˇ eûN¸´Úß¯ØÃ˙väG(Áù}Aˇ ØÔgˇ íH˘Ù•T(
 Ë3fÕú˜ÛÛŒß…˛Pæøâ∏‹ üWÄ˜ı%¯9/˘Qß9Áû|ı∞±ö˛‚+;e/4Œ±¢é•òÒU˙[>óy p˘GC≥–≠©¬“%BGÌ?⁄ñO˘È)wˇ eáŸ…øÁ)u√•yıT—Óö+uˇ d·ü˛I$ô‡L˜¸·ÊÄ4ˇ &õÚ>;˚ô$Ø˘)Kuˇ ÜäO¯,Óy≥fÕõ6lŸ≥fÕõ6lŸ≥f¿˛ΩgÂ˚	µ]NA•≤ëœ`?‚Lﬂeˆõ·œ˛t˛wj_ô7ƒ–i0±˙Ω∞;∆i©ˆÊo¯˛¬~”?4Õõ6lÿË‰hÿ:¨¶†çà#∏œaˇ Œ5ŒDøòL~UÛ<ï‘@•µ√ÔÄˇ tÀˇ /
>√ˇ ªø„/˜æèÕûUˇ úﬂ–˚ä÷–o˚€g?3D?‰ˆyW>ô~\kß|∑¶Íd’Æ-!vˇ X¢˙ü¸≤Eõ6lŸ…Á*/MØê/’z –G˜À¡s¿πÓø˘ƒKm‰XeÒÒs<üsz?Û+;NlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥¡Ûìﬁo6y∂{xö∂Zemb Ì…O˙Dü7õ‡ˇ R8ÛëfÕõ6lŸ≥gGˇ úÛ˚y+Õñón‹lÓX[\éﬁúÑg˛1I¬_ˆ9Ù7∫Ån"x_Ï∫ï?")ü-o-Õ¥“@z∆ÃßË4œEŒﬁî◊u+JÌ%¢ø¸äøÛ;=âõ6xØ˛s?C~j∑‘TQo-ß≈£fçø‰ü•Ü_ÛÑöﬂ°≠ÍZQ;\[,¿{ƒ¸?‚7Ï,Ÿ≥a_öt(ı˝*ÔHü˚ª∏$Ñ˚sRúøÿ˝¨˘ãyi%ú“[N8À20e<X}˘ÙKÚ+Ãﬂ‚?&iwÃ‹•d=˘B}Ø˙ﬁü?ˆY<ÕÅuk%ø≥ûÕ∑Y¢xœ…îÆ|∏ñ3¥m≥) ¸∆zS˛pÉP·™Í∂5⁄Kx§ß¸crüÛ?={õ6lŸÀø?ˇ 8a¸ª—ò[2∂±v•-S©^Õr„˘"˝üÁìä?üÛLÛªK+ë…fbjI;ñ'ƒÁ†Á,€Z÷[ÕWâ˛á¶öCQ≥N√o˘züÒë·œhfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6s˘»ØÀìÁè*œ≤Úø≥ˇ I∑ nYı"Òñ.JøÒgßü>Û“üÛà_õk•›7ì5I)ov¸ÌéÀ)˚p|ß˚Qˇ ≈øÂMûøÕõ6lŸ‚?˘Ã1~ëÛri®jö}≤!Â…Yﬂ˛I¥9∆|∑£I≠Ív∫T?ﬁ]œ"û.¡?„l˙{ik§)m„JGÄQ≈q\Ÿ‚Ø˘Ãœ2˛êÛLJ«ß€-GÑíüUˇ ‰ó°ÉÁ
¸±ıÕz˜\ëjñV‚4>1Îˇ "¢ëŸÁ≤3fÕûLˇ ú⁄Ûg©ußyn&¯bF∫î{±Ùaˇ ÅTõ˛Fd˛qG _Ûú7RØ(4‘k¶ØNC˜p}>´˙üÛœ=·õ<ﬂˇ 9π©ò¥=7O˚Îßêè¯∆úÊ~xÔ>è˛IÈ_¢ºô£⁄“áÍëHGºÉ◊o¯i2kõ6lŸ≥fÕõ6lŸ≥fÕõ6lÒó¸Â«Ê√Îzß¯GOì˝Oj‹q;I?ÚüÚmæ«¸fı?ë3œ≥fÕõ6lR⁄‚KiRx«,lM
∞<ïîˆe9Ù+ÚÛA0ºπÙƒ~ê∑>ç“çæ06ñüÀ:|ÎÛOÿŒçúK˛rˇ JûH{äT⁄\√-|*Zﬂ˛ggÜ3ﬂÛã:°øÚÇ±´[¥–ü¢Geˇ ÑuŒ≥õ6lŸƒ?Á0§·‰Çµß+∏GœÌ∑¸kûœ†Ûåpàø/Ù∫m…fcÙÕ.uŸ≥fÕõ6lŸ≥fÕõ6lŸ∞ßÕ⁄ÿ–¥{›Yø„“ﬁY∑ÒDg´>bœ3œ#M),ÓK1=I;ìâÊÕõ6lŸ≥fœ•ïûao1y_L’d<§û÷2Á≈¿·/¸îV…N|ƒÛú>é∑®D?bÓu˚§aùã˛p∆RæqùF∞ñøDêˆŒlŸÊ?˘Œ(>ü§Í@o”BO˙Í≤˘2Ÿ»ˇ ÁµO®˘ˆ≈	¢‹$–ü¶7uˇ áçsﬂ≥fÕü<ˇ Á"|ª˙œú
)“ãî˘LÕˇ %◊;Ô¸·?ò~≥°Í3öµ•¬ £¸ôñüÒ8˛=õ6|≈Û≠†≥◊uQ∞äÓtˇ Åëó:˜¸·•ŸáŒR≈]¶±ï~Áâˇ „\ˆÊlŸ≤˘ª˘À§˛[X˙◊ÑM(?WµSÒ9˛wˇ }¬øµ!ˇ U9>xŒûs‘ºÂ©Õ≠kzó3ˆ(£ÏE˛ƒi˚+˛ÀÌr≈|Ö‰}CŒ˙ºñµöcÒ1h?ºöOÚ¡}Ö¯õ>ã˘#…÷>N“-Ù-1i∫Rß´±ﬁI_¸π‚o˘ß3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6l˜¸Â/ÂyGX:˛ù4ùEÀ#h¶?ëííˇ {¸ÙO˜^p¯•xùdçä∫êUÅ°t Áπ?Á?>·ÛÕöË∫ƒÅ5€u¶˚}a|üÒhˇ wGˇ =S‡ÂÈˆ‹Ÿ≥fœöüö>aˇ yüS’A™Ou!C˛@<"ˇ íJô3ˇ úXÚÔÈü<⁄;
«dí\∑˚·¸ñí<˜∆lŸÛcÛgÃ‚5Íöò5In§»CÈEˇ $—3÷üÛáû]˝‰„®0§öÖÃíW¸Ñ˝¬√G'¸w<Ÿ≥gŒˇ ˘»?1ùŒ˙•»nQ≈7’”¬êèCoõ£7˚,Ù¸·WñE¶Ö}Æ8£ﬁ\îˇ ë
ˇ &¯ÙnlÚg¸ÁŸ7z5∑eé·ˇ ‡åKˇ góÛÍ'óÌûùkjPFîˇ UUp~lŸ≥fÕõ6lŸ≥fÕõ6lŸ¸≈ÛZ˘KÀ˜⁄ÎR∂∞3†=üÇˇ e+"ÁÕ+´©nÊ{ôÿº≤±wc‘≥L«˝câfÕõ6lŸ≥gnˇ úIÛ´h>m].F•∂™ÜΩE¨ñÌÛ˚qœl˜6sØ˘»ã1w‰=^2+∆ ˇ í∆ôÛ√=±ˇ 8aveÚÖƒ'˝’ ˚„Ö≥æfÕõ6pˇ ˘ÃH˘˘#óÚﬁB	˛6œÁ–_˘∆iDüó˙Q≠h≥∫isßÊÕõ6lŸ≥fÕõ6lŸ≥fÕúˇ ˛rVã»∫√&ƒ€Ù3*∑‡sÁ^lŸ≥fŒπ˘/ˇ 8Ì™~c©‘eìÍZJ1_XØ&ëá⁄X#™Ú„˚R3p_Ú€íÁf‘ÁÙG∑+c©]GsMöUGJ˚∆ãS˛zgôˇ 1ˇ -ı_À˝Q¥ça*réD›$NÇH€˛$≠Ò&Esgø?ÁnoÀ˝;óÏ‘|Ñ“ÁXœòævîKÆÍ2/Fªúè¶GŒøˇ 8dÑ˘ fÑøÚrˆﬁlŸ√Á1¨E«íÑ‘ﬁ»_ÔEˇ 33 _íóﬂRÛ¶ç5h>ª
ÏÌÈ¯û}Õõ6lÒÔ¸Ê÷ÖËkZvÆ¢ÇÊŸ°'ﬁ&Âˇ ∏¬ø˘√sÍ~k∏”ò¸ñèA‚Ò≤»øÚO’œkfÕü6ˇ 8 y«Yåvø∏?|årkˇ 8ì)O>[(˝∏'˛ ∑¸kûÔÕÅıJ€MÅÓÔ•H-„y$`™£¸¶oÑgúˇ 5øÁ0,¥ı};…j.ÆzπÙó˛0∆~)õ¸¶„¸eœ'kzÌˆªw&£™L˜7Sºíìˇ 6ˇ *èÖg˘O :óõ5¥çûÍS∞~‘í7Dç?i€=Û˘/˘7a˘i¶˝^"&‘g ‹‹SÌ˛Îè˘`èˆˆæ€ˇ ì–ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6l)Û_ï¨<’¶œ£j—âmnã„˘]Ï»çÒ£6|˘¸⁄¸©‘.5V”ÔAí÷BZ⁄‡ÜTˇ çeO˜l≥˛£#4?O‘.4ÎàÔ,§hn!`È"X}ñVÏè»Ô˘ K?2,z/ö›-uMï'4X¶=π~Ã3üÂ˛Èˇ cè˜yËLŸ≤5˘óÊÔñµ-X5Ω¨¨üÎÒ+¸îeœöÍØ˘¬/«W\q˛˙∂C˜Õ7¸»œUf¬_;ÎcB–ÔıZ–⁄€M(˘™3/¸6|∆bX‘ÓN})¸™–ø@˘[K”iFä“.c¸∂Q$øÚQõ%Y≥`][PM6Œ{È>ƒ<≠ÚE.V|ºΩª{…‰∫ò÷I]ùèâc…≥Ëw‰Ö˙…M≠8≥€â€Á17Û7'˘≥«øÛõ§˛õ”o™ø¸ú9ÁqYúáÎœ©∞ä"Å‡1˘≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ ú ÷Móì‚≤CCyw7˙®Ø7¸M#œÊÕõ6lŸ≥f√O+jÔ£j∂zúfçkq†ˇ ® ˇ √>ü´Ü‡Ó2˘ﬁ+‰≠føÚ≈7¸G>qg≤Á	O¸Î∫Äˇ óﬂ˘ïz/6lŸ≥êˇ ŒWYõè ﬁ∏0…üÚU˛7œÁº?ÁoE«êÌ£≠Lœ˙\Àˇ 3s≤fÕõ6lŸ≥fÕõ6lŸ≥fÕêØŒΩ5µ/&k»*ﬂSï¿˜AÍˇ ∆ôÛÉ6lŸ≥g”OÀÌ"ﬂHÚˆùaf√¨Aiﬁ™üÊÏK∑˘MíÛ˜¸Êéëo?ï≠uÎ˜äà›¯»èÍ'˚/M˝Üx≥6}	ˇ ún”Nü‰-*6i#y‰díJøåπ“fîDç#l™	?!ü-uü≠\Àp›éœˇ yg°Á	m˘áQπÌü¯9øÊV{6l‰ﬂÛîˆ˛∑ê5›D—„û Ú,ˇ W◊ÙŸáTº∑o∫D9Ù„6lŸ≥œÛöz?÷|±g®Vµº
OÇ»é¸:Gûrˇ ú|’ŒïÁ≠"z–<˛âˇ û –ÃÃ˙#õ6|„¸ˇ î€Yˇ òŸ‚Xmˇ 8›ÆÿË^u≥‘5Y„µµç'Â$¨EbëV¨ôæıGò?Á*ºã§"ª{ŸÏ€D«˛JKÈEˇ úìÕﬂÛõ˜°Ú÷ûñ‡Ï%πoQæb¯"üıû\‡˛p¸ƒ◊¸„7ØØ^ÀtA™£"ˇ ∆8SåI˛≈29ù#Ú£Ú#^¸≈êKjüV”QÓÂÜﬂia^≥…˛J¸ŒÈû‹¸¥¸™—/,~•£«˚◊÷ùËdîéÓ›ó˘#_Å?÷¯≤aõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÛœëtø;Èíh˙‘^§∫∞Ÿ—áŸñ'˝á_˘µπ&xGÛÚGX¸∑ª"ÂM∆ô#R§	IG˚™oÚÌ∫Ÿ≥úÁd¸®ˇ úù◊¸ê¬˙∫ññ¥)[˜ëè¯¢à–æ‰Êü…ÈÁ¨ˇ /;¸ØÁµT“Óï.ÿom5P|√/¸Òi2{ú?˛sÃ£|òlî—ÔÓbäü‰≠nÒâ?‡≥√yÔo˘≈_/˛àÚ-§å)%Ïí‹∑˚&Ù„ˇ íQGù{6rØ˘ cÙoêµ&èqÈ@?Ÿ»úˇ ‰öæxW öI÷5{-4
˝j‚(‡›S˛6œß °@U`2Ûf»/Á¶¶tﬂ$Î –õGå¯À˚è˘ôü:m‡kâ›ùÇèô4œ®˙]äÈˆêŸ«≤AF>J’ÇsgêÁ7·¶≠•K¸÷“Ø¸Éˇ Áö„~¿ÉüS,•¡ã—ëH˙F-õ6lŸ≥fÕõ6lŸ≥fÕõ6y´˛s{óË}.ï„ıô+Û·∑¸mû@Õõ6lac6°qù™ô'ù÷8‘ufc≈¨ŸÓø ø˘∆ü.˘J 95[xµUîeôC¢∑ÚA¸
â¸¸}G˚_ÿY7õˇ #¸£Êõf∂º”†â»¢Õnãäô^0ºø’ìöìû¸—¸Ω∫Úª>Öv}A))A$m˝‹îˇ Öu˝ô◊"y≥ÍVí≥Ä7⁄Ù“µÒ‚2˘Ì0á…ÀÜ“Eˇ Ç¯?„l˘ÕûÕˇ ú'ÑØño•=¯è∫(øÊ¨Ù>lŸ≥dÛ√J:ßíµãeo™I Ò˛¸…º˘«û∆ˇ ú%’˝mQ”I©∑∫Yi‡%@øÆœGfÕõ6lŸ≥fÕõ6lŸ≥fÕâ][Gu€Ã9G"îa‚qaü2|ÂÂπº≥¨^h∑ ˙ñì<U=¿?ˇ ≥N.0õ6lŸ≥ŸﬂÛçˇ Ûê:^•§€˘k_∏K]JÕ1<¨&ç~∏»ﬂ¨ã˚∂F˚m9|\;’˛µcß¿nÔn"Ü›ELí:™”˝v<s≈üÛìﬂù÷æ{∫áF–ÿæïd≈Ã¥ K)9†?Ó®ìí∆ﬂ∑Õˇ gÜp¨¢È3Î–i∂ã {ôR$,‰"˛º˙s†Èh⁄}∂óo˝’¨1¬ø$PÉ˛#Ö?ôz∏—¸≥™j–√g;/˙‹'¸?˘üû≤ˇ ú“∏€j˙ëm‡ÖO˙¢I˛N&zã6lÊøÛí)œ»:∞ˇ ä„?t±/óﬂÜ£j›i<g˛sÍ&lŸ≥g.ˇ úõ”?HyS´B"ò∞ëø·9gÇÙUÙçB€Rår{Y£ò
“•IJˇ ±œhy{˛s…˙ÇÅ®≠ÕÑù√«Í/˚Éõü˘π1µˇ úÜÚ%»™jı√ß¸úE≈€ÛÎ»Í*uã_°Î¸3¬üö˙Ω∂±ÊΩWP±q-¥˜rºnΩK|,+¸√"y≥fÕû·ˇ ú9‘˛∑‰∂∑&¶÷Úh¿#õ˛%+gsÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ∞.©•⁄Í∂“Xﬂƒì€L•^92∞=ôNyKÛó˛q$È—œÆy>@mcVñKIöÖG'0Lˇ mT∫Â¯ˇ ‚«˚9Ê,µbÑ2ö∏#:íˇ Á$|ÁÂP∞≈yıÀe•"ª®ßÇ…UùÿÀ«/ÛüÛ⁄ÎÛ>nmV”Í^°`éY]üá≈≈î‡˘üÌg1ä&ïƒh*Ã@ w'>ù˘GD]G≤“PPZ[≈ﬂ‰*°˝XmçñTây»¡Tw&É<Ÿˇ 9ãÁ->ÛÀ÷∫^üuÚµ‚¥´äÂB«%9Ñ'çYøk8G¸„¶ô˙GœöLT®Iöcˇ <ëÊ…üC3fÕúá˛r∫€˘ıß≠$	ˇ %Qˇ „LÒWÂÂó◊º…•⁄ùƒ∑∂Í~FD>ôÊÕûZˇ ú„∞¨Z5Ë˝ñ∏å˝"_¯ãgî3È∑ê5©y{MΩæµú_sìáŸ≥fÕõ6lŸ≥fÕõ6lŸ≥g	ˇ ú»—Z˚……zÇ¶ Ó9¯+áÄˇ √…xá6lŸ≤k˘+yoeÁ={≤Ky$Ùû(ﬂÏ\Æ}Õû1ˇ ú’Ω∑õÃ÷VÒgÜÃzîÌ…‰h‘˝˚<ÛŒyKG}kX≤“„k´à¢˝wTœß™°@`3ïˇ ŒPÍ"À»:èÛMËƒ?ŸK·≥¿Óo˘√Îo‰uîˇ ªÓÁê}!ˇ ôY€≥fÕõ‘,í˛⁄[I∑édh€‰√ãgÀÕWOìMªö∆aI-‰xò{°(ﬂàŒıˇ 8]ÊeÊ[Ω)Õˆ‘ï/_˘&Ûg¥3fÕõ6lŸ≥fÕõ6lŸ≥fÕûOˇ ú…¸±tö/;X•cp∞^Pta€ŒﬂÎ/Ó˝Xü<∑õ6lŸ±Õ#0
I t∆ÊœGŒ˛Xæ©™?õÔS˝∆±€‘lÛ0¯ú{A»…˘3ÿŸ∆øÁ-<¬4Ø#œl$øö+q„J˙Ôˇ 	ˆY·˜o¸‚FÑtœ#√p¬ç}<”˝ ˝]·`Œœõ6s_˘…·‰Xˇ ≈QèæXÜxÀÈœQµ^ïû1ˇ πı6lŸ≤+˘≠a˙C zΩ∑w±∏ßÃFÃø√>j‰¢ÛÚªÕêGw.óvmÊEë$Hô–´hﬁ§a”u8A>õuni42!ôH˝cÚ±†F'‰pmØó5;Ω≠≠'îü‰âõ˛"π ”ø'|·®”Í⁄=Èª@Ë?‡§π,“Á<˘®P…e™ûÛLÉ˛6ïˇ ·rs¢ˇ Œj“–Í⁄ùº∏ÖSˇ %>ØùAˇ ú3ÚùïRûÍıªÇ‚4?Ïb_S˛Kgú?Á!ºüaÂ7›iZD^Öí«FÄìNQß/âÀ1¨úœ⁄ŒÁˇ 8?yœK’≠ﬂw?¸2ˇ Ã¨Ù∆lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥g.ˇ úòÛ	—<ã®ºfí\™[/¸ı`≤…S>GH¡bh $Êí6åÒpUáb(qπ±—»—∞t%YH ÉBÓ2@?1¸Ã≠}O˘âó˛k∆K˘ÅÊ)Ö$’/XâO¸oÖWz≠›Ó˜SI)ˇ -ÀƒéŒ·ˇ 8yaıü;	©˛Û⁄M'ﬂ¬˘õû‰Õõ6pﬂ˘Ãixy$/ÛﬁB?·do¯◊<©˘#´Á]i_ÙÿO‹‹øÜ}Õõ87¸Ê^èıœ'≈x£{K»ÿüÚ]^#ˇ ÒÁâ3Ë/¸„F¥5_!È≠Zº
7∑¶Ïâˇ $¯gOÕõ6lŸ≥fÕõ6lŸ≥fÕõ<ˇ Âh¸Ÿ†ﬂhRP}nE'≥”îO˛¬Pèü4o¨¶±ûKKï1Õ¥nß™≤û.ß˝Vƒ3fÕñ	SQ±Íü ø˘Ã8-l£”|ÁØ4J]¬°û2UΩOÊí>\ˇ ì$ænˇ úÃÚÌï≥á‡öˆÏèÉ‘_N0|d$˙ç˛™'≈¸ÎûDÛ?ôoºÕ®œ¨j≤nÓ_õ∑OeU≤àø/ÏÆÁsˇ úDÚCkûk˝1*÷◊Jå»IÈÍ∏1¿øÚr_˘Âû·œ<ˇ ŒjÎ_VÚ’ñöÍÔô+7/¯ycœÁ—/˘«Ì#ÙWë¥à°{Xˇ œfkè˘ôù6lŸ≥gœﬂ˘…è,ùœ·E"º+tû˛®¨üÚ\KëØ 5Ö<—ßk,x«Í$?Ò[˛Ío˘$ÔüI¡TnlŸ≥fÕõ6lŸ≥fÕõ6lŸ∞≥£⁄ÎVsi∫Ñbk[Ñ1»ç–´
˙ÎˆsÁÁÁW‰Âˇ Â∂®`p“Èìímn)≥˜‘üÀ<µ¸ˇ ﬁ.s¨Ÿ≥fÕõ'îøïóÊ>™∫}ê)kspG√∆“ø˚™?⁄ˇ Q]óËGï¸≥cÂç6Kè“¥∂@àΩˇ  f?¥Óﬂ∑Ì>gêÁ6<÷.uK/D’[Xöy ˛iO¡˜X‚Âˇ =sÕê¬Û:≈,ÓB®I;üMºëÂÂÚÊác£-?—-„à”ª*ÄÌ˛…˘6ÊÕú£˛rñ‡C˘®É’Ã
>ô¢œ˘>ΩßB7/w˝Ú œß9≥fÕÄµÀo≠X\€ù˝HdO¯%+ü.H¶ŸÙèÚvË›y;FîÓMç∏?ÏQS˛5…{(n¢πB$Ä>ÏvlŸ≥gáˇ Á1Ì˝/:´”˚À([ÓiS˛4…á¸‡Â≈'÷†Æ≈-öü#2ˇ ∆ŸÎŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gùÁ65ól,Å†öÛô˜∆ˇ ıW8¸„~ñ5>ÈQëUéGòˇ œ8ﬁUˇ áEœﬁiw¬ópE0ˇ ã[˛$2?{˘SÂ;ÌÓ4ã>?Wåº.\ˇ Œ=y„ÌÈıß¸õu¬πˇ Áˇ /Ê5˝S˝YÊÛ7ü˘≈ ¯Úì˛í%ˇ öÒÒŒ*y3S`ÌÛ∏õ¯IÜˆ?Ûé˛C≤ «§@ƒø…ˇ ']ÛÕÛó∫>õ¢kˆ:vëm§)d§™ZIEXF¶â˚Xoˇ 8GkÀ^‘Æí—S˛
Eo˘óû≈Õõ6pü˘Ã•'…që⁄˙‡&Âﬂ»ó	Á}∑O≠†˚ˆœ£≥dÛøÀ«ÃM’lrsl“†Òhø“Ôh≥ÁzÛ˛pìÃÇm3R–ú¸VÛ%¬Úe_MÈ˛´BøyÈåŸ≥fÕõ6lŸ≥fÕõ6lŸ≥géˇ Á.ˇ )_K‘?∆zrVŒÖ∫
>ƒ›S˛E¿ˇ íﬂÒïsÕ˘≥fÕõ6l^ ŒkÈ„µµFíyX""äñf<UTx±œ°øëˇ ñ)˘yÂÿt«°æó˜◊N;»√Ï¸êØ◊˝^∑ù<cˇ 9£Ê1{ÊKMV∆€ìòÚ?ÚJ8sÅiö|öç‘60
À<âÚúÑ_ƒÁ‘+OèM¥Ç∆ÓÌ„Hó‰ä‚8+6lŸ≥gòˇ Á6<ûg≤∞Û4+V∑sk1 ˇ ºÑüÚVEëÁÆy>áˇ Œ?yÿyø…ˆ7é‹Æm◊Í”¯Ûã‡‰ﬁÚEÈÀ˛œ:.lŸ≥fÕõ6lŸ≥fÕõ6lŸ∞ØÃ˛W”º—a&ì¨B∑ì
27èÏ∫7⁄G_Ÿu¯ó<k˘∑ˇ 8´≠yY‰øÚÍæ••Óx®¨Òè¯≤5˛˘W˝˘˚8”8[°BUÅ=A∆ÊÕñvs¥~TŒ/Îﬁrtº’ï¥Õ(–óëi,É˛(Ö∑¯øﬂ≤¸ÀÍ}úˆì|ó•y;OM'DÑAnõönÃﬂµ$ØˆûF˛o¯◊1ìŒêF”J¡c@YòÙ nIœöﬂôæpo8yéˇ ]bx\L∆0{FøªÅ~àï2Mˇ 8·‰ÛÊè:XƒÎ ﬁÕæ∑/Ö"¯£Ø˙”˙IüA≥fÕú/˛sQﬁK[zÔsySŸDíˇ ÃºÚØ‰•á◊¸È£AJèÆD‰{#zß˛!üG≥fÕõ)◊ê*{ägÀ;¯˝+âc˛Wa˜˙ˇ 8˚7´‰]º-¯ˇ ¿≥/ŒÉõ6lŸ≥gã?Á56Z0Íl˛NœÜˇ ÛÑJÍÀÿ€ƒ~ÁlıÊlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥góøÁ8‹ã]{.O‹!Œgˇ 8èo=€ì’`úè¯?«=€õ6lŸ≥gáˇ Á1Êı<Í´¸ñPØ¸4≠ˇ d√˛pr
‹kSx%≤˝Êsˇ Á¨3fÕúS˛r˙ﬂ’Ú4è˛˚∫ÅøO¯ﬂ<ã˘?t-|·£Jz˚q˜»´¸sÈ.lŸRF≤)GV ˜>f~`yeºØØﬂËÆ(-n›+Xõ˝î\'øÛã~n]Û≠¥R∑5kG´—°ˇ íÈ≥œ{ÊÕõ6lŸ≥fÕõ6lŸ≥fÕõÎ:=¶µg6õ®∆≥Z‹!I∫?Áˆøg<˘„˘®~\ﬁ5ÃÆ4I[˜3“•+“ä}ôÏøÿóˆ~.Hº´6lŸ≥bêA%ƒã*^G!UTTív
™:±œfŒ7Œ;ü)ÑÛ7ô]◊˜ù˛Æ§}ßˇ óó_˘ø€f„ËLßuçKπTTì–ü4ˇ 3|÷|ŸÊMC[≠RÊv1◊˝ˆøªÄ»§Lóˇ Œ1˘T˘ÉŒˆEóî6\Æﬂ€”˛Î˛û,˜ˆlŸ≥fÕëøÃè'«Á/ﬁË2“∑1Ñ˛ÃÉ„Öˇ ÿ ®ŸÛVÓ÷[9û⁄·JKu=C)‚ ~Mù˜˛pÛÛh∫Ïæ[∫j[jkXÎ–O%‰t\”¸ßHó=£õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≤ÁO…Ø*˘Ã¥ö≈ÑopﬂÓËÎøL±qgˇ ûúÛëk_ÛÑö,Ï[J‘ÆmÅË≤¢J“øW9?ÛÉó<∂÷£„ˇ 0∆øÚ{t˘¬-&™jóéÎk¸3õåÎ>K¸çÚóìôf“Ï#7+“yø{ >*ÚrÙˇ Áí¶O3fŒ1ˇ 9W˘Ñ<ØÂW”≠€çÓ™M∫S®è˛>_˛ ˙?Û€<%ûÀˇ ú4Ú!”4Kè2‹-&‘_”àü˜ÃDéC˛2Mœ˛E&z'6lŸÂè˘Œl“tÖ;ì5√èó£ˇ ôπÕøÁÙo“z∑úä≠ú3N‡}ˇ Üü=·õ6lŸ≥ÂŒ∑˛˜‹∆i?‚G=˝ˇ 8Áˇ (ëˇ _˛NIù#6lŸ≥fœˇ Œj8>l¥Q‘X'¸ùüøÁ÷∫¶¨›ÖºCÔvœ^fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gô?Á8mãi˙E«dötˇ ÇX€˛eÁ%ˇ úQº˛~≤BiÍ«:…'¯”=Îõ6lŸ≥gÖÁ/$ÁÁ©GÚ€@?·K∆Ÿ—øÁ„˝Œµ%jÿSËü=Iõ6lÊÛí˙w◊ºÉ™(1§rèˆ∆Ìˇ À<ÂÀˇ —⁄ù•ÔOBx§ˇ Äe·üPïÉ √pwy≥gçøÁ3¸òl5À_1¬ø∫øã“êˇ ≈±l+˛º¯ƒŸÁ´K©lÊKò§±0ta‘2ûJﬂAœ•üó~oáŒñΩ?“¢Vp?fAM˚	U◊$Y≥fÕõ6lŸ≥fÕõ6lŸ≥f¿˙Üùo©[…g{Mo*ïx‹VˆY[cûb¸—ˇ ú8ªÍIî%j∆Œv€Âo9È˛§ﬂÚ;<€Ê#k~Vî¡≠ŸMh’†2!
‘ì˚∑ˇ `ÕÑY≤’K™*O@3¶y˛q€ÕﬁqdxmŒÕ∫‹]”≈èV_ˆ	«¸¨ıßÂ'¸„ŒÖ˘xÏÆÍ¥ﬁÊP>´«∏á˝oä_¯≥è√ùO6rø˘…o<è)˘>Î“n7w„Íê¯˛Yˇ ÿAÍ|_œ√>Á∞øÁ<ñl¥õœ3N¥{Ÿ˛˚ã˚∆œ3qˇ û9È,Ÿ≥fÕõ6xã˛r„ÚË˘{Ãc^µJYj¿πßEùø_˘ÎÕ˛S4øÀúCOøüNπäˆ—Ãw:…é™ y#ı[>è˛Uy˛>y~€\ÇÇIÑË?bU⁄T˚˛4ˇ ä›%π≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f íEçKπ
™*Iÿ ;ú˘Â˘ı˘ñ|ˇ ÊYÔ°bt˚‹ZéﬁöüÔÁªÚì˝^	˚ÚWï.º€¨ZËV#˜◊rØÚØY$oÚcèîç˛Æ}+–t[m¬ﬂJ±^÷±¨QèÚTqOÛ`ÏŸ≥gÉÁ+ºÃ5Ø;‹@áîV«læ’óÓñWOˆ9—ˇ Á|∫k™ÎŒ6˝›™˘-7¸»œUÊÕõ6l˘o¨?;Ÿÿwïœ¸1œ†_Ûé©«»Z@?Ôñ?|íËŸ≥fÕõ6xs˛sÏOÁoLÓl·CÙô%ˇ ôô6ˇ úµ<ı´û¿['¸ülınlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ ú≈—ç˜ì⁄äõ;∏§'¡X<˛Tœ'~Pk´†˘∑J‘\—#∫å9W>îá˛€>ífÕõ6lŸ·O˘À∏ ˘Íbjﬁ?‡xˇ ∆π“?Á‰Üµ~v«ü=Gõ6l!Û˛ç˙oÀ⁄éòM≈§—Ø˙Ãå˛>dÁ“ˇ ÀMlkûY”5 jg¥Öõ˝n!dˇ áÂí\Ÿ≥ù˛y¸kÂ;ªWï‰Î6˛>§`ûˇ cı"ˇ gü<3‘_ÛÜ?ò¬Æ|õx˚K[õZü⁄˝"!˛≤ï‘ó=cõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ±;ãhÆP≈:,ë∂≈XÕNCuO…/%Íl^ÁG¥‰zîåFO¸âÙ∫/˘«?!F‹óHÑë‚“˜4î…FÉ‰/˘|Ü“tÎ[WµH≠ˇ Nÿõ6lø¸ÂwÊ(ÛOôŒój¸¨têaZöS˛Ùø˚Uá˛yïúF“n5ãÿ4€%Áqs"E¯≥û¯Á“ˇ &y^*Ëˆöß˜Vë,u˛b«'ŒG‰Ì˛∂ÊÕõ6lŸ≤˘ø˘wü¸ªs¢Ω¡•ªüŸôª?Íø˜oˇ ªgŒkÎÏ.$≥∫CªG"6≈YOV˜VŒ¡ˇ 8«˘∏<ëÆ~é‘_éì®ïI	;G'Hgˆ_˜\ﬂ‰|Ó¨˜nlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥œÛñüõ£À˙g¯OMzjÇ~¸©ﬁ8≈◊π˚Òã‘˛dœÁØÁø+çÖúûs‘ì]É†#q?Ωõ˛{:OÚ˘eœKÊÕõº«ÆA†È∑:µŸ§ë<œÚ@Zü6œô:÷≠6±}q©]œu+ÃÁ¸ßbÌ¯∂{Î˛qø GÀ>J∞ÜE„=“õπ;ÀÒ%’É“\Èπ≥fÕâ^J!ÜIODVo∏gÀ9_‘vs˚Düø>å~FAËy#FCﬁŒ6ˇ Çˇ „lúÊÕõ6lŸÛ€˛rCU˝'ÁÕV@j±»êè˘‰â√´g~ˇ ú&”>^‘/»ßØvj\ŸËºŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥dkÛ/À‚ü-Í:({õwXˇ „ ·ˇ í™ôÛHÜâ®jÆß‰AÙóÚüŒ+Á,ÿk@ÚíXUeˆï?w?¸îVˇ cí‹Ÿ≥fÕûˇ ú≈á”Û∞oÁ≥Öø˛5…ß¸‡‹ÙóZá≈mõÓ3åıvlŸ≥gÕ?Õ.-˘üR“iEÇÊ@É¸Ü>§?ÚIì=wˇ 8ÅÊa™˘;Ùsµe”ßí*w‡ˇ øåˇ ¡I"ˇ ∞Œ„õ6l'¸‰∑Â±Ú_ö%ñ›8È˙âkà(6üﬂ√ˇ <‰?
ˇ æû<Á\◊ÓºΩ®€Í˙{pπµëdCÓß£íﬂe◊ˆó>ëyŒvût—mµÎ˚ªîñµ(„·ñ&ˇ *7™ˇ √dÉ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸŒ?>ˇ 3”Úˇ Àí›¬¿j75Ü—{Û#‚õ˝X˜üÎ˙i˚yÛ—›§bÓK3íw$úÙw¸·«Â±‘µ9|ﬂxüËˆ5äﬁΩfºqˇ ao¯9W˘3ÿô≥fÕõ6lŸ≥…üÛóøî	ø«T∫ìä^™è≤ﬂf+üıd⁄)ÀÙ€˝ÿŸÂÏˆá¸‚∑Á`Ûí˘OXì˝…⁄'ÓéÛB£Ïˇ ï4ˇ «˚6z6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6D4ø2l?/tYuõ‚O±5°ñB>◊¸ü⁄ëøb<˘€Ê2^˘õQüY’$ınÓ\ª∑oeQ˚(ã"˛ d´ÚWÚ∫Ã]~-4∂1R[©Ï∆Ÿ˝˘7˜qˇ ¡˝îl˙!ccÑ⁄Z†éQR4Q@™£ä™˚*‚Ÿ≥fœ;ˇ Œdy¸iz$>W∂j\j,$î–∆kø¸eõè¸äì<¡˘S‰ßÛßô,t5≈4†ÃGhì˜ìü˘¨´˛_˙Kkà„Q@ ÄÉõ6lÿIÁõﬂ®Ëç›iË⁄Nˇ 1≥gÃl˙g˘ueı-iv¥°ä ›H˜•rCõ6lŸ±˚ÿ¨-Âª∏<bÖG>
£ì¯˘ÖÊ^MgQ∫‘Ê˛ÚÍi&oõ±êˇ ƒ≥ﬁÛå˛_:/ëtÂqI.UÓ[˛z±hˇ ‰èßùG6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœŒK˘º£ÊÎáâxŸj$›B@⁄Æ¸Ûõó√˛˚xÚyˇ 8s˘ö∫e¸ﬁOø~0ﬁüVÿì∞òﬁEˇ =£_á¸∏∏˝©3ÿ9≥fÕõ<cˇ 9ØiÈ˘û ‡ª,T}+$øÛ^ˇ ú"ª„≠Ívﬂœjèˇ  _˘õû¬Õõ6lÒè¸ÊwîNüÊ+mz5§ZÑˇ ≈ê¸ÔÖ°ˇ Å¿ﬂÛá>qOôÂ—&jC©¬BÉ˛˝ä≤Gˇ $Ωuˇ ÅœkÊÕõ9◊Á«ÂÇ˛`˘r[Ä˝!oY≠Xˇ øu_Âùw˛∑˝å˘È<ç RD%YXPÇ6ea‚3∑ˇ Œ-˛pè'j«B’$„§Í. f;E7ŸI…I∫ó˛yøŸL˜lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÿçıÙIwvÎ©wv4
™931Qü=?<5%¸≈◊‰øRWOÇ±ZFv§`ˇ xÀ˛¸ôæ7ˇ a˚Ø"WÚ›Áôµ;}MNwWR–vÍÕ‡àø∑Ï¢Á“/!˘6”…∫-ÆÉ`?ulÅKRÖÿ¸R ﬂÂI''√ÏŸ≥fÕõ6lÿR”mıKilocY≠ßFéDaP √ã)œü?ùˇ îw_ñ˙”ZQüM∏%Ì&=”ºNﬂ–˝ó˛oÜO€».ï™›i7Qj4708x‰SB¨:û˙¸ä¸Í¥¸»”))XµãeÊµ{}b˛˙˘$ˇ ~√?OÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥aWö|”ß˘[NõX’Â⁄@ºôèS¸®ã˚r9¯Q?k>}˛p˛l_~djÌ®‹÷+H™ñ–V¢4˜˛id˚Rø˚∞âë-Eª÷Ôa”4Ë⁄k´á	/RO˘¸M˚+Òg–Ø…ü ª_Àç4ÿ©%‰¥íÍa˚rS¢ˇ ≈Q}àø‡˛€∂O3fÕÅı-FﬂL∂ñ˙ÒƒV#I#∑EUôè…sÁÊ∑üßÛÁònµŸ™#ë∏@áˆ"_Ü˘Ò¯ﬂ˛,wœIŒ˛\?OüÕ˜âIØkµF‚%?Ωì˛{LºÁè˘yÈLŸ≥fÕú˚˛rSwëuy´NVÊ/˘À¸Ãœûv≠yq≤}©]P|ÿÒœ©∂Îm
@üf5
>@SÕõ6lŸ≈Á+ø0À^U}*•Ó≠X¢.∑/˛Ø‹ˇ œ\Òoî<∑?ôµ{M‘~ˆÓdà «‚ıcNNﬂÍÁ”M:¬-:⁄++a∆#X–x*
?‡FÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fŒcˇ 9˘V?0ºº[(˝'gY≠OãS˜êW˘g_á˛2,M˚9‡(fπ”.VXÀ¡un‡Ç*¨éáÔWFÔO»_œOÃ]=mÆôb◊-êzÒtÊﬂXÑ#~⁄ˇ ∫ü·˚<∫ælŸ≥gî?Á8¥Ú&—ØÄŸñ‚"~F'_¯ìd/˛pÛP˙ØùΩﬁõI£˘êRo˘ïû„Õõ6lÂÛì~F>kÚuÀBºÆ¥Ûı∏©‘Ñ÷_ˆP4õ:¶xKÀ˙›∆Ö®[Í∂gç≈¨©*t<Ö}øõ>ó˘SÃvﬁf“≠u´X.‚YW⁄£‚Fˇ )‡ÚósfÕûAˇ ú∑¸ú:m—Û∂ì˙-Àx™>ƒße∏ˇ R≥'¸]ˇ ≥Õ9Ì˘≈øœ!Ê[DÚ¶∑'˚îµJA#ÁâGŸØÌO
˝Ø˜‰_⁄Y3–ô≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥»üÛïüûcSë¸ó†À[Xöó≤©Ÿ›O˚Ãß˝˜{¸“¸Ó∂ÁÊlˆo¸‚w‰·Ú˝è¯∑Véó˜…Ktaºpù˘˚Iqˆø„˜„Á°Ûe;¨j]»Uív ûc¸ˆÚ_óã%ˆ©ëz§$Ã’„n$„˛À9ÊØˇ 9°ÂKRV∆⁄ÚË¯D_¯y9ˇ …<ãﬁˇ Œq†⁄”E'ﬁKö~	ˇ âa{Œq_í8ËÖÓÏO¸õ¡6ﬂÛúí◊˝#ERø‰‹ëˇ É$:g¸Ê÷Å)ˇ NªÄ¶2íˇ –‰Î@ˇ úõÚ.≤B@Z»fÂ?˘(G£ˇ %3§È∫≠¶©∏∞û;àOGâ√©ˇ dÖódcÛÚ˜NÛÓë.ã™/¬ˇ rÒE ˚«˛ØÌ/Ìß$œûﬁÚ•‰mV]WN2«∫8˚2!˚ƒ›—ø·[‡oâpï¸—®y_PãW“%h.‡j´ˇ Ãéø∂èˆ]ÌgΩ%ˇ ;ÙﬂÃõ çæ≠
è^ÿü˘+~‹-ˇ ÿŸgÈY≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ
|’ÊΩ7 ∫|∫æ≥2¡i©c‘üŸD_¥Ú?Ï¢ÁÇˇ :ˇ ;5ÃªX}*›è’ÌÎÙz”4ÃøÏc˚	˚l¸‚(ûgX¢RÓ‰*™äíOEQ‹ú˜¸„o‰8Ú5†◊5§[πMîÔıxœ˚®≈œ˛Óo˘‰ø∑ÍwŸ≥fœ+Œ^~q?¿⁄Lï?ﬂ:üˆQZˇ ÃŸøÁöø8Â_ÂÌœüµÎ}⁄´ûs»?›q/˜≤|ˇ a?‚∆Eœ£öNóm§⁄CßŸ ä⁄ﬁ5é4®‚£Ó¡Y≥fÕõ8O¸Ê>¥,ºúñ@¸Wóq%?…@”∑¸4qÁï&4”q“,ÈPn‚v‰∆}gˇ Ñç≥ÈlŸ≥f»Ê_ÁWóø/‡f‘ß^“©k+‹ó˝‘üÒdú…Âˆs¬?ô_ò⁄óÊØ&≥™	"â~ÃQè≥ƒùøm˘6z˛pÎÚ™Di<Ô®∆ThlÉµ¯g∏Úb?˘Ì˛Nzß6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûdˇ úöˇ úxìUy<ﬂÂxπ] ÓŸÚS≠ƒ+ﬁ_˜ÙÓﬂÔ˜úΩO)ÈΩÊâw˛ù+€›¿‹íD4e#¸˛%ˇ bŸÎO ˘À˚ESNÛ†ó[(ªA˚ß˜ï‚Åø ^Q∆,Ù^ù©[jP-›å©<*≤F¡îèÚ]~õ6yÛ˛sOI7>W¥øQSmx†˚,à„˛&ëÁúÁu—^y“'&ÅÁÙO¸ˆV∑˝rg—Ÿ≥f t
∞H°°ÛßÛøÚÒºáÊ{≠-TãG>µ±Òâ…(øÛ…πBﬂÒè;á¸·ßÊh+7íoüq ‚Œß∑[à˛O®ˇ åŸÍ|Ÿ≥`]WK∂’≠e”Ô„Y≠ßFéDm√+
2ÁœøŒˇ  øÀ}a≠®“ióΩ¨«∫˜âœ˚˙/≤ˇ Õ…˚y”uç2Ê;Î)àX<nÜå¨¶™ sﬁêû÷øò∂BŒÙ¨:Â∫˛˙.Ç@?„‚¸ß˝Ÿ˚©ø»·ùo6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûvˇ úïˇ úÖO.≈'ï|∑-uI[âêˇ pß¨hﬂÚ“ﬂÚC˛2}èíI©ÎùÀ˛qüÚ9ºÈ~5Ìb3˙ÕˆVO(‹EÔ}f˛oÓøüá∏@ Pl’µ{=⁄K˝Fd∑∂àry$`™ª6yØÛ#˛s2f{/&€âÿT}j‡ü8†¯]ˇ ÷ï£ˇ åyÁ?7˛hyìŒ[[øö·	ØßÀåc˝X#„¸&E≥fÕõ6l1–¸«©h3ã≠&ÊkIáÌBÏáÈ‡wŒÌ˘}ˇ 9çÆi,ñﬁhâu+a±ï ép<v˝Ãø&Xˇ „&zõ»ôZûÌ~π†‹¨‹iŒ3…=•à¸K˛∑ÿoÿv¬ÔÕØ m3Û#L6„”∫é≠opZ6?Ò8ü˝ŸÌÆ™Ÿ‡O<˘TÚN•&è≠Dcô7V§ã˚2ƒˇ ∂çˇ 6ø¯p≥D÷Ôt;»µ-2g∑ªÖπ$àhA˛üÃøeæÀgµ?#ˇ Á&tˇ :,z>ºRœZ†U="úˇ ≈Dˇ w)ˇ |∑⁄ˇ ur˚	‹≥fÕõ6lŸ≥fÕõ6lŸ≥fÕêﬂÃœÕçÚÚÀÎzºµù¡Ùm“ÜI˛U˝î˛i[‡_ıæØÊßÊÓ±˘è}ı≠MΩ;h…Ù-êüN0‚r€ïæ&ˇ %>ÖCŒÎ*^G!UTTívUUXÁ≥Áˇ Áó ¢?2˘ïjÃ+qnÌ?çœ¸ôˇ _Ï˙6lŸ≥ìˇ Œ@~v¡˘u¶}^ÕñMnÌHÇ>æò˚&ÊQ¸©˛Î_˜lü‰,ô‡…$π‘ÓKπyÓÆ$©;≥ªπˇ Çww9Ô_˘«è…ı¸º—yﬁ(:ΩËWπnº˚ÆŸOÑU¯ˇ ö^_≥√:∂lŸ≥fÕûBˇ ú⁄Û üT”¥$;[BÛ∏Õ+pJ¸ñ¯|‚ñ˛|ü»ö‘:˝§1‹M p´-x¸jcf¯
û\Y≥Ωÿˇ Œq\.◊ö27ºwâˇ ‚Xs¸Áñæ“g_ıfF˝jò'˛ásBˇ ´mﬂ¸ÛVπˇ ú·”î£Èπˇ .e_¯äIëΩW˛s{Wî¶Èvû∆YO¯Ä∑ŒoÊè˘…/;˘âZ)uµÖ∂)j¢.øÒb~˚˛JÁ4ñWôÃí1gcRI©'‹·óï~ß˙ZœÙ§~≠ëû12+ 2√‘^K∫¸9ÙÊŒŒ(R÷’("Pàä(™†qUUF-õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ<ˇ 9VtıÛ≈Ãl1¬cä!?¶(V≥»¿mœÑë´´Ò|Y…E¨∆/¨oD7t<yRºy}ûT˝ú8Ú∑ûµœ*KÎËW≥Z1‹àÿÒoı‚?ªì˝ö6v,ˇ Œhyí¿ıã[{ıXV?Jsã˛HÁH“?Á5º∑qA®ÿ›€7~%_øúMˇ 	íõO˘ ˇ  ‹Sù‰êìŸ‡ó˛e£åà˛y˛t˘ŒOæ“¨5ñÒ¬<)ÈJ	tuíïxïWí´/≈ûC“u4À»/·˛ÚﬁTï~h¡◊˛#üP4ÕB-J÷ÎsXÆ#IP¯´ÄÎ¯õ6lŸ∆?Á(ø+ú¸æuÂ©ÈÅ•@Ô˚æsEıcˇ )8/˜ô‚-]ª–/‡’tÁ1›[H≤FﬁOo≤À˚KüFˇ ,ø0,¸˚°¡ÆX–c≠LrØ˜±7Àˆ?û6G˝¨îÊÕõ#ûÚõÁù&]VJ≈&Ë„ÌF„ÏMÏÈˇ ø|-ü>2ø-ı?À˝UÙçU Ü`>	Sˆdè˛7O˜[|8C¢ÎWö%‰Zñõ+AwéD4 èÛ¯óÏ≤¸-ûÂ¸âˇ úÑ±¸¡ÅtÌD•∂ª¸QÙYÄÎ-Ω··˚I˚<ì;lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ9ŒAŒME°,æ\ÚîÇMH’'π]÷Ãêü€∏ˇ +Ï√ˇ ªÒ‹≤ºÆ“H≈ùâ,ƒ‘ízís•~G˛Jﬁ˛dÍ_htãvÊz}>Ñ?Õ3ˇ …%¯ﬂˆ˝ı¢Ë∂ö%ú:fõ¡inÅ#çz ?œ‚o¥ÕÒ6y„Œ∫wíÙ©µΩY¯[¬6Ì;±K˚R?¸‹ﬂ∂xÛ_ÛèY¸«Ω3ﬂπä 2}T'Çˇ ~K¸“∑˚	‰6lŸ≥fÕõ6l3ÚÁôu-^«™hÛΩµ‹F™Ë~ıaˆ]ˆëæœu~B˛z[~dŸ{†∞kV Ò≤Îˆ~±˘˚i˛ÍÚY%_ô_ñ:GÊöt›b?âjaôºâèÌ∆ﬂÒ8€‡¯èÊß‰˛≥˘q{ımM=KI	Ù.PNAˇ 2Â˛hõ‚˛^iÒ‰Fƒg†ø'øÁ,5-àÙØ5ø”ñä≥Y„ÂøﬁÑÂ˛˜¸∂˚ÎØ+yøJÛ]öÍ:%ÃwVÌ˚Hw˘dO∑ˇ êÍ≠Ü˘≥fÕõ6lŸ≥fÕõ6ld”$“Ã¡#@K3 RƒÙÁoÕœ˘Àù?F¶˘;çıÊÍnN°ˇ äˇ Â°ˇ ‰è˘R}úÚFøÊCÃ7íjZ¥Ôsw)´I!©˘í£ˆQ~˝ú≠Aæ◊Ô#”t®^ÊÓcDçIˇ öT~”7¬øµû◊¸âˇ úo≥Ú"¶±¨∫◊®=cÇø≥ÛK¸”±è˘ü∂ÊÕõ6s_ŒüŒ›;Ú⁄ƒÚ+>≠2ü´€W˛KMO±
ˇ ¡Iˆˆô<Êo3_˘õPõW’•3›‹7'c¯*èŸD
"˝ïœRŒ.~A6ú#Ûóò‚•ÀVP8›ˇ è©ˇ ª˝“ø∞øº˚|8zs6lŸ≥f∆À*ƒÜITPI'` ÍN|€¸ÿÛôÛüôØı∞IäiHäΩ¢O›Cˇ $—Yø …◊Âœ¸‚ÓµÁù
/0Z›Al≥≥à„ò>Íßá©Õ˝ßW˝üŸ¡wüÛá>uÄüHŸÃ?»òè˘9xS7¸‚üü„Èbè˛≠ƒ_Ò¥ãÅøËWˇ 0?Í÷‰|ı[€ˇ Œ(y˙SF≤é1‚◊∆éÿ•ˇ Œy∂‰÷Ú‚ Ÿ◊woπ#„ˇ ìÔ.Œi∞˙Ê•5«ä@ã˘sêŒﬂ©íüÃo /+˘+»⁄ªË÷1≈0µaÎ8/)©ÓŸ9:ˇ ∞‚π·˚PL»^CıÁ‘‰ŸE|2ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕòönsÊoÊ/òòº≈®Í’™‹‹ Î˛ß#È}—ÒœaŒ+˘:⁄?!'◊·I£‘¶ñwI2≤Éıt‰≠U#å<øŸbûqˇ úHÚÜºZm=e“Ámˇ pk„ºÄˇ V&ã8˜òøÁ<«fKiñ◊®:Âˇ ¿üR?˘+úˇ Uˇ úvÛﬁòHóIö@;¬RZˇ »ñsë´øÀü2⁄.4´ÿÈ◊ïºÉ˛4¿c :«.QπÂ·ËΩ‚8ÜΩ¢‹hó”i∑äVh£)Ú?Ïó‚œqˇ Œ*˘‘yè…–ZH’π”⁄∏Ô¿|VÌ˛Ø§ﬁü¸ÚlÏY≥fÕõ<3ˇ 9=˘8|ó´ùkMéö>†ÂÄQ¥RüäH?…G˛ÚÚy«˛Í¬/»/Œ9.5ä‹ñ}"ÏÑ∫åo«˘.#_˜‰_ÚR>Iˆ∏q˜ÂçÙGwhÎ,(tu5VVïî¯ãÊÕõ"üô?ñ⁄_Êñ˙N¨û- >8ü¥ëü¯ö}ô<˘õ˘]´˛^jGN’í±µL3®˝‹´¸»õ˝˘⁄O¯h•≠‘∂í•≈ª¥sF¡ë–ê FÍ À∫∞œY~IŒX≈x#—<Ó‚)≈;ÓàﬁË∫ﬂ˛.ªˇ ~zmΩ7©*	#!ëÄ*¿‘zqŸ≥fÕõ6lŸ≥fÕõ6lŸ∞.´´Zi“_Í•Ω¥Cì…#UÏs»ûÛïWìDÚ{=æû’Y.∑Ye÷/⁄Ç#¸ﬂﬂ?¸Wˆ[Œ9‘?%?"µ/Ãõ±+r∂—‚jMrGZ∫mÎˆÂˇ ÑãÌ?Ï£˚√À>Y”¸±ß√§i,ê/U¸YèÌªüâ›æ”a¶xì˛rÛÛmoÃø·Ëú˝KKP
éç3ÄÚπˇ Q"_Â˝ÁÛÁÕõ6lŸ≥fÕõ6l?Ú'ún¸ù≠ZÎ∂$âm§Vª:•âø…í>IüKtÎ¯µhØmœ(gçdC‚¨9©ˇ Å8Üª†Xkˆri∫¨	si(£« ®?ÛKŸe¯óˆs«ˇ úÛâ˙áóÃöØîÉﬂi¬¨–uö!˛O¸¥G˛ØÔ»∑û{e(J∞°{a«ï|„´yNÏjÃñ∑©C≥Âë¡"íÍÀûú¸∏ˇ úÕ∂ú%üú≠Ã2t˙’∏,á¸©`˚iˇ <ΩO¯∆πËØ.˘´JÛ-∞Ω—n¢ªÄ˛‘LûŒ>“7˘/ÒaÆlŸ≥fÕõ6lŸ±ó€∆”NÀh*Ãƒ ã1Èú[Û˛røÀYo§±’ØE@öD˘w?eøÁäÀ˛«<Ø˘ì˘„Ê_?±èSü“≤≠V÷§C√òØ)õ¸©Yˇ …„úˇ :'Â_‰nø˘ã0k(˛ØßI.Â ßUåuûOÚ˛z:g∂,?(4?À´O´È1Ûπê5Ãî2I˛Àˆ#˛Xì·ˇ Yæ,õÊÕõ6pﬂŒÔ˘…≠?…k&ë°º÷®Têk˛-a˝‰´˛˘_˘Î«Ï7ã5Õv˚^ºóR’&{ãπ€ì»Ê§ü‡ø ´ØŸ\Ùœ¸„ü¸„K3EÊØ7√E{[9^Î= ﬂÔ∏˝iëΩYõ6lŸ≥fŒ+ˇ 9Y˘ê<´Âñ“≠^ó˙∑(Váuã˛>d˙UΩ˘Î˛Fx´ æ\πÛ6©k¢ÿä‹] ±ØµOƒÌ˛J/∆ˇ ‰Æ}.ÚÊÖoÂ˝:€H≤mÌ"Hì‰£çO˘MˆõsfÕõ6rÔ˘…À·i‰L˜êEˇ e,c˛#ûÚ≠ôΩ’Ï≠FÊkòS˛	’sÍlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕëÕ-{Ùïı=L<6≤î?Âï·¸îeœöÄ4ìüMºÖ†è/Ë~í≠¥Q∑˙¡G3Ùø,=Õõ6lÒœ¸ÊgêNù´€˘™Ÿq~¢)àÌ4c‡'˛2¡ˇ &_"üÛãòÉ ^iK;ß„c™o%zØ˙4üÚ0˙_ÍÃŸÔŸ≥fÕÑ˛nÚ•áõ4…Ù]V?R÷·x∞ÓÏHáˆdçæ4l˘Â˘£˘k®~^ÎiÄ,üj	Ä¢À~¸ØŸë?aˇ ‡≥ßˇ Œ7ŒB'»æ[Ûì£Jﬂ∫îÔıvcˇ PŒ~ﬂ˚Ìøy¸˘ÌH•IëeâÉ£Ä  j=OÜ;6lÿIÁ%È~q”‰“u∏Dˆ“tÆÃ≠˚2Dˇ j9˘ø„\˜Á7¸„ﬁØ˘w+^C ÛFc\(›+—.TvﬂÒg˜RíﬂªŒOùKÚõ˛r_¸ΩeµV˙Óï]Ì•'·˛Ø&Ì	ˇ '‚ã˛+œb˛[~v˘sÛ04πƒwî´ZÕEîxÒ_≥*ˇ óÚ∏‰˜6lŸ≥fÕõ6lŸ≥fÕúüÛK˛rKÀûFkÉP’£Í0!O¸ºMÒ$_Í¸rˇ ≈y„ØÃøŒÛ„’’Ê„lÑò≠£™ƒüÏ?mˇ ‚…9?˚Ñgo¸Äˇ úv∏Û‹´¨kjhHvß¬”∞?b/Âá˝˘7˚˛.M∂¥ù&”HµèO”‚H-aP±∆Çä†xõ>s~z[…ùıîò∆ÓF˛V<”˛ó ô≥fÕõ6lŸ≥fÕõ=√˘+ˇ 9Â¥=;Bªæ∑÷∂–¿‚‰zjÃä±û‹Ò®¯y:∑˘9‹!û9–KçÖUî‘‚«Á,¸”ˇ úvÚÔüπ›≤}GT?ÒÛˇ óàæƒﬂÎ|2ˇ ≈ô‰OÃø»_2˘ ¥◊–˝cOk®*—”˛-nˇ èÚªg9¡˙6Ω°‹Õ.‚[[ÖËÒ9F˚”;WìøÁ0¸”£ÖáXéRµ\zr”˛2ƒ8¡¬Ÿ⁄|Øˇ 9Å‰˝Wäj^æõ)ÎÍß4˙$Éõ¡Dô‘¥Ã?/yÄ•j6∑$˛ J•ø‰]yè¯êfÕõ6l™k⁄~êûÆ•s≤xÕ"†ˇ á+úﬂÃøÛì˛F–¡Q}ıŸGÏZ°íøÛ◊‡É˛JÁÛw¸Ê≈Ù·¢Ú÷ûñ‡Ï%πnmÛ«¡ˇ ≠$π¬¸„˘ùÊ?99mv˙[Ñ≠Du„ˇ V¯ƒ?‡2/í'y[Ûïœ‘ÙI.§®‰TQΩÂï©Ï€=K˘[ˇ 8}ßÈE58H∑◊"Ñ[GQ
ü¯±æü˛?¯…ûäµµä“%∑∂Eä$UU¢™Ø¬£Õõ6˘«œZ7ì≠˛ªtñ—oƒ1´9≥kÒ»ﬂÍ.yÛ{˛røTÛ8ìLÚ»};Nj´KZO ˇ Y∏C¸±¸ÒgÏg“tãÕjÓ;:'∏∫ô∏§qÇÃƒ˚~ºˆ'‰_¸‚Ì∑ïÃzÁöÇ\Í¢ç4PÊoŸöu˛oÓ„˝ém˚ÃÙlŸ≥fÕõººÜ 	.Æ\GJŒÓ∆ÅUG&fˆUœù_úﬂô˛`˘ä}\‘ZØÓ≠ê˛ÃJ~øöOäWˇ -Û∏ˇ Œ˛YÕÁk‰˛h,Î˜\N?‰¬7¸gœUfÕõ6lŸ¬Á2u!k‰‘∂Æ˜7ë%=ïdó˛4\Ú«‰éù˙GŒ∫<®˙‰NG¥g÷?Úo>éÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕúO˛r˜\˝‰óµSFæπÜ{)7ˇ &3»ïöÈÔ4ÈziYÆ‚?»O˘&≠üJÛfÕõ6Dø5|áûºªw°KA$© ?±*¸Pø¸¬ˇ Ò[>|‡æ≤üNπí“ÂLW;#©ÿ´)‚ÀÛVœ~ˇ Œ=~h/üº∑∑]J ê]ÂÄ˝‹ˇ Û›>/¯ÀÍØÏÁOÕõ6lŸ¸”¸∞”14ñ“µ¬U´A8hü˘◊˘ëø›ë˛⁄ˇ ï¡óÁ˜ü|Ö™yTìF÷#·*nÆ>ƒâ˚2ƒﬂ¥çˇ ˆ‚Œ±˘ˇ 9'?ìzòôß—I§r}ß∑ØÚ˜íﬂ˘£˚Qˇ ∫øﬂmÌ7S∂’-£æ±ï'∂ôC«" ¿˛“∞¡9≥f∆Ooƒm ≤F‡´+ A™≤ùäúÛ7Êˇ ¸‚7¶MW…aò’ö…Õè¸ªH∫ˇ åR~Ô˘^?≥ûU÷¥;ÌÈÙ˝R	-Æ¢4h‰R¨>É€¡∞,…o"Õë* H éÍ√¶wÀø˘Ào2yp%Æ¥≠f¥êÒòiË}O˘ÏéﬂÂÁ§ºçˇ 9‰ˇ 7ä+±gvﬂÓã™F’Y	Ùdˇ a'/Ús¶´î‘¡y≥fÕõ6lŸ±;õ®≠ciÓcâYúÖP? fÿgÛﬂ¸ÂWî|≤)N©vªp∂˚ˇ .Âøwˇ "ΩoısÕòﬂÛìjÛò{dóÙuÉmË€	œ˝Ïû¸}8ˇ ‚º‰Ÿ≥“?êﬂÛãìÎ&-Œ¥6<VçPÚ˜Vüˆ¢É¸èÔ%ˇ !>ﬂØÌ≠¢µç`Å8£P™ä UeUQ≤®≈0≥Ã^h”<∑j◊˙ÕÃVñÎ˚r0? £Ì;êüy◊Û˛sF÷‹µØî-~∞‚†\‹Ç©Ûé§èˇ =/ı3Ã^pÛ~£Ê˝J]kXêKw592™®¢é8†Q®„Ñπ≥fÕõ6lŸ≥fÕõ6K<ì˘©Ê?%HCΩíÎS	<¢oı°~Qˇ ≤˚Âg¶-Á1¥›P•óõ°˙ÑÊÉÎU°'¸¥¯•á˛JßÛ2g¢,5}Fª≤ï'∑êrI#` √≈Y~ä… ¶9 d`ATzÇ3Ö~gŒ%Ë>e/{ÂÚ4´Ê©‚¢∞9ˇ */˜O˙–¸?ÒSgï|˝˘AÊO"HWZ¥eÇ¥[à˛8[Â*˝üı$‡ˇ ‰‰36X4‹aÓìÁﬂ0i˝®›€Å–G;®ˇ ÅV„íõ/˘»Ø>Y–G´Ã¿ø˛N£·º_ÛïæåPﬂFˇ Î[≈ˇ ∆∏ˆˇ ú±ÛÒëqo¸—Ö◊üÛì>∫ŸµF@í(ó˛#r9™~my∑To5{◊S’}wUˇ ÄFU»¥˜\9íggs’òí~Ûâ„ëFÄ≥@‰ÁIÚg¸„∑úº◊≈ÌÏZ÷Ÿø›◊_∫ZxÖoﬂ?˚õ=‰/˘√mJ+sÊYﬂRúoÈ%cÑzZ_¯8ˇ „wΩ#F≤—≠ñÀLÇ;kd˚1ƒ°T±\õ6låyÀÛ7ÀæMå…ÆﬂEn‘®éº§oı`NR∑¸ÛèÊ¸Ê}Õ¿{O'[z
j>≥p?Œ8(”˛z4üÒè<ÂØ˘èQÛ”_Í˜]\øWïãıE~ ˇ íøt/ œ˘«O1yÙ•◊®ÈfÑ‹Ã‰?Âﬁ-ûoıæø‚ÃˆWÂü‰˛É˘ymËÈÚπp∑2P ˇ Ïøa?‚∏¯ß˚/ã&Ÿ≥fÕõ6lŸÊ˘ÀﬂÕÒm¯Jì˜≤Ä˜¨ßÏß⁄é€˝i?ºó˛+‡øÓ∆œ8˛[˘ÔœZÂ∂ÖePfj»Ù®é1˝Ï≠˛™˝üÊ~	˚YÙ{@–≠44ù==;[X÷8◊ŸGo¥Õ˚MÉÛfÕõ6lÚﬂ¸Á≠∆#LvyÊa˛®é4ˇ âæs?˘ƒΩ/Îﬁ{∂îäãXgòˇ ¿z#˛l˜ÜlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûUˇ ú·÷„ë•)ˇ N√˛8ˇ Ênsﬂ˘ƒ}Ùáûa∏"¢Œﬁiæí>ÆøÚ=Ÿõ6lŸ≥gêÁ0*Nüxût”ì˝ËàÓ¿fZR9ø’ôGˇ ãS˘•ŒS˘!˘°/Âﬂò"‘Xñ∞õ˜WH;∆O€˝˘~Ò?Ÿ'ÌÁ–˚;»oaéÍŸƒê °—‘‘2∞‰¨ß¡óÕõ6lŸ¸Ã¸Ø“0Ù”¶Í…GZògP=Hõ˘êˇ /Û∆~ˇ ÅeoÊÂ6≥˘u}ı=V>P9>ç¬È ÚüŸì˘‚oç’‚¯i˘E˘È≠~[‹∂o¨Èé’ñ—œ¬k’·o˜LøÂ/¬ﬂÓƒlˆﬂÂøÊŒÖ˘ÉkıùaÎ([w†ñ?ı”∫ˇ ≈â ?Ú≤cõ6lŸÛœÂæÖÁão™k÷©8‡ìÏ»üÒäU¯◊˝_∞ﬂ¥πÂüÃè˘√ÕcGÁwÂY?IZç˝¢Œ£€§Sˇ ±Ùﬂ˛*Œ©iwZ\Ìiñ˜h—»•X|’˛,íﬂ)~ly£ T]Qûó§Eπ«ˇ "%Á¸&v/,ˇ ŒkkvÄGÆX¡x£´ƒ∆˙æè˛:náˇ 9ìÂ‡¸wVOﬂîbEˇ ÇÖôˇ ‰ñNtœœﬂ#j@z≈≤◊¥¨bˇ ì‚<í⁄y€Bº ⁄Í6í◊˘'çø‚-Ü)™Z…BìF’ÈG¯„d’Ï‚íxî{∫è„Öóøò]±›jvqS˘Ó#≠Ú-™ˇ ŒEyL’’°êé–áñøÚ%rØŒh˘bŒ´¶Z›^8ËHXêˇ ≤fy?‰ñrÔ3ˇ Œf˘üP="ﬁﬂOC—®eê≤íë…„ﬁgÛÓªÊóı5ÀÈÓ˚Öë…Q˛§_›ß˚¬ÿeÂÔ-Í>cºM3HÅÓnÂ˚)©ˇ Yª"/Ì;|˚YÏ…?˘≈À)ıè2Ω’Ö#Î'¸öˇ }2ˇ ø‡O˜Zˇ ª3Ω„eï!FíV
ä	f&Ä‘ìûs¸⁄ˇ úº∞—ÀÈæNUæ∫V∫oÓPˇ ≈CÌ\7˘__Òó<•ÊØ8Íﬁkª:Üπu%‘Á°s≤èÂç¡íä´ÑŸ>Ú/‰gõ<Î∆]2…í’ø„‚›≈Og¯§ˇ û)&Kˇ 0?Á<ÀÂK‘¨Ÿ5DU&t∑VÁ;™7«4Â*Ûˇ ä¯¸Yƒ» –ÏFVlŸ≥fÕõ6lËï?ë˙ÔÊ-¿6Qò4Â4íÓ@x
}•è˝˝/˘	ˇ =3Ÿ˙‰/ît≠=Kn¢]ﬁI–4ÆÁÌJe˚h«˛+e‡ø
Á5Ûø¸·éã®üÀ72XLwKYb˘r˛˛?ü)’œ8~`~Kyü»å[W¥cjƒ_G˛z/˜Í ±∂A≤o˘k˘√Ø˛^‹	tâã[1¨ñ“U¢ˆ∞ˇ Òd|_=µ˘I˘ﬂ¢˛d[°∑’ı≈e¥êék˛\g˝›˘kˇ =3°„'Ç;à⁄ï^7e` ˆe=såy˚˛qC æf-q¶´iWmø( 1˛U≥|?Ú%°œ:˘„˛qgŒY--¥Sµ]˘⁄Ó‘ˇ *›ø{_¯«Íˇ ≠úíÊ÷[YÑhÂCFW V‹bY≥a∂âÂMO]<tÀw∏j“âB‡z‰≤◊˛q˚œW?›Ë˜øœ≈?‰„.H4Ô˘ƒﬂ>^S’µÜÿÚŒüÛ$ Ÿ3—øÁµy®u]Nﬁ‹Bè)ˇ á˙æt_.ˇ ŒyOO£Ír‹ﬂ∏Íƒhÿ¬=O˘-ù_À?ó]Ú∏°t˚{f∂®˝37)O¸HÛf¿˜∫ÖµänÂHcZF
?‡õ ûaˇ úÇÚFÖ»\Íê Î˚ıò◊√˜Eˇ ÇlÂ~hˇ úŸ” óÙÈÆ†{ÜØœÑ~´∑¸y∆|·ˇ 99Á_2Üà]˝B›ø›vÉ”€˛3UÆ?‰Ær…¶ñÊC$¨“JÊ§±%â>˝NtÔ ˇ Œ7yªŒf[ccf‘˝˝’P„_ﬂI˛O¡√¸ºÙ˜Â∑¸‚◊ñ|†RÓ˘J_≠©:èMO¸UmÒ'”/™ﬂÀ«;  
ÄÕõ6lŸ≥fÕú˚Û≥Ûb€Ú„DkÊ£Í÷;HèÌ=?ºa˛˙áÌ…˛∆?€œû˙é£u´›…{xÌ=’√ówmŸôçX˝'=œˇ 8◊˘=˛—æΩ®•5ç@öΩbN±€|ˇ no¯≥·ˇ u.v,Ÿ≥fÕõ6xü˛s7X˙ﬂõ†≤S⁄Y†#¸ßgêˇ ¬zxwˇ 8C§z∫Æ©©ë¥6Ò¬¸es'˝ãÁØsfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕû"ˇ ú ‘Õ◊ú£∂Ø√mgS›öIO‡Îío˘¡˝/ùˆØ®ë˝‹0¬˙ÏÚ7¸ô\ıælŸ≥fÕÖædÚıüòÙÎçROR÷Í3Ø±˝•t?7Ïø≈ü9ø2¸Å{‰=n}¯W”<¢íîD∫ï÷k˘$Êü≥ûÅˇ úG¸ÁûF÷$Òkˇ ≤{Jˇ √¡˛Œ?˜⁄Á™≥fÕõ6l,Û'ñtÔ2ŸI•Î%Õ§£‚Gs)˚HÎ˚.üÁé?8ˇ ÁıO*ô5O-‘4±V(fàî´˝Ùk˛¸è‚˛xˇ o8éì´ﬁh◊I}ßM%µ‘F©$lUÅˇ Ys”_ïˇ ÛôK;D\
yÔÛû‹}Øı‡ˇ ë9ÈØ.yßKÛ-®æ—nbª∑?µC¸Æ>“7˘≈∞”6lŸ∞ãÕ~D—<€’µ€8Æ–lØƒøÒéU§ëˇ ∞uŒ	ÁO˘¬≠>Ë¥ﬁXæ{V;ànG®ü%ï)*ıñl‚kˇ úoÛ∑ó94∂u
ˇ ª-™?‡˜√˝îYŒ.≠&¥ê√rçã’\#Ê≠àÊÕñ:efÕõ6lŸŸˇ *Á5ˇ :æ‘Å”4∂°ı$_ﬁ8ˇ ä!;Ô˛¸ìä/©ûƒÚÂñá‰;O©hV‚2GÔ%oäYå≤ıoı?ª_ÿE…Ny≥Õ∫oîÙ˘u}feÇ÷ª§˛ Føi‰ŸEœ~tŒDjﬂòR5ç©k-Ü?ûtÀˆø„˜I˛[|y»Û¢~X˛EyèÛ	ƒ∫|^ÖÖh◊SUc€Øß˚S?˘1ˇ ≥dœZ˛\Œ2˘[…°.'ãÙñ†ª˙◊ ˛*∑ﬁ4ˇ eÍIˇ g[ A∞≥ô˛cˇ Œ<˘[œ%Æn`˙•˚«ÕΩâÒï?ªó˝g_S˛,œ8˘œ˛pÛÕAitGãTÄt
DR”ﬁ9Oßˇ 3´ú{_Ún≥ÂÁ1ÎWÑøce˝Va≈øÿ·6lŸ≥`≠?Kª‘§X√%ƒß¢DÖ€˛9‘<•ˇ 8ΩÁ_0ïi-üÎ%€p?Ú$sü˛IÁ†?/ˇ Á|ª†≤›kŒ⁄≠ Ô¡áˇ å@ñì˛zI√˛+ŒÌkk§K∫,q 
®Ä*®≤™ª(≈3ceâ&C™P´
Çb3Å˛kŒ%Ë˛bjX„¶Íß“˝C˛†ˇ yœ˘Q|ÒVyÕûO’<•|˙^∑nˆ◊)Ÿ∫0˛x‹|2!˛t¿ZFØw£]≈®i“ºP0h‰CFR?œ˝ñ{üÚÛÚﬂÛ◊Ù~£∆r›jË6Yîª·Úv/ÿ˚K}û√õ6˘£»Zö£ÙµÀ.«@“ ‰?‘î~Ò?ÿ>qè5ˇ ŒywPÂ&áu>ü!Ë≠I£˚üÑﬂÚY≥ëyó˛pˇ Œ:_'”˛Ø®∆:zRp˘?¶ø2>r˝ÚÎÃ^_$j∫u’∏¥Ò7˘OLˇ ¡dw4ø8ÎZM?G_\€Sß•3ß¸AÜJÏ?Á ¸˜c¥Z≈√S˝˘∆O˘<≤a˝Ø¸Âóüaß;∏eßÛ€«ˇ 2’0∆/˘Ã:ß⁄['˘¬ﬂÒ¨´ä–Â˘”˝˜cˇ "_˛´`yˇ Á0ºÔ%xõHÎ¸∞tˇ Éw¬õﬂ˘ _?›
@D?‚∏"âçéFµ?Œè9j@≠Œ±xTı	+ ˇ ÅãÄ»ùÓ°s|˛•‹Ø3ˇ 4åX˝Ìö«NπøêAgœ)Ë±©cˇ µ9—|µˇ 8ﬂÁç|ÜãN{hèÌ›Ï$˝˜¸Yÿ<•ˇ 8H†¨æe‘âÈX≠üÚ^aˇ 23πy/Úg æM‚˙EÑK:ˇ ª§§µÒıe‰…ˇ <¯.MsfÕõ6lŸ≥f¬o8yøOÚéô6µ´»#∂Åj|X˛ƒqØÌI#|(πÛÀÛCÛ&ˇ ÛYóY‘?ÉUä0~◊ﬂˆ§€|ÏﬂÛä?íU∏O:kqˇ °¿’≥çá˜í)ˇ zˇ }¬ﬂ›ˇ <ﬂÒã‚ˆlŸ≥fÕõ6|Ï¸ˇ ÷ˇ L˘„Vπí•¡Ñ|°oˇ 2Û—ˇ ÛÖö/’|±w®∞£]›ï≈cEQˇ Úg°3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûˇ ú©ï§¸¿‘˝ï∑ÂËƒs≤ˇ ŒB£H’eiÆcSÚHˇ âÁ•sfÕõ6lŸ ˇ Á ˇ 'c¸≈—πZ(≈òg∂núøûŸœÚÀ˚…/ŸÁûÁLπ˝∏.≠‰˜WGCˇ ééøÏ[=Áˇ 8˘˘”Ê&ïË^2Æµf†\'NcÏ≠‘c˘_˝Ÿ˛˚ó¸ñè:∆lŸ≥fÕõ9ÊØ¸„OóºÛŒˆÿ~é’ß◊âG?ÚÒ¬Ø˛∫pì˘ô≥…òﬂëﬁfÚ≥Ív∆[ v∫ÇØˇ Y© /ıfT»ßóº—©˘n‰_h◊2⁄\⁄âä‘+vuˇ %˛Ô˛Eˇ ú–’,B€˘¶’oc†§r¸⁄?Ód?Í˙ﬂ|ùˇ 9‰ﬂ5ÖK=B8'o˜MœÓûø =O›πˇ åR>t5`¿2öÉ∏#/6lŸ∞ªYÚﬁô≠ß•™⁄Avù)4j„˛6s›k˛qè»z≠XÈ¬›œÌA#«ˇ “ˇ Ñ»fßˇ 8SÂôâ6W∑∞{1éAˇ &„o¯léﬁŒØ[]hèg∂˛+>…ˇ 8=®˚Ω^}‡aˇ 3-?Áoç9Îè@«˛fÆ/sˇ 8m•Ëõ≠sÃ+´4+ˇ ¡À=2Æh?î~Y™-Ó£Æ\ØÏ[îé*ˇ ï3Fø¸bisükæq”Ê¨:ìmßC¸Ã^‚c˛¥◊%ëÁådTíMO\Í?óÛé>kÛØ“®ÿ6ˇ Xπ1E˝Ïø‰¸>ü¸Yû™¸≤ˇ úkÚœí8]<§5%ﬂ◊ú¯¡Ò≈˛∑«'¸Yùc6yßÃˆW”ß÷ui6ñÎ…ÿı? à?i›æ_⁄l˘ˇ ˘≈˘¡©~dÍfÍ‰ò¨!$[[≤/ÛøÛÃˇ Ó«ˇ bøA ÇKâTºéB™®©$Ï™™:±œV˛Iˇ Œ&G«≠y·9»h—ÿ◊e7d}¶ˇ ä·ˇ ~Ú˛Ô=?oo¥k±ƒÄ*™Ä—UF¿bô≥fÕçí%ïJH)ÿÇ*Eu _)j‰µÓìg#¨!Uo¯4
˘ºˇ ú_Ú—ØËﬂLˇ ≈sLøá´Lˇ Bô‰/˘dõ˛í$ˇ ö±{o˘≈_ Byì˝{âø„Y$:g‰Wít“ﬂGµ$t2'´ˇ '˝Lòÿivöt~çî1¡˝ò– ˇ Å@0NlŸ≥fÕë_ÃoÀMœ˙siöÃU•LS-ë7Ûƒˇ Ò$˚˚y‡oÕ/ ˝OÚÎUm/R„j¥®¢JüÃø Î˛Ïèˆ¸û—›]º–o°’tŸ7vÓ7^ƒ~µo≤À˚K∂}¸£¸ ∂¸√–a÷`¢O˝›ƒ@ˇ w*èç‘oÔ#ˇ äŸk&y≥fÕòäÏr=≠~]˘s[ØÈ=6“·èÌ<([˛è?¯lÑÍøÛãûB‘*√O01Ô“/¸)vO¯LäÍÛÖûTò÷÷Ó˙·Œ7—rˇ Ü¬+Ø˘¡€Ø’ıâW√ú
ﬂÒ#¬ŸÁÁØÓµ§#¸´b?Ê~3˛ÑrÔ˛Ø1ˇ “1ˇ ™ÿ"˘¡∂€◊÷áø_Î>ZŒi	˛ıj∑2©'¸HÀí-7˛pÁ…v¥7Ú‰˜ı&
?‰åqƒ≤c£ˇ Œ?yI°∑“-›áyπMˇ Q&N4Ì&œMOJ¬≠„˛XëP¿†\õ6lŸ≥fÕõ6lÿY÷lÙK9u-JUÇ÷/$éh ÁØÌ7¬π‡oœ_Œ´ØÃùJëráH∂b-°=Oo^o¯µˇ ‰í|˚l‚ $n?1µ/^4z%´<Éng®∂âøùˇ ›ç˛Íè¸∂è=ÌccÑ⁄Z"≈*EUGU
1lŸ≥fÕõ6l˘°˘ó§O£˘õS±∫Ø´‹’'∏.]˝ö2æz◊˛p˚ŒvzüïŒÄúR˜MëÀØwIY•Iø‡ô¢oÂ‡øŒπﬁ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûˇ úµ≤˙∑ü.d•=x ìÓA¸ Œùˇ 8;~€X≤'uíﬁ@?÷°ˇ ìkû°Õõ6lŸ≥fœ0ˇ ŒU˛E’ìŒ⁄uùo°Aˆî«“/Û†˛ˇ ˘ì˜ø≥'/1˘?Õ⁄áîu8u≠"ONÊ®a˚q»øµã∫Á–ü øÃ˝;ÛHMWO!&Z-ƒ’¢íõ©ÒF˚QI˚k˛W5YélŸ≥fÕõ$k"îpXPÇ*=éqÔ?ˇ Œ,yOÕEÆl„:]„oŒÿLüÚÌèÓˇ ‰W£ûuÛ∑¸‚áõ¸ª [”T∂µnyOÚ≠ﬂ˜ïˇ å^∂rÌ>ÁOï≠Ø"x&_¥í)V5z6˘gÛ+Ã~W#Ù6£qlÉˆ…O˘¸¢ˇ ÑŒ´Âˇ ˘Ãü7iÙMJ+[ÙK!çˇ ‡°+¸íŒá£ŒoirÄ5].‚‹√"»>È>Øì=7˛r€»óîın'∂'¥∞?¸…ıÜH≠?Á ºãt+±n?◊‰üÚqS£¸‚ÚtügZ∞ˇ §à«¸mäÀ˘±Â©œY∞ˇ óòøÊºq˘ﬂ‰®>ﬁ≥d’ï[˛!À	oˇ Á&¸Éf7‘ƒá¬8•o’«"∫Ø¸Êoî-Apﬁ]7jF®ø|íˇ Ñ»>∑ˇ 9øvı]Ié?∏îø¸ìâbˇ ìôÕº≈ˇ 9CÁ≠h¢Œ3˚6®˛Js…\Êz¶≥{´Jn5ânf?∑+≥∑¸ñ√-y#[Û<ûéâe=€VÑ∆Ñ®ˇ ^OÓ”˝õgoÚW¸·éπ®qõÃó1ÈÒÃq˛ˆ_ñ‘Ö?‰døÍÁ°<á˘Â/%Òñ –OvøÒÒsI$Øärú_Û 4Œãõ6lﬂ¸ÂÁ˘√XmNí∫FúÂ~¥≥ÜIø H˜éˆrª3âE ‚8¡gb®$ûÄˆ◊¸„Ø¸„‘>MÇ=^åI≠ µD`∂S˚+ˇ /˝Ÿ'Ïvü∂œ›ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6C?6-,ˇ 0Ù9tã†p€ÃFÒ ¿ﬂÍ7ÿïi? „ü:µ}&ÁGºõMæCÕ¥çàzÜS≈Üv˘ƒˇ ÃÚ◊öWIùÈe´–J7∂ônPˇ œ_Ús‹˘≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕÄµ≠jœC≥óR‘Â[{H¥í9†¸˛ ˝¶oÖs¬øü?üwò◊_R≤Âo°¿’ä#≥H√˝ﬂ?˘_Ô∏ˇ ›ÎÁ"œgŒJÌÂã‰f%V˘ÇÇvé#∂z6lŸ≥fÕõ6yá˛rˇ ÚâØ"w““≤B¢;’QπA¥W?ÛÀ˚π‚øMæÃmûm¸ΩÛ›ˇ ëuà5Õ0˛Ú#GB~ˇ yü‰ø¸+q¥πÙG»ûw”ºÌ§√≠È/ áƒßÌ#è∑Éˆ]?Êı¯pˇ 6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕû4ˇ úÿ”Ω/2XﬁÅ¥÷\	˜I$˛Æ)ˇ 8K®˙^`‘lI˛˙–IOx‰Uˇ ôŸÏ|Ÿ≥fÕõ6lƒ;Éû-ˇ úñˇ úo*Œ˛gÚ¸u“&jÕè˜ùÿı˛Y§o≥˛˙›˝üO9OÂßÊNß˘}´&Ø•5GŸö~	cØ≈ˇ ∆è˛Îoã>Ä˛]˛bi~~“”W“™~#o∑˛‘RØèÚ∑Ÿu¯ó$˘≥fÕõ6lŸ∞´_Ú¶ìÊ(Ωb“∏˚	£Vß˙•ÖW˝ér_3Œ!y7V-%ÄüNêÔ˚ô9%„˛ß¸#¶r˝˛pìWÑ≥h⁄ïΩ¬ˆY—¢?z}a‚9œıè˘∆>iÑü—ˇ XA˚PKˇ ¬rY?·2!®˛Yy£M$^iW±Sπ∑íü\x·≈Ö≈±§Ò<g¡îè◊ÅÛcïÕ}∞ À ⁄µÒ••ïƒƒˇ æ‚vˇ àÆIÙœ»Ø;jt˙æètËdOH}Û˙y6—Á|Î~Aª∂Jz˙≤Ú?6Î7¸K:'óˇ Ám#£Îö§í¯•¥a?‰§¶_˘5ùOÀÛéHÚÒúó2ØÌ›1ˇ Äì˜?1gH∂∂ä÷1∫,q®†U  =ïqLŸ≥fŒQˇ 9˘≠o‰è/œmo8]bˆ3≤ÒÄﬂó}ÅrÙŸø›øÏ≥¿YÈ˘ƒ D‘Ó[Œö¢rÇ’Ãvä√fî}πˇ ÁèŸè˛-¯æ‘YÎ‹Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6x√˛s3…©•˘Ü€^Åx¶ßS˝˚fˇ e√ˇ ú∆ˆ[àÓÌœauëÉ)‰ß˛>å˛X~lhﬂòvÔKîÑQÎ€∂“F«˘óˆ£Øÿë~ˇ [·…¶lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÿGÁ/:i^N”ﬂV÷ÊX-”•wgn—ƒùdëøó˛5œ
~t~yÍô7|∂⁄LMXmÅˇ í≥ü˜dﬂë˝î˝ßpìˇ ìzßÊV°ı{Pa”·#Î$|(?ë?ﬂì∑ÏG˛…¯¶#˘·Â;/)y∂˜D“—í“ÿB1©ﬁùôõπwflÙg¸·$µÚˆ£Úﬁ˜∆üÛNz76lŸ≥fÕõ62x#∏ç°ôC∆‡´+
Ç£+)Íß<!ˇ 9˘/Âˆ¢u9Khwn}&ÎËπ¯ç¥á˛L∑Ìß√ˆ—∞ìÚKÛí˜Ú◊Tıá)tÀÇÍ zé“«·4≥¸ˇ ›∑Û/ø¥vÀ_±áT”%YÌ.<nΩ?Ò_≤ ~%oÖ∞~lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕû]ˇ ú‚”y[Ë˙ÄeÁàüıÑnøÚmÛòˇ Œ%ÍBœœv—AsÒ¬zﬂÛ'=·õ6lŸ≥fÕõª¥äÚ∂πEíT££
´)ee=UÜx˛r˛qˆ"‹6µ£#I°L›I∑c˛Íì˛*c˝‘øÛŒOèãIœ-?35_À›Qu]%Í¶ã4,O	S˘$ÚnOµ≤V˜◊ÂØÊvì˘Ö¶Æß§?ƒ(&ÖèÔ"‰ë|?íO±'¸KsfÕõ6lŸ≥fÕõ65„Y‚∏ÙK˚vö¯∆ß¯bq˘oLãxÌ Z¯DÉ˛5¡PÈˆˇ u'˙™Í≈ÛfÕõ6lŸ≥g¸Ôˇ úà”/¢m>¿≠ﬁ∏√·Ñ¨UÈ%…_¯XºÚ„œyìÃ∫áôoÂ’µyö‚ÓsVv¸GEE˚(ãÆµ∂íÍT∑ÑríF†w,x®˚ÛÈóë|´ï4K=‹ê™?i©Ydˇ ûísˆX{õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ:ˇ ŒmZ£ysO∏?m/xìG!o˘6π„\0–|¡Â˚»ı-&w∂∫à’då–èoÚî˛“7¬ﬂµû¥¸•ˇ úº±’Biæsgw≤ã•π¯ øÒÓﬂÂsˇ ≥—ñ˜1\∆≥¿Î$N+)H=Yv#Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥g7¸‹¸ı—?. 1‹0π’k§g‚ﬂÏºÕ˛Èã¸¶¯õ˝÷çû¸ƒ¸À÷|ˇ ®KZóï*"âvé%˛Hì˛$ˇ mˇ m≤c˘#ˇ 8˚©~bÃ/nπZhàﬂ‰|RS¨V¡æ”4ø›«˛[¸Ó_,y_NÚΩÑZNè
€⁄B(®øŒÌˆù€ˆ›æ&œŒW[˙^~Ωo˜‰vÌˇ $ë„\ÎÛÉ˜¥›^
˝ô·j¨Æ?„LÙ÷lŸ≥fÕõ6lÿ]Ê/.ÿ˘é¬m'TàMip•áà˛WSÒ#˛À|YÛ˜Û£ÚäÛÚ◊W˙î§Àc=^÷oÊ@wGˇ ã¢¯}Oˆ/˚y”Á3§”5WÚ}Î÷“˚îñı?beôW¸ô„_˘;g±≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕú#˛s+L˙◊ì£∫{k»öæÃ≤D·ù3À_ë˙üËﬂ:Ë˜–}n8…ˆê˙˛Ng—ÃŸ≥fÕõ6lŸ±À8oa{[§YaïJ∫8YNÃ¨ß®9‚œ˘»˘∆È¸úÚk˛]FõEc H≈YÌÎ¸›ﬁﬂ˘dˇ u˝ôﬂç»¸ìÁçW…zäj⁄$∆”b:´ØÌG*~‹mˇ 7/¯≥›ìüû˙GÊE∏âµ’—k-´Õ>‘ê7˚∂/¯xˇ o˘õ¶ÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥b◊ˆ˙|wy"C@≥»ÏT⁄fmó<Ø˘œˇ 9neh˛F%Wu{‚(O¸¬#}ü¯Œˇ ˚Ì˚ÃÛq‹Íw!=≈‘Ô∞wwcÙªª6ÛGïÔ¸Ø~˙N≠•y£:Tº—eUbªr‡ÎÀˇ %tÙøÛûèo ™˝r&#˝Fı?„L˙?õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûiˇ úﬁ‘ƒzNóß◊‚ñ‚IiÌpˇ ô˘‰ı¥ˇ Ûäzwö|ß•ﬂÈl,5£c»MLR≥"πıóÌG'≈˝ÏÏ„|ÛWù<Å≠y.Ïÿk÷œo&¸Xä£Å˚QJøã˛Ø˚,:¸∏¸ÍÛ'ê$I∏/iZµ¨’xèçµçøÀâë≥’óÛñZÛ8K]`˛âæ4î÷?‰\l˛{,Î6v∏fI—eâÉ∆¬™ j=¡¸Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥`M[W≥—Ìû˚Qö;{hÖ^I*Å˛≥gó?7øÁ/⁄Q&ó‰pUwVæëw?Û}ü¯À/≈¸±/€œ1\\\Íw&iŸÓ.ßjñb]›ò¯ÓŒÃs“øíÛâ≤ﬁıØ;°äö;éﬁËèÓ”˛)_ﬁø=?∞ﬁ±¥¥ÜŒ$∂∂Eä‘*" ™†tUUŸTbπ·Ô˘ÃkOGŒ´%?æ≥Ö˛Êí?¯”&?ÛÉóîüYµ'Ì%≥ÅÚ3)ˇ âÁ¨3fÕõ6lŸ≥fÕúõ˛r{…+Êo&›Jã[≠;˝.#MËüﬂØ˚(9ˇ ≤Dœ
yZõC‘mµ[SI≠fIìÊå¯g”Ω/QãS¥Ü˛‹÷+à“T?‰∏øÉ`úŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕú◊˛rCK˝#‰=V:T«L?Áúâ)ˇ ÖVœhöÅ”Ø≠Ôó¨G ˇ `¡ˇ Ü}EäEïD5V ÉÏqŸ≥fÕõ6lŸ≥eI»•V Ó=éyOÛﬂ˛qT©ì_ÚDU]⁄kÌ‚ˆüˆOˇ "ﬂYÊ+;€Ω&Ènm]ÌÓ‡z´©*Ë√ﬂÌ+ıó‰ø¸Â•æ†#—¸ÏÀŒ ó†R7˙ èÓ_˛-_‹ˇ 7•ûñäTôHÿ20XÇB;6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥g+¸—ˇ úåÚﬂê√⁄˙ü^‘÷†[@A‚‚˘wH’¯•ˇ äÛ«ôﬂù>`¸√ö∫§ﬁùöö«kV%,?›≤≈írˇ 'Ü˛^~WÎû~ºZ$’Hı&m¢åxÀ'¸hº§oŸLˆ«‰˜‰ã˘sπP.ıfZ=”è≥_¥ñÈ˛ÈO˘(ˇ ¥ˇ ≥ûXˇ ú´≥6˛~æb6ï qˇ "ë?‚Ië_…ùEtÔ8Ë˜2 ºÖI¬?¯ﬂ>êÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gàÁ0ºÿ∫øõKÖπG¶@±µ?ﬂí~˙O¯OE÷\„ë.≥®[iñ‚≤›M+Ûv?‚YÙ˛ —,‡é÷!H‚EE 8Æ◊¸πßyÜ—¥˝^ﬁ;´gÍí(a˛∞˛V˛W_ã<œ˘ïˇ 8gR˜æJûù˛©pﬂÑ7Ò¨ˇ Ú;<◊Êo(ÍﬁWπ6Z›¨∂ìèŸëh∫?ÿë Fe√è#˛myó….â{$P÷¶¯‚?8_í≤N/˛Vz…Ûö∂≥ÉÕvMÙ3⁄¸KÛh$<”˝Ñíˇ ´ù„ _ôﬁ[ÛrÉ¢_√p‰W”∆A˛¥qî¿dü6lŸ≥fÕõ6lŸ≥fÕà__€ÿB◊Wí§0 ´<å@ˇ )€·¡2?Á/Ù=ïßñSÙ•ÿ€‘5Xˇ ≠˝‰ﬂÛœä≈ŸÂo>~gÎ˛{∏˙Œªt“™ö§KƒüÒé¯Ÿˇ y¸œÇ.(¸¡˘ÅqËË÷Á–SI.$™ƒüÎI˚Mˇ «ŒOÚsŸüîÛèÂÍ≠€}´”{ôÏüh˛/K˝ä_Ú¯¸9’sfœˇ Œnÿ÷ÙÀ {jÒ◊˝GÂˇ 3∞¸·V†!ÛEÂ°ˇ wY14í/¯’õ=°õ6lŸ≥fÕõ6lFˆŒ;ÿ$µúräTda‚¨8∞˚≥Âˆ∑¶>ï}qß…ˆÌ¶í&˘£?Ò˜Ô¸„é∏uè"ir±´√[∑¸Úfâ?‰ö¶t¨Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕÑûy“ˇ Kh:éüJ˝b“x¿˜deÛ>ó˛YÍø•º±•ﬂV¶k8ˇ ≠¡yˇ √dó6lŸ≥fÕõ6lŸ≥é~sˇ Œ7i>~©i¸lu£ø™¡)πE˝Ø¯π?y¸ﬁßŸœyè@∫Úˆ£q§jVÍ÷Fé@¨r^¥e…˜ÂG¸‰ò?/Ym£oÆiu¯≠e&ÄÀºõ¥ˇ ÛGû∆¸¥¸ÓÚÁÊat…˝+⁄UÌf¢ <x≥2ó/Ú∏‰˚6lŸ≥fÕõ6lŸ≥fÕõ6lÊ?ò?Ûë^SÚ_8&π˙ÂÚÌı{j;·$ïÙ¢ˇ d¸ˇ »œ.~eŒQyõŒÌ,õÙ^û’úy∞ˇ ãn>?Í«È'Û+g&”ÙÎ≠R·-,b{ãôM8‘≥1ˇ %W‚9È? ü˘√Àã≤öèùú¡Ã,‚oﬁ7¸gô~ø‘ãîüÂ∆ŸÍç@∞–-N“†é⁄÷!Eé5†ˇ Â1˝¶oâ∞~y˛sgÀ´ßÎËøª∏Ö≠‹ˇ ïzâ_ıío˘'ûm∑ùÌ‰Y¢%dF§v ‘˙W˘oÁK:hzÌ±ÈèQGÏ»>£ˇ a'/ˆ?IsfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÜ˛k˛eŸ~^ËíÍ˜Ñ4‰∑ÜªÀ)®øjV˝Ñˇ +é|Ë’µKçZÓmFıÃó74≤1ÓÃy1˚ÛµŒ"yµÔ3ùne≠¶îæ•OC3Çê/˚ﬁKˇ <”=øõ6Îû_”ıÎf≤’≠‚∫∑n©*?ã£ïúœÛÜz.§Z„À7ßLwIYaØÇí}hˇ ‡•ˇ S<˚ÁO˘«ø8˘KîóV-qløÓÎ_ﬁ•<X'Ôcˇ ûë¶s•gÖÍ§´©Í6 åË~Tˇ úÉÛßñx•Æ£$–ÆﬁïœÔñûΩÂ"ı3Æ˘k˛sv·(ö˛ñØ„%¨Ö‰å‹ˇ ‰ˆu//ˇ ŒV˘W¢Àu%îáˆn"aˇ %"ıbˇ áŒã¢˘ﬂC◊ :]˝µ’{E21ˇ ÅVÂáY≥fÕõ6lÿŸ%HîºÑ*ç…&Äg>Û_¸‰í¸±…nı¶ô›Vﬂæj¯~Îí!ˇ åéô√¸Èˇ 9Øq(h<´`"˜Gì|÷œˇ e,üÍÁÛáÊ&øÁΩ}zˆ[ùÍ®∆àøÍBúbOˆ)ï‰ÔÀÌwŒWU–l‰π`hÃ¢àøÒíf„Ïõ==˘eˇ 8qcßæÛå¬ÚqCıhIˇ ……7˙´È'¸dœFi⁄m∂õYÿƒê[ƒ8§q®UQ‡™ªõ6lÛ7¸Ê˛óÍiöV¢˜SÀ?ÒëU«¸òŒ=ˇ 8≥™ç?œ∂
∆ãp≥BŸFÏøËπÔ¨Ÿ≥fÕõ6lŸ≥fœùü⁄`”|Û¨@\ô‰hYˇ ÊfzW˛pªS7Sπ¥n∂˜ØOì§Mˇ Áùˇ 6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕòääôÛÕ⁄Y“uãÌ8ä}ZÊh©˛£≤˜G¸‚Ó≠˙G»Zx&≠neÑˇ ±ë¯ˇ …6LÍŸ≥fÕõ6lŸ≥fÕÄıùR-" „Qπ4Ü⁄'ïœ˘(•€\˘á¨Íìj◊≥Í7&≥\ Úπˇ )ÿª~-ùVˇ ˛qãÃ£À÷~e“‘^≠Ã<ñË)4a«5‡üÓÒÈÒoÉ˜üÒWÌg%{	Í9√q{´+¯eeŒÂ˘qˇ 9sÊ.¥◊◊Ù≠ò†‰«åÍ?„7IÁ≤Ûˇ ãs”~B¸˜ÚßùÇ«ß^,Wmˇ ˜éJ¯*±·/¸Òy3†fÕõ6lŸ≥fÕõ6l Û?üÙ+!ì[æÇ◊øqÃˇ ´¨Ø˛≈3ày”˛sGF±ñ≠$æó¥≥~Í/ò_ägˇ d∞Áü|ı˘˚ÊÔ9Úä˛Ò°¥o¯˜∂˝‹tn?ºó˛z»˘”tª≠Ru¥∞ÜKãá4X„RÃ~JüwœÀü˘√ÕkX·wÊâFõjwÙñè;˘5˚.oˇ g®¸á˘[Âˇ "¡ËhV´ëGôæ)_˝yõ‚ˇ `ºc˛T…^lŸ¸Ô¸∫~ÚÕŒï\JMlOiRºVøÒjÛá˛zrœùóÚ[HN•%çä≤∞°Xve9‘?"ø<Óˇ -/ïÆ4{ñhA¯ï∫zW·ı8˝•˚2Ø√˚(ÀÓ/'yÎFÛç†ø–ÆíÊ" ß„BfXè«Æ∏}õ6l¶`†≥π'9ﬂú?Á ºôÂR—ﬁj	5¬ˇ ∫≠øz’>üÓ–ˇ ∆I8ˇ òˇ Á7¢RSA“Ÿái.dß¸ëáó¸ûŒw¨Œ^y‚¸ü´Iofß¥0ÉO¶‡œëˇ œü<_e÷.ÖﬂoÈˇ …ë‹~byí‰÷mRıˇ ÷πîˇ ∆¯O5ÍÚΩÌÀyúˇ ∆ÿ¥x◊≠Ëa‘où8‹H?S·ÂáÁoù,iËÎ7îûVq˜Kœ%:_¸Âü,h$ªä‰”@üÒ(ñ&ˇ Ü…ûëˇ 9π¨≈A©Èñ”éÊ'xè¸?÷2s£Œkyr‚ã©X›€›8J£ÈÂˇ ¬dÎFˇ úïÚ´@öö@«ˆgGéüÏù=?¯|öÈ^t—5`ùkpOJdo¯ãa»5ÈõÍzÕñóõP∏äﬁ1πi]P¡9\„üòÛñ~WÚÏoå«VΩ°
"⁄ À∏aÒ/¸aY?ÿÁê01u>Í'T÷ÂÊˇ f8◊h„_˜‹I˚#˛ˇ mõ	Ù-Û^æáK”ciÆÓ$hΩI?©G⁄f˝ï¯õ>à˛Q~[[˛^hË–êÛˇ yq(nV®ø›«ˇ ¢˛÷M3fÕõ6Dº€˘OÂ6Çuù:	•o˜h^»Ë∏Kˇ úkÕ?ÛÖE◊)4˘≠Ùéuß»2˙R/˚/S9/ô?Á|Ì§U≠"áPåw∑êß¸cü—o¯yÃµﬂ$kö+´X\⁄”º±2è°ÿq8J	£cí#ÛÃz=?GjwpŸ'p?‡9q…éôˇ 95ÁÌ>Åu6ïGibçˇ ·ö>Ÿ&∞ˇ úÀÛïΩÒYN? âîˇ …9S˛#á∂øÛõ⁄¬ˇ Ω:]≥ˇ ©#Ø¸K’√H?Á9˚ªEÏnø¨+˛áé◊˛¨≤“Hˇ ™8Á˛sêˇ «æãˇ uˇ 4¡ÑZá¸Ê◊ò%Yiˆp˚πíO‘‰;Zˇ ú®ÛÊ¶
•ÍZ°ÌHøÓ$ì˛9ÓΩÁMkÃÀWæ∏ªˆñVaÙ+#lt˚õ˘EΩúO<Õ—#RÃ~JïlÍ˛Nˇ úYÛßòä…=∫È÷ÁˆÓèß¥Œo¯4LÔûEˇ ú?ÚŒÜV„\w’n˝‹ ˇ ∆$<ﬂ˛zJÀ˛Fw7Kµ“‡[Kc∑∑AEé5
£˝UOáÊÕõ6l„üÛñZ)‘ºãs2äµú–Œ?‡Ωˇ Ñô≥≈ˇ ó∫ÁË0È⁄°4[k®dc˛HuÁˇ 	À>ôÉ]∆lŸ≥fÕõ6lŸ≥gÑ?Á-¨≈øü.dû¥?¸ è˛eÁNˇ úºÂm¨⁄ìˆd∑p?÷©ˇ àg®sfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ>zŒFÈ?¢¸˜™≈J,í¨√ﬂ’Dòˇ √;g†Á	ıo_À∑˙q56˜|¿¢ˇ ∆–æz+6lŸ≥fÕõ6lŸ≥ëŒTyüÙí.¢F§∑Óñ´ÚcÍKˇ $cëŸgá¸°†?òuã=/µw<pÌÿ;fˇ bø}9∂∂é÷$∑Ñqé5
†v qQêoÃ…-y˘jñ‚; Qn°¢J<958 ø‰ Øû\¸√ˇ úIÛ/óK‹Ëî’¨∆„”f¸®€ˇ û.ˇ Í.q´I¨Âh.Q¢ô` V¯ó'˛Kˇ úÅÛèîB≈e|Û€/˚¶Á˜©OÂ^ºå∆);ï?Á6Ìd§~c”^&Ô%´Ú&nøÚ9Û¨˘{˛r'»˙ËN($?±sXHˇ e0Xˇ ‡_'÷•¶¢û≠î—ŒüÕÜzÇsfÕõ∫ΩÇ—y‹»ë/ã∞Qˇ ëM_Ûã…˙E~π´Ÿ©UeWo¯πø·ê=s˛r˚…:uE£‹ﬂ0ÈËƒT¡\‚9Õº≈ˇ 9ª{%SC“„ã¡Ód.‰\^è¸úlÂ>hˇ úáÛ∑ò˘%∆•$∑˚Æ⁄êäxrãå≠˛ŒFŒw4“NÊYXª±©f5$˚ììo'~HyªÕ≈[L”Â7˚∫aÈGO$ºyˇ œ>yﬁ¸èˇ 8Ukè5ﬁôõ©Ç◊·_ìO ı©_ÎÁ†|ß‰= 0}[B≥ä—£_âø„$≠Ydˇ f¯}õ6lŸ≥ÕﬂÛí?ÛéRyÜI<’Âh˘jVÊŸ›‘ˇ wCˇ ˇ :ªæ“˛˜˚ﬂÕ¬Ì™RD%YXPÇ:´–‡ù+Xº“'[Ω:y-ß^íDÂ≤Bu˛rßœZJàﬁÒ.–t+¶DÙÂoˆOíªo˘Õè3 §÷6.|@ïÊkcnøÁ5¸–‡à,¨c=âY[˛g.Fµo˘À=ﬂÇ±›Ej˚Êˇ âJ%o«9ˇ ò0º√Ê:ç_Qπ∫S˚J≈?‰]}?¯\èf…â˘{Ê-ráK”nÓÙh·rø|x√dœMˇ úbÛı®”LJ{À,Iˇ 
dÁˇ Öòﬂí˙ˇ ÂÌΩΩ÷º±"›3"‰Êj†3r†ßÌd;Vóˇ 8óÊÌSO∑’,‰≥xn°IëL¨+®ë9rãè.-¸ÿ_®ˇ Œ,y˙»[ú˜‘—¯Vto¯\âjﬂîûm“jotõƒQ’Ñ.Àˇ d»¥ˆ“€±éddq‘0 ˝«Õõ-<≈©YäZ›Oˇ "F_¯ã`π<ÒØH8æ£xÀ‡gêˇ ∆¯Squ-ÀzìªH˛,I?yƒ≤G‰èÀ›oŒ◊b«B∂yﬁ£õÙç˝©e?¯f˝ÖlˆÔ‰è‰&ù˘mπêã≠be§∑ŸG˚Ê‹÷?Ê∑/Ìq˚’3fÕõ6lŸ≥e2áXT†‰_Z¸´Ú∂∑S®ÈVí±ÍﬁäÜˇ ëàˇ ·≤´Œ'y¸ì¨∂§ˇ æg¯å∆e»Ü£ˇ 8G°…Sc©]C·Í*Iˇ df˚˛pzıkı=b'ΩH‚2KÑwÛÖ~kè˚ãª	>o"ˇ ÃìÖìŒ˘ﬁ?≤-˝Yˇ Ê¥\ˇ BèÁø˘gÉ˛G¶/¸·˜û$˚ki˙”ˇ Õ¯waˇ 8OÊIho/Ï°¯zé‰‹_Ò,ñÈÛÉˆIC™j“…‚∞B©ˇ #Õˇ ŒÉ†Œ*˘H!‰¥{◊µs+7¸ìè“ã˛:fâÂΩ3Bã–“ma¥èßcTO 0«6lŸ≥fÕõº˘ÂÒÊ-ˇ G•M’¥±Ø˙≈O¶ÿø˘îËQä∞£Bé}%¸§Û0Û7ïtÕVºû[t¯±•7¸ïG…nlŸ≥fÕõ6lŸ≥ƒøÛô–Ûî/¸ˆ∫Ió$üÛÉ≥R˚Xã˘¢∑oπ•Ò∂z€6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ<Uˇ 9ü£˝WÕv˜ >ª4©ˇ *6to¯OOÁıèGX‘Ù≤ø∂IÄ˜â¯ÿ∆{6lŸ≥fÕõ6lŸ≥…?ÛõûfıotÕ6⁄ﬁÊAÓÁ“äøÍ¨Rˇ ¡‰;˛qÀ?•ºÊ∑Œ+ùì˚ro‹Gˇ 'Yˇ ÿgπÛf»Áõˇ .|øÁ˝-v £Je§ã˛§…∆Tˇ b˘¬|·ˇ 8Qß‹õÀWÔl«q»ı‰%N ˇ Y%Œ1Êè˘∆_<h∑‘M‰CˆÌI_˘Âœˇ $≥öÍUﬁõ!Ç˙-ÂVT(ﬂ.‚v◊sZ∑©o#F˛(≈Oﬁπ%”ˇ 5¸ŸßäZÍ˜»æXêè¯jaÃ?Ûêæ{ÑQuyœ˙¡˛&çä˘»ø>ü˙[Õˇ ˝S¿óüxüÌÎ7bø ¸‚pö˚Û'Ã◊’˙÷´{ =ö‚B>ÓxCsy5”sûFëºYâ?ÿö#9
†ñ= …Fâ˘WÊùrü£¥ªπTÙoIï‰cÖè˛:7óøÁ<È©—ØÖΩÇæ¨ºõ˛ﬂ’ˇ âÆu/,ŒËˆ‹d◊u	ÓÿuHTDø.MÎHﬂÚO:ˇ ï?&¸ßÂ^-•i∞$´“W_RO˘7®Î˛«&y≥fÕõ6lŸ≥ú~f~A˘kœı∏æÑ€Ímuœ¸ebo˘Ëºˇ ï◊<ﬂÊˇ ˘√è4il“hí√©¿+@äZ{«)Ùø‡gŒ_´˛R˘≥H$^È7àÌYó˛FF?·≤-<@Ê)î§ähUÖ>‡Â⁄⁄Mw ÇŸY[¢†,«‰´æJ4œ _6ÍfñöEÎè®ˇ ÉuU…ŒÉˇ 8óÁçPÉq6({œ*◊˛]Û´˘K˛p£M∂+/òÔ‰∫#s∫˙kÚ2?©#ıV,Ì>W¸§ÚØï¿˝¶€ƒÎ˛Ï)ŒO˘/9·≤\3gôøÁ8˛å“[∞ûa˜¢Áë3ÈwÂÑÇO*ÈªÉakˇ &ì$Ÿ∞&°£ŸjKÈﬂA¬xJä„Ópr¨˛@yW©∏“-—õº ¬È›£».±ˇ 8iÂ∫õ)o-∞Y◊Óïˇ ‰¶rˇ Ãﬂ˘ƒsÂ-Ô_≤‘ÕƒvâÍû,E@oﬁ,å>¯æ∆y◊:OÂè‰Ω˘çg&££Ilê√)ÖΩi[êU≤ë…Ò|ÈZ_¸·µ!§u;XWø§è!ˇ áÙ3•yO˛pÔ öK,⁄´œ©»7„#zqˇ »∏~?¯)õ;Vè¢XË∂Àe¶Aµ≤}ò‚Pä?ÿÆÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕü;ˇ ?¸û|´Á-BÕWåIıò|8M˚œáŸ$Á˚Óˇ ÛÖ~w[ãœ*ŒﬂΩ∂¨¿xﬁâ2Ø¸cóãœlÙŒlŸ≥fÕõ6lŸ≥≈ﬂÛöøÚïŸˇ Ã…Ÿ”˛pÉ˛:⁄Ø¸√≈ˇ 9Î‹Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ<«ˇ 9ø£zñN™˜SK¯»´"…áŒEˇ 8≥¨˛åÛÂä±¢],∞ˆHŒüÚR4œ|ÊÕõ6lŸ≥fÕõ6|Ùˇ úäÛÈˇ <js©¨pH-ìÂ7¸ïY;◊¸·?ñ˛≠£j„ä5‹Î
Úa^Fü7ü˛=#õ6lŸ∞=ˆõk®GËﬁ√ÒüŸëC¯ÆBµo»o$j§µŒël	ÍbS˝Cò≤)}ˇ 8ã‰[íLP‹Aˇ Ácˇ 'Ω\'õ˛p≥ Nk›˙R#ˇ 21?˙è*ˇ Àmˇ ¸_ıC[ˇ Œ˘6?Ô%æìÁ*¯å+ÜˆÛâæB∑°{IfßÛœ'¸ÀhÚGß˛By¬Ü‘”˝¯¶O˘>d…nôÂΩ3J”Ì ∂˝ı'¸AWsfÕõ6lŸ≥fÕõ6lŸ≥ÁÁT˛∑ù5óˇ óÈ◊˛ä∆π+ˇ úOá‘Ûıì$Wˇ $ù?„l˜¶lŸ≥fœ5Œoˇ «#Jˇ òô?‚<ÅüJ)Â—øÊ€˛M¶JÛfÕõ#øò˙h’<µ™YS5úÍπç∏ˇ √gÃ‹ıó¸‡Ó• €X∞'Ï<Å˛∞ë˛MÆzã6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥Œˇ Ûòøó-¨h˘¢Õ9\iµI®709˚_Û¬_ã˝I%oŸœ,~]y‚Î…ÂÆΩgª[ø∆ùû6¯eàˇ Æü-≈ˇ g>êËZ’Æπc©`˛•µÃk,m‚¨9ˆ_Ã0vlŸ≥fÕõ6lŸ‚œ˘ÕGÕñä:ã¸eüˇ ÁùWVn¬ﬁ!˜ªgØ3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ9¸Ânâ˙O»ór®´Y…¿˙“˘'3Áâ¸â≠˛Ç◊Ù˝R¥◊P»~JÍ_˛>õÉ]«LŸ≥fÕõ6lŸ≥`-sUèH∞π‘¶˛Ó⁄&oí)sˇ œó˜◊í^‹Iu9¨≥;;«ì~9Ù;ÚÀø†<ì•Z≈ﬁ;¯Úòõç˛^ßüÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ÊwÊD˛øôµiö˙‰ˇ …WŒõˇ 8{©ÁpﬂÔªIõ˛ üÒ∂{ì6lŸ≥göøÁ7ˇ „ë•ÃLüÒû@œ•?îøÚàËﬂÛmˇ &”%y≥fÕåûû6â˛ÀÇß‰E3Â∂°jm.%∂n±;!ˇ bxÁ°Á	o˝?0j6dˇ {fûÈ"/¸ÕœcÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6%yi‰2Z‹†íT££
ÜVYXx2ÁŒ/ÕÔ!?ë<…w¢n`FÁ⁄â˛(æeGÓﬂ˛,FœIŒyÍU◊ïÆZ≤X7≠ﬂRﬁ(ˇ ås¸_Ûﬂ=!õ6lŸ≥fÕõ6x˛s"„’Û™•ª≤Ö~ˆïˇ „lóˇ Œ[÷„Yûõ∂Z¸Ã«˛5œXÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõº˚°@‘4öT›ZÀˇ ¨»‹?·¯ÁÃí4;üJˇ +ıˇ Òñ4ÕRµi≠b.À¬_˘(≠íåŸ≥fÕõ6lŸ≥óˇ ŒKÎø°¸â©2ö=¬•∫˚˙¨®ˇ ÚK‘œ˘I}cQµ”"˚wSG˘ªˇ „l˙Åklñ±%ºCåq®U +äfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥Âˇ ö'ıık…∫Û∏ïæ˜cù≥˛p≤ﬂüõn•˛K	?`œjfÕõ6lÛW¸Êˇ ¸r4Ø˘âì˛ 3»ÙßÚó˛Q˛`-ø‰⁄dØ6lŸ≥gÃˇ Ã´/®˘üV∂•=;ÎÖ!#”:O¸·˝ﬂ°ÁÑè˝˝k:}‹eˇ ôyÓ|Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕûbˇ úÿÚxö √ÃÒ/«õYH˛W¨∞◊Ÿ$ˇ ëπ≈øÁ¸‘|πÁm>B‹aªsi'∏ó‡O∫IøÿÁ–lŸ≥fÕõ6lŸ≥¿ˇ ÛïW¬Îœ◊ D)tHÁÒ|Îˇ ÛÉˆ|4ÕZÎ¥ì¬ü
Õˇ 3s”9≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ˇ–ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6|€¸ﬁÚŸÚﬂõ5M.úR;ód‰H}hø‰úãû¨ˇ ú8Û!‘º¢˙cöæürË˘~˝?‰£Mù„6lŸ≥fÕõ6lÛá¸Ê÷≤`–¥Ì0}bÈ•#ƒDú‚Wú˛q≥E˝-ÁΩ22*êªNﬁﬁí4âˇ %3Ë>lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ#ÑRÁ†˝ŸÚŒÓOVi$˛fc˜úÙW¸·5◊u)ñ—WÔëO¸iûƒÕõ6lŸÊØ˘Õˇ ¯‰i_Û'¸@gê3ÈOÂ/¸¢:7¸¿[…¥…^lŸ≥fœù?ü6ﬂWÛ∆∞ù+tÌˇ I?„l8ˇ ú]πÙ?04ﬂÚ˝t˚·ó=˝õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ü˛~˘|kæI’miWé:¸·"„o˘«>yY]…e<wPöI´©*y.}A—µ$‘Ï≠Ô„˚$´Úu?‚X36lŸ≥fÕõ6|‡¸È’F´Á-bÈMTﬁJÄ˚F}¸#œUˇ ŒiüTÚc\ëΩ’‰ÆàQ?Ò(€;¶lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6xã˛s'KûréÂE>µgüö¥êˇ ƒcLìˇ Œj∑⁄Ωç~ä)ÓåÈˇ 3s÷Ÿ≥fÕõ6lŸ≥gèøÁ7u&µ•ÿ◊h≠^J∆G·ˇ 20ª˛p≥LjªºaµΩìÛwç‚*˘Ì,Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6÷ÊÙln%˛HdoπIœóÈˇ ˘¡ÿky¨À¸±[Øﬁ“ü¯◊=kõ6lŸ≥Õ_Ûõˇ Ò»“øÊ&O¯Äœ g“ü _˘Dto˘Ä∂ˇ ìiíºŸ≥fÕü>?Á%"˘ˇ Vºëæõˇ úu~}“ˇ 0˚„êg–‹Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕÅı$æ∂ñ“M“h⁄3ÚaƒÁÀãªv∂ô‡µ?0xÁ—/»mHÍ>G—Á&§Z¨Ú(ò?Ê^OsfÕõ6lŸ∞∑Ã∫‹Zôu´O¥vêI3W¡øœòww/w3‹Jk$å]èâc…≥Ëß‰góŒÅ‰Ω&≈«˙∫ √¸©â∏j¸ΩZdÎ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6xﬂ˛slèÒú;˝K˛fIéˇ ú$Û∞j'∑‘«¸úLˆ6lŸ≥fÕõ6lŸ‚_˘ÃÁcÁ(ÙS˛FOí?˘¡‘S}¨9˚B ˘ñø´=oõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f¬O<ÕËËîø…gpﬂtnsÊ6zø˛pn‹ÎSxµ≤˛úı.lŸ≥fœ4Œo∏VíΩÕƒßÓE˛π‰,˙W˘Wã z:7Qamˇ &ì%9≥fÕõ>}ˇ ŒLˇ ‰¿’÷á˛L√Å?ÁÂ<“?„9ˇ à>}Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ÊoÊ-ß‘¸À™€AÌ¬èêëÛ⁄üÛä7F Ÿ)5Ù§∏O˘*Ôˇ Á^Õõ6lŸ≥fŒˇ 9yÁ–ûR˝R}RUäù˝4˝ÏÕ¯G∆\Òˇ ÂﬂïüÕ~`∞—T]NäÙÏÄÚôøÿƒÆŸÙæ8÷%†T  Ï;6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6xì˛s2ˇ Îqä ∏≤âOÕûY?SÆIÁ¨ã_ktŸ"Ç:ˇ ¨“7¸Àœ[fÕõ6lŸ≥fÕû2ˇ ú◊≥Ù¸œcs⁄[øJ…/¸÷∏+˛péÙ&π©⁄Wy-ˇ ‡$ˇ 3sÿy≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lä˛kœı)k¯X\ˇ …ßœöπÎÔ˘¬i§Í≤ˇ 5ƒK˜!?Òæz[6lŸ≥gòøÁ8§•Üéû3N~Âè˛jœ$g”/ÀÑ·Âù%z“¬ÿ…$…lŸ≥fœû?Ûë"ÁœöªÉZN˛?¯◊ˇ úl∑3˘˚IQ˚2Hﬂ1JŸÙ#6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœõøú»Œz“Æ√Î˜Ò6œ[Œ 9o#†=Íp?·NvÃŸ≥fÕõ6lü¸Âû?ƒ~ní¬Âk•ß’÷ù=O∑rﬂ>π?Òá%üÛÖûJ7ö≠ÁôÊ_›Ÿß°	?Ô…7êè¯«√ˇ =Ûÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6|ˆˇ úè÷?J˘ÛTî¨R,˛y"DﬂÍŸﬂÁ	¥ìóıEÖ>±v#ƒDä‚S6z36lŸ≥fÕõ6lÚœ¸ÁìXÙ}MGFû?1âˇ ì9∑¸‚VÆ,<ıo	4pM¸/Æ?3›˘≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÑ~w cÚN≤√Ωî£Ô^9Ûã=ïˇ 8K<∑®I¸◊‘˚¢ã˛jœEfÕõ6lÚ∑¸Á%∆⁄,ÛﬂÚ`gï3ÈÔì°0hñäZ¿øtj0ﬂ6lŸ≥gÃøÃ`k^b‘µ%5[ãπ‰S˛K;ˇ ÖŒõˇ 8Å¶ø<%¿Z⁄Õ)?0∞ÃÏ˜>lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕü67gı¸ﬂ¨…„s¯H√={ˇ 8âß‰X[˘Ógo¯nÒÆvúŸ≥fÕõ6F?3<Èí¸Ω{ÆÀNVÒMOÌHﬂ	˛ V^_‰ÁÕãõôo&{âòº“±fcπfc…èÕõ>â~Gy¸ÂK-.E„t…Î‹x˙≤|nß˛1ØÁûO3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõΩªé 	.¶<bâÿ¯õœó˙Ó™˙æ°s©K˝Â‘“Lﬂ7bÁ˛%û¯ˇ úl–CyMçÖ··Ω˝Vi˛Izy”≥fÕõ6lŸ≥fŒ%ˇ 9}¢~êÚK›V≤πÜj¯&›ø‰˛yÚØ\˝Êù/Q&ã‹\è˘,¡$ˇ ílŸÙ´6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕê/œ®ﬁO#k>øUcÙø·sÁF{7˛pûÓÚ’ı≤ëÎGz]«~/b6ˇ eÈø¸z6lŸ±ÎË, íÓÓEäîªªêTnÃÃzO¸‰WÊ‹?ò∫‚>û¥”lU¢Åà£ISY&#ˆU¯Ø¶ø»øƒ‹sîg–ø…Œ-/ÛJçm ¡®€"¨ˆƒÓ¥}Hªº˚-˚aˇ  È9≥fÕú˚Û„œÒ˘' ∑w¡Ç›Œ¶ﬁÿw2H
ÜÒâ9M˛√>vg¨ˇ Á	<¨—€Í^bïh%dµà˚/Ôf¸^¯ılŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÃHQS∞Ú˚Ã˙Ä‘u[À·∏û‚Y?‡›ü¯Áº?ÁtÛe‰1N∆EñO¯9deˇ Ö„ùG6lŸ≥fÕûIˇ ú–¸¡˙≈’ØìÌ[‡∑ÊÊáˆÿRœ˙ëì˛z¶s_˘∆œÀˇ ÒèõmƒÎ  √˝*zÙ<Ócˇ ûìp¯ﬂ~¶} Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6ˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ9ü¸‰ôˇ √ﬁH‘eSInPZßπò˙oˇ $}Vˇ cû—Ù…u[ÿ4ÎqYÆeHêîÏœß⁄NùôgÑë[∆ë ˇ %"˛Ç≥fÕõ6lŸ≥f»üÊ∆á˙s öÆúZ[IJèÚ’}Hˇ ‰¢.|ÿV*C.ƒn3Èﬂìu°Æh∂:®5˙’¥Rüõ¢π¸p„6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f¿Zﬁì≥aq¶\Ô‘Oˇ ™ÍQøœôûhÚÌ◊ñı;ù˝x‹ZJ—∑ΩŒø‰∫¸i˛Kd«Ú7Ûb_À}p_02i˜ EuÍRµY˛-Ñ¸I¸ﬂ∑À=ˇ †yÇ√ÃQÍzT…qi0‰í!®?ÛK/Ì#|K˚Xaõ6E<ˇ ˘°†˘◊ÎZÂ ∆ƒU!_äY?„_k˝õqçiÛ≈úøÛêZøÊ4Ü—kg££U-‘ÓÙ˚/rˇ Ó∆˛T˛Ì?÷¯Ûï`›SDæ“Y#‘ í›ÂçeA"ï,é*í/.®ﬂÕõF÷Øt[®ı2g∑∫ÑÚI#%XÛ˚K˚YÍÀO˘Ã¥(ñ^uÄá}n›j˘S[ˆˇ Z˘ûãÚ«ûtO4≈ÎËw∞›≠*Dnı„˛Ò?Ÿ™·Êl Ûüü4&Y6£Æ\•º@*M]»˝àc˚r?˙øÏæoÁOÁÔÊ^´ıπAáO∑™€AZÒSˆ§ì±ö]πˇ ±E˚9	—¥{≠jˆ2¡∑W.±∆É©f4ÙèÚ„…Py+A¥–-Ë~≠√ˆ‰oéi?Ÿ»Õ«¸üá$ô≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ!øú~hXÚñß™∆D∑dåˇ ≈í~Ê/˘)"∂|‡ä&ô÷8¡gb ©'†œ¶˛J–ó¥K«•¥Qr™è˚&√¨Ÿ≥fÕõ<œÊ_.ió:Õ˘„oiJ˛$(˚+˛SüÅ? œö~iÛœôuK≠f¯÷‚ÓVïº#≤/˘(øˇ ìûÿˇ úT¸ºˇ yY5î„{™ëpıÍ"ß˙2¿7¸ˆŒœõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ<£ˇ 9∑ÊﬁRiæZâæ»kπGπ¨0Ã¸Á?ÛäﬁT:˜ù≠ßu¨:z=”¯Uw¸ñë˝Ü{”6lŸ≥fÕõ6lŸNÅ‘£
©#ÿÁÀÔ2iü¢µ;Ω<ˇ «¥Ú≈ˇ  ÏüÒÆ{À˛qõT:èê¥∆cVâdÑˇ ∞ë—·8ÁPÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥güÁ(?"dÛd‚}>Z≠≤Rhîo<k–ßÛOÏˇ ø#¯>“Fπ‚ÊRÑ´4 ˆ…gê?5<¡‰)Ã˙…ç÷H[‚âˇ ◊â∂Â˛ZÒì¸ºÙóøÁ7£‡]“òH:Ω¥ÄÉˇ <¶˚?Ú9∞‚˜˛so@D≠¶ùy#”£ò–¡+Õˇ ŒgÁ?˘Ã?4k*–hÒ≈•¬€rOﬁKO¯À ‡øÏ!Â˛Vp˝OTª’nÛPöKãâZI≥˛S7≈ç∞”Ó5““ 7ö‚V
ë∆•ôâ˝ïU‹Á≠?"ˇ ÁSJxµˇ 9¢Àt¥x¨∂dCŸÓfY˚Î˚µ˝æ±⁄ø2?+¥_Ã®k1|k_Ft†í"j7˛h€‡Âœ˛iŒ:˘è»n˜>ôæ“¡$\¬§ÒÚÒÔ˙ﬂ_ÒfrºV⁄Í[Y÷Ó—»ªÜBTèì.O¥˘»/<hä◊Uù–~Ã¸fˇ ®Öëø·∞œQˇ ú°ÛıÏ~ë‘} zò°âO¸èêˇ cúﬂX◊/ıªÉy™\Kup›^W.ﬂNN∂∂ñÍU∑∑FíYUE≥—UWvcû‘ˇ úmˇ ú~>Kåyã_Puôíë≈◊ÍËﬂk˛é$o˝ˆüª˝ßŒ˜õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gõ?Á5¸’ı]&√ÀÒ∑≈w3O …‚Ä˚4íÚˇ ûY¡?Áº´˛%ÛÆùlÎ $˙Ãûa˝ËØ˙“,i˛À>áfÕõ6lŸ≥ÃÛôﬂòæÖµ∑ìm„ûóT?∞ß˝&ˇ ^@eˇ ûqˇ 6p?…oÀˆÛﬂôÌ4Ü⁄ÜıÆHÌ
|R»œÜˇ *L˙3kà„U@ Ä∞«fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ–ıNlŸ¸…¸ÒÚ◊ÂÎ-æ±3=€éBﬁÁ'ÁaUH‘˛œ®ÎÀˆp∑»üÛíPÛç¬ÿ€\5≠€ö$WJ#,ï3ƒÕ˛G©Õøes®fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÃM79ÛãÛ£Œ_„6j≤7(S>ú∫àèı’=OˆyÈO˘¬ˇ '?A∫ÛÀI5	}8œ¸WV£˝iûQˇ <Û—9≥fÕõ6lŸ≥fÕü5?4Ó"πÛ^Ø5πﬂ‹ï#°£Ó3ÿøÛàËÀ‰Htkâ»˘sßÎŒÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕúSÛì˛qãJÛÀæ´•2È˙ªnÃÓ•?Òz/Ÿì˛.è˝öIûJÛ∑‰Áö<ñÏ5{+˛Ôåzë„Í«U_ıd‡ˇ ‰‰/6”4ãÕVamß¡%ÃÕ—"BÏÿ†';Wê?Á|ÕØ≤œÆq“≠‰IÒÃG˘0)¯?Á´ß˙ôÍèÀ…ø/~_C«GÇ∑L(˜2—•oˆÓµˇ "%D…ælƒWc”9wûøÁ|üÊÚ”…kı+∂©3Zë'≈‚£Bˇ Ú/ü˘Y√|—ˇ 8S¨⁄ñ}˙∏˚$¿ƒˇ *Ø´¡Gú€Vˇ úuÛﬁò≈e“¶êïî˘ŒpØ‰_ùÓ[Çh◊Äˇ óAˇ '…ˇ îˇ Á¸◊™:∂∞ÈêºòK%?…éÈˇ ¡LôÈ_À»_.~^Å=åF„P•‘Ùg˜ÙáÿÖ‘¯ˇ ùﬂ:6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ<ˇ 9UÊü”ævπÅ∞ÈËñ´·U§ﬂÚZGOˆ“?Á¸´V‘¸« Ë“#Û˝Ùˇ ˆ/û¨Õõ6lŸ∞≥´€Ë÷SÍW≠¬⁄⁄6ñFTõ>kyÛÕ˜p÷ÓıÎøÔ.§,˘P|1Gˇ <„ULı◊¸‚Â◊Ë/∑òníóz©ïÍ∞/˜_Ú5πK˛RzYﬁÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ?ˇ—ıNlÃBäûÉ>dyÁÃì˘õ[Ω÷nò¥ó3ªÔŸkH–ì|Q…\&í!#‘RÑÄ¬¢ïuaÏs’_ÛçÛëí\Iî<’)gj%ù”ù…˝õiÿı'˝”#∆&˝åı6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6sØ˘»:ˇ Ñ|ü}yqπù~≠è9~K˛Tqzíˇ ∞œüuÑ⁄çÃVV´Œy›cEŸè_•é}3Ú_ñaÚæçg¢[ˇ wi
GQ˚Dçˇ Á£ÚˆXsõ6lŸ≥fÕõ6lÁ?üüò„»ûW∏ΩÖ∏ﬂ\´⁄é˛£É˚œ˘‚ú•ˇ YQk>|Y⁄Mq≠∫ô'ô’FÂôèQÓÕüJ?-|ûûMÚıéÇÑµàa–»ﬂºôá˙“ª‰ó6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6b=23´~X˘_Wc%˛ïg3û¨–'/¯><∞æ€ÚK…VÌŒ= £˘°Vˇ âÚ…^ù§YÈë˙6EoÚƒäÉ˛‡ºŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÿV‘¢“ÏÁø∏4Üﬁ7ïœ˘(•€\˘Ö≠j≤Í˜◊ï¡¨◊2ºÆ v.ﬂãgæøÁ¸Ø˛ÚFüé2›!∫s1ÊüÚG“\Èπ≥fÕõ6y«˛s+ÛÙnïîÌìﬂüVzu°¯˛{LøÚEøõ<Õ˘U‰Y|ÛÊ+=
:àÂ~S0˝òó„ôæ|>ˇ ã3È•§Vp•µ∫ÑÜ%ä:Q≈T™∏ÆlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇ“ıNlÁˇ ùˇ ôVûCÚÌ≈‹Æ>ª:<V±◊‚iq«˝˜}I˝è⁄tœù—F“∏é0YÿÄ ÍIË3‹ﬁsˇ úv¥Û?ìl4ÇoM≥ä8gÒeAŒ	OÌA$úø„~Òm_ƒZûõu£›Àczç›ªîtmôYMœrˇ Œ4~p>h¶«Q~Z∆û%'¨±Ùä„˝oÿõ˛,¯ˇ ›πÿÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ„œ˘Õ;}wV¥ÚƒXÏ£ı¶˝˘/ÿSˇ ·¯øÁæFøÁ¸ï˛ ÛrÍ3-m¥§3üP˛Ó›~|πJøÒá=—õ6lŸ≥fÕõ6lƒ”<ˇ 9'˘•˛:ÛEf¸¥Ω?î6Ù;9ØÔÆ?Á´Øˇ ä£è%üÛàñgZ÷_ÕWâ[=4ÒÜ£fùá˝ã∆yˇ ∆Gã=ùõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕú´˛rwÃü†¸ç}ƒ“KŒ©ˇ =Ô?‰ÇÀûÚŒã&ª™Zi0˝ªπ„ÑS¸∂	_¯l˙ygiú1€B8≈™(
8®˚±\Ÿ≥fÕï#¨j]»
¢§ûÄ˘ª˘πÁáÛ∑ôØu¢IÜI
@hì‡á˛	6ˇ -€=)ˇ 8i˘}˙;J∏Ûe““{ÚaÄû¢œ∆√˛2Œ?‰ÇÁ£ÛfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lây◊Û_À^JS˙r˙8e•D Ûî¸°èîüÏôxˇ ïú;ÕÛõvë1èÀ⁄kÃ;Ir·¸äã‘o˘*ôœ5˘Ã_:‹±6‚“Ÿ{Ñ∑„3…ÄÌøÁ.|˜	´œo(x˘'È‰Û üÛõw
Îô4‘tÔ%£#˛xÃ\7¸éLÙOêˇ 34=[≠Âf‚>8œ√"∆Hõ‚_ıæ√~Àd£?ˇ”ÙﬁµÆXËvØ®jì«mk´I#Q˜˜˛U˝¨ÛáÊ7¸Êm≠ø;?'[˙Ún>µp
†ˇ *(?º˘Ëcˇ åmû`ÛOõµO5ﬁ∂ß≠‹=’ÀÌ…Œ¿" ¯#OÚUsºŒ.˛C‹Íw∞˘«]à«ß€ë%¨n(fê}â∏ü˜DG„C˛ÏìèÅ[=âû]ˇ ú≈¸™I!O;ÈÈI¨7ÅGU?›˜/˛KE¸ô¿ˇ &¸˜'í<œg´´1¿Ï–π„-‘˛ıÀçsË äç¡Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ∞6©©A¶ZÕv‹ ∑ç•ëèeAÕœ¸œôﬁsÛ4ﬁi÷o5ÀüÔ.Êy)¸†üÅ?ÁöqOˆ9Ì˘ƒﬂ$á|¢öÑÀ∆ÁU¨5z˙c‡∑_óS/¸fŒ”õ6lŸ≥fÕõ6l·_Ûïõ„ zAÚˆõ%5]Ebßx†?ííÛu¸Ùÿ\Òóñ¸ΩyÊ=FﬂG”S‘∫∫êFãÓiº∆Ì˚)Òg“Àﬂ$⁄y'Dµ–lwKt£=(]œ≈,≠˛ªˇ ¿˝üŸ…lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6yo˛s_„ï¢!˚M-Àèı@ä/¯úŸÀÁ|æ5è<⁄H¬±ŸG-À±_N?˘+,yÔlŸ≥fÕõ9ˇ ÁÔò[@ÚN´y„#AË©k3-æﬂÍâ9gœ=>∆K˚ò¨‡ñwX–x≥+¯ú˙sÂù/iñ∫E†§6ê§KÔƒqÂÛo¥ÿgõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÛ◊Ê.â‰k?ØÎ∑
Aºí˚1D>'ˇ à/Ì≤Áí?3Á-5Ô23Ÿ˘t.¿Ì…Mgq˛TøÓüıa¯ø‚÷»ﬂîøÁ|œÊî:æ®WK”€„{ª˜·Pl#˛ıÎ¸œ¡˝˘ít—?'¸ôÍ7w^cº^©n
C_fVâHˇ £ôrI§yÌfZy;Ú˘*m4–óØ˚?C˛g‡Î›{Œ≥!7˛B∞ö’E∏-O°§o¯LÅÍ£»¸ˇ £ı›.Ô…⁄´l$Pœ‚ÎyV9?„'˘Rd7_Ú«ô?(µx5i∏r˝Â•Ì≥rÜdˇ !˛À´/˜êø¸2qfıèë??ÕﬁK‘µË#÷¥´I•öRº“7ñ)T}ØBfè˘π'«˘mˇ‘‰ü?õ7û◊f˝·U¨ç¨@¸<TÒıŸ{À7⁄Â˚)˚º'¸º¸†ÛüÂ„¢[n¶èq'¡¸‰˝¶ˇ "0Ô˛NzßÚ√˛q/BÚ√•˛º√UæZ0VZ@á⁄/˜w¸ˆ¯?‚¨Ó °@U`^Gø1ta≠˘sR”H‰g¥ôîQΩ?π¯ÁÃÃ˙i˘y¨gÀ∫n¢Lˆêπ˘î^Ÿ Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ¬Á/|˜˙À¢¿‘π’_Å®Ö(ÛˆMÈE˛´æyÚˇ  R˘ø^≤–†≠n¶Tb?e≈4üÛŒ%wœ•∂VqX¡•≤ÑÜX—G@™8™˝ãfÕõ6lŸ≥fÕëOÃﬂÃm?Úˇ GóY‘MH¯aà4≤Dü≠€ˆìgŒÔ7yÆ˚Õö§˙÷™˛•’ÀÚo :$h?f8◊‡E˛\ıó¸‚o‰Ÿ–lø≈˙º|oØñ»√x·?Óﬂi.?‰œ¸e|ÙVlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lœ¸Âˆ≤o¸Óˆ†’l≠°äûÏ¡ˇ ì˘6ˇ ú—9O´k>¬Cnß˝b“…ˇ &‚œXfÕõ6lŸ»?Á+Ì§õ»7çiê3S√‘E˝mû(Ú¸:wòt€€í0^[»‰Ù
≤#1˚≥È∞5‹fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6pÔœ/˘…ã?"ªËö*≠Ê≥«‚$÷(	ÈÍ”˚…‚ï˚?Ó∆˝úÚ•ıéπÁ˚-KŒ7◊FÚ‚¡‚˙¬9<ƒrUñ5˚Nº=8˛«._g&ﬂówññmØÂ÷ç&≥Êä“_^†1¿ƒ|_W∑Ø£C˝b‚^_Ïs≠ÈﬂÛçÁõÊ]KÛ3XöÈÎQknﬂˇ ìÃèI? X ˇ ûô◊|•˘KÂo)®˝ßAã˛ÌeÁ'¸éóúüŸ.ÕÑ^rÚ6ëÁ+”uÀt∏ÖÅ°#„Bn)>‘o˛Ø˚,Û.âÂ4Õ^˜ÚSÃ“Ù€‘kç&·∆ÒH…ëˇ  n2¨—Ø√Í∆ËøœúW…:é°ÂΩ^ÔGåZ˙≠.XÎ≥4»ˆ—Ø˚ØIøÿÁˇ’Û?ôÙItRÔIú%§ÚBk˛CØ”û‚ˇ úVÛLﬂím≠c‚≥ÈÏˆÚ®†Ë}HﬁüÂ«"¸_¥¸ÛØÊÕòÄECü1ºÔ¢ù\ø“»ß’nfà|ïŸW˛=πˇ 8´Æ~îÚ%úljˆíKnﬂCô˛I ô◊sfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6|¸ˇ úèÛ˜¯«Õ◊2@‹¨Ïø—`ßB#'‘ê∆IΩF¸ú3©ˇ Œ˘‘ñÛÕ◊+∆>´nOÛ=√èıW”éøÂ…û∞Õõ6lŸ≥fÕõ#ﬁyÛÊï‰ç9ımjQ+≤®›‰n—Bü∂Ìˇ 7?œ~m~kj?ò˙©‘oøwmVﬁ‹¨Iˇ H˝eìˆø‘TUûˇ Œ4~E7úÔWÃ‘gÙ-´¸*√kâ˝◊Ôg˚ÔÊ˛Á˝˘√€‡õ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6|Ë¸¯‘ˇ û5ââ≠.û?˘HÊ^zs˛pÀLﬁPûÍüÕÏÜæ ë∆?·πÁ{Õõ6lŸ∞õŒ^YáÕ=Êâs¥wêºU˛RG¿ˇ ÏãÁÕO0hWz°>ì®!éÍ÷FéE˜S€≈[Ì#~“¸YÌ˘≈œŒ5Û~í4Iˇ ‹∂úÅA'ya
KÓÒ|1Õ˛¬O€lÓy≥fÕõ6lŸ≥fÕõ6lŸ≥gü?Á#?Á# ©'ñºµ m]á¶]≈∏?≤øÚÛˇ &◊œÀ+ÃÌ$åYÿíÃMI'©'«:è¸„vøoaÊî“µ
6ü¨≈%ÑÍz(˝ﬂﬂ(Hˇ ŸÁuˇ úgΩó Êµ˘i®é÷V∏∂c±t¯Qœ˚8çº»øÂIùœüÛêﬁQÚg(nÆ≈’⁄ÌËZ“GØÉµ}(ˇ Á§äﬂ‰Á9_ÕœÃœ?öy/Fuã}õ´≠Õ?ô^~7¸ÛÜ|Á?ôzüú<§Ëöáõd∫◊ô‘-çã;$ˇ ªJz1G˛L^É<ü…«‚œ\y]V]
∆O0:£[∆n ¯ÈÒrU¯Uˇ üè√œYÇÇÃhSû\ºÛÖóúˇ 3Oö!p<øÂ[WiÆGŸb¢_∞ﬂµÍœ/W˝⁄ërOµû~–µ≠cÕk–%eäiıF^¿AœPp}øu√?ˇ÷çŒc~_'\ãÃˆÀKmIxJGA4céˇ Òñ,øÂG.Gˇ Áø2Gî|Ã∂o«O’8¿ı;,ïˇ Fîˇ ≥fàˇ ì//ŸœwfÕõ<ˇ 9S°~äÛ›„®¢^$W˛…}7ˇ í±Iù[˛pÉ^Ák™Ë¨wI"∏A˛∏1Iˇ &¢œPÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6sèœˇ Ã1‰*‹ﬁB‹onG’Ìºy∏5ê∆˘À˛≤ØÛgœ´)µàÌ-î…<Œ±¢é¨Ãx™ˇ ≤l˙O˘o‰»|ôÂ˚=´D∞˝©„öOˆr≥dó6lŸ≥fÕõ6sˇ ÕÔŒm'Ú÷«÷º>µ¸†˝^’OƒÁ˘ﬂ˝˜
˛‘üÏSõgÑ|ˇ ˘â´˘ÛQmS[ò»˚à„Gˇ æ·OŸ_¯w˝∂lËêˇ Ûè7æ~ù5MUZﬂAç™_£OO˜T‰ø&˝ü≤üÿ˜&ó•⁄ÈV±XXF∞€@°#çTtP0VlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÛSÛNø‚ÕbΩH]…◊œcˇ Œ$”¸mO˜¸ıˇ É9Ÿ3fÕõ6lŸÁè˘ ü…'Û%∑¯ØCàæ•l¥∏çÚƒ::ØÌM¸≈ˇ ∫„\ÚÉØﬂy~ˆ-SKô≠Ó‡nI"„eo≤ ﬂ/¬ŸÌü…˘…=;œ)ï¨≥÷È@§“9œÛ@[Ï»ﬂÒæ˘˛œkÕõ6lŸ≥fÕõ6lŸ≥fœ>ˇ ŒGŒE/ïO-yn@⁄ªäM2Ó-¡˝ïˇ óñˇ í?kÌÒœYŸ›ÎimlèqwpÙUgwcˇ ÃÕûñºˇ úUM»W˜◊ﬂæÛƒ.GUâc˝‰∂Ò”˚«hπ˙è¸¸V?á‚ìÃñwrŸÕÃRXô]ußí∑–s“6øï˛l¸ﬂΩ_=kÛ€ËV¿†K£<4˚\yÙtn,˜'¡˛Î·ÜV˛b¸¶¸™"-ØÎ+∞ê/≈˛LÃ>≠˝G#·≥?Ê«Ê¿‡™<≥¢…‘ûK+)ˇ ßóˇ ßXü:?Âá¸„ﬂó|Ñ¬ˆ$7∫ßSu=z˙)ˆ!ˇ [‚ó˛-…Øö¸„§˘NÕµrÊ;[uË\Ó«˘cAÒ»ˇ ‰¢≥gõº·˘°Ø˛p$ˆ>]ˇ pﬁRÜø\‘nO …˚JÕ˛W¸≤¬Õ$üÓ◊Tn9∆¸˘ÁÀ—È‰ﬂ'#≈°ƒ·Âï≈%ºò«ƒˇ Àˇ tA˚?iæ.*ùªÚ£Ú*ÎÀ^H÷µçF:ﬁß¶]EjÒ∆—?∏˝Ø^·¯rO¥øªO∑Õsˇ◊ÔüöæAÉœû^∫–¶†íEÂüÿï~(_ÂÀ·¯≠ü>pÍ}∆óu-ï⁄Æm›£u;e<Yÿ∂{„˛q”ÛHy˜Àànüñ©c∆êNÌA˚´è˘ÏÉ‚ˇ ãV\Íy≥gìˇ Á7¸ø∆}+[Aˆí[g?Íë4_Ò9≤ˇ 8çÊ—~vä—ç˛	`>Î	ˇ &xˇ ≤œufÕõ6lŸ≥fÕõ6lŸ≥fÕõ6xG˛rìÛ0y√Ã≠af¸¥Ì/î1–Ï“W˝"_¯%/˘1r˝º:ˇ ú@¸∏:Ê∫˛eªJ⁄i›‘l”∞¯?‰Jrì¸óÙs⁄ô≥fÕõ6lŸ≥í˛y˛X~\€õ+^7:‰´X·Ø√=&πßŸ_‰èÌÀ˛J|y·è1˘ìPÛ%Ù∫Æ≠3\]ÃjÓ«ÓUˆQ~Œ˝ˇ 8Òˇ 8–æaä4˘§WNéﬁÿÂ ˇ y=>Ã?À€óˆ∏«˝Á∞-Ì„∑çaÅV8êUP  lTl™1˘≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœü?Ûí>Yì@Û∆¢¨)€ã®œäÀÒø¸ﬁ™±Œ≈ˇ 8]˘Å	ÇÎ…˜,`ÊÍﬁø¥<kÓúRN?ÂI¸ôÍLŸ≥fÕõ6lÛ∑Á∑¸‚‰c2kﬁRUÉS5im∂XÊ=⁄?ŸÜvˇ ëR~◊‰Ì„˝CNª“.ûŒˆ7∑∫Å∏∫8* √ƒ∆zÚg˛rŒÎFÈr/ud(©v>)cÒpˇ èàˇ  ˛˚˛2Á≠Ù]nÀ\¥èP“ÊKõYERHÿ2üÌ˛e˝úõ6lŸ≥fÕõ6lŸ≥Éˇ ŒGŒAßí·o/Ë.[ô~7ãuaˆøÊ!ø›i˚ﬁøÏ+¯≤nµ[°AÓ.ÓÄ
≥ª±ˇ ÇwvœpŒ>Œ>¡‰(X’’e◊f_ö¿§o_Òiˇ vÀˇ <„¯94ù¶XñU1»#==F|‘¸ÃÚõyKÃw˙-¥Ï#Øx€˜ê7˚(ô2i˘}‰ΩKÛÀöíæ©1ø©oaª#
<ø≈¡wG_Ó˘r·Òg¢ÁtO/\yV€X±≤Ö55gÜ‚n<§Êá˝¯¸ô9ƒ—ø‚ütØ8˛e˘{…±ô5€Ë≠⁄ïì Fˇ RÂ+¿gøˇ úãÛ'ùÊm7Ú«IíA^&Ú·Gˇ +ç}ˇ Á¥Øˇ sòyñﬂÀ˙—‘ˇ 0ı7ÛGòKi°˛KãøŸEˇ |¿â«˝ˆÀêo0y”Ãøöph÷pˇ £°„kßYßc‰ƒøÀ˚SKˆ»LÙØ‰_¸‚˝∑îﬁ=sÃ¸.ue£E¯£Äˇ 7¸]:ˇ ?˜qˇ ∫˘73–ˇ–ıNy#˛sÚ§⁄‹'ùÙ‰˝ÃÂbº
:?ŸÜî´˚ßˇ ã?⁄ì8˜‰∑Êlﬂóû`áUk9?uu˝®ò¸DÁà˛Ú?ıx}ól˙%c{¸›⁄∏í	ë^7SP √í≤˚2‚Ÿ≥éŒXywÙøëÓ'AY,%ä‰|ÅÙdˇ ís3±œ˘ÃÀ∫ÌÜ∞≠ÃR∑˙™√òˇ dúó>õ#¨äUÖA¡ÀÕõ6lŸ≥fÕõ6lŸ≥fÕõ8ß¸‰óÁtK“‰—¥πÅ◊/¢Ö50#}©ﬂ˘é–ï˚œ≤ô‚-'Jπ÷/!”ÏPÀuq"«¨Ãx®œ£üïæA∑ÚóÌt+z3ƒº¶q˚r∑≈,ü_
≈jãíÃŸ≥fÕõ6l‡ˇ üüÛíñﬁLY4//2‹kDqwŸíﬂ˝~œq¸±~«˚∑˝ˆ˛,‘u+ùN‚K€Èkôòºí9%ôèVf8>áˇ Œ;ÕÎyHo
ˇ ¿ªß¸kù6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥àˇ ŒR~QøúÙe’ÙƒÁ™i°ò(…	¯•à3ß˜±œD_äLÒFÖÆ^h7–ÍölÜªgé†è÷ßÏ≤˛“¸-ûˇ ¸ñ¸Ê”ˇ 2t—*áTÅ@π∑Æ‡ˇ øb˛hˆìÏ?˘]6lŸ≥fÕõ9ˇ ÊØ‰ûÖ˘çoMA=ÙäÓ0=EWˇ Eˇ ø˚LÒ7Ê‰÷Ω˘wsÈÍëzñéi‘`òü⁄øÓ©?‚π>/ÂÊø¸π¸◊◊/Æ˛≥¢ŒDLAñ›Í—I˛ºÕˇ '? œf˛Rˇ ŒEËT≥v:± i[g?ÚÌ/¬≤ˇ ©À˛GÌgVÕõ6lŸ≥fÕõ6r/˘»?œ(.¨>•`VMrÈO¢áq˝ü¨ øÚi?›è˛B>xJ‚‚ÎU∫i¶g∏ª∏z±5gwcˇ ŒÌû”ˇ úqˇ ú}O%¿æ`◊ê6∑2¸wË√Ï˘xo˜k˛«˜I˚|˚ælÚ¸Ê∑î>´™X˘í¢]∆`îèÁã‚å∑ªƒ¸ÁéA?Á<ﬁ<ªÁ;hf4∂‘CY»Jø˜?Ú]c_ˆMá⁄çÊ_◊<ç•kqh:]¥ÚO,íøß˚∫¨q¥rSü&Ö‚¯Xπ`{≠GÚÀ…≤4¿\˘∑V≠Lì∑/_é_ˆ_XF˛lç˘õÛ´Õûv„£Xˇ ¢Y?¡ÜùE#˘8≈˚Ÿ’˚‰d◊Úﬂ˛q\◊
]˘ôˇ EŸù˝1Fùá˙ü›¡ˇ =>?¯ß=W‰OÀM»∂ﬂT–mñC„ê¸R?¸eî¸M˛Øÿ_Ÿ\îfœˇ—ıN ◊Ù+M~¬}+QA-≠Ãmä{Ç;x2˝•oŸoã>r~g~_›˘]∏–Ø*¬3 ))A$M˝‘£Ê>˛Y”ˆs–øÛà_ú¢ÅµY>%‰ˆ,«®˚r⁄ˇ ±˛ˆ/Ú}E˝îœRÊ¬œ4ËqÎ⁄Uﬁë7ÿªÇHO∑5)_¢πÛÓ÷K9§∂úqñ&d`{2û,>¸˙%˘ÊèÒ/ìtÀˆnR¨<y√˚ÜÂ˛∑ßœ˝ñO3fÕõ6lŸ≥fÕõ6S0QV4¯UÊÌN©Ωæ∂ÇüÔ…ë‚Më_˛r»∫P&mZ	Ì)O¸êY3ü˘á˛sGÀV`Æìiuz„°`±!ˇ d∆I?‰éqœ:ˇ Œ[y∑_VÉN1ÈvÌ∑Ó2S˛b$›÷â"Œ4Ôq®‹rbÛ‹Ã›MY›ò˝,Ó«=áˇ 8«˘7ïøÁiÛ\59ñ∑XUá≈$üÀ<ãÒˇ uGÀó∆Ï©ËúŸ≥fÕõ66YRie`®†≥3 ROÜy[Û◊˛r¨0ìAÚDùj≥_/‚ñüˆQˇ "ﬂπÊ?Oª÷.““Œ7∏ª∏~(ä3±¸IŒŸÁü˘«oë_]’€‘÷§öQ[‡ÖûQÌ˝Ï≠˙èˆ˝◊¸Ô¬3Ë¸„∆_À˝.ø≤&_∫is©fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÚè¸‰ß¸„É#ÕÊÔ*E…≤]⁄†‹ØsèŸ˝©¢˝üÔ·Â√Õû\Û&°ÂªËµ]"f∑ªÑ’]Oﬁ¨:27Ì#|-ûÿ¸ìˇ úî”<ÙëÈz±K-oßi«˘≠Ÿølˇ æ„˛OS;NlŸ≥fÕõ6‘ÙÀ]RﬁK+¯í{iWã«"ÜV≠ûZ¸›ˇ ú@x˝MS»ÁíÓÕc#n?ÊV˚_Òä_ˆ2∑ÿœ1^ÿ›iw-mw€‹¬‘dpU’áä∑ƒ≠ùÀÚ£˛rÀXÚœ?ÃÅµ=<P		˝¸c⁄F˛¸ì/«ˇ Á≠ºì˘â°˘⁄◊Îö“\(öVí'¥±7∆üÒÂ…lŸ≥fÕõ6Eˇ 2¸˝i‰=„]Ω¯Ω!∆(ÎC$ç˝‘K˛±˚_À7˝ú˘”Êü3ﬂy£RüY’d2›‹πf=áÚ¢ŸD_ÅˆW=Qˇ 8π˘4∏¢Ûóòbˇ Lêr≥Ö«˜jz\∫ü˜tÉ˚Ø˜“|ﬁ7Ó˝-õ	<ﬂÁ]'…ˆ-©Îó	mnΩ9}¶?…c„ëˇ …LÒóÁœ¸‰Q¸∆Ñh÷ãó¢UywôôC*∑√Bº]æÁˇ 3åZ]Ii2\¿≈%âÉ£°îÚV˚Û®_yKŒﬂú⁄ƒû`ãL!ÓxëP√Djﬁ§ÌÒ|
º∏ªÁYÚG¸·J/¸Ÿ}À°0Z
ì\J+ˇ ˚<Ùìø.t&≈ËË6Q[mFp+#Ø3Úïˇ Ÿ>I3fÕüˇ“ıNl‰üÛëﬂî#œ˙∏±JÎ§Çùd_˜e∑˚?µ¸[˛ªÁÑ,oÆt´®ÓÌ]°∫∑pË√fWSU?Î+g–Ø…?Õ[Ãm	5DøÜë›ƒ?fJ}µÔ©æ‹Ï£˚Q∂tŸÛ˚˛rc 'À~vΩº`Ω"Ó?˘Î˝Ô˝<,π÷ˇ Á	¸Ëw˛Uùæ%"Ó {ÉHÆ ˘~ÂøŸ>zõ6lŸ∞£Ã^o“<∑÷5´»,„Ïep§ˇ ®ß‚ˆ9«|”ˇ 9çÂ=,òÙ®Á‘§
/•¸åõ˜üÚG9OòÁ4|ÀxJÈ6ñ∂Hz+èˆLR?˘#úˇ Uˇ úÜÛ÷¶IõVû0{C∆ ?‰B«ë…ˇ 1|À;sóUæfÒ72ü¯ﬂ4?òæeÄ÷-V˘OµÃ£˛7¡cÛoÕ„o”7ˇ Ùì'¸◊çÕè78£k7Ùˇ òôÊº?ÊòÓ+ÎjóØ^ºÆ$?Òæ›j˜óÔDÚÀ˛ª≥ƒé¡6ZuÕÛ˙vëI3üŸçKπrm†˛B˘€\#Í∫M¬+~‘ !}¡è:Øîˇ Á
ukí≤yä˙+X˚«nØÚÊﬁúiˇ %s–_óüëæWÚ&“≠CﬁCs9Á/˚˚1œè'Ÿ≥fÕõ6là~`˛k˘»VÊ}nÂRR*ê'≈+ˇ ©¸n¸#ˇ /<i˘√ˇ 9≠~`ñ±Ü∂:=v∑FﬁAŸÆdˇ v∆?Óó¸∂¯Ú‰!j˛wø]/CÄÕ1°fËëØ˚Úi:"ƒæ rl˜/‰◊‰>ì˘on&Z]jÚ-%πa“øj+uˇ u≈ˇ 'Ì˛ )g¸Âî^ßêo˘%∑o˘(ãˇ gÉ3ﬁÛâ“ÛÚöˇ $∑˛Jª∆ŸÿsfÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÛüÁü¸‚ƒ˘ó]ÚÇ¨â´Àk≤«)˝¶ãˆaòˇ »©?‚∂¯õ»Zéõw§]=ùÏoouqtpUïáà;åÔ_îÛñzèóÑz_õﬂÿ
*Œ7û1˛W/˜°˘_Ωˇ -˛∆z„ ﬁn“º’f∫ñâs’≥~“¡˛YÌ∆ˇ ‰:´aælŸ≥fÕõ6B?2'<ø˘Ö^7J)ÃTYS˝ü˚±?‚π9¶x˚ÛO˛q´Ã^G/wnáQ“÷ß◊ÖO%Ò|«˛∫Ûã¸ºÊ>µ{¢‹•ˆô<ñ◊1ö¨ë1VÏó=O˘/ˇ 9l/=œcë®±ﬂ(
§¯] ¯cˇ å…˚øÁD˚yÈÙuëC°¨*‹rÛfÕõ6l˜¸ÂáÊ¯£_˝d¸¥˝(î4;<˝'˘Â˝ ˇ ´/Û‡?˘∆ uÛ∂Ω˙CQèûï¶Òí@F“HπÉ¸•¯}I»N˝Ê{∑6sœŒ?Œ}3Ú÷√’∏§˙å¿˝^ÿˇ ã$ˇ }¬ø¥ˇ µˆS<#ÁØÃ_œÉjö‰∆YMB Ÿ#_˜‹1˛¬√7⁄vf…áÂ7¸„Œø˘ÑVÌWÍZUwπîã«ÍÒl”≠≈ˇ rœ\~^ˇ Œ>yS…(Øml.ÔG[ãêÎˇ ©ú_ÛÕ9ñŸ“@¶√6lŸ≥fœˇ”ıNlŸ„ø˘À/…è–˜gŒzDt≤∫z]¢ç£ïø›ﬂÒé‡˝øÂü˛2Á&¸†¸œª¸∫◊#’≠ÍˆÕ˚ªòA˛Ú2~/˘Ëün&˛ÚÛËvÉÆYÎ÷0Í∫lÇkKîé‡˛¶eóˆ[·¡˘¡?Á.,ÊÛ.âΩßFdº“ÀEY†oÔ?÷ÙYVOı=\Òﬂñ<—®˘_PãW—Ê6˜ê£ä£ã++|,åø+g£|≠ˇ 9∑q,^a”VVymüÖÁåº«¸ï\úŸˇ Œfy:eho°n‡ƒáÒI[Mˇ 9â‰ò«√ı«ˇ Vˇ »π÷?Á7txîç/LπôªzŒë¯O¨g)Ûó¸Âßú5a∞xÙ∏kqY˜ûNL?Áó•úzˇ Qπ‘fkõŸ^yﬂÌ<åYèÕﬁ≠í?*~T˘üÕt:6ù<Ò∑˚≥èˇ ‰tº"ˇ áŒπÂœ˘¬œ1^ ˙≈Âµíû™ú¶qÛß•¸ïlË⁄?¸·Wñ≠Ä:çÌ›”w‚R5ˇ Å·#ˇ …Lî[ˇ Œ(y!F≤íC‚◊◊˛–fõ˛qG»2}õ)˝[â„glˇ Bç‰O˜≈«¸èlµˇ úGÚ 56˜Á;‡®?Á<Å	∞wßÛ\Mˇ »∏kkˇ 8È‰+Zp“!4˛vëˇ ‰‰çá˙Âgï4ÌÌ4ã»Ó-„'˛Ø,ë€Y√jæùºkx"Ä>Â≈sfÕõ Í˙ÌÜç	π‘Ó"µÑ~‹Œ®øNW9Œ≥ˇ 9=‰=,î:á÷vÇ7¯~>ü¸>EÔ?Á3¸°D6˜“¸£å¯i∞¶Î˛swE_˜õL∫ı›˛#Í‰wTˇ ú·ºzç7Hé3ÿÕ;?¸,i¸O9ˇ ôÁ*¸Ò≠´EÃv1∑kX¬ü˘'´*ˇ ∞uŒOwyq®L◊R<Û»jŒÏYòˇ îÕVcù£Úõ˛qc\Ûk%ˆ∏L“ŒıqI§ÒT-˝ÿo˜‰øÏLˆ7í¸ã§y.≈tÕ›`ÄnƒnŒﬂÔ…d˚R?˙ﬂÏ~>ŒYˇ 9?´˘©ˇ í o∫h≥Áˆ{ü˛p˛^~GE˛K©◊˛"ﬂÒ∂v‹Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6A?4?&4Ã[~§^ù‚
Euã‡	ˇ v«ˇ …˛√É|Y„Õ?»?0˛^ªMs÷¥⁄¸7pÇW€÷OµØ$èë)y”WÚç‡‘t+óµúu*va¸≤∆~	¸ó\ıOÂá¸Êù©±ÛÑb ‰–ò¡0±ˇ ã‚í˘)¸cœDXj⁄å	we*OÇ©$lXx´/¬pFlŸ≥fÕõ6qÔÕ_˘∆o/y—$ª∞E”uSR&âhéﬂÒ|+û_Ôƒ„'Ì|g<SÁO$ÍûL‘d“5∏L7	∏ÓÆø≥$O˚q∑Û±oã·Œœˇ 8Èˇ 9'ïû?-˘ñB˙C∞Ã€õreºm‰œÏ¸ÏË•IëeâÉ#   j=>ÏŸ≥fŒi˘ˇ ˘§üóﬁ]í‚Sª¨6ã‹1ˇ Í¿ø¸dÙ”ˆÛÁÌΩº˙Ö¬A
¥∑∏UQª3±¢èvf9ÙcÚ{ÚÓ/ yr€FP≈=[óµ3ˇ y˛≈?∫OÚrkúÛÛõÛóN¸µ”LÛRmJ`Eµµwc˛¸ì˘ O€o⁄˚	ÒgÅ<”ÊùGÕZå∫∆±)ûÓsVc–ŸD_ÿç> "˝úÙ¸„◊¸„ ’í/3yæ"-èoh€Uö„˛)?±˚∑Ì?Ó˛=s)
,Q(H–UQ@ Ë™@1Ÿ≥fÕõ6lˇ‘ıNlÿV“mu{ItÎ¯÷kkÑ1»ç—ïÖgœoŒü køÀ}i¨^≤XOWµò˛“WÏ7¸]Ÿì˝åüe◊&øÛåˇ ûø‡´œ–:‘áÙ-€¸.zA!ˇ v∆?›ﬂÀ˝Ô˚Ûü∑ë’‘:TäÇ7≤+±Œ˘ïˇ 8ì†˘ûi5C•ﬁHK2™ÚÅâÔË¸&*ˇ ≈M√˛*ŒØŒ#yﬂMf˙§P_F:ePHˇ R„—»ç◊‰Gû-âh◊fü»úˇ ‰ﬂ<F/…?: h∫5Ô”¯ê{•Œ1˘˜P4iÖöicAˇ œü¸&t*ˇ Œj32…Ê-B(©éŸLçÚı$Ùë?‡$ŒÈ‰ø˘«ﬂ'yKåññ)qrøÓÎüﬁΩ|WüÓ£ˇ ûQ¶t`äÄÕõ6lŸ≥fÕõ6lŸÛ˜Êﬂó<â-rÌRb*∞'«+´Ó£¸π8G˛^yèÛ˛s[’K[yb”mŒ¬W§ìÙ˛Ê/¯?„&pmg^‘5…ÕÊ´q-‘Ì’ÂrÌ˜π≈t+Í∫—„•Ÿ‹]üπâﬂ˛ ≠íªO»?<›ä«£‹äˇ :Ñˇ ì¨òoiˇ 8ª˘Åqˇ JﬂLó<#˛f·˛õˇ 8qÁ;¢>≤÷vÀﬂú•à˙!éO¯ñN4˘¬6µ´;•¥Tˇ í≤≥…úÏ˛D¸àÚüíYg”,ƒók“‚sÍHä¯"ˇ ûItŸ≥úŒE≈ÍyWS⁄?të∂|Úœmˇ ŒMœ…≥'Ú_ >ÙÖ≥ºÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥ceâ%CäTäÇPFx„˛r€Ú∑BÚìYj∫U{È%YcC˚øÑ#é?˜_⁄˚)ëût…gêˇ 4¸¡‰Y˝}
È¢Bj∑≈ˇ Ø|?Ï◊åü ˘ÍÀ?˘À›^)eÊde„mÍÇZ›è˙ˇ n˘È…?‚ÏÔ–\GqÕ+∆‡e ÇB¨:å~lŸ≥fÕõ!üö_ïzWÊ.òtÌMxLïh.|q9ÓøÃç˛ÏãÏø˙¸|˘Å˘™yTìG÷#„"Óé>ƒâ˚2ƒﬂ¥≠ˇ ç?≈ùS˛qˇ ˛rFo%î–|¬Õ6äM#}ŸÌÎ¸Ωﬁﬂ˘¢˚Iˆ¢ˇ }∑¥¥ÕR◊U∂é˙¬Tû⁄eàC+›X`úŸ∞õŒp”|°¶À¨k2àm°Ïò˛Ãq/Ì»ˇ ≤øÒÆ|¯¸Ÿ¸ŒΩ¸≈÷§’Ô*êèÇﬁ‘G?
˚ª}©_ˆü¸û+ùó˛qÚÅØÆø∆⁄§Ëˆ‰•ö∞˚r}ó∏ˇ R±¸[ˇ s◊y¸„¸“µ¸∏–ﬂUò	.§>ù¥$˝π˝Ø¯Æ?∑'¸⁄uœü^iÛN£ÊùB]_XôÆ.Ê5fn√ˆQ¢Fø∞ãˆs—ÛçøÛçÌz—yØÕê“ÿQÌmdo∫‹NüÔØ˜‘M˝Á€›ˇ yÎlŸ≥fÕõ6lŸˇ’ıNlŸ≤'˘õ˘qß˛`ËÚh⁄ê‚O≈†U¢ê}â˛"Î˚iÁœ_;˘+QÚ^©6ã´«È‹Bv#Ï∫ü±,M˚Qøo¯¯’ó;ß¸„è¸‰à–V?+y™C˙?e∂πc_G¬è¸≥ˇ #ˇ ∫>œ˜_›{9UFC# A†É–ÉéÕõ6lŸ≥d#Õøù~QÚõòu]Jùz≈eq˛¥p	?ŸÒ»Tˇ Ûó˛Gà—ÍOuÉ˛kd¿Õˇ 9ì‰∞h#æ>˛ä’l√˛s+…d””æÛ≈?Í∂?˛á…>üÚ$’L]Á/ºåMóC˛x˘´è˛rﬂ»nhng_úˇ Ü≈ó˛r√»Tﬁ»>vÚˇ Õ%?Á)?/⁄ÉÙëÒÇ˙•ã'¸‰ﬂÂ˚~ïQ_fˇ ™XØ˝üê?ÍÌ¸ãõ˛©a&ªˇ 9k‰m6"ˆ≥Õ}%6Haa˜µ¿Ö3Ñ˛`ˇ Œ]˘èÃ≠t%]&’∂‰áúƒ∆r è˛y"ø¸Yú:yÁæòÀ3<” ’,ƒ≥3~&cùÉÚÎ˛q_Õk	u®(“¨Záú‡˙å?‚ªmü˛F˙YÈ_"ˇ Œ2y? °eí€Ùçÿ•eª£äˇ ë˜ˇ  œ˛^uX éB°E®† 1˘≥fÕõ6lÇ~{GÍy#YÚÈ!˚æ,˘ÕûŒˇ ú'óóñ/£˛[ˆ?|Pˇ LÙ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÛG¸Êˇ ¸r¥Ø˘àó˛ π‰,ıœ¸‚EØò¸πßÎ^[∏6◊˜PK$3í—;¥jÓROÔ!ÊÁ˛-Oı3œ~qÚ&µ‰€≥aØZΩ¥ªÒ,*ÆÌE*˛ÓEˇ Q≤I˘a˘ÁÊ/ÀŸXKÎÈı´⁄LIå◊©èˆ°Ú£ˇ fØû ¸¨¸¯Úˇ Êb+9>≠®ÅV¥òÄ˚u17Ÿù?‘¯øù:>lŸ≥fÕõ"_ôñ:OÊò⁄f¨îaVÜe‘âˇ û3·¸Ò˝ô?‡Y|˘ü˘I≠~]^˝SUèïªìË‹†>úÉ¸ì˚<MÒØ˘IÒ‚øñüú˛a¸ºö∫L‹Ì÷Kij—7ø±ø˘q27ÛrœK˘S˛s7ÀwÒ™ÎñÛÿOOà®ı£˙8Àˇ $r['¸ÂÂ˙'©˙H∑∞Çjˇ …¨Éyª˛sOE¥FèÀ∂s^OŸÁ§QÉ„@^Wˇ Wå_Îgô03ıœ?]˝w]ú»æúK≈=¢è˛7nR7Ì>L?"!oø1n÷ÚÏ4-˚Ÿ©C!`∑ÒoÁìÏ≈˛øœxize∂ïkÖåk¥8‘P*®¢®¡9·/˘ œ>7ô|€.üVœJW@:züjÂˇ ÷ı?uˇ <Wˇ Áø) ÛVß/òuhÑ∫~ú¿Få*≤N~!»~“@ü/Ûº_≥À=≠õ6lŸ≥fÕõ6ˇ÷ıNlŸ≥dÛÉÚM¸ ”~©w˚õËjmÆ@´#ŸoÁÖˇ ›ëˇ ≤_è<Áè"jﬁI‘_I÷·1Lª´uG^“¬ˇ ∂çˇ 6ø¯r˘Aˇ 9'≠˘SNπ_“aµ1ˇ .ÚÔƒ≈M ?ÂÙ˛÷z√…Ûê>PÛz™⁄^•ΩÀ∫.HâÎ¸´Ã˙rœ):"∞`MA‹óõ6÷5€u™\EkıyùQ‡úå‚~yˇ ú¡ÚŒã $’n@e¨pÉˇ d€˛y≈«¸ºÛüüøÁ"º›Á.PœtlÏ€oB÷±©ııdˇ g'Ú3õ€ZÕw*√nç,Æh™Ä≥Ï´π…U∑‰Ôún@h¥k‚‡õwÒ%-"¸Ó¬£Fª˙c#1¸äÛ∏˝wˇ "Œ'ˇ *GŒøıfΩˇ ë-à∑‰ÁúîTË∑Ùˇ òy?Êú/ÂWõ"°}¸W˛]•ˇ ö1¸∏Û2ö6ì|¸√Kˇ 4b‰çyE[Nª x¡'¸—â?îµÑö∆‰‹¬ˇ ÛN%˛‘ˇ Âí˘ﬂÛNiøó>d‘‰Yióíπ˛XüKq‚π÷¸èˇ 8wÊMañm~HÙªcBTë,ƒ{GÙ”˝úøÏ3“ﬂó_ë~XÚYt€a-Ë‹œGñø‰pá˛x¢g@Õõ6lŸ≥fÕõ"ú1|ù¨†©≠Ö«Oh€>mg∞ˇ Á•Æâ©≈¸∑Hﬂ|c˛iœHÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ5ˇ Œo%t}-¸.dzfxˇ >î~RÀÍ˘CFr)[o˘6òsÊ?,iæe¥m;Y∑éÍ’˙§Çªˇ 2ü¥è¸ÆüyCÛk˛q
˜KÁ©y1öÚ‘nm˛˘G¸RﬂÓıˇ #˚Ô¯Àûuˇ H”Æ?nò[›O–»Ís—üîüÛóóög3ŒÅÆÌÜÀvÇ≤Ø¸fO˜zˇ ó˝˜¸eœWËb”¸√höéë<wV≤}ô#5#¸¨?i‚\1Õõ6lŸ∞π†ÿk÷èßj∞%Õ¨¢çÇ†ˇ F≤ÀÒ.yõÛ˛p¿35ﬂìnBÉø’nI†ˆä‡W˝ä øÛ€8fø˘Á=	äﬁi7$⁄Ö=eˇ É∑ıW#È‰Ωq€ÇÈ˜eºW˛#íü/~@y€^`-¥©‚C˚w—P<È∑¸
∂wØÀo˘√[KKﬂ8N.›h~´DUˇ ãf<dó˝TXø÷|Ùççå%•§k(TDU@Ë™´≤å_
¸”ØEÂ˝*ÔWü˚ªH$ò˚R¸Ÿ}ú˘ç}{-ıƒów iù§vÒf<òˇ ¡g–œ»?(è+y7N≤e„<±â|yÕ˚ﬂã›í/ˆ–sfÕõ6lŸ≥fœˇ◊ıNlŸ≥f»Ôûø/¥o<Xù7]ÄMÂlÒ∑Û√'⁄Fˇ Öo€V\Ú7ÊG¸‚?ò|æœuÂÔ˜+c‘*–N£¸®∫Kˇ <~&ˇ }.pÎÎã	Z⁄Ú'ÜdŸíE*√˝eoàaæÅÁÌÀ‘˝®\⁄®˝òÂ`øÚ.º?·s†iÛïû|”ÄY/#∫Q⁄xPˇ √F"¯l:˘Ãﬂ92ÿ+0âÎ¯ÕLçkÛìû{’î°‘∫÷Ò§g˛Fı‰¶sçWYΩ’Â7:ïƒ∑3Ø+≥∑¸ñ8qÂÀ0˘æAÖc5»≠Ö§c˝yüåKÙæz»_ÛÖn‹n|ﬂyƒu6ˆªüì‹8˚˝8ˇ Á¶z'…ﬂó:ìbÙt(≠∂°p+#Ø3Úïˇ Ÿ>I3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ¸…ã’Ú∆≠^V#˛I>|Œœ\ŒK[b?ÂöOö…ˇ 4Áß3fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gõÁ7„ã•ˇ ÃSˇ ƒ3«πÙóÚ{˛PÌ˛`-ˇ ‰⁄‰ø6sèÕO»/˛bFeªèÍ⁄êK∏@∑A2˝ô”˝è˘3∆_öí^`¸ªòùJ/VƒöGu&6ﬁ?»ì˝á<%Ú'Ê>π‰køÆËW-	4Áﬁ9ÚÀ¯_˝o∂ø∞Àûæ¸©ˇ ú®–¸›¬√[„•Ím@∑Ód?ÒTÕ˝€˜‹ﬂÏdì;Ä äéô≥fÕõ6lŸ≥fÕõ8g¸Âˇ úçÂ1§∆‘üTïcßN2&ôø‡Ω(ˇ Á¶yÚ€ ÕÊØ1È˙([õÑWˇ å`ÛôøÿƒÆŸÙπ 
¢Ä
 2ÛfÕõ6lŸ≥fœˇ–ıNlŸ≥fÕõ
uˇ )iaè—÷,‡ªNÄMΩ?’,*øÏsôkﬂÛâæF’	hmÊ≤sﬁﬁVß¸ﬁ≤}Àê=W˛pzÕ…:fØ$c∞ö¯hﬁ¯Ü'¸‡ÌÒj6±_nƒ˝ﬁØ¸mí#˛páJàÉ©Íóé‚÷/¯g7“ºØˇ 8„‰è.ë$:z\Ãø∑tL«˛O‹ˇ ¿≈ù&#ÅP®H‘P*ä =Ä«ÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥f¬o:EÍËzÑ`Wï§‚ü8€>bg´ÁÊ¯5®´ﬁ’©ˇ #∆zü6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6yÀ˛smÚ˛ú›≈·|oû8œ§?ì[…ö)?Ú√oˇ \ôÊÕâ]⁄Cy[]"ÀÄ´£Ä ¿˛À+|,3ÕüõÛáˆ∑¸ı/%0∂úÓl‰?ªcˇ HwÑˇ ê¸¢ˇ *%œ+yáÀZóó.€N÷-‰µ∫N©"–ˇ ¨ø≤È¸ÆügB¸∞ˇ úçÛ'ë8Z˙ü_”o´NI‚?‚âæ‹?Í¸q≈yÎ?À˘»_+˘‰$OıKˆÎmpB±?ÒSˇ w7˚Áˇ ÆtÃŸ≥fÕõ6lŸ±À»l°íÍÈ÷("RÓÏh™™933vUÛÎÛÔÛP˛byÖÔmÍ4ÎaË⁄©ÿî≠3Êôæ/ı=4˝åÍÛÖ˛@yÔnºﬂrîä6÷‰éÆ€ŒÎˇ „„¸ˆoÂœ\fÕõ6lŸ≥fÕõ?ˇ—ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6 Û~¶ùtùyA €›[>]g®øÁ%"ÁZè±Kc˜øÆzÀ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6yœ˛so˛QÌ;˛cO¸õì<oüH%øÂ—Ê¯Ç‰œ6lŸ∞ÉŒ^C—|ÂhluÎTπã~%Ö	˝®•_ﬁFﬂÍ∂y[Û7˛pÛT“ãﬁ˘FCj*~Ø!:èoÜ9ˇ ‰õˇ ê˘ÁÀ˝>ÁMù≠obx.#4dëJ≤üÚïæ!ù'»?ÛínÚpX#π˙ÌöÌË]U¿À_Z?ı}N‰gÚè¸Êoó5±Î÷Ûi”mVQÎEˇ úfˇ í9‘ÙèŒ/'ÍÍœW≥jˆyï˛cˇ ¬·Ì∑ötõ≠≠Ôm‰ØN£ƒ[ï√éJA∏ÀÕõ6lN‚‚;h⁄y›cä5,ÃƒP7ff;*åÒg¸‰o¸‰Cy≈ﬂÀû^r∫,m˚…EA∏e?Ö≤∑ÿ_˜g˜è˚ú√Ú√Ú€Q¸¡÷#—Ù‡U>‘ÛUä:¸R7øÏ∆ü∂ˇ }Úüï¨|´¶[Ë∫Zzv∂»Gs›ùœÌ<è…›øõ≥fÕõ6lŸ≥fÕüˇ“ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6!~º≠Â_a¯gÀ64œLˇ Œ…MOVè∆M~Lˇ ÛVzÎ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6y”˛siO¯wOn¬ˆüÚJLÒ∂}¸ìê?í¥R?Âä˜(\öÊÕõ6lŸÛßÂ∂ÅÁX}zŒ;ÇJqë„…∆Eˇ WóÛ∑û?Á
eR”˘N¯2ÓD{í‹D(ﬂÏ‚_ıÛày£Ú_ÕﬁY'Ùñôp#_˜dkÍ«ˇ #`ı≤»[°BUÅuÉÙ˝Q”O+©†#ºR2ƒ…∂áˇ 9ÁùèCUûU≥=&˛Gâ˛:ïˇ Á65kr±Î˙|7I–ºbüıëø‰ûvø&ŒMy3ÃÂb˙ﬂ‘.ZÉ”ªûÁ¬j¥ÚW:úR§»$çÉ#
ÇA«	|ﬂÁm#…ˆM©kó	m÷úèƒƒ~ƒQèéGˇ %3≈_ùﬂÛëöèÊ∂õßÜ≥—⁄*¸r”£‹≤ˆ˛XW‡_⁄ıãdÚÔÚÁVÛˆ¶∫Nç&Î$≠Pë'˚ÚVÌ˛J˝ß˚)û˝¸Ø¸∞”?.Ù•“Ù¡ F£O;éWß€oÂQ˛Îè˝÷øÂrfóÊÕõ6lŸ≥fÕõ6ˇ”ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ66P¡>X‹
J‡t^z?˛pâø‹÷¶?Â’?‚yÏŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÁo˘Õü˘F¨?Ê8…©s∆ôÙoÚ3˛Pç˛`„˝Y9Õõ6lŸ≥fÕÖ˜˛]”u[€X''˝˘ø¸MN^~UyNR}¡´ˇ .—É˜Ñ»÷©ˇ 8’‰-DzZD«º/$t˙¯¬‰_ˇ ú*Úı–-§_]Z9Ë$„*¢ê…ˇ %3ì˘≥˛qÕ⁄8it”ßﬁë7	?‰T‹W˛WŒ9≠yP–ß6ö≠¥∂≥èÿô
π∆ySÛ;ÃûRt=B{hœ˚¨7$˘˙2sãó˘\0ØÃ>g‘¸«rouõônÓ‹ÂbƒÂZ˝Öˇ %~Ëî?ÛèÁÊâw"õ-"£ïÃãªèhœ˜ß¸øÓó˘øc=∑‰_ iG”◊J–·D7v;ºç˛¸ôˇ mˇ ·WÏ¢™‰ã6lŸ≥fÕõ6lŸ≥gˇ‘ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6l˘g®ˇ Ω2ˇ ÆﬂØ=ˇ 8Iˇ )£ˇ 0_Û2<ˆ>lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lÛ∑¸Êœ¸£VÛ?‰‘π„L˙7˘ˇ (Fçˇ 0q˛¨úÊÕõ6lŸ≥fÕõ6lÿ_ÆywN◊≠Õû≠m‹ˆ%@„ËÂˆO˘C8ÁòÁ<ù©ÕÎŸ5ÕÖMJC d˙Î+Ø¸˘/˛qs…æXïnö‘.p◊lAÒ™«¸>u¥EEÄÄÄeÊÕõ6lŸ≥fÕõ6lŸˇ’ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6cû	÷Áº˝Ø*ÈÎ*≥˚π‚=OÉHçˇ ùS˛q;Ú◊Ã>S◊/Á◊le¥çÌB+H>oQZäÎUËπÍ,Ÿ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸÁ_˘Õ¶·Ω={õÍ˝—Kû5œ£øëËS…:0?Ú≈˚÷π7Õõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕüˇ÷ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœ8ˇ Œm∏úΩÕ·?toû9œ§?ì
W…ö(?Ú√oˇ \ôÊÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fœˇ◊ıNlŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fŒ3ˇ 97˛˝g˛4˙Á£Î?°ı><πÒ¯πzøŸÒœ˘í€ BØ†\Í'¬;´hGﬂ4G˛°ÛËÂ?ß˛—˝±ıjW˛1¶J≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥fÕõ6lŸ≥gˇŸ                                                                                                                                                                                                                                                                                                                      root/go1.4/doc/gopher/appenginegophercolor.jpg                                                      0100644 0000000 0000000 00000474347 12600426226 020050  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ˇÿˇ‡ JFIF ÑÑ  ˇ·ŒExif  MM *                  b       j(       1       r2       êái       §   – âT,  ' âT,  'Adobe Photoshop CS2 Macintosh 2011:06:14 15:06:23  †       †      ó†      Ö                          &(             .      ò       H      H   ˇÿˇ‡ JFIF   H H  ˇÌ Adobe_CM ˇÓ Adobe dÄ   ˇ€ Ñ 			
ˇ¿  e †" ˇ›  
ˇƒ?          	
         	
 3 !1AQa"qÅ2ë°±B#$R¡b34rÇ—C%íS·Òcs5¢≤É&DìTdE¬£t6“U‚eÚ≥Ñ√”u„ÛF'î§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ7GWgwáóß∑«◊Á˜ 5 !1AQaq"2Åë°±B#¡R—3$b·rÇíCScs4Ò%¢≤É&5¬“DìT£dEU6te‚Ú≥Ñ√”u„ÛFî§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ'7GWgwáóß∑«ˇ⁄   ? ıTíI%)$íIJI%W®ı<óår≥Ôn= ¿sπs†ñ◊S6]kˆ˚)©æ≠â)=◊UEO∫˜∂™ji}ñ<Üµ≠h‹˜ΩÓˆµçjÂ≥æ∫Ÿ≥°cãk?˜°óπî£Ó≈«n‹ºÔiøıl_˚∂≤∫üR»Î∂≤¸⁄Mu˚±zu∞H=≤∫ç~Í›ì˛áÙåƒˇ 	˙œÛ$∏ó8íO$ÍU|ú≈á¯ﬂ¡±èãü¯´ﬂì÷rÑeı|«Î;qÕxç˛®˚-i€˝l∑¨˛°Åág£vCîÊ‰P◊;*À2Ikﬂˆw4˝≤À˝ø•W’n£¶»‰>í>"ÍKT‰…#ˆ≥p@QcÙÄd`–√‚∆
œ˘‘˙nG™´q∂ú<ÃÃCYñzy6Ωì¸¨l◊Â‚ÿﬂ‰:îW}#Ò)êê⁄GÌIÑNÒc•áı≥ØbÌfeıJÜ–m†˝õ"#ﬁ˜cd9¯w?˙ô∏øÒKs•˝kË˝Nˆb1Ô≈Œ{w,¶:õånsΩ!gËÚv5é{˛…mÏ\äçµ◊u~ïÕW!¡¶D8}+{aÙ‹œÃ∫Ø“±KbCÊ_õπxüóO…ÙÑó#ıwÎ¯œoMÎWzµ8Ì¡Ív@.ü°á‘H⁄∆f‹|ØÊzá¸oËÆÎï®»HX6“ââ¢)I$í(RI$íüˇ–ıTíI%)$ñ&g÷ºsÉáèì’r™vÃäkı$œ∑'"«”âK˝üÕæˇ W˘	)'÷.Ω˚"ök¢°ëüò‚ÃjÌçÜ˜‰ﬁˇ sôçåœÁ=6Yfˇ Jöˇ ù\SÔÃÃÍ÷‰ı˛◊ïEUúgÜ
Î•∑:ˇ YòtK˝-˛ã+~Eñ[ómlÙÏª”˝±◊zù˘?Yh9xYò"ÏCFY¨¥πØ9=FŸ∆ø!å˝zø˘
Ö˜∫æ£∑≥ïêhŸupoßÔb€ï{ˇ Gé«∂Ãü˚∞ˇ g•Eä∂y»»√aMú0èûÊ€©ˆ?nÌßoÔv˚÷n[≠«´÷ÍΩMò∏µ‚ÅY03'!∑Ád;ˇ 
—é°ˆú˜ãFÍ9ªÜôaÂd¥èﬁúÕˇ Ù)PàµüÓãe3zﬁ4‹≥®Ù⁄é€sq´p¸◊]X?ÊÔ‹©uµ—ùàˆ∑:áªuNk˜≤⁄¨?F5äﬁ›.«>Æû)eî»∂ÜT)µëÙΩLg◊MÏ˛ø¶Æ≠=√‡HC@uO¢u#B5˙πÓÎ›qåÍàìØ∫?Í∑ÆtG˝°çÛ∞7ˇ >mZ≠ƒ¿{â>eπyYwŸã”±ÔÍπ5Hµîñä´pˇ ëõêÊb’o¸Îmˇ ÉH#B$˝ÙZôÙˇ –ñ£'#LkÈº¯Uc,?¯úäÊπ¶>D<ü´z⁄˝[æÆadºèÊŒE&ﬂ˚rÃFWˇ É,}ÿÿYn¿∂é£–2´c≠5˚Æ«ÿŸı.øÌ∏÷„◊∑ﬂutWK?”'ú2˝/˙+Xû£˛è˝'J÷≥'/–±≠≥ªÓ≠‡9Ø≤–ÊQUåtµÏ™èV˜1ﬂüv*ÿ˙π’nÈY∏ù5ˆπ˝/(˝õªNÁc‹˚qÎ™˚´f%ı’e5’w´ez◊g£gËj∫‹oÕs.∆…∞€˚Nç+õ 1˘tÓ≥ÏÙmk(ß+€Ò?ôı}>≠fEXı◊çSÏÕ∑"ñamÿröˆ‰a_{Î≠ïæÍ}?˙	cî£8Å±”ÕY"%{ç|üRIsﬂÛ´'≠≥ÆÙåÆóé„µŸ[™…¢Ω>ñK¨∂‹z˜{=W—È~˝ã}ècÿ◊±¡ÃpÆAá4´≠6I$íJˇ—ıTíI%8ˇ [∫≠Ω#Íﬁ~}2+Øf9hãmsq±ﬂñ˚.∫∑˚ñg\Í¯_‚˚Í∆/°åÏ∆µÌ«cwl/±Õ}∂‰‰]≤œ“[ÈŸk˝ü§µmı˛ëW[ËŸ}.◊l5ÌeúÏx" -⁄wzW2ª>í„˛µ˝d¬ ˙Øü“:Ó=tuÍÎcFßkmémıõsŒ€q⁄˜∫ÔÁ=ZôU’‰ˇ ÑINK˙∂oTxÎñV⁄zèX«È‘8á∑õ≠/$∂∑Z∆Ìª®‰¶˝RîˆF-∏},Éê¬“ÁÿCÌ~NQŸà◊Ô˛ì’:ïø§˝/Ë±±+≥* ˛œV>5≥ƒ˚-ùUÌ«±∂bÙÏj±jun`6>Ú◊÷\›Ì«ƒ≈b—Ë’=ô?T€g™ø7´‰CÆu∞˛úˇ Eƒ Ù´ˇ ¬Í¨#ÓLôl=Dy¸üÛ[3ó∑ #‰óÃÓ˝T˙õã—+ôé˝r‡N}û˜¶úGYÓ¶ÜÓŸÌŸÎÖˇ U]"I+Mg3≠}^Èùj∂å∂‰U'2£≤˙]˚Ù^ﬂs‚ˇ ö¯J◊¡ïM˘?:>›ÇÀû÷Ìm¨xﬂçõSGµ≠…¨~í∂ˇ 3{-≠qÕ˙—ıÁÎO÷ôõu?}îa’£SY^Î}=Æ}4⁄Ê≥È>ﬂÁ¬.™é•XØ°uº¢nN £(∑@Ô≤d‘ n,o±Æ±ÔªÛ¬®≥¿÷,∏$D¿È&√q≤:óP∆Ëÿ∂:áÂá€ïë\oßΩ≠πın˙‰€ex¥[≤œKÙ∂/A¿¿√È∏u`‡“‹|Z∂™ô¿ˇ YŒsΩˆ=ﬁ˚Ôz‰~®ÁF`|zÁß–iÒÙ≈Ÿ>ø˛È.Ÿ, ˜‘£4âô¥
Y}_§uö›“≤m` d[Oß`nM7›Nf1iı®∂ß{ôg˛äR˙«vu®›”¡9ï„ZÍ6âpxcã\∆Î∫∆˛cWœ>∫≠Ø3®€‘˛«üÜ~+Hy∂˚K˝ﬁïıˇ 5mŒ˙üOˇ ∂©XﬂO~=ò∏ñuZ*≥'ˆ_«kZ⁄=WlÆûµçSΩ6◊Vk/∆~uU’ËﬂNO≠Èz∏€Ìßˆ6Ìø°XÁ2ã™6`XI.≠≠swcÔ˙‰ÃØ≥›ç˘ˇ d≥”ˇ  ∂p* œˇ ùïÁ4◊ëì”põòÜ∑)ÿV}ß`˙´kÒ÷&NL‡tŒ´o“≠¯÷‹‡éÃ™∆6V÷∞9Ó˛í«Ìc¡™Ÿ„R~ó˝(¸≠å2∏êG˛â˘ù?®ˇ _˙ﬂ^ÎóÙ≥áQ€S√ﬂK6öœßh mñZœNœ°Ìˇ ˇ ∫o©Ã≥?•8Õ=+:‹\IsûF9mYòµπˆ?Ùe˝ü˙ï.?†˝iƒË£™}èß›ìï‘söÍ≥NßmÉäæŸôkuuWïnO∑—≥Èˇ √.ÛÍˇ HJ¡s/∞_õïkÚ≥ØlÜæ˚LÿX◊}
´he∑˝LV"l¡!DáM$íEˇ“ıTíI%)p_Y∞Ÿâıá&¸∆≥Ï›Qî{nÙ˝Z[e·Ô∑Ë⁄Í›UÙ÷ÔÁˇ OÈ4ª’«}yknÍ}'‡€(Ù≥.4º1œh«∆f˙ﬂπØŸVfBfP%kÒ&)Á∞+ÆÆ•‘™ÿ⁄ôÍc;k hÿÏv2Z÷C~ïv≠¨/¥‰}QÈ9ÿ5˙ΩSÍΩÇªqkáΩˇ fk∫~~#>ìõf^æ—èÌﬁˇ ’ñÒÒzS˛›çKi≈Ÿ≥>™Y¿KÍŒmU˝'aπ÷}£c°⁄ˇ ˚é¥Û≥zvAŒÈ¶ª{YÎP˜E9h˝ç»¨YË‰z^ 2ö€i∂ØNªŸÏ™⁄´‚»#-~Y /∆,˘qôGM‚IØ	=ﬂOÍ]K
ú¸[ëãê›ıZﬁ„øπØkΩñVˇ }o˝ä¬Û˚z◊L≈»∑®‡d‰˝\Ã»∞Ÿóâïä¸åÏ€Ôπﬂcı1Î∂ËØ‘Ã√Õ™À=?”’eämˇ }OÏ±N6SÀé0üô¥üÖΩ3“Ø˛ªö≠q
ªÊ÷·7Tm≥’ˇ ≈W’<¸˚zùŒø‘&€Î™∆∂¢dæ€Í◊cÎﬂ˘˚,gˆ=ï‘˙9G®1Ï¿ÈT–ﬁü—ÎqvÁ„‘„fFc)i∫€ìï¸›˚w€U•ﬂ§±?®˝eÎ_g£¨˙gÌvlƒËGhΩÌ›fÓ°ñ]cùãç_È2ôS˛Õ¸◊¯D∫Ô¯•ÎU¨Œ=Gˆëk¸q[´∆cZ÷±µcÿﬂZÌïGÁ”˙_¯√˙¡@˙zÀˆEx˝Y≤=]#˚dãÎ/OO©túëóïâπóa∞[ëçf”ìF;2OØëK´f^5,È,Ø”ˇ Ω7ßu©á^wOππ◊Ã±áOÍ∏}&=øü[ˇ I_ÁØ,Ëﬂ‚W©71∂un°UTVCáÿãùi ˛mó’K(ˇ åŸwıáPÈ]O°uÜ4Êø+®^≠à—[r,`/˚7WÈŒ›ÅvWÈl~=ü£˚W¸r@{c©àˇ *'‹=èŸ'”1’˙o‘Óáê:√˙mÍñªı:k`6›x!’˝ó{=SgÎ´Ù_ŒÿıÃ˛’˙¸ÀClÍµ‰–ﬂ•ÈWN=Ó˛∑Øáóè_ˆp2˙Üüj£ΩJ¡≤Ó•üìoP»5ÀüÈ’[)¿¶ñ{ˇ ö¢Ïj‡“˜±ÔƒÌd˝◊W9∑ÙO™Ÿ8ŸV6œ¨Xüis]h»nÀ}9fIƒk?I¸ﬂ£ã˛íÂœuSçã”ÍfÒM»√©èyk.•Õs‹~é hV‚«]nveÓ À}a∑Ê_µëS‚ ÿ›ò¯XçèV∆Wˇ ìmﬂMT≈∏gÂ}≠í1púYäsMñŸ[¸◊1¡ø†˚&CÅ˛ëó›ï˛âW…ìåÇ¶õc> A˘§ Ã¨>±}+*ºúú‹äCYS€f÷Wmyô6Ω¡€Ècc\ˇ ßæœk‘óû`›ÈuÓçeÆÙÒk»∑{ˇ 4[e6b·±ˇ ªÎ?"÷6œÙæù_·ó°©πp84ÍXsì«Ø@§íILƒˇ ˇ”ıTíI%)rü^ikoËŸÑ¡nE∏ø,ä.pˇ ¡±h]ZÁ>ºÿ¡”1),ﬂe˘¯¢£D◊g€-≥˚8∏π	≥˘%‰WCÊèòy¿KHp0F†Ñ>è–zûUŸˇ ±›EXxñW[pÔ‹*u÷5πyáÍ∑ŸÄ÷WëOËM¯ﬁ∑´˙
ëˇ ‘8n/U¨à{zïÆqÓEï„‰RÔ˚b⁄Íˇ ≠™∏"%"¢∂mgëåA›∆oN˙ …ûçê◊èÙYÆi˛≠è»«≥¸ÍèG’ˇ ≠Y†zïQ”d‰XrÌ{\Ã\oKÈ~˛uüÒkπIN0cÎÒ`9ÚVÔ'o‘˚zvNWÈ9ùS	÷˙ˇ l≥o⁄jπ•Æ«ıj©ÃƒÙ=übÆä+∆´¸'Û∂ÿüßuˇ ≠˝{π}/ßa`TÁπÇ‹Ãáﬂª”s®øf>U˝´{}˘>ı’Æ#Íw÷è—~™—á’2Îß®‚Ÿ{20É≤EØ»µﬁã1ª"◊π÷˚=:‘†VÃDﬁÈ˙?[˙Òô“)ÎN«Èô8óPo1˜„›†sΩ6πÏŒ©Œˆˇ !ßÂ}nwOÍ›sæî‹_ß5Á ÿ¸ñ?ö˚i«≠æÜ;ˇ W¶™ˇ û≥÷ıˇ GZ´ıwÎ7FÈTÈÈ›B„è‘∫}´˙mÕ5‰∫¬%ïQçf€2=mÏÙ_Nˆ{◊Iık¸?´Ω3%•ó—âEv∞Ú◊∂∂5Ï“~ÉΩ©)«»˙éÊ8ó‘≠«Æ£Â∞fV Ueè£=ü⁄Œ±S?T˛¥Ì4≤ú5‰Ò_hw˛~]≤IáÒ∆Iç§^gÍF>ÒgY»=Oi%∏ª8ÉVñ9¯çuØ…{6ˇ ⁄‹åñ¡¨~µU∏ˇ YzïvànXß7Î´uÙ¸Å?Gu6‚”øˇ “ªÂ«}v◊≠tpﬁ[Ni≥…Ñb∑›ˇ _ÙSr¿{dU™ÏR>‡$›ËÛ˝]°›®5¬GŸo0|[[Ïo˝65zf-é∑õ_£¨c\Ôâ ïÊ˘XÔÕm]*£uK#HÇ[[Å~u€\[ª–¡eÔˇ åÙó¶   @o,=$˜+πÉÍ¡tíIN¿ˇ ˇ‘Ωâ‘∫ãzÊ/YÀy=AŸåÈùFñ{j™ß=¯üce[Ïk´ß3#6¨ãÍ›Îzø£™ÔEz:Â~∂}Wø6«ÁtÍõs≤+ÍÅ¬ó‹+˜bÂ„d˝
∫Ü⁄ﬂM◊~é⁄øF˚+Ù)YO¡˙Á‘ﬁ)¥u5ªÅ9y¯4	·–ZÏÃø›ˇ Bò¢H  Õ∆ª~ÍÚ# ":Q˛/~∏O¨Yıı.æE.ctv;9¶AÀªo⁄ƒám›áä⁄Ë˛Eôó‘™®=m„m∏ò≥˜,œœ{Ìª™∂ø˙+[Í>a§779∏,häÒ:]u∂∂{úÔÈîﬁ˚∑Óˇ èáÔˇ õ>9Î"?ÓxóCÇ$HÀä∫Dﬂp∏y9L«ÙXo  x´§5˜XL1œˆUS√‰Ÿ˙*?„?Dª´}˝'ßzymôπ/9∂3v√s√[∂üS‹⁄(©ïcQˇ O˙Eœıﬂ´ÿ]#£ªŸmÔÎ8»ÀΩÊÀ¨Ê¶∂À4˝=O——S+¢øu.’XÑy®ÀîÃˆàRI$§cR	ƒ≈9#,”Y…kvˆèP7˜=Xﬂµ$îƒ±ÖÕqh.lÌ$j'ù™I$íîíI$•.Îã˛∂eá∑kÍ¬∆m ù]Q≥%˘1üπÎ˙[˝Jøêªµçı´¶afÙåãÔØıå*nª!Ñ≤⁄û„æõôÔg—nˆ5o¯fXõí<Q1∫µ–óÑ™ÈÊ:N~'KÎïÁı F#Ò˛ Ã©%òˆ>œR€2ô˛å∂∑ø∂ˇ 7èˆNˇ Jª}Eﬂ1Ï±ç≤∑±‡9ÆiêA’ÆkÇÛúlNπOH¡Íô9ÿŸx‘‰?'∏∫ß\÷=Ã»¿´wØK}_È>˝üŒ·ÖM—:´∞.}_»∆ø¿}^ôÍ≈.'ﬁ/ƒÙEˆt¸èwÈ™f/ŸÔ¸˙)ªÙ™(L„®LPÈ!Ú≤Œ% œXı{n∑÷ô“Í≠ï◊ˆúÏ¢[âäi{Ño}è?Õc”πæΩﬂ˙: ´”æ∞un≠]]B˚˙ΩÕkŸÉSj˚5N‹}Zzé-u]fÕ˝£/©~“ª˛—÷ñ>W÷/¨/ß=˚™uO≥ohØ≤É“*»pıjfu÷_ìíˇ ’Ú2´™ˇ Iî”ÈÆ˚ñ„‚RÃzÙ*©°å’cZ•å∏¨˛èËˇ )GÜáÈ~ìˇ’ıTó ©$ßÍ§ó ©$ßÈ/¨ø≥˝∑˙ªh‚zéŸı˝V}õ’ı?Ì?©¸˛œ“zÕ≠ÖÚ™I)˙©%Ú™I)˙©%Ú™I)˙©%Ú™I)˙©%Ú™I)˙©RÎaß£gá÷úk•¿n lvªw3w˘ÎÊ$íSÙØ’Hˇ ö˝i%øa∆ÇDÙkÌ™©÷ˇ Ê'©oÌœŸææﬂ“}ß—ı¢;o˝c~œ°≥Ùü∏æuI%?I˝Wˇ õø≤ˇ Ïwgÿ˝G˙õwoı¥ı~’ˆè÷æ”Ù?•~õ”Ùø¡˙k]|™íJˇŸˇÌ6FPhotoshop 3.0 8BIM         8BIM%     FÚâ&∏V⁄∞ú°∞ßêw8BIMÍ     <?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.print.PageFormat.PMHorizontalRes</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMHorizontalRes</key>
				<real>72</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMOrientation</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMOrientation</key>
				<integer>1</integer>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMScaling</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMScaling</key>
				<real>1</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMVerticalRes</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMVerticalRes</key>
				<real>72</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.PageFormat.PMVerticalScaling</key>
	<dict>
		<key>com.apple.print.ticket.creator</key>
		<string>com.apple.jobticket</string>
		<key>com.apple.print.ticket.itemArray</key>
		<array>
			<dict>
				<key>com.apple.print.PageFormat.PMVerticalScaling</key>
				<real>1</real>
				<key>com.apple.print.ticket.stateFlag</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>com.apple.print.subTicket.paper_info_ticket</key>
	<dict>
		<key>PMPPDPaperCodeName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>PMPPDPaperCodeName</key>
					<string>Letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>PMTiogaPaperName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>PMTiogaPaperName</key>
					<string>na-letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PageFormat.PMAdjustedPageRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PageFormat.PMAdjustedPageRect</key>
					<array>
						<integer>0</integer>
						<integer>0</integer>
						<real>734</real>
						<real>576</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PageFormat.PMAdjustedPaperRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PageFormat.PMAdjustedPaperRect</key>
					<array>
						<real>-18</real>
						<real>-18</real>
						<real>774</real>
						<real>594</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.PMPaperName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.PMPaperName</key>
					<string>na-letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
					<array>
						<integer>0</integer>
						<integer>0</integer>
						<real>734</real>
						<real>576</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
					<array>
						<real>-18</real>
						<real>-18</real>
						<real>774</real>
						<real>594</real>
					</array>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
		<dict>
			<key>com.apple.print.ticket.creator</key>
			<string>com.apple.jobticket</string>
			<key>com.apple.print.ticket.itemArray</key>
			<array>
				<dict>
					<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
					<string>US Letter</string>
					<key>com.apple.print.ticket.stateFlag</key>
					<integer>0</integer>
				</dict>
			</array>
		</dict>
		<key>com.apple.print.ticket.APIVersion</key>
		<string>00.20</string>
		<key>com.apple.print.ticket.type</key>
		<string>com.apple.print.PaperInfoTicket</string>
	</dict>
	<key>com.apple.print.ticket.APIVersion</key>
	<string>00.20</string>
	<key>com.apple.print.ticket.type</key>
	<string>com.apple.print.PageFormatTicket</string>
</dict>
</plist>
8BIMÈ     x    H H    ﬁ@ˇÓˇÓRg(¸    H H    ÿ(    d       ˇ              h ê                                8BIMÌ     Éˇ}  Éˇ}  8BIM&               ?Ä  8BIM        8BIM        8BIMÛ     	         8BIM
       8BIM'     
        8BIMı     H /ff  lff       /ff  °ôö       2    Z         5    -        8BIM¯     p  ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇË    ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇË    ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇË    ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇË  8BIM          @  @    8BIM         8BIM    _             Ö  ó    a p p e n g i n e g o p h e r c o l o r 1                                ó  Ö                                            null      boundsObjc         Rct1       Top long        Leftlong        Btomlong  Ö    Rghtlong  ó   slicesVlLs   Objc        slice      sliceIDlong       groupIDlong       originenum   ESliceOrigin   autoGenerated    Typeenum   
ESliceType    Img    boundsObjc         Rct1       Top long        Leftlong        Btomlong  Ö    Rghtlong  ó   urlTEXT         nullTEXT         MsgeTEXT        altTagTEXT        cellTextIsHTMLbool   cellTextTEXT        	horzAlignenum   ESliceHorzAlign   default   	vertAlignenum   ESliceVertAlign   default   bgColorTypeenum   ESliceBGColorType    None   	topOutsetlong       
leftOutsetlong       bottomOutsetlong       rightOutsetlong     8BIM(        ?      8BIM        8BIM    ¥      †   e  ‡  Ω`  ò  ˇÿˇ‡ JFIF   H H  ˇÌ Adobe_CM ˇÓ Adobe dÄ   ˇ€ Ñ 			
ˇ¿  e †" ˇ›  
ˇƒ?          	
         	
 3 !1AQa"qÅ2ë°±B#$R¡b34rÇ—C%íS·Òcs5¢≤É&DìTdE¬£t6“U‚eÚ≥Ñ√”u„ÛF'î§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ7GWgwáóß∑«◊Á˜ 5 !1AQaq"2Åë°±B#¡R—3$b·rÇíCScs4Ò%¢≤É&5¬“DìT£dEU6te‚Ú≥Ñ√”u„ÛFî§Ö¥ïƒ‘‰Ù•µ≈’ÂıVfvÜñ¶∂∆÷Êˆ'7GWgwáóß∑«ˇ⁄   ? ıTíI%)$íIJI%W®ı<óår≥Ôn= ¿sπs†ñ◊S6]kˆ˚)©æ≠â)=◊UEO∫˜∂™ji}ñ<Üµ≠h‹˜ΩÓˆµçjÂ≥æ∫Ÿ≥°cãk?˜°óπî£Ó≈«n‹ºÔiøıl_˚∂≤∫üR»Î∂≤¸⁄Mu˚±zu∞H=≤∫ç~Í›ì˛áÙåƒˇ 	˙œÛ$∏ó8íO$ÍU|ú≈á¯ﬂ¡±èãü¯´ﬂì÷rÑeı|«Î;qÕxç˛®˚-i€˝l∑¨˛°Åág£vCîÊ‰P◊;*À2Ikﬂˆw4˝≤À˝ø•W’n£¶»‰>í>"ÍKT‰…#ˆ≥p@QcÙÄd`–√‚∆
œ˘‘˙nG™´q∂ú<ÃÃCYñzy6Ωì¸¨l◊Â‚ÿﬂ‰:îW}#Ò)êê⁄GÌIÑNÒc•áı≥ØbÌfeıJÜ–m†˝õ"#ﬁ˜cd9¯w?˙ô∏øÒKs•˝kË˝Nˆb1Ô≈Œ{w,¶:õånsΩ!gËÚv5é{˛…mÏ\äçµ◊u~ïÕW!¡¶D8}+{aÙ‹œÃ∫Ø“±KbCÊ_õπxüóO…ÙÑó#ıwÎ¯œoMÎWzµ8Ì¡Ív@.ü°á‘H⁄∆f‹|ØÊzá¸oËÆÎï®»HX6“ââ¢)I$í(RI$íüˇ–ıTíI%)$ñ&g÷ºsÉáèì’r™vÃäkı$œ∑'"«”âK˝üÕæˇ W˘	)'÷.Ω˚"ök¢°ëüò‚ÃjÌçÜ˜‰ﬁˇ sôçåœÁ=6Yfˇ Jöˇ ù\SÔÃÃÍ÷‰ı˛◊ïEUúgÜ
Î•∑:ˇ YòtK˝-˛ã+~Eñ[ómlÙÏª”˝±◊zù˘?Yh9xYò"ÏCFY¨¥πØ9=FŸ∆ø!å˝zø˘
Ö˜∫æ£∑≥ïêhŸupoßÔb€ï{ˇ Gé«∂Ãü˚∞ˇ g•Eä∂y»»√aMú0èûÊ€©ˆ?nÌßoÔv˚÷n[≠«´÷ÍΩMò∏µ‚ÅY03'!∑Ád;ˇ 
—é°ˆú˜ãFÍ9ªÜôaÂd¥èﬁúÕˇ Ù)PàµüÓãe3zﬁ4‹≥®Ù⁄é€sq´p¸◊]X?ÊÔ‹©uµ—ùàˆ∑:áªuNk˜≤⁄¨?F5äﬁ›.«>Æû)eî»∂ÜT)µëÙΩLg◊MÏ˛ø¶Æ≠=√‡HC@uO¢u#B5˙πÓÎ›qåÍàìØ∫?Í∑ÆtG˝°çÛ∞7ˇ >mZ≠ƒ¿{â>eπyYwŸã”±ÔÍπ5Hµîñä´pˇ ëõêÊb’o¸Îmˇ ÉH#B$˝ÙZôÙˇ –ñ£'#LkÈº¯Uc,?¯úäÊπ¶>D<ü´z⁄˝[æÆadºèÊŒE&ﬂ˚rÃFWˇ É,}ÿÿYn¿∂é£–2´c≠5˚Æ«ÿŸı.øÌ∏÷„◊∑ﬂutWK?”'ú2˝/˙+Xû£˛è˝'J÷≥'/–±≠≥ªÓ≠‡9Ø≤–ÊQUåtµÏ™èV˜1ﬂüv*ÿ˙π’nÈY∏ù5ˆπ˝/(˝õªNÁc‹˚qÎ™˚´f%ı’e5’w´ez◊g£gËj∫‹oÕs.∆…∞€˚Nç+õ 1˘tÓ≥ÏÙmk(ß+€Ò?ôı}>≠fEXı◊çSÏÕ∑"ñamÿröˆ‰a_{Î≠ïæÍ}?˙	cî£8Å±”ÕY"%{ç|üRIsﬂÛ´'≠≥ÆÙåÆóé„µŸ[™…¢Ω>ñK¨∂‹z˜{=W—È~˝ã}ècÿ◊±¡ÃpÆAá4´≠6I$íJˇ—ıTíI%8ˇ [∫≠Ω#Íﬁ~}2+Øf9hãmsq±ﬂñ˚.∫∑˚ñg\Í¯_‚˚Í∆/°åÏ∆µÌ«cwl/±Õ}∂‰‰]≤œ“[ÈŸk˝ü§µmı˛ëW[ËŸ}.◊l5ÌeúÏx" -⁄wzW2ª>í„˛µ˝d¬ ˙Øü“:Ó=tuÍÎcFßkmémıõsŒ€q⁄˜∫ÔÁ=ZôU’‰ˇ ÑINK˙∂oTxÎñV⁄zèX«È‘8á∑õ≠/$∂∑Z∆Ìª®‰¶˝RîˆF-∏},Éê¬“ÁÿCÌ~NQŸà◊Ô˛ì’:ïø§˝/Ë±±+≥* ˛œV>5≥ƒ˚-ùUÌ«±∂bÙÏj±jun`6>Ú◊÷\›Ì«ƒ≈b—Ë’=ô?T€g™ø7´‰CÆu∞˛úˇ Eƒ Ù´ˇ ¬Í¨#ÓLôl=Dy¸üÛ[3ó∑ #‰óÃÓ˝T˙õã—+ôé˝r‡N}û˜¶úGYÓ¶ÜÓŸÌŸÎÖˇ U]"I+Mg3≠}^Èùj∂å∂‰U'2£≤˙]˚Ù^ﬂs‚ˇ ö¯J◊¡ïM˘?:>›ÇÀû÷Ìm¨xﬂçõSGµ≠…¨~í∂ˇ 3{-≠qÕ˙—ıÁÎO÷ôõu?}îa’£SY^Î}=Æ}4⁄Ê≥È>ﬂÁ¬.™é•XØ°uº¢nN £(∑@Ô≤d‘ n,o±Æ±ÔªÛ¬®≥¿÷,∏$D¿È&√q≤:óP∆Ëÿ∂:áÂá€ïë\oßΩ≠πın˙‰€ex¥[≤œKÙ∂/A¿¿√È∏u`‡“‹|Z∂™ô¿ˇ YŒsΩˆ=ﬁ˚Ôz‰~®ÁF`|zÁß–iÒÙ≈Ÿ>ø˛È.Ÿ, ˜‘£4âô¥
Y}_§uö›“≤m` d[Oß`nM7›Nf1iı®∂ß{ôg˛äR˙«vu®›”¡9ï„ZÍ6âpxcã\∆Î∫∆˛cWœ>∫≠Ø3®€‘˛«üÜ~+Hy∂˚K˝ﬁïıˇ 5mŒ˙üOˇ ∂©XﬂO~=ò∏ñuZ*≥'ˆ_«kZ⁄=WlÆûµçSΩ6◊Vk/∆~uU’ËﬂNO≠Èz∏€Ìßˆ6Ìø°XÁ2ã™6`XI.≠≠swcÔ˙‰ÃØ≥›ç˘ˇ d≥”ˇ  ∂p* œˇ ùïÁ4◊ëì”põòÜ∑)ÿV}ß`˙´kÒ÷&NL‡tŒ´o“≠¯÷‹‡éÃ™∆6V÷∞9Ó˛í«Ìc¡™Ÿ„R~ó˝(¸≠å2∏êG˛â˘ù?®ˇ _˙ﬂ^ÎóÙ≥áQ€S√ﬂK6öœßh mñZœNœ°Ìˇ ˇ ∫o©Ã≥?•8Õ=+:‹\IsûF9mYòµπˆ?Ùe˝ü˙ï.?†˝iƒË£™}èß›ìï‘söÍ≥NßmÉäæŸôkuuWïnO∑—≥Èˇ √.ÛÍˇ HJ¡s/∞_õïkÚ≥ØlÜæ˚LÿX◊}
´he∑˝LV"l¡!DáM$íEˇ“ıTíI%)p_Y∞Ÿâıá&¸∆≥Ï›Qî{nÙ˝Z[e·Ô∑Ë⁄Í›UÙ÷ÔÁˇ OÈ4ª’«}yknÍ}'‡€(Ù≥.4º1œh«∆f˙ﬂπØŸVfBfP%kÒ&)Á∞+ÆÆ•‘™ÿ⁄ôÍc;k hÿÏv2Z÷C~ïv≠¨/¥‰}QÈ9ÿ5˙ΩSÍΩÇªqkáΩˇ fk∫~~#>ìõf^æ—èÌﬁˇ ’ñÒÒzS˛›çKi≈Ÿ≥>™Y¿KÍŒmU˝'aπ÷}£c°⁄ˇ ˚é¥Û≥zvAŒÈ¶ª{YÎP˜E9h˝ç»¨YË‰z^ 2ö€i∂ØNªŸÏ™⁄´‚»#-~Y /∆,˘qôGM‚IØ	=ﬂOÍ]K
ú¸[ëãê›ıZﬁ„øπØkΩñVˇ }o˝ä¬Û˚z◊L≈»∑®‡d‰˝\Ã»∞Ÿóâïä¸åÏ€Ôπﬂcı1Î∂ËØ‘Ã√Õ™À=?”’eämˇ }OÏ±N6SÀé0üô¥üÖΩ3“Ø˛ªö≠q
ªÊ÷·7Tm≥’ˇ ≈W’<¸˚zùŒø‘&€Î™∆∂¢dæ€Í◊cÎﬂ˘˚,gˆ=ï‘˙9G®1Ï¿ÈT–ﬁü—ÎqvÁ„‘„fFc)i∫€ìï¸›˚w€U•ﬂ§±?®˝eÎ_g£¨˙gÌvlƒËGhΩÌ›fÓ°ñ]cùãç_È2ôS˛Õ¸◊¯D∫Ô¯•ÎU¨Œ=Gˆëk¸q[´∆cZ÷±µcÿﬂZÌïGÁ”˙_¯√˙¡@˙zÀˆEx˝Y≤=]#˚dãÎ/OO©túëóïâπóa∞[ëçf”ìF;2OØëK´f^5,È,Ø”ˇ Ω7ßu©á^wOππ◊Ã±áOÍ∏}&=øü[ˇ I_ÁØ,Ëﬂ‚W©71∂un°UTVCáÿãùi ˛mó’K(ˇ åŸwıáPÈ]O°uÜ4Êø+®^≠à—[r,`/˚7WÈŒ›ÅvWÈl~=ü£˚W¸r@{c©àˇ *'‹=èŸ'”1’˙o‘Óáê:√˙mÍñªı:k`6›x!’˝ó{=SgÎ´Ù_ŒÿıÃ˛’˙¸ÀClÍµ‰–ﬂ•ÈWN=Ó˛∑Øáóè_ˆp2˙Üüj£ΩJ¡≤Ó•üìoP»5ÀüÈ’[)¿¶ñ{ˇ ö¢Ïj‡“˜±ÔƒÌd˝◊W9∑ÙO™Ÿ8ŸV6œ¨Xüis]h»nÀ}9fIƒk?I¸ﬂ£ã˛íÂœuSçã”ÍfÒM»√©èyk.•Õs‹~é hV‚«]nveÓ À}a∑Ê_µëS‚ ÿ›ò¯XçèV∆Wˇ ìmﬂMT≈∏gÂ}≠í1púYäsMñŸ[¸◊1¡ø†˚&CÅ˛ëó›ï˛âW…ìåÇ¶õc> A˘§ Ã¨>±}+*ºúú‹äCYS€f÷Wmyô6Ω¡€Ècc\ˇ ßæœk‘óû`›ÈuÓçeÆÙÒk»∑{ˇ 4[e6b·±ˇ ªÎ?"÷6œÙæù_·ó°©πp84ÍXsì«Ø@§íILƒˇ ˇ”ıTíI%)rü^ikoËŸÑ¡nE∏ø,ä.pˇ ¡±h]ZÁ>ºÿ¡”1),ﬂe˘¯¢£D◊g€-≥˚8∏π	≥˘%‰WCÊèòy¿KHp0F†Ñ>è–zûUŸˇ ±›EXxñW[pÔ‹*u÷5πyáÍ∑ŸÄ÷WëOËM¯ﬁ∑´˙
ëˇ ‘8n/U¨à{zïÆqÓEï„‰RÔ˚b⁄Íˇ ≠™∏"%"¢∂mgëåA›∆oN˙ …ûçê◊èÙYÆi˛≠è»«≥¸ÍèG’ˇ ≠Y†zïQ”d‰XrÌ{\Ã\oKÈ~˛uüÒkπIN0cÎÒ`9ÚVÔ'o‘˚zvNWÈ9ùS	÷˙ˇ l≥o⁄jπ•Æ«ıj©ÃƒÙ=übÆä+∆´¸'Û∂ÿüßuˇ ≠˝{π}/ßa`TÁπÇ‹Ãáﬂª”s®øf>U˝´{}˘>ı’Æ#Íw÷è—~™—á’2Îß®‚Ÿ{20É≤EØ»µﬁã1ª"◊π÷˚=:‘†VÃDﬁÈ˙?[˙Òô“)ÎN«Èô8óPo1˜„›†sΩ6πÏŒ©Œˆˇ !ßÂ}nwOÍ›sæî‹_ß5Á ÿ¸ñ?ö˚i«≠æÜ;ˇ W¶™ˇ û≥÷ıˇ GZ´ıwÎ7FÈTÈÈ›B„è‘∫}´˙mÕ5‰∫¬%ïQçf€2=mÏÙ_Nˆ{◊Iık¸?´Ω3%•ó—âEv∞Ú◊∂∂5Ï“~ÉΩ©)«»˙éÊ8ó‘≠«Æ£Â∞fV Ueè£=ü⁄Œ±S?T˛¥Ì4≤ú5‰Ò_hw˛~]≤IáÒ∆Iç§^gÍF>ÒgY»=Oi%∏ª8ÉVñ9¯çuØ…{6ˇ ⁄‹åñ¡¨~µU∏ˇ YzïvànXß7Î´uÙ¸Å?Gu6‚”øˇ “ªÂ«}v◊≠tpﬁ[Ni≥…Ñb∑›ˇ _ÙSr¿{dU™ÏR>‡$›ËÛ˝]°›®5¬GŸo0|[[Ïo˝65zf-é∑õ_£¨c\Ôâ ïÊ˘XÔÕm]*£uK#HÇ[[Å~u€\[ª–¡eÔˇ åÙó¶   @o,=$˜+πÉÍ¡tíIN¿ˇ ˇ‘Ωâ‘∫ãzÊ/YÀy=AŸåÈùFñ{j™ß=¯üce[Ïk´ß3#6¨ãÍ›Îzø£™ÔEz:Â~∂}Wø6«ÁtÍõs≤+ÍÅ¬ó‹+˜bÂ„d˝
∫Ü⁄ﬂM◊~é⁄øF˚+Ù)YO¡˙Á‘ﬁ)¥u5ªÅ9y¯4	·–ZÏÃø›ˇ Bò¢H  Õ∆ª~ÍÚ# ":Q˛/~∏O¨Yıı.æE.ctv;9¶AÀªo⁄ƒám›áä⁄Ë˛Eôó‘™®=m„m∏ò≥˜,œœ{Ìª™∂ø˙+[Í>a§779∏,häÒ:]u∂∂{úÔÈîﬁ˚∑Óˇ èáÔˇ õ>9Î"?ÓxóCÇ$HÀä∫Dﬂp∏y9L«ÙXo  x´§5˜XL1œˆUS√‰Ÿ˙*?„?Dª´}˝'ßzymôπ/9∂3v√s√[∂üS‹⁄(©ïcQˇ O˙Eœıﬂ´ÿ]#£ªŸmÔÎ8»ÀΩÊÀ¨Ê¶∂À4˝=O——S+¢øu.’XÑy®ÀîÃˆàRI$§cR	ƒ≈9#,”Y…kvˆèP7˜=Xﬂµ$îƒ±ÖÕqh.lÌ$j'ù™I$íîíI$•.Îã˛∂eá∑kÍ¬∆m ù]Q≥%˘1üπÎ˙[˝Jøêªµçı´¶afÙåãÔØıå*nª!Ñ≤⁄û„æõôÔg—nˆ5o¯fXõí<Q1∫µ–óÑ™ÈÊ:N~'KÎïÁı F#Ò˛ Ã©%òˆ>œR€2ô˛å∂∑ø∂ˇ 7èˆNˇ Jª}Eﬂ1Ï±ç≤∑±‡9ÆiêA’ÆkÇÛúlNπOH¡Íô9ÿŸx‘‰?'∏∫ß\÷=Ã»¿´wØK}_È>˝üŒ·ÖM—:´∞.}_»∆ø¿}^ôÍ≈.'ﬁ/ƒÙEˆt¸èwÈ™f/ŸÔ¸˙)ªÙ™(L„®LPÈ!Ú≤Œ% œXı{n∑÷ô“Í≠ï◊ˆúÏ¢[âäi{Ño}è?Õc”πæΩﬂ˙: ´”æ∞un≠]]B˚˙ΩÕkŸÉSj˚5N‹}Zzé-u]fÕ˝£/©~“ª˛—÷ñ>W÷/¨/ß=˚™uO≥ohØ≤É“*»pıjfu÷_ìíˇ ’Ú2´™ˇ Iî”ÈÆ˚ñ„‚RÃzÙ*©°å’cZ•å∏¨˛èËˇ )GÜáÈ~ìˇ’ıTó ©$ßÍ§ó ©$ßÈ/¨ø≥˝∑˙ªh‚zéŸı˝V}õ’ı?Ì?©¸˛œ“zÕ≠ÖÚ™I)˙©%Ú™I)˙©%Ú™I)˙©%Ú™I)˙©%Ú™I)˙©RÎaß£gá÷úk•¿n lvªw3w˘ÎÊ$íSÙØ’Hˇ ö˝i%øa∆ÇDÙkÌ™©÷ˇ Ê'©oÌœŸææﬂ“}ß—ı¢;o˝c~œ°≥Ùü∏æuI%?I˝Wˇ õø≤ˇ Ïwgÿ˝G˙õwoı¥ı~’ˆè÷æ”Ù?•~õ”Ùø¡˙k]|™íJˇŸ8BIM!     U       A d o b e   P h o t o s h o p    A d o b e   P h o t o s h o p   C S 2    8BIM          ˇ·:∂http://ns.adobe.com/xap/1.0/ <?xpacket begin="Ôªø" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="3.1.1-112">
   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <rdf:Description rdf:about=""
            xmlns:xapMM="http://ns.adobe.com/xap/1.0/mm/"
            xmlns:stRef="http://ns.adobe.com/xap/1.0/sType/ResourceRef#">
         <xapMM:DocumentID>uuid:0CDE46B9982A11E091A193CDBD092F25</xapMM:DocumentID>
         <xapMM:InstanceID>uuid:0CDE46BD982A11E091A193CDBD092F25</xapMM:InstanceID>
         <xapMM:DerivedFrom rdf:parseType="Resource">
            <stRef:instanceID>uuid:0CDE46B6982A11E091A193CDBD092F25</stRef:instanceID>
            <stRef:documentID>uuid:AFB0EA80982311E091A193CDBD092F25</stRef:documentID>
         </xapMM:DerivedFrom>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:xap="http://ns.adobe.com/xap/1.0/">
         <xap:CreateDate>2011-06-14T15:05:53+10:00</xap:CreateDate>
         <xap:ModifyDate>2011-06-14T15:06:23+10:00</xap:ModifyDate>
         <xap:MetadataDate>2011-06-14T15:06:23+10:00</xap:MetadataDate>
         <xap:CreatorTool>Adobe Photoshop CS2 Macintosh</xap:CreatorTool>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:dc="http://purl.org/dc/elements/1.1/">
         <dc:format>image/jpeg</dc:format>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/">
         <photoshop:ColorMode>3</photoshop:ColorMode>
         <photoshop:ICCProfile>sRGB IEC61966-2.1</photoshop:ICCProfile>
         <photoshop:History/>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:tiff="http://ns.adobe.com/tiff/1.0/">
         <tiff:Orientation>1</tiff:Orientation>
         <tiff:XResolution>8999980/10000</tiff:XResolution>
         <tiff:YResolution>8999980/10000</tiff:YResolution>
         <tiff:ResolutionUnit>2</tiff:ResolutionUnit>
         <tiff:NativeDigest>256,257,258,259,262,274,277,284,530,531,282,283,296,301,318,319,529,532,306,270,271,272,305,315,33432;22C38A4F29010CEA3C3F26298C0C806C</tiff:NativeDigest>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:exif="http://ns.adobe.com/exif/1.0/">
         <exif:PixelXDimension>1431</exif:PixelXDimension>
         <exif:PixelYDimension>901</exif:PixelYDimension>
         <exif:ColorSpace>1</exif:ColorSpace>
         <exif:NativeDigest>36864,40960,40961,37121,37122,40962,40963,37510,40964,36867,36868,33434,33437,34850,34852,34855,34856,37377,37378,37379,37380,37381,37382,37383,37384,37385,37386,37396,41483,41484,41486,41487,41488,41492,41493,41495,41728,41729,41730,41985,41986,41987,41988,41989,41990,41991,41992,41993,41994,41995,41996,42016,0,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20,22,23,24,25,26,27,28,30;70422B8F548BFB2D26B722FCE28738F1</exif:NativeDigest>
      </rdf:Description>
   </rdf:RDF>
</x:xmpmeta>
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                            
<?xpacket end="w"?>ˇ‚XICC_PROFILE   HLino  mntrRGB XYZ Œ  	  1  acspMSFT    IEC sRGB             ˆ÷     ”-HP                                                 cprt  P   3desc  Ñ   lwtpt     bkpt     rXYZ     gXYZ  ,   bXYZ  @   dmnd  T   pdmdd  ƒ   àvued  L   Üview  ‘   $lumi  ¯   meas     $tech  0   rTRC  <  gTRC  <  bTRC  <  text    Copyright (c) 1998 Hewlett-Packard Company  desc       sRGB IEC61966-2.1           sRGB IEC61966-2.1                                                  XYZ       ÛQ    ÃXYZ                 XYZ       o¢  8ı  êXYZ       bô  ∑Ö  ⁄XYZ       $†  Ñ  ∂œdesc       IEC http://www.iec.ch           IEC http://www.iec.ch                                              desc       .IEC 61966-2.1 Default RGB colour space - sRGB           .IEC 61966-2.1 Default RGB colour space - sRGB                      desc       ,Reference Viewing Condition in IEC61966-2.1           ,Reference Viewing Condition in IEC61966-2.1                          view     §˛ _. œ ÌÃ  \û   XYZ      L	V P   WÁmeas                         è   sig     CRT curv           
     # ( - 2 7 ; @ E J O T Y ^ c h m r w | Å Ü ã ê ï ö ü § © Æ ≤ ∑ º ¡ ∆ À – ’ € ‡ Â Î  ˆ ˚%+28>ELRY`gnu|Éãíö°©±π¡…—Ÿ·ÈÚ˙&/8AKT]gqzÑéò¢¨∂¡À’‡Îı !-8COZfr~äñ¢Æ∫«”‡Ï˘ -;HUcq~åö®∂ƒ”·˛+:IXgwÜñ¶µ≈’Âˆ'7HYj{åùØ¿—„ı+=OatÜô¨ø“Â¯2FZnÇñ™æ“Á˚		%	:	O	d	y	è	§	∫	œ	Â	˚

'
=
T
j
Å
ò
Æ
≈
‹
Û"9QiÄò∞»·˘*C\uéß¿ŸÛ&@Zté©√ﬁ¯.Idõ∂“Ó	%A^zñ≥œÏ	&Ca~õπ◊ı1Omå™…Ë&EdÑ£√„#CcÉ§≈Â'Ijã≠Œ4VxõΩ‡&Ilè≤÷˙AeâÆ“˜@eäØ’˙ Ekë∑›*Qwû≈Ï;cä≤⁄*R{£ÃıGpô√Ï@jîæÈ>iîøÍ  A l ò ƒ !!H!u!°!Œ!˚"'"U"Ç"Ø"›#
#8#f#î#¬#$$M$|$´$⁄%	%8%h%ó%«%˜&'&W&á&∑&Ë''I'z'´'‹((?(q(¢(‘))8)k)ù)–**5*h*õ*œ++6+i+ù+—,,9,n,¢,◊--A-v-´-·..L.Ç.∑.Ó/$/Z/ë/«/˛050l0§0€11J1Ç1∫1Ú2*2c2õ2‘33F33∏3Ò4+4e4û4ÿ55M5á5¬5˝676r6Æ6È7$7`7ú7◊88P8å8»99B99º9˘:6:t:≤:Ô;-;k;™;Ë<'<e<§<„="=a=°=‡> >`>†>‡?!?a?¢?‚@#@d@¶@ÁA)AjA¨AÓB0BrBµB˜C:C}C¿DDGDäDŒEEUEöEﬁF"FgF´FG5G{G¿HHKHëH◊IIcI©IJ7J}JƒKKSKöK‚L*LrL∫MMJMìM‹N%NnN∑O OIOìO›P'PqPªQQPQõQÊR1R|R«SS_S™SˆTBTèT€U(UuU¬VV\V©V˜WDWíW‡X/X}XÀYYiY∏ZZVZ¶Zı[E[ï[Â\5\Ü\÷]']x]…^^l^Ω__a_≥``W`™`¸aOa¢aıbIbúbcCcócÎd@dîdÈe=eíeÁf=fífËg=gìgÈh?hñhÏiCiöiÒjHjüj˜kOkßkˇlWlØmm`mπnnknƒooxo—p+pÜp‡q:qïqrKr¶ss]s∏ttptÃu(uÖu·v>võv¯wVw≥xxnxÃy*yâyÁzFz•{{c{¬|!|Å|·}A}°~~b~¬#ÑÂÄGÄ®Å
ÅkÅÕÇ0ÇíÇÙÉWÉ∫ÑÑÄÑ„ÖGÖ´ÜÜrÜ◊á;áüààiàŒâ3âôâ˛ädä ã0ãñã¸åcå ç1çòçˇéféŒè6èûêênê÷ë?ë®íízí„ìMì∂î îäîÙï_ï…ñ4ñüó
óuó‡òLò∏ô$ôêô¸öhö’õBõØúúâú˜ùdù“û@ûÆüüãü˙†i†ÿ°G°∂¢&¢ñ££v£Ê§V§«•8•©¶¶ã¶˝ßnß‡®R®ƒ©7©©™™è´´u´È¨\¨–≠D≠∏Æ-Æ°ØØã∞ ∞u∞Í±`±÷≤K≤¬≥8≥Æ¥%¥úµµä∂∂y∂∑h∑‡∏Y∏—πJπ¬∫;∫µª.ªßº!ºõΩΩèæ
æÑæˇøzøı¿p¿Ï¡g¡„¬_¬€√X√‘ƒQƒŒ≈K≈»∆F∆√«A«ø»=»º…:…π 8 ∑À6À∂Ã5ÃµÕ5ÕµŒ6Œ∂œ7œ∏–9–∫—<—æ“?“¡”D”∆‘I‘À’N’—÷U÷ÿ◊\◊‡ÿdÿËŸlŸÒ⁄v⁄˚€Ä‹‹ä››ñﬁﬁ¢ﬂ)ﬂØ‡6‡Ω·D·Ã‚S‚€„c„Î‰s‰¸ÂÑÊÊñÁÁ©Ë2ËºÈFÈ–Í[ÍÂÎpÎ˚ÏÜÌÌúÓ(Ó¥Ô@ÔÃXÂÒrÒˇÚåÛÛßÙ4Ù¬ıPıﬁˆmˆ˚˜ä¯¯®˘8˘«˙W˙Á˚w¸¸ò˝)˝∫˛K˛‹ˇmˇˇˇÓ Adobe d    ˇ€ Ñ 

		""ˇ¿ Öó ˇ›  ≥ˇƒ¢            	
         	
 s !1AQa"qÅ2ë°±B#¡R—·3b$rÇÒ%C4Sí¢≤cs¬5D'ì£≥6Tdt√“‚&É	
ÑîEF§¥V”U(Ú„Ûƒ‘‰ÙeuÖï•µ≈’ÂıfvÜñ¶∂∆÷Êˆ7GWgwáóß∑«◊Á˜8HXhxàò®∏»ÿË¯)9IYiyâô©π…ŸÈ˘*:JZjzäö™∫ ⁄Í˙ m !1AQa"qÅë2°±¡—·#BRbrÒ3$4CÇíS%¢c≤¬s“5‚DÉTì	
&6E'dtU7Ú£≥√()”„ÛÑî§¥ƒ‘‰ÙeuÖï•µ≈’ÂıFVfvÜñ¶∂∆÷ÊˆGWgwáóß∑«◊Á˜8HXhxàò®∏»ÿË¯9IYiyâô©π…ŸÈ˘*:JZjzäö™∫ ⁄Í˙ˇ⁄   ? ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*≤I5.‰ :íh1V1¨˛i˘[E®‘5KHò~…ôK»¥%ˇ ·qVÆŒZ˘NØ’Êûıáh!aˇ qË.*ÛÕ{˛s{™Ë∫W…Óeˇ ôQ/¸Œ≈^o≠ŒXyÎR'—∫äÕ| Ö?‚S˙Ôˇ ä±-GÛüŒZá˚—¨^–ˆIö1˜E√I.<ÈÆ\o6°tı˛i‰?≠±T∫•‹∆≤Õ#‚‰‚®Rkπ≈]ä¢b‘Æ¢<£ñE>!»≈Qqy£UáxØ.û∏ˇ ç±Td_ò^dá˚ΩV˘’πî∆¯™gk˘ÕÁ;oÓıõﬂˆS≥ƒÀb©•ø¸‰güm˛∆Ø1ˇ ]co˘9b©’ü¸Âáü-ˆíÓ)ˇ ◊Ç?˘ñ±‚©Ìè¸Êõ°5π∂±ô‘u?≥∆∏´ ≤ˇ ú·ΩZ}sGâ¸}9Ÿ‚Q…ä≤K˘ÕΩJ}wM∫à˜Ù⁄9?‚fUïiﬂÛóE∫÷û‚⁄øÔÿˇ …è[e⁄_Áíı2æ±h	Ë$êF‰∑ßä≤˚-J÷˝yŸÕ…„∏™+v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ™◊uçK1 §Ï1V1≠~h˘_D%uR“&TÃ•ø‰Zíˇ ∏´÷?Á,<ãß‘Es5€–BﬂÒ)Ω≈X6±ˇ 9Ω`ïVï4æyV?¯X÷¯ñ*¬5è˘Ãˇ 4›|:}µù™¯Òi˛	›S˛I‚¨'Wˇ úåÛﬁ©Q.´,J{@©¸4Jèˇ ä∞çWÃ⁄¶Øæ•yqs_˜Ï¨ˇ Ò6lU/ä'ï∏F•òˆ∏´ ”ˇ .¸¡~x¡c0˜ë}1ˇ 7¶πQÀÃ∂R=.õ˘≠‹Ä◊O∏Óo˘&?‰¶RuQ√M" Ùˇ ˘«Ì:1˛ùw4≠ˇ Öå}ÕÎˇ ƒ≤É´=x“é•˘ã˘a§hz∑÷∏ûåóg,H,#°S~ﬂe…aŒg*,3açÖøíæ]“u}6wæ∂äkàÁ"Æµ<Jßˇ Ía‘ŒQ"óO»zB˘'B4˚_˘üÛNa¯“Ôs<(˜.ˇ hıo¥ˇ ëˇ Õ<Ywï£‹˛–ˇ Íﬂiˇ "#ˇ ö1ÒeﬁW¬èph˘+C?ÙØµˇ ë)ˇ 4„„KΩ|(˜(…˘†Iˆ¨-˛à¿ˇ à·ÒÂﬁè=»)¸≥)´Y/–Ú/¸BE…~b}Ï|w(ø‰˜ñ•°_î≤ˇ 2_ôö?-æ„Ú+@óÏµƒÍ»?ÊbIí©y1¸¨|–s˛@i~Ê‚ÂO˘EıFô!´=ÃNîw•èˇ 8?cP˙«÷…ç_ì§ÛJÓ 5UoÙ{´w_Êß˛%ˇ âd∆Æ>lñ^IUÔ‰ßòÌ€åQG8ÒéU˛KzY`‘¿µù<ÇO{˘qÊ&„-åÕˇ ◊‘|>¶X2ƒı`qHtI/tÎõÙÓ‚x_¡‘©ˇ ÜÀ∂≤)´KÈÏ‰Z»ÒH:2ßÔ\(f∫Á∑ùtJMZ·ïz,ÕÍè∫„‘≈^ôÂø˘Õ/0Yêö’ùΩÍ≠0øﬂ˚ÿˇ ‰ñ*ˆØ#ˇ ŒRyCÃÏ∂ÛÃ⁄m”m¬Íä§ˇ ì:÷˘È‚Ø]äUô∆C+
ÇA_äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä≠f
	&Äu8´Œ|·ˇ 9	‰ﬂ*≥Eu|≥‹/X≠á™’%?tüÛ“D≈^;ÊO˘ÕŒ©†i).§ˇ ô0ˇ ’|UÊˇ ¸Â/ûµ}íÒl–˛Õ¥jøÔÍKˇ %1Wûkp÷u≤N©}su^”JÓ?·ÿ‚©\Q<≠¬5,«∞≈SÎÀ›~˘Ç√c8ØwSˇ ÇóÇÂg,G2ÿ1»Ùd?ëæ`πòCoÌ$ïˇ ì"l§ÍbFöEêXˇ Œ=πP◊∑¡[∫«G¸∫ˇ …º®Í«@⁄4á©dV?ëZªôßü¸óp˛I,oˇ îùTè&—•ã ”ˇ .<Ωaº61¯»üÚ|…ïÚ=[Féâ˝≠§6à"∂çbåtTP£˛rì"y∂àÅ…W'bÆ≈XÔÊ%íﬁ˘~˛&Ë i>òˇ |?ÚÏ§sây◊¸„Õ ¨óˆ‰¸L∞∏ dVˇ âÆfj∆¿∏öCπgÕk±v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WˆÌç¢í[ˇ %Ë∑·ÖÕî_´’[˛F'ˇ ÜÀFY≠gOF7®˛H˘zÔxV[cˇ »Hˇ íﬁÆ]Tá6ì¶â‰√uo˘«˚ÿÅm:Í9ˆØ∆~@Ø™ß˝ó»é¨m“ë…Áö˜ñµ
_GRÅ°cZ>ˇ Q◊‡ˆóârq%lÉ…ú>gÚK£^∫@IÒƒÁîúï?÷èÉˇ ïìb˙»ˇ ÛöVWm¸’f÷Út3€|i˛≥BﬂΩOˆ6*˜ø*˘˚CÛd^∂á{–•HF¯á˙Ò5%OˆIä≤Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äøˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®MSU¥“≠⁄ÛPñ;{x≈ZI*ÅÓÕäºÛ˛sC—˘Z˘n#©\ΩF¨pÉÛ˛ˆ_ˆ*ãˇ bØõ<ı˘€Êü;rMVÒÖ´«º?ªãÂ¡?ºˇ û≠&*ƒtΩ˜Uì—∞ÇIﬂ∏E&üÎSÏˇ ≤»ôÕêâ<ôŒë˘≠›—Ø+EÓπµ=ñ.Iˇ %1•©àÂªë4èì/” t»@˙ıÃ”∞˛@±©˘ØÔ[˛1Â´=|t£©eZwÂóól(¨£cˇ ÷O¬c"Â<èVÒÇ#£"µ≥ÜÕV—¨Qéää¿ÆRdO6—9*‡dÏUÿ´±WbÆ≈]äªv*°®Z€im[Ï åá‰√éJ&àc!a‡ﬂê˜+ª"1ﬁ[gQÛˇ ƒQ≥i™óY¶>ß–©vÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb™w6±]F–\"…ä28§î≠±¬	ê@<ﬁ}Ê?…'R&[k)Oe¯£ˇ ëm∏Ø˘*ˇ ìôp’œwz`ylÛÚè^“*‚≠D?nã˛IÌ7¸ì„˛Vf√<d·œ¢ƒÌ/'±ïg∂wÜd5VBUÅˇ %óqô\Ú_¸ÂWú<ª∆+πìS∂_ÿπzìpúdˇ ëûÆ*˜è%ˇ Œ^˘[Z„∞íÈwÄó§Uˇ å—¸_Ú2$≈^—§k∂‘ÎL∏äÊËÒ8q˜°≈Q¯´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ™Y◊ltKfæ‘Áé⁄Ÿ>” ¡G¸6*˘€Û˛s& ”ùüì‡˙‘ªè¨Œ
∆? éÜY?Ÿ˙_Ï±WÕr¸√◊|Áqı≠vÓKí	*Ñ—øÔ®ó˜i˛≈qVº≥˘´˘àÜ≤Ñàﬂ≤|1ˇ ¡S„ˇ a…≤©Âå9∂√ó'¨ykÚ/M≤]YÕ‹ø *ëçø…>£”˘πß¸cÃ	ÍâÂ≥õ0ﬁçecocÇ“4Ü!—#P™?ÿÆŸÜdO7,DJÿ;v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WŒ˛EÖtø;≠µ~Æ.!ˇ Öñ%¸sqó’É®≈¥˛/¢3NÌ›äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ìÎûO“u—˛‰m£ïøûú_o¯µ8…˛«ñ[≤è"’,Qó7úkøê’}Ë©Ïìääˇ ∆X˙»ñˇ [3!´˛pq%•Ó/8◊ºÉ≠h@ΩÌ≥àós"|iOwJÒˇ ûús.9c.Eƒñ9GòK¥O0Í¬ÎJπñ÷a˚pª#}Ër÷∑¥y;˛sÕ:?µÑãTÑu.=9iˇ b?‡·lUÓûNˇ úÆÚwò8≈y+ÈóˆnG¡_i„Â?„/•äΩz√Q∂‘a[õ9Rx[£∆¡‘¸ô>Uäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*É’ukM&›Ôu	íﬁﬁ1VíF
†{≥bØù2øÁ1¨lyŸy>≠À∏˙Ã†¨@ˇ ≈q|2M˛œ“_ıÒWÃ^oÛﬁµÊ˚ìyÆ›Iu'`«‡Zˇ æ‚_›«˛¡qTOñ?-ıü1RKh}+vˇ wK•?»˝π?Áöø˘YLÛF€°äS‰ˆ+˛Mh˙=&ª]∏Â ?‰√∫ˇ »”/˘<s_ìReÀ“ÁCN#œ‘œ@ Plb9n≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØùı´o—æ|Ÿ~øß˛z2LﬂÒ<‹G’è¸◊Q-ß˛sËå”ªwbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUåÎˇ óπW∫∂Tò◊˜ë|S˚Gá¬Ìˇ UÚ¯gîZ%Ü2yﬁΩ˘<d…£‹¨ã‘G0‚ﬂÚ1ˇ Äã3!´õâ-)ûyÆ˘;V–è˚ë∂í$úÈ…?‰jV?¯lÀéA.E≈îyµÂœ8j˛ZóÎ5‰÷íwÙúÄ÷_≤ˇ Ï≤l◊‰Ô˘Ãü0Èúa◊‡áRàP_‹Àˇ Ä¬ﬂÚ%÷≈^Á‰Ô˘ &yèår‹ù>‡˛≈–‡+ˇ «(?‡§\UÍ÷∑Q]F≥@Î$n*¨§2ë˛K.*≠äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä©Õ2BÜIHTPIbh 'x/Êw¸ÂÆãÂ˛v>ZSΩJëná˝qºˇ ÛÀ‡ˇ ã±W ~z¸ ◊|Òqı≠vÈ¶ íë£O¯≈¯˝o∑¸Õä¨ÚØÂﬁØÊR“.˝Êì·O†˝ßˇ ûjˇ Âq ßñ0Ê€F|ûÀÂ_…›#D"{ëıÀë˚R
 ˇ V≥ˇ #=OÚxÊª&§Àó•ÿc”àÛı3Ãƒrùäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª|Ô˘ÕŸyôÓT—§H•_ˆ+È~∏≥qß7S®7—q”5Sµª]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ"ªUâküïö±V{qßˆ‡¯¸˝◊¸yëD¢„ÀdÛΩ{Úˆ
…§Œó	BBI?˙™€∆ˇ ÏΩ,ÃÜ®{8í“ë…Á⁄ﬂïı=Çj6ÚC^Ñä©ˇ VEÂ±l åƒπ8≤Åè4Wï¸˚Æ˘VOWCΩû”zïG<˙Ò›ø˚4…±{óìÁ4uk>0˘ñŒ;ÿ˚ÀÓ§˙S‚Öˇ ÿ˙8´›|ôˇ 9‰ﬂ5qé¡krﬂÓõ°È5|9ü‹ø˚	qW•+¨äH*EAÇ1U¯´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈^g˘•˘˝ÂÔÀÙh.$˙÷•OÜ÷ˇ ?ŸÅ÷¯ˇ ñ<UÒ˜ÊwÁØòø0$1ﬁÀËiı¯ma%S€’?jfˇ _˝Ç&*≈<∑‰˝OÃR˙zt%¿ß';"ˇ ¨Á·ˇ cÒ?˘9\Úsgr{?î?%ÙÌ$-∆ßKÀ°Ω˝⁄üÚPˇ y˛¥üÚ-s]ìRO-ùÜ=0˜z"®PE  fñﬁ)v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´¬?ÌäÍ÷”ü≤ˆ‹Õ]€˛f.m4á”Òuö°Í{'ñnZÎJ≥∏µ%ºN~läŸØ»*GﬁÁ„7ÓL≤∂«bÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈Zí5ëJ8¨(A‹ÑA√uﬂ =V´à~≠)˝®˘'ÒEˇ $Û"ôGÕ«ñû'…ÁZÁ‰>©kW”eéÌ>˚∑'Ωrè˛JÊd5Q<˝.$¥“∑yˆ´¢^È2z:Ñ@Áß5"øÍˇ 7˚ ìåbG6E‰ﬂÕØ3y5Ä—oÂé˛ÍcŒ#ˇ <d‰ü?IãËO Œg[‹2Z˘æ◊Í‰–}fÿOı§∑<§_˘‰“ˇ ©äæè—5Îv’/Ùπ„π∂ìÏ…ı◊˘8™aäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±TØÃ>c”¸ªf˙ñ≠:[Z«ˆùÕ˙£ª;~ Øƒÿ´‰ØÕﬂ˘ÀK˝o‘“¸£  »’Z‰Ì<É˛+ˇ ñtˇ íøÂGˆqWÄ[Z›j∑(ÁπîÙfbzüıõ5Õ _'Æ˘7Ú1c•œòX1ˇ |FM?Á¨É˝ó√¸åÃöÆës±È∫…ÎVñpŸƒ∂ˆ»±DÇäàÅÚUÕyë;ó< 6
∏ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈^9ˇ 9⁄{Å˛ˇ ˇ »öf«Hy∫˝X‰œø-o>∑Â€|"	ˇ  L_Ò¶bÁ2‰‡7…rÜ˜bÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*•ui‹fîYbn®ÍOÕ[l ë…ÕÅÎˇ íz.£Y,˘Y zp¯íæ-ˇ ƒcxÛ.©~ßz`yz^OÊﬂÀ=WÀ Õ*	≠A˛˙=¿ˇ åãˆ£ˇ eóôÿÛF|ú·0Ê•‰?ÃΩs»∑b˜C∏h´ˆ‚;« ñ/≤ﬂÎ˝µ˝Ü\Ω•ˆw‰˜¸‰Nè˘Ä´e9Z≈(`v¯\ˇ 5¥ü∑ˇ €˜øÎ˝ºUÎò´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´œ6ø:4èÀã?RÌΩ{˘GÓmP¸M˛[ˇ æ°ˇ ã?‡ÒW√øòˇ ö:œüÔçÓ±11Ç}(¢(¡Ìƒ§oﬁ>*´‰è ˝CÃ¸n˙=âˇ w0Ø*~ﬂ˙ﬂ›ˇ ïÀ‡Ã|πÑ=Ì¯ôΩÎÀ>P”ºµ°ßEƒ∑⁄v›€˝gˇ çW‡ˇ '5y2ôÛvp∆!…9 õ]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØ0¸˛∑§[O˚Kr|ô$'˛!ô⁄CπpµC`ú~L‹â|µnÉ¨M*üü6ì˛7 ı#‘œL},ﬂ1\ßbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´àPÓ*ÚÔ=~K[ÍØt ∞\nZàÁ¸è˜À…/¯«Ò6gb‘÷“prÈØxºZÓ“ÔH∫0\+AséÃ§n¨§¡+Ÿ{á^Es}-˘ˇ 9Z—zzù§,õ,W«®[øÊˇ åˇ k˝˚˛¸¬á’pO¬,–∞x‹¨§AÓ¨:‚™∏´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äøˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÊˇ ùﬂúVüñ˙Qõ·óS∏m†=œ˚ˆO¯¶?¯v˝⁄ˇ í´‡è0yÇ˚ÃwÚÍzú≠qw;rfn§¯ÂU˚*ã˛«z∑ÂÁ‰‚†èSÛVO¥ñÁ†˛Vú7¸Uˇ #i3_õS“.~?Y=qT 
¢Ä
 ;◊;ÒWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±V˘·iÎ˘y§ˇ |Õ˝ıã˛fÊ^î˙úMHÙ°? ﬁ∫À·tˇ Ò≤Z±Í‰iNﬂ•fòÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUèy√»ˆiÉ”ª^3®"9î|Kˇ 5ß¸Wˇ ¡æ<ªSúòÑﬂ<˘∑…w˛VπÙ/®’1 øaá˘'≥/Ì/⁄_ı~,€„»&,:©„04^á˘#ˇ 9®˘U”ı◊ö#â¯¢ØÌ€ñˇ ÜáÏ7˘Òeço∂¸≥Ê}?Ã÷1Í∫<Îqi0¯Y|{´/⁄G_⁄F¯óMqWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äøˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*√4?3¥œÀ›)ıMIπHj∞BW˛D˛UÓ«˝Öˇ cäø?ºÒÁ]CŒz¨⁄÷≠'9Â;ˆQÿä%˝ò”˛ooçõzáÂÂ™Ÿ§zˆ¶µ∏a ÿ}Ä›≠ˇ 7Ï"¸_o˚Ωn£7áaß√¸EÍ˘ÄÁªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ƒ?7üñ/@ÎHœ›,g2tÁ÷}@Ùñ)ˇ 8˜u “ˆﬂ˘$çˇ ‡√/¸ ÀıcìFì´÷≥^Áªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Ñ’tõ]Z›¨Ô£Y`~™ﬂ¨+Ÿe…FF&√DHQ|˚˘Å˘_wÂñkªzÕßWg˝§ØÏ ?Êb¸˛GÿÕ∂,‚÷uYpòUﬂïõ⁄«ÂÕÔ÷t÷ı-d#◊∂r}9 ˇ ìrˇ ,´ˇ üd∏Ôª.ø2tü?È´™hÚW†ñ&ß©$ãˇ o∞ˇ ≥ä≤ÃUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªaﬂôüô⁄WÂÓò⁄û®ısUÜ#úØ¸â˛H˝π> ¬‚ØÅˇ 0ˇ 15O?jíj⁄≥‘üÜ(î¸%~„_Ûgoèf_ï_ïüY1Îz¬˛„fÜo¬YG˚Ô˝ˆüÓﬂ¥ﬂª¯d¡œû∂nπ{^kì±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈R?@&–/‘ˆ∑ëø‡Tø¸kóa˙ÉNo§º„˛q·Ë⁄Çw"˜zﬂ◊35|Éâ§Ê^Àö◊bÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±U≥Bì#E*áç¡VVä≤û†·êEº;Û'ÚåÈj⁄ûå•≠‚í!ªF;∫◊‚x◊ˆøi>◊Ÿ‰À≥√®‚ÿÛuπ∞pÓ90ﬂ$yÛUÚN†öÆâ1äeŸîÓÆøµ©˚hÊ‰‚Ÿö·æÌ¸°¸Ê“ˇ 2l}[b ‘"◊∂cÒ/˘qˇ ø!oÁˇ b¯´—1WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äº˚ÛwÛìJ¸∑∞ıÔö˛P~Øjß‚s¸œ˛˚ÖnOˆ)…±W¬xÛÊ©Á}FMWYî…3Ï™6D_Ÿé$˝Ñˇ Æüìb¨ÁÚØÚ´Î\5ùj?‹l–¬√Ì¯K ˇ }"ª~◊˜|}L˘Î`Ê‡¡{óµÊ±Ÿ;v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ™QÁÀEø6≥è˘&Ÿf/®{⁄Ú}'‹Ú?˘«˚Ç5+®{4ø‡YW˛7ÕÜØÈ˜KÃ˚ûÁö∑fÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈^I˘ë˘@ìá’4„ ´In£f˛fÅü˛*˝øÿ¯æÿ`‘tìØÕßÎì˘{ÃWﬁ\æãT“Êk{®Z™»zíô[Ï≤7⁄˝¨ÿ∏π?#??,1mÖïﬂmn%¨ê◊·ê˜uø˘?œ€è¸§¯ÒW≠‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈^-˘ﬂˇ 9ß˘$“Ù¢∑z··Z«	?µqO€˛X?‡¯~“Øä<√Ê+ˇ 1ﬁ…©jì=≈‹∆¨Ôπ>√˘T~ /¬∏´’ˇ .?'ñ öûºï}ô-ÿl?îŒæ?ÒW¸å˛L◊Ê‘tãüáO÷O]Õs∞v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®v#.üsÍ–»>ı98sˆ‰^%˘‹‹„˛]˛NCõ-W”Òu⁄_´‡˜º’;GbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÊˇ ô_ï1ÎÅı-,ÔÈV^ã/¸”/˘_∑˚Õô∏5;Nl[áá[\ﬁËW´<ˆ◊∂œU*J∫:üΩXf—÷>”¸Éˇ úå∂Û¬&â≠≤¡Æ(¯OD∏ }®ˇ íoÁá˝ú_∂ë™˜,Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±T=ÌÏ6PΩÕ‘ã1)gw!U@˝¶f˚8´Â_Œø˘À∏ı4_$πH˜Y/©B|E™ü∞?‚ˆ¯ˇ ﬂ|º≈_5ÿÿ›Î7kon≠=‘ÃvÍƒ˝¶f'˛‡&∑)ˆz¸∫¸™ÉÀ ∑⁄ÄYµ£∫«˛ßÛIˇ ±OÁ}^mG√ÈvxppÓyΩ0‹∑bÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏU-Û4ˇ W“Ô&zvÚ∑‹åŸ<b‰=ÌyD˚û3˘b‚P>µ*Oπx»ˇ à6lµg”Òp4øW¡Ô™vn≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±V	˘ë˘eôìÎ∂|b‘Pu?f@:$üÂ/ÏI˛¡˛>û^¸•≈ÕÉèqı<x.Ù{øN@ˆ˜p7∏e`ve#˛ó6†ﬂ'VE>¡ˇ ú{ˇ úêãÃÎó|Õ MXQaù®Ú_≤\ˇ …Ôı°Ù.*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äøˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´œø3ø;|ø˘{îæµÒKXà2˝íˇ ≥ó'˚x´„?ÕOœ=wÛRóØı}8R“"x
tiO⁄öOÚü˛y¢b¨{…ﬁC‘<”7U+n¶è3èÄ{ñﬂ‰'˚.+ïd !Õ∑3>O†º£‰ç? zvk fífÕ)˛@ˇ Üoã592ôÛvòÒ2•πÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ê~`OËhÔ„Ø¸·ˇ eÿ>†”õÈ/:ˇ úx@N¢˝¿Ä}˛∑¸”ôöæAƒ“s/dÕk±v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªbòóvﬁkÉö“+Ë«ÓÂÒˇ äÂÒO¯d˝ü⁄V…√ò√˙Æ>l<÷|Ì™ÈWz%€Z]©ä‚"*<Ueaˇ õh»a‘êF≈ıG¸„ﬂ¸‰»‘=/-yæZ\Ïñ˜évì˘bπo˜ÔÚK˛Ìˇ v~Û‚íH}9äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*£ww§MqpÎQ©fw!U@˝¶f˚#|≠˘Àˇ 9jÚ4$7Wæ#sˇ 0®ﬂd≈œÒ"~ﬁ*˘úµﬁØtYã‹]Œ€ìWwb‡ù∞Iﬁ≠‰ü…b∑ûa<Fƒ[°‹ˇ ∆W_≥˛¨˘kò9u5¥\‹zkﬁO`¥¥ÜŒ%∑∂Eä$T@ ŸFkâ'rÏ `´Å.≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb¨OÛU¯yjÙˇ í£Ôt~üÎ˛í¬Á√®ü·ÎfV≥ß≈∆“u{kùÉ±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±V'˘á‰´1Y<◊l öfY¿›UjÏ≤<_µ«ˆ~“~◊,åLM8˘±â|«õóP˜ˇ …˘ Kˇ *àÙè2ÛΩ“≈%≠fÑ}?ﬂƒø»ﬂ˛√∫ÒWÿ>^ÛüÊ+$‘¥ô“Ê÷O≤Ëj+›Ouu˝•oâqT”v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª@Î≈¶çi.£® ∞⁄¿•›‹– 1W√ûøÛêﬂò3∂ü`Z€Câæ´Fîè˜m«¸iÿOÚü‚≈XìºãÊô˝+E·ëÍL√·Zˇ ƒﬂ˘Q·W‚ ≤d∂„∆fv}Â"iﬁWãç¢∏aGôÄÊﬁ4ˇ }ß˘˛Àõ|Y©…òÕ⁄cƒ »≤ñÁbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈XèÊœ¸£7øÍß¸úL»”˝a£?–Xg¸„«ÿ‘>pˇ Ã‹»÷t¯∏˙NØaÕ{ûÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÊüû>h˝ß&ìR{√WÒ©©˘zè≈W˘ïeÃ›,,Òw8Zô–§∑Ú«ÚŒÀQ–ﬁ„Wà3ﬁ∆và>x⁄ü3rÂdÙˇ  À3Á1ïå0·çû¨/œ_ï˜˛Y-qg∞⁄íé´]∏ ü±˛∑ÿˇ eÊF,¬~˜&rÚ˜Û?[ÚËΩ—'(¶û§-ºR	cˇ ôüﬁ/Ïæd4>–¸§ˇ úÖ–ˇ 0m	Z∞¥çˆèsm'˚ª˝OÔ»˝¨UÍ∏´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä†5ùjœEµíˇ Rô-Ì¢i$4|7˘˘˘Ûq˘áwı<¥:ªV4;XªÊˇ ôQ˛¬ˇ ñÿ´¸º¸º∏Û]«7¨VﬁI‹ü˜‘_Âˇ …ø¥ﬂ≤çF\¢Õø#2˙7L”-ÙÀt≥≥A1ä*èÛ‹ˇ 3fûR26]¥b"("r,ùäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ƒø6Pøño@˛T?tàs#OıÜåˇ AaÛè·‘GÅÉÒı≥#Y”‚„È:Ωá5Ó{±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´RH±©w!UEI; sàÇiÛïÏ≤~a˘§"!ë¯'ä¬õí7˚\yI«˘ﬂ7#˜Pu˜≤}	o√
Öé5
™: G»fúõ›€Å[.e
∞®;p%Âûz¸îÜ¯µÓÉ∆çK@vF?ÒYˇ uÚªˇ åyüãS[I¡À¶Ω‚Òã´KΩ"‰√:ΩΩÃ$ljOUaˇ Êƒ‹:Ú+õË…Ô˘ÀK≠/”“ºÁ Í‘|+v7ï¸\øÓıˇ /˚Ô¯ÀÖ¨t}jœZµéˇ Mô.-•I#5G‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®=SUµ“≠ﬁ˜Pï ∑åU‰ëÇ®Â3bØùø3?Á1ll9Ÿy>ÆL*>≥("!ˇ ‚¯dó˝ü§øÎ‚Øô<Â˘ÉÆy „ÎzÌ‘ó,¬§—˛1ƒøªOˆ+äØÚîÕzê±.#âÀ!Ô¿Z&ﬂiô◊ÌÕπN\ú€qc„4˙_L”-Ùªt≥≥A1ä*èÛÍi≥M).‚1YN≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*∆3"ı<ª|æWÓ!≤¸XhœÙñˇ 8Ô”Rˇ £˘üôZŒé6ì´ÿ≥\Ïäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈^˘œÊØ—O‘aj\^’6Í#ﬁ∑˚/Óˇ Ÿ∑ÚÊfõøÊ∏öô–ØÁ%_ëX˙µ§∫‹√„∏˝‹_ÒçO∆ﬂÏ‰Áó˘Y=Tˇ ÖÜñƒı\¿sùäªH¸’‰Õ;Ãz7Ò¸cÏJ¥øÍ∑Úˇ êﬂ[è)á&¨òÑ˘ºŒøñ⁄áï‹»„◊≥?fdüÛ’›M˛∑¡¸ôµ«òM’‰ƒ`â¸≥¸‹÷ˇ /.Ω}&NVÓAñ⁄Jò§Í˛√ˇ ,©Ò±¯rˆó€ﬂïú:GÊ=ë∏”€“ªäûΩ≥ëÕ? ˇ ã"oÿïŸpág∏´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wé˛nˇ ŒJhûDÁagMCW]å(ﬂg˛^%Ï‚§˝ÁÛp≈_~`~jk˛|∏˙∆πrœ5H·â?‘ãß˚7Á'˘x™ ﬂóö∑ôHk8∏¡ﬁi>˙⁄˘ÊØ˛W™yD9∂√ü'ÆhﬂìVìm#‹÷ÚË∆¿3ä"ö7ÿã‚ˇ íç'Û/¿:ì#∑•ÕqæÏ#Úˇ π…ˇ Êˇ ‰‰9ì™˙~-o©Ôô©vé≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏU Û˙s–/«_Ùy‹9eÿ>†”õÈ/;ˇ úx?Ò—ÒÉ˛gffØêq4úÀÿÛZÏ]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_9yäˆoÃ3àmbvƒ{ñ••˙y7Û|\3s·CwO3‚Kg–÷QX[«in8≈
* 
8Æj%.#e€DP•|ã'bÆ≈]ä≠ñ$ô)T:8* ¬†É’X†·êEºwÛÚl/=K@_Üúû€ı¥?ıK˛˝˜õ:õ⁄Nø6û∑ãÕ|©ÊΩG zåZæì)ÇÓ±ÏGÌG"˛‹oˆ]3‹ﬂüìˇ õ6ôHæ∂§WëQnm…›≈ö?›o˛«Ì£b¨˚v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUüówr,PD•ﬁG!UTufcäæD¸Ìˇ ú®∫÷ûM…Œ÷ˆ¨óB´,üÒáˆ†ãﬂ˚Áˇ ä±Wœ˙Nèy≠\[⁄i‹ìA¯≥1ŸG˘G#)ÓYì∞{Oíø%-4˛7zﬂõäÈuçO˘_Ôﬂˆ_ªˇ åük5ŸuDÌaèM[…È±∆±®é0   Ä¡&‹¿)w[¯G5/û#n^`›êHÉË„'¸iõmO–Í¥ﬂSËl‘;gbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ìy’k°ÍÛ9˚ë≤‹?PjÀÙóóˇ Œ=IIÔ”≈"?q˘´3µ|ÉÖ•Ê^”ö«dÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªaõﬁg˝	£<Q\^VÒ
GÔ_˛‡ˇ ûãôZhqJˇ ö‚Í'√˛s¸àÚØß∫ÏÎÒIX°ØÚèÔ_ßÌ7¿ªˇ ø2ÌVO·j“√¯ûπö˜=ÿ´±WbÆ≈]äªxÔÁÂ«⁄◊Ù∏˝ÓcQˇ %’‰Ô¸å˛vÕéü5˙KÆ‘aØPa?ïˇ ò◊˛@÷¢÷lMP3EZ,±ü∑ƒ£oÿìãf¡¡~á˘gÃv^e”≠ıç5˝K[§áæ˝Uøï—æ_Ÿ|U5≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Ü‘u}6ﬁK€…xPºí9¢™®´3UœÁﬂÁÂ◊Ê…”t“–ËP∑¿ùƒªÁˇ ô0˛«¸e˚*∞/%y˚ÕW8éŸOÔ&`x®ˇ '˘‰˛T_ˆ\W‚ re∂„∆fv}Âè)XyjﬂÍ⁄||kˆ‹ÓÓÀo¯ä˝ïÕNLÜgwkèá$„*mv*ÏUÛøÂÕø‘ºÎ∑hÂπOπ&_·õå€¡‘a⁄o¢3NÌ›äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ™SÁ/¢ﬂ®Ímg|mñc˙áΩØ'“}œ¸ÄööµÃ?Õn[˛–∆˘∞’˝?Kı|Ìö∑fÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª|ÌÁÌRo:yël,àh—≈º=)◊˜í‘~…~MÀ˝ı√7£·«{®À/[=˚H“†“m"∞µbÖ/—˚G¸¶˚M˛Vjg.#n÷1·ã»≤v*ÏUÿ´±WbÆ≈\ QÖAÍ*˘∑ÛO…_·≠Kï∫“ ÊØ~4˛Ú/ˆ¸?Ò_⁄Âõú8«õßÕèÄΩ{˛p˚Û<È˜œ‰ÎÁˇ Fª&[jü≥(ºå{MÚˇ ^?¯≥2`bÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*˘˛rÀÛïı+∆Ú^ì'˙≥≠≤ü∑(ˇ t∆8?o˛.ˇ åX´ƒ¸É‰©¸’| PV⁄*4“(˛Uˇ -ˇ g˝ìe9rm≈åÃ”È]+J∂“≠í …p∆(™?œ©Õ4§dlªàƒDPEdY;v*ÏUÛΩ§çcÁ‚[b⁄É®˘JÏ´ˇ &n¯ˇ ÕulüÁ>àÕ;∑v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®mRqi4'pÒ∫˝‡åî9Ü‰^˘iÆN<m˛NCõMW”Òu⁄o©Ôô©vé≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´¸√ÛË‚Òä˙qxÛÑ˜A _ˆ~qI£4¯bÛ_»_.z˜3Îs°îdˇ ;
»ﬂÏc¯ÁÆfjßBúM,,€€sXÏùäªv*ÏUÿ´±WbÆ≈XﬂÊñáòtiÌVt§?Î®ÿ≥^Qˇ ≥ÀOÜM°≈Õ:6≠>è{•f‹n-§IcoCÕstÈﬂ¶~[◊!◊¥€]^€˚´∏Reˆ°øU3≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªa_ú>}O#yjÔY®}8Ô3¸1¿ˇ xﬂ‰Fÿ´Û≠V„S∫‚öÊ·˝À31¸Yõ4ê-ıì|±ñ¥ÿ¥¯∑p9HﬂÃÁÌ∑ÀˆS¸é9§Àìå€π≈IﬁT⁄ÏUÿ´±WbØû<ˇ :È~v{≥≤≈=ºﬂrƒÌõå;¡‘e⁄o°ÛNÌ›äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªoPπæÇ‘∏ë#Q‘ªŸ!Xô ñ?ù44Î®Zˇ »Ùˇ ö≤cèB¿Âèz]s˘•Âª}û˘˙™Ôˇ &—ÚcO>Ê'<{–ì~ryf1UπgˆX§ˇ ç—r_ñìÃ≈.óÛ„ACEKó˜T_¯ﬁT…~R^L55	?¥a˝›Ω—>ÍÉ˛f6KÚáΩö»ˇ Á!-ó˚õoı•˙ïÚ_îÛc˘ø$?˝=ziøÙÒˇ ^0˛OÕõÚS˘»iŸ”‘|ÊØ¸ \?îË¸—ÓP˘»;√^Q
ª‡0˛Pw£ÛGπAˇ ?ı2§-≠∏=âÊG›…pç,GRÉ™>L+ m∏ÚΩ·ø¥Të⁄6åá©4?≤Wˆïs'$≈06¸ØÌo¥ü’l«¸¨|€ˇ 5/%ßÛÛ\?ÓõQ˛¡ˇ ÍÆ ≈ôíë¸˜◊âŸ-«˚ˇ ™ò-~fJ_Úº|√„¸ã˛‹-¸ƒùˇ +√Ã?Õ¸ã˛‹-¸ƒùˇ +√Ã>0ˇ »øÌ«Ú–_ÃIﬂÚº|√¸–ˇ »øÌ«Ú–_ÃIz˛zyÄuˆ˛k«Ú—_Ã…U>u–7éÿ˚îo˙©èÂbüÃ…x¸˝◊X-?‡$ˇ ™ÿ?+5¸Ãõü⁄ﬂx-~Ñì˛´`¸§|”˘©y#"ˇ úÇæﬁYƒﬂ&aˇ 5d(;Ÿ~h˜"ì˛r˛÷ù_îÙˇ ô8?(;”˘≥‹Ø¸‰,G˚›=îì0o◊d'ÊÀÛ~IÑ_ü⁄9Ω∑πS˛HC˙‰LèÂ{/Õ‰Tû⁄¶å∑˚¥kˇ 2‰|â“À…ê’GÕ1èÛáÀ÷Ôâ1K¸#9¶õ!®äai˘çÂÎ±XÔ°Î∑˘;√"pLtf3DıLmºÕ•›7{Ày[¡%F?≠ê8‰:C$OPô≈GLÅŒÌÿÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´√=¸«ıªË¥XçRÿêx»„·_ˆ1qß¸el⁄iaB˚›f¶vkπÍ~EÚ‡Úˆëâî/9|LçÒ=i◊á˜Í¢ÊiÒJ‹‹P·ç'˘Ks±WbÆ≈]äªv*ÏUÿ´±WÀòz—uÀ´Dãü4ß@Æ=EQ˛ß.Ïsyä\Q“Âèà}uˇ 8Êˇ “˛Um&F¨⁄d≈)ˇ …˚ÿø·˝Tˇ añµ=€v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª|yˇ 9ùÁÉ{´Z˘^˝’ízÛ˛˝ê~Ï¯«¸û≈^q˘Â¡®Íè©L+íÇ+˛¸zÑ€¸ïÊˇ ÎÃML¯c_ŒrÙ–π_Û^˝öóhÏUÿ´±WbÆ≈^˘ıj"◊"ïG˜∂»I˜"ƒUsm•7U©ßªió¢˛÷≈˚3Fíì ˇ «5sHvq6D‰Y;v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Öæ’m4Ò ˆx‡ºé©ˇ #$ O ƒ»e"Ω¸ŒÚÂë„-Ùl‚æRæêe£œF£û#™Ey˘Ì†¿≈b[âº ‰c∆ˇ ôh“I®Í¢ë‹ˇ ŒB†$[ÿ^≈¶ß¸(çø‚yh“wñ≥´Ó	4ˇ ü∫√ÈAl™zU\ëˇ %ˇ ¬ÂÉK6≥™íOq˘…ÊiMVÂcÒ∫3eÉO—¨ÁëÍî‹˘ˇ _∏bœp	˛I¸eFX1DtI©UÓØy}˛ıœ$ﬂÎª7¸K& 	¥"Ì4À´œ˜ñ%ˇ Qø‚8	§ÅiÇ˘+\o≥ß›Pˇ ≈/ˇ 4‰NHé°êÑèBò[~V˘é‰ñN˛r©¯HÀêÒ£ﬁÀ¡ór-?'|Œ«{P£ﬁXø„YDÍ!ﬁœ¿ór:»≠~AV0G˛¥á˛4G»˛f)¸¥ëÚ†uø˜˝ß¸üıG#˘®˘≤¸¨ºëŒ?jg˚Î®˝^Mˇ T¡˘∏˜˛T˘##ˇ úzõˆÔ‘|¢'˛f.Õé‰˛T˜™è˘«èG˛H◊Ïõ…¸°Ôo˛Ö‹’À˛ùˇ Î˛Œy'Úûnˇ °wıqˇ ß˙ˇ èÁ<æ’¸ßö™Œ=√˛Ïøc˛¨@~πÁ<ì˘O4TÛè˙h˚wSüêQ¸0~l˜'ÚÉΩY taˆÆ.O…êÃºõ=…¸®Ô]ˇ *Dˇ ›ˇ ¡«ˇ Tq¸ŸÓ_ é˜ Ç–ˇ ﬂ˜qˇ ’õ=¡*;›ˇ *Cˇ ›ˇ ¡«ˇ Tq¸ŸÓ˘QﬁÔ˘PZ˚˛Ô˛?˙£áÛgπ*;‹ ¥^”›¡Gˇ T±¸ŸÓ_ éı6¸Ä“fÊ‡| ¯”Õû‰~Tw°ü˛qÚ»”Ö‰£∆®ß˙a¸ŸÓ_ Ù1ˇ úx^⁄âÛ¬øÛ;Á<æ÷?îÛZﬂÛè˚:ç~p◊ÏóÊ«r?({–ìŒ>^(˝’‰L F_‘_Ê«r?*{–GÚ[Ì=ß¸üıG%˘®˘±¸¨ºê◊ëZ¸B®`ê¯,á˛7D…~f,-$Ωø'ºŒ:Y‘{K˝T…D;ÿ¯ÓA]˛[yÜ◊w±î”˝ˆ9ˇ …æy1ö'´äC¢_7îµàG)lnPÌè÷π!0z∞0#¢TÒ≤.>˘6-≈+ƒ‹—ä∞Ó1Tﬁ:kPPGr ÌÎ=>ÓT»—òôSx?7<Õ
∑ÑÅ¸—∆«˛	ìñVp@Ùl‰:ßVﬂüZ‹`	"∂êw%¯Y8ˇ ¬ÂgKÃjdûZˇ ŒB©!nlŸ%Ø¸#Gˇ ÂGI‹[FØº'÷_ûö√îO ?¥Ëˇ íO#¬ÂGK&¡™ã ”ˇ 1¸Ω˝ÕÙ#˛2¸üÂGáF—ö'™}kw‹bkgYc=`Ÿ.RbG6— y*‡dÏUÿ´±WbÆ≈]äªv*ÏUÿ™U‘¢“Ì%æ∏4ägoê†ˇ )øg%Òc)pãxÂŒü7õ|œ˙BÓå±ª\À·Z˛Ì ˇ åú>˜⁄∂m≥K√ÖÍ∫¨Q„ñˇ ÷}öwnÏUÿ´±WbÆ≈]äªv*ÏUÿ´«Á 4Jã]]å~˘"ˇ ôπ±“Kòu˙®Ú(ø˘ƒo7˛ÖÛËŸZêÍq4>‹”˜–üπdå∆Lÿ8∏ÒWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä®›]Gkœ1„jYâÏrlU˘°Áü3IÊçn˜\ñµ∫ù‰ ˆZ˛Ì?ÿG≈1Wº˛Sh¢t9äKs˚˜ˇ g˝ﬂ¸ëÊüQ>){ù∂û<1˜≥∆r]äªv*ÏUÿ´«øÁ!m	[•U¸˝6O¯ﬂ6:CÃ:˝X‰YÁÂ•˘æÚÌå«¥^ü¸ã&˘óòπ≈Lπ8ƒ2\°Ωÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä•Zßõ4ù+êΩªÜ&QRÖ«?˘?xﬂBÂë≈)rg$G2≈uŒˇ /Z0¥∑>Ò«Aˇ %åYx“»¥LC‘Á Â#ççí´vid$¿"ß¸úÀ∆êu-'Tz5˘’Ê;£XÂé‹,Q≠?‰∑™ﬂŸp”ƒ4ùDãæÛ~±|
\ﬁ‹Hç’Lç«˛ºr· 9£2yîüv>$‰ÿ'ûN÷n¿h,ÆOÌöüT„ê3ôf O üZ~M˘ñr9[¨J{ºâ˙ëùˇ ·r£®ÄÍÿ0HÙNÌ? 5W#Î76ÒØrú‹˝Ãëˇ ƒ≤£´ãh“…9¥ˇ úz∑V≠ÕÛ∫˜	Sˇ œ/¸G+:æ‡ÿ4ùÂ9∂¸â–b!ùÆ%ˆgP?‰úhr≥´óì1•ämÂ/ña5`ë¸“Hzd¢g´`”ƒtM"ÚNál-vÒÖ	˚Ÿr≥öG´1ä#¢ike¢Ñ∑ç"Q–"Öπ"YàÄØëd÷*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WQC∏¬"í€ü,iWMŒ‚ŒﬁFÒxëè¸2‰∆I•Å«—)º¸∞ÚÂ€rí∆0»-˚°d…åÛX={ﬂ»Ô/\ƒ≥@<#íøÚyfÀ™MgMö˜˛qÚ—€˝ˆH◊¬D~Ùhr—´ÔgI‹R;œ˘«˝M˝RÊ	¸æH~ÂYG¸6X5qk:Y$Wìﬁe∂&ñ¬U“D?•ñO¯\¥j zµÂˇ ñuKÁwi<+‚Ò≤è¯"¥ÀÑÅ‰ZåHÊÅÇ‚HI28ËT–‰ò≤;Û#Ã:y¨7“∑¥á‘t¬L®‚âË⁄2»uegÁ÷ØoEºÜÖH˝*J…,¢ZXûM√S!ÕïÈüüö\‚ó÷Û[∑˘%dQ˛À˜oˇ $ÚâiBﬂPÍvô˘Ö†Í_Ô5Ï5sÈü¯Ω69è,„ö'´!ªå•πÿ´±WbÆ≈]äªyWÁœôMµúZ,&èp}IG˘
~˛Œ_ã˛yf~íƒ‡Íß¸)«‰œñŒë£©Ö'Ω>©ØPù!_¯Rœ\ØS>)WÛYÈ°QøÁ3‹ƒr›äªv*ÏUÿ´±WbÆ≈]äªcøòz'È≠Í’G)#Ò‰üºPøÎÒ·˛À/¡.å—‚â|”†ÎhöÖ∂©li5¨©2¨å‚9∫tÔ”mVáX±ÉRµ<†∫â&C‚Æ°◊˛%ä£±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äøˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äº∑˛rWÕ_·Ô$_≤7Ø⁄'¸ı¯eˇ í∂*¯CÀöI’ı}<zÚ™‡	¯œ–πKÑ[(«à”ÎDEçB TP–ömﬁM‚óbÆ≈]äªv*Ûˇ œsÂÛ0ˇ èy£ê¸ça˝rÆfiMJúMH∏®~DjX—›çZ	ÿ‡¨«¸?©áV=Vç)Ù”—Û	Ãv*ÏUÿ´±WbÆ≈]äªv*îko“4jã˚®¢eÍú™ˇ Ú)9Iˇ 	ñ«•»5K,cÃ∞ù_ÛÎJ∂™ÿC-”‘“4?&<‰ˇ íYì!<‹yjáF™˛zÎWU[4ä—{º€˛
^Iˇ $≥":Xé{∏Ú‘»ÚŸáÍæo’µPEÌ‹“)Í•»O˘ºS˛2#A†Ãûe/≤∞∏æì—¥âÊÂE,~Â…L@∂M¶˛T˘é¸KFâyHéüÏâ·2ôgàÍ⁄0»Ùe:w¸„ıÛüÙÎ∏¢_¯≠Yœ¸7¢2ì´Üîıd∫‰.èÍiÁq÷ÖQO˚¨ˇ ÚS(:≥–7(Í…,?,ºªb‹¢±çè¸YY?·f.πIœ#’∏`àËüŸi÷÷ÈŸ≈)·ÖrS*2'õhàëN≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Ä‘<øßj'ïÌ¨3∑åë´¯&…åíãåaåÍ?ìû\ºR›†c˚Q;ˇ ˛§ôx‘»4ù<K‘ˇ Áaj∂üxÀ∂À*ﬂ˛2'ßO˘óGWﬁó∏±=KÚOÃ6f∞§W+÷±8€Ëõ“?9ëLKL¥ÚCS–oÙ≤˝º∞Wß®å†¸πlrÒ y4ëÕ~ïÊ=GI?Ó>ÊX5!Ö?4˚-å¢%ÕDà‰Õ¥œMj–Å|±]•w$p°¢¢ˆQ6cKMÀg":ô{≥çÛ”Fº¢_$ñnF‰éh=π«˚œ˘#ò““»r›…é®{3Ω3Y≤’S’∞û9–u1∞jW˘∏˝üˆYã(Ûrc1.HÃÉ7b≠3òÄ‰ûÉ∫8 _ÛÕ|A"§†#n0ß¸oÈØ¸ål‹ˇ uQ˝ÏﬂF≈ƒ¢8¿TP ` Ëiâ∑n.≈.≈]äªv*ÏUÿ´±WbÆ≈]äª|´Á}Ù±uß®¢$Ñ†ˇ !øy¸ìeÕÓ9qDIí<$áŸ_Ûâ^o˝9‰ı∞ï´>ô+@G~˜∞ü¯h◊˛1eçol≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äæRˇ ú‹Û(/•˘}Ÿ]H>g—á˛#qäºáÚ+H7z”ﬁ∞<-bf∑7˝“è¶?W˛15R®◊{ï¶ç ˚ûˇ öójÏUÿ´±WbÆ≈]ä§æt”?Jh◊ñî‰œï,£úÚQW-≈*ê-YEƒáîŒ?j^ù˝›ÅÈ4K'”q€Ëõ˛3ıq±nñ[”‹sVÏ›äªv*ÏUÿ´±V3Ø~dhz%VÊÂ^PÓ‚¯⁄øÀ|(ﬂÒëì/é	K£D≥F/?÷ˇ Á âM"‘(ÏÛöü˘¯‰kÊ\tÉ©qe™= ÷ø0µÕhº∫LäC¡Hˇ )#„œ˝ü, é(«êq•ñRÊR{:ÁQîCiœ)˝îR«˛,&ö¿∂_§~MyáPû$∂F¨Ã¸"zí)ˇ Y1Â®àoéûEöi?Ûè÷…F‘ÓﬁCO≥
Ñ°ˇ ]˝^C˝Çf<µ}¡»éóº≥'ÚøÀ⁄e;Dë«ÌMY+Ô∆NQèˆ(πè-DèV¯‡àË…mÌ¢∂åC,qØEP %A$Ûo JòÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈\ ;É‘b"òﬁ≠˘q†jª‹Y∆ØOµÙœ¸í·À˝ó,æ9Â≠2√—ÉkÛè–0-•]≤lì(`O¸dèá˘˘ì_xqÂ•Ó,Z¸®ÛîIksq˝∏>:ˇ ∞Ωˇ Ççs*9„.Æ,∞ =¥ÿ $âö)ê‘J∞9w6ÆL€A¸Á◊t %√≠‰BÇíèäû“ØÂ˛Tæ¶cœOy7«Q(˘Ω/Àˇ ùZ.¶DWe¨•?ÔÕ“ø‰ üÒ)<√ûñCó©ÃÜ¶'ü•øÕø6Ga†ï≥ë]Ôˇ tå¨(æu+^K√˜Û◊>;ñˇ ¬∫åïøâ%¸ÜÚ¡∑∂õ\òQÁ˝‘_ÍY˝úÅW˛ydıS˛Ω,?âÎÄÁªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´≈ø?Ù>ZÍË6u0π+Wè˛ZO˘õ-$∂ß]™éˆûˇ ŒyªÙWö%—•jC©¬T¯∂*À¸íıÛ=¡}±äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äæˇ úùÛÈü=_Ò5é”Ö≤˚pQÍ…fódêz_’Ù©Ôà£\Mƒ{¨c·ˇ áíL÷jÂ∏ÀKâzv`πÆ≈]äªv*ÏUÿ´x´Á-Ñ<Ê∞∑√W&/àˇ ∫‰¯#vˇ ûR,ôπóÔ!uÙO‚˙34Œ›ÿ´±Wb®_^±—¢ıı“°#ô°4˛E˚O˛¡rqÅó&òè7öyãÛÚ⁄«¢¿fnÇI™´ÙFøèıö,ÕÜì˘Œı_Õyüò<ˇ ¨Î’K€ñÙõoM>ß∫'⁄ˇ ûú≥2£A√ñIKö[§˘P÷””≠‰úéºê?÷o≤øÏ≤rêè6"$Úg˙'‰6©tÍ3Ghß™èﬁ8˙å_ÚW1e™àÂªì4è=ûÅ¢˛MËmHöÍAﬁcQˇ "”Ç¡´Ê$µ2<∂r£¶àÛfVñpY∆!µç"åtTP™?ÿÆŸådO7 DJÿ;v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±T≥YÚ∆õ≠©MF⁄9™)…áƒ˘2-$Oˆ-ñG$£»µÀó0ÛΩÚ÷j…£‹4πÙÂ÷æ«Ô÷ı≥.æ‚KK‹Û?1˛_k_´ﬁ€±Äªc¯ìÊYªˇ ûú36c.N$ÒJ<ÿ÷Z‘ˆ!~r⁄XZ¡•jpz1D¢5ö-◊o⁄í?µ»˝©9|_±òt∆F√ùãQ¬(ΩwL’muHE’å©4-˚Hj>G˘[¸ñ¯≥_(òÏ\¯»Kí+"…ÿ´±WbÆ≈]äªv*ÏUÿ´±Wb¨WÛCD˝/†\ƒ†"_Y=åS›£ı˝ñd`óö3«ä/û|•Ê	|ª´Zko%§— èW˝óŸÕÀß~öX_E}oÂªrädWFÒVó≈Q´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈TÆ.ﬁ6öCD@YèÄß~`˘áUmcR∫‘‰˚WS…1˘ª?„lUÙßÂ÷ú4ˇ /ÿ¿;¬$?9?|‰Êi3 ‰]ŒQè)nv*ÏUÿ´±WbÆ≈]äº3ÛÎB6⁄Ñ¨bãpúˇ óFˇ ëløÚ/6öYXÆÁY™çzœíı·Øi6⁄Å5ë–	:}µ¯$È˛ZÚˇ W02√ÜD9ÿ•≈N≤¶‘ìÃûs“¸∏Öµ	ïd•V%ﬁF„øÛ∑ˇ ÀÀaäS‰’<¢ﬁKÊèœK˚≤–Ë—ãX∫zçFêˇ Ã¥ˇ áˇ _6“Åœ‘‡œRO-ûosss©Œeôﬁ{âÂâfcˇ 9ñ8Ñ€5ÚÁ‰Œµ™“K•P >#ÚÑ|uˇ åæûcœQ˘π” ^OMÚˇ ‰Œâ•“Kï7ì
o/ŸØ˘0Ø√ˇ #=\¬û¶Gó•ÃÜö#ü©úAoºk
±∆¢ä™  í£¶bì|‹ê+í¸	v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä•⁄Øô4›&ø_πäº]¿jì€oˆ+ñG•»5À è2ƒıŒﬂ/ZöDÚ‹ˇ ∆(»ˇ ìﬁé^4≤-S«Æˇ Á!aV"÷≈ô{î/¸*§üÒ<∏i;ÀQ’˜û„˛rU'˜÷Í?ÀﬂÒè&4ëÛ`uRÚC∑Á÷∫›"µ_í?Òó%˘X±¸ÃñßÁ∆º:«l~hﬂ¬L?ïä˛fJ´˘˝≠◊‚Ç‘èıdÛ;"t±ÛH’K…oˇ 9	r£˜ˆ1±ˇ &Bø≠d»˛Pw≤¸—ÓG[ˇ ŒB¬ÕIÏ≈f¯4q‰ìÕò’˘&ˆˇ ü¨„πéΩIE ¿»Õˇ ê:Iy3®ß∂_ö~[º<cΩE?Ò`dR™/¸6TtÛxû¨Ç«V≥‘6S≈8LnØˇ ')0#ònëEdY;v*ÏUÿ´±WbÆ≈Xwôø*t]v≤z_V∏?Ó»hµ?Â«˝€ïÛˇ /2a®î§„OOy<óÕ_ì˙∂â kqıÀaø8«ƒ˘q}Ø¯k¸ÃπüèQy83¡(±]^æ—.ÕÑ≠£cƒÏ…t?Ø˘-ó "[ò»«pıˇ '~y[›Òµ◊TA/OY~¡ˇ ]~‘ÏyØ¸cÕ~M/Xπ¯ı=$ıHfIëeâÉ∆‡e5å¨:å¡"ú–mvªv*ÏUÿ´±WbÆ≈]äªq ä¡≈_(y∑D:&©sßü˜TÑ/˙á„âøŸFÀõËKà[£úxM>√ˇ úx¸‚—?¡÷ñöÊ°misdZ€åÚ¨d¢o*»ﬂg“eOˆ6FúæL&ÉZ∞Ø¸ƒGˇ 5b®Î?Ãè,ﬁÌm™ŸH|‚2‚x™{my“Û∑ëd_`√˛W≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªc~f¸«ÚÔñ?„µ®[€?Ú;éÚ)k'¸&*ÚÕ{˛s…ˆ$≠Ç]_0ËR1üˆS≤?¸í≈X>•ˇ 9¡1$i˙B(Ïeúü¯Tâ‚x´ªˇ ú”ÛKüÙ{;˛k#ÃÂ≈P_Ù9^tˇ }Xˇ »óˇ ™ÿ™Ωø¸Êõ–˛ˆﬁ¡«¸cê~©±TN´ˇ 9ë¨j∫mŒõ>ünçsëzëªÇº‘ß0èŒºy>*˘„}9•~f˘n‰,0]§T 1Ä‘Â Xˇ ·≥O,Óv—œˆOky‚z∂“$±ûåå¡.còëÕºHJ∏;v*ÏUÿ´±Wb¨gÛÀÃz<÷ëä‹%%á˝u˝ü˘Ëú„ˇ gó‡üö3Cä/*¸†Û˝∑óæ±a™πä’ˇ xç≈èØVoﬁ/˘˛^gj0ôÓ,x6*˛n¸ªæÂm¢)µÑ‘z≠C!ˇ Wˆb˙9øÚæz`9ÓúöíylÛàaª’ÓBF$∏∫ôΩŸòü⁄9ô∞q7/JÚØ‰U›ﬂı…>≠_I(“ıõx„ˇ íüÍÆa‰’Àw.byÏı/y3JÚÚ”N∑TzP»~'>?ºoã˝ä¸‰ÊÚ |‹Ëbåy'YSk±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏU-÷¸…ßhq˙⁄îÈù¿cÒı#Zªˇ ∞\≤Ãπ5À è7öÎˇ ü∞«XÙks!Ì$€/¸äOâá¸ÙOıs2OÁ8ì’w<ÔZ¸…◊µä≠≈”¨dSÑ_ªZïÈÒÂ˛Ã∂fGc»8íÀ)s,`öÓzÂ≠Mb´—û**Oaäß6~I◊oEmtÎπA˛H$o¯ä‚©¥ìæqúrèFæ°Ò∑qˇ \UQˇ %<ËùtkÔ¢?®b©eœÂ«ômEg“Øêxµ¥Äƒ1TíÍ {FÙÓchü¡Å˛C‚Æ≈]ä∂7qVE•˛ak⁄a⁄ˆZÇªsZ©/5T±F\√drHr,ªG¸¸‘ÌËöå\®Í Ll}…¯„ˇ íkòÚ“ƒÚŸ»é™Cõ8—ˇ ;tÍ-ÀIhÙﬁ-TüÚ^/S˛cÃiid9n‰GSœfqe®[_«ÎY ìG¸—∞aˇ πç(òÛrDÅ‰ØëdÏUÿ´±WbÆ≈Xóõˇ ,¥Ø2÷Y–ª?ÓË¿©?Òb˝ô?‚ÒfdcŒaÊ„‰¿$ˇ 8˛\Í~XrÛß´k⁄dØ˚?˜Ÿˇ _Ì~«,Ÿ„ '…◊dƒaÕØ&˛aÍ>Víê7´hM^?	?ÃøÔ∂ˇ )~◊ÌÚ«&!>h«î√ìﬂº£Áç;Õ˙ñO∆exZú◊∑O⁄OÚ◊˛æ’dƒaÕ⁄c '…êe-Œ≈]äªv*ÏUÿ´ÛgÊ&ïÂvﬂ3¥Ï°ñ4BI£ó&„Uˇ ~e¯ôÓ2fÊÛMkÛˆ˙bSK∑é"ú§´∑Õi¡˝í…ô±“Õ√ñ®ûL?Q¸…Û˘¨∑“Ø¸b>òˇ í"<»¢:4≤=Xı≈ƒó.eùöI´1©?IÀZîqWbÆ≈QV:çÕÉ˙∂r…ˇ 4lT˝Îä≥Ø.˛˘◊A*-µIÂE˝â»ôiÛüõ¿‚Ø_Úá¸ÊºËV/3iÎ"wñ–—ø‰D«âˇ ë…äæÄÚ7ÊﬂñºÓÉÙ%‚I5*aÇQˇ <ü‚ˇ dúì¸¨Uò‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb≠ ﬂ¶*ÒøÃœ˘ -˘<µùâ˝)®-Gßü¯∂„‚_ˆ1¨üÂq≈_2˘Á˛rKÕ˛l-÷çç£W˜6µMøÀó˚Áˇ É„˛N*ÚÈdyXªíXÓIÍqU<UpöŒ*ö⁄˘OXª∂≤πî‰Ö€˛"∏™+˛UÁô?Í’}ˇ H“ˇ Õ™î˛G◊`õNªA˛T¯◊JÆ-&∂<gFå¯0#ı‚™´±TMùÙˆN&µë‚îÜF*G“∏¥ÉL„À_õ>dÇXÌæº\ÒX‰^LI;RD„+7˙Ã˘è<?—r!ûCÕÙ$CôÄY
éAM@4¯∏µí◊¸ú‘'j<◊‡K±WbÆ≈]äº„œ?úñz?+='ç’‡ÿ∑X–˚ï˛Òˇ …Oá˘üˆ37òÀy8yu l}w%ı√‹Àº≤πv†‚c»Ï3f:“mË^N¸ñø’x‹Í’≥∂4!H˝Îı?›_ÎIÒ≈mòπ5";SìèNeœg¥y{ ⁄wó‚ÙtËV=ÄgÍÌOÁê¸Mˇ ˛\÷œ!ü7cbì\≠±ÿ´±WbÆ≈]äªv*ÏUçk?ôêJ‹]£H+EY›è•»!ˇ åÖ2¯‡î∫4K4c’ÑÍˇ Ûê6ÈU”-CMûf
ˇ åq˙úá¸ÙL…éìº∏Ú’w#®~wyäÂπA$V¿vé0kˇ #˝o¯◊2ö!†Í$RkÔÃü0ﬁÔ-ÙÀˇ œßˇ &}<∞bàË÷r»ıKn<œ™\m=ÂƒÉ¸©]ø‚Mìá(s)‹ª}Á"◊%‹—ö´∞>ƒ„Kh¯|Ÿ´¡¥7◊(?…ô«Íl ÙHëS[Õ1ŸäG{#¯∞,üÚu_+8bz6“Yù˘Ò≠[Ä∑Q¡pRT´•ßˇ $Ú£•âmôW•˛i”:Ö¥∂Á≈ê}?›7¸
6Q-!Ë[£™C7—|Ô£kD%Ö‹o!4O?(‰‡ÌÙ.bÀ£Ã91Àr)ﬁT⁄ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ™[Øyé√AÉÎ:îÀ
vÆÏ«¡|O˛«,Ü3>Msòè7èy∑ÛŒÓÛïæàüVÑÌÍΩá‰ª§Ì¸¨π∞«•ûÓMI<∂yùÌÏ˜“µÕ”¥≤π´3I>Á3 ßõQDi*ä±ÿÖKÚ¸„üú¸–X,ç≠ªªnè§)˛£~˝øÿ≈äΩüÀÛÑ∂ë“O0ÍRH{«lÅ¸çó‘Âˇ "ìzñÉˇ 8ﬂ‰möj\?Û\ññøÏ$>ü¸&*œ4œ.È∫RÑ”Ì`∑Q–Eß¸AWLqWbÆ≈]ä°Ó¨`ª_N‚5ïOgP√˛a˙Á‰óìu∞~π§€rn≠zMˇ ¶ÿ´Õ<Àˇ 8cÂ´‡_Gππ∞êÙD…ˇ ¸%ˇ í¯´«¸›ˇ 8çÊ˝î∫o•©¬?ﬂ-¡ÈÔº‡RI1WéÍ˙-ˆè;ZjVÚ[NΩRT(√˝ãåUäªv*ã”ı+ù:Q=úØ££F≈Oﬁ∏æiπ=Àˇ ûZ≠ÅÍ*∑±xö$îˇ Y¯$fˇ /1g¶âÂÈra©êÁÍzóñø3¥]|à·õ—úˇ ∫¶¢∑˚ˆ˝ãÚˇ '0gÇQsaû2eyé‰;v*ÏUÿ™ŸbIë¢ïC£XTz´‘aêEºìœüí©({Ô/2ukrhßm˝˚?Òç˛Âe˚üãS“_Èú∫n±˘<éﬁÊÛDª¬œou‡ FÃ¨ß˛"Ÿû@êpÅ1/x¸∫¸’ÉÃ!lu∞Í6Y?‘˛Y?‚ø¯‰Mfm?„ÈvXsÒlyΩ0‹∑bÆ≈]äªv*ÛüŒﬂ+˛í“∆ß
÷{=⁄ùLgÌˆ˝è∑˛Ø©ô∫Y—Æ˜S‹˘˜6é±û~Y~Nk_ò∆e— [qı≤q„œó≈Dí7ÏbØ_”Á5°‘5h"ÒB“~.b¨í€˛pãGQ˛ë™\πˇ "4_¯ó©ä¢è¸·/ó)∂°{_˘Áˇ TÒTÁ¸·ò¿˝WVùnp´ƒZ,UâÎÛÑ˙Ï ∂ô®€\ë–HØ?wÆ1Wõyü˛q˜Œæ[%÷õ$∞Ø˚≤ﬁì->Qruˇ fãäºˆXö&(‡´)°®≈W€\Ài"ÕÂCUe4 èÂaäΩ˚Úß˛r◊U–ô4ˇ 5Ú‘,vø˚æ1Óz\ıˇ yˇ ~Œ*˙ÁÀ>i”ºœdö¶è:\⁄…—êÙ=’«⁄G_⁄F¯±T€v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±TõÕ~l”|©a&≠¨Ã∞Zƒ7c‘üŸD_µ$ç˚(∏´‚ﬂŒ/˘…}_ŒÏ˙vñ_O—Œ∆54ñQˇ //Ïˇ ≈)?©äº[d^QÚπÁ	˛≠°ZKt„ÌUˇ åíµ#è˝ìbØ}Úw¸·U‘¡eÛ=¯ÑÃ6£ì}3À)˘E&*ˆ/.ˇ Œ3˘E°]<]H?nÈöZˇ œ6˝œ¸í≈^Å¶ygK“î&üi≤é—Dâˇ \U3≈]äªPπ≥Ü‰qû5ë|C¯lUåjˇ îûS’Íotõ7c˚BVˇ Éèãˇ √bØôÁ&ˇ .¸ë‰{xa— xu{¶‰±¨¨»ë∑#§æ°¯è¡ƒø∂ﬂÓºUÛû*ˆø…$zI˛ º_â™∂‡¯tyŸ}Ñˇ g˛Nkı9Ñ9˙lƒ^ªöÁ`ÏUÿ´±T=˛°oß@˜wí,PF*Œ∆ÄÛÈ¸Ÿ(ƒ»–c)ã/	¸¿¸ﬁ∏÷˘XÈD¡bAVnè =yæ„ˇ #ˆøo˘3iãN!π˙ùf\Ê[•à˘[ 7˛e∏˙∂ûúÄ˚nvDÃÌ˙óÌ6_9à-Åô†˜Ø$~WÈ˛XpﬂÈ¿o+
Ø˚È7·˛ø˜üÂ*∑’ÂŒg∑ ÏÒ‡˜≥,∆r]äªv*ÏUÿ´±Wb©ò|Ô§y|®\*…˛˚_â˙W˚¥´-ô¯Ø˘Yl0 \ößñ1ÊÛMÛˆW&=‹"ÙOπˇ ëHhøÚ2Oıs6A’√û®Ùy÷πÁ=_]'ÙÖÃí!5‡ˇ ëI∆?¯\Àé1AƒîÃπ§yc¿$–u≈YfÖ˘OÊΩváN“ÆÂC—˝&Tˇ ëípè˛g_¸‚gûØÄim‡µØ˚˙uˇ ô>∂*…løÁ
<« Ó˛ #‡û£ˇ Ã∏ÒT≈Á5>-^ÚÖè¸Ã≈Z˘¬HÉVÄüxX∆Ìä•Wˇ ÛÖ~hàV“Ú∆ofiˇ …ßˇ âb¨cUˇ úVÛÊû%ö\Åﬁêˇ ¬»—∑¸.*¡5ﬂÀø1h5:¶ùun´’û&„ˇ #8ˇ Ü≈XÊ*ÿ4‹u≈YGóø2µΩãopdÑl"ó„ZÀÀ‚Aˇ ›2ô·åπ∂√,£…Í[¸ˆ”Ó¿ãXå⁄I–∫’„¸?xüÍÒì˝|¬ûîè•ÕÜ®oI≥ΩÇˆ!qk"Ktt` Ÿ.ŸÑbG7,HJÿ;v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØ1ÛœÁ=æòMûâ∆Êze≠cC˛M?Ω?ÚO˛2|Kôÿ¥◊ºú,∫ö⁄/’ıõΩ^sw+M3~”ü‰Øe_ıscÅ∞uÊDÓTÏ4˚çBt¥≥çÁûC≈5,Ã|W‚lì–ó_ÛáöæÆÔÕ˛é∑;˙)Gúès˝‘?ÏΩVˇ äÒW“æG¸ùÚ«íïNèdã8ˇ w…Ò Á´˝ü˘Á¡…≈YÆ*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±T£Ã>T“¸…¥÷maªá˘e@‘ˇ TıVˇ )qWœøò_ÛÜv7AÓ¸°pm•‹˝^r^3˛JM˝ÏÏ˝lUÛ?ú|É≠˘6ÁÍzı¨ñ“oƒëT`?j)W˜rı[cò´7ÚØútì∆√Õˆ}c–OÓÆ¢)2|7
øÔ´ØS¸áLUËwøÛåÉÃ#[¸ª‘¢’,œ˚¶jG2ü˜€Ó˝_¯Àı|U„~aÚ∆ßÂÀìe¨[Kip?fU*~k¸Î˛R|8™}ÂOÕM_ÀÂbÁıõQ∑•.ÙÒ[˝∏È¸´˚øÚ2åò#6¯fî—‰ˇ ÃÕ/Ã‘ä&Ù.œ˚¶B*„tê√ˇ ≈y≠…Ä√ÕÿcŒ&À3»v*ÏUÿ´±VÁﬂÀk?4∆”%!ø·ñõ5> MO¥øÂ}¥ˇ +ÏfN,Êçóüıü=kzÊát÷w—ò¶S”±ˇ )}•?Ãπ∂åÑÖáW(òö/_¸≤¸⁄˙˜+[zN6és˚‰Àˇ ≈ü∑˚ƒ¯Ù˝bÁaœ“OWÕ{ûÏUÿ´±Wb´&Ö'FäUÇ¨§Tve#¿·êEæWÛüñﬂÀ∫§˙sT¢5ccΩQæ(…ˇ +è⁄ˇ +7òÁ∆-“‰á	¶]ˇ 8ˇ ˘à|èÊõ{©€çç…˙ΩÕzps¥üÛ∆N©œ,k~ÑÉ]∆*ÏUÿ´±WbÆ≈Xùø)º∑ÁD+≠YG$§m2éè˘Ïîˆ-…?…≈_0~hŒ"Í⁄æ°ÂwmJ—jL,)p£¸êø«˚≈x´Á˘°x\« *ÍH äF*Àˇ ,ˇ 4ıÀ›@_È/XòèZ'”ï|ü˘$_ç?‡±Wﬁñˇ ô_Êñö∂í˚Ï≤ƒ«„âˇ ﬂr∆èˆd\Uñ‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ™EÁ?8i˛O”&÷ui=+hG˚&cˆ"çjG˝ü˘ß|	˘±˘∑™~cj&Ú˘åv±í-Ì‘¸©ˇ â»ﬂ∑/¸E>UÖZ€Ku"¡¥í9
™†íI˝ïQ‘‚Ø®?'ˇ ÁL´≠Áz®Ÿí…	Úı"Ùˇ å1≥ìˆ1W‘Nèg£€•ñùvˆ—ä,q(UB‚®‹Uÿ´±WbÆ≈]äªI¸ŸÊ{?+Èw:÷§¸-≠PªxüÂEˇ .G‚â˛SbØŒo>y÷ÛŒö≈Œπ®öÀ;|+]ë˜q'˘(ü¸6*Ø˘y‰˜Û>§ñÏµéè3®µ˚#¸©>¬ˇ /€˝åß.Nm∏±Òö}9)
,Q(H–UÄ≤®4§€πó`K±Wb©vøÊ=—ÔÔﬂÑK∞vc˚)˛”∑¸‹ﬂN34NbÀÁ;y˛ˇ ÕS9ÙÌUâé;/Åc˚róˇ ≈sqèÄŸ‘‰ gÕ3¸ø¸≠∫Û1[Àí`”´ª˛””Ì,#˛‘oÖï˛ŒC.qøâñ,&’}§hˆö=∫⁄XD∞¬Ωîu?Ã«´7˘Mö©L»Ÿvëàà†å»3v*ÏUÿ´±WbÆ≈X_ö6¥m
±#˝n‰∫‚ ÄÀóÏ/˚o˛Fec” _—qß®å|ﬁIÊ_ÕÌoY&8§˙§ˆ!$ï/˜ü<¸åœÜ≈¡ûyIÉì]œ\»q◊"3∞U'†≈^©‰o˘∆ü7˘¨,ﬂV˙Ö´P˙∑uJèÚ!£Lﬂ? ≈^ÒÂ˘√?/i¿IØ\M®À›˙1ˇ ¬7¸ñ≈^≈ÂœÀü.˘h–˙}µ≥€H«?˘’êˇ ¡b¨èv*ÏUÿ´±WbÆ≈Z C∏8´Û7Âï<ÃÙ¶ôo$ç÷E^»ÿxIˇ äºkŒÛÖzmœ)|µ|ˆØ‘Ep=D˘	å©˛À’≈^Áü»Ø6y,4∫ïõ=™ı∏∑˝‰tÒf_é?˘Ïë‚Ø>≈SmÃ⁄ÜÉ/Ø¶L–∑Ì j≠˛∫7¿ˇ Ïó·˝úÑ†%Õúfc…Ï˛O¸Î≤‘Ÿmuuó`ı˝Ÿ>‰Ô˚/É¸º◊‰“ëº\¸zêv/JV)®"†é„0\∆ÒK±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®}CP∑”†{ª…(#gc@˘ÙµíåLç2êà≤OÃ/Õõù|õ-0¥ÉŸ‰ˇ ^üf?¯Ø˛¸ùÆü©’ÂŒg∞˙^uôN3÷ˇ (ˇ Áuœ?≤ﬁ éêMMƒãªè˘vèoS˛2|1ï˚8´ÏoÀø _/˘‹E£[Å9{á£Jˇ ÎI˚+˛Bpè¸úUô‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±T∑]Ú˝Üøjˆ¨‹€?⁄I£Á˛∑˘KäæZ¸€ˇ úCû»>ß‰¢”¬7k75uÚÔ/˚∑˛1…˚œÚ‰lUÛM’§∂í¥— Ñ´+#ˆYN*»|É˘á¨yPñâ7¶ÊÇD;§ã¸í«˚Kˇ ü∞Àäæ—ÚÊ'ïø;4£e®€D◊HµûŒp©ˇ ~¿ˇ h«ˇ «¬D˝æ´Ã3?Á≈˜…sÁÍó¯Aqˇ Mˇ #±WÃ⁄ﬁÖ†]µÜ©ñ◊Qüâa˝ü ÿ´;ÚWÁMÊñV◊XÂuj:?YW˝ì$_g¯øÀ˝åƒÀß‹l\ºzÉéÔo“uãM^wa*Õm…OC¸¨:´íﬂjÂEÿ∆BB¬3"Õÿ´±Wb©ú<õeÊõ_´^2-LrØ⁄CÌ¸ m?k˝n-ób `Zrcõ|ÕÂõœ-^·G≤˝ñ_Ÿto¯én!11a‘Œ&ã’*?4—MWoﬁRê {ˇ ≈oÔ¸≠ò9spgË^∑ö˜=ÿ´±WbÆ≈^[˘ÔÂØ≠X«¨¬µíÿê˜Ùÿ¸'˝Ñø≥ˇ ÚÃÌ,Ë∏:®X‚xNl›sÔÔ˘∆ÔÃ/Òóïa˙√Úæ∞•¥ıÍxè‹Àˇ ="˝Ø˜‚…äΩ[v*ÏUÿ´±WbÆ≈^=˘€ˇ 8Ò¶˘˛ø∞	g≠®®ò
,¥˝ãêø≥}¥ˇ -~U˛øÂ˚Ô/ﬂK•Íë4P7GÉ¸Uæ“≤˝•¯±T˚ÚøÛ+Q¸æ’„’¥ˆ¨fã<$¸2«_âﬂ˝ˆˇ ∞¯´Ù' >j±Û^ôµ•∏í⁄·y)ÓÌ#èŸx€‡|U:≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUF‚‚;x⁄iò$h31† L«Âäæ¸˛¸„óÛX)lÃ∫5°)oNG£\∫ˇ <ü±¸ë|?ÔŒJº“¬¬}B‚;KDigôÇ"(´31‚™£ƒ‚Ø∏!?Á-<ánöÆ™´>π"Ó«uÄ˜T?Âˇ ø&ˇ bü€UÌ8´±WbÆ≈]äªv*ÏUÿ´„O˘À_ÕØ”öó¯KMí∂6[ÜS¥ìˇ æˇ ’∂˚?ÒóüÚ.*˘Ú⁄⁄KôVT¥éh™:ìäæú¸æÚzy_MKb∫íè;Ä7n…_Âà|+˛…ˇ o4π≤qóqá dŸC{±Wb©oòº≈iÂ˚7øøn1Æ¿¨›ëvoÛ¯r»@Ã–kúƒóÕ~sÛùﬂönÕÕ…„‘E; ˇ çùøiøk˝^9∏«å@Pu2õ,”ÚœÚòÍa5]e
⁄ö4qåÉ≥øÚƒﬂˇ ÍqÃ|˙éá7#-œ'∏EBãJUQ@ ÿ*Å–’ìn»
]ä]äªv*ÏUÿ´ÛáÊ^óÂÄbïΩ{ø˜ÃdT∆VÈˇ áˇ ä€21‡3qÚgxßöˇ 4u0÷'´⁄ü˜TU è¯±æ‘üÒÚ3eè`ÎßöSaŸ{K±Wµ˛XŒ-yáÕ‹/uA˙/Nj“)ı\≈PlG˙Úˇ 'û*˙´Ú˚Ú?ÀFU}2‘Iv:‹ÕGñø‰µ8≈ˇ <R<Uü‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*— ä¡≈^S˘âˇ 8€Â_9á∏˝B˝∑ıÌÄZü¯∂Ó§ˇ Ñì˛,≈_(~gŒ>˘è»%ÆgãÎzp;\¿	P?‚‰˚p≤˝ﬂ¸Yäº«f~I¸Œ‘<∞D?ÔEè˚Âç)ΩyDÙ>ôˇ Ñˇ 'ó≈îe¬&ﬂè1Éﬂ¸∑Êõ1[˝gNê8‰ágBfD˝ü¯ã~À6jgå¿ÓÌ!êLlõemé≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®=_W∂—Ìûˆıƒp∆7?©T~”7ÏÆJ124JB"ÀÁ?>˛`]yÆj≈dç˚∏´ˇ ˇ Ãˇ Ò‹bƒ N\¶eä€[…u"√óï»UU$ùÇ™åΩ•ıá‰á¸‚úV¢=oŒ—âe4h¨NÍøÂ];≈c˝˘œÏ™Ø¶‚âbPà P  
 *øv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÂú?êZ?Ê$MsAi´™—.T}™}î∏O˜jï˝‚¬‚Øà|Î‰]W…ZÉÈZ‹&)óu#uuÌ$O˚i˛m≈±TøC◊Øt+»ı2g∑∫Ö™í!°Á˚Kˆ[}Õ˘˘Òi˘ãkı;Œ0kp-eàl≤(ˇ w¡Ì˛¸è˝◊˛¶*Õ<ı˘o¢yÊ”ÍZÌ∫ ˜rÜHœåR˝•ˇ WÏ7Ì´bØçø8øÁ5ü"‘,Åø—∆Êd_é1ˇ /è≥ˇ S˜ÒãÏ‚Ø7Ú∑õ/¸µsıù=È_∂ç∫8˛W_¯èÌ/ÏÂsÄò¢Œ16Cy#Û«ÕpìÓÆêVHXÓÛ°ˇ vG˛WÏ˛ﬂá59pò{ùÆ,¬~ˆOî7ªv*ÏU"ÛáìÏ¸”flÓ«Zò•‚FÒÃ≠˚i˚Îpu∑SmY1âáÕ^cÚÌÁóØ∆˘x»ªÇ>ÀŸx€∫ü˘µæ,‹¬bB√®îLM≤~R˛e]Fè™5ow!ˇ v(˝óˇ ãS˘ø›ã˛Z¸z˝Fı?kÙóßföÏUÿ´±UÎ(Ø†í“‡räddq‚¨8∂ö6∆B≈>QÛá.Ö®MßOˆ°z‚:£èı◊‚ÕÙ%ƒ-“J<&ûùˇ 8ª˘Ö˛ÛTvó∆ÀTﬁJÙ_Ùi?‰gÓˇ ’ï≤L_ybÆ≈]äªv*ÏUÿ´±Wêˇ ŒA~H¡˘É¶õ€	≠⁄)0∞€‘Qπ∂ìÁ˛Ío˜\ü‰<ò´‡˚õy-dh&Rí!* ¬Ñ’N*˜O˘≈OÕñÚŒ∞<π®=4›I¿Jù£ú¸1ø˙≥ˇ rˇ ÛÀ˘qW€X´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÛè¸ÂÔÊë“4Ë¸£ßΩ.o◊ù…uÑÜ?˙8uˇ ëQ≤ˇ ª1W«8´Ï˘ƒÔ…Ö”-Œö∫VÓÂ–—áÿàˇ ªˇ „$ˇ ±¸∞ˇ ∆\UÙû*ÏUÿ´±WbÆ≈]äªv*ÛOœœÕ¸øÚÙó0∞˝%uXmW∏r>)ø’Å~/ı˝5˝¨U˘˜4œ3ô$%ùâ$ìRI≈^≠˘%‰ëu/È˚≈¨Q Ô˚Rˇ œ/ÿˇ /‚˚Iò:ú¥8Cõ¶«gàΩ∑5é…ÿ´±T&Ø´[È≤_^7bc¸≈õˆrQâë†∆R_3˘„Œó^jº7¸0FHä vUØo€¯◊7XÒà
ü&C3eö˛U~V¬öŒ∞üË‚ç,>ﬂ¸Y ˇ }*ª?k‡¯_>~ÉëÉÓ^›ö«dÏUÿ´±WbÆ≈PZ∆µg£¿nı	VÜ’c‘ˇ *éÆﬂ‰ÆN024Jb"Àƒ|Î˘—y™k£Úµµ=_§≠˛…IÙó˝Oã¸øÿÕñ-0éÁrÎ≤j∂<ÃöÓzÊcà÷*…ºã˘}¨y‚¯i∫YπŸ#_ÁöNàøÕ˚±WŸøîÛçöëï/ØBÍ∏ﬂ÷u¯#?ÚÔ˚?Òëøy˛ßŸ≈^√äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä¨í1 *¿ Ç® ‚Øüø7ˇ ÁÙﬂ0	5O*p∞‘Y†Èá¸ëˇ Ô˛ßÓø‚ø€≈_!˘áÀó˛^º};VÅÌÆ£?r
ü˘K¸Æø~Œ*÷ÉÊ›
Âot˘réΩ√ËÎ˚Jó#(â
,£#aÙGê0Ì|◊°ΩA˚»´ˇ %"˛hˇ ·ìÏ∑ÏªÍ3a0˛´µ≈òO˙Ã∑1‹ábÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUB˛˛>	.Ó‹GJYÿÙ ü˚,îbdh1îÑEóÕˇ ò^üÕw4NQŸFuzˇ ≈í≈çˇ 	ˆ Õ∆,B‘e fX÷ó•‹Í∑1ÿÿ∆”\Ã¡#çYòÙ eÌ/∑?!Á≠<âÍ˙¬•∆∫‚µ˚I ?±åøÔ…øÿGÚı{f*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈XüÊ/Â∂ìÁÌ5¥Ω^:ı1J†zë?ÛƒﬂÒ%˚˚X´‡üÃﬂÀ-SÚ˜Tm/T^H’hfQJüŒû?›ë˝®€˝ã2¨wF÷nÙK∏µ-:VÜÍähTåU˜∑‰gÁ5ØÊFóY8≈´[(0çá¥Ò≈R…7¯?ïùW•∫,äUÄ*E;Ç*˘èÛ”˛q^;±&ª‰ò¬KªKdΩ≈Ìëø‚è±˛˙·ˆWÀ6ówz-ÿûh.†b<X2≤ˇ ¬≤‡"ˆ)∑†.?2°ÛDUπ§Zä-YGGˆ„ˇ ç”ˆ‚:úÿ87K¥√õècı3å≈rùäªv*∆<ˇ ‰x|◊b`$Gu≈á±˛GÔÈøÌ/€˝û9~º…£..1Ê˘∂Ê⁄ÛCº1J∏±°VX¬∂n§É˙'Ú◊œIÊõﬂ/† L†RøÀ*èÂ⁄˛W˛_É59ÒpËª\9x«ÙôÜc9≈]äªxˇ Á◊ñ*∞Î∞(¯u1w˛Âˇ ‚HÕˇ ◊6:Iˇ Ø’C¯û4é—∞e4a∏#6ÙWÚKœ√œ>W¥’]´t´Ë‹x˙±¸.ﬂÛ”·õ˛zb¨Ûv*ÏUÿ´±WbÆ≈]äæ>ˇ úæ¸™]Íy√NJ[ﬁ7†£eöüøÛ›~◊¸Zúø›∏´ÊÙvBMËqWËw‰GÊÛﬂïÌµõïÏ_∏πÒıè˛zß	Ÿ‚ØC≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Ö‘o·”≠•Ω∫`ê¿ç$å{*énﬂ8´ÛkÛŒWr◊nı€™÷ÊBQOÏ†¯aè˝Ñ\WdëóœæfÉOîcÔÓè¸VÑ~Ô˛{?ˇ Ÿr˝úU˙I
„Q@ @ Ìä™bÆ≈]äªv*ÏUÿ´±U)ÊH•ïÇ¢ÃI† u'~{˛z˛gI˘ÅÊoc'Ù|Ü’»S˝Ì?öf˝Á¸~∆*√¸ØÂ˘¸¡®Cß[ÏdoâøïG€ˆ+˚?µˆrü≤Œ‚4Tiöle¥vVäî*Å‡?„f˚M˛VhÂ.#e›F<"Ç'"…ÿ´RH±©w!UA$ì@ ÍIƒA4˘ÀÛCœÌÊkø´⁄π˝¯NmﬁV„Ú'ÚÛ|‹`≈¿?§Íse„?—G~U~[ù~a©Í˛„‚;)ˇ v∏˝è¯ƒß˚œÊ˚œ¬9Ûp
S,x˜?Kﬂ’BÄ™(¿‘ªVÒWbÆ≈]äªaﬁ{¸Ã±Ú≤ìﬂëƒŸØFôø`~◊∂ˇ Í¸yìãûˇ ¬„eŒ!∑Ò<ÃûhøÛ¡∫‘$.eEB ˛X”ˆ„o⁄Õ¨ "(:…L»ŸIÚläΩOÚ_Ú#S¸«∏[]6§∑}ØÌ«˚≤_˘'Ìˇ æŸW‹~OÚVï‰Ì=4ΩÇ›74›òˇ ø%µ#‚©ˆ*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±V˘õ˘M£~aŸ}SUèåË£pÄzëüÚ[ˆì˘¢oÖø÷¯±W¬üôﬂïzøÂÊ†l5TÂT√pø› £∫ˇ +è€çæ4ˇ Wã≤¨WO‘.4˘ñÍ—⁄)£ ´)°¸ˇ gÕ ◊'—_óò±y¶FzGÇÍ:0ˇ ~'¸lπ®ÕáÉqÙª\9∏ˆ?S4Ãg%ÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äºÛoÛÎW'K∞`l mŸO˜é?kóÚ'Ï¡ˇ /∂ü≥ı:¨˘xç•ÁñˆÚ\H∞¬•‰r®$úÀq_oˇ Œ:˛CE‰kU÷µÑÆ\/NæÇ0˛È‚÷ˇ w?¸ÚOáó®´€ÒWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´¸ƒ¸º”<˚•I£ÍÀUoä9 ¯‚Ÿñ3ˇ ˛⁄¸/äø??0¸Å®˘VóE’„M„ê}ô˝âS¸ñˇ ÖnI˚8™…søÚn´µ•∑·;èŸu?n)<RE¯ÊÏU˙˘{Á´<hÎzi˝‹¢éÑ¸Q∏˛Úˇ )·ó„˝¨UìbØˇ úÉˇ úuáŒqæø†"≈≠†´††[Ä?õ˘n?ﬂr˛ﬂ˜r˛À∆´„nÙkœ€∑ª∂íÜª2:¡Ã≠ÄãH4˙+ÚÁœ—y™◊åîKË@ıPwÔ‘ˇ %ø·‡sQõ˛ãµ√óåIòf3íÏUÿ´±Wù~m˛_r‹Íñ˛ü¸@ª~œ¸dOÿ˛o±¸ôõßÕ¬xO'QããpÒO,˘äÁÀ∑…®Zö:0=n6ˆo¯\ÿŒ"BãØÑåMá‘:µo≠ŸE®Ÿö≈*‘xÉ˚HﬂÂ#|-öI¿ƒ—w0êê∞è»3v*ÏUÆik3i◊›ŒÖO±˝ñ˘£|kìÑ∏M∞úxÖ>O‘l%”Ó$¥úqíhÿx4lﬁÉ{∫B+gºŒ~`ù^ìÀw-KmMkz	–r_˘4ˇ ]b¬áŸ“ÃëR0U… b©{˘ßIC≈Ø-¡2ß¸’ä£-o†ª^v“$ã‚å¬‚®åUÿ´±WbÆ≈Xˇ û¸£oÊ˝ÔBªßßuP«ˆX|QIˇ <ÂU|U˘Ø™È≥ÈwSX])IÌ›£ëOfS¡«¸*˜˘√ü;+Ã3y~f§îd†'oZ!Ã¡EÍˇ ¬bØ¥qWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Ò?˘ÀO9 ß¬‹g’%
uÙ«Ô'?r¨Mˇ qW¬¯´Ìˇ ˘ƒo"ÀZùiu™ø©S‘BÑ§˝óÔ%ˇ ûãäΩ◊v*ÏUÿ´±WbÆ≈]äª|˘ˇ 9q˘°˙HW∞z^ÍKYà;•∏<O˝$7Óˇ „Õäæ.≈_A˛Ly;ÙFü˙R·iux†äıX˛“»œÔ˛yÊ´Sìà–ËÏÙÿË_{—sÃv*ÏU‰?ù^|1)ÚıÉ|M˛Ù∞Ï™¡˛ÀÌIˇ ˛¸\ÿÈ±ˇ 5◊Írˇ y˜ê|ô7öo÷‹Umc¯¶q˚+¸™ﬂè˚≥ôYrpqqc„4˙b¬∆#¥µA1(TQ–öYH»Ÿw(+‡dÏUÿ´±WbØ+¸À¸‹w-3C`◊=$òn¸ò˚4üÂ}îˇ _˚º¸:{ﬁNmEmçŸŸ_k◊´mnèu{pÙUgv?ãŸ:ÊqÊÔ'Y˛]Zç?S)wÊY‘3ƒ§4Vh√a'iØd_˘Ânø∆ﬁì‚Ø7≈^À˘˘	q˘Ör5-H4:-Ga≥J√˝”∑˚ˆ_Ÿˇ _}«•ÈV∫M¥v6¨6–®H„AEP<1Tf*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈R/8˘3LÛÜù.ë¨ƒ%∂î|ô[ˆdâˇ bDˇ ?á|˘Ω˘E®˛[ÍF“Ó≤ÿÕV∂∏Å¿˝ñ˛IS˝ÿüÒ´b¨+L‘Ó4ªÑº≥sÒö´«˛6\^≈ ÷·ÙßÂˇ û!Û]è≠@óQQfåt˘”˛+Ÿ˛_±˛Si≥b‡>Nﬂ^1Ê 2Ü˜bÆ≈]äªv*ÏUÿ´±WbÆ≈]äº€Ûõœ¢,ˇ DZ0˙’“ûduHè¬ŸIˆ’Á˛FfÈ±Y‚.£-⁄:«’ˇ Ûäí^ößùı∏˛&Ë10Ë?Â≠æÒÔˇ #ﬂx´Í\Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´Œø;ø)-1Ùf∂¢¶•n⁄Ã{7˚Èœ˚Ío≤ˇ À…˚´ÛÛS“Ótªôl/chÆ véDaB¨ßã)≈^£ˇ 8Á˘∫ﬁA÷Ñè˛‚/ä•¿Ïá˝◊sˇ <ˇ ›øÒW/ÚqWﬁà·¿e ©t¶*ø|˜ˇ 9/˘ûfÇO4˘~:j–≠gâ˜Ë⁄ «Ãkˇ #S‡˚Jò´‰Zπ—o#ø≥n3D’„£+íÀ∂FQYFF&√ÈÔ)y¢ﬂÃ∂	®[|5Ÿ–ıGi?Êñ˝•Õ.Lfù∆<úb”ú©µÿ´±WbØ¸‰Ú(—ÆøKY([;ñ£(˝âXÌŸ$˚I˛Õ~·õm>^!Gõ™‘b·69)˛N˘‹Ë◊ø£.€˝
ËÄ	;$ùæRvˇ ÏÏ¶:å\B«0∏2pö<ãË‘ªWbÆ≈]äº3Û€ ˇ UΩèZÑ~Ó‰pìŸ‘|-˛Œ?˘7õM,ÏWs¨‘¬ç˜º“¬˙{	“Ó—⁄)·`ËËHee<ï‘¯Æf∏j˙ØòuaΩMJÍkßÎY§g?Â±TªEÈ˙ïŒù(û gÇQ—£b§≤]ÒW∞~]ˇ ŒT˘üÀ.êÍ“V¿f?Ω˛+π˚|ø„7´äæ¡ÚÊ&ëÁΩ9uM^iˆ^6Ÿ„o‰ï?g¸üÿÿlUîbÆ≈]äª|9ˇ 9o‰—°˘∏ÍP≠ ’"m”‘_›N?‰o¯Àäºó öÙæ^’m5ãÔ-&IáøÂ«˝óŸ≈_¶∂±_€«wÂ»≤!ÒVó≈Q´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*¯Ø˛s/ÃÁQÛ<:«ß€äè	%˝„ˇ …!*˝HóZø∂”-ˇ æ∫ï!OıùÇ¯ñ*˝7—¥∏tã(4ÎQ∆h“$‰¢Ñ\Uäªv*ÏUk0PI4rN*˘◊ÛK˛rÚ√CôÙﬂ*ƒó˜Jµ√ìËÉˇ Ñ¯Áˇ [îqˇ +Iäº#Yˇ úñÛﬁ®Âé§÷Íz$à»Öı?‡üI◊ÛøŒ®j5õ ˚ «ı‚©Êìˇ 9;Á›9Å˝"gA˚3E˛ÀÇ…ˇ ä∞ü;yœPÛû©6µ´0kô®EGD_ŸP∏™a˘iÂÒ.™ëJ	µÜíL|@?Û–¸?ÍÛ sd‡›ãß”  (64éÂÿ´±V=Áø6«Âç5ÔMÌBßˆúçøÿß€o¯⁄À∞„„4”ó' |Õ]k7ÅWî◊WﬂrŒ«Ø˚&Õ÷¿:~eÙ◊ë¸£ïÙ‰≥å3Q¶q˚NFÙØÏ/ŸO˘©õ4πrqõw±
dKs±WbÆ≈]äº_ÛGÛ`Œd—¥G˝÷Î4‡˝ØÊé¸üÕ'˚≥ˆ?wÒI≤¡Ç∑ìÆÕûˆ>Úwì5O8ÍQÈ:4&kôOÚ™˛‘íøÏ"˛”∆Ÿû‡æ•Ω—t/˘«/-õ¯∏^yöÒLQ „rÙ¯Ω5ˇ u⁄√ˆüˆÂ˝⁄?€N
æF‘µ+ùNÊ[ÎŸ[â‹ºé∆•ôè&f≈^â˘˘7s˘è™pê4zU±s0Ó?fˇ ‚Ÿ‰ö|À…WﬂFìk£⁄Eaa√mé5
*ç≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb¨{œ>I”ºÈ•À£j© G¬√Ì#±,gˆ]?Ê÷¯qWÁ«ÊWÂÊ°‰-b]R]◊‚äE±ü±*|ˇ ma˘&*óySÃ◊>[øMB–˝ùù;:~“7œ˘øe≤Äò¢Œ16Ph∫≈æ≥g°hk´»W®ÒVˇ )O¬Ÿ§úLMs		‹É7bÆ≈]äªv*ÏUÿ´±Wb®=gVáH≥õP∫4ä.|M:*ˇ îÌ/˘Y(Gà–a9pã|≠ØÎw›Ï∫ÖŸYö¶ù ˚*´˛J®‚πΩåxEK)q,˜ÚÚ•ˇ 0uÙä·H“ÏÈ-À‚øø˙”∑¸ìı$≈˜¸$∞ƒ° U P ¿|±U\Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WÃÛóî"ÊÒæïÔb
ó™£Ì'ŸéÁÁ√üÒ_˜€bØí±W€Ûâﬂö'Ã⁄!Úı˚Úø“‘*wx>ÃG˛xˇ rﬂ‰˙X´ﬁqWbØé?Á*ˇ %∆Ét|ﬂ£«∆¬ÈÈuç£ôø›æ—‹¯	ø„*‚Ø#¸¥Û´y_P)≠ù≈aæ¬øøÎGˆø‘¯råÿ¯√vúÙ≤:»°–ÜVn>•"ù¿›ºRÏUÿ™Z“ ÷,Â”ÓÖbôJü‡À˛R7ƒπ8Hƒÿa8Ò
/ñ|√°O†ﬂÀß‹
IR£°iíÎÒfÓ2,£¬hæÄ¸™ÛÅÛñ·´ymHÂ?Õ˛˚ì˝ö˝ØÚ’øôsU®«¬}Ó”N!Ófyå‰ªv*ëy„ÀkÊ-&{îØ(é€Hªß^úæ√êÌóaü≠ß,8£OïH¶«Æn›3X´±WbÆ≈Y«ÂÊmÁÂÊµ´nY≠XÑπÑ§àüà∆D˚q7Ûˇ ìÀ~àÈöùæ©k˝õâ-ÁEí7
∞‰≠˜b®ºUÿ´±WÅŒd˘dj>UáWAY4˚Ö$¯G(Ùü˛J˙´‚åU˙	ˇ 8◊Ê≠˘Nw˛ÚŸZŸøÁìpè˛H˙x´‘1WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*¸⁄¸‹◊éΩÊÕWQ&´%‘Å˘ﬁî_ÚMeˇ Ûä˛_«ûmÖR…$πoˆ+Èß¸ïñ<U˜∂*ÏUÿ´±WbØúˇ Á/4f–Ï"Ú¶úÂ./–Ω√)°◊Äè˛{ø._Ò\lüÓÃUÒæ*ÏUÿ´±WbØ•ˇ *º©˛—”’Z]\“Y|EGÓ„ˇ ûi€˝¯“füQìä_’vÿ!√{1Ãg%ÿ´±WÕüö>p>c’—jŸ€÷8ácC˚…Á£…>9∫√èÄ:|Ÿ8À4¸çÚoo0‹ç€îpo˜døÓ◊˛zf6´'á#Mè¯ã◊Û\Ïäªv*ÏU‰?õˇ ô ˙ñˇ ™‹Hßq„ü˘;ˇ "ˇ õ6:|?ƒ]~£7áúy»˙óùµH¥m">s…ª≤¢è∑,ç˚(üÛj¸mõ˜áÂ◊Â∆â˘O¢8å®)ñÓÌ≈¯L«˘"è˝◊¸IŸôï|O˘√˘ïs˘ÉÆÀ´IU¥Z«m˝àî¸?Ï‰˛ÚOÚõ˘x‚©íºü}Ê˝VﬂD”î˜JˆU˝π¸à◊‚lU˙%‰#Xy#HÉD”Ó·g#‚ëœ˜ìI˛Sˇ ¬Ø¡ˆWdò´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wú~x~R€~ch≠lÆßn⁄Jv£wâ€˝ı7Ÿˆ~∆*¸¸‘,'”Æ$≥ªFä‚(Ë¬ÖYOV˘bØ@¸öÛ©“/E]5,Óò'¢J~?Û◊Ï7˚ÂÃMF.!còr¥˘8MEÔŸ©vÆ≈]äªv*ÏUÿ´±WbÆ≈^1˘ÛÊéoÉŸi,ﬂ3˝“¿˛Û˝ífÀKéáÆ’O¯^G;¨Q“1 π$ÙÃ˜˙˘!˘kê<πöÍ>Ω(]7å¨7Jˇ ,+˚•ˇ WóÌbØA≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*áΩ±Ü˙	-.êI®»Ë€ÜVYO˙Àäø:?7ˇ /fÚòÆtg©ÄR›œÌBﬂ›üıì˚ßˇ ãÒU/ Ø=M‰o0⁄ÎëT«qùGÌƒﬂÀˇ Ò'¸Y√~éŸﬁE{
\€∞í)Q]tea…X|◊W≈Pﬁãk≠ŸM¶j%∂∏FéE=¡≈_ùö>@∫ÚΩq°›Uñ3Œ˚q7˜R∆èˇ +Æ*Ùﬂ…8J…¥{ñ¨ˆ¢±ìRLdˇ Ã¶¯‘d˛\÷j±—‚ÀMí«	zn`πÆ≈]äªyáÁáîE˝ê÷≠÷≥⁄é2S©åü˘îÕÀ˝VÂÃÌ.J<.ßé'ñ˛]˘§˘oWäÌè˙;˛Óa˛Cu?ÏåüÂp·˚Yõñqß¯æ†V)¡iÀx•ÿ´±WŒ_ú>\˝≠<ÒäAyYó√ë?æ_¯?è˝Y7yÒG‹Í3√ÜL2\wbÆ≈]äª}√ˇ 8ÖÊ«÷<§tÈ⁄≤i≥¥K_˜€Z?πöDˇ aäΩœv*ÏUá~phü¶¸£´XÅV{IYG˘H=Xˇ ‰¢.*¸‹≈_`ˇ Œj˛Æç©ÈÑÔ L¸eNˆ/äæì≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª@k∫áËÌ>ÊÙˇ ∫!íO¯gˇ çqWÂÏíªnI©≈_Nˇ Œi<Ø5mMá˜qC
üıŸ‰˘2ò´ÎLUÿ´±WbÆ≈_üøÛí⁄€Íæ{‘Kö•ª%∫ àµˇ íÖ€yn*ÏUÿ´±Vc˘YÂ”˙Ãk*÷⁄ﬂ˜≤◊∏e=˝G¯[˛+Áîfü[∞√éO•ÛJÓ]äª`ú^j˝§õHO˙MÌcËÄ~˘ø‡wˇ =9˛∆eÈ±Ò˛kã®…¬+˘œÚáó%Û•ù¡Õ]©^(7vˇ Åˇ Ü„õ,ì·Îa#O©ÏÌ"≥Ü;ku	JvUTfåõ6]ÿ(*‡K±WbÆ≈^}˘≠˘Ü<Ωo˙>≈ø‹ÑÎZè˜ZΩOı€˝◊ˇ ¸úÛ4¯x∑?Kâü/√õ√|πÂ€Ô1ÍÈZjÆÆ"/â?¥ﬁ
£‚vÕ´´~Ä~N˛Qÿ~[ÈB ﬁíﬂJ\‹SwoÂ_ÂÜ?˜Z≥oç±Wíˇ Œb~gõ+Hºô`ÙñË	Æà=#˜Pˇ œW^o˛Lk˚2bØë1W€ﬂÛäﬂî√ ⁄7¯ÉQéöñ§Åî0ﬁ8≈≠7˜≤œ4˝åUÓÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_)Œ_˛Sà ˘ﬂLJ+Í®Ôˆaπˇ e˝ÃüÛ«¸¨UÚ»4‹u≈_L˛Xyø¸K•+ÃkwnDs{ö|œEˇ íã&iÛ„‡>˜oÉ'eŸå‰;v*ÏUÿ´±WbÆ≈T/Ô¢∞∑ñÓsH°Fv> 96J1‚4∆FÖæN÷ıyu{…ØÁ˚s;9ßjÙ_ˆ+Êˆ1·È$l€ÿÁˇ /ôºÀ˙ZÈ9Yi K∏ÿÃO˙:ˇ ∞*”œ?Ú≤L_q‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏU‡üÛó_óøßºº∫˝≤VÔJ<öùZ4ó˛E∑	ø‘ı1Wƒÿ´Ó˘ƒè=ù ÁH∏nW:SÖzò[„É˛˜êˇ ´‚Øs≈]äº7˛rªÚÃyõÀ«\≥JﬂÈ@…∞›°?ﬂß¸Û˛˘’Á≈_y[_ó@‘†‘°©15YGÌ)Ÿ”ø⁄_á!8Ò
g	põ}[ks‘IqäE¨:a…[È¢"ç;∞lZ¶ªv*≤hRth•PÒ∏* EAfR<i[Âü;ym¸π™ÕßµJ)ÂÀ#oÚøeˇ  \ﬁcü∑Kí&û◊˘5Êè”@≥ô´qcHœâB?rﬂ≠¸ÛÂ˚Y≠‘„·7¸Áa¶üØÊ≥Ïƒr›äª`üúû\:∂ä◊-g≥>®Ò·“aˇ ˚œ˘Áôzi øú‚ÍaqøÊærÕ≥™v*ÏUÿ´±W÷ÛÉ—∏∂÷◊Å{p>`M\Uı*ÏUÿ™ÖÂ∫‹C$/ˆ]YO…áU˘oqA#Dﬂi	SÙbØ•?Án∏Íöµ∑Û€ƒˇ Àˇ 3qW◊x´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªaˇ ú&€…⁄Ã™hEÖ¿˚„e˛8´Ûo}èˇ 8KlÀ˙ç«wºˇ 7¸Ã≈_F‚Æ≈]äªv*¸Óˇ úÅ¥{O=jÒ∏›Æ=AÚuY|UÁò´±WbÆ≈_E~K˘tiz(ªêRk”Í∑‡>W˛%"ˇ ∆\‘ÍgrØÊªM4*7¸Ê}òé[±WbØòø2º |√≠Mpáïº_∫ã√Ç˛◊¸Ù~R≥„õº0‡ç:l≥„ïΩCÚ; ˇ Q”€Xò~˙Ô·Oh‘ˇ Ã…>&ˇ Q0µY,πöhP∑¶ÊöÏUÿ´±T£Õ~dÉÀö|∫ç∆¸kBÓ~¬¯€¸éMñcá¶ºì‡˘{Y’Ó5õ…/Ó€úÚöü¯’W¸ï\›∆<"É¶ë≥eˆø¸„W‰¢˘#M∆´˝5zÄûCxb?¡˛K∑⁄ü˝å±ÒIã◊µΩ^ﬂF≤üSºnˆ—º≤Q…±WÊ«ùº’sÊÕfÔ\º˛ˆÓVzu‚øÓ∏«˘1«∆?ˆ8´0ˇ ú|¸¥ˇ yö+{îÂßZ~˛ÊΩ
©¯"ˇ û“qO¯«ÍbØ–EP† (¿Uv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Tµ£€kVSÈó…Í[\∆—Hæ*¬á~o~ay6„…öÂﬁÉwª[HBµ)Õ≈øÏ„‚ÿ™c˘QÊü–ƒbSK[™C!=OÓﬁΩ∏?⁄ˇ ä˘Ê>xq≈ø¯d˙O4Œ·ÿ´±WbÆ≈]äªv*Ûèœ=wÍ::X!£ﬁ=ﬂ∞îwˇ áÙ≥7K7¸◊U*ﬁ˘˚6é±˜ˇ ¸„_ë«ï|ükÍ/´·ıπ|x?røÏ Ùˇ ŸÚ≈^´äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±T6°c°o%ù áÜdh›Oua≈◊˛~iyÎ Ú˘S\º–Á©kIû0OÌ-kˇ œH¯æ*Ù_˘≈è9/y iñ˙íõW‰~8œ’Uè˛zbØºqWb™sDì!é@AU˘À˘«‰FÚ?ôÔ4p∑Wı 'ºOÒ«ˇ ˝—ˇ )1W•˛GyàÍKi“üﬁŸ5¸câ>Êı˝^´’Bç˜ª=4ÏWs—Û	Ãv*ÏUÿ´Àˇ =º∂.Ù¯ıà«ÔmHG#˝ˆÁjˇ ©-8ˇ ∆GÃÌ,Ë∏Z®X∑õ˛U˘îh:‹RJio?Ód=ÄcπØNqfo‰Áôô·«¯d˙c4ÆÂÿ´±UìBì£E*áç¡VS∏ ÏT·êEæRÛNÑ˙•qß=u!
ORß‚çœ˙—∑,ﬁ¬\B›$„¬i'…∞v*ÏUÿ´ÔØ˘∆?"IÂ?(ƒnî•›˚õ©ıP¿,)ˇ "ë_˝glUÎX´±WbÆ&õúU˘q¨∞k€Ç7Wˇ âUÙ¸· ˇ s⁄ëÌıEˇ ìãäæƒ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªa?ùä[…z»~•1˚î‚ØŒUˆg¸·;WÀ7Î‹_±˚‚á}äªv*ÏUÿ´‰/˘ÃÔ!ΩÆ£kÊ∏˙7H-Ê#¥âºLﬂÒñ/á˛x‚Øö1WbÆ≈QöFû˙ï‹6Q}π‰X≈|XÒ¡#B“ö}qkm¨Io„jGÄQ≈G›öl€ΩÖ*`K±V#˘ßÊ?–zŒÜì\~‚?b‡Ûoˆ1Ûˇ e«2t‚óπ«œ>æzÚ÷É.ª®A¶√≥L‘'˘WÌ;ˇ ∞Oã6≥ó∑UÒ}_km¨IoÑä5™:Q≈WË¢&Õª¿+eL	v*ÏUÿ´ÁOÕœ9çR˙µ≥r≥µ™°!õ˝Ÿ/!€ˆ¸ïÂ˚y∏¡èÄyóQü'Úz?¸‚ÂÛ¢|”™G]>¡«¢¨6íq∏?Í[¸/ˇ x+ÊKé˚C|˘ˇ 9çÁÉ•y~/[µ'‘§´Å˛˘àÜ?r˙_/äæ.≈_wˇ Œ,yyc ëﬁŒºo5B.ΩB˜ô?‰_ÔÁÆ*ˆ\Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äædˇ úœÚπ≥µÛu≤˛Ú‹ã{Ç;∆Ê∞ª©/$ˇ ûÿ´‰pi∏Îäæ•¸æÛÈ˝ﬁÒ»3ÙÂˇ ]~Ø˙ˇ üÏÛKö2w8g≈Eî7;v*ÏUÿ´±WbØü?<µÉyÆ}L}ãH’>l„’cˇ »øÏ3o¶çGﬁÍµπ{òˇ Â◊ñÕ>a∞—Îupä˛»)õ˝å\Œe8Ø“»¢HêFÄ*® –äØ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUä˘ÔÛ3BÚ-∑÷µ€ïáê™F>)˛1ƒ>#˛∑ÿ˛f≈_4y€˛sCUºfáÀëŸ√⁄Yˇ y!˜Ù«Ócˇ W˜ÿ´»5øŒo8k- ˜Wª?‰«!â‰\ö¬‚©Ûn∞[ëæπÂ„Î=‚X™u£~pyªFnVZµ‚Å˚-+HøÚ.oR?¯\UÎ^Jˇ úÃ◊,bÛ%ºWt2DRè}ørˇ Íã˝|UÙ«ÂÔÊœó¸˚´¢\ôE^¯eOı„˛_Ú”úÂb¨«v*ÏUÒ∑¸Êáî≈éªiØƒ¥K¯Ln|dÜÇøÚ)„ˇ ëx´ÁÌ;PõOπäˆÿÒöY¯2ûkˇ äøN|ª¨≈≠È∂∫¨›]CÀÚu¸qT«v*˘£˛sG…BÎN≥ÛD˚ÀW˙ºƒæﬂ‚âè¸cóíˇ œlUÛøÂπ˙+Ã+GuX˝ó˜ÚYcˇ cò˘·≈¸·ìÈ<”;ábÆ≈]ä°ıØÌ•≥úV)ëëá≥'%põc!bü&Îd∫U‰÷Sm,2ízèûobl[£"ç>öÚòOË÷˜¨‹¶„¬_kø/ﬁ™˘¶ÕS∏√>(€  [ùäªxwÁˆå∞ﬁ€jH ı—£zw1Ùf˘§úÁûlÙí±N∑U6ÚåŒpùäª}ˇ 8›ˇ 8ˇ /ö.cÛ.Ω]Âl?ﬁáS∂ﬂÚÃçˆˇ ﬂø›˝üS}®>X´±WbÆ≈Rﬂ1ÍK•ÈóWÚ-ºJO≤+?≈_óƒ‘‘ı≈_Qˇ ŒÈÃg÷/à¯U àrevˇ àÆ*˙√v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªH<˚¶˛ìÚ˛•cJ˙ˆì∆ªF 1WÊV*˙À˛pÉTm´È§ÓØ¿{0x€˛ ∏´Í,Uÿ´±WbÆ≈R?9˘F«Õ⁄U∆â©Ø+{Ö‚HÍ¨>$ë?Àç˛%≈_û?òøó∫óêıit}M7SXÂ·ïŸñ?cˇ ﬂb¨Wv*Ù/…'Î∫π?b÷6ìÊƒzJ?‰£?˚≈‘ £ÔrtÒπ>ÜÕC∂v*ÏU‡_ûö˜◊µd”ê˛ÓÕ(zSúüˇ ¬z_Ÿ∂“¬£Œuzô‹´˘©ø‰óCµ∆∑(Ø‹GZu4y[˛”Uˇ ^LØW=∏YÈa’ÏŸ≠v.≈]äªaøöﬁl>^“B‘∫∫¨Qxçøy'˚ˇ átÃù>>)U∆‘OÑ{ﬁÂ?-]˘£U∂—lWï≈‹ääOA_∂Ì˛J/Ô¸ïÕ√©~êy7 ñ~R“m¥M9x¡lÅF€±˝π¸πì∂*ù‚ØÅ?Á'|ﬂ˛#Û•⁄∆‹†∞“=ˇ ﬂﬂ…vóaøñæRo7yä«BZÒπôDÑuèﬁL~àïÒWÈD•ºkJU e≈UqWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Üæ‘-¥¯Õ≈‰©C´»¡T≤á`⁄üÁˇ ë¥“V}^›òæ´/¸òY*óCˇ 9;‰	à’ Øs¿…¨Uïhö^WÛÙΩN÷yD®˘¸dˇ Ö≈YN*ÏUÿ´±TèŒﬁXáÕ:-ÊâqNp¥u?≤ƒ~Ìˇ ÁõÒ|U˘°c5Öƒñó*Rh]£u=C)‚À˜‚ØW¸Ä÷ Õu§9¯]DÈÏVë…ˇ ?˘ò∏Ìnvñ[”⁄3ZÏ]äªv*ÏUÿ´x´‰Ø2jCT‘ÓØáŸögq_«á¸.o‚(S¢ë≥oiˇ ú5ÚÔ◊¸’>¶‚©alƒîàó˛I˙Ÿ&/µÒWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªx«Á◊¸‰∑ÂÙGK”8‹kr-Bù“?fYøôˇ ﬂq≤Éè5_Î˛aøÛ„Í:¨Ôsu!¯§ê‘ü˘•ï·_Ÿ≈RÃUÿ´±WbÆ≈Q⁄NØw£‹«}ß \ƒ‹íHÿ´)1WŸˇ Ûèˇ Ûë±yÿ.ÖØïáYQ8Ÿ. ˛_‰∏˛xˇ ›ün?‰U^Ôäªxè¸ÂÁóFß‰∑æ≤iÛ«0ˇ Uè’ﬂ˛O+±≈_‚ØæÁı„´˘…\’ÌKc˛¡πGˇ $§èzﬁ*ÏUå~e˘U|◊ÂÀ˝ÖZ‚	ˇ «	ˇ ë™ò´ÛaZKi-RDjéƒäæµ—5!™X¡~ª	‚I(;r∏ˇ ±Õ„¬Hwêó¥nAõ±WbÆ≈^˘Ô°˝STãRADªéçæÂ„¯kˇ "⁄,⁄ÈgqØÊ∫ΩLhﬂzc˘Ø%Œè!™∞ı„ˆ"ëÀˇ  ?¯»j·µ≥“Àz{>k]ã±Wb¨Û≥N˙ﬂóûnˆ“«/ﬁ}˘ùÀ2Ù≤©Sã©ç≈Û¶mùRg°ywP◊Óñ«I∑íÍ·∫$JX˛¸¨UıÂ¸‚,vlößùäÕ £-í†?ÚÛ ˛Û˛1'Óˇ ô‰˚8´È®!HbâB¢Ä Q@ Ï*©äªv*ÏU‰ﬂÛìﬁi]…à	Ø∏⁄†ÒıÔ‰ÇÀäæ≈_oŒ˘xÈæPmBAFøπyˇ êÄ@øÈ.*˜lUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªZ wPåU˘óÁ≠ ˘{]ø“SÍ∑∆£¸ê«”?Ïì|UÍÛà˛gGú÷ŒV§Zå˝9≠&ã˛M2/˙¯´ÓlUÿ´±WbÆ≈]ä∞ˇ ÃØÀ'ÛMm7UJ2‘≈2ÅŒ&˛t?Ò4˚/äæ¸–¸ù÷ˇ .ÆΩ-I=KG$Cs>õè˜‹üÒSˇ √Ø≈ä∞<UÔêzIÉL∏‘fπî(ˇ V1◊˛Gˇ ÅÕfÆ[ÄÏ¥±ÿó®föÏUFÚÓ;8$∫úÒä$gc‡™97·Ü"Õ1ë°oíu=B]NÓ[ŸçeùŸ⁄û,yPf¸
Ë…≥oß¸è°~Ç—Ì¨§äÅ§≠+Õæ9„¸¨‹?ÿÊó4¯§Kπ≈ÄûÂ-Æ≈]äª|ﬂ˘πÊS≠krG¨üπOò?Ωo¶Oá˝E\‹‡á]>yÒIÓüÛÜ_óT[ü9^&Ê∂÷µø„‚Uˇ ÖÖ[˛3.d4>®≈Rﬂ1Î1Ëöm÷´>—⁄√$Õ_Rˇ ÒÆ*¸∆ææñ˙ynÓ)fvëèã1‰«}ˇ 8WÂqw¨ﬂk“-VŒ
ÚÊ;ˇ ¿«/¸Ù≈_a‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*É’u[]&⁄KÎ˘Rhóì»‰QÓ«|π˘°ˇ 9ã+ªÿ˘&0±çç‰ÀR„ˆ÷õ˛E.*˘ÀÃ^l’|…?÷µã©ÆÂÒïÀS˝@~_ÚWIÒWbÆ≈^á‰?œè5˘1ïlokUÎopLë”¡C|qœLUıßÂ¸‰vâÁÚ∫|ˇ Ë±ÿ@ÌUêˇ Àºªsˇ åm∆Oı˛÷*ı‹Uÿ´±W¿üÛîVùØ5„K§ˇ f)/¸óIqV˘u™~å◊ÏÆ?d #jÙ§üπc˛«‘ÂïeèHm≈.˙è4nÈÿ´±WbÆ≈]ä•ﬁdΩk2ÓÓ3GÜ	]~j¨À¯Âò≈»ºÜ¢_$fı“>¿ˇ ú$“-S’¯¶πHkÌzüˆ1äæî≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Ûˇ ŒøÕ?.Ù5-öˆRbµå˛‘Ñ}¶Ô∏ó„¯€≈_üÆ´s´›K#Ms;óíG5,ƒÓÿ™v*ÏUÿ´±WbÆ≈QwsYLó6Ï—ÕFSB¨UïºF*˚ÔÚÛm14ORÊã™ŸÒéÂ’®˝‹Í?ín?ÏdW˝û8´‘qV+˘©£˛ôÚ∂´`Z[9∏ˇ ¨ºÍ∏´ÛW}wˇ 8C´	4ÕWL'xßéj∆E1ˇ ÿæ*˙gv*ÏU˘À˘ﬂÂ¡ÂÔ8Íñ
)÷T/Ô–¿…äΩCÚGR˙ﬂóí÷⁄Y#˙	ıøÊo‘Í£R∑i¶ï∆ôˆb9n≈]äªa?úZ!‘¸ø3†¨ñ§N>K…˜FŒˇ Ï3+M*óΩ≈‘F„Óxoêµè–˙›•Î®≤rz›Hÿ£ìõ<±‚âª∏dÍå—;∑bÆ≈RØ6X˝{Hº∂ìIÅG˘\O¯l≥©◊ê\K‰Ãﬁ∫GÿÛÑ˜ÒÀ°Í6î_V•rh+∆D
†ûøj≈_H‚Æ≈]äªv*ÏUÒG¸ÂﬂÊ"Î⁄¸~_≥~V∫X!»;⁄ûØ¸ä@±ˇ í˛Æ*›3NüS∫Ü∆’KœpÎj:ñc¡¸*˝.Úgñ‚Ú∆çg¢A∫Z@ëW˘àˇ ≥~Oäßx´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*¯ü˛s…«IÛ<z‹KH58Åc€’à§ˇ í^ãbØ–µâÙ[Î}NÃÒû⁄Tï˘HyÆ*˝,Úèômºœ§⁄ÎvF∞›ƒ≤÷Ñ˝§?ÂF‹ëø \U8≈]äªv*ÏUÿ´Á˘Õ2}KÀ∂z:=ı«6‰B*‰¨±bØåÒW’^C“øEhvvî£,JÃfﬁ∏ˇ ÉvÕ&iqHªú1®Ñ˚)nv*¡9µü—⁄ë)¯Óùa/∂ˇ ©√˝ûeÈ£ræÁS*çwºWÚÔE]g]¥¥p|˝G°T´)ˇ _èˆY±À.íÎÒGä@>§Õ∫v*ÏUÿ™IÁ]{Ùës®Ièß€oÇ>æ‹≤‹P‚êYe√|ªßiÛÍW1Y[)yÁuçπf<T¡fÒ“øK<èÂX<ß¢ŸËv‘ÙÌ"T®˝¶Î$üÛ“No˛ÀOqWîˇ ŒOÎgIÚ%ˇ Gπ1€Ø˚7^ÚId≈_ ‚Ø∏ˇ Á4ß˘0_S„øπñZˇ íüËÎ¯¬¯´‹qWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä•˙Ó∑i°YM©Í2≠m–ºé{¸îbØÇ:ø;ıÃ{‚†¥DL}`zˇ ≈”ˇ <Õˇ ÿO€wUÊ8´±WbÆ≈]äªUÜgÅƒëíÆ¶†çà#}áˇ 8€ˇ 9ﬁd·Â2…˛‰îRﬁ·è˜¿∫§ˇ óÖ˝ñˇ w∆OÔ}äª|±ˇ 9Ω†ÇöV∂£°ñŸœœå—ƒf≈_)ÉM«\UıÓì|58/@†û$êı‘?ÒÕ≈ÏMÄQYN≈]äªv*≈?5.M∑ñØ§^•?‡›#ˇ çÛ#N.a£9®óÃYπtÔªøÁlÖøë-ÂÓ˘ÁìÓs¸ ≈^Õäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUg¸ÂüõÕ~lö÷&≠ñó[h¿;r˝&OõK˚øıbLU„ÿ´±WbÆ≈]äªv*ÏUÿ´“ˇ Á<˛ﬁLÛe≠√∑K¶◊∑	ˇ Áîú$≈_°8™ú¨—¥MˆX~DbØÀçB–⁄\KlzƒÏáË<qW—_ÛÑwº5ùN”˝˘jèˇ  ¸Êv*˚v*ÏUÒw¸ÊÜâıO3⁄ÍJ(∑ñÄvçô˛I¥X´ˇ ú|‘I{bNÏ#ïG»≤?¸N<¿’çÅs¥ßrÕö◊bÏUÿ´±U+ªXÓ·{iÖcïYxÜ[¬A)Ú6£ß…ß‹Àg>“BÌ|‘Ò9ø˜tDSÍo'Íˇ •ÙãK‚y4±/3˛X%ˇ íäŸ§ÀÓqKä ßSk±W|Ò/èÔmZ÷y-ﬂfçŸOÕM3†àæíˇ ú ø·©j÷U˛Údß˙åÈˇ 3∞°ı÷*ÏUÿ´±WbØ/¸˙¸ﬂÉÚÔFc+j˜@•¨grF∏q˛˚ã˛N)¸ÿ´‡õâ.diÁbÚπ,ÃMI'rN*˙˛qÚÕµ}]¸◊xüËöq„FÕ;˘ësˇ ^H±WŸ∏´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*Û/˘»_À≥Á+OmlºØ≠“m¿ñ@yƒ?„,\ëÀ·äø>qW”ÛàøõKß\7ì5I)Às≥f;,á˚À˘Ìˆ„ˇ ã ó}wäªv*ÏUÿ´±Wƒˇ Ûôb˝#Ê»¥ƒ5M>ŸTèì˜œˇ $ΩU„Y“ˇ JÍv÷ÏÕ2+™O«ˇ êú∏E≤à≥O¨ÛBÔ]äªxoÁ˛©Íﬂ⁄ÿ-
¡ê”˘§4£±â‡Ûi§çuö©Y§O¸„ˆë kΩMøaVˇ d}G˚∏Gˇ ë’À`icπ/iÕk±v*ÏUÿ´»øÁ 5û0⁄ÈHGƒ∆w¿ªà˝<•ÕÜí<ÀÅ™ó ≥˛q? ^ÛåWíØ(4ÿ⁄Â´”ü˜p√ø©ˇ <≥bÎﬂvbÆ≈_8ˇ ŒlÍf-O∞˚Î∂r?„ˇ 3±W«8´ÙáÚkJ˝‰Ì‘ägëÓÎÎ7¸3‚¨œv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´„o˘ÀÕá÷5/Üü'˙ãV‰©⁄Iøêˇ ìmˆ„7?˜⁄‚Øù1WbÆ≈]äªv*ÏUÿ™"“Ó[Ií‚›åsF¡ëî–´…X™qWË?‰_Êj~`˘v+˘HFÈFﬂº˚ ,À˚œıπ'ÏbØE≈^)ˇ 9w•≠ÁëÂ∏"¶“‚A´}_˛g‚ØÖ±W”ˇ ï◊çyÂª)®C—4Kˇ 
ô¶‘
ôwƒ2ú«ov*ÏUÿ´±V˘ƒ‘Ú≈ÿÒ1˘)eiæßSÙæjÕª©~Çˇ Œ4¿!Úî‹íV?L≤úUÈ¯´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb©Wöµï—4õÕU˙ZA,€ˇ êåˇ √~c\‹Is+O9-#íÃORN‰‚™8´±WbÆ≈]äªv*ÏUÿ´±WÈoÂóòÃ^Y”uid∏µçúˇ ó«åøÚP6*…ÒWÊGû°Ùµ˝J?‰º∏_∫F≈^¡ˇ 8a)_8\ Ë÷◊ËíUˆæ*ÏUÿ´Êo˘ÕÌ(>ô•j@|QO,5ˇ åä$ˇ ô´¡ø#Ø˛ØÊ¸¥C$u&ˇ ôYã©'LjO°≥PÌùäªv*ÏUÛwÁï˙;ÃS≤Ä·Ve¸°∆C˛ Tì7:y\CßœëzO‰F´ı≠Ïò’Ìf`Ç?ÔÔì’Ã=\jVÊiebûëòNc±WbØî|ËúuÕAF¿]Oˇ '7ÿÕƒ{ùˆ'ﬁˆ˘√+£ú'á¥∂2èπ·lõ€8´±WbÆ≈XÊ◊Áì˘oaıãÊıoeÍˆ ~7?ÃﬂÔ∏Wˆ‰?ÍØ'≈_˘€Œöèúµ9u≠ZNwöSˆQGÿä5˝ò”˛n˚\±UoÀˇ "ﬂ˘ﬂWÉD”˜≤ö≥ë∆É˚…§ˇ %?·æ«⁄lU˙%‰œ(ÿ˘GJ∑—4≈„onúA=XùﬁGˇ .G¯õO1WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÒ¸Â7ÂyWW>a”£¶ï®9f‚6äcÒ:íì{¸ÙOÿ≈^oq$,–±YÇ¨#¶¯´ÓO˘«èœà<ıf∫F™·5€u°o]~üÒg˚˙?˘ËüÿUÌX´±WbÆ≈]äø6?5¸√˛!ÛNß™TöÍN¸Ö>ú_ÚIM#¥œ≠k‚‡Ùµâ‰˙Xz4ˇ í≠ò∫ôT\ù<nO°≥PÌùäª|ª˘ì®˛ëÛÏ›ñS˘F?èYº≈ÄÈr ‰K⁄ˇ &¥¡cÂÿ_ˆÆÊo§˙kˇ $„L÷Íervh‘YæbπN≈]äª|Ÿ˘Ω´~êÛ¿VÂa_n#„Ú9§ÕŒ‘Cßœ+ë}+ˇ 8[Â°g†^kn(˜∑öüÚ!_˙´,ø9ê–˙+v*˘;˛säËõçﬂ∞Kó˚Ã+ˇ ‚ØóqWÍ.ãl-,mÌÄ†éJ™°qTv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´¸¿ÛRySAæ◊áÍê3®=˝òì˝úåãäø5//&ΩöK´Ü/4¨ŒÏzñc…õ˝ë≈P¯´±WbÆ≈]äªv*ÏUÿ´‹Á¸Ët/5ç*F•∂´àéﬁ¢VH˛NGˇ =qW‹x´œÁ l≈ﬂëux»Ørˇ ≤ˇ ∆ò´Û∑}˘#uÎyyS˝ı,â¯â?Êfju_S¥”},˚1∑bÆ≈]äªa_úiÀÀ7G¿ƒ‰¢ ”}N.ßÈ|ŸõwT˝ˇ úkîI‰(÷¥IG›,∏´”qWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈XÁÃ≠ëıÜN¶’«–ƒ+bØŒúUÿ´±WbÆ≈]äΩÉÚc˛q€R¸≈S©\Iı-%XØ™WìH√Ì,	U˚?µ#|Î¸X´Ÿ5˘¬]	Ì ÿÍ7q‹”fîFÈ_x—!o˘)äæi¸»¸µ’?/ı3•j 	 ¥R¶È":¯ö7≈*ƒqWbØøøÁnZÀ˝4øÏ˙Í>BiF*ılU˘ìÁ…û`‘‰Ú‡è¶G≈^ªˇ 8bÑ˘∆sÿXKˇ '-ÒW€8´±WbØˇ ú¡∞I3ºpøﬂŒ˘õäæE¸≠ªæd≤ë∫)ˇ Ø¸_)Ã.%ª	©”π§w.≈]äªv*Òü˘»=<,ñWÍ7eí&>√ãß¸N\Ÿiƒ:ÌP‹'¸„ˆ¢—ﬂ›ÿ˛ƒ∞â>în?™lñ¨mltßz{éj›õ±WbØóˇ 3!˘ä˘Gyy¡ ﬂ«7x~êÈr˝EË?Ûà≤îÛ‘*?nﬁp‡y∆πsSÓºUÿ™ˇ P∑”·{´…#y$`™£¸¶oá|Ô˘´ˇ 9yc¶”ºö›◊Ct‡˙+ˇ ìÌNﬁˇ _Òì|üØyÇˇ ^ªìQ’f{õ©MZIIˇ õïW·_Ÿ≈Q>QÚ~•ÊÌB=#FÖ¶πîÙ~‘í7ÏFü¥«}Ì˘9˘Aß˛[iüVÄâØÁ ‹‹ª˚	¸ê«˚	˛Õ±W°bÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏU)ÛGñ,|œßO£Í±âmnã)Í?ïî˛À£|hﬂÕäø?ø6ˇ )µÀùQ¨n¡í“BZ⁄‡ÜDˇ çeO˜j∆åò´”u+ù.‚;€òX:HÑÜV
∂*˚#Ú?˛r~œÕ
ö7ö-u]ï&4X¶?Òg?…˝€ˇ ∫ˇ ﬂx´ËUÿ´±V9˘çØˇ áºª®Í√Ì[Z È˛∞SÈˇ √Ò≈_ôÿ´‹?Át”ùÂ˘ßÔdXáè¿9∑ﬂÎ/¸kur‰Üñ<À÷3œv*°xñ6Ú›À¥p£Hﬂ%õ%fò»–∑»R;LÂ€vc_§Ê˝—>∑–ÙÛ¶ÿ[ÿöVí3OPß436Iwê F‰ªv*‚@;àÉ≥‰-R˝µ©Ø$˚s»ÚõG: (S¢&ﬂ°üëËO%i6î‚Õl≥7ŒoÙÉˇ 'p°û‚Æ≈_ ˇ Œnì˙_Jæ≠'¸O|·h+2”ê˝x´ı*1E xU~*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´¬Á1µìc‰‰≥O¯¸ªä6ˇ Uœˇ â1Wƒ8´±WbÆ≈]äªv*ÏUÿ´±Tﬂ Z√h∫≈ñ®¶Ü÷‚)k˛£+‚Ø”µ!Ä#pw´¸ÍÛ•ÎUˇ ñˇ ‚~pbØ¸É5–¶ˇ ò∑ˇ ìpÊØWı|ûóÈ¯Ω'0ú«bÆ≈]äªb_õô|≥z´‘*7¸ëø¸kôsÎ>†zKÊL‹∫áﬁ_Ûâ◊Ç!ZGZòfù”#Kˇ 31W±bÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä∞œŒ]9µ'jˆ—äπ≥ôÄ˜Uı?„\U˘Ωäªv*ÏUÿ´±WÈ∑ë4õ}#B∞”Ï¿Xa∂âVù˛Vˇ f~6≈SÏU‡Ûô∫MΩ«ï-ıÎ◊h®›È"∏ë?ŸpFˇ aäæ*≈]äøBˇ ÁÙ√ßyIâÖë4øÚ5ﬁaˇ 
„z4í‘ªl~C~\Í∑ü\ªöÁ˝˚#…ˇ ybØ°Á	l˘Î∫ï◊˚Ó—S˛Eo˘ïäæƒ≈]äªyG¸ÂøØ‰K≈>â¢≈_˘$”]”Èˇ -pƒ◊+…Ùüs<P˜æ≠Õºv*ÏUÿ´±Wû˛yÿµŒÅÎ/Ky„ëæD4?Ò)W34¶§‚já•ÂüîVÛ-≠MOQ“ç«˛égg·`5 ˙W4Æ·ÿ´±WÃﬂõÚì^ˇ ≠¸õè7x~êÈ≥}EíŒ5kVZù-oıI„µµHÁÂ$¨Ecu_âº[·Àö_SyÉ˛ró»⁄8!/ÚA˚6—≥…GÙ·ˇ íò´…<€ˇ 9Øy8h|µß¨ Ï%πnmˇ ""‚´ˇ #d≈^ÁÃè0y _W]ΩñÊÜ™ÑÒç‘Ö8ƒø´≈^ô˘O˘Æ˛a»&∑O™ÈÅ®˜RÉ«o¥∞ß˚Ω˛_Û∫‚Ø∂?.?+¥oÀ˚c£≈G`=YûÜIH˝ßoÂE¯f´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´Ûßítœ9È“iÃ^§nŸëáŸí'˝á_Û¯qW¬øõﬂë⁄øÂÕ—2©∏“‹“•Ú&Ó©…˝ø˜[6*Û\UÌ?ï_Ûì˙Ôí¯Xj5‘¥µ†»ﬂºå≈3Ô∑¸W'%˛OO}a˘˘’Âü<¢Æït´t√{ihíÉ˛°˛Û˛y4ò´;≈^#ˇ 9wÊ—æK{54{˚à°ß≤ˇ §7¸ô_¯,UŒ*˙wÚ≥K˝Â€D ï∆ù˝BdO˘&»π¶‘J‰]æQØ1‹áb¨cÛ6˘¨ºª}*ıhΩ?¢B∞ü¬Lø πÜåÊ¢_:˘J≈oµ{;YRI„V‰ñˇ ·so3@óUd÷9°wé≈]äªJ<·pm¥kÈÅ£-¥§~«˛-ƒ.A´)®ó ∂ñÕu4vÈˆ‰`£Ê∆ôºtØ‘M>—lm¢µèeÖ…GUäª|ãˇ 9ø5-&_ÊÇeˇ Åd?Òæ*˘¶'Ù›_¿ÉäøR≠dDé:}#V≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª|›ˇ 9∑ÀÙôO≥ı∑Øœ”j∆ÿ´„ÃUÿ´±WbÆ≈Qzvù>•sï™ô'ù÷8‘ufc¡ÈlU˜_Âo¸„óº°gÍ6—j£(2Õ2áUoÂÇ7¯˘¯˙èˇ 
™≤_7~J˘OÕ6Ìo}ß¿éEXbëOä…_¯‰ü‰‚ØÖ?4ø/nºÅÆœ°‹üQíC%($çøª¯—ˇ ‚≈|Uá‚Æ≈_©zuE¥\æ◊ØŒò´¸ÔòC‰ùeè{9W˛pˇ ç±WÁ*˙Ú2öÑ˛’”ü¯Hó˛5ÕVØÍ¯;=/”Òz>aπé≈]äªv*ïy∂—ÆÙ{€tw∑ïTîQ∏ˇ √eòçH5‰˘37ÆëˆO¸·FØÎy~ˇ N&¶ﬁÏIO*(ˇ âB¯´ËºUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±U+ãt∏ç°îUJ∞Òq8´Û7ŒæYó ˙ÕÊã=yZLÒ‘˜Pvˇ Ï„‚¯™Eäªv*ÏUÿ´Ì˘«?œÕ3U“m¸πÆ‹%∂©hÇ⁄V
≥"¸1qëæYW‡t˝øÔó≈¡Wªﬂj÷v´…„Ü2HÍ´OıÿÒ≈_ˇ ŒO~u⁄˘ﬁÊCoSK≤bÌ-ÀOOíW˝’rTo˜g®ˇ ≥√x>*òhZ<˙’˝æóh9Ou*DÉ¸ß<~õhzTZEÖæõn)¥I¸ëB/¸GJˇ 1uq£˘sS‘{¡i;Ø˙¡á¸6*¸Õ≈_Zˇ Œi<,ımLèÔ$Ü‘#…Â≈_O‚Æ≈]äº„˛r-9˘WÒJü∫HŒ*¯+ «Y∞>Pü¯u»œëeaıÜhÎ±WbÆ≈]ä±ØÃõÆ˘v˙/åüÚ,âˇ Ê^_Ä‘√Fqq/õtKÙf°m~Aao*J@4$++Ù”7)‘ƒ—∑øiﬂù\ªZ…3€∑Ú…W˛Iz´ˇ ö©i§ò‘ƒß—yÁBîUoÌÄˇ *T_¯ìØ¡ósgçıˇ „=˛ÆüÚ>?˘ØÖ.‚ü=·ÛøÊMÙ˛`º∏µuñ&e‚»j¶äã∑~ô∑ƒ* Uî‹â_-jv*ÏUÿ´±W‹Ûá∫ü÷¸ïırjmnÊéû∏Oˇ 3±W∏‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äøˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±T&•¶[jñÚY_Dì€ •^92∞=ôN*˘_Ûã˛q(Y$⁄ﬂì‰VíKIöúUG'0Lˇ h≈s»ﬂŸ≈_/b´—⁄6Üå7bØRÚo¸‰ßú¸Æª∂ÎJEv=Mø…ñ´?¸ï≈]˘œ˘Ìs˘ùî⁄ã1fdf	!ev~äSÄOÊ∑äº∆÷’Ó•KxG)$`™<IÿbT>º¥µé“∂ÑR8î"è £äÁ?#f›)W]äºÁÛœPÙ¥!l9Kpà¬ªÅGó˛%Ênñ>´Úpı2Ù”Ãˇ '-å˛e∂jTF$sˇ   ?·€35†\<‰Ifô‹;v*ÏUâ~l bÚÕÎºcRFüÒ∂di«¨8˙ÉÈ/¸∑≥˙Ôô¥´n¢KÎp~FDÆn]CÙ√v*ÏUÚÁ¸Áü ﬂGæ∞˜ˆB'_˘6ÿ´‰ÏU˙q‰}DjZü|¶¢{H$Ø˙—©≈SÃUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WÖˇ Œbh≠}‰—xÇ¶ Ó)Iˇ %É€ˇ ƒÂLU˛*ÏUÿ´±Wb¨ÎÚ>ÚﬁœŒöD◊dÖ‹bß†-F~âqWË÷*ÏUÒØ¸Ê≠Ìºæb±∂åÉ<6ïíùÉ;◊˛6ˇ eäæu≈SØ&È≠kV:bäõ´ò¢ß˙Œ™qWÈ»P†∞´ÀÁ'5®˘R#ÌJ"à≥ñ0ﬂú±WÁˆ*˙OÚnñm[ºÜV?Ú1”˛5ÕF§˙ù∂òzYÆbπ.≈]äªv*ÏUÚ.µßù6˙‚…∫¡+«Û‚J◊7Ò6-–»Qßºˇ ŒÎ‚œÃwöSö-ÂØ%/r_˘',π$>Õ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*˘K˛sÚ…Ñëy÷≈*§,î¯mÁoü˜ˇ <qWÀ´±WbÆ≈]äªTiù¿F$®Ë+ä©‚Æ≈_IŒ~Y>£®øú/S˝Œ±€‘l“∞¯‹∆€˛OÚ1WÿX´«?Á+ºƒ4ü#‹@¶í_K∏Ò°>¥üÚN´‡ÏU˜¸‚nÖ˙3»N¬è{4”üø–_¯HqW≤‚Æ≈]äº„˛r)¯yW?ÒJèæH∆*¯+ +ÀY∞7Pè¯u»œëeaıÜhÎ±WbÆ≈]ä†u˚3{ß]Z≥A$JÀ¸rp5!Ôa1`æEÕÛ£d◊üó`¥Ug±ï’¿#“¶««—Áï±=[N)âU«óµ+oÔÌgJ4l?Z‰¯É§∫M„ö%'˝F˛òmãã Zƒ¬±X‹∞ˇ &?ÒÆ0:ßÑ˜&6_ñ~bΩ∫±ï„%#ˇ ì∆<¨ÊàÍÃbëËùÿ˛F˘Ç‰Vaø¥íTˇ …6Vu1ÉM"»4ˇ ˘«≤@kÎ–uä:ˇ …Gaˇ &Ú£´h“wñQß˛Iyz◊yí[ü¯…!Úg— %™ënháñ˛oËv⁄6µËŸF∞¬£ÖAA˚Iˇ fv	FÀÖû"2†˙˛pÜÔûè™Zˇ æÓc¯4„ˇ 2≥!°ÙÆ*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØ1ˇ úìÛ—<ç©I˝Â¬-≤ˇ œV…ˇ $ΩLU˘ˇ oo%ƒÇ(UûF4
¢§üñ*Îãimõ”ù7ôJü«Q≈]ä™¡;€∫Àë*¿–Ç;åU5ˇ Îøıpªˇ ëÚÕY_á·ÚlÒ%ﬁ[u◊Í„wˇ #‰ˇ ö±„‹‚Kº°/u˝F˝x››M2¯I#0ˇ Ü9!dJ_íbÙﬂ»(πkSπ˝õV˚À≈òz£È¯πzQÍ{ﬁjù£±WbÆ≈XWÁ#ÒÚÕ»˛fà…D?√2¥ﬂSã©˙^O˘´Ámi_Ù∏œ‹yf›’?FqWbÆ≈^ˇ 9è£˝w……xΩlÓ‚s˛´áá˛'"bØà±WË?¸„v¥5_"ièZ¥(–7∑§Ìˇ ¬*bØM≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªH|˜Âà¸’°ﬁËr–∏0Of#˜o˛¬Näø4ı	Ù˚â,Óî«4—∫û™ x∫ˇ ±lUäªv*ÏUp%MFƒbØ™ˇ +Á0m†≥èNÛúrô„P¢ÓÀòhÍ≠Í3GÀüÚb¨óÕøÛô[±∂o–M}vG¡ÕLqÉˇ 3˛Û˛?Ÿ.*˘Õ>iøÛ>£>±™»e∫π~nzT≤àø/Ú‚©>*˜o˘ƒ?$∂µÊì¨»µ∂“£/S”’ê·_¯VO˘Áäæﬁ≈_=ˇ Œik_UÚÕ¶ú¶çuvèçõ˛‚≈_‚Ø™¸ãb∂Zå*8ˇ £∆ƒî„‘¯vl—Ê7"Ó±
àOr¶◊bÆ≈]äªv*˘œÛßI˙áò$ïEÈPç='˙y∆œ˛œ7y\]F¢5$Âöø¬ûi”µv<cäuY¸Vˇ πõ˛IªfKé˝#Q∏8´x´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®-_J∂’Ì%”Ô£€NÜ9∫aCäæ¸Ï¸ùæ¸∑‘Ãd4∫d‰˝ZzlG˚ÊOÂû?˘)˝‚‚Ø5≈]äªv*ÏUÿ´±V{˘I˘M®˛cjãehvëê◊7|1ß¸m+ˇ ∫ì˛4W‚´ÙÀ^[≤Úﬁùë¶GÈZ€ D^˛Ï«ˆùèƒÌ˚Mä¶∏´‰O˘Õ5˝cQ”¸ΩT[∆◊¸“N/¯çø‰f*˘≤ﬁﬁKôAiÖP:ív~öy7@_.Ë∂Z:RññÒ≈∑r™õ˝ì|X™uäªv*ÚØ˘ ëê5/Ú˝L—bØÜ¸í	◊t7ˇ KÉ˛N.C'“}Ã·ı{Í‹–ª«bÆ≈]äªl{‚_:bß®4ŒÖ–æ≥Ú¥∆}& fÍˆ–±˙Q[4YH˚›ﬁ?§{ì<≠±ÿ´±WbÆ≈]äªx/ÁÚˇ π®∑’T}“Mõ]'”ÒuzØ´‡ıè˘¡€ÉÍÎP◊b∂ÕOëùs1ƒ}]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØû?Á55ñÏm–Mx˚ÑéO˙©äæi¸öµ3˘ñŸÄ™ƒ≤;|∏2¯w\«‘År0ê}%Ìökv‘óﬁyNΩ5∫µÇcˇ F≠ˇ \ò…!‘±0¢_#ËR
5Ö∞ˇ V$_¯äåòÕ.ˆ{êïû[üÌŸ ˇ Uù‚π/ÃOΩ{î?ÂPy_˛Xø‰¨øıWÃOΩóár‰¸£Ú¬ã!Ù…)ˇ âIèÊ'ﬁøóárem‰M‹Q,-ç?ö%c˜∏cë9§z≤b:<´Û‚+kYÏlÌcHï"v‚äfaO≥€‡lŒ“íA%¬‘Äˇ 8Û2j˜Q
˝˛©ˇ çr:æAñìô{>k]ã±WbÆ≈X7ÁBìÂπ»ÏÒ¯uÃΩ/‘‚Í~óò~A∏O<h‰Ù˙»x#6Œ©˙)äªv*¬:|ø˛ Ú~´ß®‰Ìl“ Òxˇ ¸<x´Ûá}ˇ 8OÊ1>ï®Ën~+i÷u‰ ºüÍº?¯´È\Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØèˇ Á.)_Oæˇ È…[K¢Ë(˚˝ïòˇ ë?Ÿˇ åøÒó|◊äªv*ÏUÿ´±WbÆ≈QVÍ«ihç,Û0DE,Ãx™Øœ~Ü~J~ZG˘}ÂËt≥Cy'Ônú~‘å7Zˇ $K∆5ˇ WóÌb¨˚|iˇ 9•Ê!yÊ-V ÿªòˇ ’8¢≈^§iÕ©^AcÕ<â>»Z‡ë°iÕ>ª
PlLÁ…∑z6v)v*ÏUÿ´±WbØ0¸˘–çﬁõß´ZøßÚIA»ˇ ´"∆øÛ—≥;I:4·j£bﬁõ7Z˝¸ÑÛ®Ûî,oùπ\¬üWü«‘ã‡‰ﬂÒí>ˇ ≥≈^áäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏU*Û/ñtˇ 2ÿ…•j≠≈§¬åç„˚,≠ˆë◊ˆ]~%≈_~mŒ*ÎYy/¸∂Ø®Èõû Vx«˘qØ˜Íøœ˚(ÒWÑÀD≈¿–É‘UOv*ÏU∞+∑|UÌøï_Ûã˙Ôú/5ïm3KÿÚu§“¯¶˚<øﬂ≤¸?ÀÍbØ≤º£‰Ì3 6	•h∞à-£Ï7f=ﬁG˚NÌ¸ÿ™yä©Õ2BÜITPI'†~m~iy¡º·ÊK˝lícûfÙ´⁄5˝‹˛E*b¨ü˛q≥…ÁÃﬁs≤W^VˆD›À·˚Ω‚˚ÁÙó~ÅbÆ≈]äªxo¸Ê§-|ïırwπªÜ0?’Á7¸ ≈_$˛VZØ2YF›≥ˇ ¿+ ? sân¬.AÙÊiÀ±WbÆ≈]äª|èØCËÍQŸöE˚òÁANÑÛ}=‰ñÂ°ÈÁ˛]ar(Õ&o®ªú_HN≤¶◊bÆ≈]äªv*ÏU·øÛêJ?HZ7s¯l⁄i9{≠’sEˇ ú o˜#´Øc'ÓgÃ◊	ıŒ*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØòÁ8ã-{n‹±bØ¸ÑPu…IÍ-\ˇ √ƒ3UÙπZo©ÔŸ©vÆ≈]äªv*ÏUÿ´¿ˇ ?ø„∑¸¬'¸úõ6∫Oß‚Íı_W¡<ˇ úyéëÍ‚–èª’ˇ ö≤≠gF›'W∞fΩœv*ÏUÿ´¸·N^Xº>ëˇ í±å…”}n6£ÈxÁ‰Âÿ¥Ûñç+t˙Ùˇ ÍüÒ∂nKÙãv*ÏUk¢»
∞™ëBÅ≈_ö?òæYo+˘Üˇ EaE∂∏uOı	Â	ˇ eF≈YÔ¸‚«õGó¸Èo≠∆AZ’º97«¸ñDè˛zbØºÒWbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä†µ}*◊W¥óOøçf∂ù
Hç–©≈_	~y~Cﬂ˛]›µ›≤µ∆â+~Ín¶2zCq¸≠¸í}â÷¯1Wí‚Æ≈]äªv*ÏU^÷⁄[πVºÆB™®©$Ï®ÔäæÃˇ úqˇ úzˇ ™˘ìÃHXësﬂÍÍGÌÀ√Ø¸ä_ÉÌ3bØ†qUé äYà
I= ´ÛgÛKÕ‚œ3j–5é‚vÙˇ „˛Í˘$âä¶üí∫7Èy.™4¶æ'˜iˇ ¸ˇ ÿf6¶U{ìßç…ÙNi›≥±WbÆ≈]äªv*Ç÷Ùòµ{)¥˚Å˚π–°⁄¥ØŸq˛R7∆øÂd·.l'!OìoÏf∞∏í“·JÀq‡ x∑„õ–owHE=˜˛pÛÛÙ>∑/ñnöñ⁄íÚäΩÒÇ‰¥<◊˝h„\(}ùäªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±VÁ?…ˇ +˘ Ø¨ÿG$Á˝‹ïé_˘oˆ|±Wík_ÛÑ˙√”5õjÙ*J›Ë7¸6*«O¸‡Ï¸∂÷ìè¸¬öˇ …¸U=—ˇ Á	thmORπüƒDã˚€Î´÷|ô˘'Â?'óI∞èÎ“iy ?‰…/.ÛœÜ*Œ±WbÆ≈^7ˇ 9K˘Ç<≠ÂY,≠€çÓ®MºtÍ˛>_˛E˛Î˛z‚ØÉÒWŸﬂÛáD:VÖ?òÓìjO¬2ﬂ1†ˇ ≥ó‘ˇ ÄLUÙ6*ÏUÿ´±WÀÛõ⁄ﬂtù!O⁄iÆ™(ˇ ‚R‚Ø¸â±ÎN√˚à¡˜%bˇ àªÊ&®‘\≠0π>ÇÕKµv*ÏUÿ´±WbØì|Ÿˇ ãﬂ˘âõ˛&Ÿøè Ë•ÕÙ∑ë?„Éaˇ 0—ƒFi≥}E€·˙Byî∑;v*ÏUÿ´±WbØˇ úÇaı˚EÓ!cˇ õM'#Ôu∫ÆaËüÛÉÎ]CW=Ñ0Ω§Ã◊	ıŒ*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØôˇ Á7ÌπizM«ÚO*¡*∑¸À≈^˘t∞˘É”'y†t0VO˘óò∫ëÈrt«‘˙5Ÿÿ´±WbÆ≈]äªxÁÈÆπµ¢ƒÊÕ∂óÈuZü©îˇ Œ?-4Î∂ØYÄß…FQ´ÊÙúã’3Œv*ÏUÿ´¸«≤˙ÁóØ¢=°i?‰_ÔøÊ^_Ä‘√Naq/õ¸Ø~4ÌZ ¯Ï ∏ÜO¯W˛∫tœ”’`¿∏;åUv*ÏUÿ´„Ø˘Ãˇ &5ñ≥iÊHW˜W±z2¯∂/≥_ı·e„ˇ qWœ67≤ÿœ’ªö&å:ÜS…[Ô≈_•?ó˛máÕ˙ûªoJ]D¨¿~ÀèÜhˇ Áú™Èä≤,Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®k˚5“Ú5ö	T´∆‡2∞?≤ ›qWÃﬂö?ÛáipÔ®y.Q5cg1¯ÁÑﬂ≥˛§ﬂÚ7|€Êè!kûUê≈≠ŸMjk@ŒáÅˇ RQ˚∑ˇ `ÿ´≈]äØDi*äì–UÈﬁBˇ úrÛoõŸ]mZ∆—∫œtbü‰F{'˚„˛V*˙ÀÚü˛q˜A¸ΩÊ5˙Ê®G≈s(ÒÇ>êè¯)?‚ÃUÍ8´±Wñˇ ŒG˘‰yK…˜oqªΩTá∆≤ﬁø˚=Fˇ _é*¸˝≈^ˇ ˘°}KIìQqGº}ø‘é®øÚS’ˇ ÖÕ^™vkπŸÈcB˚ﬁìòNc±WbÆ≈]äªv*ÏU·ûûV6ó©≠Bøππ$ßilÁ¢√#Ê”Kí≈w:ÕL(ﬂ{Õ¥ÕJ„L∫ä˙ÕÃw:…é™ y+}ôÆÙsÚªœ∂˛{–-µÀzïxÃÉˆ%]•è˛‚_¯≠ë±V[äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUc∫∆•òÄ†Tì∞ bØœüœœÃ¶ÛÔô'ªÅâ”≠´®ÏQO≈/¸˜~R©ÈØÏb¨O»ﬁS∫Ûv≥k°Yﬁ›HüÂ_µ$á¸ò„‰ˇ ÏqWÈ>â§[Ë÷PiñK¬ﬁ⁄5ä5UF*é≈]äªv*¯C˛r√Ãﬂ¶|Ì=≤≈ß≈∫¯Vû¥üÚˇ aä¢øÁt¬ñwöÅˇ v»±nõ¡zÀˇ öÌ\πa•è2ıú◊πÓ≈]äªv*ÏUÚgö[ñ≠x√Ωƒß˛≥Nä\ﬂK˘xËV˛]¢?zå”f˙ã∑√ÙÑÛ)nv*ÏUÿ´±WbÆ≈^	˘˙ı÷‡Q⁄’ó6∫QÈ¯∫ΩQı|ªˇ 89jGÈ´ûﬂË…˜zÌôé#Í¨Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ ú¡—ç˜íÕ–6wQJOÄnP~πó|â˘e®1XÃz4ûü¸å˘ôïfqê}Aö7tÏUÿ´±WbÆ≈]äºÛS\áﬁ’¸<π∂“˝.´Sı2ü˘«ÊÆùvΩƒ‡˝Í2ç_0ﬂ§‰^©òs±WbÆ≈P˙ïíﬂ⁄Õfˇ fhﬁ3Ú`P˛ºîMc!bü 2ï$£7Óâ˙a˘u≠sÀönßﬁ‚÷oıäé¸±VGäªv*Ûﬂœè!:˘RÔOây]ƒ>±o„ÍF	
øÒï=HÁ¶*¸Ó≈_SŒ˛bàﬁ„…∑èˆÎskS‹Ùàá˚2Ø¸ı≈_V‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUJx#ùs(tmä∞†‚¨CS¸òÚn§≈Ótã2«©Xï	ˇ ë\1Tæ?˘«ø"F‹óHÄü~d}Ã¯´&–ºã†Ë∫Nümjﬁ1Dä‡ÄÂäßÿ´±WbÆ≈_ˇ ŒW˛bè3˘îÈ6Ø «IC≥Lﬁáˇ `Uaˇ ûm¸ÿ´«¥]&m^Úzzì∏A^Çø¥’˚Y "Õ>±”Ïb”Ì¢≥ÄR(QQG≤é#4Ró∑wäDdY;v*ÏUÿ´±WbÆ≈RØ4y~/0i”i≥Ï%_Ö©^,7Gˇ bﬂøYé|⁄ÚCåSÂk˝>}>‚KKï·,LQ≈z◊|ﬁ{∫R+g±Œ1~mÇıØ—zãÒ“u™‰ù£óÏ√7˙ß˚πø…¯ˇ ›XP˚£v*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ÁÔ˘ÀÕ¡ÂÌ/¸-¶Ω5E?|TÔfˇ eq˝ﬂ¸cı?»≈_bØ∞?Áø+Œõc'úo“ìﬁ®#uàﬁKˇ =ùxØ¸VüÀ&*˙Sv*ÏUÿ™]ÊfO∏’.Õ µâÂsÏÉñ*¸À◊uyµ´˚ùRÁ˚Î©^gˇ Yÿªƒ±W”ó˙'Ë]“ÕÖ$Û}∑‰ˇ º`‘Â√˝éi3KäE‹·èC! [ùäªv*ÏUºUÒıı«÷.%ü˝¯ÏﬂFπ–B_Ty4SD”«¸∫Aˇ &”4ô~£Ôw8æëÓN2¶◊bÆ≈]äªv*ÏUÛáÁ5·∏Û%¬V´∆É˛\ˇ √ªfÁN*‘g7"˙K˛p´Mh<π}z¬ûΩÁ|BFüÒ¥ôê„æâ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb¨oÛÀ_‚.Í(˚W6Óâ˛Ω9Eˇ %bØÕAÍ[I]“T?"≈_YywYMkN∑‘c•'çXÅ–7˚±?ÿ?$ÕHí‹%ƒ-1»6;v*ÏUÿ´±WÇ~«n˘Ñ_˘96mtøO≈’ÍæØÇ{ˇ 8ı-aøã˘Z&ˇ Ç¯”*÷tm“uzˆk‹˜bÆ≈]äª|∑˘ã•ù3_Ω∂Ïe2-:ROﬂ*ˇ ±W„õÃR‚à.ó,xdCÏ/˘ƒ_3[…´`ÌYtÈ‰Üù¯7Ô„ˇ ìéøÏ2÷ß∑bÆ≈]äª|ˇ 91˘n|õÊy.-”éü©∏ÜÉ`ƒˇ §E˛¬F‰øÒ\âäº„À>b∫Úﬁ£o´ÈÌ¬Ê÷EëO∫ü≤ﬂ‰∑Ÿu˛\U˙=‰_8Zy«F∂◊lÓÆP1Z‘£§âø ç˛UêbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªyœÁøÊj~_˘v[ÿÿ~ê∏¨6´ˇ ˝Ô˙∞ßÔ?÷‡ü∑äø=•ïÁs$Ñ≥±©'rI≈^Ω˘ÂNM&ø:Ïµä
¯ˇ ªdGÓˇ ‰f`j≤ù•áÒ=ó5Æ≈ÿ´±WbÆ≈]äªv*ÏUÿ´…;ºên¸Afµí0‡
}ëˆeˇ cˆ¸é»Ÿ∞“Â˛‡jqˇ xél]{Ì?˘≈øŒøÒ5í˘[X˜)hüπv;Õ
è¯i°_µ¸Ò˛Ûˆd≈_@‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈XèÊwÊ5áê4iuãÚÜ´C,Ñ|Ø¸I€ˆ#≈_û>iÛ=˜ôı)ıçROVÍÂÀ±Ì˛J¢˛ "¸(øÀä≤Ø…? Ÿˇ 15ËÙÚ
ÿAIn§£Ï˛¸õ˚¥ˇ É˝åU˙eeî)klÇ8bUDE
™8™Ø˙´ä´‚Æ≈]äª|ıˇ 9âÁ·§ËqyjŸ©q©7) Ìgëˇ ëíˇ Äì|Ø˘uÂ”Øk0Z0¨*}I|8! ◊<cˇ eïeüm∑8•O®sFÓùäªv*ÏUÿ™ùÕ¿∂âÁo≥ñ? +íà≤∆FÉ„ºﬂ∫'ÿu®¥∂äÿl"çS˛qÕÕíÔb(FEì±WbÆ≈]äªq4‹Ù≈í|≈©˛î‘no∆¬y]¿π(ˇ ÅÕ¸E
tr6m˜ü¸„góŒã‰m5Ì‹#\∑¸ıc$ÚK”…1z~*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´ˇ“ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ ŒL˘º•ÊŸÊâxŸjD›B@⁄¨“#ˇ a7&ˇ RHÒTG‰Oõ8ô<øpﬂj≤¡_~ˆ?˘òøÛ◊05XÔ‘Ì6JÙΩì5Æ≈ÿ´±WbÆ≈]äºG˛r‘-Âïœwâ”˛ÉÃ‹ŸÈ≈÷ÍÜ·ˇ 8Ò(®G‹à›Íˇ ÕX5c`ù'2ˆl÷ªbÆ≈]äªxßÁˆàcπ∂’ê|2)Ö˛kWC˛…Yø‰^lÙí±N∑U6…?Á|„˙/Ã≥hs5!‘°<Aˇ ~≈Òß¸ëıˇ ·s9¬}ßäªv*ÏUÁûñi˘ÅÂŸ¥¯¿˙¸ö’è˚ÒG˜u˛Yó˜/˚´Û⁄Í⁄KYZ	‘§±í¨¨(AiN*˜˘≈ØÕÒÂWÙ©%4ΩEá'h¶˚)'˘)7˜rœ7˚8´Ì‹Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±UÀÿl°íÍÈ÷8bRÓÏhTrfc˛N*¸˘¸Û¸‘óÛ^{ÿ…uΩb¥C∑Ó¡˛ıó˝˘3|m˛¬?˜^*√|π°OØ_≈ß[éV•{*ıw>»øBr·YF<FÉÍç#JÉI¥ä¬‘qÜøGÌ5?ièƒˇ ÂféR‚6]‹c¬("Ú,ùäªv*ÏUÿ´±WbÆ≈]ä≠ñ$ô)T:8* ¬†É±V®8ÉH"ﬂ7˛f˘O,ﬁôa_˜9˝”Ÿ€x[¸•˝ì˚k˛W,‹·À∆<›Fl\…ãË˙Ω÷çw£ß»–›@·„ëNÍ√2|˛G~sZ~di`πXµkuÊ∂ˇ Ô¯á˚ÊO˘&ˇ ~À:ØM≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb©Oô¸œaÂù>m_VîCiÚf=…T_€w?
'ÌbØÄ?8ø6o25føû±Y≈T∂Çµû-¸“…ˆ•oˆebZáwÆﬂC•È—¥∑W4I?ÁÒ7ÏÆ*˝¸ù¸Æ¥¸∫—#”!§óRRKôøûJ~œ¸Wÿã˛Ì≥b¨Ôv*ÏUÿ™Q‘ ”≠ÂΩªq#I#∑EUôè…qWÁ7Ê◊üÊÛÁòÆuπ*"s¬?±Ì¸ˇ ›èˇ ;‚ØL¸êÚßËÌ=µkÖ§˜übΩDCÏˇ »÷¯œ˘+jıY,◊s≤”BÖ˜Ω+0ú◊bÆ≈]äªv*íyÊÂm¥+˘”˝U›î¢ˇ √6[Ñ\ÉVSQ/óÙ{®^¡f63 ëˇ ¡∞\›ìA”eı·ﬂ9˜|÷*ÏUÿ´±WbÆ≈XoÊœôE—%@vèfΩjx$|øŸÃù<8•˝WQ>˚ﬁ	‰œ,œÊçb”D∂˛ÚÓdéæ üç˛Qß'oıspÍ_¶6QX[«in8≈
,h<Gˇ Ö≈Q´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ”ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈^i˘˘˘Zøò>^{h~íµ¨÷≠˛U>8’ù~ı˝7˝åU3]iBD-’ª¸ä∫ù¡ˆî˝•¿E§}%‰=€˘ÆÃH(óëÄ&àv?Œïﬂ”o¯O±˛SiÛb0?—v¯≤Òè6SòÌÓ≈]äªv*Ú/˘»[Vx,.ÿGïÕ¬2ˇ …¶ÕÜêÛp5cíE˘9]jx…ŸÌò¸»xˇ Ål∑T=?≠)ı=Î5N—ÿ´±WbÆ≈X«ÊGóOËì€ ¨»=Xø÷MÈ˛Õ9«˛œ/¡>4fá_9ys^∏–5}VœiÌeISÊáó‹k7Nù˙WÂ0€yèL∂÷lM`ªâe_nCÏ∑˘H~ˇ +MqWbÆ≈]äæEˇ úµ¸û6'Œ⁄LË◊‚ØÏ»v[èı&˚2≈øÒõ|Àäæ”ˇ ú`¸Òh¥O+ÎO˛ÂmRê»«y‚Qˇ <+ˆˇ û?ﬁø1W–8´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±W»ˇ Ûï_û#PwÚ^É-`ç©{*ùô‘ˇ º™í6˛˚˘§˝ﬂÏ?%_2]á\UÙ?ÂëéÅfoÔó◊@T|	’S˝g˚r∞_¥π™‘Â‚4¶ü≤Ù√r›äªIıo8iEEı‹Q≤ıN@ø¸äNR¬Â±≈)rRÀÛ,b˚Û√À÷ÕHökÅ„tÚY°9p“»¥ùLBMyˇ 9düÔ-î≤ÆÍüÒ6X4áΩ¨Í«r˛Ü’ª˛û?Î∆KÚ~h¸ﬂí¨Ûê∞ì˚ÎQ˛L°ø‚Q«ÉÚ~i¸ﬂímm˘Ò°J@í;òÎ‘îR¸åﬂπ§ì1™ã"”ø2|Ω®0ﬂDß¬Bcˇ ì¬:ˇ ± eÇC£lsƒıdàÍÍ*wt9A‹∑äPˆÖkÆŸ…ßﬂ/(d∂ è≤Ë{2ˇ ü√ìÑÃÜÄê¢˘õŒ>Q∫ÚΩÎY\¸H~(‰¶Œæ#ﬂ˘◊ˆ‡suè ò∞ÈÚ@¿—PÚØöµ*Í1j⁄L≠‹-PGÊéE˝∏ﬂÏ∫6X÷˚ÀÚkÛØM¸»±:[Íê®ıÌâ‹≈êˇ <-ˇ üeˇ  UÈ8´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªJ<—Êù; ˆÍ⁄ƒÀ§"¨«π˝îE˚O#˛ .*¯CÛ≥Û∂ˇ Û&¯
}&›è’ÌÎÙz”4ÃøÏc˚	˚nÍºﬁﬁﬁKôTºéB™®©$Ù
1W€ˇ Ûé?ëK‰[1¨Î∑rùˇ Wåˇ ∫W˛-o˜sœ5˝ØQW∑‚Æ≈]äªv*˘g˛rÎÛÑ"ˇ ÅÙô>#≈ÔùOAˆ£µ˙Ωõ˛yßÌIäæxÚî_Ã˙úvÜ¢›~9òA¸æÓﬂˇ .Uó' ∂‹P„4˙~RX¢PàÄ*® ÇÅ‡3HMªê)vªv*ÏUÿ´±V˘”~-|π,g≠ƒë∆>aΩo¯å-ôZQrqu&¢ÒøÀØyé∆3˚2züÚ-Zaˇ &Ûcò‘KØ¬.AÙˆi”±WbÆ≈]äªIºÀÊÌ;Àê˙˙å°M*±ç›ø‘O¯€Ï3e∞ƒg…™y9æsÛøúÓº’znß¯aJ¨QéàøÒ≥∑Ì∑¸k«6¯Òà
´&C3eÙ_¸·ÔÂ[√Íy€Qå©uhl√†Ì5¿ˇ ì1ˇ œoÚr÷ß‘ÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈_ˇ‘ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äægˇ úóˇ úyìYy<€Âà˘^R∑v 7íüÒÒ
ˇ øøﬂ±ˇ ª~⁄˛˜ó™´Â=+Uª—.ñÓ…⁄àŒƒu˜VSüÚë≤2à"äA#pˆˇ &~tÿÍ°mµ~6ó=9ì˚¶?ÎÓøŸ¸?ÒgÏÊ∑.òç‚ÏqÍA⁄OHGWPËAR*‹òDSò∑ä]äªyÔÁùì‹y’NêOçÚ!°ˇ â πô•5'T=/,¸¢ºﬁd¥‰h≤sC˛…è¸î„ôŸ≈¿∏XH>ïÕ+∏v*ÏUÿ´±WbØö4¸¨<ø¨H±/kèﬁ≈NÄÒGˇ <ﬂ·_¯ØÜn∞œé.ü48$˜ﬂ˘√oÃŒqÕ‰´Á¯ìï≈•OÏı∏Å~G˜Àˇ =≤ˆá‘∏´±WbÆ≈Pöûôo™[Kc{Àm:4r#nXQó|˘Â˘Au˘u´¥@“Ó	kYOq˛˘¯∂/⁄˛ÜO⁄≈Xó©‹iW1ﬂÿ»–‹¬¡„t4e`~´ÓÔ»oœ;_Ã[kxVn›}@‡«ƒ?‰€O˜Së√z÷*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª|Ûˇ 9%ˇ 9ûZâ¸±ÂŸ9j≤'ôO˜
e[˛Z[˛Hˇ Øäæ2$ìS◊zó‰˜ÂﬂÈ)Fµ©F~´~È[§é?hè⁄é?¯w¯a◊0µ∏v‹Ã∏∑<ûÎö∑f∂iíie`ë†%ôç ´3ÉÇiÊ^j¸Û±∞&>∑(ˇ v5V0‚r…?ı≥7îü©√û§•ÂZ˜Ê∑ÆUnÓ\Dv1«%<
ß€ˇ ûú≥:8£A¬ñYKôcykS±WbÆ≈]äªv*öh˛d‘tfÂß\IzÖcƒˇ ¨üaø‡r2àó6Qëè'§˘oÛÍ‚""◊!ßOV ˛m>õ◊¸üKè˘Yá=(?KóQﬁπ¢Î∂Z‹ÎNïfã°+‘_¥á˝l◊Œ;>3‰ÜÛOïl¸ÀflØón®„Ì#:ˇ ∆À˚Y,yÜ91âä/õ|’Âﬂ,›5≠ÚÌ’$·q¸ ‚Iˇ 6Ê‚≈áS8(=^Ω–o#‘¥…ûﬁÍ‰í!°˙2˝ñÀﬂi~Hˇ ŒJÈ˛uÈ—K=jÅGhß?ÒI?bO¯°øÁó?ÿUÓ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈XwÊOÊ¶ã˘}eıÕb_ﬁ∞>î	C$Ñ"ˇ /ÛHﬂ‚ØÖˇ 5?7ıèÃ{ﬂ¨jMÈ⁄∆O°lÑ˙q◊ø¸Y/ÛJﬂ©‚¨*ﬁﬁK©ºÆB™®©$Ï™™?k}õˇ 8Îˇ 8ÍæSTÛòê>Æ‚±Bw‡ˇ 7Û\ˇ …üı±W–8´±WbÆ≈]äº£ÛÛÛ™À≠3—µ+&≥t§AﬂÄËn%»ü∞øÓŸ?»ı1W¡Ó˜Z≈Ÿw/qws%I˚LÓÁ˛ù∞IﬂJ~_y2?*È¬‹—Æ•£Ã„ªvEˇ "1Ø˚'˝º”fÀ∆|ùæ|ìÂÓ≈]äªv*ÏUÿ´«?Á µQ˛á¶+oÒLÎˇ $‚o˘=õ$yó_™ó Ûœ$y∑¸/˙@B.N%∏”ï>%j7≈∑ÚÊfHqäq1œÄ€“`ˇ úÖÖç'∞t+(o◊yÑtûn`’˘&)˘˚¢˛‹C‰±ü˘ö2?î=Ïø4;óˇ  ˝–øﬂ7ˇ ’lîóxOÊ£Ê•/ÁˆéÓ≠ÓXˇ î®?TèáÚáΩö…E◊¸‰+"⁄¿Ï^Zè¯ç‚y`“•¨Í˚É’ˇ 9º¡©ë ñ®EÅhwˇ .C$ä‘tÀ£ßàiñ¢EÖ›]Mw!ö·⁄IX‘≥í~yìN=¶~O6¶,Ü©´d◊¨…»Ø(ÀcíÙ€~ô⁄Y≈g
[[¢«JET*™ø 1U|Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ’ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª|ˇ 9Z÷Áy·”¢é&éÑ¸9 √÷gj~ﬂß$JﬂÍ‚Ø&]>Â†7Ç'6·∏8û<©^<˛œ*~ŒM&ú5mˇ ∏€óâz˚Hkﬂ“~QÚˇ +éFXƒπ≤åÃy=Lˇ úÅºçxﬂŸ«)˛h‹«ˇ 
¬o¯◊1%§ër£™#õ*≤¸ı–g!fY‡Ò.Äè˘$“7¸&PtíË‹5QMc¸€ÚÃÜãz*|cêƒ£ Œû}ÕÉQÙ∑œrÚ˛±°›⁄G{<ëä	©e˝‰k∆ü¥ËπfRåÅ¶ºπc(ëo—5—∑ˆ˜¿W–ï$ßèO√6r)◊D—∑◊
¡Äe5pFhßx∑ä]äªv*ÏUà~hy<˘óJdÄVÚ‹˙ê˚ˇ <Û—‰¢«ô82p{èü|ıÂÌzÛÀ∫ÑÆûﬁù’¥ã"Ωõ¸ñ˚.π∏u—À>Ÿ˘ÔDÉ\± 	G#≠Lr/˜±7˙ø≥¸Ò⁄≈YN*ÏUÿ´±V;Áø#iﬁv“•—uTÂÇ™√Ì#è±,g≥ß¸ÿﬂbØœœÃﬂÀmOÚˇ U}+TZÉVÜe©⁄Dˇ ôâ˛ÎlU!–ıÀÕ
Ú-KMï†∫ÅÉ£°°üƒøeó·lU˜‰_Á˝èÊ∫ÿ_î∂◊"_é.ã(ÓÎzˇ √≈ˆ£ˇ )1W∞bÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÛØ¸‰¸‰º^_Y<ªÂYö°™Mpª¨Ã±ˇ =«¸,?ÒìÏ™¯Ó‚‚I‰i•b“1%òöíOZúUô˛Z˛^MÊ{°qp•4Ë[˜åvÊG˚¶?¯›øa ·ò˘≥pÈ9qqüËæåÇ∑çaÖBFÄ*® Ä4‰€∂î5]RﬂJ∂íˆÒ¬C´˛}OÏ·åLçJB"ÀÁ/=˛bﬁ˘™SL6J~AÎO€ñümˇ ·SˆsqãÉ®…îÕáeÌ.≈]äªv*ÏUÿ´±WbÆ≈]ä¶öòot°yß»cîl{Ü—◊£©ˇ Ær2àê¢ 216E˘œ∂˛mµ.£“ªäÇX∫“Ω3˚Q∑¸}ñ˝ó}>lGÚvÿ≤Òè4ﬂÃ]≥Û£XÍ	Œ6ËFÃß≥∆ﬂ≤Àˇ ]|9\&`l3ú≈Œﬁx¸ªæÚ¨ú•˝ıõ$ +¸≤/˚≠ˇ ‚_≥À‚Õ∆,¢n´&#(	SQ±sKË_ ˘ÀCÀ‚=+Õ|Ô¨gœˇ .øÔB≠˚ﬂÚüÏ‚Ø≠º≥ÊÕ/Õk®Ë∑1›[7Ì!Ëï◊ÌFˇ ‰:Ú≈S|Uÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ß4…
%!QA$ì@ Ò≈_=~mˇ ŒZi⁄(}7 oÔwSq÷?‰¯¯ıu˛[˝úUÚOò|…®yäÒı-Zwπ∫êÔ#öüó˘*?e·_Ÿ≈V˘À◊˛`ºèM“°{õ©MTü˘•ôõ·≈_k~FŒ9ŸyV’∏›kl+À™C_ÿá∆OÊõ˛¸•^◊äªv*ÏUÿ´Õˇ 9ø:tﬂÀ{“>©2ü´€WØ¸[/ÚBøOˆ¸ï_˘üÃ˙áöuµmVC=›√rb·QˆQ> "‚Ød¸•¸∂}?KjãK…Ó„=cS›ø‚◊ˇ ÑOÚπ*k5Ø“ñ5πzf`πÆ≈]äªv*ÏUÿ´±WÀˇ òﬁ`˝=≠‹]!¨*ﬁúg∑¯yg<§ˇ eõÃP·àó,∏•lóÀ?í≥k∫d:õ]`Yc1ñkEn|«€ß?≥îœR"i∂s!mÀ˘¨É˚ªãR=Ÿ¡ˇ ìG ’GÕ'K/$,ﬂëû`èÏò˝Y¸n´í¸ÃX˛ZHO˘R˛dˇ |/¸çO˘´ÊaﬁèÀ…‰Vø'⁄6Òˇ ≠!ˇ ç∞~f)¸¥ì/˘«ÌE⁄ówpFæ1Üs˜8á uqËÃiK%“!4´j5ÙÚ‹∞Ï)üˆ#úüÚW)ñ¨Ù—“é¨ãYÚŒõ°ËÑzuºpè™N	QV?}©îè˛…≤®d2ê≥’≤xƒbiÛUà&‚0:Û_◊õáR˝K]ÄÆ*ﬁ*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wˇ÷ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä∏önqWÊèÊWòòº…©jµ‰∑2≤®ë…>8´‹?)tï≤ÚÂ∫∫Ôq Wø3¡B#Õ>¢W?s∂”∆¢÷π˘G†jƒ∏Ñ€HMK@xvˇ }—¢ˇ Åèje5ñû'…Éj_Ûè∑iæüyû“´%?Ÿ'≠_¯ é¨u4¥ß°c7ìæeÄê∂¬U¥í&ˇ C2ø¸.\5=ZN	âDﬁC◊¢n-ß‹ö,L√ÔEañë=Cé]≈K¸ÆVü£Óˇ ‰DüÛN1ﬁé‹áÛâ>â}6ùr)$-ƒûƒ~√≥Oã$ÚbEs}˘WØc@∑byn=⁄õ†?‰ó¶Ÿß‘CÜ^˜mÇ|QeŸé‰;v*ÏUÿ´±WÉ˛r˘ÈóGZ≥_ÙKÜ¨†~ƒá©ˇ V_µ˛ø?≥f◊OóàQÊÍı∏MéJüê_úr˛]jˇ ÈEõGª!ncÒ?±sˇ <µ˛¸è·˚\8Ê8èæ,ØaΩÖ.≠ùdÜUé¶™ √í≤ü|Uäªv*ÏUä~c~\È~~“ﬂI’í†’¢ïG«ˆñ#ˇ _≥"‚ØÇø3+5oÀÕDÿj© &©Üuªï|W˘_˘„˚Iˇ ÿ´≤ºö dπµvähÿ2:HË À–‚Ø¨ˇ %?Á+‡øËﬁuuÜ‡QcΩËèÌs˛˙¯∑˚ØÁÙˇ iW“±J≤®t!ïÄ ÉPA≈U1WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±Wb®MOTµ“≠ﬁˆ˛TÇﬁ!…‰ëÇ™èÚò‚Øí?;Á*ß÷ΩM…Ã–Xö¨ó{¨≤ÎÌC˘ﬂ?¸W˚Jæm≈YÁÂÁÂç◊ôùnÓ˘Eßª˛””n1Ões6aÎ9∞ôˇ UÙ5ïî60•≠™·åqUQ@j$I6]® 

ÿ<3Û€ÃÔq|ö$M˚õuY$Î#
≠’âóè¸d|⁄iaB˚›f¶vkπÂYö·ªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ™}‰ﬂ3KÂÕJ-B:SI~“∂øwÿˇ /+…1Mêü	∑’AÉ
ÉPz—tßsm‘mË≤D‚å¨Ãß5∏R/bÒü=˛I…	kﬂ/ÒnZ‹üà∆?ﬁÚ„˛_S6Xµ7¥ùv]5oíÕ¿Ê9T´Æƒ0°ú·'SÛ¶ØÂ+±°‹…k8Î¿Ï√˘dCHø‰∫‚Øß.øÁ2¨ÓZy¬ù>≥ -ˇ *H?ºO˘ÁÍˇ ™∏´Ëo/yüLÛ∞Ω—ÓbªÄ˛‘LûÕ¸≠˛K|X™käªv*ÏUÿ´±WbÆ≈]äªv*ÏUNy„ÅYò"(©f  =Œ*ÒüÃ/˘ Ø+˘a^ﬂLs™ﬁäÄ∞›˛]œÿˇ ë>Æ*˘gÛ'Û”Ãæ~c°?£bME¨5Hˇ ÁßÌÃﬂÒïõ¸û8´ŒÒW§~U˛EÎﬂòíá¥O´i¿—ÓÂ&›V%Î;ˇ íüÏ›1W⁄ﬂñî∫'ÂÂü’¥à˘O ká°íOõ~ ,iƒ±Vmäªv*ÏUÿ´ƒ?;?Á%¥Ô%,öNåRÛZ°Ü±@‚ÊnEˇ |/¸Ù·˚Jæ-◊µÎˇ 0ﬁ…®Ís=≈‹ÕVw5$ˇ ˛U_Ög{ÂoÂWËÓ∆≤üÈ=bÖø›Â»?ﬂø üÓØ⁄˝Ô˜z‹˙ã⁄.√
ﬁOTÃ=ÿ´±WbÆ≈]äªv*√5º’˙GqRÍÍ±E‚*?y'˚˝Ø˜„Gô:||R˛´çû|1˜æ~Ú÷á.Ω®A¶A≥L‡˛Uè˛¡>,⁄Œ\"›\#ƒiı}≠¥v±%º
(î"(ËG_†fàõ6Ô °JòÏUÿ´±WbÆ≈X◊ÊMÿ¥ÚÌÙáº%?‡»ã˛7ÀòhŒj%ÛØì≠>π≠X[uın†O¯'UÕ”ß~ù‚Æ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ˇ ˇ◊ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]ä±üÃÕ{Ùñµ-P<≤≤Ø«åÚPÆ*¸‘çFª≥UıÓùdñ—Y«ˆ!çc_íÄÉıfÇFÕªÿäà»≤v*ÏUÿ´±Wå~}˘sÑêkq
˝ÃΩ:ä¥MÓJÛ_ıc\Ÿi'∑Æ’C~$õÚGÃ√L’Nù1§7†(Øi˚Ø¯?ä?ıŸ2ÕL8£Õk”œÑ◊Ûü@f•⁄ªv*ÏUÿ´±T>£ß¡®€…gvÇH%R¨ß∏ˇ ?≤ﬂ≥íååMÜ2àê¢˘üœûKü ∑∆ﬁJµºï0…ŸñΩ¸Xüe◊˝üÌfÎA1nü&3OZˇ úpˇ úÉ>Së<∑Ê'?¢%o‹Ãw˙ª—øÂŸœ⁄ˇ }7«ˆyÂ≠O≥¢ï&A$d2∞j=∆*©äªv*ÏU#ÛwìÙœ7XI•kPâÌ§Ïv*e„¥éøÕäæ$¸Âˇ úz’ø/dk€nWö3ÜuWˆ.U~«¸e˛Èˇ »o›‚Ø"≈^Ø˘Oˇ 9Øy •°oÆÈ@ä€ MTÀºùbˇ W‚ã¸åUˆÂ«ÁGó|ˇ ˝8K∫U≠•¢ æ?I¸∏π‚¨Ûv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äºßÛC˛r3ÀûEW∂Y˛¶µVÅÅ‚Â‚_â!ˇ W‚ó˛+≈_~f~qkﬂòWıY∏Z°&;hÍ"_ˆ?Ó«ˇ ã$‰ﬂÏqV	äΩCÚ”Ú°ır∫û∞Öl∂dèÏô{é—ƒøg0Ûg·ÿ}N^[ûOvÜÖ(î" 
™¢Ä—TÄf¨õv`RÏ	v*˘£Ûj'èÃ∑ÇN§∆Aˆ(îÕ÷§:lﬂQaŸ{K±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äª}+‰üÃ˙ ⁄Ã]¢‹§1£$ü,TÖÁ≈Úˇ }≥fü.M;ly¢@ÃÛ…v*∆ºŸ˘{•yòsªèÖÕ(&Mü˝óÏ»øÎˇ ∞·ó„Ã`—ìõƒ¸ﬂ˘Q™˘{îÒ©∫≥ô#®ˇ ãc›ì˝oä?ÚÛeè<fÎ≤a0aê–ôh~a‘4Åy•\Kk8˝∏ú°ˇ Ö≈^’‰ˇ ˘Ã?3È!b÷báSàmV˝‘¥ˇ åëèOÔá{Oïˇ Á.¸ù´Q5>ù)ÎÎ'$ˇ ëêzüËò´‘t/>h:¯Æï®[]{G*≥¿Wó¸.*übÆ≈]äªv*ÏU©kV:Zz∫ÖƒVÈ„+™¯r∏´Œ<Àˇ 93‰}˙¯ºî~≈™ôkˇ =?‰Æ*ÒÔ6ˇ Œk›Ã/-iÎ=%∫nMˇ ""‚´ˇ #d≈^ÁÕ?2y…â÷Ô•û:‘D« ¯«ˇ ä±<Uíy7Ú˜\Ûù«’4+I.X…Ä¢%ﬂ≤∑Ó„ˇ dÿ´ÍO Ô˘ƒ=7H)Ê◊[˚°B-“¢?ÂüÖÁˇ Ñè¸ó≈_C[[Ek¡¨q†Q@
†vU]óV≈]äªv*ê˘ªŒ˙?î-˛πrñ–ä”ë¯òèŸä1Ò»ﬂ‰¢‚Øì?7Á+ı/1â4œ+á”ÙÛUi´I‰≈ﬁtˇ S˜üÒgÏbØ“4{ΩjÂm,cig~√Òfc®ˇ +#)ÓYF$Ïı˘y˘WoÂ¿∑∑‹g‘:ÉOÜ?¯«‚ˇ Òo¸Û>Ø6£ãaÙª,X8w<Ÿˆb9n≈]äªv*ÏUÿ´±W3ò–§‚Øôø2¸·˛&’Xâ˙¨5é‚+ÒIˇ =>◊˙º3uá ßMó'∑°~EyOÍˆÚk◊˚…Î5ÏÄ¸o˛Õ«˘Á¸≤f&´'á+Mè¯ûØò{±WbÆ≈]äªv*¡:ØﬂÀsFzœ$qèòa/¸ Ã≠(ı8∫ìÈyg‰fö5;hP.„êè¯«˚ˇ ˘óõwT˝≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUˇ–ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äºW˛r„\wí%∂ç{q#‰÷˛LbØéø.t„®yÇ ⁄a!ØÑæ?Ò´)®í€à\ÉÍ<—ªßbÆ≈]äªv*ñ˘èCã]”Á”gŸfB†“º[™?˚‚Ÿf9kú8Ö>VΩ≤∏“Æﬁﬁ`c∏∑rßŸî˛…ˇ àÊîä/¶|ÉÊ¥Û6óÂGÆø ;8¯}±Òˇ ≤·˚9•ÕèÄªå98√" [ùäªv*ÏUÿ™WÊO.Z˘ÜÕÏ/V®€É›[ˆ]? f9òsÄò¢˘´Œ>PªÚ≈·¥πCºr≤Î‚=ˇ ùg78Ú	ã¢p04^ø˘ˇ 9%7î==Ãl”hı)~”€◊∑åñˇ ‰}∏ø›Ôº±≠ˆfù®€jvÒﬁŸHì[Ã°„ëe`iXb®¨Uÿ´±Wb™S@ì£E*áF2∞{äæk¸ﬁˇ úF∑‘ÍûJ+o1´5õF«˛]‰ˇ tˇ ∆'˝◊Ú¥X´Â]sAø–nö√TÇKk®˛“H•H˛œÚ±T-µ‘∂í¨ˆÓcï* H éÍ√{èÂÁ¸Âøòºº”\Q™⁄-'<f˛3S˜üÛ’y≈ò´È#ŒC˘GÕ·c∑ª∑m˛Ëπ§o_b})?Áúò´“ïÉ A®;Ç1Uÿ´±WbÆ≈]äªv*ÏUÿ´±U+ãòÌ„ifeé5,ƒ¸¶8´»ºıˇ 9IÂ,Ü÷c©›Æﬁù∂È_ÚÓÓø‰_´˛Æ*˘´Û˛roÕ>qÁmü£l[oJÿêƒ≈∑ﬁ?˚I?»≈^Eä∂vqW≤~\˛N0d‘¸¿ª
2[Ÿiˇ ’ˇ |ˇ »œ⁄ç∞3j:EŒ√ßÎ'±ÅMáL÷ªb™7wêYD◊R,Q/Wv
£ÊÕ∂vIõÕºÀ˘ÎßŸÜãGå›KΩ™ëÉˇ '$ˇ íÎÊl4§˝N$ı@rxˇ ö<œwÊK≥}}«‘ ((äÒã}¨ÿBÉÅ9ô)6MÉ±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*…¸µ˘á´˘xÖ≥ò¥˝”'ƒîˇ $Óˇ ÿ2ÂS≈ÛmÜSOZÚóÁ^ù™ï∑‘◊ÍwÉë5àùøoÌG_Ú˛ˇ ~ÊM)∑s±ÍAÁ≥—ë÷EÑ2∞®#pAÃ")Àªo∞6˛QÈ:ıgÄ}RËÔŒ08±ˇ ã"˚'˝á˛nYïèPcœ‘‚‰”ârÙºcÃˇ ó«ó9=‘>•∏ˇ wEÒ'˚/€è˛z*ìõfå˘:˘‚î9±lπ©ÿ´`”|UêÈ_ò^b“)˙?SºÄÅ'p?‡9q≈YEß¸‰wüm(#’•`?ù#˘9b©ƒÛñ}åQØ"ì˝kxˇ „T\U{ŒZyäòG∏Å?ÊúU-ªˇ úúÛ˝◊]L∆?»Ü!ˇ 2±V;™~o˘øT®ª’ÔYOU2/¸eb∑7s]9ñ·⁄IVbI˚Œ*°ä™EÃ‚8¡gc@‰‚ØKÚo¸„óúº”≈‚≤6ñÌ˛Ì∫˝–ß˙á˜Ì˛∆,UÙêøÁÙ- ≠œòÊ}Nqø¶µé~J}Y?‡”˛1‚Øx“¥ã="›lÙËc∑∑èeé%
£‰´ä£1WbÆ≈]ä±ü8~dy…Òu€ÿ≠ç*ö»ﬂÍBú•¯UÛßÊ¸Êl”¥Úu∑§G÷n -Ûé—Á£?¸c≈_9yÉÃ∫óòÓçˆØq%›À˛‘åXˇ ™ø ø‰Æ* ºõ˘?©kº.o?—,ò…á∆¿äèN?¯›¯ˇ ëœ1≤j<ÀìèóπÓ^[ÚÆüÂ»>ØßDrsªπ‰~ˇ ÒÂ\’œ!ü7ebìl≠±ÿ´±WbÆ≈]äªv*ÏUÊù>x˝k˙Õø“n˜§“3˚?ÎKˇ &ˇ ◊\Œ”bøQpµ9+“Q‰o*…Ê}J;®à|r∑Ú†?ˇ X˝îˇ /égdü ∑8Õ>¢∂∑é⁄$ÇjTt 
(Õ!7ª∫∂T¿óbÆ≈]äªv*ÏUÂ_ÛêW‹4˚K>ÚÃ“»µ„ˇ 3Û?H7%¡’ùÄAˇ Œ$Èb˚œ0LE~´Û¬˙Û;6Nπ˜n*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbØˇ—ıN*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äªv*ÏUÿ´±WbÆ≈]äæXˇ ú‡÷HM#JS±3N√Â¬8ˇ ‚R‚Ø¸à∞[çmÓW–ÅôOÉ1Xˇ ‚&bjçE ”ìﬂÛRÌ]äªv*ÏUÿ´±Wè~y˘4ø0⁄Ø@‡¬≈/¸Ào˘Á˛Vltπ?Ñ∫˝N?‚/Ú√ŒáÀ:êı€˝
‚â7]∫ó˛y∑¸'<…Õèå8¯rp“™¡ÖT‘Ñfï‹;v*ÏUÿ´±Wb©oò|ªgÊF±øNq∑B>“ûœ~À˙Î·À!3aÆp_:y◊Ú˛˚ ≥RqÍ⁄1§s( q˚ìˇ Ÿ∑«îLlÍrb0Ê»(=uüÀõÖä˙ŒñÕY-\ÌøWÖø›2¬7Ì¶\‘˚_ÚÎÛWBÛ˝†∫—¶U À–K¸dè˛7NQˇ ïä≥Uÿ´±WbÆ≈X◊ùø.Ù?;[}O]µKÖa˛Àß¸bï~4ˇ à‚Øñˇ 1øÁ5m'ùﬂï%˝!l7Ùd¢Œ£ÿ¸1Mˇ $õ˛+≈^™ÈzM√Zj…mpá‚éE*√˝ãÔä†±VaÂ/Õœ4˘Nâ£j3≈ÙâõúÚ&^qˇ ¬‚ØbÚ◊¸ÊÆ±jzÌÑ7k›·c}«÷OªÜ*ÙÕ˛s…˜¿Â∫≤n¸„ÊøP4çˇ $ÒVs¶˛{˘#Q √¨Z≠{J˛ó¸üÙÒVKgÊ˝kk-ído¯ãb©Ç_€Ω8 ÜΩ(¿‚´_RµåUÊçGªä•∑æz–lkΩF“?ûx◊˛$¯´’Á!<ã¶f’†êé–ÚñøÚ!d≈X&Ωˇ 9õÂk*¶õouz„°‚±°ˇ dÌÍ…,UÂﬁfˇ úŒÛ-¯1Ëˆ÷ˆz1¨≤ˆO¬/˘#äº{Ãˇ ò˜öüûπ}=ÿÍ‹ÍD?tüÏSc∏´±TœAÚ˝Óªp,Ù¯Ã≤ë]∫¸Œ›? » B"À(ƒ»–{ﬂêø*Ï¸µKªí./ˆ¯»¯S˛0Éˇ '‚˛^-^]Aû√Èvx∞Óy≥¨ƒrùäºÎŒ_ú÷96⁄`[€ë±!øvøÏ◊˚√˛J¡Êf=1ñÁg&†ÜÔÛöu0ÕÎÍS4Ñ}ïË´˛¢Ö ˛o⁄Õî #∞uÚôó4£&¡Ë^E¸àÛgùÀßY¥v≠ˇ ªéû*[„ì˛x§ò´.Ûˇ ¸‚ò¸Øb∫çã¶®™§Œê+éù—‚ù?’˝Á¸WäºDÇƒb´qWbÆ≈]äªv*ÏUÿ´±WbØG¸©¸é◊?1gjÜﬂMí]»æ“≈˛˛ì¸îˇ f…äæŒ–ˇ #|ß•ËÒË/a‘+ª<ËGsˆ•2˝•sˇ Ò‡ø
bØ4Ûø¸·Æá®ÜüÀwiÛƒrVXøﬂß¸üÍ‚Øúºˇ ˘'Ê#˙≠´5®4¸qõÆÒˇ œUè`X´.Ú_ÊF•ÂáƒL÷ÑÔìO˘Â˛˚oı~◊Ì.Sìü6ÏyL˚Â/9ÿy¢ﬂÎ,CØ€â®˘C˘ï◊˛%Êß&#ª¥«îOí{ï6ªaﬁe¸®—5 …È˝Z‡ˇ ª!¢◊˝xÈÈ∑¸
ø˘yìD£˝'zxÀ…Âﬁb¸ë÷4‚“XΩÑo¸/Oxõ˛e…#fl51ó?Ká=<á/Sæ∞∏±ï≠Ó„h•CFW}¡Ã†m∆"ê∏PÏUÿ™w†y7VÛ¸r≠û‡÷îB	ˇ ÅÎä≤ªo˘«ü=‹˝ç"q_Á(üÚq◊do¸‚_ûØ)Í€¡m_˜ÏÎˇ 2}lUòËﬂÛÑz§¥mWTÇo/„'’ÒW¢˘{˛pÎ :}Q{õ˜C∏ç˚ø¸ï≈^≠ÂØÀﬂ/˘e@—l-ÌOÛ"L¶≤¯,UëbÆ≈]ä°ÓÔ`≥C-Ãã¨Ï}Ìä∞o0˛~y+B‰.µH$uÿ§Ã’ˇ ûO¯lUÂûgˇ ú÷“≠√G†iÛ]?@Û∞â~|S’ëø‰û*Òü8ŒOy”ÃÅ¢K°anﬂ±h8∆oä¯1WóK-≈Ù∆IÕ<árjÃƒˇ √6*Õºµ˘7¨ÍÙíÈ~•˝©G«