# gdb debugger config file

# should be written in .gdbinit (on OSX 10.12 or later)
set startup-with-shell off

# try to load .gdbinit file from every current directory
set auto-load local-gdbinit

# print unlimited array
set print elements 0

# save history
set history save on
set history size 10000
set history filename ~/.gdb_history
