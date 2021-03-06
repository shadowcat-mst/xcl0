use Test2::V0;
use Mojo::Base -strict, -signatures;

use NXCL::00::Reader qw(read_string);
use NXCL::00::Writer qw(write_string);
use NXCL::00::Runtime qw(eval0_00);
use NXCL::00::Builtins qw(builtin_scope);
use NXCL::DataTest;

data_test \*DATA, sub ($v) {
  write_string(eval0_00(builtin_scope(), read_string $v))
};

done_testing;

__DATA__
$ _type 'foo'
< 'String00'
$ _rtype 'foo'
< 'chars'
$ _rmkchars 'String00' 'foo'
< 'foo'
$ _rmkcons 'Call00' 'x' [ _list 'y' ]
< [ 'x' 'y' ]
$ _rmkcons 'Call00' [ _escape _type ] [ _list 'y' ]
< [ _type 'y' ]
$ _id 'foo'
< 'foo'
$ _concat_string 'foo' 'bar'
< 'foobar'
$ _eq_string 'foo' 'bar'
< false
$ _eq_string 'foo' 'foo'
< true
$ _gt_string 'x' 'a'
< true
$ _gt_string 'x' 'x'
< false
$ _gt_string 'a' 'x'
< false
$ _eq_bool [ _rtrue ] [ _rtrue ]
< true
$ _eq_bool [ _rfalse ] [ _rfalse ]
< true
$ _eq_bool [ _rfalse ] [ _rtrue ]
< false
$ _eq_bool [ _rtrue ] [ _rfalse ]
< false
$ _rnil? [ _rmknil 'List00' ]
< true
$ _rnil? [ _list ]
< true
$ _rtrue; _rfalse
< false
# fexpr (x, y) { x } -> 'x'
$ [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [ _car thisargs ] ] ] 'x' 'y'
< 'x'
$ _wutcol [ _rtrue ] 'x' 'y'
< 'x'
$ _wutcol [ _rfalse ] 'x' 'y'
< 'y'
# == 'a' [ fexpr (s) { ?: [ s == 'x' ] 'a' 'b' } 'x' ]
$ _eq_string 'a' [ [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>   _wutcol [ _eq_string 'x' [ _car thisargs ] ] 'a' 'b'
> ] ] ] 'x' ]
< true
# fexpr (s) { ?: [ s == 'x' ] 'a' 'b' } 'y'
$ [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>   _wutcol [ _eq_string 'x' [ _car thisargs ] ] 'a' 'b'
> ] ] ] 'y'
< 'b'
# _type 'foo'
$ [ _car [ _cdr [ [ _deref [ _getscope ] ] '_type' ] ] ] 'foo'
< 'String00'
$ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>   [ _deref [ _getscope ] ] [ _car thisargs ]
> ] ]
< Fexpr00([ [ _deref [ _getscope ] ] [ _car thisargs ] ])
# [ fexpr (x) { [ _deref [ _getscope ] ] x } '_type ] 'foo;
$ [ _car [ _cdr [
>   [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>     [ _wrap [ _deref [ _getscope ] ] ] [ _car thisargs ]
>   ] ] ] '_type'
> ] ] ] 'foo'
< 'String00'
# _set [ _getscope ] fexpr (x) { [ _deref [ _getscope ] ] x }; _type 'foo'
$ _set [ _getscope ]
>   [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>     [ _wrap [ _deref [ _getscope ] ] ] [ _car thisargs ]
>   ] ] ];
> _type 'foo'
< 'String00'
# _set [ _getscope ] fexpr (x) {
#   ?: [ _eq_string x 'x' ]
#     ('x', 'is_x')
#   [ _wrap [ _deref [ _getscope ] ] ] x
# }
$ _set [ _getscope ]
>   [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>     _wutcol [ _eq_string [ _car thisargs ] 'x' ]
>      [ _list 'x' 'is_x' ]
>    [ [ _wrap [ _deref [ _getscope ] ] ] [ _car thisargs ] ]
>   ] ] ];
> _id x
< 'is_x'
# [ fexpr (y) [ call _concat_string 'foo' y ] ] 'bar'
$ [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [
>       _rmkcons 'Call00' _concat_string
>         [ _list 'foo' [ _escape [ _car thisargs ] ] ]
> ] ] 'bar'
< 'foobar'
# [ [ fexpr (x) { fexpr (y) { _concat_string x y } } ] 'foo' ] 'bar'
$ [
>   [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>     _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [
>        _rmkcons 'Call00' _concat_string
>          [ _list [ _car thisargs ] [ _escape [ _car thisargs ] ] ]
>     ]
>   ] ] ]
>   'foo'
> ]
> 'bar'
< 'foobar'
# lambda (x, y) {
#   ?: [ empty? x ]
#     ''
#   ?: [ x(0)(0) == y ]
#     x(0)(1)
#   thisfunc [ rest x ] y
# }
# thisfunc ( ('x', '1'), ('y', '2') ) 'x'
$ [ _wrap [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>   _wutcol [ _rnil? [ _car thisargs ] ]
>     ''
>     [ _wutcol
>         [ _eq_string [ _car [ _car [ _car thisargs ] ] ] [ _car [ _cdr thisargs ] ] ]
>         [ _car [ _cdr [ _car [ _car thisargs ] ] ] ]
>         [ [ _wrap thisfunc ] [ _cdr [ _car thisargs ] ] [ _car [ _cdr thisargs ] ] ]
>     ]
> ] ] ] ]
> [ _list [ _list 'x' '1' ] [ _list 'y' '2' ] ] 'x'
< '1'
$ [ _wrap [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>   _wutcol [ _rnil? [ _car thisargs ] ]
>     ''
>     [ _wutcol
>         [ _eq_string [ _car [ _car [ _car thisargs ] ] ] [ _car [ _cdr thisargs ] ] ]
>         [ _car [ _cdr [ _car [ _car thisargs ] ] ] ]
>         [ [ _wrap thisfunc ] [ _cdr [ _car thisargs ] ] [ _car [ _cdr thisargs ] ] ]
>     ]
> ] ] ] ]
> [ _list [ _list 'x' '1' ] [ _list 'y' '2' ] ] 'y'
< '2'
$ [ _wrap [ _rmkcons 'Fexpr00' [ _deref [ _getscope ] ] [ _escape [
>   _wutcol [ _rnil? [ _car thisargs ] ]
>     ''
>     [ _wutcol
>         [ _eq_string [ _car [ _car [ _car thisargs ] ] ] [ _car [ _cdr thisargs ] ] ]
>         [ _car [ _cdr [ _car [ _car thisargs ] ] ] ]
>         [ [ _wrap thisfunc ] [ _cdr [ _car thisargs ] ] [ _car [ _cdr thisargs ] ] ]
>     ]
> ] ] ] ]
> [ _list [ _list 'x' '1' ] [ _list 'y' '2' ] ] 'z'
< ''
$ _panic 'Argh'
! Argh
$ _panic 'Argh' [ _list 'foo' 'bar' ]
! Argh: ('foo', 'bar')
$ _eq_ref 'foo' 'foo'
< false
$ _eq_ref [ _getscope ] [ _getscope ]
< true
$ _salis 'foo' [_list] _list
< ('foo')
$ _salis 'foo' [_list [ _list 'a' 'b' ] [ _list 'foo' 'bar' ] ] _list
< ('foo', 'bar')
