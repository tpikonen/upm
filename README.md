# Ultra-minimalistic password manager

**upm** is a minimalistic password manager in the spirit of
[tpm](https://github.com/nmeum/tpm/) and
[spm](https://notabug.org/kl3/spm/), written in bash and coreutils
and using GnuPG 2.1 for crypto. It features a simple file format editable
with common tools (e.g. vim) and uses xclip by default to output your
passwords to the X selection buffer, so the passwords are not visible
when used.

upm is in fact so minimalistic, that it cannot by itself even edit the
password file (or vault). For adding and removing passwords, it is
recommended to use vim with a patched version of vim-gnupg,
which can be obtained from here: https://github.com/tpikonen/vim-gnupg .
This version of gnupg.vim allows the creation of random-padded
GnuPG-encrypted files which are used to store the password data.
If you don't need random padding, plain vim-gnupg
also works fine, as does any other editor with GnuPG support.

See below for details on how to create and update a password vault.

Also included is **rupm** - a script for using upm on a remote host via ssh.

## Installation

Copy the file `upm` to somewhere on your $PATH, e.g. `~/bin` and make it
executable.

Install the patched vim-gnupg from https://github.com/tpikonen/vim-gnupg
to vim plugin directory (usually `~/.vim/plugin`).

If you want to use the remote access version rupm, copy it to the
$PATH of the local system, and install upm and the patched vim-gnupg
to the remote system.

## Usage

### Password vault file format

upm stores keys, usernames and passwords in records comprised of three
consecutive lines. The first line contains the key to the record (the name
of a website for example), the second line has the username and
the third line contains the password. An empty line starts a new record.

In addition, two-line records containing only the key on the first line
and the password on the second (and last) line are also supported.
Naturally, trying to read a username from such a record results in an error.

Lines beginning with a comment character `#` are ignored.

If a record (a block of consecutive lines) contains more than three lines,
the lines after the third one are ignored.

The records are stored in a GnuPG-encrypted file. The first and the last line
of the file are ignored by upm and can be used for long random strings, i.e.
random padding. The random lines are regenerated on every write by the patched
version of vim-gnupg in order to make breaking the crypto of multiple, nearly
identical copies of the password vault harder.  The rationale for this is that
if you store your password vault file in a version control system, the
attacker who can access the current copy of the vault file likely also has
access to the older versions.

### Creating a password vault with vim

After installing the random-pad patched gnupg.vim, create a vault file:

```
vim vault.rpad
```

Note that the extension needs to be `.rpad` in order to make the regeneration
of random padding work automatically. If you do not want to use random padding,
use the extension `.gpg` to make the encryption and decryption automatic with
with vim-gnupg.

Give as recipient the key you want to use for encrypting your vault.

Give the commands `:set nowrap` and `:GPGPadRandom`. This will create two long
random lines to the beginning and end of the file.

In order to make editing the file easier in the future, you probably want to
add a vim modeline with at least `:set nowrap` as a second line. The modeline
below also enables folds for the upm file format, conveniently hiding
the passwords from view when you open the file with vim:

```
# vim: set nowrap foldmethod=expr foldexpr=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum+1)=~'\\S'?'<1'\:1:'
```

You can then start adding your key / username / password lines to the file.
Here's an example with two records, one 3 lines and the second 2 lines long
(the random strings in the beginning and end of the file are omitted):

```
# vim: set nowrap foldmethod=expr foldexpr=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum+1)=~'\\S'?'<1'\:1:

test
user
pass

another
pass2

```

Here's how it should look like in an 80 column terminal with the random padding
and folds closed:

```
+--  3 lines: XzimHYZ5KVNYlbGL7oyzqGL0ZTVqY1cc7P5KFhT2HoCfE55kb7lNJSDd8ZtnaebTtx
+--  4 lines: test--------------------------------------------------------------
+--  3 lines: another-----------------------------------------------------------
+--  1 line: c0Kj2txRpJN8FSEHBZhIsTzI/a+FC0KiGks8Ji8rM7uDQzyD5ngthnTaAO3w272oo5w
```

### Using upm

Once your password vault is ready, you can configure upm to find it by either
setting the environment variable $UPMFILE to point to it, or by defining this
variable in the configuration file `~/.config/upm/upm.conf`. Use the supplied
example configuration as a start.

The usage of upm can be seen from the usage message which upm outputs if
there is an error in the parameters given:

```
$ upm
Usage:
    upm [-o | -c] [-p] [<key> | pass <key> | user <key> | ls]

An ultra-minimalistic password manager.

Commands:
    pass <key>  (Default) Get password corresponding to the key.
                If just the key is given, this is the default.
    user <key>  Get the username corresponding to the key.
    ls          List all keys in vault. Outputs to stdout.

Options:
    -p      Get gpg passphrase from standard input.
    -c      Output to xclip (default).
    -o      Output to standard output.

Uses configuration from '/home/tpikonen/.config/upm/upm.conf' if it exists.

Error: Wrong number of arguments
```

To summarize, you can ask upm for a password to a given site with
`upm pass site` (or just `upm site`), username to a given site with
`upm user site` or the list of keys in the vault with `upm ls`.

You can also direct the output of 'pass' and 'user' commands to the
clipboard with the `-c` option (this is the default), or
to the standard output with the `-o` option.

The clipboard output gives by default two pastes and it clears the clipboard
automatically after 30 seconds, if the selection still contains the password
or username.

### Using rupm

It's also possible to use upm and a password vault located on a remote host
with rupm, a script which logs into the remote host, runs upm
there and directs the output to xclip or standard output as desired.

The configuration file at `~/.config/upm/upm.conf` (or the environment)
has the following configuration variables for rupm

* RUPM_HOST is the default host to log in to
* REMOTE_UPM_BIN gives the path to the upm command in the remote host

Otherwise the use of rupm is very similar to upm itself. Here's the compact
usage:

```
$ rupm
Usage:
    rupm [-o | -c] [-h <hostname>] [-b <command>] [<key> | pass <key> | user <key> | ls]

Remote access to upm, an ultra-minimalistic password manager.

Commands:
    pass <key>  (Default) Get password corresponding to the key.
                If just the key is given, this is the default.
    user <key>  Get the username corresponding to the key.
    ls          List all keys in vault. Outputs to stdout.

Options:
    -h <hostname>   Run upm with ssh in host <hostname>.
                    If this option is not given, the value of variable
                    'RUPM_HOST' from the environment or configuration
                    file is used.
    -b <command>    Use <command> as the upm binary in the remote host,
                    e.g. '~/bin/upm'.
                    If this option is not given, the value of variable
                    'REMOTE_UPM_BIN' from the environment or configuration
                    file is used.
    -c              Output to xclip (default).
    -o              Output to standard output.

Uses configuration from '/home/tpikonen/.config/upm/upm.conf' if it exists.

Error: Wrong number of arguments
```

The difference to local upm is options `-h` and `-b`, which correspond
to the configuration variables explained above.

Note that the GnuPG passphrase is always typed to the terminal when using rupm.
