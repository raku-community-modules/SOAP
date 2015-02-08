use WSDL;
use SOAP;

my $w = WSDL.new;
$w.parse('..\p6-wsdl\converttemperature.xml');

my $s = SOAP.new(wsdl => $w);
say $s.call('ConvertTemp', 32, 'degreeCelsius', 'degreeFahrenheit');