ly, the session ticket keys in the
<a href="/pkg/crypto/tls/"><code>crypto/tls</code></a> package
can now be changed while the server is running.
This is done through the new
<a href="/pkg/crypto/tls/#Config.SetSessionTicketKeys"><code>SetSessionTicketKeys</code></a>
method of the
<a href="/pkg/crypto/tls/#Config"><code>Config</code></a> type.
</li>

<li>
In the <a href="/pkg/crypto/x509/"><code>crypto/x509</code></a> package,
wildcards are now accepted only in the leftmost label as defined in
<a href="https://tools.ietf.org/html/rfc6125#section-6.4.3">the specification</a>.
</li>

<li>
Also in the <a href="/pkg/crypto/x509/"><code>crypto/x509</code></a> package,
the handling of unknown critical extensions has been changed.
They used to cause parse errors but now they are parsed and caused errors only
in <a href="/pkg/crypto/x509/#Certificate.Verify"><code>Verify</code></a>.
The new field <code>UnhandledCriticalExtensions</code> of
<a href="/pkg/crypto/x509/#Certificate"><code>Certificate</code></a> records these extensions.
</li>

<li>
The <a href="/pkg/database/sql/#DB"><code>DB</code></a> type of the
<a href="/pkg/database/sql/"><code>database/sql</code></a> package
now has a <a href="/pkg/database/sql/#DB.Stats"><code>Stats</code></a> method
to retrieve database statistics.
</li>

<li>
The <a href="/pkg/debug/dwarf/"><code>debug/dwarf</code></a>
package has extensive additions to better support DWARF version 4.
See for example the definition of the new type
<a href="/pkg/debug/dwarf/#Class"><code>Class</code></a>.
</li>

<li>
The <a href="/pkg/debug/dwarf/"><code>debug/dwarf</code></a> package
also now supports decoding of DWARF line tables.
</li>

<li>
The <a href="/pkg/debug/elf/"><code>debug/elf</code></a>
package now has support for the 64-bit PowerPC architecture.
</li>

<li>
The <a href="/pkg/encoding/base64/"><code>encoding/base64</code></a> package
now supports unpadded encodings through two new encoding variables,
<a href="/pkg/encoding/base64/#RawStdEncoding"><code>RawStdEncoding</code></a> and
<a href="/pkg/encoding/base64/#RawURLEncoding"><code>RawURLEncoding</code></a>.
</li>

<li>
The <a href="/pkg/encoding/json/"><code>encoding/json</code></a> package
now returns an <a href="/pkg/encoding/json/#UnmarshalTypeError"><code>UnmarshalTypeError</code></a>
if a JSON value is not appropriate for the target variable or component
to which it is being unmarshaled.
</li>

<li>
The <code>encoding/json</code>'s
<a href="/pkg/encoding/json/#Decoder"><code>Decoder</code></a>
type has a new method that provides a streaming interface for decoding
a JSON document:
<a href="/pkg/encoding/json/#Decoder.Token"><code>Token</code></a>.
It also interoperates with the existing functionality of <code>Decode</code>,
which will continue a decode operation already started with <code>Decoder.Token</code>.
</li>

<li>
The <a href="/pkg/flag/"><code>flag</code></a> package
has a new function, <a href="/pkg/flag/#UnquoteUsage"><code>UnquoteUsage</code></a>,
to assist in the creation of usage messages using the new convention
described above.
</li>

<li>
In the <a href="/pkg/fmt/"><code>fmt</code></a> package,
a value of type <a href="/pkg/reflect/#Value"><code>Value</code></a> now
prints what it holds, rather than use the <code>reflect.Value</code>'s <code>Stringer</code>
method, which produces things like <code>&lt;int Value&gt;</code>.
</li>

<li>
The <a href="/pkg/ast/#EmptyStmt"><code>EmptyStmt</code></a> type
in the <a href="/pkg/go/ast/"><code>go/ast</code></a> package now
has a boolean <code>Implicit</code> field that records whether the
semicolon was implicitly added or was present in the source.
</li>

<li>
For forward compatibility the <a href="/pkg/go/build/"><code>go/build</code></a> package
reserves <code>GOARCH</code> values for  a number of architectures that Go might support one day.
This is not a promise that it will.
Also, the <a href="/pkg/go/build/#Package"><code>Package</code></a> struct
now has a <code>PkgTargetRoot</code> field that stores the
architecture-dependent root directory in which to install, if known.
</li>

<li>
The (newly migrated) <a href="/pkg/go/types/"><code>go/types</code></a>
package allows one to control the prefix attached to package-level names using
the new <a href="/pkg/go/types/#Qualifier"><code>Qualifier</code></a>
function type as an argument to several functions. This is an API change for
the package, but since it is new to the core, it is not breaking the Go 1 compatibility
rules since code that uses the package must explicitly ask for it at its new location.
To update, run
<a href="https://golang.org/cmd/go/#hdr-Run_go_tool_fix_on_packages"><code>go fix</code></a> on your package.
</li>

<li>
In the <a href="/pkg/image/"><code>image</code></a> package,
the <a href="/pkg/image/#Rectangle"><code>Rectangle</code></a> type
now implements the <a href="/pkg/image/#Image"><code>Image</code></a> interface,
so a <code>Rectangle</code> can serve as a mask when drawing.
</li>

<li>
Also in the <a href="/pkg/image/"><code>image</code></a> package,
to assist in the handling of some JPEG images,
there is now support for 4:1:1 and 4:1:0 YCbCr subsampling and basic
CMYK support, represented by the new <code>image.CMYK</code> struct.
</li>

<li>
The <a href="/pkg/image/color/"><code>image/color</code></a> package
adds basic CMYK support, through the new
<a href="/pkg/image/color/#CMYK"><code>CMYK</code></a> struct,
the <a href="/pkg/image/color/#CMYKModel"><code>CMYKModel</code></a> color model, and the
<a href="/pkg/image/color/#CMYKToRGB"><code>CMYKToRGB</code></a> function, as
needed by some JPEG images.
</li>

<li>
Also in the <a href="/pkg/image/color/"><code>image/color</code></a> package,
the conversion of a <a href="/pkg/image/color/#YCbCr"><code>YCbCr</code></a>
value to <code>RGBA</code> has become more precise.
Previously, the low 8 bits were just an echo of the high 8 bits;
now they contain more accurate information.
Because of the echo property of the old code, the operation
<code>uint8(r)</code> to extract an 8-bit red value worked, but is incorrect.
In Go 1.5, that operation may yield a different value.
The correct code is, and always was, to select the high 8 bits:
<code>uint8(r&gt;&gt;8)</code>.
Incidentally, the <code>image/draw</code> package
provides better support for such conversions; see
<a href="https://blog.golang.org/go-imagedraw-package">this blog post</a>
for more information.
</li>

<li>
Finally, as of Go 1.5 the closest match check in
<a href="/pkg/image/color/#Palette.Index"><code>Index</code></a>
now honors the alpha channel.
</li>

<li>
The <a href="/pkg/image/gif/"><code>image/gif</code></a> package
includes a couple of generalizations.
A multiple-frame GIF file can now have an overall bounds different
from all the contained single frames' bounds.
Also, the <a href="/pkg/image/gif/#GIF"><code>GIF</code></a> struct
now has a <code>Disposal</code> field
that specifies the disposal method for each frame.
</li>

<li>
The <a href="/pkg/io/"><code>io</code></a> package
adds a <a href="/pkg/io/#CopyBuffer"><code>CopyBuffer</code></a> function
that is like <a href="/pkg/io/#Copy"><code>Copy</code></a> but
uses a caller-provided buffer, permitting control of allocation and buffer size.
</li>

<li>
The <a href="/pkg/log/"><code>log</code></a> package
has a new <a href="/pkg/log/#LUTC"><code>LUTC</code></a> flag
that causes time stamps to be printed in the UTC time zone.
It also adds a <a href="/pkg/log/#Logger.SetOutput"><code>SetOutput</code></a> method
for user-created loggers.
</li>

<li>
In Go 1.4, <a href="/pkg/math/#Max"><code>Max</code></a> was not detecting all possible NaN bit patterns.
This is fixed in Go 1.5, so programs that use <code>math.Max</code> on data including NaNs may behave differently,
but now correctly according to the IEEE754 definition of NaNs.
</li>

<li>
The <a href="/pkg/math/big/"><code>math/big</code></a> package
adds a new <a href="/pkg/math/big/#Jacobi"><code>Jacobi</code></a>
function for integers and a new
<a href="/pkg/math/big/#Int.ModSqrt"><code>ModSqrt</code></a>
method for the <a href="/pkg/math/big/#Int"><code>Int</code></a> type.
</li>

<li>
The mime package
adds a new <a href="/pkg/mime/#WordDecoder"><code>WordDecoder</code></a> type
to decode MIME headers containing RFC 204-encoded words.
It also provides <a href="/pkg/mime/#BEncoding"><code>BEncoding</code></a> and
<a href="/pkg/mime/#QEncoding"><code>QEncoding</code></a>
as implementations of the encoding schemes of RFC 2045 and RFC 2047.
</li>

<li>
The <a href="/pkg/mime/"><code>mime</code></a> package also adds an
<a href="/pkg/mime/#ExtensionsByType"><code>ExtensionsByType</code></a>
function that returns the MIME extensions know to be associated with a given MIME type.
</li>

<li>
There is a new <a href="/pkg/mime/quotedprintable/"><code>mime/quotedprintable</code></a>
package that implements the quoted-printable encoding defined by RFC 2045.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package will now
<a href="/pkg/net/#Dial"><code>Dial</code></a> hostnames by trying each
IP address in order until one succeeds.
The <code><a href="/pkg/net/#Dialer">Dialer</a>.DualStack</code>
mode now implements Happy Eyeballs
(<a href="https://tools.ietf.org/html/rfc6555">RFC 6555</a>) by giving the
first address family a 300ms head start; this value can be overridden by
the new <code>Dialer.FallbackDelay</code>.
</li>

<li>
A number of inconsistencies in the types returned by errors in the
<a href="/pkg/net/"><code>net</code></a> package have been
tidied up.
Most now return an
<a href="/pkg/net/#OpError"><code>OpError</code></a> value
with more information than before.
Also, the <a href="/pkg/net/#OpError"><code>OpError</code></a>
type now includes a <code>Source</code> field that holds the local
network address.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package now
has support for setting trailers from a server <a href="/pkg/net/http/#Handler"><code>Handler</code></a>.
For details, see the documentation for
<a href="/pkg/net/http/#ResponseWriter"><code>ResponseWriter</code></a>.
</li>

<li>
There is a new method to cancel a <a href="/pkg/net/http/"><code>net/http</code></a>
<code>Request</code> by setting the new
<a href="/pkg/net/http/#Request"><code>Request.Cancel</code></a>
field.
It is supported by <code>http.Transport</code>.
The <code>Cancel</code> field's type is compatible with the
<a href="https://godoc.org/golang.org/x/net/context"><code>context.Context.Done</code></a>
return value.
</li>

<li>
Also in the <a href="/pkg/net/http/"><code>net/http</code></a> package,
there is code to ignore the zero <a href="/pkg/time/#Time"><code>Time</code></a> value
in the <a href="/pkg/net/#ServeContent"><code>ServeContent</code></a> function.
As of Go 1.5, it now also ignores a time value equal to the Unix epoch.
</li>

<li>
The <a href="/pkg/net/http/fcgi/"><code>net/http/fcgi</code></a> package
exports two new errors,
<a href="/pkg/net/http/fcgi/#ErrConnClosed"><code>ErrConnClosed</code></a> and
<a href="/pkg/net/http/fcgi/#ErrRequestAborted"><code>ErrRequestAborted</code></a>,
to report the corresponding error conditions.
</li>

<li>
The <a href="/pkg/net/http/cgi/"><code>net/http/cgi</code></a> package
had a bug that mishandled the values of the environment variables
<code>REMOTE_ADDR</code> and <code>REMOTE_HOST</code>.
This has been fixed.
Also, starting with Go 1.5 the package sets the <code>REMOTE_PORT</code>
variable.
</li>

<li>
The <a href="/pkg/net/mail/"><code>net/mail</code></a> package
adds an <a href="/pkg/net/mail/#AddressParser"><code>AddressParser</code></a>
type that can parse mail addresses.
</li>

<li>
The <a href="/pkg/net/smtp/"><code>net/smtp</code></a> package
now has a <a href="/pkg/net/smtp/#Client.TLSConnectionState"><code>TLSConnectionState</code></a>
accessor to the <a href="/pkg/net/smtp/#Client"><code>Client</code></a>
type that returns the client's TLS state.
</li>

<li>
The <a href="/pkg/os/"><code>os</code></a> package
has a new <a href="/pkg/os/#LookupEnv"><code>LookupEnv</code></a> function
that is similar to <a href="/pkg/os/#Getenv"><code>Getenv</code></a>
but can distinguish between an empty environment variable and a missing one.
</li>

<li>
The <a href="/pkg/os/signal/"><code>os/signal</code></a> package
adds new <a href="/pkg/os/signal/#Ignore"><code>Ignore</code></a> and
<a href="/pkg/os/signal/#Reset"><code>Reset</code></a> functions.
</li>

<li>
The <a href="/pkg/runtime/"><code>runtime</code></a>,
<a href="/pkg/runtime/trace/"><code>runtime/trace</code></a>,
and <a href="/pkg/net/http/pprof/"><code>net/http/pprof</code></a> packages
each have new functions to support the tracing facilities described above:
<a href="/pkg/runtime/#ReadTrace"><code>ReadTrace</code></a>,
<a href="/pkg/runtime/#StartTrace"><code>StartTrace</code></a>,
<a href="/pkg/runtime/#StopTrace"><code>StopTrace</code></a>,
<a href="/pkg/runtime/trace/#Start"><code>Start</code></a>,
<a href="/pkg/runtime/trace/#Stop"><code>Stop</code></a>, and
<a href="/pkg/net/http/pprof/#Trace"><code>Trace</code></a>.
See the respective documentation for details.
</li>

<li>
The <a href="/pkg/runtime/pprof/"><code>runtime/pprof</code></a> package
by default now includes overall memory statistics in all memory profiles.
</li>

<li>
The <a href="/pkg/strings/"><code>strings</code></a> package
has a new <a href="/pkg/strings/#Compare"><code>Compare</code></a> function.
This is present to provide symmetry with the <a href="/pkg/bytes/"><code>bytes</code></a> package
but is otherwise unnecessary as strings support comparison natively.
</li>

<li>
The <a href="/pkg/sync/#WaitGroup"><code>WaitGroup</code></a> implementation in
package <a href="/pkg/sync/"><code>sync</code></a>
now diagnoses code that races a call to <a href="/pkg/sync/#WaitGroup.Add"><code>Add</code></a>
against a return from <a href="/pkg/sync/#WaitGroup.Wait"><code>Wait</code></a>.
If it detects this condition, the implementation panics.
</li>

<li>
In the <a href="/pkg/syscall/"><code>syscall</code></a> package,
the Linux <code>SysProcAttr</code> struct now has a
<code>GidMappingsEnableSetgroups</code> field, made necessary
by security changes in Linux 3.19.
On all Unix systems, the struct also has new <code>Foreground</code> and <code>Pgid</code> fields
to provide more control when exec'ing.
On Darwin, there is now a <code>Syscall9</code> function
to support calls with too many arguments.
</li>

<li>
The <a href="/pkg/testing/quick/"><code>testing/quick</code></a> will now
generate <code>nil</code> values for pointer types,
making it possible to use with recursive data structures.
Also, the package now supports generation of array types.
</li>

<li>
In the <a href="/pkg/text/template/"><code>text/template</code></a> and
<a href="/pkg/html/template/"><code>html/template</code></a> packages,
integer constants too large to be represented as a Go integer now trigger a
parse error. Before, they were silently converted to floating point, losing
precision.
</li>

<li>
Also in the <a href="/pkg/text/template/"><code>text/template</code></a> and
<a href="/pkg/html/template/"><code>html/template</code></a> packages,
a new <a href="/pkg/text/template/#Template.Option"><code>Option</code></a> method
allows customization of the behavior of the template during execution.
The sole implemented option allows control over how a missing key is
handled when indexing a map.
The default, which can now be overridden, is as before: to continue with an invalid value.
</li>

<li>
The <a href="/pkg/time/"><code>time</code></a> package's
<code>Time</code> type has a new method
<a href="/pkg/time/#Time.AppendFormat"><code>AppendFormat</code></a>,
which can be used to avoid allocation when printing a time value.
</li>

<li>
The <a href="/pkg/unicode/"><code>unicode</code></a> package and associated
support throughout the system has been upgraded from version 7.0 to
<a href="http://www.unicode.org/versions/Unicode8.0.0/">Unicode 8.0</a>.
</li>

</ul>
                                                                                                                                                                                                                                                                                                                                        usr/local/go/doc/go1.6.html                                                                         0100644 0000000 0000000 00000111325 13020111411 014025  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "Go 1.6 Release Notes",
	"Path":  "/doc/go1.6",
	"Template": true
}-->

<!--
Edit .,s;^PKG:([a-z][A-Za-z0-9_/]+);<a href="/pkg/\1/"><code>\1</code></a>;g
Edit .,s;^([a-z][A-Za-z0-9_/]+)\.([A-Z][A-Za-z0-9_]+\.)?([A-Z][A-Za-z0-9_]+)([ .',]|$);<a href="/pkg/\1/#\2\3"><code>\3</code></a>\4;g
-->

<style>
ul li { margin: 0.5em 0; }
</style>

<h2 id="introduction">Introduction to Go 1.6</h2>

<p>
The latest Go release, version 1.6, arrives six months after 1.5.
Most of its changes are in the implementation of the language, runtime, and libraries.
There are no changes to the language specification.
As always, the release maintains the Go 1 <a href="/doc/go1compat.html">promise of compatibility</a>.
We expect almost all Go programs to continue to compile and run as before.
</p>

<p>
The release adds new ports to <a href="#ports">Linux on 64-bit MIPS and Android on 32-bit x86</a>;
defined and enforced <a href="#cgo">rules for sharing Go pointers with C</a>;
transparent, automatic <a href="#http2">support for HTTP/2</a>;
and a new mechanism for <a href="#template">template reuse</a>.
</p>

<h2 id="language">Changes to the language</h2>

<p>
There are no language changes in this release.
</p>

<h2 id="ports">Ports</h2>

<p>
Go 1.6 adds experimental ports to
Linux on 64-bit MIPS (<code>linux/mips64</code> and <code>linux/mips64le</code>).
These ports support <code>cgo</code> but only with internal linking.
</p>

<p>
Go 1.6 also adds an experimental port to Android on 32-bit x86 (<code>android/386</code>).
</p>

<p>
On FreeBSD, Go 1.6 defaults to using <code>clang</code>, not <code>gcc</code>, as the external C compiler.
</p>

<p>
On Linux on little-endian 64-bit PowerPC (<code>linux/ppc64le</code>),
Go 1.6 now supports <code>cgo</code> with external linking and
is roughly feature complete.
</p>

<p>
On NaCl, Go 1.5 required SDK version pepper-41.
Go 1.6 adds support for later SDK versions.
</p>

<p>
On 32-bit x86 systems using the <code>-dynlink</code> or <code>-shared</code> compilation modes,
the register CX is now overwritten by certain memory references and should
be avoided in hand-written assembly.
See the <a href="/doc/asm#x86">assembly documentation</a> for details.
</p>

<h2 id="tools">Tools</h2>

<h3 id="cgo">Cgo</h3>

<p>
There is one major change to <a href="/cmd/cgo/"><code>cgo</code></a>, along with one minor change.
</p>

<p>
The major change is the definition of rules for sharing Go pointers with C code,
to ensure that such C code can coexist with Go's garbage collector.
Briefly, Go and C may share memory allocated by Go
when a pointer to that memory is passed to C as part of a <code>cgo</code> call,
provided that the memory itself contains no pointers to Go-allocated memory,
and provided that C does not retain the pointer after the call returns.
These rules are checked by the runtime during program execution:
if the runtime detects a violation, it prints a diagnosis and crashes the program.
The checks can be disabled by setting the environment variable
<code>GODEBUG=cgocheck=0</code>, but note that the vast majority of
code identified by the checks is subtly incompatible with garbage collection
in one way or another.
Disabling the checks will typically only lead to more mysterious failure modes.
Fixing the code in question should be strongly preferred
over turning off the checks.
See the <a href="/cmd/cgo/#hdr-Passing_pointers"><code>cgo</code> documentation</a> for more details.
</p>

<p>
The minor change is
the addition of explicit <code>C.complexfloat</code> and <code>C.complexdouble</code> types,
separate from Go's <code>complex64</code> and <code>complex128</code>.
Matching the other numeric types, C's complex types and Go's complex type are
no longer interchangeable.
</p>

<h3 id="compiler">Compiler Toolchain</h3>

<p>
The compiler toolchain is mostly unchanged.
Internally, the most significant change is that the parser is now hand-written
instead of generated from <a href="/cmd/yacc/">yacc</a>.
</p>

<p>
The compiler, linker, and <code>go</code> command have a new flag <code>-msan</code>,
analogous to <code>-race</code> and only available on linux/amd64,
that enables interoperation with the <a href="http://clang.llvm.org/docs/MemorySanitizer.html">Clang MemorySanitizer</a>.
Such interoperation is useful mainly for testing a program containing suspect C or C++ code.
</p>

<p>
The linker has a new option <code>-libgcc</code> to set the expected location
of the C compiler support library when linking <a href="/cmd/cgo/"><code>cgo</code></a> code.
The option is only consulted when using <code>-linkmode=internal</code>,
and it may be set to <code>none</code> to disable the use of a support library.
</p>

<p>
The implementation of <a href="/doc/go1.5#link">build modes started in Go 1.5</a> has been expanded to more systems.
This release adds support for the <code>c-shared</code> mode on <code>android/386</code>, <code>android/amd64</code>,
<code>android/arm64</code>, <code>linux/386</code>, and <code>linux/arm64</code>;
for the <code>shared</code> mode on <code>linux/386</code>, <code>linux/arm</code>, <code>linux/amd64</code>, and <code>linux/ppc64le</code>;
and for the new <code>pie</code> mode (generating position-independent executables) on
<code>android/386</code>, <code>android/amd64</code>, <code>android/arm</code>, <code>android/arm64</code>, <code>linux/386</code>,
<code>linux/amd64</code>, <code>linux/arm</code>, <code>linux/arm64</code>, and <code>linux/ppc64le</code>.
See the <a href="https://golang.org/s/execmodes">design document</a> for details.
</p>

<p>
As a reminder, the linker's <code>-X</code> flag changed in Go 1.5.
In Go 1.4 and earlier, it took two arguments, as in
</p>

<pre>
-X importpath.name value
</pre>

<p>
Go 1.5 added an alternative syntax using a single argument
that is itself a <code>name=value</code> pair:
</p>

<pre>
-X importpath.name=value
</pre>

<p>
In Go 1.5 the old syntax was still accepted, after printing a warning
suggesting use of the new syntax instead.
Go 1.6 continues to accept the old syntax and print the warning.
Go 1.7 will remove support for the old syntax.
</p>

<h3 id="gccgo">Gccgo</h3>

<p>
The release schedules for the GCC and Go projects do not coincide.
GCC release 5 contains the Go 1.4 version of gccgo.
The next release, GCC 6, will have the Go 1.6 version of gccgo.
</p>

<h3 id="go_command">Go command</h3>

<p>
The <a href="/cmd/go"><code>go</code></a> command's basic operation
is unchanged, but there are a number of changes worth noting.
</p>

<p>
Go 1.5 introduced experimental support for vendoring,
enabled by setting the <code>GO15VENDOREXPERIMENT</code> environment variable to <code>1</code>.
Go 1.6 keeps the vendoring support, no longer considered experimental,
and enables it by default.
It can be disabled explicitly by setting
the <code>GO15VENDOREXPERIMENT</code> environment variable to <code>0</code>.
Go 1.7 will remove support for the environment variable.
</p>

<p>
The most likely problem caused by enabling vendoring by default happens
in source trees containing an existing directory named <code>vendor</code> that
does not expect to be interpreted according to new vendoring semantics.
In this case, the simplest fix is to rename the directory to anything other
than <code>vendor</code> and update any affected import paths.
</p>

<p>
For details about vendoring,
see the documentation for the <a href="/cmd/go/#hdr-Vendor_Directories"><code>go</code> command</a>
and the <a href="https://golang.org/s/go15vendor">design document</a>.
</p>

<p>
There is a new build flag, <code>-msan</code>,
that compiles Go with support for the LLVM memory sanitizer.
This is intended mainly for use when linking against C or C++ code
that is being checked with the memory sanitizer.
</p>

<h3 id="doc_command">Go doc command</h3>

<p>
Go 1.5 introduced the
<a href="/cmd/go/#hdr-Show_documentation_for_package_or_symbol"><code>go doc</code></a> command,
which allows references to packages using only the package name, as in
<code>go</code> <code>doc</code> <code>http</code>.
In the event of ambiguity, the Go 1.5 behavior was to use the package
with the lexicographically earliest import path.
In Go 1.6, ambiguity is resolved by preferring import paths with
fewer elements, breaking ties using lexicographic comparison.
An important effect of this change is that original copies of packages
are now preferred over vendored copies.
Successful searches also tend to run faster.
</p>

<h3 id="vet_command">Go vet command</h3>

<p>
The <a href="/cmd/vet"><code>go vet</code></a> command now diagnoses
passing function or method values as arguments to <code>Printf</code>,
such as when passing <code>f</code> where <code>f()</code> was intended.
</p>

<h2 id="performance">Performance</h2>

<p>
As always, the changes are so general and varied that precise statements
about performance are difficult to make.
Some programs may run faster, some slower.
On average the programs in the Go 1 benchmark suite run a few percent faster in Go 1.6
than they did in Go 1.5.
The garbage collector's pauses are even lower than in Go 1.5,
especially for programs using
a large amount of memory.
</p>

<p>
There have been significant optimizations bringing more than 10% improvements
to implementations of the
<a href="/pkg/compress/bzip2/"><code>compress/bzip2</code></a>,
<a href="/pkg/compress/gzip/"><code>compress/gzip</code></a>,
<a href="/pkg/crypto/aes/"><code>crypto/aes</code></a>,
<a href="/pkg/crypto/elliptic/"><code>crypto/elliptic</code></a>,
<a href="/pkg/crypto/ecdsa/"><code>crypto/ecdsa</code></a>, and
<a href="/pkg/sort/"><code>sort</code></a> packages.
</p>

<h2 id="library">Core library</h2>

<h3 id="http2">HTTP/2</h3>

<p>
Go 1.6 adds transparent support in the
<a href="/pkg/net/http/"><code>net/http</code></a> package
for the new <a href="https://http2.github.io/">HTTP/2 protocol</a>.
Go clients and servers will automatically use HTTP/2 as appropriate when using HTTPS.
There is no exported API specific to details of the HTTP/2 protocol handling,
just as there is no exported API specific to HTTP/1.1.
</p>

<p>
Programs that must disable HTTP/2 can do so by setting
<a href="/pkg/net/http/#Transport"><code>Transport.TLSNextProto</code></a> (for clients)
or
<a href="/pkg/net/http/#Server"><code>Server.TLSNextProto</code></a> (for servers)
to a non-nil, empty map.
</p>

<p>
Programs that must adjust HTTP/2 protocol-specific details can import and use
<a href="https://golang.org/x/net/http2"><code>golang.org/x/net/http2</code></a>,
in particular its
<a href="https://godoc.org/golang.org/x/net/http2/#ConfigureServer">ConfigureServer</a>
and
<a href="https://godoc.org/golang.org/x/net/http2/#ConfigureTransport">ConfigureTransport</a>
functions.
</p>

<h3 id="runtime">Runtime</h3>

<p>
The runtime has added lightweight, best-effort detection of concurrent misuse of maps.
As always, if one goroutine is writing to a map, no other goroutine should be
reading or writing the map concurrently.
If the runtime detects this condition, it prints a diagnosis and crashes the program.
The best way to find out more about the problem is to run the program
under the
<a href="https://blog.golang.org/race-detector">race detector</a>,
which will more reliably identify the race
and give more detail.
</p>

<p>
For program-ending panics, the runtime now by default
prints only the stack of the running goroutine,
not all existing goroutines.
Usually only the current goroutine is relevant to a panic,
so omitting the others significantly reduces irrelevant output
in a crash message.
To see the stacks from all goroutines in crash messages, set the environment variable
<code>GOTRACEBACK</code> to <code>all</code>
or call
<a href="/pkg/runtime/debug/#SetTraceback"><code>debug.SetTraceback</code></a>
before the crash, and rerun the program.
See the <a href="/pkg/runtime/#hdr-Environment_Variables">runtime documentation</a> for details.
</p>

<p>
<em>Updating</em>:
Uncaught panics intended to dump the state of the entire program,
such as when a timeout is detected or when explicitly handling a received signal,
should now call <code>debug.SetTraceback("all")</code> before panicking.
Searching for uses of
<a href="/pkg/os/signal/#Notify"><code>signal.Notify</code></a> may help identify such code.
</p>

<p>
On Windows, Go programs in Go 1.5 and earlier forced
the global Windows timer resolution to 1ms at startup
by calling <code>timeBeginPeriod(1)</code>.
Go no longer needs this for good scheduler performance,
and changing the global timer resolution caused problems on some systems,
so the call has been removed.
</p>

<p>
When using <code>-buildmode=c-archive</code> or
<code>-buildmode=c-shared</code> to build an archive or a shared
library, the handling of signals has changed.
In Go 1.5 the archive or shared library would install a signal handler
for most signals.
In Go 1.6 it will only install a signal handler for the
synchronous signals needed to handle run-time panics in Go code:
SIGBUS, SIGFPE, SIGSEGV.
See the <a href="/pkg/os/signal">os/signal</a> package for more
details.
</p>

<h3 id="reflect">Reflect</h3>

<p>
The
<a href="/pkg/reflect/"><code>reflect</code></a> package has
<a href="https://golang.org/issue/12367">resolved a long-standing incompatibility</a>
between the gc and gccgo toolchains
regarding embedded unexported struct types containing exported fields.
Code that walks data structures using reflection, especially to implement
serialization in the spirit
of the
<a href="/pkg/encoding/json/"><code>encoding/json</code></a> and
<a href="/pkg/encoding/xml/"><code>encoding/xml</code></a> packages,
may need to be updated.
</p>

<p>
The problem arises when using reflection to walk through
an embedded unexported struct-typed field
into an exported field of that struct.
In this case, <code>reflect</code> had incorrectly reported
the embedded field as exported, by returning an empty <code>Field.PkgPath</code>.
Now it correctly reports the field as unexported
but ignores that fact when evaluating access to exported fields
contained within the struct.
</p>

<p>
<em>Updating</em>:
Typically, code that previously walked over structs and used
</p>

<pre>
f.PkgPath != ""
</pre>

<p>
to exclude inaccessible fields
should now use
</p>

<pre>
f.PkgPath != "" &amp;&amp; !f.Anonymous
</pre>

<p>
For example, see the changes to the implementations of
<a href="https://go-review.googlesource.com/#/c/14011/2/src/encoding/json/encode.go"><code>encoding/json</code></a> and
<a href="https://go-review.googlesource.com/#/c/14012/2/src/encoding/xml/typeinfo.go"><code>encoding/xml</code></a>.
</p>

<h3 id="sort">Sorting</h3>

<p>
In the
<a href="/pkg/sort/"><code>sort</code></a>
package,
the implementation of
<a href="/pkg/sort/#Sort"><code>Sort</code></a>
has been rewritten to make about 10% fewer calls to the
<a href="/pkg/sort/#Interface"><code>Interface</code></a>'s
<code>Less</code> and <code>Swap</code>
methods, with a corresponding overall time savings.
The new algorithm does choose a different ordering than before
for values that compare equal (those pairs for which <code>Less(i,</code> <code>j)</code> and <code>Less(j,</code> <code>i)</code> are false).
</p>

<p>
<em>Updating</em>:
The definition of <code>Sort</code> makes no guarantee about the final order of equal values,
but the new behavior may still break programs that expect a specific order.
Such programs should either refine their <code>Less</code> implementations
to report the desired order
or should switch to
<a href="/pkg/sort/#Stable"><code>Stable</code></a>,
which preserves the original input order
of equal values.
</p>

<h3 id="template">Templates</h3>

<p>
In the
<a href="/pkg/text/template/">text/template</a> package,
there are two significant new features to make writing templates easier.
</p>

<p>
First, it is now possible to <a href="/pkg/text/template/#hdr-Text_and_spaces">trim spaces around template actions</a>,
which can make template definitions more readable.
A minus sign at the beginning of an action says to trim space before the action,
and a minus sign at the end of an action says to trim space after the action.
For example, the template
</p>

<pre>
{{"{{"}}23 -}}
   &lt;
{{"{{"}}- 45}}
</pre>

<p>
formats as <code>23&lt;45</code>.
</p>

<p>
Second, the new <a href="/pkg/text/template/#hdr-Actions"><code>{{"{{"}}block}}</code> action</a>,
combined with allowing redefinition of named templates,
provides a simple way to define pieces of a template that
can be replaced in different instantiations.
There is <a href="/pkg/text/template/#example_Template_block">an example</a>
in the <code>text/template</code> package that demonstrates this new feature.
</p>

<h3 id="minor_library_changes">Minor changes to the library</h3>

<ul>

<li>
The <a href="/pkg/archive/tar/"><code>archive/tar</code></a> package's
implementation corrects many bugs in rare corner cases of the file format.
One visible change is that the
<a href="/pkg/archive/tar/#Reader"><code>Reader</code></a> type's
<a href="/pkg/archive/tar/#Reader.Read"><code>Read</code></a> method
now presents the content of special file types as being empty,
returning <code>io.EOF</code> immediately.
</li>

<li>
In the <a href="/pkg/archive/zip/"><code>archive/zip</code></a> package, the
<a href="/pkg/archive/zip/#Reader"><code>Reader</code></a> type now has a
<a href="/pkg/archive/zip/#Reader.RegisterDecompressor"><code>RegisterDecompressor</code></a> method,
and the
<a href="/pkg/archive/zip/#Writer"><code>Writer</code></a> type now has a
<a href="/pkg/archive/zip/#Writer.RegisterCompressor"><code>RegisterCompressor</code></a> method,
enabling control over compression options for individual zip files.
These take precedence over the pre-existing global
<a href="/pkg/archive/zip/#RegisterDecompressor"><code>RegisterDecompressor</code></a> and
<a href="/pkg/archive/zip/#RegisterCompressor"><code>RegisterCompressor</code></a> functions.
</li>

<li>
The <a href="/pkg/bufio/"><code>bufio</code></a> package's
<a href="/pkg/bufio/#Scanner"><code>Scanner</code></a> type now has a
<a href="/pkg/bufio/#Scanner.Buffer"><code>Buffer</code></a> method,
to specify an initial buffer and maximum buffer size to use during scanning.
This makes it possible, when needed, to scan tokens larger than
<code>MaxScanTokenSize</code>.
Also for the <code>Scanner</code>, the package now defines the
<a href="/pkg/bufio/#ErrFinalToken"><code>ErrFinalToken</code></a> error value, for use by
<a href="/pkg/bufio/#SplitFunc">split functions</a> to abort processing or to return a final empty token.
</li>

<li>
The <a href="/pkg/compress/flate/"><code>compress/flate</code></a> package
has deprecated its
<a href="/pkg/compress/flate/#ReadError"><code>ReadError</code></a> and
<a href="/pkg/compress/flate/#WriteError"><code>WriteError</code></a> error implementations.
In Go 1.5 they were only rarely returned when an error was encountered;
now they are never returned, although they remain defined for compatibility.
</li>

<li>
The <a href="/pkg/compress/flate/"><code>compress/flate</code></a>,
<a href="/pkg/compress/gzip/"><code>compress/gzip</code></a>, and
<a href="/pkg/compress/zlib/"><code>compress/zlib</code></a> packages
now report
<a href="/pkg/io/#ErrUnexpectedEOF"><code>io.ErrUnexpectedEOF</code></a> for truncated input streams, instead of
<a href="/pkg/io/#EOF"><code>io.EOF</code></a>.
</li>

<li>
The <a href="/pkg/crypto/cipher/"><code>crypto/cipher</code></a> package now
overwrites the destination buffer in the event of a GCM decryption failure.
This is to allow the AESNI code to avoid using a temporary buffer.
</li>

<li>
The <a href="/pkg/crypto/tls/"><code>crypto/tls</code></a> package
has a variety of minor changes.
It now allows
<a href="/pkg/crypto/tls/#Listen"><code>Listen</code></a>
to succeed when the
<a href="/pkg/crypto/tls/#Config"><code>Config</code></a>
has a nil <code>Certificates</code>, as long as the <code>GetCertificate</code> callback is set,
it adds support for RSA with AES-GCM cipher suites,
and
it adds a
<a href="/pkg/crypto/tls/#RecordHeaderError"><code>RecordHeaderError</code></a>
to allow clients (in particular, the <a href="/pkg/net/http/"><code>net/http</code></a> package)
to report a better error when attempting a TLS connection to a non-TLS server.
</li>

<li>
The <a href="/pkg/crypto/x509/"><code>crypto/x509</code></a> package
now permits certificates to contain negative serial numbers
(technically an error, but unfortunately common in practice),
and it defines a new
<a href="/pkg/crypto/x509/#InsecureAlgorithmError"><code>InsecureAlgorithmError</code></a>
to give a better error message when rejecting a certificate
signed with an insecure algorithm like MD5.
</li>

<li>
The <a href="/pkg/debug/dwarf"><code>debug/dwarf</code></a> and
<a href="/pkg/debug/elf/"><code>debug/elf</code></a> packages
together add support for compressed DWARF sections.
User code needs no updating: the sections are decompressed automatically when read.
</li>

<li>
The <a href="/pkg/debug/elf/"><code>debug/elf</code></a> package
adds support for general compressed ELF sections.
User code needs no updating: the sections are decompressed automatically when read.
However, compressed
<a href="/pkg/debug/elf/#Section"><code>Sections</code></a> do not support random access:
they have a nil <code>ReaderAt</code> field.
</li>

<li>
The <a href="/pkg/encoding/asn1/"><code>encoding/asn1</code></a> package
now exports
<a href="/pkg/encoding/asn1/#pkg-constants">tag and class constants</a>
useful for advanced parsing of ASN.1 structures.
</li>

<li>
Also in the <a href="/pkg/encoding/asn1/"><code>encoding/asn1</code></a> package,
<a href="/pkg/encoding/asn1/#Unmarshal"><code>Unmarshal</code></a> now rejects various non-standard integer and length encodings.
</li>

<li>
The <a href="/pkg/encoding/base64"><code>encoding/base64</code></a> package's
<a href="/pkg/encoding/base64/#Decoder"><code>Decoder</code></a> has been fixed
to process the final bytes of its input. Previously it processed as many four-byte tokens as
possible but ignored the remainder, up to three bytes.
The <code>Decoder</code> therefore now handles inputs in unpadded encodings (like
<a href="/pkg/encoding/base64/#RawURLEncoding">RawURLEncoding</a>) correctly,
but it also rejects inputs in padded encodings that are truncated or end with invalid bytes,
such as trailing spaces.
</li>

<li>
The <a href="/pkg/encoding/json/"><code>encoding/json</code></a> package
now checks the syntax of a
<a href="/pkg/encoding/json/#Number"><code>Number</code></a>
before marshaling it, requiring that it conforms to the JSON specification for numeric values.
As in previous releases, the zero <code>Number</code> (an empty string) is marshaled as a literal 0 (zero).
</li>

<li>
The <a href="/pkg/encoding/xml/"><code>encoding/xml</code></a> package's
<a href="/pkg/encoding/xml/#Marshal"><code>Marshal</code></a>
function now supports a <code>cdata</code> attribute, such as <code>chardata</code>
but encoding its argument in one or more <code>&lt;![CDATA[ ... ]]&gt;</code> tags.
</li>

<li>
Also in the <a href="/pkg/encoding/xml/"><code>encoding/xml</code></a> package,
<a href="/pkg/encoding/xml/#Decoder"><code>Decoder</code></a>'s
<a href="/pkg/encoding/xml/#Decoder.Token"><code>Token</code></a> method
now reports an error when encountering EOF before seeing all open tags closed,
consistent with its general requirement that tags in the input be properly matched.
To avoid that requirement, use
<a href="/pkg/encoding/xml/#Decoder.RawToken"><code>RawToken</code></a>.
</li>

<li>
The <a href="/pkg/fmt/"><code>fmt</code></a> package now allows
any integer type as an argument to
<a href="/pkg/fmt/#Printf"><code>Printf</code></a>'s <code>*</code> width and precision specification.
In previous releases, the argument to <code>*</code> was required to have type <code>int</code>.
</li>

<li>
Also in the <a href="/pkg/fmt/"><code>fmt</code></a> package,
<a href="/pkg/fmt/#Scanf"><code>Scanf</code></a> can now scan hexadecimal strings using %X, as an alias for %x.
Both formats accept any mix of upper- and lower-case hexadecimal.
</li>

<li>
The <a href="/pkg/image/"><code>image</code></a>
and
<a href="/pkg/image/color/"><code>image/color</code></a> packages
add
<a href="/pkg/image/#NYCbCrA"><code>NYCbCrA</code></a>
and
<a href="/pkg/image/color/#NYCbCrA"><code>NYCbCrA</code></a>
types, to support Y'CbCr images with non-premultiplied alpha.
</li>

<li>
The <a href="/pkg/io/"><code>io</code></a> package's
<a href="/pkg/io/#MultiWriter"><code>MultiWriter</code></a>
implementation now implements a <code>WriteString</code> method,
for use by
<a href="/pkg/io/#WriteString"><code>WriteString</code></a>.
</li>

<li>
In the <a href="/pkg/math/big/"><code>math/big</code></a> package,
<a href="/pkg/math/big/#Int"><code>Int</code></a> adds
<a href="/pkg/math/big/#Int.Append"><code>Append</code></a>
and
<a href="/pkg/math/big/#Int.Text"><code>Text</code></a>
methods to give more control over printing.
</li>

<li>
Also in the <a href="/pkg/math/big/"><code>math/big</code></a> package,
<a href="/pkg/math/big/#Float"><code>Float</code></a> now implements
<a href="/pkg/encoding/#TextMarshaler"><code>encoding.TextMarshaler</code></a> and
<a href="/pkg/encoding/#TextUnmarshaler"><code>encoding.TextUnmarshaler</code></a>,
allowing it to be serialized in a natural form by the
<a href="/pkg/encoding/json/"><code>encoding/json</code></a> and
<a href="/pkg/encoding/xml/"><code>encoding/xml</code></a> packages.
</li>

<li>
Also in the <a href="/pkg/math/big/"><code>math/big</code></a> package,
<a href="/pkg/math/big/#Float"><code>Float</code></a>'s
<a href="/pkg/math/big/#Float.Append"><code>Append</code></a> method now supports the special precision argument -1.
As in
<a href="/pkg/strconv/#ParseFloat"><code>strconv.ParseFloat</code></a>,
precision -1 means to use the smallest number of digits necessary such that
<a href="/pkg/math/big/#Float.Parse"><code>Parse</code></a>
reading the result into a <code>Float</code> of the same precision
will yield the original value.
</li>

<li>
The <a href="/pkg/math/rand/"><code>math/rand</code></a> package
adds a
<a href="/pkg/math/rand/#Read"><code>Read</code></a>
function, and likewise
<a href="/pkg/math/rand/#Rand"><code>Rand</code></a> adds a
<a href="/pkg/math/rand/#Rand.Read"><code>Read</code></a> method.
These make it easier to generate pseudorandom test data.
Note that, like the rest of the package,
these should not be used in cryptographic settings;
for such purposes, use the <a href="/pkg/crypto/rand/"><code>crypto/rand</code></a> package instead.
</li>

<li>
The <a href="/pkg/net/"><code>net</code></a> package's
<a href="/pkg/net/#ParseMAC"><code>ParseMAC</code></a> function now accepts 20-byte IP-over-InfiniBand (IPoIB) link-layer addresses.
</li>


<li>
Also in the <a href="/pkg/net/"><code>net</code></a> package,
there have been a few changes to DNS lookups.
First, the
<a href="/pkg/net/#DNSError"><code>DNSError</code></a> error implementation now implements
<a href="/pkg/net/#Error"><code>Error</code></a>,
and in particular its new
<a href="/pkg/net/#DNSError.IsTemporary"><code>IsTemporary</code></a>
method returns true for DNS server errors.
Second, DNS lookup functions such as
<a href="/pkg/net/#LookupAddr"><code>LookupAddr</code></a>
now return rooted domain names (with a trailing dot)
on Plan 9 and Windows, to match the behavior of Go on Unix systems.
</li>

<li>
The <a href="/pkg/net/http/"><code>net/http</code></a> package has
a number of minor additions beyond the HTTP/2 support already discussed.
First, the
<a href="/pkg/net/http/#FileServer"><code>FileServer</code></a> now sorts its generated directory listings by file name.
Second, the
<a href="/pkg/net/http/#ServeFile"><code>ServeFile</code></a> function now refuses to serve a result
if the request's URL path contains &ldquo;..&rdquo; (dot-dot) as a path element.
Programs should typically use <code>FileServer</code> and 
<a href="/pkg/net/http/#Dir"><code>Dir</code></a>
instead of calling <code>ServeFile</code> directly.
Programs that need to serve file content in response to requests for URLs containing dot-dot can 
still call <a href="/pkg/net/http/#ServeContent"><code>ServeContent</code></a>.
Third, the
<a href="/pkg/net/http/#Client"><code>Client</code></a> now allows user code to set the
<code>Expect:</code> <code>100-continue</code> header (see
<a href="/pkg/net/http/#Transport"><code>Transport.ExpectContinueTimeout</code></a>).
Fourth, there are
<a href="/pkg/net/http/#pkg-constants">five new error codes</a>:
<code>StatusPreconditionRequired</code> (428),
<code>StatusTooManyRequests</code> (429),
<code>StatusRequestHeaderFieldsTooLarge</code> (431), and
<code>StatusNetworkAuthenticationRequired</code> (511) from RFC 6585,
as well as the recently-approved
<code>StatusUnavailableForLegalReasons</code> (451).
Fifth, the implementation and documentation of
<a href="/pkg/net/http/#CloseNotifier"><code>CloseNotifier</code></a>
has been substantially changed.
The <a href="/pkg/net/http/#Hijacker"><code>Hijacker</code></a>
interface now works correctly on connections that have previously
been used with <code>CloseNotifier</code>.
The documentation now describes when <code>CloseNotifier</code>
is expected to work.
</li>

<li>
Also in the <a href="/pkg/net/http/"><code>net/http</code></a> package,
there are a few changes related to the handling of a
<a href="/pkg/net/http/#Request"><code>Request</code></a> data structure with its <code>Method</code> field set to the empty string.
An empty <code>Method</code> field has always been documented as an alias for <code>"GET"</code>
and it remains so.
However, Go 1.6 fixes a few routines that did not treat an empty
<code>Method</code> the same as an explicit <code>"GET"</code>.
Most notably, in previous releases
<a href="/pkg/net/http/#Client"><code>Client</code></a> followed redirects only with
<code>Method</code> set explicitly to <code>"GET"</code>;
in Go 1.6 <code>Client</code> also follows redirects for the empty <code>Method</code>.
Finally,
<a href="/pkg/net/http/#NewRequest"><code>NewRequest</code></a> accepts a <code>method</code> argument that has not been
documented as allowed to be empty.
In past releases, passing an empty <code>method</code> argument resulted
in a <code>Request</code> with an empty <code>Method</code> field.
In Go 1.6, the resulting <code>Request</code> always has an initialized
<code>Method</code> field: if its argument is an empty string, <code>NewRequest</code>
sets the <code>Method</code> field in the returned <code>Request</code> to <code>"GET"</code>.
</li>

<li>
The <a href="/pkg/net/http/httptest/"><code>net/http/httptest</code></a> package's
<a href="/pkg/net/http/httptest/#ResponseRecorder"><code>ResponseRecorder</code></a> now initializes a default Content-Type header
using the same content-sniffing algorithm as in
<a href="/pkg/net/http/#Server"><code>http.Server</code></a>.
</li>

<li>
The <a href="/pkg/net/url/"><code>net/url</code></a> package's
<a href="/pkg/net/url/#Parse"><code>Parse</code></a> is now stricter and more spec-compliant regarding the parsing
of host names.
For example, spaces in the host name are no longer accepted.
</li>

<li>
Also in the <a href="/pkg/net/url/"><code>net/url</code></a> package,
the <a href="/pkg/net/url/#Error"><code>Error</code></a> type now implements
<a href="/pkg/net/#Error"><code>net.Error</code></a>.
</li>

<li>
The <a href="/pkg/os/"><code>os</code></a> package's
<a href="/pkg/os/#IsExist"><code>IsExist</code></a>,
<a href="/pkg/os/#IsNotExist"><code>IsNotExist</code></a>,
and
<a href="/pkg/os/#IsPermission"><code>IsPermission</code></a>
now return correct results when inquiring about an
<a href="/pkg/os/#SyscallError"><code>SyscallError</code></a>.
</li>

<li>
On Unix-like systems, when a write
to <a href="/pkg/os/#pkg-variables"><code>os.Stdout</code>
or <code>os.Stderr</code></a> (more precisely, an <code>os.File</code>
opened for file descriptor 1 or 2) fails due to a broken pipe error,
the program will raise a <code>SIGPIPE</code> signal.
By default this will cause the program to exit; this may be changed by
calling the
<a href="/pkg/os/signal"><code>os/signal</code></a>
<a href="/pkg/os/signal/#Notify"><code>Notify</code></a> function
for <code>syscall.SIGPIPE</code>.
A write to a broken pipe on a file descriptor other 1 or 2 will simply
return <code>syscall.EPIPE</code> (possibly wrapped in
<a href="/pkg/os#PathError"><code>os.PathError</code></a>
and/or <a href="/pkg/os#SyscallError"><code>os.SyscallError</code></a>)
to the caller.
The old behavior of raising an uncatchable <code>SIGPIPE</code> signal
after 10 consecutive writes to a broken pipe no longer occurs.
</li>

<li>
In the <a href="/pkg/os/exec/"><code>os/exec</code></a> package,
<a href="/pkg/os/exec/#Cmd"><code>Cmd</code></a>'s
<a href="/pkg/os/exec/#Cmd.Output"><code>Output</code></a> method continues to return an
<a href="/pkg/os/exec/#ExitError"><code>ExitError</code></a> when a command exits with an unsuccessful status.
If standard error would otherwise have been discarded,
the returned <code>ExitError</code> now holds a prefix and suffix
(currently 32 kB) of the failed command's standard error output,
for debugging or for inclusion in error messages.
The <code>ExitError</code>'s
<a href="/pkg/os/exec/#ExitError.String"><code>String</code></a>
method does not show the captured standard error;
programs must retrieve it from the data structure
separately.
</li>

<li>
On Windows, the <a href="/pkg/path/filepath/"><code>path/filepath</code></a> package's
<a href="/pkg/path/filepath/#Join"><code>Join</code></a> function now correctly handles the case when the base is a relative drive path.
For example, <code>Join(`c:`,</code> <code>`a`)</code> now
returns <code>`c:a`</code> instead of <code>`c:\a`</code> as in past releases.
This may affect code that expects the incorrect result.
</li>

<li>
In the <a href="/pkg/regexp/"><code>regexp</code></a> package,
the
<a href="/pkg/regexp/#Regexp"><code>Regexp</code></a> type has always been safe for use by
concurrent goroutines.
It uses a <a href="/pkg/sync/#Mutex"><code>sync.Mutex</code></a> to protect
a cache of scratch spaces used during regular expression searches.
Some high-concurrency servers using the same <code>Regexp</code> from many goroutines
have seen degraded performance due to contention on that mutex.
To help such servers, <code>Regexp</code> now has a
<a href="/pkg/regexp/#Regexp.Copy"><code>Copy</code></a> method,
which makes a copy of a <code>Regexp</code> that shares most of the structure
of the original but has its own scratch space cache.
Two goroutines can use different copies of a <code>Regexp</code>
without mutex contention.
A copy does have additional space overhead, so <code>Copy</code>
should only be used when contention has been observed.
</li>

<li>
The <a href="/pkg/strconv/"><code>strconv</code></a> package adds
<a href="/pkg/strconv/#IsGraphic"><code>IsGraphic</code></a>,
similar to <a href="/pkg/strconv/#IsPrint"><code>IsPrint</code></a>.
It also adds
<a href="/pkg/strconv/#QuoteToGraphic"><code>QuoteToGraphic</code></a>,
<a href="/pkg/strconv/#QuoteRuneToGraphic"><code>QuoteRuneToGraphic</code></a>,
<a href="/pkg/strconv/#AppendQuoteToGraphic"><code>AppendQuoteToGraphic</code></a>,
and
<a href="/pkg/strconv/#AppendQuoteRuneToGraphic"><code>AppendQuoteRuneToGraphic</code></a>,
analogous to
<a href="/pkg/strconv/#QuoteToASCII"><code>QuoteToASCII</code></a>,
<a href="/pkg/strconv/#QuoteRuneToASCII"><code>QuoteRuneToASCII</code></a>,
and so on.
The <code>ASCII</code> family escapes all space characters except ASCII space (U+0020).
In contrast, the <code>Graphic</code> family does not escape any Unicode space characters (category Zs).
</li>

<li>
In the <a href="/pkg/testing/"><code>testing</code></a> package,
when a test calls
<a href="/pkg/testing/#T.Parallel">t.Parallel</a>,
that test is paused until all non-parallel tests complete, and then
that test continues execution with all other parallel tests.
Go 1.6 changes the time reported for such a test:
previously the time counted only the parallel execution,
but now it also counts the time from the start of testing
until the call to <code>t.Parallel</code>.
</li>

<li>
The <a href="/pkg/text/template/"><code>text/template</code></a> package
contains two minor changes, in addition to the <a href="#template">major changes</a>
described above.
First, it adds a new
<a href="/pkg/text/template/#ExecError"><code>ExecError</code></a> type
returned for any error during
<a href="/pkg/text/template/#Template.Execute"><code>Execute</code></a>
that does not originate in a <code>Write</code> to the underlying writer.
Callers can distinguish template usage errors from I/O errors by checking for
<code>ExecError</code>.
Second, the
<a href="/pkg/text/template/#Template.Funcs"><code>Funcs</code></a> method
now checks that the names used as keys in the
<a href="/pkg/text/template/#FuncMap"><code>FuncMap</code></a>
are identifiers that can appear in a template function invocation.
If not, <code>Funcs</code> panics.
</li>

<li>
The <a href="/pkg/time/"><code>time</code></a> package's
<a href="/pkg/time/#Parse"><code>Parse</code></a> function has always rejected any day of month larger than 31,
such as January 32.
In Go 1.6, <code>Parse</code> now also rejects February 29 in non-leap years,
February 30, February 31, April 31, June 31, September 31, and November 31.
</li>

</ul>

                                                                                                                                                                                                                                                                                                           usr/local/go/doc/go1.html                                                                           0100644 0000000 0000000 00000213474 13020111411 013671  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
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
Character literals such as <code>'a'</code>, <code>'èªž'</code>, and <code>'\u0345'</code>
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
<tr><td>Atof32(x)</td> <td>ParseFloat(x, 32)Â§</td></tr>
<tr><td>Atof64(x)</td> <td>ParseFloat(x, 64)</td></tr>
<tr><td>AtofN(x, n)</td> <td>ParseFloat(x, n)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Atoi(x)</td> <td>Atoi(x)</td></tr>
<tr><td>Atoi(x)</td> <td>ParseInt(x, 10, 0)Â§</td></tr>
<tr><td>Atoi64(x)</td> <td>ParseInt(x, 10, 64)</td></tr>
<tr>
<td colspan="2"><hr></td>
</tr>
<tr><td>Atoui(x)</td> <td>ParseUint(x, 10, 0)Â§</td></tr>
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
Â§ <code>Atoi</code> persists but <code>Atoui</code> and <code>Atof32</code> do not, so
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
                                                                                                                                                                                                    usr/local/go/doc/go1compat.html                                                                     0100644 0000000 0000000 00000016062 13020111411 015067  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
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
Methods. As with struct fields, it may be necessary to add methods
to types.
Under some circumstances, such as when the type is embedded in
a struct along with another type,
the addition of the new method may break
the struct by creating a conflict with an existing method of the other
embedded type.
We cannot protect against this rare case and do not guarantee compatibility
should it arise.
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                              usr/local/go/doc/go_faq.html                                                                        0100644 0000000 0000000 00000220154 13020111411 014430  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
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

<h3 id="Whats_the_origin_of_the_mascot">
What's the origin of the mascot?</h3>

<p>
The mascot and logo were designed by
<a href="http://reneefrench.blogspot.com">RenÃ©e French</a>, who also designed
<a href="https://9p.io/plan9/glenda.html">Glenda</a>,
the Plan 9 bunny.
The <a href="https://blog.golang.org/gopher">gopher</a>
is derived from one she used for an <a href="http://wfmu.org/">WFMU</a>
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
computing.  Finally, working with Go is intended to be <i>fast</i>: it should take
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
Other examples include the <a href="//github.com/youtube/vitess/">Vitess</a>
system for large-scale SQL installations and Google's download server, <code>dl.google.com</code>,
which delivers Chrome binaries and other large installables such as <code>apt-get</code>
packages.
</p>

<h3 id="Do_Go_programs_link_with_Cpp_programs">
Do Go programs link with C/C++ programs?</h3>

<p>
There are two Go compiler implementations, <code>gc</code>
and <code>gccgo</code>.
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
<a href="//github.com/golang/protobuf">github.com/golang/protobuf/</a>
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
only solution is to use something like <code>Xæ—¥æœ¬èªž</code>, which
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
This remains an open issue. See <a href="https://golang.org/issue/15292">the generics proposal issue</a>
for more information.
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
People often suggest improvements to the languageâ€”the
<a href="//groups.google.com/group/golang-nuts">mailing list</a>
contains a rich history of such discussionsâ€”but very few of these changes have
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
Also, the lack of a type hierarchy makes &ldquo;objects&rdquo; in Go feel much more
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
interface <code>I</code> by attempting an assignment using the zero value for
<code>T</code> or pointer to <code>T</code>, as appropriate:
</p>

<pre>
type T struct{}
var _ I = T{}       // Verify that T implements I.
var _ I = (*T)(nil) // Verify that *T implements I.
</pre>

<p>
If <code>T</code> (or <code>*T</code>, accordingly) doesn't implement
<code>I</code>, the mistake will be caught at compile time.
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
automatic type promotion. Should Go one day adopt some form of polymorphic
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
If we store a <code>nil</code> pointer of type <code>*int</code> inside
an interface value, the inner type will be <code>*int</code> regardless of the value of the pointer:
(<code>*int</code>, <code>nil</code>).
Such an interface value will therefore be non-<code>nil</code>
<em>even when the pointer inside is</em> <code>nil</code>.
</p>

<p>
This situation can be confusing, and arises when a <code>nil</code> value is
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

<h3 id="covariant_types">
Why does Go not have covariant result types?</h3>

<p>
Covariant result types would mean that an interface like

<pre>
type Copyable interface {
	Copy() interface{}
}
</pre>

would be satisfied by the method

<pre>
func (v Value) Copy() Value
</pre>

because <code>Value</code> implements the empty interface.
In Go method types must match exactly, so <code>Value</code> does not
implement <code>Copyable</code>.
Go separates the notion of what a
type does&mdash;its methods&mdash;from the type's implementation.
If two methods return different types, they are not doing the same thing.
Programmers who want covariant result types are often trying to
express a type hierarchy through interfaces.
In Go it's more natural to have a clean separation between interface
and implementation.
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
A blog post titled <a href="https://blog.golang.org/constants">Constants</a>
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

<p>
A <code>godoc</code> instance may be configured to provide rich,
interactive static analyses of symbols in the programs it displays; details are
listed <a href="https://golang.org/lib/godoc/analysis/help.html">here</a>.
</p>

<p>
For access to documentation from the command line, the
<a href="https://golang.org/pkg/cmd/go/">go</a> tool has a
<a href="https://golang.org/pkg/cmd/go/#hdr-Show_documentation_for_package_or_symbol">doc</a>
subcommand that provides a textual interface to the same information.
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
The <a href="https://godoc.org/golang.org/x/tools/cmd/gomvpkg">gomvpkg</a>
program is one tool to help automate this process.
</p>

<p>
The Go 1.5 release includes an experimental facility to the
<a href="https://golang.org/cmd/go">go</a> command
that makes it easier to manage external dependencies by "vendoring"
them into a special directory near the package that depends upon them.
See the <a href="https://golang.org/s/go15vendor">design
document</a> for details.
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
(See a <a href="/doc/faq#methods_on_values_or_pointers">later
section</a> for a discussion of how this affects method receivers.)
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
a value that satisfies <code>io.Writer</code>â€”something that implements
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
The number of CPUs available simultaneously to executing goroutines is
controlled by the <code>GOMAXPROCS</code> shell environment variable.
In earlier releases of Go, the default value was 1, but as of Go 1.5 the default
value is the number of cores available.
Therefore programs compiled after 1.5 should demonstrate parallel execution
of multiple goroutines.
To change the behavior, set the environment variable or use the similarly-named
<a href="/pkg/runtime/#GOMAXPROCS">function</a>
of the runtime package to configure the
run-time support to utilize a different number of threads.
</p>

<p>
Programs that perform parallel computation might benefit from a further increase in
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
may experience performance degradation when using
multiple OS threads.
This is because sending data between threads involves switching
contexts, which has significant cost.
For instance, the <a href="/ref/spec#An_example_package">prime sieve example</a>
from the Go specification has no significant parallelism although it launches many
goroutines; increasing <code>GOMAXPROCS</code> is more likely to slow it down than
to speed it up.
</p>

<p>
Go's goroutine scheduler is not as good as it needs to be, although it
has improved in recent releases.
In the future, it may better optimize its use of OS threads.
For now, if there are performance issues,
setting <code>GOMAXPROCS</code> on a per-application basis may help.
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
As an example, if the <code>Write</code> method of
<a href="/pkg/bytes/#Buffer"><code>bytes.Buffer</code></a>
used a value receiver rather than a pointer,
this code:
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
There is no ternary testing operation in Go. You may use the following to achieve the same
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

<h3 id="x_in_std">
Why isn't <i>X</i> in the standard library?</h3>

<p>
The standard library's purpose is to support the runtime, connect to
the operating system, and provide key functionality that many Go
programs require, such as formatted I/O and networking.
It also contains elements important for web programming, including
cryptography and support for standards like HTTP, JSON, and XML.
</p>

<p>
There is no clear criterion that defines what is included because for
a long time, this was the <i>only</i> Go library.
There are criteria that define what gets added today, however.
</p>

<p>
New additions to the standard library are rare and the bar for
inclusion is high.
Code included in the standard library bears a large ongoing maintenance cost
(often borne by those other than the original author),
is subject to the <a href="/doc/go1compat.html">Go 1 compatibility promise</a>
(blocking fixes to any flaws in the API),
and is subject to the Go
<a href="https://golang.org/s/releasesched">release schedule</a>,
preventing bug fixes from being available to users quickly.
</p>

<p>
Most new code should live outside of the standard library and be accessible
via the <a href="/cmd/go/"><code>go</code> tool</a>'s
<code>go get</code> command.
Such code can have its own maintainers, release cycle,
and compatibility guarantees.
Users can find packages and read their documentation at
<a href="https://godoc.org/">godoc.org</a>.
</p>

<p>
Although there are pieces in the standard library that don't really belong,
such as <code>log/syslog</code>, we continue to maintain everything in the
library because of the Go 1 compatibility promise.
But we encourage most new code to live elsewhere.
</p>

<h2 id="Implementation">Implementation</h2>

<h3 id="What_compiler_technology_is_used_to_build_the_compilers">
What compiler technology is used to build the compilers?</h3>

<p>
<code>Gccgo</code> has a front end written in C++, with a recursive descent parser coupled to the
standard GCC back end. <code>Gc</code> is written in Go using
<code>yacc</code>/<code>bison</code> for the parser
and uses a custom loader, also written in Go but
based on the Plan 9 loader, to generate ELF/Mach-O/PE binaries.
</p>

<p>
We considered using LLVM for <code>gc</code> but we felt it was too large and
slow to meet our performance goals.
</p>

<p>
The original <code>gc</code>, the Go compiler, was written in C
because of the difficulties of bootstrapping&mdash;you'd need a Go compiler to
set up a Go environment.
But things have advanced and as of Go 1.5 the compiler is written in Go.
It was converted from C to Go using automatic translation tools, as
described in <a href="/s/go13compiler">this design document</a>
and <a href="https://talks.golang.org/2015/gogo.slide#1">a recent talk</a>.
Thus the compiler is now "self-hosting", which means we must face
the bootstrapping problem.
The solution, naturally, is to have a working Go installation already,
just as one normally has a working C installation in place.
The story of how to bring up a new Go installation from source
is described <a href="/s/go15bootstrap">separately</a>.
</p>

<p>
Go is a fine language in which to implement a Go compiler.
Although <code>gc</code> does not use them (yet?), a native lexer and
parser are available in the <a href="/pkg/go/"><code>go</code></a> package
and there is also a <a href="/pkg/go/types">type checker</a>.
</p>

<h3 id="How_is_the_run_time_support_implemented">
How is the run-time support implemented?</h3>

<p>
Again due to bootstrapping issues, the run-time code was originally written mostly in C (with a
tiny bit of assembler) but it has since been translated to Go
(except for some assembler bits).
<code>Gccgo</code>'s run-time support uses <code>glibc</code>.
The <code>gccgo</code> compiler implements goroutines using
a technique called segmented stacks,
supported by recent modifications to the gold linker.
</p>

<h3 id="Why_is_my_trivial_program_such_a_large_binary">
Why is my trivial program such a large binary?</h3>

<p>
The linker in the <code>gc</code> tool chain
creates statically-linked binaries by default.  All Go binaries therefore include the Go
run-time, along with the run-time type information necessary to support dynamic
type checks, reflection, and even panic-time stack traces.
</p>

<p>
A simple C "hello, world" program compiled and linked statically using gcc
on Linux is around 750 kB,
including an implementation of <code>printf</code>.
An equivalent Go program using <code>fmt.Printf</code>
is around 2.3 MB, but
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
The current implementation is a parallel mark-and-sweep collector.
Recent improvements, documented in
<a href="/s/go14gc">this design document</a>,
have introduced bounded pause times and improved the
parallelism.
Future versions might attempt new approaches.
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
                                                                                                                                                                                                                                                                                                                                                                                                                    usr/local/go/doc/go_mem.html                                                                        0100644 0000000 0000000 00000032271 13020111411 014440  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
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
		go func(w func()) {
			limit &lt;- 1
			w()
			&lt;-limit
		}(w)
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
                                                                                                                                                                                                                                                                                                                                       usr/local/go/doc/go_spec.html                                                                       0100644 0000000 0000000 00000602364 13020111411 014622  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--{
	"Title": "The Go Programming Language Specification",
	"Subtitle": "Version of January 5, 2016",
	"Path": "/ref/spec"
}-->

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
Term        = production_name | token [ "â€¦" token ] | Group | Option | Repetition .
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
The form <code>a â€¦ b</code> represents the set of characters from
<code>a</code> through <code>b</code> as alternatives. The horizontal
ellipsis <code>â€¦</code> is also used elsewhere in the spec to informally denote various
enumerations or code snippets that are not further specified. The character <code>â€¦</code>
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
unicode_digit  = /* a Unicode code point classified as "Number, decimal digit" */ .
</pre>

<p>
In <a href="http://www.unicode.org/versions/Unicode8.0.0/">The Unicode Standard 8.0</a>,
Section 4.5 "General Category" defines a set of character categories.
Go treats all characters in any of the Letter categories Lu, Ll, Lt, Lm, or Lo
as Unicode letters, and those in the Number category Nd as Unicode digits.
</p>

<h3 id="Letters_and_digits">Letters and digits</h3>

<p>
The underscore character <code>_</code> (U+005F) is considered a letter.
</p>
<pre class="ebnf">
letter        = unicode_letter | "_" .
decimal_digit = "0" â€¦ "9" .
octal_digit   = "0" â€¦ "7" .
hex_digit     = "0" â€¦ "9" | "A" â€¦ "F" | "a" â€¦ "f" .
</pre>

<h2 id="Lexical_elements">Lexical elements</h2>

<h3 id="Comments">Comments</h3>

<p>
Comments serve as program documentation. There are two forms:
</p>

<ol>
<li>
<i>Line comments</i> start with the character sequence <code>//</code>
and stop at the end of the line.
</li>
<li>
<i>General comments</i> start with the character sequence <code>/*</code>
and stop with the first subsequent character sequence <code>*/</code>.
</li>
</ol>

<p>
A comment cannot start inside a <a href="#Rune_literals">rune</a> or
<a href="#String_literals">string literal</a>, or inside a comment.
A general comment containing no newlines acts like a space.
Any other comment acts like a newline.
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
When the input is broken into tokens, a semicolon is automatically inserted
into the token stream immediately after a line's final token if that token is
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
Î±Î²
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
decimal_lit = ( "1" â€¦ "9" ) { decimal_digit } .
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
A rune literal is expressed as one or more characters enclosed in single quotes,
as in <code>'x'</code> or <code>'\n'</code>.
Within the quotes, any character may appear except newline and unescaped single
quote. A single quoted character represents the Unicode value
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
<code>'Ã¤'</code> holds two bytes (<code>0xc3</code> <code>0xa4</code>) representing
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
'Ã¤'
'æœ¬'
'\t'
'\000'
'\007'
'\377'
'\x07'
'\xff'
'\u12e4'
'\U00101234'
'\''         // rune literal containing single quote character
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
Raw string literals are character sequences between back quotes, as in
<code>`foo`</code>.  Within the quotes, any character may appear except
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
quotes, as in <code>&quot;bar&quot;</code>.
Within the quotes, any character may appear except newline and unescaped double quote.
The text between the quotes forms the
value of the literal, with backslash escapes interpreted as they
are in <a href="#Rune_literals">rune literals</a> (except that <code>\'</code> is illegal and
<code>\"</code> is legal), with the same restrictions.
The three-digit octal (<code>\</code><i>nnn</i>)
and two-digit hexadecimal (<code>\x</code><i>nn</i>) escapes represent individual
<i>bytes</i> of the resulting string; all other escapes represent
the (possibly multi-byte) UTF-8 encoding of individual <i>characters</i>.
Thus inside a string literal <code>\377</code> and <code>\xFF</code> represent
a single byte of value <code>0xFF</code>=255, while <code>Ã¿</code>,
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
`abc`                // same as "abc"
`\n
\n`                  // same as "\\n\n\\n"
"\n"
"\""                 // same as `"`
"Hello, world!\n"
"æ—¥æœ¬èªž"
"\u65e5æœ¬\U00008a9e"
"\xff\u00FF"
"\uD800"             // illegal: surrogate half
"\U00110000"         // illegal: invalid Unicode code point
</pre>

<p>
These examples all represent the same string:
</p>

<pre>
"æ—¥æœ¬èªž"                                 // UTF-8 input text
`æ—¥æœ¬èªž`                                 // UTF-8 input text as a raw literal
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
Numeric constants represent exact values of arbitrary precision and do not overflow.
Consequently, there are no constants denoting the IEEE-754 negative zero, infinity,
and not-a-number values.
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
struct {
	x, y float64 ""  // an empty tag string is like an absent tag
	name string  "any string is permitted as a tag"
	_    [4]byte "ceci n'est pas un champ de structure"
}

// A struct corresponding to a TimeStamp protocol buffer.
// The tag strings define the protocol buffer field numbers;
// they follow the convention outlined by the reflect package.
struct {
	microsec  uint64 `protobuf:"1"`
	serverIP6 uint64 `protobuf:"2"`
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
The final incoming parameter in a function signature may have
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
func (p T) Read(b Buffer) bool { return â€¦ }
func (p T) Write(b Buffer) bool { return â€¦ }
func (p T) Close() { â€¦ }
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
func (p T) Lock() { â€¦ }
func (p T) Unlock() { â€¦ }
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
const ( // iota is reset to 0
	c0 = iota  // c0 == 0
	c1 = iota  // c1 == 1
	c2 = iota  // c2 == 2
)

const ( // iota is reset to 0
	a = 1 &lt;&lt; iota  // a == 1
	b = 1 &lt;&lt; iota  // b == 2
	c = 3          // c == 3  (iota is not used but still incremented)
	d = 1 &lt;&lt; iota  // d == 8
)

const ( // iota is reset to 0
	u         = iota * 42  // u == 0     (untyped integer constant)
	v float64 = iota * 42  // v == 42.0  (float64 constant)
	w         = iota * 42  // w == 84    (untyped integer constant)
)

const x = iota  // x == 0  (iota has been reset)
const y = iota  // y == 0  (iota has been reset)
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
	return fmt.Sprintf("GMT%+dh", tz)
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
var d = math.Sin(0.5)  // d is float64
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
Unlike regular variable declarations, a short variable declaration may <i>redeclare</i>
variables provided they were originally declared earlier in the same block
(or the parameter lists if the block is the function body) with the same type, 
and at least one of the non-<a href="#Blank_identifier">blank</a> variables is new.
As a consequence, redeclaration can only appear in a multi-variable short declaration.
Redeclaration does not introduce a new variable; it just assigns a new value to the original.
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
func IndexRune(s string, r rune) int {
	for i, c := range s {
		if c == r {
			return i
		}
	}
	// invalid: missing return statement
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
The receiver is specified via an extra parameter section preceding the method
name. That parameter section must declare a single non-variadic parameter, the receiver.
Its type must be of the form <code>T</code> or <code>*T</code> (possibly using
parentheses) where <code>T</code> is a type name. The type denoted by <code>T</code> is called
the receiver <i>base type</i>; it must not be a pointer or interface type and
it must be declared in the same package as the method.
The method is said to be <i>bound</i> to the base type and the method name
is visible only within <a href="#Selectors">selectors</a> for type <code>T</code>
or <code>*T</code>.
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
They consist of the type of the literal followed by a brace-bound list of elements.
Each element may optionally be preceded by a corresponding key.
</p>

<pre class="ebnf">
CompositeLit  = LiteralType LiteralValue .
LiteralType   = StructType | ArrayType | "[" "..." "]" ElementType |
                SliceType | MapType | TypeName .
LiteralValue  = "{" [ ElementList [ "," ] ] "}" .
ElementList   = KeyedElement { "," KeyedElement } .
KeyedElement  = [ Key ":" ] Element .
Key           = FieldName | Expression | LiteralValue .
FieldName     = identifier .
Element       = Expression | LiteralValue .
</pre>

<p>
The LiteralType's underlying type must be a struct, array, slice, or map type
(the grammar enforces this constraint except when the type is given
as a TypeName).
The types of the elements and keys must be <a href="#Assignability">assignable</a>
to the respective field, element, and key types of the literal type;
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
	<li>A key must be a field name declared in the struct type.
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
The length of an array literal is the length specified in the literal type.
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
[]T{x1, x2, â€¦ xn}
</pre>

<p>
and is shorthand for a slice operation applied to an array:
</p>

<pre>
tmp := [n]T{x1, x2, â€¦ xn}
tmp[0 : n]
</pre>

<p>
Within a composite literal of array, slice, or map type <code>T</code>,
elements or map keys that are themselves composite literals may elide the respective
literal type if it is identical to the element or key type of <code>T</code>.
Similarly, elements or keys that are addresses of composite literals may elide
the <code>&amp;T</code> when the element or key type is <code>*T</code>.
</p>

<pre>
[...]Point{{1.5, -3.5}, {0, 0}}     // same as [...]Point{Point{1.5, -3.5}, Point{0, 0}}
[][]int{{1, 2, 3}, {4, 5}}          // same as [][]int{[]int{1, 2, 3}, []int{4, 5}}
[][]Point{{{0, 1}, {1, 2}}}         // same as [][]Point{[]Point{Point{0, 1}, Point{1, 2}}}
map[string]Point{"orig": {0, 0}}    // same as map[string]Point{"orig": Point{0, 0}}

[...]*Point{{1.5, -3.5}, {0, 0}}    // same as [...]*Point{&amp;Point{1.5, -3.5}, &amp;Point{0, 0}}

map[Point]string{{0, 0}: "orig"}    // same as map[Point]string{Point{0, 0}: "orig"}
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
if x == (T{a,b,c}[i]) { â€¦ }
if (x == T{a,b,c}[i]) { â€¦ }
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
t.x          // (*t.T0).x

p.z          // (*p).z
p.y          // (*p).T1.y
p.x          // (*(*p).T0).x

q.x          // (*(*q).T0).x        (*q).x is a valid field selector

p.M0()       // ((*p).T0).M0()      M0 expects *T0 receiver
p.M1()       // ((*p).T1).M1()      M1 expects T1 receiver
p.M2()       // p.M2()              M2 expects *T2 receiver
t.M2()       // (&amp;t).M2()           M2 expects *T2 receiver, see section on Calls
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
f(a1, a2, â€¦ an)
</pre>

<p>
calls <code>f</code> with arguments <code>a1, a2, â€¦ an</code>.
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
Expression = UnaryExpr | Expression binary_op Expression .
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
it is first converted to the type it would assume if the shift expression were
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


<h4 id="Operator_precedence">Operator precedence</h4>
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
<code>-</code>, <code>*</code>, <code>/</code>) apply to integer,
floating-point, and complex types; <code>+</code> also applies to strings.
The bitwise logical and shift operators apply to integers only.
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


<h4 id="Integer_operators">Integer operators</h4>

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


<h4 id="Integer_overflow">Integer overflow</h4>

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


<h4 id="Floating_point_operators">Floating-point operators</h4>

<p>
For floating-point and complex numbers,
<code>+x</code> is the same as <code>x</code>,
while <code>-x</code> is the negation of <code>x</code>.
The result of a floating-point or complex division by zero is not specified beyond the
IEEE-754 standard; whether a <a href="#Run_time_panics">run-time panic</a>
occurs is implementation-specific.
</p>


<h4 id="String_concatenation">String concatenation</h4>

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
const c = 3 &lt; 4            // c is the untyped boolean constant true

type MyBool bool
var x, y int
var (
	// The result of a comparison is an untyped boolean.
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
	IEEE 754 round-to-even rules, but with an IEEE <code>-0.0</code>
	further rounded to an unsigned <code>0.0</code>.
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
float64(-1e-1000)        // 0.0 of type float64
string('x')              // "x" of type string
string(0x266c)           // "â™¬" of type string
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
string(0xf8)      // "\u00f8" == "Ã¸" == "\xc3\xb8"
type MyString string
MyString(0x65e5)  // "\u65e5" == "æ—¥" == "\xe6\x97\xa5"
</pre>
</li>

<li>
Converting a slice of bytes to a string type yields
a string whose successive bytes are the elements of the slice.

<pre>
string([]byte{'h', 'e', 'l', 'l', '\xc3', '\xb8'})   // "hellÃ¸"
string([]byte{})                                     // ""
string([]byte(nil))                                  // ""

type MyBytes []byte
string(MyBytes{'h', 'e', 'l', 'l', '\xc3', '\xb8'})  // "hellÃ¸"
</pre>
</li>

<li>
Converting a slice of runes to a string type yields
a string that is the concatenation of the individual rune values
converted to strings.

<pre>
string([]rune{0x767d, 0x9d6c, 0x7fd4})   // "\u767d\u9d6c\u7fd4" == "ç™½éµ¬ç¿”"
string([]rune{})                         // ""
string([]rune(nil))                      // ""

type MyRunes []rune
string(MyRunes{0x767d, 0x9d6c, 0x7fd4})  // "\u767d\u9d6c\u7fd4" == "ç™½éµ¬ç¿”"
</pre>
</li>

<li>
Converting a value of a string type to a slice of bytes type
yields a slice whose successive elements are the bytes of the string.

<pre>
[]byte("hellÃ¸")   // []byte{'h', 'e', 'l', 'l', '\xc3', '\xb8'}
[]byte("")        // []byte{}

MyBytes("hellÃ¸")  // []byte{'h', 'e', 'l', 'l', '\xc3', '\xb8'}
</pre>
</li>

<li>
Converting a value of a string type to a slice of runes type
yields a slice containing the individual Unicode code points of the string.

<pre>
[]rune(MyString("ç™½éµ¬ç¿”"))  // []rune{0x767d, 0x9d6c, 0x7fd4}
[]rune("")                 // []rune{}

MyRunes("ç™½éµ¬ç¿”")           // []rune{0x767d, 0x9d6c, 0x7fd4}
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
const Î˜ float64 = 3/2      // Î˜ == 1.0   (type float64, 3/2 is integer division)
const Î  float64 = 3/2.     // Î  == 1.5   (type float64, 3/2. is float division)
const d = 1 &lt;&lt; 3.0         // d == 8     (untyped integer constant)
const e = 1.0 &lt;&lt; 3         // e == 8     (untyped integer constant)
const f = int32(1) &lt;&lt; 33   // illegal    (constant 8589934592 overflows int32)
const g = float64(2) &gt;&gt; 1  // illegal    (float64(2) is a typed floating-point constant)
const h = "foo" &gt; "bar"    // h == true  (untyped boolean constant)
const j = true             // j == true  (untyped boolean constant)
const k = 'w' + 1          // k == 'x'   (untyped rune constant)
const l = "hi"             // l == "hi"  (untyped string constant)
const m = string(k)        // m == "x"   (type string)
const Î£ = 1 - 0.707i       //            (untyped complex constant)
const Î” = Î£ + 2.0e-4       //            (untyped complex constant)
const Î¦ = iota*1i - 1/1i   //            (untyped complex constant)
</pre>

<p>
Applying the built-in function <code>complex</code> to untyped
integer, rune, or floating-point constants yields
an untyped complex constant.
</p>

<pre>
const ic = complex(0, c)   // ic == 3.75i  (untyped complex constant)
const iÎ˜ = complex(0, Î˜)   // iÎ˜ == 1i     (type complex128)
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
precision, and vice versa.
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
<code>(y)</code> but evaluates <code>x</code>
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
one, two, three = 'ä¸€', 'äºŒ', 'ä¸‰'
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
The switch expression is evaluated exactly once in a switch statement.
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
If the switch expression evaluates to an untyped constant, it is first
<a href="#Conversions">converted</a> to its <a href="#Constants">default type</a>;
if it is an untyped boolean value, it is first converted to type <code>bool</code>.
The predeclared untyped value <code>nil</code> cannot be used as a switch expression.
</p>

<p>
If a case expression is untyped, it is first <a href="#Conversions">converted</a>
to the type of the switch expression.
For each (possibly converted) case expression <code>x</code> and the value <code>t</code>
of the switch expression, <code>x == t</code> must be a valid <a href="#Comparison_operators">comparison</a>.
</p>

<p>
In other words, the switch expression is treated as if it were used to declare and
initialize a temporary variable <code>t</code> without explicit type; it is that
value of <code>t</code> against which each case expression <code>x</code> is tested
for equality.
</p>

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
The switch expression may be preceded by a simple statement, which
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

<p>
Implementation restriction: A compiler may disallow multiple case
expressions evaluating to the same constant.
For instance, the current compilers disallow duplicate integer,
floating point, or string constants in case expressions.
</p>

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
next case clause in an <a href="#Expression_switches">expression "switch" statement</a>.
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
	c5 = len([10]float64{imag(z)})   // invalid: imag(z) is a (non-constant) function call
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
t = append(t, 42, 3.1415, "foo")   //                             t == []interface{}{42, 3.1415, "foo"}

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
<code>complex64</code> for <code>float32</code> arguments, and
<code>complex128</code> for <code>float64</code> arguments.
If one of the arguments evaluates to an untyped constant, it is first
<a href="#Conversions">converted</a> to the type of the other argument.
If both arguments evaluate to untyped constants, they must be non-complex
numbers or their imaginary parts must be zero, and the return value of
the function is an untyped complex constant.
</p>

<p>
For <code>real</code> and <code>imag</code>, the argument must be
of complex type, and the return type is the corresponding floating-point
type: <code>float32</code> for a <code>complex64</code> argument, and
<code>float64</code> for a <code>complex128</code> argument.
If the argument evaluates to an untyped constant, it must be a number,
and the return value of the function is an untyped floating-point constant.
</p>

<p>
The <code>real</code> and <code>imag</code> functions together form the inverse of
<code>complex</code>, so for a value <code>z</code> of a complex type <code>Z</code>,
<code>z&nbsp;==&nbsp;Z(complex(real(z),&nbsp;imag(z)))</code>.
</p>

<p>
If the operands of these functions are all constants, the return
value is a constant.
</p>

<pre>
var a = complex(2, -2)             // complex128
const b = complex(1.0, -1.4)       // untyped complex constant 1 - 1.4i
x := float32(math.Cos(math.Pi/2))  // float32
var c64 = complex(5, -x)           // complex64
const s uint = complex(1, 0)       // untyped complex constant 1 + 0i can be converted to uint
_ = complex(1, 2&lt;&lt;s)               // illegal: 2 has floating-point type, cannot shift
var rl = real(c64)                 // float32
var im = imag(a)                   // float64
const c = imag(b)                  // untyped constant -1.4
_ = imag(3 &lt;&lt; s)                   // illegal: 3 has complex type, cannot shift
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
(<a href="#Program_initialization_and_execution">Â§Program initialization and execution</a>)
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

// Send the sequence 2, 3, 4, â€¦ to channel 'ch'.
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
func init() { â€¦ }
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
func main() { â€¦ }
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
                                                                                                                                                                                                                                                                            usr/local/go/doc/gopher/                                                                            0040755 0000000 0000000 00000000000 13020111411 013571  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        usr/local/go/doc/gopher/README                                                                      0100644 0000000 0000000 00000000336 13020111411 014450  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        The Go gopher was designed by Renee French. (http://reneefrench.blogspot.com/)
The design is licensed under the Creative Commons 3.0 Attributions license.
Read this article for more details: https://blog.golang.org/gopher
                                                                                                                                                                                                                                                                                                  usr/local/go/doc/gopher/appenginegopher.jpg                                                         0100644 0000000 0000000 00000411312 13020111411 017445  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ÿØÿà JFIF „„  ÿá¾Exif  MM *                  b       j(       1       r2       ‡i       ¤   Ð ‰T,  ' ‰T,  'Adobe Photoshop CS2 Macintosh 2011:04:07 18:12:56       ÿÿ         —       …                          &(             .      ˆ       H      H   ÿØÿà JFIF   H H  ÿí Adobe_CM ÿî Adobe d€   ÿÛ „ 			
ÿÀ  e  " ÿÝ  
ÿÄ?          	
         	
 3 !1AQa"q2‘¡±B#$RÁb34r‚ÑC%’Sðáñcs5¢²ƒ&D“TdEÂ£t6ÒUâeò³„ÃÓuãóF'”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö7GWgw‡—§·Ç×ç÷ 5 !1AQaq"2‘¡±B#ÁRÑð3$bár‚’CScs4ñ%¢²ƒ&5ÂÒD“T£dEU6teâò³„ÃÓuãóF”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö'7GWgw‡—§·ÇÿÚ   ? õ*iªŠ™M,mUTÐÊë`kZÑµŒcíkÕ4’IJI$’R’I+/ù9w3½_m®cdížøoÒ))2ÃwÖóÉ«êæ0Ïä¡kX-?¤o³$6Ë3ÜÛ+Øæ`Uu_é²qÔ+eÿ Y_êeÓf7C­çÓÆ¸Y˜Z}¶åÐè}=7óªÄ»ô¹¿öªº±¿A“¼Öµ`kD5£@ ìSŠî…Õ2šhu¼£¹Äº¬&×‰P˜Çduÿ îESëÿ V:5]3.Ê¬Ì³“sNm÷eèþ±ífu×±›ý=–zN¿Ñ®PëÌcúQcÌ1Ø·#[å%5ÝõGê«‡ü‚<ÛSOùÌcT]õO¥µ®–eà¸ýceÞÆ´¢æã:×á»ú–ãYWò®;œú+sÄ9Ìipó#TD”â9¿Zúx&·QÖèh$6ÏÕ2¹–R¶Ù“fÏø™Z%Y°ÌLÚïé™V¿Óª¬Úý6½úm®ŒÊÍ½?&Ë7þŽ¬|»mþB×CÈÆÇÊ¡øù52ú,lªÆ‡1ÃÁì|µÉ)"KŸ¥ÙŸW.uyv¿+ ¼ÍVëp§üe®—ätïôYÖ~›þÖú˜ÿ ­S¾×5Íi¤H#PAIK¤’I)I$’JÿÐõT’I%)$–OSúËÓò>ÄÊïÏÏ†¸áaVnµ­q_ô)Æ¯Ýôòn¥%'ë=Sö^¬Ê]•“kÛN&#k®¹ÿ ÍÔ×Ùì­º:Ûíÿ ]×ƒYLéùWõì×lf[Å7eãbÖØÆÇ¶—bT×Ô×þ—+"¿µ;ÓËÉúÎbãáúŠ®w\qëýî¡Ós°±Zûi£ÕmNÌ½¬§Ù‡‘”ïf'í/¥ô=U£×3Ù‹ÕºÙXìÎ¢Ánì
`Üìk[µÖûÝ]4UöÚ1?XÊ¶š®¿Óþ‰%;©.s5ýa´¾·Õ±ú£ÓÅØçË‡±ê]IŽ©ïú~Ì~EŸð«%¶ýNÈm9§õN½Yh5ädcçfTAÿ ÆfµØÿ öÅ))ê²ºÿ BÃ§™ÔqqŸû¶ß[ù¶=«+­}kú­wJÍÆgWÃ}—cÛ[ZËØâK˜æ€=79¢g}OvK°º]XøY­ÕØnÇûüo–ã_V=Ö{>¶-ô”óô}wú©èW=N‰ÚÙÔ˜1ÇÕýsú¥gÑëcú÷1ŸùñÍ[K'?ë&.aéØÕ]ÔºÛ¿¡Î¬8ncòî±Õca±ß÷fúÿ àÒSc­ô\çìÁêÙO›MÕØ~êÞåyryuõž¡_­›õG!ÃVÕ“•Sìüp®¥¯ÿ ¯¬qÒ:v]8Y=7«}VÌ½Ûª8.uø®x÷©ÇÆvfK>úÿ fX’ž¿ª›Ÿ‹ÒüÓ¿[Îô59¾Ž;¿ðæQgµÿ £ÈÄÅÎ¥RÈÅoÕsV^½Šëƒ3pµÕö‹›ƒ?ÑYVE»²±¢}ŸÕ¾ª©º¿ÓÖÂÎËé¢Þµe¬ëý30V×u<6ƒ}UÖ_HõpéßVF.3mÙálº¼‹òÿ ÉÞŸóz_Y³ús~¬eäÞ×åôüŠ6=Ø¥Ž&¬€)õê²Ç²ŸOmÞ§­¿Ù_éRS²’æp¾±uÌ.ŸKºÿ EË¨ÔÊÙ•—C©Énè»%Øø—?)´îý+ý*.ôØº\¬|Ìzò±lmÔ\Ðúìa–¹§»JJJ’I$§ÿÑõT’I%5úŽm}?§ågÚ«Ä¦ËÞ%µµÖº?Í\Î/QgÕo¨¿·²«~^]õ×›š}­}¹9EŸÎ=Ù]u>æPÏgè±ê]N^-9˜·bd7}º«[âÇ‚Ç·ü×.:Îµ…Ñ:ßW~´VÇ[‰†öcÚ3é¡›iô,{žÖæ9Œ¥—ã>Ï[í/ßGæ$¦¿KúÁXÇÿ ž™˜~›©`è7Ôk½L‹ÞÚ-½¹WO¿*ïKý¦Ç£-i_‘…õSù½™s2·fõ,Ûäû+ö;*êÚæ¿ì”=ìÃé]6§³Õ±õâÓÿ jó+¯õjŒ0ÿ «½#Æ=½'ÌÜºé{lkrìmXÌõYwÓûgT{ÏUú“­¹Õf\ZÕ¾±Ñ†ðeÀc`Ym8øÞóµ­·;ÜŸøÌËS£õ_ê¥ís:ïÖgþ»hÜÏ\‡·¤úŒ£¶µ”U{?Ã[MLý/©è~ùî­$’SO©ôŽÕ±Æ>}-¹!õ»PúÞ>´\Í¶ÑkÒTõŸÐòó1s¯ú½Ô­vMøìàæ<×â“éþ™Ìö;/ßÐd»ô~®ü|ðËË¾´}iúÙÖ~¹]ÑúfeØm«)øX´Qq¡¤±Þ©m¬u[Ýk«õ?Iüßóu.§ê¿Rê½IÝþ°éê½3ªæt«œ%ìû%¹z¾èlôí¦sÐWjJzÏ¬½G3¦Þ§Õ.¸¶×
»'5ÕXúýFâbÕm»?Óz5«]£át|!‡†Aq²ë¬;­º×=••wÒ»"ç9gþ‹YýHÐ>¸ôAtov.xÇž}IÁ.Ûÿ XõVòJR£Ôééõ;¤õ/FÖå´²ØàáûÕ¶[fæ;ÜËj÷Ôÿ  ®X^ãXà ðOæ¯›i§öÇUÌ]ê?aÉÙmÖ]’Ç¹Ï¹Ÿö•Ìgº§»èÁìôë¯§JJ}oíìû‹­»+¢í³;×úuÎ§:ÝÞvulé¾·äÿ ;•ö/³Ýê}¢ŸCU˜¸¸ç¦Ç­Ð~°¶ßJ©ÝUyc®ÈÇ§oÑÅêxÞ¾S[¿Ó«"œû˜±>¥_Ÿ™Õº]ýG{ò¬è¬½Ä¸=‡*:u—9Óê]v;/·Ýïþq[¬ØÅÍ÷tV¶ê‰þË»ÿ GQ„ú¿ë©)Éè?\þ°tÿ ­´ýJê8ìÈ£ßd®ö5ßh,c7ãeÜ}[+~ü`Ëoö}Ò.¯ Tp:ç[éU€0Úúsñ™.;Xµ¹U4<ŸN¿µaÝÊëö~°°núÇÓúw_ê½w¥çgúØt4_V%¬Øê~Òì–_~]t;ŸM¸>¯óŸÔý
é~¯tëéûOUÍ{,êUÌ¶ãQ&¶TÆìÄÅ¥ÎÛ¾ºk.©±ž­×]bJvI$”ÿ ÿÒõT’I%)sýWìØX)ê}CcznF#°î¾í¾•66ÆäcúÏ³ÛUy[®gªÿ ÑúôcÕüå´®býb©¹ôlKOè/êõ˜xx¦Œ¼ê˜ùüß´âÐô”‡ëìÇ©”ÕL¥Õ
Ú×zwäúå¡žßûUþz¥öŒÞ•Õº5•õN›ŸfntºËÏ[éÖïð6ºß±Øÿ ø¯ôjÞBÃé«­t,
èÈÂÝöœl:XÇdã<7í8íe^Ÿ©‘_§VV'ü=gÿ µ6+m]^Š:ÿ ÕìŠŽSª"‹Ü	¦ú§wÙ3Ø¹¬eßEßÒp2=_Ñÿ JÅ½)·ÑzÆ/YÀff<±ÒkÈÇx"Ê.f—âdVà××}ú[›ÿ 	üÛÕõÆuEy–u'Õõw¬±¹ã¿;!¬;Yö‘„Ëj½Œfúéºÿ ÙÝBªßþùµ®½kÓsF./S¸´á·=„‰öî§öfkiwüf_ýq%6~±ÿ ‹O«ŸXsÏPÉ7ãd¼EÏÆsZ,€×XÛ«¹»ÚÖÿ ƒØ¨`Ÿ«]':›Øö`}_ú¼.£û_ý':øûm”ûÞü¿²cµô7üíùQú,e¡•õ«+í?YœÎÓl±µWÒp]»;1ö(Àû^ÿ Ñzö}/²ì·ìþ»/ôký*­×¿Å¿WúÅ‡E·äãtÛñXkÂét1ÇšËœïJÌÛìÈs}["¬vUú/æ?Â$¦ÿ Súáõg®6ƒÐú•në87'«C¨<Sf«™]5þ½E¶ã9üå•XºžÖpzÎ ÊÄq¤²ú,.¦ÖûmÆÊ¤û©¾§}6Û£^Wþ$ºË²Z:–v5XÜ½Øûì°ÿ %­¶¬v7wïïÿ ­®›©t7tœìK3ó-ÚæbcuìsèæÒâ[ö|^®êšqz–ÎÇ¢Ÿ´eQú;?žþwÖIOx¹þ»Ñ¾¦Pçu¾µ…ŠlnŽ¶ÊÃŽ?Ežý«½ÿ F¶zvÚ³²:OøË©íf7\ÆÌ¢eï}5ã_ýJöãgãmÕ§Äè?XY”3îÆÆ¿¨´»ÒÎê–åšZý»þËƒÓ°êúöŸì¶Ã$¤ø¹7t¬,ï¬½Y…½G«>¶bôùvðÖ‡UÒzUlÝoëv¾ÇÛ“é³ùü›ÿ ÀÐ¥ÔðÇFÿ Y˜W¼9ôtÛj¶Á0ëŸS›cÛº?žÉ±hát-™¬ê}O!ÝG©TÚmsEuPÛ½˜XŒ.m;™ú7ßm™«ôOÊô¿F¨WÔhúÏÖ[‰ˆöÙÒzQ«.ëšç‘x}Ÿbf;™¶»pqr1mºë·þ›3š›«!%-×þ³ô+ú6^QÆÍÎÍ©ø¸”Qk-{î½¿gÇk…ovÆ:ëºÛ6TºJ6-8ÀîÖÚÁñÚ'ðY_[e}?ÀÓöj³±/Í´	ôè¦êò¬½Íÿ FÇÓ_¬ÿ ð4ú™B•´"G	)t’I%?ÿÓõT’I%)b}k˜˜Y…Á‡¨aÙ¸ö\Ì¿ö_2Õ¶±~¹{¾¬çÒêY“XÆ¡¿ðÙn&/ù¹7T’¥Ë]‡Ô1þ³äWõpÕ‹¿gu*ov=÷Ü÷Q‹µ•¸;
û‰–ì¬º?ý¯”º•‰Ó˜kú×ÖCõu¸øVÖg_Oõº=?ì]EÖ×’S6u~¶ÍÌÉèY±¤ø·ã[S‡g2Ì¼Ž‘ÿ nbÖ£öï­EÍÅéµtöHüë›cÀŸs›…Ó½v[íü×uu´’JyŽ£õK/!˜ùÿ mv_\ÃÈ¯+üeg¶Ü*±êkÛ‰‡Ï¦êýl½þ—ädú¨b}`úÙÕNe+ì+N5·ee+42Çµ•bcú—7Ò¶·ÿ 9Žº¥Çt³Òú-ý~®³™NCº¦FH¦ûÇº—2¯³ÛMn;îe´×íô¿âþšJKÒzŸ×¬ámÁ*ê±òoÅ¶¿Ö1Ý»Çcïe¿¯·ô›74£ŽÞ©õÊœK:–.>F§"Çäbú§&ÛíÅ±øõãÚF>=XŸhªËnþ‘ëúuUú?Ò(}\úËÑzuÔõ<Ù·[—•]y­v;ŸFEÖ_v?®ëï¯ü¦eŸ£ôÖÇÕ&Z:#-¶§ÐroÊÉeV{kÈÈ¿*íüÇ:›k~Ä”ÇþnäáÇì>¥v`‚0íhÊÅ i²ºn,ÊÇ¯÷)ÄÎÇÇ¯ý
Ng×V8†ÛÓ.iáæ«ê#ãW¯•»þÝ[i$§ô.£žc®u´cÀÝ‡YÆÇ~ŽkÛ”M¹9™5»ó?j«ÏðØÖ&­µôï­ÒÚÛN'PÀ¯0mklÁ}öý™­o±›ñs½Jkÿ G‰ú5¸±~°ï9½µÒž¤ƒÑ›ëÿ à¢Jv\Ö½¥®Íp‡4ê=ŠÆú—c¬ú¥ÑÜîF-ù5cèµYëýJÎ›Ò¯È åº)Â¨Ç¿&â(Ã«Üæ{]‘e~§»ù´~•€Î›Ó1:unÞÌ:k¡¯"…mm{È¿·rJm$’I)ÿÔÛÉ¿?'7ëp8ýo ÚÎœÇûqñO§™’ÍÕÙ·;öŽE¹þƒ×£ÒÅ¦«1_uÊÆëý''$·;§2›2ÚÃ“‘¥Yxþû×º·kêâ_²ÏFßR½ž†VBÅf/Y{*Á¯­ºªv5”ädábÐÆ‹z—K/êÖWS?Ñ¿"ëÃoIOh°³ŸWUúÅ‹ÓX[e=&3ó€ƒ¶çWÒñì÷}?}ùÿ CôeÄ³ü-k}RÎ:YÒpmiå¯ê™ïiþ»-Å±þÚÔÀè}^¶z5YÐ0ÚI&ºÞç8†7Õ»/;Òüß Î›ê}Ö’S¥ÖºÖCÀ~~{È¬Êë`Ýe¶;ù¼|zÿ Âßoæ·þ¹gè·½¡ag4ßÕ:«WRê=JòöQM{¾É‚×ýW«m¹7VßÒåd_³ôŠÂúåÐiÅú§ÕòÝ}ù¹æ~×’ðçµ}VzT2¦S‹S½?Ò3Š}oðþ¢ìÒR’I$”¤+1q­¶»­©–[Iš¬sAs	ÿ FçÌþÊ*I)g5®À2$LÝ:I$¥$’I)K2Ê¿çLªý­-Ø»ŒÜ_‰ê6¡ùÖÓŠË?ë6Ûÿ ·Ulþ›ƒÔ©m9µXÇ‹k2ZöXßæï¢êË-¢úÿ 2ê^ËX’œ¿¬FÜlî™Õ,¦Ìž€û]“] ½õ¾Æ
1ú‡ÙØ×Y“V-oÊªêêý%jûO§g ¶1òqò©fF-¬¾‹×mnc‡‹ÍÍräþ¬uo¬­è”u¶ž±ˆçÞË=6†æTÊ,»Ø6ÕÔ÷zßéý›/ýy¶+;',u/ª™øôf—¸çt÷•d8ÜìA]E¶ÚÏ³ý«üU95þ%;ýG¨U@±íu¶ØáV>=pl¶×YM[‹[ôZç½ïw¥ML²û½:j±ë‹X:Žu÷Õ~vF?Tªë¨gKéâ—¹­Û(Š.£"ì¬{=Kº‡P·§ôý–~Žº–‡RÇê™O¼›™GUÎÇ¥¸n{þÅ‚?MÔsk¾Ú›»+/ÒÅÂû]˜Øþ…¶ãzá~ÑÒàtì›Ž1°im7³F®?é-yý%Ö¿ü%Ö»Õ³ü"JÿÕõT—Ê©$§ê¤—Ê©$§é?­Ÿ`ÿ ›}Gö«ö/AÞ¿Ùöú»;ú>¯è÷ÿ ]k¯•RIOÕI/•RIOÕI/•RIOÕI/•RIOÕI/•RIOÕI/•RIOÑ_QÕœq[‹ÛëeÃœÝ¤þµ“ùÖmÿ =­Ìÿ UŸ·ÿ gzÑìûw¡»oò>ÕîÚ¾nI%?G}Wÿ šÛ2æöÉ–}£éú›vþ©ý+ôßcô lýOÒþˆ·Ê©$§ÿÙÿí4šPhotoshop 3.0 8BIM%                     8BIMê     <?xml version="1.0" encoding="UTF-8"?>
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
8BIMé     x    H H    Þ@ÿîÿîRg(ü    H H    Ø(    d       ÿ              h                                 8BIMí     ƒÿ}  ƒÿ}  8BIM&               ?€  8BIM        8BIM        8BIMó     	         8BIM
       8BIM'     
        8BIMô      5    -        8BIM÷       ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿè  8BIM          @  @    8BIM         8BIM    a             …  —    A p p   E n g i n e   G o p h e r   v 3 - 2                                —  …                                            null      boundsObjc         Rct1       Top long        Leftlong        Btomlong  …    Rghtlong  —   slicesVlLs   Objc        slice      sliceIDlong       groupIDlong       originenum   ESliceOrigin   autoGenerated    Typeenum   
ESliceType    Img    boundsObjc         Rct1       Top long        Leftlong        Btomlong  …    Rghtlong  —   urlTEXT         nullTEXT         MsgeTEXT        altTagTEXT        cellTextIsHTMLbool   cellTextTEXT        	horzAlignenum   ESliceHorzAlign   default   	vertAlignenum   ESliceVertAlign   default   bgColorTypeenum   ESliceBGColorType    None   	topOutsetlong       
leftOutsetlong       bottomOutsetlong       rightOutsetlong     8BIM(        ?ð      8BIM        8BIM    ¤          e  à  ½`  ˆ  ÿØÿà JFIF   H H  ÿí Adobe_CM ÿî Adobe d€   ÿÛ „ 			
ÿÀ  e  " ÿÝ  
ÿÄ?          	
         	
 3 !1AQa"q2‘¡±B#$RÁb34r‚ÑC%’Sðáñcs5¢²ƒ&D“TdEÂ£t6ÒUâeò³„ÃÓuãóF'”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö7GWgw‡—§·Ç×ç÷ 5 !1AQaq"2‘¡±B#ÁRÑð3$bár‚’CScs4ñ%¢²ƒ&5ÂÒD“T£dEU6teâò³„ÃÓuãóF”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö'7GWgw‡—§·ÇÿÚ   ? õ*iªŠ™M,mUTÐÊë`kZÑµŒcíkÕ4’IJI$’R’I+/ù9w3½_m®cdížøoÒ))2ÃwÖóÉ«êæ0Ïä¡kX-?¤o³$6Ë3ÜÛ+Øæ`Uu_é²qÔ+eÿ Y_êeÓf7C­çÓÆ¸Y˜Z}¶åÐè}=7óªÄ»ô¹¿öªº±¿A“¼Öµ`kD5£@ ìSŠî…Õ2šhu¼£¹Äº¬&×‰P˜Çduÿ îESëÿ V:5]3.Ê¬Ì³“sNm÷eèþ±ífu×±›ý=–zN¿Ñ®PëÌcúQcÌ1Ø·#[å%5ÝõGê«‡ü‚<ÛSOùÌcT]õO¥µ®–eà¸ýceÞÆ´¢æã:×á»ú–ãYWò®;œú+sÄ9Ìipó#TD”â9¿Zúx&·QÖèh$6ÏÕ2¹–R¶Ù“fÏø™Z%Y°ÌLÚïé™V¿Óª¬Úý6½úm®ŒÊÍ½?&Ë7þŽ¬|»mþB×CÈÆÇÊ¡øù52ú,lªÆ‡1ÃÁì|µÉ)"KŸ¥ÙŸW.uyv¿+ ¼ÍVëp§üe®—ätïôYÖ~›þÖú˜ÿ ­S¾×5Íi¤H#PAIK¤’I)I$’JÿÐõT’I%)$–OSúËÓò>ÄÊïÏÏ†¸áaVnµ­q_ô)Æ¯Ýôòn¥%'ë=Sö^¬Ê]•“kÛN&#k®¹ÿ ÍÔ×Ùì­º:Ûíÿ ]×ƒYLéùWõì×lf[Å7eãbÖØÆÇ¶—bT×Ô×þ—+"¿µ;ÓËÉúÎbãáúŠ®w\qëýî¡Ós°±Zûi£ÕmNÌ½¬§Ù‡‘”ïf'í/¥ô=U£×3Ù‹ÕºÙXìÎ¢Ánì
`Üìk[µÖûÝ]4UöÚ1?XÊ¶š®¿Óþ‰%;©.s5ýa´¾·Õ±ú£ÓÅØçË‡±ê]IŽ©ïú~Ì~EŸð«%¶ýNÈm9§õN½Yh5ädcçfTAÿ ÆfµØÿ öÅ))ê²ºÿ BÃ§™ÔqqŸû¶ß[ù¶=«+­}kú­wJÍÆgWÃ}—cÛ[ZËØâK˜æ€=79¢g}OvK°º]XøY­ÕØnÇûüo–ã_V=Ö{>¶-ô”óô}wú©èW=N‰ÚÙÔ˜1ÇÕýsú¥gÑëcú÷1ŸùñÍ[K'?ë&.aéØÕ]ÔºÛ¿¡Î¬8ncòî±Õca±ß÷fúÿ àÒSc­ô\çìÁêÙO›MÕØ~êÞåyryuõž¡_­›õG!ÃVÕ“•Sìüp®¥¯ÿ ¯¬qÒ:v]8Y=7«}VÌ½Ûª8.uø®x÷©ÇÆvfK>úÿ fX’ž¿ª›Ÿ‹ÒüÓ¿[Îô59¾Ž;¿ðæQgµÿ £ÈÄÅÎ¥RÈÅoÕsV^½Šëƒ3pµÕö‹›ƒ?ÑYVE»²±¢}ŸÕ¾ª©º¿ÓÖÂÎËé¢Þµe¬ëý30V×u<6ƒ}UÖ_HõpéßVF.3mÙálº¼‹òÿ ÉÞŸóz_Y³ús~¬eäÞ×åôüŠ6=Ø¥Ž&¬€)õê²Ç²ŸOmÞ§­¿Ù_éRS²’æp¾±uÌ.ŸKºÿ EË¨ÔÊÙ•—C©Énè»%Øø—?)´îý+ý*.ôØº\¬|Ìzò±lmÔ\Ðúìa–¹§»JJJ’I$§ÿÑõT’I%5úŽm}?§ågÚ«Ä¦ËÞ%µµÖº?Í\Î/QgÕo¨¿·²«~^]õ×›š}­}¹9EŸÎ=Ù]u>æPÏgè±ê]N^-9˜·bd7}º«[âÇ‚Ç·ü×.:Îµ…Ñ:ßW~´VÇ[‰†öcÚ3é¡›iô,{žÖæ9Œ¥—ã>Ï[í/ßGæ$¦¿KúÁXÇÿ ž™˜~›©`è7Ôk½L‹ÞÚ-½¹WO¿*ïKý¦Ç£-i_‘…õSù½™s2·fõ,Ûäû+ö;*êÚæ¿ì”=ìÃé]6§³Õ±õâÓÿ jó+¯õjŒ0ÿ «½#Æ=½'ÌÜºé{lkrìmXÌõYwÓûgT{ÏUú“­¹Õf\ZÕ¾±Ñ†ðeÀc`Ym8øÞóµ­·;ÜŸøÌËS£õ_ê¥ís:ïÖgþ»hÜÏ\‡·¤úŒ£¶µ”U{?Ã[MLý/©è~ùî­$’SO©ôŽÕ±Æ>}-¹!õ»PúÞ>´\Í¶ÑkÒTõŸÐòó1s¯ú½Ô­vMøìàæ<×â“éþ™Ìö;/ßÐd»ô~®ü|ðËË¾´}iúÙÖ~¹]ÑúfeØm«)øX´Qq¡¤±Þ©m¬u[Ýk«õ?Iüßóu.§ê¿Rê½IÝþ°éê½3ªæt«œ%ìû%¹z¾èlôí¦sÐWjJzÏ¬½G3¦Þ§Õ.¸¶×
»'5ÕXúýFâbÕm»?Óz5«]£át|!‡†Aq²ë¬;­º×=••wÒ»"ç9gþ‹YýHÐ>¸ôAtov.xÇž}IÁ.Ûÿ XõVòJR£Ôééõ;¤õ/FÖå´²ØàáûÕ¶[fæ;ÜËj÷Ôÿ  ®X^ãXà ðOæ¯›i§öÇUÌ]ê?aÉÙmÖ]’Ç¹Ï¹Ÿö•Ìgº§»èÁìôë¯§JJ}oíìû‹­»+¢í³;×úuÎ§:ÝÞvulé¾·äÿ ;•ö/³Ýê}¢ŸCU˜¸¸ç¦Ç­Ð~°¶ßJ©ÝUyc®ÈÇ§oÑÅêxÞ¾S[¿Ó«"œû˜±>¥_Ÿ™Õº]ýG{ò¬è¬½Ä¸=‡*:u—9Óê]v;/·Ýïþq[¬ØÅÍ÷tV¶ê‰þË»ÿ GQ„ú¿ë©)Éè?\þ°tÿ ­´ýJê8ìÈ£ßd®ö5ßh,c7ãeÜ}[+~ü`Ëoö}Ò.¯ Tp:ç[éU€0Úúsñ™.;Xµ¹U4<ŸN¿µaÝÊëö~°°núÇÓúw_ê½w¥çgúØt4_V%¬Øê~Òì–_~]t;ŸM¸>¯óŸÔý
é~¯tëéûOUÍ{,êUÌ¶ãQ&¶TÆìÄÅ¥ÎÛ¾ºk.©±ž­×]bJvI$”ÿ ÿÒõT’I%)sýWìØX)ê}CcznF#°î¾í¾•66ÆäcúÏ³ÛUy[®gªÿ ÑúôcÕüå´®býb©¹ôlKOè/êõ˜xx¦Œ¼ê˜ùüß´âÐô”‡ëìÇ©”ÕL¥Õ
Ú×zwäúå¡žßûUþz¥öŒÞ•Õº5•õN›ŸfntºËÏ[éÖïð6ºß±Øÿ ø¯ôjÞBÃé«­t,
èÈÂÝöœl:XÇdã<7í8íe^Ÿ©‘_§VV'ü=gÿ µ6+m]^Š:ÿ ÕìŠŽSª"‹Ü	¦ú§wÙ3Ø¹¬eßEßÒp2=_Ñÿ JÅ½)·ÑzÆ/YÀff<±ÒkÈÇx"Ê.f—âdVà××}ú[›ÿ 	üÛÕõÆuEy–u'Õõw¬±¹ã¿;!¬;Yö‘„Ëj½Œfúéºÿ ÙÝBªßþùµ®½kÓsF./S¸´á·=„‰öî§öfkiwüf_ýq%6~±ÿ ‹O«ŸXsÏPÉ7ãd¼EÏÆsZ,€×XÛ«¹»ÚÖÿ ƒØ¨`Ÿ«]':›Øö`}_ú¼.£û_ý':øûm”ûÞü¿²cµô7üíùQú,e¡•õ«+í?YœÎÓl±µWÒp]»;1ö(Àû^ÿ Ñzö}/²ì·ìþ»/ôký*­×¿Å¿WúÅ‡E·äãtÛñXkÂét1ÇšËœïJÌÛìÈs}["¬vUú/æ?Â$¦ÿ Súáõg®6ƒÐú•në87'«C¨<Sf«™]5þ½E¶ã9üå•XºžÖpzÎ ÊÄq¤²ú,.¦ÖûmÆÊ¤û©¾§}6Û£^Wþ$ºË²Z:–v5XÜ½Øûì°ÿ %­¶¬v7wïïÿ ­®›©t7tœìK3ó-ÚæbcuìsèæÒâ[ö|^®êšqz–ÎÇ¢Ÿ´eQú;?žþwÖIOx¹þ»Ñ¾¦Pçu¾µ…ŠlnŽ¶ÊÃŽ?Ežý«½ÿ F¶zvÚ³²:OøË©íf7\ÆÌ¢eï}5ã_ýJöãgãmÕ§Äè?XY”3îÆÆ¿¨´»ÒÎê–åšZý»þËƒÓ°êúöŸì¶Ã$¤ø¹7t¬,ï¬½Y…½G«>¶bôùvðÖ‡UÒzUlÝoëv¾ÇÛ“é³ùü›ÿ ÀÐ¥ÔðÇFÿ Y˜W¼9ôtÛj¶Á0ëŸS›cÛº?žÉ±hát-™¬ê}O!ÝG©TÚmsEuPÛ½˜XŒ.m;™ú7ßm™«ôOÊô¿F¨WÔhúÏÖ[‰ˆöÙÒzQ«.ëšç‘x}Ÿbf;™¶»pqr1mºë·þ›3š›«!%-×þ³ô+ú6^QÆÍÎÍ©ø¸”Qk-{î½¿gÇk…ovÆ:ëºÛ6TºJ6-8ÀîÖÚÁñÚ'ðY_[e}?ÀÓöj³±/Í´	ôè¦êò¬½Íÿ FÇÓ_¬ÿ ð4ú™B•´"G	)t’I%?ÿÓõT’I%)b}k˜˜Y…Á‡¨aÙ¸ö\Ì¿ö_2Õ¶±~¹{¾¬çÒêY“XÆ¡¿ðÙn&/ù¹7T’¥Ë]‡Ô1þ³äWõpÕ‹¿gu*ov=÷Ü÷Q‹µ•¸;
û‰–ì¬º?ý¯”º•‰Ó˜kú×ÖCõu¸øVÖg_Oõº=?ì]EÖ×’S6u~¶ÍÌÉèY±¤ø·ã[S‡g2Ì¼Ž‘ÿ nbÖ£öï­EÍÅéµtöHüë›cÀŸs›…Ó½v[íü×uu´’JyŽ£õK/!˜ùÿ mv_\ÃÈ¯+üeg¶Ü*±êkÛ‰‡Ï¦êýl½þ—ädú¨b}`úÙÕNe+ì+N5·ee+42Çµ•bcú—7Ò¶·ÿ 9Žº¥Çt³Òú-ý~®³™NCº¦FH¦ûÇº—2¯³ÛMn;îe´×íô¿âþšJKÒzŸ×¬ámÁ*ê±òoÅ¶¿Ö1Ý»Çcïe¿¯·ô›74£ŽÞ©õÊœK:–.>F§"Çäbú§&ÛíÅ±øõãÚF>=XŸhªËnþ‘ëúuUú?Ò(}\úËÑzuÔõ<Ù·[—•]y­v;ŸFEÖ_v?®ëï¯ü¦eŸ£ôÖÇÕ&Z:#-¶§ÐroÊÉeV{kÈÈ¿*íüÇ:›k~Ä”ÇþnäáÇì>¥v`‚0íhÊÅ i²ºn,ÊÇ¯÷)ÄÎÇÇ¯ý
Ng×V8†ÛÓ.iáæ«ê#ãW¯•»þÝ[i$§ô.£žc®u´cÀÝ‡YÆÇ~ŽkÛ”M¹9™5»ó?j«ÏðØÖ&­µôï­ÒÚÛN'PÀ¯0mklÁ}öý™­o±›ñs½Jkÿ G‰ú5¸±~°ï9½µÒž¤ƒÑ›ëÿ à¢Jv\Ö½¥®Íp‡4ê=ŠÆú—c¬ú¥ÑÜîF-ù5cèµYëýJÎ›Ò¯È åº)Â¨Ç¿&â(Ã«Üæ{]‘e~§»ù´~•€Î›Ó1:unÞÌ:k¡¯"…mm{È¿·rJm$’I)ÿÔÛÉ¿?'7ëp8ýo ÚÎœÇûqñO§™’ÍÕÙ·;öŽE¹þƒ×£ÒÅ¦«1_uÊÆëý''$·;§2›2ÚÃ“‘¥Yxþû×º·kêâ_²ÏFßR½ž†VBÅf/Y{*Á¯­ºªv5”ädábÐÆ‹z—K/êÖWS?Ñ¿"ëÃoIOh°³ŸWUúÅ‹ÓX[e=&3ó€ƒ¶çWÒñì÷}?}ùÿ CôeÄ³ü-k}RÎ:YÒpmiå¯ê™ïiþ»-Å±þÚÔÀè}^¶z5YÐ0ÚI&ºÞç8†7Õ»/;Òüß Î›ê}Ö’S¥ÖºÖCÀ~~{È¬Êë`Ýe¶;ù¼|zÿ Âßoæ·þ¹gè·½¡ag4ßÕ:«WRê=JòöQM{¾É‚×ýW«m¹7VßÒåd_³ôŠÂúåÐiÅú§ÕòÝ}ù¹æ~×’ðçµ}VzT2¦S‹S½?Ò3Š}oðþ¢ìÒR’I$”¤+1q­¶»­©–[Iš¬sAs	ÿ FçÌþÊ*I)g5®À2$LÝ:I$¥$’I)K2Ê¿çLªý­-Ø»ŒÜ_‰ê6¡ùÖÓŠË?ë6Ûÿ ·Ulþ›ƒÔ©m9µXÇ‹k2ZöXßæï¢êË-¢úÿ 2ê^ËX’œ¿¬FÜlî™Õ,¦Ìž€û]“] ½õ¾Æ
1ú‡ÙØ×Y“V-oÊªêêý%jûO§g ¶1òqò©fF-¬¾‹×mnc‡‹ÍÍräþ¬uo¬­è”u¶ž±ˆçÞË=6†æTÊ,»Ø6ÕÔ÷zßéý›/ýy¶+;',u/ª™øôf—¸çt÷•d8ÜìA]E¶ÚÏ³ý«üU95þ%;ýG¨U@±íu¶ØáV>=pl¶×YM[‹[ôZç½ïw¥ML²û½:j±ë‹X:Žu÷Õ~vF?Tªë¨gKéâ—¹­Û(Š.£"ì¬{=Kº‡P·§ôý–~Žº–‡RÇê™O¼›™GUÎÇ¥¸n{þÅ‚?MÔsk¾Ú›»+/ÒÅÂû]˜Øþ…¶ãzá~ÑÒàtì›Ž1°im7³F®?é-yý%Ö¿ü%Ö»Õ³ü"JÿÕõT—Ê©$§ê¤—Ê©$§é?­Ÿ`ÿ ›}Gö«ö/AÞ¿Ùöú»;ú>¯è÷ÿ ]k¯•RIOÕI/•RIOÕI/•RIOÕI/•RIOÕI/•RIOÕI/•RIOÑ_QÕœq[‹ÛëeÃœÝ¤þµ“ùÖmÿ =­Ìÿ UŸ·ÿ gzÑìûw¡»oò>ÕîÚ¾nI%?G}Wÿ šÛ2æöÉ–}£éú›vþ©ý+ôßcô lýOÒþˆ·Ê©$§ÿÙ8BIM!     U       A d o b e   P h o t o s h o p    A d o b e   P h o t o s h o p   C S 2    8BIM          ÿá:²http://ns.adobe.com/xap/1.0/ <?xpacket begin="ï»¿" id="W5M0MpCehiHzreSzNTczkc9d"?>
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
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                            
<?xpacket end="w"?>ÿâ ICC_PROFILE   ADBE  prtrGRAYXYZ Ï        acspAPPL    none                 öÖ     Ó-ADBE                                               cprt   À   2desc   ô   gwtpt  \   bkpt  p   kTRC  „  text    Copyright 1999 Adobe Systems Incorporated   desc       Dot Gain 20%                                                                                XYZ       öÖ     Ó-XYZ                 curv             0 @ P a    Å ìDu¨ÞRÐY¡ì9ˆÚ.…Þ9–öW»"Šô	a	Ð
A
´) •’–£,¸EÔeø$½Wô’2ÔxÆoÈv'ÚŽDü µ!q"."í#­$p%4%ù&Á'Š(U)")ð*À+’,e-:..ê/Ä0 1}2\3=455é6Ð7¹8¤9:~;m<^=Q>E?;@3A,B&C"D EF G#H'I-J4K<LGMSN`OoPQ‘R¥SºTÑUéWXY:ZX[x\™]¼^à`a-bVc€d¬eÙgh8iijkÑmn?oxp²qîs+tjuªvìx/ytzº|}J~•á.‚|ƒÍ…†q‡Å‰Šr‹Ë%ŽÝ‘<’›“ý•_–Ã˜(™š÷œ`ËŸ7 ¥¢£…¤ö¦i§Þ©TªË¬D­¾¯9°¶²4³´µ4¶·¸:¹¿»E¼Í¾V¿àÁlÂùÄ‡ÆÇ¨É;ÊÎÌcÍúÏ’Ñ+ÒÅÔaÕþ×œÙ<ÚÝÜÞ#ßÈánãä¿æièéÁëoíîÐð‚ò5óêõ ÷WùúÊü…þAÿÿÿî Adobe d     ÿÛ C 

ÿÀ …— ÿÝ  ³ÿÄ Ò            	
 s !1AQa"q2‘¡±B#ÁRÑá3bð$r‚ñ%C4S’¢²csÂ5D'“£³6TdtÃÒâ&ƒ	
„”EF¤´VÓU(òãóÄÔäôeu…•¥µÅÕåõfv†–¦¶ÆÖæö7GWgw‡—§·Ç×ç÷8HXhxˆ˜¨¸ÈØèø)9IYiy‰™©¹ÉÙéù*:JZjzŠšªºÊÚêúÿÚ   ? õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›66IR%/#QÔ“A‘]gógÊz-Eþ«iª&Voùgÿ …È¹ÿ 9uä}:¢Ú[‹æïˆHðW†s½{þs~CUÑ4<æZÿ É(•äöskþr»Ïz‘>•ÜvhfPÃL&“þ"‡çœoëõbôƒÙgtð1”IqæÝbçyï®d¯óLçõ¶’þâSY%v#Å‰Ä	®ç6,—³Æy$Ž§Ä1&/0êPïÔëOå‘‡ümƒ¡óï˜`þëS½Oõn$©ðÊÛó‹Î6ßÝë7ßMÃŸø“5¶ÿ œ‡óå·ØÕç?ë„ù8‡VŸó•Þ~·ûw±Ì?Ë‚/øÑlç3¼áÿ H‚Æaï©ÿ „›þ5É‡üç ”úî‘ž>œÌŸñ4—$ºüæî%>½¥ÜÅãéºIÿ ô2S¦ÿ Î^yîž´·6Õÿ ~ÀOü˜3d¿JüõòN¨@¶Ö-A=¯éù/éäÇOÕ¬õõ,gŠtñÕÇÞ„à¬Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙO"Æ¥Ü…QÔ†Eu¯Í*hµ†«i«ë+7ü‹Œ³ÿ ÂäXÿ œ¶ò.žH‚yï¾!oø”þ‚äXÿ œà³J+I–OžeOøHÒoøžB5ùÌï6]Õlmìí±Îß|ÃþIä#Xÿ œˆóÞ«_[Vš5= ãÆßðÙ	Õ<Å©jÇ–£u=É=å‘Ÿþ&Í…ê¥ ©9&Ñ?,¼Ï®Sôn—w2ŸÚ°_ùÀ'ü6tþqÏÌ0X¡ï<ÀŸø]³¤h?ó„ ZÕ]›ºÛÄÈÉYÿ äÖ~~Î9è>BòÀÖ4f¹’å.#GiXp`ê~HÇ÷žž%ÿ 8£ùmå:Ùj?§ì–êæÖXø³;­Eo‡Œn‹ö¢lôóžDŒQt{§‘ÿ ‰>/ÿ *#Èÿ õf´ÿ €Íÿ *#Èÿ õf´ÿ €Ä_þq÷È®(t{£ýM¥ÿ œmò½t˜ÇÊIGüF\?üâ·%5{'ú·ÜÎ y_°—Qÿ «9ÿ Õð¦ïþp«Ê²oåü7¿æHÂk¿ùÁí=¿Þ]^dÿ ^oø‹Å„7¿óƒúŠWêš¼xz²Ä^\_ÿ ÎùÆÞ¦Þk)Çù2ºŸù)ølj_óŒ~±ßôo¬¾1MÂúœÿ ár+ª~Tù¯K©¼ÒocQû^ƒ•ÿ ƒUeÈÍÅ´¶ÍéÎŽÌ?qË¶»šÕÄ¶îÑ¸èÈJŸ½ri¡~xùÓC ²Õ®J¯E•ýUÿ ¸õFtß-ÎiyŠÈ„Öm-ï£Y+ÿ Á/©ü‘Î×äoùÊŸ(y™–ÞêVÓ.›n7TOù7X¿äo¥‚)’dDÁÑ…C)¨ ÷›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ”Ìc@7$ç5óüä_“<¬ÍÅòÜÜ/X­GªÕð.¿¹Sþ¼«œwÌŸó›ÒS@ÒÀ¤º’¿òFÉüæÿ üåžõŠ¨¾‘ŸÙ¶SþJ0y¿ä¦sÍcÍz¾¶ÅµKÛ‹¢ßÒ»ÿ ÄØáZ©c@*NHôoËo2ëTý¦]Î§ö–ãÿ Ç‡ü6NtùÅ_>jT/f–ª{Ï2øXÚY?á2q£ÿ ÎkÐêš´"yOü?Õòo£ÿ ÎùrÜ†Ôo®îHìœ"Sÿ +ÃäãGÿ œgò—BºjÎãö§‘äÿ „gôÿ á2s£ù;EÑ@eµ­:zP¢½a¾lÙÍ?ç$tÏÒ>BÕc¥Lq¤ÃþyÈ’øUláó„Z—§­êvÿ }j’Óþ1¿ùŸžÂÍ›6lÙ³fÍ›6l}¥ZjéÞÃéá"sƒÍgòÉÅMÖ‘l¬ÝL*a?}¹‹9ö¿ÿ 8cå[Ð[L¸º²sÐr ÿ c"úŸò[9_šç¼Ë§“F¸·ÔPtSXd?ìdåü—Î%æ?*j¾Z¹6ZÕ¬¶“Ù•JÔ2²ëþR|8yäÍß3y%‡èKÙ#„˜ãˆÿ Ï9"ÿ ¬œ_ü¬ô7‘ÿ ç5-'ãoæ»&úí~$ù´}Dÿ a$¿êç|òŸæƒæèý]
ö­ªUŽ?×…¸ÊŸì“$9³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³`MWW³Ò-Ú÷Qš;kxÅZIX*›6ÙÀ¿0ç1ô]'•¯–!:•ÀÛÕzÇ>ßîéàc_ø³<Ùç¿Î¯4ùÜ²ê×¯õfÿ x¿wöôÓûÏùêdl‰iz=æ­:ÚiÐIs;tH»ö(	Î±åùÅ;kad¸‚=>#ÞæJ5?ã^¬Ÿðj™Ô¼¿ÿ 8Ce­ê’Ê{¥¼aüŒ”Íÿ &×:>‡ÿ 8»äM&ŒlÓÚ¸‘ßþ‹þIäÿ Fòn‹¢ º]µ­:zP¢½V¸q›6lÙ³fÍ‘ÿ Ì-7ôŸ—5;WÖ³ ÷1·Ç<eÿ 8¨ýSÏPEZ}fÞx¾åõ¿æN{·6lÙ³fÍ›6lÙ³fÍ›µß.iÞ`¶6Z½´WVíÕ%@Ãæ9}–ÿ )s‚ùïþpÏFÔ¹\ybåôùŽâ+$?%oï£ÿ ‚›ý\ó×ÿ  ¼ßäþR_Y4ÖËþï¶ýìtþfáûÈÿ ç¬ik©­$YíÝ¢•U•`ÉeÜg\òWüåGœ|·Æ+™×R¶_ØºšŸäÜ/äcIþ®w¯%ÿ Îaù_Xãµº\æ€–¤Uÿ Œ±Žcýœ+þ¶v­Ìv» »Ò®bº€þÜ.Â°~lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lØ\×ôýÙ¯õ[ˆím“«ÊÁGËâêßäý¬ó—æ?üæe¥¯;?'[ýbMÇÖ®XÇùQAðÉ'üôô¿ÔlóGœ<ÿ ®yÊãëzõÜ—N	*¬h‰_÷ÔKHãÿ `¸#É–aó´¾–…g$êR8Ä¿ëÌôŒ«ËŸù9é?Ëÿ ùÃ@·>nº7Rõ6öä¤cÙæ?½“ý‡£ž‚òç”´Ÿ,Û‹MÒHGQ¯»·Úvÿ )Ëa¶lÙ³fÍ›6lÙ³ceeSn¬?#Ÿ=ÿ &œè?˜ºt-±ŠøÛŸöE­¿ã|ú›6lÙ³fÍ›6lÙ³fÍ›6l‚y×ò;Ê^qäú„kpßîøu%|KÇOSþz¬™Àüéÿ 8Sy)ü­|³¯QÐàÿ %š:ÆçýhâÎæïË?1yAÊë–[(4õ
òŒÿ «<|¢oø<'Ñµëýqw¥ÜKk:ôx]‘¿àŒìþMÿ œ¿ó^‹Æ-]bÕ LƒÓ–žÓD8ÿ ÈÈŸ;¯“ç,üŸ¯ñŠþI4»ƒÚàU+þLñòJ•/¥ƒNÔíu8VêÆhî nSòdªàœÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6Õµ‹=Ùïµ)£¶¶ŒU¤•‚¨ÿ dÙçÌ¿ùÌ›;>v^M‡ëRî>µ0+>1CðÉ/úÒzkþCç˜|ÛçgÍ×&÷]º’ê^ÜÏÂµíkû¸×ýE\8òä÷™|öàh¶ŒmëF¸“à…ç«}º,^£ÿ “ž¡ü¹ÿ œAÐ4.~csª]ŠL‚°)ÿ ŒnoùêÜýõâÎÊ–ÚÒ4†TE
ª<Wá\[6lÙ³fÍ›6lÙ³fÍŸ<¼Þ¿áßÌ«™ÂßWõ‡ËÖõ—þ>†æÍ›6lÙ³fÍ›6lÙ³fÍ›6ll°¤Èc•C£
aPG¸Î]ç?ùÆ%ù£”†Ïê7-_ÞÚOx¨Ð7üŠåœ'Î_ó†îŸÊo.ÝE¨D7Éû™~B¥¡ùú¹ÃüÍäkÊòúÝ”ÖZ"§ýI?»ö‰y{Íš·—&úÎw5¤½ÌNV¿ëø_ý–v¿&ÿ Îey“Kã½:œ"€¸ýÌ¿ðqƒÈŸöYÝ|›ÿ 9MäÏ1ñŠ{†Ó®ì]+_i×”?ðn™Öm/!¼g¶‘e‰ÅUÑƒ)ä²íŠæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŒžxàF–f	Y˜Ð :–cÐgüÐÿ œºÑ´v>WQ©ÞŠƒ)$[¡ÿ X|WóÏŒñvyKÏ˜úïî~·¯]<äR>‘§üb‰~ÿ [í·í6	òå?˜¼ù7¥¡Ú³ÄwøbOõåm«þBs“üŒõWå¯üâ.ƒåîžboÒ—¢‡`Sÿ ¾ÔßóÛào÷Îw{{xí£X`UŽ4UP  vUS6lÙ³fÍ›6lÙ³fÍ›6xþrvÄØyÿ Q+·¨a”²Š:ÿ ÃòÏxhW¢ÿ O¶¼‰¡ŽOø%ƒ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lØå”±5½Üi4-³#¨e?5o‡9/œ¿ç¼™æ.RÛ@ÚmÃoÎÔñZûÀüá§ücXó…yËþpßÌºW)´)¡Ôá¢×Ò–ŸêH}#ÿ #ÿ Øçó•µ_.Íõ]bÒkI–T+_õylÃý\å<ëžV—ÖÐïg´jÔˆÜ…?ëÇýÛÿ ³\î>Lÿ œÑÖ¬xÃæKH¯ãï,_º“æWâ…ÿ Ø¤YÝü—ÿ 9#äÏ5qŽ+Ágrßî«±éø		07ûs§#¬Še" Áy³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÎcù©ÿ 9åïËõki_ëš˜ZÂA ÿ Åò}˜úß¼þXóÇ™¿ž~cüÁ¦¡7£aZ­¬5XÇ‡©ûS?ùR°TÈ×”<¬ùÂìXhV²]M·.#áPjY÷q¯úíž©ü°ÿ œ=Ót®Þo_\Š«ÆH…OùmðÉ?ü“ü—ÏDYXÁa
ZÚFÁâ‰…U
«ð®-›6lÙ³fÍ›6lÙ³fÍ›6lñüæ]‡ÕüåôÚâÊ&úU¥þ4\õgäíÿ ×üŸ£ÜRl SóTXÏüG&³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³`]OJ´Õ!6º„1Ü@ÝRT§ý‹‚¹Ç¼åÿ 8“å{”ºzÉ¥Üë¬u÷‚NKþÆ&‹8Gœÿ çüÙ¡ò›JôµKq¿î	iï¿ª9%Î5«h·º<æÓR‚[i×ªJ…±pH<›ù¯æo&°ý	,1ýÑ<â?óÂNQÿ ÂòÏBþ_ÎhÃ3%¯œ-}Ð}fØ¿ëInÜœÏ'“þ1ç¤´0éþ`´MCI¸ŽêÖO³$l|¿ÉaûJßá†lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ°³Ì~fÓ¼µdúž±:[ZÇöÍ>J£í;·ì¢|mžEüÝÿ œµÔuïSLò—;Ukƒ´òò)þó¡ÿ '÷¿å§ØÎmms©\,0#Ïs3QUAgv> U›=#ùSÿ 8{u}ÃQó«›h´Œþñ¿ã<¿fõ”ŸåDÙê.ycLòÕ¢éÚ5¼v¶ÉÑ#ßù˜ý§òßâÃ<Ù³fÍ›6lÙ³fÍ›6lÙ³fÍžDÿ œà²á©é7”þò	£¯úŽ­ÿ 3³µÎ2_ýsÈaï–3þÆY ÿ …Î£›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ°³_òÆ™æ¦±kÜ'öe@Ôÿ W—Ù?å.pÿ ;ÿ ÎyTå?—g“MœÔˆÚ²Ã_“ŸY?äkÿ ©žhüÆü—ó'åû×W·åhMæ/Ž&ðøÿ Ýl’UFÂ¿"~cë~F¼ÚÃBÇíÆwŽAü²Åö_ýo¶¿°ËžÑüœÿ œŽÑÿ 0X]RÇY¥=o†CüÖÒµÿ ›÷¿ñ“íç]Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÏ?7¿;4ËkNWGëŒ«XmPüMþ\‡ýÕùµþëWÏ~bþgë^¾7úÔÅ”éBµDìÅüIÛ÷ûM‡?•?‘z÷æ4¡ì“êúršIw(<>ÒÄ:Í'ù)ðÿ ¿3Ú_–’¾_ü»„2/Rõ…$º–†Vñ
ÝQÿ Åqÿ ³çö²{›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ2ÿ ÎpYrÓ´‹ºw<Ñ×ýuFÿ ™Y)ÿ œ;½úÇ’}*ÿ qy2}â9æfwÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6%wiäOor‹,2®Ž+ÕY[áažcüäÿ œEŠq&¯äp#“v{?Ì,öüS'ÁüŽŸc<­wiu¥\µ½Ê=½ÔFV]}¾Ò²ç¥ÿ #ÿ ç,ÛÓÐüîåâÙb¾;²ø-ßó¯ü_öÿ ß¼¿¼_WÛÜGsÏ,‘8¬¤ ôea³)Å3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6læ¿ž_œ¶¿–ÚW¨¼eÕnA[hy¥ïèÇÿ %÷kûLž×µëï0_Kªj’µÅÜíÉÝº“ÿ ªý•EøU~ÏD~EÎ+>ª±kþsFŽÔÑâ³5W~ËÜþÔqŸ÷×÷û|?oÖÖVPXÂ–¶‘¬0D¡QU¢ª®Ê1lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6là_óš^·”mî;Ã}ú9—þiÂßùÂ;Îz¥kþû»Wÿ ƒWþeg£ófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³g5üßü‰Ñ¿1íÌ“mª¢Ò+¤íöRuÿ wEÿ Ÿî·\ðçæåÖ±ä=@éšÜ&7ÜÇ"ï‹þü…ÿ hÃ§íªäçòGþrRü½•tûîWš#Š~(«ÖKbßðÐÿ vÿ ä?Çžßò¿štï4ØG«hÓ­Å¤£áeì{£¯ÚIö‘¾%Ã\Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6C5?4´ÏË­)µ=Dó™ª¶ðG•ÿ ••ýÛ'ì/ù\¾}y×ÎšœõIµ­^ORâcÐ}”Qö"‰f4ýŸø&øÙ›=ÿ 8¹ù&ô¼éæ8«£Y@ã¯…ÜŠgþY×þ{¾óÕù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿ œ³´õü…vô¯£4ÿ %?ù™œßþpróþ;V§þ]œÉu9ê¬Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ°‡Î¾FÒ|é§¾•­À&·SÑÑ»IõG_ùµ¹.x_ó—ò'Uü·¹2µn´‰‘\¨é^‘N¿î¹á$ýÚD(ü¬üÜÖ?.oþ·¦?;iõíœŸN@?âØ•~%ÿ )9&{Çòßó7HüÁÓWSÑäÜPMSÔ‰¿’Eÿ ˆ?ØÙÉflÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›!ßššZWåÞ˜Ú–¦Ü¥jˆ R9Êÿ Ê¿Ê‹þì“ìÇþ·oþaþaêž}ÕdÖ5w«·Ãkö"Jü1D¿Ê?à¾6Î¹ÿ 8Ýÿ 8ðþi–?3yŽ2ºDg”0°§Ö~ÓË²ùö>Ç<ö‚"¢…P@@2ófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÎmÿ 9mõ êÉá?ü‘¿ükœþpŠçŽµ©Ûÿ =ª?üñÿ ™™ìÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³`]SKµÕ­d°¿‰'¶™JIŠ«Ù†x³óëþq®çÉfMsËáî4Bjëö¤·ÿ _¼,¿±þíÿ ~?'òOžu_%j)«è“gMˆê®¿µ©ûq·üÜ¼_âÏx~N~ué™V<à"N%½«×þ,‹ýù7ìý™?Êè¹³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœ÷óƒó£Jü¶±õnˆŸQ•OÕíTüLžO÷Ü*~Óÿ ±“gƒ|ñçWÎÚ”š¾µ)–wÙ@Ùf(“ö#_ù¹¹?Å‹þqÛþqÆO5¼~có,f=O(¡j†¸#¿ù6ßå»¾Ê|?{>RXaP‘ 
ª¢€²ª¨è£›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6l„þwCëy+Y_)›þyÿ Æ¹æùÂË‚žnº‹³ØIøI{S6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ²¤dRŽ+" ƒØç’¿ç çÍˆ—ÌžMˆµ¸«ÜY ©Ní-ªþÔÍìºþ<å y‚ûË×±jšTÍowrGC¸öÿ )[ì²7ÂËð¶{›ò'óþÇóÜX^ñ¶×"Z¼U¢ÊY­ëÿ Ûü¤ø³®æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÎ)ùãÿ 9%§ù$Òtr—zå(VµŽjz}©?–ÿ =8~ß‰µÿ 0_y‚ö]OU™î.æ<žG5'þiUý”_…g=ÿ 8ÿ ÿ 8¾ú¥æ?8ÄR×g‚ÍÅÖK•ý˜¿–µ'û³÷ž¸Ž5‰Dq€¨     t c³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›"ßš‘|§¬ êl.zÿ Æ'Ï#Î¿;üÖsøhÎ{‹6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ5ÿ ÎAÿ Î1¦±êù“Ê¾Ýç´QA/v’û3ÿ 4foÙýï÷žJ´¼»Ò.–âÙÞÞîÝê¬¤«£©ÿ ‚VSžÕü€ÿ œŽ·ó²&‡¯2Á®(¢¶Ê— ´’ç‹ö¾Ü_´‘÷LÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ±ëè, {»É"RÎîBªûLÍ²ç”?;?ç,¤¼õ4_$3Gë%õ(Íâ-Tïÿ ÅÍûÏ÷ß·žk²²»Õ®’ÚÕâîw¢¢‚Îì}¾Ó1Ïa~DÎ.ÛùsÓ×¼Ø‹>¦(Ñ[ìÑÂ{3þÌÓùìóo=›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³dCó‚ìZy?Y˜šRÆà},Œƒñlòüá¥«Kç9eáŠÆRO…^$ÿ ³Û¹³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6là¿ó_óðùÅd×üº«´£”‘ôKŠxöKå“ìÉöeþuñ|ð]iWF)CÛÝÛ½5WGSÿ ŽžÂÿ œyÿ œ”Ì‚?-ù¦@š¨¢ÁpÔ?‚IÙ.äÿ üdû~ˆÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÏ4?<¼½ùyMB_^üŠ¥¤D~É“öaOòäÿ `¯ž0üÔüñ×¿1¦+~þ†ž¦±ÚDO¦)Ñ¤ý©¤ÿ -ÿ çš&þ]~Wë~½Z,%•Hõf}¢ŒxÉ'üE”û+žÞü¡üŠÑ. @>³ª:Ò[§ÿ i!_÷L_ðïþìvÎ“›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÎkÿ 9#p`ò¬Ãbcà¥‰?ãlá?ó„6ÁµRãºZÆŸðOËþeç°3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³~}ÿ Î=Ú~`@Ú¦–ß]‰~è³Ò)ÿ Ëÿ }Íû?aþ±áÍSJ¼Ño$°¿íîíß‹£Š2°ÿ ?‡=Sÿ 8óÿ 98/=/,ùÆjO²[Þ9Ùÿ –+–?îÏä›ýÙþìøþ)=?›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6%yy”/stë1©gw!U@êÌÍ²®yGó›þrÞYÌš?‘ØÇª½ñÌ*7Ø_ø¹þ?äTûyæg{Fà³—žæfÜš»»1úYÝŽzòþqPÖJj^q-cg³eÚgñgü³¯ü–ÿ &?µž¶ò÷—4ÿ .Y¦™¤@–Ö‘}”ŒP¬{³·í;|mûXc›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœŸþrø~_ê>ín?ä´YÉ?ç#­Ö²þÛ¼Íÿ 4ç¬ófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿ œü¡Ñ¼Õ£\k×.¶z†ŸH.i³"^„ào"Ÿ÷Wí£ýŸÚFð~w¿É_ùÊMCÊB=#Ì|ï´‘EI+Y¡ä–þú%ÿ }¿Ä¿î·ÿ uç±¼¹æm;Ì¶I©èó¥Í¬ŸeÐ×~êÃí#¯í#ük†y³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ› ëzÝž…g.§©Ê°Z@¥ä‘Í øÿ *ý¦o…sÂÿ žŸóÿ ˜—adZÛC‰¾kF”Ž“\Ó¯ù}ˆÿ Ê!Ÿ—_–zÏŸïÆ¢ÅÊ”2ÌÛGŸÚ•ÿ â(¿þÊç¶ÿ ) t/ËÈ–xÔ]ê¤|wR(¨=Åºoè'ú¿¼oÛ“:vlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÉ?ç*ÿ ò_êëÛÿ Éè³•Îÿ ­ÿ ©kúçÏXfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ5Îf~b}GO·ò…£ÒkÂ'¸¡éÝ!ÿ Œ³/?ùãþVFçÿ ç´ß8ùbëTó
:µóð³‘5ŽªÓ§ì·©/$âêËÆ/ò³–þlþEëŸ—3º_¬éŒiÜ`ð5è²¯û¦Oò[áo÷[¾~_~fë~B½úö‡9JÓÔ‰·ŠAü²Çßýïö=§ùCÿ 9¡þ`ªYÈEŽ¯Míämœ÷6Ò»ã÷¿ä²üyÕófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ€u½rÇC´“PÕ'KkX…ZI þ­üª¿~Îx[óóóâçóóêV<¡ÐíÚ±Fv20Ûëæÿ }Çþë_òÙ°‹òwòwRüÊÔ¾­mXl! ÜÜ‘²äOç™ÿ a?Ù7Ážøòg’´¿&éÑé,"xú÷goÚ’Wý¹ù¿à~<Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6r_ùÊ•-ù¨S³[Ÿù-rùÁ·çZ^å-ÜgÏXæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³`}Bþ:Ú[Û·Á4’9èª£“±ÿ Usç®«w¨~qyà˜ª%Ô®Fþœ#e¯´éÎOömŸA4-ÛC°·Ò¬W…µ¬kcü•EÊþl{eô/kuË€«£€ÊÀõVVÙ†ysóþq¾¦­äov{?õ#É™?ØIöcÏ.ÝZÝiw-Â=½ÔFV]xƒFF\ô?äïüåµæéé>såwf>»Ìƒþ.ñðŸå}ÿ sÖÚ.¹c®ZG¨is%Í¬¢©$f ÿ oó/Ú\›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³`MWW´Ò-žûQš;{hÅ^I*îÍžrüÌÿ œÈ³²çeäØ~µ(¨úÔÀˆ‡¼Pü2Kþ´žšÿ ’ùæ?8yû[óÏ×5ë¹.ž¿cD_h¢ZGûÃÊËk¯ÌMr=ÖE„q2Ë#~ÌjT;*þÛükÁ?â+ŸAü•äÍ7Éº\Z.§mëûNÇíË+~ÜûMþÅ~8y›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙË?ç'â2~_ê”ý‘û¦‹8ßüàóRÿ X^æÜÒg­ófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÏŸó˜_˜ß¡tHü±hôºÔÏ)hwXïÿ #äø?ÊD™r9ÿ 8aùuÅ.|çv»µm­kà7¸”}<aVÿ &eÏSfÍœ÷óSò?AüÅ€›øýAE#»ˆPS¢ÉÚhÿ ÈùæÉž)üÐü™×¿.®8j‘ú–niÔ`˜ßØŸ÷TŸñ\Ÿì9¯Åÿ -?6µÏËË¿¬èòÖ Ënõ1H?ÊOÙå•>?ö?{ò—ó“HüÉ²3éçÑ½ˆ^ÙÈæŸå/ûòû2¯û>ðä÷6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³þoÎLhžEç§éôÔuuØÄû¸Ïü¼J?h¾S÷ŸÏéçŽüÿ ù¡¯yòçëZíËH Õ!_†$ÿ Œq‡ý›r‘¿iñþ@ü©óŸ'ôt;V’0hó¿Ã¯)Ûý‚s“üŒô]ŸüâV‘åŸ/ê–³+jœVs¼ajÆâ7dd_·+#~ÔÃþ*Îeÿ 87§ç„_çµâ/ÿ ç¹ófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6s_ùÉýO êÂ•¤qŸºX›8Wüá´Ö5Hë±¶ŒÓäÿ óvzÿ 6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ‰Ü\GmO3Ž5,ÌM  U˜ü†|ôóÆ»}ù»çf{ Y¯g[{U?³<"åü£f—ýi3ß>SòÕ¯–4«]ÄRÞÒ%|M>Ó·ùR7'ò›³fÍu=.×U¶’Æþ$žÚeâñÈ¡•ìÊÙä?ÏoùÅ©<¼’ëþQ6žµy­MYâYâ?jXWö—ûØÿ âÅåÃƒù[Í:‡•µµ}"SÜªÃ¡´Ž¿·ý—FûYôòoórÇó+I°ô4[«zîŒiš?ÝmþÃí#dû6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6l¨júu¼——²,6ñ)w‘ÈUUY˜çÿ ;ÿ ç*nõÖ“Eò{½¶ºÉr*²Ëãé~Ôÿ Égÿ ŠþÆyÿ JÒo5›¤±Óâ{‹©š‰`³1ùõOå/üáô6á5?;°–]™l£o€ÌD«ýçüc‹àÿ ‹$ÏKéÚm¶›YØÄ[Ä8¤q¨UQàª»	æ‹¬é7uõ-å_½sÃ_óŠ—>Ÿìÿ »á?ä”ÿ ç¾3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6sÿ Ïø½_"ë
7¥±oøVþçoùÂYiæ=B?æ²¯Ý,_óV{'6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœ/þrÛóü9å±¢Z½/5bc4;¬+ýûÏO†õ^OåÎ}ÿ 8cùuõ‹›Ÿ9]§Ám­j?m‡úD£ýHÊÄ¿ñ–OåÏZæÍ›6lÙãßùÊÈ%ÐÝüßåØ¸ØHÕ»Ñ1?ßÆ£¤7Û_÷Sÿ Åoû¾1ùeù‰äjkO5
xÍh²Æ¼‰¿âHß±'Ï¢¾Vó-—™ôÛ}gLRÖé¡î?™ù]àuý—\4Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6Ôµ+}2ÚKëÙh¼’9¢ª¨«3ðŸçßçíßæÑÓôòÐhP·îãèf#¤óÿ Ì¨¿Ýñ“"–_•šÇæ 4ý!)PÍ;×Ó‰Oí;wcû¯Æÿ êòe÷Oågäæ‰ùsièé‘ú—Ž šê@=Göÿ ŠâþX“ý—7ø²u›4bThÏF}ùóãòÎ›ù…¦!Ø­ÓÅÿ ²Cÿ gÐœÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ¿Î˜}o%ëIÿ .3Ÿ¹òßüá|ü<áq~Ý„½ü$€ç¶3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÄ€*v>|~pù¶çóCÎ²~Ž¬±¼«gdƒº†ôÑ‡üf‘šoùéžèò”-ü¡Úh6”)kRÃöœüRÉÿ =$f|?Í›6lÙ±+Ë8oa{[”Y!•J:0¨eaÅ•‡ò°ÏŸŸ•2~]kïg'M¹¬¶Žwø+ñDÇùào¿Èôäý¼éó‡¿š¦j/äëçÿ E½&KjŸ³0cÚx×þFGÿ g±3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6xïþrÓó•õkÖò^“%,­X}m”ÿ y(ÿ tÿ Æ;Úÿ ‹ÿ ãç"ü©ü°Ô?1u„Òl~Vq9X£®íþS·Ù‰?mÿ ÉæËôÉHÓ<—¦E£hÑíã“»;~Ô²·íÈÿ ójñN+‡Ù³fÏžza:æl`ü"ßZãôŽ?ñú›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ²9ù•oõ,jÐÒ¼ìnGü’|ñßüâþ—ž?ß–³¯üEÿ ãL÷>lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœ¿þrGÏá/']Éñ»½ÿ D†‡zÈªÃýH­_çãžÿ œ8òÕõé¼ÇrµƒLJG^†iAU?óÎ/Pÿ ¬ñ¶{C6lÙ³fÍ›9güäåúyÃÊW&5­í‚›¨€Vhÿ ç¬<¾÷ç§ü¹à'TŸI¼‡Q´nÒ$±°ìÈy©ûÆ}6ò¾¿˜t»MbÛû«¸Reöæ¡¸ü×ìážlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›!œÞ_"yfïXRÏJÜó?ÃÏ‡Å+‘gÎ‚f½ž§”³Ìþå™˜ýìÌÙô7ò;òÂËß/C`T}~p%»~æB?»¯ò@?vŸìŸöÛ:lÙ³gÏ_ÎÈÎ‰ù‰©J61Þ­Àÿ eÂãþ7Ï¡Ê²¢È›« GÈã³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³bsÜÅn9Lê‹âÄøá%ïæ—lkõ½NÎ*uçq?‹áßçÏ‘í?¼Ö-OúÏþMÂKÏùÊ_ [l5)ÿ "	ëFÜÿ Îaù"±õÉÔ„ù8ñáEÏüæÇ–h,oŸæ"_ùšØ[qÿ 9Á¦¯÷Díþ´Ê¿©$ÂÙÿ ç9¿¹ÑE?Êºþa|¿óœ™ºÒ`SþTÌãDÀ’ÿ Îmù€ÿ w§Y¯ÌÈãuÀÒÎkù¥	e`¾¦Ÿò[µOùÌ/6j6³YKob#6"9+Å‡¥fð9Ë¼ç»ÿ #jÑëºP®bWP%”‡RÉU÷þlêÿ ÎcyÙÍTY'Êÿ ¥lÿ ó—>{n“Û¯Êþ8‹ÎXùøš‹È‡°·‹þhÄOüåWæÿ ¥‚Ò<?õK7ýWæý\þ‘áÿ ªY¿èj¿0?êà¿ôýRÍÿ CUùÿ Wÿ ¤xê–=ç+¼þ¢†ú3ó·‡þ©âÉÿ 9içÕ ¨[ÜÛÇüGÿ 9}ç”ë%«|àñ«.
‹þs+Î‰ö£±œ/ÿ Ì¸:ùÍo5/÷–VþÂQÿ 3°|ó›ÚÐþûKµoõ]×õóÃ+oùÎ9‡ûÑ¢©ä\‘ÿ °ÖÛþs‡No÷£H?Ô™[þ$‘áµ§üæ·•¤ÚâÊú?’ÆÃþO.ZÎ^ùï$¹‡ýx	ÿ “FL<²ÿ œ–òßÙÕQ	í$R§üN:aýç“ï¶·Ö,I=Œè§îv\ÙkÚ}þö—0Íÿ äVÿ ˆœ›6lÙ³fÍ›6lÙ³fÍ›6x›þsÏŸ¦üÈš»VÛJN-N†i(òÿ À'¥ù/êg¤?ç¼‰þò¥¬«Æîè}jr Uþ1EéÇþ²çIÍ›6lÙ³fÊt
°ª‘BqŸ5¿4|¤|¥æ]CD¡ÛÎÞßmûÈ?ä“¦zÇþpëÍÿ ¥¼­&+Vm2b ÅrÖXÿ ä§¬¿ìs¼æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›<sÿ 9Ÿçƒ¬ÛybýÍ‚zÒþý”| ÿ Æ88ñÿ ŒÍ‘¯ùÅ 3y­u…åi¥(¸jô2“ÆÙàùMÿ <sÝy³fÍ›<+ÿ 9w¦ýSÏ2ÍJ«h%û—Ðÿ ™9ìËLjž[Òï«S5œ~f5åÿ ’,Ù³fÍ›6lÙ³fÍ›6lÙLÁEXÐç#Ú¿æ?–ôjþ‘Ôìà#ö^tÿ Ë–BµoùÊ?!iÕP7;Cÿ Qcÿ ‡Èv«ÿ 9¯åÈ	7—t/Â0áåoøLˆjóœïQ§éÆ;fgü!ÿ ‰dSQÿ œÄó­Õ}ª[ÓÓ„’?äsË‘}Gþr;Ï·äúš´¨h–8ÿ äÒ!ÈÎ¡ù“æmD“yªÞË^Íq!ð<é„7“\žSÈÒb^#ŠÃm,æ‘#9ðPOêÃk_$k·Ÿï6w-’	þ"˜skù/ç;ª´kÚí¯üL.[Î8ùúãìi2Šÿ ;Æ¿ñ9-ÿ ç|ý-XÇšâ/øÕÛaÿ œ=ó¼ƒâ‰þ´ÿ óB6ƒþp·ÍÏýåÍ‚ÏIüÈÁÑÎùˆÿ y¨Y—ªæZà˜ÿ çuƒNz¥°ñ¤næœ]çµ
üZ¼ {@Çþfcÿ èGoêñý#·ýUÅãÿ œ”ï&´£Ùm‰ýsàÈÿ çí‡ÛÖœü­€ÿ ™øºÎiÀ|Z¼Äû@£þfTÎi4ßU¹¯ücOë—ÿ BA¤ÕÖçþE¦oú#þ®·?ò-3Ðiõu¹ÿ ‘iŒoùÁý,Ÿ‡V¸Þ$?ñ¶"ÿ óƒ¶DžÌ v­ºŸùš04¿óƒi·§­ŸzÚÿ ×ü/üàåØþïYŒüíˆÿ ™Í€æÿ œ!Ö÷Z¥³ò£qú¹á|ÿ ó…iAX¯læÒù’p²ãþpçÎÑ}ƒg'ú³øÞ4ÂËŸùÅ?CR¶QÉOä¸‹þ7tÂ{¯ùÇ_>[}½"cOähßþM»a5ïå›ì·ŸG¾P;‹yûÕNÞyoS²ÿ z­'†ŸÏ¯üIp¸‚6=s+5„a¾ŸçkN§Ô¯î §ûîg_ø‹d£NüþóÎŸOGX¹j¿H—þO¬™,Ó?ç/|ñiO^Kk ?ß°ÿ &9/Ò¿ç7õ jZLŽæZ?ÂEŸ&zGüæ¯–®(º…•å±=Ô$Š>žq¿ü&MôoùÉ!ê”©,ftxÿ áÝ=?ø|hþmÑõ —{otûæTøƒ6æÍ›6lÙ³fÍ„^{ódQÑ/5Ûª´‰œûMöbþzHQ?Ùg…ÿ %|©?æOá:…fŒÊ×·Œ{ª·¨Á¿ã4Ì‘ÏLú›6lÙ³fÍ›6yþs[ÊVÔì<ÉüQ›yHþxþ8É÷xßüñÈ¯üâ?›ÿ ByÁtùZjq4Ãšþúÿ ñ¯üeÏsæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ‰^]Çg—3·¢VwcÙTrc÷gÌ¿:ù–_3ëWºÜõåw;ËCÙIøý‚qLöüâo“FäøïåZ\jŽn÷à?wn¿êð_Uã.vŒÙ³fÍžEÿ œßÒLzž•©´°K	?ñ–Aÿ 'ó³ÿ Î1êÿ ¤ü…§jð	 oö?ù'Ã:žlÙ³fÍ›6lÙ³ce•!S$Œä“@>œ„ùƒó»ÉºVûV¶æ½R&õ[þßÕlçïüæ•lêºm½Ýë‡ŠÆ‡ý”êÉ,çzçüæÖ·=WIÓ­­èfg”ÿ Âý]€k_ó“>|ÕjRkt?³n‰ü:¯«ÿ %2	«ù»XÖI:õÍÑ=}Y]ÿ âlp£4¯'ë:½css_÷Ô.ÿ ñ91Ò¿ç¼ù©SÒÒ¥Œó2EøLèßð¹/Òÿ ç|åuCu%¨ïÎVc÷E¯ü6JôÏùÁÛ†¡Ô5„_¿ážHÿ â)Ó¿ç
<·íõìÇÁqù7)ÿ †É5‡üâgíiêZÍpGûòwÿ ™F,‘ØþAyÊž–liþüS'üži2Ceä.ØSêšeœTéÂÞ1ú“`´†Üq…‚€?V+›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6l{åý:ûk»X&ýù·üIr;¨~Ny:þ¦ãG²$÷XßC‘­GþqwÈ7»8ÂÞ1M*ÿ ÂúŒŸð¹Ô¿ç¼§q½¥Íí¹ðæŽ>ç‹—ü>DõOùÁÖÜéÚÀ>4ñ¼rÿ Ì¼‡ê¿ó†žp´©´–Îé{‘•¾écEÿ ‡Èf­ÿ 8ñç½.¾¶“4€w„¬¿òa¤l„êž^Ô´“ÇQµžÙ¼%“þ&«€QÙe$ÐŒ•hšþkÐ¨4íVî%ÕfOù'8ÿ ás¢h?ó˜tÓ¨·¦Úý_V.-ÿ naÿ ˆgIò÷üæîŸ-\Ó%„÷{yAÿ "åôOü;gOòçüä‡‘µÚ,Z’[Èbä¿áäü”Î‹eo}žÒTš&èñ°e?ì—l_6lÙ³g–ç4üÿ Å-<ŸjÛ·úUÈ©oÿ eêHËþLM’ùÃß þ…òôža¹Z\êT¯Qd¬ò2OQÿ ÊOK;ölÙ³fÍ›6lÙËÿ ç$ü¡þ&òUòF¼§³î?Å¼Ÿ|UÏèš¼Ú5õ¾§ji=¬©2ò‘ƒ¯üG>œh:Ä:Õ…¾©jkÔI2ªêâX;6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœ¯þrkÍ_áï$_n3^ñ´Oùëýïý;¬Ùá/h³kš¶•m¼×sG
üÝ‚ÆÙôçJÓaÒí!Óí‡mãHx* ‹ÿ 
¸+6lÙ³gŸç4´_­y^×QQV´»P}–Eeoøu‹ÎkXÐu)MµÐ”•ÿ Ä |ônlÙ³fÍ›6S0PY Ü“O4~zy7Ë<–ÿ S…¥^±Â}W¯‡=N?ìøç#ó7üæÖ›(ô:[ƒÐ=Ãˆ×çéÇë;ÁGœ§ÌŸó–~vÖ*¶ÓE§Æ{[Æ+OøÉ7¬ÿ ð<s˜kžoÖ5ö/«ÞÜ]“¿ï¥g@cA…–öòÜ8ŠiôU“ô›è?‘~t×hl´›Ñ¥_Eà®YÑt/ùÃ5^Qµ+‹K5=G&‘Çû×Óÿ ’¹ÐtOùÂ=[S¸¸=Ä(‘ø¬žhßó‹¾CÓ(ÆÀÜ¸ý©åvÿ „‘ÂdçHò—´j~Óm-Èï(§þ/,>›™³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÆËJ¥$PÊz‚*Dõ¿Ê/)ku7úM¤Œz°‰Q¿äd\þ9þ¹ÿ 8ä­B¦ÍnlXôô¥ä?ànßñ,ç:ÿ üáÚU´]V9<â"ŸòR#/üšÎiæùÆ/=hµo¨}n1ûVÎ²É?†où%œßTÑo´™=FÞ[i–Td?ð.Ñ¼Å©h’úúUÔÖ’õåŒ‡þ®uO+ÎXù×Dâ—SE¨Â?få*ÆX½)?àùçcòŸüæž…{Æ-~Îk=^"&éþîUÿ c™Ú|«ùåï6(mþ¦"¼Àqþ´/ÆUÿ d™#Íˆ_ßC§ÛËytÂ8 F‘ØôUQÉÛýŠçÏ;‰/8<ôxÔIª]Q{úpŽŸò"Ù?á3èV—¦Á¥ÚCaf¡-íãX£QÙPpAÿ 0NlÙ³fÍ›6lØÉ¡IÑ¢”GX„ˆÏ™ÿ ˜W*ë÷Ú×ýwE¯t¯([ýœE=‹ÿ 8‹æÿ Ó~Pt­YôÉZwôÛ÷ÐŸøgãvìÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžOÿ œÝó/)´¿/¡ÙK©úÇÑ‡þ!>@ç<±úgÎÐÝ:Ö->).O‡*z1ÃËÏý†{»6lÙ³fÈçß—ÿ Oy'U´QÉÒ:Žõ„‹¿ä_óWüá˜~£æ›-ÍúÕ¨<^"$_ù$fÏjfÍ›6ldÓ$e•‚"Š–c@¹9Ë¼åÿ 93ä¿,rˆÝýzákû»Aêoÿ ª¶ÿ òW8w›¿ç4õ«ÎQyvÎ+(ûI1õdù…ø!_öK.q4þgy“ÍdþšÔ'¸Cþë.V?ù¿á2=ki5Ü‚diem‚ ,OÉW|èþXÿ œnóÇ˜(ñiïm~ÝÑøý÷üYÖ|µÿ 8C+QõýQWÆ;Xëÿ %¦ãÿ &3©ysþqcÈÚ5KG½~ÕÌ…¿äšzpÿ É<éZ7–t½=-*ÒDéHcTÿ ˆÃ,Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍµ2×QˆÁ}sÄz¤ŠOûg5ó?üã/‘õú±±úœ§öíXÇÿ $þ(?ä–r5Î\FO.jK'„WHTÿ Èèyƒÿ "W8Ï›#<áå^O¨éÒ´+ÖXGª”þbðóáÿ =8d9^(êj4 çQò_üä·œü¯Æ1wõëe§î®Á“oij³¯üãþNwï#ÿ Îdy{Vã˜a“LœÐ½†¿ë õSþE7úøŸüåæå‚ùN=?BºŠåµ†áÎ)F›téÍ½8¸ÿ +I‘ŸùÂß U®üát»
ÚÛWÇg¸É8•¿ã*ç«3fÍ›6lÙ³fÍ›<mÿ 9£å¨kÖž`‰iü>œ„¿!Ú§ýh^5ÿ žx[ÿ 8wæÿ Ñ>j}V¤:œ% íêÅY£ÿ ’~ºÿ ²ÏmæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸ?¿ç&¼ÃúkÏZSXíJ[/·¦ Iÿ %½\íó„~]ôtÝO\q¼ó%ºh×Ôz¬Ó§üzg6lÙ³fÄî-Òæ'‚QÊ9«ÜB3ç–n$üµóü^¹*4Ûó„÷‘‚Fÿ e3gÑ A3fÍ‘:~gywÉqúšíìVïJˆ«ÊFÿ Rå!ÿ [óÇž¿ç5d~VþR²7âïsóKxÏþÎVÿ ŒyÀ|ßù™æ/89}rúk…&¢2ÜcêÁ—þ	ômP×'šU´·Sž‰
3Ÿ¹ÎÉåùÄ6ë!eÕ:\'Þ·9)í5_ö2KvÏ)ÿ ÎùKHã&ªÓêrŽ¢Fôãÿ ‘PÑÿ àæ|ëú”t.ÇèèöpZ%)û¨ÕIÿ Y”roöXm›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ²çÉÏ*y¼3jú|/3»zr|ýX¸;³åœ#Îßó…rŸÊ—õêDcð[ˆ‡üJöyçÿ 9þWyÉŽW]±–ëA-9DÕš>Qÿ ±åË"¹è¯É?ùÊx<Ÿ§ÛùsZ±P€Ií¶qR]šXœñ•‹7&dtÿ Q³Õ¾QóÖ‹ço®èWqÝEûAOÄ¾ÒÄÔ’3þºáîlÙ³fÍ›6lÙ³‘ÿ ÎRùCüEä«™c^Séì·iãDøfÿ ’#ÿ °Ïù[_›ËÚ­¦±oýí¤ÑÌÇý—ÙÏ§n¡£mí³r†xÖDoaÍOü	Á³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÄ®®RÖ'¸”Ñ#Rì| Ž|¾×uGÕõJ_·s4“7ÍØ¹ÿ ‰g¾?çôÐÞEÓPŠ=Â5Ã{ú¬Ò'ü’ôó§fÍ›6lÙ³Ä¿ó˜žN:GšSZ‰i©b{z±£þEú/þË=1ù	çQæÿ (Xß;r¸…>­?©ÁVÿ Œ‰Â_ùé ˜¿ž~Xòhõ;‘-èZÁG—ýš×Œ_óÙÓ<»ù‡ÿ 9mæ_1¶Ñ)¤ÙšÝžSþTçìÏOõÛ8•ÅÄ×’´Ó»K4†¬ÌK3âÇâc7ÈŸóžoów–Ûê6mCë]V0GŠEOYÿ ä_òóÐ¾Hÿ œ<òÖÆmvI5KBTþê*ÿ Æ8Ï¨ßìåÿ a·EÐ4ýi¥[Ek è A÷ Áù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6bi¹éï2~qyKËu]OT¶ŽEë¿¨ÿ ò*ROø\æšçüæo”ì‰]>»ÖEOû)[Ôÿ ’YÕ?ç8o‘§i ìf™Ÿþ4‹þ%‘›ßùÌß8ÌsŒ#Ú'?ñ9[
åÿ œ¶óãý›˜åÆÁ±‘ÿ ÎYùõzÝÂß;xÿ ãU:×þsÎÐŸÞ}N_õá#þMÈ˜omÿ 9±æTþþÂÅÿ Õ¯üÍ|:±ÿ œâ¹RæŽŒ;˜î
þä›Mÿ œÚòü¤í>îõ1˜äþ	¡É~‘ÿ 9Wä=D…{×µcÚx\ÃF²'ü6NôOÌo-ë´f¥ipÇöRd-ÿ "ùsÿ …ÉlÙ³fÍŒžÞ;ˆÚ•^7e`#Á”õÎ3ùƒÿ 8¥å_3ò¸ÓPéW¿(b'ü»cðÈ–‡<Ãùÿ 8óæŸ#r¸¸ƒëv¿ÖmêÊüZŸÞCþÍ}?ø³ Z¿ Ý%þ•q%­ÌfH˜©ùmÕ|Wìç¦ÿ +?ç1ªSOó¼tè¢öün _øœò'==¤êözÅ²_éÓ%Å´¢©$lHöeÁy³fÍ›6lÙ±ë(¯­ä´¸^pÌ©î¬8²ÿ ÀçÌŸ7ùv_-ê÷š4ÿ ÞZNñâÑ_ýšüYì/ùÇ?Î]|ke®êÖ—V,Öüg•QŠ/Å*»
§¤ëüóÎŽ?:¼–O­X×þ3§ë®´üÎòµæÖúµ‹Ÿsâx}iox¼íeIWÅ0ÿ …ÅófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›#^hüÌòß•ª5­FÞÙÇì3ƒ'ü‰NRÿ Âg+×¿ç2|£bJéñ]_0èUhÙLË'ü’È6§ÿ 9ÃtÄ;Hc,å¿áR8ÿ âYºÿ œÓód‡÷–õ$où€¿èr<ëü–_ò%¿ê®/oÿ 9çÿ ¼‚ÂAïƒþ#6/¬Îcëz¾™u¥ÜX[!º‚H}HÙÔ¯51ó
æJñåüÙçÜ÷G‘ç%¼„–ºX»{O«Ã*'‰”QGöãÇû?Ï[Bóv¯¯="öÞìR¿¹•\˜CUÃlÙ³fÍ›9_üäŸåáóŸ”ç[då}`~µ Oûè‡üd‡—ý©<ó_üãOçe§ååÍåž¶Î4»¤õ,Vdû<Wþ.OÝ·ùK/‡~hÎXëÞgçe WJÓÍG%5ÇùSî¿Õ‡âÿ ‹_8„QO8HÕæ¸•¶ fcÿ ÌÙÜÿ .¿ç<Ãæ~`a¥Z9NÃþ1}˜¿ç«s_÷ÖzsÈ‘žUò8Y4ËE’íãæzI-|U›á‹þx¬y>Í›6lÙ³fÍ›1 
†$o!þfp¶ÁÔŸ˜ÅsfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³dGÏ›[òBW\½Ž)iQ
ürŸ”)Éÿ Ù7ÿ +<õçoùÍk™KAåK‰:	î¾&ù¬žþÊY?ÕÎæÏÍŸ4y°ŸÓŒóFßî Ü#ÿ ‘1p‹þ"9²ÕK(©=†Ùy?Z¾´°º˜÷Ü.ßñÃx?(|á8¬z5ùþ]¤­qïù3ç4ë¢ßýîRám×åï˜ín4»ØÇ‹[Èâ˜Iqk-³p6ð`Aüq,Ù³d—Ëÿ ™>dòñ¢u+«u²²·ùÄÇÿ GË?ó˜žoÓ(ššÛê1Ž¦Dôßþ	ÿ g_ò§üæ_–5"±ë0O¦ÈiV§­ü_½ÿ ’Ù|µç]ÌñzÚ%ìkÔúN	ë§ÛOök‡Y³fÍ˜ŠìsþhÎ/ùsÎ\ï,iš“Tú¨ôÜÿ ÅÖÿ 
ÿ ³ÓæçžCüÇü¡óåõÇ¥¬À~®Æ‘ÜGV‰ÿ Õ“ö[þ+“„Ÿäå~[þmk¿—·_XÑ¦ýÃe·z˜¤ÿ ]?e¿âÄã'ùYíÊ?Ïmó»}[TE¬–’‹n¯»£ÿ Wã_÷b.tœÙ³fÍ›9Wæüäo—ÿ /®_KºIîu$UoF4â aÉ9M'ââ¿W<ýæ¯ùÌ¯4êE“F†:#Ðñõdÿ ƒ—÷_òC9n¹ù±æ½pŸÒ:­ÜŠz¨••?ä\|#ÿ …È¬’4Œ]Éf=I58ÜÙ±{KéìßÕµ‘âqûHÅOÞ¹9òïçßt¿TÕgt_Øœ‰–ž¿õ)þÇ;“ÿ ç6.¢+™ôô•:mOùú2–Fÿ ‘±ç |‰ùÁåŸ<(-â<ô©‚O‚Qÿ <Ÿvÿ Z>iþVLófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³f$SÓ8¿ægüå?–ü¢^ÏM?¥u¨)Ÿø¶ãâ_ö1,ŸåpÏ1ùëþr?În-Ý›+F¯îmk§ƒÉ_ZOöRqÿ '9‹»9,Ä–;’zœnXšÎÚùkT»¶´¸”ä‰Ûþ"¸3üæú¶^ÿ Ò<ŸóF#?“µ«qY¬.•Ö¸W5¼2«!ð`GëÄób\InâXY’E5¤‚>DgMòWüäGžt#µ´¼{äb`¹·"Mïÿ ÕT—=ãå¹µôëyu¨ã‡PxÕ¦Ž"J+Ê)mþ³†Y³fÊ’EK¹
ª	$š sžnüâÿ œ·µÒLšO“8]]…®ØV$=ýÿ w¿ùÜÿ Æ\òÄïq#M!«»c@7&§a¶v/Ê¯ùÆ0yÐ%ö ™¥µ’Uýãø¦…·ÿ ~IÁ?—ÔÏ\~]þNysÈ1Ñí‡ÖiF¹–3ÏOØ_ò"àŸääÛ6lÙ³fÍ‰ÜÝEkšáÖ8ÔU™È vm³˜y¯þrgÉ]-^ýre¯Áh¾¯Oø·áƒþJç#ó/üæìÍTòþ–ª;Iu!où#ù?œÇYÿ œ¢óæ¦üÖüZ¨5	H£ïeyû'È®§ùµæÝOýëÕï\ÂwQÿ Œ«‘ëföèÖââYùnÍÿ 8±;“–®Ë¸$iæJÌÖÚêxŠHËÿ l’irÓ)õ]bðÐ<­ ÿ ›Ô\›èó—~wÓˆR[ß(ê&„Ù[úÒ|¹ÿ 9»k!	¯ioŒ–Òÿ ’Rúòu³¯yOóÿ Éžg+ž£S·ûªâ°µ”z¼QÏücwÎ‚¬SPweæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÈ—ææ§—ü…oëë—"9V8Sâ•ÿ ãC·ùoÆ?òóÉÿ ™_ó–Þ`ó{M ~Š±;rCYØ•7û«þxü_ñkg¸¸’æFšvi$sVf$’Ovc×ªX…QRv gIòwüã¿œüÔ[k¶·o÷mÑô–ž!_÷Î?Ô‰³´y_þpŽÝ)'˜µ7sÞ;T
?ätÜëÿ "W:–ÿ 8Óä]ºrÜ¸ý«–ikþÁÏ¥ÿ $ò{¥ùcJÒ@]:ÎÞØž”HŸñ\3Í›6¼Ó­¯WÓ»‰&CÙÔ0û›!ºçäg’µºýoI¶ÝZ$ô›þ
ßÒ9ÌüËÿ 8[åËÐ_F»¹±ôW¤Éÿ Þœ¿ò[8÷›¿çüá¡†—OXµ8Gûá¸½=á—‡üm&qíSH¼ÒgkMF	-§^±Ê…±pÍ›³¾žÆU¸´‘á™Uãb¬ù,¿ÎÃäùÊÿ 7ywŒ7ò.«j?fãûÊ“pŸã/­žŒòüå”üÖVÞæS¦^¶ÞÉ	ÿ "çû¯ùé7ù9×ÑÕÔ:TŠ‚:—›6l©évº­´–Wñ$öÒŽ/ŠX”­žQüèÿ œI–ÈI¬y 4°Š³ÙWQßê®w•â—ýïò4Ÿg<Ùiwu¤Ý-Å³½½ÔUe%]Oü²ç°!¿ç(`ó§ y±ÖLÑb¹Ùc˜öY?f)Ïü‹—öx?ÀÞ‰Í›6lÙçùÌŸËŸÒZ\>m´JÏ`DSÓ¼.~ÿ ž37üÏü¹ãœœ~YþOë˜Ï2h~-¸ú¦Yñç^ˆ#¾Êg`Òÿ ç5I :Ž«oˆŠ'“ñvƒ$–ßóƒúZôZáÏù"ÿ ÄšLç	<¿MµÊü£ÿ š0çüàõƒõ]^d=¹À­ÿ ’<‰ë?ó„þ`·´ÍBÖæâ'ðá³šù£òÎž[%æ™,¯Y ¤ËOèóeÿ f«œýÑ•`CBQŽ‚y-Ýe…ŠH†ªÊhAÕ‡Lï¿•ó–Ú¿—Ù4ÿ 4òÔ¬6·ü|F<y®´Ÿ¼ÿ ‹g={åo6ižj±MWE.mdèÊzèëö£uý¤‹³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ°ŸÍ¾oÓ<¥§É«ëS,±u'«ÙŽ4ûRHß²‹ž(üãÿ œ•Ö<ôÏ§é¥´ýíé)¤’™±ÿ |§îÿ ›ÔûYÆ°ûÊ^DÖüßqõMÒ[¹Ú(>ÿ Œ’µ#ý›g~òoüáEíÀY¼Ï~¶àîa¶ÛäÓIÆ5oõc—;—ç|‹¢€~¡õ¹íÝ;I_ùçðÁÿ $³ i~TÒ4N²·¶ýõ'üAFæÍˆ]X[ÝŽ71$«àêÃd[Wüžò†¯_®ilOí,Jÿ ÿ †Ï1ÎNþ\ù#È±Ao¡Ã$:½Ñæ#YY‘"jGY}GøÛà‹ã_÷c~Æyã=9ÿ 8‰ù=õÙÿ Æú¬¸ŠÙ+µ ød¹ÿ V/±ü[Í¿ÝYëŒÙ³aOš¼Ù¦ùRÂM[Ymíb³u'²"ý§‘¿eâÏ~uÎGjž~wÓ´îVZ%iéG”5Ë/oø¥wüÞ§ÚÎsäß$jÞr¾]/C·k‰ÛsM•ûòYÃ”ßñ,öWåüâöäÀšŽ³ÇQÕ†á˜~æ#ÿ Äßm—ýý/Åü‰vÜÙ³fÍ›6s¯=Î@yGÉ¼¢½¼Yî—ýÑmû×¯ò·ÝÇÿ =dLó÷ç45«þPùjÖ;ŽÂY{/Ì.Ð§üßëgó?žµÏ4Éêëw³ÝšÔ	•êGýÚ°\"Ë “A×%ågšuÐMÒîæCÑÄLþF8Xÿ á²s¥ÿ Î'yòø’Ö+`ßÓ§êˆÊÙ%³ÿ œ(ó4€›ë½”Èßó)0Åç5R>-ZÜhœÿ ÆÙRÎjÀ~ïU·'Þ'Å°ªûþp¯ÍQ
Û]ØÍì^E?Œ$Ãd_Uÿ œYóîž-ŠÜ(ïÑ·ü+2?ü.A5ß ùƒ@¯é]>êØÚ’'ÿ Ç‡ü6fÉ‡“?7|ÏäÖ¡¯åŽþécÎ#ÿ <däƒýÏCùþsFÖã·›­»ÅµY>o~õ?ç›Ëþ¦z'ËžiÒüËj/ô[˜®íÏíFÀÐÿ +´þKüXi›6lÙ³fÍ›6lÙ³fÍ›6lÙ±“Ï¼m4Ì4™˜Ð :³1èy“ó‹þrê+C&“ä~2Ëº½ë
¢Ÿùv¿¼ÿ Œ²~ïùO·žTÕu{½^åïµžâæSÉä‘‹1>ìØ•”÷Ó%­¤o4ò(ˆ¥™‚ªüMÿ òçþpóZÖB^yž_Ñ¶Í¿¢´yÈ÷ÿ uAþÏÔæ‹=/ä_É+y%U´‹$úÂÿ ÇÄ¿¼”ûú¯ö?ç—¦¿ääß6lÙ³fÍ›6lØQæO(é>f€ÚkVÝÃØJ€‘îö‘¿ÊF\ó×æüá¥À{¿'Ü›y7?V¸%ÿ “ÿ ÞGÿ ==_õ×<Íç"k^Nºú–½k%¬»ñ,*¬íE*Ö9ýFÂ˜yWÍzHãcæ»{bvB}+¨‡óG2ü…ÿ }],Ÿä<yÑnÿ ç¿Ä6§?.µµk3ÖièßOþëõüYè“œs_òÞ¥åë“c«ÛKip¿±*•?5¯Ú_ò—áÉwå×ç—™ü†êšmÉ–Èíg«ÄGù^Pÿ ÏLõ—åoüä÷—|èRÊôþŒÔÚƒÒ™‡¦çþ)ŸáSþ¤ž›ÿ /<ìY³fÍœ[óËþq¿OóÚIªé-5À+Ë¤sÓön)ÒOåŸí¿9þÇ‰5íûË÷²éš¬/owqxÜPƒÿ +~Ë/Âß³ž’ÿ œyÿ œœkc–<ã5aÙ-ïî¿ËÓØþIÿ cýÛð|ië C
ÁÍ›6l	¬i6úÅœúmê‰-®ch¤SÝXqlù«çß(\y?[»Ðnê^ÖR¡¿™ÅŸóÒ2¯’ÈÌOð7š­¯fn67ê÷>›‘ûÃÿ dá/úªßÍŸCA®ã6lÙ³d;Îÿ ”>Yóª0Öl£yˆÚt%óÙ(Íþ«óOòsËßš?óˆº¿—Õõ,;jvKRb"—
=•~ùçÆOø«<ÿ $mpU”A ŽÇ%¿–¿š:Çåî¢5"OÝ±hŸNUþYù¿’EøÓþ=ñùgù™¥þaikªéMFY¡cñÄÿ Èÿ ó.O³"ÿ ²U–æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lØEço:iÞLÒæÖµy=;xGAöØŠ%ý©öà›àVÏŸÿ šÿ ›:¯æ6¤oµ1ÛFH··SðD§þ'#»%ý¯òSŠ,2$¸‘a…YärUA$“°UQö˜ç§ÿ 'ÿ çÚácÕ¼ñTCFK4b?åêEûñ†?ùä_±ž¤Ñ´KÙ,tÈ#¶¶ŒQc‰B¨ú¿ùX76lÙ³fÂ7ùªËÊšUÎ·©7kT.Þ$ôHÓü¹Š'ùMŸ8¼õç+ß9ë:î¢k5ÃÔ-vEG‘|?ðßk?)..0uè4[z¬?Þ\J÷q)ýãÿ ¬ßÝÇÿ :çÑmHµÑ¬áÓl#ZÛ¢Ç/@ª(0^lÙüÈüÊÒ/ôÆÕuwëUŠûr¿ûî5ÿ ‰¿ØOÚÏ~hþlk˜º½ÕŒO¡n„úq)þ_æþÜ­ñ?ù)ÅóòkòVüÈœN+k¤FÔ–å‡Z}¨í×ýÙ'ü$·üî?#yGòE‚éz…·W‘¿ß“IÕßþ#ûW$9³fÍ›,É
e`ˆ¢¥˜Ð ;“œGóþrËË^Y/k£×V½ZÝB§ü«‹ŸüñY?×\ó'Ÿÿ ç ¼ÙçRÑ]Ýk6ÿ {jÆ”ðs_V_ùèì¿äç6ËU,B¨©=u/#Î5ùÃÍ¡fK_¨Ú5­wXÁ)wÿ ‘|?ÊÎóåùÃO/˜.¦Ô%Q?sü)i›þF¦v?-þZyoË ~‡Ó­­Ø~ÚÆÿ Èçå)ÿ ƒÉ.lÙ³fÍ˜€Eàä3Ìÿ “^Qó0oÒze»HÝdEôäÿ ‘°zoÿ œgÎó…¥òÍûÛ¿QÈæŸ!,|dAþ²KœÏ?‘¾lòW)uK'kUÿ ˆ?y<YÓâþ{,yÃ,ù³Uò½Ð¿Ñ.d´¸_Ú©Qü®¿bDÿ !Õ—=IùWÿ 9‡k|SNó¬bÚcEqé“ÿ Åö¢ÿ ^>Qÿ ‘ç¤ì¯`¾….­$Y GF¬í+/ÂÃÍ›6lÙ³fÍ›6lÙ³fÍ›
<×æÍ7Êš|º¾³2ÛÚÄ7cÔŸÙD_´ò7ì¢ç‡ÿ :ÿ ç!õOÌ)ZÆÓ•žˆ§á€ŠJt{–_µþL_Ý§ùmñç"Î­ùGÿ 8ï®þ`²Þ06:Mw¹‘wqÜ[Gðú¿ëü1—ËáÏe~\þPy{òþn>°EæJ4¯ó“öþ+„ääÓ6lÙ³fÍ›6lÙ³fÍ…Úÿ —4ï0Ú>Ÿ«ÛÇujýRE¨ÿ X++¯Ä¹å_ÍÏùÄ+<>§ä¢×0ÚÍÍdQÿ Iþîñ[þ÷ü©[<Õqo%¼êÑÈ„«+#ª²ÁÉÿ 0µ"êªhs¤Ø:ÒEÿ }Íí¯ü2þÃ+g´¼ƒù‰åOÏ,Øj–Ñ5ìkY¬æŠøÍm&Ïéÿ Å‘ð’?Ûãðòæ™¿ó†¬ï¼•1a¹ú¥Ãoò‚ãþ4›þGg™µ­ûCº}?T‚Kk¨Í9«¿·ò¶u¿Ê?ùÉíoÉE4ýT¶¥¤¸9ýìcþ(•¿eßR|ÈÑg²ü‘çíÎÖ#RÐ®x¶½ù&í#ÿ Ä¿c’äƒ6lÙÎ9?%4ÏÌ«§
Ÿ«Ü¸ÿ Šåÿ ~@ßËûm?ÊðW›¼£©yGR—FÖ"0ÝBw˜~Ì‘·íÆÿ ²ÙèùÆ¿ùÈÆÓZ/)y¦ZÙš%­ËŸîÏE‚fÿ |ÿ ¾äÿ tý†ý×÷^»Í›6lò÷üæåß­·œmâŠ–×T²Mmåoõ_”Gþ2EžLÏ~Î3þaÿ Œ|©
\?+í:–ÓW©
?q/üô‹ö¿jD“:ÆlÙ³fÍœsó¿þqÏMóôO©i¡,õÀ*%‰5?bä/í,ÿ mkšü9áÝwA½Ð/eÒõHšÞîã$n7ø«}¥eøY~%ÃïËÌGòûWXÓZ«öf„Ÿ†XëñFÿ ó-ÿ aþ,úäÿ 6Øy·Kƒ[ÒŸÔ¶¸^CÅOGÇìÉ|‡9³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lNææ;hžyØ$Q©gf4
 rfcüª3À?Ÿßœs~bëêìË£Ú–ÑôåÙ®]ß’þÏûî>)üü¹¥•”×ÓÇkj,ò°DEff<UU{³÷äüãÍ¯‘ McXUŸ]‘kSºÛƒþë‡þ-ÿ ~MþÂ?ƒâ“µæÍ›6lÙ³gŒ?ç-¿6¿OêcÊzl•°ÓÞ³•;I?B¿êÛ}øËê*gŸØ"Xš :“žýÿ œvü¦_ËýMÚ«_–ä÷]¿umÿ <U¾?øµ¤ÿ ':®lÙüÎüÍÒÿ /4¦ÕuFäæ«*~9^Ÿa<ýù'ÙØ«xóóTóî¨úÆ°ü¶Ž1ö"OÙŠ%ì£þ	Ûâléÿ óŽùÙ“]×ÃA¢)ª/G¸#²wH?ž_Úû:{WMÓm´ËhìlbH-¡P‘Æ€UT`œÙ³fÍœwóOþrwËÞJçedF¥©­G¥âùþ%_øÇ9?›†y'óó³Ì¾~Vä¥¥j¶°Õ"JÖSþT¬ùÍŸò¿þqsÌ^q	{¨ÑzkP‡•Oªãþ)·ø[ýœ¾šÿ /<õoåïäW•¼Š«&j%¼ng£Ë_ò	!ÿ ž(™Ð3fÍ›6lÙ³fÍ›1 ŠÁÎMù‹ÿ 8Ïå_9¸ŠÑ×í¿­l ÿ Å°u'ù\}9?âÌòwæwä™<€Zâê/­iÀíu % ÿ ‹—íÁþÏàþY9®t/Ê¯Îýwòæqõ	=}=d´”ŸM¼Z?÷Ì¿å§û5|öïåææ‰ù‹gõ&N7­lôFOó/íÇü²§Àßë|95Í›6lÙ³fÍ›6lÙ³fÈ÷žü÷¦y#K“YÖdá{*ÞG?f(—ö¿æöø<ù³ù»ªþdj&òü˜­#$[Û)ø#_øÞVÿ vKÿ N+ˆayÝb‰KÈä*ªŠ’NÁUGRsÕÿ ‘ßóŠ	 \ó¼aä4h¬OÙ_»þfÿ Š>Ïû÷—÷kê¢HG
Š U€ÐŽÍ›6lÙ³fÍ›6lÙ³fÍ›9Wç'üãîù‰] zÂ¯Ár£g§ÙK”Þ/ùÞ§ú¿x{ÎžGÕ|™¨>“­Âa¸MÁê®½¤‰ú<mÿ 6·ÂýZ¼Ñ/"Ô´ÉžÞêä’!¡üþÒý–ý¬÷Gä/çå§æ-¯ÔoøÁ®@µ’1²Ê£ýßüÌý×þ¦M¼ûùg¡yîÓêzíºËAû¹Wá–3ã¿iÕþí¿m<cùÃÿ 8á­y ½ý­oôq¿®‹ñF<.ccþ2¯î¿ãØÎ}äß;êÞM¿MSC zÓuuÿ }ÊŸfD?Êßì~,÷ä¯çþ—ù´”-¦³ÖKrvp>Ô–Ì~Ú2yír_ÞgUÍ›6sïÎOÉÍ;ó+M6÷‡P„mrè‘ÿ žý´ÿ fŸxÍ^VÔ<­¨Í£êñnàn,§¡þWFý¸Ü|Hÿ ´¹éÿ ùÅÏÏãz"òg˜å¬à²ÏÚìÚÈÇö×ýÐß·ý×ÚáÏÓù³fÂ¯5yrÛÌÚUÖ‹|+owDÞ"£áuÿ *6øÓü¥Ïš~eòýÏ—u+øq¸´•¢ššr_ò[í/ù9Ó?çÿ 0ÿ Â>kŠÚáøØêt¶–½þ'û~òRWÏzæÍ›6lÙ³ÿ ÎCþGÃùƒ¦›ý=ë–ˆLL6õTnm¤?òe¿bOòóÁÓBð;E*”‘	VV Š°ñÜÿ ç?6›ÊÚÐòö ôÓ57
µ;G9øc“ÙfþæOùäß±žÞÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lóüææ™Ò¬#òvžô¹¾_RäƒºÂÁü÷uø¿â¨øý™sÇyëïùÄÏÉeÓí“ÎÚÄuº¸Sõ$aö#;øÉ7û¯ùaø¿Ý¿¥³fÍ›6lÙ³™Î@þj/å÷—žkvS¼¬6£¸b>9ÿ Õ~/øÉé¯ígÏ©$i»’ÌÄ’I©$÷9èùÄ¿Ê_ñª|Ó©%tý9Ç¢m%ÇÚ_ö6ÿ ÞÆOKü¼ö–lØAç¯;éÞJÒfÖõgã#eiÜýˆbµ#ÿ Ííð+gÏoÌÏÌKóV“WÕƒìÃ?Q×á?ãwÿ v?ÅGþqÇþqå¼á*y‹Ì1•ÑboÝÆv7?ìYOÛo÷g÷kû|}©À‹*4UTP 6UUcófÍ›#žzüÂÑ|duváapˆ7’CüÇö¿áWöÙsÆÿ ›ó“úçØiE´Ý%¶àûÙü_2ôVÿ }Gð;Kœ[6H¼äcÎ÷ÃLÐ 3K±vè‘¯óÍ'ÙEÿ †oØäÙìÿ Ê/ùÆ}Èá/õ ºŽ®7õ]wÿ —x›Ãýúÿ ¼þ_OìçcÍ›6lÙ³fÍ›6lÙ³fÊ’5‘J8¬ Š‚cžyüàÿ œKÓµá&©å7æ¬Öçh$?äË;ÿ «ûŸòíçµï/ßù~òM7Ví®â4hä#ßü¥?²ëð·ìã¼»æ=CË—±êšDïmw	ªºýÕ»27í#|-ûYîÈ¯ùÈ[Ì(WMÔxÚë±¯Åh“ÖKzÿ ÃÃö“í/4û=‹6lÙ³fÍ›6lÙ³fÂ¯4ù¢ÃÊÚlúÎ­ †ÒÝy3w?Êˆ¿µ#·Â‹ûMŸ??7ÿ 6µÌTß]V+8‰[kp~ÓÄÿ 4Ïþí“ýØUÈf§\jWÙYFÓ\LÁ#Y˜ý•UÏn~AÎ9Úù$ÖuµKuÅGí%¸?±óMþü›ý„_&“·æÍ›6lÙ³fÍ›6lÙ³fÍ›6l‰þdþYé?˜:kiš¼{Š˜fP=HŸùãoøš}‰?k<ù›ùeª~^ê¥j«U5hfQðJŸÎžÿ ïÈþÔmþÅš;¤j÷z=ÜZŽŸ+Au‡ŽD4*Ãüÿ Ùg¾?"?:­¿2tÊMÆ-bÕ@¹„laqÿ }?ü’ƒùú|‘¬ŠQÀeaBàƒØç—¿=çq&½äˆÂÉ»Kb½ùžÓù[þ]þÏûç÷må‹K»½"én-ÝíîíÞªÊJº:Ÿø%e9í_ùÇßùÈ¸<î‰¡kÌ°ëˆ>ÙVàÚOåŸýùí}¸¿i#î™³fÎUùùù'où¦z¶¡cÖ­T›yNÜÇSm+¾ßöýÕ'Åö}N^
»´ºÒnÞÞá^ÞîÝÊ²š«#©ûÕ•³Üóß«çÝ7ô^¨ãôÝ’R»zÑ…nü¿ÙŸü¿ýÙÅ{>lÙ³È¿ó™ß—¿T½¶ó…ª~îè{’;H£÷øÉ´óÅ›<Ì¬T†SB7gÑoÈïÌç¯+Zj’7+´_BçÇÕáf?ñ•xMÿ =2{›6lÙ³fÏÎ_þT®‘~žpÓ’–×ÍÂä(Ùg¥V_ú8QñÅ¨ÍþíÏ8« ƒB:úùù‰þ;òµµüíÊúô{ŸQ ýçüö„¿ë3gEÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6Ôõ4ËY¯îØ$ñ´’1ì¨9»ÀŒù«çÿ 8\yÇ\»×®ëÎêBÊ§öP|0Åÿ <â
™ üŒü·>ó5¾™(?R‹÷÷D¾Š¥|fr±³åû9ôFRX¢Pˆ€*¨ ‚ŽÍ›6lÙ³c'ž;xÚi˜$h¥™˜Ð Y˜øùáùåù'æ˜¦ÔŸ¨CXmTöO÷”þy›÷þÅ?c"¾Pòµçšõ[mN^WR_^Fÿ "4äïþJçÒ%yFÏÊE¶…§
AjAîÍö¤•ÿ Ë‘ù;aÞl¨júu¼—·’,Vð¡yªŽLÌ}†xóßóŽãó#W/dÒmI[XŽÕµ<‹þý—þI§þfcOùÇŸÈÙ0õ¯ê*É¡Ú0õ[¡•ÇÅõhÛþO8û	þ[®{ºÒÒ8RÚÙ(bPˆŠ(ª QUTtU®lÙ³güìÿ œ”Ó|ˆ$Ò´ž7ºØØ¥k'Æá—«ÿ Åñ;Gû^,ó_›õO6_>©­Ü=ÍÌØì£ù#O³/ò'Ã„ù³§þKþDjŸ™7>¶öºDMInHëã¸ÿ vKÿ 	íþÊ?¹ü—äm'ÉzziZ»¬íþü•þÔŽæÕâ¸}›6lÙ³fÍ›6lÙ³fÍ›6l„þhþQh¿˜¶_UÕcár€ú7(©ùþÜÏ|-þKüyáÌßÊÝ_òóQ:~¬•ªa»•Gí!ìÃöão?ÕâÍ²½žÆdºµvŠx˜2:X}–V{wþqãþr/=Âº&´Ë¹
ìvp£¬‰á2ÿ »bÿ ž‘üÖ>á›6lÙ³fÍ›6lØÙ$X”É!
Š	$š RNx?þr3ó®O?êŸ£ôç#D²b"oUÇÂ×/ÿ ‡ùcø¾Ôœ‚(žgX¢RÎÄP*I= 9íÿ ùÇÈ(ü‘jºî´µÉ×e;ý]v¿ñsïŸþy'ÃÏÔîY³fÍ›6lÙ³fÍ›6lÙ³fÍ›6l‹~cþ\éžÒ¤ÑõeØüQJÇþÌ±Ÿø’þÚü-Ÿ>?0|…¨ùW—DÕV’Gº8û2!ûGþKÂ·$o‰p?’¼ã¨y;Uƒ[Ò_…ÄZ~Ë©ûqH?j9áoù«>‰~\ùúÃÏz4:æšh’
I?rï!uÿ ‡N/ûY&Îÿ 9ÿ 8åœc“Ì^E‹[AY#pe¹þI?ÝŸbOÙtñx7ZUÕG;{»i=ÕÑÐÿ Á#£ö9îùÇ_Ïˆüýgú'VeMvÙ>.€NƒýÞƒýø?ÝÑÿ ÏDø>í9³fÏ8ÎV~HfÙüå¢GþŸn¿éq¨þö%ßþý~ßóÃÿ ¾/)yKÍWÞTÔàÖ´§ôî­œ2žÄ~Ôn?j9àuþ\ú-ùqçÛ/=è°kºy¢Ê)$dÔÇ þöÿ TýŸçN/ûY&Í›#?™~J‡Î¾_¼Ðf 7ŸMìÈ¿/þÆE^_äçÍ‹ë)¬g’ÒåLsBí©ê¬§‹©ÿ U³¼Î~`þ„óž]¹jZê‹ðW hÿ äl|ãÿ )ý,ö”ÓÇó•‚(îÄøá[yÇECÅ¯íAŒÉÿ 5`û=FÚõyÚKËâŒÂàŒÙ³fÈÿ ŸüŸoçóAº§¨Š«ÙqñE'üó•Uóæ¦¥§Í¦ÜËct¥'Ú9öe<à†woùÃŸ;#Ì’è5-õHÏNÞ´@ÈŸðQzËÿ žÕÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6qùËŸ9Ê'M…¸ÏªJ!Û¯¦¿½œþÄßñ—<5žÜÿ œAò Ðü²ÚäëK­Uù‚zˆc%!ì›Õ—ýWLï³fÍ›6lÙç¯ùËÏÍ/ÐzJùRÁéy©/)È;¥¸4ãÿ GðÆ4—ù³ÆìoùÄÊ¿Ñ:sùÃPJ]_/`Fë~)>w?äR/û÷=›6yþrÛóœßN|‘£Éþzê~Ôƒu¶ÿ R/µ/ü[ðº›8§å_åµ÷æ·eUíÏ-*"ˆŽCþWìÆ¿·'ú!å,Xù_MƒFÒ£Z[(T^çùÏí;·ÆíûM†™³fÊf
1 ’sÊÿ Ÿ¿ó”¥Lž]òT½*“ß!ÿ ‚ŽÐÿ Ä®?äOû÷<¿aaw«Ý%­¤oqw;ñTPYÝ·ÚfÉ·›ükù{n4íL¥Ï™&PÒD¤4vhÂ¡d#i¯d^ßÝ[§ÇûÇhÝ9övÈ/È;ŸÌK¯Ò€ht(’8Ù¥aþè‡þfËûëçºt"ÓG´‹OÓ¢X-`P‘Æ‚Š `¼Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ„^uòN—ç=6MZˆKo'CÑ‘¿fXŸö$Oö-É>ð'æ÷å¥ùm©›+ÏÞÙËV¶¸‹"ŽÇù%O÷dñ£+d/OÔ.4Ûˆïl¤hn!`ñº2°5VSžöü€üì‡óLônÊÇ­Z(ƒŽ‚æ%þGÿ v/ûªOòZ<êÙ³fÍ›6lÙ³fÏ5ÿ Î\þp*×ü¥IK«¥xÊwHÙƒýiþÔŸñOüfÏç«?ç¿$ÏÜ{Ÿ÷‚&ôöÃþßþG¾›=Q›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›9Çç—å·æFŒÖê5K`^ÒcÙ»Âçýõ7Ùoän2~Î|ûÔtë6æ[ØÚ+ˆ£‘P«)âÊß#?þq×óy¿/µÁãŸÑÅc¹ÿ ºîGübÿ vÅ\ÿ k†{í]C¡H¨#¡yçùÉ¿Èóy¯ËÑST…y\Dƒûôí¨ñóÿ Èäø~Ú§/ èZåæƒ}©¦Èa»¶pñºõ~µ?e—ö—álúù9ù§iù¢&§#»Ž‘ÝBØ’¿â©>ÜMþÇí£äë6lÄ(w<%ÿ 91ù;þÖ?Ii©ÇGÔ´`tŠOµ%¿²þÜ?ärO÷V!ÿ 8Õù¸|‰®‹;ç¦‘¨Žj£~‘\ûqûÿ Å_û­3Þ€×q›6lñ'üåçåÿ è2.½l´µÕT»S ™(³ÈÅá/ùNÒg³¼šÊdºµvŠx˜::YO%uaöYNÕ5ÛýYÌºÌ×2ùK#9ûÜ¶ÁW÷2	í%xe6*Gû%ß:ÿ åßüåGš|¯"C©Êu[ @dœþðø®çûÎ_ñ—Õ\ö/åçæ>‘çí8jš,¼”PIm$Mü’§oò[ì?ì6J3fÍžÿ œ¶òhÐ|ÞÚ„+H5HÄâ=Aû©ÇÞ«+Æ\ä¾Y×fòþ©k«Û{i2L¾ü7ö_g>œé·ñj6±^ÛžPÏÈ‡Å\sSÿ pFlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6x£þs+ÌçRóT:BÇ§[¨#ÂIzÿ òKÐÎ¢i2ëÖúm°¬×R¤)þ³°Eÿ ‰gÓ­I‡F±·Ó-E µ‰"AþJ(EýX76lÙLÁAf4rNyÇóOþsÇFšM7ÊP¥ôèJµÌ„ú ÿ ÅJ”yÿ ×åËêgÖ¿ç$¼÷ª¹gÔÞ=XÀù_Sþ	ð:¼è§Ö¯«ï;ŸÀœ<Òç&|û¦F¤Ó¨ý™£Áÿ dÉêÃä'Î~qÔ<ãªM­êîêr+ÄQ@QÁQöQTa÷äÏåÄ¿˜c·Ò "ÔVåÇìÄ§ãßù¤øbOòß>‹ZÚÅi
[[¨Ž”"*ŠUUTx*â¹³™þþk'åç—Þ{v¥.ëªø5>9éü°/Åÿ =4ý¬ùÿ w•ÈD5Ìï@7fws÷³»œú	ùùKåÎ„¶ÒmNæ’]È7ø©ðÂ­þûƒì¯ó?9?o:FlÙ²¤‘cRîBªŠ’v ç<oÿ 9ÿ 9%'˜š_,ùZBšXªOp¦†æŽ3ÚÛþOÿ Æ/ï8w“ü©ù¿QGÑa3ÜÊz²«ûRJý4ý¦ÿ ³Ô·Ú‡ÿ 8áå³Ï5^©Š)\~Õ>?I÷v°uÛ™¸#ýµôü‘¨j•Ä—·’4·9yK3LÌ}Ît/ÈßÉË¯Ì[ÒnQiVÄ5ÔÃÃöaþ.—þyþK{ûFÑí4[8´Ý:%‚ÖÝGŠüþ&ý¯µƒ3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙóï‘4ß<iRèº²r†AUqö£qö&ˆþË§ü7Øo…³ç§æ?åî£ä-b]T_‰>(äá–3ö%ýoÚ_Ø~Iû8É~p¿ò~«·¥?‹v­?e—öâ~Ôr/ÂßóV}ü½óÕžth5Ý4þîaGB~(äÞBÿ å!ÿ ‚^/ö[$y³fÍ›6lÙ²;ù…ç[_%hwZõîén•T­¹øb‰×~#üŸµŸ7¼Ã¯]ùƒPŸVÔ_Ôºº‘¤‘½Éíà«öQerwùùPÿ ˜šú[ÎÒí)-Óë_‚ žvøã¨ÿ ³ŸAmíã·`…BG…UQ@ UQÙTcófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ.ÿ Î_~P	¢xÒ£ýâqKåQÕ~ÌW?4øb—üM¿aóÉ¹íùÄ¯Í3æM¼·~ü¯ôµ2Nïoöcÿ ‘û–ÿ #ÑÎù›<iÿ 9Yù(<½v|Ý£GÇN»z\Æ£h¦o÷`þX®üßñ‘9Ÿä·æÇåÖ½¤¤µ”´Šê!ûQ“ö€ÿ ~EýäðeÛ>ˆX_Á¨[Çyhâ[y‘d×pÊÃ’²ÿ ¬¸¾lÙüÂò=Ÿô[
üQ'_éSƒx¦_ò‘¿à—’~Ö|áó/—nü·©\húŠpºµÆãµGí/Š:ühß´™í/ùÅoÍCæÝô-ûòÔ´°¨I;¼=!“ü¦Oîdÿ V6oï3·æÍœçþrÈão)ÝYD¼¯-ÇÖmü}HÁ<üeÔ‹ýž|ñÍ›6lš~S~f^þ^kqjÖ¥šÜ—0ƒ´‘ñ/úëöâoÙòygÑm+T·Õm!Ô,œIoqËŽ…XrS÷`¬Ù³Ïÿ ó™¾X‡•íõ„“O¸>Ì=7ÿ ’¢ñ^}ÿ œeóÖü‹§³šÉjÕ¿ç“R?ù#égRÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6|Öü××Ž¿æ­SR­V[©xò½8¿äš.L?ç¼¼5Ÿ=Y³ŠÇf²\·ûáÝ4‘ç¾sfÍ›<ãÿ 9ƒù¥6‹c”´Ù
O~†K–SB!¯‹þ{¸~ñ\|>Ì™ãœÙ³fÏuÿ Î+~Z*yiu[¤¦¡ª…™ª7X¿ãÚ?¥[ÖoøÉÇö3´æÆO:[ÆÓLÁ#@Y˜š ìÄøùßùãù™'æ˜æÔŸ¨Ãû›T=¢Söéüó7ï[ýn±cþpÿ ò˜_Ü·u$¬Ìc³V4ŸîÉþPýˆÿ âÞ_µzï6lÙ³Èó“¿óGS’_'ùn_ô4%.çCýãµo÷Jÿ »[ýÚß÷Þðo#ù#Só®©£Gê\K¹'eEnY[öcOùµ~6UÏyþ\þ[h”š…YC$f[ËÇgà91ÿ "ÿ ÝqÄ¤ffñæ÷æUÏæ½6±5VØ~îÚ#û)øúïýäŸå·òñÂ?&ùJûÍÚ­¾‡¥§;›—â<uyÁ#Oóè·åç¬<‹£Á¡éƒàˆUÜŠI÷“IþSÿ Â'û+’LÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÍÿ =?(­ÿ 1ôV·@«ª[ö’¾/Ú…Ûýõ7Ùoån~Æ|ú¾²šÂy-.‘¢ž(èÂ…YOV*s®Î3þn#k¢Âýé¤j,±ËS´rtŠãÛù%ÿ Šþ/÷Zç¼sfÍ›6lÙ³gŽç1ÿ 1Î§ªÃå+G­µ€ÏN†gŸøÃÁJÿ ËžtŠ6•„q‚ÎÄ ä“ÐúùùfŸ—þ[ƒO‘G×ç¤×Mã#îëü°¯î—ýVÛÎ…›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lBþÂBÞK;´Á24r#nXqe?ë.|äüÜü¾›È>b¹Ñ$©…O©nçöámâoõ—û·ÿ ‹ñÊï=Oäo0Úk°Ô¤/I”~ÜMðÌŸðcþ,àÙôŽÆöø#»¶a$"ÈŒ:2°äŒ?Ö\[ ëÚ¦½c>•¨ –Öå9÷õ0ûJß²ß|ãüÎò×õë
î¬"<¢ï"oî¥úWáå‘]?g=ÿ 8uù¤o-¤òV õ–Ü­±“ûè?ç“·¨Ÿä;þÌyé¼Ù³g˜¿ç1ÿ +…Õ´~u°OÞÁÆ°T'ŒøÆçÒoò^?Ù<ñùMçù¼‡æ+]r*˜Q¸Nƒöám¥O>4ÿ ‹3èõ•ì7ÐGwjâH&EtuÜ2°äŒ¾Ì¸¶lÙóßþr#È_àÏ7][Â¼lîÏÖ­éÐ,„óAÿ ¥õýN9ÌófÍ›=½ÿ 8{æÇÕü¦údíÊM6vkþûqëG÷9•Õ\îÙ³d3ó›D×“µk*UšÒGQþTc×þ5Ï›Ùëÿ ùÂ\Ë¤êša?Ü\G0ñ•
ú‡ÏJæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›üÇ¨þŒÓ.ïÿ åž	eÿ €Vø×>^»—%›rMNzoþpHç«j„u0ƒÿ ¤où0™ë|Ù³fÏŸ?ó’zÛêÞ{ÔÙV[t5T?òS›g1Í›6O?$/›Ï~gµÒI´Cë\Ÿ“wóÔñ„ÆLú.ˆ±¨DUE  ^làó—_™áí	|¹fô½ÕASªÛ¯÷Ÿò=¿uþ§­žDò?”n¼ß¬ÚèV÷×RåJ…_µ$­þLqòvÏ¤žYòí§–ôÛ}N^Ö±¬h;Ð~Ó–íñ»6æÍ›<óÿ 9Kùä|µlÞSÐä¦§rŸé)Þ˜}…?³<Ëÿ "âøþÓÆÙä//y~÷Ì7ðé:\fk»‡	ä÷?Êª>'oÙ_‹>þM~PX~[iBÒK¨L]\SwoäOå†?÷Zÿ ³o‰³‘ÿ ÎcþhKh¼—`ô’à	®È=ÜÂã#¯ªÿ ä¤³&y=·ÿ 8£ùJ<±£ÿ ‰5é©jH
Çø£_õ§þõÿ Éô—ö[;ÎlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³Éÿ ó˜?”¢_<i‰Er±^ªŽöa¹ÿ gýÌŸåz_ÎÙå¼÷wüâçæyó—Ÿzüµ-/Œ2TîñÓýoøôŸü¸ù~ÞvlÙ³fÍ›6ùÇÌÐy_H»Öîÿ º´…¥#Äð'úÒ?_õ³æ†³«Ük7³êW­ÎâæG–Fñg<Û;üâ‡åØóG™Æ«tœ¬´&5Iÿ FOö,­7üòÿ +=Ï›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³Î_þ^sËéæ+T­Þ–jôêÐ9¤Ÿò)øKþJz¹âŒö÷üâŸ½å†Ñn•Î’â1^¦«Áÿ  }H¿ÕDÎí›8WüåŸåó/—ÿ OÙ¥oô \ÐnÐï—þy|¿äú¿Ïž9òš.¼««Úë–&“ÚH²Ù€ûq·ù2'(Ûü–Ï¥^]×­¼Á§[êö-ÊÞê%•³T?å/Ùoò°Ç6l	¬i6ÚÅœÚmò	-®ch¤SÝXqlù±ùƒäÛ&k·zÝK[HB·ó¡øá—þzFÊÙë?ùÃÿ ÌS®è2yríëu¥‘é×©þÇü‰“”ä§£ÿ 6làŸó˜>Dý7å´×­Ö·:Sòju0ÉD—þý)?É_S<M›6lÙëùÁ´q´æ¼[ózç©3fÄ/í–êÞ[wÝdFCòaÇ>ZÍ‰Ú6ê¤ƒôg¤ÿ çnÊêú­¯g¶ÿ àüÍÏ_fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›!¿œ·FÛÉºÌ ÐýFqÿ ŒŸñ¶|ÝÏbÎZ…Ðõ;žïv©ÿ ·üÍÏHfÍ›6|êüü³{O<ëÈ(Zé¤'Uÿ …|€fÍ›=©ÿ 8wäEÒ<»'˜§Z\ênBÔC(ŸðrúþRúyèØÙ¦HQ¥”…D˜€rN|áüáóôžzó-Þ²I6å½;pføbùsþõÿ Ë‘³Ðÿ ó†—ÒÎ9^'ïnkomQÒ5?¾ÆIWÓÿ žOüùéœÙ³d#ó‡ó6ÛòïA—W–rß»¶ˆþÜ¤|?óÍ?¼—ü…þf\ùÝ«ê×ZÍäºü5ÕÃ™$vêÌÆ§=³ÿ 8Íù$¾IÓF¹«Gþæ¯P0ÞÄ°ÿ “#ý©ÿ ØÅûË°ëÚÕ¶‡aqªÞ·{XžYù*9§ùsæŸœüÓsæ½bï\½þúîVŽ¼GìF¿äÆœc_õraÿ 8ýùkþ=ó<6—ËOµÿ Hºð(§á‹þ{IÆ?õ=FýœúªQ@6 eæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ› ëº%®»c>•~ž¥µÌm‹â¬)ÿ ü­û-Ÿ6|ýäëŸ&ëwzæïk!PÔ§4?RøÉWÉä?æò/šmu	”Çê÷>›9ŸøÂü&ÿ aŸDATnlÙ³fÍ›<çÿ 9£ç#a¢Zyv£ßÊe”÷Ü4!Oúó:7üòÏç¿ç<Ž<­äëg•xÝjérøÑÇîýŒŸû6|êù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›êZ|:•´¶7J	ãhäSÝXpuúTçÌï;ybo+kWšÅKÚLñÔþÒƒû·ÿ ž‘ñöYÐÿ ç¼ä|¹ç;h$j[êJmÃ“|PŸ¬¨ŸìÛ=í›4):4R¨hÜe" ƒ±>pþoù¼ækÍ‡ÐGç=âŽ/ŸýÛ–ž’ÿ œ1óÙÔ4›¯+\µe°oZßRGücŸâÿ žùèüÙ³g˜ç4?/„ö¶¾pµ_Ž-®HþF< ‘¿Ô“”óÕ3ƒ~Gyðù#ÍVz£·WoBãÃÒ“áv?ñ‰¸Íÿ <óè¸ ŠŽ™³`M_JƒW³ŸN¼^v÷1¼R/Š¸àßÏ™¾mòäþZÕ®ô[¯ïm&x‰ñâh¯þ«¯Æ¸Q›6l÷¿üâï‘$ò§”"’íJ]ê.nOUV`Cÿ <•dÿ ZFÎ»›6bi¹Ï–š“º˜Á‘¿YÏAÿ ÎùØµÛê_ó2<öFlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ› ÿ ž(_É:È^¿S”ýÂ¹ó=•ÿ 8JàùoP^âøŸ¾(¿¦z+6lÙ³Çÿ ó™þC{MRÛÍp)ô.Ð[ÌGicº-ÿ aøWþ0gšófÁ:fŸ.¥u°å5Ä‹sÁGüÏ§>ZÐ¡Ð4Ë]"Ûû«HR÷¡9²ûXe›8ßüåOŸO–<¥%”ÆïT&Ù)ÔFG+—ÿ ‘ºÿ žÙâO*ùvçÌº¥®‹d+=Ü«øGwoòQ~6ÿ '>—ywA¶òþm¤X¯{X–$Ê8Ôÿ ”ßi¿ÊÃÙ²™‚ÌhäžÙóóþróQ¿0<Äò[9:]•aµˆ÷—9ØÈ¥‰raÿ 8Ÿù@<Ë©Ÿ4j‘òÓ´÷’°ÚIÇÄ¿4·ødoø³Óÿ /=©žyÿ œÊóÉÒô.[µ&Ô¤å ï˜ˆjÏI½?ùùã÷oüâŸåøòÇ•QxÞj¤\=zˆú['üï¿ç¶v|Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžaÿ œÑò žÖÓÍöËñÂEµÁÑ‰h¿Ô“œóÕ3É9ôþqÃÏ'ÍÞN´–fåwgþ‰7cÓcþ¼&ÿ _–tüÙ³fÍ›<ÿ 9Uæƒ®yÞæ5‡ODµOšR_ù-#¯û€þ_ya¼Ó¯Øh‹Òêá©Ù+Y[ýŒ\Û>˜ÃB‹`* 
 t tìÙ³fÍ›6lÙ³fÍ›6lÙ³fÈ¯Ÿ¿44!Û}g]¹X™…c‰~)dÿ Œq‹ý›qùŸ<ËçùÍbùš,ZÇcifýì§ß‡÷ÿ «ûïõ³k_œ>oÖ˜µö­vÀþÊJÑ¯ü‹‡ÓOø\ >eÕs7w¼}W¯üKôoÍ¿6èÌÇV¼@?dÌÎ¿ò.Rñÿ Âç[òWüæf¿§2Åæ;xµ:¥ÿ î_ý_N?õóÓ?—›¾^óü>¦‰pê*öò|2§úÑþÒÿ —8ÿ ÊÉžlÙã?ùÍ)?ÌºôKDÔ àçÆHhµÿ ‘/üyúÂö[ˆ®íÏ¡u‘ƒ)ä§þ>ùg[^Òí5h?»»‚9—äêŸEpË6y—þsWÉ"âÆËÍ0/ï-ßêÓüñÂÇÚ9y¯üöÎÿ 8ÿ ç/ðŸœ¬/¸ÛÎÿ V›Ã„¿»«{G'§/ûú›6l&ó—–`óNw¡Ýÿ uwFOò’>	?Öøºÿ «Ÿ3õm2}*îm>íx\[ÈñH¾‡ƒø!žýÿ œuó¹ów“¬î%nWVƒê³xòˆ Œ}ÞIÿ Ölé™³g‹?ç3<¦4ß3[ëQ-#Ô ŒÒ7ÿ ’-yû6lïŸó¿óóy²ê?2kÑÑ`nQ£÷¡Ôì)ÿ ,ÊßÞ7û³û¥ÿ vpöÀØtÍ›6y£S]+I¼ÔÑmíå”ŸõŸøgËòjjzç¨?ç´â×zÅù
G@û±‘Ïü›\õžlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›#ÿ ˜šwé/.j–@TÍgp€{˜Ø/ãŸ2óÕÿ óƒÚ 1ki?h&Ø‰#øŠg©sfÍ›üïäë9i¦µ‚áiQÕ|QÊŸåÆÿ ÿ Í9ó·óòÿ Rò­.ª¥c†T?bhÏò·ü#|ñ.Fsg[ÿ œ[ò·éï;Ú;ŠÃ`¯vÿ 4bÿ ’òDsß9³g…ç,¼íþ!óséñ5m´¤ëáêŽá¾|øÄßñ‡$ÿ ó…þFÚµ×š.±Ø§£	?ïÙïÆ8>ùïžÃÍ›6q/ùÊßÌ£åO-þ‰³~7ú¯(…ëéþÈ2Â¿ñ‘¿“<[åo-Ýù›T¶Ñtõåsw"Æž¿iÛü„_ÿ É\úIä¯(ÙùCH¶Ð´áH-P-i»7Y%oòä~NØwž ÿ œšóyó'o87(,iiÿ ïºú¿ôðÒä7òçÊoæï0ØèIZ]LªäuŽfÿ c»gÒÛ{xí£X!P‘Æ¡UG@ ¢¨Å3fÍ›6lÙ³fÍ›6lÙ³fÍ›6Ô5;]6#q}4vðŽ¯+„QþÉÈ\‚jó¾DÓX¤Ú¼Ãýô_øhEÂè¿ç(/än?¤é^æ	€ÿ “Y*Ð?6<«æéš¥¬Ò‰êsÿ <äá'ü.JófÍ„^zò´^kÐït9éÆîŒû-JÄÿ óÎNþÇ>g^ZKe<–·
RX‘Ôõ§‹/ÐsÐßó…¾n6:íß—¥oÝ_CêÆ?âÈ|?Ö…ä¯ücÏdfÍ›6lNæá-¢yå4HÔ³ N|Àó®úÎ¥u©Ëöî¦’f¯‹±øÛ;Oüá·—F¡æÙu'Kg`|B!_ù&Óg¶³fÍ›6lÙ³fÍ›6lÙ³fÍ›8·çïüä5¿åügHÒxÜk’-hwHý™&þiû®ör|}Oëºõö½w&£ªÎ÷7Rš¼’“ÿ 4¨ý•_…g fÍ›6Òõ[­&æ;í>W‚æä’FÅYHþV\öüãçüä„~tá yˆ¬:ÈŽAð¥À¢\4fOµògzÍœ?þsË£Sòa¿QY4ûˆå¯ù/þŽãþ
Toö9á¼÷¿üâ®¾uo"ÚFæ¯g$¶Çý‹z‘ýÑJ™×sd_óGÊ‹æ¿-j)žâôÿ ã"þòÿ #Q3æ¯ÅwVSò ŒúYùeæñO–´ídš½Åº?ã &ÿ ’ªù&Í›6xwþrïÉƒCógéHW¾«—nžª~êqÿ &åoøË‡¿ó…¾q6ZÕç—%oÝßEëF?âÈ¾ÐëÂîÇþ1g±sfÎÿ 9•åñå(µ5…Ò1?äH/ÿ %=ñ.Ñ4ývålt«y.®_¤q)cÿ ÑÊÏQþPÎ!-³Gªùà¬Ž(Ëd†ªü¼Ê¿oþ1Gð4ö3ÓðA¬0¨HÐUQ@ Ø*¨è?6lÙÉ?ç)<Ôº’.âI¯ÙmPxó<¦ÿ ’	&x=¹ÿ 8oåÓ§yFMJAF¿¹wSâ‘
ÿ ÉE›;ÆlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›)Ð8*Â ŠŸ1¼ë ·—õ»í!Å­Ä±’±Ù/ÅCþq#Í£yÒ;I[ŒZŒ2[ïÓ¤ÑÃEÁ×ÏufÍ›6l‡þg~Vé?˜šiÓµTã"TÃ:Î&þdñSþìì¿úÜY|'ù¡ù?®~]]ú¤|í\‘Ì`˜ä?÷\ŸÍü_ë/Å|õ¿üá–}+-OÌ.óH–ÑŸd¬¿ðM,_ðéÜØSæß0ÃåÍ&ïY¸þîÒ”#’¯û6øsæV£6£s-íËršwi¼Y6?ðG>ƒÎ>ù4yOÉ¶Ž¼n.ë3xó—ã£{Ç§ûè¹³fÏž_Ÿþ>vóeÝäMÊÎÜýZßÃÓŒ‘Íã,œåÿ g‹þpÃòäsç;Äé[kZúH•áaVÿ ŒËž«ÂÏ3ëqèZ]Þ­7Ø´‚IÈRôÿ …Ï˜——r^M%Ìç”²³;Ý˜òc÷ç¡ÿ ç
ü¬/uËÝzEªØÀ"Cþ\Ç¨ùE‹ÿ =3Øù³fÍ›6lÙ³fÍ›6lÙ³fÍ5}^ÓGµ“PÔfK{XW“É!T|Îy_óGþsâg{$Æ"ˆlo&Z³{Á|(?Ê›“ÅIžróš5O1Nnõ‹©®æ?µ+–§ú¼¶Eÿ %p¯6lŸùóÓÍ~Je]:ñäµ^¶ó“$TðUoŠ/ùâÑç­¿(?ç$ôO?Ó®Gèý\ì!vªHåÞ]¹ø©¸Éü¾§ÚÎ¿›6xþrwÊÃËþw½ô×Œ7¼nÓþzÞÿ Éu—"•~e>ZóF›«WŠCrœÏù}9¿ä“¾}*Í›6lÙüäÕŽ“äý^ñMlåU?å:úIÿ ùós=}ÿ 8C£ˆ´­ST#y®#„h“Ôÿ ±Œô¶lÙ³fÍ›6lÙ³fÍ›6lÙ³Ÿ~wþiÅùs I¨-þbbµŒ÷¶Ãý÷
üoþÆ?÷f|öÔõ+Ræ[ëék™Ü¼’9©fcVcsfÍ›6lVÚæ[YRâhåƒ#)¡VªÊÃ£)Ï~ÿ Î=þnÌM•ÙV²ãÊ¹T~îáGòÍÇâþYUÿ gŽu,‰þmhãYòž­cJ—³˜¯úÊ¦Hÿ áÑsæ¾zçþpVõ4ý[L'û©¢˜øÈ­É…ÏMæÍŸ8:|¸<¹çSNQÆ5¸ix$¿¿Œ}	&z‡þpÏÌ?_ò¤úcš½…Ó <P%_ù)ëg}Í›6pïùËï)~˜ò‡é8Ö³i“,µïé¿îe{E#Æ<òå¿šÊ¾bÓõ°h¶×Ïî„ð™ÙDÎ¹ô½:‡SU" Žã/6Aÿ <4ÒþKÕíiSõW”x¿Òþ,ùÇžÁÿ œ#¿ŽMS³â¾¤7(å¨9q‘8ª–û\yBÙé<Ù³fÍž$ÿ œ»üÄ_0ù…4Gåi¥ŒAØÎÔõ¿äRªEþKú¹Ã´ë	µ˜¬­T¼óºÇŽ¥˜ðEúXçÓ$ùf/+h¶Z­¤	#ö˜Þ?û99>æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6x“þsÉ§GóJkQ- Õ"OoV "”È¿Eÿ ÙçÑuiô{Ø5+6ãqm*Kðd!×ñô»É¾h¶óV‘i®YÃwÈ^$ý¸ÏùQ¿(Ûü¥ÃœÙ³fÍžuÿ œÕó'Ôü¿e£!£ÞÜ‘
ÿ ÕI£ÿ ÏçÐßùÇ-ÿ ‡ü‘¦[°ã,ñ}eük1õ–¿(ÙýŽt|ÙÁÿ ç1|Ôt¯)Ç¤ÆÔ—RPø®/ßIÿ %=ÿ ežNü«ò§ø¯ÌúvŠG(ç}Aÿ ¯ïgÿ ’Hùô¥T(
 è3fÍœ÷óóÎ§ÉþP¾¿‰¸ÜÊŸW€÷õ%ø9/ùQ§9çž|õ°±šþâ+;e/4Î±¢Ž¥˜ñUú[>—yÊpùGC³Ð­©ÂÒ%BGí?Ú–Oùé)wÿ e‡ÙÉ¿ç)uÃ¥yõTÑîš+uÿ dáŸþI$™àL÷üáæ€4ÿ &›ò>;û™$¯ù)Kuÿ †ŠOø,îy³fÍ›6lÙ³fÍ›6lÙ³fÀþ½gåû	µ]NA¥²‘Ï`?âLßeö›áÏþtþwj_™7ÄÐi0±ú½°;Æi©öæoøþÂ~Ó?4Í›6lØèähØ:¬¦ ˆ#¸Ïaÿ Î5ÎD¿˜L~Uó<•Ô@¥µÃï€ÿ tËÿ /
>Ãÿ »¿ã/÷¾ÍžUÿ œßÐûŠÖÐoûÛg?ð3D?äöyW>™~\k§|·¦êdÕ®-!vÿ X¢úŸðü²E›6lÙÉç*/M¯/ÕzÊÐG÷ËÁsÀ¹î¿ùÄKmäXeññs<Ÿsz?ó+;NlÙ³fÍ›6lÙ³fÍ›6lÙ³Áó“Þo6y¶{xš¶Zemb íÉOúDŸ7›àÿ R8ó‘fÍ›6lÙ³gGÿ œóûy+Í–—nÜlîX[\ŽÞœ„gþ1IÂ_ö9ô7ºn"x_ìº•?")Ÿ-o-Í´Ò@zÆÌ§è4ÏEÎÞ”×u+Jí%¢¿üŠ¿ó;=‰›6x¯þs?C~j·ÔTQo-§Å£f¿äŸ¥†_ó„šß¡­êZQ;\[,À{Äü?â7ì,Ù³a_št(õý*ïHŸû»¸$„ûsRœ¿Øý¬ù‹yi%œÒ[N8Ë20ðe<X}ùôKò+Ìßâ?&iwÌÜ¥d=ùB}¯úÞŸ?öY<Íuk%¿³žÍ·Y¢xÏÉ”®|¸–3´m³) üÆzSþpƒPáªê¶5ÚKx¤§ücrŸó?={›6lÙË¿?ÿ 8aü»Ñ˜[2¶±v¥-S©^Írãù"ýŸç“Š?ŸóLó»K+‘ÉfbjI;–'Äç ç,ÛZÖ[ÍW‰þ‡¦šCQ³NÃoùzŸñ‘áÏhfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6sùÈ¯Ë“ç*Ï²ò¿³ÿ I· nYõ"ñ–.J¿ñg§Ÿ>óÒŸóˆ_›k¥Ý7“5I)ovüíŽË)ûp|§ûQÿ Å¿åMž¿Í›6lÙâ?ùÌ1~‘óri¨jš}²!åÉYßþI´9Æ|·£I­êvºT?Þ]Ï"ž.Á?ãlú{ik¤)mãJG€QÅq\Ùâ¯ùÌÏ2þóLJÇ§Û-G„’ŸUÿ ä—¡ƒç
ü±õÍz÷\‘j–Vâ4>1ëÿ "¢‘Ùç²3fÍžLÿ œÚóg©u§yn&øbFº”{±ôaÿ T›þFdþqGÊ_óœ7R¯(4Ôk¦¯NC÷p}>«úŸóÏ=á›<ßÿ 9¹©˜´=7Oûë§øÆœæ~xï>þIé_¢¼™£ÚÒ‡ê‘HG¼ƒ×oøi2k›6lÙ³fÍ›6lÙ³fÍ›6lñ—üåÇæÃëz§øGO“ýOjÜq;I?òŸòm¾Çüfõ?‘3Ï³fÍ›6lRÚâKiRxÇ,lM
°<•”öe9ô+òóA0¼¹ôÄ~·>Ò¾06–ŸË:|ëóOØÎœKþrÿ JžH{ŠTÚ\Ã-|*Zßþgg†3ßó‹:¡¿ò‚±«[´ÐŸ¢Geÿ „uÎ³›6lÙÄ?ç0¤áä‚µ§+¸GÏí·ükžÏ óŒpˆ¿/ôºmÉfcôÍ.uÙ³fÍ›6lÙ³fÍ›6lÙ°§ÍÚØÐ´{ÝY¿ãÒÞY·ñDg«>bÏ3Ï#M),îK1=I;“‰æÍ›6lÙ³fÏ¥•žao1y_LÕd<¤žÖ2çÅÀá/ü”VÉN|Äóœ>Ž·¨D?bîuû¤a‹þpÆR¾qF°–¿DöÎlÙæ?ùÎ(>Ÿ¤ê@oÓBOúê²ù2ÙÈÿ çµO¨ùöÅ	¢Ü$ÐŸ¦7uÿ ‡sß³fÍŸ<ÿ ç"|»úÏœ
)Ò‹”ùLÍÿ %×;ïüá?˜~³¡ê3šµ¥ÂÊ£ü™–Ÿñ8þ=›6|Åó­ ³×uQ°Šîtÿ ‘—:÷üá¥Ù‡ÎRÅ]¦±•~ç‰ÿ ã\öælÙ²ù»ùË¤þ[Xú×„M(?WµSñ9þwÿ }Â¿µ!ÿ U9>xÎžsÔ¼å©Í­kz—3ö(£ìEþÄiû+þËírÅ|…ä}CÎú¼–µšcñ1h?¼šOòÁ}…ø›>‹ù#ÉÖ>NÒ-ô-1iºR§«±ÞI_ü¹âoù§3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lð÷üå/åyGX:þ4EË#h¦?‘’’ÿ {üôO÷^pø¥xdŠºU¡t ç¹?ç?>áóÍšèºÄ5Ûu¦û}a|Ÿñhÿ wGÿ =SàåéöÜÙ³fÏšŸš>aÿ yŸSÕAªOu!Cþ@<"ÿ ’J™3ÿ œXòïéŸ<Ú;
Çd’\·ûáü–’<÷ÆlÙócógÌâ5êš˜5In¤ÈCéEÿ $Ñ3ÖŸó‡ž]ýäã¨0¤š…Ì’Wü„ýÂÃG'üw<Ù³gÎÿ ùÈ?1Îú¥ÈnQÅ7ÕÓÂCo›£7û,ôüáW–E¦…}®8£Þ\”ÿ ‘
ÿ &øônlògüçÙ7z5·eŽáÿ àŒKÿ g—óê'—ížkjPF”ÿ UUp~lÙ³fÍ›6lÙ³fÍ›6lÙüÅóZùKË÷ÚëR¶°3 =Ÿ‚ÿ e+"çÍ+«©næ{™Ø¼²±wcÔ³LÇýc‰fÍ›6lÙ³gnÿ œIó«h>m].F¥¶ª†½E¬–íóûqÏl÷6s¯ùÈ‹1wä=^2+Æ ÿ ð’Æ™óÃ=±ÿ 8aveò…Ä'ýÕ ûã…³¾fÍ›6pÿ ùÌHùù#—òÞB	þ6ÏçÐ_ùÆiDŸ—úQ­h³ºis§æÍ›6lÙ³fÍ›6lÙ³fÍœÿ þrV‹ÈºÃ&ÄÛô3*·àsç^lÙ³fÎ¹ù/ÿ 8íª~c©Ôe“êZJ1_X¯&‘‡ÚX#ªòãûR3p_òÛ’çfÔçôG·+c©]GsMšUGJûÆ‹Sþzg™ÿ 1ÿ -õ_ËýQ´a*rŽDÝ$N‚HÛþ$­ñ&Esg¿?çnoËý;—ìÔ|„ÒçXÏ˜¾v”K®ê2/F»œ¦GÎ¿ÿ 8d„ùÊf„¿òröÞlÙÃç1¬EÇ’„ÔÞÈ_ïEÿ 33Ê_’—ßRó¦5h>»
ìíéøž}Í›6lñïüæÖ…èkZv®¢‚æÙ¡'Þ&åÿ ¸Â¿ùÃsê~k¸Ó˜ü–Aâñ²È¿òOÕÏkfÍŸ6ÿ 8 yÇYŒv¿¸?|Œrkÿ 8“)O>[(ý¸'þ ·ükžïÍõJÛMîï¥H-ãy$`ª£ü¦o„gœÿ 5¿ç0,´õ};Éj.®z¹ô—þ0Æ~)›ü¦ãüeÏ'kzíö»w&£ªL÷7S¼’“ÿ 6ÿ *…gùOÊ:—›5´žêS°~Ô’7D?iÛ=óù/ù7aùi¦ý^"&Ôg ÜÜSíþëù`öö¾Ûÿ “ÐófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6l)ó_•¬<Õ¦Ï£jÑ‰mn‹ãù]ìÈñ£6|ùüÚü©Ô.5VÓïA’ÖBZÚà†Tÿ eO÷l³þ£#4?OÔ.4ëˆï,¤hn!`é"X}–VìÈïùÊK?2,z/šÝ-uM•'4X¦=¹~Ì3Ÿåþéÿ c÷yèLÙ²5ù—æðï–µ-X5½¬¬Ÿëñ+ü”eÏšê¯ùÂ/ÇW\qþú¶C÷Í7üÈÏUfÂ_;ëcBÐïõZÐÚÛM(ùª3/ü6|ÆbXÔîN})üªÐ¿@ù[KÓiFŠÒ.cü¶Q$¿òQ›%Y³`][PM6Î{é>Ä<­òE.V|¼½»{Éäº˜ÖI]‰cÉ³èwä…úÉM­8³Û‰Ûç17ó7'ù³Ç¿ó›¤þ›Óoª¿üœ9çqYœ‡ëÏ©°Š"à1ù³fÍ›6lÙ³fÍ›6lÙ³gÿ œÊÖM—“â²CCyw7ú¨¯7üM#ÏæÍ›6lÙ³fÃO+jï£j¶zœfkq ÿ ¨Êÿ Ã>Ÿ«†àî2ùÞ+ä­f¿òÅ7üG>qg²ç	Oüëº€ÿ —ßù•z/6lÙ³ÿ ÎWY› Þ¸0ÉŸòUþ7Ïç¼?çoEÇí£­LÏú\Ëÿ 3s²fÍ›6lÙ³fÍ›6lÙ³fÍ¯Î½5µ/&kÈ*ßS•À÷Aêÿ Æ™óƒ6lÙ³gÓOËí"ßHòöafÃ¬AiÞªŸæìK·ùM’ó÷üæŽ‘o?•­uë÷ŠˆÝøÈê'û/Mý†x³6}	ÿ œnÓNŸä-*6i#yäd’J¿ðŒ¹Òf”D#lª	?!Ÿ-uŸ­\ËpÝŽÏÿ yg¡ç	mù‡Q¹íŸø9¿æV{6läßó”öþ·5ÝDÑãž ò,ÿ W×ôÙ‡T¼·oºD9ôã6lÙ³Ïóšz?Ö|±g¨Vµ¼
O‚ÈŽü:Gžrÿ œ|ÕÎ•ç­"zÐ<þ‰ÿ žÊÐÌÌú#›6|ãüðÿ ”ÛYÿ ˜ÙâXmÿ 8Ý®Øè^u³Ô5Yãµµ'å$¬Eb‘V¬™¾õG˜?ç*¼‹¤"»{ÙìÛDÇþJKéEÿ œ“Íßó›÷¡òÖž–àì%¹oQ¾bø"Ÿõž\àþpüÄ×üã7¯¯^ËtAª£"ÿ Æ8SŒIþÅ29#ò£ò#^üÅKjŸVÓQîå†ßia^³ÉþJüÎéžÜü´üªÑ/,~¥£Çû×Öèd”ŽîÝ—ù#_?Öø²a›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙóÏ‘t¿;é’húÔ^¤º°ÙÑ‡Ù–'ý‡_ùµ¹&xGóòGXü·»"åMÆ™#R¤	ðIGûªoòíºÙ³œçdü¨ÿ œ×üÂúº––´)[÷‘ø¢ˆÐ¾äæŸÉéç¬ÿ /;ü¯çµTÒî•.Øom5P|Ã/üñi2{œ?þsÌ£|˜l”ÑïîbŠŸä­nñ‰?à³ÃyïoùÅ_/þˆò-¤Œ)%ì’Ü·û&ôãÿ ’QG{6r¯ùÊcôoµ&qé@?ÙÈœÿ äš¾xWÊšIÖ5{-4
ýjâ(àÝSþ6Ï§Ê¡@U`2ófÈ/ç¦¦tß$ë Ð›GŒøËûù™Ÿ:màk‰Ý‚™4Ï¨ú]ŠéöÙÇ²AF>JÕ‚sgç7á¦­¥KüÖÒ¯üƒÿ çšã~ÀƒŸS,¥Á‹Ñ‘HúF-›6lÙ³fÍ›6lÙ³fÍ›6y«þs{—è}.•ãõ™+óá·ümž@Í›6lac6¡qª™'Ö8ÔufcÅ¬Ùî¿Ê¿ùÆŸ.ùJÊ95[xµU”e™C¢·òAü
‰üü}Gû_ØY7›ÿ #ü£æ›f¶¼Ó ‰È¢Ín‹Š™^0¼¿Õ“š“žüÑü½ºò»>…v}A))A$mýÜ”ÿ …uý™×"y³êV’³€7ÚôÒµñâ2ùí0‡ÉË†ÒEÿ ‚ø?ãlùÍžÍÿ œ'„¯–o¥=øº(¿æ¬ô>lÙ³dóÃJ:§’µ‹eoªI ñþüÉ¼ùÇžÆÿ œ%ÕýmQÓI©·ºYià%@¿®ÏGfÍ›6lÙ³fÍ›6lÙ³fÍ‰][GuÛÌ9G"”aâqaŸ2|åå¹¼³¬^h· ú–“<U=À?ÿ ³N.0›6lÙ³Ùßóÿ ó:^¥¤Ûùk_¸K]JÍ1<¬&~¸Èß¬‹û¶Fûm9|\;Õþµc§Ànïn"†ÝEL’:ªÓýv<sÅŸó“ßÖ¾{º‡FÐØ¾•dÅÌ´ K)9 ?î¨“’Æß·Íÿ g†p¬¢é3ëÐi¶‹Ê{™R$,ä"þ¼ús éhÚ}¶—oýÕ¬1Â¿$Pƒþ#…?™z¸Ñü³ªjÐÃg;/úÜ'ü?ùŸž²ÿ œÒ¸Ûjú‘mà…Oú¢IþN&z‹6læ¿ó’)ÏÈ:°ÿ Šã?t±ð/—ß†£jÝi<gþsê&lÙ³g.ÿ œ›Ó?HyS«B"˜°‘¿á9g‚ôUôBÛRŒr{Y£˜
Ò¥IJÿ ±Ïhy{þsÉú‚¨­Í„ÃÇê/ûƒ›Ÿù¹1µÿ œ†ò%ÈªjðõÃ§üœEÅÛóëÈê*u‹_¡ëü3ÂŸšú½¶±æ½WP±q-´÷r¼n½K|,+üÃ"y³fÍžáÿ œ9Ôþ·ä¶·&¦ÖòhÀð#›þ%+gsÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ°.©¥Úê¶ÒXßÄ“ÛL¥^92°=™NyKó—þq$éÑÏ®y>@mcV–KIš…G'0Lÿ mTºåøÿ âÇû9æ,µb„2š¸#:’ÿ ç$|çåP°ÅyõËe¥"»¨§‚ÉUØËÇ/óŸóÚëó>nmVÓê^¡`ŽY]Ÿ‡ÅÅ”àùŸíg1Š&•Äh*Ì@ w'>ùGD]G²ÒPPZ[Åßä*¡ýXm–T‰yÈÁTw&ƒ<Ùÿ 9‹ç->óËÖº^Ÿuòµâ´«ŠåBÇ%9„'Y¿k8Güã¦™úGÏšLT¨Išcÿ <‘æðÉŸC3fÍœ‡þrºðÛùõ§­$	ÿ %Qÿ ãLñWåå—×¼É¥ÚÄ·¶ê~FD>™æÍžZÿ œã°¬Z5èý–¸Œý"_ø‹g”3é·5©y{M½¾µœ_s“‡Ù³fÍ›6lÙ³fÍ›6lÙ³g	ÿ œÈÑZûÉÉz‚¦Êî9ø+‡€ÿ ÃÉx‡6lÙ²kù+yoeç={²Ky$ôž(ßì\®}Íž1ÿ œÕ½·›ÌÖVñg†Ìz”íÉähÔýû<óÎyKG}kX²Òãk«ˆ¢ýwTÏ§ª¡@`3•ÿ ÎPê"ËÈ:óMèÄ?ÙKá³ÀîoùÃëoäu”ÿ »îç}!ÿ ™YÛ³fÍ›Ô,’þÚ[I·ŽdhÛäÃ‹gËÍWO“M»šÆaI-äx˜{¡(ßˆÎõÿ 8]æeæ[½)ÍöÔ•/_ù&óg´3fÍ›6lÙ³fÍ›6lÙ³fÍžOÿ œÉü±tš/;X¥cp°^PtaðÛÎßë/îýXŸ<·›6lÙ±Í#0
I tÆæÏGÎþX¾©ª?›ïSýÆ±ÛÔló0øœ{AÈÉù3ØÙÆ¿ç-<Â4¯#Ïl$¿š+qãJúïÿ 	öYá÷oüâF„tÏ#ÃpÂ}<Óý ý]á`ÎÏ›6s_ùÉáäXÿ ÅQ¾X†xËéÏQµ^•ž1ÿ ¹õ6lÙ²+ù­aúCÊz½·w±¸§ÌFÌ¿ðÃ>jä¢óò»ÍGw.—vmæE‘$H™Ð«hÞ¤aÓu8A>›uni42!™Hýcò± F'äpm¯—5;½­­'”Ÿä‰›þ"¹ Ó¿'|á¨ÓêÚ=é»@è?à¤¹,Òç<ù¨PÉeªžóLƒþ6•ÿ árs¢ÿ ÎjÒÐêÚ¼¸…Sÿ %>¯Aÿ œ3ò•Ržêõ»‚â4?ìb_SþKgœ?ç!¼Ÿaå7ÝiZD^…’ÇF€“NQ§/‰Ë1¬œÏÚÎçÿ 8?yÏKÕ­ßw?ü2ÿ Ì¬ôÆlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³g.ÿ œ˜ó	Ñ<‹¨¼f’\ª[/üõ`²ÉS>GHÁbh $æ’6ŒñpU‡b(q¹±ÑÈÑ°t%YH ƒBî2@?1üÌ­}Où‰—þkÆKùæ)…$Õ/X‰Oüo…Wz­Ýî÷SI)ÿ -ËÄŽÎáÿ 8yaõŸ;	©þóÚM'ßÂù›žäÍ›6pßùÌixy$/óÞB?ádoø×<©ù#«ç]i_ôØOÜÜ¿†}Í›87üæ^õÏ'Åx£{KÈØŸò]^#ÿ ñç‰3è/üãF´5_!é­Z¼
ð7·¦ì‰ÿ $øgOÍ›6lÙ³fÍ›6lÙ³fÍ›<ÿ åhüÙ ßhRP}nE'³Ó”OþÂPŸ4o¬¦±žKK•1Í´n§ª²ž.§ýVÄ3fÍ–	SQ±êŸÊ¿ùÌ8-l£Ó|ç¯4J]Â¡ž2U½Oæ’>\ÿ “$¾nÿ œÌòí•³‡àšöìƒÔ_N0|d$úþª'ÅüëžDó?™o¼Í¨Ï¬j²nî_›·OeU²ˆ¿/ì®çsÿ œDòCkžký1*Ö×JŒÈIéê¸1À¿òr_ùåžáÏ<ÿ Îjë_VòÕ–šêï™+7/øycÏçÑ/ùÇí#ôW‘´ˆ¡{Xÿ Ïfkù™6lÙ³gÏßùÉ,ÏáE"¼+tžþ¨¬Ÿò\K‘¯Ê5…<Ñ§k,xÇê$?ñ[þêoù$ïŸIÁTnlÙ³fÍ›6lÙ³fÍ›6lÙ°³£ÚëVsiº„bk[„1ÈÐ«
úëösçççWäåÿ å¶¨`pÒé“’mn)³÷ÔŸË<µüÿ Þ.s¬Ù³fÍ›'”¿•—æ>ªº})kspGÃÆÒ¿ûª?Úÿ Q]—èG•ü³cå6KÒ´¶@ˆ½ÿ Êf?´îß·í>gç6<Ö.uK/DÕ[Xšy þiOÁ÷Xâåÿ =sÍÂó:Å,îB¨I;ŸM¼‘ååòæ‡c£-?Ñ-ãˆÓ»*€íþÉù6æÍœ£þr–àCù¨ƒÕÌ
>™¢Ïù>½§B7/wýò Ï§9³fÍ€µËo­X\ÛýHdOø%+Ÿ.H¦ÙôòvèÝy;F”îM¸?ìQSþ5É{(n¢¹B$€>ìvlÙ³g‡ÿ ç1íý/:«ÓûË([îiSþ4É‡üàåÅ'Ö ®Å-šŸ#2ÿ ÆÙëÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gç65—l, šó™÷Æÿ õW8üã~–5>éQ‘UŽG˜ÿ Ï8ÞUÿ ‡EÏÞiwÂ—pE0ÿ ‹[þ$2?{ùSå;íî4‹>?WŒ¼.\ÿ Î=yãíéõ§ü›uÂ¹ÿ çÿ /æ5ýSýYæó7ŸùÅ øò“þ’%ÿ šññÎ*y3S`íó¸›øI†ö?óŽþC² Ç¤@Ä¿Éÿ ']óÍó—º>›¢kö:v‘m¤)d¤ªZIEXF¦‰ûXoÿ 8GkË^Ô®’ÑSþ
Eoù—žÅÍ›6pŸùÌ¥'Éq‘Úúà&åßÈ—	ç}·O­ ûöÏ£³dó¿ËÇÌMÕlrslÒ ñh¿Òïh³çzóþp“Ì‚m3RÐœüVó%Âòe_Méþ«B¿ðyéŒÙ³fÍ›6lÙ³fÍ›6lÙ³gŽÿ ç.ÿ )_KÔ?ÆzrVÎð…º
>ÄÝSþEÀÿ ’ßñ•sÍù³fÍ›6l^ÊÎkéãµµF’yX""Š–f<UTx±Ï¡¿‘ÿ –)ùyåØtÇ¡¾—÷×N;ÈÃìü¯×ý^·<cÿ 9£æ1{æKMVÆÛ“˜ò?òJ8siš|šÔ60
Ë<‰òœ„_ÄçÔ+OM´‚ÆîíãH—äŠâ8+6lÙ³g˜ÿ ç6<žg²°ó4+V·sk1Êÿ ¼„ŸòVE‘ç®y>‡ÿ Î?yØy¿Éö7ŽÜ®m×êÓøó‹àäÞòEéËþÏ:.lÙ³fÍ›6lÙ³fÍ›6lÙ°¯ÌþWÓ¼Ña&“¬B·“
27ìº7ÚG_Ùuø—<kù·ÿ 8«­yYä¿òê¾¥¥îx¨¬ñø²5þùWýùû8Ó8[¡BU=AÆæÍ–vs´~TÎ/ëÞrt¼Õ•´Í(Ð—‘i,ƒþ(…·ø¿ß²üËê}œö“|—¥y;OM'D„An›šnÌßµ$¯öžFþoø×1“ÎFÓJÁc@Y˜ô nIÏšß™¾po8yŽÿ ]bx\LÆ0{F¿»~ˆ•2Mÿ 8áäóæ:XÄëÊÞÍ¾·/…"ø£¯úÓúIŸA³fÍœ/þsQÞK[zïsySÙD’ÿ Ì¼ò¯ä¥‡×üé£AJ®Dä{#z§þ!ŸG³fÍ›)×*{ŠgË;øý+‰cþWa÷úÿ 8û7«ä]¼-øÿ À³/ðÎƒ›6lÙ³g‹?ç56Z0êlþNÏ†ÿ ó„JêËØÛÄ~çlõælÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³g—¿ç8Ü‹]{.OÜ!Îgÿ 8o=Û“Õ`œø?Ç=Û›6lÙ³g‡ÿ ç1æõ<ê«ü–P¯ü4­ÿ dÃþpr
ÜkSx%²ýæsÿ ç¬3fÍœSþrúßÕò4þûº¿Oøß<‹ù?t-|á£Jzûq÷È«üsé.lÙRF²)GV ÷>f~`ye¼¯¯ßè®(-nÝ+X›ý”\'¿ó‹~n]ó­´R·5kGð«Ñ¡ÿ ’é³Ï{æÍ›6lÙ³fÍ›6lÙ³fÍ›ë:=¦µg6›¨Æ³ZÜ!Iº?çö¿g<ùãù¨~\Þ5Ì®4I[÷3Ò¥+ÒŠ}™ì¿Ø—ö~.H¼«6lÙ³bA%Ä‹*^G!UTT’v
ª:±ÏfÎ7Î;Ÿ)„ó7™]×÷þ®¤}§ÿ ——_ù¿ÛfãèL§uK¹TT“ÐŸ4ÿ 3|Ö|ÙæMC[­Ræv1×ýö¿»€È¤L—ÿ Î1ùTùƒÎöE—”6\®ßÛÓþëþž,÷ölÙ³fÍ‘¿Ì'Çç/Þè2Ò·1„þÌƒã…ÿ ØÊ¨ÙóVîÖ[9žÚáJKu=C)âÊ~M÷þpóóhºì¾[ºj[jkXëÐO%ät\Óü§H—=£›6lÙ³fÍ›6lÙ³fÍ›6lÙ²çOÉ¯*ùÌ´šÅ„opßîèë¿L±qgÿ žœó‘k_ó„š,ì[JÔ®mè²¢JÒ¿W9?óƒ—<¶Ö£ãÿ 0Æ¿ò{tùÂ-&ªj—Žëkü3›Œë>Küò—“™fÒì#7+Òy¿{ >*òrôÿ ç’¦O3fÎ1ÿ 9Wù„<¯åWÓ­ÛîªMºS¨þ>_þ ú?óÛ<%žËÿ œ4ò!Ó4K2Ü-&Ô_ÓˆŸ÷ÌDŽCþ2MÏþE&z'6lÙåùÎlÒt…;“5Ã—£ÿ ™¹Í¿çôoÒz·œŠ­œ3Nà}ÿ †Ÿ=á›6lÙ³åÎ·þ÷ÜÆi?âG=ýÿ 8çÿ (‘ÿ _þNI#6lÙ³fÏÿ Îj8>l´QÔX'üŸ¿çÖº¦¬Ý…¼CïvÏ^fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³g™?ç8m‹iúEÇdštÿ ‚XÛþeç%ÿ œQ¼þ~²BiêÇ:É'øÓ=ë›6lÙ³g…ç/$çç©GòÛ@?áKÆÙÑ¿çãýÎµ%jØSèŸ=I›6læó’úw×¼ƒª(1¤röÆíÿ Ë<åËÿ ÑÚ¥ïOBx¤ÿ €eáŸP•ƒ Ãpwy³g¿ç3ü˜l5Ë_1Â¿º¿‹Òÿ Å±l+þ¼øÄÙç«K©læK˜¤±0taÔ2žJßAÏ¥Ÿ—~o‡Î–½?Ò¢Vp?fAðMû	U×$Y³fÍ›6lÙ³fÍ›6lÙ³fÀú†o©[Ég{Mo*•xÜVöY[cžbüÑÿ œ8»êI”%jÆÎvÛåo9éþ¤ßò;<Ûæ#k~V”Á­ÙMhÕ 2!
Ô“û·ÿ `Í„Y²ÕKª*O@3¦yþqÛÍÞqdxmÎÍºÜ]ÓÅV_ö	Çü¬õ§å'üãÎ…ùxì®ê´ÞæP>«Ç¸‡ýoŠ_ø³ÃO6r¿ùÉo<)ù>ëÒn7wãêøþðYÿ ØAê|_ÏÃ>ç°¿ç<–l´›Ï3N´{Ùþû‹ûÆÏ3qÿ ž9é,Ù³fÍ›6x‹þrãòèù{Ìc^µJYjÀ¹§E¿_ùëðÍþS4¿ËœCO¿ŸN¹ŠöÑÌw:ÉŽªÊy#õ[>þUyþ>y~Û\‚‚I„è?bUÚTûþ4ÿ ŠÝ%¹³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÊ’EK¹
ª*IØ ;œùåùõù–|ÿ æYï¡btûÜZŽÞšŸïç»ò“ý^	ûòW•.¼Û¬ZèV#÷×r¯ò¯Y$oòc”þ®}+Ðt[mÂßJ±^Ö±¬QòTqOó`ìÙ³gƒç+¼Ì5¯;Ü@‡”VÇl¾Õ—î–WOö9Ñÿ ç|ºkªëÎ6ýÝªù-7üÈÏUæÍ›6lùo¬?;ÙØw•Ïü1Ï _óŽ©ÇÈZ@?ï–?|’èÙ³fÍ›6xsþsìOçoLîláCô™%ÿ ™™6ÿ œµ<õ«žÀ['üŸlõnlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿ œÅÑ÷“ÚŠ›;¸¤'ÁX<þTÏ'~Pk« ù·JÔ\Ñ#ºŒ9ðW>”‡þÛ>’fÍ›6lÙáOùË¸ÊùêbjÞ?àxÿ Æ¹Ò?çä†µ~vÇðŸ=G›6l!óþúoËÚŽ˜MÅ¤Ñ¯úÌŒþ>dçÒÿ ËMlkžYÓ5 jg´…›ýn!dÿ ‡å’\Ù³þyükå;»W•äë6þ>¤`žÿ cõ"ÿ gŸ<3Ô_ó†?˜Â®|›xûK[›ZŸÚý"!þ²•Ô—=c›6lÙ³fÍ›6lÙ³fÍ›6lÙ±;‹h®PÅ:,‘¶ÅXÍNCuOÉ/%êl^çG´äz”ŒFOü‰ôðº/ùÇ?!FÜ—H„‘âÒ÷4”ÉFƒä/ù|†Òtë[WµH­ÿ NðØ›6lð¿üåwæ(óO™Î—jü¬taZšSþô¿ûU‡þy•œFÒn5‹Ø4Û%çqs"Eø³žøçÒÿ &y^*èöš§÷V‘,uþbÇ'ÎGäíþ¶æÍ›6lÙ²ù¿ùwŸü»s¢½Á¥»ŸÙ™»?ê¿÷oÿ »gÎkëì.$³ºCð»G"6ÅYOV÷VÎÁÿ 8Çù¸<‘®~ŽÔ_Ž“¨•I	;G'Hgö_÷\ßä|î¬÷nlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³Ïó–Ÿ›£ËúgøOMzj‚~ü©Þ8Å×¹ûñ‹ÔþdÏç¯ç¿+…œžsÔ“]ƒ #q?½›þ{:ðOòùeÏKæÍ›¼Ç®A é·:µÙ¤‘<Ïò@ZŸ6Ï™:Ö­6±}q©]Ïu+Ìçü§bíø¶{ëþq¿ÊGË>J°†Eã=Ò›¹;Ëñ%ÕƒÒ\é¹³fÍ‰^J!†IODVo¸gË9_ÔvsûDŸ¿>Œ~FAèy#FCÞÎ6ÿ ‚ÿ ãlœæÍ›6lÙóÛþrCUý'çÍV@j±Èùä‰Ã«g~ÿ œ&Ó>^Ô/È§¯vj\Ùè¼Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³dkó/ËâŸ-ê:({›wXÿ ã áÿ ’ª™óH†‰¨j®§äAô—òŸÎ+ç,Øk@ò’XUeö•?w?ü”Vÿ c’ÜÙ³fÍžÿ œÅ‡Óó°oç³…¿þ5É§üàÜô—Z‡Åm›î3ŒõvlÙ³gÍ?Í.-ùŸRÒiE‚æ@ƒü†>¤?òI“=wÿ 8æaªù;ôsµeÓ§’*wàÿ ¿Œÿ ÁI"ÿ °Îã›6lð'üä·å±ò_š%–Ý8éú‰kˆ(6ŸßÃÿ <ä?
ÿ ¾ž<ç\×î¼½¨Ûêú{p¹µ‘dCî§£’ße×ö—>‘yÎvžtÑmµëû»”–µ(ãá–&ÿ *7ªÿ Ãdƒ6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÎ?>ÿ 3Óòÿ Ë’ÝÂÀj75†Ñ{ó#â›ýX÷ŸëúiûyóÑÝ¤bîK3’w$œôwüáÇå±Ôµ9|ßxŸèö5ŠÞ½f¼qÿ aoø9Wù3Ø™³fÍ›6lÙ³ÉŸó—¿”	¿ÇTº“Š^ª²ßf+ŸõdÚ)ËôÛýØÙåìö‡üâ·ç`ó’ùOX“ýÉÚ'îŽóB£ìÿ •4ÿ Çû6z6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6D4¿2l?/tYu›âO±5¡–B>×üŸÚ‘¿b<ùÛæ2^ù›QŸYÕ$õnî\»·oeQû(‹ð"þÊd«òWòºÌ]~-4¶1R[©ìÆÙýù7÷qÿ Áý”lú!cc„ÚZ ŽQR4Q@ª£Šªû*âÙ³fÏ;ÿ Îdyüiz$>W¶j\j,$”ÐÆk¿üe›üŠ“<ÁùSä§ó§™,t5Å4 ÌGh“÷“Ÿù¬«þ_úKkˆãQ@ €ƒ›6lØIç›ß¨èÝièÚNÿ ð1³gÌlúgùueõ-iv´¡ŠÊÝH÷¥rC›6lÙ±ûØ¬-å»¸<b…G>
£“øù…æ^MgQºÔæþòêi&o›±ÿ Ä³ÞóŒþ_:/‘tåqI.Uî[þz±hÿ ä§G6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÎKù¼£æë‡‰xÙj$ÝB@Ú®üó›—Ãþûxòyÿ 8sùšºeüÞO¿~0ÞŸVØ“°˜ÞEÿ =£_‡ü¸¸ý©3Ø9³fÍ›<cÿ 9¯iéùžÊà»,T}+$¿ó^ÿ œ"»ã­êvßÏjÿ  _ù›žÂÍ›6lñüæw”NŸæ+mz5¤Z„ÿ Åüï…¡ÿ Àßó‡>qO™åÑ&jC©ÂBƒþýŠ²Gÿ $½uÿ ÏkæÍ›9×çÇå‚þ`ùr[€ý!oY­Xÿ ¿u_åwþ·ýŒùé<ÊRD%YXP‚6eaâ3·ÿ Î-þp'jÇBÕ$ã¤ê. f;E7ÙIÉIº—þy¿ÙL÷lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lØõôIwvë©wv4
ª931ðQŸ=?<5%üÅ×ä¿RWO‚±ZFv¤`ÿ xËþü™¾7ÿ aû¯"WòÝç™µ;}MNwWRÐvêÍàˆ¿·ì¢çÒ/!ù6ÓÉº-®ƒ`?ulKR…ØüRÊßåI''ÃìÙ³fÍ›6lØRÓmõKilocY­§FŽDaPÊÃ‹)ÏŸ?ÿ ”w_–úÓZQŸM¸%í&=Ó¼NßÐý—þo†OÛÈ.•ªÝi7Qj4708xäSB¬:žúüŠüê´üÈÓ))Xµ‹eæµ{}bþúù$ÿ ~Ã?OÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³aWš|Ó§ù[N›XÕåÚ@¼™Sü¨‹ûr9øQ?k>}þpþl_~djí¨ÜÖ+Hª–ÐV¢4÷þidûR¿û°‰‘-E»ÖïaÓ4èÚk«‡	/ROùüMû+ñgÐ¯ÉŸÊ»_Ë4Ø©%ä´’êaûrS¢ÿ ÅQ}ˆ¿àþÛ¶O3fÍõ-FßL¶–úñÄVð#I#·EU™Ésçæ·Ÿ§óç˜nµÙª#‘¸@‡ö"_†ùñøßþ,wÏIÎþ\?OŸÍ÷‰I¯kµFâ%?½“þ{L¼çùyéLÙ³fÍœûþrSw‘uy«NVæ/ùËüÌÏžv­yq²}©]P|ØñÏ©¶ëm
@Ÿf5
>@SÍ›6lÙÅç+¿0Ë^U}*¥î­X¢.·/þ¯Üÿ Ï\ño”<·?™µ{MÔ~öîdˆ ÇâõcNNßêçÓM:Â-:Ú++aÆ#XÐx*
?àFÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÎcÿ 9ùV?0¼¼ð[(ý'gY­O‹S÷Wùg_‡þ2,Mû9à(f¹Ó.VXËÁunà‚*¬Ž‡ïWFïOÈ_ÏOÌ]=m®™b×-zñtæßX„#~Úÿ ºŸáû<º¾lÙ³g”?ç8´ò&Ñ¯€Ù–â"~F'_ø“d/þpóPú¯½Þ›I£ùRoù•žãÍ›6låó“~F>kòuËB¼®´óõ¸©Ô„Ö_öP4›:¦xKËúÝÆ…¨[ê¶gÅ¬©*t<…}¿›>—ùSÌvÞfÒ­u«X.âYWÚ£âFÿ )àò—sfÍžAÿ œ·üœ:mÑó¶“ú-Ëxª>Ä§e¸ÿ R³'ü]ÿ ³Í9íùÅ¿Ï!æ[Dò¦·'û”µJA#ç‰GÙ¯íO
ý¯÷ä_ÚY3Ð™³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÈŸó•ŸžcS‘ü— Ë[Xš—²©ÙÝOûÌ§ý÷{üÒüî¶çælöoüâwäáòýø·VŽ—÷ÉKta¼pùûIqö¿ã÷ãç¡óe;¬j]ÈU’v žcüöò_—‹%ö©‘z¤$ÌÕðãn$ãþË9æ¯ÿ 9¡åKRVÆÚòèøðD_øy9ÿ É<‹Þÿ Îq ÚÓE'ÞKš~	ÿ ‰a{Îq_’8èð…îìOü›Á6ßóœ’×ý#ER¿äÜ‘ÿ ƒ$:güæÖ)ÿ N»€¦2’ÿ Ðäë@ÿ œ›ò.²B@ZÈfå?ù(G£ÿ %3¤éº­¦©¸°ž;ˆOG‰Ã©ÿ d…—dcóò÷Nóî‘.‹ª/Âÿ rñE ûÇþ¯í/í§$ÏžÞò¥ämV]WN2Çº8û2!ûÄÝÑ¿á[ào‰p•üÑ¨y_P‹WÒ%h.àj«ÿ ÌŽ¿¶ö]íg½%ÿ ;ôßÌ› ¾­
^ØŸù+~Ü-ÿ ØÙgéY³fÍ›6lÙ³fÍ›6lÙ³fÍ›
|Õæ½7Êº|º¾³2Ái©cÔŸÙD_´ò?ì¢ç‚ÿ :ÿ ;5Ì»ðX}*ÝÕíëôzÓ4Ì¿ìcû	ûlüâ(žgX¢Rîä*ªŠ’OEQÜœ÷üãoä8ò5 ×5¤[¹M”ïõxÏû¨ÅÏþîoùä¿·êwÙ³fÏ+Î^~q?ÀÚL•?ß:ŸöQZÿ ÌÙ¿çš¿8å_åíÏŸµë}Ú«žsÈ?Ýq/÷²|ÿ a?âÆEÏ£šN—m¤ÚC§Ù ŠÚÞ5Ž4¨â£îÁY³fÍ›8Oüæ>´,¼œ–@üW—q%?É@Ó·ü4qç•&4ÓqÒ,éPnâväÆ}gÿ „³élÙ³fÈæ_çW—¿/àfÔ§^Ò©k+Ü—ýÔŸñdœÉåösÂ?™_˜Ú—æ¯&³ª	"‰~ÌQ³Ä¿mù6zþpëòªDi<ï¨ÆThlƒµøg¸òb?ùíþNz§6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍždÿ œšÿ œx“Uy<ßåx¹]ÊîÙòS­Ä+Þ_÷ôîßï÷œ½O)é½æ‰wþ+ÛÝÀÜ’D4e#üþ%ÿ bÙëOÊùËûESNó —[(»Aû§÷•â¿Ê^QÆ,ô^©[jP-ÝŒ©<*²FÁ”ò]~›6yóþsOI7>W´¿QSmx û,ˆãþ&‘çœçuÑ^yÒ'&çôOüöV·ýrgÑÙ³fÊt
°H¡¡ó§ó¿òñ¼‡æ{­-T‹G>µ±ñ‰É(¿óÉ¹Bßñ;‡üá§æh+7’oŸqÊâÎ§·[ˆþO¨ÿ ŒÙê|Ù³`]WK¶Õ­eÓïãY­§FŽDmÃ+
2çÏ¿Îÿ Ê¿Ë}a­¨Òi—½¬Çº÷‰Ïûú/²ÿ ÍðÉûyÓu2æ;ë)ˆX<n†Œ¬¦ªÊsÞžÖ¿˜¶BÎô¬:åºþú.‚@?ãâü§ýÙû©¿Èáo6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžvÿ œ•ÿ œ…O.Å'•|·-uI[‰ÿ p§¬hßòÒßòCþ2}’I©ëËþqŸò9¼é~5íb3úÍöVO(ÜEï}fþoî¿Ÿ‡¸@ PlÕµ{=ÚKýFd·¶ˆry$`ª»6y¯ó#þs2f{/&Û‰ØT}jàŸ8 ø]ÿ Ö•£ÿ Œyç?7þhy“Î[[¿šá	¯§ËŒcýX#ãü&E³fÍ›6l1ÐüÇ©h3‹­&ækI‡íBì‡éàwÎíù}ÿ 9®i,–Þh‰u+a±• Žp<výÌ¿&Xÿ ã&z›È™Zží~¹ Ü¬ÜiÎ3ðÉ=¥ˆüKþ·ØoØvÂïÍ¯Êm3ó#L6ãÓºŽ­opZ6?ñ8ŸýÙí®ªÙàO<ùTòN¥&­Dc™7V¤‹û2Äÿ ¶ÿ 6¿øp³DÖït;Èµ-2g·»…¹$ˆhAþŸÌ¿e¾Ëgµ?#ÿ ç&tÿ :,z>¼RÏZ U="œÿ ÅDÿ w)ÿ |·Úÿ urû	Ü³fÍ›6lÙ³fÍ›6lÙ³fÍßÌÏÍòòËëz¼µÁômÒ†IþUý”þi[à_õ¾ð¯æ§æî±ù}õ­M½;hÉô-ŸN0ârÛ•¾&ÿ %>…CÎë*^G!UTT’vUUXç³çÿ ç—Ê¢?2ù•jÌ+qní?Ïü™ÿ _ìú6lÙ³“ÿ Î@~vÁùu¦}^Í–MníH‚>¾˜û&æQü©þë_÷lŸä,™àÉ$¹ÔîK¹yî®$©;³»¹ÿ ‚ww9ï_ùÇÉõü¼ÑyÞ(:½èW¹n¼û®ÙO„Uøÿ š^_³Ã:¶lÙ³fÍžBÿ œÚó ŸTÓ´$;[Bó¸Í+pJü–ø|â–þ|ŸÈšÔ:ý¤1ÜM p«-xüjcfø
ž\Y³½Øÿ Îq\.×š27¼w‰ÿ âXsüç–¾Òg_õfFýj˜'þ‡sBÿ «mßüóV¹ÿ œáÓ”£é¹ÿ .e_øŠI‘½Wþs{W”¦évðžÆYOø€·ÎoæùÉ/;ù‰Z)uµ…¶)j¢.¿ñb~ûþJç4–W™Ì’1gcRI©'Üá—•~§úZÏô¤~­‘ž12+Ê2ÃÔ^Kºü9ôæÎÎ(RÖÕ("PˆŠ(ª qUUF-›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›<ÿ 9VtõóÅÌl1ÂcŠ!?¦(V³ÈÀmÏ„‘««ñ|YÉE¬Æ/¬ðoD7t<yR¼y}žTýœ8ò·žµÏ*KëèW³Z1ÜˆØñoõâ?»“ýš6v,ÿ Îhy’Àõ‹[{õXV?Js‹þHçHÒ?ç5¼·qA¨ØÝÛ7~%_¿œMÿ 	’›OùÊÿ  ÜSä“Ùà—þe£ŒˆþyþtùÎO¾Ò¬5–ñÂ<)éJ	tu’•x•W’«/ÅžCÒu4ËÈ/áþòÞT•~hÁ×þ#ŸP4ÍB-JÖësX®#IPø«€ëø›6lÙÆ?ç(¿+œü¾uå©é¥@ïû¾sEõcÿ )8/÷™â-]»Ð/àÕtç1Ý[H²FÞOo²ËûKŸFÿ ,¿0,üû¡Á®XÐc­Lr¯÷±7Ëö?ž6Gý¬”æÍ›#žò›ç&]VJÅ&èãíFãìMìéÿ ¿|-Ÿ>2¿-õ?ËýUôUÊ†`>	Södþ7O÷[|8C¢ëWš%äZ–›+AwŽD4 óø—ì²ü-žåü‰ÿ œ„±üÁtíD¥¶»üQôY€ë-½ááûIû<“;lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ9ÎAÎME¡,¾\ò”‚MHÕ'¹]ÖÌŸÛ¸ÿ +ìÃÿ »ñÜ²¼®ÒHÅ‰,ÄÔ’z’s¥~GþJÞþdê_ht‹væz}>„?Í3ÿ É%øßöýõ¢è¶š%œ:f›Áin#z ?Ïâo´Íñ6yãÎºw’ô©µ½Yø[Â6í;±KûR?üÜß¶xó_óYüÇ½3ß¹ŠÊ2}T'‚ÿ ~KüÒ·û	ðä6lÙ³fÍ›6l3òç™u-^Çªhó½µÜFªè~õaö]ö‘¾Ïu~Bþz[~dÙ{ °kVÊñ²ëö~±ùûiþêòY%_™_–:GæštÝb?‰ja™¼‰íÆßñ8Ûàøðæ§äþ³ùq{õmM=KI	ô.PNAÿ 2åþh›âþ^iñäFÄg ¿'¿ç,5-ˆô¯5¿Ó–Š³Yãå¿Þ„åþ÷ü¶ûë¯+y¿Jó]šê:%ÌwVíûHwùdO·ÿ ê­†ù³fÍ›6lÙ³fÍ›6ldÓ$ÒÌÁ#@K3 RÄôçoÍÏùË?F¦ù;õæênNð¡ÿ Šÿ å¡ÿ äùR}œòF¿æCÌ7’jZ´ïsw)«I!©ù’£öQ~ýœ­A¾×ï#Ót¨^æîcDIÿ šT~Ó7Â¿µž×ü‰ÿ œo³ò"¦±¬ðº×¨=c‚¿³óKüÓ±ùŸ¶æÍ›6s_ÎŸÎÝ;òÚÄò+>­2Ÿ«ÛWþKMO±
ÿ ÁIöö™<æo3_ù›P›WÕ¥3ÝÜ7'cø*ÙD
"ý•ÏRÎ.~A6œ#ó—˜â¥ËVP8Ýÿ ©ÿ »ýÒ¿°¿¼û|8zs6lÙ³fÆË*Ä†ITPI'` êN|ÛüØó™óŸ™¯õ°IŠiHŠ½¢OÝCÿ $ÑY¿ÊÉ×åÏüâîµç
/0ZÝAl³³ˆã˜>ê§‡©Íý§WýŸÙÁwŸó‡>u€ŸHÙÌ?È˜ù9xS7üâŸŸãébþ­Ä_ñ´‹¿èWÿ 0?êÖä|õ[Ûÿ Î(yúSF²Ž1â×ÆŽØ¥ÿ Îy¶äÖòâÊÙ×wo¹#ãÿ “ï.Îi°úæ¥5ÇŠ@‹ùsÎßð©’ŸÌoÊ/+ù+ÈÚ»èÖ1Å0µaë8/)©îÙ9:ÿ °â¹áûPLÈ^CõçÔäÙE|2ófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ˜šnsæoæ/˜˜¼Å¨êÕªÜÜÊëþ§#é}ÑñÏaÎ+ù:Ú?!'×áI£Ô¦–wI2²ƒõtä­U#Œ<¿Ùbžqÿ œHò†¼Zm=eÒçmÿ pkã¼€ÿ V&‹8÷˜¿ç<ÇfKi–×¨:åÿ ÀŸR?ù+œÿ Uÿ œvóÞ˜H—Iš@;ÂRZÿ È–s‘«¿ËŸ2Ú.4«Øé×•¼ƒþ4ÀcÊ:Ç.Q¹åáè½â8†½¢Üh—Ói·ŠVh£)ò?ì—âÏqÿ Î*ùÔyÉÐZHÕ¹ÓÚ¸ïÀ|Víþ¯¤ÞŸüòlìY³fÍ›<3ÿ 9=ù8|—«kMŽš> å€Q´RŸŠH?ÉGþòòyÇþêÂ/È/Î9.5ŠÜ–}"ì„ºŒoÇù.#_÷ä_òR>Iö¸q÷åôðGwhë,(tu5VV•”ø‹æÍ›"Ÿ™?–Ú_æ–úN¬ž-Ê>8Ÿ´‘Ÿøš}™<ù›ù]«þ^jGNÕ’±µL3¨ýÜ«üÈ›ýùÚOøh¥­Ô¶’¥Å»´sFÁ‘ÐÊFêÊËº°ÏY~IÎXÅx#Ñ<îâ)Å;îˆÞèºßþ.»ÿ ~zm½7©*	#!‘€*ÀÔzqÙ³fÍ›6lÙ³fÍ›6lÙ°.««ZiÒ_ê¥½´C“É#UìsÈžó•Wð“Dò{=¾žÕY.·YeÖ/Ú‚#üßß?üWö[Î9Ô?%?"µ/Ì›±+r¶ÑâjMrGZºmëöåÿ „‹í?ì£ûÃË>YÓü±§Ã¤i,/UüYí»Ÿ‰Ý¾Óa¦x“þróómoÌ¿áèœýKKP
Ž3€ò¹ÿ Q"_åýçóçÍ›6lÙ³fÍ›6l?ò'œnü­Zë¶$‰m¤V»:¥‰¿É’>IŸKtëøµh¯mÏ(gdCâ¬9©ÿ 8†» Xköriº¬	si(£Ç ¨?óKÙeø—ösÇÿ œó‰ú‡—Ìš¯”ƒßiÂ¬Ðuš!þOü´Gþ¯ïÈ·ž{e(J°¡{aÇ•|ã«yNìjÌ–·©C³å‘Á"’êËžœü¸ÿ œÍ¶œ%Ÿœ­Ì2túÕ¸,‡ü©`ûiÿ <½OøÆ¹è¯.ù«Jó-°½Ñn¢»€þÔLžÎ>Ò7ù/ña®lÙ³fÍ›6lÙ±—ÛÆÓNËh*ÌÄ ‹1éœ[óþr¿ËYo¤±Õ¯E@šDùw?e¿çŠËþÇ<¯ù“ùãæ_?±SŸÒ²­VÖ¤CÃ˜¯)›ü©Yÿ Éãœÿ :'å_än¿ù‹0k(þ¯§I.å §UŒužOòþz:g¶,?(4?Ë«O«é1ó¹5Ì”2IþËö#þX“áÿ Y¾,›æÍ›6pßÎïùÉ­?Ék&‘¡¼Ö¨Tkþ-aýä«þù_ùëÇì7‹5Ívû^¼—RÕ&{‹¹Û“Èæ¤Ÿà¿Ê«ð¯Ù\ôÏüãŸüãK3Eæ¯7ÃE{[9^ë=Êßï¸ýi‘½Y›6lÙ³fÎ+ÿ 9Yù<«å–Ò­^—ú·(V‡u‹þ>dúU½ùëþFx«Ê¾\¹ó6©k¢ØŠÜ]Ê±¯µOÄíþJ/Æÿ ä®}.òæ…oåý:ÛH²mí"H“ä£OùMö›sfÍ›6rïùÉËáiäL÷Eÿ e,cþ#žò­™½Õì­Fæk˜Sþ	ÕsêlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ‘Í-{ô•õ=L<6²”?å•áü”eÏš€4“ŸM¼… /è~’­´Q·úÁG3ô¿,=Í›6lñÏüægN«ÛùªÙq~¢)ˆí4cà'þ2Áÿ &_"Ÿó‹˜ƒÊ^iK;§ãcªo%z¯ú4Ÿò0ú_êÌÙïÙ³fÍ„þnò¥‡›4Éô]V?RÖáx°îìH‡öd¾4lùåù£ùk¨~^ëi€,Ÿj	€¢Ë~ü¯Ù‘?aÿ à³§ÿ Î7ÎB'È¾[ó“£Jßº”ïõvcÿ PÎ~ßûí¿yüùíH¥I‘e‰ƒ£€ÊÊj=O†;6lØIç%é~qÓäÒu¸DöÒt®Ì­û2Dÿ j9ù¿ã\ð÷ç7üãÞ¯ùw+^CÊóFcð\(Ý+Ñ.Tvßñg÷R’ß»ÎOKò›þr_ü½eµVúî•]í¥'áþ¯&í	ÿ 'â‹þ+Ïbþ[~vùsó04¹Äw”«ZÍE”xñ_³*ÿ —ò¸ä÷6lÙ³fÍ›6lÙ³fÍœŸóKþrKËžFkƒPÕ£êð0!Oü¼Mñ$_êürÿ Åyã¯Ì¿ÎóãÕÕæãl„˜­£ªÄŸì?mÿ âÉ9?û„goü€ÿ œv¸óÜ«¬kjðhHv§ÂÓ°?b/å‡ýù7ûþ.M¶´&ÓHµOÓâH-aP±Æ‚Š x›>s~z[Éõ”˜ÆîFþV<Óþ— ™³fÍ›6lÙ³fÍ›=Ãù+ÿ 9å´=;B»¾·Ö¶ÐÀâäzjÌŠ±žÜñ¨øy:·ù9Ü!ž9ÐK…U”ÔâÇç,üÓÿ œvòïŸ¹Ý²}GT?ñóÿ —ˆ¾Äßë|2ÿ Å™äOÌ¿È_2ù ´×ÐýcOk¨*ÑÓþ-nÿ ò»g9Áú6½¡ÜÍ.â[[…èñ9FûÓ;W“¿ç0üÓ£…‡XŽRµ\zrÓþ2Ä8ÁÂÙÚ|¯ÿ 9äýWŠj^¾›)ëê§4ú$ƒ›ÁD™Ô´Ì?/y€¥j6·$þÊJ¥¿ä]yøfÍ›6lªkÚ~ž®¥s²xÍ" ÿ ‡+œßÌ¿ó“þFÐÁQ}õÙGìZ¡’¿ó×àƒþJçówüæÅôá¢òÖž–àì%¹nmóÇÁÿ ­$¹Âüãùæ?99mvú[„­Duãÿ VøÄ?à2/’'y[ó•ÏÔôI.¤¨äTQ½å•©ìÛ=Kù[ÿ 8}§éE58H·×"„[GQ
Ÿø±¾Ÿþ?øÉžŠµµŠÒ%·¶EŠ$UU¢ª¯Â£Í›6ùÇÏZ7“­þ»t–ÑoÄ1«9³kñÈßê.yó{þr¿Tó8“LòÈ};Nj«KZO ÿ Y¸Cü±üñgìgÒt‹Íjî;:'¸º™¸¤q‚ÌÄû~¼ö'ä_üâí·•Ìzçš‚\ê¢4PæoÙšuþoîãýŽmûÌôlÙ³fÍ›¼¼†Ê	.®\GJÎîÆUG&föUÏ_œß™þ`ùŠ}\ÔZ¯î­þÌJ~¿šOŠWÿ -ó¸ÿ ÎþYÍçkäþh,ë÷\N?äÂ7ügÏUfÍ›6lÙÂç2u!käÔ¶®÷7‘%=•d—þ4\òÇäŽúGÎº<¨úäNG´gÖ?òo>ŽæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœOþr÷\ýä—µSF¾¹†{)7ÿ &3È•šéï4éziY®â?ÈOù&­ŸJófÍ›6D¿5|‡ž¼»w¡KA$©Ê?±*üP¿üÂÿ ñ[>|à¾²ŸN¹’ÒåLW;#©Ø«)âËóVÏ~ÿ Î=~h/Ÿ¼··]JÊ]å€ýÜÿ óÝ>/øËê¯ìçOÍ›6lÙüÓü°Ó14–ÒµÂU«A8hŸù×ù‘¿Ý‘þÚÿ •Á—ç÷Ÿ|…ªyT“FÖ#á*n®>Ä‰û2Äß´ÿ öâÎ±ùÿ 9'?“z˜™§ÑI¤r}§·¯ò÷’ßù£ûQÿ º¿ßmí7S¶Õ-£¾±•'¶™CÇ"ÊÀþÒ°Á9³fÆOoÄmÊ²Fà«+ Aª²Šœó7æÿ üâ7¦MWÉa˜ÕšÉÍü»Hºÿ ŒR~ïù^?³žUÖ´;íéôýR	-®¢4häR¬>ƒÛÁ°,Éo"Í‘*ÊH ŽêÃ¦wË¿ùËo2yp%®´­f´ñ˜iè}OùìŽßåç¤¼ÿ 9äÿ 7Š+±gvßî‹ªFÕðY	ôdÿ a'/òs¦«”ÔÁy³fÍ›6lÙ±;›¨­ciîc‰Yœ…P?ÊfØgóßüåW”|²)N©v»p¶ûÿ .å¿wÿ "½oõsÍ˜ßó“jó˜{d—ôuƒmèÛ	Ïýìžü}8ÿ â¼äÙ³Ò?ßó‹“ë&-Î´6<VPò÷VŸö¢ƒüï%ÿ !>ß¯í­¢µ`8£PªŠ UeUQ²¨Å0³Ì^hÓ<·j×úÍÌV–ëûr0?Ê£í;Ÿy×óþsFÖÜµ¯”-~°â \Ü‚©óŽ¤ÿ =/õ3Ì^pó~£æýJ]kXKw592ª¨¢Ž8 Qð¨ã„¹³fÍ›6lÙ³fÍ›6K<“ù©æ?%HC½’ëS	<¢oõ¡~Qÿ ²ûåg¦-ç1´ÝP¥—›¡ú„æƒëU¡'ü´ø¥‡þJ§ó2g¢,5}F»²•'·rI#`ÊÃÅY~ŠÉÊ¦9 d`ATz‚3…~gÎ%è>e/{åò4«æ©â¢°9ÿ */÷OúÐü?ñSg•|ýùAæO"HWZ´e‚´[ˆþ8[å*ýŸõ$àÿ ää36X4Üaî“çß0iý¨ÝÛÐG;¨ÿ Vã’›/ùÈ¯>YÐG«ÌÀ¿þN£á¼_ó•¾ŒPßFÿ ë[Åÿ Æ¸öÿ œ±óñ‘qoüÑ…×Ÿó“>ºÙµF@’(—þ#r9ª~my·To5{×SÕ}wUÿ €FUÈ´÷\9’ggsÕ˜’~ó‰ã‘F€³@äçIògüã·œ¼×ÅíìZÖÙ¿Ý×_ºZx…oß?û›=ä/ùÃmJ+sæYßRœoé%c„zZ_ø8ÿ ãw½#F²Ñ­–ËL‚;kdû1Ä¡T±\›6lŒyËó7Ë¾MŒÉ®ßEnÔ¨Ž¼¤oõ`NR·üóæüæ}ÍÀ{O'[z
j>³p?Î8(Óþz4Ÿñ<å¯ùQóÓ_ê÷]\¿W•‹õE~Êÿ ’¿t/ÊÏùÇO1yô¥×¨éf„ÜÌä?åÞ-žoõ¾¿âÌöWåŸäþƒùymèéò¹p·2PÊÿ ì¿a?â¸ø§û/‹&Ù³fÍ›6lÙæùËßÍñmøJ“÷²€÷¬§ì§ÚŽÛýi?¼—þ+à¿îÆÏ8þ[ùïÏZå¶…ePfjÈô¨Ž1ýì­þªýŸæ~	ûYô{@Ð­44==;[XÖ8×ÙGo´ÍûMƒófÍ›6lòßüç­Æ#Lvyæaþ¨Ž4ÿ ‰¾s?ùÄ½/ëÞ{¶”Š‹Xg˜ÿ Àz#þl÷†lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžUÿ œáÖã‘¥)ÿ NÃþ8ÿ ænsßùÄ}ô‡ža¸"¢ÎÞi¾’>®¿ò=Ù›6lÙ³gç0*NŸxžtÓ“ýèˆîÀfZR9¿Õ™Gÿ ‹Sù¥ÎSù!ù¡/åß˜"ÔX–°›÷WH;ÆOÛýù~ñ?Ù'íçÐû;ÈoaŽêÙÄÊ¡ÑÔÔ2°ä¬§Á—Í›6lÙüÌü¯Ò0ôÓ¦êÉGZ˜gP=H›ùÿ /óÆ~ÿ eðoæå6³ùu}õ=V>P9>ÂéÊòŸÙ“ùâoÕâøiùEùé­~[Ü¶o¬éŽÕ–ÑÏÂkÕáo÷L¿å/ÂßîÄlößå¿æÎ…ùƒkõaë([w –?õÓºÿ Å‰Ê?ò²c›6lÙóÏå¾…ç‹oªkÖ©8à“ìÈŸñŠUø×ý_°ß´¹åŸÌùÃÍcGçwåY?IZý¢Î£Û¤Sÿ ±ôßþ*Î©iwZ\íi–÷hÑÈ¥X|Õþ,’ß)~ly£ÊT]Qž—¤E¹Çÿ "%çü&v/,ÿ Îkkv€G®XÁx£«ÄÆú¾þ:n‡ÿ 9“åàüwVOß”bEÿ ‚…™ÿ ä–NtÏÏß#j@zÅ²×´¬bÿ “â<’ÚyÛB¼ Úê6’×ù'¿â-†)ªZÉB“FÕéGøãdÕìâ’x”{ºã…—¿˜]±ÝjvqSùî#­ò-ªÿ ÎEyLÕÕ¡ŽÐ‡–¿ò%r¯ÎhùbÎ«¦ZÝ^8èHXÿ ²fy?ä–rï3ÿ ÎfùŸP="ÞßOCÑ¨e²’‘ÉãÞgóî»æ—õ5Ëéîû…‘ÉQþ¤_Ý§ûÂØeåï-ê>c¼M3Hînåû)©ÿ Y»"/í;|ûYìÉ?ùÅË)õ2ð½Õ…#ë'üšÿ }2ÿ ¿àO÷Zÿ »3½ãe•!F’V
Š	f&€Ô“žsüÚÿ œ¼°ÑËé¾NU¾ºVºoîPÿ ÅCí\7ù__ñ—<¥æ¯8êÞk»:†¹u%Ôç¡s²åÁ’Š«„Ù>ò/äg›<ëÆ]2É’Õ¿ãâÝÅOgø¤ÿ ž)&Kÿ 0?ç<ËåKÔ¬Ù5DU&t·Vç;ª7Ç4å*óÿ ŠøüYÄÈ ÐìFVlÙ³fÍ›6lè•?‘úïæ-À6Q˜4å4’î@x
}¥ýý/ù	ÿ =3Ùúä/”t­=Kn¢]ÞIÐ4®çíJeûhÇþ+eà¿
ç5ó¿üáŽ‹¨ŸË72XLwKYbùrþþ?Ÿ)ÕÏ8~`~KyŸÈŒ[W´cjÄ_Gþz/÷êÊ±¶A²oùkùÃ¯þ^Ü	t‰‹[1¬–ÒU¢ö°ÿ ñd|_=µùIùß¢þd[¡·ÕõÅe´Žkþ\gýÝùkÿ =3¡ã'‚;ˆÚ•^7e` öe=sŒyûþqCÊ¾f-q¦«iWm¿( 1þU³|?ò%¡Ï:ùãþqgÎY--´Sµ]ùÚîÔÿ *Ý¿{_øÇêÿ ­œ’æÖ[Y„håCFWÊVÜbY³a¶‰åMO]<tËw¸jÒ‰Bàzä²×þqûÏW?Ýè÷¿ÏÅ?äã.H4ïùÄß>^SÕµ†ØòÎŸó$ÊÙ3Ñ¿çµy¨u]NÞÜB)ÿ ‡ú¾t_.ÿ ÎyOO£êrÜß¸êÄhØÂ=Où-_Ë?—]ò¸¡tû{f¶¨ý37)OüHófÀ÷º…µŠnåHcZF
?à› žaÿ œ‚òF…È\êÊëûõ˜×Ã÷Eÿ ‚lå~hÿ œÙÓ —ôé® {†¯Ï„~«·üyÆ|áÿ 99ç_2†ˆ]ýBÝ¿ÝvƒÓÛþ3U®?ä®rÉ¦–æC$¬ÒJæ¤±%‰>ýNtï ÿ Î7y»Îf[ccfÔýýÕPã_ßIþOÁÃü¼ô÷å·üâ×–| RîùJ_­©:MOüUmñ'Ó/ªßËÇ;  
€Í›6lÙ³fÍœûó³óbÛòãDkæ£êÖ;Hí=?¼aþú‡íÉþÆ?ÛÏžúŽ£u«ÝÉ{xí=ÕÃ—wmÙ™Xý'=Ïÿ 8×ù=þÑ¾½¨¥5@š½bN±Û|ÿ noø³áÿ u.v,Ù³fÍ›6xŸþs7Xúß› ²SðÚY #ü§gÿ Âzxwÿ 8C¤zº®©©‘´6ñÂües'ý‹ç¯sfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍž"ÿ œÊÔÍ×œ£¶¯ÃmgSÝšIOàë’oùÁý/ö¯¨‘ýÜ0Âúìò7ü™\õ¾lÙ³fÍ…¾dòõŸ˜ôëRORÖê3¯±ý¥ðt?7ì¿ÅŸ9¿2ü{ä=n}øWÓ<¢’”Dº•Ökù$æŸ³žÿ œGüçžFÖ$ñkÿ ²{Jÿ ÃÁþÎ?÷Úçª³fÍ›6l,ó'–tï2ÙI¥ë%Í¤£âGs)ûHëû.ŸçŽ?8ÿ çõO*™5O-Ô4±V(fˆ”«ýôkþüâþxÿ o8Ž“«Þh×I}§M%µÔF©$lUÿ YsÓ_•ÿ ó™K;D\
yïóžÜ}¯õàÿ ‘9é¯.y§Kó-¨¾Ñnb»·?µCü®>Ò7ùÅ°Ó6lÙ°‹Í~DÑ<ÛÕµÛ8®Ðl¯Ä¿ñŽU¤‘ÿ °uÎ	çOùÂ­>è´ÞX¾{V;ˆnG¨Ÿ%•)*õ–lâkÿ œoó·—94¶u
ÿ »-ª?à÷Ãý”YÎ.­&´Ãr‹Õ\#æ­ˆæÍ–:efÍ›6lÙÙÿ *ç5ÿ :¾ÔÓ4¶¡õ$_Þ8ÿ Š!;ïþü“Š/©žÄòå–‡ä;O©hVâ2Gï%oŠYŒ²õoõ?»_ØEÉNy³Íºo”ôùu}fe‚Ö»¤þÊF¿iäÙEÏ~tÎDjß˜R5©k-†?žtËö¿ã÷Iþ[|yÈó¢~XþEyó	Äº|^……h×SUcÛ¯§ûS?ù1ÿ ³dÏZþ\Î2ù[É¡.'‹ô– »ú× þ*·Þ4ÿ eêIÿ g[ A°³™þcÿ Î<ù[Ï%®n`ú¥ûÇÍ½‰ñ•?»—ýg_Sþ,Ï8ùÏþpóÍAitG‹T€t
DRÓÞ9O§ÿ 3«œ{_òn³åç1ëW„¿ceýVaÅ¿Øá6lÙ³`­?K»Ô¤XÃ%Ä§¢D…Ûþ9Ô<¥ÿ 8½ç_0•i-Ÿë%Ûp?ò$sŸþIç ?/ÿ ç|» ²ÝkÎÚ­ÊïÁ‡ÿ Œ@–“þzIÃþ+Îíkk¤Kº,q 
¨€*¨²ª»(Å3ce‰&CªP«
‚b3þkÎ%èþbjXã¦ê§ÒýCþ ÿ yÏùQ|ñVyÍžOÕ<¥|ú^·nö×)Ùº0þxÜ|2!þtÀZF¯w£]Å¨iÒ¼P0häCFR?Ïý–{Ÿòóòßó×ô~£ÆrÝjè6Y”»áòv/ØûKð}žÃ›6ù£ÈZš£ôµË.Ç@Ò ä?Ô”~ñ?Ø>q5ÿ ÎywPå&‡u>Ÿ!è­I£ûŸ„ßòY³‘y—þpÿ Î:_'Óþ¯¨Æ:zRpù?¦¿ð2>rýòëÌ^_$jºuÕ¸´ñ7ùOLÿ Ádw4¿8ëZM?G_\ÛS§¥3§üA†Jì?ç ü÷c´ZÅÃSýùÆOù<²aý¯üå—Ÿa§;¸e§óÛÇÿ 2Õ0Æ/ùÌ:§Ú['ùÂßñ¬«ŠÐåùÓý÷cÿ "_þ«`yÿ ç0¼ï%x›Hëü°tÿ ƒwÂ›ßùÊ_?Ý
@D?â¸"‰ŽFµ?Î9j@­Î±xTõ	+ ÿ ‹€Èî¡s|þ¥Ü¯3ÿ 4ŒXýíšÇN¹¿AgÏ)è±©cÿ µ9Ñ|µÿ 8ßç|†‹N{híÝì$ý÷üYØ<¥ÿ 8H ¬¾eÔ‰éX­Ÿò^aÿ 23¹y/ògÊ¾MâúE„K:ÿ »¤¤µñõeäÉÿ <ø.MsfÍ›6lÙ³fÂo8y¿OòŽ™6µ«È#¶j|XþÄq¯íI#|(¹óËóCó&ÿ óY—YÔ?ƒUŠ0~×ßö¤Û|ìßóŠ?’U¸O:kqÿ ¡ÀÕ³‡÷’)ÿ zÿ }ÂßÝÿ <ßñ‹âölÙ³fÍ›6|ìüÿ Öÿ LùãV¹’¥Á„|¡oÿ 2óÑÿ ó…š/Õ|±w¨°£]Ý•ÅcEQÿ òg¡3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžÿ œ©•¤üÀÔý•·åèÄs²ÿ ÎB£HÕei®cSòHÿ ‰ç¥sfÍ›6lÙÊÿ ç ÿ 'cüÅÑ¹Z(Å˜g¶nœ¿žÙÏòËûÉ/ÙçžçL¹ý¸.­ä÷WGCÿ ŽŽ¿ì[=çÿ 8ùùÓæ&•è^2®µf \'Ncì­Ôcù_ýÙþû—ü–:ÆlÙ³fÍ›9æ¯üãO—¼óÎöØ~ŽÕ§×‰G?òñÂ¯þºp“ù™³É˜ß‘Þfò³êvÆ[ vº‚¯ÿ Y©Ê/õfTÈ§—¼Ñ©ùnä_h×2Ú\Ú‰ŠÔ+vuÿ %þïþEÿ œÐÕ,BÛù¦Õoc ¤rüÚ?îd?êúß|ÿ 9äß5…K=B8'o÷MÏîž¿Ê=OÝ¹ÿ ŒR>t5`À2šƒ¸#/6lÙ°»YòÞ™­§¥ªÚAv)4jãþ6sÝkþqÈz­XéÂÝÏíA#Çÿ Òÿ „Èf§ÿ 8Så™‰6W·°{1ŽAÿ &ãoølŽÞÎ¯[]hg¶þ+>Éÿ 8=¨û½^}àaÿ 3-?ço9ë@Çþf®/sÿ 8m¥èð›­sÌ+«4+ÿ ÁË=2®h?”~Yª-î£®\¯ì[”Ž*ÿ •3F¿übisŸk¾qÓæ¬:“m§CüÌ^âcþ´×%‘çŒdT’MO\ê?—óŽ>kó¯Ò¨Ø6ÿ X¹1Eýì¿äü>ŸüYžªü²ÿ œkòÏ’8]<¤5%ß×œøÁñÅþ·Ç'üYc6y§ÌöWÓ§Öui6–ëÉØõ?Êˆ?iÝ¾_Úlùÿ ùÅùÁ©~dêfêä˜¬!$[[²/ó¿óÌÿ îÇÿ b¿A ‚K‰T¼ŽBª¨©$ìªª:±ÏVþIÿ Î&GÇ­yá9ÈhÑØ×eð7d}¦ÿ Šáÿ ~òþï=?oo´k±Ä€*ª€ÑUFÀb™³fÍ’%•JH)Ø‚*EuÊ_)jäµî“g#¬!Uoø4
ù¼ÿ œ_òÑ¯èßLÿ ÅsL¿‡«Lÿ B™ä/ùd›þ’$ÿ š±{oùÅ_ By“ý{‰¿ãY$:gäW’tÒßGµ$t2'«ÿ 'ýL˜Øivšt~”1Áý˜Ð ÿ @0NlÙ³fÍ‘_ÌoËMÏúsišÌU¥LS-‘7óÄÿ ñ$ûûyàoÍ/ÊýOòëUm/Rãj´¨¢JŸÌ¿ÊëþìöüžÑÝ]¼Ðo¡ÕtÙ7vî7^Ä~µo²ËûKð¶}ü£üÊ¶üÃÐaÖ`¢OýÝÄ@ÿ w*Ôoï#ÿ ŠÙk&y³fÍ˜Šìr=­~]ùs[¯é=6Òáí<([þ?øl„ê¿ó‹žBÔ*ÃO01ïÒ/ü)vOøLŠêó…žT˜ÖÖîúáÎ7ðÑrÿ †Â+¯ùÁÛ¯Õõ‰WÃœ
ßñ#ÂÙçç¯îµ¤#ü«b?æ~3þ„rïþ¯1ÿ Ò1ÿ ªØ"ùÁ¶Û×Ö‡¿_ë>ZÎi	þõj·2©'üHË’-7þpçÉv´7òä÷õ&
?äŒqÄ²c£ÿ Î?yI¡·Ò-Ý‡y¹Mÿ Q&N4í&ÏMOJÂ­ãþX‘PÀ \›6lÙ³fÍ›6lØYÖlôK9u-JU‚Ö/$Žh çð¯í7Â¹àoÏ_Î«¯ÌJ‘r‡H¶b-¡=Oo^oøµÿ ä’|ûlâ $n?1µ/^ð4z%«<ƒng¨¶‰¿ÿ Ýþêü¶=ícc„ÚZ"Å*EUGU
1lÙ³fÍ›6lù¡ù—¤O£ù›S±º¯«ÜÕ'¸.]ýš2¾z×þpûÎvzŸ•Î€œR÷M‘Ë¯wIY¥I¿à™¢oåà¿Î¹Þ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžÿ œµ²ú·Ÿ.d¥=x “îAüÊÎÿ 8;~ÛX²'u’Þ@?Ö¡ÿ “kž¡Í›6lÙ³fÏ0ÿ ÎUþEÕ“ÎÚuo¡Aö”ÇÒ/ó þÿ ù“÷¿³'/1ù?ÍÚ‡”u8u­"ONæ¨ðaûqÈ¿µ‹ðºçÐŸÊ¿Ìý;óHMWO!&Z-ÄÕ¢’›©ñFûQIûkþW5YŽlÙ³fÍ›$k"”pXP‚*=Žqï?ÿ Î,yOÍE®lã:]ãoÎØLŸòíîÿ äW£žuó·üâ‡›ü»Ê[ÓT¶µnyOò­ß÷•ÿ Œ^¶rí>çO•­¯"x&_´’)V5z6ùgó+Ì~W#ô6£qlƒöÉOùü¢ÿ „Î«åÿ ùÌŸ7iôMJ+[ôK!ÿ à¡+ü’Î‡£Îoir€5].âÜÃ"È>é>¯“=7þrÛÈ—”õn'¶'´°?üÉõ†H­?ç ¼‹t+±n?×äŸòqS£üâòtŸgZ°ÿ ¤ˆÇümŠËù±å©ÏY°ÿ —˜¿æ¼qùßä¨>Þ³dÕ•[þ!Ë	oÿ ç&üƒf7ÔÄ‡Â8¥oÕÇ"º¯üæo”-ApÞ]7jF¨¿|’ÿ „È>·ÿ 9¿võ]IŽ?¸”¿ü“‰bÿ “™Í¼Åÿ 9Cç­h¢Î3û6¨þJsÉ\æz¦³{«Jn5‰nf?·+³·ü–Ã-y#[ó<žŽ‰e=ÛV„Æ„¨ÿ ^OîÓý›goòWüáŽ¹¨q›Ì—1éñÌqþö_–Ô…?äd¿êç¡<‡ùå/%ñ–ÊÐOv¿ññsI$¯Šrœ_óÊ4Î‹›6lðßüåçùÃXmN’ºFœå~´³†I¿ÊH÷Žör»3‰EÊâ8Ágb¨$ž€ö×üã¯üãÔ>M‚=^ŒI­ÊµD`¶Sû+ÿ /ýÙ'ìvŸ¶ÏÝófÍ›6lÙ³fÍ›6lÙ³fÍ›6C?6-,ÿ 0ô9t‹ pÛÌFñÊÀßê7Ø•i?ÊãŸ:µ}&çG¼›M¾CÍ´ˆz†SÅ†vùÄÿ Ìò×šWIée«ÐJ7¶™nPÿ Ï_òsÜù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ€µ­jÏC³—RÔå[{H´’9 üþÊý¦o…sÂ¿Ÿ?Ÿw˜×_R²åo¡ÀÕŠ#³HÃýß?ù_ï¸ÿ Ýëç"ÏgÎJíå‹äf%Vù‚‚vŽ#¶z6lÙ³fÍ›6y‡þrÿ ò‰¯"wÒÒ²B¢;ÕQ¹A´W?óËû¹â¿M¾Ìmžmü½óÝÿ ‘uˆ5Í0þò#GB~ÿ yŸä¿ü+q´¹ôGÈžwÓ¼í¤Ã­é/Ê‡Ä§í#·ƒö]?æõøpÿ 6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍž4ÿ œØÓ½/2XÞ´Ö\	÷I$þ®)ÿ 8K¨ú^`ÔlIþúÐIOxäUÿ ™Ùì|Ù³fÍ›6lÄ;ƒž-ÿ œ–ÿ œo*ÎþgòüuÒ&jÍ÷ØõþY¤o³þúÝýŸO9Oå§æN§ù}«&¯¥5GÙš~	c¯Åÿ Æþëo‹>€þ]þbi~~ÒÓWÒª~#o·þÔR¯ò·Ùuø—$ù³fÍ›6lÙ°«_ò¦“æ(½bÒ¸û	£V§ú¥…WýŽr_3Î!y7V-%€ŸNïû™9%ãþ§ü#¦rýþp“W„³hÚ•½ÂöYÑ¢?z}aâ9ÏõùÆ>i„ŸÑÿ XAûPKÿ ÂrY?á2!¨þYy£M$^iW±S¹·’Ÿð\xáÅ…Å±¤ñ<gÁ”×óc•Í}°ÊËÊÚµñ¥¥•ÄÄÿ ¾âvÿ ˆ®IôÏÈ¯;jtú¾tèdOH}óúy6Ñç|ë~A»¶Jzú²ò?ð6ë7üK:'—ÿ çm#£ëš¤’ø¥´a?ä¤¦_ù5OËóŽHòñœ—2¯íÝ1ÿ €“÷?ð1gH¶¶ŠÖ1º,q¨ U  =•qLÙ³fÎQÿ 9ù­oä/Ïmo8]bö3²ñ€ß—}rôÙ¿Ý¿ì³ÀYéùÄÊDÔî[Îš¢r‚ÕÌvŠÃf”}¹ÿ çÙþ-ø¾ÔYëÜÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6xÃþs3É©¥ù†Û^x¦§Sýûfÿ eÃÿ œÆö[ˆîíÏau‘ƒ)ä§þ>ŒþX~lhß˜vïK”„QëÛ¶ÒFÇù—ö£¯Ø‘~ÿ [áÉ¦lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lØGç/:i^NÓßVÖæX-Ó¥wgnÑÄd‘¿—þ5Ï
~t~yê™7|¶ÚLMXmÿ ’³Ÿ÷dßð‘ý”ý§p“ÿ “z§æV¡õ{PaÓá#ë$|(?‘?ß“·ìGþÉø¦#ùáå;/)y¶÷DÒÑ’ÒØB1©Þ™›¹wflôgüá$µòö£òÞ÷ÆŸóNz76lÙ³fÍ›62x#¸¡™CÆà«+
‚£+)ê§<!ÿ 9ù/åö¢u9Khwn}&ëè¹ø´‡þL·í§ÃöÑ°“òKó’÷ò×Tõ‡)tË‚ê zŽÒÇá4³üÿ Ý·ó/¿´vË_±‡TÓ%Yí.<n½?ñ_²Ê~%o…°~lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍž]ÿ œâÓy[èú€eçˆŸõ„n¿òmó˜ÿ Î%êBÏÏvÑAsñÂzßó'=á›6lÙ³fÍ›»´Šò¶¹E’T££
«)ee=U†xþrþqö"Ü6µ£#I¡LÝI·cþê“þ*cýÔ¿óÎO‹IÏ-?35_ËÝQu]%ê¦‹4,O	Sù$ònOµ²V÷×å¯æv“ù…¦®§¤?Ä(&…ï"ä‘|?’O±'üKsfÍ›6lÙ³fÍ›65ãYâ¸ôKûvðšøÆ§øbqùoL‹xí ZøDƒþ5ÁPéöðÿ u'úªêÅófÍ›6lÙ³güïÿ œˆÓ/¢m>À­Þ¸Ãá„¬Ué%É_øX¼òãÏy“Ìº‡™oåÕµyšâîsVvüGEEû(‹ð®µ¶’êT·„r’F w,x¨ûóé—‘|«•4K=Üª?i©Ydÿ ž’söX{›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ:ÿ ÎmZ£ysO¸?m/x“G!où6¹ã\0Ð|ÁåûÈõ-&w¶ºˆÕdŒÐoò”þÒ7Âßµž´ü¥ÿ œ¼±ÕBi¾sgw²‹¥¹øÊ¿ñîßåsÿ ³Ñ–÷1\Æ³Àë$N+)H=Yv#Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³g7üÜüõÑ?. 1Ü0¹Õk¤gâßì¼Íþé‹ü¦ø›ýÖžüÄüËÖ|ÿ ¨KZ—•*"‰vŽ%þH“þ$ÿ mÿ m²cù#ÿ 8û©~bÌ/n¹Zhˆßä|RS¬VÁ¾Ó4¿ÝÇþ[üî_,y_Nò½„ZN
ÛÚB(¨¿ðÎíöÛöÝ¾&ÏÎW[ú^~½o÷ävíÿ $‘ã\ëóƒ÷´Ý^
ý™áj¬®?ãLôÖlÙ³fÍ›6lØ]æ/.ØùŽÂm'TˆMip¥‡ˆþWSñ#þË|Yó÷ó£òŠóò×Wú”¤Ëc=^Öoæ@wGÿ ‹¢ø}Oö/ûyÓç3¤Ó5Wò}ëÖÒû”–õ?be™Wü™ã_ù;g±³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœ#þs+Lú×“£º{kÈš¾Ì²Dá3Ë_‘úŸèß:è÷Ð}n8ÉöúþNgÑÌÙ³fÍ›6lÙ±Ë8oa{[¤Ya•Jº8YNÌ¬§¨9âÏùÈùÆéüœòkþ]F›EcÊHÅYíëüÝÞßùdÿ uý™ßÈü“çWÉzŠjÚ$ÆÓb:«¯íG*~Ümÿ 7/ø³Ý“ŸžúGæE¸‰µÕÑk-«Í>Ô7û¶/øxÿ où›¦æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³b×öú|wy"C@³ÈìTÚfm—<¯ùÏÿ 9nehþF%Wu{â(OüÂ#}ŸøÎÿ ûíûÌóqÜêw!=ÅÔï°wwcô»»6óG•ïü¯~úN­¥y£:T¼ÑeUb»ràëËÿ %tô¿óžo ªýr&#ýFõ?ãLú?›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžiÿ œÞÔÄzN—§×â–âIiípÿ ™ùäõ´ÿ óŠzwš|§¥ßél,5£cÈMLR³"¹õ—íG'Åýììã|óW<­y.ìØkÖÏo&üXŠ£ûQJ¿‹þ¯û,:ü¸üêó'$I¸/iZµ¬Õxµ¿Ë‰‘³Õ—ó–Zó8K]`þ‰¾4”Ö?ä\lþ{,ë6v¸fIÑe‰ƒÆÂªÊj=ÁüÙ³fÍ›6lÙ³fÍ›6lÙ³`M[W³ÑížûQš;{h…^I*þ³g—?7¿ç/ÚQ&—äpUwV¾‘w?ó}ŸøË/Åü±/ÛÏ1\\\êw&iÙî.§j–b]Ý˜øîÎÌsÒ¿’ó‰²Þõ¯;¡Šš;ŽÞèîÓþ)_Þ¿=?°Þ±´´†Î$¶¶EŠÔ*" ª tUUÙTb¹áïùÌkOGÎ«%?¾³…þæ’?øÓ&?óƒ—”ŸYµ'í%³ò3)ÿ ‰ç¬3fÍ›6lÙ³fÍœ›þr{É+æo&ÝJ‹[­;ý.#MèŸß¯û(9ÿ ²DÏ
yZ›CÔmµ[SI­fI“æŒøgÓ½/Q‹S´†þÜÖ+ˆÒT?ä¸¿ƒ`œÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœ×þrCKý#ä=V:TÇL?çœ‰)ÿ …VÏhšÓ¯­ï—¬G ÿ `Áÿ †}EŠE•D5V ƒìqÙ³fÍ›6lÙ³eIÈ¥V î=ŽyOóßþqT©“_òDU]ÚkíâöŸöOÿ "ßYæ+;Û½&énm]íîàz«©*èÃßí+õ—ä¿üå¥¾ #ÑüìËÎÊ— R7ðúÊî_þ-_Üÿ 7¥ž–ŠT™HØ20X‚B;6lÙ³fÍ›6lÙ³fÍ›6lÙ³g+üÑÿ œŒòßÃÚúŸ^ÔÖ [@AââùwHÕø¥ÿ ŠóÇ™ß>`üÃšº¤ÞššÇkV%ð,?Ý²Å’rÿ '†þ^~Wëž~¼Z$ÕHõ&m¢ŒxË'üh¼¤oÙLöÇä÷ä‹ùs¹P.õfZ=Ó³_´–éþéOù(ÿ ´ÿ ³žXÿ œ«³6þ~¾b6• qÿ "‘?âI‘_ÉEtï8è÷2 ¼…IðÂ?øß>æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gˆç0¼Øº¿›K…¹G¦@±µ?ß’~úOøOEÖ\ã‘.³¨[i–â²ÝM+óv?âYôþÊÑ,àŽÖ!HâEEÊ8®×ü¹§y†Ñ´ý^Þ;«gê’(aþ°þVþW_‹<Ïù•ÿ 8gR÷¾Jžþ©pß„7ñ¬ÿ ò;<×æo(êÞW¹6ZÝ¬¶“Ù‘hº?Ø‘ÊFeÃ#þmy—É.‰{$PÖ¦øâ?8_’²N/þVzÉóš¶³ƒÍvMô3ÚüKóh$<Óý„’ÿ «ãÊ_™Þ[órƒ¢_ÃpäWÓÆAþ´q”ÀdŸ6lÙ³fÍ›6lÙ³fÍˆ__ÛØB×W’¤0 «<Œ@ÿ )ÛáÁ2?ç/ô=•§–Sô¥ØÛÔ5Xÿ ­ýäßóÏŠÅÙåo>~gëþ{¸úÎ»tÒªš¤KðÄŸñŽøÙÿ yüÏ‚.(üÁùqèèÖçÐSI.$ªÄŸëIûMÿ ÇÎOòsÙŸ”óåê­Û}«Ó{™ìŸhþ/KýŠ_òøü9ÕsfÏÿ ÎnØðÖôËÊ{jñ×ýGåÿ 3°üáV !óEå¡ÿ wY14’/øÕ›=¡›6lÙ³fÍ›6lFöÎ;Ø$µœrŠTdaâ¬8°û³åö·¦>•}q§Éöí¦’&ù£?ñ÷ïüãŽ¸u"ir±«Ã[·üòf‰?äš¦t¬Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ„žyÒÿ Kh:ŽŸJýbÒxÀ÷deó>—þYê¿¥¼±¥ßV¦k8ÿ ­Áyÿ Ãd—6lÙ³fÍ›6lÙ³Ž~sÿ Î7i>~©iülu£¿ªÁ)ð¹Eý¯ø¹?yüÞ§ÙÏy@ºòö£q¤jVêÖFŽ@¬r^´eÉ÷åGüä˜?/Ym£o®iuø­e&€Ë¼›´ÿ óGžÆü´üîòçæatÉý+ÚUíf¢Ê<x³2—/ò¸äû6lÙ³fÍ›6lÙ³fÍ›6læ?˜?ó‘^Sò_8&¹úåòíõ{j;á$•ô¢ÿ düÿ ÈÏ.~eÎQy›Îí,›ô^žÕœy°ÿ ‹n>?êÇé'ó+g&Óôë­Rá-,b{‹™M8Ô³1ÿ %Wâ9é?ÊŸùÃË‹²šœÁÌ,âoÞ7üg™~¿Ô‹”ŸåÆÙê@°Ð-NÒ ŽÚÖ!EŽ5 ÿ å1ý¦o‰°~yþsgË«§ëè¿»¸…­Üÿ •z‰_õ’où'žm·íäY¢%dF¤v ÔúWùoçK:hzí±éQGìÈ>£ÿ a'/ö?IsfÍ›6lÙ³fÍ›6lÙ³fÍ›6l†þkþeÙ~^è’ê÷„4ä·†»Ë)¨¿jVý„ÿ +Ž|èÕµKZîmFõÌ—74²1îÌy1ûóµÎ"yµï3ne­¦”¾¥OC3‚/ûÞKÿ <Ó=¿›6ëž_Óõëf²Õ­âº·n©*?‹£•œÏó†z.¤ZãË7§LwIYa¯‚’}hÿ à¥ÿ S<ûçOùÇ¿8ùK”—V-ql¿îë_Þ¥<X'ïcÿ ž‘¦s¥g…ê¤«©ê6 Œè~Tÿ œƒó§–x¥®£$Ð®Þ•Ïï–ž½å"õ3®ùkþsvá(šþ–¯ã%¬…äŒÜÿ äöu//ÿ ÎVùW¢Ëu%”‡ön"aÿ %"õbÿ ‡Î‹¢ùßC× :]ýµÕ{E21ÿ Vå‡Y³fÍ›6lØÙ%H”¼„*É&€g>ó_üä’ü±Énõ¦™ÝVß¾jø~ë’!ÿ ŒŽ™Ãüéÿ 9¯q(h<«`"÷G“|ÖÏÿ e,Ÿêçó‡æ&¿ç½}zö[ê¨Æˆ¿êBœbOö)•äïËíwÎWUÐlä¹`hÌ¢ˆ¿ñ’fãì›==ùeÿ 8qc§ð¾óŒÂòqCõhIÿ ÉðÉ7ú«é'üdÏFiÚm¶›YØÄ[Ä8¤q¨UQàª»›6ló7üæþ—êišV¢÷SË?ñ‘UÇü˜Î=ÿ 8³ª?Ï¶
Æ‹p³BÙFì¿ðè¹ï¬Ù³fÍ›6lÙ³fÏŸÚ`Ó|ó¬@\™ähYÿ æfzWþp»S7S¹´n¶÷¯O“¤Mÿ çÿ 6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ˜ŠŠ™óÍÚYÒu‹í8Š}Zæh©þ£²÷Güâî­úGÈZx&­ne„ÿ ±‘øÿ É6LêÙ³fÍ›6lÙ³fÍ€õR-"ÊãQ¹4†Ú'•Ïù(¥Ûð\ù‡¬ê“j×³ê7&³\Êò¹ÿ )Ø»~-Vÿ þq‹Ì£ËÖ~eÒÔ^­Ì<–è)4aÇ5àŸîñéñoƒ÷ŸñWíg%{	ê9Ãq{«+øeeÎåùqÿ 9sæ.ð´××ô­˜ äÇŒê?ã7Iç²óÿ ‹sÓ~Bü÷ò§‚Ç§^,Wmÿ ÷ŽJø*±á/üñy3 fÍ›6lÙ³fÍ›6l ó?Ÿô+!“[¾‚×¿qÌÿ «¬¯þÅ3ˆyÓþsGF±–­$¾—´³~ê/˜_Šgÿ d°çŸ|õùûæï9òŠþñ¡´oø÷¶ýÜtðn?¼—þzÈùÓt»­Ru´°†K‹‡4XãRÌ~JŸwÏËŸùÃÍkXáwæ‰F›jwô–;ù5û.oÿ g¨ü‡ù[åÿ "ÁèhV«‘G™¾)_ýy›âÿ `¼cþTÉ^lÙüïüº~òÍÎ•\JMlOiR¼V¿ñjó‡þzrÏ—ò[HðN¥%Š²°¡Xve9Ô?"¿<îÿ -/•®4{–hAø•ºzðWáõ8ý¥û2¯Ãû(Ëî/'yëFó ¿Ð®’æ" §ãBfXÇ®¸}›6l¦` ³¹'9ßœ?ç ¼™åRÑÞj	5Âÿ º­¿zÕð>ŸîÐÿ ÆI8ÿ ˜ÿ ç7¢RSAÒÙ‡i.d§ü‘‡—üžÎw¬Î^yâüŸ«Iof§´0ƒO¦àÏ‘ÿ ÏŸ<_eÖ.…ßoéÿ É‘Ü~by’äÖmRõÿ Ö¹”ÿ ÆøO5êò½íËyœÿ ÆØ´x×­èaÔo8ÜH?Sáå‡ço,ièë7”žVq÷KÏ%:_üåŸ,h$»ŠäÓ@Ÿñ(–&ÿ †Éž‘ÿ 9¹¬ÅA©é–ÓŽæ'xü?Ö2s£Îkyrâ‹©XÝÛÝ8J£éåÿ ÂdëFÿ œ•ò«@šš@ÇögGŽŸì=?ø|šé^tÑ5`kpOJdoø‹aÈ5é›êzÍ–—›P¸ŠÞ1¹i]PÁ9\ãŸ˜ó–~WòìoŒÇV½¡
"Ú Ë¸añ/üaY?Øç01u>ê'TÖåæÿ f8×hã_÷ÜIû#þÿ m›	ô-ó^¾‡KÓci®î$h½I?©GÚfý•ø›>ˆþQ~[[þ^hèÐóÿ yq(nV¨¿ÝÇÿ ¢þÖM3fÍ›6D¼ÛùOå6‚u:	¥o÷h^Èè¸Kÿ œkÍ?ó…E×)4ù­ôŽu§È2úR/û/S9/™?ç|í¤U­"‡PŒw·§ücŸÑoøyÌµß$kš+«X\ÚÓ¼±2¡Øq8J	£c’#óÌz=?GjwpÙ'p?à9qÉŽ™ÿ 95çí>u6•Gibÿ áš>ðÙ&°ÿ œËó•½ñYN?Ê‰”ÿ É9Sþ#‡¶¿ó›ÚÂÿ ½:]³ÿ ©#¯üKÕÃH?ç9û»Eìn¿¬+þ‡Ž×þ¬²ÒHÿ ª8çþsÿ Ç¾‹ÿ uÿ 4Á„Z‡üæ×˜%Yiöpû¹’OÔðä;Zÿ œ¨óæ¦
¥êZ¡íH¿ðî$“þ9î½çMkÌËW¾¸»ö–Vaô+#ltû›ùE½œO<ÍÑ#RÌ~J•lêþNÿ œYó§˜ŠÉ=ºéÖçöî§´Îoø4LïžEÿ œ?òÎ†Vã\wÕnýÜ ÿ Æ$<ßþzJËþFw7KµÒà[Kc··AEŽ5
£ýUO‡æÍ›6lãŸó–Z)Ô¼‹s2ŠµœÐÎ?à½ÿ „™³Åÿ —ºçè0éÚ¡4[k¨dcþHuçÿ 	Ë>™ƒ]ÆlÙ³fÍ›6lÙ³g„?ç-¬Å¿Ÿ.dž´?ü þeçNÿ œ¼åm¬Ú“öd·p?Ö©ÿ ˆg¨sfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›>zÎFé?¢ü÷ªÅJ,’¬ÃßÕD˜ÿ Ã;g ç	õo_Ë·úq56÷|Àð¢ÿ ÆÐ¾z+6lÙ³fÍ›6lÙ³‘ÎTyŸô’.¢F¤·î–«òcêKÿ $c‘Ùg‡ü¡ ?˜u‹=/µw<píØ;fÿ b¿}9¶¶ŽÖ$·„qŽ5
 v qQoÌÉ-yùj–â;ÊQn¡¢J<958Ê¿äÊ¯ž\üÃÿ œIó/—KÜè”Õ¬ÆãÓfü¨Ûÿ ž.ÿ ê.q«I¬åh.Q¢™`ÊVø—'þKÿ œó”BÅe|óÛ/û¦ç÷©Oå^¼ŒÆ);•?ç6íd¤~cÓ^&ï%«ò&n¿ò9ó¬ù{þr'ÈúèN($?±sXHÿ e0Xÿ à_'Ö¥¦¢ž­”ÑÎŸÍ†z‚sfÍ›º½‚ÑyÜÈ‘/‹°Qÿ ‘M_ó‹ÉúE~¹«Ù©UeWoø¹¿á=sþrûÉ:uE£Üß0éèÄTÁ\â9Í¼Åÿ 9»{%SCÒã‹Áîd.ä\^üœlå>hÿ œ‡ó·˜ù%Æ¥$·û®ÚŠxr‹Œ­þÎFÎw4ÒNæYX»±©f5$û““o'~Hy»ÍÅ[LÓå7ûºaéGO$¼yÿ Ï>yÞüÿ 8Uk5Þ™›©‚×á_“O õ©_ëç |§ä=Ê0}[B³ŠÑ£_‰¿ã$­Ydÿ fø}›6lÙ³Íßó’?óŽRy†I<ÕåhùjVæÙÝÔÿ wCÿ ÿ :»¾Òþ÷ûßÍÂíªRD%YXP‚:«Ðà+X¼Ò'[½:y-§^’Då²Buþr§ÏZJˆÞñ.Ðt+¦DôåoöO’»oùÍ3 ¤Ö6.|@•ækcn¿ç5üÐàˆ,¬c=‰Y[þg.FµoùË=ß‚±ÝEjûæÿ ‰J%oÇ9ÿ ˜0¼Ãæ:_Q¹ºSûJÅ?ä]}?ø\fÉ‰ù{æ-r‡KÓnîôhár¿ð|xÃdÏMÿ œbóõð¨ÓLJ{Ë,Iÿ 
dçÿ …˜ß’úÿ åí½½Ö¼±"Ý3"äæj 3r §íd;V—ÿ 8—æíSO·Õ,ä³xn¡I‘L¬+¨‘9r‹.-üØ_¨ÿ Î,yúÈ[œ÷ÔÑøVtoø\‰jß”žmÒjot›ÄQÕ„.Ëÿ dÈ´öÒÛ±ŽddqÔ0 ýÇÍ›-<Å©YŠZÝOÿ "F_ø‹`¹<ñ¯H8¾£xËàgÿ ÆøSqu-Ëz“»Hþ,I?yÄ²GäËÝoÎ×bÇB¶yÞ£›ôý©e?øfý…löïää&ùm¹‹­be¤·ÙGûæÜÖ?æ·/íqûÕ3fÍ›6lÙ³e2‡XT ä_Zü«ò¶·S¨éV’±êÞŠ†ÿ ‘ˆÿ á²«Î'yü“¬¶¤ÿ ¾gøŒÆeÈ†£ÿ 8G¡ÉSc©]Cáê*Iÿ dfûþpzõkõ=b'½Hâ2K„wó…~kû‹»	>o"ÿ Ì“…“ÎùÞ?²-ýYÿ æ´\ÿ Bç¿ùgƒþG¦/üá÷ž$ûkiúÓÿ Íøwaÿ 8OæIho/ì¡øzŽäÜ_ñ,–éóƒöICªjÒÉâ°B©ÿ #Íÿ Îƒ Î*ùH!ä´{×µs+7ü“Ò‹þ:f‰å½3B‹ÐÒma´§cTO 0Ç6lÙ³fÍ›¼ùåñæ-ÿ G¥MÕ´±¯úÅO¦Ø¿ù”èQŠ°£BŽ}%ü¤ó0ó7•tÍV¼ž[tø±¥7ü•GÉnlÙ³fÍ›6lÙ³Ä¿ó™Ððó”/üöºI—$Ÿóƒ³RûX‹ù¢·o¹¥ñ¶zÛ6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›<Uÿ 9Ÿ£ýWÍv÷Ê>»4©ÿ *6toøOOçõGXÔô²¿¶I€÷‰øØÆ{6lÙ³fÍ›6lÙ³É?ó›žfõotÍ6ÚÞæAîçÒŠ¿ê¬Rÿ Áä;þqË?¥¼æ·Î+“ûroÜGÿ 'Yÿ Øg¹ófÈç›ÿ .|¿çý-vÊ£Je¤‹þ¤ÉÆTÿ bùÂ|áÿ 8Q§Ü›ËWïlÇqÈõä%N ÿ Y%Î1æùÆ_<h·ÔMäCöíI_ùåðÏÿ $³šêUÞ›!‚ú-åVT(ßð.âv×sZ·©o#Fþ(ÅOÞ¹%Óÿ 5üÙ§ŠZê÷È¾XøjaÌ?ó¾{„QuyÏúÁþ&ŠùÈ¿>Ÿú[Íÿ ýSÀ—ŸxŸíë7b¿Êüâpšûó'Ì×ÕúÖ«{ =šâB>îxCsy5ÓsžF‘¼Y‰?ðØš#9
 –= ÉF‰ùWærŸ£´»¹TôoI•äc…þ:7—¿ç<é©Ñ¯…½‚¾¬¼›þßÕÿ ‰®u/,ÎèöÜd×u	îØuHTD¿.MëHßòO:ÿ •?&ü§å^-¥i°$«ÒW_ROù7¨ëþÇ&y³fÍ›6lÙ³œ~f~AùkÏõ¸¾„ÛêmuÏüeboùè¼ÿ •×<ßæÿ ùÃ4ilÒh’Ã©À+@ŠZ{Ç)ô¿àgÎ_«þRù³H$^é7ˆíY—þFF?á²-<@æ)”¤ŠhU…>àåÚÚMw ‚ÙY[¢ ,Çä«¾J4ÏÊ_6êf–šEë¨ÿ ƒuUÉÎƒÿ 8—çPƒq6({Ï*×þ]ó«ùKþp£M¶+/˜ïäº#sºúkò2?©#õV,í>Wü¤ò¯•Àý¦ÛÄëþì)ÎOù/9á²\3g™¿ç8þŒÒ[°ža÷¢ç‘3éwå„‚O*é»ƒakÿ &“$Ù°&¡£ÙjKéßAÂxJŠãîpr¬þ@yW©¸Ò-Ñ›¼ ÂéÝ£È.±ÿ 8iåº›)o-°Y×î•ÿ ä¦rÿ ÌßùÄså-ï_²ÔÍÄv‰êž,E@oÞ,Œ>ø¾Æy×:Oåä½ùg&££IlÃ)…½i[U²‘Éðñ|éZ_üáµ!¤u;XW¿¤!ÿ ‡ô3¥yOþpïÊšK,Ú«Ï©È7ã#zqÿ È¸~?ø)›;V¢Xè¶Ëe¦Aµ²}˜âPŠ?Ø®Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸ;ÿ ?üž|«ç-BÍWŒIõ˜|8MûÏ‡Ù$çûîÿ ó…~w[‹Ï*Îß½¶¬ÀxÞ‰2¯üc—‹ÏlôÎlÙ³fÍ›6lÙ³Åßóš¿ò•Ùÿ ÌÉÙðÓþpƒþ:Ú¯üÃÅÿ 9ëÜÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›<Çÿ 9¿£z–Nª÷SKøÈ«"É‡ÎEÿ 8³¬þŒóåŠ±¢],°öHÎŸòR4Ï|æÍ›6lÙ³fÍ›6|ôÿ œŠóéÿ <js©¬pH-“å7ü•Y;×üá?–þ­£jãŠ5Üë
òa^FŸ7Ÿþ=#›6lÙ°=ö›k¨GèÞÃñŸÙ‘Cø®BµoÈo$j¤µÎ‘l	êbSýC˜²)}ÿ 8‹ä[’LPÜAÿ çcÿ '½\'›þp³ÊNkÝúR#ÿ 21?ú*ÿ Ëmÿ ü_õC[ÿ Îù6?ï%¾“ç*øŒ+†öó‰¾B·¡{If§óÏ'üËhòG§þByÂ†ÔÓýø¦Où>dÉn™å½3JÓí ¶ýõ'üAWsfÍ›6lÙ³fÍ›6lÙ³ççTþ·5—ÿ —é×þŠÆ¹+ÿ œO‡Ôóõ“$Wÿ $?ãl÷¦lÙ³fÏ5Îoÿ Ç#Jÿ ˜™?â<ŸJ)åÑ¿æÛþM¦JófÍ›#¿˜úhÕ<µªYS5œê¹¸ÿ ÃgÌÜõ—üàî¥ÊÛX°'ì<þ°‘þM®z‹6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³Îÿ ó˜¿—-¬hðù¢Í9\iµI¨709û_óÂ_‹ýI%oÙÏ,~]yâëÉå®½g»[¿Æž6øeˆÿ ®Ÿð-Åÿ g>èZÕ®¹c©`þ¥µÌk,mâ¬9ö_Ì0vlÙ³fÍ›6lÙâÏùÍGÍ–Š:‹üeŸÿ çWVnÂÞ!÷»g¯3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›9üån‰úOÈ—r¨«YÉÀúÒù'3ç‰ü‰­þ‚×ôýR´×PÈ~Jê_þ>›ƒ]ÇLÙ³fÍ›6lÙ³`-sUH°¹Ô¦þîÚ&o’)sÿ Ï—÷×’^ÜIu9¬³;;Ç“~9ô;òË¿ <“¥ZÅÞ;øò˜›þ^§ŸæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³æwæDþ¿™µišúäÿ ÉWÎ›ÿ 8{©çpßï»I›þ Ÿñ¶{“6lÙ³gš¿ç7ÿ ã‘¥ÌLŸñž@Ï¥?”¿òˆèßómÿ &Ó%y³fÍŒžž6‰þË‚§äE3å¶¡jm.%¶n±;!ÿ bxç¡ç	oý?0j6dÿ {fžé"/üÍÏcæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6%yiä2ZÜ ’T££
†VYXx2çÎ/Íï!?‘<Éw¢n`FçÚ‰þ(¾eGîßþ,FÏIÎyðêU×•®Z²X7­ßRÞ(ÿ Œsü_óß=!›6lÙ³fÍ›6xþs"ãÕóª¥»²…~ö•ÿ ãl—ÿ Î[ÖãYž›¶ZüÌÇþ5ÏXæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›¼û¡@Ô4šTÝZËÿ ¬ÈÜ?áøçÌ’4;ŸJÿ +õÿ ñ–4ÍRµi­b.ËÂ_ù(­’ŒÙ³fÍ›6lÙ³—ÿ ÎKë¿¡ü‰©2š=Â¥ºûú¬¨ÿ òKÔÏùI}cQµÓ"ûwSGù»ÿ ãlúkl–±%¼CŒq¨U +ŠfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³åÿ š'õõkÉºó¸•¾÷c³þp²ßŸ›n¥þK	?`ÏjfÍ›6lóWüæÿ ür4¯ù‰“þ 3Èô§ò—þQþ`-¿äÚd¯6lÙ³gÌÿ Ì«/¨ùŸV¶¥=;ë…!#Ó:Oüáýß¡ç„ýýk:}Üeÿ ™yî|Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍžbÿ œØòxšÊÃÌñ/Ç›YHþW¬°×Ù$ÿ ‘¹Å¿çüÔ|¹çm>BÜa»si'¸—àOºI¿ØçÐlÙ³fÍ›6lÙ³Àÿ ó•WÂëÏ×ÊD)tHçñ|ëÿ óƒö|4ÍZë´“ÂŸð
Íÿ 3sÓ9³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ÿÐõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6|ÛüÞòÙòß›5M.œR;—däH}h¿äœ‹ž¬ÿ œ8ó!Ô¼¢úcš¾Ÿrèù~ý?ä£Mã6lÙ³fÍ›6ló‡üæÖ²`Ð´í0}bé¥#ÄDœâWœþq³Eý-ç½22*»NÞÞ’4‰ÿ %3è>lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›#„Rç ýÙòÎîOVi$þfc÷œôWüá5×u)–ÑWï‘OüižÄÍ›6lÙæ¯ùÍÿ øäi_ó'ü@g3éOå/ü¢:7üÀ[É´É^lÙ³fÏ?Ÿ6ßWóÆ°+tíÿ I?ãl8ÿ œ]¹ô?04ßòýtûá—=ý›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³Ÿþ~ù|k¾IÕmiWŽ:üá"ãoùÇ>yY]Ée<wPšI«©ð*y.}AÑµ$Ôì­ïãû$«òu?âX36lÙ³fÍ›6|àüéÕF«ç-béMTÞJ€ûF}ü#ÏUÿ ÎiŸTòc\‘½Õä®ˆQ?ñ(Û;¦lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6x‹þs'KžrŽåE>µgŸš´ÿ ÄcL“ÿ Îj·Ú½~Š)îŒéÿ 3sÖÙ³fÍ›6lÙ³g¿ç7u&µ¥Ø×h­^JÆGáÿ 20»þp³Lj»¼aµ½“ówâ*ùí,Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6Öæôln%þHdo¹IÏ—éÿ ùÁØky¬Ëü±[¯ÞÒŸø×=k›6lÙ³Í_ó›ÿ ñÈÒ¿æ&Oø€Ï gÒŸÊ_ùDtoù€¶ÿ “i’¼Ù³fÍŸ>?ç%"ùÿ V¼‘¾›ÿ œu~}Òÿ 0ûãgÐÜÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍõ$¾¶–ÒMÒhÚ3òaÄçË‹»v¶™àµ?0xçÑ/ÈmHê>GÑç&¤Z¬ò(˜?æ^OsfÍ›6lÙ°·ÌºÜZ™u«O´vI3WÁ¿ðÏ˜ww/w3ÜJk$Œ]‰cÉ³è§äg—Îä½&ÅÇúºÊÃü©‰¸jü½Zdë6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6xßþslñœ;ýKþfIŽÿ œ$ó°j'·ÔÇüœLö6lÙ³fÍ›6lÙâ_ùÌçcç(ôSþFO’?ùÁÔS}¬9ûB ù–¿«=o›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÂO<Íèè”¿Égpßtnsæ6z¿þpnÜëSxµ²þœõ.lÙ³fÏ4Îo¸V’½ÍÄ§îEþ¹ä,úWùW‹Êz:7Qamÿ &“%9³fÍ›>}ÿ ÎLÿ äÀÕÖ‡þLÃ?çå<Ò?ã9ÿ ˆ>}Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³æoæ-§ÔüËªÛAíÂ‘óÚŸóŠ7F Ù)5ô¤¸Où*ïÿ ç^Í›6lÙ³fÎÿ 9yçÐžRýR}RUŠý4ýìÍøGÆ\ñÿ åß•ŸÍ~`°ÑT]NŠôì€ò™¿ØÄ®Ùô¾8Ö% T  ì;6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6x“þs2ÿ ëqŠ ¸²‰OÍžY?S®Iç¬‹_ktÙ"‚:ÿ ¬Ò7üËÏ[fÍ›6lÙ³fÍž2ÿ œ×³ôüÏcsÚ[¿JÉ/üÖ¸+þpŽô&¹©ÚWy-ÿ à$ÿ 3sØy³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lŠþkÏõ)køX\ÿ É§Ïš¹ëïùÂi¤ê²ÿ 5ÄK÷!?ñ¾z[6lÙ³g˜¿ç8¤¥†Žž3N~åþjÏ$gÓ/Ë„áå%zÒÂØÉ$ÉlÙ³fÏž?ó‘"çÏš»ƒZNþ?ø×ÿ œl·3ùûIQû2Hßð1JÙô#6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ›¿œÈÎzÒ®Ãë÷ñ6Ï[Î 9o# =êp?áNvÌÙ³fÍ›6lðŸüåž?Ä~n’Âåk¥§ÕÖ=O·rß>¹?ñ‡%Ÿó…žJ7š­ç™æ_ÝÙ§¡	?ïÉ7øÇÃÿ =óØ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6|öÿ œÖ?JùóT”¬R,þy"DßðêÙßç	´“—õE…>±v#ÄDŠâS6z36lÙ³fÍ›6lòÏüç“Xô}MGFž?1‰ÿ “9·üâV®,<õo	4pMü/®?3Ýù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6l„~wÊcòN²Ã½”£ï^9ó‹=•ÿ 8K<·¨Iü×Ôû¢‹þjÏEfÍ›6lò·üç%ÆÚ,óßò`g•3éï“¡0h–ŠZÀ¿tj0ß6lÙ³gÌ¿Ì`k^bÔµ%5[‹¹äSþK;ÿ …Î›ÿ 8¦¿<%ÀZÚÍ)?0°Ìì÷>lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸ67gõüß¬ÉãsøHÃ={ÿ 8‰§äX[ùîgoønñ®vœÙ³fÍ›6F?3<é’ü½{®ËNVñMOíHß	þÊV^_äçÍ‹›™o&{‰˜¼Ò±fc¹fcÉÍ›>‰~GyüåK-.EãtÉëÜxú²|n§þ1¯çžO3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›½»ŽÊ	.¦<b‰Øø›ðÏ—úîªú¾¡s©KýåÔÒLß7bçþ%žøÿ œlÐCyM…áá½ýViþIzyÓ³fÍ›6lÙ³fÎ%ÿ 9}¢~òKÝV²¹†jø&Ý¿äþyò¯\ýæ/Q&‹Ü\ù,Á$ÿ ’lÙô«6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ/Ï¨ÞO#k>¿Ucô¿ásçF{7þpžîòÕõ²‘ëGz]Ç~/b6ÿ eé¿üz6lÙ±ëè, ’îîEŠ”»»TnÌÌzðOüäWæÜ?˜ºâ>ž´ÓlU¢ˆ£ISY&#öUø¯¦¿È¿ÄÜs”gÐ¿ÉÎ-/óJmÊÁ¨Û"¬öÄî´}H»¼û-ûaÿ Êé9³fÍœûóãÏñù'Ê·wÁ‚ÝÎ¦ÞØw2H
†ñ‰9MþÃ>vg¬ÿ ç	<¬ÑÛê^b•h%dµˆû/ïfü^øõlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÌHQS°òûÌú€Ôu[Ëá¸žâY?àÝŸøç¼?çtóeä1NÆE–Oø9deÿ …ãG6lÙ³fÍžIÿ œÐüÁúÅÕ¯“í[à·ææ‡öØRÏú‘“þz¦s_ùÆÏËÿ ñ›mÄëÊÊÃý*zô<îcÿ ž“pøß~¦} Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›9Ÿüä™ÿ ÃÞHÔeSInPZ§¹˜úoÿ $}Vÿ cžÑôÉu[Ø4ëqY®eH”ìÏ§ÚN™g„‘[Æ‘ ÿ %"þ‚³fÍ›6lÙ³fÈŸæÆ‡úsÊš®œZ[IJòÕ}Hÿ ä¢.|ØV*C.Än3éß“u¡®h¶:¨5úÕ´RŸ›¢¹üpã6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÀZÞ“³aq¦\ïÔOÿ ªêQ¿Ï™žhòí×–õ;ýxÜZJÑ·½Î¿äºüiþKdÇò7ób_Ë}p_02i÷ EuêRµYþ-„üIüß·Ë=ÿ  y‚ÃÌQêzTÉqi0ä’!¨?óK/í#|KûXa›6E<ÿ ù¡ ù×ëZåÊÆÄU!_ŠY?ã_ký›qióÅœ¿óZ¿æ4†Ñkg££U-Ôîôû/rÿ îÆþTþí?Öøó•`ÝSD¾ÒY#Ô ’ÝåeA"•,Ž*’/.¨ßÍ›FÖ¯t[¨õ2g·º„òI#%XóûKûYêËOùÌ´(–^u€‡}nÝjùS[öÿ Zùž‹òÇžtO4Åëèw°Ý­*Dnõãþñ?Ùªáæl óŸŸ4&Y6£®\¥¼@*M]Èýˆcûr?ú¿ì¾ðoçOçïæ^«õ¹A‡O·ªÛAZñSö¤“±š]¹ÿ ±Eû9	Ñ´{­jö2Á·W.±Æƒ©f4ôòãÉPy+A´Ð-è~­ÃöäoŽi?ÙÈÍÇüŸ‡$™³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›!¿œ~hXò–§ªÆD·dŒÿ Å’~æ/ù)"¶|àŠ&™Ö8Ágb ©' Ï¦þJÐ—´KÇ¥´Qrªû&Ã¬Ù³fÍ›<Ïæ_.i—:ÍùãoiJþ$(û+þSŸ?ÊÏš~ióÏ™uK­føÖâîV•¼#²/ù(¿ÿ “žØÿ œTü¼ÿ yY5”ã{ª‘põê"§ú2À7üöÎÏ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›<£ÿ 9·æÞRi¾Z‰¾Èk¹G¹¬0Ìüç?óŠÞT:÷­§u¬:z=ÓøUwü–‘ý†{Ó6lÙ³fÍ›6lÙNÔ£
©#ØçËï2iŸ¢µ;½<ÿ Ç´òÅÿ  ìŸñ®{Ëþq›T:´ÆcV‰d„ÿ °‘Ñá8çPÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gŸç(?"dódâ}>Z­²Rh”o<kÐ§óOìÿ ¿#ø>ÒF¹âæR„«4 öÉg?5<Áä)ÌúÉÖH[â‰ÿ ×‰¶åþZñ“ü¼ô—¿ç7£à]Ò˜H:½´€ƒÿ <¦û?ò9°â÷þso@D­¦y#Ó£˜ÐÁ+Íÿ Îgç?ùÌ?4k*ÐhñÅ¥ÂÛrOÞKOøË à¿ì!åþVpýOT»ÕnóPšK‹‰ZI³þS7Å°Óî5ÒÒÊ7šâV
‘Æ¥™‰ý•UÜç­?"ÿ çSJxµÿ 9¢Ët´x¬¶dCÙîfYûëûµý¾±Ú¿2?+´_Ì¨k1|k_Ft ’"j7ðþhÛàåÏþiÎ:ùÈn÷>™¾ÒÁ$\Â¤ñòñïúß_ñfr¼VÚê[YÖîÑÈ»†BT“.O´ùÈ/<hŠ×UÐ~Ìüfÿ ¨…‘¿á°ÏQÿ œ¡óõì~‘Ô} z˜¡‰Oüÿ cœßX×/õ»ƒyª\KupÝ^W.ßðNN¶¶–êU··F’YUE³ÑUWvcžÔÿ œmÿ œ~>KŒy‹_Pu™’‘Å×êèßkþŽ$oýöŸ»ý§Î÷›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³g›?ç5üÕõ]&ÃËñ·Åw3O Éâ€û4’òÿ žYÁ?ç¼«þ%ó®lëÊ$úÌžaýè¯úÒ,iþË>‡fÍ›6lÙ³Ìó™ß˜¾…µ·“mãž—T?°§ý&ÿ ^@eÿ žqÿ 6p?ÉoËöóß™í4†Ú†õ®Hí
|RÈÏ†ÿ *Lú3kˆãU@ €°ÇfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÐõNlÙüÉüñò×åë-¾±3=ÛŽBÞç'çaUHÔþÏ¨ëËöp·ÈŸó’PóÂØÛ\5­Ûš$WJ#,•3ÄÍþG©Í¿es¨fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÌM79ó‹ó£Î_ã6j²7(S>œºˆõÕ=OöyéOùÂÿ '?AºóËI5	}8ÏüWV£ýižQÿ <óÑ9³fÍ›6lÙ³fÍŸ5?4î"¹ó^¯5¹ßÜ•#¡£î3Ø¿óˆèËäHtk‰Èùs§ëÎÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœSó“þq‹JóË¾«¥2éú»nÌî¥?ñz/Ù“þ.ýšIžJó·äçš<–ì5{+þïŒz‘ãêÇU_õdàÿ ää/6Ó4‹ÍVam§Á%ÌÍÑ"BìØ ';W?ç|Í¯²Ï®qÒ­äIñÌGù0)ø?ç«§ú™êËÉ¿/~_CÇG‚·L(÷2Ñ¥oöîµÿ "%DÉ¾lÄWcÓ9wž¿ç|ŸæòÓÉkõ+¶©3Z‘'Åâ£Bÿ ò/ŸùYÃ|Ñÿ 8S¬Ú–}ú¸û$ÀÄÿ *¯«ÁGœÛVÿ œuóÞ˜ÅeÒ¦ð•”ùÎp¯ä_î[‚h×€ÿ —Aÿ 'Éÿ ”ÿ çü×ª:¶°ðé¼˜K%?ÉŽéÿ ÁL™é_ËÈ_.~^=ŒFãP¥Ôôg÷ô‡Ø…Ôøÿ ß:6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›<ÿ 9UæŸÓ¾v¹°éè–«áU¤ßòZGOöÒ?çü«VÔüÇ èÒ#óýôÿ ö/ž¬Í›6lÙ°³«ÛèÖSêW­ÂÚÚ6–FðT›>kyóÍ÷pÖîõë¿ï.¤,ùP|1Gÿ <ãULõ×üâå×è/·˜n’—z©•ê°/÷_ò5¹KþRzYÞófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›?ÿÑõNlÌBŠžƒ>dyçÌ“ù›[½Ön˜´—3»ïÙkHÐ“|QÉ\&’!#ÔR„€Â¢•uaìsÕ_óó‘’\I”<Õ)gj%ÓÉý›iØõ'ýÓ#Æ&ýŒõ6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6s¯ùÈ:ÿ „|Ÿ}yq¹~­9~KþTqz’ÿ °ÏŸu„ÚÌVV«ÎyÝcEÙ_¥Ž}3ò_–aò¾g¢[ÿ wi
GQûDÿ ç£òöXs›6lÙ³fÍ›6lç?ŸŸ˜ãÈžW¸½…¸ß\«ÚŽþ£ƒûÏùâœ¥ÿ YQk>|YÚMq­º™'™ÕFå™QîÍŸJ?-|žžMòõŽ‚„µˆaÐÈß¼™‡úÒ»ä—6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6b=23«~Xù_Wc%þ•g3ž¬Ð'/ø><°¾ÛòKÉVíÎ=Ê£ù¡Vÿ ‰òÉ^¤Yé‘ú6EoòÄŠƒþà¼Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lØVÔ¢Òìç¿¸4†Þ7•Ïù(¥Ûð\ù…­j²ê÷×•Á¬×2¼®Êv.ß‹g¾¿çü¯þòFŸŽ2Ý!ºs1æŸòGÒ\é¹³fÍ›6yÇþs+óôn•”í“ßŸVzu¡øþ{L¿òE¿›<ÍùUäY|óæ+=
:ˆå~S0ý˜—ã™¾|>ÿ ‹3é¥¤Vp¥µº„†%Š:QÅTª¸®lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÒõNlçÿ ÿ ™VžCòíÅÜ®>»:<V±×âiqÇý÷}IýÚtÏÑFÒ¸Ž0YØ€ êIè3ÜÞsÿ œv´ó?“l4‚oM³Š8gñeAÎ	OíA$œ¿ã~ñm_ÄZž›u£ÝËczÝ»”tm™YMÏrÿ Î4~p>h¦ÇQ~ZÆž%'¬±ôŠãýoØ›þ,øÿ Ý¹ØófÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙãÏùÍ;}wV´òÄXì£õ¦ýù/ØSÿ áø¿ç¾F¿çü•þ órê3-m´¤3ŸPþîÝ~|¹J¿ñ‡=Ñ›6lÙ³fÍ›6lÄÓ<ÿ 9'ù¥þ:óEfü´½?”6ô;9¯ï®?ç«¯ÿ Š£%Ÿóˆ–gZÖ_ÍW‰[=4ñ†£f‡ý‹Æyÿ ÆG‹=›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍœ«þrwÌŸ ü}ÄÒKÎ©ÿ =ï?ä‚ËžòÎ‹&»ªZi0ý»¹ã„Sü¶	_ølúygiœ1ÛB8Åª(ð
8¨û±\Ù³fÍ•#¬j]È
¢¤ž€ù»ù¹ç‡ó·™¯u¢I†I
@h“à‡þ	6ÿ -Û=)ÿ 8iù}ú;J¸óeÒÒ{òa€ž¢ÏÆÃþ2Î?ä‚ç£ófÍ›6lÙ³fÍ›6lÙ³fÍ›6l‰y×ó_Ë^JSúrú8e¥D ó”ü¡”Ÿì™xÿ •œ;Íó›v‘1ËÚkÌ;IráüŠ‹Ôoù*™Ï5ùÌ_:Ü±6âÒÙ{„·ã3É€í¿ç.|÷	«Ïo(ðxù'éäóÊŸó›w
ë™4Ôtï%£#þxÌ\7üŽLôOÿ 34=[­åfâ>8ÏÃ"ÆH›â_õ¾Ã~Ëd£?ÿÓôÞµ®Xèv¯¨j“Çmk«I#Q÷÷þUý¬ó‡æ7üæm­¿;?'[úòn>µp
 ÿ *(?¼ùècÿ Œmž`óO›µO5Þ¶§­Ü=ÕËíÉÎÀ" ø#OòUs¼Î.þCÜêw°ùÇ]ˆÇ§Û‘%¬n(f}‰¸Ÿ÷DGãCþì“[=‰ž]ÿ œÅüªI!O;ééI¬7GU?Ý÷/þKEü™Àÿ &ü÷'’<Ïg««1ÀìÐ¹ã-ÔþõËsèð ŠÁÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ°6©©A¦ZÍvÜ ·¥‘eAÍÏüÏ™Þsó4ÞiÖo5ËŸï.æy)ü Ÿ?çšqOö9íùÄß$‡|¢š„ËÆçU¬5zúcà·_—S/üfÎÓ›6lÙ³fÍ›6lá_ó•›ãÊzAòö›%5]Eb§x ?’’óuüôØ\ñ—–ü½yæ=FßGÓSÔººF‹îi¼Æíû)ñgÒËß$Úy'DµÐlwKt£=(]ÏÅ,­þ»ÿ ÀýŸÙÉlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6yoþs_ã•¢!ûM-Ëõ@Š/øœÙËç|¾5<ÚHÂ±ÙG-Ë±_N?ù+,yïlÙ³fÍ›9ÿ çï˜[@òN«yã#Aè©k3-¾ßê‰9gÏ=>ÆKû˜¬à–wXÐx³+øœúså/i–ºE ¤6¤KïÄqåóo´Øg›6lÙ³fÍ›6lÙ³fÍ›6lÙó×æ.‰äk?¯ë·
ðA¼’û1D>'ÿ ˆ/í²ç’?3ç-5ï23Ùùt.ÀíÉMgqþT¿îŸõaø¿âÖÈß”¿ç|Ïæ”:¾¨WKÓÛã{»÷áPl#þõëüÏÁýù’tÑ?'ü™ðê7w^c¼^©n
C_fV‰Hÿ £™rI¤yífZy;òù*m4Ð—¯û?CþgàëÝ{Î³!7þB°šÕE¸-O¡¤oøLê£Èüÿ £õÝ.ïÉÚ«l$PÏâëyV9?ã'ùRd7_òÇ™?(µx5i¸rýå¥í³r†dÿ !þË«/÷¿ü2qfõ‘??ÍÞKÔµè#Ö´«I¥šR¼Ò7–)T}¯Bfù¹'ÇùmÿÔäŸ?›7ž×fýáU¬¬@ü<TñõÙ{Ë7Úåû)û¼'ü¼ü óŸåã¢[n¦q'Áüäý¦ÿ "0ïþNz§òÃþq/BòÃ¥þ¼ÃU¾Z0VZ@‡Ú/÷wüöø?â¬îÊ¡@U`^G¿1ta­ùsRÓHäg´™”Q½?¹øçÌÌúiùy¬gËºn¢Lö¹ù”^ðÙ Í›6lÙ³fÍ›6lÙ³fÍ›6lÙÂç/|÷úË¢ÀÔ¹Õ_¨…(óöMéEþ«¾yòÿ ÊRù¿^²Ð ­n¦Tb?eÅ4ŸóÎ%wÏ¥¶VqXÁ¥²„†XÑG@ª8ªý‹fÍ›6lÙ³fÍ‘OÌßÌm?òÿ G—YÔMHøaˆ4²ðDŸ­Ûö“gÎï7y®ûÍš¤úÖªþ¥ÕËòo :$h?f8×àEþ\õ—üâoäÙÐl¿Åú¼|o¯–ÈÃxá?îßi.?äÏüe|ôVlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lðÏüåö²oüîö Õl­¡ŠžìÁÿ “ù6ÿ œÑ9O«k>ÂCn§ýbÒÉÿ &âÏXfÍ›6lÙÈ?ç+í¤›È7i3SÃÔEýmž(òü:w˜tÛÛ’0^[Èäô
²#1û³é°5ÜfÍ›6lÙ³fÍ›6lÙ³fÍ›6pïÏ/ùÉ‹?"»èš*­æ³Çâ$Ö(	éêÓûÉâ•û?îÆýœò¥õŽ¹çû-KÎ7×FòâÁâúÂ9<ÄrU–5ûN¼=8þÇ._g&ß—w––m¯åÖ&³æŠÒ_^ 1ÀÄ|_W·¯£Cðýbâ^_ìs­éßóç›æ]Kó3XšéëQknßÿ “ÌI?ÊX ÿ ž™×|¥ùKåo)¨ý§A‹þíeç'üŽ—œŸðÙ.Í„^rò6‘ç+ÓuËt¸…¡#ãBn)>Ôoþ¯û,ó.‰å4Í^÷òSÌÒôÛÔk&áÆñHÉ‘ÿ  n2¬Ñ¯ÃêÆè¿ÏœWÉ:Ž¡å½^ïGŒZú­.Xë³4ÈöÑ¯û¯I¿ØçÿÕó?™ôItRïIœ%¤òBkþC¯Óžâÿ œVóLß’m­câ³éìöò¨ è}HÞŸåÇ"ü_´üó¯æÍ˜€ECŸ1¼ï¢\¿ÒÈ§Õnfˆ|•ÙWþ=¹ÿ 8«®~”ò%œljö’KnßC™þIÊ™×sfÍ›6lÙ³fÍ›6lÙ³fÍ›6|üÿ œó÷øÇÍ×2@Ü¬ì¿Ñ`§B#'ÔÆI½Füœ3©ÿ ÎùÔ–óÍ×+ðÆ>«nOó=ÃõWÓŽ¿åÉž°Í›6lÙ³fÍ›#Þyóæ•ä9õmjQ+²¨ÝänÑBŸ¶íÿ 7?Ï~m~kj?˜ú©Ôo¿wmVÞÜ¬Iÿ Hýe“ö¿ÔTUžÿ Î4~E7œïWÌÔgô-«ü*Ãk‰ý×ïgûïæþçýùÃÛà›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6|èüøÔÿ ž5‰‰­.ž?ùHæ^zsþpËLÞPžêŸÍì†¾Ê‘Æ?á¹ç{Í›6lÙ°›Î^Y‡Í=æ‰s´w¼UþRGÀÿ ì‹çÍO0hWz¡>“¨!ŽêÖFŽE÷SÛÅ[í#~ÒüYíùÅÏÎ5ó~’4Iÿ Ü¶œA'ya
Kîñ|1ÍþÂOÛlîy³fÍ›6lÙ³fÍ›6lÙ³gŸ?ç#?ç#Ê©'–¼µ m]‡¦]Å¸?²¿òóÿ &×ÏË+Ìí$ŒYØ’ÌMI'©'Ç:üãv¿oaæ”Òµ
6Ÿ¬Å%„êz(ýßß(Hÿ Ùçuÿ œg½—Êæµùi¨ŽÖV¸¶c±tøQÏû8¼È¿åIÏŸóÞQòg(n®ÅÕÚíèZÒG¯ƒµ}(ÿ ç¤Šßäç9_ÍÏÌÏ?šy/Fu‹}›«­Í?™^~7üó†|ç?™zŸœ<¤èš‡›dº×™Ô-‹;$ÿ »Jz1GþL^ƒ<ŸÉÇâÏ\y]V]
ÆO0:£[Æn øéñrUøUÿ ŸÃÏY‚‚ÌhSž\¼ó…—œÿ 3Oš!p<¿å[Wi®GÙb¢_°ßµêÏ/WýÚ‘rOµž~Ðµ­cÍkÐ%eŠiõF^ÀAÏPp}¿uÃ?ÿÖÎc~_'\‹ÌöËKmIxJGA4cŽÿ ñ–,¿åG.Gÿ ç¿2G”|Ì¶oÇOÕ8Àõ;,•ÿ F”ÿ ³fˆÿ “//ÙÏwfÍ›<ÿ 9S¡~ŠóÝã¨¢^$WþÉ}7ÿ ’±I[þpƒ^çkªè¬wI"¸Aþ¸1Iÿ &¢ÏPæÍ›6lÙ³fÍ›6lÙ³fÍ›6sÏÿ Ì1ä*ÜÞBÜonGÕí¼y¸5ÆùËþ²¯ógÏ«)µˆí-”É<Î±¢Ž¬Ìxªÿ ²lúOùoäÈ|™åû=«D°ý©ãšOör³d—6lÙ³fÍ›6sÿ ÍïÎm'òÖÇÖ¼>µü ý^ÕOÄçùßý÷
þÔŸìS›g„|ÿ ù‰«ùóQmS[˜ÈûˆãGÿ ¾áOÙ_øwý¶lèÿ ó7¾~5MUZßAª_£OO÷Tä¿&ýŸ²ŸØ÷&—¥ÚéV±XXF°Û@¡#TtP0VlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙóSóN¿âÍb½H]É×Ïcÿ Î$ÓümO÷üõÿ ƒ9Ù3fÍ›6lÙçùÊŸÉ'ó%·ø¯Cˆ¾¥l´¸òÄ::¯íMüÅðÿ ºã\òƒ¯ßy~ö-SK™­îànI"ãeo²Êß/ÂÙíŸÉùÉ=;Ï)•¬³Öé@¤Ò9Ïó@[ìÈßñ¾ùþÏkÍ›6lÙ³fÍ›6lÙ³fÏ>ÿ ÎGÎE/•O-yn@Ú»ŠM2î-Áý•ÿ —–ÿ ’?kíñÏYÙÝëimlqwpôUgwcÿ ÌÍž–¼ÿ œUMÈW÷×ß¾óÄ.GU‰cýä¶ñÓûÇh¹úüüV?‡â“Ì–wrÙÍÌRX™]u§’·ÐsÒ6¿•þlüß½_=kóÛèVÀ K£<4û\yôtn,÷'Áþëá†Vþbü¦üª"-¯ë+°/ÅþLÌ>­ýG#á³?æÇæÀàª<³¢ÉÔžK+)ÿ §—ÿ §XŸ:?å‡üãß—|„Âö$7º§Su=zú)ö!ÿ [â—þ-É¯šüã¤ùNÍµræ;[uè\îÇùcAñÈÿ ä¢³g›¼áù¡¯þp$ö>]ÿ pÞR†¿\ÔnO ÉûJÍþWü²ÂÍ$Ÿî×Tn9ÆüùçËÑéäß'#Å¡Äáå•Å%¼˜ÇÄÿ Ëÿ tAû?i¾.*»ò£ò*ëË^HÖµF:Þ§¦]EjñÆÑ?¸ý¯^áørO´¿»O·Ísÿ×ïŸš¾AƒÏž^ºÐ¦ ’EåŸØ•~(_åËáø­Ÿ>pê}Æ—u-•Ú®mÝ£u;e<YØ¶{ãþqÓóHy÷ËˆnŸ–©cÆNíAû«ùìƒâÿ ‹V\êy³g“ÿ ç7ü¿Æ}+[Aö’[g?ê‘4_ñ9²ÿ 8æÑ~vŠÑþ	`>ë	ÿ &xÿ ²ÏufÍ›6lÙ³fÍ›6lÙ³fÍ›6xGþr“ó0yÃÌ­afü´í/”1ÐìÒWý"_ø%/ù1rý¼:ÿ œ@ü¸:æºþe»JÚiÝÔlÓ°ø?äJr“ü—ôsÚ™³fÍ›6lÙ³’þyþX~\Û›+^7:ä«Xá¯Ã=&¹§Ù_äíËþJ|yá1ù“Pó%ôº®­3\]ÌjîÇîUöQ~Îýÿ 8ñÿ 8Ð¾aŠ4ù¤WNŽÞØå ÿ y=>Ì?ËÛ—ö¸Çýç°-íã·aV8UP  lTlª1ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏŸ?ó’>Y“@óÆ¢¬)Û‹¨ÏŠËñ¿üÞª±ÎÅÿ 8]ù	‚ëÉ÷,`æêÞ¿´<kîœRN?åIü™êLÙ³fÍ›6ló·ç·üâäc2kÞRUƒS5im¶Xæ=Ú?Ù†vÿ ‘R~×äíãýCN»Ò.žÎö7·º¸º8*ÊÃÄÆzògþrÎëFér/ud(©v>)cñpÿ ˆÿ Êþûþ2ç­ô]nË\´PÒæK›YERHØ2Ÿíþeýœ›6lÙ³fÍ›6lÙ³ƒÿ ÎGÎA§’áo/è.[™~7‹uaö¿æ!¿ÝiûÞ¿ì+ø²nµ[¡Aî.î€
³»±ÿ ‚wvÏpÎ>Î>Áä(XÕÕe×f_šÀ¤o_ñiÿ vËÿ <ãø94¦X–U1È#==F|ÔüÌò›yKÌwú-´ì#¯xÛ÷7û(™2iù}ä½KóËš’¾©1¿©oa»#
<¿ÅÁwG_îùráñg¢çtO/\yVÛX±²…55g†ân<¤æ‡ýøü™9ÄÑ¿âŸt¯8þeù{É±™5Ûè­Ú•“ÊFÿ Rå+Àg¿ÿ œ‹ó'æm7òÇI’A^&òáGÿ +}ÿ ç´¯ÿ s˜y–ßËúÑÔÿ 0õ7óG˜Ki¡þK‹¿ÙEÿ |À‰ÇýöËo0yÓÌ¿šphÖpÿ £¡ãk§Y§cäÄ¿ËûSKöÈLô¯ä_üâý·”Þ=sÌü.ue£Eø£€ÿ 7ü]:ÿ ?÷qÿ ºù73ÐÿÐõNy#þsò¤ÚÜ'ôäýÌåb¼
:?Ù†”«û§ÿ ‹?Ú“8÷ä·ælß—ž`‡Uk9?uuý¨˜üDçˆþò?õx}—lú%c{üÝÚ¸’	‘^7SPÊÃ’²û2âÙ³ŽÎXywô¿‘î'AY,%Šä|ôdÿ ’s3±ÏùÌËºí†°­ÌR·úªÃ˜ÿ dœ—>›#¬ŠU…AÁËÍ›6lÙ³fÍ›6lÙ³fÍ›8§üä—çtKÒäÑ´¹×/¢…50#}©ßùŽÐ•ûÏ²™â-'J¹Ö/!ÓìPËuq"Ç¬Ìx¨Ï£Ÿ•¾A·ò—ít+z3Ä¼¦qûr·Å,Ÿð_
Åj‹’ÌÙ³fÍ›6làÿ ŸŸó’–ÞLY4//2ÜkDqwÙ’ßý~Ïqü±~Çû·ýöþ,Ôu+NâKÛék™˜¼’9%™Vf8>‡ÿ Î;ÍëyHo
ÿ À»§ük6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ˆÿ ÎR~Q¿œôeÕôÄçªi¡˜(É	ø¥ˆ3§÷±ÏD_ŠLñF…®^h7Ðêšl†»gŽ Ö§ì²þÒü-žÿ ü–üæÓÿ 2tÑ*‡T@¹·®àÿ ¿bþhö“ì?ù]6lÙ³fÍ›9ÿ æ¯äž…ùoMA=ôŠî0=EðWÿ Eÿ ¿ûLñ7æäÖ½ùwséê‘z–ŽiÔ`˜ŸÚ¿î©?â¹>/åæ¿ü¹ü××/®þ³¢ÎDLA–ÝêÑIþ¼Íÿ '?ÊÏfþRÿ ÎEèT³v:± i[g?òí/Â²ÿ ©ðËþGígVÍ›6lÙ³fÍ›6r/ùÈ?Ï(.¬>¥`VMréO¢‡qýŸ¬Ê¿òi?ÝþB>xJââëUºi¦g¸»¸z±5gwcÿ ÎížÓÿ œqÿ œ}O%À¾`×6·2üwèÃìùxo÷kþÇ÷Iû|û¾lòüæ·”>«ªXù’¢]Æ`”ç‹âŒ·»ÄüçŽA?ç<Þ<»ç;hf4¶ÔCYÈJ¿÷?ò]c_öM‡Úæ_×<¥kqh:]´òO,’¿§ûº¬q´rSŸ&…âøX¹`{­GòËÉ²4À\ù·V­L“·/_Ž_ö_XFþlù›ó«Ížvã£Xÿ ¢Y?Á†E#ù8ÅûÙÕûäd×òßþq\×
]ù™ÿ EÙý1F‡úŸÝÁÿ =>?ø§=WäOËMÈ¶ßTÐm–CãüR?üe”üMþ¯Ø_Ù\”fÏÿÑõN ×ô+M~Â}+QA-­ÌmŠ{‚;x2ý¥oÙo‹>r~g~_Ýù]¸Ð¯*Â3Ê))A$MýÔ£æ>þYÓösÐ¿óˆ_œ¢µY>%äö,Ç¨ûrÚÿ ±þö/ò}Eý”ÏRæÂÏ4èqëÚUÞ‘7Ø»‚HO·5)_¢¹óîÖK9¤¶œq–&d`{2ž,>üú%ùæñ/“tËönR¬<yÃû†åþ·§Ïý–O3fÍ›6lÙ³fÍ›6S0QV4øUæíN©½¾¶‚ŸïÉ‘âM‘_þrÈºP&mZ	í)OüY3Ÿù‡þsGËV`®“iuzã¡`±!ÿ dÆI?äŽqÏ:ÿ Î[y·_VƒN1éví·î2Sþb$ÝÖ‰"Î4ïq¨ÜrbóÜÌÝMYÝ˜ý,îÇ=‡ÿ 8Çù7•¿çió\59–ð·XU‡Å$ŸË<‹ðñÿ uGË—Æì©èœÙ³fÍ›66YRie`¨ ³3 RO†y[ó×þr¬0“AòDj³_/â–ŸöQÿ "ß¹æ?O»Ö.ÒÒÎ7¸»¸~(Š3±üIÎÙçŸùÇoð‘_]ÕÛÔÖ¤šQ[à…žQíýì­ðúöý×üïÂ3èüãÆ_Ëý.¿²&_ºis©fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lòüä§üãƒ#Íæï*EÉ²]Ú Ü¯sÙý©¢ýŸïáåÃÍž\ó&¡å»èµ]"f·»„Õ]OÞ¬:27í#|-žØü“ÿ œ”Ó<ô‘éz±K-o§iÇù­Ù¿lÿ ¾ãþOS;NlÙ³fÍ›6ÔôË]RÞK+ø’{iW‹Ç"†V­žZüÝÿ œ@xýMSÈç’îÍc#n?æVû_ñŠ_ö2·ØÏ1^ØÝiw-mwÛÜÂÔdpUÕ‡Š·Ä­Ëò£þrËXòÏ?Ìµ=<P		ýücÚFþü“/Çÿ ç­¼“ù‰¡ùÚ×ëšÒ\(šV’'´±7ÆŸñåÉlÙ³fÍ›6Eÿ 2üýiä=ã]½ø½!Æ(ëC$ýÔKþ±û_Ë7ýœùÓæŸ3ßy£RŸYÕd2ÝÜ¹f=‡ò¢ÙD_öW=Qÿ 8¹ù4¸¢ó—˜bÿ Lr³…Ç÷jz\ºŸ÷tƒû¯÷Ò|Þ7îý-›	<ßç]'Éö-©ë—	mn½9}¦?Écã‘ÿ ÉLñ—çÏüäQüÆ„hÖ‹—¢Uyw™™C*·ÃðB¼]¾çÿ 3ŒZ]Ii2\ÀÅ%‰ƒ£¡”òVûó¨_yKÎßœÚÄž`‹L!îx‘PÃDjÞ¤íñ|
¼¸»çYòGüáJ/üÙ}Ë¡0Z
“\J+ÿ û<ô“¿.t&Åèè6Q[mFp+#¯3ò•ÿ Ù>I3fÍŸÿÒõNläŸó‘ß”#Ïú¸±Jë¤‚d_÷e·û?µü[þ»ç„,o®t«¨îí]¡º·pèÃfWSU?ë+gÐ¯É?Í[Ìm	5D¿†‘ÝÄ?fJ}µï©¾Üì£ûQ¶tÙóûþrcÊ'Ë~v½¼`½"î?ùëýïý<,¹Öÿ ç	üèwþU¾%"î {ƒH® ù~å¿Ù>z›6lÙ°£Ì^oÒ<·Ö5«È,ãìep¤ÿ ¨§âö9Ç|Óÿ 9å=,˜ô¨çÔ¤
/¥üŒ›÷ŸòG9O˜ç4|ËxJé6–¶Hz+öLR?ù#œÿ Uÿ œ†óÖ¦I›Vž0{CÆ ?äBÇ‘Éÿ 1|Ë;s—U¾fñ72Ÿøß4?˜¾e€Ö-VùOµÌ£þ7ÁcóoÍãoÓ7ÿ ô“'ü×Í78£k7ôÿ ˜™æ¼?æ˜î+ëj—¯^¼®$?ñ¾Ýj÷—ïDòËþ»³ÄŽÁ6ZuÍóúv‘I3ŸÙK¹rm þBùÛ\#êºMÂ+~ÔÊ!}Á:¯”ÿ ç
uk’²yŠú+XûÇn¯òæÞœiÿ %sÐ_—Ÿ‘¾Wò&Ò­CÞCs9ç/ûû1Ï'Ù³fÍ›6lˆ~`þkùÈVæ}nåRR*'Å+ÿ ©ünü#ÿ /<iùÃÿ 9­~`–±†¶:=v·FÞAÙ®dÿ vÆ?î—ü¶øòä!jþw¿]/C€Í1¡fè‘¯ûòi:"Ä¾Êrl÷/ä×ä>“ùon&Z]jò-%¹aÒ¿j+uÿ uÅÿ 'íþÊ)güå”^§où%·où(‹ÿ gƒ3Þó‰Òóòšÿ $·þJ»ÆÙØsfÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lóŸçŸüâÄù—]ò‚¬‰«Ëk²Ç)ý¦‹öa˜ÿ È©?â¶ø›ÈZŽ›w¤]=ìoouqtpU•‡ˆ;Œï_”ó–z—„z_›ßØ
*Î7ž1þW/÷¡ù_½ÿ -þÆzãÊÞnÒ¼Õfº–‰sÕ³~ÒÁþYíÆÿ ä:«a¾lÙ³fÍ›6B?2'<¿ù…^7J)ÌTYSýŸû±?â¹9¦xûóOþq«Ì^G/wn‡QÒÖ§×…O%ñ|Çþºó‹ü¼æ>µ{¢Ü¥ö™<–×1š¬‘1Vì—=Où/ÿ 9l/=Ïc‘¨±ß(
¤ø] øcÿ ŒÉû¿çDûyéôu‘C¡¬*ÜrófÍ›6lð÷üå‡æø£_ýdü´ý(”4;<ý'ùåýÊÿ «/óà?ùÆÊuó¶½úCQž•¦ñ’@FÒH¹ƒü¥ø}IÈNýæ{·6sÏÎ?Î}3òÖÃÕ¸¤úŒÀý^Øÿ ‹$ÿ }Â¿´ÿ µöS<#ç¯Ì_ÏƒjšäÆYMB Ù#_÷Ü1þÂÃ7ÚvfÉ‡å7üãÎ¿ù„VíWêZUw¹”‹ÇêñlÓ­ðÅÿ rÏ\~^ÿ Î>ySÉ(¯ml.ïG[‹ëÿ ©œ_óÍ9–ÙÒ@¦Ã6lÙ³fÏÿÓõNlÙã¿ùË/ÉÐ÷gÎzDt²ºz]¢£•¿ÝßñŽàý¿åŸþ2ç&ü üÏ»üº×#Õ­êöÍû»˜Aþò2~/ùèŸn&þòóèvƒ®YëÖ0êºl‚kK”Žàþ¦e—ö[áÁùÁ?ç.,æó.‰½§Fd¼ÒËEY oï?ÖôYVOõ=\ñß–<Ñ¨ù_P‹WÑæ6÷£Š£‹++|,Œ¿+g£|­ÿ 9·q,^aÓVVymŸ…çŒ¼Çü•\œÙÿ Îfy:eho¡nàÄ‡ñI[Mÿ 9‰ä˜ÇÃõÇÿ Vÿ È¹Ö?ç7tx”/L¹™»zÎ‘øO¬g)ó—üå§œ5ða°xô¸kqY÷žNL?ç—¥œzÿ Q¹Ôfk›Ù^yßí<ŒYÍÞ­’?*~TùŸÍt:6<ñ·û³ÿ ät¼"ÿ ‡Î¹åÏùÂÏ1^ úÅåµ’žªœ¦qó§¥ü•lèÚ?üáW–­€:íÝÓwâR5ÿ á#ÿ ÉL”[ÿ Î(y!F²’Câ××þÐf›þqGÈ2}›)ý[‰ãglÿ BäO÷ÅÇülµÿ œGò 56÷ç;à¨?ç<	°w§ó\Mÿ È¸kkÿ 8éä+ZpÒ!4þv‘ÿ ää‡úåg•4íí4‹Èî-ã'þ¯,‘ÛYÃj¾¼kx"€>åÅsfÍ› êúí†	¹Ôî"µ„~ÜÎ¨¿ðNW9Î³ÿ 9=ä=,”:‡Öv‚7ø~>Ÿü>Eï?ç3ü¡D6÷Òü£Œøi°¦ëþswE_÷›LºõÝþ#êäwTÿ œá¼z7HŽ3ØÍ;?ü,iüO9ÿ ™ç*üñ­«EÌv1·kXÂŸù'«*ÿ °uÎOwyq¨L×R<óÈjÎìY˜ÿ ”ÍVc£ò›þqc\ók%ö¸LÒÎõqI¤ñT-ýØo÷ä¿ìLö7’ü‹¤y.ÅtÍÝ`€nÄnÎßïÉdûR?úßì~>ÎYÿ 9?«ù©ÿ ’ oºh³çö{Ÿþpþ^~GEþK©×þ"ßñ¶vÜÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6A?4?&4Ì[~¤^â
Eu‹à	ÿ vÇÿ ÉþÃƒ|YãÍ?È?0þ^»MsÖ´Úü7p‚WÛÖOµ¯ð$‘)yÓWòàÔt+—µœu*vaü²Æ~	ü—\õOå‡üæ©ð±ó„bÊäÐ˜Á0±ÿ ‹â’ù)ücÏDXjÚŒ	we*O‚©$lXx«/ÂpFlÙ³fÍ›6qïÍ_ùÆo/yÑ$»°EÓuSR&‰hŽßñ|+ðž_ïÄã'í|g<SçO$êžLÔdÒ5¸L7	¸î®¿³$Oûq·ó±o‹áÎÏÿ 8éÿ 9'•ž?-ù–BúC°ÌÛ›re¼mäÏìüìè¥I‘e‰ƒ# ÊÊj=>ìÙ³fÎiùÿ ù¤Ÿ—Þ]’âS»¬6‹Ü1ÿ êÀ¿üdôÓöóçí½¼ú…ÂA
´·¸UQ»3±¢vf9ôcò{òî/ yrÛFPÅ=[—µ3ÿ yþÅ?ºOòrkœóó›ó—NüµÓLóRmJ`Eµµwcþü“ù OÛoÚû	ñg<ÓæGÍZŒºÆ±)žîsVcÐÙD_Ø>Ê"ýœôüã×üã Õ’/3y¾"-ohÛUšãþ)?±û·í?îþ=s)
,Q(HÐUQ@ èª@1Ù³fÍ›6lÿÔõNlØVÒmu{ItëøÖkk„1ÈÑ•…gÏoÎŸÊk¿Ë}i¬^²XOWµ˜þÒWì7ü]Ù“ýŒŸe×&¿óŒÿ ž¿à«ÏÐ:Ô‡ô-Ûü.zA!ÿ vÆ?ÝßËýïûóŸ·‘ÕÔ:TŠ‚7²+±Îù•ÿ 8“ ùži5C¥ÞHK2ªò‰ïèü&*ÿ ÅMÃþ*Î¯Î#yßMfú¤P_F:ePHÿ RãÑÈ×äGž-‰h×fŸÈœÿ äß<F/É?:Êhº5ïÓø{¥Î1ù÷P4i…šicAÿ ÏŸü&t*ÿ Îj32Éæ-B(©ŽÙLòõ$ô‘?à$Îéä¿ùÇß'yKŒ––)qr¿îëŸÞ½|WŸî£ÿ žQ¦t`Š€Í›6lÙ³fÍ›6lÙó÷æß—<‰-ríRb*°'Ç+«î£ü¹8Gþ^yóþs[ÕK[ybÓmÎÂW¤“ôþæ/ø?ã&pmg^Ô5ÉÍæ«q-ÔíÕårí÷¹Åt+êºÑã¥ÙÜ]Ÿ¹‰ßþ ­’»OÈ?<ÝŠÇ£ÜŠÿ :„ÿ “¬˜oiÿ 8»ùqÿ JßL—<#þfáþ›ÿ 8qç;¢>²ÖvËßœ¥ˆú!ŽOø–N4ùÂ6µ«;¥´Tÿ ’²³ÉœìþDüˆòŸ’YgÓ,Ä—kÒâsêHŠø"ÿ žItÙ³œÎEÅêyWSÚ?t‘¶|òÏmÿ ÎMÏÉ³'ò_Ê>ô…³¼æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³ce‰%CŠTŠ‚PFxãþrÛò·Bò“YjºU{é%YcCû¿„#Ž?÷_Úû)ð‘žtÉgÿ 4üÁäYý}
é¢Bjð·Åÿ ¯|?ì×ŒŸÊùêË?ùËÝ^)eædeãmê‚ZÝúÿ nùéÉ?âìïÐ\GqÍ+Æàe ‚B¬:Œ~lÙ³fÍ›!Ÿš_•zWæ.˜tíMxL•h.|q9î¿Ìþì‹ì¿úü|ùùªyT“GÖ#ã"îŽ>Ä‰û2Äß´­ÿ ð?ÅSþqÿ þrFo%”Ð|ÂÍ6ŠM#}Ùíëü½Þßù¢ûIö¢ÿ }·´´ÍR×U¶ŽúÂTžÚeˆC+ÝX`œÙ°›ÎpÓ|¡¦Ë¬k2ˆm¡ì˜þÌq/íÈÿ ²¿ñ®|øüÙüÎ½üÅÖ¤Õï*‚ÞÔG?
û»}©_öŸüž+—þqò¯®¿ÆÚ¤èöä¥š°ûr}—¸ÿ R±ü[ÿ s×yüãüÒµü¸ÐßU˜	.¤>´$ý¹ý¯ø®?·'üÚuÏŸ^ióN£æB]_X™®.æ5fnÃöQ¢F¿°‹ösÑó¿óízÑy¯ÍÒØQímdoºÜNŸï¯÷ÔMýçÛÝÿ yëlÙ³fÍ›6lÙÿÕõNlÙ²'ù›ùq§þ`èòhÚâOÅ U¢}‰þ"ëûiðçÏ_;ù+Qò^©6‹«ÇéÜBv#ìºŸ±,MûQ¿oøøÕ—;§üãüäˆÐV?+yªCú?e¶¹c_GÂü³ÿ #ÿ º>Ï÷_Ý{9UFC# A ƒÐƒŽÍ›6lÙ³d#Í¿~Qò›˜u]JzÅeqþ´p	?ÙñÈTÿ ó—þGˆÑêOuƒþkdÀÍÿ 9“ä°h#¾>þŠÕlÃþs+ÉdÓÓ¾óÅ?ê¶?þ‡É>Ÿò$ÕL]ç/¼ŒM—Cþxù«þrßÈnhng_œÿ †Å—þrÃÈTÞÈ>vòÿ Í%?ç)?/Úƒô‘ñ‚ú¥‹'üäßåû~•Q_fÿ ªX¯ýŸ?êíü‹›þ©a&»ÿ 9käm6"ö³Í}%6Haa÷µÀ…3„þ`ÿ Î]ùÌ­t%]&Õ¶ä‡œÄÆr þy"¿üYœ:yç¾˜Ë3<ÓÊÕ,Ä³3~&cƒòëþq_Ík	u¨(Ò¬Z‡œàúŒ?â»mŸþFúYé_"ÿ Î2y?Ê¡e’ÛôØ¥e»£Šÿ ‘÷ÿ  Ïþ^uX ŽB¡E¨  1ù³fÍ›6l‚~{Gêy#Yòé!û¾,ùÍžÎÿ œ'——–/£þ[ö?|Pÿ Lô6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lóGüæÿ ür´¯ùˆ—þ ¹ä,õÏüâE¯˜ü¹§ë^[¸6×÷PK$3’Ñ;´jîROï!æçþ-Oõ3Ï~qò&µäÛ³a¯Z½´»ñ,*®íE*þîEÿ Q²Iùaùçæ/ËÙXKëéõ«ÚLIŒ×©ö¡ò£ÿ f¯žÊü¬üøòÿ æb+9>­¨V´˜€ûu17Ù?Ôø¿:>lÙ³fÍ›"_™–:Oæ˜Úf¬”aV†eÔ‰ÿ ž3áüñý™?àY|ùŸùI­~]^ýSU•»“èÜ >œƒü“û<Mñ¯ùIñâ¿–Ÿœþaü¼šºLÜíÖKijÑ7¿±¿ùq27órÏKùSþs7Ëwñªë–óØOOˆ¨õ£ú8Ëÿ $r['üååú'©úH·°‚jÿ É¬ƒy»þsOE´FË¶s^OÙç¤Qƒã@^Wÿ WŒ_ëg™03õÏ?]ýw]œÈ¾œKðÅ=¢þ7nR7í>L?"!o¿1nÖòì4-ûÙ©C!`·ñoç“ìÅþ¿Ïxize¶•k…Œk´8ÔP*¨¢¨Á9á/ùÊÏ>7™|Û.ŸVÏJW@:zŸjåÿ Öõ?uÿ <Wÿ ç¿) óV§/˜uh„º~œÀFŒ*²N~!È~Ò@Ÿ/ó¼_³Ë=­›6lÙ³fÍ›6ÿÖõNlÙ³dóƒòMüÊÓ~©wû›èjm®@«#Ùoç…ÿ Ý‘ÿ ²_<ç"jÞIÔ_IÖá1L»«uG^ÒÂÿ ¶ÿ 6¿ørùAÿ 9'­ùSN¹_Òaµ1ÿ .òïÄÅMÊ?åôþÖzÃÉó>PózªÚ^¥½Ëº.H‰ëü«ÌúrÏ):"°`MAÜ—›6Ö5Ûuª\EkõyQàœŒâ~yÿ œÁòÎ‹Ê$Õn@e¬pƒÿ dÛþyÅÇü¼óŸŸ¿ç"¼Ýç.PÏtlìÛoBÖ±©õõdÿ g'ò3›ÛZÍw*Ãn,®hª€³ì«¹ÉU·äïœn@h´kâà›wñ%-"üîÂ£F»úc#1üŠó¸ýwÿ "Î'ÿ *GÎ¿õf½ÿ ‘-ˆ·äçœ”Tè·ôÿ ˜y?æœ/åW›"¡}üWþ]¥ÿ š1ü¸ó2š6“|üÃKÿ 4bäyE[N» xÁ'üÑ‰?”µ„šÆäÜÂÿ óN%þÔÿ å’ùßóNi¿—>dÔäYi—’¹þXŸKqâ¹Öüÿ 8wæMa–m~Hô»cBT‘,Ä{GôÓýœ¿ì3Òß—_‘~XòYtÛa-èÜÏG–¿äp‡þx¢g@Í›6lÙ³fÍ›"œ1|¬ ©­…ÇOhÛ>mg°ÿ ç¥®‰©Åü·Hß|cþiÏHæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ5ÿ Îo%t}-ü.dzfxÿ >”~RËêùCFr)[où6˜sæ?,i¾e´m;Y·ŽêÕú¤‚»ÿ 2Ÿ´ü®ŸyCókþq
÷Kç©y1šòÔnmþùGüRßîõÿ #ûïøËžuÿ HÓ®?n˜[ÝOÐÈêsÑŸ”Ÿó——šg3Î®í†Ëv‚²¯üfO÷zÿ —ý÷üeÏWèbÓüÃhšŽ‘<wV²}™#5#ü¬?iâ\1Í›6lÙ°¹ ØkÖ§j°%Í¬¢‚ ÿ F²Ëñ.y›óþpÀ35ß“nBƒ¿ÕnI öŠàWýŠÊ¿óÛ8f¿ùç=	ŠÞi7$Ú…=eÿ ƒ·õW#éä½qÛ‚é÷e¼Wþ#’Ÿ/~@yÛ^`-´©âCûwÑP<é·ü
¶w¯ËoùÃ[KKß8N.Ýh~«DUÿ ‹f<d—ýTX¿Ö|ôŒ%¥¤k(TDU@èª«²Œ_
üÓ¯Eåý*ïWŸû»H$˜ûðRüÙ}œù}{-õÄ—wÊi¤vñf<˜ÿ ÁgÐÏÈ?(+y7N²eã<±‰|yÍûß‹Ý’/öÐsfÍ›6lÙ³fÏÿ×õNlÙ³fÈïž¿/´o<X7]€Målñ·óÃ'ÚFÿ …oÛV\ò7æGüâ?˜|¾Ïuåï÷+cÔ*ÐN£ü¨ºKÿ <~&ÿ }.pëë‹	ZÚò'†dÙ’E*Ãýeoˆa¾çíËÔý¨\Ú¨ý˜å`¿ò.¼?ás ió•ž|Ó€Y/#ºQÚxPÿ ÃF"øl:ùÌß92Ø+0‰ëøÍLkó“ž{Õ”¡ÔºÖñ¤gþFõä¦sWY½Õå7:•Ä·3¯+³·ü–8qåË0ù¾A…c5È­…¤cýyŸŒKô¾zÈ_ó…nÜn|ßyÄu6ö»Ÿ“Ü8ûý8ÿ ç¦z'Éß—:“bôt(­¶¡p+#¯3ò•ÿ Ù>I3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙüÉ‹ÕòÆ­^V#þI>|ÎÏ\ÎK[b?åšOšÉÿ 4ç§3fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³g›ç7ã‹¥ÿ ÌSÿ Ä3Ç¹ô—ò{þPíþ`-ÿ äÚä¿6sÍOÈ/þbFe»êÚK¸@·A2ý™Óýù3Æ_š’^`ü»˜J/VÄšGu&6ðÞ?È“ý‡<%ò'æ>¹äk¿®èW-	4çÞ9òËø_ýo¶¿°Ëž¾ü©ÿ œ¨ÐüÝÂÃ[ã¥êm@·îd?ñTÍýÛ÷Üßìd“;€ ŠŽ™³fÍ›6lÙ³fÍ›8güåÿ œå1¤ÆÔŸT•c§N2&™¿à½(ÿ ç¦yòÛÊÍæ¯1éú([›„Wÿ Œ`ó™¿ØÄ®Ùô¹ 
¢€
 2ófÍ›6lÙ³fÏÿÐõNlÙ³fÍ›
uÿ )iaÑÖ,à»N€M½?Õ,*¿ìs™kßó‰¾FÕ	hmæ²sÞÞV§üÞ²}Ë=WþpzÍÉ:f¯$c°šøhÞø†'üàíñj6±_nÄýÞ¯üm’#þp‡Jˆƒ©ê—ŽâÖ/øg7Ò¼¯ÿ 8ãä.‘$:z\Ì¿·tLÇþOÜÿ ÀÅ&#P¨HÔP*Š =€ÇæÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÂo:Eêèz„`W•¤âŸ8Û>bg«çæø5¨«ÞÕ©ÿ #ÆzŸ6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6yËþsmòþœÝÅá|ož8Ï¤?“[Éš)?òÃoÿ \™æÍ‰]ÚCy[]"Ë€«£€ÊÀþË+|,3ÍŸ›ó‡ö·üõ/%0¶œîlä?»cÿ Hw„ÿ ü¢ÿ *%Ï+y‡ËZ——.ÛNÖ-äµºN©"Ðÿ ¬¿²éü®ŸgBü°ÿ œó'‘8ZúŸ_Óo«NIâ?â‰¾Ü?êüqÅyë?ËùÈ_+ùä$OõKöëmpB±?ñSÿ w7ûçÿ ®tÌÙ³fÍ›6lÙ±ËÈl¡’êéÖ("Rîìhªª933vUóëóïóPþby…ïmê4ëaèÚ©Ø”­3æ™¾/õ=4ýŒêó…þ@yïn¼ßr”Š6ÖäŽ®ÛÎëÿ ããüöoåÏ\fÍ›6lÙ³fÍ›?ÿÑõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6 ó~¦tyA ÛÝ[>]g¨¿ç%"çZ±Kc÷¿®zË6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6yÏþsoþQí;þcOü›“<oŸH%¿åÑæø‚äÏ6lÙ°ƒÎ^CÑ|åhluëT¹‹~%…	ý¨¥_ÞFßê¶y[ó7þpóTÒ‹ÞùFCj*~¯!:o†9ÿ ä›ÿ ùçËý>çM­obx.#4d‘J²Ÿò•¾!'È?ó’nòpX#¹úíšíè]UÀË_Z?õ}Nägòüæo—5±ëÖóiÓmVQëEÿ œfÿ ’9ÔôÎ/'êêÏW³jöy•þcÿ Âáí·št›­­ïmä¯N£Ä[•ÃŽJA¸ËÍ›6lNââ;hÚyÝcŠ5,ÌÄP7ff;*ŒñgüäoüäCyÅßËž^rº,mûÉEA¸e?…²·Ø_÷g÷ûœÃòÃòÛQüÁÖ#ÑôàU>ÔóUŠ:üR7¿ìÆŸ¶ÿ }òŸ•¬|«¦[èºZzv¶ÈGsÝÏí<ÉÝ¿›³fÍ›6lÙ³fÍŸÿÒõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6!~¼­å_aøgË64ÏLÿ ÎÉMOVÆM~Lÿ óVzë6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6yÓþsiOøwOnÂöŸòJLñ¶}ü“?’´R?åŠ÷(\šæÍ›6lÙó§å¶çX}zÎ;‚Jq‘ãÉÆEÿ W—ó·ž?ç
eRÓùNø2îD{’ÜD(ßìâ_õóˆy£ò_ÍÞY'ô–™p#_÷dkêÇÿ #`õ²È[¡BUuƒôýQÓO+© #¼R2ÄÉ¶‡ÿ 9çCUžU³=&þG‰þ:•ÿ ç65kr±ëú|7IÐ¼bŸõ‘¿äžv¿&ÎMy3ÌåbúßÔ.ZƒÓ»žçÂj´òW:œR¤È$ƒ#
‚AÇ	|ßçm#ÉöM©k—	mÖœÄÄ~ÄQŽGÿ %3Å_ßó‘šæ¶›§†³ÑÚ*ürÓ£Ü²öþXWà_Úõ‹dòïòçVóö¦ºN&ë$­P‘'ûòVíþJý§û)žýü¯ü°Ó?.ô¥ÒôÁÊF£O;ŽW§ÛoåQþëýÖ¿årf—æÍ›6lÙ³fÍ›6ÿÓõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›66PÁ>XÜ
Jàt^z?þp‰¿ÜÖ¦?åÕ?âyìÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙçoùÍŸùF¬?æ8É©sÆ™ôoò3þPþ`ãýY9Í›6lÙ³fÍ…÷þ]Óu[ÛX''ýù¿üMN^~UyNðR}Á«ÿ .Ñƒ÷„ÈÖ©ÿ 8Õä-DzZDÇ¼/$túøÂä_ÿ œ*òõÐ-¤_]Z9è$ã*¢Éÿ %3“ù³þqÍÚ8itÓ§Þ‘7	?äTÜWþWÎ9­yPÐ§6š­´¶³Ø™
¹ÆySó;ÌžRt=B{hÏû¬7$ùú2s‹—ù\0¯Ì>gÔüÇrou›™nîÜåbÄåZý…ÿ %~è”?óçæ‰w"›-"£•Ì‹»hÏ÷§ü¿î—ù¿c=·ä_ iGÓ×JÐáD7v;¼þü™ÿ mÿ áWì¢ªä‹6lÙ³fÍ›6lÙ³gÿÔõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lùg¨ÿ ½2ÿ ®ß¯=ÿ 8Iÿ )£ÿ 0_ó2<ö>lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6ló·üæÏü£Vó?äÔ¹ãLú7ùÿ (Fÿ 0qþ¬œæÍ›6lÙ³fÍ›6lØ_®ywN×­Íž­mÜö%@ãèåöOùC8ç˜ç<©ÍëÙ5Í…MJC dúë+¯üù/þqsÉ¾X•nšÔ.p×lAñªÇü>u´EE€€€eæÍ›6lÙ³fÍ›6lÙÿÕõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6cž	Öç¼ý¯*éë*³û¹â=OƒHÿ Sþq;ò×Ì>S×/ç×le´íB+H>oQZŠëUè¹ê,Ù³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙç_ùÍ¦á½={›êýÑKž5Ï£¿‘èSÉ:0?òÅûÖ¹7Í›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍŸÿÖõNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏ8ÿ Îm¸œ½Íá?tož9Ï¤?“
WÉš(?òÃoÿ \™æÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÏÿ×õNlÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÎ3ÿ 97þýgþ4úç£ë?¡õ><¹ñø¹z¿ÙñÏù’ÛÊB¯ \ê'Â;«hGß4Gþ¡óèå?§þÑý±õjWþ1¦J³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³fÍ›6lÙ³gÿÙ                                                                                                                                                                                                                                                                                                                      usr/local/go/doc/gopher/appenginegophercolor.jpg                                                    0100644 0000000 0000000 00000474347 13020111411 020525  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ÿØÿà JFIF „„  ÿáÎExif  MM *                  b       j(       1       r2       ‡i       ¤   Ð ‰T,  ' ‰T,  'Adobe Photoshop CS2 Macintosh 2011:06:14 15:06:23                 —       …                          &(             .      ˜       H      H   ÿØÿà JFIF   H H  ÿí Adobe_CM ÿî Adobe d€   ÿÛ „ 			
ÿÀ  e  " ÿÝ  
ÿÄ?          	
         	
 3 !1AQa"q2‘¡±B#$RÁb34r‚ÑC%’Sðáñcs5¢²ƒ&D“TdEÂ£t6ÒUâeò³„ÃÓuãóF'”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö7GWgw‡—§·Ç×ç÷ 5 !1AQaq"2‘¡±B#ÁRÑð3$bár‚’CScs4ñ%¢²ƒ&5ÂÒD“T£dEU6teâò³„ÃÓuãóF”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö'7GWgw‡—§·ÇÿÚ   ? õT’I%)$’IJI%W¨õ<—Œr³ïn= Às¹s –×S6]köû)©¾­‰)=×UEOº÷¶ªji}–<†µ­hÜ÷½îöµjå³¾ºÙ³¡c‹k?÷¡—¹”£îÅÇnÜ¼ïi¿õl_û¶²ºŸRÈë¶²üÚMuû±zu°H=²º~êÝ“þ‡ôŒÄÿ 	úÏó$¸—8’O$êU|œÅ‡øßÁ±‹Ÿø«ß“Ör„eõ|Çë;qÍxþ¨û-iÛýl·¬þ¡‡g£vC”æäP×;*Ë2Ikßöw4ý²Ëý¿¥WÕn£¦Èä>’>"êKTäÉ#ö³p@Qcô€d`ÐÃâÆ
ÏùÔúnGª«q¶œ<ÌÌCY–zy6½“ü¬l×åâØßä:”W}#ñ)ÚGíI„Nñc¥‡õ³¯bífeõJ†Ðm ý›"#Þ÷cd9øw?ú™¸¿ñKs¥ýkèýNöb1ïÅÎ{w,¦:›Œns½!gèòv5Ž{þÉmì\Šµ×u~•ÍW!Á¦D8}+{aôÜÏÌº¯Ò±KbCæ_›¹xŸ—OÉô„—#õwëøÏoMëWzµ8íÁêv@.Ÿ¡‡ÔHÚÆfÜ|¯æz‡üoè®ë•¨ÈHX6Ò‰‰¢)I$’(RI$’ŸÿÐõT’I%)$–&gÖ¼sƒ‡“ÕrªvÌŠðkõ$Ï·'"ÇÓ‰KýŸÍ¾ÿ Wù	)'Ö.½û"šk¢¡‘Ÿ˜âÌjí†÷äÞÿ s™ŒÏç=6Yfÿ Jšÿ \SïÌÌêÖäõþ×•EUœg†
ë¥·:ÿ Y˜tKý-þ‹+~E–[—mlôì»Óý±×zù?Yh9xY˜"ìCFY¬´¹¯9=FÙÆ¿!Œýz¿ù
…÷º¾£·³•hÙupo§ïbÛ•{ÿ GŽÇ¶ÌŸû°ÿ g¥EŠ¶yÈÈÃaMœ0žæÛ©ö?ní§oïvûÖn[­Ç«Öê½M˜¸µâY03'!·çd;ÿ 
ÑŽ¡öœ÷‹Fê9»†™aåd´ÞœÍÿ ô)PˆµŸî‹e3zÞ4Ü³¨ôÚŽÛsq«pü×]X?æïÜ©uµÑˆö·:‡»uNk÷²Ú¬?F5ŠÞÝ.Ç>®ž)e”È¶†T)µ‘ô½Lg×Mìþ¿¦®­=ÃàHC@uO¢u#B5ú¹îëÝqŒêˆ“¯º?ê·®tGý¡ó°7ÿ >mZ­ÄÀ{‰>e¹yYwÙ‹Ó±ïê¹5Hµ”–Š«pÿ ‘›æbÕoüëmÿ ƒH#B$ýôZ™ôÿ Ð–£'#Lké¼øUc,?øœŠæ¹¦>D<Ÿ«zÚý[¾®ad¼æÎE&ßûrÌFWÿ ƒ,}ØØYnÀ¶Ž£Ð2«c­5û®ÇØÙõ.¿í¸Öã×·ßutWK?Ó'œ2ý/ú+Xž£þý'JÖ³'/Ð±­³»î­à9¯²ÐæQUŒtµìªV÷1ßŸv*Øú¹ÕnéY¸5ö¹ý/(ý›»NçcÜûqëªû«f%õÕe5Õw«ez×g£gèðjºÜoÍs.ÆÉ°ÛûN+› 1ùtî³ìômk(§+Ûñ?™õ}>­fEXõ×SìÍ·"–amØršöäa_{ë­•¾ê}?ú	c”£8±ÓÍY"%{|ŸRIsßó«'­³®ôŒ®—ŽãµÙ[ªÉ¢½>–Kð¬¶Üz÷{=WÑé~ý‹}cØ×±ÁÌp®A‡4«­6I$’JÿÑõT’I%8ÿ [º­½#êÞ~}2+¯f9h‹msq±ß–û.º·û–g\êø_âûêÆ/¡ŒìÆµíÇcwl/±Í}¶ää]²ÏÒ[éÙkýŸ¤µmõþ‘W[èÙ}.×l5íeœìx"Ê-ÚwzW2»>’ãþµýdÂÊú¯ŸÒ:î=tuêëcF§kmŽmõ›sÎÛqÚ÷ºïç=Z™UÕäÿ „INKú¶oTxë–VÚzXÇéÔ8‡·›­/$¶·ZÆí»¨ä¦ýR”öF-¸},ƒÂÒçØCí~NQÙˆ×ïþ“Õ:•¿¤ý/è±±+³*ÊþÏV>5³Äû-UíÇ±¶bôìj±jun`6>ò×Ö\ÝíÇÄÅbÑèÕ=™?TÛgª¿7«äC®u°þœÿ EÄÊô«ÿ Âê¬#îL™l=DyüŸó[3—· #ä—ÌîýTú›‹Ñ+™ŽýràN}ž÷¦œGYî¦†îÙíÙë…ÿ U]"I+Mg3­}^éj¶Œ¶äU'2£²ú]ûô^ßsâÿ šøJ×Á•Mù?:>Ý‚ðËžÖím¬xß›SGµ­É¬~’¶ÿ 3{-­qÍúÑõçëOÖ™›u?}”aÕ£SY^ë}=®}4Úæ³é>ßçÂ.ªŽ¥X¯¡u¼¢nNÊ£(·@ï²dÔÊn,o±®±ï»óÂ¨³ÀÖ,¸$DÀé&Ãq²:—PÆèØ¶:‡å‡Û•‘\o§½­¹õnúäÛex´[²ÏKô¶/AÀÀÃé¸u`àÒÜ|Z¶ª™Àÿ YÎs½ö=Þûïzä~¨çF`|zç§ÐiñôÅÙ>¿þé.Ù, ÷Ô£4‰™´
Y}_¤ušÝÒ²m`Êd[O§`nM7ÝNf1iõ¨¶§{™gþŠRúÇvu¨ÝÓÁ9•ãZê6‰pxc‹\ÆëºÆþcWÏ>º­¯3¨ÛÔþÇŸ†~+Hy¶ûKýÞ•õÿ 5mÎúŸOÿ ¶©XßO~=˜¸–uZ*³'ö_ÇkZÚ=Wl®žµS½6×Vk/Æ~uUÕèßNO­éz¸Ûí§ö6í¿¡Xç2‹ª6`XI.­­swcïúäÌ¯³Ýùÿ d³Óÿ  ¶p*ÊÏÿ •ç4×‘“Óp›˜†·)ØV}§`ú«kñÖ&NLàtÎ«oÒ­øÖÜàŽÌªÆ6VÖ°9îþ’ÇícÁªÙãR~—ý(ü­Œ2¸Gþ‰ù?¨ÿ _úß^ë—ô³‡QÛSÃßK6šÏ§hÊm–ZÏNÏ¡íÿ ÿ ºo©Ì³?¥8Í=+:Ü\IsžF9mY˜µ¹ö?ôeýŸú•.? ýiÄè£ª}§Ý“•Ôsšê³N§mƒŠ¾Ù™kuuW•nO·Ñ³éÿ Ã.óêÿ HJÁs/°_›•kò³¯l†¾ûLØX×}
«he·ýLV"lÁ!D‡M$’EÿÒõT’I%)p_Y°Ù‰õ‡&üÆ³ìÝQ”{nôýZ[eáï·èÚêÝUôÖïçÿ Oé4»ÕÇ}yknê}'àÛ(ô³.4¼1ÏhÇÆfúß¹¯ÙVfBfP%kñ&)ç°+®®¥ÔªØÚ™êc;k hØìv2ZÖC~•v­¬/´ä}Qé9Ø5ú½Sê½‚»qk‡½ÿ fkº~~#>“›f^¾ÑíÞÿ Õ–ññzSþÝKiÅÙ³>ªYÀKêÎmUý'a¹Ö}£c¡Úÿ ûŽ´ðó³zvAÎé¦»{YëP÷E9hýÈ¬Yèäz^Ê2šÛi¶¯N»ÙìªÚ«âÈ#-~Y /Æ,ùq™GMâI¯	=ßOê]K
œü[‘‹ÝõZÞã¿¹¯k½–Vÿ }oýŠÂóûz×LÅÈ·¨àdäý\ÌÈ°Ù—‰•ŠüŒìÛï¹ßcõ1ë¶è¯ÔÌÃÍªË=?ÓÕeŠmÿ }Oì±N6SËŽ0Ÿ™´Ÿ…½3Ò¯þ»š­q
»æÖá7Tm³Õÿ ÅWÕ<üûzÎ¿Ô&ÛëªÆ¶¢d¾Ûê×cëßùû,gö=•Ôú9G¨1ìÀéTÐÞŸÑëqvçãÔãfFc)iºÛ“•üÝûwÛU¥ß¤±?¨ýeë_g£¬úgívlÄèGh½íÝfî¡–]c‹_é2™SþÍü×øDºïø¥ëU¬Î=Gö‘küq[«ÆcZÖ±µcØßZí•GçÓú_øÃúÁ@úzËöExýY²=]#ûd‹ë/OO©tœ‘—•‰¹—a°[‘fÓ“F;2O¯‘K«f^5,é,¯Óÿ ½7§u©‡^wO¹¹×Ì±‡Oê¸}&=¿Ÿ[ÿ I_ç¯,èßâW©71¶un¡UTVC‡Ø‹i þm—ÕK(ÿ ŒÙwõ‡Pé]O¡u†4æ¿+¨^­ˆÑ[r,`/û7WéÎÝvWél~=Ÿ£ûWür@{c©ˆÿ *'Ü=Ù'Ó1ÕúoÔî‡:Ãúmê–»õ:k`6Ýx!Õý—{=Sgë«ô_ÎØõÌþÕúüËClêµäÐß¥éWN=îþ·¯‡—_öp2ú†Ÿj£½JÁ²î¥Ÿ“oPÈ5ËŸéÕ[)À¦–{ÿ š¢ìjàÒ÷±ïÄídý×W9·ôOªÙ8ÙV6Ï¬XŸis]hÈnË}9fIÄk?Iüß£‹þ’åÏuS‹ÓêfñMÈÃ©yk.¥ÍsÜ~ŽÊhVâÇ]nveîÊË}a·æ_µ‘SâÊØÝ˜øXVÆWÿ “mßMTÅ¸gå}­’1pœYŠsM–Ù[ü×1Á¿ û&Cþ‘—Ý•þ‰WÉ“Œ‚¦›c> Aù¤ÊÌ¬>±}+*¼œœÜŠCYSÛfÖWmy™6½ÁÛécc\ÿ §¾ÏðkÔ—ž`Ýéuîe®ôñkÈ·{ÿ 4[e6bá±ÿ »ë?"Ö6Ïô¾_á—¡©¹p84êXs“Ç¯@¤’ILÄÿ ÿÓõT’I%)rŸ^ikoèÙ„ÁnE¸¿,Š.pÿ Á±h]Zç>¼ØÁÓ1),ßeùø¢£D×gÛ-³û8¸¹	³ù%äWCæ˜yÀKHp0F „>ÐzžUÙÿ ±ÝEXx–W[pïÜ*uÖ5¹y‡ê·Ù€ÖW‘OèMøÞ·«ú
‘ÿ Ô8n/U¬ˆ{z•®qîE•ãäRïûbÚêÿ ­ª¸"%"¢¶mg‘ŒAÝÆoNúÊÉž×ôY®iþ­ÈÇ³üêGÕÿ ­Y z•QÓdäXrí{\Ì\oKé~þuŸñk¹IN0cëñ`9òVï'oÔûzvNWé9S	Öúÿ l³oÚj¹¥®Çõj©ÌÄô=Ÿb®Š+Æ«ü'ó¶ØŸ§uÿ ­ý{¹}/§a`Tç¹‚ÜÌ‡ß»Ós¨¿f>Uý«{}ù>õÕ®#êwÖÑ~ªÑ‡Õ2ë§¨âÙ{20ƒ²E¯ÈµÞ‹1»"×¹Öû=:Ô VÌDÞéú?[úñ™Ò)ëNÇé™8—Po1÷ãÝ s½6¹ìÎ©Îöÿ !§å}nwOêÝs¾”Ü_§5ç Øü–?šûiÇ­¾†;ÿ W¦ªÿ ž³Öõÿ GZ«õwë7FéTééÝBãÔº}«úmÍ5äºÂ%•QfÛ2=mìô_Nö{×Iõkü?«½3%¥—Ñ‰Ev°ò×¶¶5ìÒ~ƒ½©)ÇÈúŽæ8—Ô­Ç®£å°fV Ue£=ŸÚÎ±S?Tþ´í4²œ5äñ_hwþ~]²I‡ñÆI¤^gêF>ñgYÈ=Oi%¸»8ƒV–9øu¯É{6ÿ ÚÜŒ–Á¬~µU¸ÿ Yz•vˆnX§7ë«uôü?Gu6âÓ¿ÿ Ò»åÇ}v×­tpÞ[Ni³É„b·Ýÿ _ôSrÀ{dUªìR>à$Ýèóý]¡Ý¨5ÂGÙo0|[[ìoý65zf-Ž·›_£¬c\ï‰ •æùXïÍm]*£uK#H‚[[~uÛ\[»ÐÁeïÿ Œô—¦   @o,=$÷+¹ƒêÁt’INÀÿ ÿÔ½‰Ôº‹zæ/YËy=AÙŒéF–{jª§=øŸce[ìk«§3#6¬‹êÝëz¿£ªïEz:å~¶}W¿6Ççtê›s²+êÂ—Ü+÷båãdý
º†ÚßM×~ŽÚ¿Fû+ô)YOÁúçÔÞ)´u5»9yø4	áÐZìÌ¿Ýÿ B˜¢H ÊÍÆ»~êò# ":Qþ/~¸O¬Yõõ.¾E.ctv;9¦AË»oÚÄ‡mÝ‡ŠÚèþE™—Ôª¨=mãm¸˜³÷,ÏÏ{í»ª¶¿ú+[ê>a¤779¸,hŠñ:]u¶¶{œïé”Þû·îÿ ‡ïÿ ›>9ë"?îx—C‚$HËŠºDßp¸y9LÇôXoÊÊx«¤5÷XL1ÏöUSÃäÙú*?ã?D»«}ý'§zym™¹/9¶3vÃsÃ[¶ŸSÜÚ(©•cQÿ OúEÏõß«Ø]#£»Ùmïë8ÈË½æË¬æ¦¶Ë4ý=OÑÑS+¢¿ðu.ÕX„y¨Ë”ÌöˆRI$¤cR	ÄÅ9#,ÓYÉkvöP7÷=Xßµ$”Ä±…Íqh.lí$j'ªI$’”’I$¥.ë‹þ¶e‡·kêÂÆm ]Q³%ù1Ÿ¹ëú[ýJ¿»µõ«¦afôŒ‹ï¯õŒ*n»!„²Úžã¾›™ïgÑnö5oøfX›’<Q1ºµÐ—„ªéæ:N~'Kë•çõ F#ñþÊÌ©%˜ö>ÏRÛ2™þŒ¶·¿¶ÿ 7öNÿ J»}Eß1ì±²·±à9®iAÕ®k‚óœlN¹OHÁê™9ØÙxÔä?'¸º§\Ö=ÌÈÀ«w¯K}_é>ýŸÎá…MÑ:«°.}_ÈÆ¿À}^™êÅ.'Þ/ÄôEötüwéªf/Ùïüú)»ôª(Lã¨LPé!ò²Î%ÊÏXõ{n·Ö™Òê­•×öœì¢[‰Ši{„o}?ÍcÓ¹¾½ßú:Ê«Ó¾°un­]]Bûú½ÍkÙƒSjû5NÜ}ZzŽ-u]fÍý£/©~Ò»þÑÖ–>WÖ/¬/§=ðûªuO³oh¯²ƒÒ*ÈpõjfuÖ_“’ÿ Õò2«ªÿ I”Óé®û–ãâRÌzô*©¡ŒÕcZ¥Œ¸¬þèÿ )G†‡é~“ÿÕõT—Ê©$§ê¤—Ê©$§é/¬¿³ý·ú»hâzŽÙõýV}›Õõ?í?©üþÏÒzÍ­…òªI)ú©%òªI)ú©%òªI)ú©%òªI)ú©%òªI)ú©Rëa§£g‡Öœk¥Àn lv»w3wùëæ$’Sô¯ÕHÿ šýi%¿aÆ‚Dôkíª©Öÿ æ'©oíÏÙ¾¾ßÒ}§Ñõ¢;oýc~Ï¡³ôŸ¸¾uI%?IýWÿ ›¿²ÿ ìwgØýGú›woõ´õ~ÕöÖ¾Óô?¥~›Óô¿Áúk]|ª’JÿÙÿí6FPhotoshop 3.0 8BIM         8BIM%     Fò‰&¸VÚ°œ¡°§w8BIMê     <?xml version="1.0" encoding="UTF-8"?>
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
8BIMé     x    H H    Þ@ÿîÿîRg(ü    H H    Ø(    d       ÿ              h                                 8BIMí     ƒÿ}  ƒÿ}  8BIM&               ?€  8BIM        8BIM        8BIMó     	         8BIM
       8BIM'     
        8BIMõ     H /ff  lff       /ff  ¡™š       2    Z         5    -        8BIMø     p  ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿè    ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿè    ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿè    ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿè  8BIM          @  @    8BIM         8BIM    _             …  —    a p p e n g i n e g o p h e r c o l o r 1                                —  …                                            null      boundsObjc         Rct1       Top long        Leftlong        Btomlong  …    Rghtlong  —   slicesVlLs   Objc        slice      sliceIDlong       groupIDlong       originenum   ESliceOrigin   autoGenerated    Typeenum   
ESliceType    Img    boundsObjc         Rct1       Top long        Leftlong        Btomlong  …    Rghtlong  —   urlTEXT         nullTEXT         MsgeTEXT        altTagTEXT        cellTextIsHTMLbool   cellTextTEXT        	horzAlignenum   ESliceHorzAlign   default   	vertAlignenum   ESliceVertAlign   default   bgColorTypeenum   ESliceBGColorType    None   	topOutsetlong       
leftOutsetlong       bottomOutsetlong       rightOutsetlong     8BIM(        ?ð      8BIM        8BIM    ´          e  à  ½`  ˜  ÿØÿà JFIF   H H  ÿí Adobe_CM ÿî Adobe d€   ÿÛ „ 			
ÿÀ  e  " ÿÝ  
ÿÄ?          	
         	
 3 !1AQa"q2‘¡±B#$RÁb34r‚ÑC%’Sðáñcs5¢²ƒ&D“TdEÂ£t6ÒUâeò³„ÃÓuãóF'”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö7GWgw‡—§·Ç×ç÷ 5 !1AQaq"2‘¡±B#ÁRÑð3$bár‚’CScs4ñ%¢²ƒ&5ÂÒD“T£dEU6teâò³„ÃÓuãóF”¤…´•ÄÔäô¥µÅÕåõVfv†–¦¶ÆÖæö'7GWgw‡—§·ÇÿÚ   ? õT’I%)$’IJI%W¨õ<—Œr³ïn= Às¹s –×S6]köû)©¾­‰)=×UEOº÷¶ªji}–<†µ­hÜ÷½îöµjå³¾ºÙ³¡c‹k?÷¡—¹”£îÅÇnÜ¼ïi¿õl_û¶²ºŸRÈë¶²üÚMuû±zu°H=²º~êÝ“þ‡ôŒÄÿ 	úÏó$¸—8’O$êU|œÅ‡øßÁ±‹Ÿø«ß“Ör„eõ|Çë;qÍxþ¨û-iÛýl·¬þ¡‡g£vC”æäP×;*Ë2Ikßöw4ý²Ëý¿¥WÕn£¦Èä>’>"êKTäÉ#ö³p@Qcô€d`ÐÃâÆ
ÏùÔúnGª«q¶œ<ÌÌCY–zy6½“ü¬l×åâØßä:”W}#ñ)ÚGíI„Nñc¥‡õ³¯bífeõJ†Ðm ý›"#Þ÷cd9øw?ú™¸¿ñKs¥ýkèýNöb1ïÅÎ{w,¦:›Œns½!gèòv5Ž{þÉmì\Šµ×u~•ÍW!Á¦D8}+{aôÜÏÌº¯Ò±KbCæ_›¹xŸ—OÉô„—#õwëøÏoMëWzµ8íÁêv@.Ÿ¡‡ÔHÚÆfÜ|¯æz‡üoè®ë•¨ÈHX6Ò‰‰¢)I$’(RI$’ŸÿÐõT’I%)$–&gÖ¼sƒ‡“ÕrªvÌŠðkõ$Ï·'"ÇÓ‰KýŸÍ¾ÿ Wù	)'Ö.½û"šk¢¡‘Ÿ˜âÌjí†÷äÞÿ s™ŒÏç=6Yfÿ Jšÿ \SïÌÌêÖäõþ×•EUœg†
ë¥·:ÿ Y˜tKý-þ‹+~E–[—mlôì»Óý±×zù?Yh9xY˜"ìCFY¬´¹¯9=FÙÆ¿!Œýz¿ù
…÷º¾£·³•hÙupo§ïbÛ•{ÿ GŽÇ¶ÌŸû°ÿ g¥EŠ¶yÈÈÃaMœ0žæÛ©ö?ní§oïvûÖn[­Ç«Öê½M˜¸µâY03'!·çd;ÿ 
ÑŽ¡öœ÷‹Fê9»†™aåd´ÞœÍÿ ô)PˆµŸî‹e3zÞ4Ü³¨ôÚŽÛsq«pü×]X?æïÜ©uµÑˆö·:‡»uNk÷²Ú¬?F5ŠÞÝ.Ç>®ž)e”È¶†T)µ‘ô½Lg×Mìþ¿¦®­=ÃàHC@uO¢u#B5ú¹îëÝqŒêˆ“¯º?ê·®tGý¡ó°7ÿ >mZ­ÄÀ{‰>e¹yYwÙ‹Ó±ïê¹5Hµ”–Š«pÿ ‘›æbÕoüëmÿ ƒH#B$ýôZ™ôÿ Ð–£'#Lké¼øUc,?øœŠæ¹¦>D<Ÿ«zÚý[¾®ad¼æÎE&ßûrÌFWÿ ƒ,}ØØYnÀ¶Ž£Ð2«c­5û®ÇØÙõ.¿í¸Öã×·ßutWK?Ó'œ2ý/ú+Xž£þý'JÖ³'/Ð±­³»î­à9¯²ÐæQUŒtµìªV÷1ßŸv*Øú¹ÕnéY¸5ö¹ý/(ý›»NçcÜûqëªû«f%õÕe5Õw«ez×g£gèðjºÜoÍs.ÆÉ°ÛûN+› 1ùtî³ìômk(§+Ûñ?™õ}>­fEXõ×SìÍ·"–amØršöäa_{ë­•¾ê}?ú	c”£8±ÓÍY"%{|ŸRIsßó«'­³®ôŒ®—ŽãµÙ[ªÉ¢½>–Kð¬¶Üz÷{=WÑé~ý‹}cØ×±ÁÌp®A‡4«­6I$’JÿÑõT’I%8ÿ [º­½#êÞ~}2+¯f9h‹msq±ß–û.º·û–g\êø_âûêÆ/¡ŒìÆµíÇcwl/±Í}¶ää]²ÏÒ[éÙkýŸ¤µmõþ‘W[èÙ}.×l5íeœìx"Ê-ÚwzW2»>’ãþµýdÂÊú¯ŸÒ:î=tuêëcF§kmŽmõ›sÎÛqÚ÷ºïç=Z™UÕäÿ „INKú¶oTxë–VÚzXÇéÔ8‡·›­/$¶·ZÆí»¨ä¦ýR”öF-¸},ƒÂÒçØCí~NQÙˆ×ïþ“Õ:•¿¤ý/è±±+³*ÊþÏV>5³Äû-UíÇ±¶bôìj±jun`6>ò×Ö\ÝíÇÄÅbÑèÕ=™?TÛgª¿7«äC®u°þœÿ EÄÊô«ÿ Âê¬#îL™l=DyüŸó[3—· #ä—ÌîýTú›‹Ñ+™ŽýràN}ž÷¦œGYî¦†îÙíÙë…ÿ U]"I+Mg3­}^éj¶Œ¶äU'2£²ú]ûô^ßsâÿ šøJ×Á•Mù?:>Ý‚ðËžÖím¬xß›SGµ­É¬~’¶ÿ 3{-­qÍúÑõçëOÖ™›u?}”aÕ£SY^ë}=®}4Úæ³é>ßçÂ.ªŽ¥X¯¡u¼¢nNÊ£(·@ï²dÔÊn,o±®±ï»óÂ¨³ÀÖ,¸$DÀé&Ãq²:—PÆèØ¶:‡å‡Û•‘\o§½­¹õnúäÛex´[²ÏKô¶/AÀÀÃé¸u`àÒÜ|Z¶ª™Àÿ YÎs½ö=Þûïzä~¨çF`|zç§ÐiñôÅÙ>¿þé.Ù, ÷Ô£4‰™´
Y}_¤ušÝÒ²m`Êd[O§`nM7ÝNf1iõ¨¶§{™gþŠRúÇvu¨ÝÓÁ9•ãZê6‰pxc‹\ÆëºÆþcWÏ>º­¯3¨ÛÔþÇŸ†~+Hy¶ûKýÞ•õÿ 5mÎúŸOÿ ¶©XßO~=˜¸–uZ*³'ö_ÇkZÚ=Wl®žµS½6×Vk/Æ~uUÕèßNO­éz¸Ûí§ö6í¿¡Xç2‹ª6`XI.­­swcïúäÌ¯³Ýùÿ d³Óÿ  ¶p*ÊÏÿ •ç4×‘“Óp›˜†·)ØV}§`ú«kñÖ&NLàtÎ«oÒ­øÖÜàŽÌªÆ6VÖ°9îþ’ÇícÁªÙãR~—ý(ü­Œ2¸Gþ‰ù?¨ÿ _úß^ë—ô³‡QÛSÃßK6šÏ§hÊm–ZÏNÏ¡íÿ ÿ ºo©Ì³?¥8Í=+:Ü\IsžF9mY˜µ¹ö?ôeýŸú•.? ýiÄè£ª}§Ý“•Ôsšê³N§mƒŠ¾Ù™kuuW•nO·Ñ³éÿ Ã.óêÿ HJÁs/°_›•kò³¯l†¾ûLØX×}
«he·ýLV"lÁ!D‡M$’EÿÒõT’I%)p_Y°Ù‰õ‡&üÆ³ìÝQ”{nôýZ[eáï·èÚêÝUôÖïçÿ Oé4»ÕÇ}yknê}'àÛ(ô³.4¼1ÏhÇÆfúß¹¯ÙVfBfP%kñ&)ç°+®®¥ÔªØÚ™êc;k hØìv2ZÖC~•v­¬/´ä}Qé9Ø5ú½Sê½‚»qk‡½ÿ fkº~~#>“›f^¾ÑíÞÿ Õ–ññzSþÝKiÅÙ³>ªYÀKêÎmUý'a¹Ö}£c¡Úÿ ûŽ´ðó³zvAÎé¦»{YëP÷E9hýÈ¬Yèäz^Ê2šÛi¶¯N»ÙìªÚ«âÈ#-~Y /Æ,ùq™GMâI¯	=ßOê]K
œü[‘‹ÝõZÞã¿¹¯k½–Vÿ }oýŠÂóûz×LÅÈ·¨àdäý\ÌÈ°Ù—‰•ŠüŒìÛï¹ßcõ1ë¶è¯ÔÌÃÍªË=?ÓÕeŠmÿ }Oì±N6SËŽ0Ÿ™´Ÿ…½3Ò¯þ»š­q
»æÖá7Tm³Õÿ ÅWÕ<üûzÎ¿Ô&ÛëªÆ¶¢d¾Ûê×cëßùû,gö=•Ôú9G¨1ìÀéTÐÞŸÑëqvçãÔãfFc)iºÛ“•üÝûwÛU¥ß¤±?¨ýeë_g£¬úgívlÄèGh½íÝfî¡–]c‹_é2™SþÍü×øDºïø¥ëU¬Î=Gö‘küq[«ÆcZÖ±µcØßZí•GçÓú_øÃúÁ@úzËöExýY²=]#ûd‹ë/OO©tœ‘—•‰¹—a°[‘fÓ“F;2O¯‘K«f^5,é,¯Óÿ ½7§u©‡^wO¹¹×Ì±‡Oê¸}&=¿Ÿ[ÿ I_ç¯,èßâW©71¶un¡UTVC‡Ø‹i þm—ÕK(ÿ ŒÙwõ‡Pé]O¡u†4æ¿+¨^­ˆÑ[r,`/û7WéÎÝvWél~=Ÿ£ûWür@{c©ˆÿ *'Ü=Ù'Ó1ÕúoÔî‡:Ãúmê–»õ:k`6Ýx!Õý—{=Sgë«ô_ÎØõÌþÕúüËClêµäÐß¥éWN=îþ·¯‡—_öp2ú†Ÿj£½JÁ²î¥Ÿ“oPÈ5ËŸéÕ[)À¦–{ÿ š¢ìjàÒ÷±ïÄídý×W9·ôOªÙ8ÙV6Ï¬XŸis]hÈnË}9fIÄk?Iüß£‹þ’åÏuS‹ÓêfñMÈÃ©yk.¥ÍsÜ~ŽÊhVâÇ]nveîÊË}a·æ_µ‘SâÊØÝ˜øXVÆWÿ “mßMTÅ¸gå}­’1pœYŠsM–Ù[ü×1Á¿ û&Cþ‘—Ý•þ‰WÉ“Œ‚¦›c> Aù¤ÊÌ¬>±}+*¼œœÜŠCYSÛfÖWmy™6½ÁÛécc\ÿ §¾ÏðkÔ—ž`Ýéuîe®ôñkÈ·{ÿ 4[e6bá±ÿ »ë?"Ö6Ïô¾_á—¡©¹p84êXs“Ç¯@¤’ILÄÿ ÿÓõT’I%)rŸ^ikoèÙ„ÁnE¸¿,Š.pÿ Á±h]Zç>¼ØÁÓ1),ßeùø¢£D×gÛ-³û8¸¹	³ù%äWCæ˜yÀKHp0F „>ÐzžUÙÿ ±ÝEXx–W[pïÜ*uÖ5¹y‡ê·Ù€ÖW‘OèMøÞ·«ú
‘ÿ Ô8n/U¬ˆ{z•®qîE•ãäRïûbÚêÿ ­ª¸"%"¢¶mg‘ŒAÝÆoNúÊÉž×ôY®iþ­ÈÇ³üêGÕÿ ­Y z•QÓdäXrí{\Ì\oKé~þuŸñk¹IN0cëñ`9òVï'oÔûzvNWé9S	Öúÿ l³oÚj¹¥®Çõj©ÌÄô=Ÿb®Š+Æ«ü'ó¶ØŸ§uÿ ­ý{¹}/§a`Tç¹‚ÜÌ‡ß»Ós¨¿f>Uý«{}ù>õÕ®#êwÖÑ~ªÑ‡Õ2ë§¨âÙ{20ƒ²E¯ÈµÞ‹1»"×¹Öû=:Ô VÌDÞéú?[úñ™Ò)ëNÇé™8—Po1÷ãÝ s½6¹ìÎ©Îöÿ !§å}nwOêÝs¾”Ü_§5ç Øü–?šûiÇ­¾†;ÿ W¦ªÿ ž³Öõÿ GZ«õwë7FéTééÝBãÔº}«úmÍ5äºÂ%•QfÛ2=mìô_Nö{×Iõkü?«½3%¥—Ñ‰Ev°ò×¶¶5ìÒ~ƒ½©)ÇÈúŽæ8—Ô­Ç®£å°fV Ue£=ŸÚÎ±S?Tþ´í4²œ5äñ_hwþ~]²I‡ñÆI¤^gêF>ñgYÈ=Oi%¸»8ƒV–9øu¯É{6ÿ ÚÜŒ–Á¬~µU¸ÿ Yz•vˆnX§7ë«uôü?Gu6âÓ¿ÿ Ò»åÇ}v×­tpÞ[Ni³É„b·Ýÿ _ôSrÀ{dUªìR>à$Ýèóý]¡Ý¨5ÂGÙo0|[[ìoý65zf-Ž·›_£¬c\ï‰ •æùXïÍm]*£uK#H‚[[~uÛ\[»ÐÁeïÿ Œô—¦   @o,=$÷+¹ƒêÁt’INÀÿ ÿÔ½‰Ôº‹zæ/YËy=AÙŒéF–{jª§=øŸce[ìk«§3#6¬‹êÝëz¿£ªïEz:å~¶}W¿6Ççtê›s²+êÂ—Ü+÷båãdý
º†ÚßM×~ŽÚ¿Fû+ô)YOÁúçÔÞ)´u5»9yø4	áÐZìÌ¿Ýÿ B˜¢H ÊÍÆ»~êò# ":Qþ/~¸O¬Yõõ.¾E.ctv;9¦AË»oÚÄ‡mÝ‡ŠÚèþE™—Ôª¨=mãm¸˜³÷,ÏÏ{í»ª¶¿ú+[ê>a¤779¸,hŠñ:]u¶¶{œïé”Þû·îÿ ‡ïÿ ›>9ë"?îx—C‚$HËŠºDßp¸y9LÇôXoÊÊx«¤5÷XL1ÏöUSÃäÙú*?ã?D»«}ý'§zym™¹/9¶3vÃsÃ[¶ŸSÜÚ(©•cQÿ OúEÏõß«Ø]#£»Ùmïë8ÈË½æË¬æ¦¶Ë4ý=OÑÑS+¢¿ðu.ÕX„y¨Ë”ÌöˆRI$¤cR	ÄÅ9#,ÓYÉkvöP7÷=Xßµ$”Ä±…Íqh.lí$j'ªI$’”’I$¥.ë‹þ¶e‡·kêÂÆm ]Q³%ù1Ÿ¹ëú[ýJ¿»µõ«¦afôŒ‹ï¯õŒ*n»!„²Úžã¾›™ïgÑnö5oøfX›’<Q1ºµÐ—„ªéæ:N~'Kë•çõ F#ñþÊÌ©%˜ö>ÏRÛ2™þŒ¶·¿¶ÿ 7öNÿ J»}Eß1ì±²·±à9®iAÕ®k‚óœlN¹OHÁê™9ØÙxÔä?'¸º§\Ö=ÌÈÀ«w¯K}_é>ýŸÎá…MÑ:«°.}_ÈÆ¿À}^™êÅ.'Þ/ÄôEötüwéªf/Ùïüú)»ôª(Lã¨LPé!ò²Î%ÊÏXõ{n·Ö™Òê­•×öœì¢[‰Ši{„o}?ÍcÓ¹¾½ßú:Ê«Ó¾°un­]]Bûú½ÍkÙƒSjû5NÜ}ZzŽ-u]fÍý£/©~Ò»þÑÖ–>WÖ/¬/§=ðûªuO³oh¯²ƒÒ*ÈpõjfuÖ_“’ÿ Õò2«ªÿ I”Óé®û–ãâRÌzô*©¡ŒÕcZ¥Œ¸¬þèÿ )G†‡é~“ÿÕõT—Ê©$§ê¤—Ê©$§é/¬¿³ý·ú»hâzŽÙõýV}›Õõ?í?©üþÏÒzÍ­…òªI)ú©%òªI)ú©%òªI)ú©%òªI)ú©%òªI)ú©Rëa§£g‡Öœk¥Àn lv»w3wùëæ$’Sô¯ÕHÿ šýi%¿aÆ‚Dôkíª©Öÿ æ'©oíÏÙ¾¾ßÒ}§Ñõ¢;oýc~Ï¡³ôŸ¸¾uI%?IýWÿ ›¿²ÿ ìwgØýGú›woõ´õ~ÕöÖ¾Óô?¥~›Óô¿Áúk]|ª’JÿÙ8BIM!     U       A d o b e   P h o t o s h o p    A d o b e   P h o t o s h o p   C S 2    8BIM          ÿá:¶http://ns.adobe.com/xap/1.0/ <?xpacket begin="ï»¿" id="W5M0MpCehiHzreSzNTczkc9d"?>
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
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                            
<?xpacket end="w"?>ÿâXICC_PROFILE   HLino  mntrRGB XYZ Î  	  1  acspMSFT    IEC sRGB             öÖ     Ó-HP                                                 cprt  P   3desc  „   lwtpt  ð   bkpt     rXYZ     gXYZ  ,   bXYZ  @   dmnd  T   pdmdd  Ä   ˆvued  L   †view  Ô   $lumi  ø   meas     $tech  0   rTRC  <  gTRC  <  bTRC  <  text    Copyright (c) 1998 Hewlett-Packard Company  desc       sRGB IEC61966-2.1           sRGB IEC61966-2.1                                                  XYZ       óQ    ÌXYZ                 XYZ       o¢  8õ  XYZ       b™  ·…  ÚXYZ       $   „  ¶Ïdesc       IEC http://www.iec.ch           IEC http://www.iec.ch                                              desc       .IEC 61966-2.1 Default RGB colour space - sRGB           .IEC 61966-2.1 Default RGB colour space - sRGB                      desc       ,Reference Viewing Condition in IEC61966-2.1           ,Reference Viewing Condition in IEC61966-2.1                          view     ¤þ _. Ï íÌ  \ž   XYZ      L	V P   Wçmeas                            sig     CRT curv           
     # ( - 2 7 ; @ E J O T Y ^ c h m r w |  † ‹  • š Ÿ ¤ © ® ² · ¼ Á Æ Ë Ð Õ Û à å ë ð ö û%+28>ELRY`gnu|ƒ‹’š¡©±¹ÁÉÑÙáéòú&/8AKT]gqz„Ž˜¢¬¶ÁËÕàëõ !-8COZfr~Š–¢®ºÇÓàìù -;HUcq~Œš¨¶ÄÓáðþ+:IXgw†–¦µÅÕåö'7HYj{Œ¯ÀÑãõ+=Oat†™¬¿Òåø2FZn‚–ª¾Òçû		%	:	O	d	y		¤	º	Ï	å	û

'
=
T
j

˜
®
Å
Ü
ó"9Qi€˜°Èáù*C\uŽ§ÀÙó&@ZtŽ©ÃÞø.Id›¶Òî	%A^z–³Ïì	&Ca~›¹×õ1OmŒªÉè&Ed„£Ãã#Ccƒ¤Åå'Ij‹­Îð4Vx›½à&Il²ÖúAe‰®Ò÷@eŠ¯Õú Ek‘·Ý*QwžÅì;cŠ²Ú*R{£ÌõGp™Ãì@j”¾é>i”¿ê  A l ˜ Ä ð!!H!u!¡!Î!û"'"U"‚"¯"Ý#
#8#f#”#Â#ð$$M$|$«$Ú%	%8%h%—%Ç%÷&'&W&‡&·&è''I'z'«'Ü((?(q(¢(Ô))8)k))Ð**5*h*›*Ï++6+i++Ñ,,9,n,¢,×--A-v-«-á..L.‚.·.î/$/Z/‘/Ç/þ050l0¤0Û11J1‚1º1ò2*2c2›2Ô33F33¸3ñ4+4e4ž4Ø55M5‡5Â5ý676r6®6é7$7`7œ7×88P8Œ8È99B99¼9ù:6:t:²:ï;-;k;ª;è<'<e<¤<ã="=a=¡=à> >`> >à?!?a?¢?â@#@d@¦@çA)AjA¬AîB0BrBµB÷C:C}CÀDDGDŠDÎEEUEšEÞF"FgF«FðG5G{GÀHHKH‘H×IIcI©IðJ7J}JÄKKSKšKâL*LrLºMMJM“MÜN%NnN·O OIO“OÝP'PqP»QQPQ›QæR1R|RÇSS_SªSöTBTTÛU(UuUÂVV\V©V÷WDW’WàX/X}XËYYiY¸ZZVZ¦Zõ[E[•[å\5\†\Ö]']x]É^^l^½__a_³``W`ª`üaOa¢aõbIbœbðcCc—cëd@d”dée=e’eçf=f’fèg=g“géh?h–hìiCišiñjHjŸj÷kOk§kÿlWl¯mm`m¹nnknÄooxoÑp+p†pàq:q•qðrKr¦ss]s¸ttptÌu(u…uáv>v›vøwVw³xxnxÌy*y‰yçzFz¥{{c{Â|!||á}A}¡~~b~Â#„å€G€¨
kÍ‚0‚’‚ôƒWƒº„„€„ã…G…«††r†×‡;‡ŸˆˆiˆÎ‰3‰™‰þŠdŠÊ‹0‹–‹üŒcŒÊ1˜ÿŽfŽÎ6žnÖ‘?‘¨’’z’ã“M“¶” ”Š”ô•_•É–4–Ÿ—
—u—à˜L˜¸™$™™üšhšÕ›B›¯œœ‰œ÷dÒž@ž®ŸŸ‹Ÿú i Ø¡G¡¶¢&¢–££v£æ¤V¤Ç¥8¥©¦¦‹¦ý§n§à¨R¨Ä©7©©ªª««u«é¬\¬Ð­D­¸®-®¡¯¯‹° °u°ê±`±Ö²K²Â³8³®´%´œµµŠ¶¶y¶ð·h·à¸Y¸Ñ¹J¹Âº;ºµ».»§¼!¼›½½¾
¾„¾ÿ¿z¿õÀpÀìÁgÁãÂ_ÂÛÃXÃÔÄQÄÎÅKÅÈÆFÆÃÇAÇ¿È=È¼É:É¹Ê8Ê·Ë6Ë¶Ì5ÌµÍ5ÍµÎ6Î¶Ï7Ï¸Ð9ÐºÑ<Ñ¾Ò?ÒÁÓDÓÆÔIÔËÕNÕÑÖUÖØ×\×àØdØèÙlÙñÚvÚûÛ€ÜÜŠÝÝ–ÞÞ¢ß)ß¯à6à½áDáÌâSâÛãcãëäsäüå„ææ–çç©è2è¼éFéÐê[êåëpëûì†ííœî(î´ï@ïÌðXðåñrñÿòŒóó§ô4ôÂõPõÞömöû÷Šøø¨ù8ùÇúWúçûwüü˜ý)ýºþKþÜÿmÿÿÿî Adobe d    ÿÛ „ 

		""ÿÀ …— ÿÝ  ³ÿÄ¢            	
         	
 s !1AQa"q2‘¡±B#ÁRÑá3bð$r‚ñ%C4S’¢²csÂ5D'“£³6TdtÃÒâ&ƒ	
„”EF¤´VÓU(òãóÄÔäôeu…•¥µÅÕåõfv†–¦¶ÆÖæö7GWgw‡—§·Ç×ç÷8HXhxˆ˜¨¸ÈØèø)9IYiy‰™©¹ÉÙéù*:JZjzŠšªºÊÚêú m !1AQa"q‘2¡±ðÁÑá#BRbrñ3$4C‚’S%¢c²ÂsÒ5âDƒT“	
&6E'dtU7ò£³Ã()Óãó„”¤´ÄÔäôeu…•¥µÅÕåõFVfv†–¦¶ÆÖæöGWgw‡—§·Ç×ç÷8HXhxˆ˜¨¸ÈØèø9IYiy‰™©¹ÉÙéù*:JZjzŠšªºÊÚêúÿÚ   ? õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*²I5.ä :’h1V1¬þiù[E¨Ô5KH˜~É™KÈ´%ÿ áqV®ÎZùN¯Õæžõ‡h!aÿ qè.*óÍ{þs{ªèºWÉîeÿ ™Q/üÎÅ^o­ÎXyëR'ÑºŠÍ| …?âSúïÿ Š±-GóŸÎZ‡ûÑ¬^ÐöIš1÷EÃI.<é®\o6¡tõþiä?­±Tº¥ÜÆ²Í#âäâ¨Rk¹Å]Š¢bÔ®¢<£–E>!ÈÅQqy£U‡x¯.ž¸ÿ ±Td_˜^d‡û½VùÕ¹”ÆøªgkùÍç;oîõ›ßöS³ÄËb©¥¿üägŸmþÆ¯1ÿ ]coù9b©ÕŸüå‡Ÿ-ö’î)ÿ ×‚?ù–±â©íüæ›¡5¹¶±™Ôu?ð³Æ¸« ²ÿ œá½Z}sG‰ü}9ÙâQÉŠ²KùÍ½J}wMºˆ÷ôÚ9?âfU•ißó—EºÖžâÚ¿ïØÿ É[eÚ_ç’õ2¾±h	è$Fä·§Š²û-JÖýyÙÍÉãð¸ª+v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØª×uK1 ¤ì1V1­~hù_D%uRÒ&TÌ¥¿äZ’ÿ ð¸«Ö?ç,<‹§ÔEs5ÛÐBßñ)½ÅX6±ÿ 9½`•V•4¾yV?øXÖø–*Â5ùÌÿ 4Ý|:}µªøñiþ	ÝSþIâ¬'Wÿ œŒóÞ©Q.«,J{@©ü4Jÿ Š°WÌÚ¦¯¾¥yqs_÷ì¬ÿ ñ6lU/Š'•¸F¥˜ö¸« Óÿ .üÁ~xÁc0÷‘}1ÿ 7¦¹QËÌ¶R=.›ù­Ü€×O¸îoù&?ä¦RuQÃM"Êôÿ ùÇí:1þw4­ÿ …Œ}Íëÿ Ä²ƒ«=xÒŽ¥ù‹ùa¤hz·Ö¸žŒ—g,H,#¡Sð~ßeÉaÎg*,3a…¿’¾]Òu}6w¾¶Škˆç"®µ<J§ÿ êaÔÎQ"—OÈzBù'B4û_ùŸóNaøÒïs<(÷.ÿ hõo´ÿ ‘ÿ Í<Yw•ð£ÜþÐÿ êßiÿ "#ÿ š1ñeÞWÂphù+C?ô¯µÿ ‘)ÿ 4ããK½|(÷(Éù Iö¬-þˆÀÿ ˆáñåÞ=È)ü³)«Y/Ðò/üBEÉ~b}ì|w(¿ä÷–¥¡_”²ÿ 2_™š?-¾ãò+@—ìµÄêÈ?æbI’©y1ü¬|Ðsþ@i~æâåOùEõF™!«=ÌN”w¥ÿ 8ð?cPúÇÖÉ_“¤óJî 5Uoô{«w_æ§þ%ÿ ‰dÆ®>l–^IUïä§˜íÛŒQG8ñŽUþKzY`ÔÀµ<‚O{ùqæ&ã-ŒÍÿ ×Ô|>¦X2Äõ`qHtI/të›ôîâx_ÁÔ©ÿ †Ë¶²)«KéìäZÈñH:2§ï\(fºç·tJMZá•z,ÍêºãÔÅ^™å¿ùÍ/0YšÕ½ê­0¿ßûØÿ ä–*ö¯#ÿ ÎRyCÌì¶óÌÚmÓmÂêŠ¤ÿ “:Öùéâ¯]ŠU™ÆC+
‚A_Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š­f
	&€u8«Î|áÿ 9	äß*³Eu|³Ü/X­‡ªÕð%?tŸóÒDÅ^;æOùÍÎ© i).¤ÿ ™0ÿ Õ|Uæÿ üå/žµ}’ñlÐþÍ´j¿ðïêKÿ %1WžkpÖu²N©}su^ÓJî?áØâ©\Q<­Â5,Ç°ÅSëËÝ~ù‚Ãc8¯wSÿ ‚—‚åg,G2Ø1Èôd?‘¾`¹˜Coí$•ÿ “"l¤êbFšEXÿ Î=¹P×·Á[ºÇGüºÿ É¼¨êÇ@Ú4‡©dV?‘Z»™§Ÿü—pþI,oÿ ”T&Ñ¥‹ Óÿ .<½a¼61øÈŸò|É•ò=[FŽ‰ý­¤6ˆ"¶bŒtTP£þr“"y¶ˆÉW'b®ÅXïæ%’Þù~þ&è i>˜ÿ |?òì¤s‰y×üãÍÊ¬—öäüL°¸ÊdVÿ ‰®fjÆÀ¸šC¹gÍk±v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wöí¢’[ÿ %è·á…Í”_«Õ[þF'ÿ †ËFY­gOF7¨þHùzïxV[cÿ ÈHÿ ’Þ®]T‡6“¦‰äÃuoùÇûØm:ê9ö¯Æ~@¯ª§ý—ÈŽ¬mÒ‘Éçš÷–µ
_GR¡cZ>ÿ Q×àö—‰rq%lƒÉœ>gòK£^º@ðIñÄç”œ•?Öƒÿ •“búÈÿ óšVWmüÕfÖòt3Û|iþ³Bß½Oö6*÷¿*ùûCód^¶‡{Ð¥HFø‡úñ5%OöIŠ²UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨MSU´Ò­ÚóP–;{xÅZI*îÍŠ¼óþsCÑùZùn#©\½F¬pƒóþö_ö*‹ÿ b¯›<õùÛæŸ;rMVñ…«Ç¼?»‹åÁ?¼ÿ ž­&*Ät½÷U“Ñ°‚Iß¸E&ŸëSìÿ ²È™Í‰<™Î‘ù­ÝÑ¯+Eî¹µ=–.Iÿ %1¥©ˆå»‘4“/Ó tÈ@úõÌÓ°þ@±©ù¯ï[þ1å«=|t£©eZwå——l(¬£cÿ ÖOÂc"å<Vñ‚#£"µ³†ÍVÑ¬QŽŠŠÀ®RdO6Ñ9*àdìUØ«±Wb®Å]Š»v*¡¨ZÛim[ìÊŒ‡äÃŽJ&ˆc!aàß÷+»"1Þ[gQóÿ ÄQ³iª—Y¦>§Ð©v®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wbªw6±]FÐ\"ÉŠ28¤”­±Â	@<Þ}æ?É'R&[k)Oeø£ÿ ‘m¸¯ù*ÿ “™pÕÏwz`ylóò^Ò*â­D?n‹þIí7ü“ãþVfÃ<dáÏ¢Äí/'±•g¶w†d5VBUÿ %—q™\ò_üåWœ<»Æ+¹“S¶_Ø¹z“pœdÿ ‘ž®*÷%ÿ Î^ù[Zã°’éw€—¤Uÿ ŒÑü_ò2$Å^Ñ¤k¶ÔëL¸Šæèñ8q÷¡ÅQø«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØªY×ltKf¾ÔçŽÚÙ>ÓÊÁGü6*ùÛóþs&ÊÓŸ“àúÔ»¬Î
Æ?ÊŽ†Y?Ùú_ì±WÍrüÃ×|çqõ­vîK’	*„Ñ¿ï¨—÷iþÅqV¼³ù«ùˆ†²„ˆß²|1ÿ ÁSãÿ aÉ²©åŒ9¶Ã—'¬ykò/M²]YÍÜ¿Ê*‘¿É>£Óù¹§ücÌ	ê‰å³›0Þecoc‚Ò4†!Ñ#Pª?Ø®Ù†dO7,DJØ;v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÎþE…t¿;­µ~®.!ÿ …–%üsq—Õƒ¨Å´þ/¢3NíÝŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*“ëžOÒuÑþäm£•¿žœ_oøµ8ÉþÇ–[²"Õ,Q—7œk¿Õ}è©ì“ŠŠÿ ÆXúÈ–ÿ [3!«þpq%¥î/8×¼ƒ­h@½í³ˆ—s"|iOwJñÿ žœs.9c.EÄ–9G˜K´O0êÂëJ¹–Öaûp»#}èrÖ·´y;þsÍ:?µ„‹T„u.=9iÿ b?àálUîžNÿ œ®òw˜8Åy+é—önGÁ_iãå?ã/¥Š½zÃQ¶Ôa[›9Rx[£ÆÁÔü™>UŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ƒÕukM&Ýïu	’ÞÞ1V’F
 {³b¯2¿ç1¬lyÙy>­Ë¸úÌ ¬@ÿ Åq|2MþÏÒ_õñWÌ^oóÞµæû“y®ÝIu'`ÇàZÿ ¾â_ÝÇþÁqTO–?-õŸ1RKh}+vÿ wKð¥?Èý¹?çš¿ùYLóFÛ¡ŠSäö+þMhú=&»]¸å ?äÃºÿ ÈÓ/ù<s_“ReËÒçCN#ÏÔÏ@ Plb9nÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯õ«oÑ¾|Ù~¿§þz2Lßñ<ÜGÕü×Q-§þsèŒÓ»wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUŒëÿ —¹Wº¶T˜×÷‘|SûG‡Âíÿ Uòøg”Z%†2yÞ½ù<dÉ£Ü¬‹ÔG0âßò1ÿ €‹3!«›‰-)žy®ù;VÐû‘¶’$œéÉ?äjV?ølËŽA.EÅ”yµåÏ8jþZ—ë5äÖ’wôœ€Ö_²ÿ ì²l×äïùÌŸ0éœa×à‡RˆP_ÜËÿ €Âßò%ÖÅ^çäïùÊ&yŒrÜ>àþÅÐà+ÿ Ç(?à¤\UêÖ·Q]F³@ë$n*¬¤2‘þK.*­Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š©Í2B†IHTPIbh 'x/æwüå®‹åþv>ZS½J‘n‡ýq¼ÿ óËàÿ ‹±WÊ~züÊ×|ñqõ­vé¦ ’‘£OøÅøýo·üÍŠ¬ò¯åÞ¯æRÒ.ýæ“áO ý§ÿ žjÿ åqÊ§–0æÛF|žËå_ÉÝ#D"{‘õË‘ûR
 ÿ V³ÿ #=Oòxæ»&¤Ë—¥ØcÓˆóõ3ÌÄrŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|ïùÍÙy™îTÑ¤H¥_ö+é~¸³q§7S¨7ÑqÓ5Sµ»]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®"»U‰kŸ•š±V{q§öàøüý×üy‘D¢ãËdó½{òö
É¤Î—	BBIð?úªÛÆÿ ì½,Ì†¨{8’Ò‘ÉçÚß•õ=‚j6òC^„Š©ÿ VEå±lÊŒÄ¹8²4W•üû®ùVOWC½žÓz•G<úñÝ¿û4É±{—“ç4uk>0ù–Î;ØûËî¤úSâ…ÿ Øú8«Ý|™ÿ 9äß5qŽÁkrßî›¡é5|9ŸÜ¿û	qW¥+¬ŠH*EA‚1Uø«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å^gù¥ùýåïËôh.$úÖ¥O†Öÿ ?ÙÖøÿ –<Uñ÷æwç¯˜¿0$1ÞËèiõøma%SÛÕ?jfÿ _ý‚&*Å<·äýOÌRúzt%À§';"ÿ ¬çáÿ cñ?ù9\òsgr{?”?%ôí$-Æ§KË¡½ýÚŸòPÿ yþ´Ÿò-s]“RO-†=0÷z"¨PE  f–Þ)v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Â?íŠêÖÓŸ²öÜÍ]Ûþf.m4‡Óñuš¡ê{'–nZëJ³¸µ%¼N~lŠÙ¯È*GÞçã7îL²¶Çb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅZ’5‘J8¬(AÜ„AÃußÊ=V«ˆ~­)ý¨ù'ñEÿ $ó"™GÍÇ–ž'ÉçZçä>©kWÓeŽí>û·'½rþJæd5Q<ý.$´Ò·yö«¢^é2z:„@ç§5"¿êÿ 7ûÊ“ŒbG6EäßÍ¯3y5€ÑoåŽþêcÎ#ÿ <däŸð?I‹èO Îg[Ü2Zù¾×êäÐ}fØOõ¤·<¤_ùäÒÿ ©Š¾Ñ5ëvÕ/ô¹ã¹¶“ìÉõ×ù8ªaŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±T¯Ì>cÓü»fú–­:[ZÇöÍú£»;~Ê¯ÄØ«ä¯ÍßùËKýoÔÒü£ÊÊÈÕZäí<ƒþ+ÿ –tÿ ’¿åGöqW€[ZÝj·(ç¹”ôfbzŸõ›5Í _'®ù7ò1c¥Ï˜X1ÿ |FM?ç¬ƒý—ÃüŒÌš®‘s±éºÉëV–pÙÄ¶öÈ±D‚ŠˆòUÍy‘;—< 6
¸ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å^9ÿ 9Ú{þÿ ÿ ÈšfÇHyºýXäÏ¿-o>·åÛ|"	ÿ  L_ñ¦bç2äà7Ér†÷b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*¥uiÜf”Ybn¨êOÍ[l ‘ÉÍëÿ ’z.£Y,ùYÊzpø’¾-ÿ Äcxó.©~§z`yz^OæßË=WË Í*	­Aþú=Àÿ Œ‹ö£ÿ eð—™ØóF|œá0æ¥ä?Ì½sÈ·b÷C¸h«öâ;Ç ð–/²ßëýµý†\½¥öwä÷üäNù€«e9ZÅ(`vø\ÿ 5´Ÿ·ÿ Û÷¿ëý¼Uë˜«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Ï6¿:4Ë‹?Rí½{ùGîmPüMþ[ÿ ¾¡ÿ ‹?àñWÃ¿˜ÿ š:ÏŸïî±11‚}(¢(ÁíÄ¤oÞ>*«äÊýCÌünú=‰ÿ w0¯*~ßúßÝÿ •ËàÌ|¹„=íøð™½ëË>PÓ¼µ¡§EÄ·ÚvÝÛýgÿ Wàÿ '5y2™óvpÆ!É9Ê›]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯0üþ·¤[OûKr|™$'þ!™ÚC¹pµC`œ~LÜ‰|µnƒ¬M*ŸŸ6“þ7Êõ#ÔÏL},ß1\§b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ˆPî*òï=~K[ê¯t °\nZˆçü÷ËÉ/øÇñ6gbÔÖÒpré¯x¼ZîÒïHº0\+AsŽÌ¤n¬¤Á+Ù{‡^Es}-ùÿ 9ZÑzz¤,›,WÇ¨ð[¿æÿ Œÿ kýûþüÂ‡ÕpOÂ,Ð°xÜ¬¤Aî¬:âª¸«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUæÿ ßœVŸ–úQ›á—S¸m =ÏûöOø¦?øvýÚÿ ’«à0y‚ûÌwòêzœ­qw;rfn¤øåUû*‹þÇz·åçäâ SóVO´–ç þVœ7üUÿ #i3_›SÒ.~?Y=qT 
¢€
 ;×;ñWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Vùáiëùy¤ÿ |Íýõ‹þfæ^”úœMHô¡? ÞºËátÿ ñ²Z±êäiNß¥f˜ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUyÃÈöiƒÓ»^3¨"9”|Kÿ 5§üWÿ Á¾<»Sœ˜„ß<ù·ÉwþV¹ô/¨Õ1Ê¿a‡ù'³/í/Ú_õ~,ÛãÈ&,:©ã04^‡ù#ÿ 9¨ùUÓõ×š#‰ø¢¯íÛ–ÿ †‡ì7ùñeo¶ü³æ}?ÌÖ1êº<ëqi0øY|{«/ÚG_ÚFø—MqWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Ã4?3´ÏËÝ)õMI¹Hj°BWþDþUîÇý…ÿ cŠ¿?¼ñç]CÎz¬ÚÖ­'9å;öQØŠ%ý˜Óþoo›z‡ååªÙ¤zö¦µ¸aÊØ}€Ý­ÿ 7ì"ü_oû½n£7ð‡a§ÃüEêù€ç»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Ä?7Ÿ–/@ëHÏÝ,g2tçÖ}@ô–)ÿ 8÷uÊÒößù$ÿ àÃ/üÊËõc“F“«Ö³^ç»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*„Õt›]ZÝ¬ï£Y`~ªß¬+ÙeÉFF&ÃDHQ|ûùù_wå–k»zÍ§Wgý¤¯ìÊ?æbüþGØÍ¶,âÖuYp˜Uß•›ÚÇåÍïÖtÖõ-d#×¶r}9 ÿ “rÿ ,«ÿ Ÿd¸ï».¿2tŸ?é«ªhòW –&§©$‹ÿ o°ÿ ³Š²ÌUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»aß™Ÿ™ÚWåî˜Úž¨õsU†#œ¯ü‰þHý¹>ÊÂâ¯ÿ 0ÿ 15O?j’jÚ³ÔŸ†(”ü%~ã_ógof_•_•ŸY1ëzÂþãf†oÂYGûïýöŸîß´ß»ødÁÏž¶n¹{^k“±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅR?@&Ð/Ôö·‘¿àT¿ük—aúƒNo¤¼ãþqáèÚ‚w"÷zß×35|ƒ‰¤æ^Ëš×bìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±U³B“#E*‡ÁVVŠ²ž áE¼;ó'òŒéjÚžŒ¥­â’!»F;º×âx×ö¿i>×ÙäË³Ã¨âØóu¹°pî90ß$yóUòN š®‰1ŠeÙ”î®¿µ©ûhæäâÙšá¾íü¡üæÒÿ 2l}[b Ô"×¶cñ/ùqÿ ¿!oçÿ bø«Ñ1Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼ûówó“Jü·°õïšþP~¯j§âsüÏþû…nOö)É±WÂxóæ©ç}FMWY”É3ìª6D_ÙŽ$ý„ÿ ®Ÿ“b¬çò¯ò«ë\5j?ÜlÐÂÃíøK ÿ }"»~×÷|}Lùë`æàÁ{—µæ±Ù;v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØªQçËE¿6³ù&Ùf/¨{Úò}'Üò?ùÇû‚5+¨{4¿àYWþ7Í†¯é÷KÌûžçš·fìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å^Iù‘ù@“‡Õ4ã «In£fþfŸþ*ý¿Øø¾Ø`Ôt“¯Í§ë“ù{ÌWÞ\¾‹TÒæk{¨ZªÈz’™[ì²7Úý¬Ø¸¹?#??,1m…•ßmn%¬×á÷u¿ù?ÏÛü¤øñW­â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å^-ùßÿ 9§ù$Òô¢·zááZÇ	?µqOÛþX?àø~Ò¯Š<Ãæ+ÿ 1ÞÉ©j“=ÅÜÆ¬ï¹>ÃùT~Ê/Â¸«Õÿ .?'– šž¼•}™-Øl?”Î¾?ñWüŒþL×æÔt‹Ÿ‡OÖO]Ís°v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨v#.ŸsêÐÈ>õ98söä^%ùÜÜãþ]þNC›-WÓñuÚ_«à÷¼Õ;Gb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUæÿ ™_•1ëõ-,ïéV^‹/üÓ/ù_·ûÍ™¸5;Nl[‡‡[\ÞèW«<ö×¶ÏU*Jº:Ÿ½XfÑÖ>Óüƒÿ œŒ¶óÂ&‰­²Á®(øOD¸ }¨ÿ ’oç‡ýœ_¶‘ª÷,UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±T=íì6P½ÍÔ‹1)gw!U@ý¦fû8«å_Î¿ùË¸õ4_$¹H÷Y/©B|EªŸ°?âöøÿ ß|¼Å_5ØØÝë7kon­=ÔÌvêÄý¦f'þà&·)özüºüªƒËÊ·Ú€Yµ£ºÇþ§óIÿ ±Oç}^mGÃévxppîy½0Ü·b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU-ó4ÿ WÒï&zvò·ÜŒÙ<bä=íyDûž3ùbâP>µ*O¹xÈÿ ˆ6lµgÓñp4¿WÁïªvnÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±V	ù‘ùe™“ë¶|bÔPu?f@:$Ÿå/ìIþÁþ>ž^ü¥ÅÍƒqõ<x.ô{¿N@ö÷p7¸e`ve#þ—6 ß'VE>Áÿ œ{ÿ œ‹Ìë—|Í MXQa¨ò_²\ÿ Éïõð¡ô.*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Ï¿3¿;|¿ù{”¾µñKXˆ2ý’ÿ ³—'ûx«ã?ÍOÏ=wóR—¯õ}8RÒ"x
tiOÚšOòŸþy¢b¬{ÉÞCÔ<Ó7U+n¦3€{–ßä'û.+•dÊ!Í·3>O ¼£ä?ÊðzvkÊf’fÍ)þ@ÿ †o‹592™óv˜ñ2¥¹Ø«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*~`Oèhïã¯üáÿ eØ> Ó›é/:ÿ œx@N¢ýÀ€}þ·üÓ™š¾AÄÒs/dÍk±v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»b˜—vÞkƒšÒ+èÇîåñÿ ŠåñOødýŸÚVÉÃ˜Ãú®>l<Ö|íªéWz%ÛZ]©Šâ"*<Ueaÿ ›hÈaÔFÅõGüãßüäÈÔ=/-y¾Z\ì–÷Žv“ùb¹o÷ïòKþíÿ v~óâ’H}9Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*£ww¤MqpëQ©fw!U@ý¦fû#|­ùËÿ 9jò4$7W¾#sÿ 0¨ßdÅÏñ"~Þ*ùœµÞ¯tY‹Ü]ÎÛ“Wwbà°IÞ­äŸÉb·ža<FÄ[¡Üÿ ÆW_³þ¬ùk˜9u5´\ÜzkÞO`´´†Î%·¶EŠ$T@ ÙFk‰'rì `«.Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¬OóUøyjôÿ ’£ït~Ÿëþ’ÂçÃ¨ŸáëfV³§ÅÆÒu{kƒ±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±V'ù‡ä«1Y<×l šfYÀÝUjì²<_µÇö~Ò~×,ŒLM8ù±‰|Ç›—P÷ÿ ÉùÊKÿ *ˆô2ó½ÒÅ%­f„}?ßÄ¿ÈßþÃºñWØ>^óŸæ+$Ô´™ÒæÖO²èj+ÝOuuý¥o‰qTÓv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»@ëÅ¦i.£¨Ê°ÚÀ¥ÝÜÐ 1WÃž¿óß˜3¶Ÿ`ZÛC‰¾«F”÷mÇüiØOòŸâÅX“¼‹æ™ý+Eá‘êLÃáZÿ ÄßùQáWâÊ²d¶ãÆfv}å"iÞW‹¢¸aG™€æÞ4ÿ }§ùþË›|Y©É˜ÍÚcÄ È²–çb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅXæÏü£7¿ê§üœLÈÓýa£?ÐXgüãÇØÔ>pÿ ÌÜÈÖtø¸úN¯aÍ{žìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUæŸž>hý§&“R{ÃWñ©©ùzÅWù•eÌÝ,,ñw8Z™Ð¤·òÇòÎËQÐÞãWˆ3ÞÆvˆ>xÚŸ3rådôÿ ÊË3ç1•Œ0áž¬/Ï_•÷þY-qg°Ú’Ž«]¸ÊŸ±þ·Øÿ eðæF,Â~÷&rò÷ó?[òè½Ñ'(¦ž¤-¼R	cÿ ™ŸÞ/ì¾d4>Ðü¤ÿ œ…Ðÿ 0m	Z°´ösm'û»ýOïÈý¬Uê¸«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š 5jÏEµ’ÿ R™-í¢i$4|7ùùùóqù‡wõ<´:»V4;X»æÿ ™QþÂÿ –Ø«ü¼ü¼¸ó]Ç7¬VÞIÜŸ÷Ô_åÿ É¿´ß²F\¢Í¿#2ú7LÓ-ôËt³³A1Š*óÜÿ 3fžR26]´b"("r,Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Ä¿6P¿–o@þT?tˆs#Oõ†Œÿ AaóáÔGƒñõ³#YÓâãé:½‡5î{±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«RH±©w!UEI; sˆ‚ió•ì²~aù¤"!‘ø'ŠÂ›’7û\yIÇùß7#÷Pu÷²}	oÃ
…Ž5
ª: GÈfœ›ÝÛ[.e
°¨;p%åžzü”†øµîƒÆK@vF?ñYÿ uò»ÿ ŒyŸ‹S[IÁË¦½âñ‹«K½"äÃ:½½Ì$ljOUaÿ æÄÜ:ò+›èÉïùËK­/ÓÒ¼çÊêÔ|+v7•ü\¿îõÿ /ûïøË…¬t}jÏZµŽÿ M™.-¥I#5Gâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨=SUµÒ­Þ÷P• ·ŒUä‘‚¨å3b¯¿3?ç1ll9Ùy>®L*>³("!ÿ âød—ýŸ¤¿ëâ¯™<åùƒ®yÊãëzíÔ—,Â¤Ñþ1Ä¿»Oö+Š¯ò”Íz±.#‰Ë!ïÀZ&ßi™×íÍ¹N\œÛqcã4ú_LÓ-ô»t³³A1Š*óêi³M).â1YNÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Æ3"õ<»|¾Wî!²üXhÏô–ÿ 8ïÓRÿ £ùŸ™ZÎŽ6“«Ø³\ìŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å^ùÏæ¯ÑOÔaj\^Õ6ê#Þ·û/îÿ Ù·òæf›¿æ¸š™Ð¯ç%_‘Xúµ¤ºÜÃã¸ýÜ_ñOÆßìäç—ùY=Tÿ …†–Äõ\ÀsŠ»HüÕäÍ;Ìðz7ñücìJ´¿ê·òÿ ß[)‡&¬˜„ù¼Î¿–Ú‡•ÜÈã×³?fdŸóÕÝMþ·Áü™µÇ˜MÕäÄ`‰ü³üÜÖÿ /.½}&NVîA–ÚJ˜¤êþÃÿ ,©ñ±ørö—Ûß•œ:Gæ=‘¸ÓÛÒ»Šž½³‘Í?Êÿ ‹"oØ•Ùp‡g¸«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WŽþnÿ ÎJhžDçagMCW]Œ(ßgþ^%ìâ¤ýçópÅ_~`~jkþ|¸úÆ¹rÏ5Há‰?Ô‹§û7ç'ùxªÊß—š·™Hk8¸ÁÞi>úÚùæ¯þWªyD9¶ÃŸ'®hß“V“m#ÜÖòèÆÀ3Š"š7Ø‹âÿ ’'ó/À:“#·¥Íq¾ì#òÿ ¹Éÿ æÿ ää9“ªú~-o©ï™©vŽÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU óúsÐ/Ç_ôyÜ9eØ> Ó›é/;ÿ œx?ñÑñƒþgff¯q4œËØóZì]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_9yŠöoÌ3ˆmbvÄ{–¥¥úy7ó|\3sáCwO3âKgÐÖQX[Çin8Å
* ð
8®j%.#eÛDP¥|‹'b®Å]Š­–$™)T:8*ÊÂ ƒÕX áE¼wóòl/=K@_†œžÛõ´?õKþý÷›:›ÚN¿6ž·‹Í|©æ½GÊzŒZ¾“)‚î±ìGíG"þÜoö]3ÜßŸ“ÿ ›6™H¾¶¤W‘QnmÉÝÅš?ÝoþÇí£b¬ûv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUŸ—wr,PD¥ÞG!UTufcŠ¾Düíÿ œ¨ºÖžMÉÎÖö¬—B«,Ÿñ‡ö ‹ßûçÿ Š±WÏúNy­\[ÚiÜ“Aø³1ÙGùG#)îY“°{O’¿%-4þ7zß›ŠéuOù_ïßö_»ÿ ŒŸk5ÙuDíaM[Éé±Æ±¨Ž0   €Á&ÜÀ)w[øG5/ž#n^`ÝHƒèã'üi›mOÐê´ßSèlÔ;gb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*“yÕk¡êó9û‘²Ü?PjËô——ÿ Î=IIïÓÅ"?qù«3µ|ƒ…¥æ^ÓšÇdìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»a›Þgý	£<Q\^Vñ
Gï_þàÿ ž‹™ZhqJÿ šâê'Ãþsüˆò¯§ºìëñIX¡¯òï_§í7À»ÿ ¿2íVOájÒÃøž¹š÷=Ø«±Wb®Å]Š»xïçåÇÚ×ô¸ýîcQÿ %ÕäïüŒþvÍŽŸ5úK®Ôa¯Pa?•ÿ ˜×þ@Ö¢ÖlMP3EZ,±Ÿ·Ä£oØ“‹fÁÁ~‡ùgÌv^eÓ­õ5ýK[¤‡¾ýU¿•Ñ¾_Ù|U5Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*†Ôu}6ÞKÛÉxP¼’9¢ª¨«3UðÏçßçå×æÉÓtÒÐèP·ÀÄ»çÿ ™0þÇüeû*°/%yûÍW8ŽÙOï&`x¨ÿ 'ùäþT_ö\WâÊre¶ãÆfv}å)XyjßêÚ||köÜîîËoøŠý•ÍNL†gwk‡$ã*mv*ìUó¿åÍ¿Ô¼ë·hå¹O¹&_á›ŒÛÁÔaÚo¢3NíÝŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØªSç/¢ß¨êmg|m–cú‡½¯'Ò}Ïü€ššµÌ?Ín[þÐÆù°Õý?Kõ|íš·fìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|íçíRo:y‘l,ˆhÑÅ¼=)×÷’Ô~É~MËýõÃ7£áÇ{¨Ë/[=ûHÒ Òm"°µb…/ÑûGü¦ûMþVjg.#nÖ1á‹È²v*ìUØ«±Wb®Å\ÊQ…Aê*ù·óOÉ_á­K•ºÒÊæ¯~4þò/öü?ñ_Úå›œ8Ç›§Í€½{þpûó<é÷Ïäëçÿ F»&[jŸ³(¼Œ{Mòÿ ^?ø³2`b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ùþrËó•õ+Æò^“'ú³­²Ÿ·(ÿ tÆ8?oþ.ÿ ŒX«Äüƒä©üÕ| PVÚ*4Ò(þUÿ -ÿ gý“e9rmÅŒÌÓé]+J¶Ò­’ÊÉpÆ(ª?Ï©Í4¤dl»ˆÄDPEdY;v*ìUó½¤cçâ[bÚƒ¨ùJì«ÿ &nøÿ ÍulŸç>ˆÍ;·v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨mRqi4'pñºýàŒ”9†ä^ùi®N<mþNC›MWÓñuÚo©ï™©vŽÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«üÃóèâñŠúqxó„÷AÊ_ö~qI£4øbó_È_.z÷3ës¡”dÿ ;
Èßìcøç®fj§BœM,,ÛÛsXìŠ»v*ìUØ«±Wb®ÅXßæ–‡˜tiíVt¤?ë¨Ø³^Qÿ ³ËðO†M¡ÅÍ:6­>{¥fÜn-¤IcoCÍstéß¦~[×!×´Û]^Ûû«¸Reö¡¿U3Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»a_œ>}O#yjïY¨}8ï3ü1Àÿ xßäFØ«ó­VãSºâšæáýË31üY›4-õ“|±–´Ø´ø·p9HßÌçí·ËöSüŽ9¤Ë“ŒÛ¹ÅIÞTÚìUØ«±Wb¯ž<ÿ :é~v{³²Å=¼ßrÄí›Œ;ÁÔeÚo¡óNíÝŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»oP¹¾‚Ô¸‘#QÔ»ðÙ!X™ –?44ë¨Zÿ Èôÿ š²cBÀåz]sù¥å»}žùúªïÿ &ÑòcO>æ'<{Ð“~ryf1U¹göX¤ÿ Ñr_–“ÌÅ.—óãACEK—÷T_øÞTÉ~R^L55	?´aýÝ½Ñ>êƒþf6Kò‡½šÈÿ ç!-—û›oõ¥ú•ò_”ócù¿$?ý=zi¿ôñÿ ^0þOÍ›òSùÈiÙÓÔ|æ¯üÊ\?”èüÑîPùÈ;Ã^Q
»à0þPw£óG¹Aÿ ?õ2¤-­¸=‰æGÝÉp,GRƒª>L+Êm¸ò½á¿´T‘Ú6Œ‡©4?²Wö•s'$Å06ü¯ío´ŸðÕlÇü¬|Ûÿ 5/%§óó\?î›QþÁÿ ê®ÊÅ™’‘ü÷×‰Ù-Çûÿ ª˜-~fJ_ò¼|Ããü‹þÜ-üÄÿ +ÃÌ?Íü‹þÜ-üÄÿ +ÃÌ>0ÿ È¿íÇòÐ_ÌIßò¼|ÃüÐÿ È¿íÇòÐ_ÌIzþzy€uöþkÇòÑ_ÌÉU>uÐ7ŽØû”oú©åbŸÌÉxüý×X-?à$ÿ ªØ?+5üÌ›ŸÚßx-~„“þ«`ü¤|Óù©y#"ÿ œ‚¾ÞYÄß&aÿ 5d(;Ù~h÷"“þrþÖ_”ôÿ ™8?(;Óù³Ü¯üä,GûÝ=”“0o×d'æËó~I„_ŸÚ9½·¹SþHCúäLå{/ÍäTžÚ¦Œ·û´kÿ 2ä|‰ÒËÉÕGÍ1ó‡ËÖï‰ð1Kü#9¦›!¨Šaiùåë±Xï¡ë·ù;Ã"pLtf3DõLm¼Í¥Ý7{Ëy[Á%F?ð­8ä:C$OP™ÅGLÎíØìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Ã=üÇõ»è´XRØxÈãá_ö1q§üelÚiaBûÝf¦vk¹ê~Eòàòö‘‰”/9|Lñ=i×‡÷ê¢æiñJÜÜPá'ùKs±Wb®Å]Š»v*ìUØ«±WË˜zÑuË«D‹Ÿ4§@®=EQþ§.ìsyŠ\QÒåˆ}uÿ 8æÿ ÒþUm&F¬ÚdÅ)ÿ ÉûØ¿áýTÿ a–µ=Ûv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|yÿ 9çƒ{«Zù^ýÕ’zóþý~ìøÇüžÅ^qùåÁ¨ê©L+’‚+þüz„Ûü•æÿ ëðÌMLøc_ÎrôÐ¹_ó^ýš—hìUØ«±Wb®Å^ùõj"×"•G÷¶ÈI÷"ÄUsm¥7U©§»i—¢þÖÅû3F’“ ÿ Ç5sHvq6DäY;v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*…¾Õm4ñÊöxà¼Ž©ÿ #$ O ÄÈe"½üÎòå‘ã-ôlâ¾R¾e£ÏF£ž#ªEyùí ÀÅb[‰¼ äcÆÿ ð™hÒI¨ê¢‘Üÿ ÎB $[Ø^Å¦§ü(¿âyhÒw–³«î	4ÿ ŸºÃéAlªzU\‘ÿ %ÿ ÂåƒK6³ª’OqùÉæiMVåcñº3eƒOÑ¬ç‘ê”Üùÿ _¸bÏp	þIüeFX1DtI©Uî¯y}þõÏ$ßë»7üK& 	´"í4Ë«Ï÷–%ÿ Q¿â8	¤i‚ù+\o³§ÝPÿ Å/ÿ 4äNHŽ¡„B˜[~VùŽä–Nþr©øHËñ£ÞËÁ—r-?'|ÎÇ{P£ÞX¿ãYDê!ÞÏÀ—r:È­~AV0Gþ´‡þ4GÈþf)ü´‘ò u¿÷ý§üŸõG#ù¨ù²ü¬¼‘Î?jgûë¨ý^Mÿ TÁù¸÷þTù##ÿ œz›öïÔ|¢'þf.ÍŽäþT÷ªùÇGþH×ì›Éü¡ïoþ…ÜÕËþÿ ëþÎy'òžnÿ ¡wõqÿ §úÿ ç<¾Õü§šªÎ=Ãþì¿cþ¬@~¹ç<“ùO4TóúhûwSŸQü0~l÷'òƒ½Y taö®.OÉÌ¼›=Éü¨ï]ÿ *Dÿ Ýÿ ÁÇÿ TqüÙî_ÊŽ÷Ê‚Ðÿ ß÷ðqÿ Õ›=Á*;Ýÿ *Cÿ Ýÿ ÁÇÿ TqüÙîùQÞïùPZûþïþ?ú£‡óg¹*;Ü ´^ÓÝÁGÿ T±üÙî_ÊŽõ6ü€Òfæà|ÊøÓÍžä~Tw¡ŸþqòÈÓ…ä£Æ¨§úaüÙî_Êô1ÿ œx^Ú‰óÂ¿ó;ç<¾Ö?”óZßóû:~p×ì—æÇr?({Ð“Î>^(ýÕäLÊF_Ô_æÇr?*{ÐGò[í=§üŸõG%ù¨ù±ü¬¼×‘ZüB¨`ø,‡þ7DÉ~f,-$½¿'¼Î:YÔ{KýTÉD;ØøîA]þ[y†×w±”Óýö9ÿ É¾y1š'«ŠC¢_7”µˆG)lnPíÖ¹!0z°0#¢Tñ².>ù6-Å+ÄÜÑŠ°î1TÞ:kPPGr íë=>îTÈÑ˜™Sx?7<Í
·„üÑÆÇþ	“–Vp@ôlä:§VßŸZÜ`	"¶w%øY8ÿ ÂågKÌjdžZÿ ÎB©!nlÙ%¯ü#Gÿ åGIÜ[F¯¼'Ö_žšÃ”O ?´èÿ ’O#ÂåGK&Áª‹ Óÿ 1ü½ýÍô#þ2üŸåG‡FÑš'ª}kwÜbkgYc=`Ù.RbG6Ñ y*àdìUØ«±Wb®Å]Š»v*ìUØªUÔ¢Òí%¾¸4Šgo ÿ )¿g%ñc)p‹xåÎŸ7›|ÏúBîŒ±»\ËáZþí ÿ Œœ>÷Ú¶m³KÃ…êº¬Qã–ÿ Ö}šwnìUØ«±Wb®Å]Š»v*ìUØ«Çç 4J‹]]Œ~ù"ÿ ™¹±ÒK˜uú¨ò(¿ùÄo7þ…óèÙZêq4>ÜÓ÷ÐŸ¹dŒÆLØ8¸ñWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¨Ý]GkÏ1ãjY‰ìrlUù¡çŸ3Iæn÷\–µºä öZþí?ØGÅ1W¼þSh¢t9ŠKsû÷ÿ gýßü‘æŸQ>){¶ž<1÷³Ær]Š»v*ìUØ«Ç¿ç!m	[¥Uüý6Oøß6:CÌ:ýXäYçå¥ù¾òíŒÇ´^Ÿü‹&ù—˜¹ÅL¹8Ä2\¡½Ø«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¥Z§›4+½»†&QR…Ç?ù?xßBå‘Å)rg$G2ÅuÎÿ /Z0´·>ñÇAÿ %ŒYxÒÈ´LCÔç å#’«vid$À"§üœËÆu-'Tz5ùÕæ;£XåŽÜ,Q­?ä·ªßðÙpÓÄ4D‹¾ó~±|
\ÞÜHÕLÇþ¼rá 9£2y”Ÿv>$äØ'žNÖnÀh,®OíšŸðTã3™f O ŸZ~Mù–r9[¬J{¼‰ú‘ÿ ár£¨€êØ0HôNí? 5W#ë76ñ¯rœÜýÌ‘ÿ Ä²£«‹hÒÉ9´ÿ œz·V­Íóº÷	Sÿ Ï/üG+:¾àØ4å9¶ü‰Ðb!®%ögP?äœhr³«—“1¥Šmå/–a5`‘üÒHzd¢g«`ÓÄtM"òN‡l-vñ…	ûÙr³šG«1Š#¢ike¢„·"QÐ"…ð¹"Yˆ€¯‘dÖ*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WQC¸Â"’ÛŸ,iWMÎâÎÞFñx‘ü2äÆI¥ÇÑ)¼ü°òåÛr’Æ0È-û¡dÉŒóX={ßÈï/\Ä³@<#’¿òyfËªMgMš÷þqòÑÛýöH×ÂD~ôhrÑ«ïgIÜR;ÏùÇýMýRæ	ü¾H~åYGü6X5qk:Y$W“Þe¶&–ÂUÒD?ð¥–Oø\´j zµåÿ –uKçwi<+âñ²ø"´Ë„äZŒHæ‚âHI28èTÐä˜²;ó#Ì:y¬7Ò·´‡ÔtÂL¨â‰èÚ2ÈuegçÖ¯oE¼†…Hý*JÉ,¢ZXžMÃS!Í•éŸŸš\â—Öó[·ù%dQþË÷oÿ $ò‰iBßPêv™ù… ê_ï5ì5ðséŸø½69,ãš'«!»Œ¥¹Ø«±Wb®Å]Š»yWçÏ™MµœZ,&p}IGù
~þÎ_‹þyf~’Äàê§ü)ÇäÏ–Î‘£©…'½>©¯P!_øRÏ\¯S>)WóYé¡Q¿ç3ÜÄrÝŠ»v*ìUØ«±Wb®Å]Š»c¿˜z'é­êÕG)#ñäŸ¼P¿ëñáþË/Á.ŒÑâ‰|Ó ëhš…¶©li5¬©2¬Œâ9ºtïÓmV‡X±ƒRµ< º‰&Câ®¡×þ%Š£±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼·þrWÍ_áï$_²7¯Ú'üõøeÿ ’¶*øCËšIÕõ}<zòªà	øÏÐ¹K„[(ÇˆÓëDEB TPÐšmÞMâ—b®Å]Š»v*óÿ Ïsåó0ÿ y£üaýr®fiMJœMH¸¨~DjXÑÝZ	Øà¬Çü?©‡V=V)ôÓÑó	Ìv*ìUØ«±Wb®Å]Š»v*”koÒ4j‹û¨¢eêœªÿ ò)9Iÿ 	–Ç¥È5K,cÌ°_óëJ¶ªØC-ÓÔÒ4?&<äÿ ’Y“!<Üyj‡FªþzëWU[4ŠÑ{¼Ûþ
^Iÿ $³":XŽ{¸òÔÈòÙ‡ê¾oÕµPEíÜÒ)ê¥ÈOù¼Sþ2#A Ìže/²°¸¾“Ñ´‰æåE,~åÉL@¶M¦þTùŽüKF‰yHŽŸì‰á2™gˆêÚ0Èôe:wüãõóŸôë¸¢_ø­YÏü7¢2“«†”õdºä.êiçqÖ…QOû¬ÿ òS(:³Ð7(êÉ,?,¼»bÜ¢±üYY?áf.¹IÏ#Õ¸`ˆèŸÙiÖÖéÙÅ)á…rS*2'›hˆ‘NÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*€Ô<¿§j'•í¬3·Œ‘«ø&ÉŒ’‹ŒaŒê?“ž\¼RÝ cûQ;ÿ þ¤ð™xÔÈ4<KÔÿ çaj¶ŸxË¶Ë*ßþ2'§Où—GWÞ—¸±=KòOÌ6f°¤W+Ö±8Ûè›Ò?ð9‘LKL´òCSÐoô²ý¼°W§¨Œ ü¹lrñ y4‘Í~•æ=GI?î>æX5!…?4û-Œ¢%ÍDˆäÍ´ÏMjÐ|±]¥w$p¡¢¢öQ6cKMËg":™{³óÓF¼¢_$–nFäŽh=¹ÇûÏù#˜ÒÒÈrÝÉŽ¨{3½3Y²ÕSÕ°ž9Ðu1°jWù¸ýŸöY‹(órc1.HÌƒ7b­3˜€äžƒº8Ê_óÍ|A"¤ #n0§üoé¯üŒlÜÿ uQýìßFÅÄ¢8ÀTP ` èi‰·n.Å.Å]Š»v*ìUØ«±Wb®Å]Š»|«ç}ô±u§¨¢$„ ÿ !¿yü“eÍî9qDI’<$‡Ù_ó‰^oý9äõ°•«>™+@G~÷°Ÿøh×þ1eolÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾Rÿ œÜó(/¥ù}Ù]H>gÑ‡þ#qŠ¼‡ò+H7zÓÞ°<-bf·7ýÒ¦?Wþ15R¨×{•¦Êûžÿ š—jìUØ«±Wb®Å]Š¤¾tÓ?Jh×–”äÏ•,£œòQW-Å*-YEÄ‡”Î?j^ýÝé4K'ÓqÛè›þ3õq±n–[ÓÜsVìÝŠ»v*ìUØ«±V3¯~dhz%Væå^PîâøÚ¿Ëð|(ßñ‘“/Ž	K£D³F/?Öÿ ç ‰M"Ô(ìóšŸùøäkæ\tƒ©qeª= Ö¿0µÍh¼ºLŠCÁHÿ )#ãÏýŸ,ÊŽ(Çq¥–RæR{:çQ”CiÏ)ý”RÇþ,&šÀ¶_¤~My‡Pž$¶F¬Ìü"z’)ÿ Y1å¨ˆoŽžEši?óÖÉFÔîÞCO³
„¡ÿ ]ý^Cý‚f<µ}ÁÈŽ—¼³'ò¿ËÚe;D‘ÇíMY+ïÆNQö(¹-DVøàˆèÉmí¢¶ŒC,q¯EP %A$óo J˜ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å\Ê;ƒÔb"˜Þ­ùq j»ÜYÆ¯OµôÏü’áËý—,¾9å­2ÃÑƒkóÐ0-¥]²l“(`Oüd‡ùù“_xqå¥î,Zü¨ó”Iksqý¸>:ÿ °½ÿ ‚s*9ã.®,°Ê=´ØÊ$‰š)ÔJ°9w6®LÛAüç×tÊ%Ã­äB‚’ŠžÒ¯åþT¾¦cÏOy7ÇQ(ù½/Ëÿ Z.¦DWe¬¥?ïÍÒ¿äÊŸñ)<Ãž–C—©Ì†¦'Ÿ¥¿Í¿6Ga •³‘]ïÿ tŒ¬(¾u+^KÃ÷ó×>;–ÿ ÂºŒ•¿‰%ü†òÁ·¶›\˜QçýÔ_êYýœWþydõSþ½,?‰ë€ç»v*ìUØ«±Wb®Å]Š»v*ìUØ«Å¿?ô>Zêè6u0¹ð+WþZOù›-$¶§]ªŽöžÿ Îy»ôWš%Ñ¥jC©ÂTø¶*Ëü’õó=Á}±Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾ÿ œóéŸ=_ñ5ŽÓ…²ûpQêÉf—dz_Õô©ïˆ£\MÄ{¬cáÿ ‡’LÖjå¸ËK‰zv`¹®Å]Š»v*ìUØ«x«ç-„<æ°·ÃW&/ˆÿ ºäø#vÿ žR,™¹—ï!ðuôOâú34ÎÝØ«±Wb¨_^±Ñ¢õõÒ¡#™¡4þEûOþÁrq—&˜7šy‹óòÚÇ¢Àfn‚Iª«ôF¿õš,Í†“ùÎõ_ÍyŸ˜<ÿ ¬ëÕKÛ–ô›oM>§º'Úÿ žœ³2£AÃ–IKš[¤ùPÖÓÓ­äœŽ¼?Öo²¿ì²r6"$ògú'ä6©tê3Gh§ªÞ8úŒ_òW1eªˆå»“4=ž¢þMèmHšêAÞcQÿ "Ó‚Á«æ$µ2<¶r£¦ˆófV–pYÆ!µ"ŒtTPª?Ø®ÙŒdO7 DJØ;v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±T³YòÆ›­©MFÚ9ª)É‡Äù2-$Oö-–G$£ÈµË—0ó½òÖjÉ£Ü4¹ôåÖ¾ÇïÖõ³.¾ðâKKÜó?1þ_k_«ÞÛ±€»cø“æY»ÿ žœ36c.N$ñJ<ØÖZÔö!~rÚXZÁ¥jpz1D¢5š-×oÚ’?µÈý©9|_±˜tÆFÃ‹QÂ(½wLÕmuHEÕŒ©4-ûHj>Gù[ü–ø³_(˜ì\øÈK’+"ÉØ«±Wb®Å]Š»v*ìUØ«±Wb¬WóCDý/ \Ä "_Y=ŒSÝ£õý–d`—š3ÇŠ/ž|¥æ	|»«Zko%¤ÑÊWý—ÙÍË§~šX_E}oå»rŠdWFñV—ðÅQ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅT®.Þ6šCD@Y€§~`ù‡UmcRºÔäûWSÉ1ù»?ãlUô§åÖœ4ÿ /ØÀ;Â$?9?|äæi3Êä]ÎQ)nv*ìUØ«±Wb®Å]Š¼3óëB6Ú„¬b‹pœÿ —Fÿ ‘l¿ò/6šYX®çYªzÏ’õá¯i6Ú5‘Ð	:}µø$éþZòÿ W02Ã†D9Ø¥ÅN²¦Ô“ÌžsÒü¸…µ	•d¥V%ÞFðã¿ó·ÿ ËËaŠSäÕ<¢ÞKæÏKû²ÐèÑ‹XºzFÿ Ì´ÿ ‡ÿ _6ÒÏÔàÏRO-žosss©Îe™Þ{‰å‰fcÿ 9–8„Û5òçäÎµªÒK¥PÊ>#ò„|uÿ Œ¾žcÏQù¹ÓÊ^OMòÿ äÎ‰¥ÒK•7“
o/Ù¯ù0¯Ãÿ #=\Âž¦G—¥Ì†š#Ÿ©œAo¼k
±Æ¢Šª  ’£¦b“|Ü+’ü	v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¥Ú¯™4Ý&¿_¹Š¼]Àj“Ûoö+–G¥È5Ë 2ÄõÎß/ZšDòÜÿ Æ(Èÿ “ÞŽ^4²-SÇ®ÿ ç!aV"ÖÅ™{”/ü*¤Ÿñ<¸i;ËQÕ÷žãþrU'÷Öê?Ëßñ&4‘ó`uRòC·çÖºÝ"µ_’?ñ—%ùX±üÌ–§çÆ¼:Çl~hßÂL?•ŠþfJ«ùý­×â‚Ôõdó;"t±óHÕKÉoÿ 9	r£÷ö1±ÿ &B¿­dÈþPw²üÑîG[ÿ ÎBÂÍIìÅfø4qä“Í˜Õù&öÿ Ÿ¬ã¹Ž½IE ÀÈÍÿ :Iy3¨§¶_š~[¼<c½E?ñ`dðRª/ü6Ttóxž¬‚ÇV³Ô6SÅ8Ln¯ÿ ')0#˜n‘EdY;v*ìUØ«±Wb®ÅXw™¿*t]v²z_V¸?îÈhµ?åÇýÛ•ðóÿ /2a¨”¤ãOOy<—Í_“ú¶‰ÊkqõËa¿8ÇÄùq}¯øküÌ¹ŸQy83Á(±]^¾Ñ.Í„­£cÄìÉt?¯ù-—Ê"[˜ÈÇpõÿ '~y[Ýñµ×TA/OY~Áÿ ]~Ôìy¯ücÍ~M/X¹øõ=$õHfI‘e‰ƒÆàe5Œ¬:ŒÁ"œÐmv»v*ìUØ«±Wb®Å]Š»q ŠÁÅ_(y·D:&©s§Ÿ÷T„/ú‡ã‰¿ÙFË›èKˆ[£œxM>Ãÿ œxüâÑ?ÁÖ–šæ¡misdZÛŒò¬d¢o*ÈßgÒeOö6Fœ¾L&ƒZ°¯üÄGÿ 5b¨ë?Ì,ÞímªÙH|â2âxª{myÒó·‘d_`ÃþWÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»c~füÇòï–?ãµ¨[Û?ò;Žò)k'ü&*òÍ{þsÉö$­‚]_0èR1ŸöS²?ü’ÅX>¥ÿ 9Á1$iúB(ìeœŸøT‰âx«»ÿ œÓóKŸô{;þk#ÌåÅP_ô9^tÿ }Xÿ È—ÿ ªØª½¿üæ›ÐþöÞÁÇüc~©±TN«ÿ 9‘¬jºmÎ›>Ÿns‘z‘»‚¼Ô§0Î¼y>*ùã}9¥~fùnä,0]¤T 1€Ôå Xÿ á³O,îvÑÏöOkyâz¶Ò$±žŒŒÁ.c˜‘Í¼HJ¸;v*ìUØ«±Wb¬góËÌz<Ö‘ŠÜ%%‡ýuýŸùèœãÿ g—àŸš3CŠ/*ü óý·—¾±aª¹ŠÕÿ xÅ¯VoÞ/ùþ^gj0™î,x6*þnüð»¾åm¢)µ„Ôz­C!ÿ Wöbú9¿ò¾z`9îœš’ylóˆa»ÕîBF$¸º™½Ù˜ŸÚ9™°q7/Jò¯äUÝßõÉ>­_I(Òõ›xãÿ ’Ÿê®aäÕËw.byìõ/y3JòòÓN·TzPÈ~'>?¼o‹ýŠüäæòÊ|ÜèbŒy'YSk±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU-ÖüÉ§hqúÚ”éÀcñõ#Z»ÿ °\²Ì¹5Ë 7šëÿ Ÿ°ÇXôks!í$Û/üŠO‰‡üôOõs2Oç8“Õw<ïZüÉ×µŠ­ÅÓ¬dS„_»Z•éñåþÌ¶fGcÈ8’Ë)s,`šîzå­Mb«Ñž**OaŠ§6~I×oEmtë¹AþH$oøŠâ©´“¾qœrF¾¡ñ·qÿ \UQÿ %<ètkï¢?¨b©eÏåÇ™mEgÒ¯xµ´€Ä1T’êÊ{FôîchŸÁþCâ®Å]Š¶7qVE¥þakÚaÚöZ‚»sZ©/5T±F\ÃdrHr,»GüüÔíèšŒ\¨êÊLl}Éøãÿ ’k˜òÒÄòÙÈŽªC›8Ñÿ ;tê-ËIhôÞ-TŸò^/SþcÌiid9näGSÏfqe¨[_ÇëYÊ“GüÑ°aÿ ¹(˜órDä¯‘dìUØ«±Wb®ÅX—›ÿ ,´¯2ÖYÐ»?îèÀ©?ñbý™?âñfdcÎaæãäÀ$ðÿ 8þ\ê~Xró§«kÚd¯û?÷Ùÿ _í~Ç,ÙãÊ'É×dÄaÍ¯&þaê>V’7«hM^?	?Ì¿ï¶ÿ )~×íòÇ&!>hÇ”Ã“ß¼£ç;Íú–OÆexZœ×·OÚOò×þ¾ÕdÄaÍÚcÊ'Ée-ÎÅ]Š»v*ìUØ«ógæ&•åvß3´ì¡–4BI£—&ãUÿ ~eøð™î2fæóMkóöúbSK·Ž"œ¤«·ÍiÁý’É™±ÒÍÃ–¨žL?QüÉóù¬·Ò¯üb>˜ÿ ’"<È¢:4²=XõÅÄ—.ešI«1©?IËZ”qWb®ÅQV:Íƒú¶rÉÿ 4lTýëŠ³¯.þù×A*-µIåEý‰È™ióŸ›Àâ¯_ò‡üæ¼èV/3ië"w–ÐÑ¿äDÇ‰ÿ ‘ÉŠ¾€ò7æß–¼îƒô%âI5*a‚Qÿ <Ÿâÿ dœ“ü¬U˜â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb­ ß¦*ñ¿ÌÏùÊ-ù<µ‰ý)¨-G§Ÿø¶ãâ_ö1¬ŸåqÅ_2ùçþrKÍþl-Ö£W÷6µM¿Ë—ûçÿ ƒãþN*òédyX»’XîIêqU<UpšÎ*šÚùOX»¶²¹”ä…Ûþ"¸ª+þUç™?êÕ}ÿ HÒÿ Íª”þG×`›N»AþTø×J®-&¶<gFŒø0#õâª«±TMôöN&µ‘â”†F*GÒ¸´ƒLãË_›>d‚Xí¾¼\ñXä^LI;RDã+7úÌù<?Ñr!žCÍô$C™€Y
ŽAM@4ø¸µ’×üœÔ'j<×àK±Wb®Å]Š¼ãÏ?œ–z?+='ÕàØ·XÐû•þñÿ ÉO‡ùŸö37˜Ëy8yu l}w%õÃÜË¼²¹v âcÈì3f:Òmè^Nü–¿ÕxÜêÕ³¶4!Hýëõ?Ý_ëIñÅm˜¹5";S“NeÏg´y{ÊÚw—âôtèV=€gêíOçüMÿ þ\ÖÏ!Ÿ7cb“\­±Ø«±Wb®Å]Š»v*ìUk?™JÜ]£H+ðEYÝ¥È!ÿ Œ…2øà”º4K4cÕ„êÿ ó6éUÓ-CMžf
ÿ Œqúœ‡üôLÉŽ“¼¸òÕw#¨~wyŠå¹A$VÀvŽ0kÿ #ýoø×2š! ê$RkïÌŸ0Þï-ôËÿ Ï§ÿ &}<°bˆèÖrÈõKn<Ïª\m=åÄƒü©]¿âM“‡(s)Ü»}ç"×%ÜÑš«°>ÄãKhø|Ù«Á´7×(?É™Çêl ôH‘S[Í1ÙŠG{#ø°,Ÿòu_+8bz6ÒYùñ­[€·QÁpRT«¥§ÿ $ò£¥‰m™W¥þiÓ:…´¶çÅ}?Ý7ü
6Q-!è[£ªC7Ñ|ï£kD%…Üo!4O?(äàíô.bË£Ì91Ër)ÞTÚìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØª[¯yŽÃAƒë:”Ë
v®ìÇÁ|OþÇ,†3>Ms˜7y·óÎîó•¾ˆŸV„íê½‡ä»¤ðíü¬¹°Ç¥žîMI<¶yíì÷ÒµÍÓ´²¹«3I>ç3 §›QDi*Š±Ø…KòüãŸœüÐX,­»»n¤)þ£~ý¿ØÅŠ½ŸËó„¶‘ÒO0êRH{Çlü—Ôåÿ "“z–ƒÿ 8ßämšj\?ó\––¿ì$>Ÿü&*Ï4Ï.éºR„Óí`·QÐE§üAWLqWb®Å]Š¡î¬`»_Nâ5•OgPÃþaúçä—“u°~¹¤Ûrn­zMÿ ¦Ø«Í<Ëÿ 8cå«à_G¹¹°ôDÉÿ ü%ÿ ’ø«ÇüÝÿ 8æý”ºo¥©Â?ß-Áéï¼àRI1WŽêú-ö;ZjVò[N½RT(Ãý‹ŒUŠ»v*‹Óõ+:Q=œ¯££FÅOÞ¸¾i¹=Ëÿ žZ­ê*·±xš$”ÿ Yø$fÿ /1g¦‰åéra©çêz—–¿3´]|ˆá›Ñœÿ º¦¢·ûöý‹òÿ '0g‚Qsaž2eyŽä;v*ìUØªÙbI‘¢•C£XTz«ÔaE¼“ÏŸ’©({ï/2ukrh§mýû?ñþåeûŸ‹SÒ_éœºn±ù<ŽÞæóD»ÂÏouàÊFÌ¬§þ"Ùž@p1/xüºüÕƒÌ!lu°ê6Y?ÔþY?â¿øäMfm?ãévXsñly½0Ü·b®Å]Š»v*óŸÎß+þ’ÒÆ§
Ö{=ÚLgíöý·þ¯©™ºYÑ®÷SÜù÷6Ž±ž~Y~Nk_˜ÆeÑ [qõ²qãÏ—ÅD’ð7ìb¯_Óç5¡Ô5h"ñBÒ~.ðb¬’Ûþp‹GQþ‘ª\¹ÿ "4_ø—©Š¢üá/—)¶¡{_ùçÿ TñTçüá˜ÀýWVnp«ÄZ,U‰ëó„úì ¶™¨Û\‘ÐH¯?w®1W›yŸþq÷Î¾[%Ö›$°¯û²Þ“->Qruÿ f‹Š¼öXš&(à«)¡¨ÅWÛ\Ëi"ÍåCUe4 åaŠ½ûò§þr×UÐ™4ÿ 5òÔ,v¿û¾1îz\õÿ yÿ ~Î*úçË>iÓ¼Ïdš¦:\ÚÉÑô=ÕÇÚG_ÚFø±TÛv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±T›Í~lÓ|©a&­¬Ì°ZÄ7cÔŸÙD_µ$û(¸«âßÎ/ùÉ}_Îìúv–_OÑÎÆ54–Qÿ //ìÿ Å)ð?©Š¼[d^Qò¹ç	þ­¡ZKtãíUÿ Œ’µ#ý“b¯}òwüáUÔÁeó=ø„Ì6£“}3Ëð)ùE&*ö/.ÿ Î3ùE¡]<]H?néšZÿ Ï6ýÏü’Å^¦ygKÒ”&Ÿi²ŽÑD‰ÿ \U3Å]Š»P¹³†äqž5‘|CølUŒjÿ ”žSÕêot›7cûBVÿ ƒ‹ÿ Ãb¯™ç&ÿ .ü‘ä{xaÑ xu{¦ä±¬¬È‘·#¤¾¡øÁÄ¿¶ßî¼Uóž*ö¿É$zIþ ¼_‰ª¶àøtyÙ}„ÿ gþNkõ9„9úlÄ^»šç`ìUØ«±T=þ¡o§@÷w’,PF*ÎÆ€óéüÙ(ÄÈÐc)‹/	üÀüÞ¸ÖùXéDÁbAVn =y¾ãÿ #ö¿où3i‹N!¹úf\æ[¥ˆù[Ê7þe¸ú¶žœ€ûnvDÌíú—í6_9ˆ-™ ÷¯$~WéþXpßéÀo+
¯ûé7áþ¿÷Ÿå*·ÕåÎg· ìñà÷³,Ær]Š»v*ìUØ«±Wb©˜|ï¤y|¨\*Éþû_‰úWû´«-™ø¯ùYl0Ê\š§–1æóMóöW&=Ü"ôO¹ÿ ‘Hh¿ò2Oõs6AÕÃž¨ôyÖ¹ç=_]'ô…Ì’!5àÿ ‘IÆ?ø\ËŽ1AÄ”Ì¹¤ycÀ$ÐuÅYf…ùOæ½v‡NÒ®åCÑý&Tÿ ‘’pþg_üâgž¯€imàµ¯ûúuÿ ™>¶*Él¿ç
<Ç îþÊ#àž£ÿ Ì¸ñTÅç5>-^ò…üÌÅZùÂHƒV€ŸxXÆíŠ¥Wÿ ó…~hˆVÒòÆofiÿ É§ÿ ‰b¬cUÿ œVóæž%š\Þÿ ÂÈÑ·ü.*Á5ßË¿1h5:¦un«Õž&ãÿ #8ðÿ †ÅXæ*Ø4ÜuÅYG—¿2µ½‹opd„l"—ãZËËâAÿ Ý2™áŒ¹¶Ã,£Éê[üöÓîÀ‹XŒÚIÐºÕãü?xŸêñ“ý|Âž”¥Í†¨oI³½‚ö!qk"Ktt`ÊÙ.Ù„bG7,HJØ;v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯1óÏç=¾˜Mž‰Ææze­cCþM?½?òOþ2|K™Ø´×¼œ,ºšÚ/Õõ›½^sw+M3~ÓŸä¯e_õsc°uæDîTì4ûBt´³çžCÅ5,Ì|Wâl“Ð—_ó‡š¾®ïÍþŽ·;ú)GœsýÔ?ì½Vÿ ŠñWÒ¾GüòÇ’•Nd‹8ÿ wÉñÊç«ýŸùçÁÉÅY®*ìUØ«±Wb®Å]Š»v*ìUØ«±T£Ì>TÒüÉ´Öma»‡ùe@Ôÿ TõVÿ )qWÏ¿˜_ó†v7Aîü¡pm¥Üý^r^3þJMýììýlUó?œ|ƒ­ù6çêzõ¬–ÒoÄ‘T`?j)W÷rõ[c˜«7ò¯œt“ÆÃÍö}cÐOî®¢)2|7
¿ï«¯Sü‡LUèw¿óŒƒÌ#[ü»Ô¢Õ,Ïû¦jG2Ÿ÷Ûîý_øËõ|Uã~aòÆ§åË“e¬[Kip?fU*~küëþR|8ª}åOÍM_Ëåbçõ›Q·¥.ôñ[ý¸éü«û¿ò2Œ˜#6øf”Ñäÿ ÌÍ/ÌÔŠ&ô.Ïû¦B*ãtÃÿ Åy­É€ÃÍØcÎ&Ë3Èv*ìUØ«±VçßËk?4ÆÓ%!¿á–›5>ÊMO´¿å}´ÿ +ìfN,æ—ŸõŸ=kzæ‡tÖwÑ˜¦SÓ±ÿ )}¥?Ì¹¶Œ„…‡W(˜š/_ü²üÚú÷+[zN6ŽsûäËÿ ÅŸ·ûÄøôýbçaÏÒOWÍ{žìUØ«±Wb«&…'FŠU‚¬¤Tve#ÀáE¾WóŸ–ßËº¤úsT¢5cc½Q¾(Éÿ +Úÿ +7˜çÆ-Òä‡	¦]ÿ 8ÿ ùˆ|æ›{©ÛÉú½Ízps´ŸóÆN©Ï,k~„ƒ]Æ*ìUØ«±Wb®ÅX¿)¼·çD+­YG$¤m2Žùì”ö-É?ÉÅ_0~hÎ"êÚ¾¡åwmJÑjL,)p£ü¿ÇûÅx«çù¡x\Ç *êH ŠF*Ëÿ ,ÿ 4õËÝ@_é/X˜Z'Ó•|Ÿù$_?à±WÞ–ÿ ™_æ–š¶’ûì²ÄÇã‰ÿ ßrÆöd\U–â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØªEç?8iþOÓ&Öui=+hGû&cö"jGýŸù§|	ù±ù·ª~cj&òùŒv±’-íÔü©ÿ ‰Èß·/üE>U…ZÛKu"Á´’9
ª ’Iý•QÔâ¯¨?'ÿ çL«­çz¨Ù’É	òõ"ôÿ Œ1³“ö1WÔNg£Û¥–vöÑŠ,q(UBâ¨ÜUØ«±Wb®Å]Š»IüÙæ{?+éw:Ö¤ü-­P»xŸåEÿ .Gâ‰þSb¯Îo>yÖóÎšÅÎ¹¨šË;|+]‘÷q'ù(Ÿü6*¯ùyä÷ó>¤–ìµŽ3¨µû#ü©>Âÿ /ÛýŒ§.Nm¸±ñš}9)
,Q(HÐU€²¨4¤Û¹—`K±Wb©v¿æ=Ñïïß„K°vcû)þÓ·üÜßN34NbËç;yþÿ ÍS9ôíU‰Ž;/cûr—ÿ Åsq€ÙÔäÊgÍ3ü¿ü­ºó1[Ë’`Ó«»þÓÓí,#þÔo…•þÎC.q¿‰–,&Õ}¤höš=ºÚXD°Â½”u?ÌÇ«7ùMš©LÈÙv‘ˆˆ ŒÈ3v*ìUØ«±Wb®ÅX_š6´m
±#ýnäºâ €Ë—ì/ûoþFecÓÊ_Ñq§¨Œ|ÞIæ_ÍíoY&8¤ú¤ö!$•/÷Ÿð<üŒÏ†ÅÁžyIƒ“]Ï\Èq×"3°U' Å^©äoùÆŸ7ù¬,ßVú…«Pú·uJò!£Lßð?ÊÅ^ñåùÃ?/iÀI¯\M¨ËÝú1ÿ Â7ü–Å^ÅåÏËŸ.ùhÐú}µ³ÛHÇ?ùÕÿ Áb¬v*ìUØ«±Wb®ÅZ C¸8«ó7å•<Ìô¦™o$ÖE^ÈØxIÿ Š¼kÎó…zmÏ)|µ|ö¯ÔEp=Dù	Œ©þËÕÅ^çŸÈ¯6y,4º•›=ªõ¸·ýätñf_Ž?ùì‘â¯>ÅSmÌÚ†ƒ/¯¦LÐ·í j­þº7Àÿ ì—áýœ„ %ÍœfcÉìþOüë²ÔÙmuu—`õýÙ>äïû/ƒü¼×äÒ‘¼\üzv/JV)¨" Žã0\ÆñK±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨}CP·Ó {»É(#gc@ùôµ’ŒL2ˆ²ðOÌ/Í›|›-0´ƒÙäÿ ^Ÿf?ø¯þü®Ÿ©ÕåÎg°ú^u™N3Öÿ (ÿ çuÏ?²ÞÊŽMMÄ‹»ùvoSþ2|1•û8«ìoË¿Ê_/ùÜE£[9{‡£Jÿ ëIû+þBpüœU™â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±T·]òý†¿jö¬ÜÛ?ÚI£çþ·ùKŠ¾ZüÛÿ œCžÈ>§ä¢ÓÂ7k75uòï/û·þ1ÉûÏòälUóMÕ¤¶’´ÑÊ„«+#öYN*È|ƒù‡¬yP–‰7¦æ‚D;¤‹ü’ÇûKÿ Ÿ°ËŠ¾Ñòæ'•¿;4£e¨ÛD×HµžÎp©ÿ ~Àÿ hÇÿ ÇÂDý¾«Ì3?çÅ÷Ésçê—øAqÿ Mÿ #±WÌÚÞ… ]µ†©–×QŸ‰aýŸÊØ«;òWçMæ–V×Xåuj:?YWý“$_gø¿ËýŒÄË§Ül\¼zƒŽïoÒu‹M^wa*ÍmÉOCü¬:«’ßjåEØÆBBÂ3"ÍØ«±Wb©œ<›eæ›_«^2-Lr¯ÚCíüÊm?kýn-—bÊ`Zrc›|Íå›Ï-^áG²ý–_ÙtoøŽn!11aÔÎ&‹Õ*?4ÑMWoÞRÊ{ÿ Åoïü­˜9ðspgè^·š÷=Ø«±Wb®Å^[ùïå¯­XÇ¬Âµ’Øð÷ôØü'ý„¿³ÿ òÌí,èð¸:¨XâxNlÝsïïùÆïÌ/ñ—•aúÃò¾°¥´õêxÜËÿ ="ý¯÷âÉŠ½[v*ìUØ«±Wb®Å^=ùÛÿ 8ñ¦ùþ¿°	g­¨¨˜
,´ý‹¿ð³}´ÿ -~Uðþ¿åûï/ßK¥ê‘4P7GƒüU¾Ò²ý¥ø±Tûò¿ó+Qü¾ÕãÕ´ö¬f‹<$ü2Ç_‰ßýöÿ °ø«ô'Ê>j±ó^™µ¥¸’Úáy)îí#ÙxÛà|U:Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUFââ;xÚi˜$h31  LÇåŠ¾üþüã—óX)lÌº5¡)oNG£\ºÿ <Ÿ±ü‘|?ïÎJ¼ÒÂÂ}Bâ;KDig™‚"(«31âª£Äâ¯¸!?ç-<‡nš®ª«>¹"îÇu€÷T?åÿ ¿&ÿ bŸÛUí8«±Wb®Å]Š»v*ìUØ«ãOùË_Í¯Óš—øKM’¶6[†S´“ÿ ¾ÿ Õ¶û?ñ—Ÿò.*ùòÚÚK™VT´Žhª:“Š¾œü¾òzy_MKbº’;€7nÉ_åˆ|+þÉÿ o4¹²q—q‡ dÙC{±Wb©o˜¼Åiåû7¿¿n1®À¬Ý‘voóørÈ@ÌÐkœÄ—Í~sóßšnÍÍÉãÔE; ÿ ¿i¿ký^9¸ÇŒ@Pu2›,ÓòÏò˜êa5]e
Úš4qŒƒ³¿òÄßðÿ êqÌ|úŽ‡7#-Ï'¸EB‹JUQ@ Ø*ÐÕ“nÈ
]Š]Š»v*ìUØ«ó‡æ^—å€b•½{¿÷ÌdTÆVéÿ ‡ÿ ŠÛ21à3qògx§šÿ 4u0Ö'«ÚŸ÷TU ø±¾ÔŸñò3e`ë§šSaÙ{K±WµþXÎ-y‡ÍÜ/uAú/NjÒ)õ\ÅPlGúòðÿ 'ž*ú«òûò?ËFU}2ÔIv:ÜÍG–¿äµ8Åÿ <R<UŸâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*Ñ ŠÁÅ^Sù‰ÿ 8Ûå_9‡¸ýBý·õí€ZŸø¶î¤ÿ „“þ,Å_(~gÎ>ùÈ%®g‹ëzp;\À	P?âäûp²ýßüYŠ¼Çf~IüÎÔ<°D?ïEûå)½yDô>™ÿ „ÿ '—Å”eÂ&ß1ƒßü·æ›1[ýgN8ä‡gBfDýŸø‹~Ë6jgŒÀîí!Ll›emŽÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨=_W¶ÑížöõÄpÆ7?©T~Ó7ì®J124JB"Ëç?>þ`]y®jÅdû¸«ÿ ÿ Ìÿ ñÜbÄ N\¦eŠÛ[Éu"Ã—•ÈUU$‚ªŒ½¥õ‡ä‡üâœV¢=oÎÑ‰e4h¬Nê¿å];ÅcýùÏìª¯¦â‰bPˆ P  
 *¿v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUåœ?Z?æ$MsAi«ªÑ.T}ª}”¸O÷j•ýâÂâ¯ˆ|ëä]WÉZƒéZÜ&)—u#uuí$OûiþmÅ±T¿C×¯t+Èõ2g·º…ª’!¡çûKö[}Íùùñiù‹kõ;Î0kp-eˆl²(ÿ wÁíþüý×þ¦*Í<õùo¢yæÓêZíºÊ÷r†HÏŒRý¥ÿ Wì7í«b¯¿8¿ç5Ÿ"Ô,¿ÑÆæd_Ž1ÿ /³ÿ S÷ñ‹ìâ¯7ò·›/üµsõ=é_¶º8þW_øí/ìås€˜¢Î16Cy#óÇÍp“î®VHXîó¡ÿ vGþWìþß‡59p˜{®,Â~öO”7»v*ìU"ó‡“ìüÓflîÇZ˜¥âFñÌ­ûiûëpu·SmY1‰‡Í^còíç—¯ÆùxÈ»‚>ËÙxÛºŸùµ¾,ÜÂbBÃ¨”LM²~Rþe]Fª5ow!ÿ v(ý—ÿ ‹Sù¿Ý‹þZüzýFõ?kô—§fšìUØ«±Uë(¯ ’ÒàrŠddqâ¬8¶š6ÆBÅ>Qó‡.…¨M§Oö¡zâ:£õ×âÍô%Ä-ÒJ<&žÿ 8»ù…þóTv—ÆËTÞJô_ôi?ägîÿ Õ•²L_yb®Å]Š»v*ìUØ«±Wÿ ÎA~HÁùƒ¦›Û	­Ú)0°ÛÔQ¹¶“çþêo÷\Ÿä<˜«àû›y-dh&R’!*ÊÂ„ÕN*÷OùÅOÍ–òÎ°<¹¨=4ÝIÀJ£œü1¿ú³ÿ rÿ óËùqWÛX«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUóüåïæ‘Ò4èü£§½.o×Éu„†?ú8uÿ ‘Q²ÿ »1WÇ8«ìùÄïÉ…Ó-ÎšºVîåÐÑ‡Øˆÿ »ÿ ã$ÿ ±ü°ÿ Æ\Uôž*ìUØ«±Wb®Å]Š»v*óOÏÏÍü¿òô—0°ý%uXmW¸r>)¿Õ~/õý5ý¬Uù÷4Ï3™$%‰$“RIÅ^­ù%ä‘u/éûÅ¬Q ïûRÿ Ï/Øÿ /âûI˜:œ´8C›¦Çgˆ½·5ŽÉØ«±T&¯«[é²_^7bcüÅ›örQ‰‘ ÆR_3ùãÎ—^j¼7ü0FHŠ vU¯oÛø×7Xñˆ
Ÿ&C3ešþU~VÂšÎ°Ÿèâ,>ßüY ÿ }*»?kàø_>~ƒ‘ƒî^ÝšÇdìUØ«±Wb®ÅPZÆµg£Ànõ	V†ÕcÔÿ *Ž®ßä®N024Jb"ËÄ|ëùÑyªk£òµµ=_¤­þÉIô—ýO‹ü¿ØÍ–-0Žçrë²j¶<ÌšîzæcˆÖ*É¼‹ù}¬yâøiºY¹Ù#_çšNˆ¿ðÍû±WÙ¿”óš‘•/¯Bê¸ßÖuø#?òïû?ñ‘¿yþ§ÙÅ^ÃŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¬’1 *À ‚¨ â¯Ÿ¿7ÿ çôß0	5O*p°ÔY é‡ü‘ÿ ïþ§î¿â¿ÛÅ_!ù‡Ë—þ^¼};Ví®£?r
ŸùKü®¿~Î*ÖƒæÝ
åotùrŽ½ÃèëûJ—#(‰
,£#aôG0í|×¡½AûÈ«ÿ %"þhÿ á“ì·ì»ê3a0þ«µÅ˜OúÌ·1Ü‡b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUBþþ>	.îÜGJYØô Ÿû,”bdh1”„E—Íÿ ˜^ŸÍw4NQÙFuzÿ Å’Åÿ 	öÊÍÆ,BÔeÊfXÖ—¥Üê·1ØØÆÓ\ÌÁ#Y˜ô eí/·?!ç­<‰êúÂ¥ÆºâµûI ?±Œ¿ïÉ¿ØGðòõ{f*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅXŸæ/å¶“çí5´½^:õ1J z‘?óÄßñ%ûûX«àŸÌßË-Sò÷Tm/T^HÕhfQðJŸÎž?Ý‘ý¨Ûý‹2¬wFÖnôK¸µ-:V†êŠhTŒU÷·ägç5¯æF—Y8Å«[(0‡´ñÅRÉ7ø?•W¥º,ŠU€*E;‚*ùóÓþq^;±&»ä˜ÂK»Kd½Åí‘¿â±þúáöWË6—wz-Øžh. b<X2²ÿ Â²à"ö)· .?2¡óDU¹¤ZŠ-YGGöãÿ Óöâ:œØ87K´Ã›cõ3ŒÅrŠ»v*Æ<ÿ äx|×b`$GuÅ‡±þGïé¿í/Ûýž9~¼É£..1æù¶æÚóC¼1J¸±¡VXÂ¶n¤ƒú'ò×ÏIæ›ß/  L R¿Ë*åÚþWþ_ƒ59ñpè»\9xÇô™†c9Å]Š»xÿ ç×–*°ë°(øu1wþåÿ âHÍÿ ×6:Iÿ ¯ÕCøž4ŽÑ°e4a¸#6ôWòKÏÃÏ>W´Õ]«t«èÜxú±ü.ßóÓá›þzb¬óv*ìUØ«±Wb®Å]Š¾>ÿ œ¾üª]êyÃNJ[Þ7 £ešŸ¿óÝ~×üZœ¿Ý¸«æôvBMèqWèwäGæóß•íµ›•ì_¸¹ñõþz§	Ùâ¯CÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*…ÔoáÓ­¥½º`À$Œ{*Žnßð8«ókóÎWr×nõÛªÖæBQOì øaý„\Wd‘—Ï¾fƒO”cïîüV„~ïþ{?ÿ ÙrýœUúI
ãQ@ @ íŠªb®Å]Š»v*ìUØ«±U)æH¥•‚¢ÌI  u'~{þzþgIùæoc'ô|†ÕÈSýí?šfýçü~Æ*Ãü¯åùüÁ¨C§[ìdo‰¿•GÛö+û?µörŸ²Îâ4Tišle´vVŠ”*à?ãfûMþVhå.#eÝF<"‚'"ÉØ«RH±©w!UA$“@ êIÄA4ùËóCÏíæk¿«Ú¹ýøNmÞVãò'òó|Ü`ÅÀ?¤êseã?ÑG~U~[~a©êþãâ;)ÿ v¸ýøÄ§ûÏæûÏÂ9óp
S,x÷?KßÕB€ª(ÀÔ»VñWb®Å]Š»aÞ{üÌ±ò²“ß‘ðÄÙ¯F™¿`~×¶ÿ êüy“‹žÿ ÂãeÎ!·ñ<Ìžh¿óÁºÔ$.eEB þXÓöãoÚÍ¬ "(:ÉLÈÙIòlŠ½Oò_ò#SüÇ¸[]6¤·}¯íÇû²_ù'íÿ ¾ÙWÜ~OòV•äí=4½‚Ý74Ý˜ÿ ¿%µ#â©ö*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Vù›ùM£~aÙ}SUŒè£p€z‘Ÿò[ö“ù¢o…¿Öø±WÂŸ™ß•z¿åæ l5TåTÃp¿ÝÊ£ºÿ +Û¾4ÿ W‹²¬WOÔ.4ù–êÑÚ)£ «)¡üÿ gÍ ×'Ñ_—˜±y¦FzG‚ê:0ÿ ~'ül¹¨Í‡ƒqô»\9¸ö?S4Ìg%Ø«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼óoóëW'K°`l mÙO÷Ž?k—ò'ìÁÿ /¶Ÿ³õ:¬ùx¥ç–öò\H°Â¥är¨$œËq_oÿ Î:þCEäkUÖµ„®\/N¾‚0þéâÖÿ w?üòO‡—¨«ÛñWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«üÄü¼Ó<û¥I£êËUoŠ9 øâÙ–3ÿ þÚü/Š¿??0ü¨ùV—EÕãMã}™ý‰Sü–ÿ …nIû8ªÉs¿òn«µ¥·á;Ùu?n)<REøæìUúù{ç«<hðëziýÜ¢Ž„üQ¸þòÿ )á—ãý¬U“b¯ÿ œƒÿ œu‡Îq¾¿ "Å­ «  [€?›ùn?ßrþß÷rþËÆ«ãnôkÏÛ·»¶’†»2:ÁÌ­€‹H4ú+òçÏÑyª×Œ”Kè@õPwïÔÿ %¿áàsQ›þ‹µÃ—ŒI˜f3’ìUØ«±W~mþ_rÜê–þŸü@»~ÏüdOØþo±ü™›§ÍÂxO'Q‹‹pñO,ùŠçË·É¨Zš:0=n6öoø\ØÎ"B‹¯„ŒM‡Ô:µo­ÙE¨ÙšÅ*ÔxƒûHßå#|-šIÀÄÑw0°È3v*ìU®ik3i×ÝÎ…O±ý–ù£|k“„¸M°œx…>OÔl%Óî$´œq’hØx4lÞƒ{ºB+g¼Î~`^“Ëw-KmMkz	Ðr_ù4ÿ ]bÂ‡ÙÒÌ‘R0UÉ b©{ù§ICÅ¯-Áð2§üÕŠ£-o »^vÒ$‹âŒÂâ¨ŒUØ«±Wb®ÅXÿ žü£oæýïB»§§uPÇöX|QIÿ <åU|Uù¯ªé³éwSX])IíÝ£‘OfSÁÇü*÷ùÃŸ;+Ì3y~f¤”d 'oZ!ÌÁEêÿ Âb¯´qWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ñ?ùËO9Ê§ÂÜgÕ%
uôÇï'?r¬Mÿ qWÂø«íÿ ùÄo"ËZiuª¿©SÔB„¤ý—ï%ÿ ž‹Š½×v*ìUØ«±Wb®Å]Š»|ùÿ 9qù¡úHW°z^êKYˆ;¥¸<Oý$7îÿ ãÍŠ¾.Å_AþLy;ôFŸúRáiux ŠõXþÒÈÏïþyæ«S“ˆÐèìôØè_{ÑsÌv*ìUä?^|1)òõƒ|Mþô°ìªÁþËíIÿ þü\Øé±ÿ 5×êrÿ y÷|™7šoÖÜUmcø¦qû+üªßûð³™Yrpqqcã4úbÂÆ#´µA1(TQÐšYHÈÙw(+àdìUØ«±Wb¯+üËüÜw-3C`×=$˜nü˜û4Ÿå}”ÿ _û¼ü:{ÞNmEmÙÙ_k×«mnu{pôUgv?‹Ù:æqæï'Yþ]Z?S)wæYÔ3Ä¤4VhÃa'i¯d_ùån¿ÆÞ“â¯7Å^Ëùù	qù…r5-H4:-Ga³JÃýÓ·ûö_Ùÿ _}Ç¥éVºM´v6¬6Ð¨HãAEP<1Tf*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅR/8ù3Ló†.‘¬Ä%¶”|™[öd‰ÿ bDÿ ?‡|ù½ùE¨þ[êFÒî²ØÍV¶¸Àý–þISýØŸñ«b¬+LÔî4»„¼³sñš«Çþ6\^Å Öáô§åÿ ž!ó]­@—QQfŒtùÓþ+Ùþ_±þSi³bà>Nß^1æÊ2†÷b®Å]Š»v*ìUØ«±Wb®Å]Š¼Ûó›Ï¢,ÿ DZ0úÕÒžduHÂÙIöÕçþFfé±Yâ.£-ðÚ:ÇÕÿ óŠ’^š§õ¸þ&è10è?å­¾ñïÿ #ßx«ê\UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Î¿;¿)-1ôf¶¢¦¥nÚÌ{7ûéÏûêo²ÿ ËðÉû«óóSÒît»™l/ch® vŽDaB¬§‹)Å^£ÿ 8çùºÞAÖ„þâ/Š¥Àì‡ý×sÿ <ÿ Ý¿ñW/òqWÞˆáÀe ©t¦*¿|÷ÿ 9/ùžf‚O4ù~:jÐ­g‰÷èÚ ÇÌkÿ #SàûJ˜«äZ¹Ño#¿³n3DÕã£+’Ëð¶FQYFF&Ãéï)y¢ßÌ¶	¨[|5ÙÐõGi?æ–ý¥Í.LfÆ<œbÓœ©µØ«±Wb¯üäò(Ñ®¿KY([;–£(ý‰XíÙ$ûIþÍ~á›m>^!G›ªÔbá69)þNùÜè×¿£.Ûý
è€	;$¾Rvÿ ìì¦:Œ\BÇ0¸2pš<‹èÔ»Wb®Å]Š¼3óÛÊÿ U½Z„~îäp“ÙÔ|-þÎ?ù7›M,ìWs¬ÔÂ÷¼ÒÂú{	ÒîÑÚ)á`èèHee<•Ôø®f¸jú¯˜ua½MJêk§ëY¤g?ðå±T»Eéú•Î(žÊg‚QÑ£b¤²]ñW°~]ÿ ÎTùŸË.êÒVÀf?½þ+¹û|¿ã7«Š¾Áòæ&‘ç½9uM^iö^6Ùãoä•?güŸØØlU”b®Å]Š»|9ÿ 9oäÑ¡ù¸êP­ Õ"mÓÔ_ÝN?äoøËŠ¼—Êšô¾^Õm5‹ï-&I‡¿åÇý—ÙÅ_¦¶±_ÛÇwåÈ²!ñV—ðÅQ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ø¯þs/ÌçQó<:Ç§ÛŠ	%ýãÿ É!*ðýH—Z¿¶Ó-ÿ ¾º•!Oõ‚ø–*ý7Ñ´¸t‹(4ëQÆhÒ$ä¢„\UŠ»v*ìUk0PI4rN*ù×óKþròÃC™ôß*Ä—÷JµÃ“èƒÿ „øçÿ [”qÿ +IŠ¼#Yÿ œ–óÞ¨åŽ¤Öêz$ˆÈ…õ?àŸI×ó¿Î¨j5›ÊûÊÇõâ©æ“ÿ 9;çÝ9ý"gAû3EþË‚Éÿ Š°Ÿ;yÏPóž©6µ«0k™¨EGD_ÙP¸ªaùiåñ.ª‘J	µ†’L|@?óÐü?êóÊsdàÝ‹§Ó  (64ŽåØ«±V=ç¿6Çå5ïMíðB§öœ¿Ø§ÛoøÚË°ãã4Ó—' |Í]k7W”×WßrÎÇ¯û&ÍÖÀ:~eô×‘ü£•ôä³Œ3Q¦qûNFô¯ì/ÙOù©›4¹rq›w±ð
dKs±Wb®Å]Š¼_óGó`ÎdÑ´GýÖë4àý¯æŽüŸÍ'û³ö?wñI²Á‚·“®Ížö>òw“5O8êQé:4&k™OòªþÔ’¿ì"þÓÆÙžà¾¥½Ñt/ùÇ/-›ø¸^yšñLQÊãrôø½5ÿ uÚÃöŸöåýÚ?ÛN
¾FÔµ+Næ[ëÙ[‰Ü¼ŽÆ¥™&fÅ^‰ùù7sùªp4zU±s0î?fÿ âÙäš|ËÉWßF“k£ÚEaaÃmŽ5
*Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¬{Ï>IÓ¼é¥Ë£j©ÊGÂÃí#±,gö]?æÖøqWçÇæWåæ¡ä-b]R]×âŠE±Ÿ±*|ÿ maù&*—ySÌ×>[¿MBÐý;:~Ò7Ïù¿e²€˜¢Î16PhºÅ¾³g¡hk«ÈW¨ñVÿ )OÂÙ¤œLMs		Üƒ7b®Å]Š»v*ìUØ«±Wb¨=gV‡H³›Pº4Š.|M:*ÿ ”íð/ùY(GˆÐa9p‹|­¯ëwÝìº…ÙYš¦ û*«þJ¨â¹½ŒxEK)q,÷òò¥ÿ 0uôŠáHÒìé-Ëâ¿¿úÓ·ü“õ$Å÷ü$°Ä¡ U P À|±U\UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÌó—”"æñ¾•ïb
—ª£í'ÙŽççÃŸñ_÷Ûb¯’±WÛó‰ßš'ÌÚ!òõûò¿ÒÔ*wx>ÌGþxÿ rßäúX«ÞqWb¯Ž?ç*ÿ %Æƒt|ß£ÇÆÂééu£™¿Ý¾ÑÜø	¿ã*â¯#ü´ó«y_P)­Åa¾Â¿¿ëGö¿ÔørŒØøÃvœô²:È¡Ð†Vn>¥"ÀÝ¼RìUØªZÒ Ö,åÓî…b™JŸàËþR7Ä¹8HÄØa8ñ
/–|Ã¡O ßË§Ü
IR£¡i’ëñfî2,£Âh¾€üªóó–á«ymHå?Íþû“ýšý¯òÕ¿™sU¨ÇÂ}îÓN!îfyŒä»v*‘yãËkæ-&{”¯(ŽÛH»§^œ¾Ãí—aŸ­§,8£O•H¦Ç®nÝ3X«±Wb®ÅYÇåæmçåæµ«nY­X„¹„¤ˆŸˆÆDûq7óÿ “Ë~ˆéš¾©ký›‰-çE’7
°ä­÷b¨¼UØ«±WÎdùdj>U‡WAY4û…$øG(ôŸþJú«âŒUú	ÿ 8×æ­ùNwþòÙZÙ¿ç“pþHúx«Ô1Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*üÚüÜ×Ž½æÍWQ&«%ÔùÞ”_òMeÿ óŠþ_Çžm…RÉ$¹oö+é§ü•–<U÷¶*ìUØ«±Wb¯œÿ ç/4fÐì"ò¦œå./Ð½Ã)¡×€þ{¿._ñ\lŸîÌUñ¾*ìUØ«±Wb¯¥ÿ *¼©þÑÓÕZ]\ÒY|EGîãÿ žiÛýøÒfŸQ“Š_ÕvØ!Ã{1Ìg%Ø«±WÍŸš>p>cÕÑjÙÛÖ8‡cCûÉç£É>9ºÃ€:|Ù8Ë4üòoo0ÜÛ”po÷d¿î×þzf6«'ð‡#Mø‹×ó\ìŠ»v*ìUä?›ÿ ™ ú–ÿ ªÜH§qãŸù;ÿ "ÿ ›6:|?Ä]~£7ð‡œyÈú—µH´m">sÉ»²¢·,û(Ÿójüm›÷‡å×åÆ‰ùO¢8Œ¨)–îíÅøLÇù"ý×üIÙ™•|OùÃù•sùƒ®Ë«IU´ZÇmýˆ”ü?ìäþòOò›ùxâ©’¼Ÿ}æýVßDÓ”÷JöUý¹üˆ×âlUú%ä#Xy#HƒDÓîág#â‘Ï÷“IþSÿ Â¯ÁöWd˜«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wœ~x~RÛ~ch­l®§nÚJv£w‰Ûýõ7Ùö~Æ*üüÔ,'Ó®$³»FŠâ(èÂ…YOVùb¯@üšó©Ò/E]5,î˜'¢J~?ó×ì7ûåÌMF.!c˜r´ù8MEïÙ©v®Å]Š»v*ìUØ«±Wb®Å^1ùóæŽoƒÙi,ß3ýÒÀþóý’fËKŽ‡®ÕOø^G;¬QÒ1 ¹$ôÌ÷úù!ùk<¹šê>½(]7Œ¬7Jÿ ,+û¥ÿ W—íb¯AÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*‡½±†ú	-.I¨ÈèÛ†VYOúËŠ¿:?7ÿ /fò˜®tg©€RÝÏíBßÝŸõ“û§ÿ ‹ñU/Ê¯=Mäo0Úë‘TÇqGíÄßËÿ ñ'üYÃ~ŽÙÞE{
\Û°’)Q]teaÉX|×WÅPÞ‹k­ÙM¦j%¶¸FŽE=ÁÅ_š>@ºò½q¡ÝU–3Îûq7÷RÆÿ +®*ôßÉ8JÉ´{–¬ö¢±“RLdÿ Ì¦øÔdþ\Öj±ÑâËM’Ç	zn`¹®Å]Š»y‡ç‡”EýÖ­Ö³ÚŽ2S©ŒŸù”ÍËýVåÌí.J<.§Ž'–þ]ù¤ùoWŠíú;þîaþCu?ìŒŸåpáûY›–q§ø¾ V)ÁiËx¥Ø«±WÎ_œ>\ý­<ñŠAyY—Ã‘?¾_ø?ýY7yñGÜê3Ã†L2\wb®Å]Š»}Ãÿ 8…æÇÖ<¤téÚ²i³´K_÷ÛZ?¹šDÿ aŠ½Ïv*ìU‡~phŸ¦ü£«XV{IYGùH=Xÿ ä¢.*üÜÅ_`ÿ Îjþ®©é„ïÊLüeNö/Š¾“Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»@kº‡èí>æôÿ º!’Oøgÿ qWåì’»nI©Å_Nÿ Îi<¯5mM‡÷qC
ŸõÙäù2˜«ëLUØ«±Wb®Å_Ÿ¿ó’ÚÛê¾{ÔKš¥»%º ˆµÿ ’…Ûyn*ìUØ«±VcùYåÓúÌk*ÖÚß÷²×¸e=ýGø[þ+ç”fŸ[°ÃŽO¥óJî]Š»`œ^jý¤›HOúMícè€~ù¿àwÿ =9þÆeé±ñþk‹¨ÉÂ+ùÏò‡—%ó¥ÁÍ]©^(7vÿ ÿ †ã›,“áëa#O©ìí"³†;ku	JvUTfŒ›6]Ø(*àK±Wb®Å^}ù­ù†<½oú>Å¿Ü„ëZ÷Z½OõÛý×ÿ üœó4øx·?K‰Ÿ/Ã›Ã|¹åÛï1êéZj®®"/‰?´Þ
£âvÍ««~€~NþQØ~[éBÊÞ’ßJ\ÜSwoå_å†?÷Z³o±W’ÿ Îb~g›+H¼™`ô–è	®ˆ=#÷Pÿ ÏW^oþLkû2b¯‘1WÛßóŠß”ÃÊÚ7øƒQŽš–¤”0Þ8Å­7÷²Ï4ýŒUîØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_)Î_þSˆÊùßLJ+ê¨ïöa¹ÿ eýÌŸóÇü¬UòÈ4ÜuÅ_LþXy¿üK¥+ÌkwnDs{š|ÏEÿ ’‹&ióãà>÷oƒ'eÙŒä;v*ìUØ«±Wb®ÅT/ï¢°·–îsH¡Fv>Ê96J1â4ÆF…¾NÖõyu{É¯çûs;9§jô_ö+ðæö1áé$lÛØçÿ /™¼ËúZé9Yi K¸ØÌOú:ÿ °*ÓÏ?ò²L_qâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUàŸó—_—¿§¼¼ºý²VïJ<šZ4—þE·	¿Ôõ1WÄØ«îùÄ=ÊçH¸nW:S…z˜[ãƒþ÷ÿ «â¯sÅ]Š¼7þr»òÌy›ËÇ\³Jßé@É°Ý¡?ß§üóþùÕçÅ_y[_—@Ô Ô¡©15YGí)ÙÓ¿Ú_‡!8ñ
g	p›}[ksÔIqŠE¬:aÉ[é¢";°lZ¦»v*²hRth¥Pñ¸*ÊEAfR<i[åŸ;ymü¹ªÍ§µJ)åË#oò¿eÿ Ê\ÞcŸ·K’&ž×ù5æÓ@³™«qcHÏ‰B?rßð­üóåûY­Ôãá7üça¦Ÿ¯æ³ìÄrÝŠ»`Ÿœž\:¶Š×-g³>¨ñáÒaÿ ûÏùç™ziðÊ¿œâêaq¿æ¾rÍ³ªv*ìUØ«±WÖóƒÑ¸¶Ö×{p>`M\Uõ*ìUØª…åºÜC$/ö]YOÉ‡UùoqA#Dßi	Sôb¯¥?çn¸êšµ·óÛÄÿ ðËÿ 3qW×x«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»aÿ œ&ÛÉÚÌªhE…Àûãeþ8«óo}ÿ 8KlËúÇw¼ÿ 7üÌÅ_Fâ®Å]Š»v*üîÿ œ´{O=jñ¸Ý®=AòuYð|Uç˜«±Wb®Å_E~Kùtiz(»RkÓê·à>Wþ%"ÿ Æ\Ôêgr¯æ»M4*7üæ}˜Ž[±Wb¯˜¿2¼Ê|Ã­Mp‡•¼_º‹Ã‚þ×üô~R³ã›¼0à:l³ã•½Cò;Êÿ QÓÛX˜~úïáOhÔÿ ÌÉ>&ÿ Q0µY,ð¹šhP·¦æšìUØ«±T£Í~dƒËš|ºÆükBî~ÂøÛüŽM–c‡¦¼“àù{YÕî5›É/îÛœòšŸøÕWü•\ÝÆ<"ƒ¦‘³eö¿üãWä¢ù#MÆ«ý5z€žCxb?ÁþK·ÚŸýŒ±ñI‹×µ½^ßF²ŸS¼nöÑ¼²QÉ±WæÇ¼ÕsæÍfï\¼þöîVzuâ¿î¸Çù1ÇÆ?ö8«0ÿ œ|ü´ÿ yš+{”å§Z~þæ½
©ø"ÿ žÒqOøÇêb¯ÐEP  (ÀUv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Tµ£ÛkVSé—Éê[\ÆÑH¾*Â‡~o~ay6ãÉšåÞƒw»[HBµ)ÍÅ¿ìãâØªcùQæŸÐÄbSK[ªC!=OîÞ½¸?Úÿ Šùæ>xqÅ¿ødúO4ÎáØ«±Wb®Å]Š»v*óÏ=wê::X!£Þ=ß°”wÿ ‡ô³7K7ü×U*Þùû6Ž±÷ÿ üã_‘Ç•|Ÿkê/«áõ¹|x?r¿ì ôÿ ÙòÅ^«Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±T6¡c¡o%Ê‡†dhÝOuaÅ×þ~iyëÊòùS\¼Ðç©kIž0Oí-kÿ ÏHø¾*ô_ùÅ9/yÊi–ú’›Wðä~8ÏÕUþzb¯¼qWbªsD“!Ž@AUùËùÇäFò?™ï4p·Wõ '¼OñÇÿ ýÑÿ )1W¥þGyˆêKiÒŸÞÙ5üc‰>æõý^«ÕB÷»=4ìWsÑó	Ìv*ìUØ«Ëÿ =¼¶.ôøõˆÇïmHG#ýöçjÿ ©-8ÿ ÆGÌí,èð¸Z¨X·›þUù”h:ÜRJio?îd=€cð¹¯Nqfoäç™™áÇødúc4®åØ«±U“B“£E*‡ÁVS¸ ìTáE¾RóN„ú¥q§=u!
OR§âÏúÑ·,ÞÂ\BÝ$ãÂi'É°v*ìUØ«ï¯ùÆ?"Iå?(Än”¥Ýû›©õPÀ,)ÿ "‘_ýglUëX«±Wb®&›œUùq¬°kÛ‚7Wÿ ‰Uôüá ÿ sÚ‘íõEÿ “‹Š¾ÄÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»a?Š[ÉzÈ~¥1û”â¯ÎUögüá;WË7ëÜ_±ûâ‡}Š»v*ìUØ«ä/ùÌï!½®£kæ¸ú7H-æ#´‰¼Lßñ–/‡þxâ¯š1Wb®ÅQšFžú•Ü6Q}¹äXÅ|XñÁ#BÒš}qkm¬IoãjG€QÅGÝšlÛ½…*`K±V#ù§æ?ÐzÎ†“\~â?bàóoö1óÿ eÇ2tðâ—¹ÇÏ>¾zòÖƒ.»¨A¦Ã³LÔ'ùWí;ÿ °O‹6³—·Uñ}_km¬Io„Š5ª:QÅWè¢&Í»À+eL	v*ìUØ«çOÍÏ9Rúµ³r³µª¡!›ýÙ/!Ûöü•åûy¸Á€y—QŸ'òz?üâåó¢|ÓªG]>ÁÇ¢¬6’q¸?ê[ü/ÿ x+æKŽûC|ùÿ 9çƒ¥y~/[µ'Ô¤«þùˆ†?ðrú_ð/Š¾.Å_wÿ Î,yycÊ‘ÞÎ¼o5B.½B÷™?ä_ïç®*ö\UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾dÿ œÏò¹³µóu²þòÜ‹{‚;Ææ°»©/$ÿ žØ«äpi¸ëŠ¾¥ü¾óéýÞñÈ3ôåÿ ]~¯úÿ ŸìóKš2w8gÅE”7;v*ìUØ«±Wb¯Ÿ?<µƒy®}L}‹HÕ>lãÕcÿ È¿ì3o¦GÞêµ¹{˜ÿ å×–Í>a°ÑëupŠþÈ)›ýŒ\Îe8¯ÒÈ¢HF€*¨ ÐŠ¯Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUŠùïó3Bò-·ÖµÛ•‡ªF>)þ1Ä>#þ·ØþfÅ_4yÛþsCU¼f‡Ë‘ÙÃÚYÿ y!÷ôÇîcÿ W÷Ø«È5¿Îo8k-Ê÷W»?äÇ!‰ä\šÂâ©ón°[‘¾¹åãë=âXªu£~py»FnVZµâû-+H¿ò.oR?ø\Uë^Jÿ œÌ×,bó%¼Wðt2DR}¿rÿ êð‹ý|UôÇåïæÏ—üû«¢\™E^øeOõãþ_òÓœåb¬Çv*ìUñ·üæ‡”ÅŽ»i¯Ä´KøLn|d†‚¿ò)ãÿ ‘x«çí;P›O¹ŠöØñšYø2žkÿ Š¿N|»¬Å­é¶º¬Ý]CËòuüqTÇv*ù£þsGÉBëN³óDûËWú¼Ä¾ßâ‰üc—’ÿ ÏlUó¿å¹ú+Ì+GuXý—÷òYcÿ c˜ùáÅüá“é<Ó;‡b®Å]Š¡õ¯í¥³œV)‘‘‡³'%p›c!bŸ&ëdºUäÖSm,2’zžobl[£">šò˜OèÖ÷¬Ü¦ãÂ_kð¿/Þªù¦ÍS¸Ã>(Û Ê[Š»xwçöŒ°ÞÛjH õÑ£zw1ôfù¤œçžlô’±N·U6òŒÎpŠ»}ÿ 8Ýÿ 8ÿ /š.có.½]ål?Þ‡S¶ßòÌöÿ ß¿ÝýŸS}¨>X«±Wb®ÅRß1êK¥é—Wò-¼JO²+?ðÅ_—ÄÔÔõÅ_Qÿ ÎéÌgÖ/ˆøU ˆrevÿ ˆ®*úÃv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»H<û¦þ“òþ¥cJúö“Æ»FÊ1WæV*úËþpƒTm«é¤î¯À{0xÛþ ¸«ê,UØ«±Wb®ÅR?9ùFÇÍÚUÆ‰©¯+{…âHê¬>$‘?Ëþ%Å_ž?˜¿—º—õit}M7SXåá•Ù–?cÿ ßb¬Wv*ô/É'ëºð¹?bÖ6“æÄzJ?ä£?ûÅÔÊ£ïrtñ¹>†ÍC¶v*ìUà_žš÷×µdÓþîÍ(zSœŸÿ Âz_ðÙ¶ÒÂ£Îuz™Ü«ù©¿ä—CµÆ·(¯ÜGZu4y[þÓUÿ ^L¯W=¸YéaÕìÙ­v.Å]Š»a¿šÞl>^ÒBÔºº¬Qx¿y'ûÿ ‡tÌ>>)UÆÔO„{Þå?-]ù£U¶ÑlW•ÅÜŠŠOA_¶íþJ/ïü•ÍÃ©~y7Ê–~RÒm´M9xÁlFÛ±ý¹ü¹“¶*â¯?ç'|ßþ#ó¥ÚÆÜ °Ò=ÿ ßßÉv—a¿–¾Ro7yŠÇBZñ¹™D„uÞL~ˆ•ñWéD¥¼kJU eÅUqWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*†¾Ô-´øÍÅä©C«ÈÁT²‡`ÚŸçÿ ‘´ÒV}^Ý˜¾«/ü˜Y*—Cÿ 9;ä	ˆÕ ¯sÀÉ¬U•hš^Wóô½NÖyD¨ùüdÿ …ÅYN*ìUØ«±TÎÞX‡Í:-æ‰qNp´u?²Ä~íÿ ç›ñ|Uù¡c5…Ä–—*Rh]£u=C)âË÷â¯Wü€ÖÊÍu¤9ø]DéìV‘Éÿ ?ù˜¸ínv–[ÓÚ3Zì]Š»v*ìUØ«x«ä¯2jCTÔî¯‡Ùšgq_Ç‡ü.oâ(S¢‘³oiÿ œ5òï×üÕ>¦â©alÄ”ˆ—þIúÙ&/µñWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»xÇç×üä·åôGKÓ8Ükr-BÒ?fY¿™ÿ ßq²ƒ5_ëþa¿óãê:¬ïsu!ø¤ÔŸù¥•á_ÙÅRÌUØ«±Wb®ÅQÚN¯w£ÜÇ}§Êð\ÄÜ’HØ«)1WÙÿ óÿ ó‘±yØ.…¯•‡YQð8Ù. þ_ä¸þxÿ ÝŸn?äU^ïŠ»xüåç—F§ä·¾²ióÇ0ÿ UÕßþO+±Å_â¯¾çõã«ùÉ\ÕíKcþÁ¹Gÿ $¤zÞ*ìUŒ~eùU|×åËý…Zâ	ÿ Ç	ÿ ‘ª˜«óaZKi-RDjŽÄŠ¾µÑ5!ªXÁ~»	âI(;r¸ÿ ±ÍãÂHw—´nA›±Wb®Å^ùï¡ýST‹RAD»Ž¾åãøkÿ "Ú,Úégq¯æº½Lhßzcù¯%Î!ª°õãö"‘Ëÿ Ê?øÈjáµ³ÒËz{>k]‹±Wb¬ó³Núß—žnöÒÇ/Þ}ùË2ô²©S‹©Åó¦mRg¡ywP×î–ÇI·’êáº$JXþü¬Uõåüâ,vlš§ŠÍ £-’ ?òó þóþ1'îÿ ™äû8«é¨!Hb‰B¢€ Q@ ì*©Š»v*ìUäßó“Þi]Éˆ	¯¸Ú ñõïä‚ËŠ¾Å_oÎùxé¾PmBAF¿¹yÿ €@¿ðé.*÷lUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ZÊwPŒUù—ç­ ù{]¿ÒSê·Æ£üÇÓ?ì“|UêóˆþgGœÖÎV¤ZŒý9­&‹þM2/úø«îlUØ«±Wb®Å]Š°ÿ Ì¯Ë'óMm7UJ2ÔÅ2Î&þt?ñ4û/Š¾üÐüÖÿ .®½-I=KG$Cs>›÷ÜŸñSÿ Ã¯ÅŠ°<UïzIƒL¸Ôf¹”(ÿ V1×þGÿ Íf®[€ì´±Ø—¨fšìUFòî;8$ºœñŠ$gcàª97á†"Í1‘¡o’u=B]Nî[ÙeÙÚž,yPfü
èÉ³o§ü¡~‚Ñí¬¤Š¤­+Í¾9ãü¬Ü?Øæ—4ø¤K¹Å€žå-®Å]Š»|ßù¹æS­krG¬Ÿ¹O˜?½o¦O‡ýE\Üà‡]>yñIîŸó†_—T[Ÿ9^&æ¶Öµ¿ãâUÿ ……[þ3.d4>¨ÅRß1ë1èšmÖ«>ÑÚÃ$Í_Rÿ ñ®*üÆ¾¾–úynî)fv‘‹1äÇ}ÿ 8Wåqw¬ßkÒ-VÎ
òæ;ÿ ÀÇ/üôÅ_aâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ƒÕu[]&ÚKëùRh—“ÈäQîÇ|¹ù¡ÿ 9‹+»Øù&0±äËRãöÖ›þE.*ùËÌ^lÕ|É?Öµ‹©®åñ•ËSý@~_òWIñWb®Å^‡ä?Ï5ù1•lokUëopL‘ÓÁC|qÏLUõ§åüäv‰çòº|ÿ è±Ø@íUÿ Ë¼»sÿ ŒmÆOõþÖ*õÜUØ«±WÀŸó”V¯5ãðK¤ÿ f)/ü—IqVùuª~Œ×ì®?dÊ#jô¤Ÿ¹cþÇÔå•eHmÅ.ú4néØ«±Wb®Å]Š¥Þd½k2îî3G†	]~j¬Ëøå˜ÅÈ¼†¢_$fõÒ>Àÿ œ$Ò-SÕø¦¹HkízŸö1Š¾”Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*óÿ Î¿Í?.ô5-šöRbµŒþÔ„}¦ï¸—ãøÛÅ_Ÿ®«s«ÝK#Ms;—’G5,ÄîØªv*ìUØ«±Wb®ÅQwsYL—6ìÑÍFSB¬U•¼F*ûïòóm14ORæ‹ªÙñŽåÕ¨ýÜê?’n?ìdWýž8«ÔqV+ù©£þ™ò¶«`Z[9¸ÿ ¬¼ðê¸«óW}wÿ 8C«	4ÍWL'x§ŽjÆE1ÿ Ø¾*úgv*ìUùËùßåÁåï8ê–
)ÖT/ïÐÀÉŠ½CòGRúß—’ÖÚY#ú	õ¿æoÔê£R·i¦•Æ™öb9nÅ]Š»a?œZ!Ôü¿3 ¬–¤N>KðÉ÷FÎÿ ì3+M*—½ÅÔFãîxoµÐúÝ¥ë¨²rzÝHØ£“›<±â‰»¸dêŒÑ;·b®ÅR¯6Xý{H¼¶“IGù\Oøl³©×\KäÌÞºGØó„÷ñË¡ê6”_V¥rh+ÆD
 ž¿jÅ_Hâ®Å]Š»v*ìUñGüåßæ"ëÚü~_³~VºX!È;Úž¯üŠ@±ÿ ’þ®*ðÝ3NŸSº†ÆÕKÏpëj:–cÁü*ý.òg–âòÆg¢AºZ@‘Wùˆÿ ³~OŠ§x«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*øŸþsÉÇIó<zÜKH58cÛÕˆ¤ÿ ’^‹b¯Ðµ‰ô[ë}NÌñžÚT•ùHy®*ý,ò™m¼Ï¤ÚëvF°ÝÄ²Ö„ý¤?åFÜ‘¿Ê\U8Å]Š»v*ìUØ«çùÍ2}KË¶z:=õÇ6äB*ä¬±b¯ŒñWÕ^CÒ¿Ehvv”£,JÌfÞ¸ÿ ƒvÍ&iqH»œ1¨„û)nv*Á9µŸÑÚ‘)øîa/¶ÿ ð©Ãýžeé£r¾çS*w¼WòïE]g]´´p|ýG¡T«)ÿ _öY±Ë.’ëñGŠ@>¤Íºv*ìUØªIç]{ô‘s¨I§Ûo‚>¾Ü²ÜPâYeÃ|»§ióêW1Y[)yçu¹f<TÁfñÒ¿K<åX<§¢ÙèvÔôí"T¨ý¦ë$ŸóÒNoþËOqW”ÿ ÎOëgIò%ÿ G¹1Û¯û7^òIdÅ_ â¯¸ÿ ç4§ù0_Sã¿¹–Zÿ ’ŸèëøÂø«ÜqWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¥úî·i¡YM©ê2­mÐ¼Ž{ü”b¯‚:¿;õÌ{â ´DL}`zÿ ÅÓÿ <Íÿ ØOÛwUæ8«±Wb®Å]Š»U†gÄ‘’®¦ ˆ#}‡ÿ 8Ûÿ 9Þdáå2Éþä”RÞá÷Àº¤ÿ —…ý–ÿ wÆOï}Š»|±ÿ 9½ ‚šV¶£¡–ÙÏÏŒÑÄfÅ_)ƒMÇ\Uõî“|58/@ ž$õÔ?ñÍÅìM€QYNÅ]Š»v*Å?5.M·–¯¤^¥?àÝ#ÿ ó#N.a£9¨—ÌY¹tï»¿çl…¿‘-åîùç“îsüÊÅ^ÍŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUðgüåŸ›Í~lšÖ&­–—[hÀ;rý&O›Kû¿õbLUãØ«±Wb®Å]Š»v*ìUØ«Òÿ ç<þÞLóe­Ã·K¦×·	ÿ ç”œ$Å_¡8ªœð¬Ñ´MöX~Db¯ËBÐÚ\KlzÄì‡è<qWÑ_ó„w¼5NÓýùjÿ  üæv*ûv*ìUñwüæ†‰õO3ÚêJ(·–€v™þI´X«ÿ œ|ÔI{bNì#•GÈ²?üN<ÀÕs´§rÍš×bìUØ«±U+»Xîá{i…c•Yx†[ðÂA)ò6£§É§ÜËg>ÒBí|Ôñ9¿÷tDSêo'êÿ ¥ô‹Kây4±/3þX%ÿ ’ŠÙ¤ËîqKŠ §Sk±W|ñ/ïmZÖy-ßfÙOÍM3 ˆ¾’ÿ œ ¿á©jÖUþòd§úŒéÿ 3°¡õÖ*ìUØ«±Wb¯/üúüßƒòïFc+j÷@¥¬grF¸qþû‹þN)üØ«à›‰.diçbò¹,ÌMI'rN*úþqòÍµ}]ü×xŸèšqãFÍ;ù‘sÿ ^H±WÙ¸«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ó/ùÈ_Ë³ç+Oml¼¯­ÒmÀ–@yÄ?ã,\‘ËáŠ¿>qWÓóˆ¿›K§\7“5I)Ës³f;,‡ûËùíöãÿ ‹Ê—}wŠ»v*ìUØ«±WÄÿ ó™bý#æÈ´Ä5M>ÙT“÷Ïÿ $½UãYÒÿ JêvÖìÍ2+ªOÇÿ œ¸E²ˆ³O¬óBï]Š»xoçþ©êßÚØ-
ÁÓù¤4£±‰àói¤uš©Y¤Oüãö‘Êk½M¿aVÿ d}Gû¸Gÿ ‘ÕË`ic¹/iÍk±v*ìUØ«È¿ç 5ž0ÚéHGÄÆwÀ»ˆý<¥Í†’<Ëª— ³þq?Ê^óŒW’¯(4ØÚå«ÓŸ÷pÃ¿©ÿ <³bëßvb®Å_8ÿ Îlêf-O°ûë¶r?ãÿ 3±WÇ8«ô‡òkJýäíÔŠg‘îëë7ü3â¬Ïv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ãoùËÍ‡Ö5/ð†Ÿ'ú‹Vä©ÚI¿ÿ “möã7?÷Úâ¯1Wb®Å]Š»v*ìUØª"Òî[I’âÝŒsFÁ‘”Ð«ÉXªqWè?ä_æj~`ùv+ùHðFéFß¼ûÊ,ËûÏõ¹'ìb¯EÅ^)ÿ 9w¥­ç‘å¸"¦ÒâAð«}_þgâ¯…±WÓÿ •×yå»)¨CÑ4Kÿ 
™¦Ô
™wÄ2œÇov*ìUØ«±VùÄÔòÅØñ1ù)ei¾§Sô¾jÍ»©~‚ÿ Î4À!ò”Ü’V?L²œUéø«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb©Wšµ•Ñ4›ÍUúZA,Ûÿ Œÿ Ã~c\ÜIs+O9-#’ÌORNäâª8«±Wb®Å]Š»v*ìUØ«±Wéoå—˜Ì^YÓuid¸µœÿ —ÇŒ¿òP6*ÉñWæGž¡ôµýJ?ä¼¸_ºFÅ^Áÿ 8a)_8\ èÖ×è’Uö¾*ìUØ«æoùÍí(>™¥j@|QO,5ÿ ŒŠ$ÿ ™«Á¿#¯þ¯æü´C$u&ÿ ™Y‹©'LjO¡³PíŠ»v*ìUówç•ú;ÌS²€áVeü¡ÆCþÊT“7:y\C§Ï‘zOäF«õ­ì˜Õíf`‚?ïï“ÕÌ=\jVæiebž‘˜Nc±Wb¯”|èœuÍAFÀ]Oÿ '7ØÍÄ{ö'ÞöùÃ+£œ'‡´¶2¹ál›Û8«±Wb®ÅXæ×ç“ùoaõ‹æõoeêöÊ~7?Ìßï¸Wöä?ê¯'Å_ùÛÎšœµ9u­ZNwšSöQGØŠ5ý˜Óþnû\±UoËÿ "ßùßWƒDÓ÷²š³‘ðÆƒûÉ¤ÿ %?á¾ÇÚlUú%äÏ(ØùGJ·Ñ4ÅãonœA=XÞGÿ .Gø›O1Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUñüå7åyWW>aÓ£¦•¨9fâ6Šcñ:’“{üôOØÅ^oq$,Ð±Y‚¬#¦ø«îOùÇÏˆ<õfºFªá5Ûu¡o]~Ÿñgûú?ùèŸØUíX«±Wb®Å]Š¿6?5üÃþ!óN§ªTšêNü…>œ_òIM#´Ï­kâàôµ‰äúXz4ÿ ’­˜º™T\<nO¡³PíŠ»|»ù“¨þ‘óìÝ–SùF?Y¼Å€érÊäKÚÿ &´ÁcåØ_ö®æo¤úkÿ $ãLÖêervhÔY¾b¹NÅ]Š»|Ùù½«~óÀVåa_n#ãò9¤ÍÎÔC§Ï+‘}+ÿ 8[å¡g ^kn(÷·šŸò!_ú«,¿ð9Ðú+v*ù;þsŠè›ß°K—ûÌ+ÿ â¯—qWê.‹l-,mí€ ŽJª¡qTv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«üÀóRySA¾×‡ê3¨=ý˜“ýœŒ‹Š¿5//&½šK«†/4¬Îìz–cÉ›ý‘ÅPø«±Wb®Å]Š»v*ìUØ«Üçüèt/5*F¥¶«ˆŽÞ¢VHþNGÿ =qWÜx«Ïç lÅß‘uxÈ¯rÿ ð²ÿ Æ˜«ó·}ù#uëyySýõ,‰ø‰?æfju_S´Ó},û1·b®Å]Š»a_œiËË7GÀÄä¢ÊÓ}N.§é|Ù›wTýÿ œk”Iä(Ö´IGÝ,¸«ÓqWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅXçÌ­‘õ†N¦ÕÇÐÄ+b¯ÎœUØ«±Wb®Å]Š½ƒòcþqÛRüÅS©\Iõ-%X¯ªW“HÃí,	Uû?µ#|ëüX«Ù5ùÂ]	íÊØê7qÜÓf”Fé_xÑ!où)Š¾iüÈüµÕ?/õ3¥jÊ	 ´R¦é":øš7Å*ÄqWb¯¿¿çnZËý4¿ìúê>BiF*õlUù“çÉž`Ôäòà¦GÅ^»ÿ 8b„ùÆsØXKÿ '-ñWÛ8«±Wb¯ÿ œÁ°I3¼p¿ßÎù›Š¾Eü­»¾d²‘º)ÿ ¯ü_)Ì.%»	©Ó¹¤w.Å]Š»v*ñŸùÈ=<,–Wê7e’&>Ã‹§üN\ÙiÄ:íPÜ'üãö¢ÑßÝØþÄ°‰>”n?ªl–¬mlt§z{ŽjÝ›±Wb¯—ÿ 3!ùŠùGyyÁ ßÇ7x~érýEè?óˆ²”óÔ*?nÞpàyÆ¹sSî¼UØªÿ P·Óá{«É#y$`ª£ü¦o‡|ïù«ÿ 9yc¦Ó¼šÝ×Ctàú+ÿ “íNÞÿ _ñ“|Ÿ¯y‚ÿ ^»“QÕf{›©MZIIÿ ›•Wá_ÙÅQ>Qò~¥æíB=#F…¦¹”ô~Ô’7ìFŸ´Ç}íù9ùA§þ[iŸV€‰¯ç ÜÜ»û	üÇû	þÍ±W¡b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU)óG–,|Ï§O£ê±‰mn‹)ê?•”þË£|hßÍŠ¿?¿6ÿ )µËQ¬nÁ’ÒBZÚà†Dÿ eO÷jÆŒ˜«Óu+.â;Û˜X:H„†V
¶*û#ò?þr~ÏÍ
š7š-u]•&4X¦?ñg?ÉýÛÿ ºÿ ßx«èUØ«±V9ù¯ÿ ‡¼»¨êÃí[ZÊéþ°Séÿ ÃñÅ_™Ø«Ü?çtÓåù§ïdX‡À9·ßë/ükurä†–<ËÖ3Ïv*¡x–6òÝË´p£Hß%›%f˜ÈÐ·ÈR;LåÛvc_¤æýÑ>·Ðôó¦Ø[ØšV’3OP§436Iw Fä»v*â@;ˆƒ³ä-Rýµ©¯$ûsÈò›G: (S¢&ß¡Ÿ‘èO%i6”âÍl³7Îoôƒÿ 'p¡žâ®Å_ ÿ În“ú_J¾­'üO|áh+2Óýx«õ*1E xU~*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Âç1µ“cää³Oøü»Š6ÿ UÏÿ ‰1WÄ8«±Wb®Å]Š»v*ìUØ«±TßÊZÃhºÅ–¨¦†Öâ)kþ£+â¯Óµ!€#pw«üêó¥ëUÿ –ÿ â~pb¯üƒ5Ð¦ÿ ˜·ÿ “pæ¯Wõ|ž—éø½'0œÇb®Å]Š»b_›™|³z«Ô*7ü‘¿ük™së> zKæLÜº‡Þ_ó‰×‚!ZGZ˜fÓ#Kÿ 31W±b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š°ÏÎ]9µ'jöÑŠ¹³™€÷Uõ?ã\Uù½Š»v*ìUØ«±Wé·‘4›}#B°ÓìÀXa¶‰VþVÿ f~6ÅSìUàó™ºM½Ç•-õë×h¨Ýé"¸‘?ÙpFÿ aŠ¾*Å]Š¿Bÿ çôÃ§yI‰…‘4¿ò5Þaÿ 
ãz4’Ô»l~C~\ê·Ÿ\»šçýû#Éÿ yb¯¡ç	lùëº•×ûîÑSþEoù•Š¾ÄÅ]Š»yGüå¿¯äKÅ>‰¢Å_ù$Ó]Óéÿ -pÄ×+ÉôŸs<P÷¾­Í¼v*ìUØ«±WžþyØµÎë/Kyã‘¾D4?ñ)W34¦¤âj‡¥åŸ”Vó-­MOQÒÇþŽggá`5 úW4®áØ«±WÌß›ò“^ÿ ­ü›7x~é³}E’Î5kVZ-oõIãµµHçå$¬Ecu_‰¼[áËš_Syƒþr—ÈÚ8!/òAû6Ñ³ÉGôáÿ ’˜«É<Ûÿ 9¯y8h|µ§¬ ì%¹nmÿ ""â«ÿ #dÅ^çÌ0yÊ_W]½–æ†ª„ñÔ…8Ä¿ð«Å^™ùOù®þaÈ&·Oªé¨÷RƒÇo´°§û½þ_óºâ¯¶?.?+´oËûc£ÅG`=Yž†IHý§oåEøf«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ó§’tÏ9éÒiÌ^¤nÙ‘‡Ù’'ý‡_óøqWÂ¿›ß‘Ú¿åÍÑ2©¸ÒÜÒ¥ò&î©Éý¿÷[6*ó\Uí?•_ó“úï’øXj5Ô´µ Èß¼ŒÅ3ï·üW'%þOO}aùùÕåŸ<¢®•t«tÃ{ih’ƒþ¡þóþy4˜«;Å^#ÿ 9wæÑ¾K{54{ûˆ¡§²ÿ ¤7ü™_ø,UðÎ*úwò³KýåÛD •ÆýBdOù&È¹¦ÔJä]¾Q¯1Ü‡b¬có6ù¬¼»}*õh½?¢B°ŸÂL¿ ¹†Œæ¢_:ùJÅoµ{;YRIãVä–ÿ áso3@—UdÖ9¡wŽÅ]Š»J<ápm´ké£-´¤~Çþ-Ä.A«)¨—Ê¶–Íu4véöä`£æÆ™¼t¯ÔM>Ñlm¢µe…ÉGUŠ»|‹ÿ 9¿5-&_æ‚eÿ d?ñ¾*ù¦'ôÝ_ÀƒŠ¿R­dDŽ:}#VÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|Ýÿ 9·Ëô™O³õ·¯ÏÓjÆØ«ãÌUØ«±Wb®ÅQzv>¥s•ª™'Ö8ÔufcÁélU÷_åoüã—¼¡gê6Ñj£(2Í2‡Uoå‚7øùøúÿ 
ª²_7~JùOÍ6ío}§ÀŽEXb‘OŠÉ_øäŸäâ¯…?4¿/n¼®Ï¡ÜŸQ’C%($¿»øÑÿ âÅ|U‡â®Å_©zuE´\¾×¯Î˜«üï˜Cäe{9Wþpÿ ±Wç*úò2š„þÕÓŸøH—þ5ÍV¯êø;=/Óñz>a¹ŽÅ]Š»v*•y¶Ñ®ô{Ûtw·•T”Q¸ÿ Ãe˜H5äù37®‘öOüáF¯ëy~ÿ N&¦ÞìIO*(ÿ ‰Bø«è¼UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±U+‹t¸¡”UJ°ñq8«ó7Î¾Y—ÊúÍæ‹=yZLñÔ÷Pvÿ ìãâøªEŠ»v*ìUØ«íùÇ?ÏÍ3UÒmü¹®Ü%¶©h‚ÚV
³"ü1q‘¾YWàtý¿ï—ÅÁW»ßjÖv«Éã†2Hê«OõØñÅ_ÿ ÎO~uÚùÞæCoSK²bí-ËOO’WýÕrTo÷g¨ÿ ³Ãx>*˜hZ<úÕý¾—h9Ou*Dƒü§<~›hzTZE…¾›n)´Iü‘B/üGJÿ 1uq£ùsSÔ{Ái;¯úÁ‡ü6*üÍÅ_Zÿ Îi<,õmLï$†Ô#ÉåÅ_Oâ®Å]Š¼ãþr-9ùWñJŸºHÎ*ø+ÊÇY°>PŸøuÈÏ‘eaõ†hë±Wb®Å]Š±¯Ì›®ùvú/ŒŸò,‰ÿ æ^_€ÔÃFqq/›tKôf¡m~Aao*J@4$++ôÓ7)ÔÄÑ·¿iß\»ZÉ3Û·òÉWþIz«ÿ š©i¤˜ÔÄ§ÑyçB”Uoí€ÿ *T_ø“¯Á—sgõÿ ã=þ®Ÿò>?ù¯….âŸ=áó¿æMôþ`¼¸µu–&eâÈj¦Š‹ð·~™·Ä* U”Ü‰_-jv*ìUØ«±WÜó‡ºŸÖü•õrjmnæŽž¸Oÿ 3±W¸â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±T&¥¦[j–òY_D“ÛÊ¥^92°=™N*ù_ó‹þq(Y$Úß“äV’KIšœUG'0Lÿ hÅsÈßÙÅ_/b«ÑÚ6†Œ7b¯Ròoüä§œü®»¶ëJEv=M¿É–«?ü•Å]ùÏùísù”Ú‹1fdf	!ev~ŠS€Oæ·Š¼ÆÖÕî¥KxG)$`ª<IØbT>¼´µŽÒ¶„R8”" £Šç?#fÝð)W]Š¼çóÏPô´!l9KpˆÂ»G—þ%æn–>«òpõ2ôÓÌÿ '-Œþe¶jTF$sÿ  Ê?áÛ35 \<äIf™Ü;v*ìU‰~lÊbòÍë¼cðRFŸñ¶diÇ¬8úƒé/ü·³úï™´«n¢Këp~FD®n]CôÃv*ìUòçüçŸÊßG¾°÷öB'_ù6Ø«äìUúqä}DjZŸ|¦¢{H$¯úÑ©ÅSÌUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±W…ÿ Îbh­}äÑx‚¦Êî)Iÿ %ƒÛÿ ÄåLUðþ*ìUØ«±Wb¬ëò>òÞÏÎšD×d…Üb§ -ðF~‰qWèÖ*ìUñ¯üæ­í¼¾b±¶Œƒ<6•’ƒ;×þ6ÿ eŠ¾uÅS¯&é­kV:bŠ›«˜¢§úÎªqWéÈP °«Ëç'5¨ùR#íJ"ˆ³–0ßðœ±Wçö*úOòn–m[¼†V?ò1Óþ5ÍF¤ú¶˜zY®b¹.Å]Š»v*ìUò.µ§6úâÉºÁ+ÇóâJ×7ñ6-ÐÈQ§¼ÿ ÎëâÏÌwšSš-å¯%/r_ù',¹$>ÍÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ùKþsòÉ„‘yÖÅ*¤,”ømçoŸ÷ÿ <qWË«±Wb®Å]Š»TiÀF$¨è+Š©â®Å_IÎ~Y>£¨¿œ/SýÎ±ÛÔlÒ°øÜÆÛþOò1WØX«Ç?ç+¼Ä4Ÿ#Ü@¦’_K¸ñ¡>´ŸòN«àìU÷üân…ú3ÈðNÂ{4ÓŸ¿Ð_øHqW²â®Å]Š¼ãþr)øyW?ñJ¾HÆ*ø+Ê+ËY°7PøuÈÏ‘eaõ†hë±Wb®Å]Š uû3{§]Z³A$ðJËürp5!ïa1`¾EÍó£d×Ÿ—`´Ug±•ÕÀ#Ò¦ÇÇÑç•±=[N)‰UÇ—µ+oïígJ4l?Zäøƒ¤ºMãš%'ýFþ˜m‹‹ÊZÄÂ±XÜ°ÿ &?ñ®0:§„÷&6_–~b½º±•ã%#ÿ “Æ<¬æˆêÌb‘èØþFù‚äVa¿´’Tÿ É6Vu1ƒM"È4ÿ ùÇ²@këÐuŠ:ÿ ÉGaÿ &ò£«hÒw–Q§þIyz×y’[ŸøÉ!ògÑÊ%ª‘nh‡–þoèvÚ6µèÙF°Âð£…AAûIÿ fv	FË…ž"2 úþp†ïžªZÿ ¾îcø4ãÿ 2³!¡ô®*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯1ÿ œ“óÑ<©IýåÂ-²ÿ ÏVÉÿ $½LUùÿ oo%Ä‚(UžF4
¢¤Ÿ–*ë‹im›Ó7™JŸÇQÅ]ŠªÁ;ÛºË‘*ÀÐ‚;ŒU5ÿ ë¿õp»ÿ ‘òÍY_‡áòlñ%Þ[u×êãwÿ #äÿ š±ðãÜâK¼¡/uýFýxÝÝM2øI#0ÿ †9!dJ_’bôßÈ(¹kS¹ý›VûËÅ˜z£éø¹zQê{Þj£±Wb®ÅXWç#ñòÍÈþfˆÉD?Ã2´ßS‹©ú^Où«çmi_ô¸ÏÜyfÝÕ?FqWb®Å^ÿ 9£ýwÉÉx½lîâsþ«‡‡þ'"b¯ˆ±Wè?üãv´5_"iZ´(Ð7·¤íÿ Â*b¯MÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»H|÷åˆüÕ¡ÞèrÐ¸0Of#÷oþÂNŠ¿4õ	ôû‰,î”Ç4ÑºžªÊxºÿ ±lUŠ»v*ìUp%MFÄb¯ªÿ +ç0m ³Nóœr™ãP¢îË˜hê­ê3GËŸòb¬—Í¿ó™[±¶oÐM}vGÁÍLqƒÿ 3þóþ?Ù.*ùÍ>i¿ó>£>±ªÈeº¹~nzT²ˆ¿/òâ©>*÷oùÄ?$¶µæ“¬Èµ¶Ò£/SÓÕá_øVOùçŠ¾ÞÅ_=ÿ Îik_UòÍ¦œ¦uv›þâÅ_â¯ªü‹b¶ZŒ*8ÿ £ÆÄ”ãÔøvlÑæ7"î±
ˆOr¦×b®Å]Š»v*ùÏó§Iú‡˜$•EéP='úyÆÏþÏ7y\]F¢5$åš¿ÂžiÓµv<cŠuYüVÿ ¹›þI»fKŽý#Q¸8«x«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨-_J¶Õí%Óï£ÛN†9ºaCŠ¾üìü¾ü·ÔÌd4ºdäýZzlGûæOåž?ù)ýââ¯5Å]Š»v*ìUØ«±V{ùIùM¨þcj‹ehv‘×7|1§üm+ÿ º“þ4Wâ«ôË^[²òÞ‘¦GéZÛ D^þìÇöÄíûMŠ¦¸«äOùÍ5ýcQÓü½T[Æ×üÒN/ø¿äf*ù²ÞÞK™Ai…P:’v~šy7@_.è¶Z:R––ñÅ·rª›ý“|XªuŠ»v*ò¯ùÊ‘5/òýLÑb¯†ü’	×tð7ÿ KƒþN.C'Ò}Ìáõ{êÜÐ»Çb®Å]Š»l{â_:b§¨4Î…Ð¾³ò´Æ}&ÊfêöÐ±úQ[4YHûÝÞ?¤{“<­±Ø«±Wb®Å]Š»x/çòÿ ¹¨·ÕT}ÒM›]'Óñuz¯«àõùÁÛƒêëP×b¶ÍO‘s1Ä}]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ž?ç55–ìmÐMxû„ŽOú©Š¾iüšµ3ù–Ù€ªÄ²;|¸2øw\ÇÔr0}%íškvÔ—ÞyN½5ºµ‚cÿ F­ÿ \˜É!Ô±0¢_#èR
5…°ÿ V$_øŠŒ˜Í.ö{•ž[ŸíÙ ÿ Uâ¹/ÌO½{”?åPy_þX¿ä¬¿õWÌO½—‡räü£òÂ‹!ôÉ)ÿ ‰Iæ'Þ¿—‡remäMÜQ,-?š%c÷¸c‘9¤z²b:<«óâ+kYìlícH•"vâŠfaO³ÛàlÎÒ’A%ÂÔ€ÿ 8ó2j÷Q
ýþ©ÿ r:¾A–“™{>k]‹±Wb®ÅX7çB“å¹ÈìñøuÌ½/Ôâê~—˜~A¸O<häôúÈx#6Î©ú)Š»v*Â:|¿þ ò~«§¨äílÒ ñxÿ ü<x«ó‡}ÿ 8Oæ1>•¨èn~+iÖuäÊ¼Ÿê¼?ðø«é\UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿ ç.)_O¾ÿ éÉ[K¢è(ûý•˜ÿ ‘?Ùÿ Œ¿ñ—|×Š»v*ìUØ«±Wb®ÅQVêÇih,ó0DE,Ìxª¯Ï~†~J~ZGù}åèt³Cy'ïnœ~ÔŒ7Zÿ $KÆ5ÿ W—íb¬û|iÿ 9¥æ!yæ-VÊØ»˜ÿ Õ8¢Å^¤iÍ©^AcÍ<‰>ÈZà‘¡iÍ>»
PlLçÉ·z6v)v*ìUØ«±Wb¯0üùÐÞ›§«Z¿§òIAÈÿ «"Æ¿óÑ³;I:4áj£bÞ›7Zýü„ó¨ó”,o¹\ÂŸWŸÇÔ‹àäßñ’>ÿ ³Å^‡Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU*ó/–tÿ 2ØÉ¥jð­Å¤ÂŒãû,­ö‘×ö]~%Å_~mÎ*ëYy/ü¶¯¨é›ž VxÇùq¯÷ê¿Ïû(ñW„ËDÅÀÐƒÔUOv*ìU°+·|Uí¿•_ó‹úïœ/5•m3KØòu¤Òø¦û<¿ß²ü?Ëêb¯²¼£äí3Ê6	¥h°ˆ-£ì7f=ÞGûNíüØªyŠ©Í2B†ITPI' ~m~iyÁ¼áæKýl’cžfô«Ú5ýÜþE*b¬Ÿþq³ÉçÌÞs²W^VöDÝËáû½âûçô—~b®Å]Š»xoüæ¤-|•õrw¹»†0?Õç7üÊÅ_$þVZ¯2YFÝ³ÿ À+Ê?Ês‰nÂ.AôæiË±Wb®Å]Š»|¯CèêQÙšEû˜çAN„ó}=ä–å¡éçþ]ar(Í&o¨»œ_HN²¦×b®Å]Š»v*ìUá¿óJ?HZ7sølÚi9{­ÕsEÿ œ o÷#«¯c'îgÌ×	õÎ*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯˜ç8‹-{nÜ±b¯ü„PuÉIê-\ÿ ÃÄ3Uô¹Zo©ïÙ©v®Å]Š»v*ìUØ«Àÿ ?¿ã·üÂ'üœ›6ºO§âêõ_WÁ<ÿ œyŽ‘êâÐ»Õÿ š²­gFÝ'W°f½Ïv*ìUØ«üáN^X¼>‘ÿ ’±ŒÉÓ}n6£éxçäåØ´ó–+túôÿ êŸñ¶nKô‹v*ìUk¢È
°ª‘BÅ_š?˜¾Yo+ù†ÿ EaE¶¸uOõ	å	ÿ eFÅYïüâÇ›G—üéo­ÆAZÕ¼97Çü–Dþzb¯¼ñWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š µ}*×W´—O¿f¶
HÐ©Å_	~y~Cßþ]ÝµÝ²µÆ‰+~ên¦2zCqü­ü’}‰Öø1W’â®Å]Š»v*ìU^ÖÚ[¹V¼®Bª¨©$ì¨ïŠ¾Ìÿ œqÿ œzÿ ªù“ÌHX‘sßêêGíËÃ¯üŠ_ƒí3b¯ qUŽÊŠYˆ
I= «ógóKÍâÏ3jÐ5Žâvôÿ ãþêù$‰Š¦Ÿ’º7éy.ª4¦¾'÷iÿ üÿ Øf6¦U{“§ÉôNiÝ³±Wb®Å]Š»v*‚Öô˜µ{)´ûû¹Ð¡Ú´¯ÙqþR7Æ¿ådá.l'!O“oìf°¸’ÒáJËqàÊx·ã›ÐowHE=÷þpóóô>·/–nš–Ú’òŠ½ñ‚ä´<×ýhã\(}Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Vç?Éÿ +ùÊ¯¬ØG$çýÜ•Ž_ùoö|±W’k_ó„úÃÓ5›jô*JÝè7ü6*ÇOüàìü¶Ö“üÂšÿ ÉüU=Ñÿ ç	thmOR¹ŸÄD‹ûÛë«Ö|™ù'å?'—I°ëÒiy ?äÉ/.óÏ†*Î±Wb®Å^7ÿ 9Kù‚<­åY,­Ûî¨M¼têþ>_þEþëþzâ¯ƒñWÙßó‡D:V…?˜î“jOÂ2ß1 ÿ ³—Ôÿ €LUô6*ìUØ«±WËó›Úßt!OÚi®ª(ÿ âRâ¯ü‰±ëNÃûˆÁ÷%bÿ ˆ»æ&¨Ô\­0¹>‚ÍKµv*ìUØ«±Wb¯“|Ùÿ ‹ßù‰›þ&Ù¿ è¥Íô·‘?ãƒaÿ 0ÑÄFi³}EÛáúBy”·;v*ìUØ«±Wb¯ÿ œ‚aõûEî!cÿ ›M'#ïuº®aèŸóƒë]CW=„0½¤Ì×	õÎ*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯™ÿ ç7í¹izMÇòO*Á*·üËÅ^ùt°ùƒÓ'y t0VOù—˜º‘értÇÔú5ÙØ«±Wb®Å]Š»xçé®¹µ¢ÄæÍ¶—éuZŸ©”ÿ Î?-4ë¶¯Y€§ÉFQ«æôœ‹Õ3Îv*ìUØ«üÇ²úç—¯¢=¡i?ä_ï¿æ^_€ÔÃNaq/›ü¯~4íZÊøì ¸†OøWþºtÏÓÕ`À¸;ŒUv*ìUØ«ã¯ùÌÿ &5–³iæHW÷W±z2ø¶/³_õáeãÿ qWÏ67²ØÏÕ»š&Œ:†SÉ[ïÅ_¥?—þm‡Íúž»oJ]D¬À~Ë†hÿ çœªéŠ²,UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨kû5Òò5š	T«Æà2°?²ÊÝqWÌßš?ó‡ipï¨y.Q5cg1øç„ß³þ¤ßò7|Ûæ!kžUÅ­ÙMjk@Î‡ÿ RQû·ÿ `Ø«Å]Š¯Di*Š“ÐUéÞBÿ œróo›Ù]mZÆÑºÏtbŸäF{'ûãþV*úËòŸþq÷Aü½æ5úæ¨GÅs(ñ‚>ø)?âÌUê8«±W–ÿ ÎGùäyKÉ÷oq»½T‡Æ²Þ¿û=Fÿ _Ž*üýÅ^ÿ ù¡}KI“QqG¼}¿ÔŽ¨¿òSÕÿ …Í^ªvk¹ÙécBûÞ“˜Nc±Wb®Å]Š»v*ìUážžV6—©­B¿¹¹$§ilç¢Ã#æÓK’Åw:ÍL(ß{Í´ÍJãLºŠúÍÌw:ÉŽªÊy+}™®ôsò»Ï¶þ{Ð-µËz•xÌƒö%]¥þâ_ø­‘±V[Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUcºÆ¥˜€ T“° b¯ÏŸÏÏÌ¦óï™'»‰Ó­«¨ìQOÅ/ü÷~R©é¯ìb¬OÈÞSºóv³k¡YÞÝHŸå_µ$‡ü˜ãäÿ ìqWé>‰¤[èÖPi–KÂÞÚ5Š5ðUF*ŽÅ]Š»v*øCþrÃÌß¦|í=²Å§ÅºøVž´Ÿðòðÿ aŠ¢¿çtÂ–wšÿ vÈ±n›ÁzËÿ ší\¹a¥2õœ×¹îÅ]Š»v*ìUògš[–­xÃ½Ä§þ³NŠ\ßKùxèVþ]¢?zŒÓfú‹·Ãô„ó)nv*ìUØ«±Wb®Å^	ùúõÖàQÚÕ—6ºQéøº½Qõ|»ÿ 89jGé«žßèÉ÷zí™Ž#ê¬UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿ œÁÑ÷’ÍÐ6wQJO€nP~¹—|‰ùe¨1XÌz4žŸüŒù™•fq}Aš7tìUØ«±Wb®Å]Š¼óðS\‡ÞÕü<¹¶Òý.«Sõ2ŸùÇæ®v½Äàýê2_0ß¤ä^©˜s±Wb®ÅPú•’ßÚÍfÿ fhÞ3ò`Pþ¼”Mc!bŸ 2•$£7î‰úaùu­sËšn§ÞâÖoõŠŽðü±VGŠ»v*óßÏ!:ùRïO‰y]Ä>±oãêF	
¿ñ•=Hç¦*üîÅ_SÎþbˆÞãÉ·öëskSÜôˆ‡û2¯üõÅ_Vâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUJx#s(tmŠ° â¬CSü˜òn¤Åît‹2Ç©X•	ÿ ‘\1T¾?ùÇ¿"FÜ—H€Ÿ~d}Ìø«&Ð¼‹ èºNŸmjÞ1DŠà€åŠ§Ø«±Wb®Å_ÿ ÎWþb3ù”é6¯ÊÇIC³LÞ‡ÿ `Uaÿ žmüØ«Ç´]&m^òzz“¸A^‚¿´ÕûYÊ"Í>±ÓìbÓí¢³€R(QQG²Ž#4R—·wðŠDdY;v*ìUØ«±Wb®ÅR¯4y~/0iÓi³ì%_…©^,7Gÿ bßð¿YŽ|ÚòCŒSåký>}>âKK•á,LQÅz×|Þ{ºR+g±Î1~m‚õ¯Ñz‹ñÒuªä£—ìÃ7ú§û¹¿Éøÿ ÝXPû£v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«çïùËÍÁåí/ü-¦½5E?|Tïfÿ eqýßücõ?ÈÅ_b¯°?ç¿+Î›c'œoÒ“Þ¨#uˆÞKÿ =x¯üVŸË&*úSv*ìUØª]æfO¸Õ.Í µ‰åsìƒ–*üË×uyµ«ûRçûë©^gÿ YØ»Ä±WÓ—ú'è]ÒÍ…$ó}·äÿ ¼`ÔåÃýŽi3KŠEÜáC!Ê[Š»v*ìU¼UñõõÇÖ.%ŸýøìßðF¹ÐB_Ty4SDÓÇüºAÿ &Ó4™~£ïw8¾‘îN2¦×b®Å]Š»v*ìUó‡ç5á¸ó%ÂV«Æƒþ\ÿ Ã»fçN*Ôg7"úKþp«Mh<¹}zÂž½ç|BFŸñ´™ã¾‰Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¬oóË_â.ê(ûW6î‰þ½9Eÿ %b¯ÍAê[I]ÒT?"Å_YywYMkN·Ôc¥'XÐ7û±?Ø?$ÍHð’Ü%Ä-1È6;v*ìUØ«±W‚~Çnù„_ù96mt¿OÅÕê¾¯‚{ÿ 8õ-a¿‹ùZ&ÿ ‚øÓ*ÖtmÒuzökÜ÷b®Å]Š»|·ù‹¥3_½¶ìe2-:ROß*ÿ ±Wã›ÌRâˆ.—,xdCì/ùÄ_3[É«`íYtéä†ø7ïãÿ “Ž¿ì2Ö§·b®Å]Š»|ÿ 91ùn|›æy.-ÓŽŸ©¸†ƒ`Äÿ ¤EþÂFä¿ñ\‰Š¼ãË>bºòÞ£o«éíÂæÖE‘OºŸ²ßä·Ùuþ\Uú=ä_8ZyÇF¶×lî®P1ZÔ£¤‰¿ÊþUb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»yÏç¿æj~_ùv[ØØ~¸¬6«ÿ ýïú°§ï?ÖàŸ·Š¿=¥•çs$„³±©'rIÅ^½ùåNM&¿:ìµŠ
øÿ »dGîÿ äf`j²¥‡ñ=—5®ÅØ«±Wb®Å]Š»v*ìUØ«É;¼nüAfµ’0à
}‘öeÿ cöüŽÈÙ°Òåþàjqÿ xŽl]{í?ùÅ¿Î¿ñ5’ù[X÷)hŸ¹v;Í
øi¡_µüñþóödÅ_@â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅXæwæ5‡4iu‹ò†«C,„|¯üIÛö#Å_ž>ió=÷™õ)õROVêåË±íþJ¢þÊ"ü(¿ËŠ²¯É?ÊÙÿ 15èôò
ØAIn¤£ìþü›û´ÿ ƒýŒUúee”)kl‚8bUDE
ª8ª¯ú«Š«â®Å]Š»|õÿ 9‰çá¤èqyjÙ©q©7) íg‘ÿ ‘’ðÿ €“|¯ùuåÓ¯k0Z0¬*}I|8!Ê×<cÿ e•eŸm·8¥O¨sFîŠ»v*ìUØªÍÀ¶‰ço³–? +’ˆ²ÆFƒã¼ßº'Øu¨´¶ŠØl"SþqÍÍ’ïb(FE“±Wb®Å]Š»q4ÜôÅ’|Å©þ”ÔnoÆÂy]Àð¹(ÿ ÍüE
tr6m÷Ÿüãg—Î‹äm5íÜ#\·üõc$òKÓÉ1z~*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿ ÎLù¼¥æÙæ‰xÙjDÝB@Ú¬Ò#ÿ a7&ÿ RHñTGäO›8™<¿pßj²Á_~ö?ù˜¿ó×05XïÔí6Jô½“5®ÅØ«±Wb®Å]Š¼GþrÔ-å•Ïw‰ÓþƒÌÜÙéÅÖê†áÿ 8ñ(¨GÜˆÝêÿ ÍX5c`'2ölÖ»b®Å]Š»x§çöˆc¹¶Õ|2)…þkWCþÉY¿ä^lô’±N·U6É?ç|ãú/Ì³hs5!Ô¡<Aÿ ~Åñ§ü‘õÿ ás9Â}§Š»v*ìUçž–iùåÙ´øÀúüšÕûñG÷uþY—÷ð/û«óÚêÚKYZ	Ô¤±’¬¬(AiN*÷ùÅ¯ÍñåWô©%4½E‡'h¦û)'ù)7÷rÏ7û8«íÜUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±UËØl¡’êéÖ8bRîìhTrfcþN*üùüóüÔ—ó^{ØÉu½b´C·îÁþõ—ýù3|mþÂ?÷^*Ã|¹¡O¯_Å§[ŽV¥{*õw>È¿BráYF<Fƒê#JƒI´ŠÂÔq†¿Gí5?iÄÿ åfŽRâ6]ÜcÂ("ò,Š»v*ìUØ«±Wb®Å]Š­–$™)T:8*ÊÂ ƒ±V¨8ƒH"ß7þfùO,Þ™a_÷9ýÓÙÛx[ü¥ý“ûkþW,ÜáËÆ<ÝFl\É‹èú½Öw£§ÈÐÝ@áã‘NêÃ2|þG~sZ~di`¹Xµkuæ¶ÿ ïø‡ûæOù&ÿ ~Ë:¯MÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb©O™üÏaå>m_V”Ciòf=ÉT_Ûw?
'íb¯€?8¿6o25f¿ž±YÅT¶‚µž-üÒÉö¥oöebZ‡w®ßC¥éÑ´·W4I?çñ7ì®*ýüü®´üºÑ#Ó!¤—RRK™¿žJ~ÏüWØ‹þí³b¬ïv*ìUØªQÔ Ó­å½»q#I#·EU™ÉqWç7æ×Ÿæóç˜®u¹*"sÂ?±íüÿ Ýÿ ;â¯Lüò§èí=µk…¤÷Ÿb½DCìÿ ÈÖøÏù+jõY,×s²ÓB…÷½+0œ×b®Å]Š»v*’yæåm´+ùÓýUÝ”¢ÿ Ã6[„\ƒVSQ/—ô{¨^Áf63Ê‘ÿ Á°\Ý“AÓeõáß9÷|Ö*ìUØ«±Wb®ÅXoæÏ™EÑ%@vf½jx$|¿ÙðÌ<8¥ýWQ>ûÞ	äÏ,ÏæbÓD¶þòîdŽ¾ ŸþQ§'oõspê_¦6QX[Çin8Å
,h<Gÿ …ÅQ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å^iùùùZ¿˜>^{h~’µ¬Ö­þU>8Õ~õý7ýŒUð3]iBD-Õ»üŠºÁö”ý¥ÀE¤}%ä=Ûù®ÌH(—‘€&ˆv?Î•ßÓoøO±þSiób0?Ñvø²ñ6S˜íîÅ]Š»v*ò/ùÈ[Vx,.ØG•ÍÂ2ÿ É¦Í†óp5c’Eù9]jxÉÙí˜üÈxÿ l·T=?­)õ=ë5NÑØ«±Wb®ÅXÇæG—Oè“Û ¬È=X¿ÖMéþÍ9ÇþÏ/Á>4f‡_9ys^¸Ð5}VÏiíeISæ‡—Ük7NúWå0ÛyL¶ÖlM`»‰e_nCì·ùH~ÿ +MqWb®Å]Š¾Eÿ œµüž6'ÎÚLè×â¯ìÈv[õ&û2Å¿ñ›|ËŠ¾Óÿ œ`üñh´O+ëOþåmRÈÇyâQÿ <+öÿ ž?Þ¿1WÐ8«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÈÿ ó•_ž#Pwò^ƒ-`©{*™Ôÿ ¼ª’6þûù¤ýßì?%_2]‡\Uô?å‘Žfoï—×@T|	ÕSýgûr°_´¹ªÔåâ4¦Ÿ²ôÃrÝŠ»Iõo8iEEõÜQ²õN@¿üŠNRÂå±Å)rRËó,bûóÃËÖÍHškãtòY¡9pÒÈ´LBMyÿ 9dŸï-”²®êŸñ6X4‡½¬êÇrþ†Õ»þž?ëÆKò~hüß’¬ó°“ûëQþL¡¿âQÇƒò~iüß’mmùñ¡J@’;˜ëÔ”RüŒßð¹¤“1ª‹"Ó¿2|½¨0ßD§ÂBcÿ “Â:ÿ ±Êe‚C£lsÄõdˆêê*wt9AÜ·ŠPö…k®ÙÉ§ß/(d¶ ²è{2ÿ ŸÃ“„Ì†€¢ù›Î>Qºò½ëY\üH~(ä¦Î¾#ßù×öàsu ˜°éò@ÀÑPò¯šµ*ê1jÚL­Ü-PGæŽEý¸ßìº6XÖûËòkó¯MüÈ±:[ê¨õí‰ÜÅÿ <-ÿ Ÿeÿ ÊUé8«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»J<Ñæ;ÊöêÚÄË¤"¬Ç¹ý”EûO#þÊ.*øCó³ó¶ÿ ó&ø
}&ÝÕíëôzÓ4Ì¿ìcû	ûnê¼ÞÞÞK™T¼ŽBª¨©$ô
1WÛÿ óŽ?‘Kä[1¬ë·rÿ WŒÿ ºWþ-o÷sÏ5ý¯QW·â®Å]Š»v*ùgþrëó„"ÿ ô™>#ÅïOAö£µú½›þy§íIŠ¾xò”_Ìúœv†¢Ý~9˜Aü¾îßÿ .U—' ¶ÜPã4ú~RX¢Pˆ€*¨ ‚à3HM»)v»v*ìUØ«±VùÓ~-|¹,g­Ä‘Æ>a½oøŒ-™ZQrqu&¢ñ¿Ë¯yŽÆ3û2zŸò-Zaÿ &óc˜ÔK¯Â.AôöiÓ±Wb®Å]Š»I¼Ëæí;ËúúŒ¡M*±Ý¿ÔOøÛì3e°ÄgÉªy9¾só¿œî¼Õzn§øaJ¬QŽˆ¿ñ³·í·ükÇ6øñˆ
«&C3eô_üáïå[ÃêyÛQŒ©uhlÃ í5Àÿ “1ÿ ÏoòrÖ§ÔØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾gÿ œ—ÿ œy“Yy<Ûåˆù^R·vÊ7’Ÿññ
ÿ ¿¿ß±ÿ »~Úþ÷—ª«å=+U»Ñ.–îÉÚˆÎÄu÷VSðŸò‘²2ˆ"ŠA#pöÿ &~tØê¡mµ~6—=9“û¦?ëî¿Ùü?ñgìæ·.˜âìqêAÚOHGWPèAR*Ü˜DS˜·Š]Š»yïç“ÜyÕNOò!¡ÿ ‰Ê¹™¥5'T=/,ü¢¼Þd´äh²sCþÉü”ã™ÙÅÀ¸XH>•Í+¸v*ìUØ«±Wb¯š4ü¬<¿¬H±/kÞÅN€ñGÿ <ßá_ø¯†n°ÏŽ.Ÿ48$÷ßùÃoÌÎqÍä«çø“•Å¥Oìõ¸~G÷Ëÿ =²ö‡Ô¸«±Wb®ÅPšž™oª[Kc{Ëm:4r#nXQ—|ùåùAuùu«´@Òî	kYOqþùø¶/Úþ†OÚÅX—©ÜiW1ßØÈÐÜÂÁãt4e`~«îïÈoÏ;_Ì[kxVnÝ}@àÇÄ?äÛO÷S‘ÃzÖ*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|óÿ 9%ÿ 9žZ‰ü±åÙ9j²'™O÷
e[þZ[þHÿ ¯Š¾2$“S×z—ä÷åßé)Fµ©F~«~é[¤Ž?hÚŽ?øwøa×0µ¸vÜÌ¸·<žëš·f¶i’ie`‘ %™ «3ƒ‚iæ^jüó±°&>·(ÿ v5V0ârÉ?õ³7”Ÿ©Ãž¤¥åZ÷æ·®Unî\Dv1Çð%<
§Ûÿ žœ³:8£AÂ–YK™cykS±Wb®Å]Š»v*šhþdÔtfå§\Iz…cÄÿ ¬Ÿa¿àr2ˆ—6Q‘'¤ùoóêâ""×!§OV þm>›×üŸKùY‡=(?K—QÞ¹¢ë¶ZÜëN•f‹¡+Ô_´‡ýl×Î;>3ä†óO•lüËfl¯—n¨ãí#:ÿ ÆËûY,y†91‰Š/›|Õåß,Ý5­òíÕ$áqüÊâIÿ 6æâÅ‡S8(=^½Ðo#Ô´ÉžÞêä’!¡ú2ý–Ëßi~Hÿ ÎJéþuéÑK=jGh§?ñI?bOø¡¿ç—?ØUî«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅXwæOæ¦‹ù}eõÍb_Þ°>”	C$„"ÿ /óHßâ¯…ÿ 5?7õÌ{ß¬jMéÚÆO¡l„úq×¿üY/óJßð©ðâ¬*ÞÞK©¼®Bª¨©$ìªª?k}›ÿ 8ëÿ 8ê¾STó˜>®â±Bwàÿ 7ó\ÿ ÉŸõ±WÐ8«±Wb®Å]Š¼£óóóªË­3Ñµ+&³t¤Aß€èn%ÈŸ°¿îÙ?Èõ1WÁî÷ZÅÙw/qws%IûLîçþ°IßJ~_y2?*éÂÜÑ®¥£Ìã»vEÿ "1ð¯û'ý¼ÓfËÆ|¾|“åîÅ]Š»v*ìUØ«Ç?ç µQþ‡¦+oñLëÿ $âoù=›$y—_ª— óÏ$y·ü/ú@B.N%¸Ó•>%j7Å·òæfHqŠq1Ï€ÛÒ`ÿ œ……'°t+(o×y„tžn`Õù&)ùû¢þÜCä±Ÿùš2?”=ì¿4;—ÿ ÊýÐ¿ß7ðÿ Õl”—xOæ£æ¥/çöŽî­îXÿ ”¨?T‡ò‡½šÉE×üä+"ÚÀì^Zøây`Ò¥¬êûƒÕÿ 9¼Á©‘Ê–¨Ehwÿ .C$ŠÔtË£§ˆi–¢E…Ý]Mw!šáÚIXÔ³’~y“N=¦~O6¦,†©«d×¬ÉÈ¯(Ëc’ôÛ~™ÚYÅg
[[¢ÇJET*ª¿Ê1U|UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|ÿ 9ZÖçyáÓ¢Ž&Ž„ü9ÊÃÖgj~ß§$Jßêâ¯&]>å 7‚'6á¸8ž<©^<þÏ*~ÎM&œ5mÿ ¸Û—‰zðûHkßÒ~Qòÿ +ŽFXÄ¹²ŒÌy=Lÿ œ¼xßÙÇ)þhÜÇÿ 
Âoø×1%¤‘r£ª#›*²üõÐg!fYàñ.€ù$Ò7ü&Pt’èÜ5QMcüÛòÌ†‹z*|cÄ£ÊÎž}ÍƒQô·Ïròþ±¡ÝÚG{<‘Š	©eýäkÆŸ´è¹fRŒ¦¼¹c(‘oÑ5Ñ·ö÷ÀWÐ•$§OÃ6r)×DÑ·×
Á€e5pFh§x·Š]Š»v*ìUˆ~hy<ù—Jd€VòÜúûÿ <óÑä¢Ç™82p{Ÿ|õåízóËº„®žÞÕ´‹"½›ü–û.¹¸uÑË>ÙùïDƒ\± 	G#­Lr/÷±7ú¿³üñðÚÅYN*ìUØ«±V;ç¿#iÞvÒ¥ÑuTå‚ªÃí#±,g³§üØßb¯ÏÏÌßËmOòÿ U}+TZƒV†e©ÚDÿ ™‰þëlU!ÐõËÍ
ò-KM• ºƒ£¡¡ŸÄ¿e—álU÷ä_çýæºØ_”¶×"_Ž.‹(îëzÿ ÃÅö£ÿ )1W°b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUó¯üäüä¼^_Y<»åYš¡ªMp»¬Ì±ÿ =Çü,?ñ“ìªøîââIäi¥bÒ1%˜š’OZœU™þZþ^Mæ{¡qp¥4è[÷ŒvæGû¦?øÝ¿aÊá˜ù³pé9qqŸè¾Œ‚·a…BF€*¨ €4äÛ¶”5]RßJ¶’öñÂC«þ}OìáŒLJB"Ëç/=þbÞùªSL6J~AëOÛ–Ÿmÿ áSösq‹ƒ¨É”Í‡eí.Å]Š»v*ìUØ«±Wb®Å]Š¦š˜ot¡y§Èc”l{†Ñ×£©ÿ ®r2ˆ¢Ê216EùÏ¶þmµ.£Ò»Š‚XºÒ½3ûQ·ü}–ý—}>lGòvØ²ñ4ßÌ]³ó£Xê	Î6èFÌ§³Æß²Ëÿ ]|9\&`l3œÅÎÞxü»¾ò¬œ¥ýõ›$Ê+ü²/û­ÿ â_³ËâÍÆ,¢n«&#(	SQ±sKè_ÊùËCËâ=+Í|ï¬gÏÿ .¿ïB­ûßòŸìâ¯­¼³æÍ/Ík¨è·1Ý[7í!è•×íFÿ ä:òÅS|UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*§4É
%!QA$“@ ñÅ_=~mÿ ÎZiÚ(}7ÊoïwSqÖ?äøøõuþ[ýœUòO˜|É¨yŠñõ-Zw¹ºï#šŸ—ù*?eá_ÙÅVùË×þ`¼MÒ¡{›©MTŸù¥™›áÅ_k~FÎ9ÙyVÕ¸Ýkl+ËªC_Ø‡ÆOæ›þü¥^×Š»v*ìUØ«Íÿ 9¿:tßË{Ò>©2Ÿ«ÛW¯ü[/òB¿ðOöü•_ùŸÌú‡šuµmVC=ÝÃrbáQöQ>Ê"â¯dü¥ü¶}?Kj‹KÉîã=cSÝ¿â×ÿ „Oò¹*k5¯Ò–5¹zf`¹®Å]Š»v*ìUØ«±WËÿ ˜Þ`ý=­Ü]!¬*Þœg·øyg<¤ÿ e›ÌPáˆ—,¸¥l—Ë?’³kºd:›]`Yc1–kEn|ÇÛ§?³”ÏR"i¶s!mËù¬ƒû»‹R=ÙÁÿ “G ÕGÍ'K/$,ß‘ž`ì˜ýYün«’üÌXþZHOùRþdÿ |/üOù«æaÞËÉäV¿'Ú6ñÿ ­!ÿ °~f)ü´“/ùÇíEÚ—wpF¾1†s÷8‡ uqèÌiK%Ò!4«j5ôòÜ°ì)Ÿö#œŸòW)–¬ôÑÒŽ¬‹YòÎ›¡è„zu¼pªN	QV?}©”þÉ²¨d2³Õ²xÄbióUˆ&â0:ó_×›‡RýK]€®*Þ*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¸šnqWææW˜˜¼É©jµä·2²¨‘É>8«Ü?)t•²òåººïqÊW¿3ðÁB#Í>¢W?s¶ÓÆ¢Ö¹ùG jÄ¸„ÛHMK@xvÿ }Ñ¢ÿ je5–ž'Éƒj_ó·i¾ŸyžÒ«%?Ù'­_øÊŽ¬u4´§¡c7“¾e€¶ÂU´’&ÿ C2¿ü.\5=ZN	‰DÞC×¢n-§Üš,LÃïEa–‘=CŽ]ÅKü®VŸ£îÿ äDŸóN1ÞŽÜ‡ó‰>‰}6r)$-ÄžÄ~Ã³O‹$òbEs}ùW¯c@·byn=Ú› ?ä—¦Ù§ÔC†^÷m‚|QeÙŽä;v*ìUØ«±Wƒþrùé—GZ³_ôK†¬ ~Ä‡©ÿ V_µþ¿?³ðf×O—ˆQæêõ¸MŽJŸ_œrþ]jÿ éE›G»!ncñ?±sÿ <µþüáû\8æ8¾,¯a½….­d†UŽ¦ªÊÃ’²Ÿ|UŠ»v*ìUŠ~c~\é~~ÒßIÕ’ Õ¢•GÇö–#ÿ _³"â¯‚¿3+5oËÍDØj©Ê&©†u»•|Wù_ùãûIÿ Ø«²¼šÊd¹µvŠhØ2:HèÊËÐâ¯¬ÿ %?ç+à¿èÞuu†àQc½èísþúø·û¯çôÿ iWÒ±J²¨t!•€ ƒPAÅU1Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨MOTµÒ­ÞöþT‚Þ!Éä‘‚ªò˜â¯’?;ç*§Ö½MÉÌÐXš¬—{¬²ëíCùß?üWûJ¾mÅYçåçå×™nîùE§»þÓÓn1Íes6aë9°™ÿ Uô5•”60¥­ªáŒqUQ@j$I6]¨ 

Ø<3óÛÌïq|š$Mû›uY$ë#
­Õ‰—üd|ÚiaBûÝf¦vk¹åYšá»v*ìUØ«±Wb®Å]Š»v*ìUØª}äß3KåÍJ-B:ðSI~Ò¶¿wØÿ /+É1MŸ	·ÕAƒ
ƒPzÑt§smÔmè²DâŒ¬Ì§5¸R/bñŸ=þIÉ	kß/ñnZÜŸˆÆ?Þòãþ_S6Xµ7´v]5o’ÍÀæ9T«®Ä0¡œá'Só¦¯å+±¡ÜÉk8ëÀìÃùdCðH¿äºâ¯§.¿ç2¬îZyÂ>³ -ÿ *H?¼Oùçêÿ ª¸«èo/yŸLó°½Ñîb»€þÔLžÍü­þK|XªkŠ»v*ìUØ«±Wb®Å]Š»v*ìUNyãY˜"(©f  =Î*ñŸÌ/ùÊ¯+ùa^ßLsªÞŠ€°Ýþ]ÏØÿ ‘>®*ùgó'óÓÌ¾~c¡?£bME¬5Hÿ ç§íÌßñ•›üž8«ÎñW¤~UþEëß˜’‡´O«iÀÑîå&ÝV%ë;ÿ ’ŸìÝ1WÚß–”º'ååŸÕ´ˆùO k‡¡’O›~Ê,iðÄ±VmŠ»v*ìUØ«Ä?;?ç%´ï%,šNŒRóZ¡†±@âænEÿ |/üôáûJ¾-×µëÿ 0ÞÉ¨ês=ÅÜÍVw5$ÿ þU_…g{åoåWèîÆ²Ÿé=b…¿ÝåÈ?ß¿ÊŸî¯Úýï÷zÜú‹Ú.Ã
ÞOTÌ=Ø«±Wb®Å]Š»v*Ã5¼ÕúGqRêê±Eâ*?y'ûý¯÷ãG™:||Rþ«ž|1÷¾~òÖ‡.½¨A¦A³LàþUþÁ>,ÚÎ\"Ý\#Äiõ}­´v±%¼
(”"(èG_ fˆ›6ï ¡J˜ìUØ«±Wb®ÅX×æMØ´òíô‡¼%?àÈ‹þ7Ëð˜hÎj%ó¯“­>¹­X[uõn Oø'UÍÓ§~â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š±ŸÌÍ{ô–µ-P<²²¯ÇŒòP®*üÔF»³Uõîd–ÑYÇö!c_’€ƒõf‚FÍ»ØŠˆÈ²v*ìUØ«±WŒ~}ùs„kq
ýÌ½:Š´MîJó_õc\Ùi'·®ÕC~$›òGÌÃLÕN1¤7 (¯iû¯ø?Š?õÙ2ÍL8£ÍkÓÏ„×óŸ@f¥Ú»v*ìUØ«±T>£§Á¨ÛÉgv‚H%R¬§¸ÿ ?²ß³’ŒŒM†2ˆ¢ùŸÏžKŸÊ·ÆÞJµ¼•0ÉÙ–½üXŸe×ýŸífëA1nŸ&3OZÿ œpÿ œƒ>S‘<·æ'?¢%oÜÌwú»Ñ¿åÙÏÚÿ }7Çöyå­O³¢•&A$d2°j=Æ*©Š»v*ìU#ów“ôÏ7XI¥kP‰í¤ìv*eã´Ž¿ÍŠ¾$üåÿ œzÕ¿/dkÛnWš3†uWö.U~Çüeþéÿ ÈoÝâ¯"Å^¯ùOÿ 9¯y ¥¡o®é@ŠÛÊMTË¼bÿ Wâ‹üŒUöåÇçG—|ÿ ý8KºU­¥¢Ê¾?Iü¸¹â¬óv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼§óCþr3ËžEW¶Yþ¦µVâåâ_‰!ÿ Wâ—þ+Å_~f~qkß˜WõY¸Z¡&;hê"_ö?îÇÿ ‹$äßìqV	Š½CòÓò¡õrºž°…l¶dì™{ŽÑÄ¿g0ógáØ}N^[žOv†…(”" 
ª¢€ÑT€f¬›v`Rì	v*ù£ój'Ì·‚N¤ÆAö(”ÍÖ¤:lßQaÙ{K±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»}+äŸÌúÊÚÌ]¢Ü¤1£$Ÿ,T…çÅòÿ }³fŸ.M;ly¢@ÌóÉv*Æ¼Ùù{¥y˜s»…Í(&MŸý—ìÈ¿ëÿ °á—ãÌ`Ñ“›ÄüßùQªù{”ñ©º³™#¨ÿ ‹cÝ“ýoŠ?òóe<fë²a0aÐ™h~aÔ4y¥\Kk8ý¸œ¡ÿ …Å^Õäÿ ùÌ?3é!bÖb‡SˆmVýÔ´ÿ Œ‘Oï‡{O•ÿ ç.ü«Q5>)ëë'$ÿ ‘zŸðè˜«Ôt/>h:ø®•¨[]{G*³ÀW—ü.*Ÿb®Å]Š»v*ìU©kV:Zzº…ÄVéã+ªør¸«Î<Ëÿ 93ä}úø¼”~Åª™kÿ =?ä®*ñï6ÿ ÎkÝÌ/-ië=%ºnMÿ ""â«ÿ #dÅ^çÍ?2yÉ‰Öï¥ž:ÔDÇÊøÇÿ Š±<U’y7ò÷\óÇÕ4+I.XÉ€¢%ß²·îãÿ dØ«êOÊïùÄ=7H)æ×[û¡B-Ò¢?åŸ…çÿ „ü—Å_C[[EkÁ¬q Q@
 vU]—VÅ]Š»v*ù»Îú?”-þ¹r–ÐŠÓ‘ø˜ÙŠ1ñÈßä¢â¯“?7ç+õ/1‰4Ï+‡ÓôóUi«IäÅÞtÿ S÷Ÿñgìb¯Ò4{½jåm,cig~Ãñfcð¨ÿ +#)îYF$ìõùyùWoåÀ··ÜgÔ:ƒO†?øÇâÿ ñoüó>¯6£‹aô»,X8w<Ùöb9nÅ]Š»v*ìUØ«±W3˜Ð¤â¯™¿2üáþ&ÕX‰ú¬5Žâ+ñIÿ =>×ú¼3u‡ §M—'·¡~EyOêöòk×ûÉë5ì€üoþÍÇùçü²f&«'ð‡+Møž¯˜{±Wb®Å]Š»v*Á:¯ßËsFzÏ$q˜a/üÊÌ­(õ8º“éygäfš5;hðP.ãøÇûÿ ù—›wTýÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼Wþrã\w’%¶{q#äÖþLb¯Ž¿.tã¨y‚ÊÚa!¯„¾?ñ«)¨’Ûˆ\ƒê<Ñ»§b®Å]Š»v*–ùC‹]ÓçÓgÙfB Ò¼[ª?ûâÙf9ðkœ8…>V½²¸Ò®ÞÞ`c¸·r§Ù”þÉÿ ˆæð”Š/¦|ƒæ´ó6—åG®¿Ê;8ø}±ñÿ ²áû9¥Í€»Œ98Ã"Ê[Š»v*ìUØªWæO.Zù†Íì/V¨ÛƒÝ[ö]?Êf9˜s€˜¢ù«Î>P»òÅá´¹C¼r²ëâ=ÿ g78ò	‹¢p04^¿ùÿ 9%7”==ÌlÓhõ)~ÓÛ×·Œ–ÿ ä}¸¿Ýï¼±­öf¨ÛjvñÞÙH“[Ì¡ã‘e`iXb¨¬UØ«±WbªS@“£E*‡F2°{Š¾küÞÿ œF·ÔêžJ+o1«5›FÇþ]äÿ tÿ Æ'ý×ò´X«å]sA¿ÐnšÃT‚Kk¨þÒH¥HþÏò±T-µÔ¶’¬öîc•*ÊH ŽêÃ{åçüå¿˜¼¼Ó\QªÚ-'<fþ3S÷ŸóÕyÅ˜«é#ÎCùGÍác·»·mþè¹¤o_b})?çœ˜«Ò•ƒ A¨;‚1UØ«±Wb®Å]Š»v*ìUØ«±U+‹˜íãifeŽ5,Äü¦8«È¼õÿ 9Iå,†Öc©Ý®Þ¶é_òîî¿ä_«þ®*ù«óþroÍ>qçmŸ£l[oJØÄÅ·Þ?ûI?ÈÅ^EŠ¶vqW²~\þN0dÔüÀ»
2[Ùiÿ Õÿ |ÿ ÈÏÚ°3j:EÎÃ§ë'±M‡LÖ»bª7wYD×R,Q/Wv
£æÍ¶vI›Í¼Ëùë§Ù†‹GŒÝK½ª‘ƒÿ '$ÿ ’ëæl4¤ýN$õ@rxÿ š<ÏwæK³}}ÇÔ ((Šñ‹}¬ØBƒ9™)6Mƒ±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Éüµù‡«ùx…³˜´ýÓ'Ä”ÿ $îÿ Ø2åSÅóm†SOZò—ç^ª•·Ô×êwƒ‘5ˆ¿oíG_òþÿ ~æM)·s±êAç³Ñ‘ÖE„2°¨#pAÌ")Ë»o°6þQé:õg€}RèïÎ08±ÿ ‹"û'ý‡þnY•PcÏÔâäÓ‰rô¼cÌÿ —Ç—9=Ô>¥¸ÿ wEñ'û/Ûþz*“›fŒù:ùâ”9±l¹©Ø«`Ó|Ué_˜^bÒ)ú?S¼€'p?à9qÅYE§üäwŸm(#Õ¥`?#ù9b©Äó–}ŒQ¯"“ýkxÿ ãT\U{ÎZyðŠ˜G¸?æœU-»ÿ œœóý×]LÆ?È†!ÿ 2±V;ª~où¿T¨»ÕïYOU2/üeb·7s]9–áÚIVbIûÎ*¡ŠªEÌâ8Ágc@äâ¯Kòoüã—œ¼ÓÅâ²6–íþíºýÐ§ú‡÷íþÆ,Uô¿çô- ­Ï˜æ}Nq¿¦µŽ~J}Y?àÓþ1â¯xÒ´‹="Ýlôèc··eŽ%
£ä«Š£1Wb®Å]Š±Ÿ8~dyÉñuÛØ­*šÈßêBœ¥øUó§æüælÓ´òu·¤GÖn -óŽÑç£?ücÅ_9yƒÌº—˜îö¯q%ÝËþÔŒXÿ ª¿Ê¿ä®*Ê¼›ù?©k¼.o?Ñ,˜É‡ÆÀŠN?øÝøÿ ‘Ï1²j<Ë“—¹î^[ò®ŸåÈ>¯§Drs»¹ä~ÿ ñå\ÕÏ!Ÿ7eb“l­±Ø«±Wb®Å]Š»v*ìUæ>xýkúÍ¿Òn÷¤Ò3û?ëKÿ &ÿ ×\ÎÓb¿Qpµ9+ÒQäo*Éæ}J;¨ˆ|r·ò ?ÿ Xý”ÿ /ŽgdŸ ·8Í>¢¶·ŽÚ$‚jTt 
(Í!7»º¶TÀ—b®Å]Š»v*ìUå_óWÜ4ûK>òÌÒÈµãÿ 3ó?H7%ÁÕ€Aÿ Î$ébûÏ0LE~«óÂúó;6N¹÷n*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾Xÿ œàÖHM#JS±3NÃåÂ8ÿ âRâ¯üˆ°[mîWÐ™Oƒ1Xÿ â&bjEÊÓ“ßóRí]Š»v*ìUØ«±W~yù4¿0Ú¯@àÂÅ/üËoùçþVlt¹?„ºýN?â/òÃÎ‡Ë:õÛý
â‰7]ºð—þy·ü'<ÉÍŒ8ørpÒªÁ…TÔ„f•Ü;v*ìUØ«±Wb©o˜|»gæF±¿Nq·B>ÒžÏ~ËúëáË!3a®p_:y×òþûÊ³RqêÚ1¤s( qû“ÿ Ù·Ç”Llêrb0æÈ(=uŸË›…ŠúÎ–ÍY-\í¿W…¿Ý2Â7í¦\Ôû_òëóWBóý ºÑ¦U ËÐKüdþ7NQÿ •Š³UØ«±Wb®ÅX×¿.ô?;[}O]µK…aþË§üb•~4ÿ ˆâ¯–ÿ 1¿ç5m'ß•%ý!l7ôd¢Î£Øü1Mÿ $›þ+Å^ªézMÃZjÉmp‡âŽE*Ãý‹ïŠ ±Vaå/ÍÏ4ùN‰£j3Åô‰›œò&^qÿ Ââ¯bò×üæ®±jzí„7kÝác}ÇÖO»†*ôÍþsÉ÷Àåº²nüãæ¿ðP4ÿ $ñVs¦þ{ù#Q Ã¬Z­{Jþ—üŸôñVKgæýðkk-’doø‹b©‚_Û½8Ê†½(Àâ«_RµŒUæG»Š¥·¾zÐlk½FÒ?žx×þ$ø«Õç!<‹¦fÕ ŽÐò–¿ò!dÅX&½ÿ 9›åk*¦›ouzã¡â±¡ÿ díêÉ,UåÞfÿ œÎó-ø1èöÖöz1¬²öOÂ/ù#Š¼{Ìÿ ˜÷šŸž¹}=ØêÜðêD?tŸìSc¸«±TÏAòýî»p,ôøÌ²‘]ºüÎÝ?ÊÈÊB"Ë(ÄÈÐ{ß¿*ìüµK»’./öøÈøSþ0ƒÿ 'âþ^-^]AžÃévx°îy³¬ÄrŠ¼ëÎ_œÖ96Ú`[Û‘±!¿v¿ì×ûÃþJÁæf=1–çg& †ïóšu0ÍëêS4„}•è«þ¢…ÊþoÚÍ” #°uò™—4£&Áè^EüˆógË§Y´v­ÿ »Žž*[ã“þx¤˜«.óÿ üâ˜ü¯bº‹¦¨ª¤Î+ŽÑâ?ÕýçüWŠ¼D‚Äb«qWb®Å]Š»v*ìUØ«±Wb¯Gü©üŽ×?1gj†ßM’]È¾ÒÅþþ“ü”ÿ fÉŠ¾ÎÐÿ #|§¥èñè/aÔ+»<èGsö¥2ý¥sÿ ñà¿
b¯4ó¿üá®‡¨†ŸËwióÄrVX¿ß§üŸêâ¯œ¼ÿ ù'æ#ú­«5¨4üq›®ñÿ ÏU`X«.ò_æF¥å‡ÄLÖ„ï“Oùåþûoõ~×í.S“Ÿ6ìyLûå/9Øy¢ßë,C¯Û‰¨ùCù•×þ%ðæ§&#»´Ç”O’{•6»aÞeü¨Ñ5ÊÉéýZàÿ »!¢×ýxéé·ü
¿ùy“D£ý'zxËÉåÞbü‘Ö4âÒX½„oðü/Ox›þeÉ#fl51—?K‡=<‡/S¾°¸±•­îãh¥CFW}ÁÌ mÆ"¸PìUØªw y7Vóür­žàÖ”B	ÿ ëŠ²»oùÇŸ=Üý"q_ç(Ÿòq×doüâ_ž¯)êÛÁm_÷ìëÿ 2}lU˜èßó„z¤´mWT‚o/ã'ÕñW¢ù{þpëÊ:}Q{›÷C¸û¿ü•Å^­å¯Ëß/ùe@Ñl-íOó"L¦²ø,U‘b®Å]Š¡îï`³C-Ì‹¬ì}íŠ°o0þ~y+Bä.µH$uØ¤ÌÕÿ žOølUåžgÿ œÖÒ­ÃG ió]?@ó°‰~|SÕ‘¿äž*ñŸ8ÎOyÓÌ¢K¡anß±h8ÆoŠø1W—K-ÅôÆIÍ<‡rjÌÄÿ Ã6*Í¼µù7¬êô’é~¥ý©GÇþÆŸþFúy=DcæäC¥äõ¯)þWi\"dO¬]÷l´$ø­>Äòsþ,Ìš‰KÉÏ†ÇÍ—æ3ìUØ«±Wb®Å]Š»v*ìU#ó—šíü±`÷×ý˜Ó»¹û+þ¯í;/ùYn,|fš²äàùŽúúï\¼k™Éšêáªh7$öP>ìÝ "9&Eôgå·’Ç–4à’ôÉèóÖ†›F=£ÿ ‰òýž9¨Ï—Œù;\8ø›,Ìw!Ø«±Wb®Å]Š»v*ðÏùÈö}FÒËöb€Éô»?òesi¤›uš£½=þp‹Iõ5-WS#û˜"„øÈí!ÿ ¨|Ípß]b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾%ÿ œËÔÏœ!µ¯ÃogÓÝšIàSKç­HŽþä˜Ä€ü½Foøšf¿Vy?H9—°f¹Ø;v*ìUØ«±WbªW–‘^Bö×
)T£©î£ Ñ°‚,Q|¿ç¯)ÍåEìœV#ñÄÿ Ì„ü?ì×ì¿ùäñÍÞ<œbÝ.Hpz‡ä·žþ»Ð/X™áZÀÄý¤î¯Q~ÏüWü¾žajqW¨9ºl·é/UÌ9Ø«±Wb®Å]Š»Q¼³†ö¶ºE’XTòÂ	„Åâ¾zü•žÌ½î‚ÐÖ¦Û_øÇþý_ò½ÿ ŒŸk6xµ í'[—NFáæú>³}¡Ý­î4–×Q…Ð•`s5Ã}5ùaÿ 9Œ%‡b&”òüg·_øœò'}-åÿ 3ižcµÚ5ÌWvçöâ`Àåoäoò[âÅSLUØ«±Wb®ÅR?4y'Eó\U×,â»·5ø—þ1È?yû\UàÞsÿ œ-Ó.ËMå›×´s¸†àz‰òYŒ©þËÖÅ^#æ¯ùÆÏ;yw“½‰»…Ý–‡Õò-ÿ $±W›ÞXÏe!‚ê7†Uê®¥Hÿ bØªv*ìU°iŠµŠ»v*ìUØ«±VÀ®Ã®*ô¿&þJßj…nuzÚZšýë±?Ý³ø¿â¿ÚÌLš‘†îV=9–çg¶h~_²Ð­Å¦Š!¹¦äŸæwo‰ÛýlÖNffË²„v	†AšQÔmôÛw¼¼qŽLÍÐóû+ö›ì®J124ÊB"ËÁ?0?6®µúÙé¥­ì7z<Ÿñ¯ÙOø¯þŸìíq`ÜýN¯.s=‡Òó¬Êqž‘ùcùæ/ÌYEõ}>´k©TÛ¯¤>ÔÍþ§û'LUõŸåÏüã_•ü˜áâý!¨.þ½Àÿ AýÜðòÅ˜«Ö  Pl1VñWšþbÿ Î?y_Ï%®.àúµûÇÍ½Éÿ ‹û¹ç¢óÿ /|çç?ùÃ¿3i%¥Ðä‹S€tPDRÓýIO¥ÿ 7ûUãÞ`òN·åÖ)¬XÜZS¼‘²©ÿ UÈàßìqT‹v*ìUØ«±Tn›¤^j’z|\Êb$.ßð(	Å^£å?ùÅ¿:y€«Mjº|«Ý7ÿ "Wœßð˜«ß¼ÿ 8‹åÍ–ë\fÕnW~.8@üaÞÏY?ÈÅ^åmm´k
±Æ€U (²ªýœU[v*²XÖU) XP‚*8«Áÿ 5çôo2	/ü·ÇMÔO¦£÷xÇ÷ëEðÿ ÅX«ä?7ù/Uò…óéšÝ»[Î½+Ñ‡óÆÿ fDÿ )qT‘¬]h×I}c!Žxú0§Ò¬¿´§#(‰
)ÃèßËï?Ûù²ØÔïbÕ·üdŽ¿î¶ÿ „û-û,úŒØxô]¶¼Öe™Žä;v*†Ô4»]E=+Øc;,Š—,”dcÉŒ¢%Í‚ë?‘úè&ÏÔ´’›pnk_Iy7ü‰™QÕHsÝÆ–š'–Ì'Vü…Õm¹5„Ñ](ècsòVåß.dÇUÏgZiLGRò»¦±6S K"úŠ>rEÍ?á³"9#.E ãæùØõËÓ­3ÎÚæ•A§êVàtô¦tÿ ˆ6*Êì¿ç!üùe´Z¼íÿ Iÿ 'QñVAkÿ 9kç¸h$¸‚Z<	ÿ 2ý<U0þs'Î‰ö£±oœ/ÿ Ì¸ªÿ úÏ9ÿ ¾l?äLŸõ_P›þsÎ¯^"Í?Õ„íÿ #â©M÷üåGŸ®…ùañ\øš>*Æõ?Îß:j`­Î±wÄõÈcòGÓÅX–¡ª]j/êÞM$ïüÒ1c÷¾*»NÑï57ô¬`’wðKSçÇ¦@æ	äËtÉ¿0ê4g‰m£a^S0òM=IWý’.Q-DC|pH³òÎ>©ró6ß@"›lÿ òO1e«=“/yz‰åm3C^:m´pöäXÿ ­+r‘¿Ù6bK$¥Ì¹QÆ#É4ÊÛŠ»v*ìUØ«±Wb®Å]Š»CêZ¾›o%åÛˆà‰y3ÃúŸ²«ûMðä£#AŒ¤",¾góç'óUó\=VÝ*°Ç]•kÔÿ –ÿ iÛý‡Ù\ÝbÆ )ÓäÈfmŸ~M~^#_Ôã²0ßþ3‘ÿ &¿àÿ ßm˜šœßÂ?Îr´ø¿ˆ½‹5ÎÁØ«±Wb®Å]Š»v*ìUóOæÝø½óÑCÉ"+ÿ bªÈÎyºÀ*!Óç7"ú‡þpÃEú§•®u7wmCâ±ª ÿ ‡õ2ö‡Ð8«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾ÿ œ«•ŸÏ÷ÀôT·åéFqVAù h“°ênœÉ8³Y«æ–—‘z^`¹®Å]Š»v*ìUØ«±V5çÿ &Gæ­=­¶[˜êÐ¹ìßÊÈ“ì·üìåørðŒØøÃænt›¿Ú†êÚO“+¡ÿ ‰+ÜìC¨ÜÒ—Þw‹Ív"m’î*,È;Î¿ä?ü/Øÿ +4Ù±p'o‡/óeC{±Wb®Å]Š»v*ìUŠyÇòÛKó82L¾ßiã—M½Aþí_õ¾?åuÌŒyÌ|˜DÞ+æÏÊÍ_ËÜ¦1ýfÔoêÄ+Aÿ 'ÛŽŸÍýßùy²Çž3uóÃ($ž[ó^©å›‘}¢ÝKi8ý¨ØŠåqÑ×ü—ËÚýäoùÌýFÌ-¿š­ñÆkzG'û(îd?êú«ß<Ÿùõäÿ 5ñKB8§o÷MÇîž¿ÊŸÿ Ï'|Uè
Á€ ÔÁÅWb®Å]Š»v*—jþ^Óµ˜ýNÖ¨ÎÜf\}Î`×üãO‘5_‰ôÕÿ šxÿ á½?øLU…ê_ó…žWœ–³»½ƒØ´n?Õ¿á±V=yÿ 8;ÞÓYeö{`â3.*—¿üàõè±>öì?ækb­§üàíÙ§-f!ãKv?ó9qTD¿ó†ºV‘	ºÖõñ+ÕŒKÿ ÁË3b¬'\Ð(|®J‹ÝC\¸_Ø·dHëï7§Ãÿ ä—yþ¹ç:@`Ð4‹]6ær×3Èë¢È¿óÊñV»qV{åÉÝ_Y¤·Kõ+cûRŒòaûò3‡ù<³&¢1ór!‚Rò{•?.´Ÿ- öÑú—#ýÝ&ïþÃöcÿ žkþ·,×dÏ)»xD6PÞìUBúúîéÄpÄ¥™@ÄÈÐc#BËçÌ?Ì+5ÜpŽ±ØDwsÿ Ëþ_ü›û+ûNÛœX„›©Ë”Ì±KkinåX Rò¹
ª¢¤“²ª¨ï—´>­ü•ÿ œOŠÝcÖ|ì‚IM;*ü+áõ¢?¼oø¥~÷ç?±Š¾›‚Þ;xÖT$j UP  vUÅUqWb®Å]Š»Y",ŠUÀ*v ŠƒŠ±}_ò¯Êº¹/}¥YÊç«P7ü€ø«½ÿ œdòÙätÀ‡þ+–dü\Uÿ BŸäùb—þ’%ÿ šñU{ùÅ By=Ÿýk‰¿„£d:oä’ôâßG´¨è^1!ÿ ’Þ¦*Ëì´ëký+H’ÇìÆ¡Gü
â¨œUØ«±Wb®Å]Š»b¿˜—GŸtæÓ5˜¹Ìr­‘7óÄÿ ñ%ûûx«à¿ÍOÊíOòïUm7Qâz´¨¢JŸÌ¿Èéþìö?Ôàì«Ñ5»ò=BÍ¸ËTxÑ•¿Éqð¶FQYFF&Ãê+yŽ1iñj6Ûe­J8ûq·ú¿ðËÅÿ k4™!ÀiÜãŸ´Û+lv*ìUØ«±Wb¨kí.Òüq¼†9Ôv‘‡ü89!29& óH/,|¹xÜ¥±Œø¬´cî…£hÏ1Õ¨à‰è“^~Fù~vå¯ ðŽ@äòË–T¼šÎ–(	ÿ çô–¹¹¸SþQFýH™?Ížæ•é|Ÿó1“û½@¨÷†¿ó52_œòûQùO5Ÿô/þ®_ôïÿ _ðþsËíGå<þÄDóvËOZùÛÇŒa[>Íù'òžhø¿ ´Qýä÷L}™ ÿ “G"ug¹ÒŽôÒËò_Ëvâ’@óŸ$jÿ É#þYÔÈ³h„òÃÈºŠ…‚ÆÇ¡dßðrrøl¨æ‘êÚ1DtOB€ª(@2¢m°
v)v*ìUØ«±Wb®Å]Š»v*ìUØ«±U“L#K+ff4 ¤œ Z	§Îß™ß˜ækªZ’º|-ð
S›÷kÆŸÊ¹·Ã‡€IÔæËÆ¢­ù[ùp|Ç7×¯Ô>#Ó§¨ÃýÖ§ùßþÃí|H3æà>¤áÅÆlý/¡Q U ( l ÍCµo»v*ìUØ«±Wb®Å]Š¾ZüÃ²–ËÌÑÍ³4ï ÿ VCêÇÿ ë›ÌFâ&AR/®ç|åg©ùWôtKÍ6Gæ½Ù%f™&ÿ ‚f‰¿ãùK–µ½ãv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾ÿ œ¸±Þzž@)ëÛÁ'Ü¾—üÊÅQ¿ó×aôÛ«^ñÎþBÿ Ì¬ÖêÆáØéÅêy€ç;v*ìUØ«±Wb®Å]Š¼Ëóòñµxÿ LiË[¸–’ ë"ÚñdðÉþª«gióW¤¸ZŒWêò¿™nüµz·ögâ]™F_ÚÇ¿ü+fÂp\LÄØ}7å¯1Úù†É/ìÚ¨Û2÷Vý¤oqÿ 7f—$q	‰‹	¦VØìUØ«±Wb®Å]Š»v*Ä¼Ëù]¢kÄË,>„çýÙŸõ—û·ÿ dœ¿ÊÌˆj%7x#'—kÿ ‘šµ/§2^Åà>§úŽxÀHÍþFgCSÏÒáOM!ËÔÀ5.ëN”Á{Á'^2)SOöY”<œbæŸycó?Ì¾W Ñõ‹tY?äLœâÿ „Â‡ªùþs/ÍvMN[äISÿ ÁD}?ù#Š½Gÿ œÛÒ%ô¦™swô]$òSêø«3Ó¿ç,|‰wORêkr{KŸó(J¸«#µüüò=Ð¬zÅ¨ÿ ]ŠÉÀ˜ªaæ÷“ßeÖ¬?é&?ù¯U›óWÊpÓÔÖ,¾71ÍxªÎ¯%Ãöõ›þ¬èßñØªK¨ÎKyÈ|Z¢È|#ŽWÿ ˆÇLU‹jßó™>O´ZGwtÝ¸Ä¨?ä«£Âb¬\ÿ œÞªº>’‹à×–ÿ ’q*ÉÜUæÞaÿ œ¤óÎ²8-âÙ¡ý›XÂÉGõ%ÿ ’˜«Ìõ]rÿ X—ë•Ä·Rÿ <ÎÎßðN[Fh~MÕµÂ?G[I"NtâŸò5øÇÿ •Ë 2Î02äôO/þAJådÖn/S;Ÿ—¨ãŠÀK˜“ÕŽŽ\4§«Ó<¹ä'ËÊ>¡‰GY[âíO¶ßg—ò§ÿ '0çšSææCcÉ=Ê[]Š»v*ðÎŸ<6¡tt;Fÿ E·?½§íH?gýHºÆN_Ê™µÓbáyº½F^#Aæ–öòO Š ZF *RIé¶f8¶çÿ çaò]ºkºâ	5¹–ª¬Êa?âÿ ÷ìŸ³ýÜ¶Ò*÷\UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š°ÏÍ_Ë{?Ì]ìš…íå#xåàõfEý¤Å_ºÖs¢ÞÍ¦_¡ŽæÚFŽE=™M*Ïÿ #¼Îl5&ÒeoÜÞ
¯´Š*¿ðiÉÖôóSü×/M:5üç½f©Ú;v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØªÉçŽÝi˜$h31  u$áÐM<ó;ó>O09Ó´âSOC¹èe#ö›Â1þëOöoñqDÛaÃÁ¹ú^lÜ{¥ç9”â¾‚ü‡åÐdW$ˆî]V½‡žŸðNÙªÕý_g¥ú~/FÌ71Ø«±Wb®Å]Š»v*ìUØ«Ì?:üÚ•°ÖìÖ³Û)¨´c~_óÇâÿ aÿ ×3´ÙkÒ\-N;õ—~^yöÿ ÈºÄÞšjñü.„ü2!þòÿ %¿á‹þÎlÝkô3ÈþsÓüç¥C­iOÎ	†àý¤aöâ~Ë§üÝöqVAŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾7ÿ œ×Ó}/0Ø_ýõ™B}ã‘ÿ ê¶*Ä¿çîÕ'¿µ'ãt‰ÀöBêßòusV6ÎÒËÚsZì]Š»v*ìUØ«±Wb®Å]Š¼OókòÄÛ3ëšJþå‰iâ²OYcÿ ŠÛöÓö?gàþïg§Ï~’ësá­Ã	òG.¼©yõ‹Ž K;2ƒø:þÃÿ Æ¹““˜¢ããÈ`l>“ÐµÛMvÑ/ìœ/ôGÚG_Ùuÿ ?‡4Ó¢íá1!afìUØ«±Wb®Å]Š»v*ìUFîÊÈÌQ¤±ªêOûÛ‘˜˜ƒÍˆjÿ “þ^ÔIe…­œš–Šÿ Â78—ýŒy“L‡›D´ñ,CSÿ œ}o‰´ëÐ|T§ß"ÿ &³ jÇPã/qc7ÿ ’^b¶jEWÆ9 ÿ “ÞŽ\51-GO ‘Ý~_kö­ÂK‚|R2ãþ
.k–±=CQÇ!Ñ,»Ð¯ìÿ Þ›i¢ÿ ^6ñ!–	ÂŠŠlzáCXª´²Îi3ŸòA8-S8|Ÿ¬ÍýÕËÜBôÿ ˆäLÀêÌ@ž‰­§åG™.€d³eSüî‰ÿ #+ÿ Âåg<GVcFCcù«ÊAºžTõ ³°ú8ªÿ ÉL¨ê¢96,‹'Ó 4ØEo®f¿È1÷~ù¿áò‰jÏ@Ý(êY–“ù¡i;ÚYÄùœzô4¼ÙØæ<³J]\ˆáŒz2¥¹Ø«±Wb®Å]Š±ŸÌ6GåÍ.Y„Š·r)XË¹ßûºóoÙÿ ‚Ëðãã>M²p7ËÌÅ‰'©ÍÓ§}5ÿ 8‡ùHš„íçMM+»˜ìÕ†Í þòãþy}ˆÿ âÏ‹íGŠ¾¹Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯Œÿ ç3<œšn½k¯À¼WRˆ¬”ÿ ~CÅy²…âÿ ‘x«À´½FM:êØvx$Yæ§ÀEŠH4mõG—<Ïcæ+aw§Èvä½	ý™öOü+~ÎhçŒÀÑwPÈ&,&¹[c±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨mKS¶Ó {»Ù(cfoóø›ùU~&ÉF&FƒHDY|õù…ùuæiÖÞ°éÀŽ)ûMOÚ—þhûþWÛÍ¶,"ÖuYsÿ Uù=ù5©~dê¸0éÐ‘õ‹’6Qþûýù;~Ê²‡2\uÏ?*YySÍ·º.–†;Kq @MNðÄìÅ¿ËvfÅ^ƒùÜßóÿ ònÕêþ¯ƒ³Òý?¤æ˜ìUØ«±Wb®Å]Š»v*ìUØ«À?5ÿ .DµM=ka3U”î˜þÏüco÷_òÿ wüœöØ3qŠ?SªÏ‹„ØúW~HþqÞ~[êž¡å.—p@¹€ßïè¿–hÿ áÿ »oæL·÷Î‰­Ùë–pêZt«5¬ê7^„ãþOìâ©†*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾`ÿ œàÓ9Úi€bI¢'ýpŽ¿òi±WˆþDÞ,óDÇy­Ý{ƒ¿ñÛ15Bâåi©ôj]«±Wb®Å]Š»v*ìUØ«±W2†0¨=AÅ^ù­ùdúS¶­¥¥l[wDÝ?ï¦þoØý¬ÚàÏÅ±ú^|<;¥Šù/Î·žT»úÍ±õ z	b'áuñ_÷\Ÿ±þ§$kòcZqä06HùÌ6zý¢ßX?8Û¨;2žé"þË¯ýsðæžp04]´&&,&Y[c±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ß#ã¢œ	miÄ×ZÅ]Š»v*ìUØ«±Wb®Å]Š±?>~aÙùR&“^¿÷pƒÿ 'ò'ü3þÏí:dbÂgýW.a{ç0y†ó_ºkíAùÈÛÑT"/ì®m£AÕJFFÊÎÒKÉ£µ€r’W£Ä±â£ïÉ±~˜y'Ëy[F´Ñ-€ôí!Xê?i€ýäŸóÑù>*žb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÎÿ ó›èÞZ°œý´¾
>M¥¿äÚâ¯ŒñTËD×¯4K•»ÓåheÖ”#ùYNÎ¿ä6FQYFF&ÃÜ<™ùÍa«oªñ³ºéÈŸÝ·û6þïýY?àó[—LFñÝØãÔ±z6a9ŽÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¬ÍÞxÓ¼¯’ñùLER#›v­?e+þìo‡ýførìxŒù4äÊ ùïÎ>x¿óMÇ­vxÀ¿ÝÂ§áAÿ ?óIÿ O‡6Øñˆ^L†gvwù!ÿ 8ù¨þaÊ/ï9Zh¨ßÄ|RÓ¬vÁ¾×ùRÿ vŸå¿Ã–µ>àòß–´ÿ -XÅ¥i0­½¤"Š‹ÿ ÌßiÝ¿mÛâlUñüå•¿¥çË¶ÿ ~EnßòMSþ4ÅSŸÈk£\'…Ë½#ÿ šsY«æ–—‘zn`¹®Å]Š»v*ìUØ«±Wb®Å]Š©]ZÅwÛÜ(’)«+n=FhØA±|áù“ä)<«yÊ"ZÊrLMÜS¬OþR?í}¯µË78rñ‡Q—zïüá÷ælš~¦þN¼jÚÞr’Þ§ìJ£“¢ÿ “4kËýxÿ âÆËÚaâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼+þsKúß“æ›ÚÝÄõö`ðþ¹|›ùUx-<Ée#š+3Gÿ ­ÿ Ã:å9ÅÄ·a5 úo4ŽåØ«±Wb®Å]Š»v*ìUØ«±V™C¬*ÄUâ?™ÿ ”æÀ>­¢¥m‡Å,*7AÞDãþeÿ uÿ ©Ë†Ó~-7Y›áy_Í·ÞZ¹VNÎ‡uqü®¿ñû_Ë™3€˜¢ãBfÃè¯'yêÃÍ0z–­Âu’#’ö¯ùi_÷güE¾ÔeÄ`í±ådYKs±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«NêŠ]È
I= ¡å>|üéŠÓ•Ž€D“CNEPÆ/÷ã—ö?ã'ÚÍ†-7Y89u="ñ´K½bì"¹»ö®îÌà™Žl § ›Fù³Ê×þVÔHÕPEw£:	^h²ª·ÚàëË
ÿ É9/üë£ÛÈ*¿[Èÿ Pú¿ñ¦*ýÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_6ÎnjK¦iõøå¹yiíÿ ™ø«ãìUõÝÏüâ¶™æŸ*i—ºq×Ô`is®Q]½tûI&ÿ ÞÇþÍ$Å_4ùÛò÷ZòUÙ±×mž5âôª8â”|/þ|±T_”¿3õo.q†7õíFÞŒµ ø­¾Ôñò2Œ˜c6èf0{'•¿6tmz‘3ýVäÿ ºæ â¹~Ãÿ Â?ù®É§”¤ì!¨Œ¼™¦c9.Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*¶i’ie`‘ %™ «3ƒ‚iå>vüîŠÛ•¦€²Ã
 ÛýÔ¿¶Êƒü‰3ñizËäàäÔô‹Ç.n.õk“,Ì÷30ëVf$Ð*ÿ Æ«› +“€Mó})ù)ÿ 8Ÿ%ÁZóºãÙ£±èÍànˆûÿ /ÇþüáýÞ>­µµŠÒ%··EŽ(ÀUEU@ý•Uû#VÅ_ÿ ÎdZú^sŽJ{e}Ï*Æ˜ªþqêrÐßÃ]‘¡aþÈIÿ 4f»X9;!æõì×¹îÅ]Š»v*ìUØ«±Wb®Å]Š»bÿ ™šÖ´+˜@¬±/­Õ<£ø¾ò9ÇþÏ20O†MáÅÎ^[ÖæÐµ;]ZÛûÛY’eù£ÍË§~œi·ñê±^Àkè²!ÿ %‡5ü*‰Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼ßþr/K—‘5h©SK0ÿ žN“~¤Å_ùnøXjv—möaž'?%`Ç#!b™DÑ·ÖÙ w®Å]Š»v*ìUØ«±Wb®Å]Š»v*òŸÌ_ÉØïAÔ4Xç/ ¢«ÿ •ì£ÿ ‘öüŸÛÏÃ¨­¥óp3iïx¼rÚî÷C»B^Þî"½OB¬6	öï"~rZê¡lõ’¶÷t§©Ò7ÿ ªOÿ $ÿ Ê_†<ÖåÓ¼]†-@;Iéy„æ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¬kÍŸ˜zW–AK¹9ÜÓhcÝÿ Ù~Ìcýö²üxe6Œ™„çOÌ½KÌäÄíèYö…	¡ðõ[ýÚßòOùUsgƒ­É˜Íß—_•ºçŸ¯¦hÔRgÚ(ÇüY'ühœ¤ÿ '/i}­ùEù£~]B'Œ­U–’]8ÜWí$	þéþ¿mñWË_ó•¶_Wóíã‘´Ñ@ãþE¬®<UŠþJj+§yÏG¸Ñ~·áÌú_ñ¾*ýÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿ Îaù¬j¾jI…«› F§ûò_ÞÉÿ $ýUâþ]ÑäÖõ+].ï.¦Žù»ÿ ±Wéå¥ªZÂ–ñŠ$jG²Ž#Aëž_°×­ZÃU‚;›gê’(aóöoò±WÍ™?ó†ªåï|—?×ê—Qò†ã¯û¿äv*ù¯ÌþMÕü­rlµ»Ym&¤Zþ£ÿ w"ÿ ”ŒØª?Ë_˜úÏ—ÈKiËÀ?ÝRÕÒž_‰?ç›&S<QŸ6Øe”y=;ËßŸ}×µhšÚC±tøãÿ Xÿ »Sý^2ÿ ­˜SÒÉÌ†¨oCÒuÛ^?WOž9Ö€ž	þuûIò|Ä”y¹q˜—$vA›±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU¦` ³¹'0/5~ré:?(l×nFÔŒü ÿ •6àÿ Ï/Sü®—LeÏÒâÏR#ËÔñ¯4ùûUó3§IHAaáAOò~Óÿ ¬íË60Ä!ÉÀžC>i—åÇå˜<ÿ qéél¦’\IU‰>oûmÿ ÇÍòÖ§Ù?”ßóšåê-×{«Sâ¹‘~Éÿ —xþ/D•ñKþ^*õLUØ«±WÈ?ó›¶\5}.òŸÞÛÉÔpßó;`_ó—¼oo-;ÉIÿ  Ü?æv`êÆÁÍÒËÛóXìŠ»v*ìUØ«±Wb®Å]Š»v*ìUò>¿§7P¹±]ÄIù+«7ñ6-ÑHQ§ßŸóŽºáÖ<‹¥ÌÆ­FÜÿ ÏhWþ$Åé«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¤¾tÒÆ­¢_éäT\ZÍ?ÖF\Uù‹Š¾¾Òo¾¿gàé<I'ü‡þ9 ˜¢C¼°
+"ÍØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅX—ÿ -¬<Ò†FÐ>”niÑe_÷bÿ Ã¯ó~ÎdbÎaýW.?{ç0èSèWÒé·EL°ÊšƒQÌS¿ÙlÛÆ\BÃª”xM2¯%þmê>_ksþ•d»pcñ(¦Â)<?È~Kü¼2Œ˜ýíØó˜{žãåŸ9iždÔÓ¥àU£mÖOò×”åæ²xŒ9»(eäeM®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š±ï2yûGòõVöpfî¨þ)?àØÿ žœ2èa”ù4Ï4cÍä>jüíÔµ:Ã¦©Àj9Yüôýùçÿ Ù°Ç¦çêp'¨2åé`šv›y¬Ý-­”R]]Jh¨€³1ù/Å™n+é/Ê¯ùÃùî
j>us[0³‰¾3ÿ æ_îÿ Ô‡ãÿ ‹S}I¢hvZªiúd)om¢ÇÐí÷ÅSUò'üæÇ–ZKO×Ñ~	âkg?åFÞ¬ðK+È¼Uóm¥ÓÚÊ·’²ÆÁ”ŽÄŒUúSùyç+8èVzí©¹ŒQû2†hÿ ØIËd˜«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Ã4ÿ 2,¿/ôYu{Ò´)5ÞYHø#ÿ Wö¤oØLUù×¬ë:ÍäÚ•ë™.n$idocÉ±Wµÿ Î"yµÏ2re­®–¼Á=Î
D¿ìWÔ“ýŠb¯¶ñWb®ÅRýgA±ÖíÚÏT‚+›vê’ a÷6*ð=Îhz¡k-ÎúlÇqÖXkíÈúÑÿ ÁÉþ¦*ù÷Îóqò§).,šêÙÝÖ¿½Z{ªþù?ÙÄ¸«Îášk9yÄÍ¨z©¡b¬¿EüÞó—ÅZqsý™Ç?¾O†où)˜òÁtoŽyE›ió6îê–Ž†›¼,ÿ äôøùèù-'qrcªïÃKüÔòî£EKµ‰È¯AJ³qéýÏ˜òÓÈtoâY5¥ô©êÚÈ’§ó#zå&$sn’¶E“±Wb®Å]Š»v*ìUØ«±T“Yó¾£T_]ÆŽ¦…äàûÇ'ÿ …Ëc†Rä¥–1æ^}¯~B•G¶27i&4Zÿ Æ$ø˜ÏHó.OçZ®ç™ù‹Ï:¿˜/î¢íü)ÿ "×áoõ›“fl1ˆòpåËš·“?.µï9Ïõm
ÎK‚À¢/üd™©²l±­ôïåŸüáæŸ¦ð¾ó|¢öàPýZ"D ÿ ÅðÉ7ü’OõñWÑ~o§@––q¤0D8¤q¨UQàª»UŠ»v*ìUóOüæî—êi:^¢ðÜI>Ò ù‘Š¼ò>ûêþaX¿å¢#û©7üÉÌ]H¸¹:sR}š‡lìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯š?6í„e¼UV1·ühÍÿ Ë7XÀ:|â¤_SÎjfçÊ3Ú·ü{^ÈÉÒ)?âLù{CßqWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š´Ev8«óÎzgè­nÿ O¥µÔÑSýGdÅ_D~Y_ß.XÊÝV?OèšøGš\â¦]ÆqŸ(ov*ìUØ«±Wb®Å]Š»v*ìUØ«±U²Ê±!’BIè êph&Ÿ#ëz“ê·ÓßÈ(ÓÈòáÈòãþÇ7Ñ)ÑÈÙ·¬j?óŒ>c_³ó”è¸g’ÙG£æ9¯ÿ wüËûÏø«$Åä±Éw¤ÜòC%½Ì-î¬¤ÃZA§¥ySóÒêÓ¾·Ö#z©A ÿ YvI?äŸúÏ˜y4 òÙË†¤Ž{½_ËÞtÒ|Â é÷
òwŒü.<vßßÌ¼“ü¬Àž)C›±—$ï*mv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨]CT´Ócõ¯¦Žÿ šF
>ŽY(ÀË“HG›×?=4{*¦ž’^IØÝ§üƒŸü’ÿ e™pÒ“ÏgZ 9nó_0þnkºÁ(²ýVû|?|ŸÞÿ Ãñÿ '3!‚1pçžRbÚV“y«Ü-¦Ÿ—7vŽ5,ÇýŠüYÐ÷ÏË¿ùÃÍ_Vãuæ‰FlwôR;Ÿ÷Pÿ ÉFÿ ŠñWÔ>Eü±Ð<Õô+U„‘G”üR¿úó7ÇþÇì*â¬«v*ìUþuþ^/Ÿ|µs¤¨[ZMnÇ´©öäbó‡þzb¯Îë»Im%{{…1ËeaB2ŸuÅ^¥ùùçuùoxÖ×
×=Ë,@üHÝ=x;sãö×ýÚ¿ê®*ûwÊ>wÑüßh/ô;”¹„^'âRfXþÜmþºâ©ö*ìUØ«±U¬ÁA$ÐÉ8«Ï¼ßùùäï*–ŽûPŽI×ýÕoû×¯ô¾ÿ žŽ˜«È<Åÿ 9¹n„¦…¥»ŽÏs _ù%?ù;Š¼ïWÿ œ¾óµõ~¬ÖÖjßPÔ¦á¦ÅXÿ ç÷žokêë"¿ï²#ÿ “+*‘Íù‘æiÍeÕo›ýk™OüoŠ¡$ó–·!«ßÝ1÷žCÿ bªÐùûÌ0SÒÔïR8ÜH?ã|U<Óÿ <¼ëaA±v@í$†Aÿ %yâ¬£Jÿ œ±óÝˆ[˜n€í4	úáœU™éó›š´@OK·ŸÄÅ#Åÿ úÆ*ÎtoùÍ/-\ºÝ©=Ô$Š>Èÿ òOg:7üä‡‘5ZõHácÚux©þÊTTÿ †ÅY®—æíVPúuíµÂž†)Q¿â-Š¦à×¦*ìU¨j¶šlfkéã‚1¹iPÁ9\UãÞÿ œ®ò·—#h´—:­íU‡û Ë¸?øÃêâ¯ÿ 0¿1õ>êSÖdäÀqŠ%Ú8×ù"Nßñ7ý¶ÅR/è7šýô:^›–êáÂF£©'þ5_´Íû+ñb¯ÐïÊoË›oËíaûÉåœåañ¿ú£ìGÿ ¢â¬Ïv*ìUØ«±Wb¬SÍŸ•žYó`?¦tø'‘…=N<dÿ ‘Ñð—þx×šç
ôk¾Rh7ÓY±è“*}ÝJ?Ù4˜«ÉüÉÿ 8‘çM&­e:„cýñ V§ücŸÒÿ …gÅ^e¯y^òýKX\ÛÕ¤‰‚ÿ ÈÊpÅR4vFä„«ãOl¼ý¯YžPßÏ¶Ôw.?à%æ¹YÇÌ6’SËOÎŸ2@Õ’hçÿ $„G*:hƒQ ›[þêÊkqmnëàœÔÿ Ã<Ÿñ¬é#æØ5RL“þrñéÕ>ÓÓþdœå{/ÍžäLó–Íýõ‹©ÿ &@ß­S#ùO6_›òDÿ ÐÀiòËqÿ 	ÿ 5`ü¡ïOæÇrãþrÕ¸²‘ÿ Ö/üEdÃùO4~oÉ/»ÿ œ„”‹[ü^RãþRø–Hi{ª=É¡ùãæ‘HL6ÞñÇSÿ %ÌÃ-h†£©‘c:¯5X½»–D=S—?óÍ8¦_b<ƒL¦eÌ¥º~›u¨Ì-ìa{‰›¢F¥Øÿ ±J¶MƒÖ|Ÿÿ 8­ç/0’êÓmÏí\š5= NRÿ ÈÁ*÷¯"ÿ Î"ygB+q­3ê·†ðBüaCÉ¿ç¬Ž¿äâ¯mÓ´Ûm:µ²‰ 8Ô*õU~UŠ»v*ìUØ«±Wÿ ÎVè¿¤¼‹u"Šµ¤°Î>†ôŸþIÊØ«â¯!ê'N×,®j	‘Xžœ\úOÿ í•ä1š/ªsDîÝŠ»v*ìUØ«±Wb®Å]Š»v*ìUóÿ çÌ"=z6d¶F?ðR'üi›m)ôº­Hõ=»þp~÷•–±i_±,Oõ–Eÿ ™y–â¾žÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»~|ÎHi_£|÷ªGJ,²$ÃßÔD‘¿áÙ±VmùzgÐZ?Ü\:àI?ânùªÕU»=)ôÓÑsÌv*ìUØ«±Wb®Å]Š»v*ìUØ«±V)ù¥«þ‹òõÓ©å_EkßÔøŸóËÔlÈÓÆä|ò¨¾}òg—ŸÌZÍ–[¹ãˆÓ°fÛýŠüY¹uÓH-ÒÞ5†!ÅP; (1Vù‹ù-å¿>ÆN«nî”[˜¨’¯‡ÇJH?É•_|¿ù‡ÿ 8“æ= ½Î„F«f7€ÿ *ÿ <¿ã*ñ»K>f†å	ã4dpUÿ )[â\U•è_›Úþ“D3}j1û3ŽòSá—þJqÿ '1ç‚2oŽyEèZ7çæ?Á©[ÉlÞ(D‹ôÿ vëÿ  ù‰-!è\¨ê‡PÌôß>hZ­µì$ø3poø	x?ü.cË‡G"9¢z§À×qÓ)¦Ûv)v*ìUØ«±VéŠ¥·ÞdÓ,…ÝÜ°ý—‘Tÿ À³W,äy³’#™cz‡ç—,Áãpgaû1#ÿ Á#ÿ ‡ËFšE¨ê"¶«ÿ 9ªé¶lÛlÓ8ZøÅ>_ò72#¤ï-Õw¬~py‡R,qm~Ì*Ÿ)”ßòS2#§ˆèãË<‹º¼šòC=Ã´²±©g<‰ù³eàSI6Í¼ùæÿ 6•m?O• o÷tãÒŽž!¥ãÏþyóÂ‡¼ùþp¶ÎßŒþj¼k‡ê`¶øäÓ¿ïý‚CŠ¾€ò·‘ô_*Aõ]Î+HÈ£p_‰¿ã$‡÷’³lU=Å]Š»v*ìUØ«çùÈÿ ùÇGó#¿š<°•Ôi[‹qþî§û¶/ø¿ù“ýÝÿ ?¼UñýÅ´–Ò4©I•eaBìÀâ¨#[¾Ñ§[½6âKiÇG‰Ê7üUê:üågžt¥ÉuâŽ‚â%cÿ ¥#²lU•ÛÎlyE'°²sâ¾¢ÿ ÌÇÅVÝÿ Îkù•Ô‹{(ÏbÂVÿ ™©Š±­[þrÏÏWà¬WÚƒþù…\Þ¶*À<Ãùæ?1‚º¾£sr‡ª<­ÃþEÝÂâ¬kv*É4_Ë2kt:n™w:·FH_üŒãÃþfZoüâÿ Ÿ¯·ýè©ï,Ñ/ü/¨Ïÿ Š¥?™’š÷åí´šç¢«rìˆ#“™ªŽG—ÃŠ¼ÿ {vÿ 8“æÍJÂNÎ['†æ$™Êá‚º‰—îx×‹6*—ê_óŠ¾}²’É.üU4gþF¿áqV%«~Py¿I¯×4‹Å«,,ëÿ tÅX­ÕœÖ®b¸£qÔ0 ýÇPÅ]Š»M-<ÑªÙ6·—ò%uÿ ˆ¶*‹?y†AÅµ;ÖâCÿ â©EÕì÷oê\ÈÒ¿‹±'ïlUŠ²#þ\ë~w»Z³LÀŽr£@jY~Âÿ ÄÛö±WÛ’Ÿ‘:wå½¹ˆ¹Õ¦ZKpFÀ¾­×ö#þfûrþßò*¯RÅ]Š»v*ìUØ«±Wb®Å]Š­*EAê*Æµ¯Ë/,k{êZ]¤ÌhÂ¼¿äb€ÿ ðØ«Õçü‰~IŽÎKbß3¸ÿ …‘¤\Uˆêó„Ú•6ZÜ>ÂIÿ XqV3{ÿ 8=t	6ºÄl;s·+ÿ –LU#¼ÿ œ+óLï=åŒŸë4‹ÿ 2›K%ÿ œ;óª}“fÿ êÌãh×Pÿ ¡DóÏûêÛþG¯ôÅUáÿ œ;ó´Ÿoêqÿ ­1ÿ #|U;Óÿ ç
<Ã ÷P³‡þ1‰$?ŠCŠ²½#þp‡OJSUš_Kü4?üGzÿ 8·äm†k&¼qûW23ÿ É5ôáÿ ’x«Òt/éÚ,BßK¶†Ö!·cTð€b©Ž*ìUØ«±Wb®Å]Š»v*‘ùß@_0èwÚ9ßëVòÄ>l¤'ÜÔÅ_™rFñ9V]M>8«ëO.ê£WÓ­µJÏ9§@Ä|kþÅê¹¡ÉC¼„¸€)†A›±Wb®Å]Š»v*ìUØ«±Wb®Å^ùÿ 5{y|m€ûžOù¯6šO§âë5_WÁêóƒ²ÒïYù£¶?sMÿ 5fk†úÏv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|[ÿ 9¡£›_4ZßðÝY¨?ëFî­ÿ Ñâ¬þqîùCßY1ø˜G"aÍþ%`jÆÀ¹ÚC¹fÍk±v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÎ@êåc³ÒÑ‡ÄZg^û~î#ÿ 6lt‘æ]~ª\‚#þqË?¥|â5N‚I½¹¿î#ü$vÿ a›÷*ìUØ«óoåîƒæè½vÊ­¨–Ž¿êL¼eýƒâ¯ó‡üá^™tZo-ßIhÇqÀõä²/	Sý—­Š¼gÌÿ óŒ^xÐIaeõØ‡íÚ°zÿ Ï#Âù%Š¼ÓRÑït¹=B	m¥þYP£À¸SŠ­±Õ.¬½¤ÒBÇ©Ùü&- ÒugùæMã¿¿ã#zŸòwžVqDôld:£‡çšß\ÿ ’QÕ,åáÜËÇ—{ò¸¼Ñÿ -ŸòFú¥ƒòðî_}ë$üÜó3Š5é(¢ª<>;‘ãK½/¸óþ¿9«ßÜõdeòL®Lbˆèœ’=JU{ªÝßWsÉ1ÿ -Ù¿ây0 `M¡ã‰¤`ˆ	cÐ(eZ'å7šõ²?GéWr)èÆ&Eÿ ‘’ðþz7—çüã¨ñ{ÿ «Ø!ê$“›ÀAê/ü”Å^£åŸùÂ½×Œšåô÷Œ:¤@DŸó6Cÿ ˜«×¼«ùAå_*ñm'M‚9W¤¬¼äÿ ‘Òó“ñÅYŽ*ìUØ«±Wb®Å]Š»v*ìUç_™_‘Zóð3_À`¾¥ÔY?ç§ìMÿ =ýV\Uó›ÿ ç<Ë¦3I¡Í¥ ­¢)iþ¤§Ñÿ ’ø«ËµÊ7iæ“x£ù–uÿ ‘‘z‰ÿ Š±[›imd0Î¦9PÐ«
}ÁÅWYØÏ{ ‚Ö7šVè¨¥˜ÿ ±]ñVQ¥þPy»S4µÒ/Xx´.ƒþUEÅYÖ…ÿ 8“çmLƒs({Ï('þß×Å^­å?ùÂ½.Ô¬¾b¾’ìÌP/¤Ÿ&võ%oö>–*ö+þUy_Êà~ˆÓ­áuõ8r“þGIÎ_ø|U–LUØ«æ¯ùÍÀF‘¥·as ûÓ|Š¿L?-¤ùcIuÜoù4˜«$Å]Š¡o´»Kõôï!Žtð‘‡Üø«Ö?!¼“«ƒõ"ÙKu0©„ýöæ<Uƒkó†þN¼©³{»3Ø$¡×þK$ÿ Š¼Ãó/þq yWG»×¬u&ž;8Ì¦'†Œ@?ïVNË¿÷x«çUéŸ–_Zïæ-Œš–-²C¦õ¤enAUþÊG/ÃÅñW¥iŸó„Z´”ý!ª[Ä;úQ¼Ÿñ?CzW•?ç|§¤0›R3êRé+pþEÃñÁÊø«ÙôÏG·[=:ííÓìÇ„QþÅqTn*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUùçÿ 9åå9_Úªñ‚áþµ‡¾3ÇýY}Hÿ Øb¬Ïò'ÌBïL“JþöÑ‹ =ãsËáïðIÏ—úñæ³U
6ì´³±OMÌ5Ø«±Wb®Å]Š»v*ìUØ«±Wb¯ÿ œ‚ÿ {¬ÿ ãÄ³g¤ä}î·UÌ=þpþ:Z¿ü`‡þ$ùœá>ºÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|Ëÿ 9½£zšn•ªýÌò@OüdQ"ÿ Ô;b¯üÔ>«æ‡þZa’?¸zÿ ó'1u"âäéÍIô>j³±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾nüáÕ¿HyŠuR
[ªÂ´ÿ $r±™äÍÎž5ê3Êä_GÎyoêº%þ¶ây:Ä§üˆWþªLßð9ã¾Å]Š»v*ìUØªòÂÞö?Jî$™ìº†ð-Š°Í[ò3ÉZ©-s¤Z‚z˜ÓÒ?òCÓÅX­ïüâW‘.+é[ÏücÏü2â©,ÿ ó…ÞQÖ;«ôHëƒSÿ ¡)ò§ü¶jðqÙ>*Ž¶ÿ œ7òd_Þ=ìŸëJ£þ!b©µ§üâ— ¡k)%§óÏ/ühéŠ²;È¯$ØÓÒÑí?ß‰êÉïSešv§iƒ…´6à¾£Tÿ ˆ*â©†*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*üäüï¸õüë¬¿…ä«ÿ xÆ¸«+ÿ œLƒÔóå«ÿ ¾á¸où&Éÿ b¯¼1Wb®Å]Š»v*ù»þswþ8šgüÅ?ü›8«ãÌUúUùUÿ (žÿ 0ßòm1VUŠ»v*ìUØ«üÀÓ«åÝJÄŠúö“ æ6ñÅ_™x«ë_ùÁýO•ž¯§“ýÜÊúêèäÐÅ_Oâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ùëþsòéµ­/2Ù§+2¢ZÌwoùã'Çþ£ÊØ«å$y¦_,êQ_¥LUã*ÿ 4lG?ö_´ŸåñÊòCŒSf9ð}IéqÍÔ2°èAV1š2+gtî¿]Š»v*ìUØ«±Wb®Å]Š»xwüä€ê‰ÜBÇïoìÍž“‘÷ºÝW0ôOùÂ®£«·a#ïi39Â}sŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»yüå>‰úSÈ·Ž¢¯hñ\ö-Áÿ ä”¯Š¾%ò6¡ú?[²¹'Š‰ÑXŸåcéÉÿ Ù^Aq!³©ú«4NíØ«±Wb®Å]Š»v*ìUØ«±Wb«e‘bS#š*‚Ið‚iò.«¨É¨ÝÍ{/ÛžFüØòÍø)Ñfß¡‘>]ýä½*ÌŽ.Öë3Žü¦&á¿äç(g¸«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUù£ù™7­æ^CûW÷'þJ¾*ôßùÃ¸½O:–þK9›ñ?ãlU÷*ìUØ«±Wb®Å_7Înÿ ÇLÿ ˜§ÿ “g|yŠ¿J¿*¿åÑÿ æÛþM¦*Ê±Wb®Å]Š»Sš!*4möX~Db¯Ë­RÈØÝMjÝa‘ã?ìOUô/üá-ø]Ô¬‰þöÑd§ú’*ÿ ÌìUö&*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wbª7v±]Äö÷
)««
†R8²·úÃ~s~pùü‰æ[½Wêá½HþÔOñGÿ ýÓ—b¯KüóÔ4§Ó¥5’É¨¾ñ½Y?à_Ôÿ cÃ5z¨Q¾÷g¦ŠîzFa9ŽÅ]Š»v*ìUØ«±Wb®Å]Š¼óùé«uì-TýòKÿ 4æ×Iôü]^«êø=_þprêëSS`¶Ë_™œÿ ÌqWâ®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»Hüñ¢{C¿Òi_­[Kù²0_ølUù“º1W×Z.¡úJÆÞû§¯IOõ”?ñÍãÂHw6Fd»v*ìUØ«±Wb®Å]Š»v*Æÿ 25Ñþ^¾›ÆüŒ"ù™—à Ñ˜ÔKæï-é¬êvš\jêxá7aüm›§Ný<··KxÖÅ U 
UWv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿0üß7¯­_M×ÔÍ÷»Uí_ó…–üü×w7òX8ûåƒúb¯´±Wb®Å]Š»v*ù·þswþ8šgüÅ?ü›8«ãÜUúUùUÿ (žÿ 0ßòm1VUŠ»v*ìUØ«±WæŸæ}ŸÔ¼Ó«[Òœ/® ùzLUéó‡·^„ïÛI“î)'üËÅ_rb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUó/üæ¯”ö>e‰~;w6Ò‘üûÈ«þ¤ˆÿ ò7|ÿ ù7¬þ×âˆXî•¡jøŸŠ:{´ª‹˜ÚˆÜ\<ªO£³NíÝŠ»v*ìUØ«±Wb®Å]Š»|óùåv'óŒu†Ðý<¥ÿ ™™·ÓK©ÔŸSß?ç¬øi:­×ûòæ4ÿ €N_ó72œgÒØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÐõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*üßüãòáòï›µM6”T¹wAþDŸ¿‹þIÈ¸«Ö%u?®ùv8Ú¶‘â?ª¿ð²ñÍNª5/{µÓJâÎóÊv*ìUØ«±Wb®Å]Š»v*ìUæÿ Ÿ7Þ†‰ºµÓ¨#ÅUYÏü?§™ºAê·Tv¦!ÿ 8Ó¢[Ïzj‘TžvöôÑ™?ä¯§›GXýÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb«]Â‚Ç ýØ«òÚþoZâYÙ¾óŠ¾‹ÿ œ"†ºÎ©/òÛF¿{×þ4Å_`b®Å]Š»v*ìUóoüæïüq4ÏùŠù6qWÇ¸«ô«ò«þQ=þ`-¿äÚb¬«v*ìUØ«±Wb¯ÎßÏë«ùçXN•¹-ÿ OøÛMÿ çî½?éÃýø'O¾ðÅ_}â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU€þ{è]ò^«iJºÛ´Ëþ´$\ù7Š¿=t­BM:êØ¾Ü2,ƒæ§–,RA­ß]«”ÔÁÍïA¶ð%Ø«±Wb®Å]Š»v*ìUØ«æ/ÍÕ½óô‰ÑdŸœj°·ü4y»Â*!Óf7"úßþp÷Kú§’þ²F÷WsI_¼ ýqeÍ/rÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¿ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ø—þs+Lú¯œ!ºQAseš´‘ÄU1T»þqæv1êð«BÀ{‘ oø‚æ¿V9?Hy½5ÎÁØ«±Wb®Å]Š»v*ìUØ«±WŒÿ ÎCNéðƒº‰˜Ÿ¤þ"Ù²Ò‰uÚ³¸dó…š`ŸÌ÷—­ÒÞÌ¨ùÈñÿ Æ¨Ùžà¾ÏÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨MZ_JÒi?–'o¹qWå¶*ú‡þpv*ÝkR,vÃï3Í8«ë<UØ«±Wb®Å]Š¾mÿ œÝÿ Ž&™ÿ 1Oÿ &Î*ø÷~•~UÊ'£ÿ Ì·ü›LU•b®Å]Š»v*ìUùõÿ 9/ÌXç„ýðBØª—üãƒqóö’â×|Râ¯Ð¬UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¡ï­ò	-¤ÝeFCòaÇ~]ÞÚ5¤ò[?Û‰ÙÍOUõG“.>³¢ØËZ“m~a7ü6hòŠ‘wXÄ'Sk±Wb®Å]Š»v*ìUØªÍÌvÑ<ó1Æ¥˜ø 91û°fM|‹¨ß=ýÌ·sy3´O<Û7àS¢&ß¢?’^_>_òn•`Ã‹‹u‘ÇùRŸ]ÿ á¥Â†sŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*øïþslÓºhïõFÿ “Š±ùÇ‘ûÍCåüÍÌ_ çiy—³æµØ»v*ìUØ«±Wb®Å]Š»v*ðÏöoÒöËû"Øóç&m4ŸOÅÖj¾¯ƒÔ?ç‘MÞ²Ç¨ŠÜ‘i³5Ã}iŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅR9Mèh—òÿ %¬í÷#Uù‡Š¾²ÿ œƒýY—Åí×îUõ*ìUØ«±Wb®Å_5ÿ În=4m-{›—?rb¯ñWéoå„&*é·U°¶òI1VOŠ»v*ìUØ«±WçïüäßþLWýh?äÄ8ªþqÏþSÝ#þ37ü›“~†b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«óGó*×êžgÕ­À Kë€>^£â¯tü¥Éå›&;šH>é$_ášm@õ—o§úC.Ìw!Ø«±Wb®Å]Š»v*ìU„þpë¿¢´	cCInˆztmåÛÃÒWOöy•¦ËÜãj%Q÷¼OòßÊ­æ¿1Xhª*·3 hÁç1ú"W9·u/Ò´EŒP€ °ªüUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*øŸþs6û×ó|àíŒ`üÙåÔWJÿ ça*š„‡ì“
ƒòõkÿ \×êÏ'?H9½ƒ5ÎÁØ«±Wb®Å]Š»v*ìUØ«±W‰ÿ ÎA[q»²¸?·‰ÿ U¿æflô‡bëuCpÎçïk¥¥w’Ùþøÿ ÌÜÎpŸ_â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±V/ù¥qõo*jó-…Éÿ ’OŠ¿4ñWØ?ó„pÓEÕ%þk¤_¹?æüUôž*ìUØ«±Wb®Å_3ÎoÉM3IOæ?r/üÕŠ¾DÅ_¦Ÿ—éÃËšZõ¥•¸ÿ ’IŠ²UØ«±Wb®Å]Š¿=?ç#.>±çÝYÁ­&Uÿ Ž8ÿ ã\U[þq¦7Ÿ´¥²ò·Ý§~‚â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«ó‡ó©BùÓYaõÙ¿âG{äù¯–-=½_ù;&j5?[¶Ó},Ë1\—b®Å]Š»v*ìUØ«±W~ykÿ ¤5dÓâ5ŠÍ(iJsŽNŸäOõ•óm¦…Fÿ œêµ3¹Wó^›ÿ 8[ä³u¨ÞyžeýÝª}^ß’|RŸö|?óÛ2ÜW×˜«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*üúÿ œ”Õÿ JyïSpj°º@?çš"7ü”çŠ³?È‹3„ó0§­pìŠ…Hÿ âjù«ÕŸU;=(ôÛÑ³	Ìv*ìUØ«±Wb®Å]Š»v*ìUå?óV>¥çûêfþF/?ù‘™úC¹¬l
þq#Vy†4úÝ¼ÐÇüÈÍ“®}ÙŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅXOçSðò^²Þ63½Å_œ8«ìÏùÂxéå›÷ñ¿#îŠù«}Š»v*ìUØ«±WËóœw4MßÄÝ7ÝèUò–*ý?ò¬>Ž‘eØ¥´+÷"ŒU5Å]Š»v*ìUØ«ó?óXÏ™5=EMV{ÉÝOù%Û‡ü&*ôßùÃý4ÝyØ\SkkI¤¯Ï„?ó7}ÇŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÍÏÎþ±çfOù~¸s²â¯eüŸò½™ñõäì¹§ÔýnÛOô³,Ær]Š»v*ìUØ«±Wb¨wW‹G±ŸQŸì@…éZTþÊ³j"äá#L'.o“ï/&Ô.$¹œ—šf,Ç¹f<ü6o@§HM¿Cÿ $üþ
ò­–“"ñ¹áë\xú²|r/üóþëý†3¼UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»Q»ºKH^âSHãRì|ŽG~ay‡V}gRºÔäûwSÉ1ù»?ãlUô¯åÖú?Ëö0xÂ$?9?|äæi3Êä]ÎQ‹)nv*ìUØ«±Wb®Å]Š»v*ìU…~qX-ß–îŠ´&9Ø†ÇþE»æN˜Ôœm@¸¼kò—\:šô­B´XîâÉvô¤ÿ ’nÙ¸u/ÒlUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Á?=ßÉÈN¿Týâoø\UùÍŠ¾Ðÿ œ,º…¼±yl¤zÑÞ³8ïGŽ/M¿ÙpoøUô&*ìUØ«±Wb¨{ÛÈla{«§X K»¹UFìÌÇ¶*ø?þr/ójÌ=i?G-4ëh¡b(Ò?½—Ù‚úkü«ñ}®8«ÈñWèoä¿æþ—ù…¥£[ýºªÏlNè@§8ÿ žý‡ÿ `ø«ÑñWb®Å]Š»`ž^~É>V»Ô9º•LÃ¹–@UHÿ ŒkÊoùçŠ¿:±WÖßó„þVhm51J´:[D}“÷’ÿ Ã<_ð«éìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š´H§`1Wæ›oÆ£¬__.ë=ÌÒÁ»>*ú3òÖËê~]±‹Æ!'üŒ&oøß4¹ÍÌ»Œ¢.PÞìUØ«±Wb®Å]Š»yç×™¸E‡|OI¥§€þé>–äÿ ìcÍŽ’ÄëõSþ·þq«Èâÿ 6@Ó/+->—Sx§÷ÿ ³›üóY3`à>ûÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»y¯üäO™ÿ ÃÞIÔ¦SIn#Éîf>“É##±Å_hšsjwÐX.Í<©|90ZýÊ"Í>¸D¨¢@†h	·x7Š]Š»v*ìUØ«±Wb®Å]Š»@ëÚyÔ´û›%¥g†HÅ|YJŒž3D|ŽQƒ.Än3|èß§^RÖW[Ò,µU5VñKÿ ŠøªoŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨-gK‡W²ŸN¹¡¹‰âqþK©Fü~hy¯Ëw^YÕ.t[áIí$hØøÐü.¿äºüiþKb¬Ãò3óbOËp^8/§\Ôc¯ü2§üYÚ_æøãý¾X«ïÍ]²×lãÔtÉ’âÖQÉ$CP£2â©†*ìUØ«óçæf…ä[_­ë—+#à‰~)$ÿ Œq}¯ö_ai±WÆœ¿óz¯æ$†Ê*ÙèêÕXîôû/rãíÿ “÷kþ·ÇŠ¼—Lumÿ GdR‚Kw–5•ŠT²8ø$^_²Ø«´Mr÷B»MCL™íî¢5I#4`Ïí.*úòÛþs&T³ó¤%\mõ»uªŸò¥·ûKó‡—übÅ_DùoÎº7™âõôKÈnÓ¿¦à‘þº}´ÿ f¸ªwŠ»H<áç#ÉöM¨ë—)o
ƒ@OÄä~ÄQý¹ý\Uð—çWæýïæV©õ†:Þ«mkÅOÚ–OøºOÚÿ câ¬CÑnµËØtË2]\¸Ž5ñbqWéåç“mü™¡Zh6Ô+mÃöÜüSIþÎFlU’b®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU‡þnù y_Êš–ª#·eŒÿ Åû¨ä¬‹Š¿8­md»™-á¤‘‚¨I=0®´û$°¶ŠÎ/îáE~J8/à3C#fÝìE
WÈ²v*ìUØ«±Wb®ÅToo"²‚K«ƒÆ(‘Ï‚¨äÇîÃf‚	¡o”¼Ë¯K®êêSìÓ1 Wì¯ÙDÿ `ŸoaNŽRâ6ûkþqgò÷ü+åd¾¸^7º¡^¢:£'ü‹ýïüõÉ±{.*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|©ÿ 9³æÀN›å¨ÛqÊîQ÷ÃüÏÅ^9ù£ÝsëŒ>HÙý‹7î}ÌïþÃ1u2¨ûÜ­4n^çÐY¨v®Å]Š»v*ìUØ«±Wb®Å]Š»v*ù3ÍkeªÞZÆ(‘\J‹òWe_Ã7Ð6tRH}ãÿ 8ÙªKÈz\Ö$xOüó‘ã_ø@¹6/NÅ]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ ÿ œœü‹7Ûÿ ‰44®­l”–%Ïÿ /Œñ~Çûñ>Ù|[$mpCBlU—yócÌCœÍ¡Ü”Íd…þ(ŸýxÛö¿ËN2—Š¾€òÿ üæå¹N:î–ë êöÒþyÍÇülU8»ÿ œÙòê%mtûÙÁý4ðK$¿ñUæžrÿ œÄó.°­ZdGnkûÙiÿ $šÿ ±‡ý–*ðí[W¼Õî^÷QšK‹‰ZI³îÍŠ­ÓtÛNá,ìcy®%`©jY˜žÊ«Š¾µüÿ œXGxµï8*Íx´h¬ödŒö{Ù–Qþûþé?kÔý…^Íù‹ùe£yúÀéúÌUa_Jd ’"j7ÿ ‰#|ü¸«ãÍ/ùÇ/1yžéßé`’.!RJùx‹íEþ·ÇüYŠ¼ŸDYÞMg žÚFŠUèÈJ‘òeÅYþ…ÿ 9çDvú¤Ò ý™ÂÍÿ :»ÿ Ãb©ž£ÿ 9IçÛØý?Òîb†%?ð\ÿ Àâ¯6ÖµýC]¸7z­Ä·SŸÛ•ËŸ½±T5¤×“-µ²4³HBª(%˜ŸÙU_´qWÚóŽ'É1~Ÿ×@mfd¢GÔ[£uñžO÷gò/îÿ Ÿ{Î*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾oÿ œÔóWÕ4{6øï&i¤ù"?ëK*·üóÅ_9~OèÇSóÂ±Û;±Ú?ù,Ñæ>¢\1-ø#r}#šgpìUØ«±Wb®Å]Š»yç¯™…¥„z4G÷·G›ûF§oø9>ÏüclÎÒÂÏ…©	ù%äóÏ™ít§RmU½k’;D›¸ÿ ž‡Œ?óÓ6nµú(‘¬j U  ÀŠ¯Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÐõN*ìUØ«üÆüëòßåùXu‰Ù®œrB¼äãüÅ~—ÔtåŠ¥ÞEÿ œŠòœ§[+;–¶»}’•ôËåFäÑ3‘êsÿ 'zn*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÇmÎ*üæüíóø¿Í—ú¤mÊßÕ1CáéÇû¨Èÿ Œœ}_öx«Ò?#t1c¢›æÔ¼rÕÿ !+ø/U¿Ùæ«U+•5Ùé£BûÞ‹˜nc±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾[üÄ‘dóù§®ãéÃfóÒ=Î—/Ô_fÎ&)_!Ú–èÓNGËÔ9kSÙ1Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±W‹~qÎ3é>zgÕ4æ»nÎîå?ñ|kûñr³Y1WÉžvü˜óO“¿JØÉè/û¾!êDG¨ŸcþzúmŠ°|UØª;JÑoµy…¶›·3‰oø{_?ç|Ç®²Ï¯ÒíNå[ã˜òbSÅ?ç£ÿ °Å_Rþ]~PyÈúz=¿úC
=Ä”i_æÿ °¿äF¨˜«6Å]Š¸ŠõÅ^aç¯ùÇ?(y¼´óÚýRíªLÖ¤FÄøºQ¢öQòÅ^æùÂZØ´šü7IÙ''ÿ ‚OUþIâ¯6Õç|÷¦±WÒä”ð²Hü‹flUkùç‹–átùiÀÁHQqV}å?ùÃ¯4ên¯¬É›ê	dú#ˆúòYqWÒ–_‘^\ü¾Q6Ÿžþ”k©¨Ò{ú±
ÿ Æ?‹ùÙñW¢â®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÁÿ ó•žiý9çYí‘«Ÿ[/…@õeÿ ’²2°ÅQ_óú7§kuª8‘Öñ7úÈŸò/5Ú¹rÃKeëY¯sÝŠ»v*ìUØ«±U“LFÓJÁ#@Y˜ì ³–-Óå9ùüÅªO¨¶ÈíH×ÁhÁÿ +Úÿ +7˜áÀ)ÒÎ|Fß_ÿ Î#þ]Ÿ/ùtë×IK½T‡ZõXûŸùñMþ£G–5½ãv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÑõN*ìU¢@=±WæoŸ¼É?™µÛíbå‹=ÌîÂ½–¼bOõcŠ/ú¸ªMsg=©S:4eÔ:òªÕ×üœš}Uÿ 8Õÿ 9%ì‘yGÍ2–™¨–—Nwcû6Ó·ó¾doøÄß±…¨±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wž~}ù×ü!åëèÛÌ©õx<}I~Kï|åÿ žx«óçLÓåÔ®¢²€VYÝQ|*Çˆ®hZ@³O­´ûì-â³€R(Qc_’Ž+šKˆÛ¼ˆ¡JùNÅ]Š»v*ìUØ«±Wb®Å]Š»H¼ñæUòæ•6 iêÂ {Èßcþí·ùÙv(qÊšrÏ€[åû;KNê;hËqq"¢¨Ü³±â£ý“fíÓ?I?.|£“ü¿e ÇBmb
ì:?ÏþÎWvÅY.*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìU¢ÅXÞ¯ùmå­aŒš†—g;ŸÚx·üXªßò_É7(ôk¿âA±VUa¥ÚiÉéYCÿ ,hÀ§UŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»Bêš„zm¬×ÓšCm#ŸòQK·üG~bkº´ºÍýÆ§qýõÔ¯3ÿ ¬ì]¿âX«éËí#ôN…gkû^vÿ ZOÞ·ü	~9¤Í.)s†<1‡)nv*ìUØ«±Wb®Å^sùÛæÑšXÓ``'½%[ÄF>ßüãú¾¦féafûœ=LèW{Ë¿)¼‰/ž|Çi¡­D279Ø~ÌKñLßð?–ë›GXýµ¶ŠÖ$‚	jTt
£Š¯Ð1UlUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_ÿÒõN*ìU€þtþdÚùË÷Ò¸úÜÈÑZÇ]ÚFTñþH¿¼‘¿ãf\Uùákm%Ô©o-$Œ@êIé€«éo0þ^Úk:<:T”ÛD±Ã-7T'üqø×4ðÌc+ïvóÂ%î|ãªi—Z-ÛÙÝ)Žâ¡ïÙ•¼û9¸Å‡RE/¹?ç?7¿Çš/Õ5å«ØI‰ë"º®>gìËÿ |_îÌ({*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|ÿ 9¡ç_­êvžX¾4õæýù&Ñ©ÿ Œpü_óßy·äV…õÝZMEÇîìÓoõäøþI‰ásU:9ËÓFåÍ{æj£±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾züäó‡é­Kêæ¶–d¨ ìÏÒGÿ bG¦¿êóý¼Ûéñð‹þs©Ï“ˆ×sÑ¿ç?-¯«Éæ»Ä­®œxAQ³NÃùrÿ ^Hó)Æ}—Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¼·þrcÌ ü~ÊyvÕ?ç©ã'ü‘õqWÂ^WÒ¿Kj–¶ìÍ*+SùkñŸøY	Ë„[(4úÏ4.õØ«±Wb®Å]Š»v*ùƒó#Ì‡ÌÔ÷*kgÒ‡Ã‚rñ‘¹IþÏ7xaÁt¹gÅ+}?ÿ 8qù}ú7HŸÍ7KIõb„ž¢ÏÄç¬ßòe2æ§Ñ˜«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*Äüåù¥åÏ&'-rú($¥DUå)ÿ VùIþËŽ*ñ4ÎlXÀL~_Ó¤ŸÂK‡ùªßðéŠ¼óPÿ œÇó•Ãn–vëØ,LßŒ²>*„¶ÿ œ»óÌ&¯%´£Áà É6g^Tÿ œÚ”2ÇæM5Y{ÉhÄÿ <&-_ùŠ¾ˆò?æF‡ç{Sw Ü¬á~Ú}™þ2Dßÿ Ä[dø«ÿÓôÞ±¬ÙèÖÏ}©M½´B­$ŒGÒqWÎ˜Ÿó™VvÜìüŸÖ$Ü}jàŒ•?ÞÉþÏÒÿ U±WÌ>ióŽ­æÛÖÔµ«‡º¹}c°É‚4ÿ !qW¤~Oþ[Ê’¦¿©¯•¼l7$ôû º¿kýÙðü<ð5¿„9Ú|?Ä^Éš×bòïÎÿ '-í ×-×÷öà,´´uÙ¿ç“øÿ Šó;K’	pu8ìqù/ç¹<‘æ{=T1[vqÀìasÆJÿ Æ?ï—ü¸ófëŸ£ ‚*7ov*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¨]KP‡N¶–öé¸A4ŽÇ² æçþ~iyãÌóy§[¼×.6{¹š@?•IýÚÏ8ø¦*÷ŸÊ]ô>ƒaIn~ÿ ìÿ »ò+‡û.Y§ÔOŠ^çm§‡}ìË1œ—b®Å]Š»v*ìUØ«±Wb®Å]Š°Í_;.iæf¥õÈ+è½o£ìÇþ_ú™Z|\FÏ âçÉÂ(s/òÏ–ï|Ë¨Ûérú—WRAîi¿ÈEøÝ¿e3nêŸ£žAòm§“4km
Çxí’…©Bî~)eoydX«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«åïùÍí{¶•¢/í¼·/þÀ£ÿ “²â¯üŽÓ…Ö¾'?ñí’™¤?ñ[1u2¨¹:hÜŸCf¡Û;v*ìUØ«±Wb©'µc¤è·—ªJºDÁìíû¸ÏüŒeËqGŠ@5e•D—ËºfŸ.¥u¸¬³È± ñf<ñ9¼t¯Óo.hph:u¶•h)¬I|”q¯Ó×LñWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»c~wüÁÑ|“gõývá`~ÕÜÙŠ!ñ?üGù±WÉŸ™¿ó–ºç˜Y¬ü¶™dvægqï'û§þxüñn*Ç|¥ÿ 8õæ5)Õõrºe‹|ou~üIöý7ýë­'¦Ÿñf*É×DüòWÃ¨ÝÜyŠñz¤X«þIFŠ?úy—dúGž„›y;òø©´ÓC×ýŸ¡ÿ 3ñT}ï˜<í:ÒC±žÕ}5-O¾Cÿ 	Š°Y<æ¾¡¯éW~MÕXPH4ÿ ‹`‘ceOøÇåKŠ°½ÊþdüžÕáÔmfâãµ½·nPÌžÍöX2ÿ yÿ Ã/Å_Vyóæ/6y7Qóº¢júU¤ÒÏnjWšFòÅ ý¯BcûŽ?ò±WÿÔäßŸŸ›7~|ÖçA!U¤¬@ü4SÄÜ2þÔ³}®_±îñV/å?Ë[ÌÔ–ÕvÕ§­%UØ~ÔŸì?Ùe93FÛ¡ˆÏ“Ùü£ùI¥h.%­ÝØßœ€Sÿ ÅöGû>äñÍvMA—/KŸN#Ïvo˜®S±T6§d/íf³o³<où0)ürP4Ac!bŸ ‘M\ßº'é¯µ¬èv¤~±k‡æÈ¥¿U>Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Âÿ ç.<õúÊãG©sª¿§AÔB¿íþË÷qÏFÅ_ù+@:þ­m§ÓàwNßür}<ÃþVW’|"Û1ÇˆÓê  š'vìUØ«±Wb®Å]Š»v*ìUØ«±T»Ì:ý®fú…óq:ìÇìÆƒ»·üÝörp™ Âs_0yŸÌwa¿“Pº5g?
öUb5ö_øoµ›¸@DPtÓ‘‘²ú×þqKòpè?âÍ^>7÷‰Kta¼pŸÛö’ãþMÆGÉ°}Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|9ÿ 9¬›ï:›@j¶VÐÅOvåpäòâªóšy[kÛâ6wH‡û ]ÿ äêf»Vya¤ËÖó^ç»v*ìUØ«±Wb¬Kóf&—Ë7ªxÆ~…’6oøUÌ9õ‡Qô—ƒ~^ÞÅaæ=2òà¶ò9=¬ˆÌsrê¦@×qŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Ä?<?ç$ì¼ˆÏ£i
·zÉ]êk$ôõ©öäÿ ŠWþz2â¯–oì5¿Ì+OÎW·FîçOxýxÜžb)–5û	L¼}8þÏÛÅYÇåÝÝ•‰ŠÛòãG“Z×ø+IzƒÓˆø½+éCÇìúÓKËýeÅ^¯aÿ 8ß­yºUÔ2õ‰®Úµ–íH×Û•=5ÿ +Ñã&*õ¯)þUycÊj§Á®Þ¡^RÈé9Ëÿ Š²ÌUØªEæÿ %i>o²m7[·KˆT|JOíÄÿ j7ÿ W|Û¢yMôÝVóòWÌÒ2ö6¸Òn|Q8$mòý™}T_‡Ô‰ÓìNØ«Äü¨yoX¼ÐÓi¯à»Ò¥JìÏ*=´KþÂëÒlUÿÕó_šô)4VïI”ö“ÉþÅAúqWÐß•ºÂjž_µe h@àv1ü#þ	8?û<Ój#Rvø%qeyŽä;v*ìUòŸ´ÿ ÑÚÕí¨U'“ˆÊÇœð›ìfâ£˜¢CíïùÅ½sô§‘,•^Õ¥·oö.Y?äœ‰“`õ¬UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š¾ ÿ œ‘ó÷ø¿Í·ågcþ‹:ú²³›ŸÅüœ1TçòËžŒërŠ_ÜÄÉ”­þÉø¯üòl×jçü.ÃKâzÖkÜ÷b®Å]Š»v*ìUØ«±Wb®ÅPš¶­m¤Ûµåì‚8S©>=•™›öW%™%!eó‡æžçó]ß-ÒÒ"}(ü?ËoòÛ78±S—!™z_üãOäQó…âù‡[Œþ†¶omq"þÇùPF½þîßœni}´ QA°«x«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wç_çíÿ ×¼ó¬KZÒäÇÿ "ÂÃÿ 2ñW¥þIY}_Ë±Éþÿ –I>ãèÿ Ì¬Ôê©Úé‡¥žæ#”ìUØ«±Wb®Å]Š¨jQßÛËg>ñLSÁ‡ÉF\&ØÈX§Êî‹q¢^Ë§Ý
Kq4­ûJËþK‰s{q’Qá4_iÎ0þq/œt‘¢jOþå´ô¹ÞXGÂ“{¼s°“ýÙ’b÷UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÏßó‘?ó‘)åD“Ëž\6°ÃŒ²®âÜûþUÿ u­Š¾2¸¸’âFšf/#Y‰©$õßzŸüãW˜ °óJé7ôkf),fVè}Aû¿ø)Åÿ =1WºÎ6^KåkZü´¿5{IšâÙWŒñV?ì£6ò¨ÿ .LUŸùóþrÊ~LåØ¸»]¾¯mI$¯ƒïéÇÿ =dLUçÉù±ù•çÍ¼™£:É¾ÍÕçZ:ú¼#?óÎ+ŒUç™Z—œ<¦Ñ®¡æÙ.µöuacÉ€$ÿ »xz1§ù1µ¿9“}aäy5I4K'×‡M­ã7aI)ñÔ/Âù¸ü<±Tñ˜(©4|Ésæû?9~f3@àyÊ¶²®e˜	~Ã~×©,Ÿºÿ ~,“íâ¯Ÿ|¿¨\k^k—Ì!/×«/€ƒž Ëÿ $ý<UÿÖÎcy ézÌ>h¶Z[ê+éÊGA4b›ÿ ÆX8ñÿ ŒRb¯?ü‘óWèÍHésµ ½ Zöwÿ #?»ÿ [ÓÌMN>!Ír´óá5üç¿f¥Ú»v*ìUóÏçŽõo0Çü|Ã‡æ+üÊÍ¾šWS©'ºÎk¼ìµMŽñËÂøÈ¾“ÿ É˜ó)Æ}=Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Î¿>0‡‘ü­s}q½œzÞ>£ƒñÿ Ïç/ûUù÷§XM©\Çin9K3ª(ñ,i€š/gÖ&“eŸn?wR´ûNÊvøÛü¬ÑN\FÝÜ#Â)fìUØ«±Wb®Å]Š»v*ìU#ówœ,|¯kõ«ÓVm£~ÓŸòÉ_ÛÙÿ [Šµ¸ñš²d¾tów/¼ÑsëÞ5#ZˆâSð(ÿ 'Å›ö›í6n1ãLò›/Jüˆÿ œx¼óÔéªêêÖúf¥º4ôÿ uCÿ ÿ ¿&ÿ aÇýÝo·ôÍ2ÛL¶ŽÆÆ5†Ú	h(ª£¢¨ÅQX«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯Í_ÍZÿ ‹ušõý!uÿ '_{wåü¢ö_)äì¹§ÔýeÛiþ–a˜ÎK±Wb®Å]Š»v*ìUçß›_—íæab¥¯íÅƒöÓºÓýø¿i?›ì|_Í>^G“‰¨ÅÄ,sxg—üÁåÛèµ=2f·ºª®¦„æVèêßkì¶m][íÉ?ùÈý7ÏI—ª”³ÖéNÒ9ó[–ý¿ø¡¾?äçŠ½§v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|ÿ ÿ 9ÿ 9¾Rü¹å×¬8¤²Å¸?ö2ß³þúûkŽ*øêÎÎó[¼X Vžêv'sVf;³3ø&fÀMnRìÌ'­¬<»s¨›ShÌ‚JT†_Ò‡ö¨ü}?ò¹f»ó!ü×?òõé<NÆúkãº·b“Bë"0êO%o¿6N½ôµ¯å—›?7oSÏôðh63[¨Y 4w‚•åöúHÅžyWáÿ tñÅS_0þT~U0‡E„ëºÊì ™¹“;£Gÿ FÈÍŠ¦¬ÿ šßšƒ‚ªùcF“©<„Ì§þžþ±W¡þYþ@ù{Èl/!F¼ÔÎíu=Ôõô—ìEÿ '?âÌU™ù£ÍÚW•mQÖîcµ·_Ús¹?Ê‹öäòY±WÎ¾müÌ×¿7’{-ŸÐÞS†¿\Ô®~ éûKËþÅâQÿ Ý¯7Uã^óöžtäò_“ãÐâpòÊâ’ÞL?Ýó,ï˜æÄE^×ùWùuåŸ$k:­ü,Úæ©¦ÜÅjñÆÑ?xý¯^wáÍ?ã}®x«ÿ×ï¿š>DƒÏ^_ºÐ§ yV±9ý‰Wâ…ÿ à¾ßù±Wç.¡§Ýh÷’YÝ)ŠêÚFGS±WSÄÿ À¶*úWò÷Í«æm.;¦#ë	û¹—o¶?knÒ/Çÿ 	û¥Í€»Œ98Ã%ÊÝŠ»y'üä–^ÚÏQQýÛ¼L{ücš}Þ“ÿ ÁfÃI.aÀÕG‘wüâ/˜?FyÕ,ØÑ/à–nJ>°Ÿòe—ý–l]{î|UØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_
ÿ ÎS~eÿ ‹|ÆtÛGå§é|¢JšZÿ ¤Iÿ ¾’ÿ Æ>_·Š¥ß‘>UúÍÌšìã÷võŽ/w#ãoö·ùéþF`ê²PáïstÐ³ooÍc²v*ìUØ«±Wb®Å]Š»v*Å|ùùƒiå8:Ky ýÜ Óo÷ä‡ö#ÿ ‰ý”ý¶LŒXLÿ ªÑ—0‡½ó®¿æÝzé¯oäç+màvD_ÙEÿ ®³oˆŠ¦R26_@Î=Î4¦»>hóH`ô’ÞØïEv’âŸîŸå‹íKû»þòL_]Á@‹*4 *¨  ;Øbª¸«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_Ÿ¿ó’¾Z“AóÆ R+¶QŸ—wû¦¯ûU’~Dù’;‹4Y÷ÖäÈ€÷G?õ$?üdÍnªñ;,öáz–`9ÎÅ]Š»v*ìUØ«±Wb¯=üÅü©ƒÌ¯ôî0êHè²¯ü²ÅŸðÎ¹˜u;¥ÄÍƒ‹qÍàú–›w£]5­Ú47Pv#ùXÔÙ´Ã¬"¶/¡¿&ÿ ç,nt‘‘ç2÷6‚Š—câ•ü^?Ýéþ_÷ßñ—
YiÍ¦³j—ÚtÉqm(ªISŠ£±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ðŸùÈ¿ùÈòL èL[~'ê-Ñ‡Ûÿ ŒíþêOØþöOØI|_zÍØŽ0óÝNþìÌÌwf?ñ&ÀMnR¾‰ü¼ü»ƒÊ°z’RKéï°ï¸ÿ Éÿ ‰f£6n=‡Òípáàßø™Žc9/–¿04!¢kwVh)~qŽÜ÷ˆ?ØòáþÇ7˜¥Å]&HðÈ‡ ~_y7RüÈòÖ¢’j“‘¡Ûò·°£
<©û\>Ò:wË—-k}	ÿ 8µ£èùV×WÓì¡Qá¸˜/)9¡ÿ ~5YyÇéÉÁ~zG›ÿ 1ô'Äe×/b¶4¨Bk#©
r•ÿ Ø¦*ñÛßùÈ_1yÚVÓÿ ,´™%âonVˆ¿åq¯¤¿óÖ_ùãŠ¼ÏÌöþ_òõÑÔÿ 1u7óG˜Ky¡þIî?aûê$þ0¾*ÀüÃç_3~iÝÁ¢ØÃKdøm´ë4ãkÛ÷küŸµ4¿
ÅiŠ¾’üŒÿ œdµò{&·æNZ¸£GÞ8ü]0ÿ ~}„ÿ uÿ ¿1W¾â¯ÿÐõN*ù3þsò¨Á2yÛNOÝÊV+À££}˜gÿ žƒ÷/þ_¥üø«Ã-|èÞYÔÖIIúœôI—°í-?š/ø‡4ý¬£6>0Ý‹'}0¬R
Á‚3JîÅ.ÅXæÆ•úGË·AE^&Zöày9ÿ ‘^¦déåRqõ¸¼Èa>\×ôý^´[k˜¤oõSþ
>K›‡Pý0FY2š©xU~*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«Åÿ ç#:àòN—&“¦Ì¹v¥)©…í\?ò5?¸ÿ /ãû)Š¾"Ñô™õ‹¸¬mG)¦`¢¿ñ&ÿ %FFR¡e”Ešª<¹¡C ØC¦Û}ˆV•îÄüNçýwäÙ£É>3næá˜äŠ»v*ìUØ«±Wb®ÅX7æ'æ}·–ÙÚÒmE…xþÌ`ôiÊ?±üãÏ+=ÏÒâæÏÁ°úŸ>jš¥Æ©p÷—ŽdžCVc×ûsllY7¹AáCôOþqú[Èº;x[…ÿ fOø×z*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿ œŸü¤:èËªi‰ËTÓC2¨ë$Gya÷uþò/öh¿Þb¯‰ôMjçD¼ŠþÍ¸ÍT{öeoòY~ÈÊ"B‹(ÈÄØ}3äß8Úy¦Ì]Zž2-±ñ#oØÚÿ [’®›.#íñä	öRÜìUØ«±Wb®Å]Š»v*’y«ÉÚ™ ô/Ò¬>Ä‹³¡ÿ %¼?Èoƒ-Ç”Ã“VLb|Þç_Ë}CÊî]××³?fdƒþ2÷S­ð·ì3f×a7W“‚·åÇæÖ½ä¿_GœúA–ÞJ˜¤ÿ Y;7üXœdËÚ_e~Sÿ ÎChT´ä,µb 6Ò·Ú?òï/Â³«ðËÿ â¯UÅ]Š»v*ìUØ«±Wb®Å]Š»v*òOÏïÏ?.¬>«fV]néO£ÜF¿gë÷Ú»ü„|Uð¬Ó^kw,¬÷7—/RMYÝØýìÌpJ½ÿ òËòÝ<¯Ö®èúŒ¢ŒFâ5?î¤ñ?ïÇÿ b¿Äúœù¸öKµÃ‡ƒsõ3¬ÅrŠ¼sþrD?èºº$?|‘ÌÜØé%Ì:íTyùÅï7ÿ ‡|åoo1ãm¨«ZHNM¼òYQ?ÙæÁÁdzæ#_×|¤kpè:U´ò\Jò7#<R6ŽJr¯¢ñ|+4XªóRü±òl­?úO›uzÔÉ1)oËüªÿ {þËëKþV*Æ¼Ïùßæß;•Ñ´Ðm,ßàŽÇNŒ¨#ù)ïdÿ Wì‘Š³/ËŸùÄk[+wæwýhwô–;—÷P³äÿ ñV*ú£Èÿ —’-~§¡[, ý·?ÿ e?ÿ Ä—dø«±WÿÑõN*—ëº-®·e>™¨ –Úæ6ŽE=Á¯ùqWçOæ‡åõ×µÙô;ª²ÇñÃ%($‰¿º“þ4ø±]qW£þJyçëÖÿ  ¯[÷ð
ÂXîè:Çþ´?³ÿ Æ,ÖêqW¨;6[ô—©æœìUJêÖ;¸^ÞaÊ9T£Ã‹~A£h"Å>GÔl$Óîe³œRH]£ošž-›ðowDE?Cÿ $|Ïþ%ò~™¨3r—ÐX¤=ùÅû‡¯úÍ,(gX«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ZX(©4øª[}æ+O¯/-àýù*/üI±V#«þùJRÓêöïNÐ“)ÿ ’&*À<Ãÿ 9å‹ SJ¶º¾qÐ±!ÿ då¤ÿ ’8«Ç|éÿ 9oæÍuZ3ÓÒàm¿sV’ŸñžO³ÿ <ãxÙ7Z½ÕI{‹¹Û©«;±?ðLÇ4-ï?•_—Ë‘CPPoåµôÔþÏúíûð?Íš½Fn-‡'gƒç›Ð³Ëv*ìUØ«±Wb®Å]Š»yWæ'çV@éú¬³š‡œn©ígòþÂÿ •ûøt×¼œºŠÚ/±±¾×ïRÚÙêöåèª*ÌìsdëžÙçùÇtò'‘%×ufõu·–U[à…¾(Å?½‘¾QþÏûïùÝWb¯ÐOùÆyýo idþÊÊ¿t²ŒUê«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|«ÿ 9#ÿ 8äÌóy·Ê±W•d»µA½z½Ìÿ 4_óÑ?k|Ó y†óAº[Ý=ý9WcÜ0îŽ¿´ÿ \äe!E”dbl>ƒò/æešBÄA~Å	?jŸµ	?mkÛOõ~<ÔåÀa¿ð»LYÄÿ ¬ÌsÉv*ìUØ«±Wb®Å]Š»[,I24R¨t`U•…Aª°=F Ò·”ùÛòF+¢×šHjLh‡o÷SºÍeÿ wþTkðæÃ«¤œšn±xåõÞ“r`¹F‚â2CÕ[þnÍ€7¸p®orü©ÿ œ²Õ¼¹ÃOó0mJÀP	kûøÇúíþôÏOÞÅ¸PúËÉ˜'œí~¹¡]%ÂPrPhéí,MñÇþËdx«±Wb®Å]Š»v*ìUØ«üÇóÝ§‘´Kvûu„R4­’7÷Q/úÍÿ œŸöqWçošüÓæ½N}cTs-ÕË–>ù#e~\Uì¿”¿—?¡a]WRŽ—ò[¬jâ2ºý¯å_ƒùóW¨ÍÅéËÜ½'0œ×b¨mKS¶Ó {»Ù(U™ºÍÍüª¿d£#AŒ¤#¹xwæWæ´>a·m/O„}[c,ƒâ%~!é§û¯ýfýŸåÍž—[›?Áç67²ÙOÕ»š&Œ:†SÉ[ïÌÇêz‡”<ïùË¬?˜Là×HÃx+s¾?Wì4˜«Õ|“ÿ 8W|gó]÷¨v&QEù5Äƒ‘ÿ a­Š¾ò‡åî…äø}
Î+aJ3(«·úó?)dÿ fø«#Å]Š»v*ÿ ÿÒõN*ìUä¿ó‘_”cÏú–É?Ü½ˆi-éÖAþì¶ÿ žŸî¿ø·ýgÅ_	XßÜéisnLW5FÛ†Ì§ñÀEŠ)·§ü›æ¨<Ï§¥ü}™ù\}¥ÿ Wöÿ /ù\³I—§s'´ó*mv*ùÓó£Cý¯<ñ€"»Q0§fû²gOSþzfãO.(ûF¢5/{Ý?ç
¼èï*Îßu =ÔÒ+€?ÕoI¿ç£fKŽúv*ìUØ«±T£ÌlÒ¼»Ö5‹¸m"ìÒ¸Zÿ ªvÿ cŠ¼ƒÍó˜>RÒ‰LYõ)Cúiÿ #&âÿ òKyO˜?ç4¼ÇvJé6v¶h{¿)\²¬Qÿ É,U€j¿ó‘^zÔ‰2j³FhBFü‰DÅXÜß™>g™¹I«_³x›™OüoŠº/ÌŸ3Âk­~§ÚæQÿ â¨±ù¿ç·é›ïúH“þjÅV¿æç›ÜQµ›úÌLŸó^*„ŸóÌ³×ÕÕoš½ks)ÿ ñT®ó\¿½Úêæi‡ùr3ÄŽ*€ÅQÚ~{¨ž6PK9ïé£7üG sHòdšoå/˜ïèÂÔÂ‡¼¬©OöúŸð™IÏÕ¸`‘èÌô_ùÇóPú½Ð ;¤õK'Où˜ÒÕ÷øé{ËÒ|¹äÍ+Ë«M:G"!øœüäoŠŸä/ÿ '0ç–SææC‡$ë*mv*ìUØ«±Wb®Å]Š¥º÷™,4>³©L±'`~ÓAñ?û²Ìù5ÎbÞç¿ÍÛÍ{•‡+[#PE~9Û÷û+ÿ ¯û'“6x´âŸ©ÖåÎg°äyòÿ Wó½úéš$Yv.Çdß“Iûÿ ýŽM™N3î?ÉïÈ½'òâØK:¬‹InXo¿ÚŽÿ uEÿ ÿ ·û*ª¥Ÿó•Ñsòó,–çþJÆ¿ñ¶*ø+}ëÿ 8£'? X¯òÉp?ä´ÿ b¯_Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÎßž_ó‹¶þbõuÏ)ªÛêF¯%¶Ë§öš>ÐÎäTŸä7ÇŠ¾CÔtëÝ
ñí.ÒK[Ëv£+UYXb¯Nò7çl–ü,¼ÁY#ÙVáEXvýòÿ »?ã"þóþ26`åÓ^ñsqêki=ŽÃP·Ô![«9X\UYAÍt¢c±v–á‘dìUØ«±Wb®Å]Š»v*”y“Êš˜àú¾£zW‹+Ýþ5ûûjÙd2rkž1>oóäÎ££ÖãM­å¨Üñ¼_õ£oýhÿ Ù*æÏ KŸ¥ÖäÓ˜òÝ…hÚåö…r·ºdò[\ÆvxØ«»2œgÕ“?ó–i~ñèþu+¦‹èQü¼§Ù‹þ3'îÿ #ûX«é”u‘C)H¨#pAÅWâ®Å]Š»v*ìUØ«â?ùÊÿ Ìÿ ñ6»úÉùXid«Pìóô™¿ç÷?ëz¿ÍŠ±?É&~–½ý+vµµµ#€#f“ö}™cûmþWælÄÔeá:¹Z||FÏG¾f¥Ú»H¼ßç?+Ú}jðòv¨Ž ~'ooåUý·ýõ¸«]‹™jÉ@>sógœoüÏqõ‹÷øV¢8×e@zñ_Úo´Ù·†1AÔÏ!™²Î?)ÿ çµï?ñ¼eúŽ•ÿ -ƒVÿ ˜x¾Ô¿ëü1Åœ²Æ·Ö¿—¿^VòB+Ú[›ÁÖâàzÿ ‘QÂ/ùæ˜«Ò ¦Ãv*ìUØ«±Wb®Å_ÿÓõN*ìUØ«ãÿ ùËÉ¯ÑW'ÎzD`Z\½/GØ•¿Ýÿ êN¼ÿ ‹¿ã.*ñËÏ:Éå]C×rZÒZ,Èj+ýàñxÿ gý’þÖS—¦ìY8¾—¶¸Žæ5žŠYMAuašR+bî½Â¦°_Íÿ (É¯ébkUçwhÅÐ¬§iQádÿ ž|?k2ôÙ8Mâquø…Žò·šµ*ê1jÚL¦ÈÂÛ£‹#«|,Œ¿+fÙÕ>Œò¿üæÔˆ‹˜tÑ#¼–ÏÆ¿óÆ^_ò{gó™Mk4w°7pÑ)ÿ “r>*ˆ›þrÿ Èñ…îŸýXæ¶\Uêÿ ó›Z,JFi·S?oY’!ÿ n?V*ò¿9ÎZù»]-9£Òà= ¤#Þy+ÿ $–,Uãº†§w©Î×7ÒÉq;õy»öOVÅS­òç]Ö {[G‘^rR5#ÅL¼yÿ °å•K,cÌ¶Ç¥È3m3þqúé÷Ôo#ŒøD¥ÿ áŸÑ§üf4µc r#¥=K)±üŒÐ-Ï)Œ÷Îàù$±·ü6PuR-ãKÑ)<²½,‡Ó$§õÉ•þb}ìÿ /ç7å–ÔÙ¢IGüFL1>õü¼;–ÿ Ê ò¿ü±ÉYê®ÌÍ—‹¿åPy_þX¿ä¬¿õWÌÏ½/ñþRùf3U²L’ø”˜?1>ôþ^ÉŒCÐ`Kb?Ê‰[þ&"sK½—ƒäÂÏC°±5´¶†ÿ Æ«ÿ  fOVb tGW Í¬UØ«±Wb®ÅVO<vèÒÌÁ#QVf4 {±ÂòA4ÇuÌ¯/X7	ï¢'þ+¬ŸòdI—=NxŽ©=×ço— û,¿êFæaL³ò²küÌPMùû¡Óá†èŸtOú«’ü¡ï4;’«¿ùÈX"ÖÁ˜v/(_øUGÿ ‰åƒIÞX_pcz§ç–»v
Û­‡b‰É¾“/¨¿ð(¹ttÑmRÔÈ°[ËëJc=Ô<ÏÕ‹1ðd\œbo›Ú*?çõ¯52_kÁôÍ,ïñ
O ÿ Šâoîƒ<¿ìc|(}…äï$é^O±]3D·[xsMÙÏóË'Ú‘ÿ ÖÅSìUåßó“Vþ·5Aü«}ÓDqWçæ*û«þq^~F…’æuüyÆØ«Ú±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«üÍüÐ¿1-ý=V.H)Ìt'û/÷dñ\Ÿìx·ÅŠ¾3üÒü€óåû´ó§ÖôÐ~¨A*?ã2}¨úß»þYa~[óf£åÉŒúlœ+ö”î­þºtÿ ²€Ÿ6p™'´y?ó§OÕ¸Ûj€YÜšDþé³Ÿîÿ Õ“þFf»&˜ÆîÃ¤{=]C¡H¨#pAÌ")Ë¶ñK±Wb®Å]Š»v*ìUØ«óå¶—æUi$AÙé<`¯üX:KþËâþW\ÈÇœÃÜãäÀ&ù÷ÍS¾òÕÓZß¥;£®èãÆ6ý´¿µ›XLLXus¢ößùÇoùÈÇòÓGå¯2È[JbÛsnOì?üºÿ ÉøÅöl`û")RdFC# A ƒŠªb®Å]Š»v*óoÏ¯Íü¿òô·Q0ý#uXmü²>)¿Õ~?õý4ý¼Uùÿ kkqª]$ƒ-Äî Ë1î~x	­Ò¾¨ò·—âòþ›¦¿NLwwÿ dßð¿hòOŒÛºÇI®VØ‘yÇÎ6~V³7wg”Q@üNÞùUmÿ cýn
×bÄfZ²dš¼Çæ;Ï0Þ5ýûr‘¶ }•_ÙD_ÙUÿ ››âÍÄ "(:‰HÈÙ}ÿ 8ùÿ 8Èº’Gæ_8D~¬Ô{{FÛ˜ê³\ÿ ÅGö!ÿ v»>æÁõœ0¤(#ŒE   °ÅU1Wb®Å]Š»v*ìUØ«ÿÔõN*ìUØªTÒíµ[Yl/£YmçCˆÝXQ—~~~uþRÝ~\k-hÕ“Ož¯k/ŠWû¶ÿ ‹bû/þÆOÛÅQÿ ”?˜ë¦8ÑµG¥«ŸÝHßf6?²ßËÿ 7ì?Äßiß0µx·ÜÌ¸v/tÍ[³v*ÁüÙùE¤ëò5Ü|­n›vx÷V>/øà=?òùfV=IŽÇÔâäÓ‰n6yÞ§ù¬Ûk9!¸AÐT«Ÿö.=?ù+™‘ÕDóqNšC’G/å'™¢k"G´‘ŸøŒ‡,ãÞÕàË¹b~Tù•úY7Òè?âO‡Æzø2îL,¿%<ÇpÅeŠ8óI*‘ÿ $}Vÿ …ÈL!§‘eZ/üãú‚¯«]×Æ8õK'ýQÊ%«îñÒ÷—¢h>GÑô5…²,ƒQ¾'­)´É—ýTâ¹‰<Ò—2åGcÉ=Ê[Š»v*ìUØ«±Wb®Å]Š»v*ìUØªY®ù›NÐbjS¬ ýwfÿ R5«·ûË!ŒÏ“\òóyG™?>§›”:$"%;	f¡o˜‹û´ÿ fÒ®gÃJÔàÏTO'™júýþ³'«¨Îó°éÈÔõSì¯ûÌŒDy8’‘—5mÊz¾µÿ »+‹®Õ†'ø‚¶I‹,´ÿ œ~óÕÐ¬zEÀ¯óñOù:éŠ¦ÖŸó‹~¸ë§‡ùsÂ?T§OôïùÃ8Ü‘õ™,í×¿)Yˆú"¿âX«8ÐçaSËYÕ™‡t¶ˆ/ü••¤ÿ “X«Ù¼‹ùå_%2Ï¥Ù«]/K‰© ?ä3ü1Ï%gØ«±Wb¯;ÿ œ„Ôò&®¾WîtlUùßŠ¾Þÿ œ7ŸÔòd‰ü—²½blUîØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØªÉbY£€UPAÅ_ÎZ~Wh^Uz¾‹Õd½–D–44ŒÑUƒ$î¿ùçð‘Š¾oÅY7•¿0uo-,ååja“âCò^©ÿ <Ù2©âæÛ¦žÉåOÎM+X+éú•ÉÚŽk?äÍ°óÓ‡ù,ù®É¦1åêsñê¹úYöb9nÅ]Š»v*ìUØ«±Wb©W™|µgæ+F²¾^JwViOó¡Ë1ä06ç1Eówœ¼›wå{³mr9FÛÇ Ù]GümüËû9¹ÇLXu1˜/[ü€ÿ œ‘—Éü413M£H¤ÝžÞ¿ñ;ø¯íGþëþL±­ön©[j–ñÞØÊ“ÛJ¡£‘e`iXb¨¬UØ«±T—Í¾mÓ¼§§K«ëˆmažäþÊF¿·#þÊâ¯ÏÏÍ¯ÌûÏÌMfMZê©n¿´5¨Ž:ì?ã#ý©_ù¿ÉãŠ³?É$´cüCx7e)n‡íËÿ 2ÓýŸù¯Ôåþçé±ÿ zök‚Oæß3ÛùkO“Q¹¸ü(ƒ«¹û)ÿ 5“Ë-ÇŒÓVIð|Ëæ?1Þy‚í¯¯Ÿ”°•eeGüÜßnaAÔJFFËèÏùÆÿ ùÇ¸h¼Õæ¸i£ÚÚÈ>×u¸?“ýõ}¿¶ÿ Û›ÖX«±Wb®Å]Š»v*ìUØ«±WÿÕõN*ìUØ«±V)ù•ùw§ùûH—GÔ…|QHZ)Ø‘?â,¿¶Ÿ*üøóÏ’u%j³hº´|'ˆÔö]Ø–&ý¨ßþmo[zå_æ¢D‰£kRUøa™ŽÀ~Ìr·€ý‡ÿ cšüø/Õ;zØ½“5ÎÅØ«±Wb®Å]Š»v*ìU)Ö¼Ù¥h›j71ÂÛÕè{úKÊJ±Ë#ŠRäå’1æR'üáòÂô»-òŠ_ã]ùiµ~f*GóŸË`Ó×sÿ <ŸþiÃùY#ó1püèòÙÛ×ùÿ óN?•’þf+ÿ årygþZüŠ“þhÁùi/æb¿þW–?å³þIKÿ Tñü´Óùˆ·ÿ +Êÿ òÛÿ $¥ÿ ªX?->åüÄ[›ÞW;}tÈ©ê–ËÏ¹?˜‡z²~iyméKÔßÅ\~µÁàO¹><{Õ—óËÍ°¾‡þ}ËãG½SþVÿ -öÿ ò0`ð%ÜŸ=év¡ù¹åË$-õ¯Y€¨X‘˜Ÿ¦‚?ø'\˜ÓH±:ˆ‡žù›óÚòìthÅª½G£?Ð¿Ý§ü”ÿ [2á¥Ÿ©Äž¤ž[<ÖêêçSœÍ;<÷·V%™‰íã™€SˆM½ƒòïþqWÌÞhãs©¥Ù5)õX‘oö‡üöô°¡ôŸ‘¿ç¼Ÿå@²Qv)Ynèûÿ ‘÷	ÿ Ïü¼UêPÂ Ž TP (*©Š»v*ìUØ«±Wb®ÅX7ç||ü“¬ùs”ýÃ–*üäÅ_hÎÉËÊ×©ü·î~ø Å_Bb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_6Înÿ ÇKÿ ˜§ÿ ˆb¯±WÔ÷Ÿó‰V~còõ†³åÉÍ¥üöpK$3Ñ;´jïÅÿ ½‡›·üZŸä®*ùïÎ~AÖ¼™tluÛW·}ø±G¼R¯ÀãýVÅS/&þij~["?Y²î—nŸñ‰÷dÿ WâOò?k1ò`oÇ˜ÁîžTóÆ™æx¹ØÉI@«Bô/jñ©ªÿ –œ—ý–k2b0æì±åäŸå-ÎÅ]Š»v*ìUØ«±T·Ì>^³×íÆý9FÝûJ{<mû.¿õ×Ã–BfÃ\à&(¾tó·åíÿ •dý÷ïm‘Ê‚°ý‰?Èÿ f\ÛãÊ'ÉÕdÄ`™þYþuyƒòö_÷/©fM^ÚZ´MîÚ‰ÿ Ë‹ù\²æ—ÒÞUÿ œÊòÎ¡®·ú|ôøˆ_Z?¡£ýïü‘ÅYdŸó“þ@Dõ?IòöM_»ÒÅX?›¿ç44;4hü½i5ìýžjE?ðò·ú¾œëb¯™¿0ÿ 4uÏ?]ýo\œº)>œ)ðÅ?ï¸ÿ ãwå'ùxªmùeùe'˜d]GPRšr»Hý”ÿ ŠÇí?ûø¾Æ.lÜ©ÉÃ‡sô¾Š$…(”" 
ª¢€°U ¨&Ý¨»¼ó¿Ì‡PÕF›¬6jéC#NkþJñOõÕ³m¦…Fÿ œêµ3¹WóY¿üâwå4>gÔ¥ó«–ÃO`±#
«Î~*·ó,	ññþy"ÿ +2ÜWÚx«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÖõN*ìUØ«±Wb¬ówò‹MüÈÓ~§yû«Èªmî «#Ùoç…ÿ Ý‘ÿ ²_|çŸ!jÞHÔJÖ¢1J»«ÒEÿ ~Bÿ ¶Ÿæü[d^Füá¼ÐÕ,unl”S_ þVýµÈßì]12éÄ÷Ü¬YÌv<žÉåÿ <iøP¹F‘¶ôØñzÒ´ôÛâoõ“’•šùá”y‡a±—$÷)mv*ìUØªÉçŽÞ6šfTY˜€ ñf8@¾H&˜G˜¿94M$´p1¼˜Wh¾Í|fø?ä_©™PÓJ\ý.4õ1½O-ó'çµ¬V(êp‚CþTßoþÓ_òs6xÇÍÂžyI†ZYÜ_Ì°Û£Í4†Pb}•~#™.;+µü™óÈ{C¸å/üL.*‹_È_<6ãGºúVŸÇqü„óÀýuÿ ý¸ªŸü¨¿;ÕšïþEœUA¿%üæ¢§E¾§ü`éŠ¡åü§ólT/£ßŠÿ Ë´¿óF* ß–žhSC¤_ƒÿ 0²ÿ Íª‹yÌ**ÚeàÆÞOù£R%ëˆ*Ú}Ø&	?æœUOü+«ÿ ËÏü‰ù§LtßË?3jr­4»Éø@à},WŠâ¯[ò?üáç˜ufY¼Á,ze¹¡(–b?ÕOÝ'û)?Øb¯¤ÿ /?$<³äEi–ÂKÀ7¹š)?äµ8Åÿ <Q1VŠ»v*ìUØ«±Wb®Å]Š»v*Ä7"2ùCYŒT“asÓþ1¾*üÙÅ_cÎÉþà5(ÿ –í[ï?æœUôv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUówüæâWCÓÂí‡ßb¯1WéOåLÞ·”´y§+cÿ $ÓMüÃå½;ÌV§êöñÜÚ¿TTWÄwVþV_‹|«ùµÿ 8‰w§sÔ¼˜Íul76Žz£þ)÷rÿ ß½ÿ Œ¸«çek½"çoRÞê¡êŽŒÐÊØ´ƒOYòWç€<m<Ä)Ø\ ÿ “±(ÿ ‡þEþÞ`eÒõ‹›SÒO^µºŠî5žÝÖHœUY òYs^A`òTÀ—b®Å]Š»v*ìUNâÞ;˜Ú	Ñd‰ÅX=™O\ Öá_7–ù§ò&Öè™ô9>®çýÕ%Z?ö/ñHŸòWý†gcÕ9Âž—ù¯;Õ?*üÅ§nö*øÃI?áR²Âf\sÄõq‰`òV¹ÿ Vû¿ù'üÓ–x‘ï8qN4¯Ê?1j$«zjf	OœßÉ<®Yâ:¶GG¥yKòJÇLe¹Õœ]Ì(D`R ~_j_òypÿ S0²j‰Ø9xôÀszR @@
  „æ7ŠT®î£´…îf4Ž%gcàroÃiÐ·Èúž£.£u-ìæ²Ìí#v<ŽoÀ¡Nˆ›Ýúùå!åo'iÖ¼fx„òøó›÷­ËýNKû(gø«±Wb®Å]Š»v*ìUØ«±Wb¯ÿ×õN*ìUØ«±Wb®ÅXïü…£ùÖÄéºå¸ž-ÊžŽüñIö‘¿Í¹.*ù+óþq^Ð™î¼¸JYu('QïÙ›þy|MþúÅ^¨i×ZlímyNRE*Ãæ­ñb©ž•ç­oIlï%DQ@…¹¨äÇ'4ð9\±Æ\ÃdrJ<‹%²üóóºñ—Ð¸>2GCÿ $Z”4KhÔÈ#Oçþ¯ÄomÏÄ‡§ü©ÿ d?)6š—’[¨~vy†ëû©"·ñTcþgz¹`ÓD5D‹Ôõ»íUƒßÏ$ì:zŒZŸê×ìåâ ri2'šuåË?1y½Âhv3\-hdãÆ1þ´ÏÆ/ø|“Ð^Cÿ œ.§Ÿ7^W¹·µÿ îÉ¸ÿ ç¦*úÊ—º“áô4+(­…(YE]¿×™¹K'û7ÅY*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»cß˜púÞ[Õ"ëÊÊàÉ'Å_™˜«ëÏùÂk¦jÑÿ ,ñ|Õ¿æœUôÆ*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUó‡üæßüp´ßù‹où6Ø«ã¬UúMùAÿ (v‹ÿ lûoù6˜«.Å]Š¼çóGò/Ëÿ ˜q½êú€K¸@
tYfdÿ _âþFLUñ¯æ‡ä~½ùy1mB?[O&‰u%€“¼/þLŸì9â¬sÊ¾xÔü³/;?t~ÔORóOæÿ -~?ö9Tñ‰ól†COsògæ¦›æN6îE­éÿ u9Ù¿ãŸõ>ÿ %¾ÖkriÌ9n–<â\öf™Šä»v*ìUØ«±Wb®Å]Š»v*ìUØ«±VùÅ®/A–%4–ìˆVh~)ØújÉþÍs+M•ÿ 5ÅÔJ£]ïü²ò±óW™4ýœ’âáÿ Æ5>¤ÿ òE6î©úTª  ØUv*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÐõN*ìUØ«±Wb®Å]Š»Jµß+iZü~†¯iÜ}„Ñ«Óý^clUæš÷üâŸ‘µZ´V²Ù¹ïo+ÿ /«ü&*ÀµoùÂ	*tÍZh¼Ñ,ŸŒmüGJþpzì·Å¬ÆÄ[ä÷ümŠ²þp“G„ƒ©êw3øˆ‘"ðÿ XÅ^•åùÇ$ùt‡·Ó’yGíÜ“1ÿ —÷_ð1â¯F†…q€¨¢€@*©Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»J|Ù«£ß åm0§Í~`â¯«ÿ çf¬:Ì5èÖÍO˜œb¯©qWb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ç6P.iíÜ^ÓïŽLUñ®*ý#üœ%¼›¢“ÿ ,ßòmqVcŠ»v*£ukÜMÂ,‘8*Èà`e•¶lUó‡æÇüâž£ÏRòk[ƒ¹´î˜ÿ Å/þè?ä·(¿ã*ùcÌžXÔ¼³xl5{y-n“r²-úÈ~Ë§òº|8«'òç©¡ñ‚ìýrÐmÅÏÆ£ü‰ãY9ÿ *ðÌlšq?''s7´ùcÏšW™}FP&¥LOðÈ?Øþ×üóg\ÖäÃ(svÊ'Ée-ÎÅ]Š»v*ìUØ«±Wb®Å]Š´ÌbÉ=*ùÃó[ÎƒÌš—c[+Z¤_åýä¿'¢ðÿ #Žnpcà£6N2öùÃ <·W^o¹JG›krGVmçqþ¢pþz¿òæCŽúÓv*ìUØ«±Wb®Å]Š»v*ìUØ«ÿÑõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*‚ÖSÔ±¸Oæ‰ÇÞ§~\b¯©?ç$¤úÒv+j~ã>*úÃv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ù×þsgþQ½?þc¿æT¸«ã\UúEù3ÿ (f‹ÿ 0ÿ òmqVeŠ»v*ìUØªAæÿ #hÞp´6:íª\Å½9‰	ý¨¤_Ž6ÿ Q±WË™ó‡ºŽ˜^÷ÊÛmÏÕå!fQàðÇ7ü“õñWÏwúuÞ“rÖ×‘Ims£$ŠQ”û«|X«2ò×ç.³¤R;¦°Ù”žcýY·ùêf4ôñ—“‘ò›Ò4_Îíø»/g%7æ¼–¾
ñòÿ ‡HóZY^§2:˜ž{3/2i—æ–—pJ|Ec÷)ÌsŽC˜o"z¦*C
®ãÛ!E»]Š»v*ìUØ«‰¦çx—æ¯æ½£hïþÒi—öéÖ8ÏûïùŸýÙû?÷›<8w.·>{Ø1oÊßËMCóWI°ciæ"«uøœÿ •û1§í¾g8OÐÏ+yfËËm¾¦'§klwÿ )›ùÛãvþlU6Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÒõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*£x¼¡‘|U‡áŠ¿,ˆ¡¦*úsþp}é«§Œ0üšOù«}oŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»|íÿ 9°øjÀöÀÉ)qWÆ˜«ôƒò]Ãy3E?òã û‘F*Í1Wb®Å]Š»v*ìUyËòçBó”?W×lã¹ ¢¹uÿ Œs/þ|óçùÂ¶«OåKáMÈ‚ïþ5¸ˆÄâÿ gŠ¼CÌÿ ’^oòÑ?¤4ÉÌcýÙú©ÿ # õÙb¬"HÚ6(à†AÅVƒMÇ\U3³ó>«d8ÚÞOŽÉ+(ÿ S‘1˜d$G&C¦þoùŽÊƒëd³*+Wý_ù)”œ=Fy¬¿Hÿ œ?
ê–€ï»ÀÔû¢“þ«f<´Å¾:®ðÏ´Ì[¢Û\ªJiû¹~©ý‘Ïávÿ ŒLù‹,‹•ñ“&ÊÐÚ–§m¦@×w²,0 ©f?çÉ¿•Wâl”bdh1”„w/	üÃüÚŸ]åa¥ÙG“ýoäüÚý¿å]¦Ÿ©ÖeÎe°úR?Ë¯Ë}WÏÚšéZDu¥³5BDŸïÉþ Ÿiÿ g2ÜWß–_–šgåö”šV–µcFšf¯O¶ÿ ñ¢~Ââ¬¿v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÿÓõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*²@
wUùkx8Ï ·ëÅ_HÎŸ÷-ªùw‹þ&Ø«ëÜUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«çùÍùF,æ=äÔØ«ã,Uú;ù%ÿ (Vÿ 0Pÿ ÄqVoŠ»v*ìUØ«±Wb®Å]Š»@Þèvÿ ïe´3Wýù·üHb©-çå•¯E.4‹ùÛG_ø†*Æõ_ùÇ!ê@úšTqÞxéÿ "Wþ`šÿ üáo—.Á}&òêÍÏ@üeAþÄˆäÿ ’¸«Ê<Ùÿ 8æÍ$4º[Á©D7¤méÉÿ "¥ø?àflUãšß–õ-ªêÖÒÚÍü³!Cÿ Š£ôoÌsFCÜ‹(é ü„”:§ûªX£.a²9%E®y“P×%õµ)Þg9lúˆ´Dÿ c“Œy1”Œ¹½#ò‹þqß[óü‰y:›" ›‰wòíyÿ ?ºÿ ˆd˜¾Öò?ôŸ%ië¥hˆa±;»·ûòWý·ÿ ®SŠâ¬‹v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÔõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUùo«½“ÿ ÆGýx«èOùÂOøîê_ó¿òqqWØ˜«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±WÏó›òŒXÿ Ìzÿ É©±WÆX«ôwòKþP­þ`¡ÿ ˆâ¬ßv*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®ÅRýo@°×-Í¦©oÔÕ%@ãþxÿ ˜ç|›ªMëÚ›
š•‚@Sþu•—þMü—ÿ 8Åäï+È·?W{ë„Ü=Û ÿ Æ%T‡þ
6Å^¬ˆ¨¨@ ¥1Uø«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ÿ ÿÕõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ãŠ¾×ç|ûòM‚L®å¿w<G©ÿ -ãoø\UêŸóŠ_–ž`òŽ±¨M®ÙIh’[ª#=8³såð²r\Uôî*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUó¿üæ¹ÿ fÁ|oÁû¢›|gŠ¿G¿%W’ôaÿ .0½*Í±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb¯ÿÖõN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å_:Îl¸]Ó×¹½¯Ý˜«ãlUúGù8ònŠü°[ÉµÅYŽ*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUÿ×õN*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å^;ÿ 9+þýkþ5úßÕýfô~©N\øž¼þ³üØ«ãŸ2[y?wÐ.u/hî­¡ÿ “Ð]Ø¾*ûÿ ò³Óÿ 
i‡÷P¶ã_M1VSŠ»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»v*ìUØ«±Wb®Å]Š»ÿÙ                                                                                                                                                                                                                                                                                         usr/local/go/doc/gopher/appenginelogo.gif                                                           0100644 0000000 0000000 00000004071 13020111411 017106  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        GIF89a/  ·ÿ      D  ˆ  Ì D  DD Dˆ DÌ ˆ  ˆD ˆˆ ˆÌ Ì  ÌD Ìˆ ÌÌ ÝÝ  U  ™  Ý U  UU L™ IÝ ™  ™L ™™ “Ý Ý  ÝI Ý“ îž îî"""  f  ª  î f  ff Uª Oî ª  ªU ªª žî î  îO ÿU ÿª ÿÿ333  w  »  ÿ w  ww ]» Uÿ »  »] »» ªÿ ÿ D DD ˆD ÌDD DDDDDˆDDÌDˆ DˆDDˆˆDˆÌDÌ DÌDDÌˆDÌÌD  U  U UL ™I ÝUU UUULL™IIÝL™ L™LL™™I“ÝIÝ IÝIIÝ“IÝÝOîîf  f fU ªO îff fffUUªOOîUª UªUUªªOžîOî OîOOîžUÿªUÿÿw  w w] »U ÿww www]]»UUÿ]» ]»]]»»UªÿUÿ UÿUˆ ˆˆ ÌˆD ˆDDˆDˆˆDÌˆˆ ˆˆDˆˆˆˆˆÌˆÌ ˆÌDˆÌˆˆÌÌˆ  ˆ D™ L™ ™“ Ý™L ™LL™L™“IÝ™™ ™™L™™™““Ý“Ý “ÝI“Ý““ÝÝ™  ª  ª Uª ªž îªU ªUUªUªžOîªª ªªUªªªžžîžî žîOžîžžîîªÿÿ»  » ]» »ª ÿ»] »]]»]»ªUÿ»» »»]»»»ªªÿªÿ ªÿUªÿªÌ ÌÌD ÌDDÌDˆÌDÌÌˆ ÌˆDÌˆˆÌˆÌÌÌ ÌÌDÌÌˆÌÌÌÌ  Ì DÌ ˆÝ “Ý ÝÝI ÝIIÝI“ÝIÝÝ“ Ý“IÝ““Ý“ÝÝÝ ÝÝIÝÝ“ÝÝÝÝ  Ý Iî Oî žî îîO îOOîOžîOîîž îžOîžžîžîîî îîOîîžîîîî  ÿ  ÿ Uÿ ªÿ ÿÿU ÿUUÿUªÿUÿÿª ÿªUÿªªÿªÿÿÿ ÿÿUÿÿªÿÿÿ!ÿNETSCAPE2.0   !þConverted by Plan 9 from g1 !ù @  ,    /   ÿ ÿ	H°àÀn™î2c‘2wT¹3H±¢ÅƒˆQDe£ !Úu±¤Å]U:nÜèPåJ*ˆº™œ)p—ÆÁ9ˆ£G32iZt‡HeÎ•>UöÔ8dI¡™™ÙØ³ãÑ¦‚–ºÔ©
*AfU†$Í*hç'CÒ¦õ¸Pl™ ^‹
B¥­Ú´dÅ	ÃïÜ®P™¡ü(bnS±d5RiZÅLXµÍ¨bF3Ó.fˆîV±¬
—Cîìrç®¢aÇTõôâ®]ÝT…4(A›8ÍL¼M5‘;Ì2í¶¨Êt½D(t·Ëaòå°Íè¥"b—Ä’Å™áqg¹gÙu‡ÿÿ»"Ú{ï Oa&†‚DdúAD•â‰”¿ƒwFcå%5‡3`BP7DpWEƒ øJˆÜ1×B‚TÁ^EÌ¼FpýÓu,uWMx‰e!MfÌ0Ã\eP"^7U<A}ê	äŽ*Ÿ‰•àˆeÆ\s1Äf¯yÆÐŒDB„Žù¤ €ÍôãbÝÕPrî0CYsj}´XCsõHÓ!¡‡Ó„ˆÖL¦)T%¥¨‡4eV™8VED7"¢Ê™ S–ªdb™‡)qäàEªÔ%ˆÿ6œ;Â÷šEÖµèI,‰iD–n:P&ra¤‘ªÑ§Šˆ¡§
k$×|ÝÁjA?ÎuLE¥Ek¤?Ò¡Tf<Ôá.,éæUAîTÁ‘pUW£–EhÆBƒ˜ÑÚ²5J%Ý4{Èhÿd¢d¶‡`3Qr;P„5†å@Z²›»YzÈ e@[R–øt]¤Ì !ù d   ,    /   ÿ ÿ	H°àÀn™î2c‘2wT¹3H±¢ÅƒˆQDe£ !Úu±¤Å]U:nÜèPåJ*ˆº™œ)p—ÆÁ9ˆ£G32iZt‡HeÎ•>UöÔ8dI¡™™ÙØ³ãÑ¦‚–ºÔ©
*AfU†$Í*hç'CÒ¦õ¸Pl™ ^‹
B¥­Ú´dÅ	ÃïÜ®P™¡ü(bnS±d5RiZÅLXµÍ¨bF3Ó.fˆîV±¬
—Cîìrç®¢aÇTõôâ®]ÝT…4(A›8ÍL¼M5‘;Ì2í¶¨Êt½D$ìöYðÑ_Î±KùÅâÌðŠ$Ñðw6zÿŽ€ˆ »Ù3€g2‰0CA"‹ˆ@y`¦ÅŽ#Tù^eú à3íÂPTÌðŸDÀõ"‚„q"U´öO7‹áµßLÌ¼D k
v£X
tb3ráLfÌPâ"TQŸ@îLuÜîÖÍD@[CëÑdÆ\†™ÈÚ.§1”#ƒÑX!†`(r$Ö M²Ø3î0ƒevA~T`]0	uG´ÑõÑ”Þ•&Ó
I„dd&HSfu‘	%ƒT!š;e‚ˆŸ1ýÃŒ*™XFZHT¼X’*u	bÆ?¤Ç'ŸÝ¼fQx)èKå4i&•*ZP&XÐwÝ§Ñ¨
DèŸÂYd$WÝÁjA?ÎuLE¥AÚê@1f¥¨Tf<¤à.,éæÕ©ýQ« )qç,‘w˜±Ð f„¸ì?ŒÒuG71:5Q&Ib{&°º­Aˆ´YF’Ãb¹”ëºZ©cvþzª¨ëZWÚp ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                       usr/local/go/doc/gopher/biplane.jpg                                                                 0100644 0000000 0000000 00000615234 13020111411 015715  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ÿØÿà JFIF     ÿâ ICC_PROFILE   ADBE  prtrGRAYXYZ Ï        acspAPPL    none                 öÖ     Ó-ADBE                                               cprt   À   2desc   ô   gwtpt  \   bkpt  p   kTRC  „  text    Copyright 1999 Adobe Systems Incorporated   desc       Dot Gain 20%                                                                                XYZ       öÖ     Ó-XYZ                 curv             0 @ P a    Å ìDu¨ÞRÐY¡ì9ˆÚ.…Þ9–öW»"Šô	a	Ð
A
´) •’–£,¸EÔeø$½Wô’2ÔxÆoÈv'ÚŽDü µ!q"."í#­$p%4%ù&Á'Š(U)")ð*À+’,e-:..ê/Ä0 1}2\3=455é6Ð7¹8¤9:~;m<^=Q>E?;@3A,B&C"D EF G#H'I-J4K<LGMSN`OoPQ‘R¥SºTÑUéWXY:ZX[x\™]¼^à`a-bVc€d¬eÙgh8iijkÑmn?oxp²qîs+tjuªvìx/ytzº|}J~•á.‚|ƒÍ…†q‡Å‰Šr‹Ë%ŽÝ‘<’›“ý•_–Ã˜(™š÷œ`ËŸ7 ¥¢£…¤ö¦i§Þ©TªË¬D­¾¯9°¶²4³´µ4¶·¸:¹¿»E¼Í¾V¿àÁlÂùÄ‡ÆÇ¨É;ÊÎÌcÍúÏ’Ñ+ÒÅÔaÕþ×œÙ<ÚÝÜÞ#ßÈánãä¿æièéÁëoíîÐð‚ò5óêõ ÷WùúÊü…þAÿÿÿá>Exif  MM *    
              †       Œ              œ       ¤(       1        ¬2       Ì‡i       à    EPSON Perfection 4990             Adobe Photoshop CS6 (Macintosh) 2013:04:26 17:59:58       0221      "     ÿÿ         S       Å    2013:04:26 14:13:03 ÿáøhttp://ns.adobe.com/xap/1.0/ <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 5.4.0">
   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <rdf:Description rdf:about=""
            xmlns:xmp="http://ns.adobe.com/xap/1.0/">
         <xmp:CreateDate>2013-04-26T14:13:03</xmp:CreateDate>
         <xmp:CreatorTool>Adobe Photoshop CS6 (Macintosh)</xmp:CreatorTool>
         <xmp:ModifyDate>2013-04-26T17:59:58</xmp:ModifyDate>
      </rdf:Description>
   </rdf:RDF>
</x:xmpmeta>
ÿÛ C 

ÿÀ ÅS ÿÄ           	
ÿÄ µ   } !1AQa"q2‘¡#B±ÁRÑð$3br‚	
%&'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyzƒ„…†‡ˆ‰Š’“”•–—˜™š¢£¤¥¦§¨©ª²³´µ¶·¸¹ºÂÃÄÅÆÇÈÉÊÒÓÔÕÖ×ØÙÚáâãäåæçèéêñòóôõö÷øùúÿÚ   ? ú¦Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(ÍŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢›,«—rGRN ú“À®Ä_ü 1ŽïS…ä ÌÍ’r°	009$àdŒŠóíSöÍðÜ;¹òw°Ý‹g¹BkŠÔ?m}Q€šU´'¿›3¾~R}rÙ¬9¿koj—^Ÿ¬e‡ËP4§’Ã.\‘‚~áQŽj;Oˆ_îÑe€jNŽ2¬,cÁ ›qÁížÕ¥añ_ã‡Ë^jV—WVêqsgòæ;í’'N,K``à M{ŸÁŽúÄxšÝZj‘ÏíÁÔ` “½H#p*ÊÇÔh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š	­Equº™'eVb üK`W¯~Ð^	Ñ[dúœR¾@+nb27dù@:œàçŠäåý¯üŒURõÀ=D#Üu?˜Ö³5Û?Ãp…û•äÌsâ8ÀôÁg}Äú`t<×1uûn¸‘…¾Ž¾V~R÷'8÷ÂêÑˆ®c[ý°üWvÐaµ²‹'F‘°~è/3"¼œªŸáÀçi>!|T!OÛµ8@0zœyc˜úœüËÎ¯yáØã_Ô6É®ÜÃa	 ”OÞÉØ°Ú¾\(ØÈÉi0Ã•a^µ¢~È¾°L^›× d˜ ÈûÅRßÊÀnêÅÀs]æðwÂzíô‹ ¤äî…\ú}é°ã°8ïŒÖæáM'Ef}.ÎÞÕŸïbT'7PN2qõ­ZF®wIøw iŒšÞŸc½üÛƒËífÞCI>\» Í…'’k£¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ªjzµ®•]ßÍ¼	i%`Š ä’Î@ žµã2ý®|-¢“”²êssóFDõš]¥³žQ¸à‚AÆ|KÅ_µß‹uftÓŒ:t'D)½ûºiÃxÆVIÏÍ^O­øÃXñnÕnçº9Ïïäg© +Ÿ-@ÉÚ¹;p:u~øâÿ k;	RÝ¿å¬ß¹¹È2áÛ8Æc‰ù Ÿ”î¯U°ý‰/äˆ5î«Rÿ v8@=>v–ž¹1èMnéŸ±5Œq‘ªË$™ë£I§?ð*ëtŸÙÁ–{MÏÚîÈ\$ÅA=ÜL ´g¡â»mà—ƒtm¦ÓJ¶Ü«·t‰æ1¬Óo,Ç,~cë]¤p¤J0G@à §ÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEPN*;‹¨­£i§uHÐe™ˆ VfÀÜšñïþÕ^ðþb±‘õIÇ¶Ç–?zâB±‘Çü³óO àŒ‘â^.ý±|I©‡FŠ:›/qŸ2LD§zDøeÈb+ÇuÏk~)¸jw3ÞM#|¾k—äœŠ?º9l†0Fp£œOðì§â¢]ê!tËgä5À&R0+j¤8Îp<é"<“'Ûü=ûxRÅö”—7Î:‚þR #d²Àù›¹ ’v^ýŸ¼á«ÕÔ´ûö”ÎÆ–G”.qó"NÒ"¸ÇË&Ýë’ Mz´´QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEWÔ5}>º¼‘!‚1–y*êÎÄ(S^1âïÚßÂš+4:h—S•r3	F8óæÛ¸s÷¢IÇ5åúïí©¬Nt«k˜íiYå!y*¾Jn<‡ tÁ¯ñ§ÅxØãY»’xAÈŒa"cÉlyÎdßƒ’
‚EEá…þ"ñ“£YËr¹Ç™±]ÓÉ¶<OÊÌ{c$gß|ûí+qâ{ì	‚Ðs×$5Ì£¸O—žêÃ¥{Ï‚þxkÁª‹eRŽ³0ß)ë’f“tœäðQœ ×ŠZ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢°šâ<cñ§ÂžSý¥¨Eçv†#æÈz€qn#%HÜûT‚ExŒm+¹wEá«qÄ·'{û‘DF¤vÝ+úàòµá>.ø¯øÊO7Z»–èg!Xâ5ë÷ ]°G€HfïVàbO|-ñ/‰£7:]…ÍÌ\1c;Nxù^C¿Nv3cø±Æ}7á'ì¯ªx¡äºñ—L³‰Êmhÿ }#†¬¿,q¡Æfuus•‰Ys%}áÙÇÁže™,EÔé‚$ºc)ÈÁ#þéH+BeI885ép@ Ž%Š0F €  Ð
}QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEr¾9øŸ x"7\»H\Œ¤#æ•úÝÂ™v#,@EÎY€É¯œ|Yûiê³Çáë­âÈ	%Á2IîÆÊD‡¶Ó+ãÉûµâÞ(ø³âäjÚ„óFr
nòãçT>\XùFäd`“›>ø9â¿ tÍ>v„ã:ùQçŸ6o-[îYCàà1½—Â±]Ü»eñú@:˜í—Ìn½<éB 8î"l>aÍ{ƒfïxe’uµûmÊcl—gÌÁ†X° FÎV1‚ÜW¨,j *Œ 0 è;`ƒŠp¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢³|EâM?Ã–Rjz¼émiËÈç v ¬ìH
Š³E|£ñWöº¾¿/§øAZÊÜ¦åÀ38ÏX‘ƒ%º°Î›q
ùÞúþëR™înäy¥~^I³7lÉ#’Ìxxž@ pzGÃÏÙÓÅ0d™mÍ“g¹wGÄÓd—j¢Þc8ú»á§ìïá¿*ÏåýG½ÅÂ‚W¨"¹ŽÉåA‚CHÂ½DRÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEÀ|VøÍ¤|:´2^Ÿ:úE&T?;ž¹Â	¥qÓ;Û
~!øñkZøznµIq
10À¼G=£^	|ºgÌŒzl_Qð/Ã­gÇ¿ÙÚ4,‹‚í÷R0s†šR
ÄÓ´»‘„Fíö_Â_Ù¿Dð:¥åð]CU>t‹òGÔbÚ&ÎÒÁ•ËÈÄd(õý´´QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEâ¼ãoí;eá…“IðÃ¥Þ©¯0ÃE	&¸\cË$lA•¸òÏÇ÷—ZŸŠu¸—Í¼¿»“'‚òHç UQ¹Û DEÂ®UTWÑ_
d)®Bj3f‚3‚¶‘0óë‹‰W"xá%ðHiTð>Ÿðç†4ïÚ.Ÿ¤[Çkl1êYVby,Ä±=MjQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEU]OS·Ó-ä½½‘a¶…KÉ#œ*¨ä³1àÿ Ö<WÈŸ¿iÙ¼BBð›¼~yr¤¬“ü)Â´äòÇp–P ;#$?|7øâO²Ëe“e‘ºæl¤XÈÏ—üs	 B¥Ië"õ?cü+ø#¡ü<„5šyúƒ.Ù.åy’0>XaÈFœœìì3^‡EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQFkø‹ñWBð¡¹Ö'b¤ÅnœË!Ã}@É Èûc\üÌ+âÿ ‰Ÿuÿ Š—ÉfŠÉh\-½”9`Xv0ng'IPçËE¹÷O‚²í¦“zÏŒ"êïŽÕÈhâô3”š~IÚKEÞà½}k„@@À `Ø 8 z
uQEQEQEQEQE“p¥ÍG=Ìvèd™‚ êX€?3UF½§ž—0ÿ ßÅÿ â©·,çâ/ûø¿ãSÛÞCr7@ë Jôj]Ô´QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE#°Q“ÐWÍß¿km,>—àâ·@•{²3ãƒöq'ngÊ_€~uð·„üGñKYhí¼Ë«©X<óÈITÖ\JxD ˆ9`6Ã§Ú?	~èŸ"B¢ëTeÛ%Ô‹ƒêVÉaoO!IwÀóð1é`bŠ(¢Š(¢Š(¢Š(¢Š¥ªëvZLFãQž+h”-+ª  Ë¹(äúWŸë_´‡ô£°ê)rà¶ÙZ^ÙÈhÁŒ¨HsƒÇ^+€Õ?m]Ûa§\Ì2A2<q>éPV;ºÁ
úgÆê?¶¾±$L,ôëXe?t»É ¹@!qÆC¨î+¼ý°|iq)­ Çüó·Î~¾t²~˜ªR~Ö:”[¸ÆF>[hò=ÁçÞ±%ý |w*Ú¥ÎÁ "þ¢!·ê#Ö¹«¯ø’í<»NîT<í{¹}v™1úVUÆ«{r¾\Ò´ŠHá¤göùœžŸ)¨E½Á‚d§Ëþd/‹Ìp$ÿ °øš³k}¦Öï$9FxðGC•(Äó]¯‡þ=ø×CÚ¶úœò*’vÌË89àîóƒÈ@ê?y€zq^¢~Ù^#¶Bº•µÙÃ.øO{v<ô,Ýr*ŸáÅuÉûlØd	t‰”z‰Ðýp
®:ê|=û\ø?TsßÚl9tñ†^rr^Ý¦Úù€$°ÀëMÐ¾ x_mšV£ktãX¦F?7ÝAÝ“ƒÆ3Æ1šè3EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE÷À,¬4™˜à 9,Äà  É$€|{ûFþÐ‹âCÿ ç…ås§‰æL¯žÝ8ñ‡6ÉÉ';‘€c\¿ðkà&©ñu»“u®¬CÜ•Îí¼­•¾Y_?)|y1 Ù.ÀG_nø7ÀúOƒ¬WMÑ X!,@ù°Ë3ýé$`Y°  +zŠ(¢Š(¢Š(¢Š)7WŸøÓãÇ„¼#!µÔ/VKµ80@®;áÄyXÎ9ÄŒ§¯×ÿ m‹t;tm-›§Ïs(_]ÃË€Jzí
|Ï\Ž|¿Ä¿µGŒõ¬ÇÊYF†Ö0¤õÆeÍ'pÝ›¶•NkÌ5OPÕåó¯¤’âfþ)Y¤cÐpe.äð3·œžtZGÂëJ^ÓL¼‘ &&QÏ*TÍånÈÊnÇ<×g¡~Éž5Ô˜›x¬£ ÓÌ½ÎÙ•·(ä©)ž³]Õ‡ìGvÌ~ÛªÅc*bO¿›"€>™­‹Ø’ÁÍZY¸ŽCø3ø©®ÇEý’¼`ª.ãžù”ùÓ2‚NpÛ òT
ä‚y®¾Çà‚ì‘ÌùxÚ^ íÇ ³É¹Øû³]øGG_»cl>§ÿ SAáÝ6ÝÄ°ÚÁŽŒ±(#èB‚*ï’ŸÝ£ÈOîÈTw\¡ŠxÒHÛª²‚ÕXXŸÃ?ê›~Û¥ÙÍ·¦è§Ê+>O‚^pTèÖ8#B þ Aô ‚:Šä5ßÙ7ÁZŒelášÂLš	X÷Ýó%ÇœÆW àžàçš—ìHÊéÚ¸/»…–ßo<ŠMÛ€Ç! cž <y—ŒfßxY~Ô-…ì çÌ´&R¸?)1íK…ÏÞÌk ^…³U<9ñÏÆþeo&h£$yW`È§Ê´m”Œaf£!BŽž¹àßÛ;2%¿Š,6£`­IÈ=5´¼•ä#•Ù@8p+è¯xÏHñU°½Ñ.£º„ã%%sü2!ÃÆÞªê¤VÕQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQ^IñÛá§‰> 5ž™¤ÞEi¤æéX¶]¸ò‹Gýühb3,k½·¸m«Œ?
~È~ÒgÕå›S•H%_ÄH9Ž,;Ž™Y%elt }ÊÖÖ+hÖcT  T` ; *Z(¢Š(¢Š(¤f
2N ¨`¿·¸A$2£¡èÊÀŽ88 ‘ÁàÕ{ÏiÖGeÕÔ163‡‘TýpÌ8®CÅ<!áq‹ýF'—ŒEóœç‘òÃ¼(=™Ê®pkÇ¼UûjA¼?§™1ŸÞÝ8QÁ ;Üî#{¡kÄ<gñãÅÞ.fKËéÝ¿å…¿î£J•Œù’’H–W'¶ ã4½QÖeû6Ÿ·2Ÿùg
3·â±† ñÉl	'‚kÙ¼û"x›ZÛ6¯åé–äô”ï—ˆ"%W#8ó&Êr=“Ãß±ï…tõÎ£-Íó¹Ëˆ“#;±![kç<Ž@ êkÔ<-ðÏÃ~Ñ´û{gþú .z‘™_t‡Ž2Ç àq]>(ÅQEQEQE£ªßiVš‚yWÇ2vD9àœ0#$3é^5ñCö[ðÿ ˆíOC—©(ÊÁX\ùg4+€Œ,*®Œw ÊŸ˜¼KàŸü&¿K™Ä¶O»ÝA!ØøÃafM Ža‘Ç–Ã }ð‡ö©Óu+DÓüe0³Ô“åHŠQŒ«»(+o/H­ˆ˜ñ°#_}°ÔmõVæÒTšWF§èÊH?YÍQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEfŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢°üeã?ÂzdÚÆ© ŽT°€ÎßÃ@ã|’6w9<_	üLøùâ?;Áu1·ÓØ¶°±ã«+Œ=Ë 3HDlÃrÄ¢¼è	z…?€#ù`R}Ûp3ß#?™l+§ðçÃOø›þA6NôŒˆÎ1œJþ\%°A 9f¯Pðçìuâ›ö©½µ„_í9•údb8B®3ÁÌÀ‚ÊG5í^ý’ü+¡‘.§æj“œMòFlA{ù&yãëÚ>a¢Â-´Ëx­a…\a IüêýQEQEQEQEQEWÔ4ë}Fµ¼‰&‚A†I2‘èÊÀƒøŠð?‰ÿ ²N›­3_øMÓMº9&Ç6eí˜¶ÐÛÅ‘G>ªiž9ø/{µdšÃÌ?$¶è%8ì
›yXæ9bY€ c½ïáOíg¦ë–>.cy¢áAò¶d›VÎÞZË	î¡!™&A,L¬AÀŒ‚äpG"ŸEQEQEQEQEQEQEQEQEQEQEQEQEQš3Uî5kc‰åHÉ Ì'î˜ŽOaÔö§Øü´Oûèm‡ûëÿ }ñ ÞÀ?å¢ÿ ßCük'ZñÆ‰¢«6¥mo±w$ª=B¼ŽÃ çµyî±ûTø#MÇÌ×d1SöxY—â?–Ž¤ð
3sÛÂë_¶Å„X^—$¿1ÉžeŽÄ–vÜ{«Ç®x®^ãöÙÖ™ÉƒN³Dì¥b>¬6üVþØ~1bHû"ƒØ@N=²eú‘šÊÔÿ jÏ]¸xoRÜ±A>§Íÿ À…Sÿ †žñÿ ýýø‡ÿ UÝ/ö¬ñÍ›nšõ.1‰`_Ýy'#ëøW]¥þÚºìúÆÒà/ß*d›ÜcÍD?Ea]÷‡ÿ líê<êÖW6ÒãŸ+lÊNO æ'9t\ò â»ÏþÑ~	ÖÜC¢°ÈÛp·
ÐòÜ*¬lÀðv¹#œô[k¸n£[ºÉ«!y2äG#¥Kš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŒÔWWQZÆÓÎëH3±@’ÌØ
 êI¾~ø¡û[iº8{	ªêXæá³ä'Q” ¸*q¥!ç™IkÁôxßãV£ö™K 	s9Û@õ
TykÐ~æÙBOÏ’=ëÂ¿±¾`]nê{Ùq‚‘Ÿ&<ŸM›§%Nv“(Èá”õ®òÛöuð$1¬Ù0¾Ðçgf>ìÅòÌz–<“QÙ~Î~°¿]V-=wÄw¬lîÐ‚}Ù£8å€`@˜ÀéüµcËÀÛŽ˜í€8 éRbŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š£¬èÖzÅ«Øj0Gsm(ÃÇ"†Sé•lŒŽ õA¯”> þÇš´’ÝøRH§²9d†W)2çþY+²´R…ä+ÈèÅ0­¹²Ç;áWÆÝwámòx_ÅÐÌ4ÈÉSˆD°p²ÁŸõ¶û&$.¸;­Û-¾½ðÿ ˆôÿ Ù¦£¤Î—6Ò«Ær=pÃª0þ$`O£EQEQEQEQEQEQEQEQEQEQEQEŠ­}©[XFg¼•!‰A%¤` É%˜€ î{W­þÑÑßÊ›SŽg©êÓ`Ž¹0+€3À9Á<f¸½GöÉð¬(~Ëm{3ƒ€
"=w¼‡Ø®{q\_ˆ¿myÎSDÓcN˜{™ù\ /\m>oc”¯(ñWí	ã/!ŽâúHmÎKp!CÛÑæBym¹Á
¼þòúæúS=Ëù²·V‘÷1ì2òcôÏ©l´Ë­AÌv±œ‘ z‘n>µ|x7Y<‹+ƒÿ l%ÿ ãtÂ!¬ùrŸ?õÂOë]Óþø›Q¬´Ë¹B%³àÈ*§<gŽœÕãðWÆLrt‹âO¬-ýMMgðÆ—ryQéa¿ÛŒ ÿ ¾¥dOüzº/öVñÅèböKÜßMçè#3dù#é]D_±g‰ß¼±F”þêÅ[²ýŠ5¦“z…¤qú¢Èçþù>Pÿ ÇëH~Ä7?ôˆÛ³Yèÿ †!¹ÿ  Ä_ø
ßü~°<Oûx†Á<Í"âÞü’œÂùäáD†XØp:È„“Œqšñ¯x[ð´žVµg=¡Î•Sþä£t/Óød>Ù¬DIGÜƒéÈüqk¢ð§Ä}ÂÑ/&´'9T?!'Œ¼…¡1ç¾s‚=ãÁ_¶…ÔX‡Äöi:ÿ Ï[o‘úÿ gîJ„œ ¼’>‰ð'ÅÇP´ºÈ•Ð$,6J™èd…°ásÀpl~ëêÁÏ4QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEŠò¿Œ?4¯‡©öTóVp
Û«` =æPD¼©ƒ,„`(\°ùîê?‰Ÿ%i„‚Í½ ÈÜ¤nËÜã †"àá²6ägÙ¾~ÊZ‡ã[Ÿ…ÕoÏ$8>Bú…¹”Áy‹gøQ"½²ÒÒ+HÖtXâA…DTÐ*® ¶ME€(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+—ñïÃmÇVFÃ[€Iõr¯Æ½¸,™ÀÜ¼£ŽXq_+x¿á7~M&µá»¹dÓÔ’Ó[ä¾ÙhD‘°õ—d‘ñ–ò zŸÁ_Ú~×ÄÏâ}–ºœ®#†TE1<*YaˆÀRÆ9‚ÆÛÈJ÷ê(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¢º»ŠÖ&žáÖ8eÈ
rÌØ äšñoþÖ^ÐA¥—ÕnFaÂÄ ü×aXõ…dc##>âÿ ÚÛÅšÑhô÷‹M€ð¹ñÏÞž`yçªElm<×ë$Ôu©<íJâ[©9;¦vó€Oï HUP ¨²J@;gøgò®ÛÁŸüQââ­¦XÊ`l:AåD çÍ—nî#ËI3FFHöÏ	þÅRåeñ ª?Š+T$ö8óæà;aÈ8enÕì~ýü¡*yzr\È„7™tL¬HÎ$ÊŸ›j MÜ…»?ÁÚ.šÅì¬m cÁ1ÂŠ~„ªƒZqZE	ÌHªO÷@È
—bŠ(Å¢Š(£¨nì ¼‰­îcYba†GPÊAà‚¬ ‚AÈé\uïÁ/^HÓM£Ù—n¤DÛ¢mðÄø»öKðž´M4K¦ÎrG”Û£ü`—rè#dîy<×ÏŸ?eßøX´Öÿ iÚ O™j	`üô¶bfSŒœÇç.$¾a¦jÚ—‡nÅÕŒ²Û]@Øßu ò¤Œ2òhÜ`òN8öÿ þØž!Óa×b‹Q·àÿ U7P	€Âä.N$ÜßÄ¢¾•øqñ§ÃÞ?@ºTû/îki°²€1–’² $ñ3¯8$+»Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š|ûñ3âˆ¼]¬Éà†ç÷‚·—ŠpôdYÎå…#ä<Zg“1À2ŒÃ¬ømû<h>y|ƒSÕ‰Þ÷3À9ûÍN]PçþZ6ùØòîOOUT
  pô”´QEQEQEQEQEQEQEQEQHÊÁæ¼¿Æÿ ³¿†¼I2ßÛÃý~’	|ë`3÷ÐŒG&Jçp
à’Á²N}FŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¶+Ï|mñïÂ^ßíâÏt™Í½·ïdÈÚÁÈ‰ãgŒrps^ãÛCR¸c†ìãµ'÷—½“ˆ
ÂßòÈ ðÕâž/ø•â¹›Z¼–tè›lC’ß,¶yà•gÀ_˜•'‡þø—Ä€I¦i÷7
ÀëƒÂŸ6M‘í8ûÁŠ€2Héþý|S©}Q Óõ7šãœGÉœÀŠ° n^kØü+û x[M„aæÔg#“½¡@xÉHà`ýAÇ™,‡8½BøEáMU¸Ót»X¦@ ,3`‚÷Ù îûÙk®TÀè:õ©h¢Š(¢Š(¢Š(¢Š( ×ãß„ñÌxÖ-TÜ BÜGòL¿IW–9Ù t'ª×Éÿ ÿ e­wÂ¦Kí KN^wF?|ƒþšÛ¨ù‚÷’Ã˜Ôd×Xj:dÑÝÚHÑMI°ÊÃÈëÊ°ãAìÃë/‚ÿ µmµúÅ¤xÉÄ7 [Ò@G=Ú€ÀñßÜ¹Éo)°ÒpÎ“ ’&Œ2¬§ ƒÈ*FAt âŸEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEW+ã_	_x¡RÉ/ä°ÓÎ~Ð¶à	¥¸9ò"ÆíþZ\•ÄˆªUô<'àÝ+ÂvI¦h–émlŸÂ½Xãäs—‘È.ä±õ­¡EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQFi²H¨¥Ø€ d“À¹$ð¹¯6ñ·íá/
+¤·‹wvœyÄHÙç‡p|¨°F	‘Æ28äWË?¿ioxÐµ¥£;N9L,w88ÇŸ8Úï‘åÆ#CyƒçÞðNµâÉÍ¦k-Ô‹Ëð¹àyŒvÅ=äu=N${ïƒ?bë¹Õgñ-êÛ9†ØpOfžAå)öDýpŒ·¼ø3à„ü"éö(÷ çÏŸ÷²vä<™	Ê‚jŠÌI'»
 À¸¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(Åy§ÄoÙûÃ7Ýq<d¿n~Óo…bxÿ \˜1OÓÈ¥ÀÈW\šù+â—ìûâ ºtû^šPƒ´×xòÏoèKˆ’›“Š­ðÇãÇˆ~ºÃk/Ÿ`Ík1&<Œ$ÖîFpÑæ<¶æ‰ëìo†¼?ñv2ýŸPÁ-i1N:´D“ÇÜ<d¸.¨x¯C¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š1EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE#8kÅ~&þÔº„ä{-´ïÓ*Â6aÁY'ù·:Ÿ¼¬„`†*kåŸˆ<Iã·hµ‚¶„ñmR!è
)/1Þ™ŸÙW ­ðÿ áˆ¼!]"Ü˜áæùp¡äàÉ‚³ÁŽ‘ÆrÁG5ô‡ÿ cOÛ7‰.^þNñE˜¢íò³gpyß ò¹ ×½èºŽ‡l¶:\Û['ÝŽ%
£ß
IîNIîjýQEQEQEQEQEQEQE5ã
°OÔx#Ø×Ïßd½7]-áVNºê``~ÎÜ`	ó[pNÅxÉ91çšùkÅ~×þjo©Å-¥Ê’ñ:±ÁÚqæÁ<gŽäe‘sóªô?Eüý«cº£øÙÖ98XïpO m¼…}Ãþ>Ûp,dno¦a¸IÕdˆ‡FVSAäFA±¤¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¹Ÿ|EÑ¼f/õ¹ü¥n#Fé$=Ö‡.FFãÂ 9vQÍ|qñkö–ÖülÍe§–Óô¾WÊ¾ypÄÉ´œŸ&-±Ä;MŠàüðß^ñµÇÙ´[Y.
ÀÛtÏ›3b(ðvÌ™;c'8úoá·ì}¦é›nü[ ½œ`ýž"VŒÞIòÍ?#§î£#†«èM7L¶Ó-ÒÎÆ$‚Þ #BªÐ*¨  «X¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬_ø;KñuƒéZÌ{gçX}Ù#q†ŽEìÊAÆAÈ$—<}ûj:z5ß….~Úª2 ›lsqžP2±ôe„Ÿï‡Œøñ‡ÅïH¿ŠG´FÌ–W!¯Qºl˜ríÜöç}}ƒðçâž‹ãë?µhó~õ 2ÀøÅž˜€Ÿ”vH¥£q÷[µuù¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠBqÍyÅº€íÞ!"]ê¥O—mƒÐ5Ë®D1‚rC~ñðDhOO‰<eã}kÇú™¿Õ$iî$"4USµA?$0D»Š®O»Û.åÛ‘ï¿d£p‘ê¾4Ý6,á˜‘ö©æ9æÈ~0òR¾¢Ò4K-Õ,4Øc¶µˆa#B¨ú*àdžI<“’I&®ÑEQEQEQEQEQEQEQEQEW-ãÿ †Ú/Ž¬–· “êå_–HÏ÷¢”|Ëî§(ýH¯üið‹Åÿ ï¿¶ô©$kHÏÉymü#†ÛsÌbR@Þ’,–²¤p¶|ý§m|Tñh¾%Ûmª¹	«ÄS|ªrO“;œá	ò¤86æ	^úh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*®§ªZévÒ^ßÊ[Ä»žI*¨õfl ?Ošùãßí6<Ažð«<v,@–ë%aÔÇü¯ýöl<Ãå
±’Íã^ øs¬øúûû7Eˆ;¹ÝŽØÑzo•À;TŸ”#B)Á+ö·Â€'€.B‹ÍTn¤_ºy[FKu!Š–Rdq÷Üô¯QQEQEQEQEQEQEQEQEQEQE5ãWR®R0AèAà‚ÔùãâÏì¡g«Ôü²Êï©µo–î|’¿ñìç¨P¦øâ3óŒ/‡¿´Õß„þ¯Û\›‹3åùàf` ;æ'*d` rŽþráØ™è/üBÑ<innô+¤¸Eá×•t>’BádObÊê	®“4QEQEQEQEQEQEQEQEQEQES&•bBîBª‚I' É$ž ’O rx¯œüiûdéúMûÙè–_Úñ’¦v›ÊW#©…Ds3Gœ€ï³Þ@P†®¯á—í;áÿ J–™Óoä *JÀÆìxÙøUÜO
’¬nßÂ§¥{4´QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE#0^M|AûK|k>2Ô±´™s£Y±Á&”e^fÏXã9Kq´dï—'txñ]>Æ]Fâ;XÉ4Î¨Š:³1Úˆ3üNÄ(úäð~†|øYmðïDKÃ^Í‰.¥þô˜û«É(W÷qªà‘½ØžúŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÍyïÅÏƒ:OÄK&ŽåVI]*üÊFHI1ƒ,’&<Y
¸¾Õ¬<AðÓ[{gyluR xœŽ9d¹C¬2®Õ€÷ß„?µÄ“Ï•ãM/”mÚz)»Œ|Y¸iâ¨H2FªK/Ô±Ê² Êr¤dÐŽ ‚8 ö#¯QÅ>Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯•ÿ ko‹òÇ'ü!zT…T(kÖS÷·ÑÚ9Ú¬³ŽŽ6Ê—ç¿gk¿ˆju]BSi¥+”Þd‘‡°Ê(Cò¼Î¬¡²¨ŒT°÷~Èþ¸Òž-ÏƒPD&7yK«°	4rd8É‹Ëdl2£i›öaø³'‰´÷ðæ¯!mWN^œ¼ƒ³sËÉþæFêÃË‘¹s^éEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEùïö¯ø·'‡tõð¾šû/oÐ´Î>òA’›T‚
½Ã‚¡°@‰%ÀÜTŒ]‹Ïáíè;W²~Ê§-å¸Éû$S\(ì]BÄ›½—Ï.1Îõ^Ù¯»‡J(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šóÿ ‹´¯ˆÖF+ !Ô#R ºQ–Nûr<ØXýèØñÈQðÕñÄ„Úï€.üZ"fÄS§1I×ý[öb&)Ê~V1è~~ÐÞ#ðd–öÆáî´¨HSk&là†FlLª?r†58]›IÇÝñ>Ÿâm>_I™g´œnG‘V^¨èr®Œ++VŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šå¾&øÞ/èzìÃs@˜‰?¿+|ÇÀ$Ä…ØÀ¯ÎMSV¹Õ.å¾½Ís+3¼Õ˜òÏÆ0s÷p U
  ¢¿L<1£Zèze¶™b¡-í¢HÐ{ 9>¬Ç,Ç»{Ö”Žª71À’}$Ÿ`+à|D‹ÃŸÄvÏ›&¾œ¹	¥q!À Dë0 uŒcGß°N“"ËG•È òÁAA©(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( ×Áµ.¨o|s~…vˆ0Žzí\·¶LØÇ¶{×‘Wº~Ç×QÃã ŽÁZ[K„@N2s›WÕ¶£¶?º¤ö¯¸QEQEQEQEQEQEQEQEQEQEQEGZÑ,µ»Y4ýJ¸µ™J¼n2<t=ìÃ§A¯þ3~Ë7þy5o«^i¹,Ñ}é¡ÉÈ<ÜÄ8duR$K×˜|8ø©­|=¿[­6V–Ì°1>T££	TT<å°PýÅðãã?‡ü}þÌœ%àPdµí•Nm ñ2àKä>ÇŠîÁ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+œñgÄ]ÂI¿]¾†ÔJ£·ïgd+™_uHÉ s_þÐ¿ÏÄ+ˆôí5-&ÕË |n•ñ°O"òc
¥„QîÜÂ¯‹«9ë^ý§üe¡ÙE§Ct’E„C4K#*™	W`£…Ý’ IÆj§Œ?hÏx¦ÉôËÛ°¶²‚²$1¬{ÔõGeÜåÈe»!‰ƒæ%Žwwÿ ?ç+Õ¾~Òž)ðU’iv¯Íœ|$w*Ï±»ˆé"®8TbèŸÂ ÂTÓ?m¶2bûI_/òÊàç=¸š5]§Ÿâ$qÖ»MöÁð–¢Þ]ìwV$ KItÉà€Ð4µzïdA~+Ñ4ŒÖ#±Õ¬ä’FÚ¨fUr})
9Ïo—¨&ºØ¦YTI­È ä¡ž(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( ×ç/ÆýUµOê×´âòXÆÞ˜lÏ<íˆgß5ÄØŒóôOá[^	ñMÏ…u{]jËý}¬«"Œà0<lpp²ÆZ6ã£gµ~øGÅv>*Ó Öt·[\ aÏ*Ž7;d²Ž§•`ElQEQEQEQEQEQEQEQEQEQEQEQHE|ññëöfO´¾ ðº¤z‰å¶áVvê^&áb¸aÁ¿w1Áb—? nºÒîpKÃqÝ]NÖmxÝYH8 ‚5ô—ÁOÚ¶K1ã&i`%ïÞté…¹P3,cŸß®dA"²æAõ…µÔWQ$öî²E"†VSÊyVV¬AT´QEQEQEQEQEQEQEQI¸Wã~ðtlÚìopVÞ$•ºã¡;AÁùä(ƒ-Å|ÝãÛ]ÔYàðü1éöç ;,ØèsbØŽp\a²|TÔï5;‰/¯dy'™‹<ŽIf'‚K™AÂŽ UâºáŠu‚E–™w&6óä²›îÓ—Ô ä+©±ý—<{q2E&›ä£{ˆv¯»yrHøÿ v6>ÕØiß±wˆ¦}ÕÝœŸ»™]È¨¼úmãÖ®ÿ Ãkô´ÿ ¾%ÿ ?á‰uúÚßÿ Mkûj.Ø¹Õmã_Xáw?L<‘Œ{çð«éû`|úÖ[Ú×úÉýjýŸìKb„ZVÿ r_ËsIÖ®^þÅºD‘8·ÔîVr>V’8™AìYUQ™Ù¤úŠó|ø‡ðéþÑ Ü\ÜÙ§ÍæØÈê@_œ	¬Ã’VÚ‹4]TŽ@kþý¬¼IáÙŽŸâ«qz±ðÛÇ‘:ŸF,«žA!ã±ÎN@µ þÖ¾Ô›eÙ¹°;‚æx²¼ÿ {v™QAàîÁïŒs^»£ë–:ÍºÝé—ÜÀÝ'§¿ÞBE^Îh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢³<Oq§iWw¶Qù·0A,‘§÷U™€OÌÀ>Õù‘}s%ÜÆiÎé$;˜ú–ùÙ°0æbp 8
û/öwøkáýsáü_ÚVPÌÚ‹Oç;(.vÈñE²O¿#M›mq¸rI¯•~'x0ø;_¼ÐÃ4‰k)Uv,„‰Û ”`€XŽ8®ÓàÇ	¾^µ­Ú™t‹·dy[…ûD#¼@Gÿ -‘@‘WwÝZN­k«ÚÅ¨iò¬ö³¨xäC•`zB
A ‚*ÝQEQEQEQEQEQEQEQEQEQEQEšð¿³^3¼“^Ð¦KkùFfŠLùr°+®Z	Y@W;7!X¢°fo‘<UáOÂwï¦jð½µÔX%[Ðý×F\«ÆßÃ"¤‚2=à×í«x	–Âë7ºA °cùžÕÛ„8$˜\ˆXô1IûCÀþ?Ò|m`5=a4\SÃÆØÉŽd<£Œû«uFeÁ®ŽŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¼ëâ‡Ç_ü>ÿ F¿vŸP*m¡Á|ºò³Ž=AvÞG(_%üQý£üCã}Ö¨ÿ `ÓŽÑàfÅÄà«ÍßåQ\ò€kÏ¼9áSÄ÷i¦é=ÍÌœ¬qŽÜìxD@H,…QxÜÙÀ¯§<	ûÛÄ‰sâ›ÆyÁkò…89W¹p]È$dÆ‘ŒƒË)¯qðÂø=è¶BãþZ¾C×¬Ò—ýã»  âºÍ´¸¢Š(¢Š(#5GSÐìuXŒ…¼W6r²¢¸äm<0<HÏ\w¯ø…û$h:ÐkŸ1Òîù;^<uŒðäf
:ùmŒWÎ×¾
ñçÃ+æšní^,·Ÿm½£e\Éx™ý¡€Ë‘ÇyáÛ^ÓU`×­¡¿UÀÞ¿¹õÉb¡áfÎÜ‘ã,kÚ<	ûPøWÅ2­¤îúmÓª·;B1ãåK„f‹%‰UYnØÎÑ+×‘Ã€ËÈ<‚;úz}©h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š|ûJü8ÿ „7ÄÒËl›l/ós:ŸôˆG'TÍ¸  Ê€}Ó_E~É> ¶¿ðji°·ïì&•$^ø•Úâ'²²ÈT´Œ:Œ¿Æß|-ã;‰/õkBo¤EC<r28Âµ¶åÜÈIP² ÇÆ?>Þü7ÔþÍ!ó¬'ËÛOŒP~häQ€³E‘¼/ÊêD‰¹W¶ý™>7·…¯—Ãš¼‡û&òO•ŽO“3áUÁþ&l,ÃRFeCI_jƒKEQEQEQEQEQEQEQEQEQEQEQEÈ|EøY¢xú×ìºÄ9‘N˜YcÏ'Ëƒò’èØ4müJz×Æ?¿gý_áã¼ý¯Jc…¹E .NÕK•ù„.I[&$ ÊØSÆx+Çz·‚õõ-"v†hÈÜ¼•uÌSÇ²ÆA#k`¡;ãdp¾ÕøCûDhÞ=	cpE–°F<‡?,„³ZÈxqÔùM¶e ¬£uzÞEQEQEQEQEQEQEf¾øóûL[ø]eÐ¼2âm\’M€ÑÁýà¹Èšår Lâc™IeòÏÇšŽ¡{®]=ÝÛ¼÷3¾YØ–fvõ<–v< q€ ( {Ã/ÙSÄ&1Ýë#û3O$12ß:ðO•nÕî€÷vœ%Çõ×>èþ²~‹Ä¸ùä<É#pÍ'Þvlg"ôEQ]5QEQEQE„q^ñ›ödƒÇ‚júD°Ø\²í¸+!r_Ý+(G$"í'9ó{ÿ Ø¯Y†öZ´³ãî2<k×$Ì¹yËÆyã5tŸŠŸ¡ûTm/ödæ
âæÜ(ãç‰Žø#;¸`!«ë^åðcö‰Ó¼y³LÔÙëX9‹?»—M»1Îð0ÍþñFâ»Ð¯bÎh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠóŸŽ
ÇÄ=ØÀU/íÛÍ¶wÎÝØÚñ9ªL„¡lµö¸¯—¾x¦ãá§ŒÎ™®†´†rm.VC´FÙÝ’dÚ’p$Ç?˜¬S¯ÜÊÙæ¹¯ˆž Óüu¤K£j`„|4r.7G"ò’¦x%O§‡BÈx5ðÄ†ú§ÃýQôÝM:e£‘s²Dè$Œž¨z2“º6ù¬ßVþËŸÅ:Zø{S—:¥‚a´Ð.¾H’ˆå,FÉI;Î=ÞŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¨o,`½…í®‘e†U*èà2²žY[*ÊAÁ`Šù‹âçìˆ'iuO°ræÆB õÛi3pƒ#å†c°dí•¯˜56ûA»{[Èä·º€tu*èÜ2ä2œÈÃ¨;‘ˆæ½÷á?ík¤ìÓ¼XúÐaDëƒ:óÖLí[• ÿ ³6˜zý_áiž(³]KF¸K›gèÈsƒÝ]~ò8îŒÔVµQEQEQEQEQES&™aRò¨£$“€ ä’O äð+ä_´åÆ«$š„%1ià2Mr¼<ÙùJBßz;n¿¼\I1û…#8øUð+\ø!šÔ-¾ž„«ÜË÷˜ãŒaæg%Tª/ü´pÇiúÿ áÀ_xV{XþÓ¨ƒu0‡r!@6@¼ÿ  ÞGÞv95é bŠ(¢Š(¢Š(¢Š(¢Š)“B“#G*†FYXdx*ÀðAx#­|]ñ·öyÖ<3ªÉ«øZÞYô·o5º–{vÈ>^ÄÝ.ÈØî‚hÔùkò>Ð›¢|ý©­®ãDñ£ù‰„[Â1ã
Ïüð˜žLXƒ¸ÆÙZú2„H˜:8Ê²œ‚Bd{qRQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEx§í'ð`xÏNþÚÒ¢S¬Ù)à ñuxKq—ŒeàÉëº1'ýš>/Câí4[é·k…mÙÌ°®;•'%ØecŸ’Ë ÀZöšæ|}ðóHñÕÓ5¨· %£u;^6Æ7Äã•8ûÊrŽ8ua_xûáæ½ðS^·¿µ”´a¼Ë[¤Ê†Û2)P£m8š,´rÄÌT
§Ø_
~*éŸ´Ä½³tKÕEûM°l´LrAÃ4LA1K®¿íoEQEQEQEQEQEQEQEQEQEQEQEQ\WÄ„zÄo'W‡¨"+ˆð%Lã;X‚N hä„v‘ñ—ÅoÙÿ ]ø~MÄËö­7 ¨”íç´ÑüÍnÄð³DÇ¤ƒ!k•ð/Ä-cÀú‚ê:DÍ€èrREòÊxø!œ:gtl¬}Ãð‡ãŽ‘ñÜGúª.émY²p82ÂÄ/›HÉ <dí‘Aäú^sEQEQEQET7w°YÄ×2,P Ë;ª u,Í…P=Iãþ)ý«¼£3Ei$ºŒ©ÿ >éû¼ä‰å)à“¹¯s»ŠáuÛrÝ%"ËHw‹±’áTûåQ%_üxÔÚ_íµc&ï·éRÆGO*tÏÌãðÍwžý©<­á..ÂR3‹¤*½2@™7ÄqÓ–RÇî‚+¼¹ø‹á»xZâMNÌF‹¸Ÿ>3×8Iã°ûWÆŸ~=^øÚþm?MšH´(›lq©Ú&ÛÁž`0Î²š(¤;Q3!rqŸð'àœÿ oä7Öúm®Ó<ª>b[%!‡p)æ°™ŽDI†ÚÅÓtøcÃ6ÓáÒ4˜–KuÚˆ?6fcË;±,îÄ³±,Ç&µ(¢Š(¢Š(¢Š(¢Š(¢Š("¼KãOì×cãw“XÒlõ‚	lÝLq€fU£”à)™Èÿ [œcçßxïÆõ&Ò.Ñ–ÝNç´Ÿ˜I9–Ý×;Ø–°·Ä[õ‡ÂÏ:Ä;pl_É¿Q™-d#Ì^™hñÄÐ‚p%AŽ›Õß†Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š|µñ÷Á—?u«oˆ¾_³£LÊ !„çs¢ð ½ŠuùWÍÚã÷Ž{wÂ¯ŠúgÄM8^Ø‘Ô`‹f9x˜þ[â~±J×^×‹Û×7ñÀ–7Ò&Ñu5ù$I £q÷&ŒžŽ‡ÜnRÈxc_]¦¿ðwÅ,‘1·¾´o•°vK<6Òq-­À¦NÖÊåfŒ5}­ð‹âöñMV¤E}æØœ²1èêx/˜&9 õW
êÊ;Ú(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠdÐ$ÈÑÊ¡Ñ†Xdx ƒAx5ò÷ÆÙ<K¿VðJêÒYŽÄ–´v8É8ÿ Fr“å:p‡æH'Ô|7|$ŒÍg{lÿ íG$l8 •ãqÈ ‘C)Áú—áíkóÃ¤xÅV)[j-êð„žº‹¤;ŽÐÓFL[Ž]b^kéˆ¤YT:U†A ƒÈ Ž#GEQEQEQ^kñã¦‘ðâ!ãí:œªZ+d88è$ùòb-ò©ÚÏ!DµŠü´¾"ñoÇ­~-[€9gr°Cà»˜×3/Ê¥/#Hà)‰IÛîÞý¼/bê“Ý_ÊFÏå&xÁU„	#æ•ÎHÎ*æ­û"x2÷onívç>\å³õûBÍŒ³·ß5Çjß±5£'üKuWVÝÒx†Þx-DÅ³›¡ÁÊóÇ”xËöcñ…b{µ…o-Ó$½£ z¼,©0øŠ	 ô#&¼™Ùã<€=ðäp#ó®DNz××ß±¯l_NºðËmŽõek”Î•*¾ÞìÐ2 Ã¨FVà¥AÍQEQEQEQEQEQ\×~hþ8ÓÛMÖáó;‘×‰#nÒC&	FÇ*Ã*êÊH¯Š>&|'×¾ê‰{lïöO0›[ØŽÓœŠÐ\lr}É@o,²æ5õ„ÿ µâ°M;Æ«óp¢ö%ÿ Ç®`NžòÂ
÷h×­}1¤ëz½º^éóGqo ÊÉR:ðÊHúŽ£¸«”S$™b¤!G©8™Àü*­¶¹cu#Coq’!Ã*H¤ƒèÊ¤}ˆÍ]¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢«^jVÖ(Ò]J‘"©fg` Õ‰b QÜžpÞ øýà­”ºÔá’@Bíƒ3[¤LXœ@$^q¯þÚ²°Òlnn_nA˜¬+œã™d#9T'1œãŠ¹ý¶u–—tu¢CýÖy½ÿ xkŸCåŒzê|=ûjéÓ°]gM– OÞ‚A.:”@äîã
 çwW§x3ö‚ð‹e[[;Ï"éøXnTÄÄó…FÝHÜ}ØäcÈã'èÊÁ€ äÿ ýzZ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢©ëM¶¯i6Ÿ}–Úá9º2°ÚÀúpx#y"¾-ñ¯üAð#Ä1ëº<…ìÈ‚r2¬„îk+ÅÄÊ9#nß>“+(úÏá§ÄM?ÇšDZ¾žÀ1f‹9h¤ç‰ú(ØD*ëÁ®¬s^uñ³á¯Ä}+ìÿ ,Z•¾ZÚfÁ?zÃy2àÁÊ0Y %0~¶½Ö|	«!ilu9
žÌŒ§æF«¡þ$`c•8!büý¡Sâ:>ª‹¯oRœ$Ê0‘Oú¹PÏXl;ãböÐh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(®âGÁ¯øþ/øšÁ²íFê,,«× ¾•Oîåœ’ <×ÇŸ?gxµÞß¶é£¥Ô*p£ý¦"Y­ú¶^@óµ£ðcö‹Õ<é§j;ï4såóD3ËÚ±è0IòùOå˜Éù¾Ðð‡tŸYKD¸K˜´üÈØËš3óÅ Ž`ƒÈ Ê(¢Š(¢Š(n•óOÆïÚ iO xOr›£’ðò¨Ãåu¶CÄŽ‡r™Ÿ÷JÀíY¯“5=RçS¸{ËÙiåmÎîK3ï;6K¯AÀ qW|)â«ÿ jjÚT¦¨U‡=F2œ««.U‘†Ç>Žðí§*í‹Ä–
ãŒËjÛOa“Ùãs“rp¡@æ½—Á¿´7ƒ¼RË½è¶¹|b¡å1'€ªÏû©‘ŒG#r@5éƒr)kËüû:ø[ÆM%Ì°;é2LöÄ!f?Å,X1LsË]ä7s_$|Tø¯ü?s5Ê}§Nà-Ü ìç€³)Ë[¿O¿˜‰`V<EÖnô+È¯ìdhn`pèëÕYyzú2žK+pÆ¾ûø-ñ¢Ãâ5†FØuH}¢þ|9å sÿ ‰¿w';Y½&Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬ïø~ËÄ62ézœK=¥Â”tnã±ª²Ÿ™a•€e ŠüüøÇð²ïáÎ°té›Í·y–ó}3´ì²¡ÂÊ£øˆuù\Ïø[Çº×…f5ÜÖ¯œŸ-°§±ó#!¢“ ûñ±àsÀ¯Mö¹ñª(S4@&Ýr}Îž§ÏaPßþÖ^6¹…¢K¨¡cž;t0A;K™Td£pN0yqâë~"búµä÷DœâY‡RÀÉ€	%@O—øp Æ<7RÀâXŽÇReùH#U—k)ªA÷¯cømûRxÂ¥-u:‚ðRv>búesËñÐ,ÂEÀÀd#ë‡tˆÆmoßF›o Û,y üÑäîNp%Œ¼D‚ä;,ÑEQEQEQEQEQEQEQEQEQEQEf²<OâÝ+Ã¦ÿ Z¹ŽÖÜ‡?ÝEûÎÇ² b}+çï~Ù–6¡ ð½›O È]e>«fg8s~„`ø‰¿hëå„Ú”°FßÁmˆTq´€cRI;¥<œ€ç÷ú½Õûù·r4®7HÅÎ:€Rä“À sUŒŒÃnxôíùt£Êlg¹ãò'ˆêGæ?¦h1Qùñ¥Û$]A úèx®«Ã?<Iá–S¥j*` mP`—|eBœ
 Æ0úá×í“´ñ…¾ÒxûU²’;àËlK8à Z~Oúµôo‡<U¥ø’Ô_è×1]ÛŸã‰Áþëó#êà0î+T(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬øVÇÅZdú6©™kp»Xwï#¡ê¯€èÃ£_ÞGâÏ€~#e†M¡ÇÊøÌ1Y~é8‘[3-¶2—ûáOÅm7â&˜·Ö'Ë¹qnNZ&úñ¾&ëÀmuàípÊ½±¯ øñð"×â±¾°·
áð³(éç±ù3rc'kf6"¾#eÔü!©ÿ ËK;ûI?Ýtu?øë/â¬§ø£›ëOÙëöŽŸÅ·+áßlì¹‚áp¾q-‘•fÚ¡O–PmF\7ÐàæŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠkÆ®
°È#NàŽãÛ¥|óñƒöQ²×Lš§„öÚ^Ÿ™­˜â=ÌGŸ³ÈÇ¯XXòQNZ¾kÒõü*ÖXÇæé÷ñcÌ×†^Ë,d˜æ…²B8$rR«s_[|$ý¦4o*Xêe4íXð#výÔ‡Ÿø÷•±ó1JÁ`È>jö`h¢Š(¢Š+Ái/cÂ0Iá½çVž?ÞIÚp@+ëq"äÇÚ%ýãs±[âvbçôüÿ úúõ5½á¿k^%$hÖsÝíáŒQ–¦C?‚7‚û€9 šôï~É>1ÔÛý6(tôÜA3ÊãÊÇmæî¼ºs‘“Öjß±6¥»I§êp\NDoD¨‰'Úz˜ñÎIà^*ð†­áÇÓu›w¶9Û àŽ‚HÛ”–2rˆYs•8<WÑ³?í-D>ñ„ÆÅc³Žvg„µ”Ÿ›Ë-’v"c·a¯«Á¢™=¼s£E2‡Fe` õ§ ƒÜŠù[ã§ì²E.½àÈÎÄå±\“Œ–w³ç îû)ì¤[œ‘ùÃÃ>&¿ð¶¡©¥ÊÐÜBÛ‘×ò ƒÃ£–HØmuÊ°¿z|øÉgñ#N2 !Ô­ÀƒÇ<,ÑËC! üÑ°1¿ 3z=QEQEQEQEQEQ_&þÛí¤×Zf•ÍÕºK,€c…—jD	ê¼·`§øFkåÚÞðŸ‚5]}‡Dµ’ê|d¬`p;4ŽÅc‰O@Ò:‚p5ôWce[^yG90ZáŽ3Ñî$A#ƒåEÇg=½>ÙSÀqÆ±Ég,¥F=ÌÙ?í0GDÏûª£Ú‰¿e_º2%œ±·3d´Èë‘Ûr°õ¼Wâ—ì‹¨èÑÉ¨ø^F¿¶L±€¨êvc	s“€#˜ö7Ât­oRðÅòÝiòËiw2¬¤2œŒàãl‘º•<¬ˆzWÙhø¼nÉ¡ë¡aÖŽï-Ðb9ÀŽÕÉ1Ü*‚^.QÂ™"8&4÷PsEQEQEQEQEQEQEQEQEQEQEcx³Æ_„ì_TÖ§[{dã-ÕŽ	Æƒ-$ƒµ5òk¯jÓ²hÓ,Áù0ªóCI$ãB@Ž8Ø(,¥ØüÃÅõßjž!¸ûV©s5Ôäœ<®]†yÚ…³±}0«Œ`C¦hWº¬†d¸”ì‰Û°åcG$›'®÷Oýœ<s|¢Hô©•IÆehã#±%$HuÎÃ‘÷s]u‡ìsâÙäpö&	,ÓÇ¶Øã$ñœà{×«xGö7ðþžµÛ™¯åV3äGßŒ!iˆÁ\“09\ŒÛ^™áß‚~ðþŽ—o½F7Ê¾kõÝ’óùŒNà9ÈÀÁâ»an?åšß#ü*–©á]+VÈÔ,à¸Ÿ–H•€ÈÚq¹N	>õÃê_³o/Ê³é‰QÜ¼‘~b']ßŽk†ñ‡ìq ê
Ï ÜËa/d“3GÛœ¬ëÐò%nNH ¯œ~"üñ€ØÉ©Ûî´ÎÌ_<G°Ë€"OE™SÙš¹ß	øÛVðòê:EÃÛ\)ä©ûÝAYPü’§') `:©Vù‡ÙŸÿ i}'Æ¦=3SÃW| ¤þêVéˆ$lð|‰·8¤ šöš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(®gâÃÝ3Çz[éºeÍ‹ÃÄýh[øYsÈû®¤£‚¬E|!¨Úkÿ üLcG6÷ö”‘~ìˆyFÀâKyÂ’Ñ6pw!DÝ_mü%ø³¦|CÓVîÑ–;èÔ}¦Ø‘¾6î@Î^91J>V^2Žèó^Sñ£àñwºÄkˆæuÀû‘](º².%‹?)+”?ø¯Ázß53i©E%­ÌM¹d´‚³ÛÌ¸ íe‘0ÈØ¨ãm}#ðGö¦“V¹·ðÿ ŠÂùÒ•Š;Á…Ë„IÂ†‘°‚XþRì¡£Læ¾š:RÑEQEQEQEQEQEQEQEQEQEQEQEQ\¿Žþè¾9´û· “oú¹Wå’2q–ŠQó.p2§(Àa”‚E|gñ£ö}Ôþ}³HvÚ&	8DºŒ|¨X©"f6l#rÚø)ûLê>–-'_g¼ÑÉ#sóCœh™Žé!R>h,Ì-òùMö?‡|M§xŠÉ5-"â;›YÈÏulrŽ§†F”ð@5§š(¢Š+œø…ã[Oh·í÷)ü¨:»·ËKï#3ÑW,p šüâñ&¿uâB}RýüË›™G<à³ ’B¨Â Ïª+Ù¿fÿ €cÆ²w[iòm	È3ºà´`ñˆœLêrí˜PŒHkí3K¶Òíã²±‰ ·‰B¤q¨UP8UpZ¢¸oŒí<}¢Ma2/Û#V{YHå$ íärc“îJ‡*ÊsÊüìš&¶•’U*TÈÃpÈÀà‚¤9 ‚3Áé÷¿ìãñ%¼má¤ûcïÔ,H‚rz°0Ì@ÿ ž±ãqèdW«Õh ŒŠù—öýœ…ÿ â¯Eþ“Ì—v¨1æw{›eâžp3"bpDß;ü-øƒwàrbÔoòKA$Mƒ$[ˆ;wa]#¢“º¿@<ãÝ'Æšzêz,ÂXÎ§ñÆÄdÅ<y&9pxo¼¤©º sEQEQEQEQEQEVÔ¯•´·L,Q³: ±<r+óGÆž'»ñF«s­_œÜ]Èdo@<¸ÁÀùbˆ$i‘Ñ}É¬Ý2Ýnn#…Ø"»ª–=X)cž0 “ÏsÅ~’xÀš_‚4Èô1
Œ´‡ås÷¦•Æ7»õã
«„ETU¥Ížh"¾Aý²¼i¦êž µP’_‰ež ¬³p>óFÛç,UXò9ùóÃzÌú.¡¥jvÍm"L§Þ2$öê©Tœ_§eêßZÅv€…š5Ô€8ÈÈœ=*ÍQEQEQEQEQEQEQEQEQEV‹üu£xB×íÚíÔv±s·qùœã;brò6;"ŸS_=øïöÍŠ0öþ´,ààOuÀëÕ-ï<r¾kÇî½Îž3øƒ®xÖëíšÕËÜH3´•PJÇâ8×œâ>ûµt?~x—Ç[g±·ò¬‰ÿ ™ÉHû«àÉ6'÷JPàƒ 5ô‡d/èÁg×ä}Ràvs ƒ¸)XÉ/`Þl¥Â£Ût}ÇEmtÛx­ A€‘ @:Šx$äœsWñEQETÖ0ßBö·(²Á*•tp
²žYNC)Ò¾mñ§ìaipd¹ðÝñ€ì\&äå"YÐ¬¨‹Ê‡‘f`»AÎ	?3x§ÂÇƒïMŽ¯–·	Ù»ã4r/É*’&;O]Œ0=ÃàÇí[q£„Ñü`Ïqbª;KI†K\ÄŒ:ƒ:äJWëM\²Ö­SPÓ&ŽæÖQ•’6§±Ã2§H €E^¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¼›ö†øB¾?Ñüë%Úö@¼§˜½d¶fÁ8p7EÐ,ÁNB–ÏÄ~ñ.©àíN=GN‘í¯-Øàã‘Ùã‘†SÊKðNAÃ Ãíß­>"Ú}–ëe¾µ
æXG"Ž<ûmÄ±LãÌŒ’ð±‰RŽÞ±\çŽþé7°m7Z„Hœ˜Üpñ±ó!|Ž8ÿ e±‡¹ñÅÿ zÇÃ«¦¸Á¸ÒY€ŠéFNHŠu0Ìàñœ˜?î×Øþ ~Ó"ìÃáŸ¾&â8/ýïáH®ó‚$În:HJ‰B¿ÌßNƒš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(ªZÖk­YM¦ß –Úâ6ŽD=
°Á ÷räWÉ^=ýŽ5=:9o<9t/ÑrÂ	dÛG #©1O'¨eƒqéÏ_ð·¼Aà@Í¦Í-¤èûeŒ‚8h®mß
Är¬²(‘sò²ðkì‚ß´N›ãØÓO¿Ùg­ƒp’ž…­KÄôfÿ x€ü¦EëØAÈ¢Š(=+ãÚÿ â`ÕµHü-dù·ÓŽéñÑ§aÂôçìñ62JÃªq…û?þÏÏãÖm_UgƒI…Âü †™‡/NxHÓîË*åƒ{YY‡ÛZ^›m¥ÛGccÃm
„Ž4UQÀU ©äóV¨¢‚+ó¯ãÖ‹ãMZÊƒ  ’ ™Vä˜“Á•³Û$íãÜþÇšóØø´Ø—ÄW¶ÒFW8£+4mƒ÷˜/šª ;{}·EšùÇãì¥½<šÇ„Ù-î¤%¤µ“å‰˜œ³Àê	˜–&61ÈòòIùú_xçáµÇÛ¾Ï{§Hf‹%pi ó!xóŒ	r‡ 5Õé_µ·´ø¶M%½Ø  óA“ÀÇ-‚Ç«nÏaœW x/öÑHxžÈ*žÔŸ”“‚ím&IP$G+°ˆp+èïx³Jñ-¸¼Ñ®¢»†wFÀã¶~úA]UàŒƒZÔQEQEQEQEQHTµò'í3ð´Ù[Å·?a|›¨bùNNLÉ‚E»ä™A¿Ì ÛoÍ'(}ÿ Ïæüö¯Gð§í	ãÛ-û›tQ&U”(”P3€7°
¡@·$ý¬|rãò1ô¶úæ¹ËŸ~4ºdi5k¬ÆÛ†WŸpˆ¡‡û.}«ëOÙ³â~¡ã­
VÕð×VR,Fa€d¢Dy ¢@×*¹‚©$W¯WÌ¶ÝÔdÒm÷3}ÃíÏ;v¢nÇ÷Kg¦p+ä¸³`I =HÀ NIñ¯Ó¯	içMÒ,¬˜00ÛÄ„1ÉQA{Aµ¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+?X×ì4XMÎ§q¬ ^W0:œ±3Î+ç¿Š?µýŠµ—ƒP]Oœ©”ˆ†Éˆ”’cÁÚï²,àƒ OË!ñN©âk·Ôuk‰.ns$’$*ôXÓ$íŽ5UôRk·ðìóâŸ•šcmfØ?h¹ÌiŽ?Õ¡i¾RHØ1æ‚~œømû-øsÂ».µ1ý©~˜;¥P"S×1Ûò¤ƒÑæ27q·¥{2D±€¨ QÀ€=€°§QEQEQEšæ¼à/ÇkéÄ{£~REÀ’'þarÇSŽ9GI‘˜ƒ>(ü"Ö>ß5¾¡{fr ¹@|¹GÞ]§Ÿ.]¹ßÊÀùfHö±ÊðoÄmsÁó´[ÉmKŸœ)Ê7Nd…÷Dçå ’ñdçï„_íü} ÁªÆËö ¡.£^©(8Û’B?úÈ‰ûÑ°=rkEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQA¯žÿ hÿ Ùú/Á/‰ôÂjq)yáQþ¼(ÉtP?ãéTzbu[«ãí/U»ÑîRöÂW†xŽä’6*ÊznF\H=ˆÊ°#+_^|ý©-ü@bÑ<VË¢ä$W mŽSü).IÎÇ…<E+.Ç!+è€Àôªú–›o©ÛÉg{Oo*•xäPÊÀõVV0>â¾Hø»û(jlÒêžSudIckŸßFT‹8€HQ¹fU
¿½8#Wàí.ÚP_xáÜˆŠ+©Ü˜;W™ö¡ãÏeß
Î0×ÔvWö÷Ð¥Õ¤‹4 UÐ†RB¬¹PjÀ9¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šó‹4_ˆQµÃiªÂ]"ç=[ˆÁQ:ŒaI"DÏÈã¡øÃÇõÿ ‡WË§ŒägŒ“‘†ß+oCü$$Èy9÷‚_µYŒ&ãi(;c¾#,2FÕ»
0T´¨ <åë!úžÚî¨Ö{wY"q•t!•‡b¬¤†±Š”ÑTµ½I4»B_¹oÊßDRçÀ'Ž#&¿25-B]Jò[éÈ3LÏ38,ù•âc×< 	8¯Ò‡ž‡ÃZ†“n%½º)*0ˆ$˜99’Fg9$å«‰ø‹ûJxgÁWŸÙ’/nÐâT·ÚDgû²I#Gÿ XÑ™×áxÏIðËâÖ‹ñÙçÒ–XqæÁ(Û"nû¬@,®ŒC"3)*Fr+µ¢Šøö£P¾=Ôˆ'È'þüÆ9ü ü«OöHÐSTñœSÉÒÊ	nG^OËn˜Ç§žÄ‚pG¸÷@¢Š( €x5ÀøÛàw…|`„ßÙ$w§ƒ÷RÏñÆ qó¶Eu$çÁ¯ ñ_ì]ªÛ»I ^Ãsr©818'ÐI@	s“´'×þxÃáô¢êòÞæÈ¯Iâc·¦?ãêÙ¶Ž;¯R 5uý©<eáòêuÔ-Á-Òäã€vÜE²N@à°zÖ½‡Ã¶n‹y¶=fÆ{Iá+2tÎvþî`d±°,Ýk×ü%ñcÃ- hÚ„3Hå™m’zs»$ëÓ
Aê29®³u-QEQEQEQA¯Œj¿ƒ°øfö?éˆôûÖ+$h0#›—%Fp±ÜÌ¨ 	*°_õ€WÏ4åBÝ?Ï×Ð{ž+Õ>þÏz÷.B=,à›™T€Ãƒþ ×Aà°ƒÖBASöÇÃÿ ‡Úgt´Ò4„Û;¤‘°^W84¬ Û   TP U·ï/!³…înGj]ÝŽ¨fbp  d“_žÿ ~'7üA.£acÚ©ÈÄKœ;)èó±2°À!Ljs°cGömð!ñ_‹mVdÝigþ•6sŒFG’™|÷>V#r$@ ýü(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š	Åy'Ç_ŽÖŸ-M¥žÙõ©—1ÄyXàOpÎ?ç”Y)î fë¾$Ô5ë§¿Ôç’ææBK<¬Y¹9ùsò c
¨ *€hx'À¿oÆ£@ÓÌpXôTR@ó&ü±Æ3œœ³¸Žx¯µ>þÎz'¢K«´MCV™ä_–3émîàpd9•ÎIe(õ°1EQEQEQEUcE³Ö­dÓõ(RâÖ`UãeH<rCèÃ§AðßÇß> ½7¶
Òè·û©XÆO?f™ºïù.ßë“>jÜ7€~!êÞ	ÔQÑæ18#zÿ ŠLS'GŒäŒýèÉ/Vëúð÷ÇºŽ4ˆu­4Ÿ.L«£}èä^$‰ÀÎO ôt*êH`k¥¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( Œ×Ë´ÇìõG?Œ<7Æ’òÙG¿w¨ù\}ëˆÀÚë™Wó>RÉŒã¿çÿ Ö þ õ¯§ÿ foÚXf‡Â>"—tBZO#s¹m+·Þ‰ÏË^7"¹=¿Yš1^3ñ£öqÓ¼tÏ«i®,µ¢£çÇîå+÷Dê0UÈÂ}¡>u\nY€>J:—‹>êÀKu¦\ÂÛÌAÊ¯9O3ËÉ¶ž7ÁM€9öÀ_ÐüC°h/6E¬Zæ  	ð.!Bro–TÉÀ%YkÖh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢³µïiúý£éÚ¬	sk/ƒ úÝXve!”à‚+ä_²Ýß‡ƒk]Ø™!ûÓB1»z‘ó\B0A ãÊ’$PÅ|çá·Æßü?‘SO›Ì²ÎZÚ_šÉË˜˜óóÂ@ÝË#œçì?…ô?ˆ¤°´Õ6‚ö²°É=Í¼œ„ê¡]Ž5¯L¯?øùy¯‚5w™‚+[4`žìøŽ5îì{œWç‘9•ÈéóZý+ñåÕ†®n¬7QY;Å¸ïXËG…±Ü ëÒ¿4î§’w2JÅ¹%ŽI'æf$ä’ÌKy$’kÖeÿ I øÊÒ!Ÿ&û6’Ÿãùâm¹
vKòA!]Èç¾õQ_ ~Ó“ùÞ>Õq‚ PG´1dê}:öØ¯Â¯¶£â	W+%¬D¯'fe˜«Jï‘àm%É*@úzŠ(¢Š(Å2XU1È## ƒÁ‚àƒÚ¼ïÄ¿³Ï‚¼@æyôä‚bw-‰„“ÉbÂ"¨Å‹Ä©'Žxåúÿ ìU§JèÚ”±7e¸dÎ~ü^K·Ã6pKòïþÊÞ3ÑwIowð©8ky2ØÏÊ|™„r+0F}½7±àé_<wà™~ÇöË¨Z2At¥ð281]©•´•eÀ$)RF=£áÿ í•î¶¾-¶ÿ /6À=L¶Íº@;æ”ŒýÎ2~ŽÐ¼Aa¯Z­þ•<wVÒ}Ù#`ÃèHèÃ¡VàŒÖ…QEQEQEWñÓÂ«âoj68Ì©	ž#0ðþùãØUk0g5ùØÑåö¯sÇãÈÏàE}qû1|	ÒŸJ‡ÅºÜKuqrKÛÅ h§jÊPå^wefRùò—hPq?Kª (ÀðöÝÜV‘5ÅÃ¬qF¥ØáUG,ÌÇ@$“€+ã¯Ú7öˆ_ïð×†ßþ%JGŸ>0g ä$`à‹T`	b3;€"\Éóõ¥¬·³,1+I$ŒUFY™ŽÕU%˜€£¹5úðá,4aá[TºÄ—N0p@Â@Œ˜á’wHÒ?ñW¦QEQEQEQEQEQEQEQEQEGqp–èÒÊÁ#@Y™Ž ’ÌÇ  9$œÖ¾gø¿û[ÅfdÒ¼¶YåkÖ@GË›Xÿ å®q;â,Œ¢Êkå]WV»Ö.¤¼¾•ç¸™‹;ÈÅ™vfnIÀ<Q€@ÙþþÌš—‹ÌZ¶µºËH'# ‰¦BŒ•|ßéÏÊ>Äð—ƒ4¯	Y.¢[¥´…»`)’W?<² 3¹,p9À·EQEQEQEQERÖtk=jÒ];Q‰gµJIŒ†±ô ò¬0ÊÀ2@5ðÇ„w_õ†‡ýfŸpYíeë”˜äÿ ¦ðä?Æ»e\.7ÃŠšß€o>×£Íµýd/“€p±‚2W?+¡Y³ùÚ¿¾?ø{ÆÖˆÏ4v:€Ì¶Ôx¡v*³ÄXá\a»:+q^šy¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¤eÜ<æ¾ý¦>jƒTÓP.‘|ÄÆqœ¼–äã[æ–œì&?v¹ñEm§üÿ Ÿê:ŽkíÏÙ¿ãÄ^.³OëR¬À¤FÍöˆ×£)â5âdÀgQç(`_g»Q\·Ä†ú?ŽìŸ¬Å¸˜åS¶HÛ‘¾):Ž¼¡Ìn8u"¾ø™ðÃXøi«y·yA·ÛÝ (®;2:ŸÜÊ¤m’"á•€+¹{'ìÏñþXçÂ^$’YÄÛmn$}ÅÁ?g•¤>c#¸ýË–‘•ßÊ8M„}^h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ƒ^!ñsö_Ñü\$ÔtMšv¨Ùcµq¬y&h“ý\ÎfˆI&E’¾>ñ?„µŸj&ËT†K[˜˜2ç¾9Ya‘N«$lO_-¸³ð·ö°Ö<8«aâÚ¥ÀWvt cVg^3‰Èq“ûÒ0´|rý¥×ÇzbèZU³ÛZ;,“4Œ¬ÎPîHÂÆYV5p²1-¹™U@ |#†$ú7ò5úuá«Øu]"Òî!˜n-âp¢ú_üsøUuà=rXB§NÆKY1…(Ä‘nÍ‡˜ÙÎÅGQ´œ/ìýàËŸø¶Á!žYÒâwS€‰.8ÈRîªˆ¹Üäãw0ý	Š†òê;Xžâfj]‰èÌO  M~iøÛÄ‡Äšåæ°Ëÿ SÉ0R1ÃÈê•7ryÉï_~üðÙðï„tÍ=ÓË˜[¤’ƒŒù’:PÛr	åIÉÎ2y®ÖŠ(¢‚qYß‹ô}	Kê·Z€~öESÁ!X†8<ÍqÚ§íàM4)“UŠMÝ<•yqþðo¶ìfªÙþÓ~»•`MKc9À2C2(ïóI$jŠ=Ù€ÏMw:Œô_ “H½·ºSÏî¤V=vò î0#2kdÑ\ïŒþèþ3´6:ÝºÎŸÂý <Rž68ÁÁçp ‘_üaýœµ3ßÙî½Ò[ÏUù£ùVæ5û¤.?~‹ä±aJâ<ñ#Zð%ðÔ4yŒn~ú6LrI£DŠsÃŒH§æGÛß	>:h¿àH¢amª„Ý%«žxûÏnÇ|@‚w/Îƒb©¯IÍQEQEQEÄ"dhØ¬
Fx#ÜsÈï_˜zþ–t]J{ÞaµšH‹còÝ£É‘ ã¨WÙ¿²ïÄí+RðÕ·‡¤š8uÑùNB—MÌñËcûÌ©"@„”`w '¿ñßÅÿ x*“U»O?[xˆy[¾%9ó>Ô’Ø¯~0þÑ:¿‹XÃþ‡¤ƒÅº6KàåZêN<Â0q
Ÿùè~jò{{inåX¢V’Y*€	,Ìpªªff'
 ' ¯®gÙ¶ëÃ×qøŸÄêê/šÞÛ9(Äó®ùŠ¤ùQ!}…‹³ïWéZ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬øßJð}ƒjzÔë+£ø¤ldG
}é$nÊ>¬B‚kâŒ_´>¯ãÇ{+rÖz@c¶n\p»u8˜äÜ¡ )‡’(iÔŸ_çôòõ_ìóû4ÆðÁâ¦íø’ÚÍ‡z¤×`ç%Ž;º #M¹‰Dú•Wm-QEQEQEQEQ\×¼¦xãL“GÖ#ß|ÈëÃÄã„š ì‘2{u-ŠÈÌ§óïâWÃëÿ ëèú€ù“æÀÀ’2HŽd8W¹ýÜôåÖB¼vô<È÷÷ë_WþÌîu	¡ðfº^i+i99o•ZCäòv¢1ŠNIcs‚~¢¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(®wâ‚­|i¢Üèw¼$éò?xäÅ2ÿ µá¿ÚSÁ"¿8¼Oáë¿ê7V¢ž]Õ´‹Û õR@Ê8ÃÆØÃ#)NÃPžÂd¹¶vŽXØ::YNUÑ‡*êyVƒìH?g|ý¤cñvÍÄl‘jÜ¥jOþË/ÝŽçvÐvL2c
À ÷ÐsA¨®-!¹O*tYõV Ä6Gé_6ücý–„Îuß¨·¸C½¬Ôì_™^ÉÆ<©C("V2Ç(Ñ‘†©ðçö­¼ÓnWBñô6÷ot¬ˆËþ—lG^¦I"Á^Ãµ·¦¬oà¿….­$I nGBXv*ËÃÜ±EQEQEQEQEQEQEQEQEQEQEQEQEf°<gàm#Æ6GNÖíÖxy*OÓÌ†AóDãûÊFGH¯Œ¾0~ÍZ·Äš•†ëý!rÆU_ž%äsg„@7\FDòÉkÆJœóÿ Ö÷¥FÚAëþz~5÷‡ìÁñx^9¤Ý}¦(‚E'æ1Œ‹y@É%Z0={sêÚ®e«Ûµž¥w6ï÷£•©ôÊ8**n ØhM.Þ+[q’#…œ’v Q’I=:š½A¯ý«¾'§‡ô3áË91¨jK‡ÇT·Î%c@3‘ä'rFlÈø¢&,äû7ò5úƒ¡lmÈéåGÿ  ­^¢Š+Ê>#þÒ>ðfûd“ûCPNä§ÒyÏî¢Áà¨/ ?Á_.x÷ö–ñ_Š¤tŽäØYœ©(0r1$ÜM) òwF¹åQNòÉï%žFšV-#’ÌÍËy,]²Ä“ÎI'Þ£i]øbOÔÐÔäd’É`‘fŠÈ„2°á‚pà‚2`Gc^§à?Ú[ÅžtîMõšàn‰qD›ý|d»–‘Aê‡’~£øYûFh=‘l>kM‡LA€¥¾Ï:þîB`FÛ&!Y¼½ªMz½5Ñ\Ã ŒüÁÁï_<|mý—-5È¥Ö|%Ûê#.ö«…ŽcÉo/8ó°<cÈ@¨O˜>M?ÚžÔ°D¶wö’gœ£ÆëõåXqê
ŸâFù¾ÃýŸÿ h¨üfCñ$ZÈ»p¥À«Ñ.Trñ–EHº2'¼EQEQEQE|KûT|-¾ÑuéüG3éšƒ	€#”€’Å+œ„óD‘B°b‹Ê€|%Cƒ°ŸLgñâ)dóaP}±ý9üiŠ¥ˆQÔñ_e~Êßl´í.ê1,º…Ö^ÛpÉ”WNXy³®\ÉÃ$l±¿6~ˆ(¢Š(¢Š(¢Š('Ìxƒâo†¼<Û5]JÚÝó­ -ÓpÊ)f‚F9®)ÿ jŸ) ^JÀ÷Ó`{œÆ?ìƒ[zÇïkd%¶©
9%BÏºÀÝœN±ü¸èÇƒÐs]åµÔw(%ÖD=H ÷ÈäG=jZ(¢Š(¢Š(¢Š(¢ŠÆñ‹¬<'§M¬jÒyvÐŽ{–cÂGŽZI
ª;œœ Hü÷ø£ñ7Rñþªú– Ø@JÁ?,QçˆÓ±b0e“ïJùÉØG%om-Ô‹*]Ø…A$’p ’Y‰@’@ šúŸà'ìÁ-¼±øƒÆ0…Û‡†Éù$ƒòÉv¿uBà:[å‰bÄmòÇÔÊ0)h¢Š(¢Š(¢Š(¢Š(¢Š(¯4øíðŠˆš9Š©ªÛ{Yêqó[ÈÜüsû¹Kƒ´ƒð©¦Ï¦\Igtð¹GF*Êv²0ìÊÀƒÛ¸à‚oxCÄ3xsUµÕíù’Òd˜]‡qRH#›“§ñgµ~—é¤:­¤7ö¬ˆÖDaÝXSù®r5rŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¾iý¯¾%õ¢xÆÅÚ-öÃwŽñçÌÀ26Ç~¾Sòq×ÈL¥NZtR´LNÿ õöçƒÈ#@ ‚¯©¾þÓâ4‡Ãž/°Gëœ:$w„õ áç' ¯ž2Ÿª•ÃŠZ5ã¿þÛøöÔê:j¤Zä#åº&QÒ›³ùc)ÎÆù[÷lqòïÃ¿Šž øSª›Wó>Í….,¥%TàáÆÆÈ‚uÎDˆ 'g™n¯µ¾|OÑ|{d/4y‘@3@Ä	b' 	cà§dŠZ7*Æºê(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¤t6°È<‘õÕó‡Ç/Ùr`I­ø>5Šø–ym
’w-oŸ’IëH[?»a¸üsm%´ÊRE$2° ‚ÖVS‚¬¬
°<‚=+¤øsñÿ Àš¼ZÎ˜G˜€£#«£`Éã´™+¯ †û¿áGÆ#â-‘¸±>Mä|Mjì¡ìËŒy°·T•F*Á\ÞáHd
€:ŸæIè1^Oñ_öŒÐ<–Ö’¥þ«‚˜2£v7R)Äj	Æ	•ú*Œ–x·Åº‡Šµ	umVS5ÌÍ–cÿ Žª¨áÊˆ¿*/$³6:œ×Ñßÿ j3áËX|?âdy¬!"¸Nd‰FFñõšÚÊ|ÔPd€>´Ð<G§ø‚Ñ5&â;«Y>ì‘°aèTã•e<20§ €A­Fé_!þÒ´-åÍìþðä¦(	ŠâhÎgK¿ÞŽ˜ØÆCJá°áæ¦rÝÏÐá[^ðf©âËÔÓtxâáú*Ž îîçäŽ1ÞG!{Íò×Òþý‹¡¬¾&¿o0¯1Z œÄ¡‹`í?,HÁ5èpþÊ¾DT{Y¤  Y®eÉÿ h…uPOR@ô Sÿ á•üÿ >RàLßür¨k?²Gƒo¡òíæÎA’&gí€.<Õ*8IÆcŠñ?ˆ?².¿¢+ÝhNº¥ºäíEÙ0ày$”›ŒùN¬NvÅÐ’:b²Šh›AVVˆ ::ž™
Ã¨ÇZ÷¿„ÿ µ†«£Íâ†7Ú
f#7Ž›÷Ž.Uz²¸•Î×v[ìM3S¶Õ-¢¾±‘f·™CÇ"«)ä2‘Ôùt85j¼CöŽøÞ;·ÎŠª5›d*S…	ÔFÒmš>|‡c°†hŸ
ÊÉñ]Õ¥îzÐÜ,–×vï‚§(èêr=XrIö÷ìéñ­<y§3R|ëvˆ„àyÉ¢á@à88YÔ ëò8Ç²ÑEQEQETWv‘]ÄÖ÷²DãŽ)Ã+d}¯7oÙ·À­xoŽ˜™'>X’Aq·"Ü8ˆqÎà7Ì 5ãOÙ‡ÂZÞŸ%¶™jšuæ•49á¸ Kb²ÆH”á€$£+`×Ãzž“>‘¨I§Ý³ÛÊÑ8ôdbŒ9 ãrädd©ó_¡?@	Ñ±ÿ >q*îh¢Š(¢Š(¢±¼Wã/Â–/ªkS­½²q¹²I'î¤h¹y$l¨ “××Î4ý´ˆÝ†,@ì&»<úd[Ä¾Uí• œx‡‹>6ø¯ÅnEýüÆ"xŠ#åGßË‡ilgîçßW™à…>Øèqƒøg–Þ£óãN]à`LŒ~YÅkè~,Ö4æiWSÚI&	9#i,±„ Ë.N<
ôÍö¯ñž—…¸¸ŽõÎ."RqŒmó òXý‰Î[ž=GÃ_¶¥”À&»§<GŒ½³‡9>T¾SŒ·ð†pòÄƒ^ÓàÏ‹þñh÷Ñ½Áò1ËøC(Waî¡†9ÁìÍQEQEQE¾ý¨þ+7Šµ³£Y9:nšÌŠ8y†ViˆÎ!Ì0œeq+óƒ^ˆ\àŸSô“í_g~Ì¿-´+|W­C»TwÛ¤ƒýDl>WØxûD«ó–#tHÂ5ÚwçèJ(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠùOöÀøZ‘ù~2ÓãÁ‘„7aG÷å±äH{“	<Ž~X©Èê+ëÿ ÙâÊ_ÚÂ¨¿úE¸g³'?4_zH2s–€’ñŒÿ ©lˆ›Jžh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*¾¡ao¨[ÉiyÍÈRHÜnVVYNC+Aµ|ûBü?5E–À;i™krÙ%æKg“¹ŒÐ³ÏChÙðçáî¡ãÍZ=K
%pÎÏ!!är ¶åPÎê8#câWÁ}áä êq¶íKˆ‰h˜ó„,À4rùR($giqÅwß?i»¯	ôo—ºÒUGë%ºýß—ø¥3&HÕtX~ì}•¥j¶º­´w¶¤öÒ¨d’6¬B¬¤ƒüÇCÍ[ Œ×’ülø§üCˆßZ‘k­"€“cä/ÝŽåG,1•I—÷‘d}ôYøÚþÓÄ_µÆˆ´–:•©áõSÑ‘°Rh$ÇV¹Šà¨ú«àgí1mãš7ˆŠ[jìÛcubŸº’ÞUÇPb'd„n…¾o-=áOÒÑEQEQEQEQEQEQEQEQEQEQEQEQAóíQð=.!“Æš,adŒ¾Œà´€ÉôÎ˜—‘·|–À©Á«zn¯w¦L·VRÉèr²FÅOªºÊ}pp{ƒ^ƒíã¨‘c]V|( ebcÇ³BXŸVbXõ$žkÄÿ |MâuòõmBâxˆÚc/µäs"(ØÄÊI‘ŒrLåºÿ ‡è8¦Óâ…æ`ˆ2Ì@ w'€ ’{’z kKQðÎ¥¦F%½·šØí$Nƒ<œ•s€N3ž±ðûâ^³àKá}£ÌPœy‘¶LrŽ¡gŒrv¸Ä‰œ£v?x|%ø¥eñG]NÔ®ì¸€°cýG-ƒç‰È”ó†£;ã·Äè¼áé®#FéL6‹ßyi±×eº“#7MÁ«
ü÷¸Èå˜’Os×êOrO$÷$žõgFÒ§Õ®â°´C$óºÆˆ:³1
«žÙ'“ÙAcÀ5ú!ð—ám‡ÃÝ!4ûeW»p­s>9’@0O<¬IÊÅÝUç™‰íÀÅQI´W|Wø¢|A·s<km©íýÝÜjägjMÿ =¡ÉÃ#äÊ2|!ã?jžÔdÒuxL7ª²ÿ °¿HŸª°ä‘Â¸"½ßöEø®ö7§ÁúŒ€ZÝ{bÇîÍ÷ž%'…[…Ê¹Çœ­´fLW×Ô_:þÕ?†¹hþ/Òcÿ Nµý)s,KŒJqæ[&âÜn’®rˆ+å_xºóÂÅ¶³`q=´€ìÃî¼Lyù&Œ˜Øö0åE~øCÅV^*Òíõ­5ÃÛ\ uõ£Æøèñ¸hÜve"¶h¢Š(¢Š(¢Š(¦M2B,¤* ,Äô rI=€ ’kóKÇzÔZÇˆ¯µH?ÔÜÝË2wùYË&xWÓ¡÷gì÷¨G}àm"Hº%¿”~±³Dÿ †å8¯D¢Š(¢Š(¢ªjº¥¶•m-õô‹´^Gc€ªY‰ö™àrkà?‹_u?ŠáxO²«ìí”*§ˆÐe®'Æùp€" Ûç£ðwì—âÍslºŠG¦@Ýî_‹xI`pNI#9R¬«kÝ¼!û%xOHE}LK©N6’db‘äsÄ•Ou•¤\“é|/gÛÁ¥Y,h0‡ß–e,y'’I÷©×áï‡äiv@ÿ ×¼üE;þ?ÿ Ð6ÏþüGÿ ÄÖ/ˆ¾
øC_ˆC{¥Û®:4+ä¸ä‰-ü·ÀžFGBkÍuÏØ×ÃwH³n®­e;ˆÞVUçî®ªØSÜ>â27gšó~Æþ"Ó¢y´©àÔòs‡Œ«)x‰Ï|á»®åé^{c}¢ÝµµÌrAunß28*èÃ§Ã™[¡¯høuûYøƒÃ±¥–°£Tµ@[lÀ'–_—8ó“q8Ý/R~‹ð'íá?ìŠ+Ÿ±^9À‚ë±9 ß&wò„· é¨áÀe ©äÐŽÄ„ÆEQEQEy‡íñE<	áé^ÝÀÔïCj3È$~ò|rvÀ„°8 ÈcCÙ¯ÏéÈùä“ùþ'¹=IîI=ëé/Ùƒà:k%|YâwX£it•”ÓH§¬8Äjx–@Y²ˆ¡¾½^-QEQEQEQEQEQEcøÃÃVþ&Ò.ô[¡˜®âh±#åq×æGÚê{¿45>]:î[;Ž&Ú9££qÈï)8 º.³u£ÝÅc#CqGC†R:2ŸQÈÁÊJ°*ÄÐ/ß?áah	0y7*£x„ˆD™:÷NåþôJ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šá>6ø|gá{Í5P5Ò'nOicË&:ãxÝëò¹=+ãoÙûÆIáZ\ÎvÛNÆÚ\öI¶¨$œãË™b/Ü Ù _|jšM®¯m%–¡\[J
¼r(eaèÊÀƒêPyWÊ?ÿ eFÒb“[ðhymcRÒZ/"ÔÛ3eæ@ “±•pJ4™Ù^]ð§ãvµðæà­«	ì$;¤µüŒHÀ‘\ÐËŒ|èp˜÷‡Úÿ ~.h­LúD…n# Ëo&±ç€YA*èØÊÉ2FHl¨íÍÉüEøe¤xúÄØkò¼Å2`KtÝx9ÃFÁ£q÷”ðGÄ_¾
ë¿®D—Î²$ywq#'ª«ó˜&ùwylÄdf)€ª|ý«$²è¾3/4#*·§™¦Õ¹@•Í™×2¨ÌG’¾°µºŠê5žE"†VR`yVVH ‚8"¥¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢™4+2ä‘ ƒÁ# Žâ¿>¾>|3oøŠk8ý‚qç[ÿ <ØàÅœºÝÿ wŒ“å˜‰ë^gEQ_VþÆžÓî¡»ñEÊ	n¡˜[C¸dG„I¥‘AãÌ17ÞUB7ýCugÜf„Yba†G”ƒÁ[ ¨¯Ž¿j/‚6òuý1Ä†9aíINéÂ§;b”_,±2®À¨H%áOjÞ¹ûn‹u-¬ØÚLmŒîº°d‘rwu`æ\74ïøãWñmÈ¼Öîdº˜.ÐÒÀþêªDRy!TdòÅˆ`×»~ÈžÏŠµ%‡LŒÍíæ>b€0Hi $UXdgo
(¢Š(¯2øõðªè2,QƒªÚ+Ihøç8ËÛ’0JN«°ŽŠû¨¯€à¸–Âáe…š9#`ÊÊv²•!•*èÀsòº÷Å~‚ü	ø•ÿ 	ÿ ‡"¿Ÿn·>EÈ €dP‘sü3FÉ'f_á¯D¦KÈ¥eXAîî2+ó‹â÷ƒÂ%¾Ò1ˆ¢”´Gþò3ÁËÈã1‘Ú½_öHø¦úV©ÿ ¥óÿ ¡ß’aÜxIÀÈUô[„Rÿ žÊ§¬‡?dŽ”QEQEQEÕk^±Ðí_PÔæKkXÆZIUÙ=Iì£,O _"ütý§ÛÄÐË xd´¹T¤Ó¸"I”õDN6î>öìM*¤F¤îùØ¶Nkîÿ Ù:ý.<oiî"o©‘¦c Û(àäØ5ìtQEQE_$þÖ_õÑð^•'ú<ã'°nkG !æçlSþ­Áô_Ù›àõ·†4x|Cm^þ1 fÃsI¸IHyÎ,|¿ºƒ>â(¢Š(¢Šæ¼aðß@ñŠ×l¢¹e+‘‰¡&M²§¯ÊÃ‘ƒ^'ãŸØ×N½>…îšÑÿ çÆdè’ƒç¦?Û2Ž;º¼Åß ¼aá]Ïwc$¶ËƒæÛþú3À9"1æ(ã÷¯Cü µbø[â‰<(êúMüðÆ£XrñvàÃ'™EQÂ«ùU”öï~ÚpâY­Âùmk„~Ø-­å1ûÙ),}° WÒø¡øÖØÝèW+8N9YúKaÓž„§øX×Mš(¢Š(¦M2B$„*(,Äð ’O` É¯Ïßfñçˆ'¿Ü~Ç1[&NJNÆÁÆc™ŸŽw þQ|ø[wñXM6bµLIq0êãÎ	\ðe‚‘/?6\¨sú¤i6úE¤:}’í­ãXãAÐ*€ª? 9=Ï5rŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š|CûY|;}ÄgZÐõLÊ,ÊÜ!À '\’[t§øMxM{ßìã/ì6+bR"˜íæÅ™a$“€Z32S´“ÇÛ4QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEšøö‹ðx7Åw$ÛezMÌ0ä™£Â)‹`º¯ õ‡ìùñþA=ÃîÔ-1osêY@Ù7Eÿ _I	Ë¨åMzS×ÃŸ´ÏÁÙ|#«¾³aüJ/ÜºmE!æKvìªÍºX1´-A»Èt_hWqêlÏosGC‚9ú8Ã£Ž>WR+ì¯‚ÿ ´îŸâµM+ÄM–ªp«!ÂÃ1'jªO“;d)Ž×lùLÙÚ=âŠ«©i¶Ú•¼–w±$öò©WŽE¬Y[ ƒî+åOŒ?²mÍ´«x)L¶üfIóÔÛÈç÷ÉÜDì$NB;ª8¿ƒßuo…÷/¤êñM>›œIlÙY!n» I¶ùlGÞ·m‘É÷£[í
x»Lñ]‚jº4ëqk'F^#ï$ˆpÑÈ¿ÄŽLkc4QEQEQEQEQEQEQEQEQEQEQEQEW”~Òž Åž¸uîœÌ$›
3<C¡+,A¸ççTl WÀŽ»N#üâ›EoxcÁ¿Š$htkI®ÝXD…¶ƒÐ±á8;C0-ÕAÄ^%ðŽ©á«²jöÒÚÍŒ…•
’:î\å]yä£0ƒÅzGÀ?Žò|6ž[[ÈšãJº!¤D#z8DÑÚ¬YB¤‘³.àªÊÛ—ê;Ú_À—Q‰RXXçä–9‡ûÃa=G<ŠñŸÚƒãg‡¼U¤Ûèzßka:ÜI*«*.ÅeXÆð¥ÝËäàmE$–¾a¢”s_o~ÇþŽÃÂ²jAH–úåÉb1”‹Ç´õdÈ‘¹8ÏŽ{}åäVq=ÍË¬PÆ¥Ü€ª,ÌÇ  9$œ
à¢ý ¼,ÿ f]bÜ>Jäî	‘ÿ MYD[xá·í<`œŠïí®c¹f…ÖHÜeYH ŽÅXd}EIER5~yþÐ~Añ¦§i 30™@$àL¢à¯Í“îý	à` ¦þÅ~#’bûE9òî-„ý°XóŒg,“€0p6’G9¯°¯¿m"5m;QA‰®-äú`ùN…L–w$á@Æsó–›{-ÄwVìRX™]uVRg<« ÃéŽ†¿DþüM³ø£E©[²­Ò€·0ƒÌrcGË“â|aÔðrÞŠ(¢Š(¢Š	­|ÿ ñ›ö¥±ðß™¤ø`¥æ¢¤¤“}èb8ä)) D‡"GÜ6WÌ3j~,ø›¨­¼’\ê—¯ó"d¶ÞŠ]#`·$eöÆƒ<¹={[ÿ Ù3Æv¶O|bÝy…&Ý/«"§–Üsò‰~b0¬ÄŒøÄÑ˜£ÁþG9äõ¯±ÿ b¿ù j#þŸÿ ä(óù×Ñ4QEQEÍüFñRøSÃ÷úÛc6°; =Ü°¯Få¥d Žyâ¿6înå»¹yçbòÈ\³’ÌÛ‹±=Iwb}rkôËÂWQ]iSÛ°’)-âee9\Ã¨>µŠ<o£xV´k—ÚFzyŒ§	ÌŽx<"“ÁãŠñþÙÚ%“4Zœ×§I)¦z©Áæeçœ¢}Ü×mSx#MµÙŽG™&sØ†Ø1ôÚ~µ×x7öËÒu	RÛÄc¼àÏy±¯_šDÂNˆ PJ¤„rŒŸ¡l5}BÞ;Ë9ky”:H„2²°Ê²°Èe`ràÔôQE£h¯6ñ÷ìÿ áO³\Ý[}šõó›‹o‘‰8¥@S2ÆÇgçço~È:öŠw Èºœ
IØ£Ëœ É1LTg>[£62±’ÁG‰éÚ¶¥á«Ñqg$¶—1]ÈYJœ27Ý`C4nìÈA ýð›ö¼–6M;Æ£Ì ¼~eÿ ¯ˆ‰ó™a—ø¢#,>¡Ñu»=jÕ/ôÙ£¹¶”e$ƒ)üGqÜx *õQA8¯šjOŽqØÛËàÝLÝKò^È9
„Ö¨ç¬€¯œÀ~ê2S>c¿%XÙË:[@¦Ie`¨«Õ™ˆTE¬Ä*Ž™#µ~„|ø[ÃÝ;'µ	ñ-ÓŽî@%'þYÀ¸{1&s^‡EQEQEQEQEQEQEW)ñ;À¾;Ñ.4K¬+È»¡Œùr¯1J Á![‡\èY	Á¯Îhw:ôúmòîmähä_FSµ€ÏU?yø«ƒSøS_ŸÃú•¶­kþ¶ÖT™Fq„1™7)öcßúi§_GoÜ'1Ì‹"ý^>„}:UŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šó/Úá‚øóÃ²En êVyžØžäÞAÆÙãÊImü5ò¯ìéñ9|â%·M¾‚HyÌ7OüðrË&HÛ’v
ûÖ9Àe9GCèAîäãšçþ!xJhWš%À¹‰‚îÈ>hdpc•Q‡~+óVþÒKIž	×dˆJ²žÌ¤«¯|®qÇqP«íÿ ?Ò¾ŽøûSO¢lÑ¼\í>ž£	só<±wÄŸyç€t4cÞ ù~»Óõ+mFÞ;Û)ky”<r!¬§•eaA‚*Íç~iìYfT‡SEýÍÐ_˜œG141?2•?<eX_êz¾Þù.×Zs1%Z)•.@ÊËº	ð‡ HžljFQ1Ç¯üý­äWKñ§ÏÂ­ê z n£\N¥¦ˆ^,eÇÔÖWð_Â—V’,ÐJ7#£V£+)!õ§¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š)³D²¡ÆU{üA¯ÌZ%ž£qmÛRÈŠ3œvE9'
ª2NN2y¬ºÓðæ‡>»¨[é–ƒt÷2¤IÁ?3€;W%Ûº¬O ×è÷€<	§ø#J‡GÒÓÆw?zGÀß4­Æçr3è£
 ( 7âÃí/ÇZké:Ä{£nc‘x’'þ¡r×_NU×(êÈÌ§ä?þÉž(Ñ%gÒQu;Lü­	&8}¼„|ÜóåHë€NÔ´=GH"þmdÆvLç‘Ä¡:óÓ9ÁÆk>EqËçñÿ ëÓ(§G÷‡ÔWèìÎ»|¥Œçå”þrÈqøgË~Øº­ÅŸ…`¶€â+«µYzò¨2)í†•!Ý€85ñGœýwÎ¾ƒý’þ'ÞéÚÔ~¸rúuöÿ ->\ÀCÇýÄ•RA"°°WÂ¶íßfÑEWÆ¶nöo[ß¸¹´^ ç1»¡,zÂT ç &j¥ûÀ²xÅØç1ØÎãê^çÔa Õöåóoí¯+K“"y†{óqŸBF
øýP·
3]_ÃÏˆº¯€u$Ôô·ÚãåxÛ;$LäÅ*ðJ“È#ó!ÎC}qàÚËÂÚÜhš¹}.å°ÌùâÝÆvÏ8\“9c [û‘¯éúÌBãM¸Šæ& †‰ÕÆ*r¤õŒõ«ù£4fŒÓ|ÅõTrHÇÖ¹íWâ?†ô­©ÚB7Îƒ$uæí\7Š?j?èÑ9µ¹mBu8Û)9ÿ hÌá!	Ï/¼û^5ªüDøñ¬3Ã–­i¥±+'”ÅPŒŒ‹›æØÖ(ÍÎV@@­¯
þÅ¬Ì³x‹Q `f+TïÔ>n Œ¤##æ]†¾„ðWÃÍÁVŸbÐíÖ<»õ‘Ïv–VË¹ôí^Š «>/ñe…t»gRq½ºäú“÷cVy„PI5ù§­_û¹n˜m2»¹ çÙ¤+žáK¸ï_]þÅòÔëé?ôLuô]QEQQ]]ÃiOpëH2Îä*Ü³6 ¹&¾<ý¦þ=Yø®4ðç‡¤2ØE!yæWCˆÖ"pZÛ.dÛ¶WÙ³(¤Ÿ3Îk±ðÿ Åïx~ÐiÚf£s°Î#WùFx!‡Ø?ÙBª!CdžkQÖnõ)šêöY&ºÉ#³¹Ç2HYÈ¶ì{TþðÞ¡â+µ°Ò ’æåó„w1Ç,qÀG,ÌBŽ2A ®÷àGŒ¬ák‰t›°‹ÉÄa§ÝÏ^ŠŒ}«ˆ»²žÆV†á9c;YXe#øYX++Bü{÷ì©ñŠMRO
êr¦Þ¾Ø7¶›$Ï+ÉùYÚ³íuPdŸ³ÍQEPFkÇ>;ü³ñÝ«j:b$äjJ¶ YÀÿ –Sœ}ÿ ùå1ÉBv¾èØðî¯¢Þh×RYßÄð\BÛ]J²ŸFSÈö#*ÝU˜s]_Ã/Œ×Ãë£>— h$9–	2b“§,€²` &LH¼|µöWÂoÚÄ[eagªãæ¶‘¾÷«[Èv¬ëÁà*óÆ½O¨š(¯ý¡¾8Aà]=ôÍ2PuÛ„ù ¼•<}¢@xF~ÎŒçùÙ|µc_
Ý]Ky+M34’ÈÅ™˜–ff%™™ŽY˜–f<³kéÙ;àÜ·7)ã]Q1mo±©?~NciÊô1D,Dœ´»œ|¨¤ýl(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯Š?l/
fx5X”uÎ?ç¤º—€XÌ-œ–8là(¯FÚÁ½kôöh×_WðE‡›÷íCÚ“Æ‰ŠFF;ö)$dIë^¥EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQš­¨êúu¼——²,6ñ)y$rUG,ÌÍ€  “šüÎñn£ö±w{b1o5ÄÒF6íùGxÆÏá[/ËØqÒ¾Éý•>&·Š4&Ñ¯œ½ö—µC1$¼ÄX¹£*ð6	8Dc‚ø¯q¯ÏïÚOÂßðøÊýQvÃtâê?q(ñÂŽ&YFB‚ ’I¯,¥Žµêþ:j¿.J|ý*Gkféï$ñØî?w! HùÇÜ¾ñ¾•ã%Ô´IÖxŽŒS!ù£‘AV#*A­êÍcx³ÂšŠ´étZ!5¬ÃwSü2FÝRD?2:à‚=2+á_‹µ¿‡²½Ë¡¸Ò÷ÜcåäáVuÛÉ’æÄNÿ êß¡ÿ ~<jÿ '[bMÎ”Äù–®Ø'&Kv9òeÎr¿ê¤ÉÞªØ}Íàÿ iÞ.Ó£Õô‰D¶Ò£+½«Õ$CÃ)úŒ©íQEQEQEQEQEQEQEQEQEQEQEQE¿1|ds«ÞÐÜOÿ £d¬Zï~ÝEkã&YØ"È²ONw ÏÕÙTz–½~‹Š(ÅV¾Ó-oÓÊ¼Š9“û²(aéÑÁ	JòÏ~Ì^ñMö[Q¦]c-¨Ú£¦7Ûÿ ©‘xù¾UsÎñ—Ä¯‡—þÖ%Ñu¬É†ŽEÎÙ#oõr n@8*Ë“²Ed$àÊR©ÁÒ¾÷ý•ï…Ï,âÆ¼“Ä}È‘Ÿ#ê$ˆ®«âç€Çž¹Ñùs¶Ù sÑeC¾2Ü‘ŽQø$#£p|âÏ…ž!ðµÉµÕ,fˆä…`…Ñºÿ «š ñ¸ÀÈÁŽY¿·þÊŸïÆ£‹õxš[pÆÙ\i$a°J¶Ÿ"8ÝðÌ ‘ÜmÜ©“õ½QE|Uûcëâ÷Å1éÊT­•¬jpCHÍ3+ÁùEp8rIéÓ~Äºc›Vÿ hØ‘C{åšIp;í*}HÇjú¾Šù¿öÖ?ñ(Óý<Kÿ ¢r²ÂÄÑ]ëºíºÝ¤,0Å &=Û|ÉduÎÉHÞ±„e*„1 –ôˆÿ ²n¯ÆÓøx.ó’Ah““º,îˆñ€Ð²…Q€¾jñÀOøQ‹]XË$+ÿ -m™1‚wˆyˆ RO™ 1¸‚@®*‹ý*q,Nöó¦0f‰Ç\6Aó‚pÝy8=k¦Òþ1øÃMFŽ×T¼
Ç'÷ÅùéÁ—ÍaÓ `=ªéøÿ ã~‡Vºÿ ¾Óÿ ˆª—Åÿ j›~Ñ«]™Æ.
uõòŒDþ9ª'â‰]Nìýnåÿ ãµVÔëZ¤™·77HØ²cØß¹¦I®§NøCã­Z#,Zmñ@vüêÉÏ|-ÃÄØç®Ü{šî<!û#x§RN²bÓ-°6å’BUH¡ÂîüÉƒü/Ûß|'û3x;@Û$¶§På¥Ûoç‘ ëÿ <øÂ‘ÈÍzœÑÛ Š	ŒP Ð(Àè*LXž0ñ†á:M_W”Emú³1û±D^G<*©Â‚GÂ_~7ê®À—ýN…‰†Ù	 žlÍÒiöð#–!ó3·šª–8ÿ >§ò×ß³?‚ßÂþ·7I²êýÓ‚0B¾Ù ‚°%OÝfeÎ ¯W¢Š(¢Œ×üYý¤tOy–¤_êÊ9…É9Á¹˜eTñÌ1—›%X5|ãÿ ‹>!ñäæM^á¤ˆVÊÂ˜é² J“þÔ¦G?Þ*¿ƒ>ø‡ÆnF‹g%Êƒ†|±ƒÓ<…bg8Íê£­zb~ÆÞ0ed±R@$ß#ØâÜŒŽ‡Œô$WŸxûàß‰<†Ö- '22"zæ§
ÍÕREF#€eG_PþÄq!¼Õd o@îy· zà•\ãƒ…ÏA_Ymä´¯Ã]?Äž»ÕÌjºŽÏ `”A¾Xd#—FI@yY”+Î~†f·”<lT©È àŽà‚:0á”ÿ  G"¿C¾xæxZ×S¼éiº	÷ž#°È?ë¢ísèÅ‡l× QEQEf¸ÿ ˆ¿
t?Z›}^ç(";„ K¹!*qóFá£aÕ{×Å>ë_¦inía %Ôcäç;RUë¼‡ÌG?$‡î7Ži `T•e ŽÄÈ ðTŽ ‚ìkÙüûUøŸÃ(¶·ÌºªcpO˜ ãj]ÎG§œ’‘ýìuÓ?l	\Â$ºŽîÞCÕ<¡ G‰Š{wõ ñ\ßÄ/ÛÊc„ wºp?}r›Q:çl!·Êà·qH ’ÛJ”5jïYº’þþVšâf.îç,Ìz³ç  (T Óà—Ã~ kñi¬YGûÛ©ðÄ
†è$™±}HË¾0•úcc„ÚÚ¢ÅJT*ªŽ  `SÑEQEQEQEQEQEQEQ^û]øeu?	®¢ó4û„|…ÏÉ'î%GÝA¹¶( à_‘ƒƒ_i~Æ»øbò7bU/ŽÐ{nŠ`=‹~¦¾¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‘˜(Éé^oã_ÚÂ-Åàºº\þæÔy­‘Ž—÷QžGH§®ÁóŸ?kßêÎðè
še¶HV I1Œ´’â8Ûiû²œ>Aâk^"'û^òâè%•˜dªDdˆòC³<“žk œó]×ÁŸˆ/à_ÛjüýœÂŽð¾Ü I1ágP:´@gœÑ[y’xÖXÈdpHèAä} ŠùÛöÈð7ö†“mâh2Ù?“1ïåJ~F'")Âàd %cÀ$×ÈÚ>˜Ú•äVHB¼Ò$`·@]–0N9À,	Ç8×Ú#ö?ð¡Ó–Ñ¤ºaFnNKu$@ÊÐ'»2`ß5|ÇñoàÆ­ðæña¼ýý¤ÇÜ¢á$Ç%
å¼©‡x™ŽFZ6uÎÜÏ†¿õo j#QÒdÀ`XŸ˜åQÑeAƒòœ˜äR$'i*Yîÿ …_4ßˆºgöŽžRÆÛ'È-u¯š)8 :²¯kEEwiÜMop‹$N
²8¬Y[!îÅ|£ñ»öT’ÐM®x5L°Œ»Ù]GVû&eEäˆùŠØ™¾XëÄüñ/^øuö2V¬I“ãå+4$¯Ì…v‡&‹AÀ(~ÀøUûJè^7xôël5I8HsŒ‘üO;c”G)Æµzð9¥¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬ßê£HÒîõ&‹h%”…ëò+?Ëž3Çã=kóöåîei¥%þf'¹o™‰ú³øÔ-µÃÛ¸–6(êA§Ê²A¬)`Žµúð?ã—´¨„²¢ë0 [ˆs†$`âCËE/•Ï–Ä£`Ž}8ÑEóí§áø&Ñ¬5’?Ò!¸6ùõIUœ‚sŒ#Â¬¹’pFN~9¢¾Âý|qÎ›uá™X-Õ¼†æ5àŽM«)åŒS›µd®I¯¤Í&ÚP1EQUµ=FßM¶–öñÖ+xQ¤‘Øà*¨ÜÌÄð  šüàø—âÖñˆ¯u£—2–@sÄk„…HÉÆØ•I¡f WÙ¿³/ÃÙ¼áu{åÙ{¨?ÚdSŒ¢˜€DJ”çl’8äW­ÐN+âßÚûÇi¬ø‚=Õ·C¦!Y'i6¼ƒpùQˆÐ°Éò!èE{ì`¶Þ†`I77èC˜0=F!Ïv#¦+Øè"ª]höwm¾â¤lc.ŠÇ™`N+œ—áƒåc#èÖÌI$ÛG’O$“·©<šoü)ßÐOÿ Àhÿ øŠÔÓ| éhb±Óí`BrV8QG×qW°tñÿ .Ðÿ ßµÿ âjÕ½¤Vë²X×Ñ@ë…ÅKŠ( œWž|XøÙ¢ü<¶"é…Æ¢Ë˜­#a¼çî¼¹ÿ SzÈÃ'‘»q_|Hø£«øöüßêÒåGÂ™Æ½6Ä„œÎù2Iœ1„uzwìñðþø¦ÞÎõ<Ë(¹HÈdŒ±·Û,ÌŠÀõ@ëß5ú¨`p§òü;RÑER;„RÌp$ŸÔ’z 9&¾DøõûOÏ}4ºƒ¦1Ø®Rk´á¥=mœs‚Ë‡˜çÊeŒ,ø]ð{[ø“vËdvÑç\É‰žHÀù¦—æòÉiC~¯ðgì·á¢½äS¸^ë”Ï}¶ëˆ@ã£8ûÄžkÖím"µŒC,q¯Pè«€?R×7ñ&ÂÚÿ Ãzµê‡­&Ü§Ì§<U‚²A5ù¥7Þú€@Oë^‹ðâRxÄqjW!œ¨Ð\>[Cª÷h¤U|™—r®X€~ë±ø‰áÛØêßR´hœnSç àú†`Ê{a€ ðFkÂ?iŸzLºD¾Ð'[»‹£²âXˆ)jrñ	9W–VP„&à‰¼±¨?#.dqêÇù×èìÍ¤6™àM8H$¸NÜçw˜ìñ¹÷h¼¾;c‘^£EQEQQÜ[ÇpÊ¯2°Ü2œ‚pE|ùñSöHÓ5„{ï
cyË}œÿ ¨~§l}ZÕ‰#wEÆC;‡ÈZöƒ{ ÞK¦êq4P1I#~ªF22¬!•Ô•tee$YôTBÓ8D“ØŸ@ îI (îHëôö~øR¾ÐUnTR÷l·G¸ã÷VùêVb$ZF5z…QEQEQEQEQEQEQEWñÆÉ/|¬Å! 9dãÖ1ç(ú@¶kóšS—'Ôæ¾±ýˆïóo«Y—èÖò*gÕ]ÀôùIõ WÔQEQEQEQEQEQEQEQEQEQEQEQEQESd•cœ€£©'ñ'Š«s¬YÛFÓO<QÆƒ,Ìê ¥‰ s\?Š~?x;Ã`‹B9å"¶ýóŒõ[‘r;»ª‚@$+È¼MûkÅô4°ç]I·¿É€;W¨iQ”‘×¼WÇüYãHÚû¦K6àÃ òâ=ˆ}¹yAÏÝ–FCÆPr¦è÷ú³ˆ,a’áøÂB…Ï<  Ø,zg­zNû1xÛYŒMö³£#í2,Gþ™üò£–ªã¦Ü×©xSö)ÌaüG¨ísŒÇf™õÎ'¸ä¸"ÇÌ<ê?á‹¼)³oÛ5ç¯™~˜ò6ã¿Lû×ˆülýžo~mÕ-%ûf”îI·Œ~êN‹òmr6¤¨B³|®ªÌ¤ýû*üBÄ^MWÍæ•ˆŠž¦ÿ Î=B¨0¶:4} +ŸZñ.ƒo¯é·:Mâî‚ê'‰¾Œ
îêH`{jüØÖ´Û¯jóXÊZ;«9š2Ü‚6ÂÈ\U•Xg‚-ÔþŠ|8ñ|^/Ðlõ¸Oü|D<ÁýÙäš3É9IU‡'8Á­=ÃÖ ³“LÕ`K‹I†dB;«ªêC) ‚|ñ»ö_ºð²¾³á¯2ïL2FrÓB	<áAià\ÞÞÆ¹2U.<ŸÀ?Õ<	©ÇªéRl‘xd<¤ˆNZ)@á£lg™FC»î?„Ÿ4oˆÐí›ìúš&ùmå€ÎÒñ>g‹8Ë(Ü›”JˆÄèÔPFkÅ~5~ÍºŽº®”VÏYa¸±Ï•1 L«þ®C€ÂßóÑdWÆ¾+ð~­àë÷ÓµhÚâ3œ0á†x’7,±’>Y#$dŒqø=ûX]èÂ-'Å»îì[7Nƒ 2ÿ ÏÌj½X¤ 3‰Hçë-ÄZˆ-Vÿ I¸ŽêÙúIî¤ºÃº°
Ñ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Ï?hYtßjÒ—1´y*@9-)X•FÜ‘¿~Üð 9$
üós·¦N>ŸÏ ~5õ‡ÁŸÙ_I¾Ñ"ÕüSæÉq{’8cvŒEÑ—+‡y™Hf|´Ü+]¼·ã—ìùwðñÅý“=Þ!
²7ÆçÆÀçãË™UQÎQ‚¾ÝþKe¨Oc*Ïlí¨r¬„«Ó*êC)ÇR	8¯^ð_íSâýEKÙÆ£l0w nÇ9ÛsYCÃæL>U ýQð£ãŽ‰ñ+"Öú„k¾Kiq»nv™"uùfŒdù²‰.}4WþÙw(ž¶ˆ‘½ï£ÀÏ8T•˜Ô…ãq23Ö¾@ð‡†æñ.«k£Û%»™!RzÇ›‘ò¨ˆ'F	{ÆOÙŠçÀújëZmÉ¾´pa<ð%Â­$+“‡‹!‰e'o’ø+ÆþÕ`Õôç1Ïná±Ù‡I"Lr®RA×aó*×èÂïŠZgÄ-4jqÙ2agŽ^'#8?ß¹1JÙÑƒ(í(¢Š*¶¥©[é–ò^ÞÈ°ÛB¥ä‘ÎTrÌÌz ?úÜ×ÅŸ?i+¬ºˆ6þXäIpZE8ò ,7$?}ÀV”¯úªoì·ð•¼W¬{QLéšs‡äÿ ¬œaá‹ý¤‹‰¦çò‘À}½Š+†øÉñ/ ø~}W*nØyvÑ’>i[…8$e"–_DCÜŒþvßßK{p÷W^Y»1êÌÄ³»´ìKsŽ€WÝ²~¥oqà{{Xd-¬Ó¤«žT´2n~xäVSÐ‚qÈ5ìtQEQET7—ÙÂ÷72,PÆ3»U«36Ü’|Åñö·X·é~
!›•k×_§üzÆãÜyÓ)LsI÷‡Ë:–©s©N÷W’4ÓÈrîä³1é¹Ý²ÌqÆIàp00*­
2p:šûSöAðéž!˜¤jNU2Ä1TÆç¬žd›—†S€1ïôQEWÊßµgÆÒwø+F€0/dFë×ýç†¹Áa<4€xWÂ¯†÷¿5¨t»PV"wM.8Ž1÷ä<ž6B¤a¥*>ê¾?B<-á}?Âú|ZN“‚Ö…QÔž¬îÇ—‘ÎYÝ‰fbI5­Fk„ñçÆ¿x ˜µK°×@gìð2^øÜ‰Ä`ã†•‘zsÈ¯—þ1þÔWþ3µ}I‡ì:l£åƒK*ñû·eýÜQÉvp 2*–Jðv%‰'’hŠwœÞÇêêHÉ¤g-×üÿ õ½«±øQðúëÖú,Tî™ÇðD¸3IÎyÚDi‘Ì’'¡¯Ñ:Â>Þ;;TÁ
*Fƒ¢ª€ª z  «4QEQEQ_,~Ú~´AaâÀ[©KÛÉ÷Â©–&cÝ£Ã $‘ÈÏÊ¢¾R¢½óöQø[ÿ 	µÿ 	êa¦0e=Æ3
`ç>@"v#$xWÛŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬ßÄ³i—q8­ ƒÐ‚Œ?ZüÁŸï÷Wù
úö/Õ]Y 
OfÄžãË’21ÛæóŽÝöeQEQEQEQEQEQEQEQEQEQEQEQEQEs¾!é~ÓVÕŸ
>Xã_¿+ã+Jq–=YŽr_üMøÏ®xúéäÔ%)g“åÚÆH‰ ¨+ÀÆie–Ep
œá@ü‡êq€=ÍzçÃÙ¯ÄÞ4/%U°ÓŸæÎ,9†ÙvÈýÎæ`r¬Ã½«Cý‹´+p­ª_\Ü0UÈˆ$JO»I!SŒ(/¹A'q<DÑ¿g¯i[LZ\2º¶àÓî”ç¶LÌÁ€ì v®ãMÑl´¸„|[Ä£b@€¸
€d“Ž™« bŠ+7Ä:®¿§Üi:‚y–·Q´R.qÃÊ°á•0E|²jßüj@É’ÎL8žÝðx$a„ñ£>]Ê(s÷¦‹¬[kVPjV,$¶¹e‡ua¸}ìr|wûaø0éž#‹Z…q£,pÖÅˆäöù¢10îv7e®Çö+ñ{Kÿ ‡%<&Û¸‡ûß¹œO™b|w,Ü ¼ýCA¯Ÿ¾4þË–~$ß«ø\Gi©1-$'åŠbNY”ŒýžcÉÜªcà:‚w’®lµê{'I¬uWÜ$B8§®Öþ´r).§ôÿ Á¯ÚÆGËÒ<fV	ðo¸XØóÿ H0¶äü¸•3Kz¥b•ePèC+ A ƒÈ Ž#Gt§Q\çŽ¾èþ8±:v¹ –<åq$l:<2™¨k«†RE|wñoöcÖ|¯¨é›µ1y/þö1ÎLð ?"óMPY“\/Ã‰úÇÃýHj\ƒòËäÇ*úHªFH<¤ª|Ä9Áe,‡î?„ß´ŸˆÖfkÃy}³‘¹3Àt#‰ac²„muFâ»àsEQEQEQEQEQEQEQEQEQEQEó/í¥âï"ÎÃÃ‘6gk©@<íOÝÂuÚÒ;8ì|£ÝE|­ i§T½†Å[a¸‘"ŒãÌeˆ·~ìgÈÎkôöÊÕ- ŽÞ0DªŠ À@P ì ÃŠ¥âoÚø‡N¸ÒoÔ=µÔm‚;Ã˜d8e ‚"¿1ï­Œ3´ î*Åsë‚S8Éå±’2y5ê¿føÚÁuk&ÖÒLùorÌ¦Lqº$]Œ}q#m2üÇœñ/…<IðŸY‹í!í/a"X&‰²­ü%á—]|¹Q—£ysFU†ïqð7ížV4·ñU™‘× Ïj@'¶ç¶»¡o*R	ÜB À®ÊãöÇð’ÆZ(/ðp¦$\žÀ¹…ûÜÔ×Ìß~0ßüHÔVîé°)H S€òìÎpd–B÷Â€" –‹àC„ñžÍÀûd]}÷ækô>îÎ+ÈžÞáCÅ"”unŒ¤meaÜ0$_|{ø=7Ãí\¥ª³i79{W98î·v<™`2IxJ?%dÇàjÞ¿]OF˜Á:ŒVRrÑÈòÉÊœ~ddoš¾ÑøUûJh>3DµÔtíQ°¾Tˆä<so3`6âxŠM²ƒÆ`Ÿ`Ïj\Ò¼·âgíá¿£À²­þ¤Å´ññ(ÌpG2áŒ×È¾9xƒây:”‹l¥´#lc“µŸ9yœ|Ò’ Œ¤hy®{À¾ÔüeªE¤i1ù·òIû¨€€óÌßÃy%› i
ýð‚ìü£[è–1À¿3¼î~ieö¤r[ØaG WCPÞ^EgÜ\ºÇjYÝŽ¨fbx ’M~|wø³/Ä-i®!b4Ë|Çia?ŠgROïg?18cÆyŸ3®—Àßõ^}¿C¸h$`Æ+¨;¶Kå]{Ž¹>[¡'>÷áÿ Ûbíqë:lRœüï¥1ÁX¥WMÙë™€ç€1ƒÞè?¶…/ÎËø®¬›žLbTã|ÖåÜ–Î1åàr@Á¯Kðÿ Åoø€„Ó5;i¤c€ž`W'°#}®N:à`Ž ×S«"‡BOB9š3Fj)îâ€+ªÓqëØÍp~)øùàï‚.µ¦”Ë;oß?~1å^T‚]”)Àb2+ÇüOûkÂ™MM,yK©6úmo&äƒÉ*Ò¡`žqáŸ~7x‹ÇŸºÕn1hE¼Cd@ç ²´¥xÚÒ³c …VÉ<®ƒáKÄW"ÏK·–êáú$JY¹þ&Ç
¼ä»•\sº½ëÀ¿±¶­~ãÄw)`„gÊŒ	eèxsŸ"2‚@325Ã|{ø,¿/-c‚äÜÛ]ÆìŒÊƒFUdVTùJþñ`œ²py\?{#¨þ@‘_¦žÐÓAÐl4¨ñ‹kh£;s‚Bì7e°Í–çžkvŠ(¢¼ÏãïÅDø ´Öì¿ÚwyŠÕOcÞ\Ô­ºÞ†C½_ø[ÂÚ¯Ž5TÓ´Ôk›Ë†$–$õ;¤šyJ ,^Yä“…Ëº©ýøeð×Nð”šfœ ÈpÓÌGÍ,˜Áv=”tŽ1òÆœœ“×“Šä¼ñKBð%°¸ÖîHà˜àOšY1ÿ <â•ÏFÛŸ¼â¾Pø£ûVk~%c¡ƒ¥Øœ‚clÎã‘‡x‰HÁÙÍœƒ)W‡K$—ds’Ç$“Ôõ%˜ýæ9$’Kä“šÑ·ðŽ«r‹,³º8Ê²Ã#;eB¬b	±ª—ú5ÞžÁ.âx™†@td$z…‘U˜pr@ w5JŠÒðç‡îüA—§Æe¹¸qh;“Ó“Â€fvùQC1éƒ÷×ÁOƒVôâ€‰µ;€¿h˜tã•†yXc$àŸšV&Gä…_H¢Š(¢Š(¢Š|£ûjø¡^};@1¤—2à¾ ‡œäeDÄ‚£?+pE|³]wÃO†ºŸµ4Ó4´ÿ jI;#LàË)GÍ+|‰üLŸ ¼eà}NËGK;}éŽé%|p7E"AÂŠèè¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š£¯Ç…Ïýq“ÿ Ajü½›¨ÿ u¯fý’Vñ½¹‹;ƒ&?»µGÍí¼§ãŠû¨QEQEQEQEQEQEQEQEQEQEQEQEQE†¾ý£þ%7<I(³abZÞÜ‡iÄó8Ìò¯uŠ8ûŸ'¯ª¿e/‚úeýŸü%ºÔIs ˜¥¬mÊ©åyÝÊòy¹F8Û#ê QEQEã¿´wÁ§ñî˜—ºR¬XƒåŒíóc<½¾ãÀ|€ð3|¡ÁBUdfoû*üYþÌø[/™[ì…Ô¯’f²pc;ÕÞ à~ðÉìùj}Gö˜ðjx—Á÷3ÍÆþ—p€‰Ó¨áà/‘ÈÈVÚÅ@¯þ
xèx'Åš¤¬~ÊÇ?bl‘¹ü‡dØ8ˆŒòAýŠE‘C¡¬2èAäGPG"F+“ø‡ðÃDñí™³ÖaË¨")Ó,dã-˜8ÎQƒFÀa”Šø«â÷À}gáÜí;´éDÒ/Í#2L2ñŽs™$Æ6>
~Ñš§‚&LÕîô\…17/äµbr È&Ý²ŒØá¾ÙÐµûzÎ=GL™.-eIäoUaÑ‘€e9¡š)6ŠðŽ³¯‰‘õG¶¨2ò@0±ÎNYŠž–'ïñ‡PïÊ’Úøƒáþ¨¥ÖãNÔ-Ûr’
0ÁÉ*yI#lØ2BëÃî¯­~þÒPxÐ¦‰¯m·ÕñˆäÜÔ*ñäÜÏ•’²aŒMüîÙ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( šøGö¯ÖÎ£ãk¨>m¶‘Ã ÉÈáÌTvV3ŒŽ¥”“Ú¹OÑ‰<e¤) ¶Ã×Ø“ý+ôf°¼sâ%ðÞ‡}¬·üº[É(rUIE°	fÀ õ'ëá/‚ÿ [â‰£°¹'ì©º{¦Æ¤E)·<å®
•Bì2Súmo¼kJ8ÀUP0 
ª:   lWÎ_¶¿Ù¿²tÍû>Óö‰vgöygÌÛü[<Ï'~8ÝåçµñõU:ú[ˆî­Ø¤±2º°êHt`«ª°ƒŒ	¯Ñ?ƒß­þ h1j‘ánÓ÷w12’ó'Ë”~ò"z£àÑø›Âúo‰¬ŸKÖ K›Y:£Žã£)duþROC_%|Zý“u=GÔ<(þÄ’Æ<øÇ] d}©}q7@É!ù«çë‹iìähfVGCµ•ü.ŒRgP}«¨ðïÅïø{¦êWQ"‚y…Ðg â)Ä±ƒòŽväs·5¿ÿ +ã¿ú
Ëÿ ~áþ~McxãG‹<E‡RÔ®$ˆdl#Sž~u·XCãoÝŽÜ¹Üà~@~gŽ}«Ð¾üÖþ!\…´CæK¹ùKÔ„cÏ—#(Ûƒþ±Ð_p|7ø]£xËìzD_¼p¾tïÌ’²Œvì£$¤IˆÓ'j‚I=}6G
7€:Ÿç_~Ñß´Oü$†Oøqÿ âT­‰ç_ùxe9Ùÿ ŸUaËõ¸aÆ!“ç„æm«’Çúñõ$“RH$ŠõŸþËþ2×mVõmVÞ7 ¨¸FÄCy[d‘Gýt¿ûæ¯_þÉ>5µ‰¥H ™—Hî±çh‘bR@çæuàuÏæ"ðV±áÉ<­^ÒkFÎ?|…8ÈÚç÷m‘ÈÚä	Æ9¬BàñNó˜òN~¼ÿ <Ö¶âý[NÙö+¹àòùO*W]½þP¬yìÕ¶Ÿ|^5‹î}nÿ <Óÿ ásxÇþ‚÷ß÷ýª½ßÅo]£E>«|èÿ yMÃà÷Á Ž=@Å`ßj·Ú†Ö»’IvgVg8Î¥Âç8Æp)ú^…¨jìb°‚K‚¤eaF~O‘°ˆ!wc8ëÅzû5xÛXa9íãçæ¹eˆqÛi-/=m?Þ¯YðìW±Öo_‚ƒ“¢O àÜMœ2d@ŽÎGO¢¼#àÂ6‚ÃC¶Khs–Û÷œàòÈÙy\€2ÎÄñ[˜ô¯¿m}f)õm;L\¶·’Gçft
¤v;mËžA>•ãŸ¼<|Câ­7MþnP·8ùcÍÄ˜Èa‘pA'g5ú@´´QEP×µÛ=
Î]KR•`µK;¹Àú±<*Œ–b šøâ‡Žõ‹&ómb‘•È‚ÎØrBgäL—Î™ó$§¼)bæ¾¿øðrßáÆ˜c‰µ; ­s(r°EÜE'’wJå¤leU}/ÅxOÇÚVÓÁÛô} ¥Ö­Œ<™ÑÀ?½œ| B¦A•‡Ý?ëºõÿ ˆ/$¿Ôf{›™If’FÉ9;±“€ˆ	ùQBÆƒT
ô¯†³W‰<j‰zè,4é0Â{€rÃŸšÈ;˜£`r¬Ùãêÿ ‡<3àˆÑííÖêùy7S¨gÏý3R6@¾‹wby¯FTTT` ~@qXÞ,ðn•âË'Óµ«t¹ÇF©ìÑÈ0ñ¸ÎU‘¾ø×ðr÷áÆ§ä13éóî{iñË(ûÑÊ ž,ûFÙ¨\º¯›×¤þÏþ8±ðoŠ­µ-QGÙHxñ“ó€ÿ ¦e@|r"ygnèLR,Še G ƒÈ Ž ŽAïN¢Š(¢Š(¢Š©«j–ÚU¬·÷²,Vð#I#±ÀUQ¹˜Ÿ`?>+ó“âŸŽ¥ñ¾¿u®JwZ1ÎÈÔl…: ÜûN<Ç|R|5øo©xûUM+LNOÍ$÷#@pÒÈG;A8U4„\|Ì¿~ü8øq¦xL]+KOF–V|¯Œ$#·hÐ|±¦GRzª(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š£¯Ç…Ïýq“ÿ Ajü½›¨ÿ u¯wý‡üVúqœÿ ãöâ¾Ù¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+’ø³âsáêZº%†Ýü¼çýc..…[c©;X ñ_›—YÉ''××ÔŸrrO©$Ôuô·ì—ñ~fð–¯.È.äßjîNfÂ´’B­ÆG÷WÎÞ§-"çëàsEQEQ_&þÖæÓ/SÇ:ìŠB¢è§ÊR`@†àÁ_8íFpAY’6'/‘çz×í=âÝ[D—Ã×oE<^L“ùdNÊ~Wáü¬ºå]Ä IáŽkÉ¡%¤ç§é¦8úWèŸÀ›«›¯éÞÿ ­û*îÜJŒ¬LIç-RGðž;WyEÝœ7‘=½Ê,‘H6²8XªÊÙB+äÿ Žß²çötrëþFkeùå³fŒó=±9y"ÜÐÎ™&"PycÇ¾ü_ÖþÝùºd­¤`Ó@ÿ 4Rã#,(àtš2‰l¯¶~|gÐþ ÀŸ'•|«™-d H¸Ææ@8šœ	cÈé¸+dW|h¢°<cà]#Æ6GNÖíÖâªO‚¢H¤<n8e>ÄÅ|cñ¯à¡ðÞeÔôç{%˜mŸx›9D¹)€§;|»…ØŒãG&ÝÝ§ÁOÚ¦}8Ã¡øÉŒ¶ l[Ã“$`p¢ä Zt0ýò™œ°úÃNÔ­õxï,¤I­æPñÈŒYO*ÊÃ ‚:Vh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‘«ó[âŽ¨Ú§‰u+ÖL×s¶3œì€dúã°]oìÇ£¾¥ã8…Ü4“¿=q°V÷"Y"à{úWß¢¸?Žº-ÖµàÍRÃOC-ËÁ¹PumŒ²²¨ –r¨Û³a{×Ëÿ ²·´ïx†xµy/¡òÒgl"º¿˜Šäª²eÞÌ¡B·.1ö¸º£ó•·dcwnû»qÎsŒWÃ´ÄX¾ x•mtrn,ìÇÙàhÁo1Ù‡$J3¿Ì—d1¼,¬„z'ƒ?cžÁ'ñëÁy b„ÈÎÇ’PûäùŠ@rï¼tu?Ø›N‘ ±ÕfóÉ’qa’Aú±Õ–aé;kKøÚ…À¯#ø­ð]øxÂ{°·{°T¹‹;rz$ˆÙxd8;CGèŽ[å9¿	~*êuQgûÈ$.!nˆvç’!%¢}Æ$0(Ì+î¿‡¿4?Ú‹­`e -ßhóÚX'k¡hÛV5×šã¼uðÃž7\ëVŠó…ž?’Qô™0Ì÷_rz­x'Šb™w´žÔQ“Gt„‡Î‡ålœšz³1<W?cß“ôAžæàñî@‡$àsé]Ç‡b}­¿\ÔÆÜ’Ö.zŒ4å±òç B$Üsê7ì¿àm1’Sf÷R!'7»ƒè-Ëž¨äŒ×©[ÚÇmÃªFƒ
ª  vUQ€ ì ©i²H±‚Îp d“Ð¤’x w'¥|‡ñóöœ—Syü;á9éåZ9®—ïMÙÖÝ-ñ•i@ß>O–V0þwÒt›½fê;;Úk‰˜""–cÂª¨ê}¸
$ª‚GÙßf‹_íÖ<F±Ýjà†ÍèW8Yn3ÖR»cÀ‚íï QU5=&×UìïâK‹yWŽE¬2¶A…|Ÿñóöa])|Cá5w´R^k_¼b^¦H:»À¼ïŒîx‡Ì…2šJœ¿çó±È®£á§€î|u­Ûè6Ž±=ÁlÈÜ„Tär ©r|¨ÜÄÊ¹5õ¦“ûøNÙ ¼šòåÃdŸ1cqòì‰©ç­nŸÙcÀïiî~·3ÿ ñÚOøeo‡ßôoü	Ÿÿ ŽÖæ‹ðÁZ6Ãk¥[–ŒåZPelû´ÅËÀ³]½­Œh"¶"@QB€@€ ‡ASŠ( ô¯Ïÿ ÚgV}GÇ:–\ºBé
g°Ž4ÜƒØJòžyùlc¥ýŽôö¹ñ{N¤·´™Ï©Üc„ô''Ú¾ÛŠ(¦I*Ä9
 d“À rI'€ ä“Àðçí!ñ©¼k¨ÿ eirÄšÍˆB½%­rHûÉ–ÜgwKŒº‘Ý~Ç¿–G—Æ7ñçÊ&MÃÜ‹‰×=Ô!Xt>n:ñõa8¯œÿ ißŽãCü-áéÊê2|·RÆy…É†7þ‰™rÐFs•‘“#éEæ¹wŸaMq3Ž8ÆI'ª¾Ã,Ä Ý€«ì‚¿²Ý—‡’-cÅH—Z˜"D€ó$tßƒ¶æeÎIaäÆÃ÷jH •Bð:RÑE`øÓÁZoŒtÙ4b?2	9pÈÃîKõIò¤pFUƒ)*~øÉðSSøqzßéóŸÜ\ªáXõ1H¼ˆ§ Ù’.Z#òº'œ+m9çüút=ëë_Ùãå´–Ðx;_q±.Îv8V_àµœ‘Ë¶T2DŠý:h¢Š(¢Š(¢¾fý±~$;X|#fFë€'ºÁçbŸôxO´’)‘Á+×Ì~ðf¥ã-N-#HˆÍs1ïÂª¿4ÏÎÈ“9vêN;(?}|"øI§|7Ó>ÇgûÛÉ°×7$a¤aÐÎÈcÉD	
	bYÙØ÷tQEQEQEQEQEQEQEQEU{þA÷?õÆOý«òö~£ýÕþB½ßö6?ñWÉÿ ^3ü~Ü×Û"Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯ý°µ	m|!1¦åžösýÐ¡åñtUÿ WÄ(…ÛjŒ“Ûú{“ÐçŠõÍOö^ñŽŸ¥l5²H¢1#A›¦U#qÌ;@fA÷’9$qÈPæ¼–)FH ‚üÁ`‚È ‚È!‡eþÎÿ ´Jx™#ðßˆ¥ª(íÇžHä=ÈƒÀ¸#Sô 9¢Š(¢Š*®©¥Úê–²ØßD³[N¥$ÆU”ðTƒÛõ‘‚+ãŒ¿²Î£áç}OÃ+%þœI&07Mäàªü× ‘”?/Y¿gGÅ—ßiñ3Yi6ì<Á"´rLzù0¬]P‚<é°6ƒ²,¹,ŸnXYCcv–È#†%ˆ¼UUTv
 §¢Š(ÅxÇÙŽ×Å…µíuBA’#òÅ7fl¨>LøçxR’‹“æ/Éš†®øRAwöð6ô,
0#þZDã*Ãý¸ÙÐŽ •¯ª~~Õ~ òô2Zjv¥Àùa“ U“$ù¿9Ïî\ƒ±°Œ}(¨®mbº HÜe` ðU”äG|ÅñƒöKFWÕ¼
ºåšÉŽ}?ãÒF?)Ÿ&V+ü1<|)ñ¿†ß<CðÂé­"ËZ«•šÊpUwµÀÈßm:UŠŒnÁ’6u}Ãðÿ â—ã­-5"MÑ·Ë"6Äÿ ÅÈ	ÚëŸuu!Ð²2“ÒÑEQEQEQEQEQEQEQEQEQPÞ1X]‡+ù_–÷sÉq!šf-#’ÌORX–b}É$šöÿ ØúU%RÖà±€”ªIè2Ù=M}¿F+Ê~"~ÍþñœÒ_ùmc ù¦·À½,R1ÉÜûVF–$>vø‹ðÆž·0ZK6¥¤¿ìÆLáQ5Š³•$–02Á×½ý–>Ém!ñoˆmÞ)¢r¶qJ¥+ò½ÓFÛXc&(Š
íyBüÈÃê,bŠ*®©¥Zê¶ÒXßÄ“ÛL»^7PÊÃÑ”äßØò0kä_¿²ÄúË­øP4úzò[œ´±ç÷XÏ)äßÆ«œÊ8_Ÿ´ÍVóH.ì¥xfŒå$Š°>¨èAã$âSŒWÒ??l[‹TKÂn@Âýª Lp7MÚ’¤´%Xþ¨·_£<ñ3Ãþ2ÌÐïb¸lÑçl‹œðð>ÙW£rWâºŒŠ(âŒÐXW™øçö†ðŸ„7Ã=Ð»»N°ZâFÎàˆ£÷ß #Ž9¯—~-þÒºÏŽc}:ÔgémÐÆä¼ƒ‘þ‘0Û½JžaEÿ }¤è<ãÁÞÔüa©E¤éQnf<g…U,‚#Š0rÌG¢(geS÷/Áß€úOÃ¨¾Ð ºÕv½Ë.6ƒÖ+t%¼¨ÿ ¼Ù2KÉ‘ˆÂ¯¨bŠ( €z×Ê?´oìÞ¶ë7Š|-"{›Ts©yíÕsû¼üÒÂÉóIË¹+È> ø™|5ã:îlÚo!Éç8ò7g 3!ÝœÜpkô4QEQEüêøñÿ #¦¯ÿ _’ÿ ìµïÿ ±W†ü?Q×f•-“8é2H@Æîd›Ýƒ´ ®OÒÔQM–EK±
ª2Iè ä’O Ôž|sûE~Ñ‡ÄfOxjR4°JÏ:ƒÑ£ŒŒhG7$`~çýg/ðà=ßÄ±|ýäƒƒ#°@¿ÚIËð?z@O¹4ÓG´‹OÓâX- P‘Æƒ@èó$ä±$’I5æ¿þ2'ÃÍ'Ë´!µ{Åe·^@0æ@z¬yÄkƒæJUq´11ºÖo	ùæ¸¸“ÝÝÛóy$‘ÿ àNÝ‡O¸g¯qøÏûKSU}jå ~„B‡æ0FÜåÉÁž@pÌ/Èƒ>ÉÒŠ(¢ŠËñ7†4ÿ iói¼+=¤ëµÑ¿5e#”t8du!‘€e ŠøãOÂ¿‡:©µbÓXM—¶œŒ_âI0ùðð$ÛÃ©YB¨b«çjÅOùýE}/ðöœŸO–ø®Mö$,pÝ6KÄsµá‰>e¹ÈEþò<ÂñåÓë ÀŒŠZ(¢Š(¢°<uã+?éæ sn¹
:»Ÿ–(“¯Ï#•Pq…Éc€	¯Îÿ ëú‡ŽuÉuŒËw{(Â¯',BE`u
Cœ<³û‹àWÂ~é%µ[¥Vºr+g÷Qn<ò^BÎO M¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÏñüƒ®¿ë„ŸúWåüÿ xº¿ÈW¯þÊ²xêÉT;€ÞãÊ-ƒí¹Tý@¯¼EQEQEQEQEQEQEQEQEQEQEQEQEQ^UûNé-¨xù“9¶1\`ä#©aÇÝI%¿„O¯ƒ´¶Xo#gÆÔ‘IÏ”œú“Øs_¨0²ÊŠèAV ‚:FAu¨5ó—íû4Ûê‰uâ¯—{ƒ,öª>YHù¤–¥Ã™ãIÈÈ+oâ•í\Ia‘ÓA ‚2Ã+ FqöìÙû@ÿ oÆ¾ñ4ûµ qm<˜ÌÃ¨†Gà…çcè:™U³ôX9¢Š(¢Š)Í(¢Š(¢Š+ñÇ€4X6™­B%’Ñãl`Icqíò°ùX2’Í4ý¯4ÛYï´ñw$amäŒFÌ£æ’£ÚM €4ÛäŽ_àÏí%©x%ãÒµ÷º8Â…'2B3Ön]FNëy‚ ‰Ð‚‡ì	øÇKñ]’êZ,ésnØ©åX€Æ9PüÑH¡†èÜé[TR0Íx÷Æ¿ÙãNñâI©iÛm5ÌJr#—hÀK•PNí¿*Î È (mè»+ä«MKÅ?uÇŽ6’Æú"<Ä#+"‚BïSû»ˆŽ3Áù7È`üøÿ ¦|C„ZÏ¶ÏYLî·-àsæÚ³`È¸åã?½ˆ‚ÚíêÀæŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢«êñï'ûü~[KÔ}ò¾§ý‰ôTÖ_$VÉÏ<îžL¯Läàç9 î~ª¢Š¤–Š(¤#5æ?gŸ
øÉšê{²^¶IžÛÌN	2¦SŽLˆ[ý¬d™>#þË#ð¾ë­9´ìW'|
|ÅA–Ûæ~Z(ÿ a{øúOqe ‘$‘žHôa‡FÀ Žâ½#Âß´·Œü>4½7P®?wt¢QÆå¡)>9ÏúÒI$ô=Î•ûiëñ#ë+9ØŸ”¯™¡Pgç<îv«ÇöÚÔ»i–ß÷öOþ"°uÛ'Å“™´Vp#gf"geô!ä”+0êEU5ç^+øÓâ¯šž¡;ÄÙÌhÞ\g81A°ÀáËä€	®///‡ä?§zö¿‚¿³n§ãbÔµt{=á··Ë$£û¶èÃpVÇú÷@$Æ®v°úûÁ_tBÐh‰m¼ î2Ò>2G™3–‘À$mRN ®œQEQHÃ#¾ ø÷àeð7‹§·ÓÐEi6Û‹`¹Â«äì ŒÂ6Õ€C'£î‡þ&_hÊÿ ËÕ¼r79Ã‰œ•2’ WAEQEüáøÁ}ÿ ‹µ[ˆ²ckÙÈÏ¶ŸÕÎ¾àø ¦‰àÍ.ÝpL–ëpÄg–›3¿_wÆ  cŒW}A¬x³Lðµ‹êšÌémkÉg=OP‘ ËÉ#h¬ìx¾6øÛûH_øÙ¤Ò4]öš?Ì¬7bIÇBn
ãdXÏú8lOœÇîüýšµ<z¶¸ËIá#Ì?»¶(ÈëÝzä¡ûãí#HµÑíbÓôø–X$q ÂªŽ€Ô“’Ç$’Nkœø¡ñ.Ãáî’Ú®¡—v;!…~ô’`€žÒHxDà¶þ{øÃÅú‹µumZS5ÌÍ’{ü1Æ§;"Œ± è9?31?BþÈ¿	Ì‡Æš’LRÌÎ2²ÜcŸõ'1Dç§˜Ã¢šúÊŠ(¢Š(®gâ€ôÿ ièº >\œ£¯ÞÇú¹£'£!ê::–FùXŠüÿ ø•ðßRð©&—©§L´r(;$NÒÄOðœ€Ë’Ñ¿ÈßÂÍÉ£m9ÿ ?ýqê+ë_Ù—ö€[¤Â~%›ÊyÞÒYçÌ‹flù‹û¢Þb¨§Í-QE7Jøö¤ø³ÿ 	f®ºšáôÝ=ÈpD“ò’J¬HÁ0Â@™›œ©®ÓöLø4À¯uxÊã"ÅuÈÃ^c9Úh­÷d”4f¾¨QEQEQEQEQEQEQEQEQEgø…¶é×GÒ?ô¯Ëùþðÿ u¯ ?co-ÿ ‰&ÕŸ8ÓíÉ^7Ì|¡’8‰d;Nwn¼ý (¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šåþ(éÒê^Õl­ñæÍe:.x(ÀdúWæÃ±Y7üãØòGâ+ï¿Ù·Ç­âß	Áö—ßy`~Ë)îB€`ç¼”ÜrApÝ z™•óGíû3¶­+ø“Â0µ9-sh¸By7àáDÄÿ ­‡*³}õ+.|Ï“Ò4éÿ Ž)couee=ŽŽ¾‘×Å}¥ðöŽ¶ñtQh~ ‘aÖ‡È’cj\tƒÊÇs‡ˆ²0ß±=àÑEQEQEQEPE|¿ñwöK›R¼º×<-21iMœ™;òˆ&¨Y–H¤M¨ÙUuB6|éáÏëÞÔZãMš[;¸›dƒÎÓƒÄO”p§ ¤ŠHê„pkê¯„µnâFLñ8K÷!ReÏ‘!ã·m¤cœfˆã.â¾€F óKF+ø›ð£Fø‡d¶š²,Y0Ï‘’0v’hÛ2'7Ú¤Ê¬>'øð»^øQ©ÆîÍåïmweVaóÉŠtÁÌlÛ¸Ê#b¹|ý«WSxt_mŽvÚ‰z0ªÌxjŒab,v4º,~u‹5ôº°##½-QEQEQEQEQEQEQEQEU}Cþ=äÿ q¿‘¯Ëyz þCúWØŸ±Pÿ ‰&¤éê?ý•ôeQEQEQŠóßˆü5ãÓ_Ûù7¤qsOûiÁI†{JìG5á÷ÿ ±%à‘¾ÅªBñcåóaenœ†òÜ è@éÔW¨þÈ^4µPÐÇkrNr"Ÿ÷>|pŒƒŽzŽõËŸÙãÆààé7?”gõóyú÷­öVñ¾£µžÉm‘‰Ï2&1Ý‘<Ù =ÕbzàãÑ´Ø’fMÚžª‘¹å†àâËJêO<(àgÔ>þÌžðžË‹˜¿´¯P†Ü€UHÁÌVã÷I‚„Ž;ë×KEQEù“öÔðÁ–ÏM×£1;ÛI€O<è‹0áBÉ*äÍ'^ ­ïØïÅ?Ú^ŸH‘‡›apJ¨ëåÊ¨pIàIæ  *¨
:š÷Ú(¢Š( ×æ¯ˆua†û]ÈÁõódÀöê?_ µ[}SÂzUÍ£«§ØáBTôdQˆ}YH<‚+¬žâ;xÚi™R4fb ¹f8 RkÀ>*þÖš^„ÇÂ¡5Î†rspyB¤5ËŽ#+'2äm?+ø«Æš÷Ž¯ÖçUžK»—;#à8X †1µ7 ±¡wîZ¾”øû3G§*xƒÆºÎè-$ÁãMr¼†›ŒÇ	%!S—Ý)ýßÒÀRšø'ö˜ø„Þ,ñLñBû¬´òm Áàí?éŽÙ’`W=Ö$¢±¾	|&¹ø‰¬­˜&;1%Ô£ªÆIS9t¤‹ƒ·!AŸÐ=#I¶Òm!Ó¬£[[¢Ç/EUT “É9'“W(¢Š(¢Š+–ø‡ðëKñæšÚV®„¯ÞŠUÀ’'è$‰ˆ88á”‚’.UÔŠøcâçÁ}_áÕç—v¦[Xˆ.T|Ü#|©öòbo½µŒLê0<ú9Z6§úû{€r9 úcàÿ ík&™
i>0\Â€*]§Í( `-Ä|ðúå>içz9Ë×Ôñ†“â«5Ô4K˜î­Û2Aë¶D8xÜ¨ê¬;ŠÙÎh¢Š3^!ûM|a_éM¢iÒãV¿B2§'(ó‚¤2Jü¥¹þöé:Fkç€	â¶>Ö¥t«LIrã¡òÎÙIçtø!ˆÉXC±;™+ï›kh­bH EŽ(Ô**ŒP0ªª0¨   ©(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šå>,ÊÐøKX‘	¶$Û· ú×æÃõüò¯³c/µ–ƒ{ª¿[Ëãl+³8ê	’I$åBœkèZ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢£ž$™) dpUèAà‚PA#ùËñwÀ3xÄ7ZL ˆÕŒ7÷¡rL.1è‰¸áãaÀ*+­ýšþ,ÇàmlÛê·L¿ÌO°?¹¸#¦Ø÷2KÐˆÛHÈ?wE*È¡ã!•€ ƒAäGÈ#ƒN+šðÚöyÅi'ˆ<;]YFé¡\pñ/@·@ÀœŽC„añ¬‘Üi“•`ÑÍ`‚
²²œàƒµÑ”€yÚêpF}!ðãöÄ¹°‚-?Å­xmûLL¤æÄøI_Ì‰"3à~ì¹&¾ªÐµË=zÊSMMipãqÐƒìpA!”€ÊÀ© ƒWè¢Š(¢Š(¢Š(¢ŠÍp_þ
xwÇ‘;j6ëñRê0U8!K‘2)91Ë¹HÈàœ×Ä?>k/þÇ© 1I“É“ª8%	8ó!|ºÎ„=v??i]_Àë™|þ’˜Q65à£JÙùQrVÞO$ˆWÙ
ø£øÒÈj$ë4}z<m×dÑŸš7üªHæº*+/Ä¾°ñ-„ÚN­ÜZ\.×FüÃ)£¡‘Ô‡F”‚3_|jø¨ü;“íð9ºÒ$b©>>d$ü±] 6«°8ŒE)ŽB¶ÁOÚ7SðeÄZ^±#Ýh¹Q²ÒB?¿nÇ.Ur@ÛQû­ò·Úú.·g­ÚG¨é³%Å¬Ê$CAþDte8e9*íQEQEQEQEQEQEQEQEãýOû/Ãúð-¡´ÕýFÚyã†Æ+ó6^¿€þB¾ÏýŒlÞÝ66MxU}whIôÉ<{WÐTQEQEQEQF(¢Š(¢Š(¢Š+Ì¿i6¹àB8ÿ ÖÛªÜ¡Á<ÂÂF ¬Ñ‡Aœ€['¥|éûëYx½¬“Ý´¨Ã<f2³Fþøb¨ãýalœ
ûbŠ(¢Š(5ùÓñÖ&‹Æzº²•ÿ M”àŒpv²œpÊCÐ‚àÖƒ~+ø“ÁˆñhÒZÇ)Ë 
èOMÞTË"  dP€'­?ÅŸüMâô	®_Ms~ã‘gŒB8IF+`äŒMn|2ø	â/ºÏoÙôóÖêpV<qÄKÄ“œ/Œ`Êõ×Â¯€ZÃáö˜»ÔˆÁ¹”ÆVÇÉ
’2HÌ­Ñ¤# zh¢¼söŒøÑô¶ÒôùGöÝê˜£9V¹nÊz¬ ýùyÁT||?¢è·ZåìZ}„M5ÄÎ±ÇõbxU ã–c€ªÏ
kô/àÿ Ã;o‡šzT$IrçÌ¹—ß!À8£@Ž%ìŠ	ù˜“ÜQEQEQERÖt[=jÖKJ¸µ”aã‘C)CÐŽ¡†O ƒ_ütýoü<š¦”­s¡±Ü$êÐç¤w |ÅGE¸ «	v>Y¼LŒWIàˆZÇ‚ï†¡¢ÎÐËÀqÕ]AËš3òÈ‡ÁÃ/ü³t<×Ø	jÅÅ4íd.©¶ Üß¹‘¹ÈŠVÇ–ÿ .|©¶’X,o'ZöàÔ´àþ/üV±øu¥}¾äy·s–Ðgß%ÈÉHc4¯‚@Â¨.ÊÁzÎµ©øï\k»£öBþe ÎÄEH¹Â ÊÆ‹“µI'q?ü(øumà-
4Ã÷—2fÇ™!öÆ+(õ®ÆŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¸ïŒŽÁºÑ$ô‘Ï©€RHÔ~p„Ì:òô¯Ð_ÙËFþÉð6–„ óÄnƒœù¬Ò©b‹c nÀŒzUQEQEQEQEQEQEQEQEQEQEQEQEQEy×ÆŸƒöŸ4Á£o¹­¦#€OÞŠ^æv®ìÈÁd^Wóÿ WÒn´k¹,¯ch.`vI‡*ÊpÊÝŽqÃ)>Vôçì½ñéCàÏH@ØÌÜsÑläcÇ?òìÍŒ`Ü[ÊõH9 ŠòŸŒ³ö‘ñ	âbÏWå¸Qø,w1ð$QÆ$\L€¬Tm?øóáÞ±à‹ã§k0¤ä£RE^0‹ÈÎ tÎõì>~Ð¿Ã×dý«If,öÎq‚Ø-%¼„“ÉB|—bKb^¾âð‹´ïiÑjúD¾m´£ŽÌ¬>ôR/T‘‡‘ÔeH'k9¢Š(¢Š(¢Š(¢Š(¬¿øcNñ-Œš^¯\ÚJ0Èãñ¤a‘Ôà«¡VRø¿ã¯ìéwàfm[I-u£»q—ƒ<„¸#;£#„¹ÂŒ³b¼³Â^0Õ<%¨Gªé3µ½ÔY‡9S÷£tl¬‘·Æà®@e*À0ûkà¿í	¦ü@‰l¯6Yë#ƒ	o–\dµfÁnf…¿yþúáÏ®ç4T7V‘]ÄÐ\"É‚¬Œ
²œ‚ê¯•~9~Êëeºïƒ#wIylWæ*1ËZgçukv,ÃqòN ˆøßÃ‹šçÃ{ã%‹·w{i8Iqò¶r	Šlp³(¬ •]AA÷oÃïˆšOŽôäÕ4yw©À’&À’&ïñ‚J0 àòŽ0ñ³)º|ÑEQEQEQEQEQEQEQEWñºŸÁzÄq)g6r'“€=5ùÍ1B{ŸÏšûƒö? x5ñÔÞÏŸÊ?é^áEQEQEQEQEQEQEU]NÉ/í¥³—˜æ£nqÃ‡‘ÈàõŽ¢¿?~ÞŸøîËí„7Ù/~Ï+€ç²wÉØ»„„’ª5ú´´QEQ^qñ3à/‡~ Ê.õ’À™íØ+²º²WŽL…gBê¼+Œqö_±Ï„mÝ^Y¯¦ÕZUö&8Ñ‡üƒ]¯†þx7ÃÎ³Zi±I:ÂIó3AS1p
6^Çšô@€*Œ 0 ôì ì=©h¯/øïñš‡`6Á&Õn²¶ñ1áG;®ePC£8
£™d*€¹—àýw_¾ñäš†§3Ü]LròHrO×¢ª¨áU@H×… f¾³ý”¾cÚjñböåH´Vê‘639RYgÆ+odq_FâŠ(¢Š(¢Š(¢›$k"”pXA ðAz×Ä?´ÀÃà»ßí3ýtä€«ÄŸ ã¤nI6ì@Æ'$GŸ¥W*r?ÏÔã^ïðcöžÔ|&Ñézù’ûJÎ'tÐ‚I&'ošdÿ ©•ò €WÖø¥á¿‹óågl€µíÁÜ6å{ã"¬x÷Çºg‚4¹5}^M‘ Â Æù_XaRFùrF]Ê¢±Ÿþ#j<ÕåÕõÇÄV(Áù!Œœd(åØó$,ä}Ð=¯öGøHoîÿ á2ÔWýÕŠÚ¯?<Ãå’c‚2–à”PrWcŸÝŒýx(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯*ý§µ³ð%ú Îa‡žÁä@H÷â¾óm^YÎÕ¾QÓÝ…~žèövŸmeÇî!Ž?”`|ª;G¯ÑEQEQEQEQEQEQEQEQEQEQEQEQEPkÂ¿h_Ùæ/Æúö‚Ššâ/Îœ*Üªð‰Â¥Ê(Ä3ÇfÇãWE¼ÑnÒþ‚xÎ9T«ß262>ðÊç•cŒ×Òÿ j²¤ZŒ¤/ÛW§–QÑEáÎ]@ÀûH†3892WÕ±L²¨xÈeaAÈ ò#‚b84úÂñ‡‚tŸØ¶›­À·•Èù‘ˆ*%…þôR('¤H9ƒñÆ¿€Z—Ãéšî×Z;0	sò–áb¹Änd C.Wì®wá—ÅkáíòÜi²nÌ¦kw?»•GqÎÇ
w:|ÉÆw Ù_z|=øƒ¦xëJXÒ(ß,‘·ß‰Çß†Uu×<ºêUÐ•`k§¢Š(¢Š(¢Š(¢Š(¦KÊ¥V Œ‚x ÷ŠùOã¿ì¶ V×<2d´ÖiÉ\å‹Ú©ä§]Öàå80‚3|Ç³ØL2ÑËVRU•”åYXa‘Ñ†Ad>‡"¾µøûPÇ©yZŒ$ÙtNØ¯_²ÇtFÑ™ùV`rpcýï¥Uƒ Ãy¥¢¼ãÿ ìå‹¢}sÃ‘$:ÒÏÂ-ÈêC.‡&9Ž™òæ;J¼(èzþ¿ðãYómš[+ëWÛ$lÎ:Ãq Iv6Fx˜¯_sü!ø¿§|EÓ¾Ñoˆoâ \[’„ôt=^ ìp8å+©ßŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¨kújêº}Îžùs‘JÀ?7 ¯Ì]NÆ[—µœm–&1¸ôd&7Œ§ê0{×Ø_±Ž»Æ{¥å|Ë{Ÿ7çlª¸%{(x’­ÀÅ}EQEQEQEQEQEQEPkàoÚKÃ·ñµì•ŽíÅÔOþÌ€#æ)‘ÔwF's
ûàÏŽÆž³Õ7¹!¸´Ñ€’ñÎœH£'äu99Éíè¢Š(¢Š(¢‘›oZðßŒµ“áT“NÐ
_ê£r0ÂÃ+ûÇ^&‘¬Ÿi+ãoxŸRñ5ëê´ïsu.7;žx`""ŒíU
ˆ¹À$û—ìñû8Ëâ	cñ‰bhô´!¢…ÁV¸#¤«a–Ô	bŸî¦#ÜÏöJ¨QÐRÑEQEQEQYþ!Ð,üCa>“©Æ%´¹CˆxÈ>Œ0U”á•”†VWÀß>_|7Ô|¶&}6à³[\w`0Z)€û³ÄÜ@	*þõ1ó¢y¥fÓPžÒEšd‘U•ˆ+þã)§ÝH=ºUÝ{Å:ž¿ ŸU¹šêU4Œä…ÜHPB€Bœ|Ù£ÂÚÆ¿©[évc3ÜÊ‘&F@f;C0ùPeÛº§é_¤þðÍ¯†4«]ÄbÞÒ%}ñ÷¿Ú‘‹;ìÄÖ½QEQEQEQEQEQEQEQEQEáßµþ¯ö/¥¾Ýßj¼†<ç¦À÷Ç|ù;qïšù;á”uOiv …ßy$d|®&<wÈ‹oã_¤TQEQEQEQEQEQEQEQEQEQEQEQEQEQEr>i><°}?VˆnÇî§P<È›³Æäø6Q×*Àƒ_üXø)¬ü8ºU»u”„ˆn£G#¬¹cÄså9!°Æ'p]ÿ ‚¿´N¥à}ðkÍŽL$üñœcu«¹
€à± ”1³ßjøGÅúo‹,VÑæÛIÆGHûÑÈ‡’)á•†G^A¶©“ÁèÑL¡ãa†V ‚PÊr=Á¯žþ/~Ê:n³ê>D²¾\±¶C/û1äâÖCü;’Ç‡Aãç/xÏ_øI¯;"´3ÄÞUÕ´ …uùr¨Î|3&â¹xØ«}³ð·âþñÓÎÓßË¼Œ=³Ÿž2{ƒÀ–"GË,yR8m­•Þh¢Š(¢Š(¢Š(¢Š(ÅxÏÆÏÙÏNñÔrjzR¥¦¶p|Ã‘Øp;_:©q€®8ø‡Ãš‡†ïdÓu8^ÞêµÑÇ#ñå]r®¥’EåIÚ~~Ò—ò´?;M£(Ú‚Ò[áÙŒ¼¶ëÐÅó<kƒ*¾]}•¥ê¶º­´wÖ2¬öÓ¨xäC•e<‚¤~½ÁààŒUº+Í~/|Ò~"Û—-¶¨€î•rÄâ)À*e‡ž`ñŸš6 üa®økÄÿ 	õ”óüË+Ø¿yÑ6U€8ó"qòË‘H¼‚xÆA?Züý¢´ïÇ›©”³Ö°ËÏÉ1,öÅ¹Á-nÄº6™æ¯d4QEQEQEQEQEQEQEQE|CûY|<ÿ „{ÄgY¶\Zj ÍÇðÌ»VáxÃå'RX’Z^0¼sß³¯ÄÕð7ˆÒ[¶Û§ÝopIáTœÇ9Ïüñ“–?óÉä=«ïå`ÀÎih¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠòOÚ;áAñÖ‚g²MÚ¦ŸºX ë"ðf¶èÖq2' ¯žf¯‹‘øV“JÖ\Ç¦^•Wb8ŠUùRgî¡ºœã)µ¸G5öür¤ª2°r<‚à‚Ap9¢Š(¢Š(ÍyïÄ?Ž^ð22ÞÜ	ï ÊÛ@CÈ}7àì…O÷åe™5òoÄßÚKÄ^8ße}‡N~>Ï9aÇÏòÉ' åSËˆƒ‚®+€ð¿‚5¯\mÖ[¹:åW¿Ï!ÛKþû¨b¾ªøAû(YèO«âÂ——‹ÊÛ/Í

´¤€n$\.'!€aô@P£–Š(¢Š(¢Š(¢Š3FEyçÇÍ/LÔ|¨®®ËQDeŽB2VTù (2	f|&ÐrêÌ§*H¯Ï@@ÿ >£ð<S(¢¾‰ýŽ¼Ú†¹7ˆçLÁ§ÆR6#þ[J06œã1Á¼·‰—¡Á¯²ÅQEQEQEQEQEQEQEQEQEWÊÿ ¶ÇˆGüK4U# Krãw® ˆ²À¥(ÄöpZò/Ù¶Çí¾:Ò£ÎÊòÿ ß¸äõ5ú
(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*¦«¤ÚêÖÒXê$öÓ)GÆUà‚èzƒÈ ×Æ_?g)üï¬ø}}åyw·Ç$Jygƒ)1É”˜ãk×9ðã,¿µR·›¤Ò®¶­ÂNÜ}Û˜Ôd"0 ù°ü£æT¯¼4­Z×V¶ŽúÂTžÚe’FC+Ð«b:ƒynƒÍyoÆŸ€úoÄxVà0µÕ¡]±ÜÈeäˆn`¼aŽQó"$”8,ñN§¦ë¿5¿&_2ÇS³pÈÊpGe’6û²C ãvR¡(ã9UúûàŸí§øácÒõb–zÉUsˆç8äÀ[îI‘“Ü-¤j¢Š(¢Š(¢Š(¢Š( ×›|dø%§|HµO1¾Í¨À†à.x<˜fLƒ$E°Ã6ù£a–ñ'Ä_…Ú×€/~Å¬Å³x-¨wG ‰ø'o‘ÂÊ€‚Ë´†;_þ8kn¿pæãNr<ÛYì<ä¼'?¸›“ó¨Úùj¶/Ûß>&èþ=±Ú<¹`›%ˆž6Ê€œAØêLn9V5ÖPy®sÇ Ò<k`tÍn,|²7G±$.>dqíò°ù\2ñ_|^ø?«|.ÔÒHÝ¥°‘ÃZÝ Ûó/Î#}¿ên£#r`…ñr5÷‚ŸµT:ËÇ¢ø»lLÇx>T‘²@[„éŸ—l€˜¤lîò›
ßHšZ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Ìh 7Œ¼+q²o½³?i€É(™ôæXK mÈ8ùúvÜr?¡ÿ }{õ¯ºeï‰cÅ¾]6íËj`Xœ±Éx¹òä’X…S×|dŸ¼+Ùè¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š|½ûF~Î/vòø§Â–‘‰{›HÆX±åç¶A÷‹™¡±Ì‘Å•¼gáÿ Çx¾Íi9–Î3†µœŒc‚ª	Û7b6PsÁô?…¿lß±mqe6Ü³ ó£ÈÇÊ­&ËØÝ ™8¯BÑ¾<x+Wö}ZÙ€;fo)¹à.'	—Ï,;Šímu;k²E¼±È@Îƒqëò“Ç½YÍAq±y2zn`?ô"*¤þ$Ó`C$×P"(Ë•@ä–â°æø¿àøsæk6 œ}¦<ÿ ß!²O 'µrúÏí;à}57G|nÛi!mâw<tRJª!cÂï`½I ×Ï_¿jMKÅñ3CI4Ý<Ÿ˜‡ÄÒŒ	^"Qç9†7mÿ Ç&Ñ°ùG…|«ø¾ðiú=¼—37.r7Ìçä‰F0^R\n9õ_ÃÙIÒ/<VÂþïƒä)">Ž~W¸ ÿ lg´x¯{Òô{M&³ÓáŽÞÝ8”*ìª þ¿‰«€bŠ(¢Š(¢Š*›ØmSÍ¸uŠ1üNÁG¯VÀè~Æ¸)¿hOC;[>¯nY:²îdú,ˆ¬ï´‘ïI'íàD^žŸË	Éö®sRý­¼iMÜÜ°Æ8IÉÁ!§ò£ ˜îpH ž+„Õÿ m¸Ã(Ót¬¯93ÏƒþÎ“Œ–Éàð	ë\V«ûdx¶å™mc³¶Œ¶T¬Lîe-,Ý¼¥>€W5¨þÓÞ9¼—Ì‹D0Ø¢‰Ô†II'ýìqÒ¸xû[ñ;™5›Ùî²Û‚Ë!*§¦cˆmŠ3îF¾£šçè¢·¼áïji\~eÄîuÀÇ$„r±D¹y²Œ™—?¡ßüià}Èîò†e“2HÜË3[Ûî®HD
ƒ€+¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šø?ö­×µ<muÎÛ8â¶ }Õ3>0I#|çàöè+ ý4¶x’ãS ²¶nHÎV˜nŠÛ#“¯,¬ØàûBŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šk¢º•`#ùà‚à×Î¿?ek=^)u¢Û_­){‘	$-´§£ýC¶Éóø+â—Š~ßÉgtHÜ¬öw ”ÜÍº<ƒ¼äË¾Va*‘Ÿ­~~Ðº‚ZnûªÀfÚV1Æ[ìÒð³ƒò€²€	hÀ¯SŠã¾$|,Ñþ Y}W&|™ÓHÉÊ6Pçç‰Áð2¹ Š¾)|×¾\¬ÒþúÉ˜yWq°ä+¨%­æ”RÄ	†BWèOÙïö‡Ä±G xšUT@Ü€'9áVè~qó.$µôh¢Š(¢Š(¢Š(¢Š(®wÇ^Ó|m¦I£êñï…ùV<n>äÐ¹d‰ØòŽƒñ‡ÅÙ£Ä^y.¬ã:†˜	"h–Uãþ>-×/9x¼È°7v;ð‡Œ5?êjÚDÍÌy—Ê~ôn§å–&#æ¸ÜR®¸þ|xÓ>"@¶ÎE¾±n–Ñ±ÃKlÇýdyÁ)þ²,áÁcêY¢¨kšŽ»i&Ÿª@—6²Œ<r(e=Ç¡•a‚¤5ñÏÆïÙš÷ÂlúÇ†Ö[½+«¯ß–œê 4Ðñ"«:.DÁ”y•oà?í-7…ñ¢x©äŸMÿ –S»ÃþÉ<¼¶Øä YáÇÉ¾3µ>Â°¿‚þîí$Y`™CÆèC++ÊèÃ!•pEX¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( Šø»öœøÿ ½Óx—FCý—u'ïsäÊä’qìIN«„Çò« kð‡âUÇÃírZd‡ý\ñ¯dAœ1HH××èf…®Zk–Pêz|‚[[„Žàúã£ËÕX@"¯ÑEQEQEQEQEQEQEb¸ßü ðÇŒrúÅŒrLå²f9}¿}×?F,0AWŒø³ö,²¸c/‡õƒþ™Ü§˜L4^\‹˜’Ë!9
0yŒ?fOø}LÉl/­×q-jþa t&	(Ü¼á]£†9Æ|ÉÅö“pñ°{{„ùYpÑ8èJ²þéùùNÒ=9#x“TQµ®'ÐË'òßTîµ;‹¢áÚBr[Må±øTfé…ÿ ¾GøSwšØð×…õOÞ¦›¥A%ÕËçj/'31	@g‘‘BÙâ¾šøsûÅ-ç‹î˜çì¶Ì@ïòÍsò»•cä¬"¾ŽÐ<7§x~ÜYi6ÑZÛ¯D‰B©Ç,ÚbIîkKQEfŒÑ‘FERÕ5»&#q¨ÜEm‚Å¥p€Ë¹(äúW«þÑ^Ó7Õb•Ó,¥Îzh•‘½ðÇðs^qã?Û/K±u‹Ã¶wÝä¸&Æ:" ò³g©eDùKgŽ#]ý³õë¨<½2ÒÚÒSœÈKÊ@í±Dç-æÅ;ñ?uŸÎnõ‹™nä8æF$‘CÁ8	ã$ýâIÅÝ7bß­.ù½[õ¦ùNy<}¦y?†MkéþÖ5(…Å•Ìñ@hà‘Á#‚"2“ž1ž½k°Òÿ gOêX0éS*ñ“3G^‡¸f rÛT‘Œc$
ôÏ
þÅš­Ã‡×¯aµŒ7) 3;27¸Š$'œ’c ƒ^—aûøBÞ%K‰/&qœ±˜&rIû‘ U ` =9¨µ¯ØûÂ·6²E§ËuorËû¹O1Cv/¨Þ§ø€e8û¬¾5ñ&…>ƒ¨\iW`	íex\)ÈÜ„«m=Ôã+ßÈ5œªXàWÛŸ²¯ÂÄðÞŠ<C}5Ir›‡Í¾wDžÆs‰¤õ5 lÅ{µQEQEQEQEQEQEQEQEQEQ_š/›Pñ.©u¹¤ÞÜ²–9;|ÆTç¢(P:  ¯«c­†î5r£Ì¿¸*”„yKÉá—Í30 pY—$Š÷ú(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( Œ×—|cø¥|E‹íDý—VEÚ—
2»ÄcjB0"Hóò¶>Sñ_~k¿uiªÄÐLx¤BJ6ÞDL»s´óÆÉ¢þ%^§Ü~	~ÕrZyZ/¥‡…ŽøòÈ1…[¥Q™“€>Ð?x:Ê úºÎò+ÈRæÝÖHdPÈèAVSÊ²°Èe#AÁ5P×´=zÊ]3S‰gµJHÐƒïÔ0<«)¬)WÆŸf_Â’¾¥áð÷úg
Or&eE <@¿wŒ¼÷Ÿ³ïí-Á‡<a9YWå·½”ü¬¼†êCÒAÑ'p@ÊÂ^_é¸¦Y”IŒ29uAìAÅ>Š(¢Š(¢Š(¢Š(¢‚3_?~Ð?³Œ%‰õÏB±j©––Â­ÀêYG
·@çÀ˜®wmañÜs^h·!âi-îac‚¥‘Ñ‡ÊpF×ŽD9SÑ”åXuö'ìùûFÇâ”MÄÒªjÀ…†b­Ç¢aäáDÃíÊ>€SšZÍ|÷ñ³ö^²×’]gÂˆ-µL™ qÇ’ÛKyØà«);:‚ÛÇ|øÙ«|/¾þÂÖ’VÒ„…e·uÃÀÄåÞlmÇ|–ÿ êäÉhö»‚ÿ lhÚÍ¦³i¡§J³ÚÎ¡ã‘CÐqÐƒ‚¤ÀWh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*Ž¹¢Úë–Siš‚	mnchäCÝX`óÔÕXr¤ üýøËðŽûáÞ¬ö²†–ÆBÍm9ë®¨çÄY— ž%±þ[?¾6êo÷d„	í‹pA<É c¶;…ä†Y~ä¹%]~øÐµ»MrÊOO‘fµ¸@ñº÷ŸÀŽC)åX8"¯ÑEQEQEQEQEQEQEQHV¨jÞÓµˆÌ:•´71T‰cWa†08Ü88ë^q®þÌÕœÌ–mg!êm¤hÇLcËËD Æp¨¹9ÎrkÌüYûCä<=¨±AýÝÒ.ÿ @¨bôËG '“šùoWÒ.t‹©l/£1\@íˆÝU”íe8È8#‚	Ã‚*¬k¸óî.¥~†üø[cà-(aUkû”I.§—r2Xàˆb¶$ (ùœ®÷b}QE×+â¿Š~ð›yzÞ¡¼¼,¶é0xÉt›}öàI¸=sö²ð^œ¯öIg¾eÆ<˜ˆ8ÈNaA´¶Hô<W¬~ÛVë½t½)M<Ê8î^8VB\‘»d×	®~Øž-¼fkf„‚»"20åKÎÅXÉ>J‘ÀŒœOÚ›ÇvÉåÿ häœ¼1çž»G°ÇŽjÿ ÚcÇwìö“Ç´t†(Ó>í„lût¬Sã_Œõ8ÄW­à@Û†%òùärðˆXõ<Ç|qYzo‡¼Gã	óiÕü¬Ü¸W—–ù‰idÜŠ[ÜÒ.ìgqâ½Ã¿²—um­wv11^n%Á<Ÿ&+nUä£4g Ýœã¸°ýˆ®X7Ûuhã?Â"€¿âÆY vÚ7ìsákE?m¸»¹b áÖ0ûÄÑÙ¶ÁÎIß³ý•¼ "[)''¼³ÊHöéWGìÓà1ý–Ÿ÷ò_þ9MÙ—À×K_ÂYGòWIá„þð¸HÓ …‡ñ•ÞýKË.ù	;Il¨À 
êÕð8çÒ—QA5ù©ñGPþÐñ6©w·h–öá€öóGþƒŸÆ›ð×Ãñx‡Ä:~•9ÄWW1Dý~él¸à©ù•JpFgµ~•EÄ¡aT  è àìú(¢Š(¢Š(Í£4f¶+žÖþ"ø{CãTÔmm‰$bI¯Þs»#¸ÆsÇZã§ý§<¢iÞq•ŠRÝÏ—Àô<Ôÿ ðÒ~ÿ  ´÷î_þ7QGûMxÝ“ûMFÞæ)pÝ>_8ïÅ>oÚ[À1©íDlác”“ì—Éö¬£ûXø t–äý-ßúâ²µ/ÛÂv²yp[ÞÜ.3¹cELM$múb©ÿ Ãixkþ|o¿ÿ Úõ›?íµ§+‘•3'bÓ¢ŸÅ@p?5ü6åý%ÿ À„ÿ â(ÿ †Ü±ÿ  D¿øŸüEðÛ–?ô—ÿ ÿ ˆ©mm­1œ*t¹I£cø+ÁüXWkáŸÚ£ÁšÑXî'“O•ót›W®9ž3$##’à y9W¬iú•¶£
ÜÙÊ“Bü«ÆÁ”ýIó«QEQEK[Õ¡Ñì§Ô®ˆX-¢y\“€v$óŽ\¡¯Ì»™$Õ¯ËÃi'²¢üÄ´ŒY#Ç|:OLf¿GþøR?	è:$@³BªØÇ.~yœà KÊÎÄàI'’k¢¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬/ø+LñŽžúN³šÝù™}Ù"qÌr/fA*ÙRAø»â¯ì×¯ø2Y/4ôký)Ieš!—EÏæ•”e‰Z"â"É/ƒõo\C§Ü¿Ÿ¢4ƒÍ…ò|´'÷’Ú2òŒ¹2¾h¥ÃTf_vY_A}wV®²C*‡GSÊFU”Ž ‚5=WŠüiý›ôÿ «êš0K-`I
sž \Y::‚pÄH². ð|KñÁ=E´mJ'kdå¬ç'a8–Öa¼F¬ÙÄ°‡…˜aãVÎ>¹øsñWDñõ§Út‰¿|€mßXóÿ =#ÉÊç…‘wFßÂÕØfŠ(¢Š(¢Š(¢Š(¢‚+Åþ5þÎ:ŽDš®–Ó[8%Î|¹°u_»'@'Uß‰‹€>1ñ…ußµ–«–·Qàín8êN×Lò$‰ˆ•aô§Á?Ú®Ž-Æo±”*G|rAçj‹Î>BPnGÈ@-0C–?P#«€ÊrB?0Aô#{ŠuW|wøkñÕ¯ìBÃ­Â¸G<,Ê9Î{¢)¹1“†Ìd­|Ñðûã'‰~ÝM¤Í™n’:Îã*Uú1F6ò·›l‘Ê }­Ÿ0ýiðÃã‡‡þ DÊ_#PÁ-i1@VŒƒ¶xûïŒ’ÕŠô,ÑEQEQEQEQEQEQEV<¦øÇN“HÖ"ó “GŒ>ì±?%$Br¬8#*Á”~øÁð_UøszèyÖ3.P|¯Žv:õ3ùš3ò°Ñ3*»>:Ýü?½·lóhó·ï¢•'ƒ< ð%Æ€:ðxŸ¹t~Ç^³QÒçK›YFVHÎAõ«Œ­†SÁ ŠÑ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(5ù÷ûK”>>Õ¼¼mó!éÓ>D;úq»vw÷Ýœó^b´çØÌcú×Û¿j¿]éVë¯ÎloãPbv˜ ¬ð´BL#cvÇÃG§v3[Ú—íIàKHËÅ|×:G2=ø.ˆ˜ä–÷é^;ã?Û?Q¸f‡Ãv‘ÚÅœ	n?{!äùhVÈcÇï&û£#æ!xgýªüvÀ|ƒÅ¼\ýr¤~@W=ªüvñ–§ÅsªÝmä„që’±²Œº®89ÄË,ó±‘‹31ÉnI'®YŽKO$“KoaqvÛ"V‘ý>œªaÉ9àWwáï€3×@k]2uCŸš`!×ÁGÏ8&± f½?ÃŸ±f³pCk7¶ö«žDA¦lc=XA;¾Ra€HcÅvv±N‰x¼Ôn¤“=cHß.“ûïü+®Òÿ e_Ùf¶–ë·÷Ó9îác1€Ç¸ ®»Eø=á-£ØiV‘¼`…sgç®d“{¶z|Äàp+®†àAJ`*€ € Øt§ÑEQEQE#WæGŽífðúÜÎò,•oá¯ˆ¡ðïˆ4ýZäf[˜¥|uOÎFUI` %¶í‘_¤zf©kª[G{a*Oo2†I†VCŒjÖhÍÉ¦ù©ê?:<äþðüë-¼]£©*×ÖÁÁdÈ#‚ÝÁ‚=jïè5ÅÖ£kiË3L˜¹ù³Ô×-©~Ñ>ÓØ$º´.Oüò(üZuBkœÔ¿k_Ú‡6Ò\Ýo—(cè¯1Œ÷œ*ZñßþÙ:õó¼z1XAÈVqçKŒðÄ¶ØP9P’’77
óö‹ñÅÜ†gÕgRp1H×DXñžäõ5~Ð8<.«tàJö=>:øêá¼µÕnË7 \Ÿ¢¬{ÕG…,3üHºAqk’Fãpu7eH=+€Aí°ø
¥¬ÚxîxÕUku Ÿ=nŠƒØŸ7*¡ëé\íŸ†5BC­ÄÒà’"†Flw'b#=IÏ=y­ÝàßŒ5«km¦]ï8æXš%–’àD€äà±Æx¯OÑc\üÚ…Í­ª•ÞVûŒcPGr$uô'­lCûê{Ç›ª[ˆò7ŠBØîT3í$™8'¯èÞý’|)¥Æ?µ|íN^æF1¦qŒ¬PÆ9+½Ý†pX€1G[ýü/zåìn.í>\Ü²¨<óûäiÁh|“ÌÝþÄQlo³kÌþöÃð"²øŠÈØ—T íÔ­Ií˜¤ÿ ßg^~•‚ÿ ±§‹Á K`W±ó¤CƒÇÓ'µF÷öCñ­»Š+iÁïÀ {5"9ú=ê±ý“|rüzDíæ:ÍÔ¿fØ¦¼›?¹xäÆ;6×]§Ó®k‡Ôü­ixû}•Í¸9Ç›‹œuÁd±ßi#ßÖ@ŽEå?ñÓŸý5Ñx;â6»àÙŒÚÜ–¬ÇæUå§úÈt.p1’›ÇfçÝü!ûhÞ¤±Ãâ;(æ„’[l¤ƒÑ„2ðx*%BÙÈÁÒÞ
ñÞ‘ãK/í-à\BÖ*ÈÝLrÆÀ4l0ÃæRTƒ]QEWŠ~Ö~.:'„[Oˆ‘6§*ÁÆ3å¯ï§<‚0QgþðÞ¾eý<<uÿ iñÉ™R5Ä½0JdBCpWÏ0ƒ€HÈ#Èý^œÒÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQHW5á?ÿ e=#ÄòÉ©h26ýòÌs¶rX ÃÀÎxf„íà7”[$ø®‰ã¿|ÔWGÕUšÀ~Í)Ý¦ìl¦ê·`‘·
¬ÿ ¾Xƒ_Xü7ø¥£xþËíºDŸ¼@<è‰"' u§ø$BÑ¸èÙÈ…Ë|Cøo¤øïNm7WŒÖ)”2&ìñ9í!ÊH¹WR|uã?…/ø?ý±¦I!µˆþêöß 'mÄ7“™¡­Ÿ8ß {ÁÏÚ’ÇÄï‘âP–Z“°Ž9"XŽîÏÙåb0¨ìcv!Q÷•ï ÑEQEQEQEPFkžñ§€´Ù?\·Yâ£tt?ß†Q‡½Ôá‡
’+âOŒÿ õ‡­Äln´¹˜ˆîãœC:ŒªK·î‘ˆçØJÕøAûLêþ	H´½Dý"<(ï"\‹yOQs²Þ_”à*KÀ¯°<%ñ/@ñdÜi°ÊdàFX, €#ÀÄH® Œ§Ô9®ž‚3^{ñgà®ñÍÖåD’¯înÐ|ê{,€cÎ„ãœàŸ-‘°Ãâß|8ñÂýMñ"’·¹ˆå‡Ì¯ŸÃ Æ|§Û(Æ
ºOÖŸh=3ÇÐéúŒ‹k®€ã|*ÌÀ|ÒZ’pÛ€.ðœIÈÃ(}€ÑEQEQEQEQEQEQEVŒü§ø¿M—FÕ£ó-æ¸eaÊK‘žUºv © ü%ñ—à¦¥ðâø,¿étä‹{•\=L2¨ÈŠáFH\í•è¾ë¢Røcñ{]øwsçiÍºÖFky3åIÛ,Ì’÷e¡ÄŠ6×Ú_>9hâòìÛìú‚®^ÖR7ãZ&lññËG–N<ÅB@¯D4QEQE2y„(Ò·ÝPXãÐž;ž+É<ûPøOÄóýŽW}:flGö½ªœÄÈÏ1îHÈsÀÝ]¿‹~%h>´ûv¯yhFQCwÎJˆbR^BØãhÛÜ+Àí¿m…mA„ÚV4Ì
Ì<à9Ã²²¬°Û˜„‹°äy¯Æ}cÃ´o‚|A"[Ûj)Òc	p­$à'™ —ÉjÈÙê	é(á€#yCN¢Š(¢Š(¢Š(¢Š(ªš¶¥™i5õÁÛ´Ž}”? ükó7Å^ ŸÄ•Î«uþºêW™†s‚ä°\ñªU…óY*¥¸5rÏKººÛ#¾1ŠÍŒôËƒÁààûVÔ_<MpãÒïäFäµ˜ƒîÌï]“û<xÛRòÌZ\è².ØÀ÷1Ã ¥=±^ƒáoØË^¼`úÝÌ1ñ•Bf“ù†G8òy
EzŽ‡ûøVËæ½žîíŠà‚ëç»(ÀôV‘ÀÉæ»/öuð.°¦•®ŸÅ1i7{ºÈÌŽ~«]Æ‘áí;FŒC¦ÛCm€¡bP`rä€yÖ¯í¥¢Š(¢Š(¢Š(¢Š+˜ø¯Máÿ jZµªïšÚÚG@zd:ªg{E<Žµù­7G§ýÇ¯ãL+WJñ^©¤#E§]OlŒw2Å+Æ	Æ7‰ÑK`’3Öµ¬>+x¢ÆQ<¥ê¸ïö‰ÿ ‘ñÜÖ©øõãB1ý¯yÏý4üEs·ž=×o£¹¿º•ï¸”ƒõS&Óÿ |ãÚ²ÿ µ.ç£ÿ ßmÿ ÅRµíÔ‹ó3•÷fÇêqQsÇÊ>¡­né~×õS>Âæ~@ÌVî@'îîpS=AfP$Ívv³g/¤òÿ ³¥ŒîšHÐ}3æ>IôÇã]f‹ûxžé•µ‹KTeÉùÞW²”D¹YˆõÒéß±$¾foµdXñÒ+rN{s,„c­tšoì]áèB›Ûû¹˜6NÁjG÷q²GYôÁ®ÂÃö\ð-«™ÍçÈÆÙ§‘€÷róè{Wyáÿ è~Pš=½ 9Š5SœmÜ\Å¶ðX’Orkom.)6Ñ¶–Š(¢Š(¢ŒR2†=?Ï­ršÿ Â
ø€îÔô»YŸ oòÂ¾$,{$ xƒ’¼Ç±¾‘|¦o\½œØâ)¿yöÄñÿ ßr(Àù:çæ¯ˆ?	õïN!Ö­Ê#œG*ñIß÷r€>lg1º¤½öÈ>|NÕ<©®§¦>Táf…‰Ù*Ï9 èW$Å ¢c‘¹£}ýàXxßI‡[ÒÉòeÈdnx’gCÜ|¬¸u%Xèè¢Š(5ñOí‰â¯í?Ç¥FÊbÓ 
@ê%”ù²ò=#pFOPÂ™ûZÉ'‹žURR;9‹Ðnh•rÚ*qô¯¶h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+”ø‘ðçMñö–úN¦¸þ(e\nŠL²&x=pè~Y•n¹xŸáïŒ>jk¬YHË
±ÞCÌLþXÎ»fìaœ23a£”¸{oÁÏÚ¦ÛÄ×1h¾&,ï¥!"™2"‘Ï7GÉ·‘Î|Ï±Ú[
~ƒÍÍ´w1´3*¼n¥YXdxee9¤pA"¾Iø×û,]éòË­x:3=™Ë½¢ó$}ÈOúøz•‹‰cÀ	æ*Éð+ö–}'†übÎÖêÁ"ºnZá1ÜîùÚ=$ É+((/Ö±J“(’6Œ‚!G Ž§QEQEQEQEUoE´Öí%Óµ–{YÔ¤‘¸È ÿ "
°Ã+ ÊA ×Ãß´À‰¾Ý‹í;|Ú5ÉýÛ°ËDýíæp0ÙûÐÈpd‘·H¡ŸÈíoeµ‘&‰ŠIŒ§¤ÊÈãæFV”‚0@¯»~üt´ñõ’X_:Å­À€H„àLÜCœg'™b4L{¡V>¼zQTµÏY¶{F¸¶”xäPÊAàäüðFê5ñ·Ç¯ÙæãÁ“6¹áäytc–uf·#'k‘ó›p?ÕÏ÷¢d÷d¯Kýžÿ h»MRÒø¢àÅ©FDpÜL~Y—¢É/
“ 3!hùY¤fZú,(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÏ×ü?aâ94ÝV¹µ—ãd©õ¤V2
Eyæ±û3xQ·0G§‹V=$‚GWÕ™Õ€Îv²²’AÅx'Ž?fx*c­øZf½ŠÜùˆaÊ]&9±¯2Œe `Íƒ˜HÊ›¾ý°µ},%§‰íÖú5àÍîæÀà–R<™Ÿ#œù9æÀ?Døã7†<lDzEÚý§½¼£Ë—¶H‰ñæD]s‘œƒ]¾áKEQAë_›Ÿ´ø´¯j––£lQ^Lª:áwnîcÁéÀì+’VfùW¿§ùéíÒ¾¬ý“>(ü]­[ƒ¼l²YT”ÿ ­ºUlðãBÅA(×+"š÷üð·‹Fu}>%Û´JƒËHH¶6$€r$“X7_
õ?X…ð¥=«À2–—oö‹i08‹÷Á§¶€‚TEÆJ“]GÃÏ¯Š´á4ñý›RŒ7–¤å¡™8‘}í‡‡‰ú<n¬	Îk©ÍQEQEQEQ^QûPkRi~½X	Y.š+lŒp$qæÈ?+D®œs–#¨ø>c’{ä“úÿ ŸSÅ}—ðcö_Ò4ý:SÅPÍBuY<‰9Š @eãlÒ€xÏ””EÚ2Þó¥èözT+m§Á¼*„‰(…P€8·j¹EQEQEQEQEQEÉ¢Y”Æà20! ðAx#ƒÅy¥û+x&÷Í)o4.âS¸[8ò£bÑ…B~T*P i^+Ì¼IûH¡äÐõ%|))Ì{I9;TÍ	Ú2¸Ì'æçhÌ­?eï\\=±°(?;Ë¡ÁÇÈáœ¶î«ò.Wž:WIìcâæÁ’ãOAùë)#Øâ>¤zf¶ìbmQãïR¶Ž^ê±Hãþú/ïZúoìIöýX“ü>U¸ÇãæÈçò"·ôÏØ¿Ã2½ííäåX«åÆ¬?ºB£8ÏªÈ¡ßhÿ ³Ïô°»4¸feÏÍqºbsýá1elt\©Ú ÅtºOÃßi[NÓm-Ëu1À‹Ÿ®Õ®„ 8bŠ(¢Š(¢Š(¢Š(¢Š(¢Š+;ÄŽ¿e.™©Ä³ÚÎ¥]dsÆFz2õVe E~jx·J‹HÕnôø$ó¢¶¸–“ûêŽÈ²v0\œp[8®«áÆKáÖ¡çÚŸ6ÎRöìp®p‚eêåí÷1Ÿ—ïø¿Nñf›¯¤Ê%·”À•¿Š9WªH‡†SõR	Û¢Š++Å^$µðÖ—s¬ß¶Û{HÚVõ8*ú³¶Gv WæÇŠuÛê—:­ÙÌ÷R¼¯“œ;ŠŽûc\"€>êÐ}¥û0|)ÑF±z¸Ôµ4W õŽ¿X vÝæÍþÑTé5íTQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQET7–pÞÄö×(²Ã *èà2°<el«8 ‚+ç_‰²%•Ù›RðŒÆÖã—[Gæ"yo.rßsc`c$hz ã¼ûRøƒÂÆíz–ÇËv?%Ò‘µóˆæa€™å»ã>l™ßVxcÄö'ÓáÕô™V{I×r:þL¬§”t «£ ÊÀ‚2+VŠð¯Úöz‹Æ(Ú÷‡‘b×#tU¹¢±8T¹Qþªc€ã÷S›?<ø/ñúO‡ªÞñ¤3Ç«”ö’NLEíÉhŒ{Š‘CÆQ‡Ôñ~—â›U¿Ñncº·oâ²Aþë§ßÇuuV•±EQEQEQEQY^(ðÍ‰´éô}R1-­ÊuýU”ŽUÑ€taÊ°Wç¼)?…5«½äî{Yš=ßÞ˜ÛæFèåsò–#¶=•ôÖr¬öÎÑÊŒ	VV«£)¬¤d2Aöâ¾ªø3ûYG(Hñ«mn/‡CÛý1F6žƒÏv“ÌŠœ±úvÞæ;˜ÖhX<n+)È ò¬¬2 äpGJ’™$jêUÀ*F=<AàƒÐŽ†¾Qøéû/}'ñƒÕšL“Y’ƒ«5ªõxÔ†f·9d÷9 GP|ý¨—F·Añ{;Û ÛØË´hÂN£2K$@ÒF>YUß_Wéº•¶§n—¶R¤öò¨d’6¬FVRCpjÍQEQEQEQEQEQEQEf¼âßìÝ¢øåŸP´ÆŸ«>32.RLgý| ¨,s:2²ôÌ ZùÇ_
¼Iðöàj@Ñ¢°1ÜFKDÄ`†ŠpÆù
þT €x5Ûøö¯ñ?‡mu=º¥ºð>ÐJÊ  \Æ¬ÏÏ$ÍÔn9}ÓÂµ¿„õ‚"Ô|í6R@Ì«¾>qÿ -¡ÜsÉ‘P\ñ^³¡ø«K×âMÔ7qžñH­Û8!I*pAÁ Žâµh¢¹_ˆÿ ´ßioªêÏ+CïÊøÈŽ0qÇws…2ÌE~tø›^Ÿ_Ôn5K²÷R¼®@ÀÜä±
;(áW¾ '’kÖÿ f¯‚£ÆúÕµEH²q½Hÿ ]'Þã Ø£kÜuÊ²ÅÈûŽ8–%€*€ À  € S«;ÄýŽg&¥ªL–ö°Îîp ô«1èª ³ 	5ðþ¡©jÿ ¾ \ßx0=½ÅÓüŽŒb+a#óî$NP|©$€‡%Œq„i0+íïYÞYi¶Öºœßj½ŠI¦Ü $“c{z½+NŠ(£4fŒÔ)w·–Ž¥ÇP'Ž çŽüqÞ¦ÍQEŠùŸöÓñ<qXiú1ó¤•î]Aà")Š3"÷Ý,™¨Ìlzâ¾~ø%ácâ_iº{b7$ƒ"ýü°F¼µBr1¿#8Å~Œ--QEQEQEQEQEQEQŽôQEQEUG]±ÓÉqº.2e‘Pô¹'¶z×-©|lðn›!†çW´ 8YðzsáŸlä¢ üÿ A‹_ûìÿ ‡éP^~Ð¾µˆÊÚ´ás±ÿ uKì®wRý­<fÀDnîŒ–ŽÝ€ÇÏ0œž¿(#ß5P~Ø^#>]ð>žJÿ ñÌ~f¨j?¶w†¡ ZYÞM‘Éaxöùä9ü+Qý¶íQYi.ê~ù’uR?Ý¬ ÿ ÀŠýkkMý³¼93{ew ÆAO.Lžà…u+ê	ëè+£¶ý«|4bG¹ž&#î5´¤bcWLýzm§í_ày÷y“ÜCƒ¾ÞCŸqå	8ÿ {iö«ðÔÞÿ ŸÙ?ðþ7PËûVø"Ü\8?Ä¶Ò`}C*·ä¦¦ÿ †¦ðüþËÿ €Óÿ ñº…?jß™šqpªD†ÚM§Ù@S ?ï"z¯7íkàØçòí@óE¹	ÏVÃ›ß÷[ðƒKª~ÖÞ	±Û²K›Ùû–ì¸Ç¯Ÿäç?ìî÷ÅP—öÇðh…¤/QÂÆbP[ŒœÈQW8RKdg;qÍdÃjhÿ ô¸ÿ ¿±ñU•ûk‘)ûŒ^Í%Æ¿E*ãèæ²õÛOX|}‹J·‹ûÞd’IŸLlH6þ;³í\?‹iÿ kðÉj’­”R’µŒ£m#î^P;îMžŽŽÌ$'t€‚}úý}ûž§š`8®Çá§Å[ÀŠê\Ÿ!âX\“«ýÙ£þYÊ¿¼ŒŒÈJ¹¾|cÑ¾!Ú	,E|ŠÖ®~t=Êçh³²Ç•#‚6Tw”Q_$þÖ¿#¿qàí&@ñ@áîÝNCH¼Çnã7ï&¥òÓ‚2ýŸ~?Ž¼EsÇ»Mµ"k¢zl˜á9q"ìÛLK)Ï? J¡F–Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(#5À|Nø- øúÞC{G¨ì"+¤ulža\yÑ‚yŽ@ÊFqƒ‚><³ñ>
ê’éÈòZ0}ÒDã|ã JªÃG"íS4,’…!]ƒ®Úú÷áÇ-ÇvðÇé¨è–Žpá€ÄEÂ‰ãå^<åy*¤0‹š+Ïþ(|Ð¾ Â[PÉ¿
wq $ä+ÿ ñvòåÈ …î¯Œücá|$ÕJù“[Ù†êdIBòOÍ€G™»š<U—.}ãà§íW¬Ñhž0";£µ#¼ìNÐ.PmXå@•3’wH ý&RÑEQEQEQE¾"ý°´¤µñˆ–<nº´†VZHrHë•@KxÆp+;Ã_²ÏŠµíu¸V¼äC®VWSÊ°Â´qïS¹F†mÏI©i×:UËÚ]#Cqu`U•‡¬*Àõˆ$Oªüý¡u/ Ê¶7{®ôwaº~hû3Ú±ÎÂ&"Œ/–Ç'íxÛHñu˜ÔtK”¹„ðÛOÌ‡®É£8xŸ;$U8 ô ÖíóÇíû<Ûëv²xÃ6å5XÉyá‹¤ëür,y \¦7˜3€ÈCHP×þÏ¿$ø}tÚ^±¾Màä…É0¿#ÎŠ?âWág@o”8Euo°¼)ñÃþ,]ÚôLJ#à·Ä‹ÿ QžÕÑƒš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*Û(oa{k˜ÖXdYV¨e`AÐŠùÿ Çÿ ±æ«È×~œéÒ6I…Á’òwÈ–Iûªï€6Æ 
|3Å³'4.–fò5?ë-Iß ùgËœgƒ€´rÄWž4z–ry¶—@dgt2 xÈ'Ê—ƒÏÝ$u8¯Eðïí3ã}/(^ý­”YHÆIÌƒd¸lá‹;œ´®+ºÓ?mZ5a¦ÚÊÙùLrIpC,û‰=ò¸ô5±ûjë“ºu­¸*F]žRf^ ^?ºÊA=N+Ä<eã½_Æ¨kW/q1Î7*Ž»"Œa"L€v ä€X³|ÕÏWÖÿ ³/Æ¯èúø{W¸K¨¦‘ÃÉ’‰xc.6,‰¿ËerÄV®qôU—‰ô»èEÍ­ÜÂÙÃ¤ªÊqÁÃ àŽy¯%øûShF·Ñ5[ñÆ#oÜ§bdC#þyÃ¹³Ã#äˆ?uß\‹jàº©Ìp§Ë}¿sHSØÈÅ¥aÕñÅt>.ÅðãW{»¸öwyR„Ç˜ 1-ØCd<e—z°9Ê ~Žÿ †Æð†3äßgÓÊ_Ëýn?ZÃ×?m]&ÃIÓg™°0gtˆgø²©ç>t Ç#­r·ÿ ¶Öªà}‹M¶×|’IŸ¦~¿…eÝ~Ú)‘a¶±‰F	#ô&Ò~¼VKþ×^5`@šÝsén¿˜ËŸ×5„iŸíY?¡ý?r™úÑÿ -ãÏú
Ëÿ ~ ÿ ã5Ÿ«üzñž¬‚+­Vëf"6X²ÁmÒ"ÀRqÛšãlõË»)þ×k+Å?'ÌŠ¿'$ùˆC“žNæ9 Éæ½Aý£üm£²ìÔ¥“²à, ç¨bê%#¸UÚqJôÈ¿m­HZì—L·k­¿ë®w8>NÆ|goœr27ƒŠ¥à¯Û[Tþ5Š}9ÎÙ¶:gþZDw6òŸóÍù‘rÆ~µÐuûvÒ=GK.meIäQêXSÀÑ¢ƒÒ¿>?h¯ÿ ÂEã+ùã}ðBâÞ,tòÛiÂ’c3s»X+·•ûøSí:­î¿"ü¶ˆPñóîGV±D£#2œæ¾½¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*Ž·­Zh¶Sjz„‚+[t2Hç Uäœ’{ –$ 	5ñ'ÄßÚÄ~$º–*wÓtàJ¤p²2çåyçÁ“{“eØwœšñÛ½Bk¹{†2HÝYÎæ=†]÷1à 2N  q^Ïð/öy¹øƒm&­{rÖZr9J(/#óìVÄj‘’¡¤`ÅœP6–>õmû$ø:^ä®ã‰à†_tTÉç#ûUöUðf™'›4SÞò[™‹(Çcb%ps’$ÈÅm_þÎÞ¼ˆÂt¨¢ÉtE£n=0¡Áåâý|…‹5ãîÎŸîúÚŠN:Å†:äóY:‡ì_áÙ\5õä+Œþ\™> ²)_qÈ¬koØ’Ùn§Õ­ÿ …VÝC÷™ÿ ÀQk{OýŒ¼3
‘ywy3“ÁVŽ0¦Õ>ä×Gì«àXÐ#ZÌäk™r}ÈGUÏûªµCmû'øgxn%ÑZâ@ÙLeú|Ìß-Çì¡ày]Ymî#
rUn$!½›{3þã)÷«#ö[ðRƒ’qÉ¸˜‘ŽFÖ2e}ñ×½'ü2Ï?çÊ_ü	›ÿ ŽTÒþÌ^y_ììmÇÊ³Jã¦ämlÿ AÝß5¡qû>xxÌGH·P{®å?ƒ+?
ÑÒ~x?JR¶ºM Ý€KÄ®N:s.ò:œ‘ŒžNkA¾øeŽN•bOý{Çÿ ÄSäø}áéQc}2Í‘>è0F@õ

à~‰qð/ÁW24Òèö›Üäá6Œ÷Â©
? 7þ?‚?èiÿ |õè?¼ÿ @kOûãÿ ¯YÚ¯ìÙàm@(:jÀT<gœ}íŽã]ÀèA"¼—Æÿ ±~§ð½îâ:CwÁ>Ës=qæDFp7(?<øÏáÎ¹àéþÏ®ZIlOÝfcuÿ W2“ôÉPÁÀêƒ1´ÍRïI¸K»9ˆNätb¬§¦U†N88àŽÅ}ið{ö²²¿…tß8‚íx[°¸‰ÇªdÃ.só…ò_¯îÛå>Òÿ |&¨d:Å†Ð2OÚcúŸâÏNÝkçßŸµrÏš/‚Ù‚¸)%éI³r2>ÐàaL ùÃÃ~¿ñF£™§Ffº¸m¨£=z’Ç¨ƒ/+“ò¨fc’3úðŸá•ŸÃÝ=&Ô‰g?=ÄûB™d=NHÐ|©'d`d–,Çµ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¹¯ü<Ñ¼oeýŸ®@%E9ÁÛ$lxßƒ”n™«†VWÇ_?gýkáÌ£TÓK­1:\F6É™uR>K˜ñà7yDáº_†µ¾µiŸŠŠ]iìDrK³lÑô_8²b9U~ôªcVe‚6·Ø·Q]Ä·:É€22CÊ²°È*ApEKX7ðm‡Œ4©ô]MC2œ62Èÿ Á4g¨xÛ#<©Ê’+àO‰_	u¿‡×¦J#ä3•†áGî¥à‘±¹
ì –ðãæPFãê_?i‰¼>Ë¡ø²W—MÆØ§l³Á€ŒÉ-¾Þ’ÓtyÙõî•«ZêÖé{a*\[È2’FÁ•‡ª²’óêÝQEQEQEWÍ_¶…V]:ÃÄH§t5´¥F~Iôfãø$Œªîu“hå²>Œ°‰#¶Š8À¨  0     +âÛÂ_	!@¯qg²üLXw}‘Æ¾ûs×5á»H¿ÏåÖ·üãÍ[Á×ë©èÓ´¯«/xå¾Yc#ø[•8dd`}ÓðOãM§Ä«b«o©[ãÎ€6x?vxs†0±È9£pQ³ÁoJ Œ×‰ügýšt¿¤ºžŒ©e¬˜ž‘Ly'ÏUdŸõè»³þ±d^Ÿ]ÛkÖsy–z”z:0åYX}å#Œ	ŽXÏt$¸~ük³ø‰§¬r•X·Aöˆznè¦æÞn«÷¡s±ÇÝfõ
(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¤ÛPÜØ[Ý·¤€Œê#Ðî#Û¥rš÷Áß	k±yº]®pÑÆ#aœd¬ùn§ÈlŒq^_¬~Æž¹‘žÂòêÙH8FÙ(’i~Ðwg;‰$×!sûÝ*1·Õây?…^Ù”÷fr¿QúW/ªþÇ^,¶b-^ÒåBä”¦O÷BÊ„çÐ–
sÚ¹ifÄ	:T„.~ì°¶}Ô	ƒösíX÷_üceK.“z¨£æ>I<}±aôéXw~Ö,£3\YÏkÕžÝÔ~,ñ€?:Æ`ÄòGçíô­íáî»¯ t»›•`H1ÄÄ8$9 ñÃ“í[ƒà??ÙŸ÷ëÿ ²¥ÿ …ã_ú^ß±ÿ ÅQÿ 
Æ¿ô¼ÿ ¿cÿ Š­}+öañÍüˆ§Nh#ãšXÐÿ 2‡’UÏ@<¢r{W}áoØ·V¸‘_]¼‚Ö yHA–B8Â8WpÎ«íà9ÈíìW¡wÔnÿ ïˆ¿øŠCûè}µ¯ûâ/þ"ûè}õ¯Á"ÿ â)áŠô/úÝÿ ßñºÏÖ?b{7ˆ3T‘%çÏ…YHÁÀI…”îÆX– gå'ä¾6ý—ü[á¥iã·öÊ	2Zä % m³Ž§î,¹ÚIÛÀ>K=³ÀÌ’	V‚à«‚¤FF2F+µøwñw_ðÍ.‹>Ø¤9’	xœã’,® 66I00Y‡èÿ ~Ùzeû¥·‰-Í›ƒ<'ÌŒq’Ï<kœ•eÛÆI\µ{ö‰âvÝot«ˆî­Üd<L~%IÁÈ#AäW›||øÓgàm*[K9£}návE`Z0ÙSs*Œ•XÆ|°Ø2IµF@b>
v3I’O'©ýI=ÏRÄ÷Éâ¾ûýš¼|3àë_5
\_w 9y˜)œcÀç9Ps^©EQEQEQEQEQEQEQEQEWÆ_µGÆS¯ß7…t§?ÙöR3) K2œ2°ãtVÎ
¨9W˜äFµóÉ9§4N£%H¸¯©¿dïŒzu…«øOX•-¦2ZÈç
Í!àf?*Èdù¡Ý b€îPÕtQEQEQEQEQEU]GJµÔàkKè’x$häPÊGº° þUáž?ý‘4pµÆ!Ó'#ý^<È	ëÄd‰"Ï#÷RmÏ–pC|Ãñáˆ|8]Z°±ÄsÆwDÿ îH0QAË‡¡Ç'‰.Aíù
@ŒRM}­û'|1¶ÑtEñ=Â‡¿ÔTùmÞ83…AËÓ2y²ž6FFŸ|QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE2hVe1È## ƒÁ#‚Aøãö‰ýÛÃLþ$ðÜdédîš%äÛž»—›Bz¶çƒû¬óüqñG£û.—t~Ê|‰TI8'j±`0|©H$€î¯­>þÑOU,.öÙk' Ÿ–\³Û9Æî2L-‰PÃ¨ß^»U5m&ÓV¶’ÇP‰'¶•J¼r(e`x ©ÈüzŽ ƒ_þÐ?³ÄžvÖôi4V#rä³[“ÀWc–hñÌICˆå?qëø_ñsYøw|.,µ³83Ú¹"9GÝ`ÀçÊ—oú¹ÐVUó‘îC÷?Ã¿ŠÚmEÆ8ó€Kw Mç¤`œ¯\H…£nªÆ» sEQEQEQEyíPÈ<	xŽ/%º®N0L©†÷ÛŒã¸<f»†>&‡Ä>ÓõHŸx{tFC¢„™d ¬²+ðz×ÆŸ´÷,<UâÙ'ÓK¬1Ú‰]É$P<¾X=£2’¸®
ïÆSÜhpxxÃn!‚gœJ±âb\2”’mÇtjí] ä.I
µÏVÏ„¼[¨xWP‹UÒe0ÜÂÙV“+/GG+£|®½pB²ýÉð7ã½—Ä[SkrÛY…s$ ü®½öû¾b™À’2KÂHY
;z¸9¢¼ãâÿ Á-+â5¶ëô}J$+ÊŒ‘ÜG2ÿ ËXws´É’ce$çâŸøcÄ5”Kö—°‘$RÄÇ:	`”c|gX0ëû¹£äõoÀÚ:ÛÇLº6²ÛXòp—yŒõsŒh2A_ž&eÜÍQEQEQEQEQEQEQEQEQF(¤e0FG½GöH¿¸¿ÿ 
‘P(ÂŒØ…-QEQEâ~ üð÷Žâ+«[s‚æ,$ÉÆóŸ¹(t=Ö¾rñ_ìa­Y¬“hwpÞ¨ÉHÜd#’v^Ãå “¹'ˆÅ|ÿ ­x~ûEº“OÔax.b8häXŸtýàqÃ&åaÊ±Ö~HúÕ«MVæÏ&ÞGŒ·]ŒËœg¶ÝŒœÉæ¡¸º’áÌ’±fc’I$ŸrÇ,ÇÜ’{t®ÿ àwÃY|}âtò³‹÷×OŽJFäÏ@ó¶!AžŒí‚×ètQ,H± 
ª  v€°S¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠüñøÝðÏQðN»<WJZÖâI%¶›ødFbøÜ8Å¿lÑœ2à86±>øz×Ä"Óô­A¶[ÜÜGpvœ’mfÆÀz‚Ù_˜-}Ãû<øúÛì‡J†  ÃÅ¹$ÎBžçq`Ç—Í|ûñ/öGÕôW{ß1Ôm:ù'uq·åŠäu9_.CÇÈíÉí¿fïŽ×7s/‚üRÄ]Æ
[M)Ã±^>Ç?™†3(ÿ RÍóº©GÂ³ý(h¢Š(¢Š(¢Š(¢Š(¢Š(¢ªjºM®­o%•üI=´ªUã‘C+Á­˜ìE|—ñ³öT›IY5+OdŠZKL––09&b^â<û¶&tÇÊehù´†î9ù__~ÊŸìîì!ðf¨â;ÈFl‘\[ç´Ñå¶þ¶06’êÂ¾“4QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE×\a•#A¨ ðAî+çOÿ ²Õ–«Ú×„còoÆ]íâ9:—0)âÎr#C!v£õòïôéÿ Ž)¢lŒeYYO$FÌŒ<äW×ÿ ÿ j+mq!ÐüXë¡òÇ×Hæ=Ïþ'lŸõ2¹ùJ¾‰Sž{TwV±]FÐN‹$R)VVÃ+)È*Àà‚0E|½ñgöD{‰äÔüÈªùce#m
qÈµ˜îP¬ØÄ3mT$ì•S
¿9][k^ÕJ&°ÔmXÕ$By¥OÝ`r-ŠyÜ2ÔŸ¿j¨5–‹EñnØo—ƒ’p¢á8ò6@.avêb8Sôr0`r-QEQETWwqZDÓÜ:Ç³¹@îY˜€ õ$WÆŸ´ÿ Ç/4^ÐÈ–ÂÒ_5çí,J/“ßÉˆ;üçýkŸl]íá–¾!¿µ¶’Â‰cµ›ýdK#ª?ýtX#ÿ À”Ö{1c“NX™¹^ß™â—É'¸üÇõ Ã4ð~‡?ž:U­Y»Ñî£¾°•à¸…·#ÆÅYOL«AÁ õ	V¤ƒöÁ/ÚŽ×ÄÅ$A©6#Žã¤r¶0¢^‚	Üð1û™áX„¯¡ÁÍË|Cøs¤øóN:f±*2ÑÊœIcâ|dpÊAG:‘Œ|Gñ;àÖ¿ðÂõn[t–ŠÁá½‡*¡Ì{˜smp¤U-‚y‰Û•Ïð‡ö·Ž/Iñ ¸Ú‹z£ ž7qõg<¼ñþïœ¼q M}/e}ôIsk"Ëƒr:ÊÃ±V\‚¨5=QEQEQEQEQEQEQEQEQEQEQEQEPFk'_ðž“âM¶±iÜDc n2ÊÄn^@ ©ä
ù¿âìx…^ûÁrÃ'ìs¿°ÂÛÜ·#§	pXÿ ®A×æ=wÃ÷ÚÓØjPIoqÃG*•aÎ3ƒÕN>WRQ†
±Íf×Ûÿ ²meáIuÇúEÝÌ‚F8ÎØ±HÚ 3à“óÈäpp=ÖŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¹ÏxNñ¶“6ª.ceº7Ù<DýÙŸ£.Q²¬Aø_âÁÿ ü5½ÜÆÍn¯ºÈ1’1œõ‚`ÛHŠ\eÔˆš@3_Vüý tŸØEm©O®µ…–)A!{rØVYI>dM¹Yv…fõÑÏ5á_´Ài|Zá$ðàÛ­Bª0BùÊ§(Êä¨K˜¿Ù€uK+"2ñÿ ÿ j;ýàxâ.¦#k’…e·ídã“,`97–ãç?Néº•¾§oí”‰5´Ê9åYO!•‡³EQEQEQEQEQE&+æ¯¿³k3?ˆ<#­Ãî{‹Aò‡n¦koá¹ÿ YIXïVY7où>Hî´›’Žˆ_«#!äÃ$ˆÃÙ‘€ ç¾Îýœþ?/‹íÆ…¯Ê««Â ŠF!~Ð¾Ã€ncÇïæ)YUyp¾ñEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEx‡ÇÙ¶ÏÆÞf±£m¶Ö1ó…Šr;Ë…&9¶ð³/À•X WâýsÃú‡‡¯$°Ô¡{{¨IWŽA‚9Ç¸tl|’!häR
1¾¥ý™h½‰|+âiÕeŒ*YÏ!åÇO³Jç1 C±Ì©òdL¿ÓY¢¸/‹ŸôÏˆúy¶»è6×*2Ñ·÷[§™ž$‰ŽåJ¸VøßÀÇ‚o›OÖ`0Ê3µ‡)"ƒ6é$L9ìÊYU[ƒê¿iK¯´=xµÆŒ¿*0¥€—ÎeNA„åãS˜‰Uòëì­\²Öí#Ô4Ù’âÖP$ŒäyíÐŒò§§† Õî´QEQE¯øÅûGéaa¶ÿ W^Jß$GÖæEÉ"FÆbÕñÿ >-øƒÇ—Ö.žH·ea_–ôÙ’§šC#ÿ µÉÏ¤9ëêOõ'Ì×]á„¾%ñiG±šhÏü´Û²?Æi¶Gÿ |–#Œ€5íþý‹®æ"o^­ºwŠÔo~œfyTF„¡b~˜ÝÑ«Ý<-ðÁþ+%ž“¯>mÇïŸ<Œ†—p^ƒ±TŒŽ+®“ÃZdª«%¤¨0 Ä„è ® öÏxÓá‡<ahlõ+8Ô€vK
ˆåŒð7G" xÀùX26 e#ŠøÓã/À[áä­t3u¤³|—*§“…Žä!’ lù2òo’¼°‡ô?Ô_P~Ï_´¤âh|3â©L±HV+{§?27ÝH®òñ¹Â¤Ç.ŽBË¹[zýbj*¾¡§Ûê=¥Üi4®Ž+Ô2¶AQ_#üný–¤Ð£—]ðžél£¤¶9i"îx˜|ÓBƒS™£PX4Š62ø_ñ³]øw8ryÖ-÷íd$ÄÜ’Z<dÁ&IÌŒ9À‘}«ð¿âö‹ñÌÜinc¹‰m¤ Hž…$<MÕ%L£t;\2Žã4QEQEQEQEQEQEQEQEQEQEQEQEQEÃ|[øO§üEÒÚÆè,Wˆ	·¹
FÝqÏ-ãl±ä^A‡Á^9ø}«ø&øéÚÔy(z£¨%|Ø_£ÆqžÎ€âES×Ô>~Ñ'Àq¶‰«ÄÓérHdýäLØV!eˆÑ‚®³&ýÁGØþñv—â›Õ4[„¹µpÈz¥$S‡ŽEÈÝ…uî+_4QEQEQEQEQEQEQEQEQEOVÒ-u{il5’{YÔ¤‘¸Ê°=A¨=A ‚Í|gñÛör»ð{Ë­x}ãD{©ùÞï	ËIõYùxÔ•›…óÏ€´œž xœ¼Ú` E7,ðdò¬	-%¨0 ™!ç`xðìM?Q¶Ô­ã¼²‘&·™C¤ˆÁ•”òYrPkŽø¡ðFøƒhÑ_Æ±Þ¨ýÍÒ(ó#=²xóc8ÃDä©Rvíl0ù¿Eñ—Š?gÝ_þýe>×¢ÊÆDQ÷]=”ŠÄíä%wrÛK‰›ê¯xçIñŠêZ,ë<'€?<l@&)“ïG"ç•n½T• ÖýQEQEQEQEQEW|oýŸ4ÿ A&£§ª[k€$è³m\žJáRpÇ…r§â-OL¿ðíûÚ]Æö×–Ï†FùYyŽC!ãb¤ûövý¡cñb'‡¼A ]]ÊÇh¨=ÚrÀ`L¿¼P:¯¾ƒš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šqÿ ~èž=´û.±2ª‘Â`K{Ç&ËžZ6Ýã¦¾0ø§û?ëßÙ®~×¦äbê%ù}q<_3[œŽ¬Z,ã.@¯[ýžiD§†¼_>Íƒm½Ü§  ºvôC;xŽS»k?ÔQÈR# ÐƒÐ¥:¹ßøIñ¦žÚf³–3¾6#X$ ˜ä_QÃ•Ã)"¾øÁðKUøuxà}£O˜Ÿ&åÚÇþyÈ¿òÆp0|²J¸É‰Ž
-†?õ¯‡×~~™.mÜæ[y2b“ %¶\ ÉûÁ˜H¿-}Åð»âîñÌÜéŒc¹‹kió#'p$‰¹Ù*|­È;XÅQEgëZý†‰]êwZÀ½^W
=z±8ÀÉë^!ãÏÚÿ BÒAáØ›R¸®öÌPŒq¸;,Ã9Ç–›X‰ *O„xÓöŸñ‰cke¸[+gÜ-Wa ôV‹Í…e-ÀÃ‘1Ó´›Ý^uµ²†Iç¹j]•#¹lc»öÏþÈ>$ÖvÏ­2ivç³âIO=¡ŒˆÓ+Ÿõ’’8Êw¯¢>þÎžð~&[·^ùot‘Ôþê,bëŒªo#ï;sŸNXÕ UQÀ€=€N¢Š*¾¡§Ûê0IgyÍo2”’7•”ðÊÊrH8 Šù/ãwì­6›æë~FšÌÏf9’0Y $îž>?ÕÌœ2”|ØèÐ6Ò0GþD`óìAÁ‚¯«¿g?Ú=fX¼/â¹€“„µ»õì¶÷.ØùøÄ31ýçú¹™µ¤ú[pÈ¥ Œ×†üfý™tÏ¤šž„©e«œ±QòÃ1',eUË˜ó‰Ðrx•\r>A–=wÀZ©Fó´ýJÑûŽ¤d0áâ|pFø&RÌ+êoŸµ:÷—¢øºHàÔÔŠçb~]²òC9<†a—$(†ÃôP9QEQEQEQEQEQEQEQEQEQEQEQEQEÏxãÀzOtöÒõ¨D±Q‡v–0LrQÃ«RAøÇãìÝ«ø~£i›í$|ä\4c’ÌK¡T`ÎŸ¹'ï,YÅq?~'ë~¾ºDÅsÄ‘>LRÂhÁð>äŠDˆ>ãmùOÚÿ 	~=h¿aX–ÓUçµv>¯nço{ $NŽ‹ÔúuQEQEQEQEQEQEQEQEQE6H–E(à2°ÁAà‚Ôµò¯Ç¯Ùm‘µï@Å-5œy%z·›j½JzÝyNŒÆ|ûàOÇ[ß‡WŸÙš–ùti_EÞ&èÓ@§\ËX~Q(ì³¿î-'VµÕíbÔ,%Yí§PñÈ‡*ÊzB*A¬_|>Ò|s¦¶“¬Å¾"w#©ÃÆã¤°¾ÇYIWVRE|ŸâøÃà¦ÚÞ‹/›¥»ó€Ìn¤üßÃÇ–ÙùVE!AoÜËo(ûÇÁßÚ+Kø€FrŸaÕÀ?¹fÊIŽ¦ÞB³†h]VE#ÌU-^ºQEQEQEQEQEu¯&øëð*Óâ¡»³µ
â)O ˆ.ÉÛ’|©yhX÷BÈßêZmÿ ‡/ÞÖé$µ½¶“§*èêr#•u8du8#k¡*A?_|ý¤ ñ$)¡ø¢d‡T\,S±
·U³…K¢qòŒ$ÙÝr h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¦MÌ†9 d`C2< ðAx#ŠùSã§ì¸,ã—_ðddÆ€¼¶K’Àr]í2Iu“jy 	éå>þÑ×
Ù¢ë¡îtv #/Ìðv-<É ¼ îŒ‚aÌUö~—ª[j–ÑßXÈ³[L¡ã‘U”òHêüGCÍZªz¾i¬ZËa¨D“ÛL¥7V‚þD`©äkâ_ŽŸ³¥÷‚d“VÒ³s¢³pÜ—‡=äc?….Á8c½¼£Ã~%¿ðÕôZ–™+AuW^£¹tdneIt#îÿ ‚l~#Ymm°jÐ(3ÁžéçÁžZ<~hXìáfôàsEA„]ÝÈ°Á—wrU@Ë3³`*€2I8óÅßÚä@_LðP†U¯d\Žã6°°*Ã¡YåO;bqóWÌ¾ ñf§âƒyªÜËu9þ9\±þ]ß*hÕGŒóPhúî·r–VIqq)Â$jY˜ôáFOÕŽ‰”s_H|9ýŽ.nÝøºãìÊp~ÍnCIØâYÈ1ÇÎAX•Î9ƒÂý!àß‡zƒ`û6…i¸?yÀÌï,Í™ý[°ÒQEQEðŽÿ ³l^4s­h]¾¬Ö£|±ÏŽŒYAòî ó6•`H2‘üaàkÁ—ŸbÖ­žÞS’»€*à}æŠEÝÊ23´’ÕsŠõ¯‚_´íç…z7ˆ‹Ýé#j¤™Ì°/O—Ó@£‰‰‘~é˜.¾ÉÒµ‹M^Ù/´é’âÚQ¹$ƒ)Ì¤¨êW(®GâÂÍÇ¶âßZ€4ˆŠd;e=|¹;I ”mÈßÄ¦¾6øËðTørÂú6û^”í´\*ãa<,w1å„e¸ >Lòâ6!NßÁ?Ú_QðŒ‘ió=Þ‘¿1-,Ö9i#\ó’Ê«ˆXF~ÈðßŠ4ßÙ¦¥£Ü%Õ¬ƒ‡Cž{«¼Ž¹ù‘ÂºžZ”QEQEQEQEQEQEQEQEQEQEQEQEQE6XÄŠQÀ*F<‚x Ž<ùWöý™V%mÁ–çË3ÙÄ2Wù¶±ŽJŸùiä©ùáCó2Íc"É4rÆÁ•”•ee9¬0Èè@!†\r+ìŸ€Ÿ´¤'Xt¸‹Wû‘ÏÀIð>PÝW,Êñ¬3¼µú(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Éþ-þÎú'ƒ^Ç‹Xäý¢5Hq€.£ãÍÆ +,ª8Tm>á?ø£à¨Ú½¹Ó¥"C±*A#uÕŒ¬ ,FCÆÁC°/—&$¯<3â?ÄÚ|:¶“(žÒuÊ°ü™YOÌ’!Êº0Œ#ŠÐ¸¶Žæ6†dWÆX=C)È ÷`×Éÿ ÿ f+ßÄ^
W’Ý	•íTþò-¿0{B0ò"òDa¼ø°<¢ãå]ï€?´³êsGá¿H¢åð¶×mò‰Ý\žLÄ.\(•³…—þ–ÝKEQEQEQEQEQEyoÆ€úoÄhEÎ~Ë«D¥cœ`í†åz¼AŽUE’Pà²·Ä^5ð&¯à»÷Óu˜W¦yG^x¤ $±œŽW”o•Õb¾ƒý›h©Zh¼+ây‹¬„%­Ì–V<%¼ÎÙ.Žx†F%‘ˆ‰ËFVš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(Àë^ñÓös²ñŒ2júio­¨Ü@ùRã$þæÀýÜÀŸ–\©Ü¿:|:ø£â/„Z´–+'ÙÒ@·V3qÓ« lù`VdýÜ ¦ÿ 1pëöŸ€þ%hž8´š-ÂÈŽ&ùeŒ÷Ya?2ô8laó#ÍuÉaI”Ç"†F2‘Aà‚ÁƒÞ¾Tý ?f8l “Ä>„¬qåî--´Y¦¶°EÏÏn¹Ÿ4 (~iÑõ»Ý
é/tù^Þæ#¹6*Àú†C£¯WÑÿ ÿ l›«e[OÛý©@íà,2ÀvÅ!ûÌZ&Œð1'å÷íáH¡g¶·½–Q÷Q£Dë#HB€9ÉÐ×Î_~=kßÈ¹"ßNS”µŒ’¹W;ZwdUD<¤`üÕæ€4‡Ôõ'ù’OêOã^Óð›öbÖ¼d±ê:†tý-þa$‹™$ÿ –6ÖvY¶¦9Tqƒ_\ü=øW øÛÈÑmÂÊÊ“¿Í4˜ÿ ž’žvç‘mOÝA]~(¢Š(¢Š(¢ŒV7Šü!¥øªÅôÍjÝnmŸ³u³ÆãƒÈteaë_|jý™ïü$ÕôR×š@9<,#®fT’ zN€ÏïT¬<Ã‹zï€.ÄÚ\ÇÈ-™mß&)Où[–-¯œ\p~×øGñ«Jø‘lÆÌ4Ð(i­ß’ ’¡ã²ÆH#pÃ)ÂÈªHÏ¢QUõ>ßP‚KKÈÖh&R’#€ÊÊF]NC)x5ò—ÆOÙ7û:Þ]cÁÞdÑF75“e¤
Ìm¤'tÛ@ÝäÉºFPDnX*7‹ü>ø›®|:Ô~Õ¦ÈUwbh>\ pRdùHu=$eŒðr2µögÁßzWÄdk`¿cÔãšÝ˜0uà-ß
dU'¥VDÈ,˜`O¨ÑEQEQEQEQEQEQEQEQEQEQEQEQEb¼Ÿâ×ìï¡øí^î[Xóöˆ×år ¹‰v‰xàH•xÃ6ŸŒ<}ðßZð÷Ø5˜LlÀ˜Ýrc‘F742áC…Ê–RHÉRê8cë¿¿j­—Hñdu¦“„²òÀ1Œó<ð}Ó™£•2(Ú¿_éZ­¶«mõŒ©=´Ê9åXAR?ý`ð@5nŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢°|càMÆ6Ÿ`×m’æ!’¥†	à¼R.'÷FÆGóWˆ<#âï€—RjÞ•¯|=+n•$ÂàËäHaÀÚ/aÚ LíÛè_¶'†n,Äº¤6×Šè£O5IïåJ
eqó~ñc qÉ¯Døqñ‹@ø„%]GÃËÃ2ì)8*åƒÆO•ŽÓ€ûIâ~4~Ív4i5m­ž®FXû©ˆyª?ÕÈHQç 9ÇïN1áZOÅŸ|#Ô¿±õ6h!ÎmnÉeeÎÛ\œÈ#ùHŽHÝá;ã }‰àYxÇI·ÖôÖÌ7§‘‡C R@’6Ê°ÆA·è¢Š(¢Š(¢Š(¢Š(¢Š(#5É|MøuaãÍ"]"ø ä‚le¢“ø%N‡¤L"Vë_Ÿ~6ðN¥à­N]#W‹Ëž#Û”t9Ù,OüQH”<:UÂÈ„WÖ?³Ÿí‰ ‡ÃZó„ÕcPÊÇp£XöºUŽ“€]>mÊ>€¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š('Éxƒâ×…|=tl5]NÞ•hÙòËé¼&í„õ°qÎ1]—¬YêÖé{§ÍÅ´ƒ+$LOÑ”}ù«tQEQEQEQEQEQEQEr~>ø] øêÜÁ­Û+È	:ü³Gß1Là2(Û£oâR8¯‹þ(ü"×¾ê+ynîl‹âÚö"Tç’#sW‚p¿ÃŸ.L< î<ûbêzj%§‰­ÅüKçFBM€:²ŸÜÎÙœÂÍ’NI¯£üñƒÃ~8\h÷Jnq–·—ä™zg17.@/tä|ÜŒö„ñ_Ÿ´G†ôïøÂúÓJeò,¦5Î#yÌ–’~ëŸ0€‹* my(RÝ+¥ð¯ÃmÅG-”÷C8-|€ó÷¦r¯CÖN ýcðWö`²ðÒ&«â„K½T0t‹;¢‡(z<àÍ#-	|¥Ûß@À¢Š(¢Š(¢Š(¢Šk aƒÈ5óŸÄßÙÓ[»“RðÅÄv-),ÖÒ!1n$axÈxPÌcÙ"8Œ"ð<E¼7âÿ ÚÕ¾¯<-¬BÈ§|©Ì…¤NÒ(ÁI9APñ«ý9ðãöœð×‹åŽÆà¶}& IÈòÝŽ Ž€v3@Eq±áTEzþêZ+Ç>3þÎzoŽÕõ;Ë²ÖO&M¿$Ç r«ÈaŒ,è¨Èa"üµñß‹<¯ü?ÔVÛSŠKK•mðÈ­€ÛHÛ-´è@b¤©•2¢çôŸÀßÚš-OÊÐü`â;Ÿ»ëÏð¥ÈV9A0ÄR¹Ã}&®dr-QEQEQEQEQEQEQEQEQEQEQEQEQ\ç<¦xßL“GÖ|/ó#¯¹4/ÎÉñVRR@ÈÌ§àŸŠ_	5‡ÚƒZ_¡{voÜ\¢‘£’¥O"9€Ì·'z0%7ÆU«¨øñÞãáýÙ±¿Ý6pÃÍAËFÝðïùkÇœ£#¿îÄíšj:TñÝZË÷dƒ)Çdte †S†R`5£EQEQEQEQEQEQEQEQEQM–5‘J8X`ƒÈ ðA‚àƒÅ|ÉñÇöWŒú×‚ãTäËb¸U<d½¡áQ²2mÛ¶âcdaµ¾]Óµ=GÃW«qi$¶·p1Ã)(êÀáèAmtq‚F×CŒWÓ¿kŸ=£Òüj ÜB­ê. ã­ÜKÂ‚p<èFÕ$#EË~ñg‚´?i¢ÓT‰.­¤H¤SÊä|“A2ò§•*J°8!"¾lÕt¿~Î·FïJ‘oü;u0Ü®0¥°>Y•pÖ×-”Žx‰ŠM«¾=ÁR¾Œøwñ3Gñåˆ¿Ò%Ë€<Ø[‰"b2RTö<\ÆýQˆ®´ÑEQEQEQEQEQ^cñ×àì?4­¶á#Õ­¾ky[ŒŽ¯o#|¹{1Ê,€}à~Ô,o4+×µ¹V‚êÞBŽ¤á•Ðà©*xeaÊ}
šúëöjøÿ ÿ 	'†|E6u%·™Ï3Ï”ç€nTñç Ï2+ô@9¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šð_Ú_ã§ü"ÇÃÚ$„j÷™$\~â3žA=.&é ˜Ót§ËÝñ\—’ÈæBÇsIÏRz’z±=ËORI®£ÀµßÜý£D¸h•Ž^#óDý?ÖÂHV8C©I@èã¥}Yðïö¸ÐuöKM}?²î›1›u¹=¿}ò¼;±Ÿß UÎ†½ÚÞâ;ˆÖXY^6¤G¨aG¸5%QEQEQEQEQEQEVv¿ YkÖRéšœK=¤êQãn„}z«)Ã+©Œ)_ürøIqðëY6Ã2i÷žÖRA,ƒÒLc÷Ð³“½JHÌØóË{¹mÝd‰Š²œ©‚ª²Ê}Ôƒ]D_üYÓW¿
  }¦N à’HÀãƒõ®ZææK™i˜¼ŽK31$’NY™›%™‰$±$’rMmxGÀú·‹oNÑ­Þâv8!×æ•ÏÉ
p~i
ôÂ†o–¾±ø[û$ézËï²êXìà!Cçæº*Ù ¸Hÿ é—>ÿ mi¬kº,q¨Âª ª`p RŠ(¢Š(¢Š(¢Š(¢Š+'Å>²ñ.q£êh$µ¹BŽQžŽ§ø]r¬ùÝñáî§àMNM3SB
³äÚBJ€ñ,Dä0`Tº†fÉVÆ>Ñû3|{»´¾‹Âþ!¸il®ËyfrLR#{åŒ2ŸÝ¨f")6!_húþŠÍgkÞÓõûW°Õ­ãº¶qóG"†QžU‡PÊC)äkãÿ ÿ ³-×…ë~]i™f’<n’×æþ)íÔdy˜2F 	Dƒ."ø%ûLÞø=aÐuå7ZJ0T|“,zú‰àªDq"!+²*F>ÈÑ5Ë=rÒ=GM™.-f]É"‚>½ˆèÊpÊAW¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‚3TµËZµ{Jîm¤häPÊ~ ÷ˆÁAòÆïÙ^M!$Öü¯5ªòö`’1Î^Éyâf"±ŽU¤_•|GÁÿ uïNgÑnå¶,rê§(ý9’‘Œd¨®õ$×Úþ<ÙüBµw¥-õ¨W÷‘P8ó­Ãq“ûÈ²^&þòcëtQEQEQEQEQEQEQEQEQE^ñßöqƒÆåõ½e¾®2!KŒ—qêî8
³`«Œ, €®¿k:5î‡w%…üOosmtu*ÊzÀò7X¬¤23kÕ¾
þÑÚ—tí@5îŒrÅ“’öÎØàä“nì#cþ­£'öF“¬h?´s5³E¨i—*UÕ†GL˜åÆä‘r2¬ÔàŽÆ¾xø“û4ê¾ºþßøu,ÛcòB'?èò–qä´R6þ0<Þt¿?hÖÖÙ´Mé…‚y1šs±¡—;c[ØÛ€žnJˆÖD`~†GW”‚¤dÐŽÄÁâ–Š(¢Š(¢Š(¢Š(¢Š( Œ×ÏµÀñâgñ^‰mJâ(×&hÇüµ `´ð/³4°‚ƒæTñå•äÖ	q˜å‰•Ñ”à†ROfV”ö ‘_j|ý£bñ¦Í]Û®È8K£-òð"¸À,cGš#ÁE÷j(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÃñÎ¾ÞÐïõ„]ígm,Á}J)`9ÈêjüÖÖõ[½^ò[Ûù{™œ´ŽÇ%˜ýæ=:ž  Pª  Øx+àwŠ¼gdu=ÌÉi–U‘cVeá„^a@Ê]G—¼2oÜ¬ÔŸ²çV! Ów1ê‚xw®\'äæ¹ïüño…`7š¶<ŽL‹¶DQÉÌ’[´‹àòû@ã$dTø§âN%Ñîž$a't-““º>YÏ?2la’Csö¯ÁŽšoÄˆ_²ê(imÉÈ+Àó­Ûƒ$[¾V	"l	FoN¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠðoÛ¬án±ö“x†¹á_Ïé—ÉÜvW%GÞÛ_U­?M¸Ô%[{HÞiœáR5,ÌzíD@Y˜ã… œdô¥~þÈ77—þ2³ÃÔZÄÙ‘º&™r°©"/!ÏúÔä¨|?á7Ã¶Ëc£ÛÅil¿Á…î[³ìÄ±=MjQEQEQEQEQEW1ñáî™ã­-ô]2§æŽEûñ?!e‰FÁ*êJ8*H¯ƒ>'|$Ö¾Þ›}N<Û;0†áyŽUåy%óÂøt9*] z÷ÙûöœDŽ?xÂS…Â[Þ9è:,WlNp§
—' ‚Ä½¾¦Že‘C¡¬r<‚à‚9piôR2î¯–þ>þÌ;„¾"ðte›%æ²AØòòYŽ‡æklåŒ$6#oøeñ^øetñÚö®ÿ ¿µ˜ŒÃåfþü€6³(ÉÂ‰£b£d|(øß¢|D‡e£}ŸQU-%¤Œ7€1™"#‰¢ÉÆõÃ)âDC^ˆh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÍxwÆÿ Ù¶ÃÆK&¯¢*Úë!rTabœŽz ÂNG8êp%¼5=/Sð® Ö·i-¥í¬œ©Ê:2œ««)ÈäŽXØ«7 ×Ñ?ÿ jÙâ–-Æ²y–íò¥ñ:à[ £D~ïÚ‡Cƒ(ef‘~®µ»Šî%žÝÖHœWR
z2°È ö Ô´QEQEQEQEQEQEQEQEQEÂüPø9¢üC¶òõò®Ð*æ0‰ÁÂ±ÿ –±då¡”ÿ 	Vù«ãO‰¿³ÿ ˆüï4Ð›­9rEÔ ”Ç'3'2[æ2f NÇ¶Ãÿ Šç€¯>×¤NÈ<È›æŠAØK;[„•q"ò>>SögÂ_ÚDñð[)ØµlÇ¼‡åsŒ–¶”àHüó`“suSøÁû7i^9gÕ4â¶»™Âæ9Hä}¦1Ÿ¨&ŸÞ	B´ˆ^7ø-¨&ñ\@§›KŒ´L¹’ÙÁ%FÛ%¹)ÿ =!ÈÅ}Kð“ã¦‹ñ3®mµ(—|–ÒNÜàÉŒ,Ñƒ€Ì 4d¨‘rçÒÍQEQEQEQEQE|cûJüŸ@¼›ÄºE´©É’eQþ¡Éùò:‹y—WlNÌµ
‘àvÓé×	snÍñ0ee;YYNU•‡*ÊFA¨È?pþÏÿ !ñäIÕH[…2qÂÎ£ïKôYT`ÍãŸ2<ÆHOi4QEQEQEQEQEQEQEQEQEQEyOí=­føùáîŒvëómûî»ýØyjÁ”Tœàd×Ç
>Ü|A×¢Ò-ßÊVÝ$²‘¦7¸\Í—DEè]”·Ê~…xoÃöžÓ­ô=6ZÚÆ±F=€ÆXžK1Ë3KO&´ð)­°*Ã ðGô#¡ÕóÇ¿Ù–×R†]Â0¯”™&µîËÝžÝ>ìsŒdÄ¡Rnp\ùkÃ%Ô|ªEªiîa»¶|©#þèèq¹e$C‚FAÚê6ýñðâå‡Ä}3í–ØŠö-Í¾rQFRp^	pZ'Ç 8ua]íQEQEQEQEQEQEP×õËm
Â}RùÄvöÑ´ŽÇÑFqÏváTu,@šüêø™ñ'Sñî¨úž¨þ«CîÄ™ÊÄƒ¶821ùžL³…§ð·àž¹ñ
r4øü«8Èó.eF¾ª¤|ÓKÁýÜw1£Ï?d|*ø¡ü<A=ª›H®×º”Ø?yaAòÁô\¹;µzH¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÍcx·ÂzŠôé´}V?6Úq‚;ƒÕdº¤ˆpÈãGq‘_ücø«ü;™®ÇúV”Í„¹UÀàGp™"'åþ¦L¥Xùukáí­x’Æë7ºP y1Ð›i>V>KfF•œ×Úø¤xâÀjz$ÂHóµÑ¸’6cš?¼Ügåe!‘™H'£¢Œ
òŒŸ³î“ñsnËW"áW‰;î•pdSü2­ˆò¤©do<Oàÿ |5Õ+ä’Îê2^QŽmçL#vÜ2ƒ¶Tƒïjé¤4H¦'ùRô€¥Oð­Ø\!Fû¢áUJ6<ÕÚÆEúž	ÒxÖX˜<n+)È òXdG Ž§ÑEQEQEQEQEQEQEQEQEQEQEQEQE®#â‡Â=âŸÙõ4Ùuo"á>üdŒ{	"'á|£c#k ÃáO‰?õo‡Ú‘ÓuHðZ“>\ª:¼NyÊäy‘·ï"$nÊç«ø/ûAj_‰²‘>Ù¥Èr`-´£óInäFañ‘åH~l£å›í‡ÿ 4¿é«ªèîJgl‘¾‘?S¨	±Ê°%Hdf5ÓÑEQEQEQEQEQEQEQEQES^5pU†A úw ÷óßÆOÙVÇ^ó5_
´¿9f·é‡>V8·•Î9ÿ PÇ—Eb^¾HÖ4MKÃW¯g–×p7ÌŽ
° à8öÈÊK#óšú‡ö{ý¥ŸQtðç‹æw!mîßq<,$awžSày‡ä“÷…ZO¡|Má=/Äö§ë6ÑÝ[·ðÈ3ö‘†7XA¯š<iû-k>¼÷€.]ÌdŽ"ûgŒó•‚còN»IM²lgO•ÚN†ÏÃ¯ÚÚæÊ_ì¯ÀU£%æ8Êº2ðËui×x`C@aÞŸ¦4}nËZ¶Kí6xîm¤Y#`ÊÏ<òèE]¢Š(¢Š(¢Š(¢Š(¢ŠŽx#ž6ŠU‚¬¬2<2²œ‚¤pA#ƒ_$|vý—dÓ<ÍwÁñ¼¶œ´¶ƒ,ñµl -$ }è¾i"ÆcÞŸ"üï¢ë7ºäZ†Ÿ+ÁuŽD<‚3†ÂÀ‚Á•²®¥‘E}ùðGâõ·Ä]!fb‰ª[…[¨W€	àM$Ÿ&\¼’Œ6;—ŸG¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šù£öÙ’eÓ´¤RÞIšrÀ}ÝÂ0#-ÛpV/9Á~8óßØÛþFù?ëÊýÞ¾Ù¢Š+çÚ_àzµ¼Þ,ðüD_Æ7ÜÁÿ ®ïOùn‹óH >z/O4)?.ø3Ç¯‚µÔ´yŒ3§^èëœ˜åN’DýÇ}øÊ¸Í}ýð³âfŸñIMNÄ…@[ˆsóE&2Tÿ yïE ù]9ûÁ€ì¨¢Š(¢Š(¢Š(¢Š(¢Š(¢šøßö¤øÎÚýëxOH|éö‰ÙHÄÓ) Œæf@$œ3+“…ðKörÔüi4:¦¬i¢?˜~W˜uÛn¤n
ßóðÀ"‚LAÛk¶´"×Gµ‹OÓâX-`P‘Æƒ
 t ~¤œ–$’I$ÕÊ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*»8o"k{”Ybq†G”FVÈaìAòoÇoÙvk	[ð\[2Mf™gŒŽKÛ)ËKrL ™"oõAÑ¶'ˆxÇZ·€5TÔtç1ÍÙ"6vº¿éÁ+Æ
œI€Éµ×î†4ˆªØÊ"Ôî’ÒC‰¦æ8Ä	À’<Œ¸)8¯@4QX>1ðF“ã&Óu¸x+Ÿ¼‚°È>h¤ œ2ž™ ‘_#üYý•µ?	Ã&¯¡Joì#Ë:íÄñïŒl’ïGQóyeA#à×íªü>•,n‹]èìÙhä ÆZ;±œà˜‰ò_[Çí	xËLñe„z®2Ío í÷÷ŽTûÑÈ¤ÊÃ9'nŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬øIñ•‹išä<î\ðÈØ IŒ4r($SÈ%[*H?ügøª|=ÞFMÞçå¸UÆÌœ,w*2"“N"”ž61Ù\…<k«øFì^è·2ZÎ8%vD`RDÉÎÉ€zm9¯²¾~ÑVÞ<Æ‘¬¶Ö@Êmá. s
±%&@I[åýälË¸'¶žh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(®kÆ¿t?[}“\µIÀ$ŸvDô1L¸t öièÊA"¾Jø­û,ë>ß¨è%µ-9y ßÆ;ù° ÄÈ8ÌÜ’Ð€7W¤þÌ¿¿µ"Âž#›7«òÚO!ÿ Z½­äs÷¦@1™m$Ê‡wÒ=kÍ~,ü	Ñ>!DÓL¿eÕíŽê03ÜªÎœ,ñ†9ÃbAÿ ,äC_)êzg>ë$r4)#’!/ÂŽ¡ã$+œž9ÜFd||çêÏ„?´ˆ¡?gÕQMlÇêíØàMG%~xò¢URF}*Š(¢Š(¢Š(¢Š(¢Š(¯œ¾?þÍ6º´ø‹Âñµ ZYí×îÍÆ]áO»ÇŠ.rN@”†?/øÇºŸµHõ]&M’§JH‡ïE*Œo»ŽM®¼þ€ü5ø‡aãÍ"-gO`|³E»-ƒïÄøôûÈÄ22®85Ö
(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Å¿km!/¼×,Œíis Œü¡‰‚F`:®ÉJœŒAàŒ×€þÉƒYøÞ0Ú ¸ˆûaVlS˜Bþ&¾ç¢Š(¯“?j€ÆÑßÅÞ·ÿ GlµìQ¸ÝMÒFú¦ÉûHOõm‰¶ì2²ø¯Â¯‰šÃí]5+&&#„žÊËrÈF@–‚@AIñFî§ô/Ã~!³ñŸ¯¦¿™ks‘¾8aÕ]OÊêyVEiQEQEQEQEQEQšð¿Úãí§…­.<=¢M¿]‘B1A¸@¯÷™˜>ÐS>T`–BË,€(¼‡öoø|_sÿ 	¿:D-û´n—÷yåí£?ëX|³Iû¼°Ysö|Q,j UQ€ À p € àÀ§ÑEQEQEQEQEQEQEšñß?³¾›ã¨d¿Ó;=o¨—•Iqü*€òAùgU2!Æíè
’üMðÿ Å_oaº¾†[IQÁ‚ádÞ>aåN™Mø˜ßc°J2æ¾žø;ûQi~'HôÏ²Xê˜
$o–˜ð6»C+±HB’víœwV óKEA¯ø¯û/è¾.ß}£Óu6%‰UýÌ„œ±–%ÆÇns4XbN]_¥|´ïâÏƒºÙ‡t–7‘íb·$¨3å±Çî®`l7£nOÝ8"¾¤ø?ûNi>/H´ím’ÃV /'ÊßtyÇ÷nç‚C»'´ƒšöìÑEQEQEQEQEQEQEQEQEQEQEQEQE[PÓíõy,ï#Y­æR’#€U”Œ2²œ†Vø›ã‡ìÝàÉ%Õ´ek–Ü9xqåÎ2YâP@K…Î0\	Åm.§²™fÚ)c`ÊÊJ²²œ«£.]O*À‚¶kêoƒ¿µªíM+ÆÄñ…KÕ\ñù|Eäœ€<ø—9•ÓÖ…¾¡]ÙÈ“[Ê¡’D`ÊÀôduÊ°=ˆ5bŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‚+Â~3~Í¶~"Y5¿¨³Ö.cL$s¶w’Û@ò®Xò³©ŸhÎx„¿µMÖ›*è~;Þè„ »Û‰ƒ·mÜcÕ*Ò¢ùªW2#äÉ_PéZµ¦¯n—º|ÑÜ[H2’FÁ”fRAúuÀ5[ÄþÓ|Oa.•¬@—³20ü™|ÑÈ½RD!Ð€Tƒ_ü`ø©ü3¹%ðä²I§G.ô‘r%¶l‚žk¯U'å[ È	:üÛ›®ðWí•pD> °ÌYî!}™„ó î`’lc÷BŽ+ê€sÍ-QEQEQEQEøÓö®ø?ý…¨ÂS¥E·O¼?¿¸X§=XíÀHîx ‘<0$EyŸÁïŠWõ¥Ô¡Kw]Ä9À‘=1÷|ØÏÍ‘ò¶PŽØýð×ˆì¼I§A«é’	mnP:7±ê¬:«©ÊºžU‘ZtQEQEQEQEQEQEQEQEQEÉüXðùñ…u=- i&µ“`l½G™;A<HŠx8Æ|ð¿Ä#Ãþ(ÓµB@Ž+¨™‰ÉÂ1É÷y%c‘‰9eÆ~‘ƒšZ(¢›",ŠQÀ*A„#¸#‚=+àŸÚ'á+x[i,&ð™-Î8Nò[ëÇžL$Ï6®‡öZøÃ7‡5TðÞ£&t»÷Âîÿ –S¶96Ç19TîaŽEÚL›¾×4QEQEQEQEQE!lrkäoÚ#ö‡ÔTmÂW¦+(lÓ[’óæ*Ï‚DP€1•æL»*ŒRýžgù<U2ø›Å·ö`!á‰Áÿ Ibs½÷|ÆØ'þ>XãqŒ3ì+khí£X`UHÐUP  pT`    ©h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢©êÚE¦¯m%Ž¡\[J¥^9 e ðAÛ¡Ž ƒ_|wøyà-FK­>9%ÐäÃE1‚ÖÞvÚÈÀl’PT+–2+S>~Ñz÷dŠÂáÍæ’„)·”ò‹ÿ N²·ÍcrÐ‘¶<îixÇú_ŽtÄÕôi7ÄÇk£pñ¸å¡™;$\ƒÔ«)ŒÈÊÇ¤¢ƒ\‡Äo…º7ì…–³/ãÈq$e†	F ‚­ÆøÜ4o¹I Œ>0|ÕþÊ×_ñõ¤±nUpâ@Žá2Æ'ÈoõNJìe|%wß¿jËcÑü_¾æÍ DºtÑ€0e „æLùëÎD½GÖz>³g¬ZÇ§L—ÓÉ$lXtàCGPAWh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢™4+2”F# ƒÁ‚àƒÁ+å/Œÿ ²|ë$ºÇ‚×Ì‰Žæ±à2dßefÂÈƒ%¼‡edQ¶&a¶:ù’òÂâÂV‚å)£8epU”ŽªÊÁYXz0¾1]çÃŽ:ÿ ÃùBXKæØ’ÚË“Ëæ‚B|ñpXƒ$rWÙ
¾8è_"ò¬˜Ûê*»¤µ—ï€8g‰‡Ë<@Ÿ¾Ÿ0yˆ„â½Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‚3^Uñ3öqðïŽ%“P!ìu)9iàÆ€Â´Ð¶côË’}þõó$÷Þ.ø¯½œr%ñ ^M½Ì|ªÈcá•‡Ýb
Í€È…wý!ðÇöšðïŒŠY]ŸìÝEøÌÃËsÇÜ|ªI'9DRžÈk×%‰'B’ ÈÃHÈ ðA ‚;ƒ_4|eý”`$Õ¼ž\à–{,œ–6¬ØòÛ'‹va	˜È á|#ý§/<2Ãž5ŽW‚F.>t aU.b`¯" /Äê£•”|Õõ~©[êVñÞYH³[Ì¡ã‘ee<«+‚èEY¢Š(¢Š(¢Š(¢Š(¢ªêZe¾§o%•ìk5¼ÈRHÜeYO¬þ#šøãçÂGø{­­Ám2ë2Z¹9ÂçæØòd€2I/#çvüvÿ ²_Å7ÑµoøEïœý‹PoÝg¢O”ƒŒâá£ãÌDn®Äýšh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š)f¿:¾4x;þ_i`b)’.8ò¥ýì{sœìÞÑçœXû{à¯‹×Åž°Ôó™¼¡ÃÄ±~êAƒ’2Wzò~VSÞ»Š(¢Šä~)|;³ñö‰6v»|ðKŒ˜å\ùr.{rRAüQ»¯züïñƒyá½Fm3PO*æÚC‹èF3´÷V<n>ò2°9<}›û4ük“ÆÖO¢êÌ©e°|ŒÍÂy¬£þZÄÅRR ¹$ÂïÅ{QEQEQEQEW˜þÐ?ì¼áË˜%“þ&„2Ak9fQ·æXà½Ÿ»j¹ÔW„~Íÿ ³ññ‘x«Ä	ÿ ¸Û6ð°ÏeùC¸9Õx^³8ÿ žKûÏ°ãQB¨  08 À°ê(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠŠæÚ;˜Ú	‘dÁVV ©‚¬§ ©A¾vø¡û!Yjî×Þ’;›“m.|’I$˜Ý7I çXY"Â©Ö¼GE¿ñgÀŸ+ÝBÑâH]³ÌJHùd\«må¡G™nÇ ™íO‡¿´ŸiË©èÒn^‘7DØÉŽTçv`J8ù‘˜s]ET7¶P^Âö×Q¬°È
º8¬Uel†ÐŒWÉe¹ô³&¹ái¬¾g–ÔrñóñM_3F„óåað§ãN³ðæè½«}¢ÊOõ¶²1¿ûh~o&SÚeS»¤ªã•ûƒáßÄÝÇ¶"ûG” y°·DHÎÉPóÆp$]Ñ¿Tb+¬¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š1^gñà^ñ4Š-õTB±\¨üV;…ó¢Ü8Ïï#Ë4L¤~ñÇÃý_Áw§OÖ­Ú	y(s¹]Gü´†Uù$LN0éœHˆk+D×/4K¸µ>W‚æˆpU‡qØäpÊAWRQÁRE}Õð3ãÕÄ+QgzÉo­Ä£Ì‹8ùïl’§¼‹—…¸9B®Þµš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+ÂlÃ¨xV=Lág±¹iÆIYq$`çå²Hx<Æ Æs_«•éþ~ ðkØþþÒÚï‚ŠY^1¿Ò×É•¾dÍ¼ì—â)Å€LCšû'ÀŸ´ØOE˜Ivº7FÃªMrŒ:ŽªÃŒÊAª_þxÇõkqöŒa.bÂÌž…%ÁÜ÷$îµà—Zo~«¾˜éªxh9|2’±ƒËy‘©ó-‰bÏ	’ÝŽ„d‘^™ðûö ðÏŠ`Ô$þÊ¾8.ylN?ÔÝ`FÀ–àH"òv`^Á‹"‡BHÈ#GbàƒØŠuQEQEQEQEyßÇ?…ƒâ&‚l )üæÛ;ç°U¢r9	2…€;d›X ðÍ­÷†õ‚`ö×–’àâŽHÛ=FA(êJ¶†¿A~|R²ø…£¥ô«{ªÝCžRLrqÞ)p^'V\ïV»¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯“¿m,wZv¹ó4r[¹ õŒ‰¢Ëgnv¼¡W ãqÉ¬ÿ ØßÇâÃTŸÂ÷ˆ¯—Í„‚XÆúë úÃŽâ¾Á#4QEWÏ_µŸÂxõ­0ø¶ÅOÛlT	Àþ8~rí‹ÈäÄ]I8\|µðßÆ÷~×-µ«NZù“<:7Ë4G ýâ}ÒrÂ?jýð×ˆìüI§A«éæZÜ ‘ØõVÂèr®§•`AäVQEQEQEQEs¾>ñ½‚ôyõ½HŸ*ò ûÒ9â8cÿ nFàŠ2í…RGÍ?|ñßYŸÅÞ-fM2&$I•Ìm!|†Žt«ûÉdv‘³·ë++(l¡KkdXá‰B" Âª…UQ€€ASQEQEQEQEQEQEQEQEQE…âïi>/²m7[·[ˆ#<2ïÅ"áâqýä ‘ÁÈ$WÈ¿<­|ÖaÖ|7w/Ø.#sÉÊüíiv€,s)\ºd(uWË‘7ºüý£ô¤z~ VÇY<˜þîR2K[HÝIQ¸Ã&Ù’«æ¼û9¢ŠB3_:|wý˜ ×]wÂqˆõ&I­ÂJO,ðòÅ9<²eb˜“’|Çå=\Õü¨«	e²¾™22®¤<R#€ñ$2)R~òô5õçÁ¯ÚŽÃÅ&='Ä›,µ7eHäLÇ ç?f”‘´$ŒRF Få˜ ÷ÀsEQEQEQEQEQEQEQEQEQEQEQEQEV‹¼¥x¾Å´Íj¸³Œ™	!½‹“µÔƒØä+â³Æ©à)ZöÐ=æŽOË8rq·HŸêÈÁ`¢ã&6;O”Z^Ma*Ïní±°ed%YX««.HÈe!¯­>þÓÃW’/ø¹Õ.‚ñŽÐEsÑVVà$Ã	+|®ÈÝô°lÒÑEQEQEQEQEQEQEQEQEó—í‰ãø,ô˜<-+]]H“Ê½JD„´g¨ÚÒÎ /\¤rpøäœµÐh ×|A›I±¹»z´13ÛÔmÏ€ÄŒpjî…®ø‡áÆª.mLÖ7ÑpÈêT•Ï1Í€y‘1*HÌn­Í}}ðoö”Ò¼l#Ó5]–:ËÉò¥#©·vûßÈ•¼Áœ#HêöGEp
° ƒÐŽ„z‚:ƒÁóÅÿ Ù6@¾©à½–ó–²c¶6î~Îç"'Ÿ)ó	?tÇ^Wð×ãWˆ¾Þ¶‹¬Ã,Ö1°Ym&Ê¼\òÖÛøŒ•%„yû<ÙÊ²ýêûÀ¿´oÙhhs‰:•ãn¥%ŒòŒ3×•nªÌ9®’Š(¢Š(¢Š(¢Š( Œ×È¶ÃF²¿‹Å¶iû‹ÌEqÒeŽCØ	¢	ÿ ž‘(êüùGÁO‰²ø_‡R%›þêåñDÜ±ÝâlK|‡Q÷ÎB´íJßR·ŽöÊEšÞeˆr¬¬7+)AÈ«4QEQEQEQEQEQEQEQEQEy·Çï‡-ã¿Mgoÿ ¶§í6ãŸ™ÑX4Dó£gŒ¬ÊØ8Áø;ÃíÇ†õ[mRÐ‘5¬É*‘’§;€ëº'ƒ0<Wé7…üEkâ=2ÛX°mÖ÷q,©ìd©ôd9FC)‘Z”QEð$ñ´R¨tpU”ò<2x ‚A‚+ó×ãŸÃ'ðˆ%°ˆc/ï­˜äæ&$ËåàlÄÜ“´FÇëÕ?cŸˆ¿c¾ŸÂ—’b+°f·xó”bT\ž³Bƒ–‰ÏSÏ×Y¢Š(¢Š(¢Š(¢Š*¾¡Ÿ——r,PB…ÝØà*¨ÜÌÄô
&¾5ñßŒ¯þ<ø®×@ÑE¦Díåd:úáFT€ˆC“rÄNùœ¯¼/á«iÐhú\b+KdØŠ?6f'–wb]Ø’Y˜’I5©EQEQEQEQEQEQEQEQEQEbø»Âo‹lIÖaÚÈAÆH!‡*èêC#©èÊAÁ ðH¯Œþ:~Ï·_d]KIin´‰IË²å¡#RáÓ
U²LsíŒ
¾kçàOíGöeMÆÓ“…Xod¯ETºeºFÛ’2¼ùä‚$¯ª¢•ePèC+ A ƒÈ Ž#AÁ§ÑA¯!øÓû<é¾?ïì¶Úk\bl’àm	r«ÉùpebaGÌ€¡ø›ÅžÔ¼%¨I¥jÐ´1uVOÊèßvH›$‹•=ðÙQêß
¿j}oÂk«í5 UW8–00 ŠcÃªŒâ9òz*Ž+ë¯üGÑ¼sd/ôIÄŠ?ÖFÜIèRhÌ‡#ƒÊ0ù‘™H5ÓÑEQEQEQEQEQEQEQEQEQEQEQEQE2hRdhåPèà«+‚X àƒÁkãÿ Ÿ³4Ú+ËâGæi¿~[uÉx¼bP	–ØuÀýäÆ5>rù‘¸ÿ ¯¨#óôÿ ìËñþu¹‡Â"›|Ÿ.ÒyæGþY¹xåû¶ìÇz>!Ë+&ß¬AÍQEQEQEQEQEQEQEQEf¼sã_í¦ø)tí0¥æ·‚¢0r“Œ5Ñ9Ü _Þ>>cÕñ¹­^k×²ê:Œ­=Ôì^I\òOLžÊª0¨Š"…D Ÿ¢~þËj"-{ÆRÑ—|V|«ÉŸº÷$`Å^D÷’nB€Ûë,a[[HÖ#QBªÐ*®Ø\ïþèÞ:³6:Ôñþ®UùeŒÿ z)pJôåNäaÃ)ñ¿ÄÙ³ÄÞ¸•ìmßPÓA%fw¼‘çÀ¿¼Ô›bºnåt??jm_Â›4¿«êHvïcþ‘3OõûIÇ•1YTaCœm¯«üãýÆ6ÂïDºŽá‰Äˆzí–&Ä‘°ôeÁÆA#šÉø‘ð‡AøƒÍV-·(Šæ<	S®î’F	'Ê”<dó€y¯”|gð‡Æ¯F·¤M$–±ä-å¶FÕá™.¢;ÄHHä8–Ùˆ”<W |.ý¯˜ºéþ5AƒÀ¼…qŽ³À¹Êä¬ƒ8´`e«é­'W´Õ­’úÂdžÚP$ƒ)C:uGp*åQEQEQEW7ñÁðxÇC¼Ð®GËsºãç†Až…$UoÌ+óoS²›O¹’ÖáLsDìŽ§ª²’Ž¿ðVéë_EþËMž/jç6—bÖRÕHÜ‹r˜S˜æm›JH
}{EQEQEQEQEQEQEQEQTõ]bÓI¶’ûP•-í¢žI*¨õflì:“Àæ²¼#ñCñ‚K&v—kM™K®C…<€p@ÆAÈ"º|+ûOü1—Âž!“R¶LiÚ“4Ñ8Y87’LÈ0 ¤õlk§ý—>8Ç ÈžÖN,®%ÿ F—´R9ÁÇüñžCãýTÌC¹>Ã4QEW™|øb¾;ðô‘@ êV™šØã’@ýä¸2ƒœ,›®+à­+S¹Ðïâ½µcÅ¼‹"7B¬§r’;a†yãrw5ú1ðÃÇPxçA¶×-ÀF”–1ü¯Ë4|ó€à”'ï!Vï]UQEQEQEÉ¤XÐ»ª ’O@$“è&¾øÓñóUñÅÔúl2ùZÊ|¸cóîå˜‘Ÿh•#ùbL¨*än¯§?fß‡Ö~ðµ­üh¦ûS‰.g—©!Æøa×dHGË’<Âîr[5ëŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¦M
L†9 da‚È#¸ äGñOþÊñ ’çGÝ¥Þ7#Ëù¡'ÞÜ#¿Ñã“ƒ“ŸÒ~!xãàeòèz²y¶ ’¶òÑº‚öWçN	 XÉX#ïõ‡ÃÏ‰ZGtñ¨èòŒ	b|	#n»e@O®UÔ´n9F5ÕQErþh¾?´ºÔY’0ÞLéòËa‚c~r§‚Ñ8hœ…Ü‡ Š¾.üÖ~LÓH¦ãKfÄwH>^N'\~âSÀÁ&7'÷oŸpÞñF£áËÄÔ4™äµº‹îÉÁÆAÚÃî¼dº)Fã†^õ÷¯Àï‹üEÑ¾Ó.Èõ;bê$' œùs nDS¨,€–ØÁâ,Å2}"Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(#5ó×ÇÙ–ÛÄ1É­xR%‡TÜ^X
““Ë:n"8®3Éû±Í“¼«áÇÈÚ}î‡tÐ\£ÛÝ@À20*èÃ7£)ã³#†¯¦~þÖl<½'Æ™eÈT½QÈ }­ÞµÄc#¬‘Ž^¾¨‚tX˜<n+)È òXd äpE>Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š)±_*þÐ_´ÄŠòøsÂm@sÞFyc÷Z;GqW•{•ËÈ€¾e|íá
jÞ3ÔWNÒ¡{›©IlÃ#|²;$aˆ+Ÿ¼@ùÜàýðwödÒüÑêšÃ-öª£+Çîbny…™$ ãÎ—$`Ò:öê( ŠñÏŽŸ³þŸã{9u.$ƒ\@]]@Q>ú™ú)fÌ~hÛ%)øâûCñîÖkˆn´û˜ØvV² `#”a[‚ÔwºœWÑ¿kh%DÓ<m˜äPª·ª¹ÔµDƒ1°ùs4Jcl’ë9úGNÕ,µ«e»°–;›YGVÝIR<ƒëÍyÄŸÙcÃÞ(ßy¤ÿ Ä®ýÎâc\ÂÍÔ—·ÈOw£<’Ct¯œ¥“Ç5_³ïk4ï 2ÚàeVÚ²6†â+”»¸Á?I|ý¥t¯²iš’­†®G
Ì<©B-äbIÑŒ ø?»2…b=œÑEQEQEQE|eû^|7þÈÖÄ¶k‹]K‰qÑgAóÏ|J$à}ø¤'ïqàšUô¶Q][’³DêèÃ³)ëÃªž9ÇNkô¯À¾&Å%–·ÝÀ’;1¼N3Ê8e#'Ú·h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šù'âîµ¨ü`ñœ~Ð¤ÂÉÙYðJo^.®äÚpË|ˆ°<ÀËôÃß‡š_tÄÒ´” pe•¹y_2ÊÝØô aQpˆ€+§¢¹?Š>·ñ¯‡î´k…Ëº„ô+*Ð¸=°ü £2A"¿8Ñå±¹ŽXÎpF
²œ€U³’(0=nõúKðûÆVž0Ñmµ›'³F»ÆFäæÅ _»">A:ùH5ÑÑEQ_~ÕŸáñ	ÕìãÛa©î”m,Ãi¿+p¼äï—ÆÇìñ!tV_^6Ø5,4$ô ÆÞ˜xWh$Œ¼J¼–Q_dŠ(¢Š(¢Š(¢Š+çoÚßâ£èšzxRÁñq~…®H<¬Ø"ÇPn[p$`ˆ£|}êøÛwÍ¸óþzqÓŽ8éÚ¾´ø7ûRèºnƒo£øŒKÅŒk
I{ÖHÔmŒ•çŽD@Ã.ÖÆåv$…ô+OÚŸÀ³È#{Ébø¤‚@¾¼°SŽœqÏJô¯xOñ¢ê:EÄwV²gl‘¶FGU8åYz26O
Ò¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Æ>Ò<agýŸ®[%Ì<•-Ã!<o†A‡‰ÿ ÚFŽGò‡þxƒà®ª¾+ð´¯&›q/VŒ7X/cUàr6ù¼#¥¼©°çè„ß4ˆ¨"‘mõP¿½´vùÁyáÎÐœå]A ²`Ez.h¢ªjš]¶©m%ôK5´ÊRHÜeYOXýGQƒ_"üiý•.ô_3Wð’µÕ‚‚ÏnIi¢ d˜É9¹ƒÀýú %ðOŽµê¨èó´c*ëœ´RÆÜ<dƒpÈÙ(Èàšû‡ágÇ½Ç6¨xìõ0¿½¶‘‚œô->Ñ4Dò¥~u,Š­^›‘EQEQEQEQEQEQEQEQEQEQEQEQEb¸‰_4/ˆþV«Û•Žæ0©í¸‚$CÞ9!À¾ø›ð“Zø{|mõ(É·g"„»”0(rJHás½X…Ó]Â?Ú[ð‰hînôÃu´‡îŽ„ÚÈN`n2#9€œåPãíïxÛIñ…ŠêZ-ÂÏ	À`ÜŒ@cÉ÷¢•A‘€=ÆAîfŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢«ê…¾Ÿ——r,0B¥ä‘È
ªYŽ¨ ’M|}ñÃö£›Äi&‹ábÖúk©Yfa¶Y†z'! ”t M*±#^Æüðÿ XñÅúéú<iI˜ð‘©8ó&“¤q( .áJDŒÜ¼¾ü%Ó~é¢ÊÈy·ràÜÜ°ÃJÃ Ÿ.òD0‚BK‘Û»QEUcE²ÖmžÇR‚;›i92Ÿª¶FGb9|ëñWöE²–Ú]GÁeâ»A¸Y»nGÆK$¿Ï„‘dw‰˜>X;—ç-7\ñ7€/ØäºÓnÔå†Œ“Èd*nøœeIÀjúSá—í}c¨„°ñ|bÒs…ûTc1ÀÌÑs%¿?y—Ìˆu,‹^ë©éZ7Œ´ß"î8u:áCáÑ‡UxÜguWBO ×‚øÃö5´¸˜Üøbý­Fsä\)‘GL¸B³(^HÞ%lãæÍpþøËã„ÚÙÐ|Xeº³‰öË­æ8C“ÙÜ>•Ü‚FhäU1®êo	|Mðï‹_E¿‚á˜å‡Aœà<¶To”ü¥sÁ=9®£"Š(¢Š(¢Š(¢¼ëöƒÐ ÕüªG8æÞsCÃûÕ#Ó;J1ëµš¿=$ýÜ‡Âxü+ï?Ù_TkßÚÄÎÛK4#ÈPå6;í|äŒEzíQEQEQEQEQEQEQEWžürøŽžðô×‘°÷ Ãh½I‘†<ÌvÂ¹•°^¬ó_Ø÷ÁYØÝø¦ñH{â"ŸïÐ––Pz‘4Ç“œ?”Üý(¢‚3_þÕ?á½oéƒ6Òþö0î¦`Xœ€G“pÁ˜FÉ˜§Io+û<üe êßg½,ÚMáTsÂ.Ôñ/Ë*©áç£Q_y[\GqÍÀee9U•†AARQEWœ|~ðxÓÂ·6vÉ¾öß6ã ’ñä˜×$`Íxº–äWçõäºuÊ\Û±ŽX]uVRuÃ#…nü‚9¯ÑÏ…¾:‹Æþ´ÖãÂÉ*m™ðJŸ$ÉÛà²èT÷®²Š(¢Š(¢Š(¨oo#³…îg;b‰YÝeQ¹‰ú M~nüNñ¬Þ5×îõ¹²Ä™OðÆ¿%¼xÉ ˆ‚–Æ2ìç©Éç!°šn#RÄu
	#Ó!A#¾3Œö©ÿ °/¿ç„¿÷íÿ øš‚[9íÈÞ	é¸Ï®7ÏQÀÉæ»/†_5¯‡·¿hÓŸ09u¼™1È028rdù×€ÁÓä¯³þ|{Ð> ¶¶ck©mÉ¶”Œœd±ÇÉ:¨¸uº-zP9¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*+›hîchgPñ¸*ÊÃ ƒÁVSAF|ñÏöt»ðÝÉñ/‚£ÙæIDù–Ì>c-¹Sæ!	’÷CBpÁ?ÚŠÓUHt?¸ƒPáí¸ŽSÀA1C3ã8‚BF`•ôTr	 e ©r<‚êcßµ:ŠxOÇÙžÓÆ,úÎ€R×VcºDn"ŸŒØÉœà~õAWäJ§;×ã=cI¼Ñ.¥ÓõšˆX£Æã•aÔ2œ€qÈ#!”†F*CmøûLÜøMSEñû­+vL–– z„&hs‚bÏ™,b,¸Œ}‹ ø‚Ç_´QÒ§K›YFVHÛ û}Ö[§† Ö…QEQEQEQEQEQEQEQEQEQEQEQEUgD²Ö­d°ÔáK‹YF92žã*{‚rE|‡ñ¯öZ»Ð7êÞY.ôñó<<¼Ñr~èPZâ1Ï3F¿|HáãþøªøQSÒe1¸#r’Lr(ãË™HðHþüdîŒ«½¾|RÓ>!iƒPÓÎÉÓâÝˆ/pq÷£| m‘}2ŽÒŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+–øƒñ+Fð‹jÔÛr—ó$­‚BErq‚ìV4Î]Ôs_|`øï«üF˜Ûôm)1Û!ãŒaî M # "?('ç7¾þÍÚçŽZ;û lt–Ã}¢QóH§ŸôhN™ãÉ¶6åóq´ýŸà_‡úGì™¡Â"‹;‰ËÈÝ“H~gcÛ¢¨ùQU@ÑÑEQEšÏÖü?a®[=–©w6ò2H¡íßpNGc_3üJý3ßx.PG$ZNØ#Ñ`¹9Èì«q“ùl:(ð¿¼eð~üØ²Éç/gr§Ëa“—Hò’r|ûfÁêþf1_Dü=ý¬ü=â¶Úè:UÓq½Ûtyé8¢àg÷èŠ3€ä×£xËáÏ‡> ÛGý±oÒ˜gFÃ¨<æ)â!¶“ƒ´%M|ýñöB»ÓÑõÝ5Éç[y°%~aö{„Ú¬üªâ6b?Öî5ÅxOö‘ñŸ‚®>Ãª³^ÃÙ%½à"EÀÆÏ<>'óD£9'vK¬~ü]Ñ> ZùúT»ným´„	SÜ '|mü¡doPÀ¨íAÍQEQEWˆ~Ö=‹BðÃh±¾/5Cå€"%!®à•€X@<1Œ1.ÙîM}Óû$éÃÁk>»™¥ù»€D*ËŸá+ ô'$W´ÑEQEQEQEQEQEQEQHÇ$àWÄž0¹¾øÝñû2ÍÏØc‘ ˆçåKxúEÈ2ï†pHÙ­Ð‹šûCGÒ­ô‹Htû$Û[Æ±Fƒ²¨
£òúžM\¢Š+Æ~³ñf“s¡ê+ºÞé
ÆTýä‘2…t88eùÅãÝøWV¹Ñï†Û›IJ10Ë"ÿ ±*2ÈV Ž+éÿ ÙâË_ÀÞÔŸ2@¦K6cÉŒ­¶ëä’$ˆe›Êf^!_LæŠ(¢ƒÒ¾	ý¦üÿ ·Šç’Ý6ÙßµDA¸âá<mŸs€Ê 2}ö-ñ™Šê÷Ã36dQÛÓN=Z3ààf' ¯¬¨¢Š(¢Š(¢Šù×ö¸ø¦ú=ŠxKOlO~›îXu“µbç7,1ín %¸óÙïöu3Sâ‡](EÊµÁêçÌá–Ù~áhÈiX°WU\·×Ú†4ÍÜYé6°ÚÀ£"@£¹çhË’IbI$’rMií•KTÐì5h¾£oÌL+*+Œ†pFp}ExßdßëêÓh¹Ò®ŽHÐ’yù­Øüž™…ãÀãi 
ùãÆß<_ðô¶¨¨Ò[@K‹«7c°/"V
{r«óoÚÈœ†¨$ûgÁ¯Ú¦ÂþÖ=+Ærýšþ< »#÷RŒ|¯1^-å#ï3%Î]Ys°}kwÔK<²Dã*èC)¡V\‚bKEQEQEQEQEQEQEQEQEQEb¾aøûû2½Ü’øÁÑ1²óÙ¯ž­%ª´—ä½±ÀfËDC1Fä>þÑ·^Ç†üN’K§FÞZ6	–Ø•£òØo’$lf¶X>`—¯Ø:>³g¬ÚÇ¨iÓ%Å´Ê$CAç¨è}Tà©È Š¹E¯7ø¹ð?Gø‹nÏ:‹mMWÝ¢‚Ügls<èA9ÚHdë©Í|9ãï‡:Ç¯Ž­CåHFäe;‘×;|Èdãzg¨!]2Š¤Œéü/øÅ­ü=ºó´É7[HÀÍo&Lr	,Ì’÷f•Ã¯Ë_oü*ø½¤|F²k8˜®bâkióÑ†ÒD‘>ÉWƒ‚+†QÜæŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(Åx·ÆÙ»Kñ¤Rê:B%ž³Œ†Q¶9ˆè·
£år2«: êNd(Û_!éÖ¿ðÛZ/nÒØê²D<{˜¦îKýí§(à‰"aõöÁïÚHøƒÚK‹-\pmÙ¸|™-\ãÌ^¹ŒâXðw)\9õlƒEQEQEQEQEQETw1[FÓÎëh2ÌÄ rÌØ ä+À~)~Öz^ˆ­cá@ºéÈ3œù	ÇU#tÀàmŒ¬]Ì¹OÍé¾+ø«¬4Ê³ê7Ò¯&>T®üCoä™P¹áÏ?N|#ý•4ß2j~%)¨jC¤@~â20AÃ ×2+g °‚7{D
¨Àü€¦=:Š(¢Š(¢Š(Åbø«ÁÚOŠíŸ­[GuvqÊçø£q‡‡fFz×Ìß?cë›Ekÿ J×
2ZÖf@98‚•$Ç
m¬@ÿ ZÄâ¼·Á¿¼Wð›Pk/ÞDˆß¾²¹VFI'Êl™‰8š”ðq*à±¾|jð÷ŽíÕì§Xnøm3gä2uÛ$yƒ/xûá_‡¼u	Y¶W—K„ùfOB“˜ŽŸ#nŒÿ ‘_ü_ø9ªü)¾Šî	Ì¶R9û5Êf7V7”þY)•rA‚J ²…`PtŸ
jí_Ãx±ñ™©Øp3>0 I_u'YØ8ê²Ÿ»_Mx+ã‡…<_òi×È—þêLñÑ$ÀqÈæ2ã'ÏÞdŠ\ÑEQš2+ø—ñCIðƒ_jr1SäÛ©d­ÙQO*€ÿ ¬•†È×$’pÀ_<{}ã^mkRaæË€ª¿ur#Š0y€““ó;vù›J°ŸPºŠÖÙKÏ+ªF£«3¨£êÄí“Ú¿J¼	á”ð¾‰e¢GŒZ@‘’;°¼~02òbqÉ$÷­ê(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+É?i?‰ÇÁ~k{GÛ©j; „Œe¸¸Á þî3µHÎ%’<Œf°eo…oá½(øQB—Ú’/–Œ>hà4y “ºs‰XO-¤W¼Ñ^gñƒâ…ç…nt­D‰&Õuk”D€•HÃ(–FDÃ6Cm (Þüí ú`éEóOíð´ßÚÇãÌ¶ê"» u?¹œÇî]Š;ÄO’@Ž¾Uðö½wáíBJÁÌWVÒ	½znÔò®§†Fe#šýøkãËOèkvG`Û,}ã•x–&ÿ u¾éÀ…\pEuQEâ¿µg€Oˆü0u;tÝu¥±›€2a#mÊ×åP³`LCŒã$ü#ñcxKÄö«0X¡D§87ýÔÙ9Q¿“·(¬s´Wèò0a¹NAèGèGÔS¨¢Š(¢Š(¤jøgÅ67þ&MgfÌðKsäïÞG,ªA‘@ÂÈPä’T )s_néše¾—mš­àEŽ4Q€ª *¨° Uª(¢šñ‡0‚qÜP{ŠùCã×ìÆº|røÁèÞX%æ³A€òÒZ…ù¼¥9/nòÔ“|ºñ?ü\ñ%ÎtÉ	9h[ç…ºç0“´Ž#ú±é_P|<ý®´iVßÄHtË®“—Oõ€yúâdØ£þZ7SîÖWð_B—6²,°È#¡¬FV\‚¨5=QEQEQEQEQEQEQEQEQEkÉ>2þÏZ_ãkÛ]–ZÀeé…ºUŸÂÌ¿½Œ÷—å?6ø/Æþ#øâ	´½J&kfaö‹fo’@xŽêÚB6‡ |“"ƒá]sÙ^øƒ¤xÚÁu-a*7¦@’6êcš<–Gÿ +™Y”‚z0sE¹ˆ´¯é­¥kJgtr&‘·O2!¶¶8`C#¯ÊêÃŠøkãÁ=SáÅà[ßéó’ ¹Aò±äùR.?upnòòVA¹¢cµ•8¿xŽûÃ×‘j:dÏosGC‚ç³£cæ9•u ×Ü¿~?éž=¶ŽÒõÒ×[Q‡„œ,„peµg?:·SL±TîP½lÑEQEQEQEQEQEQEQEQEQEQEQEQE¼ãâçÁâ±i•mµE\Ev«– gÌ¹_:OÊHd?4l§¯Ãž3ðN±à-Q´ýJ6†x[r:çk…å'·”crc¬¤Ie\#ƒ^Ñðgö­»ÒÝtÏH÷6p·;wM:y»y¸‹–Úg_¼L£8úßKÕ­u[xïl%K‹i@d’6¬=U— ÿ 1Ðâ­ÑEQEQEQEQE…±Åxÿ Å/Ú_Aðc=…—üLµ5àÅaò14øeæ(Ä’Žê ƒ_2ø—Çþ5øÇ{ýÉ<e[;e"%ç†‘sƒ´Œù·R%BôÏð¿öC´³}ãGSðE¬L|µÁÈó¦c€2‰²!È>`«è/H´Ò [M>ííÐ ±Ä¡TÀTÀ­ÑEQEQEQEf¹oü2Ð¼sÛë¶Ë+'ú¹GË*gùS.A n\”lÊkæŸ~Ç:µœ¾g†.öØç÷s‘«Ðcx_&Nä¸ò ­Æ<ðøûâÃ{ƒ¥Éuye*Ë¿x¸À"N&F]ª h\ªŽ›I5GâGÇ?xþÞ+-ZTÐ¶ñQìRø*$qºFfPÄ/ÌrH\œ;§‰Híéÿ ëïïÔv®£Ã?¼Gá«¤jèƒ
Šås¸&_2-¹ä¨@Nì×²ø?öÍÖl¶C¯ÚÅ|ƒ¤Œù2c€[oÏ·qûÄãäŸlðÇí?à½m@šìØM·qK¥(8Æ@˜nŽN nl5ÛÙ|EðåìK=¾§fñ¿Ý"tç·BÀþb¬èkÉÔ- ÿ ®ñÿ ñUÈx¯ö†ðo†˜Åq~·ùejÍÆ3“cN¾EÜÛ’¯ ñí±ólÑ4±· ïº—œó•ò`:cÍr
w¯.×ÿ j?êÇ	|-##-¢DÏ9Ü$q4ª{² @Æ:×™júíî±;]êIq;ýç‘‹1ï‚ÎIÆNBŒ(?uESŽ3!ã·Sþ>•õ·ìÅð]-âñ‡ˆ¤ÅwZ@Ã‘¸`]J*ÅIFFåViÊ«ôØ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‘˜’qŠøÏ\¹Ÿã‡Ä”Óã'û*ÕÚ1Ž@¶…¿Ò%8ln»“§ rŸ²¡c@ˆ0ª Ð üú	¯Ÿ´›‘ñâÜ—°3MðÔ x*gmñ±\‚óA¸slã5ô¢Š«ªi¶ú¥¬¶7ˆ%·9º2°*êG¡RE~}üløMsðëXkFýåŒù{Yq÷“8òÛ=&„a$%†Ùz9ÿ ì÷ñRãÀúüK$˜Ó/aºSÐ);cœd€¯°;¹ÌEÔð¯ßÊÀŒƒšZ(¢™<+2ä‘„ õüïøÑðõ¼	â[,-ù–ì{Ã&|¾rIòNè[þ¹ƒüU÷Áÿ ¯Šü-§ê æW…R_Q,º˜gzÀcŒWeEQEQEx¿íOãGÂþŠ-"o³Ï9Üpâ=$†ÈòØ•Ti@&5rWk•aWö[øQÿ ®ý¿|¿ñ0ÔÑYF0bƒïÅ<ï”Ÿ6^˜ù!'Ü¨¢Š(£áß¿eÍ'Æ¾§£0Óµe27]î‹µ¢‘º4‘¶ ¼nrOÇÞ2ð6¯àÛçÓµxÞd'ò¬8>d2’XÈ#æCòŸ•Õ¯Dýœ>/Ià½n;=Jà¦‹u˜åV'Ë1\ªà„*ÿ $Ì»AŽBî—¹~ìŽU‘C¡¬r<‚à‚9pG4ê(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(Åpþiÿ 4ámsˆoaÉ·¸’„ŽQÇàs2<Ž@u*ê|3¬iž øi­=¤-Ž¡ož'*Jä’)WlrN6:‡R£è?ƒÿ µ²O³Jñ©Úü*^¨ã<ô¸Ð ƒÖxÆÎòGæ¾œ´»Šî%¸·u’) eu ©ÊËAÁ©¨¬ÏxoOñ%„ºV¯
ÜZN0èÝû‚Ã+©‘Ô†F”‚3_|wýœî<[XÒK\èîÇ9<û©;ïŒžà…ù°“‘!ñ(¥x2’¬§#¶äz‚;†ˆ¯¥þþÕRiâ=Æ.ó[Œ„½$³ ÀÚ·
tÑäL3"gQæ¬¬ïa½….m]e†UŽ„e#*ÊÃ!•pEMEQEQEQEQEQEQEQEQEQEQEQEQEÏø×ÀšOŒìN›­À³CÉCÑãb
‰!qó#€x#ƒÑƒ+âŒŸ³Ö­à	öÜ5ÞÍò\(å8È[¤QˆˆåD£÷/€IŽÚÏø;ñ³Uøw|¡Y¦Ó]¿jÇå=™âÏ\ 8q…|”w¯Ýþñ^Ÿâ­>-_I”Mk0àô ½‹Õ$Còº6>Ä±EQEQEQEQFk™ñÿ Ä=#ÀÚyÔµ©|´'lh£t’63²$±Ç,Çƒ—`+ä_üuñwÄýCûÃâ[{Ißd6¶Ç÷’ÏïæR¬üi<Vñ§ÏçÓþþÈV6h—¾1µ\uû,GlKÐí–EÛ$Í×r¡Ž’0ã^ýáÿ éž·zE¬Và…îÛ@,Ç»1$’I9&´ñEQEQEQEQEb±¼Qàý'Å6ÆÇ[µŠîÂEÉ¦èß‡¿ÚFR=kåˆ¿±ö­ûMá2—6œ¬rÈH³ÕÜ™ÎÉ2$ íub¾cyïŠfÿ xrÛí·&hGÞ6î&+Óæxã@¼“¹Uñƒ»šó)­¤…™ÊpGpza‡U9à† ƒÁ¨ÈÅ%9$dû¤¥/œÞÇêó#4yÇÛþùáAv~	ãÓ·àð¤ØßO¯–kÐ¾üñ?ŽSíe°KC.'o."A ìl3ÍŒœ˜cu#~î+Ý¼?ûØ,yÖõ)ÿ »j‹ùi0˜»?*ƒÁqŠô¯
~Íþðä±ÜÅhn®!ÚUî\É†^D‚3ˆUóƒòÆ   Šõ (¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¹/‹(ðÆ£«gl‘[°Œç¼ÝBÃ|ÆG]¹R	Àï^/ûxM ³¿ñªGœékÕbùåe$nÚdp‡Ç‚2•ô­Âüjñ±ðo…ïuXX%ÖÏ*ç¬Ÿ$gþ“!Î’:Žsöbð3øgÂÉwt¥ou6ûT›¾öÂ1n®Hw•‰#ïÈÙÉÉ>»EWñgá•§Ä-M*á„SžÞldÇ èqÞ9c•A£c‚?=üMáÛ¿jWN ›.m¤hÝ{dwV GV¹[Œ×ÚŸ³/Å¯øM4a¥ß¾u]9\ãýd_rù'.6ùssÃ€ü	 ¯h¢Š(¯¿l­þ‹mâ”l¥È{ùs«Ÿ]—<ó¶0Vì[ã5+}á‰[qw'¯Hn  ˆœàÿ àÉú”QEQEQ_/|P¾*üK´ð‚déºR“psîËwüC–ÞÕJ®Aw<ŽŸOCÄ‚8ÀTP  € € 
}QEQ\÷¼¤xÎÄéºÜh¹(Ý6Æ<ÈdûÑ¸ÏQÁèÁ‡ðÏÆ‚ÚÃ}CÓé“±û5ÈÏ"`¿*\ Ï	2ñò¬øûL]ø9"Ñ5Å7::œ+eOüóÉÄ°)äÂpè¤ùLB¬UöŽ›©[êVÑ^ÙºËo:,‘ºœ†V•”÷EZ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ƒ\oÄ¯…z7ìMž©ª‘ÂæDNQ¿‰	|M”q@8#âoŠuß‡’™®ÓÎ°-„º‹ýYÎv«‚KA!îHJ“ÂHçŠ“áÇ-gáÝÎÈI¸Ó["KI„ë’ðõò&ÎrÊ»8•	×í‡4?Ú­lÊª¶ï,yÈXòx8;]FÃÆºðsEGqmÌmÊ¯‚¬¬
²œ†R8 Œ_4ü^ý’`¾ó5?í†_™šÉŽ‰%Ù¥9“œ,/ûÑZ!_)êú=Þ‹w%ôoÌ±ÑÆXvaØ÷¬>df\õo¯<t¶ƒ=Æ‹)ÃÅœ˜Éÿ –¶ÀýÒ3—…p’Œí ¾Þðÿ ‰4ÿ ÙÇ©é3¥Í¤¹Û$g ã‚ue †F”‚¥EQEQEQEQEQEQEQEQEQEQEQEQEÅ¼w1´3(xÜeaAá•”ä2H ðE|qñÿ öm›Ã~wˆ¼6¾f’>ya/n?ˆÉ–Õ:îÏ™}ðÑ¦åòï†ÿ õÏ‡×¢çJ›÷,G›å¢cÌ@x`1²hÈ‘@ C´ýÅð¯ãñÏÎÓÛÊ»Œ:ÙÏÎ„Ž«ÐK	 …•88Ãl¨î¨¢Š(¢Š(¢Š(¢›#ˆÔ»’z 9$“ÐÔž|ÿ ñKö´Ò´Ö^TÔ®†A˜’-×ƒ‚¬¿5É÷Ecë™r1^! ø_Æµv¼¼•žÛl—C
“»Ê†%* 2 ˆî'kO 8júëáÂ-áí¡ƒK}Ì€y×.3$„c=#ˆ•†<"ç',KÞŠ(¢Š(¢Š(¢Š(¢Š(¢Š( Œ×ã/„>ñ‰ó5›äœËdÌrúàÍI
õá‰ŸS^3â?Ø«O÷hºŒ)9Ùp‚\ExÌ×Ý»9Éæ¸kÿ ØÃÅ«5½Í”ätPò!#êñ”SŽpI³\¦»û0øÛJ_0X„
X›yLc¶ÜÆå±ÈTG'ëÅpZ¯‚u#ö…•Å¿—Þl. g¡,Ë°ž¥€Ï«à…÷Ž¦hôKf–8ÎRBÄ‡æo”69Øß‘ò€r>…ð¯ìWj°£x‡Ps1åã´Pª8áViƒ¹!²Kyj¤`l“ìÚÁh°k}*ÚAÆ^hÄ®ÄI0v'’x z]¬0¬*0T` 0 ì  {O¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯›l?¿Ùì|%gÌ×N.$…>]¼g?óÒvÝÉ òqkÛ~øB?hZxÍ´*®Àct‡çšLp^VvêÇœdã5ÒÐN+æOŒú“üLñÎŸðöÈ±²”IvÃ8-·uÆHÆ6ÇÊ6à€A\7ÓÄ±(DU  ;À€âŸEPkå¯Û+áâ•¶ñm¬9"Úä€Nx&ÖFç|%¶ó¾0OøMñ
köúÔ º!)4cx›XÆp7`,‘ò?y€ÍŸÑ=W¶Õí"Ô,d[\ ’7SU†AÈïØŽ ‚"®ÑEã?Câ}óD¸â;¸^,ú>GèûXvÈæ¾ø7«OàZG||¶K–³¹›É¶7íY¼·È!W•×è ¢Š(¢Š('Àø÷ão†|“Ç}yß@„ý–3ºVoàbä#1#>a]ªKœ(Íy×ì› Mu§ãkáþ‘«\8L.Ðí,å1ü/s#¯=¢\c‘_AÑEQEQY^%ðÎŸâkt^¸³œaÑ¿0ÊÃŽ§Ž„:0¤_þÐŸáåÒ_éŒòé$„w#toËy0ÆàSæŠV ¶X³€[ªý—>8'‡ä×\Ga+“o#p"‘ÎZ7nÃ3œ†#ÌHbÆß°ÁÍQEQEQEQEQEQEQEQEQEQUïôû}B´¼&‚U*èà2°=U•²>â¾Nøûû1Ç¢ÛËâ?
+HòóÚ“»ÊP2[“ó´+‚d‰‹<`ïŒ”Îzf¯y¤N·62Éñœ«ÆÅY{å] ¼­ÔƒÅ}AðCöªÄ§Ç3òXyW¥@ÆHQÐŒ
26ÜíU>vÜo©ÕÀe ‚2üÁ¸#¡¥£ç¾	é¿-TJE¶£ÄW!wuh¥@TËêåhÛæ—,žj±~„Úw“g}rº€K&ÖŒžxhPªàl2àœø“â¿üÖî, “ÉžÛ<-óÃ'BŒéòîYkÇ2¥(@ÝÈ>¨øWûKh>51Ù^§jÀŠFýÛž8‚sµK6xŠ@’õÚ¬kØr(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‘Ð0 €AëŸë_.ümý”ÒA&µà¨Â°ÜòÙvîäÙv^Iÿ FbBSÌšV«¨øjý/l¤’ÚòÖL«¯Ž8`C;¬‘H¸u%$R+í‚´¥Ž4\-¦°GÊGÌGQ	bZ9°œ˜Æ@öÐih¢Š(¢Š(¢ŒŠó¯ˆ¿|3à`ðÞ\}¢ùåÚß =¼Ó‘I•”ã¢“€~Nø«ûCëþ?ßcú–N>Ï'píö‰pcœâ5	é¶N	é~~ËŸˆÙ5_o±Ó¸eN“Ê0Ú¤³Æzn	¸ù#@CWØz6i¢ÚÇ§iÑ,°(HãA€ è©îIË1É$“W¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¦ÉÈ¥SÔGâ›´VëåÂŠ‰è ù
“QEQEQEQEQEQEQEQEQHÕñç‹ž2øÏ lÅkycäÏÉl¢âUuî¦Q"o<aÐž1Ÿ±(ªzÆ§•g6¡rÁ!·åv' *ìI<€r{WÏß²VŠu)5]®n/®4b:ÆæãŽL²ª>Ý¼ú6Š(¢ŠÏ×ô;MvÆm/QŒKkp†9÷Ž=uV« G"¿:~'øçÀúõÖq’!|ÄçþZDÙ0Ëœ(%“‡Ú0%IjôÏÙ»ãÃøFé4fAý‹pü;Ÿø÷w?ëCv‚G?¿S…Fo9J0¶Tî Žô´QAé_þ×^	mÄøŠØl‡QOœ¨#lñ ò8â1È1ónˆœçôçÂoxfÃYÏïeˆ,£ÒXóÃ¿òÑŒA'®¢Š(¢Šç¾!x›þoßë`ö–ï"Ð¸‰NÀi
®p@Ï<Wçf•câ­f;4f’òúà)c“ºIç’M¹ÉÜZV>ŠG@+ôƒÂÞ¶ðÞ™m£Ù[ÚD±/¾Ñ‚ÇÕœå˜÷$šÔ¢Š(¢Š(¢Š¯§Ûê0½­äi4:H¡•‡£+úŠù/öŒýmü9nÞ&ð¬N-‰¹·_˜B§Ÿ> I³ƒ•–?œD:íˆ8¯ì›ñbç_´›Âú¬žeÍŠ	-ÙÎY¡Ï–Ñ19,mßhV$Ÿ)ÑOÜÍ}EQEQEQEQEQEQEQEQEQES]‚¬2Áõ£ÔWÆŸ´¿À4ð»¿‰ôK™À–?Ô;t)Ž´¯ÀL¬|Ž|ö®Pÿ ŸóìG§öWì¹ñ²ÓXÓàð†©'—©Z¦ËfcÄÑ/ÝO¿>VŒòñªÈ…°á~‡4QAæ¸ïü$ðçŽþ'Vªó…Ø³§É*Ž£l«‚B’HWÜœT‚AøÃãÀ_áåÌ—MÆŽÍˆ®†1ÏÝŠáú©Tñ¸§6|µíþ~Ó×Z&‹â·{;*±ÎÄ™ wœ´Öë€ÄfˆÁ‘FÕûNÔ­õ(îÊDšÞU’FÁ•èÈêJ°> Õš(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š)Íy¯ÅO€zÄ{‰“ìš¦Òê!óÆÄ|%ÂpÈI&¾/øð¯[øw~mµ(ñäÎœÇ(\Ñ·ÞVPAhÛF~a•ëÖ~þÖz:Å¤ø´5åª€‹r9™
¾jÿ ËÒ¨êù’D§&¾²ÐµûzÒ=GK™.-eY#9Øã•aÑ•°Êx Ð¢Š(¢Š(¬øëGð}¡¿ÖîRÞ.Š	Ë¹ë²†^W8û¨' WÈ¿ÿ j­cÄ…ì|<_NÓŽA >@AÌ•säœì€ïÇPx¯1ð'ÃÝoÇ÷ÿ aÒ"2?Þ’GÈÏï.%Ãmƒ½,œìV$‘öWÂŸÙÇAð8K»•†¨0Þtª6ÆqÏÙ¡9ÿ ×F-)ë¸t¸(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š)|‘û?ƒ¨|UÕn.‰’XÖú@Äó¸Îdú(• àŽ•õÅå_´×‰FðMä{ÂÉ|RÕy Ÿ0æ\cïb‘™xjßìïá¶Ð¼§Å"í–áZéÆÝ§31•CÎR#gŒ…5éTQEQ^AûH|"oèßjÓ£«X‚ÑàÉæ[|à‚ÇHAÀóTUY«àù#{i
¸!”à‚1ìA‘ÝXAÊžA¯µ?eÏŒ‹â}9|3©¿üL¬P™ØfhG;škpÊ0w!IrrÛ}ï4QEy¯íàSã	Ý[@žeÝ®.­Çrñ‚YNdˆÉ¬;ò<£ö,ñ<Îº—‡¥lÄ›.á7ç$àÛ |ÅØqÀú†Š(¢Š+çÛ#Æ-§h–º-†¾É/˜áÁœmÃÎñgœáHÁ‘Á~ÇßN¥ªËâ«Ä>FŸ”€“ÃNà‡lÏ‘¼0$”w'Ëö-QEQEQE2xxÚ)T:8*ÊFAa”ƒÁÜWÄ^<Ñ/~xæ-SIè,Æk`[åh›ä¸´àåïò9Â›yNY}àÏYø·I¶×4â~Ït›€lnS÷^)6–Hœ4n 2œ+jŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(ªš¾‘k¬ZK§ê,öÓ¡I#qÊzƒüÁ €A_|}ýœeðh:Ö‚$¸ÒX“"¶Yà=G˜ã—€òf£ 	X‚xTIm"Ë(èÁ‚åX2ÊÀòH#±¯­þ~ÓÑêbx±öÝ$WŒ@Wè;“ÆÉIùV|ä;CìüßJ«ÒÑEA}eôkuËªQÑÀ*Êxee9¤#WÈŸ?f	ôC&¹áÚ]9W|¶ù-$8êÑg-4ä®L°à•œ/ž|%øë­|:œE}£LbL–®~C’3$.3äËÁù—1¹'ÌBß8ûGá¯Å½â«O¤K‰ãÇ›o&±äg%rCÆs…–2Ñ±È v™¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÅñƒôßéòi:Ä"ki;t*ÃîÉš9ý×SžÇ ‘_|hø©|;½$¸Ò¦oÜ\ãÿ  Î;…éœç\<xmñ®ÃŸŠúç€oÖ•9X‹fX&)GGÐ9Ú ™12€Ä§í?„ßt?ˆ1¬°µÕB‚ö²O«[¿xÁ (ÿ XŠzúnh¢Š(¨®¯!´‰§¸uŽ$gr@îY› rkçŠ_µÖŸ¤‡°ðŠÛ‘•7/þ¡z‚b\‡¹ ŽÉ ‡p¯”¼QâýSÅ¨ë\Ü¿Üôˆ£	`’Dqª ÏBy®ŸáOÁkâ-Ñ‹OQ¬ED×’0yÀe›nY!R3ò™4`OÝþ ð—àm.=Glkó;·/+žiœºGÀì,hTt”QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQES&bˆÌ:€Oõ¯•¿c»£ªëzÎ©p«ö‰cG,O6i¤/p¬ÀdgøW=+êÊ+å¿ÚŠæoø³EðT[¼¹;m#ïO'Nù^8"•—y*wð§ý?im¬)oj@èª    ÅKEQEø«ö»ðZ&¿³e—¦…Ü(;|èÈ0ÇÊ­,l’0,É$‡%‰% k·Zô:•„Å¼‹$n½C)È8èÀò¬§‡BÈÜ1¯Ð¯ƒ¿ ø¡Eª.Ô»OÝÜÄ§îH>ñQ–a£BXä£Ôî(¢‘”ÏJøÃÀ: øqñZâÆäˆl¥ºžÔüÜæ"kVb6ƒµšK'˜ÝÇ?gƒž´´QEWÃ_µw‰Æ·ã6²F&ã¶9Ïï§`2@lÉŸ,ÊšúwöwÑ Ò¼¦,ÍÄ_hrq’ò“#g d.B.rv*‚I¯H¢Š(¢Š(¢Š(¢¸_Œ,þ"hÏ§Oû»¸·Ik6~ä¸ ëº>äÈAÊË‡Uaäß²ŠžÔj>	¿;.mei£F##Ÿ&ê00î¦@ýÎ$Î}'EQEQEQEQEQEQEQEQEQEQM–%•J8¬ Œ‚x Ž<ùã×ìÂÚ`ŸÄ^RÖCç–ÍW-ä¼c%à^¦o…rP´cbüÒwDqßüýA}A ×¾|ý¦.¼$#Ñ|BdºÒËºXxIÝ-ºó˜‰i#P<’Ê¾Xû+JÕ­u{hï´ùR{i”2H‡*Àò#õAà€jÝRšù÷ã‡ìÁmâv“[ðÀK}MÎé 'lRŸât íÁ'ýT¬2á]Œ•ò¥ö¹ðûWÇæØê6Ñ”«)êUÑ¸dq÷”îŠUèXa‡Ú¿>=XüDƒì—
¶ºÄK—„7Ë mÉÃ:É|ñdrÈCŸY4QEQEQEQEQEQEQEQEQEQEQEQEQTõm"ÓV¶’ÇP‰'¶™J¼r(e`xÁô=AäkäßŒ²mÖš_Tðhk›02Ö¤–™9ê	ÿ ˜ðI*ì&@£i›;GÎi$Ö†RÑË%J²œ‚Ã#¡aÔðpx¯©¾þ×Q²&™ãPAPoPg<þ•åƒq–ž Tän‰0IúkMÕ-µKt¼±•'·”nI#`ÊÀôee$ô5jŠdÓ$*^BTI8 I$ð IàW„üKý¬ô_²ðúNñIS&vÀ¤uýàËÏHT¡<G–|}ñwÄ>8—v³tÒBVù!_M°)*Hþô¦Wÿ k®xßšCêzÿ õÉôõ'ñ¯mø+û5ê>3hõ]\5žŒ~`ÄbI†~ìpQÎnc‘å#ýõû?ÃÓ¼/a•£À¶öŒ*/êÌÇ,îÇ–w%˜òI­Z(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¨®ñå>º‘¯˜ÿ b]¬¦¨IÚL6ëÇ€Ó·ÍÝ”Ê ŽÀ®z×Ô4WÉúìË®|r·€‹m<Kœç&ç>Á˜…Ç8Áï_Xh¢Š(¢Š+ÆþÓ|g¦É¤jñ‰ “Ã‡¿‚h_d‰žB2¬
’ç¿Äß‡·¾Ö¦Ñ¯ÆJ|ñ¸é$LHŠe p¤2ÿ ŠéÐ.u¾|Uºø{¬¥ê35Œ¤%Ô@ðñ÷lr<Ø2d‰°á¢ÎÙ8ý
°¾†úîíœIÈ®Ž½XnVÐ‚OEñ'íwáÆÒü]ý ©ˆ5MÃ.™‚aÜ–Ûä±bÞQÎÓ_Jüñßü&>µ»™Ã^[³\s“¾<(vÆ0eŒ¤¼â<œf½Š(¢‘˜(ËÎOë_™¾3Ô´5ëíCåýýÔó|§šG|)È8<ç9¯Ð¯…š<š7…´½>c™!´…[Œs´
žAàƒÎEu4QEQEQEPE|‘ñŸN¸øUñ×ÆÚr“i{!™‘G€ß[œm\Ï	¢ÜÇ2–l™¯©ü?®YëÖ0êšl‚k[„Ž§9±ÆpÊr®½US‚1ZQEQEQEQEQEQEQEQEQEQE„db¾Wý¢?fÃ™<Má8r§/qiä­5²/%IÉ’S—ˆ²•ÙO?çüþ‡ òzÂ_ºÇÃ›’ÖgÏ±”ƒ5«œ#‘Æôl1‚lqæ¢ØQ*>ÐWíÏ†ßô_ˆ6ŸiÒ%ÄÑç[¿FHæ_ãNp³Gº7Á²˜9¢Š1\ÅoƒZ?Ä[O*õD¨?utŠ‹×älÿ ­„äî‰Ž2w!G‡Å>>øcâ/†:‚ý­^5˜. ,ˆË†eÚÑÊ cb²¨é–>·ðÓöÂ½³1Øx¶µE¦æ P8¤‹ý\øêL~SžÑ¹Æ~ªÐõÛ-vÎ-KL™n-f]É"‚?¡†S‚§ €E_¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŒWŒ|kýœtß,š¦˜ÓZ |ý#›Â¨$>Õ¸E.Õq"(Qñw‹<!©øNýôÍZ·¹’¬:Œ²#}Ù#bÙ•8ÁÚÙQÛüøó«|;œ[¯úN”ïº[f8ëÁ’ÿ –2ô'.L0ûÁõ·‡?h¯kVÂçûF+GãtWGÊu8Î0ÿ +Ÿ¿:gÙÈ¬?þÕ¾ÐÃÇa+êw	‘¶Ýp™ÆFndÛSÓtfNø†Óó'ÅÚÄ=&Þgû.ŸÚÚBúìÇpyèábÏHºâ<=á[Ä·ÛJ¶–ê^…bBØíó„ŒöÝ àw ûO…¿cjdÖ&·°ˆõŒÒGðG² väŒÊÃ8£šö¿þËðÌ©wt¯©\ÆCq·ËŒnèmƒ–_7Ì*qÉ ìŠ¸¥¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Æ‡ G_²Oÿ ¢Þ¼3ö,½-¢j6XcºŽ@ÝÉ’$R1Óä‚=wôôeòOÂ[/íoŒZÜŠe“ßHr†Ñ’Gug®}}l(¢Š(¢Š(®âïÂ-7â>›öK¼E{&Úä´lz†o†L,Dá†Jº«€<Yákÿ 	êSi:šyWVîU€Î>ë£G"áã||ÊGñéÙ?ã?)à­Y;”Œsƒ÷šÌžÊFé-ó€0ñvŒªAÍW†þÖÞ
mwÃ«@36—'šÜd˜\ysã‘÷	I{ðŒ ÉÈó_Ø¿ÄÒ[ê×ú…Œw0‰”uá"7#Ÿ—tr 'vÅp~¼¢Š(®3ã‰†¼)©jhÁ&KvH‰ÇúÉ?u	Þà…ÁÝŒcšüùð­„:Ž±kep7Ã,ðÄÀeZD‰€#e	 ƒ‘œç5úo…P£ ãòâEQEQEQEÄü_øsô	ô‡!.ï-ä ’®v†@Z)1Ö7a^Gûxšæ8õ/	_†I,¤"1åw3CuÃ²tFyi€ çé*(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(#5áßÿ e½#ÆÉªi2;P•‹É…ÝŒq¹Þ U¢‘°KÉØ–tf9¯”>!ü$×¼8‡YƒlnqÈwÅ'|G.çë˜R\„#šÃð¿ŠußÅªiS4Pœ«¯_B¤6‘œöÏÁ/Ú#NñÜqéz‰K]w1ôI¶Œ—·,OÍ·æxW|cu{QY)ð¶Ÿâ}>]'WˆOk0Ã)êU‘r’!Ã#®
¯…>2|	Õ~]4Ä*GÄ7 uÏ+Ê?ÕLóÎR	Œ‚|°Ï‚ÿ µ‡Wü–ŸK™¿Ò-³×þ›A»åŽáÑ'QåÈCl‘>ìð§‹ôßX¦©¢Î·²q¹r#ï$ˆØxä_âG‡Ðæ¶h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( ó\—Äo†ºO4öÓµX†ü*uÌ‰»<lGLã|gä‘r¬;×Â?~jÿ o¾Ë© hdÉ†hòc‘Aä©<£¨Á’Ë  ‚èw×“:p¤ìiËrÇ'Þ½cö{ø7ÿ Uf¾.š]˜W—‚äçË·Gþ“‡Ì‘—Ea÷V…áëÕ4ý*¶¶ŒaR1õ8å˜÷f%‰ä’k@QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEr594¿
j×‘ ÏœÄéÊç=óÔ}kÇ?bÛWM/U˜ÿ «71F©HþoÑ×ó¯£é“J°£Jÿ uAcôŸÐWÍ?²_j:ö´¥XÉ"*÷ö»ÍpXŽ¡dAçtx<ŠúfŠ(¢Š(¢ŠxWí;ð^OØ¦¹¤G¿U²R¬Šé¡ûÅpZX2B¹ùƒIË2ãâ¨dšÂu‘£’6$2• †SÃ++ GB¬¼€Aúð3â”_4î¤aý£n+´ßÇ¨ã÷s¯ï),™Ü†½Š¯©iðj6ÒÙ] ’	Ñ£‘O «®¤wIñÃë7økñF6áÊÅÛÚ’I£™Lp;íà‚ ‚­ Ær7WÜâŠ(¢¾wý³¼HÖz–MÜæYy)ÈtÌñœõ«€rkäR“LºŠöyºH»†Fäa"n×rÃ©¾ÎÓÿ l
É`—q]GxTo…#Üc,mÊîÎÖ ‚PsZÞýªü­íK¹¤Óf9âå~^2xž-ñcÅI$ 	®¶?ž’7™u‹=‘ãqó@Æx1Éô®øwâ†|Isö#R·¹¹Á>Z8Ü@ûÅTà¸NÜàsÒºÂ–Š(¢Š(¢Š(5òÇŽb_ƒ ñV3£êþi” I]å~Øå%òîÔ—S*ðpOÔÌ’¢ÉF ©<‚à‚ ŽÔú(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬ýsA²×m_OÕ K›YF9A÷ç£Ì¤2žA¾KøÓû*\hI&±á=÷6+–{c–š1œæ"kˆT`s:(Îe ãçXf’ÙÖXÉVRH8är¬¤`‚F2ž„ú{àíU2Ë‡ã9ÂÇb_7„àF·xZ#÷~Ò0Ñ¦pT´«õlS$¨$F¬‚ ‚2=ˆâŸESVÒmu{i,u’{i†×ŽE¬=OÔw‘ŠøëãìÁuá€úÏ†VK­0’Ï¤€}áÓ-=º&±¨g˜3 óÏ„Ÿõ?‡:º¶>e¬¸ÀOË*Ž<…•9ò¦tü˜ÉïŸx²ÃÅzl:Î—'™mp¹à©<n¿Ã$l
ºö#‚AµEQEQEQEQEQEQEQEQEQEQEQEQEÍøÿ ÀzwŽ4©t]YIŠLuáãq÷&‰Žpè}AVRQÁF"¾ø»ðcVøwy²íL¶±X.T|˜#Ÿ*}¼˜›†ÚÆ&u/×Ð¿²oÅKß\hz³¬0êŽVû«*æ5Y8T•Jª¹ùVA‡ :×ÙÁéKEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEÄ|oÿ ‘+Yÿ ¯)¿ôóØÊáN©[_—?GŠ ¿¬m_BÕ]Wþ=&ÿ ®oÿ  šùsö&™EÞ¯?3AhÀ{0cø_Î¾­¢Š(¢Š(¢ŠÍ|ûTü0<ž2Ð¡&'%¯£Nv?ÒÕ>[ãý#nv6&ÆÓ)à_êÞÔRÑæ1J¸:£®rb™:<mßø—;ã*ÜŸÐ?†Ÿl<}¤G¬iÇ;&ŒŸš9 âlp@ÈdqÃ£+¸]¾?ý°49tXøŠÔ´msÕHÄ¶ì
?˜	¶:`±2OKü5ñÝ¯ô;mjÐÿ ­]²§t•~Y¢ óò¿*‰
¸$k©¢Š|]ûdø™oüI•–À0È’cæ°$ÕÇ¤÷šùò¬YØMy"Ã3ÈßuTÇ¹ÚŠ›€OÊ§ xµGƒ5¨ðßc¹\ô>D£?CåóZ¶?¼Y¨Eö›]2öXû:Àÿ C´°Vàõ zöæ°î!Ô´K 'Û]DrîŽE#ºîÙ"°#”Œ@cÍ{—€kýsG	iâ8—Q…x2gËœze±åJ@îë7vÏÞúsÀ?4Â$ÑnU¦
Àÿ ,ÉþüG’÷Ótg¨b+°QEQEQ^AûRxPëžšê%ß6šëtû”¸ö?¸wbnzIû2|D‡Å>‹M•¿âa¥*ÛÊ	Éd[Î2Kt¶–7ÆÜûQEQEQEQEQEQEQEQEQEQEQE|½ûLþÏi*ËâïDD¹/yoä6ykÈQy7( ‰ó€+™>OÁŒóþ{uÛq^ÁðoöÕ¼É§Ýæ÷GÈ?4c9fµs€§œ˜\ùMŒ)ˆœ×Úžñ¾•ãÔôYÖx[€?:7SÑýèä^êÝz©*A;´QAë^ñ—öbÓ<X²jz [-XåŠ–‰9c"€|©8š0<JŽGÍþñÇ‹~êrY2=¹Üö— ˜ß°} ã,	sÊ:¸GØ_~3i¿,Œ–Ãì÷ðçÛ3W=$Æ<ØIÊ‡ÚHÛ"«c>…EQEQEQEQEQEQEQEQEQEQEQEQE¯øvÃÄ6Réš¬+qk0Ã£ŒƒÜÝYO*êC+ T‚+ã/_³.£á.­¡‡½Ò,p3,##‰”s*ÿ ®r &TÉ^wF}ùü#êö¯øûLÜøTG¡øŒ½Î•œ$¼´°ü*>fž ßòÏýdJO–]@Aö>‘«Zêö‘j|«=´ê9åYOBèAåH €AnŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÀñþºÇ‡õ=Ô¸žÖdÚ	%hs’ÀWÏŸ±MÝÃ^¹·?grø?ëu)»îŸÀ÷õVÔÿ ãÖoúæÿ È×Ë?±-º5æ­9¼H-fi‹ÄÆ¿•}_EQEQER:R¬`ƒÐŽ„ÜÔw¯†ÿ hß³x.ýõ}*,è—-”ÛÒnZÝñ÷P·6ìx*|œîT‰ðâßü+ÍlIvXé—AbºP2@ùw  YšÜ³«–x™ÔU}ñ§ßÁ¨Aå¤‹5¼Ê9†VV•Ñ†C+AÁb¼öÈÐ÷†-µu•Ò†$‘„•Z äeòIÎ0 àö>Aû%|@“Bñ Ñ&cöMPyd‹2öîx,¢H[œÇ’WÛ`æŠ*†½­Úè–3êwî#¶¶¤‘`£'êO@:’@ šüÙñ·‰'ñN³u¬\gÍº™ä ó´¹Ïhã	;môÅvß¿gýoÇó%ÆÓk¤‚wÝ:ðq’Þ2TÎíž~á@bÎÇ·Ú~ø_ ø"ÜA¢Ú¤nFfù¥y&l¹ä’‹œ"Åu˜¢³5¯iºìFVÖ¨ÏðË¸èG à9àŠñO‰²F‰¬Â÷?Ù× ±’ZÝ;žÁÃDv‚rÑ¶M|µâ_xáÖ¤‘ßG5•Ôd´2£ž£Ì¶¸ˆ€ÙáX8Ïï#+Þ¾~ÖŒÍ“ãSÄ"^¨oaöÄs€gŒg2Æ 2WÔÐ\Gp‹,,6VR ò
°È Ž„}QEQETÕ¬P´šÊO¹<oã<0*x<½ñìï¬ÜxCÇÑi—h™å°r È,©ü[r³@9ËcsÎúûœÑEQEQEQEQEQEQEQEQEQEQEQ^ñÏöe¶ñJ6±áxã¶ÕrZX¾äsç–n2±\gø	.q.~8Ö´KÍî]?P‰à¹¶Éƒk)ê)õRH%]HdfSšÛðÄm_À×ÃPÑf19Àu<¤Š|¹£þ4ê’<“)àýÝðŸã“ñÀOdÂ+èÔ‹V9xÏBTày°’w2Œ0 0GÜƒ¼ÍQ^ñ{áŸñNû=Î!¿„opJÕÈÓ<:p|=wmâ…šñL½–¥hÙV^FFR~I •G$\«€êB}[ðsöŸÒüX±éšùKP…Päâ˜ñû¶n!•Hd8b@‰ß ÷LÑEQEQEQEQEQEQEQEQEQEQEQEQE!¯þ9~Ëöºäsk~`ÔywµG1êÆ"HX'až?ÔÊØŽññÝÝ¤¶²4S£#£e`AVŽ§]H!”à‚+×>ü{ºðÐ°¿->;fHÇ-=g€ãÿ ž±ð&#€_î=]±×-cÔ4É’æÖQ”’2
ŸlŽŒ;©Ã)È`Å^¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¨®¿Õ?û§ùùËö'¼µ:6¥hûjÜ¤êchÕ!÷!dI‡LHÉ'¤ª;˜„Ñ´g€ÊGæ1ýkåÿ ØÞÈÙêšíº¶ä„C×l—(­Ÿ`§ë»Ú¾¤¢Š(¢Š(¢Š(ªZÖ‘m¬YÍ§_Æ%¶¸FŽDaU†ïÏpz©ÁŠøãOÁ›ÿ †úŽÖ->›9&ÚãxLSmá.#{ ,ª<ÔÇÎ«è_²ïÇ8<4ÍáŸL°é²’ðJç„åÑØ±Á1ËnÀXæ$¶L±c‘eQ"ÊÀAÈ ò#‚äÁ®gâw†?á)ðÞ¡£/ß¹·p~øâ8'*ñü]×ç6—¨Í¤j_B1<¤ªtta Rê6‘ŽOµ~˜øYƒ[ÓíõKS˜n¢Iû8?ž+BŠùŸöËñ«[ÚYø^ÙÎë‚n'Pz¢#Œr­1i1œ#î×=û9~Î–šõªx§Å³Ú»mlÀ SŸ>ppÍ0Äqp²¨ß&èÙV¾µ·¶ŽÚ5†T UU  UF P8   ©(¢Š+/Ä^Ó|EhÚ~±oÝ³rRU3Ù—<£Î„0ìkåo‹Ÿ²eÖ–¯ªø8Éu å­[™—®L.HûB>FÄÀrO»\gÂ:÷Ã[…Òo§ÓLIk*•xûÉöbÛZ2wd&9ÂÆ_}}¿áßYø‡OƒVÓ_Íµ¹A$mŒdU<«•e<«"´h¢Š(¢Š~~|n»“Mø¨ÜÚ.h¯DˆÃ³ˆß„€1ãž{×Ü¾ñ2x£C²ÖãÀp$„pÄ~ñ8'”pÊFrÁäVõQEQEQEQEQEQEQEQEQEQEQEf¼ëâ÷Ám'â%£	•`ÕqÐŒr#˜y°ÕOÌ™-Væ¾ñ×ÃMsÁ7&×[µx9!$ûÑ¸ç—ä~â¿,Š>ú.2|=â]CÃ×i¨iSÉmsÊ¼m‚=GpÊØÃ£G2ž1õ/ÃoÛÚhÅ¯Œ¢1J3þ•n„¡œËnIc«Eæ!<íAÀúÃÞ(Ó|Gj·ú=ÌWVíÑâmÃ=Õ‡Uaƒ•`¬;ŠÕ¢‚3^{ñ‡àîŸñ"ÀA9_@ÛÜ’¤õŽAÁx€YAH„0Í|EñáF»ðþëìú¼ccˆæOš);þîL›Œ˜¤*ã;Hù«Ô>þÓ—^tÒ<U+Üé}VËËqÏ2O ämÒF¸òË"ìbéz¥¶©mõŒ‰5´Ê9åYO!”Ž þ‡ƒÍZ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢‚3^sñKà^ãø^[˜Å¶¤W	wùÆ9UágNÅdÉ Œ†üHøi©øS}/TNŸ4r.vH±É^Ì§æ‰²¯ü,Ö¾üYÖ|~·Zd„ÀÌöìw*ñ¸89	&É:€èq¸²ekï¿øçMñ¦›¯£ÉæBü2ž7þ(¦N©"<0Ã)e`OCEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQER7Jù¯ösÑçÓ<wâkY'Ì­ýÓ¾i%‰ã„CÆ 9ì?JÕ}EŠÛJÃ¨F?¡¯•?b½Kþ&š­«åžkxf,ØygÝš|þ¾³¢Š(¢Š(¢Š(¢°<mà½?Æ:\Ú>ªá”pßÄŒ>äÑž«$gG^U²¤ƒùññ'áÖ¥àYôDÊ7Ç"ýÙä,©è­‚1¸(r6–úCöMøÁoqd¾ÕfÛu7ØËž3ó`ìOï!mÆ$ãt$*Ý•Jžkó·ã§†Ç†üa©Y +žfNŸvoô… . 
de€UBƒž§é_ÙÇVðüºÍûí5ó'“„ºã<‘¾d}ÀGÀ÷êl’,j]Ž“íÔŸÀWÀ¾(×âÄ%.Çì—·‘[Eœñáp?<aäà‚Ûƒ}ïik¤Io„Š5Š8@Úª`  
–Š(¢Š(¯ý¡>Aã›Õ4ØÂë–èJmÀóÕA"		Àó:ù“•c±‰ˆKû+|]OÝ·„5§1Û]I›v|“±ØÐ¾ãû´œ€ Æà0lyƒ`š(¢Š(¢ƒ_žŸ´6GŽ5cßí?û$x¯£¿cŸË©xrçI›Ÿìùÿ vyÇ—0óU2Iû²	p P¨ää×¾ÑEQEQEQEQEQEQEQEQEQEQEQEsüeã}ãCÔ2a”qÖ9˜¦LóFø$g¹FÊ±ù¹¬é²é—“YO,<lÈÜŒÑ¾àÊp}1ÉëTó]_Ãß‰z¿oÆ£¤LQ›TnRU>\ÉüC¨W’<’Œ9S÷/Â/WÄ[0ðƒQŒ~úÕ˜ôÒ#ò™a=œ(*r²*°çÐÁÍVoˆ|9§øŠÍôÝZ¹µ—ïG ÈöažUÔò®¤2žTƒ_ümýšïüeÖ4b×z2á‹õ°ç¨œ Ä1p£ŒþùF<Ó›ðGö€¾øy!±»F»Ò%;šFäc÷¥¶-òîaËÄJÇ)ÃG$¿Û^ñn™â›Ôôk„¹¶pÊy©Iá£tdp¢¶ÍQEQEQEQEQEQEQEQEQEQEQEQEW9ã¯ i>7°m3Y„K%£ÆÄ`KQÇ·ÊÃåpÊH¯…>/üÕ~Þ*]>ÊrD7(0ŒG&7^|™ÂÆ2J°É‰˜)UÅøyñUð.¢º–“)FàH™ù%@såJ§*Tò¡ñ¾,îF þƒxÇw4¨u-ÃG Ã¯ñFàðÈ:«ÆN92á×*À×EEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEÒ¼;áMºj?<Y¬Q$MªÆæÂ¨F‘“¡Vòs†,£Ôû•Eyš‰z²•ˆ :ø›ö]¼mÇ‰¦ÌÄ4Ñ\[§†dùÆG Á#.zgŠûxt¢Š(¢Š(¢Š(¢‚3^]û@|)Çº‹dU³%±îÝ¶äðÎ«µrp²„~Õð4rÍa8d-±° ä«) äa‘Ñ‡PC#Ž0E}Ýû9|[><ÑLï»V±Ú““€dSÄW 2ø)(‰Q³€Â¼göÓÐÍŽ®¡±ulb'»¡bÀwys’Û‰*íèkÉþüG—À ƒWP^cW‰ñæêèBËã.›r7×èf­Zk6±ßéÒ¤öÓ(dt9‘ÈÎ àƒÁ ×‡~ÓŸmô6_èó+êwjcœÆÜÁpJýÙæD\îD-)Ÿ”þë0i%Óu+¶Û½Ü2H}XolÑî<ð žq_¥1H²(t!•¹r<‚pG ÷§QEQEšøwö¥øv¾ñ/ö¥ší³ÔÁœÑeý%ÌË:òH.ä ôÏìûãÆñ—…mnndó/­‡Ùîy.˜	#tÉš.\ã±Æq“é4QEQE|=û]øu´ï=øGRƒ€ä	 Ç'c$¶dÀÈèŸ±‹ö]a27o¶8ï²ã®3Æ}kéÚ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š('kÂþ5þÒšo† ›GÐ$z»©Mñá£€Ÿ—.àâIÔd¤)œ0R‹×ã½#Âš·ˆ¦Ù¦ÛOvä€|¨ÚNXàuæÎYÙW;²F:†øãEŽ“wþÂÿ -ùÿ ÕÃjZUÎ›3[^DðÌŸy$RŒ3ÈÜ’qF	\Š—D×/4[¸µ:V‚êˆpU‡ˆ#åu`UÔ•pTâ¾×ø!ûHXøÝSIÖLvšÑá@â9ûæÄì”cæ˜“ÃDÎ¤…öÚ(¦ÉÈ¥Vy ðAx5ó_Å¿Ù"ßRi5O2[ÌrÆÉþXÉã"ÞA“<•‰ÃC¸áLK_7xwÅ¾ øwª4¶Ëeyl•pvä4W?É&ÝÌ6¸Ü™¯ÊÇìƒß´®•ã†M/QÇWa…Bu)ÉâÞFùƒ€0ÊÎáå@${8¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÊñ7†4ïØK¥jð-Å¤ãú2°Ã#©ù‘Ð‡F”ƒ_|xø	uà¯·XïŸF±§–F<ˆ'#øúùr`,ÃŽ%?1ðŸâÆ§ðóS¶M¾Ýð³ÀÇ	*Çû’ Ï“0Œü­º"Ë_yxâ&“ã›©h’ùˆÙ†$±’ÆyVô#(ãæFa]=QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEÒ¾ZÑ®îü+ñ¶êÎ=ßgÕ$!Áà2ËÚU°2“4N¨Nù˜7ÔÂŠøSá-Å[eŸä)u¨f(ª}Ë2Æ¾ë(¢Š(¢Š(¢Š(¢Šø‡ö®øj<5âí›4ÛcªfL(ÀY‡ü|'  $ÊÜ.NYšl9óO†ÿ ¯ü«Å¬é¤L«£gl‘Ÿ¿ã¬@`pJ:«ÁÏcñ×ã§ü,Ód‘Ú}’+Es‚áÉy6†;‚®U PFI;Ž:W’V¾“âÍWHF‹O»žÝ$9a²Fãa cŽ2A$u5—,­!ÜÇ$óøž¤ú“ÜžOsMSƒšöï…_µ³àØ#ÒõŽ›Ûl‘¯M°Í†Š>ìs´ ‹"® úsá—Ç¿ü@”ÙØ´–÷Ø, œ Ì£«Dè^)00YU÷¨<®5é æŠ(¢Š(¯
ý°4(ïü'ó²YÝFTã$‰s¦r6ƒ½\õÉExìâ[?Æé‘“ö{ø¥ŽEÏEóã“!FPx;daœ +î1EQEWË_¶õ´atyö4ý¥w*Lú€Ä°ô5›ûÿ ÈGSÿ ¯hôd•õ½QEQEQEQEQEQEQEQEQEQEQA8®3â/Å½À6þn±?úC)h­ãù¦“ÆÈÁTG™!HÁà¶x¯•|YñgÆ¿/_GÐ š;3-m‰û¤c7·#bÄ7ßx  ,œôï„¿²e¦›·PñžË»Ž
Ú¡&$äŸß0Ûç·C°*Â§v|Ìî¯¢,¬`±‰mícH¡A…DPª U øTø®Câ/Â½Çö†×X„UHŠá8–2{Ç']¹ÁhÛto¹Oð¯ÅÏ…ÿ 51§^°š)Ì†tR«"çk§;$FÀ’=Í·rJ°Ç­Ü§üãòìzƒÈ ×Ò¿jYôö‹Bñ{™¬øHïåâuEÇšÆeÏ›É1rËõ­ô°¥Í¬‹,(dt!•ä2²ä0=ˆ$TôQ^MñŸö|Ó>!¡¾·"ÏX@ŸYðæ1‚ÿ )*’©Çòà²‡âÏø'Zð.¢luhZÚá~e9È`VXeLL€C)„|Ë
÷ƒ?µ„¶e43M á/1™ž>Ò2ÆÇ›ùŠÎ®2õõf©[jVñÞÙH³[Ì¡ã‘ee<†V³EQEQEQEQEQEQEQEQEQEQEQEQESÕô‹]bÖ]?P‰gµJIŒ†¨#õ`© ‚¯>5~Ë—Þ/«x]^óMåž/½4 ÌO{ˆW¹™Ö@7×’øâ&±àKá©hÒì®ÖV£‘zì•27¦y!Ñ²Q•·÷_Â/‹ÚgÄm8]Z‘ô@‹bÙhÛûËÞH“ `•‚º²ŽøÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEPFkÇ¼MðšþëâF›ãR¦É÷ÿ ÞF%8ÏÎ& #FCì4WÇ^$ðÊhíc‹ˆî¯íî×9ÿ –Ùi9lç÷«!È8Ú1¶¾Å¢Š(¢Š(¢Š(¢Š+øáàH¼gákËÚbC=»|²Æ/$,‹º'?Üvë_’®Öã€yCÈý2ŠP	àu§ùtþT†•?•7DÖ®ôk¸µ>V‚æ’!ÁVÎAã ©YIVI÷§ÀOŒñHg¹§fB\*ð91ÜF¹%RP¬
Ÿ¹":ò êQEQ^uûBØßêñªdƒÌ öòÙdgèQ›=x¯ÿ gkÇ´ñæ˜ñãæ£9ô’9¿:Wè(¢Š(¢Š+Ä?kEªøHê‡]6Uå$"	PÎôp2d’+Î?b—QÕþáý$ú«ëj(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¤w€:“ú“ôóÿ Å¿Ú¦ÇBit¯½¾\«Ü`Œàä¦?ãåÑ¿ºD Œ4„§œøcû9ÜøÑÅŸnn%’÷÷«n[ÈrQ®f<jês¼_•Õ,¥š5úGÃþÓ|=j¶E¼v¶ÉÑ"P£Ü¶9f=K1,NI$Ö˜¢Š+ç/Û;RÓ—D±±”ƒ¨›Ÿ25•ˆ+$ìFFËFƒ îlmèHøâ”GZõ/ƒÿ µ‡²¥²·Út¦lÉläàdåÚÝ‰Ä’pN~úƒ—¯·>üAÒüw¦&¯£Éº6ù^6âHœrÐÌ€®¹‚U”‡Fd`OKEƒã/é>1±:f·n·W<26
‰!a£pÊzpAŠøÇã'ìÝªøŸRÓ·^èë–ó†7Ä2 H¡@äñ<cË8Ì‹S‡ð“ãŽµðêçd$Üiì{i#a«ÄÄ¼ŸGãÍFÀeûwáçÄ½#Ç–+£Ê <Ø[H˜ÿ È	Ç íq”p7#k«¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŒW€|~ý›í¼Mšç†bXuuËÉ
ü«qÝˆ*]wWáf9Iy+"ü¢kšŸ„µ$½²’K[Ûg88*ÊÀáÑÑ€ã9Yama•aÈ#íï‚Ÿ´ÿ ˆp‹;¶šÄjB[åti-‰äŒòÑ7ï#ÈûËóŸY¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+åŒšŸØ~/é77`ˆ¡ûÜtÉ"’ýëàãÓÚ¾¯QEQEQEQE`øï]µÐô;íJõ¶A¼…ºUUAÆY˜…QžI¿3g?6=  þ¢­é:î¯:ÚiðÉq;ýØâBì}Â -VÀQÜŠö_	þÈÞ,Õ™_Qi°äÌÛß¸`€°Î@?<Ê6zåkÜ<3û"xOKPu>¡&Cïå§íA°n7g'	Ö¯ì÷àAÿ 0{üú½V¾ý›¼wˆéqÇœÑ¼ŠÃðÊùAôéY‡öTð7kiÇý¼Ëÿ ÅW|Zý’.´;y5_
Ê÷¶Ñ)g·pàXÄP¸y(U%Âü¦F;O•|!ø›uðï[T€`e1Ï8Fy*;	€x˜Žmo•Û¡ñ—ˆl!ÕtÉÖ·w¨#øYNUÔà«¤+FŠ(¢ŠÅñ®›§¢_ØÜažÚdpäq_
~Ï6osã½)""o4ý'‘ÏëÀú
:QEQEâµÞ¹ö}ŒnmºŠ#·*»®9È;Hˆtä¶L×„þÈÚ´Ö¾4ŠÝ÷wPOƒœª&C€q•tàpÀÆâkîZ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š('òoíEñÐ^³ø;ÃÓŸ%Y–úT8Gj®>cßi+1‡’	Q(®§àìáa§YEâÀ·:„ádŠ	W)ýèËÄß+ÜC6ðV!µCÇè1EÒn®'Æ<)áòukèÖãþxÄ²t$nŽåÇ&ÕÉ85áŸlc,FÓÁöí‘ö‹•‡U¸,7d‘ºfÀÀ"7Ñ|âïŠ—ò]Ã÷ó9Ì—·Èe{‰1í	yØ>UFâ;ø?c°Ì—zñÀó%?ýÈzŒJÅ×¿dÿ iALpEzõµ”uûÉp-ÛŒrÃ#9çâß†ú÷„Y[²šÔHÆuù[9ùVXÌ‘$¦ýàcåäfïÂÿ ‰úŸÃíQu=1·#af…Ždì“®Ö^L3º&?Åt? Þñ}‡‹t¸5-ÃÁ:çÑ¿Ž) û²FÙWSß‘Á¶è¢›4I24r(d`C2<AÈ Ž#u¯˜~3~ÉËqæjþUFåžÇ <dýº)''ìò„“å¼|)ù¿@ñ±à]Uo,ÚKKëV*C üðÍc*Hýä2HÁÚãì¯‚ÿ ´~™ãˆãÓµB–ZÑ lÎ#˜÷6ÌÄÄÆ;×8S"Õì¡³KEQEQEQEQEQEQEQEQEQEQEQEQEx‡Çÿ Ùé<x£WÑ|¸uˆÆ7Ê³¯ew ì™?å”¤ ˜äùJ²|_¨iÚ‡‡/ZÞé%µ¼¶qÀ££©Ü¬¬¤nGRAÆQ™y?U|ýª!Ôü½Æ2îËáÂ£vuŒ,RÀ™TE&@a}ï¤ÒEpNAäúGÄu§QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQ_$þÙÇO×´½fÙÙ.³€{‹,L£ûÁæ$ç í^01_ThZ€Ô´ûkåˆc”×çPø8ã<óŽ3W¨¢Š(¢Š(¢Š(¢¾Bý®~+=ýøðvžÄ[Z{’3óÌ@xãì-Ð«œ™œ3c|ý›aî¼ïo¥†ÄIOƒ—`ä.Ü“z‚òû«7Ö~øy¡x6o¡ZGlîd|tó&}Ò?¯ÌÄN5Ñm´QE#t¯‡?jï Åá¿ÿ hY Ž×RO<*Œ(;n@³1I±ýçà“è_±gŒ%•/ü7;îÝBg‰ŠáT¥„raFÐÌìp[Ÿ¨¨¢Š(¯?øçãøüá‹«ã†¸œ{u=’ °ÈÊFåpJ¡šùö@³K¯š=þE¤Ì¬GÝ$Å
6zd2/¸-ŠûpQEQEÅ|bðž™âOÞÛêà¡‰çI3ƒÆ¬É*·N«)*Àƒ_~Í—Íeã½0Ä2$wŒi"}ÄºWò¯¿…QEQEQEQEQEQEQEQEQEQEÉ“z”ÉduçŒqÔ{×ç&‹¦YÅâø,u)­ýc•ß’Qg1³>A¾Ðd89,Ç¡&¿GT 0:
	Åpž6øßá_e5+Ô{‘ÿ , ýì¹Á8)DyÆ•£\‘’3^;¯þÛÑº>˜Î~ošâP£ýƒåÂ²1ÏVFd# ló^'ã^/ñK¸»¾’çÈ¼˜Àà…Â•ÆTd•‰9<+T|ðwÄþ5`4«70pLÎ<¸FrAóœ!ã¤+)Ã€ƒ_E|:ý4Ý1–ëÅSýºQÏÙáÊCž?ÖHq4Ã9àyHG‡šúNÓ-´ÛxììbH-âP©jT U\  ôdQ´Ï×¼?c¯ÙK¦j­Å¤ëµã~„ut*Ê@*ÊC+ ÊA ×Íž9ýŒQÄ—>¼9Ë0·ºêA—( åS,rgåÜùË.ðüKðK\k=NÞXá}¦æÒ^§E–'Œº`ˆ®#f¶˜¤;q³íÏ	ø³Oñ^Ÿ¯¤J&µ˜pz#ïG"õIPðèyÔkbŠ(#5äß~XüE¶ûU®ËmjÄs‘òÈ:ù;FæCü¼-ÊåK#|IâÏêÞÔMÕa{{ˆÎpÝd…–'ÄH;eC€Gð8Àúà_íJl’-Æ23À $W‡,È8
—XÉxÀãí}@paûÊúÂ	ÒtÆÁ‘€ee9ApA Ž9%QEQEQEQEQEQEQEQEQEQEQEQEf¼ÛãÁ+â=¸y¿Ñõ8¬7*2qÔE:ñæÃ»	,be,ÙøgÆÞÖ<~Ú~³A0ÉSÕs·Ì‰ÇË$MëÃ.vHªÜQøûJ^ø8Å£ë{îôq„^s$ÖŒËvlªä·YûGGÖm5›Xïôé’âÚe’FAR¡ýAÁSÁ Š»EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQ_2þÚÖq}—H¼+™VIÓ?ì•W*~¬€þéŸ³f´u_é¬ûwÀ¯nBöò£MÙ'cätù†8ÅzuQEQEQEåÀ·‰æ#!›¸±øâ¿6­,î|kâ5†"EÎ§uÇ’w.\ýÀYËœ¡Áú=¢é6ú=”:m’„·¶bGePGä9õ<žjíŠ§§ë6ZŽÿ ±OþS-Õ¶°á‘¶µê«€æŠ+Ál]oü/¢Y]/\ò³(Ç|Æä‘Ñf¼‡ö8²¸—Å’\D?s¤¾aÆxv‰Pg#	g„ Žs_l
(¢Š+æ_ÛgWU±Òô°ü¼³NÉî ‰¶00Ó2œÙÇ…ûZ»jZ¥À»ŽÞ'ý¦wu÷Ê}+ëz(¢Š(¢¼Ûã÷ô¿xZúßQ‘>Ñ{o,0Byi—g>o-7#ð¨:œÌß²5€¼ñ²M»f¶žQÇ^#ƒþþ»~}F;æ¾âQEQEQEQEQEQEQEQEQEQESdMà¯@F8ü¸>¾•ù³ñÂ7þ×®´»ØÝeŽG(_“$lÌÑLŒÖ¤‰ÉaŸ˜:¸k²ðßí-ãMÊ=:;•’€T7+²¨ ,bV(ÌªÊ»ŽFò 3Äükã‰M´——©Éò-²«Ž3˜­A‘”`»8¸cÃ³—|@AKµ‰¿ŽäˆW±©Ì­Ãqˆ°y¯oðOìe§YìŸÄ×tã“¾c·ÊÓ6gpyO'< ƒŸiÐ~xcAT];LµˆÆr¯å)px¼×!8ÕÓÇŒPŽ ÀÐS¨¢Š(®wÆþÒ<kdtínš>¨Ý6ÁHd2:äã)èÀ‚E|¯«h0ýŸu3¨ér5Þ…#¨'º“9QÔ@“ÂˆçL!ù±€}Cðóâ6“ã½55=PÙ K#Ì‰ûÇ2g*AÎÖûŽäfRu4QA®_âÃ'ÇzkézÄaŽUÀ’'þ!r	VªòŽ2®¬¤ŠøwâßÁcáÍÞéÁŸOvÄ7H0¬z„uÉ0ÍŒþí¾WÁ13•}öý¥?áH|3â\¶š¿$7Å è#‘q™-Ôò2CÆO¯týFßQ‚;»9kyT<r#VSÈduÊ²‘ÐƒV(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(®cÇß´içMÖâódÇ"ñ$lF<È\r­Ó*rŽ×V^+áo‹Ÿõo‡7j—€Mg1>MÊ#ã’Œ§>TÁ~c$“2«_„_uo‡W…íÍ±™žÙÈøàºž|™öð%^j‰UÔ¿s|<ø‘¤xóO]KH“=¤…ð$‰»¤¨	Çªº’Ž0Qˆ®¦Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯ý±´W½ðœqÍ¥älÄœ’+ÀBúî‘âÈãžØ5ÿ cMFK]Ú¾6AxJã¯ï#ŽFÝë†éÓŽ;WÐQEQEQEW!ñ{XmÂZµôlÉ$vr„eê”Çç]ÔçœøOàåìV>0Ò¦¹m¨—°8'ùc¦N72ŒöÈ'ŠýQ^uñ÷ÆsøKÂ7—Öm¶ê]¶ð°ê­)òË©äŽ2ò.x, df¾ÑüI¡\­*ymeR0ð¹CÇ@Jcx=Ã†S“‘ÉÏÕ ¿iÆ×'OxºE[¹[k¢‰ð ¸“±æ) Xæ'Ë*’…ó>“S‘Í-x÷í[ÿ "=Çý|[cþþ-x‡ìoâ+{Ï§Lq-õ±H«FÞqLz˜Ë0ô¶{gíEQA8¯ƒjO§ˆü_<P9h,Z/<nBZá€É31Œ>P>PO°þÅZ[é:–¨Á€¸ž8FF&æ*OÞÃÎÈØÈq×5ôQEQ_~Ù—r¿Šá·f&(ìbÚ½y&/ÿ }yhOû¢º¿Ø—JŒÿ kj'>bˆ!1ƒ¾f9ëØqŒqšú¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+ÄžÑ¼M‡Z³†ñå|ÔG•Ì ÷ €{æ°ôÿ ‚¾ÓåÛi‹"çÄ¯‡Ü::p8®®ËJ´°EŠÎáEU€= P Â­bŠ(¢Š(¢Š+7Ä^±ñ„ÚN©šÒå
H‡¸ìAee8du!‘€e €käOü"ñ7ÁkáâÜ¼ú|L3(áÐu{ÂK+KÄeŽJÀÄI^×ð¯ö–Ð¼d‰i¨²iº¡;|©÷rÆÞfÀ;²•&Ù8Æû
¶á‘KE[RÓ-µ;y,¯bI­æR€ÊÊx*Êx ƒ_!üyý™ŸÃªþ ð²¼šzÒÛ€YàóÒ6ÉymÔðÀƒ,—Œœ'Áÿ ŽÚÇÃ©ÖÜ´iLß¼¶sÀåžÙ³¶	NIã0È~úƒûÁö÷|}¤øßO®‰7›J²‘µÑÇÞŽXÏ(à`÷VR)ôTQEQEQEQEQEQEQEQEQEQEQEQEšÊñG…ôÿ iòé:¼B{YÆOnêèÃ”‘He`5ðÆ_ú§ÃÛÖ;^ãKþæä/‘O·ˆîL$ßz.Ixÿ xÛRðv¥±¤Jb¸ˆãÕYOß†TÈBøùAÑ‘Ô0û¯àïÆí7â5¦­¶©ýí±lŸúë82B{ñ¾6$‚Þ”QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEW'ñ_ÃGÄ¾Ô´”Ç™5´ž^zoQæE“†Àór@'Ç5à±. |ýbÍßï¥´È™÷•$p:q˜‘¿à"¾«¢Š(¢Š(¢Š(¢¼¯öšx¼¨›|üÞJ¾~C*		ë€©ì9¯c•£›x%[=GP{0ÆTàŽG r+ôkàÿ ŽÆž³ÕÉ{'—8¥ä”c¶HÞ¿ì°#‚+´¢¼Gö»Ýÿ hÇO¶ÁŸüükášr6ÓíþÏê0y¯³¿f1øŽÞk’íH“l»dÎ‹ÎÆcÉ¹9$Ì‹ægxp>ƒÜ+À¿lo¥†í´¥+ç^Ü«m=vB¬ËÈÇï|¤$ƒÄExŸì•¢Å¨xÖ	å'6O:ŒN y 	ÙîP:+î 1ERŠòO­<`ön$×.ùH>P?(¹˜s€§˜£#t®1€Ù~-ðo„u/ë1išr´×7IgÉ
3ºYç~NÄÉyòÌB(,ê+ôGÀÞ¶ð†k¡Ys¬awcØüÒÊØþ)d,íîÕ»EQEWÂßµÆ¢×^7ž x-âî
´Ù>ù˜ êÿ ±=£¦“ª\õoqî‘îaø	Só¯¤¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¨æ&Sª`‚2<AÈ ô ðGZù—ã¯ìÁi¬þ!ðŠž%2Íd ²°¼l¿1V\–Ø12‚±Û ù§ÁÏÚ;Vð;­–¦^ÿ G8Y;ž?{Y†3ZÞVØqò˜ßfx?ÆúOŒ,†¥¢\-Ä±÷‘°Ç4gæŠ@Ê¸¸È Öè¢ŠF\õ¯Ÿ~2þÊÖ~$i5ì³Ô‹Éq¤ã,˜ÏÙ¥nK­ŒrÈ­—¯ž|/â|×÷ÍÁ0ÂÏm/	4yû¥—r6ÞL713ˆ˜ã%ÐýÃðûâ6“ã½55MPÀŒI$‰¿Š9UèÜ£Œ23)ºŒÑEQEQEQEQEQEQEQEQEQEQEQEQTõ"ÓY´—OÔ"YígR’Fã!êýA*@ ‚¯Š¾>~Î÷^
™µm^ãD“’yg€õ)9ä˜Oü²¸=?ÕÌA	#øÞ‘«Ýè—Q_ØÈÐÜÀÁãt8eaÝOcØŽC•ƒ) ýƒðGö¡´ñÅ£ø­ÒÛR'b\p±LIU‡H'làƒû©%I¡ÍQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEøÛà~§/„þ(Üè“n	s5Ý£ùrUžâ*Ã8/ä¼Õ#+Šû&Š(¢Š(¢Š(¢ŠÀñï†—ÅöˆçîŒÙˆýÛuPv¸VÁ `ñšüÔÔlæ²¸’ÞåJM2:žªêvÈŒ;2¸ Ç¡éß þ6KðçPxîU¦ÒîÊ‰ãTŒ…žH_5AÃ¯r ¤‡DÏÜ>ñž•âË5Ô4[”¹€ÎÓó)#;%CóÄã?28ÛÍxíw4iàÐŽ@f¼€($rFö8ð “Žƒ“Å|3]·€~kÞ;Žê]
2Ú(g,ácÊE•¥u‚åT.:–Pycö­"ë¼·ºú|ÈèêpAû²G"0Á2‘ùû“û\xÎÂÕmd’Þå”`K4$ÉÓsG$HÄuÜÑå-šòïxÏTñuûêšÔíqrà.æ  £•p±Æ¤’@‹;nbMz§ì‡©ÛÙøÉcÂ5Å¬ñGŸârb•P›ŠÅ!Ævàr@?qƒFhÍpúïÆßè7²iš–§WPŒº|Í·¾ÒcV]àrcÎñÝkÂ~.~×M0m;Á@ÆòEùˆÿ §h›;LM2îë²._>è:±ãÝ]líCÝß]¹%˜’IêòË#g
 î’Fá€2QÝ¿~iÿ 4ÿ "M¨LÚ.1÷ˆäG<¤IÚ¹ËœÉ!,xô:(¢Š(¢ƒ_~ÓÚ„w¾:Ôš,â6Š#Ÿï$H¯l‘‚qšúö3³–]Ë*•Yoœ¡õ1>ŽŒ§8äzW¾ÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEçž;øá_+µå¢ÁvÜ‹‹p#“8ÆX²QÏ+*:“Ï^kåÿ ü=ñwÀíTk:LÎÖÔ%Ô_qÁÎÛ{Ø3ŒñŽO¹|™L*ýAðkâýÄM1fVHµ(@6àò§§™?3A&2­ÎÃ˜ßæS^‡EW/ñáÖ•ã½9´½^<ƒÌr¨dMü2DäÑ”åIWR§ñ7|9â‚~"1i÷rFûwÁsTI%~hÛtmµ†Ù`1ðWÔ¡þ~ÔšoŠ<½/Äe,u6!VNÊO@û<§¦Éc·¹$(÷ÀŒŽ”´QEQEQEQEQEQEQEQEQEQEQEQEÙ"YT£€ÊÀ‚È ðA‚àƒÁñÿ Çÿ Ù¢}"I5ÿ 
BeÓŽ^ktå ÆYž%ûÒ[wØ»ž€4XüâwDqÓü?‘ñé^ñð[öŸÔ<*bÒ<@^ûJÝ´19šyýÛ6ZxÁ<Bí½W' ëì_ø—Oñ-„Z¶‘2ÜYÎ»‘×ò*Àá‘Ô‚®Œ£¬VQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQA¯þ0Íkà¿‹VšÍÇò=­ä˜'€wZÊÇ9Æ<­ä6Ž95õú8`èy´QEQEQEWŒüjý›ôï;êÚ{=`¨±û©±¦åToór«2ÛHYŠªãŸ|6ÖüsöMnÕíØ’(ü‘˜¦\Ç&@ÎÐD€}èÖ³´ê^¹š]Ä¶·Æø˜«`sµ±Ã¯åpËŽÕé~Õ>;‰õ| 2ÖñgŽ2HQ’z“ŽMqÞ:ø©â4g^»{…‹;
ˆ¹$EUÞÃ†s– í.Aäkê¯Ø£Ä–ÔôFÀ‘–+•ë’0H1Ó˜ÎrdÆ¬ßÛá§Øo¢ñe’bÌEq´p&Qû¹:yñ„÷’%^¾g¢¥¶¹’ÖEž)"ÊÊH ŽU•†YHÊ²Àò5ê:wí9ã«VÝ5u^†X£‘¿àR:îolò=M[_Ú³Çc­ò­¼_ÑEgë_´§õ{w´ŸQtò’‰`‚
ù±()¬§§Ì1^g%Ë¹,Xäœž}É<’y'“Îk_Â>Ô|Y¨Å¥iQ®g<(ãâ‘Øð‘¨ÉyåP;¶ýëðwàöŸðëOÃ‰µ€ûEÆ9cÔE<¤sµz¹ýä™sÇ¡Š(¢Š(¢ŠF¯ÎÏˆÿ iñ7ŽoáE}Æ£$(;æXóŸRªOâ3Þ¾õðƒ­<£[hVê­“icÕÜüÒÊøþ)$,ÇÓ8[ôQEQEQEQEQEQEQEQEQEQEQEQEQEQEQESVÒ­µkYl/ãY­§R’Fã*Êx ƒú àŽE|añgàîµð—R_xfYNœŽ+„?<‘ˆ®qÃ#”;)Št>\à7-í_ioH4miÓWÇÈTâ9Èå„jÙh¦Ÿ%™÷ Z7l_p¢Š+øð»Fñý˜´Öc%ãÜa™$ˆ°Ãßlñ¸hßjîRTñÅÏƒ:·Ã›â“+Ma+Ê¯ÈýÄoÔG0æ…¸m¥¢,¼/Wð{öžÕ|åéšÎýCJ [3D8Ç‘#“æF [ÈGaˆÃöƒ|w£øÆÌjÂ\EÑ€áÑº”–&ÃÆã=õRAôQEQEQEQEQEQEQEQEQEQEQEQE„f¾nøéû.E«™uß"ÃvAy­	)ê^ßøbº4\E)ÚG—&æî­$µ‘¡™Jº1VVG¬§YO¤SÁ»Ï„?µ?‡z€žÕŒ¶r·ïíÙˆI °íà²`:²nBvýëàßi¾/Ó¢Õô‰–òŽ}ø¥N©"O³.T‚wh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šù»öËðƒ]iö>"ˆögki€ÇÜ—˜ßž~Y Áë(ã šõ_Þ1OxNÂüq4q‹y‡¤‘b'îÜ0
ë’IVç"»Ê(¢Š(¢Š(¢Š(ª:Æ‡c­[5Ž§w6Ï÷£•C)ÿ €°#>„r=kÂüiûè£<úòiÒœ‘~öòpbxÁ$}ÙJ¨*s^#â/ÙWÆšK‘ªÞÅ»í¤VÏpLr˜]zsœ€NaóWœk¾Ötÿ jÙ\Z€Ås4NŠH;NÙ|¶èUÈ9IÈÎpz×§~Î^(>ñžŸ!ÿ Ws'Ù_é0Ø:•,¢&ç  Ø±_søßÂvÞ.Ñî´;á˜®£dÏun±Ê¹Š@®‡t=æÎ½¤\h÷³i÷‹²âÞFŠAèèJ¿aÁ#*p2¥OzÏ§";W“þÏ©<kDøoP`—Ÿúdÿ üE2ÏA½½o.Ú%}Û0‘»Ý6aTÙão\ö®ëÃß³¿5ÅA¦M0bÆ!èvã~èh×#qÉõ?þÅ×Ó8“Ä×‘ÛÅÿ <íy!àpe•V(È9ËÈ1¤<ðÛBð=±µÐ­–ÿ ~BKHç®d•òì3Ñr…Etø¢Š(¢Š(¢‘ÎOjüùð$Mâoˆv²JDmq©ùÍ´dæ½Ñ
	èL{FO æ¿A…-RÖõ›]ÎmKPCkn†IôU“’}€“€¨|9â;ØC«iR‰ìîtnU€e`A¬)iÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEVÔ´ë}JÚK+ØÖky¤‘¸Ê²°Ã+)à‚:Šøóã‡ìåuà’Þ$ð¶ù4¸ˆw@XËoŽD›‡Ï$°&Î€aŸr!‘{?ßµ(¾eÐük"Ç?Ê°Þ…nŠì•$'. X¤#eÌŸKE*È¡Ð†R2äØ‚8 úŽ)ôQYÚÿ ‡ì<Ag&™ªÀ—6“<n29SêXF2°¤|kñÃöh¼ðx—ZÐ·ÝéfeÆd·^¿½ÆL°¨Ïú@‘Gï†›^QàßêÞ¿]KH Î9W^—*}Ùbn>Vú£)ù«íƒ?´.—ñ5²»Ûe¬æ~I0q¾ÖFÁ|‚Bß½C‘‡Q¼úÞh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š("¼{ãoìõaãøšÿ OÙi¬¨8“oÉ7¢\íù·vI×.€ÁÓå¯‡üAáÛïÞI§jp=½Ì,Uãq‚N¿uÑ±”‘	ŽEÃ#k¨øWñwWøyzn´æ˜A!;$QÓ8å$A‘ª&véò¼>üDÓ<y¦&«¤¿vX›â~¦9 ÎtaòÈ˜t$êh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢¸ŸøGTÓ ]ó=»¼j $¼½E°vM»²#šñOØ»ÄñmÔôVRÑÝD¹ù™Jˆe v=°ç¸ó9¯¨A¢Š(¢Š(¢Š(¢Š(¢«ßXA}ÚÝF³C *Èà2°<ÊÙàŠø3öŒøW€õý– :ñÐüí– ÝÄNWgq¨bp	óMüé÷‘]¸Âë Æv0—nyÆí›sÎ3šý=Óoc¿¶Šî9‘dRAqƒÁî+äÛÀ-§jðøšÝ1o¨.ÉHhÇV9ë4 Ç&É9ùÊ½à>¿¤h^-±¿×ÂýŽ6l³Á©X¦eç"' –ÁòÁóGÜãô:	VdYc`èÀ`r<†R8 ŽAsK	|µ““€O©ÇSïOŠ(¢Š(¢Š(¢¸ÏŒ^/‹Â^¿Õ$?¼4Q/'t²~ê%Âàãseˆ<(-Ú¾Dý–¼:ú¿­gº’w#€6¯“à–’N‘œ9ÉÚE}ÝEy¿í©¦Ÿà]Qä¼Ø–ïJé“œ|¡˜ï€p	¬ßÙlîð-›zÍtò4•ëTQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE6D6°È<{ú‚;ƒÞ¾døéû/E:Ë¯ø61ˆ¥¥±Eá±÷ž×±’ÖØÙ'>^Ç;[Ç~|vÖ>^GŽ÷:IlKjÍ‘´ð^Ü¿ú™S¨@R'åUˆeû§ÂÞ)ÓüQ§Å«i‰ífVAèÈêyIå]R"µ¨¢‘”0*Ã ðAþ£Ò¾høÕû)C¿WðZ,3—±TsÝ­YˆX_a8…¿€ÆÝ~P–­"ä¬Šð\Bü†NFAÚñÈ‡ý×SÊž†¾“ø7ûY½š&•ãVia^õAi.c@Z`8Q,HdÇ2£½}U¦j–º¥º^XJ“ÛJ7$‘°eaê®¤©CÇCÍZ¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(®âÇÂ+â5ˆ·¾ýÍÜY0\¢‚éžªAâH_øãcŒ€ÊUÀaðçÄ„ºç€®Í¶«	³b)Ó&):ãË“€Iñ*ŽpÀ†0ü5ø›ªøR]KKöe‰³²DÎLr¨ç ’QÇÏr¹•¾êøOñoKø‹§ÛÝ]E…¸¶bÆÇ¡ÈÇ™˜&)”mq•;dWEî‡4QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEPE|?â­÷á7Äx®m‹Ei%ÒÏ(;Z	dhG@Â1$‘:ÆØXç Ÿ·×§)h¢Š(¢Š(¢Š(¢Š(¯ý­ü5Ÿ
R5Ìúd¢\“å?î§	w$§åç’ ¯‡Wäo˜t<Ðé_ ³Š?á ðU‹»nšÐ5£ó“˜ŽÔÉ }èLmŽp‰Ít|Ž<?u¡Ë…’UÝÿ rUùá~8 a‘”,:üãÖ4».ê[+ÈÌSÂì’!ê¬§k¡ÆGÊÃa‡U0JœŽ¯xøûFÝøJXtm¼í˜(b~k|ÿ gø­Ôó$'Z–xŽË?lE2L‹,LV ƒÈe#‚äÁ)ôQEQEQEò§í«âÍÒiþ¾âµÜƒÝ³ãŒ/žFžAÁ'ìiát²Ð®õ§Qç]ÏåÎO—n:.fy‚w¤ò0>‡¢¼—ö¦PÞ½'¨–ØûýþDÒ~Ë Øç¼—'ÿ #Iƒô5ëtQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE×!AcŽsýOÒ¿9~5^iwž,Ô§ÐÊ›¸b…1´œ/œñí|¶ŸÌhÊäIÉÍ¾-ë_ïÖ—.acûÛwÉŠAÓçAÊ¸ lš<H¸ ïL¡ûáwÆmâ%¶ý9ü«Ô–ÖB<Åé—P	ÂIùeN9Ãl¨ïA¢ŠÏZòïŒŸ4¯ˆ¶¯mŠà¬w*?ÖGœ€ßë"É(ÝTü9ãOêžÔdÒuxL7ú«)å%Š@ ’&ìêÖ#©Zè¾|iÖþ\†°2É˜y¶Òå°Ï%@È”‚q,c$ãÌIí†?ô?ˆVûôÙ|»ÄPeµ"tÉQÒX8Ç•=ÖùGtQEQEQEQEQEQEQEQEQEQEQEQEQÖ´[=jÖKF¸¶”xÜdxèzFaÔkäOß²ÕÇ‡RMoÂû®4Ôå…ŽéaÎPºâSÉ9ž5\·š2GøÇþÖ Öl¬°Ÿ™rBÈ‡HdÛÑH0z0W	*Ê3ú	ðïâ&™ãÍ15]%øû²ÄÄo‰ú˜¤¿taòÈ˜t$êh¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯ý¬ô¨Ç‡í5ÕU7Zeì2FHêíhØžˆÌ#b;”éÞ ñÞŸã}"oK'Ê”a‘¸hÜq$RÌÆFU†IVôtQEQEQEQEVˆtxu½>çK¹¡º‰â`}Jwdg ààŒãŠüÊÖô¹´«¹lnF&Ú'í!1·P%I • ‘Í}ûø»Ê¼¾ðä§:˜¿ß÷SêÍDßð'9úØŒ×ÎßµÀñ®ÛIâÝ"ÚŒ
Ìiÿ -b@z«Á3À½@9– Tê•ñ³¡Sƒþ}þ‡·­ $Ž¢½ïà?í+7ƒQ4=x<úNàÇ/n	ùŠ/Y-Æw4#æÂ,}Ÿ§jVú¼w–R,Öó(xäB
²žU•†A‚*ÍQEQEPx¯ŒhûVñŸÄXtMÝ­íì$Ý,Î	ùbŽPÒô*Çõ<màýÓB²ÿ UkRÝ71ù¥”Æéd,çÝ«~ŠðÛ\{/ÛX 8»»Mç8b9V%²Ê„c+’{ïà=«Ûx#GŽEØßeFÇûÄ¸?ð%`}yæ»Ú(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¤g
7 rOó$ž‚¼Çÿ µ…ü+1³·gÔ®•ŠºÛØ„}à÷D[‡B±ù„oóÄÿ Ús_ñµ»éªiú|«¶H¡bYÁáÒiØ!hØãHÕ‡Ì8>_£øsR×§ºm¼·3Ÿà‰·¶UÚ=màtÅwMû6xì.ÿ ì©°~ü9õû¢mÄûœñŒñ\DO©ø^ÿ rùÖwö¯þÔrFÞàáÐãµ†2ké„µÊÈcÓ<j0N^¢ð=îâPŒŽf„’Ä‹–¯§¬¯à¾….m]e†EŽ„`y¬2#¸©è ×5ã¯‡š?Ž,N­Â%LîGkÆÝÅ"á”óÈå\|®¬¤ŠøãÀ]_áíÃMƒs¤³Ò.OH§@O“(#þYI•òØ11¯iZ½ÞsåŒ¯ÄM¹«)õV#Üt=Hâ¾¸øûMŸO‡¼XÊ—¯…·ºÀU•ºy3¨ÂG;ã1ºíŽc”ÛVO£ÍQEQEQEQEQEQEQEQEQEQEQEQE¥|wûQüAsâ½5O•±sð"‘ÏË"/E‚f;Jƒ¶9ˆÚHvøÿ ÃO‰z§€uDÔt×Àáe‰É*g&)G<uØào‰Žåà²·è€<ocã]"oM?º˜|ÈHÝŽ$†@::?Ú]®>Vº*(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÊñO†ìüK¦Ï£êiæZÝ!G!”õŒ#Œ¯•>xRøCãY¼«|ö·bù›ä³»„ FÉÁŽ)GÝÎ0Ù„ƒöh¢Š(¢Š(¢Š(¢Š(£ð‡íWáq¢øÊâx×lwÈ—C¦2ÃÊ˜ŒÓH÷@%#¥?Ùzþk_éÉÂÌfÇª˜¤r?ï¨þ÷Ø ¨=kâÚ{à×ü"ZŸöÞ•4›ö'¤S³Ã· ,R¬· œ7™ „ÒƒŽEz§Áú‡€/ã†iYôYý" ÁšyIPáÈBU¬¥Êµ}í¦ê6ú•¼w¶R,Öó xäC•enU•‡Þ¬ÑEQEQ^gñçâº|=ÐÚhN§uº;T=Ž>{‚0r¶êCí<;ì?7/û xR]_W¿ñ…ùiÆŽä1i¦ýìò±9}â2¹n7ßœeGÖ‚Š+åßÛ:9/o4=:' Ëö€œÌÐC7R 278é»Æ+é/i	£iÖÚdYÙkp®NNB“‚OËÔŽzÖ…¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠG‘QK1@É' I' Ô×'âŠþðºÕu"}»„aÃÈG8Ù[älà…Á8Éã>&ý´´ÈÇ¡XKpÊp$¸aœdn§›)R +¸#Á1šð?üqñOŽÇ©\”µ9u	ÎrA-/ M#ñü=IÎð¯Â?x°«iVÍcÙ ùÒùqíÇ#a`GÝÜx¯|ðìf±2]x²ë `ýžÔŸ®Ù.Xö"CèþŸFxcÂ:W…íEŽ‹k¬øc\dÿ yÛïÈÇ»9,}kc¸¯‰ô[ùZ´ \¨"+˜ø•	?ü´Aœ˜¥Ýw\à‰>-|Ö>]„»mœ¬D(0ŽG!Xd˜gÛÉ‰ºáŒLà³ü#øå¬ü<¸}£NcûËI„9ä¼G‘ßí¨(ùýê¼>àðÄÇVBÿ E˜8I|²FÝJKäc<0ÌoÕŠêh¢«jze¶§m%•ôI=¼ÊRHÜVSÕYNA_¨Á¯”>1þÉ·FM[Á Ïo÷šÌŸÞ ê~ÎÌ@š5#v  F“…5ÍÖr4r‚Ž„©AUÃ+)‚)ÁÀ8¯£>þÓw\É¡xºv–Áð±\ÈrÐº«+ýé-Ï Èå¤„òÌÑ’cúö)’UFÁ‘€ ƒAèA{Á§ÑEQEQEQEQEQEQEQEQEQEQEQEŸâ
Ó^°ŸJÔÌµº£‘}U†åXuV« Ã‘_ |iøEwðßUû$­çZNÛMÝÔ0uþ£Ê‰@á·	
ÅS³ý’|{&‰âQ¢ÌäZj‹åz	P·bÊ$‡½º0xPkíÁEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEy7Æÿ ‚Ïã™lµm"Híµ‹S÷¯‘¾ ÂB…Ð6‚ÞŸ/™¸zºS¨¢Š(¢Š(¢Š(¢Š(¯˜ÿ mOù¶šv¼ƒ˜Ýí\€:8ó¢³ž'U os‘^ðéí¼k¤<gÝ¢~6Š¹~‰ÑYúæ…g®YK¦êq,ö³©I#qÁõ`C+ ÊA ×Â¾Ýü;½ûD$Í¤Ü¹LzƒË}žlt™T¬ÙÑK8u¯'¥Š÷ßÙƒãgü"·ßØÕÆÍç;‡ä‚SÈpÇý\3œ¬£ýZJVO“s“ö”1Î‚XX:0Èe ‚=C‚=ÅIEQEUmOQ·Óm¤½¼‘a·…äw8UU™˜ž  WçgÅŸˆ3xóÄ7´¤ý›d
‚Ï”¸ìJæi$Èçû£j~Ï~›Â¾³´»n§s*‘­)Þ¨G8)ÄaýàOÀôŠ(5ò'í5¨ˆ:e±P¼v£>»ç/Èí¸÷Í}wExÿ íQsukà¹®,f–	£¸€ƒ'..åÃ †H;”uW¤øCVÆg¨‡}¢Þ)¯BYT±ãïgŽÕ¯EQEQEQEQEQEQEQEQEQEQEQEQE±üMâý+Ã­­\Çkÿ ‚}‘ywcÙQI=…xŽ»ûgè¥ãÓln®YI¤)Ù†æyy?ÂÑ#cŸA^ñ3ã÷ˆ¼~M´î-ì2qmà„tsd=ÁÇüôÄ`äˆ†xä¼3àoÅ2˜t[In›;O’™Qß Ûrw¸8çéïýŒï®BÜx¢émP€LbI=ÃÌß¹ŒŽŸ"ÈsÑÆ>ùàÿ žðžO°G¸ùÓþöLñÈiwåAÄjŠ MwŠ¡FÓü-QT5½
Ë\µ“OÔáK›YF9Tþ¡•a†SÊkâŽ¿³µïÞM_LÍÆˆÍÃr^Ÿ•.xÁL‰pàJˆfòŸx£RðÝÚ_éSÉkuÐàã©Cœ†B@Ý«!î¹æ¾¶ø7ûVÚkæ=+Å›-/˜íK…â	áD “öi ³1…Û;Y2}
’+€ÊrÈ#ô ÷±u„f¼Ãâ×ÀâmrTYê |·1¯Þô[˜ÁQ:öH•ÜqÐüWñá~·à+ß±ë”Ï1Ì™1H:“¤.â3ó!*gæ\|Ç²ø+ûDj>‘l/wÝèÇ9ƒ#tdò^Õ›NyhY„O“·ËnOÚÞñ®“âëÔôIÖâÝŽÒG­€Æ9Pá£‘CU€8 Œ‚	Ü¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Èj?	®»àÛ‹•MóiÌ·I×!Wäœv0³–È*6îÆåR>Óï¦Ón’êÝÊM«£ŽªÊC£€xÊ²† ðqƒÁ¯Ñ/ƒßâñÿ ‡àÕÀr	Šá,«øÆp’²Çžv:çšíè¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(ÅQEQEQEQEQ^mûEèÑê~ÔÕÁ-bá0!¢eu
@!ÈÁØ[‘_x\Ox‚ËTlyv—QJr	UÆóòüÜFY¸§ ×étr,ŠNA#ô§QXÞ.ð¥‡Š´Ù´}R!-´ëƒê§ªH‡ªÉa‘†aèM~x|Jø}}àMbmPd;£,‘œˆç@s…|Êyr+¡<ò¨¹<öÿ ?_Ó©â¾ÕcM^5/t«ènï
h
y]@;bžEb3Þª9Rxç~|MñÁmM´­nÚo±?2ÚKò‘“Äö¬Ùˆ6r	F0L>V*áX}á/i¾+°VÒ&[J3‘ÁSüQÈŸz9åYGqƒ[4QEPM|iûQ|m—\¾“ÂºL¤i¶¬RvCÄÒ¾¤Ž°Û¸Ø«÷d3ÁVì½ðÖx„Ýj
$±Ó•g‘O!Ü’-âpAŒÈò¸?xF«Ðšû¨QE¾:øË<¿ÅÛ;v¤ú|ßBR¶ÙSŸ­}‹Ex/í“}%¿„í¢B@šþ%lw%”g×Ÿ¯5Ò~Ë“¼ßôÆ•‹‘ç¨,sÂÏ*ª‚z*¨
£ P ÀêÔQEQEQEQEQEQEQEQEQEQEQEQFjËè,¡k›©(PeØ*Ü³1 ©¯ñíiáM´:i“T™N3,Žßh—‡¼K ôÈäxw‹¿k¯ë;¢ÓLZl'êW|‰y‘Œ¤+ÔŒžÞ9«kú†³7Ú5	å¸œÿ ®Îß@ÎXŽ00¸ÀÆ §økðƒ\ør!Òaÿ GV[‡ÈŠ>çt€ï‚1[¤9ÉØ>jú»À²‡…ü?K¬!Õo$ËòÂ0B[)ÚÃÞv•º01ì¶Z}½ŒBÞÒ4†%èˆ¡T}@ò«¢Š(¢Š*Ë8¯"{k„Y!‘Jº0YHÃ+)Èe`pAàŠøûãWì¯}£É&¯á(ÚëO$³[¯3B1œ 'uÌ ä(\Îƒh+(‡Îï1V0$äAÓ£)í^íðö¹ð‹Ç¢øÞ}òïoýÓW’Ñáù™Œý¤êÖºµ¬wö¤öÓ¨xäC•`zGäGPrb­ÑEdx£Âºo‰ìdÒõˆæÖPC+žŽŒ>hä^«"u<ƒ‘_|ký™5‰uuæ’	f fXTŸùj£™£\ó<k¹T* ×Ÿ|0ø««|<Ô~ß§0dphŸ.Uê…èéÖ”%FèÙýÉð«âî‘ñÉ®´Òb¸‹kyÞ™û­ò’'çË•N
°W£¹¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠÄñ¾›§¡ßÙ\bšÖdl`p{w¯Ì©þ÷Ôù€Oêké¿Ø§Äf;íCCwùf….N~ôgÊ¯ð’H·p¾^H\­h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+;ÄšPÕôË­5‰æ	!$uÔ¦FxÏÍÆxõ¯Ì{»g³¸0N
ºŽ8à®cq‘H`ÀH8ÈÈ¯ÐÏ~&oø?M¾“(‡Ér½	01êÙÉ “–ûÄs]íW™|yøEÄ=’ÝUukP^ÚB:ž­líDsà“ˆä	&ÒÀW–’Ø\=¼êRHÙ‘•¸ ‚QÑ‡fR[Üv5öwìßñêÚÅáiÂk0&ØŽÊ(ê¤ã1 ýì|—Uó£,<Å­øïð‚?ˆúJÅnË§jKÛÈÝ#[ÈÀ±K…;€&9ä‹oøM>j‚àÇ5Œ¯òãt3*’§É¸Qóm–drìŸzðOí•¤^‰-^ÊNòÁûØO˜§ÇÔä >öHî>ñ¶âx~Ñ¢ÞCw-Á#§œ:FC( :ÖÝVv³â=;DˆÜj—0ÚÄwJêƒßïœdgóŸÆ_ÚÂÑm¥Ò|Í$Ï”kÜmU«}”6ä8À™F€–{c(Ã·óŒ3Èì 
IáUFY˜ž€ÌrNNM}÷û<ü8—ÀÞŽÞõ<½BíÍÅÂ“’¥€Xá=³JªÀp¾+Ô(¢ƒÒ¾G]-<EñÊV„y‘ÛÜ¬®zcìðF×º\mQÙ°pzgëE|Ûûj_§iVÀY.%•—#?"lWÇ\/šÃ=2Ez—À4i6èw[‰˜7]Ò“;ðq¾C´v¯@¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( œV]çŠt«&tº¼·‰£ûáåE+ßæRÀŽ9ät5cKÖ,õhEÖŸ4w7G‰ƒ)ïÊHÎã¯=*åQEQEPMgê¾ °Ò#3êW[FbÒº ÂÌ~r:N3^gâŸÚÁšä‚åµ	W-ªî¿å»”ƒbr$#åaÔb¼¿Vý¶å/;JELžgœ’Gð°¦‘É˜À'­s¿í—â‹†ae²ÀýÛÈÀÿ x;ÉÏpläq^Yã‰Þ#ñ™[»–åÈCÄ`ú¬…ˆ2U˜v#&¹»k›ÙVQä™ÎTb{Eì~€óÇS^§áÙÆ> +Ú‹(}Óygˆ@y‰ÃdXó‚¤¡¯qð/ìu£il·>#¸mB@säÆ<¨z‚LòŽ9DVÎ+ß4Ý.ÛL·K;’x€TŽ5
ªEUP AV¨¢Š(¢Š(¢‚3^?ñ›övÒ¼ußX²Öy>h_’SŒºUäô
'Qæ ë½~Zø‡Ä~¿ðÝìšv§Ása‘Æì=¬r&Q×§°î>üoÔþ_¸Òå8žÙ›Ž¿ëa,vÅ:äóÂL>YyÛ"ýËàé>5°]KE™eˆà:ôxÛ1Ï&9¡à™K)ô4QHÊ`ô¯Œ¿i¯áË§ñ6‡:UÃn™‘ŒIn Ê[JH(NV)K!*Ž˜ñ_	øÇSð–¡©¤LÖ÷Qd^àýätl«£`nG`}‘ð?ö•´ñË®¬¢YêÄ,©ýÔä°‹Í äù,Ï¹~hÝ¹UöðsKEQEQEQEQEQEQEQEQEQEQEQT5ÿ ùÜÿ ×?ô¯Ëéú÷Gòîß±¸ÏŒœbÊÇç·ãúþöÕQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQE¿>?h¿ÆzŒQ¨X§\¨é07 ~ôK…Ç·“š÷_Ø¿Å‹s¦ßx}ÎÞE¹Nœ¬¿$˜ç'd±sò€¢D$œ}%EŒ3_.þÕ_ãÍñ¶Œ„»¯£Š h¸Ï»n@?t,Ár®[å½+T¹Òn¢½´Åq¬‘ºõVRsH# ×è7Á¯‹V_´‘wXõ0—PÊ·ðÈ áŒ`´MŒpÈNäjì5ÿ éþ ´};U.mdá£d}GuaÕYHe<‚|¿ñö6¹I^ïÂ,D’-î[k¯VÛÈdÚ¨&T`0ZfÁ'Â<Mà¿xíWT·šÎpw!ÈÜGO*â3µñ´MÃ ì^+Ð<ûTø§Ã1‹[Ö]JÝFÜ“æ`anW2âU‚r[ŒY°ýµ´g…ZóMºŽb>eŽHAôWv‰˜c¹~•…ãÛ<Ïhmü/fÐ\H3Ü²¶ÎÙŠYÕß*Ò:ª°GóV·â+ínéïõ)ä¸¹~²JÅÛ®@ÙÚ'
Uz*Åfä““Í}eûøkF–ÚóYm’êÐÊ#PÃ˜£e:g83’áœ @_+8¾ ¥¢ŠŽæam+`RÇ'“’z9=«æ_ÙL}gUÖ|g:mi›ÉS¸žecw:’@±Mºî9a´` Õôõñgí‰â®üRšq†ÆÕ}ÚlË#g®0±¨¡RŠ¾ÇÑlÒÆÊH‰)Iç®BŒûàsW(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š2*Ëè,£3ÝH‘D½]Ø*«1 ~u›ÿ 	ž‡ÿ A_ûÿ ÿ X^&øÍá/§™¨ê–ëXÛÍr	Ú
Ç˜äg©Û€' f¼‡Å?¶–›hæ-O’ë¨Nâ%è6°‰D²•Îr­å¶ +×#ñWí1ã_µ¶¸û2î]¢mb@&o2à²ŽEå’2JÈà®üâTï.tÛÁG‘íeÆ>ó;Èñž9Ü]›Üšèþ|a¾øu©¬‹é³2‹¨;2ô2 	âS¹`¸7%YJþƒÄâE9?E:Š(¢Š3HX“Ò¹O|Uð×„ãgÕõauÏîÃo‘Œ…‚=Òó/x'&¼ÆŸ¶’ÆÍ†lr>`'»8ç
ÛDKc£2T8à¨È5ã~$ý¢|i®—êRÅäíÀ…@<•ÌcÍ#ŽJ\á¹¯>¾Õnoåk‹¹i\åžF.ÄôÉi±8 g9àsÀªÌìÜ±'ëI^ð+àãüJÕÞY6ªâEÁl1+q†¾d…îu(ˆŒHf*+êý7öbð-œ^Tšy¹n»æ–FnÃWUŒ€ I®ËÂ_<=áÃB±†ÕŸï:®\õ 4¯ºB£'
_°®“ŒQEQEQEQEpÿ ~èÿ ,Å¶¦…."É†æ0<ÈÉàŽx’&ã|Mò¶X	üGøc«øQ};RˆíÉò¥P|¹W¨x\Œ->dg!Æ f©àoˆZÇ‚oF¡¢Ü42puWPCysFp$CŒ`Ë’ct9'í„Ÿ´†‰ã…ŽÆõ–ÃW#Sœ$‡¹¶•¸lö†B³@VqõüÑECygäOmr‚HeRŽ¬2HÃ+Á	WÄÿ gß<š¾ŒçE$ž/ ë¶|gtJ8KŽ€ &
pçÄ¡–Kw*ÊAr9‚à†Ôy¯¦þ~Öf‘hþ1,*-âó"ÀûRu˜ËOï xØåëêÍ;Q·Ômã¼³‘&·™C¤ˆÁ•”òrObX¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+ÆÚ¥¾•¢__]¿—6Ò³7\ § ’N ’H“_™3ýìz ? ýs_F~ÅZlrë××­Ÿ20«éûÉüûþåqø×Ø”QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEWÊ¶¿†Üiºò™#’ÙÎOT"x¸Æ>ëL	ÎIÚ1Ç˜þÍ>0—Ã¾1³]À[Þ·Ù%à“˜Ï%W1Î±°'< e…}ú(¢Šd±,ªR@X`‚2<Aà‚<_þÑÿ åðmëkZDYÑ._å?ÔHßòÁÇ$Bç&ÞAò©ýÃ…ÄEüïáŸÄGÀªjÚk²HÛîI ´Rc$@euù£p7+}ýðïâ™ãÍ15m)¸?,±7ß‰ðE Ær¬2²!¤ƒ]=PÖt+nÙì58#¹¶a£•C)÷Ãgu0AäkÁ|]ûè·òI>…w-‰nD2(–0xÂ«³ªc<Œü¤ŠóMcö4ñU³»XÍguãh<nÝ?‚Dx×ç3Ç<Wø—à‹|:—úmÀ‰IH×ÍN?ˆ´Bõê€çx®H<†8>ÞÇÐûÜf£­ïxÛTð…újš4íopœey§–ŽDl¬‘± ”aÔR¬7WÔ¿lm>í[µ´Ã¬öê^3Óæxyž#Ôžrúp=ãÃ>5Ñ¼QÚ4[¸nÓ¿–à‘ßŸ}†QÐúÛŠã>2kƒDð†­zJ)[YwœÎ<”^£,ÌáUAË1 u®+öIÒ¢±ðZË%®.§wÏª°·\z.Ï¾OzöŠ	¯<uugâïŒ1[Fw@·¶ÖÎTƒ–ƒ&2 H¦6ò¸8â¾Ê´QEQEQEQEŠ®#S†`¹^ïY³³ŒÍu<QF:³º¨àe˜€2x=k†Õ¿h_iglú¬.Ù ˆƒK‚89òUñÏO^Õšj_‡àgûHŸ¥¼ÿ ËÊª—Ÿµ‡ Ç“qqqŸùço Ç×Î~™¬=OöÉðÜ/²ÊÎòàmÎHHùçåÄ¸ôä‘ŒšóÍ{öÒÖ§]šnofÄdf™³žH·LÆ ääô¯ñ—Ä-Åó	µë©.Xr«!¯1À¡bN¤n	¸÷c\þýür´´?jšüÂ×J·–êV muà1ª<´Œ¡G$…æ½Çáÿ ìy¬jL·%™tû~	1$ÄcG0By³Ls‘´u?Lxá'‡<]Ñ|a§žfõ-3e†º›vQ]{(#Éùãsmý¿¨› ÔÝ]y!F Ì“Ë
¼mP½¿E|z/|?§\®ìIi|Ãî.r çÖ·¨¢›,«—rG$“€>¤ð+×¾>x+C%/5HÃm+éˆ8ÎJÛ¬‡n?‹§læ¸þØþ±Œÿ dÛ\ÞËómÜ(q¤¼…¤ÚÙíp%;W’ø—öÄñV¡½4Ä·°FÊã’sæLDy…ÿ RTòp2 ó|Xñ7ˆ]SQ¹X0*d*„7ÞT>\{N>áR p Ê[GÛú÷?2”×ªxoöiñž½j·°Ø˜¢|óäX˜ƒÈaæM¾…•IÏÝÇ%ž&ý›¼gáûswq`ÒÂ –0:ÌTrÉ$Æ	9T~Èåì»Ïùÿ >õë¿³oÅh|	®²ê.›|¢)Ûì*KC>ITfu‘¹q†¾ñ·ž;ˆÖhX<n+)È ò¬¬8*AÁ*J(¢Š(¢Š(¢Š(¢Šeø‹ÃwˆíNÖ-ãºµ“ï$ƒ#Ô2Ÿ¼Œ*êCÈ5òÆÙWQðù“SðÀ{ý;–1už!É9Ué1¯g÷À™«çò#ƒþéùƒpkèßÙóö”“D‘tÌÒiÎss!,Ðÿ ,æc¹ÞÔŸºç-nxba Çõõ­ÔWq-Å»¬‘H+)XC+‚äpEKE6HÖE(à#„w=Áà×Ìdd»i5O•Ûsµ“ªIù±i/H9ÛŸºá%â¾ZÖ´+Ý
éìud·¹„áÒE*Ê{dÄr¬	V£0æ½'àoÇ-CÀwñ[\Hòhr9óíñ»nîÖã‚’¡Ã2©Ù2î…Z¾îÒu{]^Ö;ý>TžÚeˆr¬ ‚?Py‚rŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠçüeãÝÁ¶Ÿn×nRÚ&$ 9,ärV(×/#tÈPqžH¯Œ¾9þÐ÷¾>wÒì¶ÑXÏ)_º÷$ó¤äFÚÎ]Ômñ’sÍ}sûønH,õ-nT!fxíãcžB$Ø @yT	ùÃ) ­}5EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEy7í?ás¯x.éÐ–Á–ñ@$qD¹Æsû‡àŒ7‚¾Òu	t»Èï-ö™`u‘w‚ca*ä	RPdddw¯ÓÍ6õ/­¢»„æ9‘dSê‘zjÍQTµ­ÓZ³—MÔbYígR’Fã!õîê¬0ÊÀ0 €kóûãoÂ›Ÿ‡šÓY9/e>émeçæ<£Öh2©.	È)/N#ø5ñrûáÎª/ [I°·0gýbà¯a4y&õ&6ù[åýðïˆ,¼C§Á«i²	m.PIôÈ=ˆ8*Êr¬¤VHVQŠá<qðOÂþ3õ;5[’0.!ýÜ£®2é€øÉ H®½±‚Aù«âgì«èÉ¨ø~_í+XÁf‹nÛ€£*‹˜î07#òä<ÉÅ|û$f3µ¸?çÿ ÕÏ äA¤«V:¥Í„Ësk+Å2ý×F*ã·!Wq×±Ž+Öü%ûUøÃB;™ÓPˆÒîn‡þ[ÅåËÔƒóù„ã½GHý¶m$FþÒÒÝcLêÀúçÎXHç †-‘^Oñ§ö‡Ô~"ªéñD,´¸ßx…\³HÀ;€ªB‚!PQ_æ.ä.=Çö?ñÝ¥þ…'†˜„½³•åUÏ/§ÌódÇ!xÜ.vŒOÏ_B+ø­ãëoè:Ìì¾r!Kt'—™†!G$üß3à±«9¾#ø%w%ßŽô¹æmò=ê31îÇ{;êÌK¯§ú(¢Š(¢Š(¢ƒ_3üwý§¯ü7ªÍáß¬jöß$×)sæ`–Š(ÎÔVäÝ#—ËåBaI>)ÿ Óâ±(Hõ;·“,!T‘ëåÛÄöŠ‘êEn.¹ñ…€#ûsŸúdÿ ün¹ýCâïÄ9‚^jWð1Ï±CÇbDBH<¹ÁëT¿áwøÙ¾oí{Óô—ÑqWn¿h\ÅäI«LŽSÊFãþšGÉõù¹ïšÇÿ „ËÅÚì¯0½¾¹cqYf|v«œ ŒÕ	<1â^àµ»¹¸sû©ÏâêI÷ËWoáÙ“Æºäk(²‘¶Ü5Ó,g9&,I60dWä ¦»/ö-×fÝý£¨ÚÃŒmòÖI~¹mÂã°ùéÅv6±^Œ§ý3S»‘qÒ4Ž3Ÿ]ÅeãÛoã]]¯ì£àˆbXä‚âR£Úâ@Xÿ xˆÙèª«è*Ý§ì½àKi¿`iqü2O+/â¬ø4·ÿ ³nä2ý¢`¤SH‹é÷ñ’:žõÐiß|§€ Ñ¬²à^‘0ò‡aŒp qšêƒ§•Øm¡*F1å®1ÓÇLqJšÏO·²O.Ö$‰8á(ãÂ€8AV1Ep<oÿ w…/5ÛmÌ©ö{~Ÿëeù€n–¥¥#åCÆ3_ž
Ùl?-£óâ¿J~êöº·†ôë»°µ¬@2úª*:‘ÕY]J²œ ‚3]³$CtŒtÉ8ýN+„ñ—ÇO	xR67—ñÍ8[‘,„Œ»c$!ÊLŒŠäŠù»Ç¶¿ª;CáäM6Ü,ÇœåÃ@™•Häà‘¿8#È|Iñ'Ä%O'W¿¸º®É$%z†ÿ V6ÆpÀ
¤»q\æ÷”ìôÈTÖš|÷’­ÐÉ!ÏÊ€±ã“ò fÀN0;×káß>1×ˆû&—ríùå_)pÝ4æ2W’ŠäJòô½ö/ñÐ/ª]ZÚ)
»ælç>ß% Ç!•ß®0:Ó<Wûkúm·Ú4›ˆ5PKDªÑ9ôò¼Æ’9\«ILI¯Ÿï,¥³•íçFŽXØ£«2²®Ž§]Xa”€Aü3©à›Ëk-jÆêÿ Ö+¨$˜cYåˆl‘Ð€kôÖ£XÈdpXr<©¸ ‚¥<Šù{öŽýœ¥¾üMá;mòÉ–»¶‹©n¦æøÏÈž4Ã;m•œ¸o•n¬ç²•¢™Z9Pá•VR;2°¬1Ñ€=úW¹|ý¤eðR^>OÈW—€“óRAx9,ð©Ü‡- ˜ëìÝ#Y´Õí£¾ÓæK‹iT2IR=ˆãê<«´QEQEQEQER^'ñ£öjÓ|f’jz*¥ž°y8ùb˜òOœªÉ[<\*î'Uuéñoˆ|9¨xröM;S‰íî m®Áp#†Fê’!(ë‚¤öôïŸ´çÃéMð{­C–„š6ÿ ž–ÛÈU'£Ã•ŽAÊíqóý¹áXxšÂ[I™g´w#¯äUåt``­Z(Åpþèÿ mŠù7qÿ ªºŒ1?Ø9’Éßü§ª•p|=ñ?á.±ðö÷ìz¤`Äù0Ì™1È=Qˆ\cç…¿x¼½NêO†ÿ 5¯^¥Þ›3y;³$ÇÊta$|€Hé*"Ÿ›-§î_…Ÿ4ŸˆÖMw¦ŽâÖò¾2sµ¾RCÅ&	ŽUù[N×VQÜÑEQEQEQEQEQEQEQEQEQFEpþ8øÓáº¥êŽÐCûÉOÁŽ<ìÈþ)J/#žE|ïãoÛ3U¼-†í£²‹ –oÞËÓ ì`Œ‚sŒÍŒ÷ZðoxËUñ=É¾Ö.¥º¿ŠFÎ÷QF4à‘ª/BA c¤¸ dç§¯ y' qÞ¿H>ø7þÿ ØèÌ š8ƒL}eÞLIï‡b œœ(8®ÂŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š¯¨ØÇo-¤à4S#FÀŒ‚`Aà‚ ð{×æOˆ4¶Ñµ;>PwZÍ$1³DAÆFHPISŒ“ƒ_z~ÎÞ*>"ð]„Òg¶Sk.NNèO–¬Xñß¾ÝÛw^•EQ\¯Ä¯‡:´—Ò5,¯;â•FZ) !dPxa‚UÐðèYN2üõñÇ‚ïüªO£êq˜æ…ˆÎ8eçË–3Îè¥Q¹I£|èÕí_²¯ÆVÐï—Âš«ÿ Ä¾õÏ’ìF"¿„–#\;n
 JÄ}’ih¢Š|“ûYüƒOaã"0‘Ï KÄ^‚Fâ;•_áóŽ#”.“d˜ÜÒóÿ ‚ü¨øÃR‹GÒ#ón&'8U eä‘ù	/,Ø'%UAfP}³þ¯Ä{söÛÞ™—ùìþ•ÈøÃö`ñ‡§[Q}d—´o0àcŸ!‚OÎO
’•‰ `Ÿ'žÌrpAàäpAA@ ŒEGVôÍRçL.ì¤xgˆîI#b¬§ûÈë†Sî#ƒ‘Åz"~Òž;E5Yp Ç	<qËrO©$“Ô’k“ñ‡ÄoÆ3%Î»w-ÛÆ¥SyT½åÇ¤h_{*|ÄOøoâHü7â^e-­Är°J©Ãã$„f`0K}êý$ÒµKmVÖ;û	kiÔ<r!Ê²žAR?QÔ‚jŠ(¢Š(¢ŠdÍµKz.kó^¿:ž¥szàšY¥ z³<‡¯'“Œžp~‡|/øy¤ø3G·³ÒáUvYˆýäŽT’Gå²I8@v"á WcŠ§©höz¤FÞþî"`AIP8 õ\ƒÇµr·üu/Ÿ.f_Ú £ñTÚ§ñx|-ð¨F‘c€1ÿ Ñÿ ñÐÚØÁh»-ãX×„P£€0 pÒ§ÅQEQEPN+ãÛâö–±†mŽ`Ó—|¸=f}Ò1ÿ ,`#ÙÝ1ÈF~s¿áÿ ëžG‹H¾¸´IXC+ '¦YAÚO¾=Éâ¢Öü[¬x·ê—3ÝCfiÀ mk’ƒ
HÈP@'žMgÛYÜ^È¶öêd‘Ïƒq$dð‘†fÀð§=«¼ðŸìýãáítùb„óæ\~å:2þñ#lDdŒ•¯aðßìQ.Íúæ¤¨ä}Ëh÷`çŒÉ9†:OV×¢h?²_ƒ4Ç\%Åñ~Yåùr99HDAƒªû‡Wªè¾Ó4(–ßJµ†Ö%è±F¨9àŸ”“ŽI9=óZX¥ Œñ^ñóöxµñ²I®hàC­¢|Ê0çhù^›g lŠ~àˆåÜ6|Gwi-”ÍêÑËepU•Ã+£a‘ÔŒ2‘_C~Ï´„·ñ;HÖ¿Ñç?Š)|æß#r2hKÛåm+õÆ‹®Ùk–©¦OÍ´ƒ+$lO¨ÈèGu8 ð@«¤f¸‰¿ôÄÍ†ÿ nî ƒÚ ž0NLrduÚTó_|Pø1®|>¹)¨Dd³f"+¨Á18ÏÊ	90ÊG&rÆsV¾ükÕ~^bfÓ¥pn-˜ü­ÑL‘“þªp  ãå|*Ê¬ eûÀ_´oØCD˜H£‰#n$Œÿ vh²JFårŒÃšéè¢Š(¢Š(¢Š(¢Š(¢¸Š	4oˆvbßTR—1ä\'ßŒž1é$Dà¼O”l6°>ø›ð·Uø¨ÿ gjˆ6¸-É“ª8-dàK|ñeIÜŒ®o|(øÏ¬ü;º2X7›g+5´„ùnzoà¸ÀóPdíQ"¸u|;ø‰¦xïLMWJ~>ì±1ùâ|dÇ û«’EÃ) ×SE—âoiÞ'°—IÖ![‹I†ó¬0ÈêpQÐ†V ©¾0øåû8Þø)›UÑ÷Ýèä³Û—ƒ¾Û¹ß3‹ 0RC·œ|:ñýÿ €õˆµ82<«+}×°^'Ç; ‚¹(Ád\‘†ý øsñLñî˜º¦”Üð²ÄÄo‰ñ“€uÒAòH¸e=@ê¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( œs\‹>,xgÂi»W¿†7ÆDJÛä9é¶·ÈAÁÁÛ‚F3šñ~Ú––ÃÚ{KÔ	nŸ`Ï[È‹ÌvÏñäÈ'âþ7ý¢ü[âÀÐÍvÖÖ­ÿ ,mt¸É8gRg`€CH es“^i–zÈ¯L‘øž}ëÔþþÍž)ñ‚‹…€YZ“]e±Eƒ4™ìÅcOöÏi¾3~Ï7¿¬àÔžî+»YåòIThÙ\«H ÆÍ(de¾pã€WkÈ«×ÿ f†Òø·ÄÐÝJ™Óôæ[‰Øô%Nëxx#-$ªŽž\lOûÐt¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+ó³ãÖššw5hcà§Æ@“ÖC^½ûø¬Çyáé[äž5¹‰qÑ£Ä3`Õ£xI†6ü ’Æ¾µ¢Š(¢¼kö˜øP<g¡JÊ=Ú®œ¥ãÆs$_zk|îl6‚|Ô
ÙøZ92†RF Ž¨eô#†SÔQ_¢_<qÿ 	Ÿ…¬õ9[7J¾MÀî%ärpN<ÀUç;\Î@ï(¢Š+—ø¡áÓâ?êZJ d¸µ•cÎ@Þ´D•ádU' çÁÍ|}û+jñi~8·Šï*×QMž€;Î1“¦>aŒçtŒ¯†?k}&ÖÃÆRIj‚3qoÒc¡vóßu‰cï0,rI5âTQE-vþøÉâ_þïG¼t€’L.‘s–ò¤ÈV%·£,ÀÝŠõ-3öÓñR/Û¬ì¦ˆ0A$lN8;÷LžH‘Øb»hm0…ót¹ÁãvÙ£?ïm÷À8'€HíØY~Ö	¸…%’k˜Y†Lonå—ý–1	#'ýÇaïUSö¼ðk^B/!ÿ -Ì!ïÂ3óÓ˜GNxÁ=fñÿ Á¨S­o0'läÂF8!¼ð[ÑKdŽFk«Ò|a£k	æi·Ö×)¹ŠTqž˜Ê±ç=«^ŒÑš¦u› qçÅŸ÷×ükø•ñwBðf›-ÍÝÌOrco"Ý3ÈØÚ *’UæHp¨¹$ç þu†¸=±“î0OÓ$ûãÞ¿G¾xÂ?øfÇVÚ%IT6ËîæL@¤®IÊ9Á®ÆŠ(¢Š(¢Š(¢Š(®Oâ‡`ð.ƒs®N7<cl1çåo–ûàåÈj+60+óÿ IÒ5ˆzè¶·ÍÆ£1ffèYŽùerÙ»¿$`(ÚÖ¾ý¼1¦Ú…ÖÌº…Ó Y„j{ˆ£…•öûÊîÇ¯ËœUÛÏÙÁWù±­ÜÇÈ—¯NeIówùñýÐ+ Ñÿ g/iRyÑi©+åHóÝå‚«3ºŒŸ½†èr8®úÃG³ÓÑb³‚(>êÆŠ g®Ð€œœãÖ®bŠ(¢Š(Å|ïû@~Írø®æ_xp ¾dÌÖÌ6‰™å¤R}Ô×
Ë Ù!T;ã “ñÝÝ¤Ö’´+G,lU•VVSµ‘Õ°ÊèÃ¬SÇ¡>‹ðSã-÷ÃÍH:“&›;sèÃ¡™ðÜF¹*À~õG”ùÊû÷KÔíõ;X¯¬¤ÛÎ‹$n½XnVÐ‚¨èjÕVÔ´ËmNÞK+è’{yT«Ç"†V‚¬­A¯~?þÍ#Ã17ˆ<.’I§ƒûë|h?Ö£dÉ%¸#4ä6æˆ6ßðwŒõ_jêšDÍÄ|drN	ŽEåe…ˆ¡ã 2`¾üøGñFÏâ&Žš•¾#¹	süó“ ÷¢qóÄã!—ƒ‡V·¢Š(¢Š(¢Š(¢Š(¢ŠÀñ¯´¯Ø6—­Â&€Êz20àKƒæŽ@	åIVXƒð×Æ?š¯ÃÛ¶}­q¥;b 89ÉX¦Uÿ U8ÀIqº3’c^sá×Ä­[ÀZ€Ô´‰±]e$^¾\¨ÊƒÊ°!ãl”#,­÷GÂ_ŒZWÄ[=£oãQö‹Vl¼g¡e<y°19Že €á2þŠ)²F²)F © ô õ=Áà×Ê¿´WìÚ$ž&ðœ!bPZæÖ1÷qËOn‹ÿ ,ûÍ
“™"Þ‡Á¾üHÕ~j‰©é¯ŒadÉ"u1ÈU9ÜŽ2Ñ·Î‡ï+ýÑð§ã‘ñËí-äÞGÄÖ®ÃÌCýáõ¶AI”m?u‚¸eè9¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Œö¯*øŸûDøwÁ	%¼r­ö¨€md+q´L$ g%NéEBkæýOö¸ñ¥Ù”A4Ë&BˆàfxVrHë¹Áù¿‡W	¬üQñgˆßmö£w?šÃù¬ªOÝa‡ËBÜã™$ô$ŠÝð¿ìñãO(–‚ë.
À¤c#
Ù˜†ãÉÁ=H"»Í7ö,ñÊy{gï¼˜ì¿ýAõ®ŸJý‰ I	Ô5fxñÀ†Ü!Ï|´ÒN:tÂ‚<×±xàw…|¶]:Ídº\ââÞKÏk¿ð1ˆ•'Œ±ÏxHšø¿ö©øÇmâ»¸¼;¤2Ë§Ø¹‘å‰'ÃGò†(UÇHìFU>1áê+ÔbÒt¨Œ×36Õ¿Úwa÷cŒ|Ò?EQýâ þ†ü2øwcà--ÄqóM.0ežVê@ãj.HHÂ àWYEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEWÁÿ µ_†î4ŸÜÝJ	ŠùRâ6ÆVMÜ‚Ñ¼?7 áÔÁýŸuïìOiwLû#i¼—ä€Veh>m½@v€#ip™Æ¡ÔQEPFká¯Úá)ð~¶ukÆ™¨³H˜é¼¼ðwÂœ™¢è6´ˆ£Šæ¾	|_½ø}«$¡Ëi“:‹¨z‚ŸtÊª4*w©Q—U1·Jþ‚Ú]Eu\@ÂH¤PÈÊrHÊ²‘ÁAªZ(¢‚3_	|lðßÃ?ÿ iiÃl2Ì/­N8q$ü»HòæÜ›Aæ)Pg“_nø{Z·×,-õK6ÌI*sÃ Ý‰ €N"£ñ/‰,|9§Ï«j’m-»±ôìª,îp¨€f  I¯Îÿ ø’÷â'‰gÔvq:¤Q/$ˆm­Ô‚áv©ÆÐÒc’=ßÃß±cÍ¦™5}CÈÔdPV8£‘œgl®Ä<¤ÂbPAÚ[‚|âGÃ[À‰Óud#tr¦Lr/Mñ1 	Ã¡ãlefä(¢¥··{‡D; $’p $’H  I$ 	 W®x{öWñ¦±n.šÕ-U°Une¹g>Z¬Ì¾„I±ÁþôýsöRñ®™Ÿ¬w@grÁ2³ ;¶H°né€¨YÉ ¯$¼Ó§²™­®Q¢ž3†IFSèÊûJ°î?QÍ@ñ²}àGÖ—ÍlmÉÇ§oÈñNŠáã!“È rPA`AèAv5©ÿ 	ª:ÜL>³H?›ŒÔx‡X‘Ö(®g,ä*ªÍ!$ž UY1'€ $ž5ÙÛ|;ø‡}Í–¦èã Ÿ0d{‘XgÐ¨>Õ‰ªü)ñ^”‚KÍ.ê49Á6äŽ9<Æ$#ŽrØõÈ>ò= ^vÓÐò*"ë^ñû,|]O	ê­¡ênLÔX|Ì@X¦ ,r±=e‡³˜WÛ`æŠ(¢Š(¢Š(¢Š(¯ÿ lŸýVÛÃÍº;óf÷Ò"‘ÉÝwlÆyÆzßØïáÁ±±ŸÅ—‘â[¬ÁlOüòS™¤_A,ªé#†ÉúLQEQEQEž+Æ¾4þÎZwµ[[=d¨ÈýÜØÀ_´ªüÛÕr‹:|áp®$EUx»Á·ƒïŸNÖ-ÞÞáº0ê$†AòÊœýô'!Â0*='áí/«ø(´«ÄÚJ#c¶HÁ9o³ËÓhË2Ã()Ÿ•^1_Zü>øÅáß)]ã7*»ÞÞQ²UeŒm÷ÕK Ït›‘žØR2†=+Á~/~Ë:_‰MGÃ*–‘Ë‡Ë¤õÊ(>D‡<@!9ó#mÅ‡Í>ñoˆ~ëÅÌoñŸ.æÚl…‘A9Ž@2'sAqàÏ:Fû§áçÄ=3ÇzbjÚKåOË$mñ?VŠUÃåXedR	R+¨¢Š(¢Š(¢Š(¢Š(¢Š£­h¶šÍœºv£Ïk:”’7cèGXa”€T‚¯Œ¾8þÍžkz!k­ÌL°×ÍÀýì
Ý'2)e!LµãþñF¡á}B-OL• ¹·+/êû®Ž8t?$Šp{0ûëà×Å»/ˆºHºŒ¬z„[¨å´ˆæ0MÑ7#ïFNôjô(¤+žkå¯Úöi{‡“Ä~ƒqb^âÒ1Î~óMlœäÉn¼†;á,‡æ]\¿ðõÜwºtÒ[ÜÄr’FÅXàØý×FX|²!é_`üý§í|Q³Hñ9Ž×Tc¶9†ºlS¹“pÙÆÂ|¹f&„cßÅQEQEQEQEQEQEŠâ>"|bÐ|%´:ÜŽ²ÝUcBåUpiýØÃ2¨êîIØ¬ÊùÇÄ¯ÚÛEÑbX|-·SºpNó¹bÓvTI+“ü ïºäWÏž1øýã/m=Ó[Ää 1+•ò³\J8Úd*OIÆ!ð×ìõã?ìh4ù"¿å¥Á $²~øƒŒeac’7’k×¼%ûË7ˆµ˜­Sœü§þ>'Î ùÔì„Œ®:W»x+à÷†|höH³Ž³ÉûÉO©ódÜËŸDÚ£ We¶–Š©ªjÖºM»Þê¥½´@³É#P$–l×' ¯>?~Òrx£v‰á‰-+þZJ2?û8ùdŽÜpíy.xWð;9µ+ˆí`S$Òº¢*õfbG÷™ˆUÐq÷ÿ Àÿ ƒö¿ô¤YW¸Pnfó÷„1 ˆc'°cæGÉ#—EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQ_?þØ¾mKÃ¶úÌ*éóâCŽDS-ŽpNa	Á!@Ë+ãK™lçIíØÇ4lu¤:èC¨ÆzOJý2ðwˆbñ‘i¬[cº…%ìXËÏ9VÊœà‚9 ÖÍQEÊüLð¯Ž´;ïå2®è¤ï«ÌRŒ`ü­Ã€FèË.pkó³Å»ðÖ¥>•~¾]Õ¬†78Èî„à”`CÆØù£e=s_Q~É?ÒêßþÍVP&‹-d]ŽY:Éj¥‰É‡ïÂƒŸ$•PDgMæŠ(¢¼ããÂ(þ$iKl’yö¬Ò[9û¥Šíh¦-åH1–L<l× 27È>øÃã/†¢_ÚÜ4	Œ¦	cYl	¨$»ËeˆSµ²UwsãßŒ#ñÈDÖîÚX£åcP#?ß1G…i=÷ÏÉ·œú÷ìgà«mGR¼×î•]ì4„v¼¡‹J±.Ä;²»Ü€3šû 
å¾#ü<Ó|w¥I¤êh9Ã(<Rc,mÛ~ì‰”`A¯Îoh“èz…Æ™t6Ím+Äãý¤%[ÁÁÆåÿ d×5•¤Ýj·	gcÍq)Ú‘Æ¥™\*.Kœp,@×­h²‡u6h¶ŽÊ2îžeèzþî5÷(å‘¶zÏOyø5û0Ûxýu½RáoocD‹#Œœ4Èó*‚¾@ß
[^êSPÒ,õ1^ÁèNvÈŠÃ=ŽŸCÖ¾gýª>øgÃú¾­¤ÚÃcwö•‡l@ ‘\;6cÈVhö†pìâ¾S‚™Äq‚ÌN =x ’I$ I$ 	 WÓ_ÿ dÇ¾u_«Ã²ÉIYq†¸‘bR3ˆP‰T»¡+è­+áO…t¢ZËJ³˜`‘
@é’Àÿ õëfÏÃ:]Œ‚{K;xeŽ$V÷•AÁÇ<Ö•®Å¿|!âÛ{¬iÑÉqÞHÙâfÿ ®†Ý¢óÇòGjã<Kû#x>þÑâÒ]:çl‹+Ê¹íæEpòQÓ
ÈÜ’8#äÿ ˆß5Ÿ‡÷ÆÏU„ˆÏú¹Ðƒ&) gÌ‰±*H*CŸ{ýžÿ ixü¨ü5ã¶ºa-ï$<Â¬7oÙ×Ã|®¿,¥d]Ò}F7JZ(¢Š(¢Š(¢Š¯¨^Åao%Üì(Q¤v' *‚ÌI<  $“À¯ÏGÔ>-xÉ’=ÆMFáæ‘Ïü³ˆÎìT0U†‘ÇŸ”Ëå $_ z>“o¤YÃ§Y ŽÚÞ5Ž5¨Ú£aÏ©É«”QEQEQEV7Šü¥x®É´ÝjÝ.mØr¤ÿ N0ñ8ê`kâ¿‹ÿ ³n±ào3Q²Íö»›ÎQûÈ—¢ê5ç…û×ƒÁgX³\ÃoKàÝzÏ[PÌ-eÈ§–B
MçÞFÇ‹äpÃôSÃ>)Ó<KdšŽp—6Ò†FªàrŽ!•€`Aâµ³Eyÿ ÅÏƒzgÄ{×î/¢È¹UË.y1È¹_68-`C èÊÃ5òdúo>ëéG—Ÿ(eíîaÊ0à¹?#ž/™£,›‹}iðŸã6‘ñÓÌ³>Eô`yÖ®Få'«FGBH;d^$Tl­wôQEQEQEQEQHÈax þ Žâ¾;ýª>
[øzEñF‡—cpûn#@vÅ#r’(lPNr¤3IÊ„À—Ä<ã=OÁšœZ¶“)†êŽyVS‚ðÌœo†L|èpAÃ¡YM}ñð“âæ›ñMûe™ò¯" \Û1ËFÇ¡20L2€Œ«‘]¼¢Š1^/ñ“ökÒün$Ôô½¶:Á,î¥#8¢ãl„œ}¡2à}õq_ø·ÂŸ„54­^‚æ,­È*~ìˆÃ)$LG¹Œ®
yøûQË¥´¹’ÁT$WX,ñcî­Æ2ÒÁ·åY0d‹ >ô;Óë{[ÈnâK‹gY!GB
°<†VäqSQEQEQEQEQEQ‘\‡Ž>,xsÁIjñ#”ãl+óÊsŒbòøä|ÌGsÒ¼÷Xý®ü#i–Ñn®¥Îb#zà´“@¹ nnxVé^)ãÚÇÅšÓô½še¹è"¤<ƒÌó“ØùPÉ9qúÂÿ |F¹‰osreÚZêä²¦;1¸¸å”‚%cî¯júÁ_±Æ•h«7‰î¤½˜õŠbˆtùLœÜH8`NøÂ‚¯eð¯Ã_xQBè–[ Þ |Ó>éX‘Õ‹ßÅ“]6(ÅdTw1[FÓNëj2ÌÄ rY° ÷'óçÅÚëLÑKØøUP¹hrD
y@¸’ä†;Lqÿ ­8¯–¼iñ#\ñ•ÁºÖ®¤¸9%TœFp"…q`´¿räóU|!àÍSÅ×é¦i=ÅÄœáG gI\ü±Ä¤á¤sŒð76ýð{öjÒüÑjº‹}·XNCtŠ6<fÏ,ê§hšB[$”Tí QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQY¾&ÐmüA¦\éƒ0]Äñ?Ñ\B¤†`‚üÐñ6‹¨Üi· ‰í¥xŸýäb„ýÇ$a†	'ëßØ×ÅƒPÐ.´'a¿O›z/¤s3$‚ë7@0Ï-ÏÐ”QEQ_(~Øÿ $Áã4ÌN«otGgñí+`tuc1`—½|Ë§ßÍ§ÜGslÆ9butuá•”†WSÙ•†Tþ AþüPâó51ÚŒH >bùç:‘"c e“;èTQE¾ýª­"¶ñÍð‰BïX±Ýš1½¾­“ßãõõGìSâX_RÑäp·3ˆ¦Ip@É(Nw3&åfP†éšú°ÔW3¥¼m4‡j ,Äö e‰=€ ×æ‡õÏøHuËÍQpÝÄ³00ìYx9#÷{I$ý+ì?Ù{á-¿†tHüAyþÕÔxf4pb‰sÊWÍŒ,¨Iµî8¢Š+3Ä>$Óü;g&¥«Î–Ö±}é$8Ê;³·EEØà(&¾øåñ†ïâ.¬Z2Ñé–ù[hOÅ4 <é@ù¹"(ñ~ù>¯û#ü#ó$ëù [ã‚Üù·(¤r#Š9¼ÆNÌ>­QEQX¾.ðŽ›â½:M'XˆMm/QÐ«»$n>d‘*ëÈä‚Aø_ãWÁMCá½ødÝ>—;³Üc¯0\p3€ KˆÁxÆá$kîß²¯Æƒ­Zëî½¶LÚ;u’À0³wÍ~^x0NY×Ñ€æŠ(¢Š(¢Š(¢¼[ö®ñ›è>:}¹+>© ·ÈÇæ\}ïï¢ˆ²G˜pAÁª?²wÃƒáý¼Ax›nõL20VÉˆu8ó˜´ÇùJGÊ ÷z(¢Š(¢Š(¢Š(¢šñ‡[x út Žà÷|¿ñ—öNŠU›YðgÊùgk§?3}ò6`ä­³eJÄÑ€ª~a³Ô¯ôkŒÁ,¶Ó#`²3FêFTò…:dŒ7+÷OWè7ÁÁã?Ùß¬é5âD‰tª~d™FÙˆIe.Tº–áÔ‡^®êŠÇñg„´ïéÒé¼Bki‡#¡R>ì‘·T‘(ã}A üMñGá>µðV‡TÓ&‘­<ÍÖ·h6²¿üò”(Ø“c#n<«˜òä<cè‚?´m‡ŽQ4½X¥¦´  dç=Í¾ã‘'žÜå€;£2 ${@9¥¢Š(¢Š(¢Š(¢Š(¢ ¼±†ö¶ºE–T«£€ÊÊxeel†R8 Œ_'ü~ý˜¤³‘µÏ[î³Û™­#ÜÎœ™-ãù‹ÂÀåâCº"3²±Uð?øÏSðn¥¯¤Ja¸‹ŒõWC÷â•	HŸ2`JH¡‡Ù_i­#ÆòG¥ê)ýŸª¾©lÅ+sÄðUÈPÞLÁ[æJA5í æ–Š+“øðÓIñîœÚn¬Ÿ0æ)—dMýèØƒs‡²’/:ð—Å/„š¿ÃÍ@Úß¡{rß¸¹PBJ½T©çË”ûÈoF©xÊ½k| øõ¬ü=•mã?iÒ™‰’ÕÏË“ŒÉò`“#8¹|èÎ>×ø{ñ?Eñå »ÑfÊ–À–,ä4Y%AÚv¸-€J±ÖQEQEQEQEPMbxƒÆÚ'‡6fúÞÌ¿ÝJ¨O^ˆ'¡ç«Ë>"~Õžðìf×V½ì"8…sÐ½Æ÷ 1äµàZßí!ãÏIö)¿žv¬6páÛ¯Ëþöå˜ƒÏ–A;A9§i³Žõ÷7-·›–gº˜'8>b§Ÿ1sË ýGñ)5ìýô]<	|Cu%ô½ã‹÷Qui#tî8*I‘÷C kØ<5ð»Ã>PºNoùÄaŸåÉRÒÉºFe$á‹÷® (´QEAw{œfk—H£^¬ìÜ³$½ÅxÆoÚ“IÓ,fÓ<'?Úµ)T¨¹‹(s€]do–iv“åˆÃ"·Ìì1ƒòF­âý[WQ£wqr‹ÐM4’ß¤®ËÔxÁ#¥d’\óÉ5è_
¾
k_®1bžU’Iu >Zúªãi}#NF÷A×îO‡_ôX-†‘@ó§`<ÉX®:à“±0pŠu”QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQA¯‰¿k¿6‘âq¬D¸·ÔãgŸõ±ÃždòdàäüÇ .Ngì¥â¶Ñ|a£ÜjöÍþñl Ÿ26QÐ!$ð+îµ¥¢Š(¢³|G ÚøƒN¸Òo×}µÔmƒÙ†	r~ò‘È`9ù·ã\x[X»Ñnÿ ×ZJÑ“ýà9ŽLdñ,E$þñô®ŸàwÄù>ëñj62*éNb<ïUèd¿zœd€èÏŠý±½†öº¶q,2¨tu9¬2¬¤pAjz(¬ßø†ÏÃº|ú¾¤þ]­ª$n¼ÀY˜áUG,ÄÉ¯ÏjÚŸÄ¯Ï{o’Ý_LLp .ÁGËJOî¢
ðŠÛ˜•Vã¦¹ý—¼u·Ú›O-ò†(“FÏÎ8òÃYsó(lðqžþqks¨xrùf‰¤µ¼·|‚2ŽŽ¿Pz@88`Uˆ?ZüýªtíJÍ4ßÎ-uð‚å†"˜c†•”·˜`‰7‰ÎnØ¹¿´í)¥\isxwÂ³ý¦k cžá2ã|p¹ Jó.TÈ™#-†.@6ü>Ñc×üAa¦OÄwWPÄßî³ ã ƒ‚€¯QÁëÅ~–ÅB(Â¨À€pà)ôR
2N ¯ø¥ûQè^ó,´ŒjzŠ|¤#~å8"Y×;Ùz˜áÙbœ‘ó>¡®øÏãV¯«y—r“”†1²G'Ì+“Œæy™¥nYòýðÛöLÐü?åÞkïý§x¼˜ÈÛn<y\¼ár0fb¤€ÞZž+ÝãcPˆ¨    8 v¥:Š(¢Š(¬¯øjÇÄÚ|úF©šÒå
:ŸÑ”ÿ ˆØxÜrŽ‘_|Bðf­ðŸÄžTR<m¬ö—* Þ æ9”r»•²“FxÝ¹Hòä\ý}ð#ãD?4æ
°êÖ¡EÄk÷Xâ ~o)È!å¢|¡$lfõ*(¢Š(¤Ü)sFh ×Êµ¦¥m©øŸGÐØnòPy#‹‰b@™Á1ÂÇ!³†ìE}Y),Q ¨€*Ø À
}QEQEQEQEW†|vý›­¼jYÐ‚[k ëÑ.=„qÀ?r|Ã)(aµ“ä½_ñÃašÖIlo­_dˆxéÖ)â?$¨A$+nB>x˜=}Ñðkâµ¯ÄMo“ßCˆî¢ÂøÎô$Ã(ùãlñÊ7ÌŒ+¿ÍâÙx‚Æ]/S…n-']¯Žêî¬§Ž¤20¤šøwã?ÀWáÅÓjV{çÑÌƒÊ¸y	û‰s·9U¾T™p’¬9iôo‚ßµkE³Fñ³—\á/±ó(þ»D2¯#í2 rõýSñÎ‹,LVSAä2°à©Gt©(¢Š(¢Š(¢Š(¢Š(¢¾møùû1ri<Eá$D»}Ïsk¢FÆã5·VáÈÄ‘±Xæ'ÌÜ’†2|“ygu¦\47ðOÃ#‚®¤sµÑ¶º0Æp@`FáØ×¸ü1ý¬µŸ$z~ºŸÚVI…Çlê£€ÇäŸhí6×=æ=¾°ðÄ}Ç6_oÑ'Ä‘·Ë$gû²Ä~dÎ>Vå\r¬Etù¢ŠÈñO…¬<Qa.“«D&´˜a”õø]ªH‡Ž¸e`5ð÷ÆoÙ÷Tø!½‡7zK7Ëp«™8Xî€â7û J1ŒF<¶;œxÄZ‡‡nÓPÓ&’Úê,íxÎz¯pTó¹Y'*z×Õl;+¨–×Æ1˜'}¦&23Á– ZX˜¼cFH'äÈQô6…â-;^µ[í*â;«fèñ0aî	ÚÃº¶î+G4QEQEQEªš®¯i¥[=î¡4vöñŒ¼’0UÝ˜€?<žÕá^9ý°4%ZÂúŒà•ÙŠ07`e•z‘åÇ†ÇÞ•‚x£ö“ñ¯ˆƒzÖ–ìòíTD #÷¿4çƒÇïAÉ¡[£ðŸÀïøíÍòA"$‡&æñÚ0ÝòQ%Ä úª2çœžH÷?þÆÚ]¡ó¼Iw%ëôò¡ÌIøÉ–²;A×ƒÆ=—Âü;á"[C°†ÖC]W.Açi•÷HW=vAÅtôQEªš¦¯g¥[½æ¡4vöñŒ´’°EÝØ€?:ñ¯þÖþÑ÷Å¦yºœÈJæ!²,Œÿ Ëi¶†\óF²dË¸f¼[Å¿¶Š5]Ñé+›èQ|Ù\æY¿wœ>Xx#r°Î+È<EãM_ÄRùúµÔ×OÛÎràtÎŸ-s´p¨ 	æ±YËrÇ4ûki.dXaRò9
ª ’I!UUW%™˜€ ’@õGÂÙ=WÆœte²CÏ®.äx"8ÇHyZú{NÓ­ôÛxììâHmâP‰jUGED\Ð
³EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQ^OûLx¼Uá9žÚ?2óO?jˆä…N‹Œ’Zø\²®à¸øWBÔæÑµ/íðf¶•%Lô,Œ$\ã³mÆzmcÎ	¯ÒßxŽÓÄºe¶±§¶û{¨ÖE>™*ÞŒ•aÔ0"µh¢Š( Œ×Í?µÿ Âõ½´OY)óíÂÃtyŒ’!˜Æb‘¼·lgÊ“$â1_!‚Tú_\þÆÿ öÖãÂW¸Û´[g´díž%à|±ÊË"Œ’Ät ¦hªš¾¯k£ÚË¨j¬°)y$s…UI? –$ 	 WÄŸþ2jŸµHô-$h”,(ùå|áe•GY[þYD~X,Çxfé/-~éË=Ê¬šÕÂ´K×`?7Ù¡=£Cì9š@]‰PŠ¾§¶¾vý¯~ÙÞhÃÅ°*ÇyfÈ“° y‘;”¿BÏŒ¾Yå¶3¡ùq·ã}ÅzPÌXäòkgÁ^!>Ö,õp¡Í¥Äsm'¶0b¹ã— €àž3_¡~ø±áŸÙ¥ýž¡nú¤’*:¶1ÉŒ¬®¹ ŒÜkNOhQ‚[Q´æxÿ øªâ¼CûJx'EMÂýo$ –ªe'`²-qæ:äW8¯—>/üyÕ¾#\‹;1%®—‰lŒI·§1®‘òÂ7F‹ÀÄ°×ø[û.k¾"ºŠïÄ1>Ÿ¦pÍ¿+½²(yhËg—”!O›ïÆ>Äð¿„t¿Y¦¢ÛÇmn€ å±ÆéïHç«;–f9$äÖÅQEQEWš||ø]|?$Q : i­[–ç€ž»'Q´Œ€FýPWÃ^ñv¡à­bWNcÅ»çÑ‡G†P1”qòH¹H>dú'àÚø¿G¶×,Oî®cW ”n’DøÈ†F¢·h œ×­|gð†‹$°ßj¶©, —A f*=ÌÏŽˆ ¶xÆx¯!ñ/í©¦YÈcÑténÔ1æBìÊ¡fdô*sí\/Š¿lÏj0´:=´:in7äÏ àƒ´È±Â9ÁÄøÆ
¶r8[ŸÚOÇ·(b“V—ië²(Q½x’8•×ð<Ž:ÒðïíOã]6‰îÖíIÈûTbF^¹Äˆarz9|`Ú3žŸHý³¼K„ß[YÜ¡Ç^#×æƒÊ2G •ÂžHaÅ{·Â¿Ú/Añë-‰Í†¨ØÞV9ÆæÓ	¶óò•Ž\ùuê®áT³ 9'·©>˜ï_žß|t¾ ñ¥æµ§Êd…fU·lî`
±2g,m"®9zäûãÃ:ä:î›kªZ°’¨RUaÜ2†éØ‚H+ü$y§EQEQEQEQEç¿þém
Ý#PH†é ,½ÂJ¼	¡Ý‚cbäÆèÇu|¯økÅŸ5´¸ŠFŽãñÅ2†R­ò¸Ç2[L¦Cƒÿ -+èOƒ¿µ=Ÿ‹.¢Ñuø’ËP›	¨Ù†WãáððK!'ÊF/°Ø²yŒ¨}ôÑUµ6ßR·’Îö5šÞe)$n+)à«)à‚:ƒ_|vý™î<8Ï®øR6›Kt‚ZH1Ô¯Y&€u3,#!ƒ"‚¹¿ÿ i+¿*hšÔmw¤îù6ŸÞBsäòËl#rí$˜›þY×Ùžñ—ˆ,¢Õ4¹V{IÔ2:ô#¸#ª²œ«£ ÈÀ« EhQEQEQEQEQAâ¼§ã—À»/ˆ¶h¶Ùo­@§É˜Œ+Ž¿g¹Ûó4lGÉ&7Î™Rñ¿Ä1ð>«áçÓu‹w‚t'‡?¿–hÏgLÑ‚°+LðŒµ?	ßG©èó¼ÿ žÎLr/Ý’&#æÁSÔmoš¾×ø'ûCiþ=Š=;Q)k®`æ!’íä½³1';~f˜È˜b7 ß^Â(¢¢¸µŠâ6†uFã¬ªÊr=#¾`øËû&‰êÞ	Q“–{"qêOÙˆP=-Üàc:ýÚùfûO¸Ó¦k{¸Þ£;]$R¬§ºº0Œ=ß¦lø3ÇÚÇƒ¯F¡¢Ü=¼Ç¶ò®~Y£l¤«ó¾7r®§šûá?íI£ø¯e†¹·NÔ›
	oÜHÄà,R>r7Š\gøëÜƒ GzZ(¢Š(¢‘˜(Éé\¯Š~*xkÂÊN¯¨A®v4‡$,1î·Ì¸rr1_?xßöÏ”ÈÖþ²UŒp&ºÉcÎ2¶Ñª/™6ãžUñMkÄ~.ø£ûö¹ÔgÏËHY#É l‚!åBHÞø|¼„d×¥xö>×µR·!•4èNÎ%˜úüŠ|¨Ïo™ä9ÏÊ0	úÀŸ |)àÝ’ÚÚ‹›Ää\\âIé”âï*4ê}kÑvÒÑEŒØ5çþ9øíá_îŽúíf»^>ÏoûÉ3èáØÀîdeôäàñgí¥©\o‹@±ŠÕ:,“·šÿ _-6D§¨Á’Aü@Ÿ»^â¿k^+›íÝÜ·nG˜ÙQž»"P°Çÿ  Œqœ`í#F½×.£²°ŠK‹‰NÔHÔ³1ï…'YŽG,Ê9¯|ðWìm­j
· ¸OF ùj<éFAá°V íÈÝ/Œ‚+­Ÿö%±òØE«H%ÁÁktÆqòä ã89ÇLù›Ç^»ð~±s¡ßcÎ¶}¤Œáã‘3ÎÉ•—<Œ•9 “í±çbÕµ©õë¤Þšj/”yÒd+ò~ôQ+2|§&A¢¾ÌQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQL–5‘J8HÁ¡‚±üöøïðÑüâ¬¢Sö	¿}jØãËbsqÐ>b`	;<¶ oçÖ¿c/Ê·7~¹˜¥O´À§³®áW'øÑ£¨²»x×ÖTQEQY¾$Ðá×´ë*è~æê‰¾Ž¥sÆ:g={Wæ§Šü;wáÝJãIÔeÍ´†7¥ˆÔH¥dSÝ\¦ÇÂ¿¿‚üCg­®JA'ïóFÃdëÇSå’Êrè£8?£¶7‘^ÁÕ»‰!™Ñ‡B¬7+èTƒY~/ñ®“áÔµ¹ÖÞÀÏ,Ç²EåäsÙTS€	¯Š>$üQñÅý\iúls}Œ¶-ì¢Ž3ÄÓªpóî.ÄCn8F4ôoÀ¯ÙêËÀ‘G«jj³ëŒ§-œ¤†8{4›~Y'êÜ¬{càû5óÇíñÒÇE_	ÄUîï™$•r	Ž$a"’9*óJŠ±ñ‹#vçã2rkÐ~üñÄ/¥Ä©jµî&;cSÁ(òHû‘©8vCÅzìß±%ðF1j4˜;AÀ'°-æ¶ÐOSµ±×ié\Ä¿²RQû‹ÇïÇ`ö!âà²¿J²ÿ ±·ŒA O¦{ù’qõÍ¾}¸É®ÛNýŠbkuþÑÕŸíÄ"…Je2±sŽäàÊ£ŠõŸ†4‡É¾Ê?´_½u0S&?¹Ðò3µâyvcÍz&(¢Š(¢Š(¢Š)¥~süoÑ Ñ|aªYÚçÊ[§eo9UÚ 
­+*p O5ÛþÍWÁ7Í¤êò£]œ±Æ|©xQ?ùL£dàFP8“?iØëú}õº^Z\Å-¼‹¹$GR¤u¬÷¯-øûLxsÂPI2j:–0‘ÂwF¤•®'_(êR2Ò· (ÎáòŠ~0xŸÄÒ¼šŽ¡pèû¿v²ŒÀ*°ÂQíÚÛøÎâÄ³?Î|` à~C“ÉnügÔãùâµt¯jÚ¾?³­'º-œy1<™ÇÞÁE*Bãœ1Áã­z.‘û-øßPŒÊlDŒ	¥D'#9
‡89*Aà¯Ýcö^ñÆš¡Å‡žb|‰cŒ`üÊZ6ç'nÐÄàŒgó}gÃZŽˆâNÚkYHÈI£hÛ…)#W8Ï8ª6÷2[ºËu!È`Fe<†ykµÔþ6ø»TÓNy©ÜIdË±•”Œ–UEšT`HeyaÁÈ®±'=ÿ Ïåý+èïÙOã$ún¡„uIwi÷Yûú©¹`ŠOH®0ÃfHY¶”æ0?bš(¢Š(¢Š(¢Š(¢Š(¢°|ià½;Æ:lºF¯™o àŽ}Ébn©"U‡•`T~!ø­ð#^øs9¼Pn4ÝÀÇw àL«–·lùDá’El í>þ×z¾–ðØøöÑp¯0gU\ã÷s”^X2ÆïƒÉo½ö%¼Ë2,¨r¬Ôpy‡š’‘†kçŽ²í¾¾%Öü&‹¤Ì^[|…ŽR~óÅ‘¶‰å‡JI-±þzð†Ÿ5ÿ …‹ÙÈŽÖ»ÿ Òl¦Ê|ØÁa¸·ŸùÀÚà1]pãí?‡ô_YÝ\ºæÂüI ²'qÎ‰º'ÁØçºÐsEQEQEQEQE‰âßi>-³m?[¶K¨8>e'ñH0ñ8ÏŒ¬=kã³Ž«àË‰/ô¸ÞóF$²È£sÄ:„¹E¾^@AG òØœøäËjë,d«)Ê°=ä2²œ†SÈe9E}3ðkö±žÙ£Ò<hÆhsµo ùÐvûJ®¨£½|Àiùzú¯NÔ­µ+xï,¤Y­æPñÈ„2²žC+‚ô«4PkÍþ-|Ñþ!Û³Ì¢ßTT"+¥Žá'Q<YÃ|è	12µ|Iñá^¹à;¯³k0BqËÌRuæ)p8ùnP:§sÈüÑCþzCèz×¨|9ý¢¼Mà ¶ñMö»÷$ºÛÊ“>t8ìš>ÞX>…ð¿í‡áB5Ä3ØJ~ñUó£dÑ7ð„7BÀ
ìôÏÚ3Àº‚³&©[N™^#ë&D,=ÆEjZ|jðeÜ‹:Å™vè ~­ùšél|C§j	æÙÝA<`ãtr+úeXŒûU“} ÿ –‰ÿ }ñ®cÄ¿ü+á°ÃTÔ­ã‘wf5pòeq•E¾MÜŒ.ÝÇ<^ªþ×~´Þ-~ÕtUr¥!(¬»ºs/<d {Šó/~ÚZ”å¢ðý”V©ž$œ™_·>Zl…OQ2AŒ‚
×x“ãŠ¼H¥5MJâd#ùiÓiýÔ$ä †ÏÌ	æ§øið›]øƒtÖÚDj±Å6gùc@z	AfsÕaP\€X…PýáOØËE²e—^¼–ôŒæ(‡“ëÃ0/9]¤$CNpp=ëCðý†…n¶ZU¼v¶éÀH”(ü—9$äää“žkCQE…dx‹ÅÚO‡!ûF±w¤}Œ®=° ÌyþMxŽ?lML‡ {ùGYs_P3È²"Ÿï€Cž|mñïÅ~/.—·¯³Ë?uHOÞH?ë¤ßå |ù•Ûå8ÙñÁÇ$wî)Cô ÿ "irØ=;þŸÇ+ôö{øicáZÜ¤huè’yæêÇxßJÇ•Ž$`¡FmÎÀ³}Jƒ_~Õ
o‚õ+oùùJ?Ãð¯¡ÿ d¯
Â#P•vÉ©JÓŒŸ-q##< ¡ãƒ^ÙEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEW™ü~øbž;ðä°À€êV§µ=ËûÈ;|³ )Œà?–ü”ðŸ…|Iwá]VßWÓÛeÅ¬‚D'òdqý×BÑÊð³u WèÃoˆ6><Ñ¡Ö´òï–X³–ŠP’àr¹N xÙ|¬+©¢Š(¢Šù¯öÁøh—¶1x¾Ñ1=±XnqžccˆenÙ†C°·Ë”äŠÈ ”l÷üñ_s~ÉÞ1mwÂcN˜“6—!ƒž¦"<ÛsÀ
¬Ñÿ »çÎøö{ñŽ¼c>§â‹´"H|–'#e¼1à-¹#>t¼–bYC2û‡„|	¢øBØYèv±ÚÇüEF]MÒÊÙ’Fãï;[ÔWñWâ]—ÃíMZðy’“åÁ82HA*¹?uò¿;‚ØSùéâ¯Þø›QŸWÔŸÍº¹}ò61“€  1µ@H×øQ@ë’{¯_î>"je—o†¹˜¡X#<:aœ|¨ó!)Ÿ½ô"ÓIµŽÂÂ$‚Ú‘ Â¨ õ=Iäœš¹EQEQEQEQE#WÁµ˜¶>8¿ÚÄù¾TÇ=‹Æ¹@òÆ;òkÉ äu§	O ü‡øRüÒuè?ý Ï?©®ÿ Áÿ ¼[â¥Yl,%[wé4Ø†<`Á¥Ãºœ`ãq’@9¯uð7ìeklRÞœ`˜-r‹žáîy¬1ÿ <Ö/®FO·øoá?…¼8©ý—¦ÛDñôÆN›Ió¤ß!$p~ny=ÍuQB‘(HÀU €üPFkÅÞÒ¼[bÚnµÜ@ÜŒðÊ{<R<nFBc‘Å|íñö4‹É7ºc(äÛÝ0ÃsÒ+…PPÂ¬ªÊOWSÍ|Å®xvûBº}?R†K{¨‰‹µ†23´ýå8ÊºF^Uˆ¬Ê|r4lx#üÿ >sÔF5öì¿ñÙµˆÿ áñÈkÄÇÙ%™¾i£@Ò1ýäÑŸš=Ä¼‘eš65ôQEQEQEQEQQ]ZEwÛÜ"ÉŠUÑ€*ÊFYNC)‚WÅ´'ì÷'ƒ&mwCS&Šíó/SnO9SnÄíŠcÌ|E)ûŽ}_öiøïo®ÙÁá=e¼­RÙP;'DU%º]Fƒ¤æUbwªý(¢¼«ãÀ‹ˆÖës-®±Äs‘•uëäÜÃ2IÆ^$®å,ñŒ©â/…úëF­%†§hHÜ¸Î]À¤ÐH9VŠ@F@q…úóà—í§øå#Ó5B–zÖ Û»Îqó5±lùkvË¨9F‘FkÙÅQEQEQEQERÍyoÄÙÃÂž//ra67¯ÉšÛ¹½e„ƒ™<±*äüã$×É~k?¥\bãOsˆî£)<|²¡,mäÉùC;#àì|µ'Áÿ ŽºÇÃ»•I¸ÒØþöÕÉÀÉÉ’x‚n¼åIŸÞ.pãíÿ ü@Ò|q`5=o6,íu#kÆÃ¬rÆ~daÔuV23)ºJ(ªÚ†™m©BÖ·±$ð8ÃG"†R:Èà©ãÔWx»öMðŽ´L¶.™)9ýÃn°?¸›z(À<FPd’s^]©þÄÚ¢7ú¥m"’ÖÆè@í÷PÇpg Æ+"óö1ñT1—†âÆf<ŠOÑž= ýN+Rý–üw§…1Z	ƒuògFÇûÁÌ8Ô\®±ðƒÆVÿ ¶iwbÆæ{ïˆÊŒy*[Ìßè÷ºpò„7O2&Lýˆ¹ü*¶ÏÓúÕÝ?G¿Ôw(¤—n7y(Ï× o%Xàà1í]Îû;x×Zaåé“B„àµÆØ@ãvOšÞa\`±0É#œwšìaâ+¢Sºµ´Cœ€ZgÝùPEÏ=$àc ž+Ò´oØÓÃv²	5»»­¤ŠR%8êËRø>ªêÃ±î>ðæáëDÓô‹xímcû±Æ y,qË3Y˜–cÉ$ÖQY'ñn—á{S­\Çkn7HØÉë±ï;	
€±§zño~Øþ±Ý‘mq{ ÀC8y“3`±ÁÄ;€€xÏŠø¿ö®ñ~´Ï”É§@Äám”n
x®%å¹å‘b;€e+÷kÉ5MróUœÝßLóÎÝd‘‹1ï÷Ü–êIÀ!A' dÕx[RñEâiÚDsu&v¢N9bYˆTUêÎìª ŒœÔÿ c{hÒçÅ—<ýM½»Œ²óÿ ­”Xü•Ï@y'Ü|=ðÓÃ~Òtëks‚,j\ƒÉ#‘‡‚ÄqÆc|WøY¤øÇD¸´š’é#v·˜(€S¹F|¶ 	På]IÈÈ~}i:cj7±YFB´î‘‚z!XÁ=ð¦@O|
ý=³€[Ä¨ "… p8paÇ°©©¿?üwvß¾ Ì¶9e¾¼Kh™F~E"ÙeùAÈ£Í»Ÿ”ìE}ë£épi6éöŠÞÚ4Š5aPQÐŸ•\¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š)f¾+ý©~·†5#â=1	Óu		pL~fN¹òîùcã&øøRý–¾*'„õÃ¥jlÓµ-¨Ìz$Ã‹yO8TpL¸ËDX…BOÜC¥QEUM_J¶Õí&Ó¯PImqG"…Xaùc‚:WçOÅ‡—>×®4k‚Yï†CÞDßê¥ãÄ’c¤¨ý2µÕ~ÍÁ^#T»mº}øóú)-›yÄr3+r—+Ü½—‘šZ+›øã½?ÁLºÞ¨O•Q~ôŽÜG`ñ¹ÏrBª†v!TšøâoÄÝOâ¨Ú–¤Ü¬0©ù"LäGL“Á’B7Êüœ(D^Ëàwìñ}ñ:•Ü†ÏHF+æ…ËÈÃ’Ù[ä*œ«ÎÛ‘\lEvSíøJð^žºN‰•n»d–gvûÒJí–w8'…P¨¡UT‚Š(¢Š(¢Š(¢Š(¢Š)¿??hïÛø‡Æw÷6d41²@†òWËw›Ôc#äÈ$^`k¨ðÃcÇ7ÃNÑa28Áw9Æ§8’y "48$ôûKágìå x"4¹¹uP`™åPU"Ú&ÊÆ çÛ¦låŸQë `RÑEQEaø§Á?ŠíÍ¦·iÔDq½~e÷ŽA‰#ot`kæ_Š?±ýÍ®ûÿ Èncêm% H:“äÎJ¤ÀpK±ð?Ö±â¾kÔ4Û>f·»á™J²ž»]Fö`3ÔdsPÃ)ˆîS‚?ÏàGPzƒ‚9÷ìëñÎßÆ6èz¬¸×-ã –¢p%VÉ`˜óÐà–UÜh¢Š(¢Š(¢Š(¢Š(¢ŠŠêÖ+¸žÞáH¤R¬Œ2¬¤a•”ä2°8 ðE|ñ»ög¸Ðd—ÄÞ-#l–ÈO™	^L¶­Ë4K3f|È
–ˆºaÐþþÑšŠmàÑuéE¾´Š;àŒ èü*Îã¡8ÜÙh·)À÷0sEÅ|PøO¤üC°û¦¾\ñóÂæF{àŸ¿gBß#Žx`¬>øðëWøq«›àAÏ™É²*œ¬±6r¬§Ów™ó’»dokø-ûXImåèþ5c,YÚ—¸Ë¨íöµëAÎ|Å2#s%}Ua¨ÛêñÞYÈ³[Ì¡ã‘ee<«+.C) Ž*ÅQEQEQEQET¶0ßBö×Q¤°È6º8¬Ud`UîÅ|³ñÇöWòUõ¯DY9il—’3Ë=¦âK/96Äü¼ù'¤gçÍÄºß‚/ÍÖ›4¶W‘|­”ûÇ4R2÷òæCÈ@<×Ñ¿ÿ lxå+iã(vvûU²œw9žÛ,ã ËÀ\dÿ «Q_Jèºå–·j—úlÉqm ÊÉnR>£¡ÁÁ‚^4QEQL–åâEQŸçšˆéöç¬Iÿ |ð©"·Žˆ”.zí ~xÅIŠ(¢Š3Xž(ñ¾áX>Ó®^Ciéæ0»á—vÀ'j)8Ž+æÏþÙÓù¯oá[DH Ou’Ç¨Þ–èUS³/›#1<kž>}ñŸÄgÆ7nÖ®^âQ¹áTáŠ5ÂF¿îÄ}÷jæè¢¾›ý‹u­*ÖúþÂá•5+¤È,q¹yš(òp\1YY Ë ÝÈS·ë€A¥¬okèº-ö§66[[Ë!ã;T» ±ÂƒêE|ð+I·t›frŽCŒ‚"Fœ‚=O•ž‚zWè…Çü^ñ+xkÂšž«Ä±[¸Œàœ;þê"pAÀwRH#žÕò‡ì™á±ªøÄ^Ê¥¢°†I³ŒçB[ý£¾WdïSž?oÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQX;ð•·‹ôk½
÷ý]ÔeCc;[ïE*ç?4RqîµùÁâ-
ëÃÚ„úf †;«i9œexb2”pCÆÀa£eaÖ¾ãý™|xþ*ð¤QÝÌg½°co)l—*>kwrÄ—-	P_ø™X™Z½nŠ(¢Š+çOÛ3Â{£Zx‚5ýåœ¾L‡þ™Í÷IÀ „#Æâ Þ@å¹øæ6ÚyéÐýô5ú%ð#Æ'Å~°¾‘·\DŸg˜ž¾d_ºflæE Î	q]ýGsp–ñ<Òœ")f>€“Ç< M|=ñÅÚïÇ/®Ÿ [É%œð¯d8urÄ„¤ù~fÀŽ2±¨v/ŸJðìiko¶çÅ·&f8&ÚØ•^ùY.%pr2"XG“ÁIéú}¾oœk¼*8Ð ª aUT` `V(¢Š(¢Š(¢Š(¢Š(¢Šñ_Ú[ã'ü!Z_öF› ½ú¤rb‹î¼äs‡“æŠÿ çäFká‡;ÛÀÐó“ßšõ‚ß u?ˆR‹ÉZé
Ä=É\î á¢¶VâGÎU¤ Åw¸Ù_ox?ÁzW„lLÑ`X \¼í€“?Þ’FÇÌíÏa€ ”QEQEPFkˆøð{Ãþ>„Z]";˜þYSŒ˜q"çË”<gû¹ ˆ>,ü!Ôþê&ÒñL–²Ü\(ÂH½±Ô$Ê8’wó&èÈ#–ð×ˆn¼?¨AªX6Ë‹iD'8Ü§#pŒ2Ž22ŒÃ­~|;ñå‡Žtˆu­0ü’IûÑÈ8’ èÊzŽ…]r¬t´QEQEQEQEQE#¨q´ò|QûH|
Ý?ˆ4XÇö5ÃüÈ€âÝÛŸ-€à[Èù08Ú±1òNßÝëÿ gÿ Úeƒ'‡¼g>W…‚òS‚§ ŠéøÊž‰;|Êß$Äå^¾¨G¡Ô‚¤dÐŽÄÁt4´VŒ<¦x·O“JÕâ[È?àHßÃ$OÕ$S‚¬>‡ ~øËð?Søqv‰¸Ó¦?¹¹UÀÏ_*`2"œ@ÈIFL\«"Üø)ñ÷Qø{:ÙÜo¹ÑØöÙRy2[ Fû¾fŒ‘¹l„rý½á/éž-±SÑ§Yíä¾òžñÊŸz9£# Aé‘‚vè¢Š(¢Š(¢Š(¢Š(¢‚3\Ä¿ƒZÄJêpùwŠ1ÔX¯ cÒXÿ éœ¡—’FÖæ¾=ø¡û<x‡ÀŒ×&3{§—0) p[3Â7ÉoŒ˜—‹8ýè$
âü1ã½oÂsùú-äÖ®NO–ß+vÌ‘ÑMúhŒ}Æ=ûÁŸ¶Ü
°ø’Ån1Ökf·QËA&c'É*@áAÍ}'àŸé5±ž‡8š•a®Œ:Ç,m‡ÇPa”†RÊÀž†Š(¢Š(¢Š+ÄÞ7Ñ¼/Ú5»Èmôózœ"rîHáTœ{ò-söÆð¥‹ìa»½;r¬¨#ByÂ³NÉ"Œî0äc'8ñïþ×>$Ö·Á£„Ó-ç˜òzÏ ØœcˆâÈ9Ä„G‰_ê÷š”ÆâòY'ºÉ#sîdrÎrI=q’N95>‰á­C[œZé¶òÜÍ‘òB…Û“´d !98Ë•¹ê~ý”¼e¬÷6éa#æ¹ƒ’O“›'ÁV1°$pFk¼‡ö!¹(¦mb%“0[f`p®gBÀz•R}y¯Œÿ fønWÙf×ÖÊ	Z~ð2~h‰£\Q—$*»ŠòëË¬ähn’T8e`TƒèÈÀ2Ÿf Ñc}5ŒÉqlí±°ut$2²œ««e<«>Äçë‚ßµlW[4o¸Ž^;ÓÂ±Î »Q…¹_ß¨òYg“ôÌ2¬È$Œ†V‚ ‚8 ŽAò¯ÚwÄ°èþ	¼†B¾eñKXÔž¥Èg w)»úq‚FE|¯û5¾ÿ ˆQõ’cÿ &?¦kô Q_;þÙ^+û‰g ÆA’öo5Çr•ÈÎFéÞ0!Yr*÷ìƒàÄÒ¼7&¸êú”§kcŸ*"bs“ÃH%ð§,h5ïTQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQ_,þÙ£)oâûDÃ’-®qß‚m¥<˜Ð±ÁÈhò@AŸŸ¾üJÕü¨hèÒìfdÆèä^¡& J²•‘	%[’§ïŸ…¿lþ hÑëvCË$˜æˆ°c‹ñ’¤‚!ãbxª“×QEQ\§Å?
økPÑÀIào/<âEýä-Ôr$U ä`óÚ¿6§B¬r0}==Gàr=xæ¾‘ýþ -–£?…®ŸÞ6ž<ä‘ þô° ÃÔÂÙÉÆ>¿4ŽÔ« A þ ŽàÖ~‹áÝ;C¡Òí¡µØ»,(¨Y™‚’I'žhÑEQEQEQEQEUw\´Ð¬¦Ôõ	V¶èd‘Ï`?™'@ä± rkó—â_Ž.|m®]kWYwùÿ kòÃ<´Æü`Þ»_Ù÷àƒüB¿k«òÑhö§÷Î¼‚¶Ñ¹û¬Tï™ÆZ4*£kÈ
ýÕ¦i–úe´v6Q¬6Ð¨HãA…U^T  Uª(¢Š(¢Š(¢ŠÊñG…ôÿ éòé´+=¤ë‡FýXr’!Ã#©¬üüøÃðºëáæµ&™6é-›2[Ìå¤D¥ˆ y¨~I”‡Ããl‹Z¿>.ÉðóYón6™r]"òp2c™S$“÷â.Ÿ{e}ùe}ôÝZºËªNC+ÊÊG0 ƒSÑEQEQEQEQEÕ¬Wq=½Â,‘H¥]¬¬§ ©‚+äÿ Ž²Ûi¢ox=Yí‡Í%˜š1ümmœ´‘wh]o,²~ìs¿ÿ i+¿˜t=xµÆŠ>T`I ?wÊÇ2À§ ÂFøÁ&"ByUöV­ÙkV±êlÉqm2†IäyŽ‡•8e<]Îhªš¦•mªÛIcOm2•xä•à†S}QÚ¾(øëû8Þø.Iu9Îrðg“Ž­œ*\dðBÍƒûÆó|FÖ<~/ôyŒRp$FÉI È	<@¨‘FNÜñ“˜ÝO_¸>üsÒ>"ÁäÄ~ÏªÅy­˜öû­%»õ°†êF=Ê²ª’¤úUQEQEQEQEQHÊ`×‰|_ý˜ôÅ.¡¡¢XjØ$ma•ºâhÔb7<:%'2,Š6×Ç.ð6¯á;Ã§ë6Ïo8Î¯Œ¬©þÚâÒ¡ð÷ŠµO\Í&æ[IÆ>h˜© r€ùd_ö$W_jöÿ ~ØšæšÉˆbMFÜ` E0	Ü¿¹÷Ã$Y9ùù }àÏŽÞñb¢ÙßGËø÷¸")Áb¡\…r $˜Ù×9ÁêåñV“ï’òÝTw2§Ð]´¿·¼_2ÚD•AÆQƒúeIÁÎ=*mÂ—4f¸'€:Ÿê}+‡ñ/Æÿ øqš+ýN9ÌQ5ò `¥!U˜´6ÝÙà×“ø£öÐÒ­KE¡ØKrÃ$ì"N£‘ù“WwÞT`@à‚My/ˆÿ kjá£·ž+ÏAmŒä~öc+gª¨`3µIãÈõbïR™®¯&’iÛïI#3¹ÿ zG,çè[ÕWÊn§êúýO°É®ÿ Á|YâÆV°±‘-Ûþ[N<¨ÀÆàÛåÜõQÉœñÆHú7á÷ì£i@\xžS¨ÏœùI˜á8l6|ül±H1‘œû¶ Øè°-¦™o´
0$=:(à““Ç&¯ÑEq>xÇ‘…Ö­Á>äñ’¯l	–Oö$Þ™çæ¾rñßìm©éë%×†î–ù" Ž\÷Q×÷±#€DÎ21“óÎ§¤Ýég{ÁqÚèêU”õÃ£`© äg†©e9®ãÀ|Sà¨¾É¦]nµ"—ÌŒtáˆhÇ+ªú(9'âÄÝkÇ—k{®Oæ´`¬hª#–8× o orYß
° WKû3Èÿ ¤ÿ ¿7þˆš¿@ÅðßíSâ&Ö¼k%œLZ;ã·UÉÆÿ õ²a[
	’XÑˆÈ!îôû#À¾_èV:Bg¶ñÆsŒä(IP’Ù$€2yï[”QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQX¾2ð—‹4›R]Ö÷I´ãªŸ¼’&rÄá]÷”f¿:¾!x&óÁzÍÆ‹¨Ë`8¤nŽTü²¡Œ­¾<åz—ì©ñN
ë/¤jRyvUÜÇåI—ˆ]‰8T‘I…Û0‹vM}ºFh¢Š( ×çÇÿ 
x¿P´UÛ’™âÿ roßd±ÀÊœœåI )Q\g†õÛ­P·Ô¬eÍ¼‹$gý¥9PFFU¾ë©8*Äý&ðO‰£ñFg­Â¥ò—iê¥‡Ìžû[ àÞ¶è¢Š(¢Š(¢Š(¢Š(¢Š(¢¾jý³|oö[O[É‰.í3(Æ|¸ÎØ†rç%ÀÆ’H9?"ÛFÒ¸DRîx ’O
 $– ÎOæ¿L¼á;/
éÚFŽPÇ,Ä$²I’GË9$òqÐ[´QEQU¯µ}>3=ä©C«ÈÁGýôÄûg5Æ\|wðE»¬o¬Úý6I¸À™*Àˆ®§Bñ6™¯Ãö"ê¸½«Ž¤rPœrç+NŠ(¢¹/‰¿4ÿ éiZ‚&A6>h¤ÆE=v“Ä©÷dL«„~wø£Ã·žÔ§Òo×ËºµrŽ@G!”œŽ¤I`nFS×5ô?ì¹ñÒkY­¼ª.ûiY–ÖlœÆÇ.¶ì§ ÂÄ?–A&!
” ¯ÖÀæŠ(¢Š(¢Š(¢Š(¢Š(¢‚3_>üzýš­üJ“kÞA­÷ä€`G>>ñN Šå¸!²#•€ Íæ›<ñ3Ä_õ-áPÿ é³)ä`2Íá£” •Ì ]pÜ¿~(é>?°[í.@%P<ëv#Ì‰ð¸Pœùr¨Ù"àƒœØQQÜ[ÇqC2‡ÁVV ‚¬§ ©85ñíû;¿…üAáô/¤1Ì‘ŽM¹=‰êm‰â90œG!Ù±Ç…éÍæ‹wõ„¯Ì¹«)û¤«H%X«U•—"¾½ø1ûUÚë¦=Å¥-o›åK¡òÃ!ãjÌ	>DÍÎ|‰À1±XÏÑ
Û†ih¢Š(¢Š(¢Š(¢Š(¢ŠÉñ'„ô¿Z›fÚ;«sü2.p¼÷‘‡fBz×—kß²o‚µLv1Ma.0)Y»ƒ—ŽàÊÜv8'œàž~ þË~'ð»4Ö1ÿ iÙŸ6ÝNðüôµ%¤S×ýQ˜qØ+ÈçµžÑÌR‚Œ¹\m Œƒ”“ ‚:pAEFL½×ÿ áW4j:<¢ãN¸–ÚU9´gÐÿ «*pÈ †q]Õ¯íã›i‹ªÌØí"ÆàýTÆ3ù×Kaû`xÎÙ6JÖ·œî’ßýßÜËàvùsîjy¿lH…U,‘ˆ 2Àùã|ì¹Få#=A¯:ñoÆø¬‘«_Í,gþY«yqö?êaØ‡A÷àò»rAäwJzgÃòTL¥zŒRW£|øI/Ä}_ì&C¤)æÏ  °\…T[2VÜªHeM¬Ì­òƒö¿‚þxWÂ 6—až:Ï(óe'‚O›.â¹*b‚2 ®Ûh¥QEPFk‚ø§ðoEø…hc¿O*õ]F?x§ÿ žÑg¢|Œ”£|Õðo¼	¨x+U—GÕSlÑ`‚¼«©Ï—,L~ôoƒŒüÊC#€êsÍW«~Ì6²MãÝ1£RÂ3;±—É‘wmÎ£ñ¯¿…RÖµX´‹)õ’hÞW$€ .ÙcÀàu<
üÙ¹Õ¥Öµ¶Ô.y–êçÍ¬’	ÿ €îÛŽØÀà
ý2NƒéKEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEWþÐŸ“â°ÔôÜ&³mÔÏ2\@ì~ã«0ÉÐ3q±²¿ßé÷MËÚÝÆÑMtpC8du<‚:2Ÿ¨$OÚ?³Æ+oèñxT¹Úö™Ž1+|ÓD>h™±æI~îU¸$nW»ƒš(¢Š+åoÛ[Ãƒ¦ëÉ+	-ŸÔ…ÿ HŒú|˜‘Os½{-|¬ŒQƒ æ¿@ÿ fFKÿ i­63––9d‰	É?1UBr@+Óè¢Š(¢Š(¢Š(¢Š(¢Š(¬OxÃMð–&¯«Ê"¶‹ñfc÷b‰z¼®xUS…Ï‰¾:¹ñ¾»u­Üü¾sâ4ÎBF¿,1H%—eÂ´Œì®ïögøS7Œ5äÔ.];MtšVçæpwÁ‘ŽYÐI&V%óÑkîáÒŠ(¢ŠkÈ¨1À$ŸNä“Ðç¥xÄßÚ·@ð×™g¡ãT¿C·*qž3¾qŸ7ns² ÙÁRéÉ,ëÞ+ñWÅ]QVàÍrç÷PD¤ªqû«uÊ".í­+å°3,ÄŽ:?øf>Ñö~]Û~Ñþ™Û³wßí·w^3Þ¹Éô?|4»MFH®ôÉ×fÁPsÈF•wÁ ;yŠVl‚+è…µ½¦¥³Mñš­¥ÏAvƒ1ÎÏ–·c‚Ð“’LK_GC:L¢H˜209„Á±Sè¢ƒ_5þÖ¿[R·>4ÓW3[Fíx×!.ËC¸¬¼ÿ ©Ãc÷uòÇ„µ!¤jö—î7kˆ¥#8Ï—"HF{p‡'°É¯Ó{y’dYc!‘À`GBÈ ÷Š’Š(¢Š(¢Š(¢Š(¢Š(¢ƒ^GñÏà%§Ä+¶Ù¶Ö¢\$¬>I@û±\m¸'÷s Ï ‡BV¾;±¾×þëþbo³Ô¬œ«+êc	mæŒ’)FC€Wìï…´'‡üuVÍ*ÙjÌ kiN76	o³Hp³¯€•@ùã^þ¤h¦\AÄmÊ7YXdxee<#‚pkãÿ ³$º}{Âq¼Ö“5²ÏpÑ Ën9¿4° ¤ovÏœ†è›?çÈƒù•ï_¿iÛß
ùZ?ˆKÞi[‚¬„–šÐyyÉš;sè¹13 #¯²t]nÏ[´‹QÓeYígPÉ"‚ò ðÊpÊAUÚ(¢Š(¢Š(¢Š(¢Š(¢Š+?RðþŸ©‚/­¡Ÿr•>djÜ«–àäñšãµ/€>Ô èöË·8ò”Å××É)»ÛvqÚ¸?þÇ>¾\é—6R–/\ä¬ ?O”‘BsŠñO~Ê~'ðÌ/yfR¶Œe¾|À;±¶`]€ïå<‡;09ñVB§üÿ Ÿþ±æµ|+á›ßj0ijy—W/± dà±%
ªªÎìxTRpNýƒáOØûÃ–VjšÜ³ÝÞ´rr±¢|ÅAèò1vàü£åe·ìÏà(Sû1\¯ñ<²’}Øù€øWñ»ögðü>¹Õ|1jmo¬ÐÊcGfYQrÒ©G2b@…š6LT!§ñÌ‰°ãüý¢¾ˆýŒu¸-|Cu§ËÄ—V§Ëärb1—žI)&àxG' 
û*Š(¢Š(¢Šñ¯Ú“ÀvÞ!ð´ú§–¿nÓž’wòÁiˆ	(ÑåÕN ‘îQ¸×ÂN»IŸç#Ú½ÿ ö4ÒÏŠf»Émg!Æ:™# ·A€¤ÔóØûN¼“ö¢ñ@Ðüum²ê¶«Œç—› #BI¸ ©#9#?h­¾ú#ë*èk_¨iÐRÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEžµá¿´/ìÿ ÿ 	âgCÙ±íuo•gQ÷Uœ¶xÆV'`U”ùnBíeø¶öÊóB¼kk¤x.`puaÈÈ8dqÁVTb9¯¹ÿ fÏŠ²xëB0ê¿S°ÛÌzÈ„~æàï>ÖI;ccß×h¢Š+çOÛWþ@zoý}?þŠzøáT±Àÿ ?áõè+ïÏÙŽÆöÇÁ6j5»y“<a¸/»M¥·ªÃ%T?F½ZŠ(¢Š(¢Š(¢Š(¢Š(¢Šù“öÎðÎ«ume­@ÅôËmÐÈƒø$‘—dÄÈ’[ø¤­_&[À÷ÑK³Q’O@ ’XáT Ib œWè¯Áo xf×JpÙ_:äŽòÉóH	 dGÄJHÎÔÜÑEUmOR·Ó-¤¾½‘a¶…É#œ*ªÌÌO@ þƒšøcã'í	¬xæâm>ÍÍ¶¹•!L©‘8
÷lp\¶7ˆ¾HãÄŒ	«?¿f{Æi£¨ŸìÝ9¹*“#®G0Û¤!Ù$¥Œ2#®}uðóá~‰à+O²èÐ…‘€Îø2ÉŽžd˜¨9Ûâ4ÉÚ£šëp*ë/¡{k¸ÖXdYR;†VÈ ûŠøËö“øžuý
é7µã"	OÝUÉÝäMÿ ,ÁÈ‰ÁpG@!ý>>Íá¨ôj]Ú,ì g?ñîÌp$BxìÇ÷Ñð±“ç&Ð$SöÄR	:ÊFA<‚êäâEÅ¼w1´3(xÝJ²°È Œ2°<A ƒÁùÕñ“ÁQx'Åš=±Í¼.,œŸ.EÆŒORŠÆ2{…NkëÙâ@ñw†’Æá‰¿ÒÂÛÈIÉtÇú<Ü’IhÆÇÉÏ™Ã
ö(¢Š(¢Š(¢Š(¢Š(¢Š(#5Á|Tø;£|E´òuòo#ÿ Uu1;ì9–ÉÝü§;”«…aðïÄo†zÏÃÍDØêQ™-Ê—*ã…ÿ ¼£Ð‘49çŒ9÷Oÿ µJÄ‘èž4í]©é‘ÑBÞr ÇúHfýaúšÖê;¨Öxd‰Àeu «ÈeaÀŽ„–‚3_;ürý—íµñ6·á8ÖH–’[|íŽcÔ˜‰ù ˆéÄ2±Ëìbd¯oì'°™­®cx¥CµÑÔ«)UÑ°ÊÃº°ÏÔ`žûáÆÍ[áÕá{sö‹×[;þÚDSÒÃ%0Ë÷'€>#i>;Ó—SÑ¥0‘6‘7x§$«2ŽèÙ”ƒ]EQEQEQEQEQEQA ×Ç_µwÁ±£^i1âÆíñrˆ¼G;õ§îIà¸Ÿßqçß³¿Œì¼'âÛKíM„v­æBò1ÀA*ìYàüŠêÉÀUbìÀ)¯ÐTpêH Œ‚:Bp}ii²"È¥¤`ƒÐƒÁwpE|eûAþÎáU—Ä~f“»2CüvûŽ¤¶vƒþ²T0xÔ²ø÷Ãÿ ËárÓZˆe­%W+ê¿vdê>ôEÆ3÷¶ç8Áý'Ó55h¯m<¢ÉAV•ÎAêÍQEQEs¿eX¼9ª;ª,®9=?Õ¸ëõâ¿4%ëøä+ë_Ø›I	gªê[‰/$0c|ŠÓŸïfr¤v g“_NWÇß¶‹MÞ³i Fwešàùi7
Ær°Ç‘Î1(#½|ë§MäÎ’sò²·x!°=Î0=ñ_§š³m­Ø[êv.$·¸dF98ÈèÃ³;Uú(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šy?ÆÙûOøŽRú9~ÇªF¡<Ð»–DªL™RJdì‘:†e9R ù²oxÛàª5HÔy
”-¥Rr"›î´mœWòäVÉÜê„ŸtoÛ"oK]T}ûWq“ã€¶Ó4gØoC•udúX9¢Š|«ûjx¦:vVž=÷2`ò¡‡‘‘Ó÷€Èüœãy—ìÓðé|câxÜ{ì,GÚf|¬AÛLr?ÖL7• †HH œ}ì«ŠZ(¢Š(¢Š(¢Š(¢Š(¢Š+Ãÿ kígì^[E`îî ŽJ¦gm¾›Z4$údw¯›¿fß¦¿ãM=&UhmÝ®X1ÿ ž*]00rDÍm8U²kôŠ(¢ŠùƒöÂø’öÑÁàë*eQqwŽë’-àcŒfV™×9"4cVg?ÙâÊ+oø’-ä§Î··”ˆ§ýTò§Ì$™ÁócY8„2‚PHúUW
Z(ªö‡k¯XÍ¥ê%µ¹FŽE=Õ†fU‡*Àr+ó¯â—€n|¯O£\’Â3º'?òÒ&Ï•.:|Àt+Ž„
ûöRñæµàØã½þƒ3ÚÄíüQ V(+“È-þ«ä=ŽŠ(¯“m?ùw6>$ˆq25¬§Ñ£Ý4'¯VF˜p?‡$ð¢¹_Ø÷\’ÏÅß`˜¯m¥B1˜öÎŒÙçåP0G2s8ûrŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¬_ø7Kñu‹izÔqnÜ€x*Ã!d×‹“‡R	 ‘_|dýõ_‡åµRo4Ü\†'—(ÊHÂùèNØ",£ð³ö„×þ¨±ˆ­Öœ&Úláz–ò$\½¹f$‘¶HËdù`ç?bü2øÉ¡|Bƒv™!Ží4¶Òñ"t‡U–-ÇXÉ^›¶±Ú; sA¯-øËðKø‰	¹èÚ¼hDS¯FÇ+Ò™#Éá†%$£c*~ñŸ‚5OêizÄ-Ä|àòOÝ–7,‘68uèAWà­IàŸêÞ¾]KF ™p9W\‚c•FHåNêŒÍ}ÃðãÎñ?³©ºª(/lì>n2Ò[7t@†`K?x€'ÔÍQEQEQEQEQEQTµ×Y´—OÔbYígR’FÃ!”õ¸=Á*@ ‚+àoŽ¿
eøu®!ÜúuÀó-dnI^’E!ÀX˜í~ï$‡–jú›ö\ñ¯ü$~ŠÖg/u¦±¶|õØ>kf÷¨¹†8¯`¢¡½³Šö¶¸PðÊ¥OB¬6²‘èA"¿9>+x"Ox†ëF9)ƒâ‰¾x=ÈB¿ÛFú­d¿gÂCN‘‹M¦JaÁëå·ï <VhÁ8æ2Ê{eQEQEpßg‚5“œ¢H?<~9À¯ÎÉ—2°Þ ~u÷oì£¤5‡‚ ™·w<óá†8Ýå!\€J:D®¾î8Å{×çoÇ­pk>3Õn¹U¹h†þÂ-ö’‡ÊØç©¯>¯gøûAÝøOìÍ@5Î‹+dÆÏ––Û<nZ[rU]þxÊ»0“íx§Mñ=Œz¦:\ÚJ2®¿‘VS†GRdpOV­QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQESTÓ-µ;YlocY­çCˆÃ!•†H=ˆ?‡Q_|jø©|9¼7ÖaæÑÙ†àc$€±\2ÿ ª•NÕI¾U›åee2×Sð‹ö®¿ðò.™â•’þÉp©( Ï]­¼¨¸@Fö‚Hß Æ>ðïÇ/kê¦§9òæo%Ç;pR}‡9Æ1œ‚È ×].³g
ež%FâÅÔ %‰' Ôž+Ì¾"þÒžð¥³‹+ˆõ+ü|ÀÛ—8§]ÑÆœŽid">%×uOÆº´º…Öë›ëÉ2B)bXð‘ÅÜÄ*QŒŠ?Ú5÷ìíð¾Ox|%òíÔ¯XM:œ|œmŠß+Æ$ûÄñÒ½RŠ(¢Š(¢Š(¢Š(¢Š(¢Š+æ?ÛkTHìô­?{É<¹í…Uˆ©i”ý®;ö.·ŽO]HêÇbÅIìLˆ¬G¡+Áöâ¾Í¢Š(¢¾ø‡m'‰þ(\Ø\ßhÔÒ×œ°4pª¼ãÊR§d³ûÆV%ƒ
  = àÀSè¢Š+æOÛ_Dì´Í[‘:I-¿ÁFO<n8ÜJ<_'8ßŒšï?eIün‚V{}¿zÌôÈ ýk×è¢Šð¿ÛG7¾K°Hû%Ünp20áíÉcü y ç¦p;×ËßüOÿ ß‹ôÛæ8O=b~Ÿroôw$· )ubrU>¸¯ÑQEQEQEQEQEQEQPÞYÃyÛÜ"ÉŠUÑ†U”Œ2²œ†Vx"¾Xø¿û$H¥õO|éœµ“Ÿ™GýW8qœŸ*fˆäè•ó¶“«êÞÔãº¶ilïí_Œ©WFèÊñÈåNÙ"‘pèpÃHû»à¯ÆK?ˆºo˜vC©Á…¸€7|dM?9†NHÈÌl6$®ãéšåþ!ü:Ò¼w¦>—«GœóªøŸød‰B3ó!ù$RUÁ¾ø­ðKYøys‹Õó¬d8Šê1ˆß¡ÚÃ,a—ŸõN~b”î8Ž¡qa2ÜZÈðÍÜ®ŒU”ŽŒŽ¸daÙ”ƒÛ¦E}Wðkö²ŽpšOX#üª— pz(h í9É7x9‘cÁcôä3¤è%‰ƒ£†SAèC‚¨â¤¢Š(¢Š(¢Š(¢Š(¢Š(¢Šä~'|7Óü}¤I¤ß®$Áh%z)0BÈ=Tçlˆr®„‚3‚>5øKâëß„þ1û.£û¨D¦Òõ	À»iÚ…ÊÏÿ %¹Ãñ÷º0ar=GéŠZ+åÿ ÛGÁ¾l>&~e&ÒbœËnÅ€è®$Œn8h5ç¿²?‹[GñbéÎØƒR¡aþÚƒ4À'?,¨	  üž ?q
(¢Š(¢Šñÿ Ú¶ù-|sguÄöñ.=|Å•ƒz)Hœ{œõð|DïÜ:ŒŸË1_¥ŸtOì?éºnÒ¬JÊNHm¡¤ïó–éÀè8®‚æt‚6šC„@XŸ`2N;à×æ‰/Î£¨Ü^³iå’RÇ‚w»I¸ŽÅƒGlÖ„¾kž.Ã¡ÙÍtWï_•{€ò¹H°åUœ3@#³ÄÞ Öü0æ=fÊ{\*§¯Ý”n‰ú»!ÏlÕÿ ‡_ujÿ J”®p%‰¹ŽU;&C×…‘q,{ŽÆÁ*~ßøOñ»Eø‡n«jâßRUÝ%¤— ‰¸Å’>t\"£q^‹EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEEqmÂ4S*¼n0ÊÀGpÊr>„WÊ?d[ëM¯<!äý†b[È‘Ìf#Ô¢1Yç;ÊÑŒ'*«ñ?Á¿x`ìÔ´ùÖ<®«æ¡Æz<h ·Î¶ò@é\c©Úà‚ }AÈ?ZÞðw€õŸ^%†n÷XT|ˆW–\yq ÆIc¸ÿ 
± µ>	~Ïö#×L·ZË¦\|‘gïÇlû­3þò@ ùì¯[QEQEQEQEQEQE|‰ûmA8Õ4É™³nÖÒª.z2È†VÇmÊñçžÂ±cXnÅs<-ˆ’ÎC(õãŒz¬™nÜWÚ´QEŒ@=~tonóz‘¸ÜÙ ârr{ãËÇ° zWèº8u¼ƒÈüy´QEó‡í­uèÚlê%k™TžJ¬L¬Áz•VtRzê$Vìa9
]¡#ä¿èp·?RN+ß¨¢ŠòÚ¦òKo]GÝžh#sŽŠdH=îUã©ðæ‚s	=åÿ CZýB¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šòÿ ‹ÿ 4ˆˆn›ýUUÚ—3» ìKˆø ÎdJƒ„p8¯‰üOá=wÀ¡´¿ŽKK¸X˜ÝI]ÀqæÛL›K¡†C‘²*°"½óà—íZÈbÑ<håÔ°HïŽ2 ð¢ó¦åÎí+Êç3®3%}X<Š*¦©¥[j¶ÒXßF³ÛL¥$ÆU”ðAÛñA¯‹~8þÍwÞ2ë: k­ì &H¯ïÇ&HPgý!FUW3æCáD>„Ÿò{×±üý ïü	:i·ì×#7ÍÅ»–’Øõ™ Ï—&[`IÝöç‡|G§ø†Ê=OH.­%û²Fr8à©î®§†F”ðÃ5§EQEQEQEQEQEò'íoðºþ-M¼ae’ÂdE¸dÇ"(4ÀsåÌ†5ÿ  G*6ô¿ÙsâÇü%Z7ö¢ùÔ´Õ
´}Ø¤9 —‹L½OÊ’1Ì•îW+ñCÁ‰ã/Þènùâ>Q?Ã*þòà¯Ý•W<€W ðH?ŸÔ§ð¾»o|Á¢šÊå$eäcqæÆÛ~lad‡ñ®q_¥–—QÝD“ÂwG"‡SêÜâ©h¢Š(¢Šù‹öÙÖÞ+]/JQòÊóNÇwt	½3³=
`u$|¹á‹Ô5+kI+4ÑF@êCºÆÀ{•f÷+ôöÄH#_º ôÐW5ñGU“Ið¶«–)Ý	é¸#làõË`c¹5ùÅ¦é³ê—‘Y['™<Î‘"ú³/âÄgÛ'±Çèÿ ÃÚø'D¶ÐìÀÄ)™»È~i¥cÔ–rqŸº¡TaT½§[ê½­äi4­ŠXe`T‚=E|§ñßö[Ëâ¡6ë—šÍy(:³ÚõgŒrÍ%×$ÂJâ:ùªÎúãM™'µ‘áš3¹6*Ê{<r)­Ó¤ÃŠú‡àÿ ío¸Å¤ø×œ«z£§ wàc æâ!Ôƒ$J2õõ•ô°¥Í¬‹,2¨dt!•ä2²ä2‘È â§¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(£›EDl¡=Qï‘þøíã‹>Z…Ï\~xÅ?¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¯‘m«ISÒî‹æ'¶•=$FwôùÄ¨8çäçµRýŠHÿ „†øcŸ°ñÿ S?Óò¯±è¢Š(#5ùµâ]#Å7-<eVÞöFdÆs!@( ^Ç#·5ú=§ÞÅ}oÝ¹È®„r
°¤Ar8©è¢ŠF8é_~Ñÿ _Åþ)¸òœ=‘6ÖàgC‰¤à™gw 2‰Ÿbý‰ušÏV²ù«$cm(Ñä™Þ„§=«éÊ(¢¼«öž»ŽßÀzŠHpÓcAêÆT!}¸V9<q_ØÜ›{:Œì`àzí!ñí¸ükõ
ÂçíVñÜ1±é†jz(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¬_ø?Kñ]‹éšÌ	qnàðÃ•8ÀxŸïE"õWB5ñOÆ/ÙÓVð`÷Hê'-ä•ºEû¸™•|–1¶AëþþÔ7:3Ç¡x¹Ìºx
‘\žd‡/Vž 1óœÍ&Då~¼´»Šî$¸·u’)2:U”Œ«+X‚8"¥¦º0È<PG¡¯—¾;~Ë‹0moÁP 5’p8äÉh§åûÖÀ€x0íl£|¥4˜äe${ÁGB¤^¡ðâÄþ×aóä#JºqÒò…o”\`ÀÛ]œ|Æ"œáJýûé:,±0taÊrìAÄ}QEQEQEQEQEí”7°Émr‚HeRŽŒ2HÃ+„pká_hÚŸÀÏ­ÆžKAyöÄä,¶ìHkyH'q
g’ËØ–¾æÒ58uK8oíŽèn#Iÿ ²À:þ‡ð«t•ñÏíqðÍt]R/ØG‹kö"|tYÀÎã“ÇÚcày‘·ñ?Íì_²Ï"ñ'…bÓ]¿Òô­¶î2cÆm¤ …1þëŸã‰‡#û%QEQ_*þÛz4†M+TU&2“@Í‘€AI£sœ•’@#å qŸø.›üa£ú~€þMŸé_£Â¼Ïö‘Ôc²ð.¦$83"BžìîG°<äôšðÙáÒjÚ¼Þ*ºP`ÓØ¤ ž³¸Îâ3ÿ ,`|Ã‡”Ê}ˆ(¢¾røßû,Å¯É6¹á0±_9/%©!c‘¹,ð61®ydoÜ»Ù‰còn¿áÍCÃ·oa©Á%µÔ_y$Xz69ÊžªêY»…õß‡³c'›bÄ-d'ËnrÆ>¦	O?¼ˆ`œy‘¸}³ðËâæ‹ñ
ÔÏ¥É²æ0<ëwâHÉúIrhò‚2 vÔQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEòí¿þ¿Gÿ ®w_ú½sÿ ±u¹ÝJ€KÊŽ‡2 ‡|c+ïšû:Š(¢Šø›ö±øo&¯ÿ ÂAj	³Õ	žÉ8ÎŒœc¨¦ã’|ÐWgû1|~"ƒÁž qR#²ÊAû¶r“÷-œ®¸„í‘SÔÀÑEæ´_Ž¥ð„®'³“Ë½º"ÚÎ/þ¶Eä01Â$`Ê	VÚHÀ$~~;n9ÿ >ÃðõWìI¦Î§U¾+þŽVCz¸2JÊ=v¤ˆO¦@î+êEWÍß¶ŠþÉ¥Øè1\Ê×ýÈ†Ø÷dwžEa‚îÈ ƒ_&h‰/aB2HÆ|ºŒ­~¡¢„T`€è-QEQEQEQEQEQEQM’5•J8¬ Œ‚x Ž<_1üaý“#Ÿ~­à±H2ídN<±6’1Ädž9öâ&øyñ«Äÿ îÿ ²®wÉe…e²¸ÈÙƒûÄˆ·Ík'àfÍ¼Çµ·Ÿ´üñGñ’_è×	(`G‘æFpG4@îG\€r0x*JOIEx‡ÇÙÆßÇDë:1KmdI»„¸ aD¥GÉ:p±Ïƒ”ýÜ¡”!ãxWRð½ëéºÄku	Gó÷YYIGFÁÛ"3+`àä^‰ðã,¾Öc„²`cž0K*g•¸H²@hX|Â5Ñ3áXª©ûÆÂþøîÒEš	T2:ÊÀòYr#EXÍQEQEQEQEQEä´ÇÃ6ñ—‡þÕcýON&h±÷™Ä*pNJ* Fd‰FN|§öZøàl&Oë²æÚVe#6H¶f$*^f9	ˆü¬€}jh®Kâ¯£ñ¿‡®ô7!d•wBçøeC¾íÆð¹å‡C_üñE÷Ãÿ Aitšqeu=7·—óò'*áóÂoeÈûáih¢Š(¢¼3öÃÁñ3 Yo¡ÚHYÚO##ƒŽ£­|çû2éOã8ªH^I›$p7ù¹êVGŒ€2sÏjûøt¯—ÿ mOÇäéÞFag»uÈÈ  $}à<¥r6¶Æç)]ßì™fÐxÛn.n$\zoò¾o}Ñ1xÅ{5Q\çŒ¾è~3·ºõª\ªýÆ<:g©ŠTÛ$yÀÎÖ ãkå¿‹¿²uæ…š¯…ïlÐxftÇ°r€-…I”.@˜ð<B×oü7{¡§Jö÷P6ätê¤px<2žVHÜuÊH¾ŸuüøãgñÏÉŸe¾³n Ï <8éö›}Ü´,xt9{w;*c‘ýPÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEòÿ í·¥™-ô›ð~ã\DGûÊ’çÿ  ö=ù®ö:×"±ñcÙÊ@kÛY#L°22Ï€Þ,Šø çåcŒkíš(¢Š+™øàkOè—ïeÌoÞ9æ†UÇ?#‘Ñ—r«_œzöu¡ÞÍ§^¡Žx£‘OfSµ‡8ùI”÷R¬:Šõ_…´Î»àÇ[]AŸQÓ Ç“+üé×˜'}Ì¸Ïú©Æ@Ây|WÕŸ>9xkÇ@GaqäÞw¶Ÿ	'Õ9)2äýè™ýñ^ƒšÈñ?ŠôÏY¾£¬ÜÇklƒ%œõÿ e|ò9àEf' ¯…>=ü`“â&®$·ß™j
[ÆØÏ?~w¤³a~\Ÿ-S;‹×á__øŸP‡KÒâ3\ÎÛQGêÌGÝÍ#œ@I9 Ñ…ÿ í¼¡A¡Û‘# /4 cÌ•¹–M¹8áQrvÆª¹âºÊ(¤cŠüóøûãøL<Wy}n·‰¾ÏOõp–@À‚AHe”ôuú'@b—°°í,gÿ S_¨Jr3KEQEQEQEQEQEQEQF+Éþ6üÓþ!Û5Ý¨K]n1û¹ñòÈHn‚òèG	(XNÖRËº6ø»XÒµï‡ZÉ·¸Ùj6¬
²¶Qâ‘8xŸV°C&C ú“áíW¥êöñéÞ.”Yê…ûCC/ïw-´‡z¾"'æÚ¿AÆáÔ2At#¨ Ž=ˆâœFk„ø£ðsEø‹GªŠæDWA ²Á’HØ€v:+´ó_"ü]ýœõŸ‡àßÂßmÒÇ[ˆ×iœ*ÜE–1ç 	T´Dà1Œõó+]P²O"	å‰nØ’:ŒŽClFU	$šûƒö_ñÛø›ÃõÙºÔ,äxß{fO/; i|Î
6Ñ!Îvá˜°5ìTQEQEQEQEQEžµðßíAðÅ<âí==
éúžéTs„”×1Œ*±ež%Ý…áˆÔWÑŸ³ÄïøM|8‘ÝJ$ÔôüCqŸ¼ÃŸ³ÎÝÿ }á˜õ•$ô¯X €z×Ê_µçÃU´žØ|žs,Ap>|"àcì«å1Ï°·I¯køñþ[_ÎáïaýÅÎ:ù‰ÆòO96J8Àí^…EQEó§í©!œ™àÝ9#éqßþ¸Ø¯CKrûS|kj¨ ŽA™È.§ Â@Tñ’Æ¾Ã¯€~+ë_üy<v ÈÒ\­¨ä‚±±†3À%cy<Éœàa	b7Ÿ¸|á„ð¾‰e¢#op$Eºn |íÀy²zgžy­Ú(¢ŠB+çÏŸ³\~(ó|Aá¥XµL–ß¢ÎGVCÀŠå‡?»™¶ù›[2WÈÚ^«¨ø_QK»7’ÒúÒBU¾ë£¯ÊêÊÝXæ‰ÁVRR@T×Üß~6EñÁá»	¯jœ‹®§…¸‰NHRß$‰¹¼¹3µ”ŸWQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQ^KûOx9üGàùä·]×{­Ú€2J¦Vu^	ÿ RÎØn(8Í|Qà?ÉámrÏW…Šµ¬É!#œ¨8•qÆCÂÒ.2	Î8Í~—E(‘C¯F Ç‘ú}QEWˆüxý-üxÇYÑÊ[ëAB¾ï–9Àá|ÒÊ“`å@Ž@Ê§ÇºçÃ­C˜Ûj60:œ|Ñ>®ÙZ7ŽQØr9ÏšÚUí°ÜñH€s–F µ–PÞÈÇ¨­Xþ x–%	£z¨£ -ÌØÀà‰1€:Æ:Vn¥«j:Ä¢kù¥¸›CJìíŽÊ­+;}y= æºï|ñ_‹~ÃdñÀÜù÷ Åd6÷]òÆ<˜ä$ÁÇÙŸþ
iŸí€ý£Q˜5Ë(Ž¾TKÏ•o›nægošFb=Š(®ãwãð?†nµÿ ¥J¦eõ•Áz¡Û+À„CŽq_sHdbÄçÜÿ 3îzŸRI¯BøáEñ7‹ôû)Wt)/Ÿ í²çrac\†®FE~‡Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( ×ñGáñÌ[êjRæ |‹„ûñ“ÛÒH˜à¼/ò¶26¶|=ñ/á·ðöôÁ©E›vb!¸Œ£Â1å\‡‚L8Á+æ'Î}öwý¡„äˆdvÑßý\‡,mÛØrßfãEÏ’Ãz ŒÀ}“¦êvÚœ	yc*Oo(Ü’FÁ•‡b¬¤‚>†¬Ôw6Ñ]FÐN«$N
²°H<2²œ†R8 Œ_)|wý—Æ9¼Aàôfˆ’k%ä ÆYíVŒY­É, Ÿ í*ùÓÃ¾$Ô<5}£¦LÐ\ÄC#©#¸m­¿àoGRARkïo„?tˆ¶Á-Ï‘©Æ¦¶cÈþ$-ÒhwüÉ•ª1ôj(¢Š(¢Š(¢Š(¢Š(¢Šä>)|:´ñö‰6w„üðJFLRŒùr‘‘ÉI#|lËÆs_(þÍãSð¯ÄXô+‚awûMµÌg8>Z´€‘œI¼nA&6$pù¯·EË|Nð‚ø»Ã—Ú+c|ðŸ,žÒ/ï!oøŠ§<ã®+å/Ù'ÄÓé,m"Wòà¿…Ñ¢cæÇ‰"ÂŸùh MSƒ·p<¨íj(¢Š(¯•mùœ>'a[¦#¶AAÇN·¿5©ûÚÄºv«8P%3@¥±ÎÑ`¤úf z±õ¯zñ¿ˆ#ðö‹}«ÌHK[y%à€IU%UIÀÞÍ…L‘– WÅ_³q©øöÊä|ßfO)bIÇ–ñ3rK4Ó©ç©,s‘ŠûÄt¢Š(¢ŠÍ|«û`ü.Ž1Œ¬#½„7›Gñ`-´íîqä;¤ÄOJð/…þ9ŸÁõ¶·â°?ïP¿|³ÄA*¤²|Ë»"!ê3_£Ún£¥mí£‰ ™ÑÇ!•€e`}Á«4QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQES&eCÊÀ‚px ûpkó§ã'€ßÀÞ&ºÒHÿ Gæ@}`“-9nc $€7Eœ E}Ÿû>øù|eá[iå`×–€[\óº0HsÉó¢Ù&{’Ã$ƒ^•EQE¤Ú)³AÈc•C£`#¸ ä}qzŸÁêrî´‹C!bÅ–=„’rÅ¼­›‰<üÙïëZ:/Ãhr‹3K´·™FÐé
ÆAûøÜNT“œ€s]6(¢Š(5ó'í§â‹Ac§ø|6o<ÓvÊÝŒ$!a×÷²Hv{Fäð+äzúKö*Óá“Z¿¼aûè­PäðCæ|¹ÁÏ•ÉŒqŒœýƒEQEQEQEQEQEQEQEQY¾!ðæŸâ+'ÓuhêÖO½ƒ#ŽCêêyWRO*A¯¾7~Í7žY5ÍšëHRþ¶{Í´$!ºN»Y2<Õ k‚ø_ñ{Zøyz'Óœµ±aç[9>\ƒ¡yÉòL‹¹Oß™Zû¿áçÄ'ÇšrêZL œbXX2&î’ 'ý×I„ƒ]M¯’i_Ùîæ§ñG…í÷ÚËó\ÛÂ¤´oÉkˆã\î†N²¤kº'ÌYö|á¥j×š-ÔWö2<7¶èäC‚¤q”aíÁ†+‚2+ë_ƒŸµ…¶¯³Jñ‹%µÑÀK°6Äçž.îÛ¿ÝÃ‚arOú£…¯££‘dPêAR29ApAàÓ¨¢Š(¢Š(¢Š(¢Š(¢ƒÒ¾_ý«|&umñC-È•á£áƒ‹[•a÷[åòà†Ì[†gÖþüG—Ç¾‹P¼(oáv‚ãg ²ò’íþ:2’mÆ2[hÛŠôZ|/ûBøûÀž,:¾ž­­ä¦êÖUè’ç|‘Ñ^)¿z£¡‰óÈY+ìo‡ž'>)Ð,5¶{»t‘ÀÈÄ A `=†{×EEQE|“ûnA Ôt©‰ýÓ[Ìª=
¼eÎ?ÚƒßoµSý|iª^h7rùbö5xwÉ!ÔgÌxvÁ7zë?k?‹vÑYÂ¥Ê$»•®öœ„Œaã™HIÜ+2e¶Â§z"è?dÏ‡K èÄ7#ý3U—=V'É31-;	
W»QEQEŸâ
×_Óî4«õßmuE öaŒƒÙ‡ÞR9ŠüÐñ.”Ú.¥s§3n{Yå„°îcvˆ°ïóÝž9=Júsö<øŸquæx6ù‹¤hÓÚ“”<ør¹q4c¹‘GÊ£QÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEx/ígðÍuýþ[UÍæ–¤È {rAHæÝ¿~½~A*óWÏ_³çÅ?øWþ tOömæØn€Ç$ÅqÛ?gf%°Nay0	¾ü‚U™HÈd` äyÁrqO¢Š(¢Š(¢Š(¢ŠF ž•ðí%ã«Ox®k­9ƒÚÛÆ–Ñ¸èþYròõS,Ž¨‰7B	òÈ×sþ~¿AÞ¾íý—~/…¼2šÂm¿ÕvÎù¬xÅ´Dà¸L¬I%aØì´QEQEQEQEQEQEQEQES&…fS€20 ‚2<Aà‚	¯~4~Ëz–‰4Ú·…‘¯tÖfsËýí7©ÊÆcdMªé&Ó%x¯…|]©øJú=SHà¸NŒ‡‚8%~ì±1tN
Ÿö[‘ö·ÁŸÚ+KñöÍ6ô-ž´Cb’íÁ-o#c-´îh÷ªÞŠ^½„ÐFkÊ¾%þÎ^ñªIqBÃRpH¸@»àâ9†~ñùe#îÈ§šøÛâ?ÂgáýñµÕ"""ÄE:ÿ «”v1¹È¯&)1"ò0àn=ÇÁÚCSðCÇ¥êÅï4eù|³Ì‘ƒìÎä|«Çú;¤q!ÂŸ³<'ã=+Å¶k¨è·	qc%O*zì•7ÑÀ ÖÕQEQEQEQEVwˆt?ØO¤êq‰­.PÇ"ŒƒèÃ¬YHe`@¯‘ü¯ÿ ÂñýÞƒ¨Ìÿ ØÓ7—#¸þ<Û;²¨§s cÅ1•29Q°(ûNÔíµ+xï,dIíåPÉ$lXC+.AÔUšòïÚKÂGÄž¼X£\Yí»‹ŽG”wK³ý¦€Ê¿CÐñ^Aû!|R–+–ðUó+A ’kF<ü<ÐŒŸ™%Rf@åq.råúÀÑEQ_9þÚZ ¹Ñl5` µµÃB[<…™rÞ„"BOQ·Þ¾9VÇùÿ ?zGÀ†‹ñÄ1é×$­”Jf¸+ÁòÔ…ØÆÎDeÊ®ã×i¯Ð[KH­"K{u	jFª€ªª;P ‚¥¢Š(¢Š+˜ø™âçð‡‡oµè£ó¤´ˆ²!8‰›÷C0fÇ%AœWæö±¨Í©]ÍytÛçšG’Fé¹‹»`p7;Àé]ÿ ìë®®ã]2y
ª¼Æ[¦&V„Ž¼¢¯l¶Zý	4QEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQQ]ÚEyÛÜ(x¥RŽ§¡VYHî$üñø×ðÒ_‡Úüºjå­÷¶ÎŠ&$*±<„ƒŸÞÂ¾ú÷OÙSãrM
x/[#Æ1c#±ù‡?èl[#røöÉ“÷ nEÝôþh¢Š(¢Š(¢Š(¢¼ö¬ø®¾Ò†ôùJêWê<Í‡!‰8;Zà¯’£†òÌ®>ï?39?çü§ ¯UøðfïÇÚªK4et{WSu)àa¾Ëþ9¥Ä11g!Ú4o¾¡c@ˆª€   =€Ôú(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(£¼_ãOìÝ¦xÝeÔô –zÑßƒåÌ@Â¬è¿qí®ð>úÈ£m|i¯øwWðV¦lµä³¾·uaÎHù¢–)ààÑK`pA£ê¯€?´¬Zò&â©–=@aa¹rfÏ9OÊ‰qÐ+|«8è@Týš*¦§¥Zê–ïg}
Oo ÃÇ"†V‚*ù?ã—ìµ&˜&×¼ ¦K%¤³gûÍo÷šXGSÌ‘òPºü‹á~
ñö³à«Ñ¨h×¤ ØÁWPs²To–Tãl2ó±‘²kí?mþ"DÖ7ë®±ÉIÛ*ÿ °ùSÄ‘fPC‚ÈÙ¿EQEQEQEQEâß´wÁñÝÕt…Z´Btó£o ¿ðÊ¤³[³|»‹FÅVBËâ²ßÄ¹ü3¯jrùz}ñ)²O”G?H˜8¥! ”`n“Ëó›íPi“D²©ÆUàðAú‚E~yÌ$øoã¦±ˆi—çþ­_ºœ»#ZHF2K§Bwsú¬ŠyVCÈý)ôQEÎ|BðE¯´kõ™#¸½QÔ‰"ÁØê¤©á—*x5òf§ûx²ß-m-ÈÜ@	#!Çf>l{GÊ†$€N2~€ø	ðP|5±•îÝfÕ/6ùÌ™(Š›ŠC`€,Ï#•Rîq´*­zµQEQEyíAã;}Â6.ÃíZ˜û<Kß<˜Ã|±Ä<|ìHb+à·mÌ[ÔÕÝýôëÈoc%^	PW¨(Ë +ž26äg¸¯Óû;•¹…'O»"«ú03ïƒSQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEyÇƒ‘üGÒ• a©i¹­œ•²ûyxÜ"—já—æŠEI `à«û½íí®Q ¹Êº·¬§æSŒÊÀr0~ë©S_b~Íß‡Š¢_ëòíh—÷7á|ÊO®¢,Ñþô.VL{ø9æŠ(¢Š(¢Š( ×‘|søùcðþÙìlJÜk’/ÉUˆ0ÈšäŽ€™!È’SŽ	qðÆ»®Þk·’ê:”­=Ôì^IòÇ¦N8 *"€‘ €(®§áÃK¿ˆä:T’ßýdóþ®!÷Ÿž7¹ÄPŒÈÛˆÚ_¡ðÝ‡,!Ò´¨–Ku
ˆ½‡rÄä³±Ë;±,ìK1$“ZtQEQEQEQEQEQEQEQEQEWŸü`ø?§|FÓ¼‹ŒC&Þã*O&9 Áxãzg*pèC€káøVðV Ún³	†eù‡!•Ó'l‘¸âHÎ:à2Ÿ–EG>§ð_öœÔü14:_ˆ$kÍ;Il´°ŽÏýécOâ…÷>ßõOýŸ¥jöš­´wÖ¤öÒ¨d’6¬BqõAà€jåW„üiý˜ì<[æêúÛMY·;§H§l¼:A+cýj®Ç3#gpøâöÃRðÅóA:KiynÜƒº9‡F!”ÿ uÐáù]”óõ/ìáûFO¬ÌžñTÁîXbÖéÈÏkiÏ¥#˜eÀ2à£æLú`ÑEQEQEQEQA¯k…rèº¿ü%61–°ÔyØ$øÃnîÊ¨u8ÿ Z®2Ò½»ökøÿ 	¯‡–ÞòMúžˆfÉq›{‚''ÈÄà™c“Ôë•ð¿í]a·Ž.ÚÓÃ±Éå™"Üç 8ì â¾ÂøgâøH¼7§j§ï\[FÍÓï N |êpAÅtÔQEQEQEQA®CâÅMÀV¿iÖg)Rb·L4Òc´qdgƒ#•‰Iœ
ø[ãÅK¯ˆºÃjS)ŠÝË‚Ù€ç“÷ZIç•Ô Ä*Œª)<køKLþÕÕm4þÚn!„n<ˆœŽãžGqšý;‰"ŒéÀÛŠuQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEPFkÆ¾>|·ñå»jšZ¬ZÜKÁè³ªŽ!”ôYHf?wý\™Œü¿KÞ‹xQ·Áuo)®’FØà©Ý±H½TåXpHëõŸÁ_Ú²ßUhÞ1u‚ïVó…È r3ˆe~O˜ @çþyý©"‡BXdrìAî)Ù¢Š(¢Š(¨®nc·¦™Õ#@K3 ©f8 äœWËßk=›ôŸ7ª½éPE¢0Á1pãâFáÇË7·ÓßJ×.ÒÊä³3±f$õff%™vbIéÐ 'Ñ4K½jî-?O‰§¹‚G–cÑGaÜ³•3±
¤×è'Á„ÖŸ´f˜’ú|=ÌØûÍ€iÔˆbû¨	$Ò™ÍzQEQEQEQEQEQEQEQEQEQ\Çþé:ÓÛKÖaÞ‡˜ä\	"nÒC&	FÇ(ãå‘YIñÆš·ÃË¦‘”Ï¥»~æé@ÚsÑ&ýDÃ¡ˆÜóÁð›ã^³ðâá¾Ê|ë)é­d8G8Æõl3C6 E0 JŒ eûoá¯Å=â‘¼Ò$>dx@üI# :Œ†Fçd¨Loƒµ²È|AøW¡xòÛìúÌ Ê ˆçL,±ç¯—.3ƒŽQ·FÝ
×Äÿ >
jÿ ï2ù¸Óß˜®‘HCÓ)/$A2¶0¥¶¿g*ž³ðöŽÎ$ð÷Œæaa »|£!DWMËl\—ƒåœà	ÕpOè²ÂÁãp
²œ‚ «‚äpiôQEQEQEQE“â¿Yx£MŸFÔÓÌµ¹BŒ;ŽêèßÂèØdnÌ¯ŠüGáï|ñ$wöRn·r|©°|¹ãÎ^	Ðpy±š3‰à8éôW„¿j?ëV‹5ýÏömÈ|3ƒÁ9Ë–5d•2Àcz)8¯–>?øîËÆþ(›RÒ·5®È¢ˆ ¸@s B(vsµOÌ@ÆàÕ¿²ÊÈ¾³)Qæ\'ø”Í#ìœCŒŽzÕQEQEQE¨®n¢¶§™Ö8Ðe™ˆ å˜à =I¯–þ,þ×“Au&™à±†?”ÞH»÷Œm¢;T"œ–]ÂNJÇ´+Ÿ™5­r÷Zº’ûP™î.%9y$bÌOûLyÀà*Œ"€ªŽ)ºn‰y©¹ŠÊ&‘FJÆŒä™e‰]”d– f«ÝÙËi#CpŒ’!!•Ô2°¤wqÈ¯Lýš´Ó}ã1åÈóÿ Ó8Ý¶vÏ¶3_ @bŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Šòÿ ‰Ÿ³×‡<rÒ^K³Ô¤äÜÁ€XôxŽc› ˆc£ŠøïâoÁ{áõÁŒ[í‘Ìy18ìbrSa‰ÈC"óNðÇ/x÷:eÉkaÖÞpd‹þ*ÑúâñU5ížý´Ì×pC­iñÇhÄ,²Ã#3/¬« ªyhÕËíÎÍÄ ßLhúå–³n·ºlÑÜÛ¸Ê¼LNyê¹çŽî*îih¢ŠkÊ¨1Â’O@:’IàßÓ­ywhÿ 
xK}¿ŸöëÔãÉ¶Ã`ä²LH†"3È._ á	À?(|Yý 5ÏˆYµœ‹]3!…¬D•$`ƒ<‡á•†å«°FH^^‘½Iÿ 9'ùšõ/…³Ïˆ<{¶î5zi<ÜÌ§ÿ ^ñ‚¯pÚ!æ1_\|,ø ü<ÍÍ˜kA—i¹›€î°¢€«ÐYÀÙ±^(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¨nì¡¼‰­îQeŠAµ‘Ô2°=U•V¸ Šù‹ã_ì¤®WðDx`KKeœc%­ˆÁ“níµƒ)óÇ„üY¬ü?ÕÓP°-oy(èê@#øà¸…¶1GÆZ6ÚÊÀH…\¯µ>~ÑŽcŽÒiËV`·‘°»ý–FÀ”gË8™z2qšõ`sEV¿ÓmõÒö4š	F×Ô2°=U•²úŠøïã§ìÏ} ÝI¬xRŸJa¼Å-$xÙÌ’[ŒnGBï%6…jå>|Õ>L-%ïHvíËr¹á¤µfÈG?ºâ)
|·ù«íÿ 
xÃKñ]Šjz,éslý×ªž¥$C†ŽEÏÌŽJÙ¢Š(¢Š(¢Š(¢Š(®7âÇÃ›hSèóIÏï-åaŸ.UûÜí`LrËFÌ+á][á‹4«æÓdÓ®üíÛG—º·%AIc©#åbË‘Ë¯xøCû$ùm«ã\aÖÉ9ëÅÜ‹Á L0¶	’G\©ú~ÒÖ+H’ÞÝ8£Q ª
ª£ (  ©h¢Š(¢Š(¢ŠF8¯“¾&~×Î™®]iþŽÐØÛÈbY$F‘¤+ò¼–HÐFÍ€)8\–çÆ¼ñ³Äž:mõ‹ÖÊr!DqäC2&LŒ3€dg …ÝóW%¥è—ºÅÊZXÃ$÷Ÿ•#RÎ~Š¹l´p£»
úCáwì{s;%÷Œdò"ëöX[2„	¦\¤#¨d‡{‘Çšµôÿ ‡|+¦xnÕl4{hímÓ¢Æ }K7Þv=Y˜–cÉ&¾Qý´´ûXu›˜‘Vy­˜ÈÃ«muXËã©UfUcÎÜŒ6co‡r,“øÂèVµ·}âJ›‰FF@M«
y>ojúªŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š*¶£¦[jVïg{Oo*•xäPÊÀðU•q_/|ký”6‡Ö<…†s%Žr@9%­ˆÈ^?Ñ˜ýÐ|§Î#?.Mi,.Ñ¸ÚèJ•<AÁR†ÁžÕoO×u%Ä–SKo 9¼mž„æ6C¸Žu#‚q]¯‡?hèE>Ï©Ï"!'däL§=CyÁ¤<ò1 Û—èÚWí§âƒû;9Éû¥|È±ê>ï®WéZ#öÛÔ?èoÿ ¤ÿ ãuÿ ¶Î¨Q„Zmª¹$ƒêFÅÏÓ#ë\íßí‰ã)ã)³GŽ$}<Ùz¡öÅyŸŠþ(ø‹Å,N¯}=Â…È¿HcÙûÄr¬ÛNÒÄ +–.Í×òÿ  8…jx{ÃˆnÓMÒà’âê_»±«s€ª:³¹T9n1_]ü"ý”tí &£â°—×ßy`Á$Î>Òã®]D*~ìd€çè%EPF àü€ì)h¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š1^_ñ‡à>“ñÝ§Ú¶Úº.#¹¯B#¸UÇ›Æ9’,“ üGã_ ë~½û³nöò”'”p¼†Uù$ ’¤H™•zoÃÚ«]ð¸ŽÇXÿ ‰žž¼0âdqÁ'Ì
2BNã
&P ?Xx#â¿‡|iÉ£ÞFò°¹	2žF×…ðùùN
îV*HæºüÑŽõó§ÇÙ‰|E$¾ ðª¤Zƒ‚óZð©3õ2Bç	ÃóæÄS6Œrvù‡Hñˆ~jŽÖ’Ïa{•y^Fp“Âß$ª2HY”ŽcnŒ>ÍøñòËâ¨³¿d·Öâ<YÂÊ:yÖá‰'·™KÆÝ7!V>¹š(¢Š(¢Š(¢Š(¢Š1F1EQEQEf¨k:ý†‰ºÔî"µFKÊá¿,F×‡xóö¿Ð´‚mü;jsÏBLp¡`f—ÂFÑóÁðþÑþ0ñdOg%À´µ“ƒ²ù{‡÷ZRZyk*²†þè©å´„^*ñìý6æ]ÁHcHoº|Ùü¨ö‘Ñ•ŠÏï?cVn¼]q´Ïµ±Éÿ ¶—,=Ö·˜FsôW„<¢xBÜZhV‘Ú§r£.Ý³$­™d<uv5¿À®Wâ'Ä+Àzsjz´˜íK2Vê%8ôË9Â"å˜€+åÁ>!ý µù¼G¨‘g¦#,{ñˆ§+im<Ù‘]ÞI÷k#’à’±¯ü7áÛ?iðil~U­²ã^§»1å™ŽYØòÌI=kJŠ(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( ŒÖV£áM'Së;yüÐUüÈ‘‹6Å”“‘Ç'¥y—Œ?eoëà½œ-¦NNK[!íƒo&ø€‚*`äç$šÂ¼ý<3—,OvoB±I‹)ù‡ uQ)ÆÒ AáÃa«ã+‹I"s)¼2‘ÊžŒ¬¿yJ° † äÉaË~?Ÿòê{WAeðçÄ7Ê’Zé·’Ç.62[ÊTƒÀ!öÛþÖí¾¦½Ã²ŸŒõ€^kt±Œfê@¤ôÎ"ˆLür~b€á¯IÓ¿b<Ç›í\,™9[åqÛ,›²y'# ®‹DýŒ|?hë&£{uuƒ’¨%#U^QÏ$¬‹ž3^Ïá/è¾·û&…i¤gïl3{É+fI]oQEQEQEQEQEQEQEQEQEQEQEQEâ¿i~+²}3[·K›Y:«u³Fë‡ÇgFV÷Å|‘ñ»ö^¸ð¼2k~gºÓ–6ù¦ˆg—ù	 A÷Ÿtkó8‘C2øWÛ:²’®„2pA2²0åN@!ŽÄ•ô/ÁÚ—SÓï¢Ó|_sö-_>DÝ,Gc´‘€ÒÅD›Ñ¤PÁÃ¬+ëí7S¶Ô­ã¼±•'·•C$‘°e`y¬¹j´Fk€ø¥ðWCø‰u0ßª…Žî Š,#|‚³C’s€ã,P£ÕñÄ/‡×ÃmTYê
Q³æ[Ï;$
AÁ Ã+Æq½2³BJ’J²»{OÀÚ~ño"Ð|a)šÞb±Ãvß~7'
·,1æBä…¾'ÇšYz}f®¥-QEQEQEQEQEQA8¬x¿IðìbmbîHÏC4Š¹íò†9nxàu¯*ñíoàý<§ý£P|û˜ö/BÙ2\†N9<Á¯<—öŽñ×Ž]ìü¦H3"™Ý:ct²yV±7Ã«0 ®j;/ÙgÅ¾-œj~1Ô–)ß®æ72¨9m å @Ù*vžÕèZ7ì…á1›Çº¼lƒóÈ`uR°,`«sœ’Ø8Ý^‘áŸ…¾ðÀØúu¼1ó„üFe“|„‚N	lŽ€àWPµ®x‡OÐmšûV¸ŠÖÙzÉ+…À#$ž€dŸJð~ØzMŽë[µü£¤Òæ8GQ¸)|€`JsÃðkÍ~ü3×~3kGÄ~+’ìÞ¯3eL˜ÉKkMÃjD’æÙªÆWÞ¿chº-ž‰g›¦Ä°ZÀ¡# ù’rYŽY˜–bI&®ÑEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEW7â†þñyš¾ms'?;Æ»¹äâ@ò@ÏÍÍE¦|,ð¶—2ÝXé6PÌŸuÒ;pÛsœwÎk©Å¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¦º‚0Fs_8|`ý“-µ_3UðvÛ{£–kFâ'9,ßg~~Îç<Fs8 EËWÉÚÖƒ{¢]ÉaÁuèà«)r=;‡RÈÃ•v×kð¯ã–»ðò_.ÉÄÖÛ¤µ—î7L´l>h%+‘æ&Pœ#|f¾ãøuñ#Jñîœº¦“' –&#Ì‰ûÇ*Íe$2+ªëX^2ðN“ã¦kvëq;—<26
‰"q†ŽE€ÊAÁ åIáŸŒ_õ_‡w!VŸJvýÍÐ)‘àqà@Ž_½É1®÷ÂOÚoYðZÇ¦j¯ô¤ùB1ýìkžD·Þ3¶	¸<"K WÙ^ñ¦“âë%Ô´K…¸ºã†SýÉcl<n0~WP{ŒŒÛÍQEQEQEQEQFjµö§k`žmäÑÃþ)(ç§.@ç·­yiO
xM¼„œê@àÅjU‚ö&I˜¬(x8]åÏeÁ¼‹\ý°u½eNá­0[ÝÌJÆåÄ‡=VÑÆ È0O&U­ÐóÚ_ìßãÏ]jëÍöf˜îio$-.xÇ¹ÔsÄ{á@¬6ÊW³ø?öLð®Žµa&©?s))ÿ vŠþnîzŒãì:>‰e£[-–›vÖÉ÷c‰B(ú*€2{ž¦®àQFEqþ8ø³áÏ.u«ÄŽR>XSç•¾Ç– ôÜÁTw WƒxÛöÌ³…¬„C´÷g'¯T·‚ƒ´dy“d‚œsæšg‚<}ñŽô_ÝùÓ¨ãí79Ž ˆWj¨åFRÚ"I3Í}ðÏö_ðÿ „ö^j jš‚óºUýÒä­ÎA*@Ä“Œ®Üà{4hB¨ € z  {S¨¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢ŠæücðëBñ”?g×m#¹À!\ŒH™ÿ žs&Ùž~VÁî|ñçön›Áu­žçI'çß‚ð’~Q!PÂx1 «|²ä0zò¿x÷WðMúêZ4ÍëÃ2®¹Ç,mÃÆØèpÊ~hÙšûáwíC x±×WeÒõ"ví‘¿rç8_&á‚¨-‘û©v8$ªù€n>Ð¬‘Ò«êu¾£Ú^F³A*•tpX¡•²5óÅŸÙy“SðSqË)ÛîÚLÞ¤|±Nq’BÊ£¼Ã^,ñÃmY¦±y-/ `“Dà€ÛzÃu	Æô## îÁÃ±¾þÒÄvW,,5fãÉü’&Úc…|çˆßdÀäl n>ºQEQEQEQMó  2z\§Æ»‰NÔØ‘ü‰®{Äÿ ü;áxÌºÍüØ\3ž °¦éX°hU%»f¼âWíp÷û;ÀÐ·™'Ê.¦Œ–Éá~ÍjA,NA(Ï¤-ƒ=°øñâ%ÊêzÂHžfŸ¨>Ò“°Ò€1Äk#•àX{†¿cÚ,rkw7“ w,dCO÷˜9Æfù¿ˆW¯xKáÇ‡ü"›4;mX€ÕxØÎ7ÌÙ•ºœeˆ  8®QEâ¼Óâ/íáŸ»ÙÜÊn¯ÐÛÛá™Oa4™@}D¼v_3ø³öƒñ¯Ä¿ìÝIi¼%­–ã#ûÉÂ‰ßœä ‚ Ï8jèüû!kz»‹Ï\‹d;Þ4"K†ÎKosºÜ’æk†9Î~Œð¯Á¯
x]Wû7N€J :EJsÃn–]Íów× Wd¨ 8§ø
uQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQES'·Žâ6†e‚¬¬2<e9Hà‚0GZùÛã'ì§a©ÛÉ©ø:%µ½@\Úˆ¥ï¶Çm´§h˜€Á>øù
úÂãMí®cheŒítu*Êzí‘nR1¬;dd`×´üý§/üi´m}¥¯Ü¿{þì-!Û$yBì»r|·>ÀðOŽôiãTÑ'A¸£dda÷£–6ÃFàpFJºFV=À|Uø1£|D¶)|‚åº»G˜¸è‘ûèNNcsÆw!FÃWÄ_¾k¾ º6ú¬€œG:dÃ ê6H@¸9ŠM²®:7}áíMªø[n™â/3PÓ‡‰ÌñHÝñç§OÝÌá”}ÉÂWÕ~ø§áß®t;ÄšP2Ð¶RUŒ´2>ðHÁÖdQEQEQFE5äT]Ì@QÜôüÏÂx·ã—„|.oµžeÏî`>l™vE»iÊw•
~ñšðßþÙ·RïƒÂÖKùmrw¶3÷„‘qÈó%nI£>¨øÏÄ~'Ô…ü÷W7ìNÒŽû‡ˆ£€-@_»*Œs“ÍwÞýš|cã	Eæ£Ø îy¯3æ •€–ÛÌ­#£cöö6ðÝ›$ºÕÕÛ©åT¬(ÃÚÂ%óqŸ›+*“€Ï©xGáG†|"Â]O†Â…óˆß!g÷Òn“æÀ-‚7NMuØ¢Š*«¸­bk‰Ýc‰YØ€ ¥™° É"¼WÅ¿µ¯…ôißLYµ9WÑ ±ÏÝšR»þ`cF©$^3â?ÚÇ?ôßÄöÑI…òìž\Ãs´ºdd’«Âä6
Ýø{û!êZ«CÆ3H˜î0FCÌÙå¼ÙNè¢-üDyÒžî'é|?Ñ<Ùt;Hí”€”eßå•³$‡Ý˜û
è±Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š( Œ×ñ'à§‡¾ &ýRè]©uP*¬H+*xIU€çnÓÍ|•ñoömÖ|	êq:ÞéjÀdÏ ÜBs±IÀóQÌ{ˆ#1çþñî³àÛ£y¢\Ék1Àm½‹,Nr“€ë¹z+-}ðKö‡Ó¼ol¶Z´‘ZkKÁŒ©0>e¾ó÷°™æt °Ü˜5ìJáÆG ô?áëP_é¶Ú„kyMƒ’(e#Ñ•ñá¾;ý‘<=­»\èr¾™1ÿ –`yuÉ"&*ñçž#•TvQÍx–½û6øëÂ-î›ºòNRk	u<`¬gË,Gî÷ç#o^‡Iý¢þ"xn¯gö¥ˆáÞîÚHÝ@'pybXã'n÷^0	,rOwáOÛ3I¼•`×l¤´ÜHó q:Žà²øë¸¤oŽ0I»kñ{Â70‹˜õ{/-ºftSéÊ9Wú¨«¶ßü7râ85K'vèâ2OÐÍnAyÆ|—WÇ]¬ç‚qR–Ç5‰«xëBÑÿ ä#¨ZÛ’¥€’dR@êB–ÉØâµÚ_À¶.ûDLHÎ`ŠI í‚È„+qÐãŽkž“öÂðr’;ÖÇLB9ún}À÷¬«ïÛG@öÙØ]J r]£ŒçÓk;Ÿ©ý+Í¼Sû`ø›RÊi1[iÑ•#+ûé#K²1Ž«ˆN3¸W56‰ñ;â)Ý<zäRnÁ—1Ãü;€Y¼ d.WË J©ç=ÿ „ÿ c-FáDž!¿ŠÙIÉŠÝ|ÆïÒ>ÈƒgÄoÇF+Ø<9û1ø'FQ¾ÌÞÈ?ŽéÌ÷«a ùcQ†ÎN}IðÖ™£®Ý6ÖU'$C§'‚~@9#ƒíZ@bŠ(¤'Îø£â7‡ü-“Z¾‚Ø€NÆp\ãƒ²%ÌŽAàíSƒ×óÿ ¿lF.m<kœ¢âèžÙ†ÕH$ÿ wÍ`Ä<®xã“Á¾.ú£L–,rÙò 0!’Õ<˜É(Í«0+Õ|ûèZY[ŸÏ&¥8ëæ(sœò™¥ ò„aœ¦Ü4mÇD·[=.í­Ð`$HGà dòI'$’I9&¯Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¨®­£¹ ™D‘¸*ÊÀÀðÊÊrH8 ðE|åñ#ö<±¿yá)¾Ë7_³LKDÙŠ^e‡¶y±Ž€(éòïŠü«øJñ´ýbÙíçR~W^ã¹I“ïÆX÷¶ž+gÀŸ<Gà»•¸ÓnœÆ0	Yž&€¯1Æ¢hÝGÝ8OÚ_¾8i_íÊB>Í©D ËlÄ:`n<ØweIÀt8"åKzFE.)ÁV¨<þ`ñX÷€4|mÕtûkœ€2ñ)lTÀp'€Øæ¸_öSð& Y’ÎKgvÝºœcÕU$2Dª}qØŠågý‹4äÁ¨]$dœ)H˜Ø(cÔóŠÈ¶ýïìšÇ^òCrÝÐ3·yŠæ0Äg® É88ª×ß²·ŒžFë©4}¤’áXö<}0†;Ñ¦~Äò–µV0¿Æ°ÛóôI$“o^íNÙäwÚOì‘àë@çÚ¯n™9Ažî(©=—qP;w­H¿eïÆë °vÚAÃ\LAÇ8ei
²ž…H Œ‚+Ð4_i$"ÛM³‚Ú!ˆãUÎ8ˆbbO½_þÏ·ÿ žIÿ |ð«¢Š(Í®Ä¿4ý·ohÄI sŒglY267.v©À ô¯ñÏí‰£i…­ü9n÷òþ¶LÅyh Í/Lä"¡aðI_Ö>9øÿ Çò"Òiç8ò,ÆNH;w){œ³J‹´°‘Ššï<ûj[ÿ ]}”¹ÜÐC‡˜ç–ón[thä–°LyÏ›œçß<ðgÂþ+&•c¸_ùo/ï%ÏLù’n+ŸHö’ Åvø¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š+Å~Ò¼YfÚv·n—06pr§ûñ8ÃÄã³#+äïŠ¿²V©¢53jC-äãý! 0— s–@’àŒ£Ið};Q¼ÐîÒîÑÞ˜r:’¬¬;©ê¬:2‘Óåu ‘_V|*ý¯-nÑ,|f<‰‡î5ùœ~þÜÐœc/xÞaÝ¯£4½bÓV·KÝ>hî-äY"`ÊG^r;úÕÊ(¢Š(¢Š(¢ŠŽ{„’°D^¬Ç våŽ üMp"øÿ àÍ²\jQM*œíó3d¤`¥H;ƒ0 ãã¾+ýµT©ÃzqG]°àñÿ .ð'¿2dcx¯*Ö~;x÷ÆýŠÉÕ¤Cbž[pKü¢ ÷<p	2 ²7«áßÙƒÆÞ#“íz„kbó%ÜŸ¼<¸Ç›1ÆâGFkÖ|ûi,%ñä—Íœùp%;|¬ážwÁóp íR2}ËÃ^Ñü1Ù´[Hm#î#@	÷vûÎ}ÙmQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEW–üRýžôo»eû¦ßòó
˜à*ý¦#…œ( JÈ ¯™ügû+x»ÃÛ§³‰uu'æµl¸Îão&Ù9åéœŠóÏøÃ_ðeÛK¦\Og<lCª’£pÊ•žùðAYcÝ‘ØŒ¢>~ØbF[/F è.àSÇ©žÜpq÷àÝŽñ(ä}áÿ i!ˆO¤^AwÌR+{€w¯š3FhÍ……!`9<Uñš„†º€×2¯ë–®{Ä|'áÜKS¶Àb¸wç8"8·¾8Ú;‘šòÝ{öËðí›4zmÕÙÃ6ØTç“þ°´ ¯NbÁ=ÀøöÑÖn•£Ñl ´$¯!iœ>QåE¿q	Þ¼m(rqã(ñïˆ¼c8þ×»žé†ØÙŽÜ“…Û&#å° XØ“€K+¬ðìÝã/2Ÿ²5« L·GÊ^£¤?4ìq’”6³!Å{ß‚ÿ cÍLQ/ˆf“R›©EÌ1zµÌáxûòàã;@%kÛ4
i^‹ìúE¤6‘zBŠ¹êy*<±êOSZ¸¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(¢Š(#5Æøçá†¼l3­Y«Î>ìéòJ=1,xfû¯¹}«À¼]ûMeðÖ ²cŽìmnÙ?hJ“Çæ€t9%«Éµ¿‚>8ðÌ†Itûƒ´€$·h9äö¤Ëü=
¤Ø8§é<{áV(·÷qˆØ†KÒ HÚCµfR8 OAÍt·ßµÇ§‹Ë‰ía~>x ¸ëòÌ€1ëû±ÏB:Q¤þÖ>9‡1Èö÷,Çåó-ù¡„·©ùXŽ¹¦Õ¿ißˆ”g·ÙjÍ‘ºVr0 2™ðA9Rª69#Š¢ž:ø¶FUõrý;¹üÙ©[ÇVÕÿ ðÇò¶®OSÑ<{«¸{ëmZåùÁ’;–Æy oTÉjûWtÿ ÙëÇŽ±Ç¥L›‡Q(ïó<Žqô#$×cáÿ ÙÅ·Ä6¥%µ„g9üÆ‡Ë€;»;<a—ÓÒ4ÿ Ø«CH‚ÞjWRK“–"EÇl+¤ÌO˜ry t­ÝöAð}7Mwwó‰%
þáX T÷è}ëÓ</ðãÃÞPº%„Ä 7ªçÒ¶éXàœ–rNy&º01KEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQF*9íb¸SÈ®‡¨`?PA¹í{á¯‡5è~Ï©i¶Ó'8ÌJÏ£ WFÇñ)ÐÒx[á¯‡|)ÿ  M>fîê™s×•÷Hq¹€ËpWK´zRâŒQŠ1EQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEÿÙ                                                                                                                                                                                                                                                                                                                                                                    usr/local/go/doc/gopher/bumper.png                                                                  0100644 0000000 0000000 00001033367 13020111411 015603  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ‰PNG

   IHDR  €  8   g±V   gAMA  ±Ž|ûQ“  
9iCCPPhotoshop ICC profile  HÇ–wTT×‡Ï½wz¡Í0R†Þ»À Ò{“^Ea˜`(34±!¢EDš"HPÄ€ÑP$VD±T°$(1ET,oFÖ‹®¬¼÷òòûã¬oí³÷¹ûì½ÏZ ’§/——KÊðƒ<œé‘Qtì €`€) LVFº_°{ÉËÍ…ž!r_ðzX¼pÓÐ3€NÿŸ¤Yé|è˜ ›³9,ˆ8%K.¶ÏŠ˜—,f%f¾(AË‰9a‘>û,²£˜Ù©<¶ˆÅ9§³SÙbîñ¶L!GÄˆ¯ˆ3¹œ,ß±FŠ0•+â7âØT3 IlpX‰"61‰ä"âå àH	_qÜW,àdÄ—rIKÏást–.ÝÔÚšA÷äd¥pÃ &+™ÉgÓ]ÒRÓ™¼ ïüY2âÚÒEE¶4µ¶´4432ýªPÿuóoJÜÛEzø¹g­ÿ‹í¯üÒ `Ì‰j³ó‹-®
€Î- ÈÝûbÓ8 €¤¨o×¿ºM</‰Aº±qVV–—Ã2ôýO‡¿¡¯¾g$>îòÐ]9ñLaŠ€.®+-%MÈ§g¤3YºáŸ‡øþuAœxŸÃE„‰¦ŒËKµ›Çæ
¸i<:—÷ŸšøÃþ¤Å¹‰ÒøPcŒ€Ôu*@~í(
 ÑûÅ]ÿ£o¾ø0 ~yá*“‹sÿï7ýgÁ¥â%ƒ›ð9Î%(„Îò3÷ÄÏ H*Ê@è C`¬€-pnÀøƒ	VH©€²@Ø
A1Ø	ö€jPA3hÇA'8ÎƒKà¸nƒû`L€g`¼a!2Dä!HÒ‡Ì d¹A¾P	ÅB	ByÐf¨*ƒª¡z¨ú:	‡®@ƒÐ]hš†~‡ÞÁL‚©°¬ÃØ	öCàUp¼Î…àp%Ü …;àóð5ø6<
?ƒç€¢Š"ÄñG¢x„¬GŠ
¤iEº‘>ä&2ŠÌ oQEG¢lQž¨PµµU‚ªFFu zQ7Qc¨YÔG4­ˆÖGÛ ½Ðètº]nB·£/¢o£'Ð¯1£±Âxb"1I˜µ˜Ì>Læf3Ž™Ãb±òX}¬ÖËÄ
°…Ø*ìQìYìvûGÄ©àÌpî¸(—«ÀÁÁá&qx)¼&Þïgãsð¥øF|7þ:~¿@&hì!„$Â&B%¡•p‘ð€ð’H$ª­‰D.q#±’xŒx™8F|K’!é‘\HÑ$!iééé.é%™LÖ";’£Èòr3ùùùEÂHÂK‚-±A¢F¢CbHâ¹$^RSÒIrµd®d…ä	Éë’3Rx)-))¦Ôz©©“R#RsÒiSiéTéé#ÒW¤§d°2Z2n2l™™ƒ2dÆ)EâBaQ6S))TU›êEM¢S¿£Pgeed—É†ÉfËÖÈž–¥!4-š-…VJ;N¦½[¢´Äi	gÉö%­K†–ÌË-•s”ãÈÉµÉÝ–{'O—w“O–ß%ß)ÿP¥ §¨¥°_á¢ÂÌRêRÛ¥¬¥EK/½§+ê))®U<¨Ø¯8§¤¬ä¡”®T¥tAiF™¦ì¨œ¤\®|FyZ…¢b¯ÂU)W9«ò”.Kw¢§Ð+é½ôYUEUOU¡j½ê€ê‚š¶Z¨Z¾Z›ÚCu‚:C=^½\½G}VCEÃO#O£Eãž&^“¡™¨¹W³Os^K[+\k«V§Ö”¶œ¶—v®v‹ö²ŽƒÎ[º]†n²î>Ýz°ž…^¢^Þu}XßRŸ«¿OÐ m`mÀ3h01$:f¶ŽÑŒ|ò:žkGï2î3þhba’bÒhrßTÆÔÛ4ß´Ûôw3=3–YÙ-s²¹»ùó.óËô—q–í_vÇ‚bág±Õ¢Çâƒ¥•%ß²ÕrÚJÃ*ÖªÖj„Ae0J—­ÑÖÎÖ¬OY¿µ±´Ø·ùÍÖÐ6ÙöˆíÔríåœåËÇíÔì˜võv£ötûXûö£ªL‡‡ÇŽêŽlÇ&ÇI']§$§£NÏMœùÎíÎó.6.ë\Î¹"®®E®n2n¡nÕnÜÕÜÜ[Üg=,<ÖzœóD{úxîòñRòby5{Íz[y¯óîõ!ùûTû<öÕóåûvûÁ~Þ~»ý¬Ð\Á[Ñéü½üwû?ÐXðc &0 °&ðIiP^P_0%8&øHðëçÒû¡:¡ÂÐž0É°è°æ°ùp×ð²ðÑãˆu×""¹‘]QØ¨°¨¦¨¹•n+÷¬œˆ¶ˆ.Œ^¥½*{Õ•Õ
«SVŸŽ‘ŒaÆœˆEÇ†Ç‰}Ïôg60çâ¼âjãfY.¬½¬glGv9{šcÇ)ãLÆÛÅ—ÅO%Ø%ìN˜NtH¬Hœáºp«¹/’<“ê’æ“ý“%J	OiKÅ¥Æ¦žäÉð’y½iÊiÙiƒéúé…é£klÖìY3Ë÷á7e@«2ºTÑÏT¿PG¸E8–iŸY“ù&+,ëD¶t6/»?G/g{Îd®{î·kQkYk{òTó6å­sZW¿Z·¾gƒú†‚=6ÞDØ”¼é§|“ü²üW›Ã7w(l,ßâ±¥¥P¢_8²ÕvkÝ6Ô6î¶íæÛ«¶,b]-6)®(~_Â*¹úé7•ß|Ú¿c Ô²tÿNÌNÞÎá]»—I—å–ïöÛÝQN//*µ'fÏ•Šeu{	{…{G+}+»ª4ªvV½¯N¬¾]ã\ÓV«X»½v~{ßÐ~Çý­uJuÅuïpÜ©÷¨ïhÐj¨8ˆ9˜yðIcXcß·Œo››šŠ›>â=t¸·Ùª¹ùˆâ‘Ò¸EØ2}4úèï\¿ëj5l­o£µÇ„Çž~ûýðqŸã=''ZÐü¡¶Ò^ÔuätÌv&vŽvEvžô>ÙÓmÛÝþ£Ñ‡N©žª9-{ºôáLÁ™OgsÏÎK?7s>áüxOLÏýnõö\ô¹xù’û¥}N}g/Û]>uÅæÊÉ«Œ«×,¯uô[ô·ÿdñSû€å@Çu«ë]7¬ot.<3ä0tþ¦ëÍK·¼n]»½âöàpèð‘è‘Ñ;ì;SwSî¾¸—yoáþÆèE¥V<R|Ôð³îÏm£–£§Ç\Çú?¾?ÎöKÆ/ï'
žŸTLªL6O™MšvŸ¾ñtåÓ‰géÏf
•þµö¹Îó~sü­6bvâÿÅ§ßK^Ê¿<ôjÙ«ž¹€¹G¯S_/Ì½‘sø-ãmß»ðw“Yï±ï+?è~èþèóñÁ§ÔOŸþ˜óüºÄèÓ    cHRM  z%  €ƒ  ùÿ  €é  u0  ê`  :˜  o’_ÅF   	pHYs  .#  .#x¥?v ,(IDATxÚìÝw¼-Uæÿ£-9GADrÎ9IŽJÉI2HÉ9'ÉIr‘Œ
¨ˆ¨(`hC«mwk÷8=3Ý=Ý¿÷œï°¦ÜûÜs7ž{ïóùc¿êì]»víZ«jŸzÖ³žïÀ@!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„IÎûÉq!„B!„B!„0¾”Üìñýï[ŽB!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„B!„i÷ý)ÝgrpB!„B!„B!Œ;Mh¶ðþ÷¿?ºs!„B!„B!„	I©Ïög:„B!„B!„Â„á#ùÈ2Ë,3Ûl³M?ýô3Î8ãtÓMçÉÅ_Ü3-‘#G)„B!„B!„IG$¹0utc–çX`×]wÝpÃ©Ï¼ÏsÍ5—ççž{îvÚ‰=Çsl¿ýöDêw³¡­“CB!„B!„Â„'ºs˜ÊøÀ>0Ï<óX8à€N>ùä¥—^z•UVñç¬³Îzê©§Î7ß|è%—\ræ™gžþùZh¡±B!„B!„&ï{—Š0µÂMY^n¹å<ðÀwÜqöÙg×á÷ÙgŸÃ?|¥•Vj«1Jo±Å3Ì0CÐ!„B!„B!LH(n¥»æäärŒFƒSŒÏ«®ºª…O|âµ°Ã;P¥7Ûl3¾Öa…>ñÄçœsN¦é±B!„B!„0íÒ5,¿¯ÕX]µŠ¸åú,AÙ:ë­·ÞŠ+®Ø}£ÀºÛû!·-µÔRÄ¸5ÖXC$niÐµš—j³¶Öý¸žÏ­gÚÇ…0Éèéu=}Ò°Š|ç~ô£MSÞk¯½=ôPZ³h¯î¿ÿþêÖK«¯¾úÇ>ö1'‚þo…ÚxÄôl6„B!„B!„iê˜ºj]]lÁ\tÑEþT¤¦Jxáüà‰qÒÈÍde¹¸ýöÛÏ3óÎ;¯—è×´¹=öØCHî.»ì"µ`«­¶’«JU®j¸Ñ©»ûP"uSëB˜dèÃºŸ~«ç×xI÷U‚ò—¾ô¥7ÞØòK,¡ë—­vÙ žÙsÏ=maÍ5×\yå•8âˆ+®¸Â:›nºé!‡Rw~ÕèK·>a	!„B!„Baj¦œÎ´³2l’ž—_~yOÎ4ÓLµ5mƒ6 ¨yÞ“+¬°­yíµ×ö<z±Å;á„hp§všjlÖ¼ôÒKwß}÷6Úè ƒ²pÁÐ ¯¼òÊ‹.ºHdÌ\Â©íl¹å–/¼0-6=ðnˆGZ$Lâþ_Š0õYo$/¾øâZ8úYdi:êwÜqË-·XGGUf°Þx÷Ýw¿ñÆª>òÈ#çwÞ7¾ñÿ¾ûîûìg?ë-×^{íI'äÌ2ãyçË,³ÌRo4ôâÉø C!„B!„ÂÔIS¾Zêá˜ôFP²ñè£’ÛÈÍŸúÔ§vÚi'Ú1qíŒ3ÎØf›m¨Æ§Ÿ~:§§D‚2§ç¹çžËòyÿý÷?øàƒÖ$·ÉÃýö·¿}ÓM7½úê«_|ñ%—\ò­o}ëüóÏÿâ¿øÐC	.°qÏéÄ\uÕU>’7©Ú'~à]ÒFabtûÍ·û§q”Šáh¾á†n¿ýö£>z­µÖòxðÁÿíßþí¾ð…¶²~.‘ƒÇçw>ì°Ã~ùË_êÛ—_~ùð_ÿõ_„éÝvÛcÚ8SF‰Bã4Nª´÷ÊF§Dû”´H!„B!„B˜Ri	ËÚmQïzŸEjÞ¸>7ß|s:#çsÏ=÷òË/¿öÚk_þò—?_zé%š}íÆo|á…,œyæ™o½õÖï~÷;væ‡~˜¦|Ï=÷Üzë­ìŸŒŸ6rì±Çz×›o¾I†þÿãØÔÓO?ýŸÿùŸ_ûÚ×®¹æ§h¯»îºgŸ}¶5©Ï:yë¯¿þŒƒ´¼‚4ex×¤ÜBZú£Ã«W·Õ:±Î­ÿ38WÔÌÀ`A½]ˆù[láOÒ0{¾Ë[o½5/ÿ< UfuÖa^¦#ó2“¡½W]vÙe™pý¯¶ÚjÎŽ¿þë¿ÖŸ;î¸#1ú×¿þµ•uf½Ú®¾új¹4,ÏŸùÌgDyØ®ŸÚgõ!|wÏÙB!„B!„¦š]·:Ì=ëÐ×ø=©cûî»ïYgõýïÿ…Aîºë.RÚÏþs†h~ï{ß£S“éÈ_ÿú×éÑ,Ï¿ÿýïŸxâ‰Ÿþô§Vû»¿û;ï%Xÿð‡?ôŒÕ(Ôÿß žùÉO~ò÷ÿ÷hÛä§.i[(Šm\Ò4kþP;C›Ûd“M3
È…µÛiÇÐÔä¦8Añ$ÉX'™sÎ9õú–qá¥V³u!+s4“ƒÙü<òH¡1VC•Öÿö³ŸUßûÐ‡>$ã¸ãŽ£#Yán~å•WøýW]uU¯2Ds=+Èyï½÷êÌüÎÿñÿaŽi§Ã¯~õ+ƒ7†gHÏ=ö˜·žñ)>ÑPÍÒK/Mò–‡ÎL}ýõ×ïºë®roÌVãIç¦W}…ôùB!„B!„0Ú)Ë'‘Nn}­ž$Õ™øO€³ÀÚI€cÉ…Aü*è“O>Y²²ÀŠ³xÿý¿ÿ÷ÿüŸÿ“Óù›ßü&eí¥?þñþçNk£¾‘•ýù‡?üáí·ß&L—”¾LÄñâ‹/¾óÎ;ÿöoÿæÞþøãSëH{ôîÏ}îsä?ÆRº>Ž>(`WH4ŽÇš*„·Œ¢!4ÿ~-è!ôbdÂœsÎ9áÒÖo%þ,P~u'ÖûO~ò“žŽ!£6¢[²B‹Îàe&:ë<ËDa';ÿ_ýÕ_éü:ùoû[ga¤Ä™bk1È?þã?š1 “ÿøÇ?þ—ù'Âë¯¿Nzfÿ7„sòÉ'×èC4s4'µ5Ìó«Aì†öÑ²nó¸MDhÓ!„B!„B!ŒjÊGIÕ¢¦™éO¤@b#½ñcžrÊ)d_Ò˜4?&±ŒdÌ¹LDþ¯AèÑ5¿øÅ/¾óïÚ¨lÿú¯ÿêÂœÒ‚^%OKØø‡ønPó7óÏÿüÏ¶ðßþÛó6ÑÍ‚—x¥ù ðƒð>ÛIú«_ýê©§žzÛm·ñJ?ÿüó>¡ä9†ÐA«©ˆNÒ4å´Öiþ4¯™‚¬Kp4ëÌ¥>«–9Ûl³	;®?³$éK_âJö’’€gbMjòÇ?þqº³ÎFðÕ{õdgø+_ùÊ¶Ûnk}r7³<Û8Ñ™jl(…%_GÕ- kñ<û?ÙtÏ8!+ÿÓ?ýÅÙ‰à¬1ôB¤vjü÷ÿþßå›S“Ã”âl$Æ‰æƒìÒ>ûì³ÿþû[Ó[ž}öY¢Ò/»ì2ÞgÃ0ÑË-·œ˜ÇC!„B!„B˜l´<ÜöLO<®…?ÄKª¥1;Ó×ÈÁÒ™•G#õ™šék”5é„c
$NO™ÈpÒ3þcú²çÉm–ÿ}/QâJöFbœx¯þ¯ÿõ¿˜¦Il^¢MûJ\y¥A•¶)
õo~óÆRVhBï*…š2NOTÕ9š)Ûnï¤T
GB	¦2Z›vÃ=ûÕie°Ì0Ã[mµÕñÇOŸ/ÎL2¶,mC·1 "¼…ŒKÀ¥ðZö^]Ö¬§aü—tÁ¶Ob–¹,æ¹AôU+pÜ[³…sßS~ÿò/ÿÒhŠÑñ3Ï<Ãí”ÑWÉß¬Ö{ï½·xhñ2Ë7ß|s»8/ÃØ”ÁÛü QTi¯~þóŸ¿ðÂ}–•M8°‡‚kœÎ»aè…Ú«–åø¾
{ZØ­òg;ÇÓóC!„B!„Â¤¦©u­ºÚ@GÑ“_áQrÅ!‡B¼ãk¦¬™ì/ôö¨£Ž"ŸQâ<o:L>£¯Y&½y$‡Ñ‘	jßýîwy–EgÐ”…ž‰Îde›*sÃÊdhzžè\ïõŒuþë]<ó_øCIÛ>JšxMƒ£Üù“Ó™BÇ­:±\ÎÊJòë†ÿv÷0uôaróûßEÌ™fš©ÂÊIÉ4YCú‰þÀ¤Ì/(ÆúlÂedè¬cY~ã7Êþ4b!@†ÙŸ»ï¾»q:¯mÊgR¶
¯¡‘ê„:?Y?÷ŒÉºßoaá7j¢® Ä˜
“‘]ÃLm~ «µQ[sjüí ¶£KðpøÓX‰ÙHŒŽÍCíjƒ:FzÎ?ÿ|b´Ýó¡UçÓGÛUow((æœÝ$u9!tvgkëü!„B!„B!L:J“êª±ü›’id¢i™9(¹AÅ+Ÿxâ‰ô8FcjM.-)™LFk¦ ±?“É*Ç™mÓ2ù˜è\b±5K_öH}&·5M¹lÑÿÙ¡Š–ÜÜ=ÓêUZ¶²3,¢öAqBâ/¶]9	öSÑ6ºW]uUÉ…ü§êË-²È"Ë.»l”¸©¯·"“•ÝÌhüÁ~ÐÂ¼óÎË¯éÙ“%WP/¹äº­^qì±ÇJÀ`y¾îºëxà:µh½ˆæK>í´Ó¥ðGS{]¼E´…ðqÎŒö\Æbæ}Ê²žF öFC&iî¼óNFæ{î¹ÇŸ\Òåô§[G×e¾æ‰vŽÔ©ÄaM§¶A*3Ï²¶ÿ}g“G]ýŸ±¦G'ÕÛ¾Ñ©};oÇPõ\Ÿw:}!¯Kµ&¦óYów3P§“„B!„B!„É@“by„éVü¡t:³,Ÿ¤7º“¦Wù7¥XX¦¿*%ƒLq£ ñre’›	aœÈ•­Q2q­F¹®¸ç®¹+1wWn¯Ör=–HÝTl”“šÇyêOöOR O¨¸û/‹ãÞ{ï¥èY É	@ËÁ-áWÙ7Õ—_~ù´þTCÙ{ÈnžkÖ½]tQfáÁ€fÃ$ž¡8‚ùåuÝ§žzŠYX3s±Œ1ÊzšñÂîyçW!Îºû¼‚•€!Lœ¨M2¶Y
²~H/ÖÃ=VòŒ¸so¡ASºÅè~edæôç•fa¶eGAö¼]2{@¶?>‹lM§öªgtïšU`Ù–bF\l°\>ÅIg†~nû:<ÉÛmJ6:µÚ“+¯¼21Ú':w	!„B!„B“‚ñly©¥–b”ËÚItã	•³aF¿‚lŒŸü˜5Ë´-:šÉvD:ÖNÔ7"aŽôL5kÒX	Ç¥„¦Gpåþå–1Í
M³#ä‘çhst@ë°¬Êå ;^9ˆ<_%[l1Fo)ÀM¯è(òatvÝ¶P®ç¢þœo¾ùŸ÷Ýw_Ff•0Ù–­)€B‘@=œg_7æë—’¬cž9ˆÈåÐ{u!ê0-¸ú¶"'šfý£ýˆ
üê«¯Ruv0#{‹?½¥‘”Ç_ç·NiÍTfâ5S3-Û“äiO¶±eR¢½‘ Í°OtvâøÓ#¿³mZÍ§X°A› íÄ´&kÛ©SŒîlDÇ:½ë¡\;[móòË/¯Q‰²GˆòN#1²t†šôB!„B!„Â„¤«±J$ØtÓM%Æî³Ï>æþK®xôÑG)t¬”d5qD7
‹%I«¤®’˜I`Âm	dž´f%”÷¹ÜÊÿ5Éiá%¶¸UNŠˆx\ù¼ÇsŒX¥\²;	~–YfI¯˜RúmK|®?©ÏÄåZð8Ûl³± Ë£Ð‡¥l·Ývüºÿþû33õS!ÅrK«°`”…SX¬!£¢Éõj‚¯gC6E2&Wì¸dŠ ÝÔçêiøóAj\¤¢<¼¥Î—Zh¡4õ$qÙ»JÈöRwN@¹þ=i*`Ú††qêUúý4ôbÇ(éå‰¦€³{â••jÝ`úR!„B!„B˜ˆ”„§üš´\â”òedYe«ü}“WÉ³-¯™HGqn™%øVÀ§s3AO|zæÚ²¯SAgžy¦ ¹½ŸúÔ§$ÿ’é’rE6Ø`âûÁÌñš¾1Êé–ÊÔ{…•¼+=ãè£Vúß™Ó™ÃÝ C…ÆÐd™½T-†Xä&k}ý\Ÿ÷*÷þûï¯b˜z>[±“‚ž+ôÙ²wQŠiÁ^¢/s.7×¿ïUÎhiv~+Ø²÷ú“4\ƒ"mr@­æô©ª›Ý¬óž?-P“ÿóOiŸk[4MÝøDFì¶)ßeÃ7TŒ±{H_
!„B!„B	Èò4"³<“À¸AÕè†Ë*Â¢Ü—4ÜÊµh:5­«|uã/º'—ôÜöŠ2nWËþl·Ù]å>“ÅqÜzë­´¹Ê‰&DÚsÁGq„\ŽC=TNnúÆhFdŠünÒ6ä•SO=õTzR\“;õù±ÇÛa‡<iŒAléYÇ¦>Ëw&ãê:¼.¡ox•Ç¿g6ùú£4‰™ÜÌì\bn…Ì4‡r;)º½½:ž>fãÝSàß©b›>‚—¹'sÆY&Ê¦»)' 4óîFôäÚ‡îÇuEêÚ~¹°›º]Þjë|ûÛß€NLwÄšXB!„B!„ÂøR^ÑæíºGO:é$ò+©Ž¾&v€§Þàã?N,óLIl¥µ•Á¹ÜÄ=âÚ$Ðš›¦Ü­RØ-T8ÂhéªùFdˆfS•·àûJW G?ðÀUqNj°ÃÂ½ùæ›Ï4ÓLé?“‹nFùÀ»qÏØi§Ä‘‹Lñ¤Ôfv9Ÿüä'ÅkÐ‘é¶ªÿYÖÊDd+ÂšËÚÏ•üðÃ«àgG–…l
r³¡Ï^%ïêðÊÄhý¼,ÉÎç‚VèÒv»=°†dJ®é½Í‰LS®­Õ(H­@V¦WÞt+­i8Ä™Xsê¤“O-¨º7¼ýï±µZÁž×ªgW‰.+t}‘îùRo+“¿O;í´AÏx2 C!„B!„ÂøÒ&ÚSëV[mµö¼ìbÜƒP¾*Á–„§ÄÙ«)Î¥j5t½4‰ÍÝ=išÚÈåïZŸîvÉ%—ðÀRŸN	”eŒ%S^uÕUsÌ1÷7‹ôá‡.´0½øâ‹Ë+ Ð%©`²Ð"ž5„zõ¤pgÃ¢™×XcÎýe—]öÚk¯}öÙg<ð@ã(ŸýìgçœsÎk®¹†>«'Ë}–»rÆghVš¯>@Õ½5:¹™ «(¥0hËÂ:“«“}Q¸²¢ÌKeÖ[¨Ï¾ÑiÆäJz©•m¿Jq²N›.ÃµMIOÏÓ²õ7¹ÒºœñbqåÃ|ñ‹_äÁ·'ìùê"Ú,7£·Ñ •üM:wê=óÌ3ž·­¶ÚŠ_B¹mötøÚÕž‘ßÈ‹õ	^‘Æ!!„B!„BÝwßÜ¶Â
+ð?*ËF³#ºÑÅÈ²D±*€Æ
Jáj‚Ú"oOÖó$ Ûí¬dÁ–I=òø²\ÏL©Þ^%=Iì#>ÊpÝ@+td(›‚8n¾ùf¥çfuV2}DºÉ‹DnôW\Q©Ìu×]Wr·:™«¬²
Ó:_3±˜üÖ[oé·3Ï<³uTÎÔÖúðAä™~ô£¼ÀÚúƒ°ÀW-ÍR~­¦3/‰¹,ÆÆ*„Ò”ßÙpK«ØcÃ÷vï­Ìåz¦¤jò®½÷LP?Ý>”RlkÖ¹›=I§€3à“Å-À¡/"ò<yÚ7þá[{ì±†CtKçé‰'ž808qa£6Ò-«ÔáçKOHNýé‹üjßÒ=èB!„B!„0þÐªŽ<òÈÁ„\2–?ÉOd/ª“&ß%Á‹¹²²žIZâtK†ëÚ<û­Ç“2_åö’ü9I{ÍõYªôÈ÷ªÕ|£Q2ÉRŸÙc_™tH%¤c*IGª»ë®»Ž9ætºÐd¡åo¬¼òÊë­·žQÊ2)ö_ø‚…¥—^Z^ÊÖ[oÍïÌL‰&Ë’q…oha=¦óÒ‘½QB:ri¯Õ‹*ƒ\©Ê:¹¹’Í«/9/~ýë_÷Tùëöÿƒ±R²¶xËúƒ¶-—¹\Ïõ[Oêf:³Ü=ÐçÊe®øiS|A½ÑWóÎQàþvdq ñÌ¦›nªx¦äëzUEMÞjgî3=å
}e'·8±^,	½Û B!„B!„FD	I-6·HTžä dÀ4ë_"Á~ûí§[Ë™-š4Fž« \âÆ”­<Îês“íZ<nKp®ÜzPfÒfp.bN=$ÞUu5¢¡¼m“ºWïª<„¦se^{;í„÷¯ƒP¥K.ôŒòŒ|0ºO¤zÛÄîÆu„ëh/¹ä’.¸ #óì³Ï¾É&›HØ ,«I«þùE?{†–*UÙ[¬¼ë®»®ºêªüì„]_:/˜¹bš+»¼º¹Ù“º\Uì÷÷<ÓÊZvS•½Ô3R=Öj==°hSí°ovãå—_.™žÎÏÖm”HV†EY„ë¹Žáø²Ë.ûØÇ>FRÿÄ'>á™…^˜nNM.	»©Û“Å/¼ðB£M/½ô’žo”E5Ât¹B!„B!„0RšxWË$hvrr×\sM¥Øn¿ývJ\K­-uŒôF"ïã¨®eÿ,;ç„5;wEán&@{É‡ÒÅ¨Ì­Z ©@MÜþWHBi|žd µLÂ£3z»/eYÂF¦‡Ùÿžê¤ƒÀ0Ëõl7lÇÑ FóÛÖj«£zwãX@€†HnyÇþ\ýõåÆÐ—-_|ñÅÚZá>ŽcÝ»Ö/4¡öºë®“ƒ!ë¹zK‹ÈÐOšÜÜh²òð}¸Æ*ô“î„ [þ·AZ<t¿õ¸žÔÇþé]êOTUÌZ3š”,£ùßø†×	éÑüÝRGX¼ß~ûmç/UÚ9ôÐCå¹«Éí¼,Óöj˜ý§w_qÅÎwJ´sÇŸ~úééo!„B!„Bá½A™¢“*Å¶ÖZkñQòxÊ"`¬Á=ÚUfK€fyî·÷hÄã¯ÎÝÍRß<Yê31±%PÇ84¯¿þúSN9å¨£ŽâÚÞpÃ8â«‰t”;¯òŠ–°è[”;•MÅóx¥ÇTÝ=|´Ï­üÍßüMÅõf˜p‘
Ð‰,˜¨¼ï]DOHsžqÆ‰ÎÊ’•8à Ú«'õ„í·ßžs_ë{IÑHýüüóÏ?ûì³ÅJTo'R“Y­ #	bî1ÝI&¦Ã×t•66S+Ûx%;ëÌcz{‹‡¶ZuxRg³ÜŒÕ5&dÄž†Ñ“=ÏÜ-?DBÉ0_ùÊWÀèÞwÏ8Áëˆí±Çž‰ëŸÒmƒvXÎ_|Ñ´å–[ºJ¤×…B!„B!„áh’(§$E‰{tî¹ç^i¥•ÈL¥>óžè¶¥5W¿ÒãÈ^Ýj~]ïð„Íz¶'$Ý*éFD Ae³WeFc¥;ì°[o½•ßÓ3|Ç¢ˆÝ¯)`a™e–ñ½öÞ{oòœù¿»®ÆçSjûè©RØóš†Ø¾,Chå$Ô(­Ü›m¶ÙdqÐ
	)Ú6‘Q3PïµÀ«K\–]þÁ~ÐŸÍâPÎ8ã7Þxã¶ÛnûÈ#—wÛm7ëèZZíµ×^ã&LsÇkÊ2>ë*þì×èÑ Ç¤Þ¶òƒtó {ºJ7ûeLŽûöY%7Wð‹·ë®õLåD[Ðñ|)aÐÆ`X¡©ÏªƒZÍú";|ë“O>™Tí¬q ¤pŒðlµY9<O>ù¤Òˆ:¶J¤âMÒëB!„B!„ÂŸÐ4Ð
&¦8WÜ³ô[Q|ÄÂd©Ï Òr¥{S¦mýYêðÑ+â`HK)Ÿfí	³3=‘èL.¤8U˜~úé}*÷GF¯
lÃ ~A(ü_nPþÓþÏê/W&Ó&¶•ÙQI–e‚nj£eO²ˆÚ¾9í`»W\qÅn+DŒÏn\Tï…ÈcgÃ"&ŒFHÞý<ï¼óÒLé°Æ$J_Ö¢'öÜsOAÏF)ôpƒ+Æ-4¢&¶Bì&5÷„®ŒUtîŸ¨¢…ºJÿ¸Å8Ñ4×3•Ü>;e(éTò²ó×~êÕ>NEž^\½”|ì{½þúëÔgz´ÓV¥D!Ñe—rgº§†-{‹ÓÐwØì*«¬²è¢‹VC—‘ôçB!„B!„04t:!¹$$1ŒŸ‘B	(\äª&­ökm]šf7ÖÌŠJl]ëqW§£ ñb“ÒˆÒTZ“ðË×<ð§’úX¿¬¯I¡æ„õK¼–ËÑ’=j¡Gm¬}ð¹Íà\A
Íš-ZWÀn9X›èy
Ú3ÞH"¤ú,áB!¸Gâ†Z˜IéžE–«+häÊŸkd‚ºJt¶Î+ƒè¢Ù¢]T™>NùO<QQc5–àË¤[kj²Vô²;:R}`x·r¿ ]	-Î¦ž^=Î6=üiŸ}DmÜîél–}Á}öÙçÍ7ß$Oût#7µÂ4œDèÁ];æÝú‡ýßuˆÔl4RUuÙÆ‰þ­Æfzf!„B!„Bø?”Tä±ÜÕV[íÜsÏåØ½à‚¤»–ÆÚ{Ü Ã×	œP¡Ï¢z’ˆƒW^yå;ì°úê«7µ«Ù`G"C7™¬ÞÅ-{Ë-·”îì³dTˆA×õYûC¼«ìÝ&üuLíjS›òè0ÚgŽQú&Ïu)õ§vZ™µ#@3Bqæ}fÿÈG>âx}ôÑl°Á§?ýiéÒc¤Lìºë®Ž¿¤cR)º±Qæú¹Öô<)¶‘b«¥*R¦5zkâê!º‡ì*íð5*ûÅåî‡ÌîŸ›vŽ´á½ŽÝÞŸ,Ï&1ðw—¬\Š³ý¿çž{”[´Ž éªX‚»+€1’a¾KåPM![ßtÓMŽ°+äØÎÁtËB!„B!„ð(©ˆ~'à±Ç“K›+Á”É±…ÕöX5‡ ‡åA­;R—]jÕÕ87ÙTŸ¥XÐë[´ø…N¢ÅðÑ=2ÙB-D²ôYõíˆkLÖå$-›s×‚Ý¬¬¥D÷|å¦[~H7úü#…šKÚò_ÿõ_‹þ¨O·çÑ Ç:hsÍ5—
x+"ÂŸüÎ?üá)Îr!táà¼üŠûiÖ9æ˜CÂŒ† m™0ÍÆ[™ÝÆ*¿OšJ“wË\\Vè¦öŽU€îwCçhÍYä=õ?+Çw—:âÑnë„UçÐžS}ýVÃS—.Ú¥€©¹?l¤û¼rÍRMÝæ47~#ÐÃŠvU	!„B!„BÓ
ï3^ÝqÇã>ðÀwÞy§Ü/ùË4)’+hw„ç÷¤©SPò-¬"kY,=ò¨’Ÿ}öY6í	~|¦›n:qÀŠ¶€ú»”[fXbes:÷ä04Çt¿àÞ/;öˆƒU×‘ß|`P€îîLzìHšl`Pèdy6A€VrP#r²Ï0ÃrŸÅM¬³Î:÷ÝwŸ½ZL‘”ëœK×ÐÅw¿û]öùO~ò“Z™ [‰5Üb¸b¾{ÄåjÁ:/üi,Aé¯½Ù33¦Z‚Í°lƒv`<ƒkzÌÚíI;Yne±éÄb{ûOƒô|µ*´Xªz¿îÜsú÷wxG•À½æšk¦‡B!„B!L‹ô¤R”qØ(ÍŽiT6*é™Y’kf}9vûm¿œº¼¥õ¹þð‡?Pi•’À¬ºõÖ[/½ôÒöyÂŸ:8¤LŸU»$  ’¯ËÚ-@×#ŽÉÊ:¤Y-Û¼Î‚ºùæ›D³§&ÃœsÎ)Æäƒü`=sÈ!‡ÈÜàÆ}á…>õ©O1Ëø¦A\ñêÊ+¯|þùç3J+ÊÇäËº[DŸ­þ¦ÿëöFþ÷ Á-
¹5b©ÕÄQ¡Éí¥aâ8úã2ZG"‚ëç=™Ëãoˆî9¿DÇTg.þmgÒ!K}æÊ7ø¤[zÉu€3zÈ>ßý”òòÛ‚C­'óžs §3‡B!„B!Lst'Å[VµÏ‚zƒr'ÐªçñŠÞ~ûí8Z¡ª'sc‚ÄÔŽU€® „Ñ¿ìó&ãêQG¥¸[ëÆo,3aÈo4ž438çlí=®|£d»V™°'œ¡IÒ?ÈÈOsRSi|ü¹³Ì2Ë@4è÷Þj†RTœi¦™jLBŽÊyç§,žørÞdÇô}®yÞy"é#<²å–[rÐsIs@kGM\²oiÊ¬ÐV«dç$Ðºè=
¯æ£Pwi¼·[«s¬¦æn6ôøŸ_5xcôÞ¶Ûýc$¾”ýlC>5ÞS5éé
6Zàg7äSÇ§ç‹·"œŽ’ƒ@Ç«mˆÈÔ¥Ó9C!„B!„¦Q(¹|ðÎ;ï,²ÀŸûí·ŸÚƒd#Þgªœú%¢Uöñ$ ›•th†HWDŽªÈåÚ¾BËwž°G¦6¸þúëKihŠ›å§žzª«ÅÓõ*?·û~þóŸ+I7&¡yÈhŽö•iý_ýêW…çvS8ÂHË3±Ûn»xâ‰‡v˜ü‡…^øÂ/Ük¯½ÄMÔHFµGsÙùkœ€ß_W/Ï/	•<ÍöÛMsnÇý¢sS–›zÛ@Ñn±à^ma#9&ÔyÔ¾Hjs¿8­Nf¥TœH¹¹Û·óü]wÝåˆõÐ-¯£}}¢ó¡D³B':„B!„Baê§[‚¯2ŽiÍ—_~ùñÇÿüóÏK!¸æšk(¼^•°|ï½÷Ò {,™ã»ÑtºžAÐŠûQ²4ó5ðá‡¶l.¿Lîì|ä#“àXÕÂ<óÌóÐCµ½¥²qtv°ý¹Àã,ÚŽà…ªä¦¤à‚?K	Ã4–bw¼ÏóÍ7ßþûï¿ÑFéÏ¬Í,ÏFS¶ß~û‹/¾X‚9Xó]yå•74%ƒ³gº­PaßLîä×ÒR=V!Êª<9L¬Ê˜‚/Z€ÌOŸv‚´3®iÜ=³ÞëùX}µ6Ûjx>áqnõE«úb½T¦i/½üòËŽ•q Ûn»­KO|yOÄ¹Gem™¬ÿúë¯3¡§—†B!„B!L+”ZGÜÜgŸ}®¸â

??ûÙÏ~øÃ¦]wÝuGq„Ø–PB˜?KG› ®ÌeíŸéWÓÍúÿÆ7¾±÷Þ{o³Í6=_aÒ@ÿ•$@ƒ+7kOôó„õ€W±»Ò9p+]¤;l†éÕÌÎÌ´=÷ÜóÀ<ãŒ3vß}w7Þx£Hc*¬ëŽªN>ï¼óZíg?ûYð¨c^1/ÕÄÕ¸å®øï’’ûÐ#ÏWyOÁÍõéýc6ãÓëÚ÷µl¨£Äw<üË|Í-f‡4_ÙÐMø¯g
Î&U·3·ŽUÿW«Ë…Ó¬äçž{Ns¤‹†B!„B!LýT¥Á±pÐA©ÌF’»à‚Ÿ×^{m.QR]Õa+ñ«g¶~×ê8n)Ý·T­³ÒÂ¨`%ýÕ_ý½Oh¯¬ç/~ñ‹b@_|ñ®q{`’˜‚+1 Rc‰u*'—
iWkÏ+`·"&ˆ4ß÷¨8”Ú‡ÄŒµ±„o¬>Èb‹-Æ¹/Ð™Ÿ÷YÕÁSO=•W'»:„º÷õ×_ÿøãK•¡«jGÍWzk~›Õ½’%Ú‰PÃÝª}C&ÆŒµÛ¿§ôŒÚ¥îÙg,Ä¾ó\„¶eêpm‡Ý¾ê+ú¦5ìTåëïz·[ÁÌZ®©!µuç/¿¹…ýèGsÏ=÷"‹,¢,dºq!„B!„ÂTNyiIuÛn»-1hå•W–‡K„âj|å•Wˆk4_²Q·Ù‰Ïã,@7+(éŠŽÆ#éC)­ž‘“{íµ×¾úê«&ì£‰†D«V`p’éÎÝcU>””i‡Ë(j·´cŽ9†s¼$¼*ï6aK/ÒøÖÑ}÷Ýw`‚Wœ*)^æ}öçV[mÅøÌËæ™gÊ7§;_uÕU´é‹.ºÈq&:sC×°‡ÑŽyk¡Û«»¡ÉMcý‡A†1õOë÷Û¥í!%½>·²ª›ì[ºùøÈÐ•6î,#³!IÐ>¥žñ)Æº™×-$g$AðÿsÊ<J™7•¡Šj†B!„B!„©–RT…œ~úé;ì°ƒÌ¤grj«1XÒð8OðoJ•vLz\³—Ro[þ¬; mƒÿš5Õ.Ý|óÍÊ²=y)ºB$“<öØcUœÍ‹éåG~¬ZÔCÿñù§A¼Jvt&mäÈ”EIó"5–]vY¥)$C«:h´€ºJ†VþîÑGÕÇÈÐ_øÂ4™8ãÛo¿½'pcH+z” ;&#ó)ÈihÍ-cºí}œYÛÙT‰-Ž£Ö©N2>]Ñ7M_vVúSFv©Ïôè*ÉX½ÞØŽU7“ºMeh+wSã},<^}õÕÕGÃIB!„B!„&¥Ð5“-ôÁ´ð½ï}OÁÑGM­£²uÁ®GÆÞÚµB“¿i[/¾ø¢Ç·ß~›>Èµª@â()¾g=ôÐÿøÇö™ôLÙôØs¬|_¹ê¶½W3ø¥½ô«Ahñì†išê$›nºé†nxì±Ç®µÖZ;î¸£L	íÅ¢Îx+÷ùþûï'=“q™|)¡ú˜ Ž:ÔDê®{½Ç†\=yøèó	"@·téRº=–­ÞîÉ² M÷Ôð‡òƒý…@‡ÔÜÛ2ZÉAte€”_IèÝw9guQ{øÌ3Ï´¯Ð¶æ-Ng4õßšÎ£Öjé½!„B!„BS	­„“9ôk_ûõí .Q~=Òš =þUõÆjÉl/U
G	mlªùÈGŽ<òÈÓN;mÍ5×\j©¥FUå=aÙ5Ð£Xj>èò{vÅÊqpŽ¹~s¿Òþ~øaqyóÏ?zr?MÇÔgvÙeµ"ålÜvÛm—_~ùe—]öÖ[o	”øÝï~gÌ@®Ks1k)MY}¯Æ?z’ÍÛ0@IÏcíÏã©>ÃÒ¢Ò‡ŒÁézÇ'ô£ÿü­Ç¤]HÒÔä~·¾cëò•¯|¥¥[LGg *~þóŸ§PŸþù=B!„B!„¦(¼ûì³ÏPUÔn¼ñÆ7ß|³ô¸2-–x4žêó0ÞÞ~ý‹½TH‚ÔiÉ	äæ•VZià]³öûÞe4ºõÖ[™PNµ¤W–¿»Ü¾øø‘]s+÷+£ºžyæ™ÓûihË§³²äÎSN9å‡?ü!´ö’”B†®CZÍ§Ã“õÿe¶ÜnöØI®u²´d"iÐCÖùì>Vèsí†½úÉO~2>©Óídï7>™'Sƒ"´æž¬óîa)©º4ýÚ·ZÙ1ßÿýYÔucáÆ–)B!„B!„0Ðæ¹[¦,÷ðÃ—¶!‹€'‘0D*ã31N.Áð
Ô{ÒÑ†y‰Õ|%Z	I8ê¨£–Xb‰Q,K‰>ï¼óik·ë[üï2¡Ü¯CBm¼âŠ+ÒŸ{úvë*|ýŠj®¶ÚjÛo¿½Êþð‡çšk®ã?žv¯cWoüã uT"¦ö³Ÿõ7bKAé`h/OÆõ<Û F÷™¶W=ög_áÙgŸõ8ÎS†9I›µÈï8dp‡=iÇ¹LÓ]4ÓôÙgŸÍœî€SüUƒˆ:„B!„BaJ§)t„Ý]wÝUÉÁ­·ÞZ‰¿Ÿþô§„!2´JzM'"ýèG?*-‰±yB'  ÝÍ„µ?ÿùÏŸ¿ýíoó>“ÅGÿñdœÍ0þË_þ’ŽÆZKJ›ês%{Ð¾í@’ ‹6¬Òœòûî»¯ü¹á³Î:ëæ›o~È!‡È÷L¿†[>bêss×BÓ[ŽJWtn#ÍFí4éJÆã²1¦Èš&4­ò<Ò	•U²ˆâø-iþÚk¯­©~ç‚¸˜î‡¶/E€þÍo~#¸FÈrwÜqq@‡B!„B!Lé´Ðçüãçž{î­·ÞJ "¡š¹/÷šk®¹ï¾ûˆÎ´*zSWnSLìé§Ÿ&¤@4xNéàŠ’	ê•k|æ™gò«¾Ñ|<íªÔl‡ÎA«L†®%vâ	Ðô;Åôn¿ýv;Í®¿‡‹Ý`í¿è¢‹¾þõ¯W‡ßsÏ=¿úê«	zŠ
¶\}¾kòíº}½Ú_r°­VæýŠîùÇG€†­˜é©hÁÎR€öé†Cúw£4ôñé™ºœR¨ÞSà{ÿgµ—º‚¸æRŸcŽ9ÒC!„B!„¦l¨rò”dcvÞj«­xB¯¼òJbñ—Š*‰•ÌÄ´H½â²lŠUÉFV«²lã,­ŽIòøÐCQ Ôñ;âˆ#jWK}åêªÉÂMÓg÷ë{E}÷»ß½çž{¢>7Ä¡hŽÁQ,»ì²ü÷ØcE]TíA¡.XìE¦tÕØj¸*”×õø÷„o”ë|Lq=šõx
Ðm—œŒ]7}ÿG·È—ÖýhÖŠÊÓ=’xî›áY¶?#Y¿œàMÙï&V7wví¡Hî'žx‚¡Û0˜!1I)éÉ!„B!„BSM¦\e•UvÞyçµ×^›ö®»îòøo|ƒZôçþçeyîUi&àõ=éY=º^‹xå•Wˆ“ŠðÚk¯m´ÑFöpúA¦ c{ê©§VhC™:'vøF7`÷ôÓO7°òÊ+žªŒ“¥oë0³Í6›H™6ØÀ3o¼1/?1zÉ%—4Ä¢“3>s‹“ž¿öµ¯ér“¢Õôü–¿ñÇ?þ±;â2’øò÷£<Îsìäo¼ádiçÊÍòÜº_+EH€î·it¤fÝMéqd{‰úüÒK/U	Á±–:loì‰þðgIÒuØ…íÜ}÷Ý7ÜpÃ¶Ûnë: &áŒ3ÎØrêC!„B!„ÂMgØ}÷ÝÏ:ë¬}öÙ‡ñð?øøˆ2$Ö¼þnà@eŒ$(`ät"ë*Ñ\pÕéê«¯fPg<0˜–0…íðÖ[o•ØG%ò M@é¹IŠÔÀ{ï½—iÃw`ZÏ­o-­…}^Mº3áòºë®Ó
â
	Òšÿûßû“{×rùm›9·´Qý¿:ü]zŒ(Œ©¡Û²Xg£AÍÑ¬›•_Û7ü2’Ý«÷v¬{Îh‡¢äøæ¿n±¡ŽúÓ²=!äé¦ÍÐº×
sþú¯ÿºÙ¢k,#ms@o¶Ùf5Š0úg?„B!„B!„?!ô€`4vÁÊ&Iž#@3~vË©•rDŠê²íÎ£§g%köI‚šÝ°¯¿þú±Ç»þúë×~NYfÞf˜ÁÞ^qÅ£ˆœãµö`Ó¿óïNq}ú´im>Ùå–[n‘Eqt¤uÖYGi;‘âÚÂá"•~ï{ß£ØÖô¤ü®Ï·ŽªVkÂëx: '5TÓöðŸù_ƒHa½¢\§ghÁBÛõ}Ï$_Ü°»7£·³»™¤“[öjzCž˜ˆ%»Cwê)~èKnnØ¾Ž[ÑÑÇü©§žªc^­P{Ug8 UW]u…V˜â®!„B!„BÓ4MÇ¯ÌÌøöÛosÎª:øÓŸþ”tE3£¿«>÷etM”]Wæ¸å³ø…éƒgœq†(ê\ðæ›o^wÝuguÖ¶·S–ð$ä$çH–g|bë•M$å}f·Àö;0­
vh#+BË¾ñÆ)­(âÓ"•QâfO»x²™p{l¿ÿ5
hsjÈÁ®:aŸ|òÉ‹/¾XâÊ2Ë,³âŠ+î¶Ûn'Ÿ|òÂ/¼ï¾û[’í.á}›m¶Yl±Åæ™gž~ô£«­¶š lÊ$Yzé¥M}ÐQì5æÔ=¯kÒCY­+¾£é-Š§BákMOv«#ŽU€nËìÏÏ>û¬Ó¿Iÿ”t¶èî:çœsqHîèŒ.„B!„B!„ÑK%§›nºí·ßža–éX"Á/¼à±Ôgêòƒ]ƒs£Ç]¦Å‘+t]µº¤=RßîM7Ýtçw2B–À´æšk
²˜‚b7zP8‘ó´ylß«(?‚u­¯í`é‰r½¦ŽR$[2ƒG}†úìëa™gµ‚cB€¦eÁá@1ðL‰§<ÂýEÿs(FÞ½MèINÉðL÷£ÇÇ\ÉÎå}vª*Ÿ¸üòË—Ý~|Ž¡M“¸ë@%Ãú¸2ƒ·:mnxŽå¦7IšÖ?Ö"¥—°­Ó»ucË_ÿú×	åÌìuYHG!„B!„Â¨¦´ò‡’TGð¥—™’OÏâC$‘~^|ñÅ•¹T!‚©_H¢4\i-ÑªxëS¨¥·Ýv›ÄçóÏ?_r1ofÏO‰Çù–[n¡»U&ï8Ô7Çt%wû\¡ÞÓ€ú\rd}MË,Ïú6«¬Ä†vØáÐC•ûü«_ýJ4„Ä	aÐr]hŽUÔá"q¦Ç-5b¬±æã @·Êý¹ÉMöµÿ/¿üò~ûí·Þzë	™°ÇSÞú^{íeDª;¹¡iÐÕ™›JÞ?’Ô†£J•®mFé¯‡?hVóÕê ø¬:Zj»í¶Û|óÍ·©äm°!WòB!„B!„QJS$ùC7ÜpC³õ	pL ÷w'º¡” Òp¥»Rzt4
å®Ç1ZVGšÑuº IÞ”noTN(­øÚ/ùË¢`©Kdñ÷½Ë”{¨}á²M$ššïÀžtÒIµS·ZW4ÑÙ²´–ÓO?ýÌ3Ï4€±õÖ[SQ9j/ºè"D‚_¿„š¦~Në,…ÔˆKË:òhC[¹þH¶P²µçÝ3*yù•W^ùÔ§>Õ=£'H÷lG¦G^ÃEMz®â„=å
Ë÷]‡º[lp¬5ÛpW	Ð5<P#^§œrÊUW]õÈ#Ü}÷ÝQŸC!„B!„¦ ¦dƒ6Øh£XI<„ŠÕ²¤äÒ•Ê½Ø59Ž©À`7zä
}–ôJ}>ðÀwÜqG1¯‹/¾xéÎMfšB5èYf™å¨£Ž’ÅLŒ›”4Ä2pµKèÄSL­¹R¬½öÚúõY_ þ±}L¨ƒ³ÐçïÿûLÐ5vb¬… íyÝ¯ü¶Ã§<¿×¶èQ]Gî}nÚ«ó±ÎÄî
$i2:ã³<Š}èC%¸L €ïn÷èžzÆ0¾ùÍo–@ßÿ½š‹¼aÔê‰'žhrsÉÇ”èòD?Óš€ŠmØÀÀ€÷úÓéc¤JvŠ!gÓì³Ï>0µ©„B!„B!LytõæbI¯L…×_½8FQå}."aŽË’¹Ç†ùžÄÓå®Íâoalžò¦E"\rÉ%vf®¹æš*9šÊÉQ>)«ØñŠÞzë­
K¼+ßOÅAUlpÉ%—Ñ@ƒ>õÔSÅš{þŽ;îp$É°ö“2©¨R ”¹£lR¢+í•¸	£“¸Ì`;GêsËYÜÎ‰ÕµšÚ€vX.³i
ªú²+¬°Bu­	Ø¦Cnª=ÉmÝNÛ6tÔê4vOyýü¡‡êªÌDs¹Ö1VáÞ–ßyç×Ÿz‹/~Ã7XÞmtJã& :„B!„BaÔQeÙJ¸!Õ]xá…7ß|³T\²Žäå|ð¹çž«ç’¨u4 ‚Ý8Ð]Wi7Ù¶n¼ôÒK,ºJÒk'§>W£8]oÜ9ÉÄMÚ¥"{,´l¤%ëOÝEÛªÛ|ðƒT²RªÌj«­Æ{.zŸ}öa6²RÞçä7ÞøÞ÷¾÷­o}K‡×½µKÓ|½Úz>idèžˆ£AæÔŒž_Ó–Yf™•VZi§vê?©'Ív0UqìÊå\ÉÆ¨Æ”M4ÿéOÚÝVg/?{ì1¡ð¶söÙgW=Òv)!„B!„B£…¦×É¥Ð~øátg^EâyHsÅD49‰i”øÕÍß›gF_{í52A£“œÄ|-d¦™fšZ'Ô+×äÅ–B0±1AZå<5Æ°ÀLíugžyf½H"Ñª»¸ÜrË­»îºGyäÃ?Ì;¬c;ìŽ	4Ú‚˜Ú®®{;\•Ýú#‘™Pø\Þ^qátgÖuZóÆoü¹Ï}îCñEêÔ¨Tô¥2É\í%øÂå¢õáž9]+w}£Ï~ö³çž{n7ú¹¿¬âÈ±´×ï~÷;)tð–7Òv,„B!„B!Œæw^†Ü5ÖXcÏ=÷ÁqÙe—Ý~ûí’pYe[ø1ŽvÉÛH¶c%§ m›òmÐò~ô#eÉÐ¼ÏË/¿<Ýpà]!©”µ©L']tÑEŸ~úéªÉÖœà“@Ü¬ 	‚¦äi¡cë6K,±¹¶²)äT\sÍ5PáÛßþ6‹ý/ùËêÉg’teGT5Âk‘/<Y¤çfæXgßþøÇ?^ßˆ†.kÂIZãïº¼K†n_|Û4ÁWQGƒFMhn‰%=ÁÐŽ­{ß}÷ hõ	{Ö¡(ß“ˆ¢W?ùä“u•˜PEC!„B!„ÂøÒ•«–Zj©+®¸BšêV[m%ýYZ+S!C(m®‰Gœ¡ôb‰]Kã˜
vƒž‡I‚¾ë®».¿ür~jY®<žÇ{ìZk­Õ³Ÿ¤Úh û-%™ÔáíÃf…žHr'MSôÄ<@ÁœZ;öûÞ¥=#§âÃþ°gÕüô§?}Ë-·P–ÉÍˆñ2-¼Øñév]¤™Æs ¥¿çwU×ögUÛ«N@^õo¼ÑÈób†fàã>ãŒ3Hê«®ºêd7°w?úÒK/í”{.Ž­é¸1€vb<7òT‘Ö#,ÃØ&Z°ÚÎ²¬úbÿŽ…B!„B!„ÉCù›RCÏ/{ÕUWmºé¦_ûÚ×˜.«Æ`We%±:võ¸îtøÁhÈÒmí9°6(YÔ†êptm¾ÈiäÈ{ô}+= BúEÉ‰g­¥ý‰ÍqÆ§Ö#Ü°µñ…ZèƒL?ýôœþ†XˆžhÊ²¼°[â¯RÈ{zõ„mŽ®árÚ>½[ð´çä9µO<ñDYÏ[l±ÅÎ;ïüÍo~“z;÷Üs¯·ÞzÒi&k6zSùíƒ`¹«×œ‰î ¾ Ùº*ðÄé¯Ö¨iM—Rz®Œøž«éY8‰CT#Î¦cŽ9f ês!„B!„Â(¡É4œ•‡z¨IôÊyIf`|öH$"Q|èD¥#«:ØJõL®R€öÆªRØ£A·pX&k27ûó†n¨òátÓM7-ó:ìsÌ1ÇO<¡ž£ô¿é¦.Lì0hšÝ²Ë.;Õç:ÔzòÕW_-yã´ÓNSxPðÅ³Ôç–oÞŠ@vÈe…FO´'”š‡\À%7WÜsÍ0pîüä'?ÑCxÕe²ï»ï¾ö|õÕW7>¤óˆ9õÔSW\qÅJªWáÔ<ÈÃÐåî/ÍdìøîÍÎ<Ìl‰V
²­ÓMå¶©_|ñàƒvˆ B!„B!„0J(4Ý™jc^¿gÄ_ÈQ¥yÉÆ¥UÁ:þÐŠ~þío[a¸ýé®C
ÐÝŠd=r’­U…7ê³ÒaÔ4šZíÕÔ—õÜsÌk-÷7Þ ØI5!WnéÎÿ0ÈDàÐŽì´Swß®C-+™P{íµ×ª’§êà·¾õ­“N:©/×-û­HbNÿVO4Q¸Û¥›1yÂFpXp–q7Ë´áä-ÅY—`Í&IÛ}ãŽ;î°Ž	O=õ}‡v8âˆ#˜|/¹äA"<ì›m¶Y	Ð“å”éªüóÍ7Ÿ`_¡'™§çâ ï9à-V¾Çi>|\Í:YJÔÖ‚Î¡=í%Bö£>Z™B C!„B!„FôÂ–š`{ï½7…îûßÿ>Ù«êž•‚L›«"lÒ9Úóã¦¸u&²Úé§Ÿ~ÓM7IEk;Ë,³t{§ný¨¾’ŽÜ_2\	ÐÝ,ˆ‘K™ïieIl¿bO¦îŽ]Z¤hôùçŸ¯Ø õ™-Î‚à+müî»ï&7óAWW¯£äù7ß|s˜dó	(@ÓO 7ó5õùþûï·¬ˆÎöM5ÎGyÄ“ìÏTi%+-Èâ ›;ƒ®¼òJ'NiÐfÂ™ôYíT]yå•ÕH´Wu0ué6øÔc!'s+»Ô´Q–þZ…Cb›˜îB$»¦ÔŸuiRÂ´ÐU³4—÷B!„B!„É	å—F£”Ù^{í%ãùçŸ§àÈ" ylÙÍ-‹–÷°<Ëã¦Ç5Sd)Pž»ì²óuÓ‰¦5ÁH„ãÐ”µq÷ß« ]žtº§¬QÈSw÷žneúhÐ´ZÚ¨¸ç/}éK_ýêW+ÊÜ¸• \ñM&b
Ðtpês;/Œ
¿NFºó­·Þzá…RÉùÏ<óÌ{ï½×PÐþûï¿Új«]pÁÎG’ôa‡öÌ3Ïˆæ Jû²“^x­q£šµ°É&›ÐÊºiÒ#+WÔÛˆ1ô2Ý¸¹øÛ)Só*;Û(šã0ÕÔ,!„B!„B˜‚á\ýõAH|f½þúë«_¡ðBX·,^WDgÑ­=Ò‰.½ôR–ÉÚ“iJ*jÛd¨ØV„`W)O€îÖmÓ¾Üµ»ï¾;ïùÔ}¨çœsNUcŸ{î9r3Û¬ŽíT4y£ŒçmÐeb×ìÆ´ˆ²÷>ôÐCrB”¤;ËßPfð¼óÎ#ªî¶Ûnês’ÑÅµWÐ_ÿú×7ÞxãñÇOX÷$%šæ>0ÉrJònÐr]*ß¹f‰Ñž©4íöõ=S£Yû‹”Ž°'·ËQ‹™vÜ8à€iðªB!„B!„0ºMP*•2tRSMó?ãŒ3rÍë/”Ñ’W´ri›tü]ŸT'SæyNiÜ«®ºê@G,›v‹-˜XÔo“;›`÷^EÏ÷$@Û>5s–—ö3ŸùÌ~ûí7Ûl³M­ÇY°øÆoL¨½êª«tlQË„]æb}»ôJ°¹ž»ºsW}žHtg™qÊ8MÜ£Tšòµ×^T}Â	'H|ö¸óÎ;¯³Î:ŒÏ«¬²Ê¬³Îºí¶ÛŠÞ`ƒ¨½?þøW\A’.xÒŸGen'²£íÀ6E¸bš‰þ=tÓ|ä3ý'HÓ¯É÷²V\Ü­%#„B!„Bar²ÜrË¶ä\sÍ5/¼ðÂí·ßNª“,ý¹ksÿªk]EÒDYûýïÏÚ)^`õÕWŸ–›`Ë-·TÑ±Iœ]‰âÅ>øâ ô	Q"¿§šƒY’«ÇÊ °,Úåê«¯þÂ¾àÑPÊ7¾ñƒüÂ’+è¼øÄÊ&’Ž¿ÐÜÔÕþS¦'Ê£–}zó4cì§ÊŸUçÓ«/¿üòw¾ó/~ñ‹ÎU	ÍRžÛùâÎ>ûìµ¼Ækp@¦GIH;îl"…qŽŠfÖßhÐ¾æYðÝKÍ˜®6=ëWtÿ™bŒÁG`,C£ B!„B!„0Ù ™ªÿáø¸ãŽSëìwÞ1…ßÜùO~ò“ãñ<Œë¶b=üùõ¯ý©§ž’û10¨£Ù“*7­»îº+¹¿en8J•i;Q]·¥ñ©ŸjÙL-¹ÛÍÑ?0h|^a…Ä‹êSŸ’_±ýöÛSŸ9¾Õ÷£;sã:æ•¸ÝüæãyÀ«{©Ÿ¶¨„Ò—K™•ï¬Ì 3B
åôCúÅ¹BÏ=÷\B¯¾ú*ÚWð¥æšk®ÖyºçÊÜ5qvCeQSº‡Å—ª~^_¼ÇfÞ®¥,µ-jƒý&èW^yE>	ížU<ùB!„B!„É	‘h¡…ši¦™D ›O•#G~å+_1{½jâMTìƒ¤é»îº‹>Øö¤›;Môßå[€€CôÇ?þq‚Ï‡ïJü‰O|b`j kLE¤¸@sÄÜ=öØcæ™gö's1WÆ…±ø=îþ÷@<Öá–þÈˆòA;¹ööÑ4qº³À×_]á>¦]ò“Ÿª>å”Sœ&Ûl³Í<óÌó‘|¤e\ôŸ)£0¸ÆU¥JçàGîñ8wh¶ŸJ‹Ó€aºë7¯íû ´™>Ú¸Ú@ C!„B!„&tuç$ÉJ&=Eâ’çˆ8eWœ°ÜDÂ/~ñ‹k¯½–ê]fÕÉV;ªà€vð›Q”i”7Á?ÿøÿ(!áØc˜Zr·ë+jwÜqÇ}öÙç ƒZwÝu/ºè"I/ßÿþ÷ö³Ÿé~”})$Ñ*³Ù1‘Ž9©´>ô_bÈ§jôý™ÍÙj”h!ÎN;ïÜ´6‹!¨Y­veËi_Tâ°l›TQáÚ¾{·aOþ†'û]ÏC6D9Öû×iïõ‰tçgœÑuFêw·c„B!„B!„IA·PéYàìwÜA©‘ÜfÇ—÷^¡=ë7Oâ?¢¼áóÏ?â‰'–—³íÌÀ4,U+ÈXàum­”ú‰]øî»ßý®äRàn»í60%Ð]Õµ–k`CÄ3Ë³ÎÎ¯ŽŸ‘•RùK>b¸G8n2ñ:õ0mÔ³5ò·­ž!ÒIËL7í@sHÑFþÅGyÓÈ?aF®0Ÿv4þí]ª“w²{B9zŽp{ìvW~w-4ßô§?ýiŸ¾çž{xàS‹µ?„B!„BaŠ¡©uæõËz6å_èçÒ@{ª½WºÇ·[›¢ýQŸÉÜpÀå—_>Ûl³ô)žÓ²	ú„Nè1~¶#?ñh)Ã—\r‰H
!S²H×Ã˜sÎ9?øÁ®¸âŠG}4ñqÿý÷÷í±|ë[ß’ûLñl³_hî×=½hæ¦>·á™VXo$!Å•kL€æËþÌg>ÃíŒ»þúë¹ÝÙ±ï»ï¾M6ÙdÉ%—ÜvÛm§¦Ž-\ž¡{HQ¾äæþÂ˜­	Zc5ÙÚ:±¾;6æ-·lÊè‚'ÙÛùúõêJbYxá…§ñkK!„B!„Âd I
 ^|ñÅâ˜…áJ®éí%÷q*zäÄý‚i‹se €P¡ÏT¡#Ð=[¼À´ÆsÌ¡¾\7Í¶d¸	®8wÕU-B¤åýö·¿=øàƒ{:Æ‡N¥;)žiAª—ýùçŸ¯ä  àêÆÍc;V·r¿ Ý¤ç==¶äã®'ºç½­ ae{”¢Ÿs:Û1sž~úéwÞ¹ªvƒ5¦Á”¤þÍo~sÈÅ˜òÛá*º–Ë´NÁ7ŽÅ'Þ&jÔ:MŒ¶‚.ýì³Ï¾ýöÛ´oaùå—¯«ŠÇhÐ!„B!„B“Z]FÎ,Óåm·ÝFý¼çž{DtU¡
Í¹·k,%´õ¼‹ÖvÔQGd.üPå¿ô¥/MT³s¿<ÊÕ+âÑG}üñÇé¶SnÓTŽyí¿à…¥–Zê˜cŽ9ýôÓÏ=÷\o±ŽM—ìlß« ÝuL—Ö©P'SÅ×ÈMOæL7°˜3·»MgÜ‘GIý¿ðÂIäk­µV}‘:þ-}ê(È)N„ÜœKPR€î–lG¾ôh—GûßøF'£þ7Ó´5EØ9»ñÆE¯˜U 8{‹-¶(é9WžB!„B!„‰KWÒšk®¹öØcx@M‡–T'¦`‚h œ¡4 ¶þð‡ª«íµ×^€ºmÑM0ÀÛÌæÃÇž4‰³+•Ž[«FùIåT”€;ÅÉM¨­}Øa‡®¹æ¹[n¹¥¿˜Ë¸iSŸ›»¶¿~Ýåû2A{”¤¡‡wµéÛé@3í
ÓÎ»ÕW_}éê"wèÅ.=ŽrÏ4¡¹GýwÄÌÉhÓ/Ú„á<òˆ:B6 ´¦ìOî%´÷Þ{o·ÝvµS“£<„B!„BaôRú‹9é3²ß~ûq&tÌX'Ùð,ÓÑZ$ëøÈÐ-j€ð÷ï|çˆ#ŽPˆlàOðÐvÙe—²Ð6­ßE;&tœK¶D]" `î)4ùÄ´çÔgK,±„@óC9ä™gžÑë¾÷½ï½üòË,˜×»³=6Û®R<’Ã8¤9šúøCùy[U=çÑOúSçWÍ!(8¦•¬Ämž÷i¡“kšë®»NìuË–éÖ!lÑØ=ážçwŒŠµ:œmHÆóo½õÖë¯¿NƒîiˆZç¯ÿú¯y©2,°ÀÀ ô\Ù,q@‡B!„B!LtJ…!	-³Ì2‡v¹™jó“Ÿü¤I9¤46ÃòuŽ›î\j‘íØ,‹âUW]%Ý˜8H˜¶µ-Úò¥—^ª	*å¶Dá÷”æÜ²ÞScù¬çž{N6Å/¼pÅW´Hî)«HŠÓO?½Þ5ï¼óžzê©O=õÔ½÷Þ+ÔBÚ8¬oG€¦f ˆè–Ýl‡:›åÜ«=ñÆtÌ»–ÛžZþóŸûtªh¡s¯Š:Qo¥W*g®äfÙžº¡kNÛõÁA®VpÀµK¦_á*¤ádktóÛ¡ö.ƒ
ÝF±ÍvÕ2ê`øÁGl¾ùæ[mµÕA´Øb‹ug„B!„B!„‰ãó¾ûîK“K ê`OÄ-‡g™pÜŸàü^ÅMÒÛ™gž)ô¹kb£iaŠ@òÉ:b>Ëg‹*æøk8mÔ\Ì–Ë~û^›IâÊ}ƒl»í¶­™¦¸c¸ðÂË1ßsÏ=…ÉÈÑf|¾|_ÿú×”ÊÒ4Kôìñ;÷@ëìI„Þ{^Ç¼D”ýÙéãC%ª·TèÚ2­ßA¾á†xŸwÚi§uÖYgC}Mq(Õå:·\¾æî•§IËÌË¯½ö±ÞU¨GÓ9é‰©©Á›¢mYË*«¬" ºM¼ˆ B!„B!„0áéQ~)2_|ñóÏ?ÿÆoÐ:›|ö^óº’P[¨ Èo»10˜2QÞç0&”Ë“' -¸D©–c:þÝda:u7Øa¬²éWæw.ÝgŸ}v¹å–›ÓŸ›h~ðÁ«t÷±}Lâ³4ŒË.»LªµLínçt”„3”Çy„ÁÙ=
õJh7³Û#;9ï³Ö UOlñYgeÈgÉ%—ìÙói§¿«M“˜Ë„^ÇJnQ3.uÄª?s²«Ð8d×­r¦ÂL†¬^X[Ó±¿öµ¯©ªš¯B!„B!„‰NI0•‚ºè¢‹üñ.¸ 4€Mó½Æwº&êIàmü›¿ù›ÓN;â–ƒ?V´Ë7ÞX	¹äÑ²?Õ{;>tY˜TÇmºÑFMYÇí}ÃYgõ#ƒÜ|óÍh!äK‚~IóíÐÉm`6wœ[A¼‘Ð¥l”»Û,*»£6åÓ"|õ«_­q‚[n¹…å™2^§C%VOSª¨FÙÜ‚2šÓÙa¬ÂŒ]Mž4(âŒhòžðn°ü³·÷4_â°là£ýè7¿ùÍ³Ï>;™B!„B!„‰Ks¶~øÃ–…Jj\sÍ5ÙŸ‰ÅŒ„-˜u|MJ_)§¢!dÝŠÝ q¯¾úêƒòwf¾Ó.‚#D³‚R6›â6Qéjvjµ]}õÕü×2Á§ÄcXþúµÖZkÙe—•5¼øâ‹ïºë®4ÇŠnÐÃ{ÒÌ}w1]XÈCÓ GXr¸id…²iFYºSÄnx¾²‰ëÊî9ÅœŸûÜç„ÞH©Þ}÷Ý=L)Ûã‰¯ÏŒÜ?[¢-÷\X›o½õVm×8ïY§òjzR8Z(J=óøão°Á¢NRõ4„B!„BaR°Ë.»Ð…?ýéOŸsÎ9¢r	4Ô4nÐ±š@‡1IØô šÑÇ?þñ¥–Zj 2õgL”yçw¶²ÍE;ryÜ¨ôƒ2Š>üðÃôÁyæ™gÊ:z¤çYf™eæ™g^{íµyluo¦{A÷w÷è£–=¶ü¶=‡«TiG»bˆ‡÷•w¥Râ¦¢’Í+!½ù ËX]Ò³²‡–Y/½ô’hï‡zHÜQŸ)´Àã„B«’ƒŽ¼ãSÒ×BîOO¨Ãþæ›oþèG?ªòƒC6P·d m;u™äQŸž B!„B!„	OK'°l*:aNq6Šk¡GÒh=U­†#{J~•å™ˆYY®,‡ýÙQŸ‡.ùÌ3Ï8Œ¼Ï•30žtO0÷0ë”ôÕW_••¬^ßtÐjHcºé¦›þù×]wÝ½öÚëßøÆwÜa4Eò¸.]c!ßùÎw˜Ê›O¹)Å²Z¼!c [*q¿K—¾,/û•W^é¦p47.gtY¡UÒ³©—^zéB-4-ŸÄ_ƒË/¿¼Ž:\F´N‡dÆŸ]ëHÍþÖ·¾Õ“lÞ“¶1¦îm$€Òí„ºâŠ+?üðx ÔÿB!„B!„0)šøÂúãÿ˜g“Où‘Gyì±ÇþuÒkˆtDä÷ä}nY·
¾ñ„>ýôÓÄ¾óÎ; XÂ_#l „¶rnŽÉìù^é#ÙŽèg£dÓ|Pc‘q§ ‘Î®:tjiÒ ®ðS„©Ï”_ÁÒ`ÊN«`Ó¶ž¯'ÀÔèK;øcÒñ›mÁG8YÈÊ>¨­V‚µñI&?ûÙÏlMî³!ŸUW]õ¤“NšÆO-µÓN;Ýÿý¤ùÊESùGÂq9 LVîÖx¬l‘Ì pA«iwß}7ûù>ûì“KM!„B!„Â„çýƒXPúì¹çž»òÊ+ÍjW’‹MAk5K’kÁµ#7ÞÒƒ¨<<†ÔgŠÏ–[nÙU0ãz!Z‡Z·MƒžØ´€ÁÓ;ï¼³Õ%jO¦ºº–G™‡rˆýê©§Œ©0ÕþÅ_ü…cè`6ƒ-c¾¾=ä1áuúÝâ]Å¹'°¸¹^½êª«>ûÙÏ:qZ¾‡Ê¬’·Gy&+¬°‚RŸ³Í6•<§ƒxn•!5Jú{‚MºÞÿ:ºMP«Zm¬iõ.JÕâêL²ÃË7gÁŽ:„B!„BaÓò—Õàºè¢‹L~çwd0!–ú\‰ÃipfÄ¿§ìàrrzŠ#`ù|ùå—¥ó¢tê¶Ãà¨ªk2ªŠã¤ eøPaÿý÷¯3‰tê%4¨HÃàr%øJÕøå/Y=™sVFsK{°ÜsXºÒçÇÊ	bL¥ò£2ÿcî uŒèH³é
Ö¦˜àÔøÊW¾ÂuËÝs2N›¢Zpñ©ÕÒ~ºŠs]‹ðzõ?éÑšG86cÈAZá¹þÉO~¢Ÿl¿ýö¹Ô„B!„B!LJêjj×®»îzÏ=÷wÜq´99O>ù$W ©®Ù9é>5/~_áˆ¸Ãì©ª!¹MBwÒÃÐÕ"·Új+Iu<5Á+Ž?•Yì‘ü=Çsüibø¨íÛmAxÈu×]'Û÷‹_ü¢c! @ý™!š”ßcØï—ž‡‰®`t9¤LËfP–ëp54¬pÆgTšGÅ>8•ÌàŒþÂ¾ ü àãœÅ¬³ÎJvô.ƒa->ÛQmeërT§@½DDv‘éýêÉîhîi®lå}/c$ÀÊ‚«Ì0Ãi‚B!„B!„	C‰›Ô–\ÐÄsù§§œrŠ°ñ¸ê³Ø® Cz.ËáHè
À­õ™OþóŸ›Þ~ÓM7pÀÓO?}þ©A‚RÄÈ”ÆOÒ[¥Öþ×$H®•ÁÆ[}fô[tíá'?ùÉµÖZË¡;ÿüó/¹äÝ›@yß}÷±rW 99ÒŸjÙõ”Sèð˜þÍ×ì‘]gMmªRç_ÿú×œÑJzVÚƒÕÎ9ç»úá8ŠgOÛÉKÑå·ªVZGX{U•Èr× LëVsu2œÐÓuýi)(Ýfªvñªn`®âºwï½÷tÐAi‚B!„B!„		ñk›m¶¡;ŸuÖY«­¶ÚÃ?ÌKX“Ü›×œ†cæºÖQr±Ü&ÖcÉ%—ÜvÛm?ö±Í3Ï<ï*˜‰ÝIë”:)˜ZZÆÏzœ EGð/~ñ)‹/¾¸ì”ÚŸÑßv›l²‰#6ÓL3ÉVVK“àHó•û\–ç:tba<É	K¾¤³;°–›=’~ÎÚÜjåU(„H‡ætöY<×-mˆªôMS¥o»í6#
æê«¯ÞÆ†‰×Ó­.XÇ³¼ÿíÏÊè0*Sbtµ`k ÙŽmeíwúîw¿«uêUAái‚B!„B!„	Ci^+®¸âæ›o~öÙg‹ðç	'œ@…†+I€Í¶¤œVõ«9=GRx°ÒuenœvÚi¤>·ÅGtaAŽD	p50A*ŽêÞç?ÿù.¸@TqíÌèWŸYd‘2ŸúÔ§N:é$ýí–[nñE$›ëØ¾N«4èIÆäïÿûMÓ§xŽ)ë¹?Þ’ÚDŽZ}¾¶ßJî·ß~Ï<óŒeê3•S;^sÍ5‡z¨0“
À©Ó!çB#UZÊáu$KS¦&—£¹]‚ªumÁ>"ƒ†i©þ*‘Ý+•sÊøŠnàÑÇ)¶™ãB!„B!„i‚‰'HuÕCÓÿ(vá…®¼òÊž¡ŽýË B387û‹zŸüPšQÉ:?úÑxŸ?ýéO/ºè¢iÐñi¬VXxJÿªƒ#/NØ-ì&ãðÃg%å§L;käŒ‹S¯ÌÜ*ä—LL£” ­K3øË_öX_“¶–[…À¶Ð?²ÒƒiyÄíˆÙTå×“šŒÙ™è|ûí·WpÄ£>Z9ÚaLÈ w¾èHVŸl#a%ñ}ôÑ²ƒ¼ZGØÄ‹Z§Màè:Ö»­YÏür-¥Ÿ(S)¶%Ç?„B!„BS?¯Â[SŸka‹-¶`n}ñÅzè!%æN?ýt3ß‰h„›2Ž\¯l+S‚x	¿ô¥/‰d]h¡…Òšã‰òtÜÇÝ<IþÜ$<FT®^æS©SÄáªŽÍB+ãBÕA|_ÇþË€&MY!=‹…©°àªJG¬±–¦Wvsúë6‘ºO!Â%:K(®Dé&LŒñ‰ªÛI‘û¬°§(±<{õÛh£UGÒ$1&ul]U*j£«û;ò÷÷¿ÿ}5´?9Í»ö®Ö\4üPó3j2Á]wÝ%žÞ3â¹çšk®D…B!„B!Œ?MüÚwß}IfJ´_H0<ð ™¬&¶¿§„‡îÊ*J ÷‰»­ŠÖ6>,½ôÒ„Tî]zY	“ÆjxŠ×^{íÎ;ïèd§Œò¾M@Ü`ƒ;ì0#+¥&S«ö`e4óæÿû ¥;3Û6wy^ÙožíyÕÀ }™ j™ÏÚyÔFnœD”n¡êo½õ–ôA4»ï¾{÷tÈy1&6ÜpC¾Q*¨IÆýnôî8A«:Øoy®e*ú³MÐ:Ö4HðôÓOßpÃÂ‚$ÔWÿI„B!„Ba*gâ)SM^™~úéÙ“¿ño¼ýöÛ_þò—ù‰;?ùÉOÊHØª¾'Õ’úó7ó7—^zévÛm÷‰O|"jÎK]Žè?òžœéã#@Wƒr²o¼ñÆ[n¹åtÄöÚk¯Êd`†¥0–jÙý^JÒ£+ÜœYC
Í4ën‚p{µM h~õ«_UŠ°{u€¶eoõÕW¥ì´ÓN+­´’Ží4œx³¦TCUô²DüŠØîÚÿáØV0}µNU#Ô¦elï†D÷dnxÉ6Ük))CËEÌ}î¹çr©WM-!„B!„B£ˆ¦·
…nÿý÷§l~ík_ó(ZE†‹sÈä1™d›ÐCæã(dö´Yõ£;O(6Ûl3qäTþtú~én“Æ-÷@¯^}f
sïËóÍ7ßyçÇeÌÍúüóÏs%—XYNçÖW)Ô|Òp+±èkv½´täæ´µf«ÀÙVh›m=¿¨É¦¬»Þ"³˜Í–u]Í‰'ž8ÿüóÄò<bÖ[o½|PQŸÙÕ©üÕ"†
hý¾FlÉÝ53@Ëâ¨6Ò¦m®@Ó¬[¾JEÊxWÕŸd|vf}îsŸ[sÍ5	ß9ø!„B!„BãBW§Ô4)Åçœs' îÍ7ß”NËH¹£GÜ![vÂÒ†ˆDÔöçí	Ë~ûí§™èn$61¸´³Iæ€æŽ§}“PntšÙíRY‰©Ï*jê½Q$*€i—ºt)’:¹Q–ÿD¤ƒN[ÚJ…îÉs(;m×éÜÊ¶hìnt½ZJ(o5é“l}ÕUW	 Qq×]wÝyç¢>¿D5$FÖ/S¹iå7w„ÉÇ]zÏ\6$På
{Æš3Ýð@E¯¼ñÆRSL1BPC,9!„B!„BxÏ”qµô/ÉÍ£Ž:Š YáBO	7*ýy„e¥²–Ù9÷³Ÿýì¬³Î:01‹(NkÌ0Ã,´¥rÖÑ.émbÐÚTO¸þúëŸzê©#Ž8b™e–)©w´Ÿ¶Kì«ë¯¿þá‡þÊ+¯žKš¤#;V:9%š\&5^R‡ÑšNZbCtCŠâÑÕ=ßM®…J‚6``œÀÎÈ2vÜœtÍ<žób${ì±²éIÏŽg¹þ[¾s•9uxë€w›¦'Â»ÚÅJåÚ7ú/ÿò/K€ÖúßûÞ÷,\wÝu•”
!„B!„BÊ»JãÄé«*ÚŒ3ÎÈªÜ¼]ùì=ô–šüNË>ùä“?ð´‹‘p‚pê©§V»PQ©f“& ºW¢®#¹¸íÌ(lSM¯“fnLE3/?û³Øª.èÐ‰×Pt®ŽI½TH-ÍHÞig/Õ{¨?«Œa;Sšñ¹¼ÒúÜ^ºòÊ+ï¸ãŽGyÄYÆ”ÝNŠtæ‘sÒI'IÆp`U2±ƒß€æ\fcwüü’éÏïnØŽ>lê@÷’Å_ÛÔô
1Ðk¯½v{!„B!„Â{ 	^eFfÀT™íŒ3ÎP+Wa·Ýv“ÔL|)õÐS1¸#,<Øl†¤Ê¥òî»ïÎ1Ÿ€m×ìêªD6mô=Œ›èÜM*¸ë®»“´£¿ŸpÀ[mµÕg>ó™G}”øKkö-ˆŒº·.ÊBKdãð›ßü¦Â„•ëhÕ»üû M›¶NýIÂ®‚„e.ùÒ:4Ð¬[hÉÑG-ABŠqzò8c8Á˜VÏpKw¹þÓu=w›R»NÐjFÝJ€®6bãÞ«q­c¨@ØvÛmã€!„B!„BxtÄb¬±ÆŸÿüçÏ:ë¬W_}•ÖüÌ3ÏŒ-—‚CAD0ºgê›Àºö’K.9ífÑã‘GÉÌ;d.ÄÄ ûA$¹vÚi­µÖ*ïhæ¸ãŽ{â‰'ôgœúüï|‡:,f¡â˜›^=_òš6-{ÁŸ=â~×f[OÒ¯´lPŸoíjËUlÂË.»ìì³Ï¾êª«ŽÂ‚Sûì³QQU+²µKÜ  kÇáó‚ôaFéžî]!àõ.«“ðS6¸ÿþûçž{îÄ…B!„B!ŒnÉ8¢Øí·ßN˜c•Q@}{ùå—_zé¥k¯½¶4¸wè2%÷ŒU€¶À=]ÑmÓM7­JìÆæ;çœsn¾ùæ’hd“@}n_ó“ÞxãºÍj«­6š{8%ã(Ï?ÿüc=Æ×/mƒ¿Õþ+E(DX—ær¥ë®¥]êáôânŒFîÜ¨Ø¥oºé&¢s«UØÔÌz,mùj/»ì²ÁÈu-˜sa|0ò¡)+‚£[E°)ÎÔgMÓ­†ÚHé0ë*tG\0|ë[ßÚd“Mš:t!„B!„ÂØ)z¦™fâMæ€>è ƒˆ,
”GûÃþ@,£¼ÜvÛmf¦·[Y«äÎ±Š••KÀ4}óÍ7ŸpÂ	‹-¶X}âè,R7%2óÌ3_þØÇ>&€˜]éÃÛû\Rl5.xà¥–Zjé¥—µÍZéÏ;ì°Ã9çœCùÕ±e)\pÁºq	ÍFGÐz{«:Ø¢êû¶á1iñ¸"P”°{çwœ>U
Ï–ÉÙ%hz»S©"8Ì*XwÝuÛ‰sa|Xa…ÐÂ1ïÊÊ•»mA#’þ[ó•Ã}LêsÂ±µêUš’÷YÛ	ÿÐ‡>ÔíW9þ!„B!„Bc¤ýìqùå—7™}™e–P@ £Í}÷»ß%C—ôVÕ½,ê†ô™ûL²©Ê]R¤“30‘p`E	Ë ojšfàÒ®›KºÚ½*³5£(W»,‹Å_œ>Jô¸*kÙMéõçG>ò‘{ï½÷ë_ÿúsÏ=WÕÉ‹åGÖ?ýY¥êz´H‡ëg?û™Cê •£¶)Îí,èª–6È
-óÁùâLá½Õ.ÞîÑŸ>…^ÿÐCí»ï¾=g_xOíÛ=në¯¿~M°ÑÜAÓÍ ¯[Ñ(CžÝ·XÇÀÛ¿òàƒBÓqæ™gî±Çq¬‡B!„B!Œ&â”Ž£‘…3ôê«¯~ñÅÉdÄ8jÝI'ôío»[­U]^€&çìp”;’ßšk®™c>Á©ü%Ñ„¥°?ÿÃ kH£n‹C¡¨–Ò:žÙBmçÊ+¯Ül³ÍçGý¹íI[µ|ñÅß¨rsÍ¼_´?9—»‘2íp‘5ùšR¹M†.ñš]+ËyÐ
Mž&7“¡SÔg]Q6B¥è°Š§ëNªqwÜqÇ¿„íjÓSÐryŸ›½Ôg­V>èaâ8jÙj\íº‡kšÎðéOzôg‡B!„B!Œ
šúÌBËòüúë¯SÐˆ,O=õµ…ÜVb%ýe„zeWµ!^ÿö·¿%@ßzë­,°ÀtÓMÛào¸¹æšk—]vÁ¬ºceÔV¨q
G3u’DKtÅnTg ÷½ðÂäWÂnÏ^†ã3Ð	_{íµwÝuW!æ¢ÌuoG ¾…¯ÃÓZ‡Â¬”†ÊÜh=Ù²Ø_'B7\¸½ú›A$èêþ|üñÇýYyDíƒùå ªä‰™VÛ3#1Š0­_Ûé“Í¥Þí·®fFh·Œ*©VJÿ¹Ðš¾6Uó	4±æ3z±×^{å˜‡B!„B!Œf¥>¯ºêªÌ¡$³òVÚF7f¡¿îÜ˜"šš#…€¨GýÔ§>UŸØ-u&RSd>h¸RÓ†l nþKï8Ð%a—SØÇqßyçGqÄÀ»êó(iß¬,gy¡…¾qà²—¿lË4eT_Þäúv¾T¥.tûs%AWZt7Ò¡<Î5Wàï©—XžåXöÕRIO¶h$ d¶Ùf+ól…„¤÷Ž'3Î8£Xùk®¹¦šµ§f`×"BÝ¶SþF×á^#.UsU³~ô£5SäÏÉÁ!„B!„B‚–Š[o–]vYZÎ¾n¸I°I3äãŸÿüçã`­·“ðøÏ;ï¼ä¥N¼vÄüóÏ¿ß~ûQ9EP–‡w¦—$*C€ÕwœÃ7Jé«Mé9ƒ"àh;,MÞµüÕ¯~õÂ/ToÖlˆ¥Šú" ³ÿë·%1÷¤7´âN‡’8+y£DS~go'^{$7ßwß}\Ïo½õ–F)=Z
éy†f(í2¹Ïrð¿øEG¸ÛÕ:Ý!„›s“¡‡°ï.3>3Ñç€‡B!„B!Œˆæ}Þz«®ºŠ^F8#“I$ZÙ–“;VÝ¹g $µ€÷ùþûïßxãsÀ'85~°ê òª†ÞÆÏZ±¤ï¦ÊCGke#£IHíªÏµ¬("Ëª|Œ'žx‚F¯oÿèG?ª€ì–±P¹%ÜÐžq{¢fê@Ñ4^¯–¬YªtWè¬ºvo¿ý6ƒ9©Ú¯»î:0BpˆŸrÊ)/¼ð@tç	4m	õM_&k…ê¥ÚËŸ•òÜÆÕ™=ÓÜÍ#	:o…7Ï}âŸxw&Gš2„B!„BaZJ¯’qsÏ=·h¶>)Ï"è2:1µ”5²ôEÉn$.kí#<BÈ¦úm°Á›l²IŽùÄã“Ÿü$oo%ÛŽD€öÈÆ+k¥Úkê6ïð÷¿ÿ}Ý"\F§·ÞzëÉ}&Ðó8—7¿‚eê‹×3ôh#.”Jò¢þ?dzI"Ùz»š7ÞxCl:oµ7e‹Úà}–öðÐCyüÜç>§è¤ö.é·Õ/íôìòUc	þ4ØpöÙgq©W5–~«¡ñ‹_ô§pŸ)TkJñV‘µ>wÔöùB!„B!„ÉLËÆ~úéO8á„“O>¹‚q+ý–XSÚó )í=	”%ÌÑ²>úh†ÓË/¿¼û‰9ò–Ê>ë¬³ÈýZëVÔÃ0ŽÎ
Í ¿~ï{ß«¨è
pCÂM¼ãŽ;Š¶Xe•U:µþ&;­0ã6Ûl³à‚nµÕV:ùá‡þê«¯ÒˆË¶ÜÍ4]R’µcâ:’C“¶r×[}Þ¡­ÁéüoƒPŸÁ¼ùõ¯íù'Ÿ|Òž°Š·•saÂ¶õ†nèbÕ“Ú\-õ¥/}ižyæÑ¸]Yë8ÁÑmú~üñÇÄþB!„B!„0<M7!Ò±gþÅ_üãg‹Ú :Ssü9òˆ†®ç½”>qÒ|ð:ë¬Óó‰aüÛŽò5Ï RSN;í4G›”ÖZj˜&kÎ6Þ0nÔ˜]ÕÎ(~¨Â¾ýÁ~8¾ÜrË­¸âŠvõñÇá…tõJ•©èçê´”Uxsøú’òë½ÝnËŒÿôhQ6\ÕÆqH¶Y{íµµW³£­[n¹¥ í
Ü¨–%1W.ŠÚ’†ª½ºC-¿»§­[kÖKQkrUëR>.¾øâµÖZ+G>„B!„Ba,lha³Ï>ûa‡fŠ:s·fyc+sƒà¢„ÚH¼Ï]Ch	@ìÏâ_|ñòç†	ÑMÛiÁ-¶Øâî»ï¾÷Þ{µi•âÆÀ[BÛðM¦‰»bë8äoÜsÏ=Bx{íPãùæ›o`ÔŒ1H|^f™eô=¦ãÏ|æ3äB{Ks×·¿üå/+3(œák_ûZ`¬”s¬ÊÖéFB÷]¤Ev¶$æ
€öª—w”í°<ûì³ÜÐšCe<8EÛŸjµtà	{.ÔÂ-·Üb†R¬•¥ T¾sµ¦çÎtmÑõ¼Õ4Ð˜F*GH³jbo×šžt©\h¡…rØC!„B!„ÆN‰˜ò1¡–y¶djÏf©0e«ºG³{ê©§¶ÝvÛE]t “4&lÛyÛÍ´K¦œ
 Ñ”™Ùï\®äñA‹³”*©wÎ9çØ“9çœsT9 —Xb	aGuÔADš7ÄòÚk¯1&ëÛJ68£«Ò`õü‘­£ó“§ûÐ-óº+b:Ôºí²5Ÿâs»U
Uàä¼¦A—jÙÔçœŠ:¤Î…_|±´æj—*³i„ Û‚Í]c	2ÐMõS[[Ð*XpfýêW¿Ò=ŒÜÈÊÏa!„B!„Bo¼±
r$˜þð‡ªYÓhº²rÿõ!ÅšŠìr j@èÁ@‚n'ì3Ì°Ûn»‰3fÚýÆ7¾Á˜IPÓvƒ;Ì˜AU•$›Ž$÷vößÿ=öØãŠ+®h»4zÚz¶Ùf;ñÄ•‰“LB7¼òÊ+¿þõ¯s³£«Ÿ;PŽ “,ùÞq«Þk…*E(‹¦ž¾aýi#>¥ò¶Ûn³}êöK/½äyêçƒ>xÙe—ñ§¯»îºŽt¢¨Ïœ#<²7Ê×_­£éÊ´Üç®m€H]§Ì­¶$ÚÊêÖ\sM)_ùÊW¶ÞzëðB!„B!„¡yß»Ã–]vYVÑo¼ñÅíoVKµéŸ«>Ö’ƒµL}S’nµAú<¡Û®û§ÂzUýïÒK/]l±Åh¬¢¼Ï-S¢§Z3°e‡W`9äc=VtYPGC[W¤L©ó»ì²K¬¸g=S3%šRÌë•Ù™ªèyº³uJ•ÈP_£¼Ò9P{ZÏ:È^µqšþ7¿ùÍJ‘VÏSs(¿©iÎ<óLªéÎéÆ-~É%—´Î©]z’K€.ü8t{mjh·]ûØÇ>¶é¦›æ˜‡B!„B!MIÏƒ’ÂqLšB¤PÜˆ,ÿû]º)·# [áABö©§žš”Û‰Dk»é¦›îÐC}øá‡ÕCcC¾æškªÕZšD Ý±ÊâµÀîq ›”÷YA¶Ûo¿}”èª)³òÊ+×Ÿ¬ÇÞ~ûíRä®Ô÷õõK¦o}›¹bZgî–Ól³Â+p£•.][þ	-ÛKu]wÝuvÆ$ É_øÂf™e–îN¦Op6ÙdÃÝ0ú:zŠ
–0ý^û¼fµq}ÆõMžx÷L!„B!„B½” =ãŒ3n·ÝvŠ–ç±¼Ÿ=Ù®µyxQ²
²—žþùÒ¦Ÿ~úm©ùêÀ.¹ä’O?ý4õàƒP™Ã·Z½ÄÞ^&GØ¸ý)öÎ;ï\ýõÏ>ûlåGO[ÛiÔ§vš¢¼áŽÌc=Ö¯›tþŸ*+ƒñ¿+V¶`è~9­™¦\Ç°Îâµ
u¤ço}ë[†s˜ _~ùeá6\ØLÐN‡œ£‡~¸ šn¯îÏtÖîâ8š±}ä3 jŒÁ‚fuÞµž–#B!„B!„0FT”WK/+Ûr%t37š:3B™†¯ö¦›n’x»ÑF$âvâ`ä@]Ç÷ÂøüÊ+¯pøþýßÿ½`®Q·_}ëFFô7ñ{RŸ›‰øÂ/¬½"ÿ7¨þ&|ÃÂöÛoo4E¦ù/ùËk¯½–ìH=¤¿óÎ;•|]bbW©,#s«·Ù5þ·åúâÖ±eŽé2ÒÖ:R¤IØ?þñE‹{–ÕpõÕW—{5ÖP/]wbsÕUWÕÂ˜®ZšO  7£tÿ,±íÔsäºtæ‘„B!„B!„ÿC7VÀŠ+®H}¦—ýìg?+M­«µ\‹ôFöOñÂh ÒL„ï~b˜àí¨º#÷ºJhü¶µJ2âyL…"Çþ°6ê•VZ©§ƒMÆÃR;°ÀxÜpÃo¼ñÆ‹.ºH1LáÎ1ž}öYAÕwÝuWuø28ûR~ÛJnö«¾þcú»7:þ•µ]'‚†t{¢ª§‚‡™0	½T`|E8»ñ)ýmWÐúÃw¿ûÝfF€n+HVq}3Àfè‚Éz™e–‰ôB!„B!„ÐK)5%‡­ºêªwß}w•bcyÎÆ˜PÀpçw|àFs´'*ûí·ŸÂƒl¶¿øÅ/„	p¯ÓÅFîå7ºåQüó l×ê°ªî]øÀvß}w½qÿý÷ß{ï½åS—Y[ð‘þØ¢ŸK¬$Dþñì?&c kÙ»ªh¡mþ÷Aè’LÐÎ)’mvÝuW»‘¾:É]
¹&v.T^s×ÛÞÐ‡?x•	ú;ßùÎHÆÛêÕ×_]¾Šeí»Å[äÈ‡B!„B!AsÎ4ÓL«¯¾:{¦Ü†æèljË¿2BR
Á< ÂÛo~ó¡³Í6g®4†í‰×ˆóÍ7]õÜsÏ}æ™g¾ò•¯?ø÷AFž§1>…-ðßô>Í=:‘dÞg•âöÜsO±¥8Äÿ1ˆ#&®dÙôèþ‚ý
fá-hZ¶Xp@lÖÙdƒ¿ýío%~ƒYl±Å2	`’4·ÇM7Ý”îï:¦j8¡QK–¬gŒè·Ï=÷œuŒ´‘•aÒÒK¶6âR±-6( :áB!„B!„BCPsÆ©Ã«¬²
4OŸ ÎÐÊ"è7=z¬U¹lD:VSbŸ\>DÛ43Q¡µÉ9yñÅ©À„Ô²ô–åsäå"Ç­ð í3\ºØwß}7Ø`ƒÊ¡=G¦:ÞRK-%ãÉ'Ÿ¤H>üðÃêaŒ­”}Û2Ušd|Ë-·4urÈcÒ£;·`Û)¸­q@¿ðÂ”M‚æ‘GùÐCÝqÇë­·^Ãd0fÒ ê©u5cÌ¿þúë-T:A˜Ó[ó±ÃëRS¬ÜëþLÑÊ"†œbšøˆ#Ž4\'‚#„B!„BáÿP*IÓJè&ûì³«2Õ˜.Sµ‡F‰kR5]æ›ßü¦Œ]†ÜÒ"#·MTJ`]sÍ5Ÿzê©·Þz‹Ù–‘“ ª+}¸y9»-5¦<èqs@“áäçÞsÏ=<òˆî4Zžæ˜c¾ÔZ&@Û7Þç£Ž:Jn¯b€äHù	5C¯g’}â‰'ÈèVhUëèc¯Üçv8Ž¿g,ø&hz´’ŒÇsŒ€àž&õúß•‹RY(†Iš ]—¸j\¯VñÉž„±Õhkã=î=öØüóÏŸ#B!„B!„ðiºJ­[c5Ä4rÈ!?øÁ¨r%Í4'àX…˜®´‚V/¹äiñN‚vlMIZ}å•W¸8K€¦¨ÒÝÐU
¯[~­Ú´†;þ´OÑm|ºŒí>º÷ŸrôÑG¯¶ÚjýèG7Ûl3Åè$üÊk”Žà…ï}ï{–IôÊþð‡Œääûv¬*t$û3*'º=ãUÁÊIÛóÍ7¥:pÈ2Aïµ×^J æ\˜dÔ¡6¥ÃÁ×4Z¡’š+1£¬îÎ‘1™ÙG>WÀÕ’žœíÊ)e(G>„B!„BáÿRÍôÓOO;ï¼óèÅ|°t‚¯}ík4š&¯üË #”c¼‘ôIña3Á±ôÒKÄé9IÚqæ™gžk®¹:è î]–[	*Ðr@W¸DÏ@B“ØÆ³Âd7*WféVµN5yÛ½>ºL÷â_=ôÐÝvÛY8Éÿ6Hwì„4ÉûìXQ“[ÈÌ¯~õ«(QÇ°ÿp•ìîÑÑ¶¾Íêù6e;2è’*pòY?ýôÓ+¬°Â;&j7pq«ž¯Q´r]ÊÌÐ£[åÌîŽ‘GÐôHÕ~ÌÉ1!„B!„Bø”þEµ$É½ôÒKwÝu—áo¼‘:ÓUdjtÌáãž­IÙ¡{àî¼óÎãŽ;îšA¸ª"´Müv¤AkGÕíN9åAÃ4hQôÐj;MSâ)Ë§Ê„|šÕp•Î1¡"8*å€äzõÕW×ŽM^·oõ:µõêu×]— ýýï¥•VÔk?¹V±Û¾~…A7×?õ™­Õ7j+”Ö<äw—|b	Þ§p@;~üã;•lá_ø)¼Ù±Þ5­§ëNl>ò‘Üzë­e|VR’è\íU‘)²ž#ÝFy­ÎniJ]èË_þò9çœ£wå˜‡B!„B!ü?JÛ|óÍ	4T3bÙOúSI¦#›´BryŸI{„ìG}”
¹õÖ[Ov'ì4ÒŽÅ¼óÎ»à‚ÊÝ¾øâ‹‰¡š’ÊøIl%43§{†<-€¢QèÃreW2ÁºëëlÛóg·h÷¦bsû>ðÀo¼ñ(Éß˜{î¹<ðÀ“N:I†Drñ±Çë+·ýw(^~ùån˜FËz¶ –£T_*M^w<KÊo2%IšNí-øÃÈÙäf™ÐÿÂ Ž¶³`ÖYgM/,}`±Å»ÿþû9ÐIÏú¿¡ëtÖo=¯±*Œ¥\üýžèþÌž\?ÙÛÏ8ãŒ}èC9ì!„B!„Bÿ—Rè<~üãç€¦Î°¶ò\# Io%\6’‚Câ¡xÒbZh¡Ž6š>ñèÜƒ”‰uÖY‡-æX³²yÚø E3‹X9ì°ÃÔ™äÉÕd<¡å µðÏƒXyÈò’­}Kq#¹ÚšÍÊS¦tK\¡ñQrÙ«wÝu×w‡&{‡Dìë¯¿^6‚¯O f÷Å	Ä¾N%•{þ—¿ü¥/E8®g˜—-××ÿÌg>ÃËßJq¶ï‹×ÑðŒeÂ}åÁH°!v“¶Å¡ð¤§Núv¯Gº?4¿?+ºý%U«Ýuþ
ûî ›ç½ÆWÚó5ØV¡êõŒ‘†9çœsžyæ™¼…7C!„B!„F´’UW]õ«_ýê_þå_rVþÀ§Ÿe¤3„–4C¶ûÑ~DÍ!ÍÜvÛmë¯¿þ@ŒÏ“›k¯½–%Y8€tï·Þzë‰'žÓQ/‰¤`VmO•<vuF]5÷.»ì2µøˆ§š’¾Ìð«KQhÅú
",WÜŠeöÒ»ï¾›ôÕW_úÁh¼ÜrËüióäÂ—¥8/¹ä’DgÝ›—ÙWcR®[Ng_°ÄG¶è
å0|R*3sºÅë½Ö©r‹lùµ×^#bÖ«žq<}Ö;ìÐÎ²œ“òšÖŽöÂ/ltÍ)Pÿ>H×¼ü?iià^¥VkÁî5PËVñÉî“.t•ST+¬µÖZ>TÏoçW!„B!„Bø?,°ÀbšI0l›¼ÏM‰ ]\‹Äæ Œá/~ñÒÛ¾ûî+yƒøXbÐûÉÑžxto÷€]XsÍ5ÅÌ1ÇK-µ”Fi¶wI‹,²ˆ€‚7ÜÐš-1cºé¦Û`ƒÈÓÛl³Í™gžyå•WÞpÃRtéËU[’P+ëöª«®¢_sOÓ¦	Ü\ÆÖÙl³Í*qeô°÷Þ{Û·o}ë[bÞ~ûí’˜›ÚX²2yÑ!L³B¿ÐÖìz`išTH$_’ Ä8˜¬yÃmŠ÷|•UV©¦IÿŸ”´þ¿âŠ+.¿üòziät±ÒRMJ®Æ5lfìMóµöÕ*ï¾­cZ@ÙÛ»³tû²KÃœ/>ÚP‡Ó'MB!„B!„ðÿ|©µŒ±|-ÛtxÝ¹E ·4†hH“´l†SÓÞg˜a†äÉE	pvƒóÏ??K;}™¨ºÌ2ËV–x;Ë,³l»í¶2.´øÊ+¯¼ì²Ëö¿qÒ÷Ù}Ægôä}÷ÝG…¼ãŽ;ˆÂ¥&š	‘-ZÁ‚˜¸õäþJt^­àà®6­ó3Àvl¨Ï„N	$çž{®
Ç|´ÈÉBu~@·<äCØ™«Ò Æm£eÝTª´ªé»áæíJh¡+I×jºDÓ¬½¤wåÈ‡B!„B!ü_¨rôD›nº)ñƒü òƒ#Ï}îª0T<æAò+(ú¨£ŽZ{íµs„'/“1ða²ç}7Ç½!–wÜ‘‰{¿ýö#7ÓŽˆ«®nLkæS&"ëºý·û·%F{dnmQUZ»¿tÆn1Ft™©AŽ´ïÿ¥—^*Õ„X_Úw˜ô ìÏým´‘PrÍW•Q[mÉ¦÷¨Ì…f­žÐ½èuG&ºE8q4'Ÿ|r~!„B!„Âÿ…6G;æ˜cÄþJ&ÌUÂÀè–‡[Üž|òÉšäNâ9ôÐC¹{
â…©‰n…·–æÑúUÓ'ïîø¸Ë.»ðãßtÓM¤a=\þ†ˆêÊ))™ªXi¿]W¬ ë7k¿‘rd³»võÊªØÙdhÉ$¤gÅè@;SMr"L.”Ù4Þ ùªÝUÈkÞ½Êµ$–îõÍ“¢Z´lÿDk|YàIÏ×]wtõÍ7ß<Ç<„B!„Báÿ!0AæiFµ*¥5ÂÜgü÷AZÂ{î¹G"ðç?ÿùÃ;¬r„›èõmr11Ž|m³ÅwÃ.ú¨'×÷ÑóÎ;ïÀ`ùÁOúÓ»í¶›êpâ~üãS	Ê†I4Wzû3Û~ÕTìŽ©|ûÛß.l*lnèZ F—„íí/¾ø¢Ó‡Ç–Ó–Í– M†^b‰%’{>y;¿#/…:¬eµZc)EXÐMPÖÊ­ü`wbG¿Ç¹ë’®—*¸C„´Pš-¶ØB˜~Ž|!„B!„¦iÊ©ZŠ˜€fÞ@1µeÞì&ŸöÛýúUBG¡’kô~æ3Ÿ!óUé¹ÉžÀ&ÃŒ+ô<3;€!}öÙG¹E%ï½÷ÞoBg|î¹çªÀ åæo}àÄC%«'—¼HX4¾RFéžÒsõ.=ßÖˆ6õ»ßýNš‡òŒÇwÜE]äœ:ýôÓ»&ñ0Y®u³Í6Ûe—]VÁÍÕâ’‚ˆÅÕôƒg'ú/€c²?w—]9]	-|ç;ß™}öÙsØC!„B!„þom.éÏbjYAß|óMô˜Tæ1¢+#UÈ 5k¡Yí'tÒA´Ækä‡ÉH|_|ñ<ððÃ?ï¼óÈ‹²žå;SéÍÎ\
W\qÅK/½D ”ÞÎº7qÙ2§³—þóO±šˆÚdh+¿þúëçŸ¾ñ˜§Ÿ~úúë¯?ñÄflûôäbÉ%—<õÔS"”R,h¥ë¬«á;ï¼óµ¯}ÍD=#Pe„IDF)¸ª¯½öZ¶Ñ‹~ô£9æ!„B!„B˜ÖiZØ{ìA‘!µ°y£¶ô¸>»ç¾øÅ/’á¾ò•¯ì¹çž6xðÁo¼ñÆ“µü]˜Æ©Ž·ì²ËÞ~ûí7ß|ó¹çž»îºëê™lª¥6Vä‚ü’•IÒäé|3šºuu+V©®>¤š}ë­·ÖéC€öq$HYò¦å0Dtžì¸Ýyç¿øÅ/ÈÄ.S|ÐÛÔðƒqê­€d­°H²¯DŽ±bMƒÆêãZh¡\÷B!„B!„0­Ót11µUrM˜“ºL =Eº”h{æ™g¼ý†nà}^xá…ç™gÑ‘ÞÂdg÷Ýw¿øâ‹/¸àÖÔvØG•š\)çNtxý¹JÒ‘iˆ¯¼òŠh`êš9š]Z/C4Q²âž»h±Ñœ³õ¼GYÃë²ÕV[$yc E¤Ûs=k -.þÛ€ÄÃ?\‰
Êf1ÌÐcˆþõ¯Ýs­†¿üË¿äy¿ÿþû}œü7Ü0íB!„B!„iŠðŸýÙŸ5]˜9ôÈ#$ÃP8 éhÝ’\C
Ð™RâšWÚÛŸzê)îBÒ4oÆgÌ¡“ý¼vÚi§í¶ÛN´”ó«¯¾šCù7¿ùMu`Šd©Æ†U^{í5§€ç²¾¶hàbññ2þ$R;ºVYØ2}ÓÛÙl¯¼òJ§ÃlPå7Ãä½ÖÕò&›lBevqóh¤á«_ýêC=TuS54»zEsðDkÇ
f©gÆCÔ?Dç]‚Œdßû8¡+ê¯N7Ýti…B!„B!Ls0åuh¡¨¬Ô7"!¦ ‡ K•óbÍÿä¯þê¯˜FúÓŸR÷¸>·Øb‹¸>Ã(@?§î²Ë.Ÿüä'Y\kø¤ÒœÛðIóþ“#ë°Î¿RÏ×Ê59 ´ézÓ´³ åÿÒ²IØ‹-¶Øc=f#²¤cÿŸì×:,·ÜrÛo¿½æxùå—…lH(«»¶«K™+UZkjG#p?üáË(­‰­Yãc¥º“õwÜqGDÆ*ï;—ÁB!„B!Ls”&RÒ¥˜ÚR’\Í4SÄs7º4;^B’úë_ÿ:ïó#<rúé§ËØå6]sÍ5£¼„ÉK´Ì:ë¬üø;ï¼³Øc$ ¡<`ÉÊ…±lÈÜÝt!1—r-¯FØBeþ*6Hk¦Wþüç?Wº¾Éûl$æœsÎiÞÛ0û Œ=<þøãÊ¢>ñÄ¿úÕ¯ÔŸ¬B©._UvÒ£Õâ5®VÞv¯¦…r”0=BZ²‡¬….c~!„B!„Â´K	sößÏK\#»´èç1©Ïý&èz†MváúT}ë€?°ä’KÆû&;:áG?úÑ™gžy›m¶aóo*!Iñ_)×?í˜¸\6ç–éìŒ`ˆîövOrúÓšuøz¯–:5ùòÉ'Ÿ”)üê«¯¾ðÂj¦33Ù/tçŸ~ccR†$€?ÿüó†´,Z}HÍ×Œðÿ0H3”«Ý¸B•”ì¿R¨û+µVžøzë­÷‘|då•Wv~úéÓ
!„B!„B˜†(9¦yŸ7Úh#ª1‹_©0Ã‹ÎCR‚u¹©{JopÂ	¶ü¡}hà]ïaûämîi’}ëë¯¾úêÁ7Þøàƒ–ìÜ’4@g¬¬s¢!Wl	ˆõRéÔUƒÎKÕÃ›­DaÅÔÔóòÌ!°qò¥M½ùæ›°>z¦™fÊÌh`ÑE•é,CH·é÷Ýwš²üío›ÝÍµ7,Q•qßúÜþl©,ÝUÝFgÛrË-+z Så5„B!„Ba*§ô¸¦†,¿üòäi§ìœMY{¯4½†„ýÎ;ïlX>YA÷Úk/Þç¤?‚æžf› }÷•VZÉ ˆJ€Œù²8ô››•R,o¡tCÝø×¿þu7ç·	Ž„HúrW’¶`Ì†x]+èùÍo~ó›?ùÉOlÁf¥sœrÊ)Ý“.LFä`(²êê$šY@ŠÁÃ—\r	é¹dèÊßè‰22QcCŽÌu×láõ’ é¹çž{Ž9æà»ï&…B!„B!L49LFó=÷ÜÃªI2ëÆ¼WšúöÆoÐ åxHóP{Ü3ß|óåP’†ž–Yc5(ÎFY$ÿ
^0Ð¢£–gYª/Y¹Dd*¤B$Í‘ß¹²œBœ+ƒNmM"u)•µ…‚FiýŠn°&šM}®S Êãh`­µÖ:í´Ó4½Fÿâ¿( ÅhDÐbëkŒ¡çÒWu&«¡õRu«3Ù¯D×jßýîwõ1+¾ás_|qùÉ`	!„B!„Â4DÉab$“òlÖ4sÊZÓ »ÊÚ©ŒÓÛ_{íµÍ6ÛlÞyç­Oyß»ä°O4qþ™gžyÛm·‰~~è¡‡HMCÔçiÊ?øÁ(’Ú+¾¹Æ`H„é’ U)l59å6p¶Ö M…ÿÖ²u(Îò£ÀÐ iÜ<¶ûûþAÒ';\ðDg-¨M…>W¸ ÑÿÛûoÍ¼\.†ž¬+ae‚Ã0ƒQŠ1]ë*¯
˜ÖIä€/³Ì2>w‰%–<î4L)ÂB!„Baš eOËG€F—\a…„á ÕRk
òU¶†K†óÆ’rLo?ûì³uÏªmõs4tøi‡®ÏT4Ê¢ŸxàE¤ñr7SuTÝ•ÄLfv¦›P}¸U&¤8{©–i‘%AÖr•§ÓíKÈ¶Ž÷V€ƒ—¾õ­oQŸe
ŸuÖY3Î8c®9£¡?L7ÝtsÍ5—?_~ùåÊÓ`u7fPõ¬ñ®'ßY›Jê(«{ÌµîÑFZò†•+CÜ3:À_rÇwvØaÓòÉB!„B!L£$ˆ³ù‘	äñüÃþÀ³YUÔÞkøF­O›£éPah:×^{íÚk¯MîIO“…æ»Ìü}öÙé€jJá8ãŒ3¤?SK_&@ßxã¿üå/‰:?g+áØ‚„z´Ç–õ\Nç\°KóM7'õsÏ=GÚV¥P^‡y Fb/¤9FÉåN
ó½÷Þk(B(J5¢ÆrÕ2övçw–©yÈKß0¹ÏÝ h
µiKÃWˆ’$­;Ýu×]³Ì2KZ!„B!„B˜æˆÕØž~úéÿì0V¡¹»Z%u4»´ôç8`‡vØj«­Ì:Ÿa†¦íÚwa²Ÿãƒ‘\ÏW^yåÖ[oMg$ÊßPl“s™¹UýÀÊÙ(+ôoûÛJ¦A_îæ*´âœÍýJslc6–iÖÜµ_|±ò›óÌ3Oe/Ô$€0Ù¯öÆ!žyæ#d:@YÝ5}¹•o¸á†îe­ÿºW>Ìõ°-µu-#b ¿óï\sÍ5m´‘¯i…B!„Ba‚T“â§qÌFW ‹|F8ã¤›ŒU†î‰æ¨••ð"=òvß}÷þO‰ú&=­×­¶Új‡zèQGÅõü¥/}iß}÷U}N×¥—+ñ¼…-èÞ¤çÿdH±i‘¥]š4à‘Š-x¡4kTÌ“Ú¸é¦›Öd”k”ô—}x>ªq=j2ãÌïÂ7sõÆÝ/OÓ_xá…G}”Ûúõ×_'müñë¬³NZ!„B!„B˜:E‡îcùguVÂë1ÇóÈ#|æ3Ÿi+wCc†òíV±÷u˜BKSÄÔdûÙÏ~&. ‚›+”`H‰yLBLåPôÔï¢ß‘rvÚi§Ùf›ú×g˜¼ç¾ìfü[n¹…úLüêW¿j˜ä±ÇS€®„f½—vL2–¡QNXËegnçŠÝhtO
¢33µÐgÛ¬s_ÿú×Ï?ÿ|žë4ÁhCÀùçŸÿÔSOm)zÇ:Ã»¼”2D·æn}`L—Áþ+a9èmœ­³é×]wÝ­·Þ*aüÂ/ô»“&!„B!„¦r*xÁ” kÂ5Í”ÿ‘lº÷Þ{KçlšlS™Ò]•¹+@O¹Ç¡öÑE]e•UÔdãÖ¤£µ"Zï5ý¹Õj³è'Ÿ|RÖÁƒÄø&/r~Õ ¼ùæ›™^µ\tÑE<þ]³s)†þ”Ò+*Á#5™:Ù<­ýÞgëWTtý)ç×[œDfˆö¼I ë¯¿þB-”ã?ªp1ßu×]—]vY×ð/ùË•Ñ,šùÓŸþôã?n¢]ÐBT¯òbØB¢ûèºB=C&èJg^d‘E„ÅB!„B!LýL?ýô«¯¾:s"·£€N‘¯?ùÉOh&àÿà?ØgŸ}æœsÎ&uÅÓ¥—^š€e"÷ùuuŠ[e4?4ù¬Gj¡ ÝV£Ó9†×_½zk§
|í·ß~IÞ“ê{ûï¿ÿÉ'Ÿì¤ÞqÇ)Ñ_ùÊWd:=+\XÝXfd®Îìybt¹¤].Ê[ò¢º‚„ft.#º½âu?ü°Ðgy¼®µGOg€±m·Ýv`0’E3•ÛÝ‚_ßýîwç](x¢{âž»×=+H‘Ö7z^2GÚæ…g´é¥—þüÏÿüì³Ï>ì°Ãêg%ý!„B!„B˜ú!¹5oš\Nê 9I„+	‰ À·Ç{«Ô#¡®±ÆŸÿüç=öØ]vÙ…ÀD¡éIÆ²²VûÀ>0%BŒðkÂÜ¾ðß‹JBMë7{ö8þ†Ôbº«9˜BN>úèÁyî¢Rx0L^Ìu`ðçGþÄ'>ñ‘|Duš+<Hz.‰ÙB&x4Cs|î¹ç<OFGã¼Ðí½*š£ú¿ïUQé%RÄª7R½Q”°vWE:?a”àº½Í6Û†4K£{ùªàû²Ãknª´™1?úÑ,9W«Ãè Zøeñ.DeW?õÑ~,ÒB!„B!„ÑNË\®7ó…ÑË´˜ÉÙð(ÿü40h^&+3¾1¦™‰¿ÄKtÐAßÿþ÷	Låa$HÝwß}–ÉL”
/&4o·ÝvÏ<óŒ€Žûï¿ŸÁ(G­>üðÃÙÙØ¥ñ‹_”Ø
Ÿ508¿»íjwŸGÏlÂ7$ø
f;ÝÉæCN9ÒÝê°‚Úi§}tè,aruïwM¦.³Ï>»‘¤#<RàïW\±É&›Ðuõ×^{íùçŸ¯ çz©(jr9XË	ë¼hÎh‰„Ånö‚gD7ÈÜ¨ˆ«×3}SÊ‡‹ÌÐ½ „ÉÛ1Œ‡r«Ž±æškp½jÁAÚÔÀƒ KÔ3ú€c‰ËzE+PÙ“õÜ½fvŸ”þ\à¦Ú|ðÁF&j:HOšS!„B!„FˆÐóXtg4S6Úh£u×]wƒ6—A)6#Þóä'Ñ®‚&H	ÊLÍ1ÇÛo¿=u É•ý*šâPö7*éêÅ_4aŸ*Íá¨Fû¤5Ÿ}öY‚Â[o½Eœ¢gÝ~ûí'tuÃ<k+pL_uÕUË,³Œ¤QIµ·=…'û‘\l±ÅB	ÐUx°$˜‘Çn47tS^T¼òÊ+mSáAîBé±aRR×6.EpÜzë­?ùÉOJZïûòË/;ñ›_ûÚ×‹™ ‰èmj2Á‘Ýz¸¹5%‚ÖÊ%PJá0U¢´iýßŸ¶f\Špi:…ò†ÇwÜwÜ±×^{µ-y£¤oh‹å–[Îü?
´àË/¿Üu[+kÇDë»žWEÊ
€6¢Pt]îú«Ö5°Â:Z!Ö*hižÍÊ+¯lBÉAãRÈÉÐÝ²B!„B!Œ^¡ÝÃ[&ôy…cx†âLizê©§xœÏ:ë¬K.¹„Ãñ–[n¡œ~úéæàÓÌ†.ù€#r§vª¹ÕÍühîüøÃ¦.Ý{ï½b:¼Db¶‚5}¹Ö7óÚ“¥Sxô)ŠK®ü’dõÇx®Îî¼óÎsÍ5×è9€Uƒ‘6W¡Ï ³88v~„ê³ƒã˜4Í¥T=M_‰­(,a`@ˆî|â‰'Ò /¸àÃKú*Ï2qPW×u{9Î-`Ám0¦ŒÌþtvHQ(	²¼±:¼g¬S²£í‹²)ñ5„ìŸrÈ!‡|šo¾ùúÇÉÂdDCÓ:,ð	.sÌ1Üë´\ÏúCe°tSVþc±ÆßwíÏ-
ßŒ™7ß|SÇ0Rû°öÚkWKzE!„B!„0Ú¡+UªÆæ›o.¼XÖ*yˆ%ù²Ë.«Z‚„`Êù€£Mø&!‰‹™a™”À½Hh <ðÀVkrCùÚJ“ª'ýiã&×ûÓ¦ÊW³°K›°YÊE)\Õ>š_²ÊR•*ýÈ#ÜtÓM¦ð³I*l8JŽíããÿøJ+­$—d\–½š`>¦ä1iÐMm!ÉISõ5	Ð¥nDz“©{{4¿Úha¦™fúØÇ>Fp¤?ñÄâ¦VáÁò«ÖŸlÎú°E˜¼Ó^0Ðâ¢QC/u¡_ëüÎ#:¦«•M)?ð§“r.Œ–\rÉÍ6ÛŒY—0féâ,‚IRŠMiG¥¯4›³Ÿî¥e ý:´Ž¤Ñ»ÉøÖ)ÍZùÒ—¾dsþùç÷é#ý
Œ¶©0!„B!„ÂÔ@7²¹TajyÍÝçÞ­ÖU¯¶-Ð*ÍÙòÂ/¬èŸ¢³¬UŠÒ7¿ùMÞÆš%Ík¦~ôõ¯þËÌHæMæ‰6¿ÊLÄ…zWëwuØR©Ú¤ìzÆ{=–c®•ì+¯\ÓdkËv‰2.lTÅdL‚î¦Q;’f‚sˆqÄ„³ÚÛnúóðv¿ælßšàBÇa-\gu4ß,³ÌBûKì@˜\ý\è³*óÔ Ôzë­g2„w<ÖÜúy;yK^ô§3èL†vÑ (WBt­ãUNÆ“<éÑ•„œ-ÄÃj®3F¶îÄ'ºdDttJTCÖ¯Q¼}îsŸ3H œçÝ5PK_ùñLJnÍÝ_aÕE²ªV‰l.én:GŒ¬KË×_½ëaýÆ™ ³ì²Ë¶”˜´N!„B!„0aèJÌí™®ôÜÍÓhå¡
j¦Ûu1Ê´câ‘W?üá3”Ñ‘o½õV¹ìÆj2)ó8ÓF¤ù¬Žr6üqá$ƒÁçw»b¿É—ŽÜ|ÍCÎ­îyé÷ƒt×éâzŠòÙ1	Ñ"b…Nö¶¨‚ˆÊŠ`³ûÜõâ;‰¿Ù¥K¾§ãì¿ÿþ$žúˆT]“±“»Œ¬¸âŠRwT3RÅâÊžïš ÏË€î	Lh´,ø?D¶†3·U(õ’žo"…Ò…$KÞ%å³Ÿý¬pêóßýÝßùIñ|µ™0zh?1Æ$¾ð…/Èæö§6­­l¢3é¹åÕŒ–a®‡ÝñÅžŸ‰îŒº*2Åû ¿P=?mé!„B!„Â¦«EZ®yñÝ;p“i—_|±iÑ"›÷ÜsÏUW]•F ¢uàÒK/5?šÍyË-·\j©¥¸‰ÉÊJÿ‘‡è>ž—ÂÌ~ûóŸÿœTD‰¶·ýf=“¨H¥±–xD0â˜– ÛÜ¾¥ ”Éq$þßZÇçÚøÿ7H¿K®éÑ>ºV¨tQ»=zÚbî¹ç®h‘fíì~—ác7|v-Ðý™@…Þ2¶w-ÞQXÂ¤§ì.½ôÒ.LÊÎVU)Ôõ¤??¡	ˆñlY6y¢NÙˆ·×•Ä£ëŒ>oSª•Šã0ÐåÂâ%b·1³tþQØ,¬¾úê~Päo°?«ByõÕW««<  &M¬õµ©q=Ö¹áµé6úh¨Cò†ÏÒ=ì@Íû™Œ“`B!„B!„©íž¿g™ù×|gÊ²
îÿ×XcÊÄ4M^¼wÞy‡ˆÃ›¼ÝvÛŽYkÅhx²²2ˆjLˆŒÏtQ‰¡Œ M	¢U‚ù˜í‘Z¶ò²q)6º¥mÔäèþIÖCŠýë4¶M»®gì	¤gÈå–= |ºÝ(u[mÃúÖ“«QÊ‚§â¡‡ÊÊ¼I©¹ñ¹_°«ègRŽr^FˆÚïzÞ¢Á…É„y’7Yd‘ýöÛïÑGeL®sßY¯»V€FW€î&ùÖX”©Vkq:õ^g´çÛéoS„E×y¢„ÍÒ nvw#9¿£äÇ¨ZAµ€SN9eÎ9ç”‰aÀrß}÷Õ1´š‘Kª5ÉÓ~t†œòÒéò²ÙìÏzŽß¿S>÷Ÿø„OóÁ~»]Ó7B!„B!„±Ü!·Xçî3ƒí<óÌ#¦y¡…ª?wØaZ'QXy.J¥
xÖ_wÝu©Énûß|óM4š…W_}µ&D”é;’+ê~Þ3ž§/õ«_%4Ñ¹;š~ôïƒô“›%­Y}û£6†7µc|kï%:Ûû@h.ù›¥ŽûR51‚€NaoÉÉÒ ƒÆg)¤4ÞpG»ô¸F?·9æme_Ó”viýèG),å<Í¹3M]zÚ8G{RÞ‹`„î“¶Ÿô˜îWYeöçÃ;ÌuF%RS+¾óï´n¬ÃÓ£›ºéÎÕ½=_W•îù^WJäh™35šeìî»ï~ì±ÇvÚi§!/ŒaòRÃ »ï¾»ÔûÃ?üÚk¯5ðf2Êi§öÅ/~ÑÈã”¦ÎhJYÞÃ_ç»×Éþ?«GéÄ÷»ß©7èCzè¡óÏ?_ŸÈ˜\!„B!„Ð¥_$êÏUpc/Lƒæ(kuÞyç]`>ó™Ï(½åÏãŽ;nÃ7tc¿üòË×7»™YídŠ3Ç™;ñ¬ž!ÎÊÐp».Xƒ M¨õ$ã3³³eÓÛMrïÞÞ[G’†w•úC í¹ù¯‚U¨Ä€ÜS1¯›Î<¡(+tm–²Ô.OV&5×$Ãèj†;ÓÀ'c›ò>KA­Ò²A* {¬ês}£®WIx U}±ÅS_«è×š¦®=Š¹Ûìöçž{®°—Ûo¿Ý3%C÷„¿OpÖZk-Š°R¥†µÖ_}ç]ehÔ¹o¡EîÔEÃ%ÅpQ»D8gË1=ä8“7LªÑ2W'R&…ñØcˆ¼8Záˆç…×Ô ¸òÊ+-oµÕV¤g#&Üø­Q R#2,— =Ì\CÑÆT«P*”>oðC‹_ˆM÷!„B!„þ„’‡š•¯©ER,Kd´àO²O™T•¸¯ò4Ür3”ñ;s2Æžzê©ÖQû‹îCn>çœs”°ãn¦Ì–ôã¾]¢O%WðAÓ©©<,Ï#/5Ûò¿Ò52)+[§•“ª©ôï5kbä‘mJõ.1ËA(…B(Ní2&;j26«
KÌK}«cØìác_*	·Ö·©"¿[â‘%öÏi„þ¡©ž…?:ê¨½÷Þû˜cŽ1¥ÃÈÛÝyçR´+ÌÄÛ%Á¾:ùwÞIXôçç>÷9½”&Xe3+¾TæfdniqîbÕéîÉš`Q2œê êù»îº«¯é¼Nôù¨í«,ÏG}´Ñ³m¤pš¯„5^=I?7B„Ìä¨AÐ‘ÐUZÖ•pÈ€&ã£o¢×	;:á„ÞµÆgŽH!„B!„ðÿpŸ,­¸?Ã”î¼öÚkµ¯±ÄK˜Ñ,b‚ý©O}Ê·›yF3s™ÝÌó”±ý>óÌ3DdÏ—|CÇUáîÝŸDî°w‡«üYÓäåò›ðþÿuèÉÙl3è{fCÿgõäàÿš8´ÏmJ7m‚ôÆ†Iz>òÈ#iaŽÃñÇ_ÂýdA)¼ÉÍ«˜tã5ÆTx°ÖaK7xP_V“QÕ9@O:é¤¦­D€žvh	¥&Ó—=’b÷Úk/]Ý ŒKÁE]ÄaJæ»üòË<­2ˆy¼ŸÔ>Ø²Iñ”D^W'6ú¥Çâª!YçoqÏõŒ?KOl#Iý§€\—*˜Þ
.b'žx"S­\ûžcFÆÆn¼ñFƒF#®»î:ÝÀà„è!!øìÏâ’üÜüä'?ñÕ²žFâ€îŽL´Ÿ¤Zð{wÛm·QºL»6JOùÁB!„BS0ý7´í.·&¹·<„fK,órû³‰†*¬;È–[nIB­€OJÕ›ÁÒÅúçÖÝDfÁšnì©9ÜÊî´Upâùâü’/L{zâ‰'~ÿûß{©ôŠzèz™)8%†’ž»uíÚ“UÓ¯«
u37†ãì }Vm­Ç³ÜUW‡ž†d{¤çöégœñˆ#Žøô§?-‹–+|©¥–˜äúTë óÍ7ŸD®óöõ‰qÌæÝ|’aâ°»G²Z°Ž¤&½²É&›t…õˆ,SÐ¤çúÐ¦>ÿ®é¦›n¥•VšcŽ9„;aYJ¯¸â
y,7ß|³ë†ÙÆ6Œ$Ñj‰q?ûÙÏGjÃHà1€!wÂFpØT¥Ïe1ðÃëj”ËÌ—)»A8.ÿ²®ÛR8ª6i·‡71º;¸UÏÔKN³:œ5O?ý4]û¥—^’5$ÞWÑ—åŽ“·c×Á—®Dªn ûþÒK/52Q¿GÑèˆ”'£h~°<SÃ~•¹]ó{œòu1¬1Ôî[5cÄ‚•1$ÓJ#„B!„BSÃ]÷@gn{“¡›í6xå•W&õ¼±Ý«KÌXa…,Í¸ðÂ©Ït[RÍˆ~DWrû-Cƒ¸ã6›»ÙäúºåvÎSæþ¼Z@wõV.ksÝ··ú]CŠžÝgúýÅ4#®Û‘$iôÐ]w[ÿ«=¶Zžë-¾x“Åiñ<ð û×sRJW&^O3MèÂÕŒ"Üÿýe^î~Íþï[	'ý‚{{le¼í}Ò©0¡.Ý+FÓÈêZa¼D€û2Ë,3ûì³ëEo¼±"“Ûl³MUÑ:aüÉLN4YW	ºž‘'ÑdhÝ¬bsJöe…vMh±Ë¢0Œ`Í0Ãö»ØIC>E+øDÓ/LÎøú×¿.‡×%¨kS­á.»÷OƒÔÕ©á»8‹{ª˜z{9 ¥aïkòtËp2Tç}ÒÓ&=ÝÌ(]×ÚËƒP„õ=AæÖhJ—Ä3Î8Ãè Ëå?&ºCTUp«;U¯Ög*¾Ãø„È—Í7ßüƒ¤1E -B!„BaÊ¦«qtËÎ…·@”i’´…-¶Ø¢ùõøsï»ï>¦æÒPˆ‰BœÙÝ6«F9"'±w1‹Ô¨²~Ä’“?Ýl»åîº†	7•Z¾æ&7·Ê]Cj»ÃÛ–{¢6zœ‰# ‡¸ûMÓÝ@±BƒøÆ7¾Qµå‡šÜýðÃ³³ÚÙ4“"´…j©æôòûvGú÷6´àåÞÕþRxp
¥d²ÖO^xá\¾ÌÊ¹lÉ¥@…ì¹ŒÌLô24dÈµ0¿Á‰P“þõ]ôrwÏ¯²{ž<gB€T\êñ´…öœ_µ5)çtF{õÔSO¹ñ,×å¨]‘*|£í•‹[«7Øõø7¹¼iŽe›%mS02y‰›{»í¶ë~z%Tsù3^²ä’KZfvæX×=¢>ø`nh'úJ¾4ˆŠ±
ÐuéSQÖ(l•o­õ-èWÕÓÓ*‡`(Wç¾Áìß?âB!„B!La4ks)€ô£M7ÝÔ‚»îe—]–÷Jz‰¢äNØógu‘t=ö˜¡ÐÃ2IÈ$z†D7Õt7äûØÇÜc—ÀJ‹¡9R¢› \¶Aö1®FwìD¥²–pé®¾êwõØlû¥Þ±æft'5·9Îýîéaè!?½èj¬v¸‰é# éï¤/|áäZCöÑ20ª®ª¥iÓ®Ê6dåÆá­&6DQQÚâ¤ÛHÆ„S“W	zœvtú+¨M?¹8È(e¶NmB³Îc°Ê4SèÑ®ÎtNçº2´:CÛc;ÓëBQ9Ë\¨;î¸£kÎæÞÿ.¾‚‰
5R\FæÖ™EýÖ°Y}©~ïs÷ºQÊu ³\#p•ðK¬$ÄKžiçûXsKÂ¤DsøíSÆàCúâ¨»í¶›:„º±Ñ¹RhýDO¨”†hÁÐzrKØS‡G¿zìÒ:·¼ýöÛž1Fk´¦)"§.¸àÏ8¹ûÉ¨Is„B!„B˜tçb7Q²ûge1ü©…¹_Îèqüµe÷ØóÎ;oýIEâÃUøNô°9ÅBWUœm¶Ùx–‰&”è*	È$èöÛ\x’!‰ÖlRy9Ý9Ëßpƒ-ÓÍv@YØ‡++I³+þ6[ÙêpOÈF¿s¹_%-Qº–´æUl:u=V&@ÂÊÃX¡xÕ¡ $©™ÆÚÙÿ8@U¦²…Íº>të­·&ÕI)ÑXr‡©.8d«MTñ¥}
†~ÅWdÛì6Ü0Ã¨ð¾¸š]%ð1Î$yc_pzž©1*Áˆ”PÉ ž'¥Qßhdþð‡Å7kw×Ñ±‰Î:?)Öµ‚ÇÓIgØÉ•ÄI!Ý‚ G¿s•ÎÛ"jz4Ý¶êŽzÞiëts‘P`Ì†Ÿš“z|tÛxóvÝ[<½<z³jR‚6®fpÈ®Ú	2Ùí°?]ÓÈÐìÛÔC=yL.×	mÿ]4ì¹çmÓ×÷ªLIÓusŒBŒm´à‹SO=Õäc'.Y:‰ò˜sÎ9'ƒ¼¦<ûì³Õ*0Žh@¥ùô‡w@ë<~7kÆ‹¡·è~C[ŸÑÍÞxã?+âkZGM‹„B!„B˜ètR5Ñ¤¥3üiÅ$¶åš2Œ™fš©B™»y©²YÚ":SpLf'4óyñâqÿ‘¡MŸw¿M[!¹=fÎzóÍ7)Ñ´÷ØŽUz‹$DW"ÊTaÀòzÉ-´pLtU«ëq
wš!UK/Q©ºo©¬Õ!ßÒ¯xsóß]™zNH"	õìÆtÔÊìºüh%¼ú¾ˆ—¢9žAygˆ›{î¹kkmÞ=n¼ñÆõ×_¿ÍËùj}ÎÐRßüqÓ«™ÍÙ9GaÓâöÉ’¨ô¡p„æî!qô*ø[?¡¶¨8·ôÒKGw›‚®<õÛ¾¢y²›]FØBY˜µ¬\‚å–[Ž'í}Ï=÷té ©é0ÔgrÅÖŸÎâdkÈÊ“¥;{Ò¹SÝà³
ê-^Òg,üã Þåô9äCœwïF%Œ›]ïeßvžÊevÕºå–[*åÜGW&µ 1«ÃÍž+NHa' ’k,ª'ëyÈ£‘ÄÞRSFh—5Ñ$ŒNê·Õ°„™2Á:ê(Ý¾Êèí®í†Rü4¨!éÚèÁc]´ ð!«ÑêözTû³Lý:Xe ×/ˆ³ƒ½šÒ-B½>1Qà!„B!„&í´'¯™7¹	ôæÄÕW_]DI…'Ñ:[mµ•›d¯Š•ô¤uL>ùä“wØa¥“(ÈnwÂ¢Þ}÷Ýò=)žõƒ”VâÆ˜ D{-­¹òOÝ3»yn¥ùšxÔîºÝiŸÆÐ?=¹ôšVì«+XI¶rc 	d\fDä²âv=ºa2j¾ø£>ê(ÑŒ%o¤8OI§œrÊ•W^I§PZTM• M|þóŸ·}B•ƒIÀ¥\('HÞ"ú—®¡Šã®»îªiäZÈÌíÉÝ%ÍãZk­¥D$‘¥»Œ M³£:ªuÈ²{ÇÙ7ú/8íO6áÕV[Úü†c=ÖLˆVA”¸27Ätg'MÙµÅŸ–ëºAb«KGKLîGyìžø%7w%¼ZÍ:•k¡6 .ä¬"™ãd"ö–
ñ 2º^u3Ážÿó \ÏÔÛ¬©†ŽÈÐ®–ÎîîpWe/ô_vêÛQÒy·œJ?'CÛŽôü¹æš+ÝltR#k¬±×³áXc*~gõù«®ºÊ´¥LmqIôë ‡H9×±5k¿¶ñËî¯aÃéP¿¤~^»'BåPÕP±^£ òjöÝw_¿ QŸC!„B!Lj*3—™ß[™~GSv§ª—»eB§¹ÀR–é¤ì{·Ýv›ÄÕ{î¹‡6ênYŠ%é™zBƒ¾é¦›¼T
,‰„ÈÈÌk}Æ.wÈ% Õ½t	Cåí­;ênNE‹È¨W[xë˜ŠÔõÔô²î_OÔrÅ§£~º“¯$Ù‘ÐðÝÿßpÃÄÐ&o)h;ìi>‹¸@Gv`I¡Ÿ
…•;’µ|ÑE-åHp€Ö4m*tk&Òé<Jðì×5zh)Ï£Me¸ãŽ;ˆÎ:IKHø¯ñÀ§eóSó}ëÆeäOáµQK ½ÖÒ9EF°óV!=?÷ÜsdhW’‹jYNºæþ«AjåñìoNM°k§mÿù^o¡Ó‘ð\µHºÎG¥üV]uU»WÛÆá;VõK’¢«ŸëžK+‰ëaÉÐ>È5Á£Ë‚oñ?q¡ð½JL¯ó‚æÞtêöØw4’÷Î;ï”gÖ§¸ó$yc´R—&“„Ó®½öÚê\>ˆ!
Mi<ÒÐ‹~Èo°V—ÐÐfÕ´žÜ~S*‘£Û‡õ
}IïRA¡†ôjÒ.gLeûí·èarÌC=ä?î±?‡B!„Bhtoß×a SP®i:ÝWÞêÛ]­G ’Jd!‘Hgf¼%™ìÕŒ`ÆC:©)áŒ{<Y¤ß¿R+z‡ûÛ–A,Æ—rTðÜHw“+j
0Y§¥!)éÂÖ*…£ß•<d.ðm³Ýéz™KïîUÏ
µóu3ß/rµ7Â-}û8R‚	Î$fëÐX}qÒ<;³ØM7fžyfë05ó’óZv‹Ý¹ÚÕ]HMa²µ"Ysú¾¢EFo2$šO‡¤b³”r‚WŽp$•ÑC7P~àÝ¸gÛn»-Ë?Ÿ>n`Ð_¥GiÊ.5fT¸þ8}(q.eá¬ò’­f`ë ]‰¹«ÐuŸ¯3½2âË,\í%ç¸A5×4Ã5—8È”mÍEp¶¾§N>08Pd8„ßhÜÕW_íjP¥Dÿeúh_D¿‹ÏÐí*Q3?œíÛ]T+^¦›Yo‡¥þtÍ$Vš\"[ßFÃºä,…'B5
ë19øðÃßo¿ýüøê²ªC”aL×Y`¥¸,ÉÇ­æd÷ghÈßG}Øà¥>ÃPÏììÈK¶|Â	'èŠ—]v™‘IÓ5i&„B!„Bø“{×*ÒU"NÓºâN×ïY*O=¢ c¥ªX™î,£Ù$\Y¬slwOÂ='“—B‹q+Ë‹W èŸÕH'¥†lÊÏÛ|Ä’LËÍÚD"÷½”èßýîwMê1mõä`TG×î71èId²Æ`÷Vß©œèI«'„šxD¦/Q•‘S†,'8÷Azj Spª¤[eŽóŽ_¦òRÓÊÿ^èj JéŸmðšk®ÙgŸ}’¼1ú®]µ ‚Öìñ€
Ýu×Ü2úU1åÄ8×Z[På®b}Õ=ê4lçæÈ‹U6×³®R£MhÙ¦qT±P×œr"ëHÄ;§°jrlLûð¸óÎ;}ôÑ#s{"Œ¨ŠôeŸbîˆËlIÏöÁ%±²DÚwñém@Ëî¹œ¶Ñ/Ãì[ÏØBw¬«†}„ƒéÎj-g 3õ!ŒªsÁÔ"cêÊ
³b‚v:ƒ¼è¢‹Œ¸è$Î…Í7ßœîlÓ¯­A…fxï™÷3¦Ù?ð®ÏèEúž4n[S$@Ö‡©H~¦]{å8U>L.˜!„B!„†¼?ì&*”®Ç¬G×«?ùª8L›Rª´{]Öfª(=…Bav¹u8­¨Ã^xá%—\Â`er.Ã·TÕÅ¢ÈˆŒìÅpïêÆØ:]pÙ	ÿ÷ UR¯ÝÛ ¹¤ô#ÊuVúÃLÇÍÚ<ÎtdGO|G3HY‡Ð²ƒàHz|ðÁ…i˜Cíÿ‚.0Z5ÆI*OÃµÑ‚îBk¬iÁ±Hy§¶T€¯>V¶>ÕmÞ“ ]Ê#…ŸšOßàJû Ø?G„6M3ë¬³²<ë ®9ºŒÍŸ¡;Ëèq/½ôRóü–ðJ#Ö¾¥Ì“®Sòñð'{»ìT G}„5aŒÍu©eûs	Óz”«ßgœ!çœsÎááˆQ÷,vÕ•"b;šÅñ¢Ú~åð ]ë»ÃZµÜÍß¨Q[³”ô*½èª=¯á@Ë¶ébžþ6j8ãÇÚ0ðºë®Ëo¨À/²¡­Æ³L‰¾öÚk-°B«*©5…ŒiîÎ0‘2~Êu<Ã®Šz>w<Iš5žëÙ˜(´ÓPÞ´l™´H!„B!„^Ü.ºk5œÖÌš7ð®ÄænÖnvBw³¦±@«`½Ë3üVî9ï¼óN"©IîÏ?ÿ<=…îC€6—rG8&g>ê¶üV •ðÖ5¶”·»¤j÷·]çr{lÍÝÒwÊÚÜ?¤]qÜ¢Þ+dqæîžÂ€mæ;+7‘¨§öWwe*³æp„¥”HÒ¨£í°k±À45ª„æj‘®‡½k`Ÿv‚8õ@Q$u`mòbOŸy¯è’ iš$›¦ø'Øt4 	äl(ˆ÷Â/ht`ü˜Òf<«Õ3ÕXs®Ñà~7HIÃ5îUzqw:B÷jÓ‚Ð_­;²UŠ-}ÖùÎJtñá‘†[¡ÏöÄjÕk–F%M«›J³ M€^h¡…Fò•Û½øâ‹3´J±‰
®	O=õ”#C—°^_­dº“-Ú÷êfÜ×‚¯à‹Ô«ª’VíÁÊÙ÷Ì*žäúŸS`ÔRñýÆcYd³”U[eÄY ´¯|¿Å~—iÐ:^–l³Cª—Y·u¡ê†÷\ýÀÙ é8Þ¨ZAÿaç÷¯‚ÑèžîB!„Ba‚I!Ý­þ›óöÌñ»MIj¾êHnáz>½¹˜»dËÙèäEv<p™AˆžÒ.¾øbN[Fª³Ï>›RLìêžÓ4ÞÃ;Œ0mî­S%Í·u7ûóAÜ‘²ø¹Ñe tkJ"=Sœ©3±ê6ÕÊu7[Õ®X\7½î™K€î¯þ×ïR“žØ•¡ÿs”RSÆþ5Ç¤\)W5³˜çí¿Ä“¯Oã¾ôªÃâ˜tL¯ª¬ØS®Ðž8€ÂI¨ùÍf>|—ëvªi“®ï›òÂw¯£êceóìi¾~#üðèHÐj¤L~U}>zÊ8\ÇôdO°xÿÊm…ž+j–Y0!ƒ‹Óœ	'¦SŒ²vóÍ7Ë0u€ ë\«pg2tÝ4q¶ÔØž±Ÿfî«èÏÏ©¾Ô.®{,¥k\ÍåËŽõ'ê´Nhgº*pÔg†èõÖ[oäÞã*«¬Â…J/þƒ¨©hØ¯®¨]¹¼}\{tíuXªði‰íËV„H½±b:jã”hË$~ã^56FÕÉÕ†Š¾X0³ñÆûÕVÀÅÐ•Ð¹ šÙYðúë¯‹RQrÐÜMl`Æ)Sý¤å•*U¿S5,:\—+k|uIVkÝr«­¶È‘B!„B˜¨"K·:ßk6ïp€8dlÂHtœ&%÷‹à}ÂwÛsuËNK>,øñÜdpw§f…«bçÆU‘":}äÄOdˆcëc²SÎèwÞ!°~îsŸcpvjå
m>_d7½îKËîçÖ—©¹*Âµ)ícÊW&wuÜ²˜‡ ›Ðw©ébºn¯žb€M×.%«îÆ[á²új¦üsËºówTE3û“(`²ü7¿ùMfp÷ç5=™pæHþxù$•m-‘söÙgObæÈOº
"¯#F™sÎ97ÝtSv?ÂJªé{êQÎ`AßP#ŽV(Y8M3ž—Çþ'{*—v-“=|<ž3Ì0ƒá1Q¶ÖÙ{ï½)ª.MÈIdÈGÈ€sSÃ•RÖy©s¼¿ÌZó}H›pwª®!jáÓ»“9Ê}Ü6Õr-ÚÖô.WÒ3!ØãÐ…hÝuÖY‡ÈN¼¦ý™wR—ßÖ« "EÞUº¾¾gš'Ú3ÎiÑZwúHË5ªÝ³Ÿuúx£ÜùŸþô§ööÔSO¥>w+„Ñ@÷ß#pæ$-¼ðÂ~tü¸ûÒ´`‡h_Ò3{²cƒ
Ý¨žèóa~OõjcrºS¦Ö/#Û™ÿœ˜ý.Åi—B!„B˜èR‰¤_pé÷D÷‡óö«ØµšlÓ!}Óýa÷~M’¶'îEgši&’,ºè¢œƒ÷Þ{/Íbƒ68î¸ãî¸ãŽóÎ;X£º”»J‚2…‚B¡b0Üm#JµÐüqÌõ.Ù¢nG-S|ÖtsK}¶`#6X¦`ËU’k„ÎÓ	ÓÜ?§¸f×þû.ö­ûY%1·hÔz†Öã~»æ)ûš¬Ê—;yåé¼äûºÏgR ð8Ï<ó°–»?×–=CE"âË3±,I€XÐíÑ:Gxº¼«ÊI!PGÑ½ËD¯ÿ× ý¾ø±Æqhz	§7È7Ü@ƒ«A…´Ë0×´þW‡¹puŸìx«é-¹6µÍ6ÛxFÉ>g‰MÜ-}­"˜+ ^mç|,|ÅÝœ¦ÕÓú®	ìÌír×? 2.m·ž±ÐÂ.êU{"© "ÈkÈÍð°)ÔX_1õ\¤ûHŽ¹Ãâèá>ÑEÛGèÜ)¾.köÍÕ›GÕÅ¹ŠVþ{èXUü‚Õìƒe'K÷ÚUC®o¶)Ó_š¶gVF3+¯¼2_¼Díe(|ƒÎ€\u3'…kšŽ­7jô’¤Çôã;¦Lüþº¾¶Ém­PÛµÿ7ŒmtÚC!„B!LD˜z
Ä¼+–1Ã’ Þ•ª«¸_á-n »Ïtß8¶Ó´E‡–^zio†+ÆaË-·ô$Só¡‡jbì,³ÌâF‘$ÁàLt ™Ê6s– ãîT¨(m‚î ÇÙŸä’*BU’kÝòë•õ¯
»µQÏP7Jn&X[­É¥b÷äH£;Á3šû'ÔwýÚ]iÒ7¥Ôô¸ž=CUwëîÕÒkèø*›ô	aÒQ™šÅ’ô$ôËjåØý³A†—™z| 9§†1Shƒš©T¶B(ÝM÷®Š—­YÇä‰îÆ¶T‘.œlg„üÙW‡ìÌu}sÁévãÖ“]kx¬­OMöçÇ>ö1M.ÎRZÉ²5W£ÖaBç–D\¢­Zjå¾4<àªUN^ÄY×Ÿa²àÇ”éÜ=ß]æIßQòüßÒ¸pI,%–u¹ž˜Žî>tßè’âÊ?’£m4ñƒü ï³)&¶ï*íbëªk.Ýþ4.hƒ•@ý?éÐ÷¨c[Áj•Œ]« êšÂââïUg“(áO}êSFwr-…gßÀàäÿ6Pœ5“q²K/½ÔL&íh*€Y5æÔeP~·„"ë")‹ã¨î§¡ý9Öx¢–Uc-u®yR¢´Ï•ßUçµ,¯þhB!„B˜vRàëúõ†¼ÙnAm“^«Ú;¹„†"~Ñ)Ù“Ý-Þ­šÅÁÇ­9ß|ó­½öÚþ¬¼‹“e‰OùC‘púáX ƒ‰ÏäâuÆK2—»ûã®OL3G-}ÙltéÌâ†e7¯ºêªÌ¶¢œÉ(GuÔÕW_m†,ÑÙ:Â‰5´wÄš…¼FB’%š QÞ(b„çK›hZI·Ð_×5¤¶ÛŸ¬ÚïnSÔr¿TÝ/Iw§÷¼«iâ%%w_ªÄgBc•,3gŸì^b%'—ûpÏÈ±‚ûsÚ–{xá!Üât1Å­@‘Q‚©§!(ecrÛB4q¦²ÎíB—ìö1¸†O,hY¦Î/ÑÏKR€nçœ#¬F¾~…¼${d0 3ß¿‡Mé	”o30º“ñë²éÒÄªiÌ„ #dëây9?bj=öX9dhÏ,·Ür–åŸÈ´‘L}v#¢¹ŽµR~1Q3-jZC«túŸÃÒŸ6ÐsÁq¡£ÏÖÕ¯?ËåŸß¥¥|´Ë‹kµFG1¤U¢È0"c=:Ž ç²^J‚¯·ßxãæÝÖÃ]Õ%$ùë‹ÛÉº’×ŸLïI{Rá35„Sñ~ƒü²h¯\¬Fç¿1þ1p®‘žÍg2“F©­¦Wø)g–g×š›÷ßÿš„$8ËÏ\M]ò§c*Oë=qùµ`ŒGêKW€®sãsþ	1[ç,zÞyçý9„B!„þ4ò¢gNqí™?Ž\°Í‡ CÏˆ¶ »ñ³c3,àòË/_vÙeùÅJ [qÅ—_~yd*LÏ˜ìþ…Mà2Û&ÕÌ»h+n9˜iMžu7èîÑ´VuŸÊëGP,5ØM ¯ÓÁ\…æÍ³¶¦2wž¡}[`n’¡¡öwQNÝ(Rèj º]¬ŠC5)»b4¼ê&Ó«V®ÐÛf&@·{Ñîìò	èVîéjyµÐSæ«+ºa.§^{©Y{‚Y)5ÍYóîi‘\`?þ¸F1`@öÚh£ÌY6åœvïîÝK2yZc‘ï?ûÙÏŠ(á46à€›‡®]vÙe—6‘j2Â+eÛyáÑj†K8kå%{*J:F€n]Ž^£óèšÛ9>ð§¶ô0ð§ÞgÆÏÚU´Îƒ4uÝó¿®ŸŽ§rŽ®~®]$fƒ†ÄäH¸49æ®xæp¼öÚk”h#g†<)F@e3£e.n®WZÖcS1Ò1éÎý>÷!Ëœv³8EÔlîH[½Ð\ãz¦jú5;¨«îÕ²‹Òšk®9ÌVë{'œp‚a¹üÒ“À&ºRõÌõßv¸HRv£uåÿî •æá—2nÀŽ;îH}vµÌoôü3ðn‹¦1Pm œýéOÚlÍç¨ßúWÄ,C•¹áO4£Ë~€DêÅS™„VÓ«F8hÖmˆ®BÏmÓÉkƒF†ü3c—üSd8<u!„B!„iýž­§._ÝÂñèQOHÆ„`‚r·HàÀ»KN=2eiÓÎsÍ5—\E·^”)ïrÎ©GÊä6sáþž{î!(xs[>î6Žfèø”éË5CöÙgŸe±¬À
2H-œD¥ ¹ëû§A(ÅdµVóÊ#ƒ3®»Ê}÷Ý—¹‰ôæUæAå)kÄr	9ÕÖê.QT¨ç+DÂ²­ÕŸõåq«™ìå%,ý®Góõd›Š>¡èÃrW=é&côx÷jÆºo×]ÇW ]y¾+j{Ò¤V»Cöç3Ï<ÃÂLëw«¬Õ(Ëš^¶xŒäÄÎô¦”-±Ä¬¯,êÌì&È[hvÎÜ]xî„ëêU
’^ÌÂßSN­=”^9&m®§[:k¬OÔ£–ödµOãMßóõ/ÞºN—Ðv œhÌÎÔ1cÆ·jW?ú©É’µýi:ˆÓ¶U%IP*M½Óæt®Æª«V]…š<äøÁXèþ76Î\1ÚŸ.‰ä¼æ‹ïßx7Wºâ‰F’_ßÝá@uG7‡<ì¤|‚>=Ñ•ØgÜ¥ö¼Ûº_ŸHýä“OVIÃAÈP?"Ý}öƒå—È±uy¬T“ºÚ»x2ÌµoÄÍDÐŒBxË÷ß…ƒÐÆ¶Ímºí¶Û¨ÏF MÜ1ªZãmÎ2#†:jÔ¹LúúI@ÙŸ»Y«ÿÊ__‰ê_WK	ER8Lnhç~úI!„Baš–Nºs™e‰²{RrO±
ŽWòñœsÎiJ¸|JŠÉÎœ°4sW9”­F¬Ü~ûíÝ×¹=ãb–háyê3u’žBª`rCè6†Â‰Ì¤&ÏÁíÉ˜?Ž—–“ˆ@¡—QX¸ŒKÝàY&—±·…-Ömž›ÉÒ…­ì½žôAn&mÜ“¯lÁgÕÊ³²WyË£çSê&³6è³È
>½ž!ñL5‘¢,Q=¡¥M³èWUÆÓþ\"xí'eÜ]nÍj¯äh;VîæÚ+Ob™¸­I:¡³8n,u˜E«J‡ÕÿÕ 4zßÑa¡5o1ˆÆÕ9TÜvK£ÒºÝLçÜ`OvöÜsO#=ÍÊTÑCJé*)Í©êdI/µ¦þã,sžò¼›è0Ð)uØ?gbÄ8Ý™æåô1ç¤cUf{tñtÍ4Scx®¢fr«3]€h%#ÅÅ³ÒŠn¼ñF*˜#KæI'D-Å³TÔ2oÖÜ…žé=ÆÌ!]ÌÝa³1	ÐýïªkNQYömjEO"PwÆÆì±š Ûn“ž
tkuY’D‘Tô³^W×´?b¡çËÚ²Ÿ'Ê` ­EzvÌš®¥~žü ùâ{]/9L¡JÛ=ö67(WžÑ@5Š‰Vþo1d´Û˜7¹Ù¯¡óËð¶WýD‹kÓ¤{¾TÊJÏÙÔ}¦"YzcêêZ….kHF÷Ûo¿ýüþê*Îô¡&–…B!„ÂÔs'6Ð‘[€F7I£çß­š›%q
ƒù‰šÍ'IŸvÚin³Õ¡2Ë¸ óº‘#3™Îeì]¤jB ¡™ˆ,&Ø]º[tä`>²yÙÝ˜Y¶1Ú=[Íh&oUÑ'J™;@o¡X’»eÝù÷¸=I»¡È”äá]«¢ZU‘*áÆJ;&F”„çK´-ÇS×"W{è½ý±Î=ÆdÂ·îÑwz$ém¨Gl+÷¸PÝWlçø{åOwÎž1ÇüÌ3Ï,Ä7jn>GR‹Pù¯¸â
zc ”jVæeeèîºë®#Ž8‚.FÜ©‘ ‘—œb4²!•1ý9üó¹Áž,´Ã.,E4­“Ñƒr¾÷Tlc':LE™£?¶G+;ÓuËã?Þ¡¿­§ v“Ô}¦›$Ó“;4ðnÈFw¾µËÅÕÑag?7¥ãsŸûœ“NF1>"5„;KŸ§~£™U`ˆŽ¸éJè]ÞkV+g]sˆV¢íuëNvRiýÙ†âz’âGâ2yaÒa\Òm<cÈÔû1eß÷ÍíÕV°þ$òJ-¾_yÉ¨Ë£1Ec‡åñ¯G=ŸÂè×~;zö¤{ám_ÊõÜo‡?Ípa7ÎgxÆ–ý"¸f¶Ÿ¿n~5YwOrÝ%@'cU0Ê\½Èx¹3Ñ¹ß}§žÞâÇÝ¥Ì¿•G$¡«Ðê65Ê2¦$ô
z®‰D6âLô.¿Îeóo«©  þw<<?Ž!„B!„©™®²Ü³\ÒIPôX&ùÈ¨Ïâ&lV¢Wn¹å–náÜ‡‹Ñ¨-ðõP[xœÍt~y÷ç2Iå9pÔÒšyô<ràRÁH*h÷i·m$‘Í¥_péÒUÝÞˆÝÅy;Ó™ÕÜÈ‘lÜü{©¢™½ZÉåøk“¾«â|7\¢´æv‹èy©?IÕ¶ßä›–HÐã,Óôð
N/Zi¯®·tH]¦+ÐtíT]s³šR©¨Ìåy$îË¥ýŽ©ù\ÛtÖ1ŸÎånÙá%LkmÇV©Y…iô;še–YºEµ©5Ý¥©$†)Ta¼-Õ’|F&v~éçúëu=zJ5ˆ¼Â®:žþÓŸØ3Å« ÝgjY]ÓM6ÙÄ‚Wë:ÙR \$™+Í¨gpFKeèM­¼ q7FÅ[šÀÜGØ@šsÖp+d]+\Ki¦®äN²—k iM¶h—mGƒ®A²ÖvÆ ø£ëØŒ–ƒ‘ø£ÛP\×…Ý½ ŽUï¿z|î¹çÄ’T@öÀâÅ»Ó2·øÉ(‘(¨„,XÝÞ…Ñe³g\°{A.Õ[+ø¹©]rî)µõP$”ß#¦.Â¶)Ù‰6í§„?‚irOõ\9GÕÿ<u¶Uõ_ZŸüä'ý˜Êõ¢Ao¼ñÆ¥DWÉ
&ÒücãŒöïGõêNÃÈµ.T“½Lðªú·Á²³Þ™k<Éd¿¼:s:I!„Ba*¤Þ-è–Ì#•¤Ý3»/¢¤˜G¿Ùf›‰cv×MÍäœu{F=q÷N>¶½ƒ¬ÉøLpeV¸Xgwà\~Ö¬07rnþ	(îÄØuI-néi1¶£Ž–{x·v49nØ|ðÁÒ¼<ï¥8Oi4>«,HI ¼~%L—¬LY F×rÅq)”tU†ž åî[ÆHÚ3µ|øx®»yÈÕžùïýŒ;aÚ½ã`Æ·{WŠ3›¹Ca
¿ö"‡‘<ÜÍj2Öæ7Ü°ÝÐ2Z
[ #[pÇ;÷ ŸùÌg*³»´Âêï“š¦tÈ£Ä§¡Ä‰FÜN^)s,ƒ3®ªŽµ(¬æ¤V¡k*è<uR8GÖs³öäÉ¸Ä¹X¹î™LÀ¹L·rÉF7`CÀb–tªÂ‘×ìÊ)^Ö•µÙ[%ÇÜåÎRŸ¹¾¹TòóÒ1ÛQÕ4>·I·ÝkTOš|÷²ÖD±ºHŽ¿ÍyÈ+ÕÈè~×ó8®®å@9:épàO%æ!èöëFd<ë¬³¨ü¶c4Žß¼t@}›úlƒåŒî©×ZÆÿzžµ™Üß.àó4«_%~ÝÚq¦>Û>)Ó/;}s 3©(ŸÑƒÑt9éºàæ‚hGƒ¸þ‡á©3ePÜ@…!ó´{¥rÉº©‰PÃêô”ëôKm
‘S»ûã®Ÿ˜4¦^¨Ò~”ý[Å…ÝÊ†B!„ÂÔF÷ÆXøšj¶2}ŠÍ™žB7ËàfŒÔ++–îIñä>#RÓ—KGö*©Å=ÍÅ}%ÉŠ}(Û2á†‚ÌæÞm›Û0ÊÙ…ý§\Ì$l¤,PÜïÙ”û=·ôå®Æº—ãMö¡õFÂAóýuoöÜéÉýhÉ§ýõè‡”›»2ÍOcîI‘ÀžÜ¨$!3X	èeÐnæë6§› E#¦v©£ÈQ®hýò4ª5-UÙ200˜3[ÕÄ^Zc5‹ž­µÖZ]á¦'™´Å4÷§
LÑbb(ŒR8ÓÅæèBºŸó®Æ‡H¢CJÕ‡É.µæ˜F\tÑ*±Šqvêè'5ã 9+y–‰V”ç‘õ}ÉRFw\ÓäÕ¸F91	ú%Ü“´\¬1ê3¬@:WwC¹e­Iþ‡AÚeTÍÝ.\[[«Ù=Ó)ÚH@IÏ=×œñ ‡¼R½§„è±jÙÃ¿Ñ7òÃá×D/5~f@”høþw©kÝ09?¦æø¡ïWUÆ¦)·ýÑv¶_?(=´Cm¡¦×Ôó~Ñ”ÆõX3oêÈûÁò3çl"bšÁÃ½¾üòË·«qUçµîu±ÄÖ_}§§³Û	ëÿsƒÌßÒÙ´¦éDþëÐ÷Œ—×àG+2<ºÆÂkNCû¯ÓÓÆk
Åá‡^)X©‹B!„B˜RéÊ‹=f1OvçÈ{\qÅY#ÝÉÓ ñë±y†‘V•'Â‡;4n>™œYù8—)Ë$i’
a…†BGæ£¤ÓˆÉÊnÕ<R^J™r;ç®JÀSslÐ]I…õÏ¿Ú'k¦sÕwÃo#u{_1Ðþ¤k»«¢[ý¡>«›È<òÃÛ÷†\ºaÍ=%ï»ÁÍm¹vØ‚wóiW{>´f…Wy@GÀ«K6×›ÖÌ‡^Hh6Z`a‰%–`ºìo÷!%ãv;ÖPæîšQœ§ÁÅ#‡“Wè0Ï™[å+û#n‡qóyš81ËÆ¢ÄÝp2Â1E_3{]Ø!Z]êhß2Ïà¶Ûns±rÂ–å$¥E6_¤Ë”k ¹Ê
ÄM—,«Y¡{ì9Î¿¤[Y´^muÏ*æÞEÒÕÄo7¤ÂÛU®ÇSŒ‰µyâ¥|xô­%ñì¤ö_¦†¼¦µ0n…¸Y«^k©É5?¦FM4Š…6`Ù"z‡Ì§¶`šŽ†ðFÃ~¡ZÆHMÊ1ŒJÙô£ÉÖªÅßÄ=Ê˜}öÙýŸc°\é?¿ž<Èþç1â~òÉ'Ÿ}öÙ4hÿùxÉ)ï,6ë«2Ö«‰+Ê¹Õ˜’gê•ªf©{8mÛIí%ÿ8¦]¥o„B!„¦xš›Õ#×ÞJ+­ÔªfÉ=ø;ß|ó©>úè6ÚˆÈ
ÊÊÍ¹Ïç·5•žàÂÒå~ÛÍ I”ÍMVüH)2VsO”¡FyÆí½›..0·[näªV^%5—°ÂñGš©RN%4wUÚqðÊµÈÎ	2ë|LŽæ¦)÷OŠoF¹zì¯1ÈCÊÕè%RGUm‡ãÛM)ã6……‚ï {‰_Ïš–=I÷çÉJOãy° ´]×¢ éŠÎÓnyº‘äüŽi'»­9ÍÅ³òµ˜bòÍQ‹Å_œ6$¿µÎqçiMJøëA*¦ÙIê»—Y²É¾®®H†•dì(ÕP\¿²YRum|LJqKœ¯ ã‘­uuç6B6¤—y<¯Šéz[»Mò3ŠéJH($ŽÐ%Z#¯šì×ÊEµ%'ØaG»ìÌÝ,…rFûkõZûÛÂ:6ÐÆü„Õ]÷±A¿e~"íƒâr³Í6[;s!š¼×Àwð¥T­¾úê‚¿DWQ¢Õù4Üî47—È¯-šú¬¾±áv¿ÔZÓ‰ßÓÉÛ? õ[_çaNÀêiå¦×yüçãŠÁ¯HFš&„B!„0•ÐJmÜÃ›ìÌŸBK¹ iRîÇø—Í(ßn»íxÝ®sý6—¼Ò-Ý,¹=û§AÜPq~¹	§—BqN_.ƒžyèU¾îÍHÒtUoqëUù‰õ’·—Õ·¼Ì]§^Wáa­ªžpç‰'ˆ´Ê„öŸAªhA<C¨ïRËóHõ«ŠayÌãÄ}ê_î%QjŽ3Î8C=1ÎJîæO|â´-YÛÍòÜ­Â¸¡ˆ–¨ò‡SÏy×•ØÆY€®çx]7Ž;î8™)z"y;ÅÌÍ§F9O«ÚX/ÕqûÿÙûópÛêòNô•ca4"6(Á°D@%¨ˆ
¶`ƒØ7`-FDEì{E%QìR£&j¼©¤bR©ª4SÖ­ÊÉ­ssóÔynUêäT›êRÉ©“ºŸg~‹÷þs®¹çZ{í½×Þû}ÿ˜ÏXc9æ¿þ÷}¿ï÷Õë8^ªªlF<×#Æ†¶<¹¦ ÜŒ%èÿ\ÇK·”ò¼çÆ=GŽ¢q§.¸À<E‹M5x”üÎã¡FR§5ï8æBC@&×1“mËU†ä5Ê3QÕ—ÑþŸøuŽ–-Úifh¢Ü¢½ùÍoÖµE6\uÕUèê|Hê=¹%ˆèò¢¸ ÐÆ´ÑQi0GÇ³Oq`£tû¤£EMË(á¶ÚL¾Åu¡‘ˆD9üðÃìÇ~¬«¦­­­­­­­­­­mÿ6x%:s¶¾GuÔ7Þß¼ùæ›AÌXŠ¶=/{ÙËÞö¶·ù/Åg[²çFÏÔ~,Â¦ÏÍe»©$LD9>ø5›m[2è³-V d€5 ÚþÊŸ@mxM¤3ìŸ-ú$0|)Ð¼7YGft‚,#>üá'c8IYye)Úä"CxT2
Ê™"ÇAÞe$C…:‹WàxOoí„?ö±AU|ýœ¬sé¶Çj„'@†+Õ7$SèÆ5ÚÖ1]ôÀ¡¯ú`¡¨»Ï€™š7åNwºS~qÿÅ õ):øbðy†¼WŠ(ðâ;c$¦<Ž`£ç,øf Ì¤`Kµ‚$Æ;/ÕùYªõ¼KVr¸Ã¹Ò“x—mYÿyvÇÌ;#î¼þ GT'Õ,–8…óáMý¼¨F`ŽÑïN7‰³a¼ Þ:TÖ”ª‘‚_›æxÄÍn­åÒõN09x	ß'Šæ2%w°ÙÙÒˆXŠ±‘˜™ßÝ¬,& ¶Ñ*e\u†°ÔYš”UƒÑB4*Z‹æ!K3Œ;ù„#Ï"gC7¶¶¶¶¶¶¶¶¶¶¶ÍÁ{èÎc‚¸ñäøß2H^ó%—\$Ä|üñÇË¢#£|©GÚ@{ò#<µVÀ©d;gœq†¸f¨´:Š®lZa:ÛH[Ša¾³]·ôJnbse•í·‹] e.„%JécN`—¥ó
½æ¥ t„
ŒMÊ¾R#à;µ'œüPñÚ‚’#zÛLÖVó¿Î-ÁÚ#²ƒ»$t÷½ï}/J)Ù¬*sœåç>÷¹èTÊ—üÚk¯…nVòã÷œ åX¡ªÌÉÛßþö9é`R¿Ý¹Ú¶6"E…ÀP@ƒ 6(T†™jçšnu¢MŽG‘›üð‡?ä/yÆ3žæž-K\¹“K©ôI$i9&à+íXD™ãg‚–Û,ãƒQQF´aä2/²•)ÏK½EaŸEÚø•:Å•áÐ¦ŠGìuéýwSzèña`vüsˆÆk&ñ+ùžTd|É	"Ãøßç–i¢d|C¯ÎàŸ_L]g.‹è
oâ8ƒL*ˆw6ò€Ka.˜°W^yåì–À£1ÅBÛ>\•q)‰ôºãïh‚6wßpÃçwžþNCM{ì±×\s¦<§»”?™“XÈ‡}­FîóèdZ!Õ•¸RZÂÂ Ô†\Zô¦ÝVƒÉ˜Ó	*ÛÚÚÚÚÚÚÚÚÚÚ¶dì¡;]Y•êLé;çb°²lu4Á£O{ÚÓøU§"gÞ÷¾÷ÁO©¢ñ¶ßƒ'l“\/(5[tàrÐg{§ä¿r¥ùzBíÌ±„|wÄv÷4nÁŒdÃb#â o±$a
Iþã]r¾ÂØÑ–e	SJš\xFÚ²ï¦0"IC*É úˆTö¨J‘ÊÇ¤¨ŸúÔ§÷Áp÷œÛlÎ=ðƒ¼{é¶¶õŒÌ¢ ¸£>ÚŸpYºßd³Èã"XénºñmÒOÙ_Êg„õ\tHjøçŸ>oÐi§vÑEA-+5(œ1/ëÀPSr‹J¯%õ‘‡5ÓŸºè´[ZòÉ…X)—*2¯)ú¼; ôŒ®‡áÕ¢TÍš ]9]ÔJÞÇGˆå*â„ŽJ•CÔTÆ’çC-yhÉ—¯œ„‹ès¦›ÈqÈh‡0k:g0ëÜ­;Ãâ04q¿™šßùÎwZQGo$…¯|ƒ_|±žþùÏ*ÍiÁs,›……±>bb…&¯¯Ÿ^^=K’âŽ1¬'–ÎàYã>sNóXwúÁ¶¶¶¶¶¶¶¶¶¶¶M=Ûµ_Z¼[Áß	n’?m]Hg˜‚àc‹uê©§¢â"ø$ÈljE‚âl“ls;þô§?m[ž$x6Z¶[6EàæätÆ]7ÄÙ§ÖdB•íÌmÔ]ã‚ ¼ÎÃs÷Žèb‚ÁÉ¶Ð³¡¼aj1#¸íý@oÞÐ,Å¢ëÿÕÜÜŠn !lé†Žã|%©!kèK0Ø¬
žMi¿îu¯;÷Üs!ÑðJÝ0—AÏ“ö@d?BåÚ¤q‰¡ôãà,pUžN#:BÆ‹°¾Óh‹(ôIánÁåßp·<§göä‡z(R<FBD6ÌÖò®)1#FÁ¾IÁ:Á›Â™Má`3Hî´Áë$-\]ø7xno”èNÝˆÝ¼Z+cïÈhŒ*Fë x^Ê`.ÜB›?å”Sžþô§®Ñ]Íz
Ê¬—ZÕŸË|"¥RêÏéAæò¾`M¤Zžž@Š*î3ùÞæ6·ÑÇy‹AÌ¦lªVœô\Â’a˜ô9’1‘MîÎP!C·7Z‚‰³<°Z¨6cää¨N¸ÃIodüÈÔYA…)UMÊ\¨%.Iž-Ø¬ÖöwÅü¶¶¶¶¶¶¶¶¶¶¶}°ÏÙ.Ldq7b‹‚Âƒ2ƒÉe›ý|ãßxÈ!‡`ZA™ídD¾7¶Å’àÙ™¦!q:†”…ñyÊˆ< T°…•­C»,«Í³ËÐxa¯6H_üâÁ.àf:Ñ ØìÌ39ÂóŽžmU!Â{4ïß¢y˜—gþo·˜ð„6{€f…à]<¤ô	töüÎ ‹}n”`ÙYx,áNºP»S¸<ö·ÿ’Î@…_ø-(zWÙ>ç9Ï¡=¢:ì`]gÀˆz”LólˆëOmŽöÝËfÍƒnÛä`Bõå—ù—5cJ;¿}€Rýw³ tà¹°D©ÖP¼ÀO™íoŠ1Šn¨w‹ÄE0‘ÄqÆ‹Š@L’Q¥~"é0Á·µ.‹ßk‘2lÄ+}!Æ_øå/9è§qo¬Ç\6y’1ÅëjÉ‹’x0i9MKÑe}	Ÿ¤ïŠSùÐ‡>êºéì?øödÐWoí‡`‹NŽØtŽ“–0¾Î†Qßi,´ŸÿùŸ¿fn³!D©Çê`{ØÃ8Þ¤S~ÿûßÓM7=ó™Ï<ùä“Å*ñÜ[P½ò•¯”ká¾sãB³ì±4¢¥pW[$X/U÷±Ž²ˆÊ*H›‰?c…—ÅõV)ôÐ436ê[ÐpÜjË‰qñÐ5ÕÖÖÖÖÖÖÖÖÖÖ¶	 c",2g<î“Wà5ðeŸ°Q!áø\¶I‚ˆQutì Èkø—]ÓK_úR¢´ò‡H¸äÔfÈ, :YÝíï÷~žb†¹ŒfOnN hŸâ”ñ|#1õ“@QÛ§À‘Ú 3ák¤U(ú¨†1Æ)×ù Öe¹2¬ê‰¼¦Ï:_¿eiÎäüQ&^(à˜Z«¯ø„¤C‘è·’ÁžƒD ìˆK6–¿ök¿Fdãºë®»÷½ï­l#–œBKÕ@ð+Ï•úB›"™M,¸Ÿ“ö±©,Ÿþ;Výx°‡6“cãik[1MÆ «Ñà»ßý®Nz6,£\G	ai\yYz¨á…R*ôù°ÃÛQEQÚD	#Þ&CÄlîØÊÆwŒ“or@˜ˆ_*²BXÖ „m0!ãk«µìGôbnÕQØÁ •d­õ¯bSF’¸ dÃµÁ<èj†Ä-€ÞHfº2©.þw‚À®F¥Wˆõ/²°7«­ä€ïèä[ßø	)|à0-r(šÚÜÍ¤æ€#62¦¿JEfJªXy#ãyUã\¾R)'EäNßÏ­ÇŸÒñs`Dâ¡7 ÷¸Ç	Z:mn2ýRÛÈüÎ3gMõÙÏ~"lÄ¯Ãia¥'ZGñ^+=.],BáëtÒ4'Ë†ë"mO«ÓÞôÐ8Q?üp‚EV/“õC[[[[[[[[[[[ÛVö?#VXð¼ÃÞXÐ¥OçøÀÂ4}ò“ŸŒ#2”t†3Rdgª…ÏzÖ³ä	Ä·…5;¶D‰Ö$µà)ÈXˆ1æ2j”YÐ·mÈðjÃŒçåOr`e[,Ø¹&PEvÚöÞ‰£
_,–ßuZŒæy„0&Š¨õ¯\V2Í =Ñež	=?mÿr±ÿzÛ?8²,öâdmÑ¡0bŸák.ƒ,+Fek'	 uMð¯YYÉ ƒMÃàlDg·Æý÷‹@Í“jÛø2>3bÐÐƒ"éÜD¯ßZÆ¹ôÜˆQÀ²ÝGN-R?Êv“æ¿½ý¥X¨ÜEŽ¿yHŠ:ÆYE9€æ°üà^Ä¹¨Œ1¢gÛFPì
5Œñ¸Rá-e×2þÂˆ¨oE£?)Rƒ>›)¼Èj´wSýˆ“4­Kó‰úÄD-d1Aåê;,}Âð`¤n¡Þ9æšH\p¹@Ë4{šó¨¦B¨"/¬v»ô!]ã_® H¯üšå1­ªÏ»;6%É)‡N›ä±mûÜ¢íî€¢÷’Æ ¤If`#€e’%â3÷³AÀI?Åù$ý Ì†J^|ƒäÄE4É¹êÀZB[5Í°YäDü]äùvÞ¯ßxãš4òhžÍúÄê®kª­­­­­­­­­­mÓHÇÒ?‘nN?ýt0Gá ø\—\r	IVx(þË³Ÿýì+¯¼ZzõÕW£ëŠûþÂ¾€Bµ5nÆ.ôiŒ•ƒÏeG=IŠ†¤{E´±Y²çqø0„ê•œ`Ô›ðéà^và¶[áÐ„r>w(4a1Ïû„×6nÚ] Î.e‚\ŒÀÍåä¿~7è‰g† £''Ÿ!®?ƒAçzg;:"$ ÉÔ–©‘(aTqœ&è¼œB³[]ºÞã÷Hø¶ëAºX ç fKëq§‘Žƒn[§‘T;ÑÀœ7cï|¹eÕ…~Êdx1:ÁtFPB4;§ª§§"Áp4Œ±÷äÆ.h£±ÔàùÃþ*”‘g#òoñe3üN|l«iÂUøÉ•Zÿ
ZD×htà•Üóˆó.æÁ3lšk¼é Á%»¤Oðñ`jyŒEô._m)ú<a…¯ŸuPáh±É—»…á—
3r«êæÌ¡óJF‹ÍÃƒÎC*vÓ_Þ=ùu‘	îÏÌ›åG4¾ýëMoz“™=ôÿ¥
Zm{ß`Í†>`¢Ä8×1ÙÎþ„óøŽ<IY=xèùx¤Œ–Y#>˜Å.&¬øÑÕZ¢Ó¢EX,á8ò5K;ò,.ðºªFb×i!ÚÚÚÚÚÚÚÚÚÚÚ¶ÍˆÚ÷y¨3€f<\l;9Áä¼ÂˆÁ¸Á_¶™Ž —ÿàþ åÊe‚@#‚QRƒØ:øÎ`e1à4Ñœí—l†Ó+DÞñ_[)_ÄÄ¡ôšô€Í(Þ¢-Snª}Ù2"#/o<™}xt< '²®©­šŸö$‹‰›òsØÙþ.'¶hã ¸#(y}'É&z—ÿcn0z²
Ä¯ÐÓ@\²\:•JF™ˆóÒKèr4õ¸mÿ²4]<Pê=Ø|Qø}qö,*oAœ×0Â›ª£#á…Špçõ™íHÝ[ž*áö	ß#JL}ICßW¾òã·ÐÙ˜Y²?#;²}Î‘”Å4Põš ôˆüþÅÜêÏ‚ºò‹A¬ênu¼¨1]ƒ³q¨
ÛÊÅ“`”E{¥Žœ¸MCJœäZ¢v½:e]_6Š5mJÛt ²´%þÅ-Ô8Ýg² ?¾^ÕL4™V*'-È8ŽÛü‰ÈÿùÏÞŸQû±x''éóß Ðþkã·ÀimàÅlÛWv§;Ý‰sšz6§X`€€Év1‹BÓH(ã«}=OÙ2ŒÛƒW‰;G«ßêM“àQ©¦‚ÀXÂYDY_¥³hY¿1ÞËŽ.k¿ZìqWmmmmmmmmmmmÛl“}cí$GÔr)™÷Ðlcˆ-x7FqríŸÉ‰Rô]Û!Iíðnì„!È¸½þÄð²C¶ïµQqÒîE(hBãË8zþ¤Îl«cS„×l'ã[€èÏ¿ž›¯Ø]Ûù ga(8‰ádÙ!#;$²*øÀîÈm’ž #f1¡?0tÝÇ<Ä½úzmØ<¡ñl¦äS“Í	pCwÊ@œZÆg3†N„ä¢‹.²W$l-c.ÛlNb"#°K©å¥›ÿª¯¥ßZªÜÝÖ¶ß`“cŸ'tHQOäÍfAêt¢±°¾eXÈgº?ÿÐ“vÐOÌmç”ÃÈ?5ê’Ô0f
›0ÚKY"C“ú<Ê¤€È‰âD@ÿºä+QfX$ƒÃªF¨·ä*ä’#h5ƒÇ‘Ó¯ÄU0É(¸¥Ú>õH²v†÷.?çarÃú/ø[ÀO#ÊþylÉlº¾‹¹9‰}1¤–ªˆLrô-¦Xß·Áˆf¨5üÐ­È4Õµ9KwD+noý„™‹ß7à`²hB!ÍM"oâcHîA¯cv®@x ªÖ|‘£”ÇW"Îki=
í„U\µ™,º¨¸¨k¡Q0hø2Oƒ 3M‚x—Šã™3<Z8éæñ(¤¯©}!üýñi!UõÕÑÆ5OŽõ)ë«Z#i`mÏ×AÞ<aïxÇ;>ñ‰OÔÓ6 ÝÖÖÖÖÖÖÖÖÖvb7ãîe<3»%|;ñ’…n•Ð S@FÄž17Áž"=iGà)ÛØÞ¼à/°F®ãiË
–µE¡:êâÿsnþt¥-¯ØñÚámA"lûƒ@Ÿÿþßÿû6½”=ÿ²Õñ/ðA
›j¨ë,lÏ‰þWs›ä¬­Ôø(vOA£DiÁ
þüÏs+½ŽEŽ›_÷§÷µÝTAØ)‡|úÓŸÆ—´÷“ùÇVœÈlŽ,R$l=[»h8¸­mMÇ%°Jòl®<£&ƒ(Ít#ÃÖÐç‘ýgp0‚¹›ØÈÎ÷ìÛ;¦,X¸ÏÛßþvÐàÃ\øÕp
o…aÂ¬2 ;Ÿ±Ñ8\Ž¼ÖP¼X2#;8¶òº“(~ãgÔíkøÖYrÌ£#p£êˆ‚DqËÜ9°¸±÷Ïç–¯¸2hñkø Öôdâp12¸rãüó¦f“ŠŒ©Y`ðÑp¿Î‹rn½Å hõ8~ä#9ºu7eBŽ¼Q©”|½uy¼ G;AM¥úÌ§‰Â,r:s&wð.,•è+Þ¾¯ñ˜ÝÜÍÓ£Ð>‹.`¼{ì±Ç¾æ5¯1$’çæ\Áe•\¬–XÜüéÚº‰(+=¢ ´„äœÔŠˆƒUCZô—TvŸ	N’&÷Á›n òÓZu¤ŠÚÚÚÚÚÚÚÚÚÚÚRT²)I>ñ¿ø¶60âÊ³Ÿq ž]b@×Ð†ìHf%ïüÐq&2ˆb‘Aé¥)YÆµqi÷b£ëš/}éK$Gmhmrì„íµ²±@'Ÿ 8bXaÜê hÙ$ÿ§¹å_°x®ãbñ VûQu.7_ªZähæ+‰'%J+B¼XžŸèG6FìIÐ¦Îë{YXfÅåÁÐ
P. 2ÖB_m¡ö-]äž×É3ÚÚÚ6²››4›„ô;þª¢Çnþ<ÑëÐë9Àn:¦1s'hn”¿Ðh“çI®W¤oaïÜ„"2øÐ™æg~”A˜Î‡‡íp6ãªw
9I Z"Â«sëðGÕ£Eå ÀLJD {Qdñ'Æ´%RÀ™÷ŠGNj" ,ì,Ãµ	"òÇp1sc9tœ ãhV ÝAT
tui*ÅÅ÷U2 _ø>æ2ä:(­™.ilW'E\|/¡<£hÒ¦Ú@ì-oyK ÷Që<“ÚÈI¯yMù„	1î‘Öà¡ð»){©€Œ©Aÿ5›%îyjŸ¯âÒZ$„°ÀjÆ«-ÐJ•!ð÷JÓñ¹¸åb–Li*ÝŠ‹;\OñgZŽÏŠxPËúÈ”°t(/QÄ[^nø.ÚÐ.RHž­kª­­­­­­­­­íàµ‚8=ôP°2Qf›Ø(´B
£›Îæ¼B†]ŠŒ½ƒ’ póK^òÚÍW\qtÕ–ÆÕfÞùÅqö$6!"1³Ïì¹È>?;–¢ÂÙÉ#ãŒ	ú*þ×FÈ^ºUåOà #açe«ÌüËùp'ZŸã;×ÛgûD ´~´à*7IŠÂœ‰º´?!®¹L´©øe9Í\oÂÍhÎ):Zœ4I–æÛ)ô
Ö_ÂÍùs‚A´¶f[Ûjü…K,Š@Hv: TEg„³ŒÝTi_€®x=] †¾/y×ˆûì¬kE‚qúy×»ÞåõPþõ¢½Èøuæ½ï}/É×äšƒ1'“t®ÞwÔG)ÀK™ÈKs:—¶F”¦ƒC¸Ì#H½©Jñ¢[ÜÇ¨kÊð§¨éÞÈy/ëÿå4¡fcƒ’£uÍ«^õ*;Î›Å@uï{ßûàÑzÔ£”Z6Ù¹Éšð±_‘J×çþnb‚«4SÕR)ê2/ˆ¨ãì°~ÕÇ¸„½iM^Q\™¨lW{v¬IDÌ*R$¥·À=dƒ9ãbHâxÂ­.>8@s6Wzi9…}n©M—ûMÞWüOœdVtÏþóµs’ÐØñº€µ
w\š‹ÎêEÍ¢±«âäsÖŒãÑß¨wMzÒÙ+'ÏlžçPÆi-äYÏzV/cÚÚÚÚÚÚÚÚÚÚöWÀe²ó\ÔÍø6»u¦ Úâ¢å"/ÃíàËÐç¯ýë¨»²W‰QfÞð†7´Û”·Š3ž¶—-·+V2ªþ—}>êY€†lE`µµqýåÚiƒüé+¹ÆŽ×Ö½¨[Àk[£l‡BsKtpÅA/îêÇ9A(BþI:ãGIìÏ½NqŸ“0 ÷É><r™^Üú˜˜Ý²)¢<ÛÈÙùŸpÂ	o~ó›mðV$ú›@“
Ýh‡Ö;·¶¶Õãaø¿ŒèÕcãUÜ]ú,ŒÕxOÙ, =ª!—†ƒîV¼§ƒ2"ÁÐÎpƒwÜq¸‡2$S&ÐIÉÁþëÜQ¤‰ïm9MD¢'‰AäðdsRáÃ.!¿&…
(1–Ž²Â‹Êû£„E*nàr¯CïÛšÂÈ\ƒÜ„&/ÎQ)ò@r²œ{î¹J'”Â²¸ŠH®nWõÆ7¾âöÑ~&ÈXõhf‡<í„DÏ'ñÌg>S©zMœWzëçtOÓV
œä]Çê+ G0¢çÄ¤†ªKÂÉG;ÖT˜Ë‹y&BÞ¢|±TŸ)ï#ù®t)Yù‰sÎ9g³Ú¶½bjücûØCò‹šæ‡~¸µÓææ¤¯\£<ÃõÂåÀ*­¿€¤IsX’©zm¦<ú‡}<îµLª¾¯F¤oô…Èy¨—=ùÉOÖ1E¼u}µµµµµµµµµµh»‘Ù á°ô²ÿenGu”ìIð¿ì*á¿ö«¶”ðSLg0mª-DPã$)
laJr2£€r@`´MHÎÎ”9‘¿ctvé]$r³nèæÁŒF\#HôF„²¥›¥1&tü¯Ý~žÄ¾âÚW±ÿüîïýÞïy÷‘†Zåw¿û]i—îxÇ;"€ã¾Ið=F¨DÀ{7Å¶¶}bbÏqWQÿ~.Ñ‹ÓÇ7E³8´J_”xw‡ØHÁ®Ô^´_!>\†PW£·1Ù[(h©aÍð¢]*B„=ñ“ËÆ\d5¤GÁ# t.Gb1Ñ 	WÙºrÀÙùoñ¯# R- ^Ào¨š5yáoBÑ‡ùp0hç¢åÒS>úè£E¢D\qAå°Dgs<ÎwÅñÐ¡Ñ&5ÿkÆŽ ±?íE¢æ1”;P0âÎ¦càk²žój9à,€ Y.³Ë6àÕdÝ4%™¡;ÿ(œöÇ_’bÌ©OH¨*sëä93÷ådÔ6’oÐ·´"2Áå#irÕUW%÷C£ÏûÊ*XŠ©Ü²„öŽ	§ˆ†$ +íœëEh…¡!Ôâ
Ê†*!cs!ï/:ZÆüÌ“üÕCùo©õGÝÄÁG‘m)åv7•¶¶¶¶¶¶¶¶¶¶ýÕ&ørýY¢¹°Qªx(‡væ—ÍI6·6«¸Ì¶(vÚ6Þ+Òâ9ø/sû÷sstÎ#ÈBt“ñ|„'ò/›Ð¬ÆJñ­ìs‚ ”äè"lDœ'l»1<|) =&°*Ð;Ûî¨nÍÐÒ6õRÙlç™ó+x@öð˜;¡uæp‘­‚ýSÔPŒÂF‚ó¸-lkkÛVþ6^<ßœyå+_ù½ï}è„‘MÇm
€Æx×Žc—Hn`ÍÅ „}"ÄQ!É¡¤œäS-ááJÂY€M‰Øè¥¬Y†DÊÈÇŠ3x:àŠ#„ˆ–¹c:Á„GegCè¿ÛFŒéz$®G@¿ mÔÍ=¹¡8jÄ–¥À;z£€Îò›qÀ[IŽPŽÂýL5Uf¶Ù “›c² >ñåƒ ƒ—›ïJ<jÂëcÖ+YäÌ_I¤{@Ó|}ôyÌ[‹²4ßrCâ?Æø¾á†"<e^SÑÊ|¬Ÿæwn  ´¢áï˜‚­wwŸLˆ•ù òY©è3_õSŸúÔÙ-nžòöÕ"ÐºŽä}òv8¾úê«é]US#V}çw·ÂF®Ëhš¨LÎº¿‹¤”u‹mÔDµ(ý=«¾Â£‹^ànz‡•$…Ÿ y=‘'LÏAÜfÖ t[[[[[[[[[Ûþˆ¼ØNäúiÓ+¾²ð›XÒ4@moºé&QÆˆKa¯v³lVÁÍ0+˜ÆþÔ’göyœp‡ø
P»Öà2ný×Â„¢63µûiÎcxõ_/X`ˆäaŸ@KÕHGÆ!Ò¼4\/ú;O•g(
›k U¨:µëÎûÚ¥Ãn ø€-[8H´m•BÊM«¤ö~#ß¼Øv;D¶­í€7«P×ã
ÂJ†wôpúôkÃL¤~Fñ5ah(ÀeLÅ&JªâGQ£qX®a/O³9
â#DÃÈ/8úl|CÎ•˜êdðÀºBš!Ú¼PÔÈ@ÏJº¾|ÚÓž½*áàÊz—Xðåû©
\Hó‚…Ý¨"=<æqu+÷„d©;°2LVšÄÎ`S0ÔûûshbdöjÔ3ÐÞãsBŽ2S¥­?ÌæžB©qM‚~²VŒìšÚFggRPfJ
žR6ídsŠðYÏ²__ÒºHúÞ”8µô¿[›Aè®PÊ—ƒþ_ÞbZZBÿEçnt¥&-A	fí3	NT­ÇP'ò\K‹”äÎ‘A?8Í¸ÇSnÉçX§ ‹bICžøÖÿ1ÇÃ+£y¼ç=ïÑY´ÏO}êSF6*:š•’*Ö1µí¸Æ@´	;>‘p#oÀà Gè¡nkIŒÛMœäÿ°õHT>4oÈø¬è¶¶¶¶¶¶¶¶¶¶}h¶mcÆ¹QÙyñ‚8d•qb¹/Ü˜ é»ßýnèÌ62ûAPQlàí
üëÕ¯~µ3Ðøà2P€äýËfµ°×àÉ\sEï:€ÈØWØš&m`€Çn˜=‰yøÂ¹~b^d:/†sÖÁ_Ìm)<½T¶²XØ6WX¿ƒ üç¹wÆ}WÞ>°G‚ÔØ†yAºÙ¨¤‰[=î±'ÜÝ’ÛÚö¾ì‚<
-GúCCZuÞôý"ôMŽ×€Î`ÅÐç Ê3»5‘v'Øˆ†ÇE½ 7¢?Ã•UP‹YÁ€u£×ÏÔ’,›Üt ¬„5Žð±ÿòösÍ8cpŒË”!Ñ—%ÿa`ë/}éKPÎ ªOÙc'­«Ë€ÐáÎ€u•¾bÈÝHCvke*¥Á_x|YOå×KZz2éb)*F? K×Úâð¦DÆ“ñbµ„É2`—õ>»%õœJ§ç+Å,¨è<†‡÷"€Å¢ëã3Vì%RžWŸfO.¨ºÙúïëÚLåKpz·ºà‹íñg'X€Ôäü¸ÿQ ãìÖý­úàÑÏUèMsƒk!*—;[]³‰2€‹¢j‹týY^½ Ðú»ìnôÖ1âaÜþKÙÆ˜,Uµö|óÍ7K"2»µXP[[[[[[[[[[ÛÞŠŸ5Òiëäx%‚[Ž…WS8¥ñk¶%°ÕÿÙŸýY(ªí¥ý!eÌßþíß¶ñˆÐ§í„O;ä¢§ÙL:c§á+öØ 	›|ÛdRØQØvŠkv~TØ/¸ ë‚ózÕWÜÜâ.R•SZm‚ìòšI«Ú0dÉ“Øh…³Ë€Ë{SÐÜ¯Gi%¯Œ¶—%ˆZí&ÚÖ¶cÍ)êœ¼¯±Q/–}Ž& @s…þÇîY1ã!ÈˆåZ;Öˆ=ûÙÏ&‹ðˆöˆNkŒP2h²ŠÈ>ÑAZZBGe$ãò
šP Ë0âà›‡”	Õ/ÄÓ¤ãb7‰ “ÑØÀhsSæÿ28ƒ­ÃW\q¾s@Ñî Š_àÎcûXŠ”ŽiËÎ¶Ä¦,°>ÜgÐ¬¶œ¯Qòéç’·Ü¨‹“×ŸÎ-…©(Pïay›m`Jàëó˜ÇÌv•Šv±ý—sÚ»x`B
¢8ÜÐŒ–ç,òÈN¢‘d6TøVÚÌ7ÞX·oËö©‚¼ãsŸû\R'²ïÒ0éQhŸ¯!ó‰ü®ƒX´€›Á¾Ür'Ÿ|²+‘zè7¾ñu‡¡Ï;/Öt­µ=À±Ú§
¹Œ»°Ñ‚­ZŽö #¹C£EÃ…Ï£CNÂï^tÑE|*Tš(eó¬¦S1·µµµµµµµµµµí›Ä,œ“¨ÍXQ¡øÉ!C^Ãúu»@lCîIb'£‘,I6ö6üvv!¦ùWå†‚G`?Á ´¥´±Eñ-ÿáËM\ü9É
U„â¥Ü€¸`‹QAu)v¼\^¼ùÒÈÐŠé.Ðy¢n½iÔ-ôI¸Cà$ˆÆ3þ<õÔS³M²eú‰Ÿø‰TÝ'aõmmm«L$Ö.¸€úD2²ðJ¼ðÄÒ#^_a©÷–÷ôC†…ÈàC{:Óú:K8æ	9)yÑxfã|¡Æ^@Ÿdz†z°éšåÊsòŒ™VŒ·™ Ì. i‰ÅIL>¿ýíožö¡NÕr>9 TVÐOÿBÑMDNFlsÓ;ßùNÒ TQ,×]w™hNN¤ ÿÐØ2`Çîw¿ûi-P¹Lsq¬‚áD9;¦FuK\lVÀ÷Hßraz©Dÿlª¥™¦ÍJHß%,¾©WËÅê:Yã˜GÂo,ª\îæ*}$nçÝ ÐÕ¬Û[û:ò¬Ø©šm] $È§û€¶å”K˜.)?ô@´Ï‡Á4inýå)Oy
ÅgbD<sêÄ¬PbÑD“PZ¯„;ÏEdh(Ðsõ5EZ„\–ˆKW_¥¨¦»aúoVY’Wã;\ð+´ËüWÛvG÷™Çâ®w½k/¢ÚÚÚÚÚÚÚÚÚÚö±ÉuŸûÜGJÀÉö8Ü"YìÅÃF‘J hY¶¸ôˆí4líl2.É‰-%¡Í>m&íŠÙ$Ø`ØIFšÓ¨AQÐy‚ÔŒy¥&I‹Ú6"ËK7&Øtq²v	@À÷
ÉƒÁD&épÄy[,Å…®…àqsª`¥ƒÇ"`A”RàTMFÙ“ÙB(tïÚÚv”QÅ!CôësËXÆ#UR¡ën!/\¥T% /¢¦½éV\eÐ@XùWÀ(`N5Š«4a…Õæˆs×ÐIþ5¸°©dÔö]@§ ”f‡2yÓbe@W‰Íçõ`å@ÌÑqòÓ†_óQî†tlê12ç°×A`îé+\ƒ³¹²Ê¹çž{ï{ß›Òá‡î k'´µ¬wù
ùÀœ	"è¼GRP"‡<v2.z˜`â51¥!ñÓk&‘ Äæ ØZ±¬ž§62¿K¨w6Hjl
ƒF;üéZ¾šUÈÞËjAÙªtV_…¶ý7‰ãÒY ÑŠ"þ_×›âÇhUˆáþKYøQzT¡ä='îs«µ
W? X;äVùÅ_üE]U«°€Ô75}S=$-#¹^Tqr´ZF‚¤µøzy2F+7^z;óFüß·˜ôQ† ³¶‡øìí
ßã	RéÖÒÖÖÖÖÖÖÖÖÖ¶6I<5Éq4Ù÷–Id'd lœ„Èñk®¹†z#	1ÇSN9sÞ¨ýÃÿ{nðåp™m¢’!p)D¶È%Ûc`µØZD[#¡‘Îäzg¢bTpÉn97¯,Kå/Æ“‘Ë\L›¾PÎL¬œúÑâdå™KÓcÑl™ÂÚ+R^ýUn¸ÁöÒ {‰ÝÁ%B‰…^{íµˆä€yáWTÊ¤*{¿ÔÖ¶3ÇÛ8˜¤iÂ> d¡ãM”åK™gMXÐ¢€¨Ñxh°2¶ ~&÷àa@§;ì0‘1ˆ¨g¾Lˆ-î¡9ÅŸHÐyZÿ5$š ÀxÜ0¦”Iâ]ÖIMÊÙM2ê.ŽçÑÈ†ÛB¾ Oæ€Ë)IÇÀ)§+ë+XžT“°Ì~«"bkZ¬^M°]|¯TJr²ùE3E‚fB»–±ÍlëñòØ¡yV$MMIæVÍ#ÓnÄµMÄ^!ÎÝ‰|ÁFó`ùBþ÷¹)±£>z/¥Ar<¨P`z"¢Ô)g@´8üY¯°ˆ'j%Ì’ÉÔë˜7S¹8þó¹+]ìe­XzÚiÆÕdÁÒª’ÞŽ:²žäÑÂ¿öµ¯Epƒ å¢†‘õ$ZcÖaµdt–^Ì·8ÆôÑcþo·X5ußM§†A‡ï,bOã¤ÿ£¿'ñàÙgŸý°‡=lÖ	3ÚÚÚÚÚÚÚÚÚÚ6|,®žWð•ìEDÊ‹@RƒÚå:/@$Š'‚x"EíHZl_	kØ“[Üc©à­”tF¶©£þfv¥hlÛú3î’¥gþ›ýC šB\†½åä"÷-ÛÎ‰¦ó"è<ùÊâw£ëëO@Æûßÿþìa¼ZöÉÙØ—†ÆdëžWk²Ï5xBÑ_ûÚ×B™aÍ‚¸áø°µ tèmO[Û3B§ðVH"µ‡°VQ4AçúÖ £aìÆEàØÐ
5’ÌvXúÁÓO?ËÍüòùÏžß‹–díLmŠÀ†J˜”Ë A¡ÿë¹3
X¿Kõç¢Ã˜*ãKÕ@A;ZÏÌ¡]ã¡j |æ3ŸAZ'$E¯6bìÌ3ÏÄÝŒ’H m÷ÿ¥Öâ±p@ ;rÕy5OŽ"Êaé@C2‡–à€ÿFÆJ3ˆ†U|·ÐX¸sÞZ .×¬–¥',¿¹†zý­	ãb…Cáæª»d¦”s¥.!¬QA+(ÓâQ€Š€Aç&£Ø%‡—¾ô¥ª‚‰ë=ô¬ºÆÃ>ð$¹ÍÉIGt—Öhe¥Ê4MÚùT(_G”+ãR*AF|ü–¦‹â<É26é¬éM„kœ÷[‰áCð+s³ƒAÿøÜºÁ´µµµµµµµµµmøØèŒ,X€ !áÔHå·
÷I7âl‹hÛF\-¨ñœç<úz–BÐæÓ.T®ÕÅèiZåC¤\<_}ƒ(oÚdQ¿lƒ!&	p.äeÄpÇ\‚ÙZ/Õq^åoS‘ÅaÓlLûiŒoàÑš[®2‚G9ÃçCÚ‚$k"´óÍYúõ¤¥Š)ÿÊ4IíØÖÖ¶ÿÂéÅt ¨?úŽni0É¥*n€£G¹âÖ 3äBjŒÌŽ…“þÎÁPÎ:ë,S€¸¾ DÉÇÈVÀ©IÐ»€Ë“³ 
oò^ Sg2¹Dzý2Q†JuQ.©ÆêJQXÎK<âÀU¨Ðˆ–†k£½Üh ªñÇäèl,ý×–­îÉ ßž$3ŽÄ<ëá_ÿú×;YrÏ5	ò@h]‘p×*íº“ŽÏ+»ƒ)˜‹¢òÜ®	dÊÖÆÔÔl7˜¡çŸ>r+ ]¹%Çe@¹&!MAó*×+è2Ñé)º[Ê¡^šÚ4¬¬dx8Äf•bXÛN)€?á	OÀ£W›š(ØñÙÒˆ;A7CÿûßOc'è•Zlñâ€ICÔŸýi!ZŒ€Ž–Kµç$Õ08î†B!EW¢ÍÕ$ ÐM”‹V¬¢ÛÚÚÚÚÚÚÚÚÚÚ–obó	kSÕ-$(Œ¼nõüô§?—Šv³®“62¢}aæÚÚeãŠæl[ko`[.¾Õ® :`;š t *†Ú¸ç÷]{	_Ï>Á2mÇÊ¸5¡/*2OhÎ‹
Îc¨uEa/ªmld5·y½°fˆ_Û+¯–Í|öÀJ¦hÎŠ:ï¿¶Uv;°{¬cˆÿ"Ð6Yå[¯=ÏomkkÛÚ’qØÐô'·—áøÞF7G]X®£JÏš t†G¸3™ è^ ”RXÚ!Eý-àƒÊ³aÐŒo4ó‘|$\cM ©ç’K.1¿8	¡tb	´´¾&É˜`§Ž7‰èS‚T2ÎáiÓÖ 	â1ªè&çËáÕŽøö6›ÐŸAuR&àŠúŒ”m4p6‹D<Î˜¦'M+ï€¦×&b³•;ä[ð»EÌn) ]“/Rª
‚ç–ªÌfßKdß¶‡”DýïçfšV%i5	`Jâ¸úoÔf¼ˆy‚IÀ—8ƒ§‚$zÁøË‘ëIÐ¼úÕ¯¶€‘à®¤·LÜ!ëRN«MNm ŸI§ƒ;æHàB0ˆÍ„ˆ‰·3*Æ_Rí6m´Ô–z˜ÆÆ“^ÑÚ|xôéÀh¦.¦Ùø9+4‹Þ—¼ä%„tFq³n3mmmmmmmmm~1¦°¸é-a	s–¼]Tíbr%ÁF‰0Ê$…AÛöçàÍo~3ê
URY£ã‰à‚ ~þç^n@›=À8Õ†ÁÎšJ&BV¯‰¥µÊ/®Š»Éµ¥Üˆ³¼¨¡±T%cqËa_j—^jË¹ØÃ‹²\Ä&ò …="Aù¬ÄMãÇþ ¬L”ŒB€2‹DÜ¯„VÐ*E¥<ÁOá÷‰»ßêîößÖ6"Á¼Æ¡o„ËV`¯Ç¼!qvŒM»òÊ+ð€tØCc89#ãƒ1Ó0kÀ²$ÜF1·ÕIö&£¥Q}Ø .g©à•VwJ@v>ŸðA*O˜àž êèÀ ªdà¿^ÞtÉqyVÂ½M¡Ïõ•¤.¹ÏEfJ,úH&)c;ta–ªtµ”óÒ*ÞvýÙ\ý®š"2é˜Ý tËaô’Êw[ïú0Ï6&S¢é)S0è ÷÷uï›ˆ¥Õ8þé×á¼TSN8á„Ù–ô¬)My¸0?w	&¨#™î°¨…5‰…u6´KÉ6sF/þÜç>çþŽ6z¸e©Cõ¥GÎµŽÕ¶Âx°<„Ö¢jSúZyâ2Ät|«)zëÑ)­ü4 —´"Y©W7žú"þD›õ›ÖVtÜut;òU9+És¯ÁÚÚÚÚÚÚÚÚÚ^äe¤ÇÎn2OŽÑ¦ F³QDžÍÅ7¥[yÅ+^AËô_¶/µˆ·E ²ŽŽ„ãŒAHq`¿j}ïb[ðnøS6œô_¨4¾U¶Áa;ïžÙ.ÚWXå/
4/Í2´)pa‘ðbËmwQ?”Ÿ@­²QÁ‹R£.}É	è<*5ÇìXÜYÉx¡¾h2`wŸU;Ä@1Ê»•¶µí	äb÷’Uo6€Ë…Œª³[0Á{Ýë^Àe²ž¾H¶³•³DkxÔgaÐðPÑO{ÚÓHqÎí¡·8äC01)F$£bIm@ÿÇ¹­Çì…ù
2)mŸ“O>yâ&ŠªëÙÈ(s×Á
=3ús &s ‘›óï|'¹ç Æ^§êHj,•àØ¨+Z?ÿ2‘%Y´!\¸Ø¤¨¹ùS-ó˜Çì¨ˆÞ°ZóàXQ j…™£Ã”ÏÜ:¾{Í¹®±%å VÁ¯ì}“Ñ÷Óy×8£)®æÚ×mÝÄWLúâ¥ˆ8g±)Ì=W^~ùånˆÊž\ì0a£å5
p{ë(¢,v
-ZQ”ÐŠ	Zhj-*«)›3Ã¯ÌnñKõ@º±i9¤Æ´à2Í7v,åÀ¹½2•‹Ö%ã}™$Ãt™QÂªL6láh5Ý1¾!R-q{Ð@;ãŒ3ƒâÈåèPï@¿][[[[[[[[[Û2d:ÎãÀ(Nâ-µÍÛÝîvôìD’·Ã.±}µ·j%ÛšÒ¿³"GÆkFÛXµû¯3öuåD8N6¨•È>¶ô.Š ”Ýo$Æ-öÊF	 ·€Æ_³‡±™)ÚKv2¢}+ s¢é¼H'´±Ir0›€…·ÝòQG%ÅR‚[Aðƒ‚èX¥ŠC}‡­È÷ØÖÖ¶)[Ô¥	SU{ä#Iã‚b/œ÷~÷»ßÑGË}º÷ÍãÔÔ€6"áâA§#C¢É|õ«_¨ýn—ÑŸ…€ûi`7çß
ˆM™‘LS.=£œ7%¯<–ÕžêaÐpmú¹ÌA„‰ÐT9,=¿©JT>ÊªÉÂØ›ÉÅœ•¼s	[YäAoTz¡?ç_¾h^ˆÞ±iNEC½=€<u (øìqÇ7™F÷¹á>Ë»`Š0.÷pRF÷FJ&h]•@Ú€I0zP€9“dÍTî$v'v9T×eÉø·¢ôÆ)2É-5-O­KÛTë*×‘eFžPE‡Ûž™Ú:$µ<¢ÞÉ8©k_G@v¯–´Ì%¡ä Ü@R¶’ÕÎ1ËQšŠºu&j?ˆ×
GFU½ÕpÍSžNu]@k±:Íà`‘©å,†ÓÕÚ/Ã…V‡ŸûgÀ »K¡‹zê©àâ‹/&¾±Ù¸‡¶¶¶¶¶¶¶¶¶¶Ön{ì±vï –·½ímÔ„ô á’Ð|€¡œ}öÙ4¬Úý‹¢Ý—oÖD±¸‡«ú´5ÍºÜÚÝþ­örÙì1Tëû‘‹´¨²7
=ÇõqäŠ|Ü2Â²K z‚AØ'ÿR]`ä¢6yÊãù´‚I…ç[þ„^ÖÕ+0L/o¦L
?…Tá)áô•vs¡Ï£šmmm[0= ¬3Îæh&Ô3TwOÀÔP2˜üOTeu ÂÁ…O}êSøq hDW×°‰ìFyF…‚‰ÆºÅ3%(Äu·'žß :êý´±&È·…9Tw9fzeÒüoÃÆ .vêÎ¬GìUW]å3]Â„½ƒ¡œŠÅÕWÃ5Ä76(d”%6Òe
Ïqt.&µ£7¾B5Î‹õ¡Û z&ôì§fIrû¬ÇÛ9ÎBõ½7ÙÃù-gj‚&¼àÀô•ÜÈëõµ4k-Ù™“Òm—Í,×øŠ‰•«^/?¤°ŠkSÀ.g9Ño”©â³¡ «ó=TÄ’w7{5Hehàjß
G÷‡*ÂÊý>ÎëÓâ1N8­åþ÷¿?©úûs{Ç;ÞñÌg>“ïm(S‰iÚ›¶*bÏg™-M“Û¹Öl2á4¤-içV¶	wËšKÑ;Þ“P’1ìÏæqÆŸ‚¶à\ikkkkkkkkkÛ)›íu.(¤r’æÈI¨Ùœgçæ<––íð¾Lªæ}vAr¹<ëYÏ²²‡[dÛ˜Ù©ÚŒÑÙD7³·w>	—þ|nI^,³²ÿkn‹"Ë	.=^GÓy5‹m—àKáÚv¡Ù±ÔÖ´¾^[ñlZFÊ³=*-K€Ä
ÿÅ§ã‘÷‡<…|£ª¬ìŽ{°ØQ˜H[Û:6Q
Zz\Í{é8I5*QqOÍ¸G7ÃX'¯ˆxLj	V0î}ýë_×å“ rà0î¹ß/ØÿâXâ½#‹iK(öMoz9¡ß°l ´Ÿ‡âÝöŒç(~pOa(8yá&cï: ôj½œ5 yeÿ¥a‚Ø/Æü…ÈãªMè!5Ø¼€RÝ
7vœ›&ê%A$#[x4’—‘uWHn, ‹C[Ú1ÄgMBœÐ¨$¾Ï§tœ ºd
ˆH¤ÒÍàæk%C«Ziä}½£ qÊ«†¡(L‹`wy×ëåTž¸7’~¡ü$æÕhåTG[@èòFjAûOò·d$®¸¨1»`=@É[>‘Ìòú°H`eV2¡{‡?‹j-Ý¥\0DÈûp\MEÞQÝ+"©Gù3¨0s±~uÉï}ï{paÔødÎ´$S¹\‰Ei“Æ:îÃˆf,. G‰ðj!úHV¹Bútw0&à<G aÇðÒìø¶¶¶¶¶¶¶¶¶jý=&¸Fásn.¶óòBí‰ïÏVJZ$«v«gœø8µ_ÏÞ¦ªz°¦·SÍV-‹o‹øìG¦XèT»$&ïfxø
ÝÒöc²òÊ¸(ê7n¹½o¾R_\¼³û(‡ìmÂ:|ë[ßªxmM‘¤pˆ–à’°Ó€›æã´íCßˆ=-Ê°â1àÀà&ª©Ê,«§Ž©?Š?ÌžÌýÆ»†¸
¤à(Jîµ¨*Ð<Œ‘MTG¡“:»?]ÉÑiÎ
Ú=t@Çãv‚Ó&(x~3nvkGà–!ß…q¼æ5¯ñ»PoO²>Áy#ÇÛR¥ãÄ²`C	g·V½Ø™Ví"Š°…Øa‡)ÿ€’0D4z»†¡v¼#É^àãDûx”‡2) ª´Iî‡#Ž8B^Ð'w,¥WÌkq-ÅäÝQe“¼Lf‡‘áƒY“bA Sp[XmEfskSJ°W=BKÐ) Ð:K"Ÿ‚üŽ¥·"ñ`æMTbáUò|3‰øÙr]‹ ˜o(i±~K„:†’G¢w|ÈŠ£RQ²ž,]BÂur ë¼ìBŒ-ˆö³–àØ×¦¯YÄ’à ttî¹çrÅi¨´×íé’–gê]­E!G7\sü9ªYjÏ•—5a|“±qLÈ™ìWÜSÃÐô&íG$„%´G2Ëä‘ü(mmmmmmmmmm¬¢1ÙËa7ƒ*ˆ„"2Ët‡þ,M“íÍP+u`´MšE¹ ZÛu»8KvËëì¾’®*Êµ“,ýÄ‘d4ò›¶]c %Oµ¨+]{†ÊÇäæÑ½xhq9È«œe >vÝ63hà—]vêú¹„8¸óH®T#c]4àÛÖ¶e›¤=Ùr¾|Ÿ¹y€ä/œ„JL'ûy¡ú&ò¥G#/#«â&
ôeø”Ññ_æ@<`í=*—ûòöV©Àî¸úÈwðÞ¹y$eaaÑyÏ3ÿÈ-¶årð^Fo?êÕ|Öƒ-j¯/=49v«Âe0ˆ1iÖïÎ ¶×¸À)[þ?ñ(è±ÎHWðâ¿˜d
SpÏ3þÑ~”º”QûÁœ¸”®w69ji3n‚õìÎõs4¦Ý{5j ;vmÆF G›G9ú!«=¸™%5àO|â7Îòîe-Ì}ð>îj…£Lâ¦Ý¥îsáÂ¦KKÇÜ?ª “æú`nyßM¯z(¼ü%ƒÎù	±µ8©Iâf *Qñ|,½>r%†/ëÝ/ºè¢Ù-:!@ï«ö\¢dØÞÇÌo€‚_äéOºq¸êQ¶²MòIÍOŒËXËþe"(%èQtÕŠboZ2èØä¢› òû3ƒC¯÷ÚÚÚÚÚÚÚÚÚ´UøäLHj¨X”ïhØ"Ú„cäY%ƒM‘5l>er—+ÉÆÌöÛº<A¸!/[OWÈvËJÝºÜ’[$T©Rj.®PïCôy…XÇÒíÄ¢øcÒM¨ÎØ™D0ÿE¥œÍ}ñ›èá~)^˜š¹ÈÜP/KÊ9©K¥÷$mm[6xSÑKú ¡×ËÔ‹Ùzå•W "œtÒI„eÅv uOÿ…#‡ª™°†±§J-œÇ
Ì÷_ßŠæo,|vüó›¤NŠÉœ|€oÃi.aãirVÁì$$$X|È!‡lm@ðìË¼àXÛº£œ°²øå«ƒÉ*7S€iÂÃïf*Å½@Oþ,$4 j6W‹æš…Dó¼J–XuM¢Â}à°“R	ÖÏéÈ›‹D®} È(õïØA¾é+_ùJžå°F”mT
¸µWðbúæÀzX›®ÇuÿŠþ5êZ¬vrhQ‹
åé»‚±0X7[h¹žÌ‚…Jr'&4ÁCVŠH$}$ŽäÂ­jÆK:¸–Cý^
£'í¤·Ž|´h:	ð¾mÏézˆÆHÍª†o|6=â3'G$Zôž6ÆkÂäÀ86ŽoÚ¡J×t]Ï+Éï¢êòqÚ˜Õr“¶Á{Áãë†'áñ†”Íê˜·µµµµµµµµµmç~¸8;%cZ»—lÇXþ5îp&¼ZÍvA½sÆÚ×
V&o‡­†dÇøÌ-üËh»,kh»2ëuÇ‚pƒÅõiTÀ´ã²4·@~ÅÒ|>ãnmïÐ‹i—¦q™ìTµ×e fåS˜ÔÈû³±ÓVhN‚¢§AZT9’v¹ÿ¼ÃÜºý·µ­	+ÔÀ8Q2RÌ€ávý‰Ðªc¢3ƒ„@ Ñx
Ì÷&š§_µ8=LðÙÅã1§èˆ5Œ”·¥ü¸¹ðH…`Ž9TÜœ|W; (ˆ¼Þnëßå<â ÏNÈ9`%	ôŒWÅÎÞìð;Æ„¦Œ¼H¼’IXå=ùÉOÞïZÔÒ3†åú—v…ÔLLƒ|Š÷UGj§*NCBrWšø•¾¿+?þø?±sÞ½f(Ý'Ô{YX-P )Fð(F{ÊØ_´1ëÀ±þåÀÃ¼zx¥b[‡íÓÚÃŸÔ<,Zt®”Ùf$ªê½x|õýqù1yf¸9×Â„»jýcE4zÓY½xÝ$kÝ!‹Ç˜­DWvx¥Ø³Ã8M Yœ~úé¼bªO'þÂ i»káøìVnû²’ŠNã@²„ƒ ÇŸTíÐX½£Éó_±Í‹ù±3jâWÂÙO$œfï€³Š‹1âò”ëtËïn!mmmmmmmmmûÌFÐyéþj£uêäbæ‡?üá¶¾8€èWxLÍ"­¼­zíl´s €²?—9«j{*ÿ¤VÀì$)Ð¢0Å"dçØøð¡_Ù'u«´ürY.ƒA+¨Ú~Àâ•´†¥ÄÜ)%A—ÙÀ(|J)Å¨
Îæž€kŒÔæÕ€Z÷‚¶¶¥C\åê&‹ã$Ù\Tmøõƒ¹žQ8õP€ åu×]—±.ðñ?ŸŒ)py×V§æÍ‹çwÉîG$CMºGô9a%ÿvnø´‡³[§U\¸B‡{‹4JÆÚ oà*ÅÛ­iëO¾bN)Aƒü×ÓšPà8o°Ú²¢Õ+dZ|Q¬Òº4*­ˆhÉ³6¥ˆ¢T z¿ 7æ!Óº<<Ô€”Õã€Ë¢ÂÓÏÌXìo9Ý
=Æ§X‚»Åµ£Upù$~h—m¯à<ë†òñÖ”º~rËqÚ%ß1AÒÇÄØÐyœ7Ýó¦Ä—<Žž_?ª¾)j,«À‹‰c »“nâó¾/ªöÉùU±ö)Æ¤ õ¨ÐõhR°rÃkæ3F§rµöyi¥+©ktœO#™DºüåÜÒÆ’ ÀIŸhÔ oè6 ZüUz×T[[[[[[[[Û¾´\€#17"¡2#ap8)®Y‚,ä2È²ÔFD3hÏæá¥T>…	¬¤(
±àÆÕ‚8["ƒMm“l“+[)è†w»öÏaÆå_VÞÉ¯5*™N¸Ã“Ô|EÚ}ŒmO<8a)ú	Ú®B\ò²°ÇöÞ6Ù…Ú3(7Q™HˆÔúBãÂšüä'?©
F(vÿìŠ'hÑ.a£YaÚÚ6?NRóÈŒÑw¶
8×¥¸Ài”-QºsÜKA
œ,8É™J¤¶4Ié8ŒŒHîj•ä5õ+
+Íh@	07ð4´b[Y¿øpH"GcäØcåC‚æ‰Ü¸“‘¾ðEyÖ“+É•CeU= [ÝfT‘FÊYÙ^pÁfê×\sü}vkÇðÛÓ¨29¶´à^EÎª@7©¼*:"3ÛZH8Öt·°ìQJ­=4’$Q ÏBÎŽœuÅ:ó{~°ëÓ´ÚÈó´Ž™£Cpöxž“>°`á†¦u:ÕÈóÊ£tAÕð÷À‹AáÝÇûþú¯ÿzðkÐ¤Àgöœ¾ºí‘G)mYTÂ(;k«êÑ§c 0hØz/Î’ä¢Ì²PkÆ´qä¬10-aœ/øKP­5ÚŒäÖÞÎ»­öï2…_×B¨tÕ´µµµµµµµµíû}àì.Lgèùæ7¿ùÑ~ôoÿöoÛÕ¿ÿýï—¶ò½ï}O˜§ýy‡»ÝínÎXïZC[ãZRã¦Ù&ùçH&›+DSÂ‚ØÂÚ¶Ðwí„ÂSñ†p
3î¾6â8o/^¼' h”8€ÙXæ¶‰¢U¶¸¡n9ï¤rK‰9°OPà`,[UóÔ§>ÁYzFl,)¤¢0;¦;›Ý¢…’Ï"à¬Ã[ÜÂ¦º­í #kÃ	¢o oÒêá,i´0‹!M:²Ñ,1ò#ùq1[T!‘ªX@¯`@G¤h—×"x½8è/òÔZ;Q£Öí.Q­\€	%uJBú;ßùdÄ€¿;A*5TqQêŠ_•šöCúPr«%màáYs2tWÓt gcšEEßÆvµO|âñCõ)he†å©PEóÔZN,6Ý¨u¹ÀÊÐ©\‹pÞ_ÌM%q>†­Ã€Öþá~!ºXØÜ½³õ‚ ;—¼©<^(O)†­{¼ñ"•0	äÊÓ&éh)þ§HB‡úíÝ7yT€³y@F3 ÷a'Uòrh#p<íiO³ú5~š/ÀÊ&…P˜™Ç}†/ˆÕ]©«•?Ò:ŠÞY=fi@žÝ¹8æïÿûÔWÜÜ`­'_Ñ’Ÿõ¬g‘D÷‹çíIâH]Smmmmmmmmm›°Ú]OvD“]wikÔÊx‘-;›“t|’_„r‚Z€ÀÈ5v_pÒ$ö!û`›› ª†k•2ïFÙó*m`Ì’º ›hŽ¹wì ì'G¢ÇšéªV+8}©:êR…èŠù-ÑÉ	ö±TSu²,Ô	/šŸ´QÊêñm	<Œ½±ÐKà>BŠ].ElyÒéeû/éØÔš9Ê¹*˜\iÍÆ}Nw„¶¶hÝìÖ¢œ…"Mâ&£( ™›‡‚¹BöÒÁQíÚÉ"3Ô@§×Ì±,g¥Í:I5aï®Ð 9[ÀgË•µYi‹ETºÀð;ã<Ì»ÖõÈG>r°[~/ÜpA0¸{Ø¬øÔ¤HÈ ŒJ#»éá¶
Ö|²„QÒý˜ €^«^ñ_åÏI~ôÄ=¹“ÍÔ†(Š#/ÜâfþU•Öñß¨n€Glú]ºI¢t@`® ªbIëžDH,K\É}«ÅNÓ×ÑxñuJ°lÜUÙA=ÛfgÛ1—F”Ö=dB"5Õ²*'#^¡-J€£:Ò[y‘ÿ~‹#~j)…[=6f@ïå^™Ï¬Ó¬¥MF?K;!k hMþkõëSª>•®fµù½«GCnÆ4˜uµb õ­ä-*MŒ¨¢	‰{@º±ªµD¸'±¼Ô®|—²ï`Ðmmmmmmmmm›°¬ÎÜfnc¬è
„%ÜÄe–ÛÁV¶(;%ì	`AÈÖ²2ðÁ¶œÑÆI
_Ø
‹ÎÆjbÑ$_J®G£46Ê¸-Ú¶©•|Äˆ'I½js›ç™ ëùo¨U¯'ù¸Å}4C£û›^…i`?`Gýú×¿ž.³¸éŸþéŸ†ì¶üà«ˆC=T-¤R$i¤|²!mm;sœœ- Ð³e™ÄôJŽ7nžãŽ;N¶1gÛÇ?þqÉš‚  73‘HE.¬F£bý¹Z£"£·]k>Ê¡{(±ªAOÀ8à#ÊK+Œì)¿Î°Ãwad¼n02ÏŒŽRíî‹&ÕœbÞpÃ«ÁñƒÛ¿L•=éIO"Ÿ¢£i*QyÖ6,3BíŒ°Fþ¦ÑLÊà<ÉI˜ZÐ·Ì¹ŽÍ­7î"ðq ½õè“ÓÑÈùÝÝäÒK/¸~75øœþùTÄ¥®—¬( ÇÚpÎòÌ!5GXÃ¬øþ…>3ç<®Wt^¶—
ûªß%øŒ=âÀ9àlPYÈÖrÆLuÄƒ¢rU“*ƒ›S²ò´4-V{MY…J€ùaªf£!Es†Àt»œ.šŠ9Ksu<#ôÅªx3š¯x¼1Ux[[[[[[[[[Û&¶šã†kŒbLÁy6Ï½.š5kMà¦ÑÐÀMÔ]NKXÀ¨Å®•1¬E’âO*…ŸZÚ"A‡¶lìO_Ùg#Õw}íÑ¥:Î“|}Û@×oYÖG2oDÀÇ¸øìf³õ-ÆˆÚ0$ßKÎØ<$„6›ä”ÕÈòckçànbÏí
 ö‚‹Ét¦Dp®úªmí4/‚ÎcB›¶¶¶M‹ˆLXž|{ÜÃŸÈeð/”IÃ`F5ã^üdp1zÌšñ*ØAå]¯FÙg¶Ý¶]†htÈyM † pÈòŠV)óÇ>ö±pZ´bÌ×Í7ßL¹>BæÅ¸-	cß0Ãì)§œ‚Ö7k_Ý~h- ZíŠ‡C×‹ÌqMÍfÞxŽGÍW83ÌÔaG`WsmºÇçaNßB†=Ô–:’[œuÖY[{/0"fàÂÈO{Î[—ŠNE<`°&=FŠÊ~‘ã¸Ãk¡¥'BÆÓ»›ÛÂâƒYóp7¶¸¯¬2¯^~ùåª#«eôyNMŸ<ÚªÑOÛ6ªq3Šs+’‡e9¥æ§ýªùÑ7×fÜ3tf¡.rîÂ/4£}ó›ß‘ŸkGKÖüðHÄ5òÒÍ–ù_ÛÚÚÚÚÚÚÚÚÚV+ÙçßùÎwÎ:{(Q~øÄšß÷¾÷9i1jyzÙe—}õ«_µE…@‚@¦°­²´µ‹³åóé8™îìŽÂt	µâ‰šD–‘ÆÐòõ7x‹ú§{Z¹vqyò	É:©ä}þ‹¹Z"Éè ŒbS‡TR÷Ð'Ü¾vÊÙfò½ï}/ÕìÓç&¼Eš3þ ýˆãê?Ÿn>IpäÌD(à §õµµíŽ%iÉæç¦‡B’xj8ƒÆÃ«¯¾;L»Pèp‚•ýiˆHP|Œéþ¹,9Ó6¶
‰Þøu#x[€ì‚wã+Ò¥o«Á‹N8ãW:¾îÀGe(YánÎÇ©¹;jÈ…3òêq¾šg@XØ~„ÙéƒPcµ™Dj9(8¸Òî1¸›ù×I¨+ÇCÀ=àµIÙbÆ§>˜„„+Ó'–ù•|ºÍÿ$>ì'~â'f[¢–p@‡W@@ÔTwàQ³û¬·àÕ»p)€%{ó_ÍÍ»û3×»sÁë0n £÷ïÆ¿¯¦‹4MrÏ~oªÃ|qÕUWi¨VÔFª,)5ox4ŠÏThežt‘SmÆ¯é3Ú2ãÄ‘‹™ÿ‚§‹ãïn~Âo¹ƒ>âÌë^÷:Ïvøá‡?ìa“;DJØœ	Y»k­­­­­­­­íàµŠŸðš÷¸ÇáÑÌ–E‘¿øÅ/¦.'+LÙÞÆöÞbE”çäUw`ašAÏ$Oüœå/M€†ÀÖ»è?¶:‹$å¥$»MÐ“[„Ž¥0ôF\éÅ‡Yh^ü­±&ÕxVöÎ(‹þ¯}íkö	ãƒæet‘@ ÿŒg<#¦µ°¾÷/¾2ÄÞB’Â
Ä[yÂž0Vëas›l_×Tiœ(¨´µ´ã¨æ<f×œ€Yy’ô4tÉw¾óø_Q˜E¿Å´{7 ?K˜~iÈEA¥cÖ¯‰ŽP.¨ó‰„Ø¾´mtÈ­1Ÿ<ï•Pnø 	ÂÌ¢$WW!{³ÒË_þr“P/Š‘î­ûgêqÛÝ|`¥)r¶qF„ƒ¶×ì/
}æþ	Ž ¹¢
"DP0t¦ø°>Sû&e½XÓ‚ÞÆaœ„£›yu¬5ƒ›Hz¡9EÙø 2–®+e¶F"ßÅ’—ƒNþX¤gã„&evÝu×éqíç5#'2ñU9T¦MŸn†^Ä"KbâOå¦4<¶¥šŠZâ Úöò…d ƒÖZ$kµtÔŠÔ—ª!yØ!„Îj\e…ºá3¢Ì8Ë™/Ò\oŸ<(K‡è:v+—ýÙÜª¿ÔWœô+V¶h«Ñƒd[[[[[[[[Û­Ö²¶.³9¥‚”!ˆ„¡@NglíjH7Ðn…-tÀ>Q×®ÆújÖõR¸sö-Q‹+ãpj&@p ƒ=LÔ'L¥‘4‰E?êÊ‰Æ›Oî™Õ¿rPÖúŠÎ.¥Þ·¸H»¸OúÓ4I°#©7^rÉ%ˆuw¹Ë]„âÚ@’.¹þúëA0’›‹g¼ÛÝî†PIS/Õ'õ¼3£tFc"mm»c€ÅŠ…h8bœEsó¢‹.šÍgÉT¹‹ðmsÑ£àŒÏ¨ï É­ÒTñ$:Aýimd:¶,1´3­8Î¦Œ`^¥3;ÈLð–t©<m`hñÝ««ìñ¼¨sSÐ$B|~“òÜ2¼ÆyæŸûÜçN>ùäf=ïwëœtäcŽ9ˆlòM:µ8‰+ò€ï|qÂOœ|}Ñ¦Å»4T-ÍÜ=Êa­••A€Ö³X1ð;³¿å-îÿ’÷]g¯k }"Ò’M‰+ë¿e´áÀöðE…öÌé)K»FÎpžaø
˜2˜#n²­ÒÓ=-Q„»eõØ¶wšñlM‡¡vŒHRàËi½*Ë9H#WeþCŸÅAˆí©\#0´T¹^ŒeéÏÕæ+JÏW.~Ôúÿoxƒ¥©[áOd7qì±ÇjV¤­­­­­­­­m
¸PÌ´‡!n5	î”b‚žc¿4Ñ€4äÀ6ÌNÉ~U°b#‡žJ/Xœjó©âìÖ’¨gÂeùn–ÅãÖçÖˆuëoüVà59“øÓÅL€¶j%ŸWÿr&±‡u"8€’L/6Pæk®¹Æ^ÐL—9‰ìâ\†¯t÷»ß]-ÎxÐƒT8×RÙñdD3&[ÐÅMi[[ÛÖàªìó…Ã‰Æ:ëÇg„$.$‚}ÒI'AH“F?~;@€cƒg×õ÷Il„£Bþ·q|ÛFQæmDœK†(÷˜,B¢£Nˆ±Œ’øîpQá#cæêÍ(*Ý|ÄEªðïRçâÖÊ'ˆyRÕõ«^õª#<²Á”ý®GƒÃ¸ˆ¨µhxjþ(V“Ð­UÆÈø–htÀ¢*³æIÛ†÷€×‘šñ-œ}2F¸³õ•ÁÄ³ñ1ov¯+TÕ}öv•„ÐCšýƒ0 ‹ôíÅ#Ä±ÑsZÆˆÞ(ÀÚMôG_ÑI_úÒ—ÊêqñÅ÷zcoš‘ç¶·½­Ö´‰,2­º?üáÇñOƒÏ4ÎœQé¼¡W5àL=%µO+ß"Ùn—úCó/QšŒØnë>dkrÚž–ÌÿŠ?!õwˆH ˆµµµµµµµµµµýÏµ,óÐCÅ—‘²É"•0â¿øEG„>Thû€]7 •FLŸu­¥§ãÿïÜ‚³„„äk5\ñž‰È«Ìe#•¸Rß,’àÖ”]P¨°ÓÄ.ý¡b:WnÀÒcuÒ"Û:>Üí2ÿý?çV"Ÿüà"¯}ík)Pf¼<ÒØ¨ÍèN)sºÌgœqÖ$`%	|&~-ê2&ÇmüÖàmkkÍx'ŸÄÊ§‘·ËàãCúPè³žßáŠûÖ·¾_6\À}Œ–ÆO)ÀI0¡°h``±]êÉ´z’ •À(RãdavUÎ SˆeG}ˆë¯†ÞŒ¥ýèGq¥±;£`›t¬Û¥õŸG5ÇA·M|2$$¨{ÊþeV5ô`vÀY=4˜rX½‰RÒrÂî{“I?©ª¹¦­ÌÙÐ›òq“¡àøG(†ÙáAkT³9ˆ¼å„úY{xÇ,ÉŒN•Þ0ë/bì*ÄyQ£¬Èàõ^–|ÑUg^Ù=uÀ÷Ö6
ó>÷¹Ï¬è½k(Æ¨Èò*¿Á°™aJ3N[ˆ°QÔ”®½‰I½!…ãhucBoTUŒ€FódÌ´àO¼c…ªÔž“~+‹j{×¿þõ¨,kÅ,ÝntÝµµµµµµµµàVðåÈ–AÌã?^èœM…­ÅŸøDh©}S;ŽXÙA–›Ñ˜ËöÃ§•k2ã-ÆîåsÌ,¿(a±eºßÖ¾,É~l˜.ÐÐ–Ká®¶ÑÑsAI"(|Ð	oR K¢cMÚR:¾ËÜWá8,ë“ó%5;Ši,ÕŸmµ¶¶¥Ž–EwÎâx¸x¥Áðˆ#Ž€RA™áÎ¯yÍkl¼iàœyæ™(“èŠ®±u—9Ð®>)U}âŒœ¶ß6áÉÝdœq T22„>&jéd* œÅXŠ/ß¼)Ð6"×°àŒ·ã0;Fv×œ“
MÈˆÙÇÔ#6 YžQç“j%@ÄÍÉK*‰P/(Lü ¥¥°úÆÙjQ~!ºÀu^¥Ëñe<ïQwjÂ%f%_…Ö’Æ¦SKöm˜.©É%/E­U\ ¶´7®dV$X}•Ž¯9vÉõ8†!òî[eÉèoôf­ÜÒÖr¼_Ör9‘†ÏæCaDÆC“Ì„“‡,?YõM£ÿ:R‚ë='™5‚N"}ÓXËÂ¦Å½Ó’spÎ9çÈ.¨Mj¨¢mŒ®¥øÛŒTa7g­?œÁƒ$kø¬Ø“Ïv\'qË$-A5rËæçÑ• 7.÷çÕH.q-Y<ÙçÒ¥i™mmmmmmmm¾ýÈ-6ÙŒÅ´Y,¾ýío·‚Œ>àÇ?þq
YCE€ ¢rAcká»‘–Å$Gß–%8wß’~Ê+9ÙK4j¤ù34çD[û´Gµ^·þ¶¬÷KyÔ77t«yøòòˆ±¬·«„[rÊ)¹Œ¶¶¶½¿]/ßÛÒÎevž‚3Ž-Ð˜¢;C‚ƒ\qz·ñM—‡‡êÝØdOzÒ“H £ìlXˆˆDŠ@<%&;jøPç0œ†_¹Ëd§;
€#²Fþ5uÆÔˆÊBaP7J…ÌÔZq3´M¸œÁ§ƒþóä-­_ö²—½ì…/|!— ¡ ¸°Š'£u´«Ì=!Ø.=ã·Œê÷ïþÝŒÆ šÛvøúG;¡ª,ƒ‚©ß:W4 šeÀW\Q™~#ž«³“Ýê kHk­s&±ë Ðc¨Vt?ü¨Fî×9Z`ˆoÈ™A|Ãˆ´å±îx€|ƒfÄÓ&šÔ“'ŒÚ¢L3¼k%Œæ€CÝªFœ‡216*@å¦¸Œ~òÎ}Þ+sY-Ý±æÍMË	Q†Q;/J´óÖíbn¢cþâA	:2•òƒ:õç	!c’ÑÃ:j!”ääÇ>ö±¯|å+~N‡BXádôs·‡¶¶¶¶¶¶¶¶^¼NI‚ÔÙ$¯sðò—¿ü;ßù|$;® ¸{Ö”¥o¸Q¨ø$SöÒt#°7á•Eˆ$ÜŸ@E•Š0úžùVvVðw;Uÿõ;.kzá± Ð$‚ "œBæwÇÔ`‰i@"D¡RB´7¸ç=ï9›«3¯ÖÇhkkÛ®ñmv‹kméXW×vØaÔ3DŸvÚi‚ûØÇJ$xÖYg8¥ÒÒ©m§)ç*7 RlGËÈ 3J2UPQˆ†£ÇˆQ@Ï­ŽJ¯“Ar)ú<ùâÎd@ÿç¹möë9€†Œ^^6p| è8/ô„Ð6XxßûÞwœÅ&ÕJ)…ò©Z@†ßÑŒ
›µJrSYý44'ß#uB•E!4wD6a¶²mÇ®|r,‰¥v’zÔHÒ+£M‘4q0ð”hYj
°`ˆ¥+™±S¯Ó‰÷ÀÑeÝõà?ø‘|$0‘Z—‹B×U¾Â/‚¤,\ÀºE[-Ï¢>O5ïE š‰Õð²†µH+¸›‘Ð•€xí_YùðÄðÄ¿úÕ¯žüë¶=Ú˜é>Sr# qíµ×Z±Ç/’\]ñÓ5r+yÿÊzÞ¿¸:Ì_‘È‹š92{4èJYnQŒ¥-¾hÖ³è 4QÒ7WšRyMÞö¶·i$OúÓWøzÛÚÚÚÚÚÚÚÚ.€f6Ï—v9ûì³¥»Â¼õ­o¥ÿ`Ûcs•MQöÿV®>­YGéŒÉ&jLÔ³hŒàÛ'¸É"ùÚR; ²Û¨°áØÎ£'‚×È>6„ÈD¢YQðÐÃ—ò«ð%å~¡p§ á#QÐÜ™EÙ“]ÖN[[ÛîqÈƒÀžmð]ïzWˆ³?ÉõŠ¶[†Î ô›Ï=÷\bà'TA[k)˜ˆà
lìQü .bó#p“ƒ¨1”b,OUdKyÍzñnã 5ŠrîX[ÿñ x‘Í«ÜL4à¸.AÓ3Ñäz´Mßò–·¨,µ)Ñý¢¤Z]¹RÅ†e¨"øZÔ«¢6ÔªÓ›RYŒÔÑf>ô¡]•r‹Ñ“xžÆYöÃ}¶òAÏL”‰>®Ž˜æ'Ã^”sÂÙçr.'D-!tsÏ¥ÎŒ5%8r+?mQÔÓÚhä¸ÏRÀñ^ã“.fƒØ”½ùÍo†?zGŸqê”zÅŒîEb¯ø:_ŽpÐŸ­ÿbnz™Ñ²©£‰÷‚{Ršé•nzÏMm5©‰Vêñ¿ÍM‹U#š@Q}ârþ÷¹QÕQ²°pD	
å¹†nõ«±qµ–¦y¢þrnÆ“ˆF=Â=9i´.”ygÑÑ²Ó³ÔnŽØaº”pv‹¬_mmmmmmmm¯YÞîv·#IŒºee5ió m±ÿ· ´BÍ2t’pýY{4ùë5l’9p?XJÍ>Ñv²°‚$¼H‹è!ÀÛB«g]pè”jäƒô )é·Â=©%ußœÜ(
{QÇyÅemmÞ¶y©jùláò‰(sq™'<ÓÑ£3îrí„³K¯¼p®¤ü¾÷½unÈå7yÎsž£›Û0_}õÕ‚Çy˜~øÃú^aAH¬LF‰¿õ·þVRçÃc@cKè>o„C-:ä–•‹±ü»/ò¯µ>&šH‹ìÎ1»Z¨pÁ&‚m-}æØ2Ñ@¯€••¤2WÂ 
ÈEñÚÂJpôÄ—(ysS˜›†_¸se)¨Qw±™ñb@§‚Ü!uQë‰W`ÍÙªJ,Ò˜w‘‘ Kf„ˆöm;gÍ“Ð3RxñUïÞÊ5¢q.JµLœF°WÒiù[è¡sµü>Ú¿5˜@+è³¦eŒ’E3é gk+ŒÍ±€Û&¯iIãQ»6ö‚Q‘f¤ÄUEµ$ð¤/Ì—e’…Sö–Iéõœ‡`ê}ÝÒ¶½Ý–V^êW“0»Y‹b<|Œ–H‘xµ}1s¬B¢ÑÆ@ªÕ,¢º?1¦G ÚlsÑèH3Ð`0ñùB"µ1f=É1Å^“$¥Ô¸â<ži”GÇÜŠ5´±b¬nkkkkkkkk;XR#÷J‹@9¨JÒ’Tn½¥@óúèó²2FAºÝ¨Ýc1w 9âÉBÓçïð/û(?q£â»¿ñoˆdÄ‘”ù‡¨ì=ÑÍ°—›Í%J¡±Å_[[ÛF ÐbßIpÀ„.W@saÊ#~=IêO[ñSO=Õ{`ñ¿öÀÏxÆ3¨©bä‰TÈÅF<»e[eÛräGºööÌ0J$Y J˜¶ÜQ6á>± t–®c£‡A£ò2ÒÆ{hxÜ¼µT
`„˜ƒ¸MpX¯VÜí¤	±Ÿ@çU&ÀØÇdvGã®KUÃïŠåW{p7ÕIúë¿þëêÂpÁà¨syÈCÔBz„JËë´1pŒZFÆ¥+AÖ"ô_ª«E9ò]ULNÚÅH…žŠ¯â¥/})f(OF÷îo
ÁI´tÈDhäú{‰½L¼&éÎÕlw”öY@mÌèqÙš7]KÀ„ÄƒF!ÇžJëbE„×Þ±FÚW¼âÐç¬y`Ž8ÝÑU˜¸—½Põ‚c§†NB±=¡¡rB‰Í‹(ŸŸú©Ÿêf¶í6„†Ô¬cCîˆ	ÎØk´4ß‚¸+4Qs–5­¶­õJ!86F%ý`F9ÇÒ‰'—I	@Nq>N…þi!.3ð‹p‡¸mµmÀ×£×È˜,¬‘!bÏOÓñëêkkkkkkkkkûŸ†Ì‹©ä!‹‘àKè}˜-p#FÞ"XÑÀÚ° ŽJÝj”:û:¤'tf+rT ªyâ?ûÙÏ"ÖI(çÏÒR²Üã÷'Û¼Åómmm«Á‘Ù
P½lÒ•ÖqçÁ@FÃš©âœpÂ	<j’êæÆ}ß˜ áOÒÍaÍ\M6ÏF	(3*ŒKÀ—Ø¿™Ûˆ®Ž°ÔD‰hgfœ<O¤í3’žŒí0&ˆsR¡ÜÊ‡í‹^ô¢œCîªðuƒ*´7b¡LNTe'‚K9PàÕ„%§"P>ÝÄïòƒò"@u9ŒÉ.ãÄX'‡²&³’~.fŸ[yr@^{ñFê¸'×™Ú"Bå­A6Z=ÁÓš Úvò°“AæQzuP,ü”:>iHÂæD›e¿
K®ZEyÖ*…æúf<\Ö'P]÷Ÿ‘T¯{Ýëôy/›÷•DšÿF[%­ð3?ó3îiLwÐsŽ é	î\9Ç¡‹ƒ5+h#Ž³‹üB^!ÿuCÝìX{â÷Ü¼yì±Ç’úÑ’¥+0òpÔÑÃ™ÐxŒÀ©YugŒ
á]¹Ìb¸jY;ç©µ*vYm¦;„Å<’9¢rž±Ñpš±tQmÏ5qOò biˆqJÇ¯˜ûÝ$ÚÚÚÚÚÚÚÚÚf¿¶èÂ?GžÚH
[¾oá•ª“ÖÜVÉÖÁÖÖ8D@(iO~â'~‚.3Ôé| CJˆó]îr—¬æIÔýèÜwnE *fe˜õ¿b1Ýëì¶¶Õ†½uÈ!‡L0;]LŸMf9{lÝ6BŒõ\š(Ì>Q½PMÉ4£}IH²Ù¦w6Ï²õ˜Ç<æ’K.!Ù,äœc	jlÏÃˆŒJÂ²PÔè¼Gac¡Š»H"^äÒ.úí¶q¨,²¤§Ýìm½Eäû¶ÂPGíW#'¨Âó¦þä·‹ú¿	4¬„‘‘•R"¯Y’Ó¡xõÈŒ~àp[ƒ°;õ RpºËã´‚aWI®‚èáâ)s¿þ Ëaôæ$ðsOxÂ€YÒá¾ë]ïzêSŸ*Ø\›Y³=÷¹Ïå{À¿ÃË†¼ä™—
nFtAh°»,ØJŸ›ÂÑº`â‘yé‘çƒww¸ÃN<ñDÌz­¹X«ø(´ÀðŽÁv©â¢	W“p
ýú¬ñé
ãÎ$›5NCY’—b›r½ òÀÐ€ò¬X¶ð¾FN½Òpe¦™®Cƒ•‡‹~Ã7Œa.£Ò0Žu¾å&:oü.°ÎÑ—4¡¾e Wíw»Éí!³”¥,ÄÏj~¼îºë´FmF™‡ÈlÔÕ†5¡8¸
â~ p¤¥ŠùóÔ”¯ècÔŒÆ\¸èUUÅ¹³_Ñþó‹¡°Zˆ“þeFæÖ9/5°^·µµµµµµµµýOËZM†8.=÷tÆå:	ÊžÈL$‹¥tlD”$˜’ïÛ¢_¾÷½ï(YÊG[¡9;»uhÿC/ŠlLDi»µ 6FøNÚy¹aûÈ:låóÏ?_’¢#Ž8p,/œpš)Û ”‘³êJ*ÌdÖEãs‰Kpiû´§=<
LD„û >l•mª]6Øv¹:>À‘”-7ø)ÌaÎcŠæiF÷§üPäßXˆÎgw=>cÀÇ:ã áu‡FÇÛ¨K;þ\¥*obÎ@@lÊ´0u9#$’[AŽà_¥ûé[úJ6É%˜«²€û`z?á“î§x|P	„*óEhˆŸZl80f]O
©íd½šÒ†¡PáÀ¡v+<Mì97ù£Ù\•eS [9é&™<ŒVÊLR®U¹…¼¹X˜«}Ùˆ77Ý€5;f'[éç’å1t€É#¼P‘Ü`Êi´C4!›'ç=—eÝ¼2º=Ü6:Fû»¿û»¤{©Òs³!koí}}êMº[Ä¸Iô¯_$Ú§7Òïà†+&ap“wIQ|þ|nÇÏõÆºƒŸÓ^èuÑjÆæP’ÊæAìf-YTŠŸÚÔJ­ŠÕ²êæ*ÐPyJ´Û¼D©_59é Rû‹±)5w,2NœTÑVÝš«6Ã¸FKNÚ9µ¥ˆ¡?ñ‰Oô´ rs4¯p¯“ÛÚÚÚÚÚÚÚÚþ§}ôÑÖ²ÅÜýTWë$œìj
ûÏŒ¸Ï¸ö¨VØx=VÞBS…"RdÆtžìÿ—’”{ÜÖ¶ÂFXyÄ£=Gycw¾óo;›Ë>&GèâÌ¿åýeØ®(`Q8èÎ‚Ã…§,ØœúŒÄO¡Ò†`Ì,êùH×C?‰Š”m¹k(€ƒüéÜ‚Ggƒ]£DeOýsKê¤26ÌvÑ*ÈŸa>®3díÑñ°çIJ.ÁåúW†n¥J%“‹àQ`hÜÅ ˆ©4¼,æZ’ŒåÎÊS]ô§xå+_	à€e(^2ÙÐaè’ºP•² ƒì©—€Ô¦šå*€ä&…W GÒ=Õõ+a£Ÿðëþ‹Ýù¡}ÈOø–ß¢6—ƒ|ƒ¾¾<7-SÃÃ…3‚¿¡ê~×ó$—šz/Îæfz&Á@sÈôÜãÆ~a–
¼`2-9°t3FSôUÆÜ¡ý¢çîsŸÓÎ9Å®¤›íø…\Cñô»@rN:ÃÃ‹£·nmÝâ+<ñ„2$¦3&¸­~ªoÒR÷ú^6iTŸZ²ç©ArÒ#jÌq gTpg£GòÔåJÃÜÜ+ è“ëµ×ZÛbå8™Í½q¼§Ÿ~ºànTƒ¹º#?õÑ~4>ŽÞ>mŽ3ô9Ðºâ_ÔÔÕQÊjPME;%˜òêD¬ù32Ðî/ÚƒhR<7†qSLt9ð?N9å?$¶ KgDLÞ¢­­­­­­­­í 6{uÁ}Þs€K[ÎÂ¬ƒ'ÂÍ#¥È~Ìr6›Ÿn[X':{#ôaÂMî]Ð–v!lc1Ö\¹þJ·Ñ~2°BIÐvØa¼>|?œ@(Ì f¢½1UJ0(ž,¤‰WëÉO~2­I}K+"’!ßù/4<JÛ—`ŽR	ÊôEÔZø|S¯·a \vÙeîàÏˆcLXÃ£ó8€äŒ}r€’É¿FÛü~{tœI9Üá©Áô×_ýío{ˆpþ~5Z*[ú€ƒd—¥¡Å@R‹ž@÷pÀ•¿Ñ8âQw%P€Z®F0ìÁ§ì‹5Q\ hÈ…ÚÌA:«8¿¢CRø	UŸGúÎh%Sô„héÝï~wTw:*šèYãrÀ‹»í¿[,„¨#	_ƒËxZÈK0wìoÀYÈËz}‡AŽôÚ³bI¿hÛù†•©5O´jÀ\DÓ¿FgÏD·àW.ŠÀ>î± nF•
DØZ@˜{’ª7œêeÎÀõO¨]Ýï~÷{Ä#¡TòÕÍŽGµÀ“·“?/‹(% #$sfdFþÝÜÊ5ÉêœUY^3ƒ¤‡4 G«Ç ¡g%~Î­œ‡ò÷Ô¼í´Æ 6Ï>ûl£7Qo!–ÁÜ!*Ñ€LÙˆ­='å‰æm’5;©­Ø]¶ÓäÖÜÁ¡ÿjnKÃT½IÄ¯h¨<ÄT°Tº– G ‚À µS¹•€ßÕÆø¤Q[D;k†®Ê¶¶¶¶¶¶¶¶¶†‚ÍIX?{šñ—½¥0È„žÚHò pV‚Ú4tXÅ‚6ì÷ìãßAµl ©"Ö¢|Q
 ¸™Í¶8à­·4{b£‹‰ì ÅéðÃÏtfh MOdUàž2RžÎKâ œe(§O8ÈP`hõ‚¸‡œ…ÓwõÕWë¹ú2r\(‡XZú;´Ô]1.DÒž61¼öÏå	†]è34½¨î†±;!O”ë5
Q…€lÓ	îeóÓt ¼ìÒ…8œ|‰Ž¼àÉÑ“=O]`ƒ€Õ‚3Vr%hä,€P* ëÆ[äe…O²ùË_þrŠW­,‚ø«MQ?¡¾`a@•nÐ®šÂ²¾ðÂ5â (Àyuêaà~×ÝÐãy`°¸z:¥]»ÚRvžÍõU€`šàþ„»E|¶UÖçl.TÍá¢gêeÃ¸OcÅ ·Ò øžÞ$
ß©XSÛÎ1H.—,|P9ÃˆOM4¢ÏÚF Ö‰,XÆ¤Qÿõiø
ýÿÝï~wr–îÎb)7×³äP¥D”Õ—N
[>B÷<­këq'z§ORK,B7‰Ñ7Qª>XïXãjºÉèÆ‹›Ê±±Ý ­GûäÚáásÉU:ãÜöÎÈ‰C2*šÁÐŽ¹~ùw%Kà ‹1úþ^+yõkŽ :'k.S;þk^ÐøGKÍªU;Ñ|=ô¢¹¡“ˆ×Ç·ç !Ú¼uÜr.ógžy&Ý-énmmmmmmmmm·2ûRq©cŽì¥	µÃ–'›)çÅxWîU¯z•H=û+aû°-lµG?úÑòÖ#e#€Ô¦q#”a—0DÛ¿7ëŠÞ¨Šs4¡3/~]¿ƒ5ëqD–Ñ™Ë6>íf)cÌæ9»nºé¦×¾öµxUÐL”+üYJÍ°¨1ÓyBÀE Q*H¦ö¥¶ÇŽ-,-;Ûì]#²D50t4X+Ü¢å$0b‚2¯ ±Nd6úÊž@ŸG*åD:c<o¯Ê¡rÍQ8	ï*jû|€/PÉ¿@«öùÎû/8Øe—_~9btŒ^6‚'-N.äJxZ1%Ù7¾ñ*Eº?x´Ê2´¢«Yàìyçƒ©ùº3 UéçøÔ‹'Ô¢¹ 3bÏæDc€ˆ‹½ˆú"{xø—¡B;¯I@–ù*°ä|GÞñØJ}òRxÜíÝÀ«…ûxJé5J›þ¶¦™ZÓt•¤>R©á:ÀNs@ˆŸF×ÀÓÍîê¨ó#ß¹Ö
> ÎÇ4$.J»F­-¤Ê˜d¼ˆýl.KaAoÒCu®Ð3·ß–]é@m.ÀZw1£±^ÉIœÉO!@–#†î²¼à8ŽÕÐíü‘0À:gœaÐ°´ë&·íƒ&ˆO„j6wK ÌÉœ©¦2¹D†[ã¬Ö²ó_ÎÍôa"˜¸i#8ã¿<¦Î˜rÇ–zÜœÉ0ÉË(°&ý"Pµ‹+æ¦ pª/ú²ÈîêmmmmmmmmmàM´pé“O>™ k¦V±q9Ê#&ÅvÑ…v™¸‰!ÈX¡ÂA^ÿú×_rÉ%(–+öT#©yé6²­­­ÀåÐ£f·P¥ÆP€¥Ç>0h†?"±RÏ v .õ}+j’T)°ãß›ÌM“6¶€¿ 2	Á p X3°¬c÷‹?©)©ÐR×Iêª1“žŒ0!åD*ÜjFá¾")o€éfIð¼¦¸F±•}Jäb°¾Üag¡21@
LÖ›kÔ»ƒ3JÛ±1YL4`	ò	Â#Ð!qÙà6Þp0æ²“.ð»¸ÏÔf/¸àAúê9Š”O$Çä‡ô­43ß=ê¨£¸%àe¨Ð d¼¼07¯hHØÓ|Šš4œ—Â+ µO=õÔÙ\èÉ§ç7óvX<*ŒoË ä‘G¢z¿ô¹òË£sLÕª2•£çSÁ@ì‰iç#w>¥'5²ùQ›;Œà$s¯9ö¯¨âVÇ¬>Kë ÞZ.—m¡-M¼ò¹3¼'$ì«»ùÓHû€<@GöÀ»¹þ9öØcÅjéK_J~Áø¬_·º\VFŒ”ÔSgÀšÞÚ5þ•Ì„58Ë¿Ž‹±eãSŒrtCÊ–ÕBÚ–Vw÷¹Ï}8Í×„DDUCÝñ‹¨Ê±A|\òS©DØ±‰»&Ù‘Øî@%f¨Ì¼<}	²Ñ;|š¬ÍD£3Ï1¸™€’éC«ÐM<žVDž«ë±­­­­­­­­mùb·T,q!…rcA FþKFöK¶F0è	»Ð>Ç"ØžÄ&ô q`Í
Â°tžÝBj^\dÿÁ6Z…·µµML‡:ôÐC—vçt‡N 6ìïœsÎ$wÜq¯~õ«qcIßˆ9À¢…)@%àžv§°H"Ú2øyÖ7y±ìo“úÏþÐ`Ó‹BXâp
Wú:¼Ï'žT!Å#Ò:Ñ\.ôçOæ6Ž$%AÚ£Ò@{NÇ¹Ò7{ø>Yþ*®Ùë+pè0t 7™&It®]#]ô™h†…	–³H,à	PˆŠ¾(ì @Àà[ "7w´:œ8µì‡@Ã–ñ+0)ž÷q=Ž3’ò3žñÂ ¬ÆsÃ8Ñ˜²¶tÈ!‡`ÁCâ W p¤éÇ=îq¢g4Ã>^<¬´­íÝsnîì¶@-°sÎJµÕl£Y`³†µ­+grlK!ú-ç×a­–A´h† Üµ/Îkm;Ê`»zQ¶9«—1¢¢ZˆÞ!’#‚?Yó¸X¿Ó×øêøiB5âmYs#Dc]8TSfA´E5x3äœ…&ì~»òâ¢X¼V`±Ñ8ò$è®<[^ÓÏ	V¨µœ“¼MI¶ËCæ•õ) £öŸ›Œ	¢}Å­\›Ý#¶eMQ×'·±ben˜åú5Þ¦
´%cÁœ÷7ƒ|ÔíÇ)¸Üoª/ÞÍI,QèÿÅ/É:c¤¹rìQÆ7e¼FÕ›/T=¯$Og¶ÆœˆÆ^Ã·µµµµµµµµ-_ìN$,ÉhB’–ÊÖß-{$ÐUˆBÙ¤±,O¡Z_|1ÀËr™ú›; ë=ò‘œ¬§gî<»uÚÀEîs/^ÛÚ62°…ýž.Ñƒà»ÙòÁûˆc8C7ƒä’&‘ˆaTeH(,p„$’b‚51íl“àâØ^4ø‹fíf‹Ô<Ò¬‚îEhrç)}ÉQ¨g"£1’£'vÀ ÐÂ¢1
óŽFQ2&6ð ¸˜ªAÌT*ZD–ß.Êžê_ØØS#Î|£¶aøUÔ®AÅ…)pø¡L:ösXêô1p“aÙX€…ˆ~uj|ö§jÂ˜#²,æbô]¿å_m.g Ýíxý4µ¨ÇóŸÿ|¥´Ìbç	‰: o›µ7ß%úAÙY›A¾Ö256®%z2Ëä8c~€ªEänû è 3AÍ¢ëR8òÚÏä+`}Õ¤€ò^¡)Ÿ;ÙèŒµÐt½l…BN„Â¹m’™°.ó§/-a¯Ža¸É×·ThÁwã$y=hÈ¤›Ó>"ç¢Q£ cÞî¿;w£á8ô
ÿÂ"ý®è¯¬óZ¿Õð›ø6¯	z.1Lð¸ÄüùsËÐÙA¹qÉ˜J¼È(¹Ð¶åy†c‹@%Q&Ä”cî™M
A™Õ7˜aÖ„þÝ¹-úØ2‰§ÞñÙ“rsÔ€N¨´
“Ù6ˆ¶¹¯Y”Œð­¢H§møz4ñÍ&xÐ³¹ö‹gn?D[[[[[[[[Û.V½õùð‡?œaMi›íÀ2;ÒÖ$óºè¢‹Fº"lÅ–Œ”!eºè ,3—FXîe=ß†¶»µ¯ß#FQ‹EÚþjø©¾X—•f)÷T$X¼UH+ÚêSB ^qÅL$Yø ‰O{E ™3`GÈ|ô€×fãj“Ê3Â,Ô€à†î¬kS~ÀÒÿ?sËí*GáD^QbàFÈÝR¤f¢Þ³×Àå¥@öø²q¡EX|”r¶O.¦|X¬aÄj!ð½+Á ƒãø\K]] £‘Ž©R:Qìài,¤¦£FT«¤|2ž9_Pe!'Fº( ÆòHþ§ û–Zöé<o„/¶àY®w17ƒƒ\/|gn2éi!ÿ=Éž›ŸUD†>‹w	6
¦ ³â ³CßF±Ç€óé¿èÏœ” 5_YÚ;VO»Ó ik½)¥rr”¿$àÚ
Ñð¥f‚Sò9¦K£´•€ó$ˆëátŽí\&Ú¿Ö®ßy¡fê}’bÖGK7éOƒF}YØäœaÓGqbQšl…XÐèó§‘Š÷þ¹“¥\Öwtm~D=Ô8¬é>æ1ÙŽP3Ô5×\“4t@óøÀê©àÅQ“öŸA¬XÒ“x”¼8;€u@+˜µNaD2 £ÕípSõ5Y-ä“û÷˜{ôÑG¥5fžEÃr²bF¸™ÛÒ¬A—Yý&ÅÂ¸8gQê›¥V!ïLÜ‘£)gŒñ¿òº›?ÝÙd¤qæM4	9«ãÔì$ßd¯´ÛÚÚÚÚÚÚÚÚ6±&¶¯Æ#£‹XÆ²¬Cœ!à†bõi“A®¹ÿýï/Zp?¢ƒõÊ¸7~»¼f"¦\	ýfR`®ô—Ç¦5bÍ‹ ÁxÏ1g`= í¹:	&¼tnp=aàÈÎ ? &ðÜ	Aþä'?	Êä+"¿€Ú&>Æá$6+è-j!H(¤ ÷!’Àu…&ü‹¹,¤P’Ýéš,¿df«ëŽµB‚–"écxò˜”,²‚œŠÖí}éf|úÓŸV˜®¡žWˆ\86~Âg»P¡$>AZ¡Œ©&´5•¨ÄàÔPî=Ã©;KÕrâ©Ýê¯x Zì¼0 UJ4[}ª}ÂýÚƒc¿¢ù¡½ã »	¨j€ê’F„‡49	¡@ƒ£y02€oŸx$’š‹ª¬åhBw¦ã	&[ìÑÕ‹øº·À-Õ´.½ôÒñ¿³yÌv©j¬¶ê¤ÂÿÉ^çù¹RFßFµLÅUçÖwW@[€’AÜ(œÐÂX0Žm;Ç´ÌG<âZ‚gÄ3‚t9ZÊ©VÒ·ºMFí.¬jK¾]ÕO3Œ±5¡º ãgL¯„8rù~Œš¨>.þ@'rfÇk¨“êqú»Ø‚­5­ênÖ¹›¾)$bdÅæMi£¬ÖIâZ¡aËšhôÃ\>º4Ñ\2Å$Ëh‹ÒlašºNFn- ¾6,·V%eþ<£1ôß´žÄ³\bætŸüm|UMA–ÓäÌ;áª«&ç3–ÎFþ•TÀ_rÉFešSãbnò§N”d•qÉ$!g8õü(–+]§mmmmmmmmm›ÛÌÏ®%XÙ:Ø*Ù~û¤“NÁµ‡>ô¡€iáÞ­§ÛÚvòÆ/mõ™ÛR"óRæòÒü~‹ÀôbW'¤§½ÅrFGÓ¹Ào{ÛÛ¨püHä«A(ìú ö{ Oƒk`ö¢°†„ÛPÂVó•àq6–;I|ÀÐ9íH#ÓÔÈÚËî4»ëG—ï|}ŒÕ<ë‘ÛXW‚ƒÅ¨MÔyR?Á‹1ÍåVê®lýI[ñòBC²üÉ€rhÓž_±Wà~H=©Uh)9æoð-7$Æª–yyˆf€›“éËOC¥ËHÓ8žjYýB{µ{Nuíbð™6 Ý¾Í9ü"Ò'¢Ä_ˆÎ†ÿì&ýªæÕHæY”'ÖkWß]1MÌæaþ°òâHÁ³…ÜY{ÍÉ—4D™Eá€ò5õ*Ò gñ"Tø›’s©Ë ™°~ÔuHwNÛv Ý~näìõ8ž²úÒkj4K…3õÂ‘ù’Ù"Ž% 3¤JkøMøBqK×áÎçÊjr`'r…¦‘\ïæAt 4â0÷<ú¬.É±ÄAeHÙ@€{Éˆä-2hDÉº¤Ìõ~²RäXD»ÌXG>©ê<¶‰Æó£“Æw¨H† öÊlÊÊoÛ‘@”ëx‰)óChºÆ43‹èoxWÚ\ÈÚ¤ª4Ah6°ií“Y»µe´y@9.´š£3j¾5ú_3*fzò™ÖäZA7ÑŒM7šVü €!‘úŠðšÙ^dlkkkkkkkkÛïmJ6g)\8Ýd‰Yru{thkÛ–ÏX»Á¥pDi©ÅÆâ–:Ð/²Q›=’© ðÃÅ@Â's½~ä¤{SÜŒâT€5aÑÓàKøˆ9<S[MÛÅ Ðvþv‰P€_ù•_-ÚþE|:`/
v±ÕŒF°ëí<;
GŒáÕÁ 'Ìß5ÕrÿûÜÖ¡Ñí :Àúä±aO
-!Ì¹Ì±“J‚sþçJ@ XŠ®äèÔSO…Ù™C{íÌEIû—=?ˆY]Ø™cò ¾°i•b3ÿç&ŠÙeTT1¤@-«&Ç b·‚€˜EXÌÇzs+”dO	Jsõ<¾B_Å£ªtÀÖQGb~êSŸê§ÖÐ®èïçÀð.š¥xmTeTheÆ…Ó<€ÎñÄ\vÙe¸“P4×¥˜B&#Ò4ž·1©àš¦ga’êj:£Dœ44½À(K)êëúÎ•4÷ò÷@º{äÜ±ÆYtÖOu"ýQSçæÑ»'|g¼QQ5déé!óÆü©³Z¯Aî‚ÞêÂ5œ®veUzU_Ô q¨gÅ€#¥2ƒ¼^óš×8g4Ôh·Dxxt¶&d‘)L	˜;¼;’·H›7Tã‡-òE-X‰æïx†Îœý_ƒžQ%}ê_Î§ÇÝ@¢ò‹öòok¦ÐxòŒÃ’¯¨Dƒ<ÍÝeŠGÃ7€Çë©•šPâ`ó	N…j<f™´IkƒxL#úTˆs…ò”7…“RËœ$ÖTÆ5CZ¾yàR­+üœ'¹öÚkõC¢,—µžiD[[[[[[[[ÛæVÃ³2N.[ä»õö£m§5æÉvhÜ&1ˆ„ŽÆ¢”íºýpÙyÛi"¹A¨-_~ùåãMhÝJ¹	ó²õ|zÆgÌæXóGæƒ÷á%ÙRvØaÎ£²Ú%2ü
ÈáT¶;”\Hc›ò„úô¶yÈ­@FZ¸lmEÄÄr‚;ÃÀ”à 8fØÍÙXâ(!(ÙŽ&[©ß.µ‰s°’ºÕ:€ò‡¾3.ÊLçiemR’#/˜0d?_9ë ÊžÓÜfÛN’¥ØýÉ Þ‰o`©ƒž³GOƒ~†™®ºU.½N×h'° ‚/Õ©c›v°ùÐ˜½&Avf5ÃwF„=» wF²X»³&ä<ÜspÌ‚jí‘<ðsŸû\J~lí‹Ž©?Ótö§V1-@$ØÒÀ šôƒô BÏëq‡‹•ïd¶y"óbwÛ3‚Ÿ¸Ë]î‚C
‚‡AbãcPÂQ&‚¼5ì Å€5éÃÙímûvœ/£En„«i  ^0ôÒ6 kgˆ"*Õíü©ù–ÎÅýS‰UÓ|Ë»´	M~Bwv_ÑCu|^þý‘?Rº6±™¢g(0÷ä‚	dõDÆ£¹…6––É	‹Ìïš5ÌEýŽÀˆ’™d«Ë3…°Ç7ê·	Å¼c4r!*•’ö-/búkðq³VÎ<ã°ŒÁŸ5 Þnã³6Àh Éù4³ÓÁsÀ¯¦ðÇ
-=™âïsc¨¬º <èQè9Ÿ®„nC«k*\Ô.Ïª@EsvšÚ"'­a ×kÒÒÔiµ—Çü¶¶¶¶¶¶¶¶¶¶¶¶…GLÎØÞãçO»eè$ÇKÔ~ÏnÊ^]¬ëi§pX™Ùú„Ã”.3v‰@dx1ª)xðæ‹R3þ2Œê¨û@ð˜drCµsûWìÿñOÁXx6ónsLF8ûLø¦M¦m!®™Û{D3`(H%XÄ9Ù¥bIµ¨kQæÅdz«ÍëÓBw>Óy$<@Ì§Í3ð×6•Lù£
JêNX±í:N±÷u 'ðEuSÕPbäÕlW]ƒÔz£“/|áÝÖ1÷°X“{Üã‡öÈ 8à¨ sl <ˆÕÎ/üÂ/@œý¢ó‚îý¬A½;pX&±ò0/ˆH ‰€²y#ó£xs^ÁsB¢5KàòR%Öè½H¤G`þˆ'®sö&0Ê¤k¬N·‚â¡
]ÔjoÛ	~ ÅôÐ°•ŸÆ[åŠ‹nÆ:Ã£A@¯	ål$çÀ3ºò!q6›ñåÅ˜¥ò>¹R›1à'–‚;Ê°Äj´ws½ÞÌb  {cvà¹ä°Ôß©»ìfrK€`å“>ÎKYNÛöÊhÑf“Å‡¯c Jƒ7v…®pŒu zp\l ¢[ýñœ\w™µþÆæ×'Ub\Ú¦$KnEC´6L€ËêÂ¡¹r!ð;ªVSŒp(õXÁþ;j
eÊ§~×p[Â£IUÖÅ¾«GYóÑ]=*€›q<¤•I¡¾hÖSïV>–O³ÆÛÚÚÚÚÚÚÚÚÚÚèa´‰RsŽ	ÝþÈÈÛƒUŠé)ËŸ?Œ ¡ä‡°…”–ÍI`ßð #f%¡s˜¯3eRX!ÞLûÕ¾ m3ù²'©„9Ú:‚pŸ›vû ØÞ“n°´y³Ÿ‡n à¡µ"8ós5†÷=I~y˜E‰© VÛÈÉ&êvL{µ˜8kçË4oc²ÁñeÁL Ýˆ`¨J G!W¶0ñïj!WÚ½#ô!QÂYø ´X³JÇq¶ÿ×HT¸“mX¬œy/ü©~ƒ+9	> ÑÅ€FS¿	‹Acš"÷‚$ò{PcxºÌ??7Ø·k€ËöüZèêíS¼–†ïbìx ´û{ µ6	nÖæáY£€REñ— ÆÒ\—û»é§Xx*¡;ú é#ÿanió:‘n\Ñªg¾Ä:œÑHÖ¥ÖÚ¶=vâ‰'fãm"c4Žré	 —KbÈ `4v`<WËŸÆ„Ä‘ªžÄ‹¬Ö—ÿó¹¹?if'3›-Ìµ™V²ÿêÝR¨ß¤8a1€içÌG@½äÛ²ñ}š>Ê7‰»j^ðš½²7ÅDÞÈ7S™øb¤±•‰.ÆYë_ŠW‡ò+œ¸\pqLÖÇ† ·`Æa¬gõîØ,£a[´Òü	xRøÑëçÆ0;Ä’UR“Žå¿Üb#v<’–zXB{¯xŽ¨•ËØLjYäØJÆ,ûö§%cgÌ›"Ãø> ´ã¡­­­­­­­­­­íÀß¿­ØùØËÑÄ¨?Gø¡²å  lË‚NÊ±…0±Ý„SPh—å$|ô°·³å¶Ä ³'t±“6ovæ.†/ƒ’]ÓÚïÙ¿a.ÜÛ°kýzq–ýi‡Y¤Ëø!Xv ‚ì*	õ,¼6güYÒE^.|aQã` @´]Ý*Þâªj ¤xÃK1ØJ”1ì±¹ G®¡‹rõÕW¦¡ÉP*(°
u±ö€eë„;óX@©ìÆ_ñŠWØçû	J4Ö!Ô lG(˜V‡N¨ð+ Â”5mÉM<€ý<™„´8hwhHžÖƒ½èzè•GrO k€žØmo{Ûh¼,"qé1¥‘v·TÍ?5¾Eÿ‚ÝÅ[S—ÔÍ×+U·ºÓ–êÞŽmÆ­s¹[N‚w¼ã Xá¬%8vž•€Œªá¤ÑÑ4	u‰s#ü8&Ãj9¨Ìi$úl¸¥F‰ˆäŒWŽŠF+ÚÊ0ÿ“/4 ÌÆJ<F‘H -8&ÏÌíÄJ«ÇØÂaÉ·Ä•²˜ävSfÈ'”¨mhÿÆJI7jÎ,E-#³L¾â	ÝÄÝ £"xºþ…]Î…&ˆ×miÈEÛj‹ò†Eˆ¦Ës`šP’Ö*Kù8¸_{¶¢0¿˜â75Ä}÷€qo¢µeìJÅÅ=.	’!Úñ¸Œ´ýtÿú_çVÊàf:à§M‘¼žµÄšµã¡­­­­­­­­­­mGÙç˜Æ“ù“¦øSIÿ k³!›YÄ%V+:gÝÍ·Š56bC¨gDoÏ>ûìü‰b†æL^ÙæÆ@ÄÞ²¯=  £›,PnekgS=„FE”%Ù~º¤°9ŒÚ²= !h—‹Cãýƒq$ÆÙÜ9×€G¡“ŽGÌ4îcßìv OŠ<_ÌM"Z:JLŒÑßûhžD£OBz'òã™Å™œ_¼xD[i4[mËU‡j²…¶{GgVìjVíÛEs3 ´Æ= $W¹(Éà!è•ïj +p°¦ò÷æ¦%¸!žh	RàækdUmç»$2 1¾ª;¨›E£-¨5t&-Š€¦?éfÀRñômõ5'*i·$;<³ ì¥ Û¤—M¤ùÇk¯ßOƒ	ÂžÀpâßÎ-j§\D‘©Ñ¡`ýÕHÖÌ®™fVQó€‰™H-t¶ƒ½\Ý+æ”1Ý¥¸=Há¶I–6>]OÂ¢BQh=ÉZÿ Õq1Å‹¨¥Q~—ïÊXO„*þîÜ7ñ™€î~÷»ûEè­Ç6Pðjˆœ óîpME÷iË­Kû„wGlÁˆæ¾ÏŒŠé#ø^¢ÿýËÝÁ°f¤R8	¯q±>åži^ŸÚ ê‹4C<­Y»ÈÕm¸|$Ü9	½=ùä“1 9È¡êk„Ö$LRàb@saš˜’~Ð\¦©hŸÊŸOÅÂ`Œò©ù±(Ìáï—Óz¢DäüÒÁÐZÊœÖ’ïZŸ0Ó¹'¾§%B(&Äí¶¶¶¶¶¶¶¶¶¶¶¶%Ø{Û‡Ýµ¼*â¶ÎrçìÐìÒ9ä¥èƒ]½TN³9²L<1{àñ·¨aÐU¤òüÍo~gÎ€ØnÐ`OEiÁŽ.»5@d´,ìÕíÞýnlÂök{æ‹IÍ4f‡¯˜ýìÖF´«‚¸sMmø“ù
º\Îö~"Së‘l8íÿs‡2Ï9 °c .Íù6Rí<ò
ÃŸ >ÊYy³'M¤HTeX]6ç¨aðb0€jœ<`”1>ñ‰O(jrë(fä5“OLó ³vF#I½ü]BžQ•1ÝŸwxÊ4Œ³LãÐCÅu7:-~T[ò_?Úõ ^
H´¦®Ák“D3 8èÒÌ/Ân¬Ó¼©yhÃ¼$§ý"ZãçVÑŒÝÓÉä%ë1dèœpÂ	àÜg½®!…h Œ½)áê£»bMJ5`¸^û>œ56:o„i‚#p¦›òô£Ôp„ÍHp”/°*W›öÒ&…JÕŠœçÃWtÑÕ5bŒ <3‹ŽÏ÷	‡*æ¹?e:&zNøA'„VqþuÅWàAv³¬L©Æ1~Msçÿ«áÎ@”á1Ý¡J R“35ðzN#[Ü¥é5ææ¥jfŒN½Ð¢øŒÛV·á´ÕcŽ9&^.IäqÐ3Ç¿&L?Qš‡Â×8•v8È–‰íÐ’]€8ï|É‘›"Ñ¥+ÄÄ“=z©Ë¬=Ü!`$õ;P³þå†fC¿å1Ì›\8Ñ—Ìö¤“N27Ñ.÷ð]³mmmmmmmmmmm;G zÃMKN?&“-$ÎÞÆ'µ°‚¬_À>»t›sƒäÀÓ¸¢¶pÔuí±]àVèÁFú`wä+hª)Û'@€Í›Èh;+x„­WáJàHÿÿ+[qÇöx ˆQÚbB«L}9ô’ìeg8IX?î	7JfUd6bµ	›³ðÁTÃø«¹l;ÈÅ$VR,†	>Òœ!¿Â½QÀ&Øôø¦¾æfP×ªMÊ£@‚lé“F™âŠjERÖl¨¬à»@ì²7¼áZ`äY´è°›Ô@zõëZù$ßÿþ÷‹&{ŠYïúÃ?(Œ5i»®±Ù«»ý¹&ÊâW8Tü
ÑÖÉþ•^Ë„)5eš=±wv eåhÆš.¯	:¤Æ¥*¹áNð5LbÊV9«E=:iPP#›î|³©°€êtA±gû•.ö½o¥c¾´ÔŸG}´>n:Ð/ä%À¯ºó„"šcƒ³v’3ÚOR&ËŒ-kRæcÂ ÌGÆJBÈSSÀÐ79ÿ„'<A:‹Þ÷JRœ«)éûèA(£6kn"ðÂ4§(8#Ãë{‹¼Kœy»hCGAx2wô—s‹F¶ÑBêO2ôøC¢4&ñFŸ×¯ŒçåY7’+4pÅh
0g›U‡â3wˆQ
¬Ø£.sœâÌä•U
s ù„1ÓzôºM¸Æúu«v%ýæè6v†sTÍò­Z’éV\LcŽC—³ÄÇëÐRømmmmmmmmmmm;tV€‚O)Ô€†À_rŠåÄ_ƒÒÊ´É±ï‚ÁáÙS•áz¨XÔraÖp=Ÿv¿öð¾Bƒ€ˆCäd"R±ÏÀ‹á¯Ù§Ù;Ù~'ÍT¤3l¡m±l°]eÌÂŽ‹W[àÅDöa„AÇ€#»y;ÙøMd7'ñÝÅEZús£fEÝ'4êC‚ö@ñÌ"‚÷‹¨å¨$«D;çÈVDî —!^¹ï8:$Ùo«ÖÐÕ•¹û Ý;Õe¾è+ÈÎ6óXZÐdÍIœ¸@rÊÐ%¢+gu–Æfó°ö˜’øhøËÁP|pCOC³D†Phås Úh†JÃ 	„5œ±-×VÁÊ|'hÎO|âAÉˆp„h
 ‘FMJ@_ÄØå9=BJÌä$#“•ðë÷½ï}ýè(ÜÜ²*j„w!éƒ¬EôVÓJ ÏÅž¸Kx­±i„Z rk«Üîýùb…ÜvÎë8fÙ>E$@å tÆ„D6¤ÆAÌzâ82'¨"CS°WŸÈÎ‚TwgLó]šqØy$\QH´0´_GI6Úx¼Ùœ°ÏepÐÁA{fÃËl.QÅî” hèa ˜FTœëšˆdÜÀÜÍ†žÐÀ8y… jÌä¢ñóÁD„J/3œêqF6Ã¯i·…€wiAŸ}ò7ð=(1s7<Ž¼j²˜±ŒIhŽ·\±Â‰ —*0ŸŽ1C¦B'U™óñ(ø“‹ÔWâ8Ûm'…(-û.‘(S')Ã5nVM~fÓÕ©Ù-Tîvˆ¶µµµµµµµµµµ­»ÃŸ`[u<!¶ŒX@ˆœ³[ç:[¼²¤6ì´K­5'#”1j%ÎÔdûsT5Û'Ûðý3ÁÌ–Œ‚M¯í™í:‰O;"{*—ÁÀ.&›`‡Ÿ5¢·ÿísýsíÀýé¶pÌí1å1F{Â˜[äe¯ž|MK1åEðb#¤8;É’ØHLy‘ª¹:¯Ú¦€é]^9!qE—DU‘Évà©l\ƒ&ñQ¹7¦¬Ö.­þ>Æ«B†C“Ñ–±ÀœL
/„,41‚*¸†O¥Ä]!†CÝx¤ö!/öáb{cáç×^{-h)÷è|ýõ×—5`0M¾´úÇ?þñgžy¦FH(à$=¨¢"Z‰pŠîf=ŸÌ%½ Z²·nŸ¤Lnî'0¦Ðn{ì±Çz;›v¸Ãêþ²Ñ™ÝLGv`[! FÍ&<¾ôß`.az¦[è¶¢…¶Îq€÷ÔÞ;¼eºöæô´æ5FCŠŽ¯Çéû¦•d¬êV§y/ÿ¢3¡H¬Œ3ÉDšÔ²¡ý.q»0Tæ <a
s“î+ó š³Ê ’>î¸ã#€<Ã0:â<»ÓÍkúÖ¸¯àÂžÇ¨è§ChMÐÏøÌÉ2g ¢T>ãÈÌ„bŠ4áFŸ!£z¾KŠÁ˜¦Ð’)Á+Or9t»WS“šE67i¥¤ÆÌ}T•MtÀµ–(n›­ÌkŠ]§R²€‰^srQŒëøÉ&ë´Éø}Kac\ÆT«æÐVËùÛ">sÜ’qlèÓ¬¸ú­ÙfCDB'bmkkkkkkkkkkÛõ©€›`Íc§Jë4¢Æ‹ÌDÇþæÜÆ3e˜Ë°9›-»nò”6«(?þDRFp¶CFü¤=„ÙAœ“ÖR™m™½nÔ'¡°f˜µ‹m«\	°N¸½í“ý?’NåÛÉ†*°Bî¶^SÝq(]ÅH‚.MY¶ûYûF5Æ	sË÷\|bV³¢–~7°o@«„b°…-tê”wA5©h»YÜaY¹àDê”LDE/Ð™Ð
J2é	+4œx1g€8Ä@WÚ ãBu¥õ
»Æ£Uh$ØÍç4æj~î¯IˆçÀ@mô°Î¡–bñã°éã?+MŒ¼ÜJÐBã¢Fà¡Ù\ÙýaFÚ?êŸü’ÑÕiÕ ôÙœÅOëÙÝBp®hëhÚ¶Ñ2ji-üè¥£†Àb»8KVSžsÌá‘áÅI6õÛ€Ë©÷ÙÕ–rº¹ƒØ¶/ê1ølÒŒKfR2)›3›Dî?ÍÃ’¬•]£Õn¹"œg¢«U_#‰9Ñ4g¨4	ŠŠx0#G—ÑÆ˜ëa‘»)ePEaä1®fÆô:F-o$èÇPY3HÞÅì‹ãÏ™Ùú™Žñ†Ò¹ë\ÌÃç5u7C®~g„7Î{—îãú*ë(Ÿ¦	“_¦úU×<‘ „àP‚;›PÞõ®w™RÚ! ?0	Š5NÇ–4œñåâ\IFâ¤AæåM{žøª}¥¼nÝ•V]ÖÈfÖK>	7(‡ùZ+2ÕÂÄáÎ.Vï<(*º‡]ãmmmmmmmmmmm»¶‚ÃFP,[¦p[òY`ôHˆÎtTñÎvV¹Ò†ÊŸ2¿‰ƒ–Hc¨'·;8ÀÎJ .PR)‰g'ÁˆNBvìŠƒÛAý»¹eŸ’l  ´‹!ŒÙb9Ñ±/º ,¶Úw…1´4z:0Äh^W …cOrÐ¯ŸÜl³xyRt)´	>>Fé®ÿ„ã×C©ìÔ$æ‚.ŠÌe/ª°yÆmwòÜsÏÕxÀC|	öÆ”+àÈ ^Œãj‡0¾…á¿ÈSÌæŽˆW@¥mæ]ã ÊûÀÅš @
Ö«•2×“×DàÒO<ñDw“¯¦Ôv¨÷3ŸùL|4Ïæ$ù:¡Ð<œQ!×ƒ˜ól+/2ÝÆ=yKgìSƒ8,HY2‹’p³ý(9’î|'€<@†-¶Ê9kŽçN2ñÈ#$VØ…åé¶:û˜¯µª[	‹ZR™,ŠŒD_<ßNwARç¹+¨m¯HQã5ó¹.€Î†AOÅƒè½óï„Hf€2žp\•Ãl÷ÛUE&)^·Ì€ÞZ0JÖŒS^^pTl0ÉŠ8Éí(§ç2`½Â1¼›è1†{5×ÄŸ¬%r‹b›4}ê—¼IJš
ŒxH4µÎNzñšGX£š–5’ùTíX EÎ>Œu(m(QAfvc]ÐêTî8»g¾.€#Y(
z›®fO?JÐ@<úA¢9zôX¹a»s¥˜=ª	qœ×LÊ]émmmmmmmmmmm»Þ·Ï‰ŒIÖ#ÛflÐúÓŽÚ5Gq„-S¯á®Š½ÛöTÒ(!¢bÍÐó}á_ ék»d¤Èi„GÁA¡²e%òh&°`·cÿoCÜ'»Üð”m¨BjÎF×–)Ìè";(RóD7ctæ‰ñ
z#@y)nÜºK[Í•^ÊMöä8h+t66Gum‹ ö:*cÀï€d“GR5è‡ô.Ô»þ	0®m­3@ÞóÏ?þ¿K>=Í­p|õÕWãÛèjBQe)ÈÇß*Û]79ì°Ã4ÈÙ<íù N4ÑgM®6º½vnó£`™9¬„\£TC±Eë=Gý™4	J. šØBÐœ
ÈÃµm„êäx°TÜ¦-ö£sÛÍ›¤H9½zG|Tš¢TF'¦,¢Ï«å‚Í‘/à;œîÓÍ ±éhÛ	VÝJ'7!¸è¿Oq	•Wm"GP˜ÿ:7CV¤ÿËc‘!ÎÉ¤šÜH©£6£‘ÀïÌqü[³¹´ç–áˆ"ü+_ùJCŠ˜	šXï97j?.YÄáÝJ[‰ # t@ç<aßã3ë,fÞQu*š3Ðê ”I 0}®<uú1ôHLXïÁmRLuGÐÉ´’‰ÏÇ/H«°F2Z5E®Ê$å3Þô8ÚÕ à0Ru$áAyÖyIÍ¡`kî±ä×-µÔ#¸ÙW|WÝ·°¤ãV±Ëb ÏÚqîé¼ÿrTŒÎ¼ìK.¹$‰Áå³yAôòsx5óiWw[[[[[[[[[Û¼ñÞå¿
›Ý’î¯@6½à?È  ŽV f–ÍAÞÂƒÐ²\foê©§wì—|å¹Ï}®­¦m	ŽŒï,¶×•€ tÏèÖµ¶é$),0Û''í—€È‰M˜g ç‘‰ø8Ð€3öó¾2AcGWm’Ç–ªLŒˆÛ’^o#òòîßdÅ­<R&îòÊÉÍ”*Š¥ië¶ªBaÜQqÙ¯:×¸¨ô€tªÒþ–Ê°6yüÚ»¢6Ïn¡(:Â;±ðš' Ò.ù"ÝØßn?­½Z¾PtÇ§Ÿ~:¾3ö–Ä•þ”òË³å[£(óD¸^°SX|’±¯­VsnŒf´mâ†æhÉÜZjù?Í-é¹Œ<cY?:!7¬ÃÈ¼p¡AŸ‰·t=îœy0‘7ŒHªþK·}œ&™`MF¨ £ˆ¥þ,IŠDáLÄ[vé¤¬ë!¹&Pp!Æ=HWôÒK/å‹"<wlròÉq›Íæ>31@åoÛ.ïT:”Uø/ ›ü7sÎ^~YŸ» åˆ¤Í›ÊKL)'•b8“¨¨£ßr"Ã*L×KŸHÑ¸D{m–º0û—,«h=›¹"8õ%°ôâþ´ú²š²d2j™FÍ³«ÀÄJØªÆâÇ¿,®øL¬¾%f.† ¬²÷¨)ud¦®&ªâ¢×nûYõÍo˜RBxç]W_¹ñ9m-'´hò¦£¶­­­­­­­­­­íÀÜálÒ[‚‰8æ„fqù‹ÒbK‰–EÁ=`Î)œPû%²€²®áýÉ{î¼’Ü8`Üg» ÛWgJRÓgÀÊØÌØš¢ç²ü«¹ÙhÙ5ÙV%à¢
DÍ=I¸”Dô
vËâû…é†
Y.ÿ¬ËŠ*>ª9ÜOf¿œWq@ÈŽ8_òÇhV€ž`<\¶Á®‘êÊy\x|.ˆ³˜bð(óp—ñdÌn¡Û/Ý¨oœç'õÊÓn37½ ñÐŸ<(¢<XÛ>w¿öÝÐ£)‚ÿ`%%ãÌúáå ËÞ_ƒü+Ø¬Æ1›+S¾a—Ò~Œ0z½ÐŠï|ç;»Ô¼0‘Ë¯1Pµº,¾O3T¾CxßeDÈ}.Ç'¤ÏÀh^ÓBÀ²FKÊõÐgàx&_I‰AcFºiIÙç¶·%wŠdr7t‹FBR¹5¯	†ÖžóðÆyx½r \ã¼Q]š”]I÷:yM§ÞtÏoçúÌ¶””xe»ù‚z²8i‹‰øá³?á„,«(ñÂŠÓÖðÐ[\)XÈ/Žóÿ67ôgë¢ðÍƒ «5 ¿OåïbÿTäzÀ±‹-ÛÔ¦Z€û
¨:ÄÿEOóÄ›’ÎÅÖoq'»gt<Ôo:ŽÁSLm¾d­ž¢šd	]­mmmmmmmmmm#p39Ydçlhñ°fsz©ˆ`¹nÄN:C©Àv¶bƒ¬j1Ddj?) ÚIT2ˆ3ØÑŽš¤¦ªÍª„(9¶¦…N†TUò‘%Ílcï”“ìZmný7¹ž|ÚöØüŒl2'K­x—Ê›ë«ÀVhH¥X\Dœ‹<ß ‚[ÎØÓÚv†ëD§‚BÛ (\ýõ4ü‰Nh¯‹ÁÇ'€&ijçÐ^¼Ëø3´+ÆNÂ\´7$¯j?r‹-¶á=×;&ˆÌlHY¦ƒèKu‡æpì3.iüP³ÄCTã_sèH„DôU3¸ýÑýÑŸÏÍ±î``ÄiÕÆÜ­mûÖh+«S¶/E‹¯|å+qjNª>ÇæÌ,£Ìô¶Tši :©h¡Àk#!ôùòË/³M‰ÎŸ>¹oåE˜^aç“Ìm‡¾¹8ÁâHÐ‘Îˆ°ƒ3a7‡ëR-·M2þå-ff‡o¦4|Üìž(Û‘rÊéÛ@·-'—tS\:ûpE¤1À ä‰ÃpH|úÓŸvüÍo~ÓjÊ*H›„Asß’4‰˜•“ª£r]h]J›‹×
Í± —%K¡k¨™A·!Ô¾hŒªä™å~N…V¾ÁÑ-­*G§‹UYè‘£qO>Nes: š¼ôÝµÜÖÖÖÖÖÖÖÖÖve€äd›(¨Úü<æ1	ˆ
b&ËˆøÒ—¾>hiÇhbËm›áS80A{!;[V*0h»šlãG8äeÜ(ÛuÇ¶(®IöÂzBžU˜#@i£ô¹äGZî$J:BåÝg7ÀèÚUfSZïè|ÔN”'‚í%†»ˆZPÆ“z+ am,AÌˆíGÄóú3Ê•v›hÂt“áz`å“N:	âœÆèVó#|Q-pÁ%›'Ò+Ð“Ýßüovçþ£:ÇveýjÛç&˜]å9KÂQö}µÒú(Ñ3%•à6÷Ô­ŒŠúÝðÙ<wk·™`F'Ð›ðØ–®Ì~€¼DLô1rl:+¹çèNpŽšÕoš?WddÈ•ùi"!b¾,H+àÈ×Øb’'8†òl ­1ªF¤í*“´L®Ä Ë™”™’Õ–Æ"ªWß=çÁ ®±00ã“Òrspsæw÷9C6¬Øˆ*«ª4JÐßàø¿òÊ+•·„	×‚þÌ¿+'y2#Anœ15ƒµ^Œr´6™*ˆWŒ™²-ÃœÁRw`-"¿"¼[\©”Zã˜ê«eÀèÔFIí§5ã8¤Ã¤6®Êìªaã>k·wœ[<mmmmmmmmmmû±6ná
¼«-MQ5}ÇÎù+g „Éƒ‹*1:FB«
^³Mµ­‹­…äö<6*ÎÛW’ß/Ù„\m'†T!8QÌ¦%P²ŒÚç8¨ØöqÃÙ$H9Ô*?—PöB#¸¼BOy÷¹Ïã–l±‰ÉO/Å5¬nâ_#¸?¬æuFóQ5 œ¹hFÛxðƒLCÀ–’š3.^˜Y‰÷fhÈgœášC=tl¢2ò!s-¶ØI3õa&ì˜hP¯mËƒ§ð"6‚×@Çvé¾Z‘–0ù¾¢o®û6Qk…ðçÍ–y8Úöfu×cC,•jW·$Œ#ÿ½8œF©IÍ‚ö`mÁ©H©EˆÞ¨Ô&A9¹¶û‘|§•ØÂlr$¥*	Ž$å#»A{a6=¯#ÚMKË|Ík^“é#®Oy±/ŒïU3TÊÐ:!Ë ÿú0ß9ÂÙë]¬äÅÄ˜Z|clŸj§Aòsî7Þˆ }6íB©-[}ÉÐ«è4EÈo|!(üØ À_Ë³,´FuÁÏá@©¸¡ïª…/~ñ‹I6Éî³´‹úÊd½1Ð<ÆOD¿«¢Õ¾O“æà¡‚¯ ãôîg‹mkkkkkkkkkkÛ÷6æœlJs¸,øÑT6ŸýìgR`"¸®øVÄ¡ŠðøÈÝï~w×`(Û`ÃmÄlÚfàþæoþf‚g³«±ù)¹ŒÈbØ,DŽœ€ô‰pð¦ à¶è¹ç.Ùˆ{ÂþÛÜö¨üÅR"¶b/8~)¾Ð]ÿ’ßOÎŸª£1	á¸)µoüsû÷sÓ*œñ»öºW„-nä2ÊÀÉÔ7[† ×5bÛ—^ÓÖ¶Pž4Ë`"üp’zÑ@!aµu†š	ë3_1\BƒãÀnŒ·âE€G8€]øû|®Tûwš›ÄwB&å H´)K´šA€¼:pÞœ(â' ðBf×êÇFRŸ`»w¼ã/yÉK|ÒÙðxX¢QZHC•u¯éü„R-¯ƒ—…NþÙÜŽ7;y‚NNºI\/Ú?¸Saš€ê­#æ ;˜_þÅÜ"?‚~ÛÐó¤}V½kñÂ2 ÆªµUn3uÒ`Z÷£š%ÒQ ºÌªÀœ^Î0\e.‡?	ª¨P0´{jx¾ÍICUãj?À´ã¸J…Ãç„(ªÌ§û«å§<å)Þ‚ú³—ùa=Ð>†¶¶¶¶¶¶¶¶¶¶
U©=ŒO9åÉhäF*ý±ÆrÂØ{Ø!„C<Á>šj´¯€2ã âÑØ7:Cu!·Ìe k×ØEÒÄ=“§ÈžÇ6Æveƒ.LtàF¡Ê‹P, v³½×ì¿Ïm¯ÐáÄ‰
fkßXÂ‹KùÑ‹|¥Ûg†Î©ríT³çŒLÊ'>ñ	UùË¿üË¢eeš²QÔ0x&„âRlDYÊ ^}ôÑxñB€G2òèáXŠ‰T#ìxê¶ýèDR9àqÑ×’3³€›õ5 G‚úzÎÀn~mn˜žÆÛEaÛÞŸ%‰Ò>â{XAøÎêÏ@²°¡+j'¢ºär%pÍd·)Wè˜&7ìÔú“†¾¶‡òLÍY^Ó‡>ô¡$,XÈ#6´>ùä“oûÛï5îIqKix_ÊÂpð(—:öâÆ=®tñÁá›ùJa”Žå„°`°Š0+Y¸Ã·›å¤‰RBãµ‚>k¢jÿê«¯¶¸úÒ—¾”Dñë›â'V£$ùW€àš´mV=&¼)Y4­ñ|½"É&^ w"ÕÆ!®3VÖ“(è>Vk~}÷™÷zèzÐkkkkkkkkkk;pÓÙNÕÅ½oûÛpç#Ž8”LHÁÞÀîÅ¸‰|”ôA@IûLÚ#Æ¶$z—ÅíJ®mL¾DqâÌÚÉ”Ç„«;Ù¢=ÐvhE´ò$¶wÜðx*ÌKYÌ²QÁ…©:Ú(†Ê¤üdKËª,*%PÏÔ>Š7n;þ‘`XÝBzíüAÌ7ÝtÓ“Ÿüdáç ŽuöÃ¥å²x°ôâæ:µí/†•ŒúØvvIOŒ“lô¹dîG Ce…#LÔ(GmûÖÊ1ÆÍFh‚gNZ ª16-!ÕjÊ“RÕì£*Bù¹+E£]¶í*¹Ú
ÈÓºÑ4ôI6rìy`ÐTòÍà¥ž”œ‘˜’½@å—'Ö¼§Óey­á4ï¥="yê&o]<Ùë >©2'A¶+ÓV <@Ý2c©b¸sÁáù £AreYPV*"ky ¦ÑµŸ†SeJˆ
°ÎÉHŸ­qR§*ˆ€Fg’yrtÅ•M-Z,N<Ì:ÍÀj5ÁâPcG5É2Òƒ¶¶¶¶¶¶¶¶¶¶ýÛn{ÛÛú¤¤^ôâ¿Ø¦.lkGR£*ûC{›çÑœíF’³>†±n^J÷«´~‘t¬“Ž¡*6'¥ã¼(Q'G¾óH†Z?l9´=/æ’Zd‡MÀôIÌþz,ÿµWÇõûHô«'‘“º³?#éxK–?û½¯ýëjßÖÑÆO½Ûø•Zè…^è˜Ô€]ëµ×^+»vó".3Ù%®Ø+ö6²m¿¶‚E®ºê*ÑëÆÀ¨©_tºP¡Ós¬fÔÒOC‰ur!7ƒíH4ø
Ù€&×ãÛ–FÛÞ·±äÅyøL•G~-ˆŒÀ\°fÿU•˜Ñ™é’Ø@;ÙTV€âS×¯@MÓÜŸúÔ§ðâ‰oøÓCòòV‚ÖÙ2Y­=m~ íÙ´dºðÄrE/‚•õj“Ð}Á[ë
Í=Â
Ä§ø!8þk>úßøA9ÕÂ>2É»›b,ÜÆWÏ~ö³UQÙ­ÜR¤%t¦`“úr4E­ÝfÕ@hÑœ++;…®Åð).«Xfˆ£šÈeý‰ð¸8¼™€rm?*ƒ%§ú3uuÒF³[ÇEõØÖÖÖÖÖÖÖÖÖ¶_nZ²M•Ié«_ýªè] ˆÕ?Òk¶¶öuÿøÇ±Qûj{ÂboÙ^¢$/ê/ê<ÖÎ¼Ò­ÔF;r[˜Âë$Ü'Ìåßc+PTv}XuÉê3&¬ã,•õätŠÙæùJdÝç—çF£Cz"ÚµÐd²¡|ä#}NXrpçÚÛ;FªÜÝÝ§­rÊ)¢@ '€0N¸(ØõÓ„zè¶ b5@–¤€ÃÕ],‚$·ŽeZ^à†Nº•$u`hú¾ìó¹2ÒÒUËÜ{x¸£~Ñ˜¨ NbÇô£MÛ(ÐmEÊê)&K€‚³0ã¶üo|‡	mp>ñÄÏèÏFì»ÝínûªÁ(«k®¹Fë5ÝÈB<Éú»ÔE=9¯€˜é}™¹Ld„ž@Ÿ–ŽA¨—_~9=ÒÛzŸˆßƒ9>`’qôLvCàQ²f¢çãÑl¤vUM’Lì€ÃÀ
0M7X³%‡°?ùZŒräËÃ<ˆm£lÆ	€S‰h£™o²üsà>•#J5äžÉvq“kÛÆU¯ã6ý¬ÝÕmmmmmmmmmmÆ¦ÚÁ^ðàˆ}]2üPo°KUƒ'Ü®"ÛVZ?_‰f}Ôu_Ç»/Á±X¼›¶”?^'Ã›Ã‹´=³Q¤ø	×°?ÄtVed@í÷ÐÍ01¡]ÂWU¸ì¾ð…¶‘òÝ_ýõ„¹%kBd¦	¤8ï¼ó|XóR¥Å‚0J4£;N[Ûì²!¿EÍ Xý:³Hö\:J&(_Ñ[õ_]›œº„`|E^]ž 9×JÝÙ¶Oª{6÷À½â¯dÊãÆã˜„§8Hdä4HŸ:Åv±j&g—XsÆI#áÆå3ÖBžûÜçzªóæ°›Íaè;Üá·#Ž´OmUzFŒlS’öþìFóxb¡ah_˜ú¯	Šø>ŽXó ’4ÙqÄÞpÃ"rîu¯{½ò ]Ñq<(ŠsÎ9Ç§YžBÙ"úü…/|Áo/A³ ÄÛ@ÿÅÜ4à©©ù<>üás~¸XµF¸cëN#â™+ù1^oÄ8B†a`•BF†N*ô]îr—ƒ™ÒÞÖÖÖÖÖÖÖÖÖv º+½H¸¤-ÜÙ6 d‚ÇZ%y1rGlºX-«wÑëo¹÷(éx™Ë»y“ìß"‡½Qv¦(
õÉO~Ò6­AÒ&Ü&ìõþÁ?@IÆ»ôÒKáË4ÄÞö¶·Ñn¶§¤a/ç ÀÄhXÏHR¥Èl¿¸y²ñ“°÷„mmlÊîÅ!”ˆ”“º³:u‹z©ã`â>à ÿÚ ›P¹…“ÑÏÑ¶½lå‡“˜sÓhì“Ÿ/€]Uë8ªSŠPqP<ð!ê.4j`:(ê(Ã²Kßdš‘\ƒ¼Ä´§ÑZ‘â£ËL$Šþl`ß‡™*ý4˜8Ž•ŒŠ«1+«bÝ:¨Ät%}“	…6‚]ŠK(€’ôE“4ÓBE9 ôõ‘Ï|æ3|3Ø¾³õtŸxC>÷Üs¯»î:m	Ý`¢5E%Œ0®Ý*Ï¤ëˆ
Ç¨iVÜåŒ1í2KµpÙe—!>ÍÍ£†vñ.CÖâÚÏïÒEÉºEã¯Ñ/Ä…='‡¡ó‘sìG¹Ù8×ŸùÌg–G¡Ã>ÚÚÚÚÚÚÚÚÚÚ„µO[D1¼Vü¢‰ÇÌ?yâ	t[Øt	1¯ÃP®MÎ~šèo 0”Kø¢$˜')Ë3—…+Ç‚V,ŒÃ5>2Ã/Õ¯¼òJÛ3¼Ë|ä#(u„¸ÙÜ—P•›4’+ê}ýó»se[Û÷ÐÖÐ—5•˜«FƒQ§~Å¸W& ¬&¶Ý0"à]ïædJ@ñÖÙàþiÛ›V¤Z@'Öm¨¸¼Æ^µË!3#ƒß©ÄLvÆv-Z—/Fy`â¯]Ñ62iÖ¤ƒÿéOZN`ƒÿ[Þò™÷‚½ú,ÀŽ»‘RÕq+îåu‡¨'”N@<•$!½r¨Ä13!DOþTªàHÝ:ÄY(Ï÷¿ÿ}¥JóÄ\™‰õ³Ÿý,äÌZ\ïƒv†Ê+k¸ðüXáÚ˜³®0F’•[¤Ò¨‡Gòb„ž+ÊÍêK5iÒa¯ú£ÉÆÜ0¾„b$ŒêäÕPý4¿xV8<sñÈÅÚùêÔ¦ÆÀ7cUcôãNÈ[ð¦<øÁî‘§­­­­­­­­­íÀ±ÓO?]jšo|ãöxÐä”l& t@Õ‘Þ5âªö˜,‹Èìþk‹ó+XÏù3Ð3Ü!¤¶”aÁôµ7«=Øøö‡v†hbjÁ(uþ…U¤:nºé&ùÍ0Ý¥:ƒÔL²Y­©»Ã;ìÐC.iæW[ÛÞ}PM¿öµ¯NFçì8Y7“‘l`# Î ôñÓIÈt1Ô€ÞËõ;Ÿyæ™@½ª5¾@#sÁvP¹4ƒÊá6†
à`Ç&ÊšÖç> ´ŽR?ÈÊŒëšÇÆ¤‘ì“6cb¢Ú¬ˆÌŒ@O3£·€&{‹1åàF5y_4gEj!ý¦»AI@€¡ÝÓä¨„-]htPDé¹/¯ÿ€<@iP–¾sB@ëŠoûÛÊ
Ya*7Ð ÍqEW+™ˆ;GT-jõj3ÀùÐ–“‡°4FYçªMµ–•LþäŸË/–‡^cHjžuÉÇð­o}‹þF½ŽvÛmmmmmmmmmmŽ‘|âŸ(Tb‚©D×ri. [Á$µÿ•]‡-¿q3s  ÐÁŽ7Êµ(áêÞ”Ì<eEùEÃ’«ï˜ yPñÔöÕ¹Æ~Œ˜†Í6J‰~uÊ3šób’¥	ç«Á©¶¶½iÈ†Ø…ñÀUdƒÔõÇC°˜‘îˆyßûÞ‡„˜kú>á…‡?üá]à{ßB"¦)×ƒÄ©üPS^ë5SàùIGYÛ±öµ“¬kÜ!ë·³ôò?››¼|°9:÷»ßýî~÷»ç!o{ÛÛN<‘Ký÷Z‰ùÄÔ‘Ÿ\C^V!Dö¡@ù Óidå ÜÉûBxŠr¨„¾Zõ§(®žûÅ-j$O{ÚÓ¾ûÝïòUk±F'(p­:”?Ø7™¢Ón .6vif1´s…l\*Ÿo¥å«Gr\óD»c"	=!.¸9wøÛõ?Ä+c©#‰ˆ.õ()õpè’ëñ§­­­­­­­­­í 1,ªpL5¢×ýê¯þêâ†p¢nYI–’¾Ô‚½ë[¶âÿã@± »¯lÞ&ûd»âJæÎ>ô¡}âŸP 	bU8õ/|4g”g±Ûþ:K$Å€Ël;g3&±±Eqýo}ë[‚
xN[UV³‰•ˆs·ê¶¶½c?þã?þÁ~R³T\~}„Ñèa¬±î+Hµ‚2åp÷àæ  Rï}ï{O:é¤Ym{ÝÜå÷ºÇ7 Ž€žp½ìRÑ(ŸÜ¼‰£crœ7ÍÐça×$È»Œ[Bþ·¿÷÷þBëi§¦€žt4ýäƒ6Žè£÷•còC©gL.;ï«y›ûj&M¨Ðb!T¯IP0D6€ªR•³%‡~AËXa*9ug·¤(8hí>÷¹Ï§>õ)ÃÑ{ÞóÊ$ûØÇžÿüç“îQŒJ¬ØÍŽ³œSþ£QÊõ>9„\øDy†‡´^Œõ
’óu7ÓS«ŽI¦±Z# -2ÏºEv¼¼#ÖNjö˜cŽÑ°¥¯àb×rît§;ÍöQòÌ¶¶¶¶¶¶¶¶¶¶¶=eYžxâ‰€NûºR˜h2VÔp6x^6“6‘+­,êã·E‘céu¢†1æøÚH|ygž|}#Øhä8g«fÏ†4&P‚A–A`b[e‚ÚJ²Ô#–r«]–½œSA¬®·Ý²õ’ŸGéa¥"Ž8âôŸ¨yòø¼ë]ïŠÔ6©¬¥ÇãÉ§ÚÚöÂ°™ÑîÈ˜ÉÆ!%Ñë§<ñ`&ª¼PòwqGAe8„é¸?2)tÖèóÞ­edLó#PjöÔ§>œ‡Âú§1šlú3#T-«DtÝÅÉeüsÌX¸~¾Üäm{ýë_Aç[=jÄ

wÞ	Æ‡šœÆÅ·…Šþáþ¡¶­ÐJ¢dÅü[(¿2a}îO¢nŽEËSË}~ÀÏ}“À£¸ÍAeè babôà±>R”d5¼j„Æ(ÞFp#ð´òÔ†¿óïX¢8Cjœôs­š¢=i™~BÅ£`™TiWs²3ñ-ƒ$ŸÁÇ?þqLvÇžðæ›ov½”	Y.Í{ÜãåG)ÏzDmmmmmmmmmmˆUz"8)Î ºðÜR+^dCÿà?peˆH¶‚6µuŒ€à6
q¬Öbž`Í|yÂÝ.Œu~.—ÙöÛ§Ù>ye¡ÄÒø ‰ã}ô£EUFd¶=Ãózàˆ’¦ïÿû/fÿ+à“-š‚~4–´oá8C7Ô‚kÆ}fëi´µíXKÇ¤~@|#’“q’j3 Í`ÑÞ]ŽlIjúAt…
ýþïÿ>Øúó¤'=	ä<ö¨ábüõ¶=Z¹1RËçŸ>hO=ö¹áhªU¥ó)°“Ïm"e@“jŒzÉdÊ4‰(2»œþ¸% fg2Mžç¾÷½oéþïd;üðÃ‰f$=cJ —Ö|ª^—º–'~âbI«‹¤1ÔGt± ŸÊ'Ù`¼rÄd‹ó^ÿµäxÊSž¢`­Ä`Í2[cS³<Ö;9æ(`„EZ}
3!`K¤…ë5¶+®¸FÌÅÈNóN-„g0iŸêHÍ:æ1jUÛÎWtRB(Ïœ7@ÿÁÜ<•ð/Ï ‘H#yû¹qºÏz&{[[[[[[[[[Ûk%æ@KQ”7rîâ>0${›mû‚¤öû
œ¦à/!ý!¼¸Õ¦’,m’^š<giÔóD@#»¯Ûq%¼Ý«¡SÑÄ€òÀ…ËÊáÕ¯~µwýÈq÷Êâ|eøAR†eôœç<(èy6Gók»8î'»bŽÔæÉfrÜE7ÒÔÖ¶Á tLùßœÄ)•ÕAðGèÕD~uœ‡ëy¹Cg`Ð $lÁÏ}îs ÍÏ|æ3ñQ5+pï˜–#<’"-µááb˜‚ÛJsc’0 ’@ÖBï\¦~kZ­ÐRÿšz¤àËSUÀÝ/¦“1â@“PË òú‹ÐŸ Ò­Æ´½	«
Zjù‘œêWd¬‚õSçPYv§(1
áqµÀ{æ,@[‰Áâ5á2'`Ëzþ«ÝŽ¸p|êi·|êÊ0é1ÔQ¶
’›šÏÃùÕ¹1ÜMÍVeAf‘ûpÀUàÁŒl¹›óïxÇ;Œ~Èã]yå•ÅN8á¯vÇ;Þ±uŸÛÚÚÚÚÚÚÚÚÚX+ ÚN†Ì%E;3Ú‹-Jö6v8bÀŸõ¬gj+7Þx£ƒá£õ(›óì7²Wô™Ôç»/ÁQŠ„+0èQD5¡¾Á¤qÏfÌŸâ£=¿ÀO)zÐ|.ºè"ÊžhË(T$AÉ†´ú¼îºë^ò’—'±¿”Û¢ÔrJ²6‡¥mRêÌ‹°òD©sQÓyG…T·µµfô€3
øÀèŒ,ñjÄ"ëÏ]ŽrApH`9Æœ1Šrn‘ø0‚ˆÐ¡3±×Œ
-¬™ÂôG^Iý‚ÌJ2Â\“	¥4 F¡ç ®E|.DuQ‹cµC˜è@ØÄ&Ú¸"f¢Ä²Ã-Mô•¯|%´1Ðy#Xç³Ÿýìh¦§dV ñ)@}¦t5ð¥È Ža…¬pL²jj§Él{aæÕîr—»DlÄ+Óì²£ÿƒwŒ\†¶*C^¶„š(˜Þ±krÄ1B)°x3jÁñ¤8ìŒT.0Ki[ÚI¶)%5¼Ä·M”dFHÚå·T_¾ïV­	æð¯nÆ4?Ê£ÏÿOþÉ?±úò) ÌøvõÕWs­%—f­|züikkkkkkkkk[µ×: ìßøÆ'?ùIè³}—½‡ý„åçæ&YÜ1VxÚ^ÂŽÂ¼[q²‰G®Kã^e¤ÝSÞhC>&UŸÜ' ÀAÏ_WÚðüÊ¯üŠ ÒË.»Ì6˜ú¤0Ohr¸6ëìp\S²Uúˆ)OÒ=MÀè¥féA3ÛÚvþ€OQC¸fÐK¢ÑÊÍeðÉqvéiË€)vÞ‹$hE¶Õñù‰Æð/êð³üØãÃž¨Ó®%–„ô	sùæ7¿	¹}õT±)ÆÜWYg#O<ª<ÚMcÒ6SäúùÇiä
L|Ë[Þ‚õƒÖ ö‹Ú¯'Ô€ñµêt‡D®Ò¶ã†é]ºH9@6¹ÝÁ•Ê?ŠÃºÀô!yˆZ;ë¬³TYT°ÔÑÆÛqŠËÑgsç;ßÙR‡(9dî‹×Hä™à&G“ÓbÁ»ÄÁ ½F…g‰B‹3>Þ«;$Ää¨aÀŽ]¯x³ Òàù	œI~ÂîHíŒ	$“¶ÚÙú…õëzÔ”¨p 9ût¥`²w¿ûÝH –gÞ‹¾UÙdAÕã[[[[[[[[[[ÛªÂ°b¶y{ÙË^†d÷S?õS„&ûDþ¾éMoÊCJtölT`+(3Ï{Þódì-m9œ©­#D†ø`È€ÅŒbfXcµlmÏ3nÎi+0ÓwÆ£'‘¶.hÌH&ÕÖ[Xã'llÀè‚g·(\Gd9ut@îQÛÚÚö¦ÝáwàÓ2¬Å*)kGÃ&ÒÏF³1aéR¯[rºÞXg<4 á!B<eî¢Dˆ“éüTé¹Ú¶Ý‚>Ã1áÎü¯nár’c¥ä gÒxZ‚©Jœ„%y\¨ëú‘@#ÏÔý)!È:ø°‡=,ßý«öá¤bŒ¸gÌà!AÇ¢7ÕkF±ì*}è\EAsúï>ÎGÚDeÁå:ê¨“N:IˆÒ-$BúüÌg>Óà ¹1¸’k¹uÓM7ùüå_þeÅ—7hÀë—¦hù„’Ösü"Š:ÿ¥íãOƒ…K&€u”4ÆŠˆ¦s¹Ê—f%dyI« jÜÍ×¾ØÚyË9ƒìLÑÞ
óÔSOE²æ9xèCJÙ¬‡µ¶¶¶¶¶¶¶¶¶¶MØ³€ö"ÀHÇÑGöå/˜h¾ôÒKå>ò‰ÓdCð}ãß(B\„fX~¡ÉØÏØ%M“m	–,ØF%Ç1$Å>Ä†ÄþçgögñË^øÂÚÿøº_AÕñ¯O}êSò,!Å8o“c£…vmÓ"]®?!ê6K(Tþnv#yì1Ë¥Ž´øF‹µÓ,ã¶¶¶-LC%úáDT!HM¹ßFÍß¥h#t&bGØ.'îH¸~à Jï_ 'ƒ º#Ó÷œ™ò¢äðº×½Î†úŸç¦üM[æA€ššŠŽsxÐ#å™EñVþƒ(P­–xÞ%m%Îkš£3NŠz,RbV(ºV1Ž×e@¥“ ¨I	(íø›z‚GÏ9ç"8 ÄïL27ÈÇÀ»L–d¶Já€±8=ôÐóÎ;/¹‚c™ÑŸú§:ªñN*gkªÿ×Ü´ÆQ%#*ÒÄ®i¢ÔK,º@ÌFK,š\¥îˆÕ8VÑlAÿ“ŠÐ’¯ÒÆ d§ïø4š©&«D£¥®ALÆ+€Öª…¦á1ÌT­ÛÚÚÚÚÚÚÚÚÚÚvašY«ì ÑO~ò“ÑÁ¨$;¾ç=ïIƒÒyq¯HLb6í+’bRœT„Ù.‚’m QollÝím8sl`Ä6<;¶w˜ÙVÊV#ÆŽåÃþ0Â5CCôêË/¿HûNô±°w0=§ÏñÉ¡3žÐFëÊ+„*÷¹JŽ¹÷<mmm[0áYÈ†Æ@ÞµE,rÂf]8Æ3'¸ÄÉ¾öN;–äO(3É”ïòßCè¿øâ‹;î8ÕaòŠŽs¼§<¦ 4ÔNgèHª–š©6ÙEŽ#ÿuqâ~¶ @×Wü/¬‰o2AïGåÉ‡-‚JÕUW]•Òˆ´WÓqVÈ
—'@Ù*L] «è¬k@6u…ìO«tÚÙ*Ý Ëßîv·Ë1‰doUácÔ“¯¶j”PJX[,Ìš…V@ç”-ÜÙð’å™ÒÓ¶ÈgÈµ)Fô¨3\.¶~~í3—¥vô7YlÃÜ0á!ƒ‰Cº=ó3žñ”g‹´ÓN;íï|§µešt­Ðzjkkkkkkkk;¨í`[Oˆs ÌEerìÓnÁŸÒa¸*‘Æ.%‘æööB¶åvï´¤ÁÊ‚.±up”„ðƒ´£LEËl§}
|¾LUê=Ù~/>í$¹ß¤Ö6ª¾Þê´µµmÊF~%Â ÅX‡N˜Pô"VÆ¹Õz÷{$A÷1tà5€$P€lÀ’#°¦µƒöÐ|×& µ k²£ZÍ_©8X'4-|Ïèlñ$iŽÿ4·ÿûSqñŒÔø5 ]©]¡úÊ[dƒ5Çíw g°™éÕJ r%Ñ#ö‚xåQ%¦X±âØö_ÇÏÍëÃI ë°Õ0k‰”Ò„`@ndjTÑ¬ˆþð‡¿üå/yfqØE(æ£Š}xú0z¾ŸÊ'ë1%œá(ªô9#Ù Ä9_ÑJaÊ¾_Ë¢? 	6¨ÒzVQJ¹aÆ¨1#t\/AºU·‡$ì¦‹<ç9Ï©wåv×»ÞõÞ÷¾÷þ"kÞÖÖÖÖÖÖÖÖÖ¶÷ö½ù/úŒ•sÌ1ÇØA–©”‚˜ímÝñ\ì7Øi|õ«_E}"âAœqÜð/EVüÙÖÖÖ¶o­& "Šê ¨Ap~ÿ÷?ÜÀ¿^°õ¯Ðœÿ07ÐÎà0rìAÜüD	ÄÉWËëZØ¾”< %Ó„•$ºÑßøõ_ÿõ1€£?­ú
À‡ì¼‹jÁ¢|Aé±ì²=„\×Ó}FåuˆÿuÿÔ-’È}ÎÂ Z4UòÔý»¹÷—RÅ1v#·­`ƒ{º†úÖ¾ðÄ­€°„†énEû@jr L@1Zg‚À¬¦Pž¡ÏRqç!c¢4C¨×Ÿš"å€>¬ÙÐÄYA90˜€€ó'3—)N±ÿÕÜr¦²IO²A¦eY^¬¬´p8µÇ@‹äjÅâ×·¡›÷¹Ï}¼š¤H¸.¸ EíÛÚÚÚÚÚÚÚÚÚ–lÚ‹%œ#$Û¿ÛÜæ6 ié›ðtD‹û|Üãgw!A}Ìz¶v–óñæ]Ômmm;Êô !¨b‚ŒE{¼¸~¢¹	Ó³$; ?H¸Tì!›ùœtÃìÉhÏÙµIN
!<GÛè	ýT/¥ß=‚Èê–¡VYÀÓÐÒ	¥½À;ŸnR‰à–ZtuÓ~Ó}®¬ƒûµ®1œñÄOäM‰%BçyMèd\8è¥}'¤rÅ¢:hv¥`R+œ(J« d^?A•+Ê`†¥º8â"eÄáŸ¿¾a(™d µUÞ/íà«ù% î3TZƒÔÞ”°a
*ô€q Äw	ŽÒwÖ†Ó>7ò”Œé4WxÑü–ÊÀ…‘tH·ª!ÞM'DÜŸøDËÅÙœþ|ÆgPµîÁ§­­­­­­­­­íÿoûcÜë^Û&ãI¡•å¿ÙåW„éRT%bÍ³5”4ÚÚÚÚöæ\`h¢d
BEj"á¦XÏ‹Rð à,IÉÇ>ö1ÒùE¹ÒÁkzÜCuJK
º§Cð$~‚o[bàÑâ&W‡a
nCàuÞe¥¶1
nŒ<è‰('³£óyÜš:÷Ç‚ÍÁãÿxN\%Y”ÛàžU\…„.j@GÙ~­vô8ý.ªëÎ_xá…³A°â€±óÏ?_ªgôgþ-±eðeÞi3¼¾cè³?ÚáßþÛ›ƒJ›qŒ}¬é‚¤SÔš(0:ò&'YûEÏW°àì¥£Ó"©õ@§¢…qdìr[C™SlÁç?ÿyŒ~šdÁ³,¬€’…ÚÚÚÚÚÚÚÚÚ´Mf¯t·qK¹Xžã¿6ÙèòokkÛ-8—¨ª¬$$æÂÁ„WâÓYMœd™›`”Ð"7hbbŒR„Àë“ô)§œÒå¿½Yð/‘:XÌˆ¢0ß Î€NÈ2O¨ÎiÁv9à~øîw¿û­o}í´N°®·Kíï‰vAÝ\[’z÷-oyºèdnÝË™!½kæ\ÁÞqü‰HúbÂñZ1ø•^Ç¥—^
“¹êz2Ïæhæ~:žLê×‹]Aè¦Œ¬ádÞóž÷ˆ‡ 
Osƒ,•r0JüÁüA¼_Ú›tŽßþö·AÕÐ^TqÃZKvehõ£$ý(G>6ÝƒŒ}Å3òDšcRk:ŸÿznúÁz#˜§’)ÑÃ òCœ!ã*úšH¸¥YFÚÚÚÚÚÚÚÚÚÚÌmg[[[[[ÛÖf 44"x„›rëfEŸGt€K’p{ 	oô}ï{°‰Âþì@¤yîÃz¬Üƒ×\s\O%B3‘7£K…â«\ˆ©‡B–}b›ª×ûï˜sr}'Ä„ïç"úÚ–1¸êaïxÇ;¨ýJ¨È‚œ[E´@_K)âOþäOÀÙ`zÂÇ7Þxã~½´éí"ÆîyÏ{z¦XBþ[vßøßðÖoûÛ±¼©X|ä#qæ¦›nòîÜÆŠ>7È>
må¸L|‘µXrÌ%S
?“¨‹ÑÂ˜Î¿h V'åfd&™kÔÊõ²U-ëJ*šóì5¯yM^ÓKéb§Ÿ~zî’`w[[[[[[[[[ÛÔ¨6	º­­­­mË–éãéOºq0â A¥¿±>¸AN,L'¡ôŽ	À ¡hƒÂÕaLbðråïÊt"Üm±b²ã™ªG¢ÏFUJ!kP<%_48B8ÍeÀbÇSQ]Jm^M|Nò7•NÚøƒüàe—]VÒU@Qã½ˆ¸üòËßÿþ÷ãÆF)[¹E¥aþ³&Á£?Õ•á$~¼ùæ›÷ë]´ÈäEy–RÏátíµ×‚qçw~‡ÿ	°«}úóMoz†>Íq	Š±bÑh_÷º×Ñåp1‰ÿUÈ| `2`} âEy“Å’WžAœSA_ùÊWüzÐ‹>¶ už Oîüº3¿ú«¿úáøÝï~·3RDò¥aÁChûÒÚÚÚÚÚÚÚÚÚdÔ »d\þ¶µµµµµmÖîq{Pg¦gŠuX°cI.L˜†+ÀÇ`:Á.á>¡yF5y }§;Ýé7ó7áJï}ï{K º™ƒÛeà]$SLvØz&Ä-©ð¢8ì“rnò@‚á0OÕKØ¸¥orôÚÅV'¥,…ß…$ò@@i¡ÏQÞØ¯ŽK¯“O>Yc~ík_Ë[ã5(OM6ZzÐ«zp*>¯JùË¹‘›p†?àºë®ûèG?šRÚËŠD¥ã¼ã¿áo ûÂÖAÏšÜ7¾ñ 2øÞ+p0 Q¿ÿs3DP€2sZ`ÿËù/©Ä ?þñSïEA Cœd)Ü<Ñ?Y”ÞVÎØý#åyÙ2jå A†DÎ³Ã;Löig¤F|ó›ß|ýõ×ÿÍ¿ù7µêW¿úÕö¸|*ø }immmmmmmmmmmmmmmmS‹ó¡HJƒ CdÞšæod7*Ó`ŽÁFà$ë=èAX„ä8¶ßç>÷™5 ½­vÇ;Þö‡UÑÛ ÉŽG¹ÛÐœÁjÉ´èê*XA˜Ë¹øÏæ–x&àƒ%Ö±‚?Ñ{ßö¶·éžóœç\|ñÅ@º¦Ó\Ï8ã]F“†Q+IC(CbÁÊv)0:‘†ø+ð”|T×AØ_ÿú×á­pí±oîäqcñ	:ê¨c=ö©O}êyç'å ×äðxðU¯zykþÜÏý\çÄ[ Ã¦ßùÎw"JãækfD¢AÊö3ŸùŒ/F&[3VÎ4—TQ-¹â-&¢ÛJuL™‹'ÂÐ“Jñðtr28Î\çž{®÷ÂàþÞ÷¾GÁÃ‹¼þõ¯§¾’÷­¬Ô;¿ÊÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚö¶V@yZ„ÀÿùÜ < ã`‘› c€{Â€¨yüãüÁIIðÜã÷8 L
ÖP²ó¸nc…>ô¡}ãßŠhØÍ+˜¨©¨kXZ¾ÁBå`yPÔ¢ˆúÄBºåO•xÃ7ŸzipyÞíÉ/GbEÓº×½îu@vœŸüÉŸß+ywýE³W‹ ôˆ™æ¤ø€d†ÔAÀ²Š=ø&RðW\1Éh·o­X½y¤’<u'\ã“Æ÷#ñü—¿üå¤Ÿ/ºè"]îG–rˆŒþY~×»ÞE½!ZSDÕ‡Dc+EJM¥‡@¢tÐä’Ìfnž Ð«)^ÖñR^ÿÄ+ =ž®ábà'?ùÉ½èE!ïyä‘·¹ÍmÈ†p«wÜqäïòâí<kkkkkkkkkkkkkkkkÛÐ
BÂåÐ#È3± ²õ“ª —‡çÐ„þ ˜€k`ºgŸ}6Ä†;>IWÇîÛ¡‡J¦¾Ÿº+ÝçÔ pƒ!U	3¥' eSMUË¾¤¯jx-¥n¤
(>Ãì¢ÄK…?Fsã@ªßÂøÀþìÏþì©§žJ/Bè@ ùJ0¸Ð9ááªôÞÔ—þ‚þü»¿û»>)Õì´~±ø0@gbEöI’‚˜óÏzÖ³P›éœ47@Æe®ê"ÇüÃþð¼à°i/Jöé2 ³¢@:æö Ö¡4Ð¢)œ*Fð—~é—HE—VÆ_/³ò¾pÆð‡…7½¢^´X2Õá“&µ_qRjÄzwµLÙÆ±Wž´„¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶]aSÐ$ÄQ*TÎ	=p—4-|[4j\hÔtrÃ•äì:óÌ3ÁÜð©C9dvÞ ôvÒ1ÀNáà&úÝÀeÐÎ@Šƒ,ÉzI×V°uÎ*ÁO—j‚»€Dï¯ýÚ¯á´BñÐWð€,Ñ¼Ô1ÇƒÀ{Î9çÀÜy\Rt#|¿Z‚£J˜c&p§òÅ+^AÞä1)•ÙŽ KÚÖ,jÁëçOjð÷ªâ4ß€/ßö¶·}Ò“žôGôGú$š®ýóŸÿ|ÂÙ”ß!…@–G[ø~àøÄ'>á2Äg¥Á{AÈp„=]bnYyh²ƒXø3âæ“¢®â5ìÄ%³:¦ŸŽûÓÃÈ™IrZg‘jrvK¶•«®º
§;E‘7=ðœ+mmmmmmmmmmmmmmmmÛi@‹À=Ð¸0®"pgSÒÏ“L_EWŒ4n#aˆÒŸþéŸ~ùË_¦¿m‚ÙMùÛ¶fcéÉùFW-â>«JLîµ"D3~‚úS}‚ðÉ	çÁbz·Eï(.Qráêú-oy¥UŒîú”§<em8ÀÊœ ¤’šŽmÏ7Ê€7)´Q}8$tîEHE¹Uh‚öyÂjW©¾ü	8Æ_Xj>à»îœçÎ
n€G_zé¥\p2þ_øBTe1`hM²Ì¹EŠÇŸT,|¦(´U°»óüÇŒ%4­9A¥ˆT¥\JIs‚D—k$ª2•?sô¯c«Žð©W$-9Z¶C%¯#@ÿ9äŒTœg:T
ÁËÞ÷¾÷­b©zF7	º­­­­­­­­­­­­­­­m¹õX,<A†þð‡D~—ÂgëHÜLú;ŽÁ‰ ÐN~ç;ß¹ûÝïŽòyÍ5×tlc=¢d>ä!AÈÎIh¡U•Ð:ôöÐH' iˆ·j¿þ»©Ú¡U@*%
 â·¿ýmüÖÇ>ö±w¾óÈ2æ(ÉžrKþÀ_^ê˜‰WNZÅ¸KzTê>ú \|Ï~ö³«r÷yëª÷=gn·¿ýíQ˜UîÉ'Ÿü¼ç=Éý”SNyÔ£EýY¶I : —ä_øì˜ égòâ
ŠêË¿šÛõ×_qÌYüõâÆM7M(Ì}C‡fINÍ•bô€A—Ì¨s²4J£À}÷¡þ±÷9õ’È ðèG?Z7¡F}ÄG8þþ÷¿/cêlŽ2¼­­­­­­­­­­­­­­­­m]žrÂ	'¼áo€ò€à†‘Øý¹$V¡HÂç£¾êž¨…Pà0ˆ,ì±Ç¦¼òÊ+»
¶Ñ`‚£7õ¨üG¬Y¥ ïQ€qŒ		ý)”>¸”%º& |ˆíðG"˜°³A$÷ #¹ç½Î:ë,eî}¿ô¥/aÎ®  !E¦t<JÖ¢êÓÝH±£ŸtÒI³}-1ü7nmÄy8 ÍˆÌpgÄg>B:°ã×¼æ5Ð[•þâ¿ûžj3ÜYèF3<òÜ
’VVT5¾øÅ/ÒÄPè¨¾xwš-Z©h5¶¾/bFtÖ˜•eˆöêâŒE`åt„’Û½/)y  ý¨'$ïOÒ1^_æDÁz®Üjmmmmmmmmmmmmmmmm›3xÊá‡.Mš!Ú,êôdü?vÛ :0Pèz#d¦ÍVÜO±í~ðƒMh†]Ûb go¾ùæpBvá>”ìàú¹Á¦£°¡vÔˆJw*íÅg°t~ÎÈÓ@:Ùó¨4Øhr÷CúP`+&/€Ew—¾™À*(g#PËW´ÎÊmlß`€W2#*Ô“t¸ßÿþ÷§ÔŒþŸ=÷Üs%	ôÌ|.¹äE! ¾ïThBì·~ë· ëÊ‡Âòu×]¤CC“©+Š¿ówþŽÑÀÈà‹ ywà)q½ŒHcrŸ„i¾B_{¢GãYÒ¸Õ‹RÑÆ¥ä3tÕš«¯¾Ú‹«\ ´A~ò'rÖYRÛÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚ¶fÏxÆ3`g°°H0P ·€8åIúÁ×ÀI0M7¬„xŽ‰Û*½öÚk»ü·l‡A	)~WÚÍŽÃ*­
zÑ‹^„¦ý‡(¥¨ õžz	úVÞÐÕ'zeÎ‡I:r¥AÛÔrÎèí¤~üÇüÀì¼Ýínw; ,­	Ø}tf&º‹9ñü)Ô «·ðh©¢‹Ã€ýÓúOÁGy$™šÙ Ò¾7ß+r³[ÐI-è€ß¬¬~ýZ¦AXù7¿ùM)þäës—y"Î§v7\…—ÐeF”ö'¢ôÓŸþtôç÷¿ÿý?ýÓ?PþÞÜ°ï½»¨ÎV$¡!Îá)Ã…ËS2‘:Ûá"0=~Žõ?ì¦yõþú×¿îET´w”ò^÷º—Ò~0‚îÌ¬eëÛÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÖ± (²„A!CÉDCÔ·`%ïDR&:ØSü+ 7å¿(Bÿ­o}k×Â¬úüð‡?Lv9jI…³‹3@-@œýKò·W¿úÕ¡ßVŠÈÍïNc˜èê&c^ÐÀ€­ùó]ïz—Üt³ƒ›Ë;Âd½x’é¥Ø+c4¸G¸3¤N@ç|(ëûÔ_ žw¹Ë]TëøC{ùÕ’c0-x´ì‚§Ÿ~zú,