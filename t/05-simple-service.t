use v6;
use Test;
plan 3;

use SOAP::Client;

try require IO::Socket::SSL;
if $! {
    skip-rest("IO::Socket::SSL not available");
    exit 0;
}
# Reference:
# http://wiki.dreamfactory.com/DreamFactory/Tutorials/Temp_Conversion_SOAP_API

my $temp = SOAP::Client.new('https://www.w3schools.com/xml/tempconvert.asmx?WSDL');
ok $temp, "Got a SOAP::Client object for ConvertTemperature";

my $result = $temp.call('CelsiusToFahrenheit', Celsius => 100);
ok $result, "Got a result for a temperature conversion";
is $result<CelsiusToFahrenheitResult>, 212, "Got correct result";