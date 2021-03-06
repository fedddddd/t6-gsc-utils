# t6-gsc-utils
Adds some useful stuff to gsc, based on Matrix's [t6-gsc-helper](https://github.com/skiff/t6-gsc-helper)
# Features
* Adds chat notifies (eg. `level waittill("say", player, message)`)
* Adds a bunch of IO functions (`fopen`, `fread`, `fputs`...)
* Some other useful functions like `printf`, `cmdexecute`, `say`, `curl`, `system` ...
* Adds `notifynum` and `notifylevel` commands

# Commands
| Name | Description | Arguments | Example |
| --- | --- | --- | --- |
| notifynum | Notifies a player | clientnum, notifyname, ... | `notifynum 0 test argument1 argument2` |
| notifylevel | Notifies the level | notifyname, ... | `notifylevel test argument1 argument2` |
# Examples
IO functions work basically exactly the same as they do in C/C++
```c
init() {
  level.basepath = getDvar("fs_basepath") + "/" + getDvar("fs_basegame") + "/";
  path = level.basepath + "whatever.txt";
  
  file = fopen(path, "a+");
  
  text = fread(file); // fread reads the entire file, you can also use fgets(file, n) to read the first n chars
  
  fclose(file);
  
  /*
    printf also works similarly to C/C++ but only has %s
    eg. printf("%s, %s", 1, "2") -> "1, 2"
        printf(va("%s, %s", 1, "2")) -> "1, 2"
  */
  printf(text);
  
  // you can also use fgetc and feof if you desire
  file = fopen(path, "a+");
  
  eof = false;
  buf = "";
  
  while (!eof) {
    c = fgetc(file);
    eof = feof(file);
    
    if (!eof) {
      buf += c;
    }
  }
  
  fclose(file);
  printf(buf);
  
  // write to a file
  file = fopen(path, "a+");
  
  fputs("hello world\n", file);
  fprintf("hello world\n", file);
  
  fclose(file);
}
```

Chat notify example

```c
init () {
  level thread onPlayerMessage();
}

onPlayerMessage() {
  for (;;) {
    level waittill("say", player, message);
    
    player tell("You said: ^5" + message);
  }
}

```

cURL example

```c
init() {
  // The request is sent from a separate thread so it won't freeze the server
  request = curl("https://example.com");
  request waittill("done", result);
  printf(result);
}
```

# Full function/method list

| Name | Description | Type | Call on | Arguments | Return |
| --- | --- | --- | --- | --- | -- |
| fopen | Opens a file of given name with given mode, returns a file stream | function | - | *string* path, *string* mode | *FILE\** stream | 
| fclose | Closes a file stream | function | - | *FILE\** stream | *void* |
| fremove | Deletes a file | function | - | *string* path | *void* |
| fgetc | Returns the character currently pointed by the internal file position indicator of the given stream | function | - | *FILE\** stream | *void* |
| fgets | Reads file until *length* characters are read | function | - | *FILE\** stream, int length | *string* text |
| feof | Returns true if a stream's internal position reaches the end | function | - | *FILE\** stream | *bool* eof |
| fputs | Writes a string to a stream | function | - | *string* text, *FILE\** stream | *void* |
| fprintf | Writes a string to a stream | function | - | *string* text, *FILE\** stream | *void* |
| fread | Reads entire file | function | - | *FILE\** stream | *string* text |
| popen | Executes shell a command | function | - | *string* command | *FILE\** stream |
| pclose | Closes a popen stream | function | - | *FILE\** stream | *void* |
| system | Executes a shell command and returns the result | function | - | *string* command | *string* result |
| regexreplace | Replaces a sub string in a string based on a regex expression | function | - | *string* what, *string* expression, *string* with | *string* result |
| regexmatch | Checks if a string matches a regex expression |  function | - | *string* str, *string* expression | *int* matches |
| cleanstr | Cleans a string from color codes | function | - | *string* str | *string* cleaned |
| curl | Sends an http request to the given url, returns an object which is notified "done" when the request is done | function | - | *string* url | *object* request |
| say | Prints a message to a all players' chat | function | - | *string* message | *void* |
| tell | Prints a message to a player's chat | method | *player* | *string* message | *void* |
| rename | Renames a player | method | *player* | *string* name | *void* |
| resetname | Resets a player's name to the original | method | *player* | - | *void* |
| setclantag | Sets a player's clantag | method | *player* | *string* clantag | *void* |
| resetclantag | Resets a player's clantag to the original | method | *player* | - | *void* |
| time | Returns seconds since epoch | function | - | - | *int* seconds |
| date | Formats a date based on the given format | function | - | *string* format | *string* date |
| printf | Formats and prints a string to the console | function | - | *string* format, ... | *void* |
| va | Formats a string | function | - | *string* format, ... | *string* str |
| cmdexecute | Executes a command | function | - | *string* command | *void* |
| sendservercommand | Executes SV_GameSendServerCommand | function | - | *int* clientNum, *string* command | *void* |
| memset | Sets specified address' value | function | - | *int* address, *int* value | *void* |
