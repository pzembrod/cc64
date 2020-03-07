/*
Copyright (c) 2012 Guillermo "Tordek" Freschi
Copyright (c) 2013 Sampsa "Tuplanolla" Kiiskinen

This is free software, and you are welcome to redistribute it
under certain conditions; see the LICENSE file for details.
*/

/*
Identifiers starting with CHEAT_ and cheat_ are reserved for internal use and
identifiers starting with cheat_test_, cheat_wrapped_ or cheat_unwrapped_ for
external use.
*/

#ifndef CHEAT_H
#define CHEAT_H

#ifndef __BASE_FILE__ /* This is indented so that older compilers ignore it. */
	#error "the __BASE_FILE__ preprocessor directive is not defined"
#endif

#ifndef __STDC_VERSION__
#define __STDC_VERSION__ 198912L /* This refers to ANSI X3.159-1989. */
#endif

#if __STDC_VERSION__ >= 199901L
#define CHEAT_MODERN
#endif

#ifdef _WIN32
#define CHEAT_WINDOWED
#endif

#if _POSIX_C_SOURCE >= 198809L
#define CHEAT_POSIXLY
#else
#ifdef __linux__
#define CHEAT_POSIXLY
#else
#ifdef __unix__
#define CHEAT_POSIXLY
#endif
#endif
#endif

#if _POSIX_C_SOURCE >= 200112L
#define CHEAT_VERY_POSIXLY
#endif

#ifdef __cplusplus
#define CHEAT_POSTMODERN
#endif

#if __GNUC__ >= 4
#define CHEAT_GNUTIFUL
#endif

#ifdef CHEAT_POSTMODERN
extern "C" {
#endif

/*
These headers are also
available externally even though
they do not need to be.
*/

#include <ctype.h>
#include <errno.h> /* errno */
#include <limits.h> /* INT_MAX */
#include <setjmp.h> /* jmp_buf */
#include <signal.h> /* SIGABRT, SIGFPE, SIGILL, SIGSEGV, SIGTERM */
#include <stdarg.h> /* va_list */
#include <stddef.h> /* NULL, size_t */
#include <stdio.h> /* BUFSIZ, FILE, stderr, stdout */
#include <stdlib.h> /* EXIT_FAILURE, EXIT_SUCCESS */
#include <string.h>

#ifdef CHEAT_MODERN
#include <stdbool.h> /* bool, false, true */
#else
#ifndef CHEAT_POSTMODERN
typedef int bool;
#define false (0)
#define true (!false)
#endif
#endif

#ifdef CHEAT_MODERN
#include <stdint.h> /* SIZE_MAX */
#else
#ifndef SIZE_MAX
#define SIZE_MAX ((size_t )-1)
#endif
#endif

/*
All nested conditions use
  #else
  #if
instead of
  #elif
since some compilers choke on the shorter form.
*/
#ifdef CHEAT_POSIXLY
#include <sys/types.h> /* pid_t, ssize_t */
#include <sys/wait.h>
#include <unistd.h> /* STDERR_FILENO, STDOUT_FILENO */
#ifdef CHEAT_VERY_POSIXLY
#include <sys/select.h> /* fd_set */
#else
#include <sys/time.h> /* fd_set */
#endif
#else
#ifdef CHEAT_WINDOWED
#include <windows.h> /* spaghetti */
#endif
#endif

/*
This is used to truncate too long string literals.
*/
#ifndef CHEAT_LIMIT
#ifdef CHEAT_POSTMODERN
#define CHEAT_LIMIT ((size_t )65535)
#else
#ifdef CHEAT_MODERN
#define CHEAT_LIMIT ((size_t )4095)
#else
#ifdef CHEAT_WINDOWED
#define CHEAT_LIMIT ((size_t )2047)
#else
#define CHEAT_LIMIT ((size_t )509)
#endif
#endif
#endif
#endif

/*
This is needed to be able to cast a void pointer to any other pointer type.
*/
#ifdef CHEAT_POSTMODERN
#define CHEAT_CAST(type, expression) \
	((type )expression)
#else
#define CHEAT_CAST(type, expression) \
	(expression)
#endif

/*
This disables GNU extensions for compilers that do not support them.
*/
#ifdef CHEAT_GNUTIFUL
#define __io__ __cold__ /* This is informational. */
#else
#define __attribute__(_)
#endif

/*
This makes comma placement automatic.
*/
#ifdef CHEAT_MODERN
#define CHEAT_VARIADIC
#else
#ifdef CHEAT_WINDOWED
#define CHEAT_VARIADIC
#endif
#endif

/*
These are needed to print size and pointer difference types correctly.
*/
#ifdef CHEAT_MODERN
#define CHEAT_SIZE_FORMAT "%zu"
#define CHEAT_SIZE_TYPE size_t
#define CHEAT_POINTER_FORMAT "%td"
#define CHEAT_POINTER_TYPE ptrdiff_t
#else
#define CHEAT_SIZE_FORMAT "%lu"
#define CHEAT_SIZE_TYPE long unsigned int
#define CHEAT_POINTER_FORMAT "%ld"
#define CHEAT_POINTER_TYPE long int
#endif

/*
These are ISO/IEC 6429 escape sequences for
communicating text attributes to terminal emulators.
*/
#define CHEAT_RESET "\033[0m" /* Some compilers do not understand '\x1b'. */
#define CHEAT_BOLD "\033[1m"
#define CHEAT_FOREGROUND_GRAY "\033[30;1m"
#define CHEAT_FOREGROUND_RED "\033[31;1m"
#define CHEAT_FOREGROUND_GREEN "\033[32;1m"
#define CHEAT_FOREGROUND_YELLOW "\033[33;1m"
#define CHEAT_FOREGROUND_BLUE "\033[34;1m"
#define CHEAT_FOREGROUND_MAGENTA "\033[35;1m"
#define CHEAT_FOREGROUND_CYAN "\033[36;1m"
#define CHEAT_FOREGROUND_WHITE "\033[37;1m"
#define CHEAT_BACKGROUND_BLACK "\033[40;1m"
#define CHEAT_BACKGROUND_RED "\033[41;1m"
#define CHEAT_BACKGROUND_GREEN "\033[42;1m"
#define CHEAT_BACKGROUND_YELLOW "\033[43;1m"
#define CHEAT_BACKGROUND_BLUE "\033[44;1m"
#define CHEAT_BACKGROUND_MAGENTA "\033[45;1m"
#define CHEAT_BACKGROUND_CYAN "\033[46;1m"
#define CHEAT_BACKGROUND_GRAY "\033[47;1m"

enum cheat_type {
	CHEAT_TESTER,
	CHEAT_UTILITY,
	CHEAT_TERMINATOR
};

enum cheat_subtype {
	CHEAT_NORMAL_TEST,
	CHEAT_IGNORED_TEST,
	CHEAT_SKIPPED_TEST,
	CHEAT_SET_UP_UTILITY,
	CHEAT_TEAR_DOWN_UTILITY,
	CHEAT_NOTHING
};

enum cheat_harness {
	CHEAT_UNSAFE,
	CHEAT_SAFE,
	CHEAT_DANGEROUS
};

enum cheat_style {
	CHEAT_PLAIN,
	CHEAT_COLORFUL,
	CHEAT_MINIMAL
};

enum cheat_outcome {
	CHEAT_SUCCESSFUL,
	CHEAT_FAILED,
	CHEAT_EXITED,
	CHEAT_CRASHED,
	CHEAT_TIMED_OUT,
	CHEAT_IGNORED,
	CHEAT_SKIPPED
};

/*
Test outcomes are reported through exit codes, but
some of them are reserved for the operating system, so
this is needed to move them out of the way.
For example POSIX allows
  0 ... 255
and in that range Windows allows
  35, 37, 40 ... 49, 73 ... 79, 81, 90 ... 99, 115 ... 116, 163, 165 ... 166,
  168 ... 169, 171 ... 172, 175 ... 179, 181, 184 ... 185, 204, 211, 213,
  217 ... 229, 235 ... 239 and 241 ... 253
of which long enough are
  40 ... 49 (9), 90 ... 99 (9), 217 ... 229 (12) and 241 ... 253 (12).
Therefore an
  #ifdef
maze is not necessary.
*/
#ifndef CHEAT_OFFSET /* This can be set externally. */
#define CHEAT_OFFSET ((int )40)
#endif

/*
Isolated tests that take too long to send data are terminated after this time.
*/
#ifndef CHEAT_TIME
#define CHEAT_TIME (2000) /* This is in milliseconds. */
#endif

/*
Repeated tests are obviously not repeated forever.
*/
#ifndef CHEAT_REPETITIONS
#define CHEAT_REPETITIONS ((size_t )256)
#endif

/*
These make preprocessor directives work like statements.
*/
#define CHEAT_BEGIN do {
#define CHEAT_END } while (false)

/*
This computes an upper bound for the string length of an unsigned integer type.
*/
#define CHEAT_INTEGER_LENGTH(type) \
	(CHAR_BIT * sizeof type / 3 + 1) /* This is derived from
			the base 2 logarithm of 10. */

/*
This prints an error message and terminates the program.
The error number is context sensitive and
might only contain the least significant bytes of the actual error code.
*/
#define cheat_death(message, number) \
	CHEAT_BEGIN \
		(void )fprintf(stderr, \
				"%s:%d: %s (0x%x)\n", \
				__FILE__, __LINE__, message, (unsigned int )number); \
		exit(EXIT_FAILURE); \
	CHEAT_END /* Using cheat_print(), cheat_exit() and
			cheat_suite is intentionally avoided here. */

/*
These could be defined as function types instead of function pointer types, but
that would be inconsistent with the standard library and
confuse some compilers.
*/
typedef void (* cheat_procedure)(void); /* A test or a utility procedure. */
typedef void (* cheat_handler)(int); /* A recovery procedure. */
typedef void (* cheat_copier)(char*, char const*, size_t); /* A procedure for
		copying strings. */

/*
It would not hurt to have
  __attribute__ ((__reorder__))
on any of these structures since they are only for internal use.
*/

struct cheat_unit {
	char const* name;
	enum cheat_type const type;
	enum cheat_subtype const subtype;
	cheat_procedure const procedure;
};

/*
This naming convention used here follows the notion that
lists have items,
arrays have elements,
arrays of structures have counts and
arrays of primitive types have sizes.
*/

struct cheat_string_array {
	size_t count;
	char** elements;
};

struct cheat_character_array {
	size_t size;
	char* elements;
};

struct cheat_string_list {
	size_t count;
	size_t capacity;
	char** items;
};

struct cheat_character_array_list {
	size_t count;
	size_t capacity;
	struct cheat_character_array* items;
};

struct cheat_statistics {
	size_t run; /* This includes tests that are ignored, but
			not tests that are skipped. */
	size_t successful; /* This includes tests that did nothing. */
	size_t failed; /* This includes tests that exited, crashed or timed out. */
};

struct cheat_suite {
	struct cheat_unit const* units; /* All tests and
			utility procedures (changes for each compilation). */

	cheat_handler handler; /* The procedure to handle the recovery from
			a fatal signal (changes for each compilation). */

	char* program; /* The name passed to
			the entry point (changes for each execution). */
	struct cheat_string_array arguments; /* The arguments passed to
			the entry point (changes for each execution). */

	bool force; /* Whether to force running ignored and
			skipped tests (changes for each execution). */

	bool timed; /* Whether tests that do not send messages within
			a time limit are terminated (changes for each execution). */

	bool quiet; /* Whether to capture output from
			stdout and stderr (changes for each execution). */

	enum cheat_harness harness; /* The security measures to
			use (changes for each execution). */

	enum cheat_style style; /* The way to
			print messages (changes for each execution). */

	struct cheat_statistics tests; /* The totals of
			various test outcomes (changes for each test). */

	char const* test_name; /* The name of
			the most recently run test (changes for each test). */
	enum cheat_outcome outcome; /* The outcome of
			the most recently run test (changes for each test). */

	FILE* message_stream; /* The auxiliary stream that
			gathers internal messages (changes for each test). */

	struct cheat_character_array_list messages; /* The messages related to
			the test suite (changes for each test). */
	struct cheat_character_array_list outputs; /* The captured output from
			stdout (changes for each test). */
	struct cheat_character_array_list errors; /* The captured output from
			stderr (changes for each test). */

	jmp_buf environment; /* The recovery point in case of
			a fatal signal (changes for each test). */
};

#ifdef CHEAT_POSIXLY
struct cheat_channel {
	int reader;
	int writer;
	bool active;
	struct cheat_character_array_list* list;
};
#else
#ifdef CHEAT_WINDOWED
struct cheat_channel { /* TODO Use this with pipes. */
	HANDLE reader;
	HANDLE writer;
	bool active;
	struct cheat_character_array_list* list;
};
#endif
#endif

/*
Procedures are ordered from more pure and general to
more effectful and domain specific.
*/

/*
Calculates the arithmetic mean of two sizes and returns it.
*/
__attribute__ ((__const__, __warn_unused_result__))
static size_t cheat_mean(size_t const size,
		size_t const another_size) {
	if (another_size < size)
		return another_size + (size - another_size) / 2;

	return size + (another_size - size) / 2;
}

/*
Returns a size that is incremented so that reallocation costs are minimized or
returns the old size unchanged in case it is maximal.
*/
__attribute__ ((__const__, __warn_unused_result__))
static size_t cheat_expand(size_t const size) {
	if (size < sizeof (int))
		return sizeof (int);

	if (size > SIZE_MAX / 2 + SIZE_MAX / 4)
		return cheat_mean(size, SIZE_MAX);

	return size + size / 2;
}

/*
Compares two strings and returns whether they are approximately equal.
Letter case is ignored and only single byte characters are guaranteed to work.
*/
__attribute__ ((__nonnull__, __pure__, __warn_unused_result__))
static bool cheat_compare(char const* const first,
		char const* const second) {
	size_t index;

	if (second == first)
		return true;

	for (index = 0;
			first[index] != '\0' && second[index] != '\0';
			++index)
		if (tolower(first[index]) != tolower(second[index]))
			return false;

	return tolower(first[index]) == tolower(second[index]);
}

/*
Finds the amount of conversion specifiers in a format string.
Valid specifiers start with '%' and are not immediately followed by '%' or '\0'.
*/
__attribute__ ((__nonnull__, __pure__, __warn_unused_result__))
static size_t cheat_format_specifiers(char const* const format) {
	size_t index;
	size_t count = 0;

	for (index = 0;
			format[index] != '\0';
			++index)
		if (format[index] == '%') {
			if (!(format[index + 1] == '%' || format[index + 1] == '\0'))
				++count;
			++index;
		}

	return count;
}

/*
Safely allocates memory for a block and returns a pointer to it or
returns NULL and sets errno in case of a failure.
*/
__attribute__ ((__malloc__, __warn_unused_result__))
static void* cheat_allocate_total(size_t const count, ...) {
	va_list list;
	size_t index;
	size_t size = 0;

	va_start(list, count);
	for (index = 0;
			index < count;
			++index) {
		size_t argument;

		argument = va_arg(list, size_t);
		if (size > SIZE_MAX - argument) {
			va_end(list);
			return NULL;
		}

		size += argument;
	}
	va_end(list);
	return malloc(size);
}

/*
Safely reallocates memory for an array and returns a pointer to it or
returns NULL and sets errno in case of a failure.
*/
__attribute__ ((__warn_unused_result__))
static void* cheat_reallocate_array(void* const pointer,
		size_t const count,
		size_t const size) {
	if (count > SIZE_MAX / size)
		return NULL;

	return realloc(pointer, count * size);
}

/*
Allocates a truncated string with a marker at its end if it is long enough or
returns NULL and sets errno in case of a failure.
*/
__attribute__ ((__malloc__, __nonnull__, __warn_unused_result__))
static char* cheat_allocate_truncated(char const* const literal,
		size_t const length,
		char const* const marker) {
	size_t literal_length;
	char* result;

	literal_length = strlen(literal);
	if (literal_length > length) {
		size_t marker_length;
		size_t paste_length;

		marker_length = strlen(marker);
		if (marker_length > length)
			return NULL;

		result = CHEAT_CAST(char*, malloc(length + 1));
		if (result == NULL)
			return NULL;

		paste_length = length - marker_length;
		memcpy(result, literal, paste_length);
		memcpy(&result[paste_length], marker, marker_length + 1);
	} else {
		result = CHEAT_CAST(char*, malloc(literal_length + 1));
		if (result == NULL)
			return NULL;

		memcpy(result, literal, literal_length + 1);
	}

	return result;
}

/*
Strips out ISO/IEC 6429 escape sequences from a string and
returns its new length.
*/
__attribute__ ((__nonnull__))
static size_t cheat_strip(char* const variable) {
	size_t in = 0;
	size_t out = 0;

	while (variable[in] != '\0') {
		if (variable[in] == '\033') {
			if (variable[in + 1] == '[') {
				size_t off;

				for (off = 2;
						variable[in + off] < '@' || variable[in + off] > '~';
						++off) {
					if (variable[in + off] == '\0') {
						memmove(&variable[out], &variable[in], off);
						out += off;
						break;
					}
				}
				in += off + 1;

				continue;
			} else if (variable[in + 1] >= '@' && variable[in + 1] <= '_') {
				in += 2;

				continue;
			}
		}

		variable[out] = variable[in];
		++in;
		++out;
	}

	variable[out] = variable[in];

	return out;
}

/*
Builds a formatted string or
fails safely in case the amount of conversion specifiers in
the format string does not match the expected count.
*/
__attribute__ ((__format__ (__printf__, 1, 4), __nonnull__ (1)))
static int cheat_print_string(char* const destination,
		char const* const format,
		size_t const count, ...) {
	va_list list;
	int result;

	if (cheat_format_specifiers(format) != count)
		return -1;

	va_start(list, count);
	result = vsprintf(destination, format, list);
	va_end(list);
	return result;
}

/*
Prints a formatted string or
fails safely in case the amount of conversion specifiers in
the format string does not match the expected count.
*/
__attribute__ ((__format__ (__printf__, 2, 4), __io__, __nonnull__ (1)))
static int cheat_print(FILE* const stream,
		char const* const format,
		size_t const count, ...) {
	va_list list;
	int result;

	if (cheat_format_specifiers(format) != count)
		return -1;

	va_start(list, count);
	result = vfprintf(stream, format, list);
	va_end(list);
	return result;
}

/*
This procedure does not have
  __attribute__ ((__io__))
even though it uses cheat_death(), because it is reserved for failures.
*/
/*
Converts an outcome into an exit status.
*/
static int cheat_encode_outcome(enum cheat_outcome const outcome) {
	switch (outcome) {
	case CHEAT_SUCCESSFUL:
		return 0;
	case CHEAT_FAILED:
		return CHEAT_OFFSET;
	case CHEAT_EXITED:
		return CHEAT_OFFSET + 1;
	case CHEAT_CRASHED:
		return CHEAT_OFFSET + 2;
	case CHEAT_TIMED_OUT:
		return CHEAT_OFFSET + 3;
	case CHEAT_IGNORED:
		return CHEAT_OFFSET + 4;
	case CHEAT_SKIPPED:
		return CHEAT_OFFSET + 5;
	default:
		cheat_death("invalid outcome", outcome);
	}
}

/*
Converts an exit status into an outcome.
*/
__attribute__ ((__const__))
static enum cheat_outcome cheat_decode_status(int const status) {
	switch (status) {
	case 0:
		return CHEAT_SUCCESSFUL;
	case CHEAT_OFFSET:
		return CHEAT_FAILED;
	case CHEAT_OFFSET + 1:
		return CHEAT_EXITED;
	case CHEAT_OFFSET + 2:
		return CHEAT_CRASHED;
	case CHEAT_OFFSET + 3:
		return CHEAT_TIMED_OUT;
	case CHEAT_OFFSET + 4:
		return CHEAT_IGNORED;
	case CHEAT_OFFSET + 5:
		return CHEAT_SKIPPED;
	default:
		return CHEAT_CRASHED;
	}
}

/*
Finds a test or a utility procedure by its name and returns a pointer to it or
returns NULL in case of a failure.
*/
__attribute__ ((__nonnull__, __pure__, __warn_unused_result__))
static struct cheat_unit const* cheat_find(struct cheat_unit const* const units,
		char const* const name) {
	size_t index;

	for (index = 0;
			units[index].type != CHEAT_TERMINATOR;
			++index) {
		struct cheat_unit const* unit;

		unit = &units[index];
		if (unit->name != NULL && strcmp(unit->name, name) == 0)
			return unit;
	}

	return NULL;
}

/*
Initializes an undefined array of strings.
*/
__attribute__ ((__nonnull__))
static void cheat_initialize_string_array(struct cheat_string_array* const array) {
	array->count = 0;
	array->elements = NULL;
}

/*
Initializes an undefined list of strings.
*/
__attribute__ ((__nonnull__))
static void cheat_initialize_string_list(struct cheat_string_list* const list) {
	list->count = 0;
	list->capacity = 0;
	list->items = NULL;
}

/*
Initializes an undefined list of character arrays.
*/
__attribute__ ((__nonnull__))
static void cheat_initialize_list(struct cheat_character_array_list* const list) {
	list->count = 0;
	list->capacity = 0;
	list->items = NULL;
}

/*
Initializes undefined statistics.
*/
__attribute__ ((__nonnull__))
static void cheat_initialize_statistics(struct cheat_statistics* const statistics) {
	statistics->run = 0;
	statistics->successful = 0;
	statistics->failed = 0;
}

/*
Initializes an undefined test suite.
*/
__attribute__ ((__nonnull__))
static void cheat_initialize(struct cheat_suite* const suite) {
	suite->units = NULL;

	/* Do not touch suite->handler. */

	suite->program = NULL;
	cheat_initialize_string_array(&suite->arguments);

	suite->force = false;

	suite->timed = false;

	suite->quiet = false;

	suite->harness = CHEAT_UNSAFE;

	suite->style = CHEAT_PLAIN;

	cheat_initialize_statistics(&suite->tests);

	suite->test_name = NULL;
	suite->outcome = CHEAT_SUCCESSFUL;

	suite->message_stream = NULL;

	cheat_initialize_list(&suite->messages);
	cheat_initialize_list(&suite->outputs);
	cheat_initialize_list(&suite->errors);

	/* Do not touch suite->environment either. */
}

/*
Clears a list of strings.
*/
__attribute__ ((__nonnull__))
static void cheat_clear_string_list(struct cheat_string_list* const list) {
	list->count = 0;
	list->capacity = 0;
	free(list->items);
	list->items = NULL;
}

/*
Clears a list of character arrays.
*/
__attribute__ ((__nonnull__))
static void cheat_clear_list(struct cheat_character_array_list* const list) {
	while (list->count > 0)
		free(list->items[--list->count].elements);

	list->capacity = 0;
	free(list->items);
	list->items = NULL;
}

/*
Clears all the character array lists in a test suite.
*/
__attribute__ ((__nonnull__))
static void cheat_clear_lists(struct cheat_suite* const suite) {
	cheat_clear_list(&suite->messages);
	cheat_clear_list(&suite->outputs);
	cheat_clear_list(&suite->errors);
}

/*
Adds a string to the end of a list or
terminates the program in case of a failure.
*/
__attribute__ ((__nonnull__ (1)))
static void cheat_append_string_list(struct cheat_string_list* const list,
		char* const item) {
	size_t count;

	if (list->count == SIZE_MAX)
		cheat_death("too many items", list->count);
	count = list->count + 1;

	if (list->count == list->capacity) {
		size_t capacity;
		char** items;

		capacity = cheat_expand(list->capacity);
		if (capacity == list->capacity)
			cheat_death("item capacity exceeded", list->capacity);

		items = CHEAT_CAST(char**, cheat_reallocate_array(list->items,
					capacity, sizeof *list->items));
		if (items == NULL)
			cheat_death("failed to allocate more memory", errno);

		list->capacity = capacity;
		list->items = items;
	}

	list->items[list->count] = item;
	list->count = count;
}

/*
Copies a message form a character array to the end of a list or
terminates the program in case of a failure.
*/
__attribute__ ((__nonnull__ (1)))
static void cheat_append_list(struct cheat_character_array_list* const list,
		char const* const buffer,
		size_t const size) {
	size_t count;
	char* elements;

	if (buffer == NULL || size == 0)
		return;

	if (list->count == SIZE_MAX)
		cheat_death("too many items", list->count);
	count = list->count + 1;

	if (list->count == list->capacity) {
		size_t capacity;
		struct cheat_character_array* items;

		capacity = cheat_expand(list->capacity);
		if (capacity == list->capacity)
			cheat_death("item capacity exceeded", list->capacity);

		items = CHEAT_CAST(struct cheat_character_array*, cheat_reallocate_array(list->items,
					capacity, sizeof *list->items));
		if (items == NULL)
			cheat_death("failed to allocate more memory", errno);

		list->capacity = capacity;
		list->items = items;
	}

	elements = CHEAT_CAST(char*, malloc(size));
	if (elements == NULL)
		cheat_death("failed to allocate memory", errno);
	memcpy(elements, buffer, size);

	list->items[list->count].size = size;
	list->items[list->count].elements = elements;
	list->count = count;
}

/*
Checks whether a stream should be captured.
*/
__attribute__ ((__pure__, __unused__, __warn_unused_result__))
static bool cheat_capture(struct cheat_suite const* const suite,
		FILE const* const stream) {
	return !suite->quiet && (stream == stdout || stream == stderr);
}

/*
Checks whether a stream should be hidden or
terminates the program in case of a failure.
*/
__attribute__ ((__nonnull__ (1), __unused__, __warn_unused_result__))
static bool cheat_hide(struct cheat_suite const* const suite,
		FILE const* const stream) {
	switch (suite->harness) {
	case CHEAT_UNSAFE:
	case CHEAT_DANGEROUS:
		return stream == stdout || stream == stderr;
	case CHEAT_SAFE:
		return false;
	default:
		cheat_death("invalid harness", suite->harness);
	}
}

/*
Here goes:

cheat_limit_output(size_t)
cheat_purge_output(void)
cheat_scan_output(bool (*)(char const*, size_t))
*/

/*
Adds the outcome of a single test to a test suite or
terminates the program in case of a failure.
*/
__attribute__ ((__nonnull__))
static void cheat_handle_outcome(struct cheat_suite* const suite) {
	switch (suite->outcome) {
	case CHEAT_SUCCESSFUL:
		++suite->tests.run;
		++suite->tests.successful;
		break;
	case CHEAT_FAILED:
	case CHEAT_EXITED:
	case CHEAT_CRASHED:
	case CHEAT_TIMED_OUT:
		++suite->tests.run;
		++suite->tests.failed;
		break;
	case CHEAT_IGNORED:
		++suite->tests.run;
	case CHEAT_SKIPPED:
		break;
	default:
		cheat_death("invalid outcome", suite->outcome);
	}
}

/*
Registers a signal handler or
terminates the program in case of a failure.
*/
__attribute__ ((__nonnull__))
static void cheat_register_handler(cheat_handler const handler) {
	if (signal(SIGABRT, handler) == SIG_ERR)
		cheat_death("failed to add a handler for SIGABRT", errno);
	if (signal(SIGFPE, handler) == SIG_ERR)
		cheat_death("failed to add a handler for SIGFPE", errno);
	if (signal(SIGILL, handler) == SIG_ERR)
		cheat_death("failed to add a handler for SIGILL", errno);
	if (signal(SIGSEGV, handler) == SIG_ERR)
		cheat_death("failed to add a handler for SIGSEGV", errno);
	if (signal(SIGTERM, handler) == SIG_ERR)
		cheat_death("failed to add a handler for SIGTERM", errno);
}

/*
Stops a test or
terminates the program in case of a failure.
*/
__attribute__ ((__nonnull__))
static void cheat_exit(struct cheat_suite* const suite,
		int const status) {
	switch (suite->harness) {
	case CHEAT_UNSAFE:
		suite->outcome = CHEAT_EXITED;
		break;
	case CHEAT_DANGEROUS:
		longjmp(suite->environment, CHEAT_EXITED);
	case CHEAT_SAFE:
		exit(CHEAT_EXITED);
	default:
		cheat_death("invalid harness", suite->harness);
	}
}

/*
Prints the contents of a list or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_print_list(struct cheat_character_array_list const* const list) {
	size_t index;

	for (index = 0;
			index < list->count;
			++index)
		(void )fwrite(list->items[index].elements, 1, list->items[index].size, stdout);
}

/*
Prints a summary of the usage or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_print_usage(struct cheat_suite const* const suite) {
	bool strip = false;
	bool print_usage = false;
	bool print_options = false;
	bool print_labels = false;
	char usage_format[] = CHEAT_BOLD "%s"
		CHEAT_RESET " [test or option] [another test or option] [...]";
	char option_strings[][80] = { /* This length is a coincidence. */
		CHEAT_BOLD "-c"
			CHEAT_RESET "  "
			CHEAT_BOLD "--colorful"
			CHEAT_RESET "   Use ISO/IEC 6429 escape codes to color text",
		CHEAT_BOLD "-d"
			CHEAT_RESET "  "
			CHEAT_BOLD "--dangerous"
			CHEAT_RESET "  Pretend that crashing tests do nothing harmful",
		CHEAT_BOLD "-e"
			CHEAT_RESET "  "
			CHEAT_BOLD "--eternal"
			CHEAT_RESET "    Allow isolated tests to take their time",
		CHEAT_BOLD "-h"
			CHEAT_RESET "  "
			CHEAT_BOLD "--help"
			CHEAT_RESET "       Show this help",
		CHEAT_BOLD "-l"
			CHEAT_RESET "  "
			CHEAT_BOLD "--list"
			CHEAT_RESET "       List test cases",
		CHEAT_BOLD "-m"
			CHEAT_RESET "  "
			CHEAT_BOLD "--minimal"
			CHEAT_RESET "    Report things in a machine readable format",
		CHEAT_BOLD "-n"
			CHEAT_RESET "  "
			CHEAT_BOLD "--noisy"
			CHEAT_RESET "      Capture and display standard streams",
		CHEAT_BOLD "-p"
			CHEAT_RESET "  "
			CHEAT_BOLD "--plain"
			CHEAT_RESET "      Present everything in plain text",
		CHEAT_BOLD "-s"
			CHEAT_RESET "  "
			CHEAT_BOLD "--safe"
			CHEAT_RESET "       Run tests in isolated subprocesses",
		CHEAT_BOLD "-t"
			CHEAT_RESET "  "
			CHEAT_BOLD "--timed"
			CHEAT_RESET "      Terminate isolated tests that take too long",
		CHEAT_BOLD "-u"
			CHEAT_RESET "  "
			CHEAT_BOLD "--unsafe"
			CHEAT_RESET "     Let crashing tests bring down the test suite",
		CHEAT_BOLD "-v"
			CHEAT_RESET "  "
			CHEAT_BOLD "--version"
			CHEAT_RESET "    Print version information",
		CHEAT_BOLD "-q"
			CHEAT_RESET "  "
			CHEAT_BOLD "--quiet"
			CHEAT_RESET "      Do not capture standard streams",
		""
	};

	switch (suite->style) {
	case CHEAT_PLAIN:
		strip = true;
	case CHEAT_COLORFUL:
		print_usage = true;
		print_options = true;
		print_labels = true;
		break;
	case CHEAT_MINIMAL:
		strip = true;
		print_usage = true;
		break;
	default:
		cheat_death("invalid style", suite->style);
	}

	if (print_usage) {
		if (strip)
			cheat_strip(usage_format);

		if (print_labels)
			(void )fputs("Usage: ", stdout);
		(void )cheat_print(stdout, usage_format, 1,
				suite->program);
		(void )fputc('\n', stdout);
	}

	if (print_options) {
		size_t index;

		for (index = 0;
				option_strings[index][0] != '\0';
				++index) {
			if (strip)
				cheat_strip(option_strings[index]);

			if (print_labels) {
				if (index == 0)
					(void )fputs("Options: ", stdout);
				else
					(void )fputs("         ", stdout);
			}
			(void )fputs(option_strings[index], stdout);
			(void )fputc('\n', stdout);
		}
	}
}

/*
Prints a list of the tests or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_print_tests(struct cheat_suite const* const suite) {
	bool strip = false;
	bool print_labels = false;
	bool print_subtypes = false;
	size_t index;
	char name_format[] = CHEAT_BOLD "%s"
		CHEAT_RESET;
	bool first = true;

	switch (suite->style) {
	case CHEAT_PLAIN:
		strip = true;
	case CHEAT_COLORFUL:
		print_labels = true;
		print_subtypes = true;
		break;
	case CHEAT_MINIMAL:
		strip = true;
		break;
	default:
		cheat_death("invalid style", suite->style);
	}

	for (index = 0;
			suite->units[index].type != CHEAT_TERMINATOR;
			++index) {
		if (suite->units[index].type != CHEAT_TESTER)
			continue;

		if (strip)
			cheat_strip(name_format);

		if (print_labels) {
			if (first) {
				(void )fputs("Tests: ", stdout);
				first = false;
			} else
				(void )fputs("       ", stdout);
		}
		(void )cheat_print(stdout, name_format, 1,
				suite->units[index].name);
		if (print_subtypes)
			switch (suite->units[index].subtype) {
			case CHEAT_IGNORED_TEST:
				(void )fputs(" (ignored)", stdout);
				break;
			case CHEAT_SKIPPED_TEST:
				(void )fputs(" (skipped)", stdout);
			case CHEAT_NORMAL_TEST:
				break;
			default:
				cheat_death("invalid subtype", suite->style);
			}
		(void )fputc('\n', stdout);
	}
}

/*
Prints the version number string or
terminates the program in case of a failure.
*/
__attribute__ ((__io__))
static void cheat_print_version(void) {
	(void )fputs("CHEAT 1.0.4", stdout); /* This is always boring. */
	(void )fputc('\n', stdout);
}

/*
Prints the outcome of a single test or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_print_outcome(struct cheat_suite const* const suite) {
	bool strip = false;
	bool print_outcome = false;
	char successful_string[] = CHEAT_BACKGROUND_GREEN "."
		CHEAT_RESET;
	char failed_string[] = CHEAT_BACKGROUND_RED ":"
		CHEAT_RESET;
	char exited_string[] = CHEAT_BACKGROUND_RED "!"
		CHEAT_RESET;
	char crashed_string[] = CHEAT_BACKGROUND_RED "!"
		CHEAT_RESET;
	char timed_out_string[] = CHEAT_BACKGROUND_YELLOW "!"
		CHEAT_RESET;
	char ignored_string[] = CHEAT_BACKGROUND_YELLOW "?"
		CHEAT_RESET;
	char skipped_string[] = "";

	switch (suite->style) {
	case CHEAT_PLAIN:
		strip = true;
	case CHEAT_COLORFUL:
		print_outcome = true;
		break;
	case CHEAT_MINIMAL:
		break;
	default:
		cheat_death("invalid style", suite->style);
	}

	if (print_outcome) {
		char* outcome_string;

		switch (suite->outcome) {
		case CHEAT_SUCCESSFUL:
			outcome_string = successful_string;
			break;
		case CHEAT_FAILED:
			outcome_string = failed_string;
			break;
		case CHEAT_EXITED:
			outcome_string = exited_string;
			break;
		case CHEAT_CRASHED:
			outcome_string = crashed_string;
			break;
		case CHEAT_TIMED_OUT:
			outcome_string = timed_out_string;
			break;
		case CHEAT_IGNORED:
			outcome_string = ignored_string;
			break;
		case CHEAT_SKIPPED:
			outcome_string = skipped_string;
			break;
		default:
			cheat_death("invalid outcome", suite->outcome);
		}

		if (strip)
			cheat_strip(outcome_string);

		(void )fputs(outcome_string, stdout);
		(void )fflush(stdout);
	}
}

/*
Prints a separator or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_print_separator(struct cheat_suite const* const suite) {
	bool strip = false;
	bool print_separator = false;
	char separator_string[] = CHEAT_FOREGROUND_GRAY "---"
		CHEAT_RESET;

	switch (suite->style) {
	case CHEAT_PLAIN:
		strip = true;
		print_separator = true;
		break;
	case CHEAT_COLORFUL:
		strip = false;
		print_separator = true;
		break;
	case CHEAT_MINIMAL:
		strip = true;
		print_separator = false;
		break;
	default:
		cheat_death("invalid style", suite->style);
	}

	if (print_separator) {
		if (strip)
			cheat_strip(separator_string);

		(void )fputs(separator_string, stdout);
		(void )fputc('\n', stdout);
	}
}

/*
Prints a summary of tests or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_print_summary(struct cheat_suite const* const suite) {
	bool strip = false;
	bool regular = false;
	bool print_outcomes = false;
	bool print_messages = false;
	bool print_outputs = false;
	bool print_errors = false;
	bool print_summary = false;
	bool print_conclusion = false;
	char long_successful_format[] = CHEAT_FOREGROUND_GREEN
		CHEAT_SIZE_FORMAT " successful"
		CHEAT_RESET;
	char long_and_string[] = " and ";
	char long_failed_format[] = CHEAT_FOREGROUND_RED
		CHEAT_SIZE_FORMAT " failed"
		CHEAT_RESET;
	char long_of_string[] = " of ";
	char long_run_format[] = CHEAT_FOREGROUND_YELLOW
		CHEAT_SIZE_FORMAT " run"
		CHEAT_RESET;
	char success_string[] = CHEAT_FOREGROUND_GREEN "SUCCESS"
		CHEAT_RESET;
	char failure_string[] = CHEAT_FOREGROUND_RED "FAILURE"
		CHEAT_RESET;
	char short_format[] = CHEAT_SIZE_FORMAT;
	char short_string[] = " ";
	char* successful_format;
	char* and_string;
	char* failed_format;
	char* of_string;
	char* run_format;
	bool any_successes;
	bool any_failures;
	bool any_run;
	bool any_messages;
	bool any_outputs;
	bool any_errors;
	bool separate = false;

	switch (suite->style) {
	case CHEAT_PLAIN:
		strip = true;
	case CHEAT_COLORFUL:
		print_outcomes = true;
		print_messages = true;
		print_outputs = true;
		print_errors = true;
		print_summary = true;
		print_conclusion = true;
		successful_format = long_successful_format;
		and_string = long_and_string;
		failed_format = long_failed_format;
		of_string = long_of_string;
		run_format = long_run_format;
		break;
	case CHEAT_MINIMAL:
		strip = true;
		regular = true;
		print_summary = true;
		successful_format = short_format;
		and_string = short_string;
		failed_format = short_format;
		of_string = short_string;
		run_format = short_format;
		break;
	default:
		cheat_death("invalid style", suite->style);
	}

	any_successes = suite->tests.successful != 0;
	any_failures = suite->tests.failed != 0;
	any_run = suite->tests.run != 0;
	any_messages = suite->messages.count != 0;
	any_outputs = suite->outputs.count != 0;
	any_errors = suite->errors.count != 0;

	if (print_outcomes && any_run) {
		separate = true;

		(void )fputc('\n', stdout);
	}
	if (print_messages && any_messages) {
		if (separate)
			cheat_print_separator(suite);
		separate = true;

		cheat_print_list(&suite->messages);
	}
	if (print_outputs && any_outputs) {
		if (separate)
			cheat_print_separator(suite);
		separate = true;

		cheat_print_list(&suite->outputs);
	}
	if (print_errors && any_errors) {
		if (separate)
			cheat_print_separator(suite);
		separate = true;

		cheat_print_list(&suite->errors);
	}
	if (print_summary) {
		if (separate)
			cheat_print_separator(suite);

		if (regular || any_successes) {
			if (strip)
				cheat_strip(successful_format);

			(void )cheat_print(stdout, successful_format, 1,
					(CHEAT_SIZE_TYPE )suite->tests.successful);
		}
		if (regular || (any_successes && any_failures)) {
			if (strip)
				cheat_strip(and_string);

			(void )fputs(and_string, stdout);
		}
		if (regular || any_failures) {
			if (strip)
				cheat_strip(failed_format);

			(void )cheat_print(stdout, failed_format, 1,
					(CHEAT_SIZE_TYPE )suite->tests.failed);
		}
		if (regular || (any_successes || any_failures)) {
			if (strip)
				cheat_strip(of_string);

			(void )fputs(of_string, stdout);
		}
		if (strip)
			cheat_strip(run_format);

		(void )cheat_print(stdout, run_format, 1,
				(CHEAT_SIZE_TYPE )suite->tests.run);
		(void )fputc('\n', stdout);
	}
	if (print_conclusion) {
		if (!any_failures) {
			if (strip)
				cheat_strip(success_string);

			(void )fputs(success_string, stdout);
		} else {
			if (strip)
				cheat_strip(failure_string);

			(void )fputs(failure_string, stdout);
		}
		(void )fputc('\n', stdout);
	}
}

/*
Prints an error message or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_print_failure(struct cheat_suite* const suite,
		char const* const expression,
		char const* const file,
		size_t const line) {
	bool strip = false;
	bool print_assertion = false;
	char assertion_format[] = CHEAT_BOLD "%s:"
		CHEAT_SIZE_FORMAT ":"
		CHEAT_RESET " assertion in '"
		CHEAT_BOLD "%s"
		CHEAT_RESET "' failed: '"
		CHEAT_BOLD "%s"
		CHEAT_RESET "'\n"; /* Mind the line break. */

	switch (suite->style) {
	case CHEAT_PLAIN:
		strip = true;
	case CHEAT_COLORFUL:
		print_assertion = true;
		break;
	case CHEAT_MINIMAL:
		break;
	default:
		cheat_death("invalid style", suite->style);
	}

	if (print_assertion) {
		char* truncation;
		char* buffer;

		truncation = cheat_allocate_truncated(expression, CHEAT_LIMIT, "...");
		if (truncation == NULL)
			cheat_death("failed to allocate memory", errno);

		if (strip)
			cheat_strip(assertion_format);

		switch (suite->harness) {
		case CHEAT_UNSAFE:
		case CHEAT_DANGEROUS:
			buffer = CHEAT_CAST(char*, cheat_allocate_total(6,
						strlen(assertion_format), strlen(file),
						CHEAT_INTEGER_LENGTH(line), strlen(suite->test_name),
						strlen(truncation), (size_t )1));
			if (buffer == NULL)
				cheat_death("failed to allocate memory", errno);

			if (cheat_print_string(buffer, assertion_format, 4,
						file, (CHEAT_SIZE_TYPE )line,
						suite->test_name, truncation) < 0)
				cheat_death("failed to build a string", errno);
			cheat_append_list(&suite->messages, buffer, strlen(buffer));

			free(buffer);
			break;
		case CHEAT_SAFE:
			(void )cheat_print(suite->message_stream, assertion_format, 4,
					file, line,
					suite->test_name, truncation);
			(void )fflush(suite->message_stream); /* This prevents crashing from
					absorbing messages. */
			break;
		default:
			cheat_death("invalid harness", suite->harness);
		}

		free(truncation);
	}
}

/*
Figures out whether further checks should be carried out or
terminates the program in case of a failure.
*/
__attribute__ ((__warn_unused_result__))
static bool cheat_further(enum cheat_outcome const outcome) {
	switch (outcome) {
	case CHEAT_SUCCESSFUL:
	case CHEAT_FAILED:
		return true;
	case CHEAT_EXITED:
	case CHEAT_CRASHED:
	case CHEAT_TIMED_OUT:
		return false;
	case CHEAT_IGNORED:
	case CHEAT_SKIPPED:
	default:
		cheat_death("invalid outcome", outcome);
	}
}

/*
Checks a single assertion and prints an error message if it fails or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_check(struct cheat_suite* const suite,
		bool const result,
		char const* const expression,
		char const* const file,
		size_t const line) {
	if (cheat_further(suite->outcome) && !result) {
		suite->outcome = CHEAT_FAILED;

		cheat_print_failure(suite, expression, file, line);
	}
}

/*
Runs all utility procedures of a certain type or
terminates the program in case of a failure.
*/
__attribute__ ((__io__))
static void cheat_run_utilities(struct cheat_suite* const suite,
		enum cheat_subtype const subtype) {
	size_t index;

	for (index = 0;
			suite->units[index].type != CHEAT_TERMINATOR;
			++index)
		if (suite->units[index].type == CHEAT_UTILITY
				&& suite->units[index].subtype == subtype)
			(suite->units[index].procedure)();
}

/*
Runs a test procedure or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_run_test(struct cheat_unit const* const unit) {
	if (unit->type == CHEAT_TESTER)
		(unit->procedure)();
	else
		cheat_death("not a test", unit->type);
}

/*
Runs a test from a test suite or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_run_coupled_test(struct cheat_suite* const suite,
		struct cheat_unit const* const unit) {
	cheat_run_utilities(suite, CHEAT_SET_UP_UTILITY);
	cheat_run_test(unit);
	cheat_run_utilities(suite, CHEAT_TEAR_DOWN_UTILITY);
}

#ifdef CHEAT_WINDOWED

#define CHEAT_PIPE "\\\\.\\pipe\\cheat" /* This is the pipe name prefix. */

#define CHEAT_OPTION "--__hidden" /* This is the option to emulate fork(). */

#endif

/*
Creates a subprocess and runs a test in it or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_isolate_test(struct cheat_suite* const suite,
		struct cheat_unit const* const test) {

#ifdef CHEAT_POSIXLY

	pid_t pid;
	struct cheat_channel channels[3];
	size_t channel_count;
	size_t index;
	int fds[2];
	bool due;
	int status;

	channel_count = sizeof channels / sizeof *channels;

	for (index = 0;
			index < channel_count;
			++index) {
		if (pipe(fds) == -1)
			cheat_death("failed to create a pipe", errno);
		channels[index].reader = fds[0];
		channels[index].writer = fds[1];
		channels[index].active = true;
	}

	channels[0].list = &suite->messages;
	channels[1].list = &suite->outputs;
	channels[2].list = &suite->errors;

	pid = fork();
	if (pid == -1)
		cheat_death("failed to create a process", errno);
	else if (pid == 0) {
		for (index = 0;
				index < channel_count;
				++index)
			if (close(channels[index].reader) == -1)
				cheat_death("failed to close the read end of a pipe", errno);

		suite->message_stream = fdopen(channels[0].writer, "w");
		if (suite->message_stream == NULL)
			cheat_death("failed to open the message stream for writing", errno);

		if (dup2(channels[1].writer, STDOUT_FILENO) == -1)
			cheat_death("failed to redirect the standard output stream", errno);

		if (dup2(channels[2].writer, STDERR_FILENO) == -1)
			cheat_death("failed to redirect the standard error stream", errno);

		cheat_run_coupled_test(suite, test);

		/*
		These are very important, because
		streams opened from file descriptors are not flushed when
		the file descriptors are closed.
		*/

		if (fflush(suite->message_stream) == EOF)
			cheat_death("failed to flush the message stream", errno);

		if (fflush(stdout) == EOF)
			cheat_death("failed to flush the standard output stream", errno);

		if (fflush(stderr) == EOF)
			cheat_death("failed to flush the standard error stream", errno);

		for (index = 0;
				index < channel_count;
				++index)
			if (close(channels[index].writer) == -1)
				cheat_death("failed to close the write end of a pipe", errno);

		exit(cheat_encode_outcome(suite->outcome));
	}

	for (index = 0;
			index < channel_count;
			++index)
		if (close(channels[index].writer) == -1)
			cheat_death("failed to close the write end of a pipe", errno);

	due = false;
	do {
		int maximum;
		fd_set set;
		int result;

		FD_ZERO(&set);
		for (index = 0;
				index < channel_count;
				++index)
			FD_SET(channels[index].reader, &set);

		maximum = channels[0].reader;
		for (index = 1;
				index < channel_count;
				++index)
			if (channels[index].reader > maximum)
				maximum = channels[index].reader;

		if (suite->timed) {
			struct timeval time;

			time.tv_sec = CHEAT_TIME / 1000;
			time.tv_usec = (CHEAT_TIME % 1000) * 1000;

			result = select(maximum + 1, &set, NULL, NULL, &time);
		} else
			result = select(maximum + 1, &set, NULL, NULL, NULL);

		if (result == -1)
			cheat_death("failed to select a pipe", errno);
		else if (result == 0) {
			due = true;
			break; /* TODO Make sense of this control flow. */
		} else {
			char buffer[BUFSIZ];
			ssize_t size;

			for (index = 0;
					index < channel_count;
					++index)
				if (channels[index].active
						&& FD_ISSET(channels[index].reader, &set))
					break;

			if (index == channel_count)
				break;

			size = read(channels[index].reader, buffer, sizeof buffer);
			if (size == -1)
				cheat_death("failed to read from a pipe", errno);
			if (size == 0)
				channels[index].active = false;
			else if (!(suite->quiet && (index == 1 || index == 2))) /* Urgh! */
				cheat_append_list(channels[index].list, buffer, (size_t )size);
		}
	} while (true);

	for (index = 0;
			index < channel_count;
			++index)
		if (close(channels[index].reader) == -1)
			cheat_death("failed to close the read end of a pipe", errno);

	/*
	Both kill() and waitpid() can fail if
	the child process exits or crashes after select() has returned.
	*/
	if (due) {
		if (kill(pid, SIGKILL) == -1)
			suite->outcome = CHEAT_CRASHED;
		else
			suite->outcome = CHEAT_TIMED_OUT;
	} else {
		if (waitpid(pid, &status, 0) == -1 || !WIFEXITED(status))
			suite->outcome = CHEAT_CRASHED;
		else
			suite->outcome = cheat_decode_status(WEXITSTATUS(status));
	}

#else

/*
Windows makes working with pipes a hassle, so not all streams are captured.
*/

#ifdef CHEAT_WINDOWED /* TODO Implement pipes. */

	LPTSTR name;
	HANDLE message_pipe;
	HANDLE output_reader;
	HANDLE output_writer;
	HANDLE error_reader;
	HANDLE error_writer;
	SECURITY_ATTRIBUTES security;
	STARTUPINFO startup;
	PROCESS_INFORMATION process;
	SIZE_T command_length;
	SIZE_T option_length;
	SIZE_T name_length;
	LPTSTR command;
	DWORD status;

	/*
	The memory of these structures is zeroed to
	avoid compatibility issues if their fields change.
	*/
	ZeroMemory(&security, sizeof security);
	ZeroMemory(&startup, sizeof startup);
	ZeroMemory(&process, sizeof process);

	security.nLength = sizeof security;
	security.lpSecurityDescriptor = NULL;
	security.bInheritHandle = TRUE;

	/*
	if (!CreatePipe(&output_reader, &output_writer, &security, 0))
		cheat_death("failed to create a pipe", GetLastError());
	*/

	if (!CreatePipe(&error_reader, &error_writer, &security, 0))
		cheat_death("failed to create a pipe", GetLastError());

	startup.cb = sizeof startup;
	startup.lpReserved = NULL;
	startup.lpDesktop = NULL;
	startup.lpTitle = NULL;
	startup.dwFlags = STARTF_USESTDHANDLES;
	startup.cbReserved2 = 0;
	startup.lpReserved2 = NULL;
	startup.hStdInput = NULL;
	startup.hStdOutput = error_writer; /* output_writer; */
	startup.hStdError = NULL; /* error_writer; */

	command_length = strlen(GetCommandLine());
	option_length = strlen(CHEAT_OPTION);
	name_length = strlen(test->name);

	command = cheat_allocate_total(4,
			command_length, option_length,
			name_length, (size_t )3);
	if (command == NULL)
		cheat_death("failed to allocate memory", errno);

	memcpy(command, GetCommandLine(), command_length);
	memcpy(&command[command_length], " " CHEAT_OPTION " ", option_length + 2);
	memcpy(&command[command_length + option_length + 2],
			test->name, name_length + 1);

	if (!CreateProcess(NULL, command, NULL, NULL,
				TRUE, NORMAL_PRIORITY_CLASS, NULL, NULL,
				&startup, &process)) /* There is CommandLineToArgvW(), but
			nothing like ArgvToCommandLineW() exists, so
			GetCommandLine() is used even though it is not guaranteed to
			return the correct result for file paths that
			lack a file extension, contain spaces or
			are not entirely built from printable ASCII characters. */
		cheat_death("failed to create a process", GetLastError());

	free(command);

	/*
	name = CHEAT_CAST(LPTSTR, cheat_allocate_total(3,
				strlen(CHEAT_PIPE), CHEAT_INTEGER_LENGTH(process.dwProcessId),
				(size_t )1));
	if (name == NULL)
		cheat_death("failed to allocate memory", errno);

	if (cheat_print_string(name, "%s%d", 2,
				CHEAT_PIPE, process.dwProcessId) < 0)
		cheat_death("failed to build a string", errno);

	message_pipe = CreateNamedPipe(name,
			PIPE_ACCESS_INBOUND | FILE_FLAG_FIRST_PIPE_INSTANCE,
			PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,
			2, BUFSIZ, BUFSIZ, CHEAT_TIME, NULL);
	if (message_pipe == INVALID_HANDLE_VALUE)
		cheat_death("failed to create a named pipe", GetLastError());

	free(name);

	if (!ConnectNamedPipe(message_pipe, NULL)
			&& GetLastError() != ERROR_PIPE_CONNECTED
			&& GetLastError() != ERROR_PIPE_LISTENING
			&& GetLastError() != ERROR_NO_DATA)
		cheat_death("failed to connect a named pipe", GetLastError());

	if (!CloseHandle(output_writer))
		cheat_death("failed to close the write end of a pipe", GetLastError());
	*/

	if (!CloseHandle(error_writer))
		cheat_death("failed to close the write end of a pipe", GetLastError());

	do {
		CHAR buffer[BUFSIZ];
		DWORD size;

		if (!ReadFile(error_reader, buffer, sizeof buffer, &size, NULL)) {
			DWORD error;

			error = GetLastError();
			if (error != ERROR_BROKEN_PIPE)
				cheat_death("failed to read from a pipe", error);
			break;
		}
		if (size == 0)
			break;

		cheat_append_list(&suite->messages, buffer, (size_t )size);
	} while (TRUE);

	/*
	if (!DisconnectNamedPipe(message_pipe))
		cheat_death("failed to disconnect a named pipe", GetLastError());

	if (!CloseHandle(message_pipe))
		cheat_death("failed to close a named pipe", GetLastError());

	if (!CloseHandle(output_reader))
		cheat_death("failed to close the read end of a pipe", GetLastError());
	*/

	if (!CloseHandle(error_reader))
		cheat_death("failed to close the read end of a pipe", GetLastError());

	if (WaitForSingleObject(process.hProcess, INFINITE) == WAIT_FAILED)
		cheat_death("failed to wait for a process", GetLastError());

	if (!GetExitCodeProcess(process.hProcess, &status))
		cheat_death("failed to get the exit code of a process", GetLastError());

	if (!CloseHandle(process.hProcess))
		cheat_death("failed to close a process handle", GetLastError());
	if (!CloseHandle(process.hThread))
		cheat_death("failed to close a thread handle", GetLastError());

	suite->outcome = cheat_decode_status(status);

#else

	cheat_death("failed to isolate a test", 0);

#endif
#endif

}

#ifdef CHEAT_WINDOWED /* TODO Implement more pipes. */

/*
Runs a single test and exits or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_run_hidden(struct cheat_suite* const suite,
		char const* const name) {
	struct cheat_unit const* unit;
	DWORD pid;
	LPTSTR pipe;

	unit = cheat_find(suite->units, name);
	if (unit == NULL)
		cheat_death("test not found", 0);

	/*
	pid = GetCurrentProcessId();

	pipe = CHEAT_CAST(LPTSTR, cheat_allocate_total(3,
				strlen(CHEAT_PIPE), CHEAT_INTEGER_LENGTH(pid),
				(size_t )1));
	if (pipe == NULL)
		cheat_death("failed to allocate memory", errno);

	if (cheat_print_string(pipe, "%s%d", 2,
				CHEAT_PIPE, pid) < 0)
		cheat_death("failed to build a string", errno);

	if (!WaitNamedPipe(pipe, CHEAT_TIME))
		cheat_death("failed to wait for a named pipe", GetLastError());

	cheat_suite.message_stream = CreateFile(pipe, GENERIC_WRITE, 0, NULL,
			OPEN_EXISTING, 0, NULL);
	if (cheat_suite.message_stream == INVALID_HANDLE_VALUE)
		cheat_death("failed to open a named pipe", GetLastError());

	free(pipe);
	*/

	cheat_run_coupled_test(suite, unit);
}

#endif

/*
Runs a single test from a test suite and prints its outcome or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_run_specific(struct cheat_suite* const suite,
		struct cheat_unit const* const unit) {
	int status;

	switch (suite->harness) {
	case CHEAT_SAFE:
		cheat_isolate_test(suite, unit);
		break;
	case CHEAT_DANGEROUS:
		if (suite->harness == CHEAT_DANGEROUS)
			cheat_register_handler(suite->handler); /* This is here, because
					signal handlers may be cleared after each use. */

		status = setjmp(suite->environment);
		if (status == 0)
			cheat_run_coupled_test(suite, unit);
		else
			suite->outcome = cheat_decode_status(status);
		break;
	case CHEAT_UNSAFE:
		cheat_run_coupled_test(suite, unit);
		break;
	default:
		cheat_death("invalid harness", suite->harness);
	}

	cheat_handle_outcome(suite);

	cheat_print_outcome(suite);
}

/*
Runs every test from a test suite and prints their outcomes or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_run_all(struct cheat_suite* const suite) {
	size_t index;

	for (index = 0;
			suite->units[index].type != CHEAT_TERMINATOR;
			++index)
		if (suite->units[index].type == CHEAT_TESTER)
			cheat_run_specific(suite, &suite->units[index]);
}

/*
Runs some tests from a test suite and prints their outcomes or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_run_some(struct cheat_suite* const suite,
		struct cheat_string_list const* const names) {
	size_t index;

	for (index = 0;
			index < names->count;
			++index) {
		struct cheat_unit const* unit;

		unit = cheat_find(suite->units, names->items[index]);
		if (unit == NULL)
			cheat_death("test not found", 0);

		cheat_run_specific(suite, unit);
	}
}

/*
Runs a test suite and prints a summary or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_run_suite(struct cheat_suite* const suite,
		struct cheat_string_list const* const names) {
	suite->force = names->count != 0;

	if (suite->force)
		cheat_run_some(suite, names);
	else
		cheat_run_all(suite);

	cheat_print_summary(suite);
}

/*
Parses the arguments of a test suite and delegates work or
terminates the program in case of a failure.
*/
__attribute__ ((__io__, __nonnull__))
static void cheat_parse(struct cheat_suite* const suite) {
	struct cheat_string_list names;
	size_t index;
	bool options = true;
	bool colorful = false;
	bool dangerous = false;
	bool eternal = false;
	bool help = false;
	bool list = false;
	bool minimal = false;
	bool noisy = false;
	bool plain = false;
	bool safe = false;
	bool timed = false;
	bool unsafe = false;
	bool version = false;
	bool quiet = false;
#ifdef CHEAT_WINDOWED
	bool hidden = false; /* This has to be at the very end. */
#endif

	cheat_initialize_string_list(&names);

	for (index = 0;
			index < suite->arguments.count;
			++index) {
		char* argument;

		argument = suite->arguments.elements[index];

		if (options && argument[0] == '-') {
			if (cheat_compare(argument, "--"))
				options = false;
			else if (cheat_compare(argument, "-c")
					|| cheat_compare(argument, "--colorful"))
				colorful = true;
			else if (cheat_compare(argument, "-d")
					|| cheat_compare(argument, "--dangerous"))
				dangerous = true;
			else if (cheat_compare(argument, "-e")
					|| cheat_compare(argument, "--eternal"))
				eternal = true;
			else if (cheat_compare(argument, "-h")
					|| cheat_compare(argument, "--help"))
				help = true;
			else if (cheat_compare(argument, "-l")
					|| cheat_compare(argument, "--list"))
				list = true;
			else if (cheat_compare(argument, "-m")
					|| cheat_compare(argument, "--minimal"))
				minimal = true;
			else if (cheat_compare(argument, "-n")
					|| cheat_compare(argument, "--noisy"))
				noisy = true;
			else if (cheat_compare(argument, "-p")
					|| cheat_compare(argument, "--plain"))
				plain = true;
			else if (cheat_compare(argument, "-s")
					|| cheat_compare(argument, "--safe"))
				safe = true;
			else if (cheat_compare(argument, "-t")
					|| cheat_compare(argument, "--timed"))
				timed = true;
			else if (cheat_compare(argument, "-u")
					|| cheat_compare(argument, "--unsafe"))
				unsafe = true;
			else if (cheat_compare(argument, "-v")
					|| cheat_compare(argument, "--version"))
				version = true;
			else if (cheat_compare(argument, "-q")
					|| cheat_compare(argument, "--quiet"))
				quiet = true;
#ifdef CHEAT_WINDOWED
			else if (cheat_compare(argument, CHEAT_OPTION))
				hidden = true;
#endif
			else
				cheat_death("invalid option", index);
		} else
			cheat_append_string_list(&names, argument);
	}

	if (colorful)
		suite->style = CHEAT_COLORFUL;
	if (dangerous)
		suite->harness = CHEAT_DANGEROUS;
	if (eternal)
		suite->timed = false;
	if (minimal)
		suite->style = CHEAT_MINIMAL;
	if (noisy)
		suite->quiet = false;
	if (plain)
		suite->style = CHEAT_PLAIN;
	if (safe)
		suite->harness = CHEAT_SAFE;
	if (timed)
		suite->timed = true;
	if (unsafe)
		suite->harness = CHEAT_UNSAFE;
	if (quiet)
		suite->quiet = true;

	if (help && !(list || version /* No conflicting options. */
				|| dangerous || eternal || noisy
				|| safe || timed || unsafe || quiet))
		cheat_print_usage(suite);
	else if (list && !(help || version
				|| dangerous || eternal || noisy
				|| safe || timed || unsafe || quiet))
		cheat_print_tests(suite);
	else if (version && !(help || list
				|| dangerous || eternal || noisy
				|| safe || timed || unsafe || quiet))
		cheat_print_version();
	else if (!(help || list || version)
			&& !(colorful && minimal)
			&& !(colorful && plain)
			&& !(minimal && plain)
			&& !(dangerous && safe)
			&& !(dangerous && unsafe)
			&& !(noisy && quiet)
			&& !(safe && unsafe)
			&& !(eternal && timed)
			&& !(timed && (dangerous || unsafe))) {

#ifdef CHEAT_WINDOWED

		if (hidden) {
			if (names.count == 0)
				cheat_death("test not specified", 0);

			suite->message_stream = stdout;

			cheat_run_hidden(suite, names.items[names.count - 1]);
			cheat_clear_string_list(&names);

			exit(cheat_encode_outcome(suite->outcome));
		}

#endif

		cheat_run_suite(suite, &names);
	} else
		cheat_death("invalid combination of options", 0);

	cheat_clear_string_list(&names);
}

/*
Prepares the environment for running tests or
terminates the program in case of a failure.
*/
static void cheat_prepare(void) {

#ifdef CHEAT_WINDOWED

	DWORD mode;

	/*
	This ridiculous shuffling prevents
	the executable "has encountered a problem and needs to close" dialog from
	popping up and making the test suite wait for user interaction.
	*/
	mode = SetErrorMode(SEM_NOGPFAULTERRORBOX);
	SetErrorMode(mode | SEM_NOGPFAULTERRORBOX);

#else
#ifdef CHEAT_POSIXLY

	/*
	Interruptions are unnecessary since
	processes wait for each other and
	the return values read() and write() are always checked.
	*/
	if (signal(SIGPIPE, SIG_IGN) == SIG_ERR)
		cheat_death("failed to add a handler for SIGPIPE", errno);

#endif
#endif

}

/*
This global test suite contains a pointer to the test units instead of
encompassing the units themselves, because
their size is not known when the type of the suite defined.
*/
static struct cheat_suite cheat_suite;

/*
These add source information to assertions.
*/

#define cheat_assert(expression) \
	cheat_check(&cheat_suite, expression, #expression, __FILE__, __LINE__)

#define cheat_assert_not(expression) \
	cheat_check(&cheat_suite, !(expression), "!(" #expression ")", \
		__FILE__, __LINE__)

/*
This stops a test if it has already failed.
*/
#define cheat_yield() \
	CHEAT_BEGIN \
		if (cheat_suite.outcome != CHEAT_SUCCESSFUL) \
			return; \
	CHEAT_END

/*
These help the user place commas.
*/

#define CHEAT_COMMA ,

#ifdef CHEAT_VARIADIC
#define CHEAT_COMMAS(...) __VA_ARGS__ /* This is not very useful. */
#endif

/*
These are automatically generated with
$ tcc -run meta.c 127
or equivalent.
*/
#define CHEAT_COMMAS_1(x1, x2) x1, x2
#define CHEAT_COMMAS_2(x1, x2, x3) x1, x2, x3
#define CHEAT_COMMAS_3(x1, x2, x3, x4) x1, x2, x3, x4
#define CHEAT_COMMAS_4(x1, x2, x3, x4, x5) x1, x2, x3, x4, x5
#define CHEAT_COMMAS_5(x1, x2, x3, x4, x5, x6) x1, x2, x3, x4, x5, x6
#define CHEAT_COMMAS_6(x1, x2, x3, x4, x5, x6, x7) x1, x2, x3, x4, x5, x6, x7
#define CHEAT_COMMAS_7(x1, x2, x3, x4, x5, x6, x7, x8) x1, x2, x3, x4, x5, x6, x7, x8
#define CHEAT_COMMAS_8(x1, x2, x3, x4, x5, x6, x7, x8, x9) x1, x2, x3, x4, x5, x6, x7, x8, x9
#define CHEAT_COMMAS_9(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10
#define CHEAT_COMMAS_10(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11
#define CHEAT_COMMAS_11(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12
#define CHEAT_COMMAS_12(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13
#define CHEAT_COMMAS_13(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14
#define CHEAT_COMMAS_14(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15
#define CHEAT_COMMAS_15(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16
#define CHEAT_COMMAS_16(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17
#define CHEAT_COMMAS_17(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18
#define CHEAT_COMMAS_18(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19
#define CHEAT_COMMAS_19(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20
#define CHEAT_COMMAS_20(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21
#define CHEAT_COMMAS_21(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22
#define CHEAT_COMMAS_22(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23
#define CHEAT_COMMAS_23(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24
#define CHEAT_COMMAS_24(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25
#define CHEAT_COMMAS_25(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26
#define CHEAT_COMMAS_26(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27
#define CHEAT_COMMAS_27(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28
#define CHEAT_COMMAS_28(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29
#define CHEAT_COMMAS_29(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30
#define CHEAT_COMMAS_30(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
#define CHEAT_COMMAS_31(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32
#define CHEAT_COMMAS_32(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33
#define CHEAT_COMMAS_33(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34
#define CHEAT_COMMAS_34(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35
#define CHEAT_COMMAS_35(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36
#define CHEAT_COMMAS_36(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37
#define CHEAT_COMMAS_37(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38
#define CHEAT_COMMAS_38(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39
#define CHEAT_COMMAS_39(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40
#define CHEAT_COMMAS_40(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41
#define CHEAT_COMMAS_41(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42
#define CHEAT_COMMAS_42(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43
#define CHEAT_COMMAS_43(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44
#define CHEAT_COMMAS_44(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45
#define CHEAT_COMMAS_45(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46
#define CHEAT_COMMAS_46(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47
#define CHEAT_COMMAS_47(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48
#define CHEAT_COMMAS_48(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49
#define CHEAT_COMMAS_49(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50
#define CHEAT_COMMAS_50(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51
#define CHEAT_COMMAS_51(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52
#define CHEAT_COMMAS_52(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53
#define CHEAT_COMMAS_53(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54
#define CHEAT_COMMAS_54(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55
#define CHEAT_COMMAS_55(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56
#define CHEAT_COMMAS_56(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57
#define CHEAT_COMMAS_57(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58
#define CHEAT_COMMAS_58(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59
#define CHEAT_COMMAS_59(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60
#define CHEAT_COMMAS_60(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61
#define CHEAT_COMMAS_61(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62
#define CHEAT_COMMAS_62(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63
#define CHEAT_COMMAS_63(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64
#define CHEAT_COMMAS_64(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65
#define CHEAT_COMMAS_65(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66
#define CHEAT_COMMAS_66(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67
#define CHEAT_COMMAS_67(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68
#define CHEAT_COMMAS_68(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69
#define CHEAT_COMMAS_69(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70
#define CHEAT_COMMAS_70(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71
#define CHEAT_COMMAS_71(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72
#define CHEAT_COMMAS_72(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73
#define CHEAT_COMMAS_73(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74
#define CHEAT_COMMAS_74(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75
#define CHEAT_COMMAS_75(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76
#define CHEAT_COMMAS_76(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77
#define CHEAT_COMMAS_77(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78
#define CHEAT_COMMAS_78(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79
#define CHEAT_COMMAS_79(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80
#define CHEAT_COMMAS_80(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81
#define CHEAT_COMMAS_81(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82
#define CHEAT_COMMAS_82(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83
#define CHEAT_COMMAS_83(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84
#define CHEAT_COMMAS_84(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85
#define CHEAT_COMMAS_85(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86
#define CHEAT_COMMAS_86(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87
#define CHEAT_COMMAS_87(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88
#define CHEAT_COMMAS_88(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89
#define CHEAT_COMMAS_89(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90
#define CHEAT_COMMAS_90(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91
#define CHEAT_COMMAS_91(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92
#define CHEAT_COMMAS_92(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93
#define CHEAT_COMMAS_93(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94
#define CHEAT_COMMAS_94(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95
#define CHEAT_COMMAS_95(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96
#define CHEAT_COMMAS_96(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97
#define CHEAT_COMMAS_97(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98
#define CHEAT_COMMAS_98(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99
#define CHEAT_COMMAS_99(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100
#define CHEAT_COMMAS_100(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101
#define CHEAT_COMMAS_101(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102
#define CHEAT_COMMAS_102(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103
#define CHEAT_COMMAS_103(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104
#define CHEAT_COMMAS_104(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105
#define CHEAT_COMMAS_105(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106
#define CHEAT_COMMAS_106(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107
#define CHEAT_COMMAS_107(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108
#define CHEAT_COMMAS_108(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109
#define CHEAT_COMMAS_109(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110
#define CHEAT_COMMAS_110(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111
#define CHEAT_COMMAS_111(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112
#define CHEAT_COMMAS_112(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113
#define CHEAT_COMMAS_113(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114
#define CHEAT_COMMAS_114(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115
#define CHEAT_COMMAS_115(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116
#define CHEAT_COMMAS_116(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117
#define CHEAT_COMMAS_117(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118
#define CHEAT_COMMAS_118(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119
#define CHEAT_COMMAS_119(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120
#define CHEAT_COMMAS_120(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121
#define CHEAT_COMMAS_121(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122
#define CHEAT_COMMAS_122(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123
#define CHEAT_COMMAS_123(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124
#define CHEAT_COMMAS_124(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124, x125) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124, x125
#define CHEAT_COMMAS_125(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124, x125, x126) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124, x125, x126
#define CHEAT_COMMAS_126(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124, x125, x126, x127) x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, x61, x62, x63, x64, x65, x66, x67, x68, x69, x70, x71, x72, x73, x74, x75, x76, x77, x78, x79, x80, x81, x82, x83, x84, x85, x86, x87, x88, x89, x90, x91, x92, x93, x94, x95, x96, x97, x98, x99, x100, x101, x102, x103, x104, x105, x106, x107, x108, x109, x110, x111, x112, x113, x114, x115, x116, x117, x118, x119, x120, x121, x122, x123, x124, x125, x126, x127

/*
These determine the reserved names.
*/

#define CHEAT_WRAP(name) \
	(cheat_wrapped_##name)

#define CHEAT_UNWRAP(name) \
	(cheat_unwrapped_##name)

#define CHEAT_GET(name) \
	(cheat_test_##name)

#define CHEAT_CALL(name) \
	(CHEAT_GET(name)())

/*
This pass declares the prototypes of test and utility procedures.
*/
#define CHEAT_PASS 1 /* This is informational. */

#ifdef CHEAT_VARIADIC

/*
These variations eliminate the comma problem.
*/

#define CHEAT_TEST(name, ...) \
	static void CHEAT_GET(name)(void);

#define CHEAT_IGNORE(name, ...) \
	CHEAT_TEST(name, __VA_ARGS__)

#define CHEAT_SKIP(name, ...) \
	CHEAT_TEST(name, __VA_ARGS__)

#define CHEAT_REPEAT(name, ...) \
	CHEAT_TEST(name, __VA_ARGS__)

#define CHEAT_SET_UP(...) \
	static void cheat_set_up(void);

#define CHEAT_TEAR_DOWN(...) \
	static void cheat_tear_down(void);

#define CHEAT_DECLARE(...)

#else

#define CHEAT_TEST(name, body) \
	static void CHEAT_GET(name)(void);

#define CHEAT_IGNORE(name, body) \
	CHEAT_TEST(name, body)

#define CHEAT_SKIP(name, body) \
	CHEAT_TEST(name, body)

#define CHEAT_REPEAT(name, body) \
	CHEAT_TEST(name, body)

#define CHEAT_SET_UP(body) \
	static void cheat_set_up(void);

#define CHEAT_TEAR_DOWN(body) \
	static void cheat_tear_down(void);

#define CHEAT_DECLARE(body)

#endif

#include __BASE_FILE__

#undef CHEAT_TEST
#undef CHEAT_IGNORE
#undef CHEAT_SKIP
#undef CHEAT_REPEAT
#undef CHEAT_SET_UP
#undef CHEAT_TEAR_DOWN
#undef CHEAT_DECLARE

#undef CHEAT_PASS

/*
This pass generates a list of the previously declared procedures.
*/
#define CHEAT_PASS 2

#ifdef CHEAT_VARIADIC

#define CHEAT_TEST(name, ...) \
	{ \
		#name, \
		CHEAT_TESTER, \
		CHEAT_NORMAL_TEST, \
		CHEAT_GET(name) \
	},

#define CHEAT_IGNORE(name, ...) \
	{ \
		#name, \
		CHEAT_TESTER, \
		CHEAT_IGNORED_TEST, \
		CHEAT_GET(name) \
	},

#define CHEAT_SKIP(name, ...) \
	{ \
		#name, \
		CHEAT_TESTER, \
		CHEAT_SKIPPED_TEST, \
		CHEAT_GET(name) \
	},

#define CHEAT_REPEAT(name, ...) \
	CHEAT_TEST(name, __VA_ARGS__)

#define CHEAT_SET_UP(...) \
	{ \
		NULL, \
		CHEAT_UTILITY, \
		CHEAT_SET_UP_UTILITY, \
		cheat_set_up \
	},

#define CHEAT_TEAR_DOWN(...) \
	{ \
		NULL, \
		CHEAT_UTILITY, \
		CHEAT_TEAR_DOWN_UTILITY, \
		cheat_tear_down \
	},

#define CHEAT_DECLARE(...)

#else

#define CHEAT_TEST(name, body) \
	{ \
		#name, \
		CHEAT_TESTER, \
		CHEAT_NORMAL_TEST, \
		CHEAT_GET(name) \
	},

#define CHEAT_IGNORE(name, body) \
	{ \
		#name, \
		CHEAT_TESTER, \
		CHEAT_IGNORED_TEST, \
		CHEAT_GET(name) \
	},

#define CHEAT_SKIP(name, body) \
	{ \
		#name, \
		CHEAT_TESTER, \
		CHEAT_SKIPPED_TEST, \
		CHEAT_GET(name) \
	},

#define CHEAT_REPEAT(name, body) \
	CHEAT_TEST(name, body)

#define CHEAT_SET_UP(body) \
	{ \
		NULL, \
		CHEAT_UTILITY, \
		CHEAT_SET_UP_UTILITY, \
		cheat_set_up \
	},

#define CHEAT_TEAR_DOWN(body) \
	{ \
		NULL, \
		CHEAT_UTILITY, \
		CHEAT_TEAR_DOWN_UTILITY, \
		cheat_tear_down \
	},

#define CHEAT_DECLARE(body)

#endif

static struct cheat_unit const cheat_units[] = {
#include __BASE_FILE__
	{
		NULL,
		CHEAT_TERMINATOR,
		0,
		NULL
	} /* This terminator exists to avoid
			the problems some compilers have with
			trailing commas or arrays with zero size, but
			also helps avoid having to
			extend the test suite with the unit count, which
			would have to be qualified const. */
};

#undef CHEAT_TEST
#undef CHEAT_IGNORE
#undef CHEAT_SKIP
#undef CHEAT_REPEAT
#undef CHEAT_SET_UP
#undef CHEAT_TEAR_DOWN
#undef CHEAT_DECLARE

#undef CHEAT_PASS

/*
This pass defines and wraps up the previously listed procedures.
*/
#define CHEAT_PASS 3

#ifdef CHEAT_VARIADIC

#define CHEAT_TEST(name, ...) \
	static void CHEAT_GET(name)(void) { \
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		{ \
			__VA_ARGS__ \
		} \
	}

#define CHEAT_IGNORE(name, ...) \
	static void CHEAT_GET(name)(void) { \
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		{ \
			__VA_ARGS__ \
		} \
		if (!cheat_suite.force) \
			cheat_suite.outcome = CHEAT_IGNORED; \
	}

#define CHEAT_SKIP(name, ...) \
	static void CHEAT_GET(name)(void) { \
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		if (cheat_suite.force) {\
			__VA_ARGS__ \
		} else \
			cheat_suite.outcome = CHEAT_SKIPPED; \
	}

#define CHEAT_REPEAT(name, ...) \
	static void CHEAT_GET(name)(void) { \
		size_t cheat_index; \
		\
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		for (cheat_index = 0; \
				cheat_index < CHEAT_REPETITIONS; \
				++cheat_index) { \
			__VA_ARGS__ \
			cheat_yield(); \
		} \
	}

#define CHEAT_SET_UP(...) \
	static void cheat_set_up(void) { \
		__VA_ARGS__ \
	}

#define CHEAT_TEAR_DOWN(...) \
	static void cheat_tear_down(void) { \
		__VA_ARGS__ \
	}

#define CHEAT_DECLARE(...) \
	__VA_ARGS__

#else

#define CHEAT_TEST(name, body) \
	static void CHEAT_GET(name)(void) { \
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		{ \
			body \
		} \
	}

#define CHEAT_IGNORE(name, body) \
	static void CHEAT_GET(name)(void) { \
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		{ \
			body \
		} \
		if (!cheat_suite.force) \
			cheat_suite.outcome = CHEAT_IGNORED; \
	}

#define CHEAT_SKIP(name, body) \
	static void CHEAT_GET(name)(void) { \
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		if (cheat_suite.force) {\
			body \
		} else \
			cheat_suite.outcome = CHEAT_SKIPPED; \
	}

#define CHEAT_REPEAT(name, body) \
	static void CHEAT_GET(name)(void) { \
		size_t cheat_index; \
		\
		cheat_suite.test_name = #name; \
		cheat_suite.outcome = CHEAT_SUCCESSFUL; \
		for (cheat_index = 0; \
				cheat_index < CHEAT_REPETITIONS; \
				++cheat_index) { \
			body \
			cheat_yield(); \
		} \
	}

#define CHEAT_SET_UP(body) \
	static void cheat_set_up(void) { \
		body \
	}

#define CHEAT_TEAR_DOWN(body) \
	static void cheat_tear_down(void) { \
		body \
	}

#define CHEAT_DECLARE(body) \
	body

#endif

/*
The third pass continues past the end of this file, but
the definitions for it end here.
*/

/*
Suppresses a signal and
returns to a recovery point.
*/
__attribute__ ((__noreturn__))
static void cheat_handle_signal(int const number) {
	enum cheat_outcome outcome = CHEAT_CRASHED;

	if (number == SIGTERM)
		outcome = CHEAT_EXITED;

	longjmp(cheat_suite.environment, cheat_encode_outcome(outcome));
}

#ifndef CHEAT_NO_MAIN /* This can be set externally. */

/*
Runs tests from the main test suite and
returns EXIT_SUCCESS in case all tests passed or
EXIT_FAILURE in case of a failure.
*/
int main(int const count,
		char** const arguments) {
	cheat_prepare();

	cheat_initialize(&cheat_suite);
	cheat_suite.units = cheat_units;
	cheat_suite.handler = cheat_handle_signal;
	cheat_suite.program = arguments[0];
	cheat_suite.arguments.count = (size_t )(count - 1);
	cheat_suite.arguments.elements = &arguments[1];
	cheat_suite.harness = CHEAT_DANGEROUS;
#ifdef CHEAT_POSIXLY
	cheat_suite.timed = true;
	cheat_suite.harness = CHEAT_SAFE;
	if (isatty(STDOUT_FILENO) == 1)
		cheat_suite.style = CHEAT_COLORFUL;
#else
#ifdef CHEAT_WINDOWED
	cheat_suite.timed = true;
	cheat_suite.harness = CHEAT_SAFE;
#endif
#endif

	cheat_parse(&cheat_suite);
	cheat_clear_lists(&cheat_suite);

	if (cheat_suite.tests.failed == 0)
		return EXIT_SUCCESS;
	return EXIT_FAILURE;
}

#endif

/*
These are a "best effort" attempt to manage process termination
and stream capturing without process isolation.
Some libraries and system calls can still exit or print things, but
that is a problem for the user to solve.
*/

#ifndef CHEAT_NO_WRAP

__attribute__ ((__noreturn__, __unused__))
static void CHEAT_UNWRAP(abort)(void) {
	abort();
}

__attribute__ ((__unused__))
static void CHEAT_WRAP(abort)(void) {
	cheat_exit(&cheat_suite, CHEAT_CRASHED);
}

#define abort CHEAT_WRAP(abort)

__attribute__ ((__noreturn__, __unused__))
static void CHEAT_UNWRAP(exit)(int const status) {
	exit(status);
}

__attribute__ ((__unused__))
static void CHEAT_WRAP(exit)(int const status) {
	cheat_exit(&cheat_suite, CHEAT_EXITED);
}

#define exit CHEAT_WRAP(exit)

#ifdef CHEAT_MODERN

__attribute__ ((__noreturn__, __unused__))
static void CHEAT_UNWRAP(_Exit)(int const status) {
	_Exit(status);
}

__attribute__ ((__unused__))
static void CHEAT_WRAP(_Exit)(int const status) {
	cheat_exit(&cheat_suite, CHEAT_EXITED);
}

#define _Exit CHEAT_WRAP(_Exit)

#endif

#ifdef CHEAT_POSIXLY

__attribute__ ((__noreturn__, __unused__))
static void CHEAT_UNWRAP(_exit)(int const status) {
	_exit(status);
}

__attribute__ ((__unused__))
static void CHEAT_WRAP(_exit)(int const status) {
	cheat_exit(&cheat_suite, CHEAT_EXITED);
}

#define _exit CHEAT_WRAP(_exit)

#endif

#ifdef CHEAT_MODERN

__attribute__ ((__unused__))
static size_t cheat_printed_length(char const* const format,
		va_list list) {
	va_list another_list;

	va_copy(another_list, list); /* This is a big compatibility bottleneck. */
	return (size_t )vsnprintf(NULL, 0, format, another_list);

}

#endif

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(vfprintf)(FILE* const stream,
		char const* const format,
		va_list list) {
	return vfprintf(stream, format, list);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(vfprintf)(FILE* const stream,
		char const* const format,
		va_list list) {
	if (cheat_hide(&cheat_suite, stream)) {

#ifdef CHEAT_MODERN

		size_t length;
		char* buffer;
		int result;

		length = cheat_printed_length(format, list);

		if (cheat_capture(&cheat_suite, stream)) {
			buffer = CHEAT_CAST(char*, malloc(length + 1));
			if (buffer == NULL)
				return -1;

			result = vsprintf(buffer, format, list);
			if (stream == stdout)
				cheat_append_list(&cheat_suite.outputs, buffer, length);
			else
				cheat_append_list(&cheat_suite.errors, buffer, length);

			free(buffer);
		}

		return result;

#else

		return -1;

#endif

	}

	return vfprintf(stream, format, list);
}

#define vfprintf CHEAT_WRAP(vfprintf)

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(vprintf)(char const* const format,
		va_list list) {
	return vprintf(format, list);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(vprintf)(char const* const format,
		va_list list) {
	return CHEAT_WRAP(vfprintf)(stdout, format, list);
}

#define vprintf CHEAT_WRAP(vprintf)

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(fprintf)(FILE* const stream,
		char const* const format, ...) {
	va_list list;
	int result;

	va_start(list, format);
	result = CHEAT_UNWRAP(vfprintf)(stream, format, list);
	va_end(list);
	return result;
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(fprintf)(FILE* const stream,
		char const* const format, ...) {
	va_list list;
	int result;

	va_start(list, format);
	result = CHEAT_WRAP(vfprintf)(stream, format, list);
	va_end(list);
	return result;
}

#define fprintf CHEAT_WRAP(fprintf)

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(printf)(char const* const format, ...) {
	va_list list;
	int result;

	va_start(list, format);
	result = CHEAT_UNWRAP(vprintf)(format, list);
	va_end(list);
	return result;
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(printf)(char const* const format, ...) {
	va_list list;
	int result;

	va_start(list, format);
	result = CHEAT_WRAP(vprintf)(format, list);
	va_end(list);
	return result;
}

#define printf CHEAT_WRAP(printf)

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(fputs)(char const* const message,
		FILE* const stream) {
	return fputs(message, stream);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(fputs)(char const* const message,
		FILE* const stream) {
	int result;

	result = CHEAT_WRAP(fprintf)(stream, "%s", message);

	if (result < 0)
		return EOF;

	return 0;
}

#define fputs CHEAT_WRAP(fputs)

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(fputc)(int const character,
		FILE* const stream) {
	return fputc(character, stream);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(fputc)(int const character,
		FILE* const stream) {
	int result;

	result = CHEAT_WRAP(fprintf)(stream, "%c", character);

	if (result < 0)
		return EOF;

	return (int )(unsigned char )result;
}

#define fputc CHEAT_WRAP(fputc)

/*
This is needed if putc() is defined as a preprocessor directive.
*/
#ifdef putc
#undef putc
#endif

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(putc)(int const character,
		FILE* const stream) {
	return putc(character, stream);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(putc)(int const character,
		FILE* const stream) {
	return CHEAT_WRAP(fputc)(character, stream);
}

#define putc CHEAT_WRAP(putc)

#ifdef putchar
#undef putchar
#endif

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(putchar)(int const character) {
	return putchar(character);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(putchar)(int const character) {
	return CHEAT_WRAP(putc)(character, stdout);
}

#define putchar CHEAT_WRAP(putchar)

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(puts)(char const* const message) {
	return puts(message);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(puts)(char const* const message) {
	if (CHEAT_WRAP(fputs)(message, stdout) == EOF
			|| CHEAT_WRAP(putchar)('\n') == EOF)
		return EOF;

	return 0;
}

#define puts CHEAT_WRAP(puts)

__attribute__ ((__unused__))
static size_t CHEAT_UNWRAP(fwrite)(void const* const buffer,
		size_t const size,
		size_t const count,
		FILE* const stream) {
	return fwrite(buffer, size, count, stream);
}

__attribute__ ((__unused__))
static size_t CHEAT_WRAP(fwrite)(void const* const buffer,
		size_t const size,
		size_t const count,
		FILE* const stream) {
	if (cheat_hide(&cheat_suite, stream)) {

#ifdef CHEAT_MODERN

		if (cheat_capture(&cheat_suite, stream)) {
			if (stream == stdout)
				cheat_append_list(&cheat_suite.outputs, buffer, size * count);
			else
				cheat_append_list(&cheat_suite.errors, buffer, size * count);
		}

		return count;

#else

		return 0; /* This is consistent with CHEAT_WRAP(vfprintf)(). */

#endif

	}

	return fwrite(buffer, size, count, stream);
}

#define fwrite CHEAT_WRAP(fwrite)

__attribute__ ((__unused__))
static int CHEAT_UNWRAP(fflush)(FILE* const stream) {
	return fflush(stream);
}

__attribute__ ((__unused__))
static int CHEAT_WRAP(fflush)(FILE* const stream) {
	if (cheat_hide(&cheat_suite, stream))
		return 0;

	return fflush(stream);
}

#define fflush CHEAT_WRAP(fflush)

__attribute__ ((__unused__))
static void CHEAT_UNWRAP(perror)(char const* const message) {
	perror(message);
}

__attribute__ ((__unused__))
static void CHEAT_WRAP(perror)(char const* const message) {
	if (cheat_hide(&cheat_suite, stderr)) {

#ifdef CHEAT_MODERN
#ifdef CHEAT_VERY_POSIXLY
		CHEAT_WRAP(fprintf)(stderr, "%s: %s\n", message, strerror(errno));
#else
		CHEAT_WRAP(fprintf)(stderr, "%s: Failure\n", message);
#endif
#endif

		return;

	}

	perror(message);
}

#define perror CHEAT_WRAP(perror)

#ifdef CHEAT_POSIXLY

__attribute__ ((__unused__))
static ssize_t CHEAT_UNWRAP(write)(int const fd,
		void const* const buffer,
		size_t const size) {
	return write(fd, buffer, size);
}

__attribute__ ((__unused__))
static ssize_t CHEAT_WRAP(write)(int const fd,
		void const* const buffer,
		size_t const size) {
	FILE* stream;

	stream = fdopen(fd, "w");
	if (stream != NULL && cheat_hide(&cheat_suite, stream)) {
		size_t result;

		result = CHEAT_WRAP(fwrite)(buffer, 1, size, stream);

		if (result == 0)
			return -1;

		return (ssize_t )result;
	}

	return write(fd, buffer, size);
}

#define write CHEAT_WRAP(write)

#endif

#endif

#ifdef CHEAT_POSTMODERN
}
#endif

#endif
