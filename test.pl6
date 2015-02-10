use SOAP::Client::WSDL;
use SOAP::Client;

my $w = SOAP::Client::WSDL.new;
$w.parse('converttemperature.xml');

my $s = SOAP::Client.new(wsdl => $w);
say $s.call('ConvertTemp', 32, 'degreeCelsius', 'degreeFahrenheit');