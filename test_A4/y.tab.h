/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CHARACTER = 258,
    STRING = 259,
    INTEGER = 260,
    VARIABLE = 261,
    FOR = 262,
    WHILE = 263,
    IF = 264,
    PUTI = 265,
    PUTC = 266,
    PUTS = 267,
    PUTI_ = 268,
    PUTC_ = 269,
    PUTS_ = 270,
    GETI = 271,
    GETC = 272,
    GETS = 273,
    RETURN = 274,
    DISCARD = 275,
    ARRAY = 276,
    IFX = 277,
    ELSE = 278,
    AND = 279,
    OR = 280,
    GE = 281,
    LE = 282,
    EQ = 283,
    NE = 284,
    UMINUS = 285
  };
#endif
/* Tokens.  */
#define CHARACTER 258
#define STRING 259
#define INTEGER 260
#define VARIABLE 261
#define FOR 262
#define WHILE 263
#define IF 264
#define PUTI 265
#define PUTC 266
#define PUTS 267
#define PUTI_ 268
#define PUTC_ 269
#define PUTS_ 270
#define GETI 271
#define GETC 272
#define GETS 273
#define RETURN 274
#define DISCARD 275
#define ARRAY 276
#define IFX 277
#define ELSE 278
#define AND 279
#define OR 280
#define GE 281
#define LE 282
#define EQ 283
#define NE 284
#define UMINUS 285

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 32 "c5.y" /* yacc.c:1909  */

    arraydim* dimension;
    arraydec* decDimension;
    char cValue;                /* char value */
    char *sValue;               /* string address */
    int iValue;                 /* integer value */
    char *sIndex;               /* variable name string address */
    nodeType *nPtr;             /* node pointer */

#line 124 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
