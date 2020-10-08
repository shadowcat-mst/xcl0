use Test2::V0;
use Mojo::Base -strict, -signatures;

use XCL0::00::Reader qw(read_string);
use XCL0::00::Writer qw(write_string);
use XCL0::00::Runtime qw(eval_inscope);
use XCL0::00::Builtins qw(builtin_scope);
use XCL0::DataTest;

data_test \*DATA, sub ($v) {
  write_string(eval_inscope(builtin_scope(), read_string $v))
};

done_testing;

__DATA__
$ _type 'foo'
> 'String'
$ _rtype 'foo'
> 'chars'
$ _rmkchars 'String' 'foo'
> 'foo'
$ _rmkref 'Call' 'cons' 'x' [ _list 'y' ]
> [ 'x' 'y' ]
$ _rmkref 'Call' 'cons' [ _escape _type ] [ _list 'y' ]
> [ _type 'y' ]
$ _id 'foo'
> 'foo'
$ _string_concat 'foo' 'bar'
> 'foobar'
$ _eq_string 'foo' 'bar'
> false
$ _eq_string 'foo' 'foo'
> true
$ _gt_string 'x' 'a'
> true
$ _gt_string 'x' 'x'
> false
$ _gt_string 'a' 'x'
> false
$ _eq_bool [ _rtrue ] [ _rtrue ]
> true
$ _eq_bool [ _rfalse ] [ _rfalse ]
> true
$ _eq_bool [ _rfalse ] [ _rtrue ]
> false
$ _eq_bool [ _rtrue ] [ _rfalse ]
> false
$ _rnil? [ _rmknil 'List' ]
> true
$ _rnil? [ _list ]
> true
$ _rtrue; _rfalse
> false
$ [ _rmkref 'Fexpr' 'cons' [ _deref [ _getscope ] ] [ _escape [ _car args ] ] ] 'x' 'y'
> 'x'
$ _wutcol [ _rtrue ] 'x' 'y'
> 'x'
$ _wutcol [ _rfalse ] 'x' 'y'
> 'y'
$ _eq_string 'a' [ [ _rmkref 'Fexpr' 'cons' [ _deref [ _getscope ] ] [ _escape [
<   _wutcol [ _eq_string 'x' [ _car args ] ] 'a' 'b'
< ] ] ] 'x' ]
> true
$ [ _rmkref 'Fexpr' 'cons' [ _deref [ _getscope ] ] [ _escape [
<   _wutcol [ _eq_string 'x' [ _car args ] ] 'a' 'b'
< ] ] ] 'y'
> 'b'
$ [ [ _deref [ _getscope ] ] '_type' ] 'foo'
> 'String'
$ _rmkref 'Fexpr' 'cons' [ _deref [ _getscope ] ] [ _escape [
<   [ _deref [ _getscope ] ] [ _car args ]
< ] ]
> Fexpr()
$ [
<   [ _rmkref 'Fexpr' 'cons' [ _deref [ _getscope ] ] [ _escape [
<     [ _deref [ _getscope ] ] [ _car args ]
<   ] ] ] '_type'
< ] 'foo'
> 'String'
$ _set [ _getscope ]
<   [ _rmkref 'Fexpr' 'cons' [ _deref [ _getscope ] ] [ _escape [
<     [ _deref [ _getscope ] ] [ _car args ]
<   ] ] ];
< _type 'foo'
> 'String'
$ _set [ _getscope ]
<   [ _rmkref 'Fexpr' 'cons' [ _deref [ _getscope ] ] [ _escape [
<     _wutcol [ _eq_string [ _car args ] 'x' ]
<      'is_x'
<    [ [ _deref [ _getscope ] ] [ _car args ] ]
<   ] ] ];
< _id x
> 'is_x'
