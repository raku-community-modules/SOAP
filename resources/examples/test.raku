use lib <../../lib lib>;

use SOAP::Client;

my $file-name = "ConvertTemperature.xml".IO.e ?? 'ConvertTemperature.xml' !!
        'resources/examples/ConvertTemperature.xml';
my $s = SOAP::Client.new($file-name);
say $s.call('ConvertTemp', Temperature => 32, FromUnit => 'degreeCelsius', ToUnit => 'degreeFahrenheit');