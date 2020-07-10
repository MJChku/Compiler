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
    STRING = 258,
    CHAR = 259,
    INTEGER = 260,
    VARIABLE = 261,
    FOR = 262,
    WHILE = 263,
    IF = 264,
    GETI = 265,
    GETC = 266,
    GETS = 267,
    PUTI = 268,
    PUTS = 269,
    PUTC = 270,
    PUTI_ = 271,
    PUTS_ = 272,
    PUTC_ = 273,
    RETURN = 274,
    IFX = 275,
    ELSE = 276,
    AND = 277,
    OR = 278,
    GE = 279,
    LE = 280,
    EQ = 281,
    NE = 282,
    UMINUS = 283
  };
#endif
/* Tokens.  */
#define STRING 258
#define CHAR 259
#define INTEGER 260
#define VARIABLE 261
#define FOR 262
#define WHILE 263
#define IF 264
#define GETI 265
#define GETC 266
#define GETS 267
#define PUTI 268
#define PUTS 269
#define PUTC 270
#define PUTI_ 271
#define PUTS_ 272
#define PUTC_ 273
#define RETURN 274
#define IFX 275
#define ELSE 276
#define AND 277
#define OR 278
#define GE 279
#define LE 280
#define EQ 281
#define NE 282
#define UMINUS 283

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 29 "c7.y" /* yacc.c:1909  */

    char* sValue;
    char* cValue;		/*character(s) value*/
    int iValue;                 /* integer value */
    char* sIndex;               
    nodeType *nPtr;             /* node pointer */
    paramlist *param;

#line 119 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
