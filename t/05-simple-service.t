use v6;
use Test;

plan *;

use SOAP::Client;

# Reference:
# http://wiki.dreamfactory.com/DreamFactory/Tutorials/Temp_Conversion_SOAP_API

my $temp = SOAP::Client.new('http://www.w3schools.com/xml/tempconvert.asmx?WSDL');
ok $temp, "Got a SOAP::Client object for ConvertTemperature";

my $result = $temp.call('CelsiusToFahrenheit', Celsius => 100);
ok $result, "Got a result for a temperature conversion";
is $result<CelsiusToFahrenheitResult>, 212, "Got correct result";

#my $stats = SOAP::Client.new('http://www.webservicex.net/Statistics.asmx?WSDL');
#ok $stats, "Got a SOAP::Client object for Statistics";

#$result = $stats.call('GetStatistics', X => {double => [1, 2, 3]});
#ok $result, "Got a result for Statistics";
#is $result<Sums>, 6, "Got correct result";
