# SOAP::Client

Raku library that acts as a SOAP client.

Warning: This library currently only supports the simplest of SOAP calls.

## Synopsis

```raku
use SOAP;

my $temp = SOAP::Client.new('https://www.w3schools.com/xml/tempconvert.asmx?WSDL');
say $temp.call('CelsiusToFahrenheit', Celsius => 100);
```

## Authors

Initially by [Andrew Egeler `retupmoca`](https://github.com/retupmoca), currently managed by
 the Raku community in the Raku modules adoption center

# LICENSE

Licensed under the MIT license.
