class SOAP::Client;

use LWP::Simple;
use XML;

has $.wsdl;

method call($name, *@params) {
    my $namespace = $.wsdl.namespace;
    my $in-message;
    my $out-message;
    my $location;
    my $soapaction;
    my $type;
    
    # find the porttypes for the operation
    for $.wsdl.services.kv -> $service, $sdata {
        for $sdata<ports>.kv -> $port, $pdata {
            if $.wsdl.bindings{$pdata<binding>}<operations>{$name} {
                $type = $.wsdl.bindings{$pdata<binding>}<type>;
                $soapaction = $.wsdl.bindings{$pdata<binding>}<operations>{$name}<soap-action>;
                $location = $pdata<location>;
                $in-message = $.wsdl.messages{$.wsdl.porttypes{$.wsdl.bindings{$pdata<binding>}<porttype>}<operations>{$name}<input>};
                $out-message = $.wsdl.messages{$.wsdl.porttypes{$.wsdl.bindings{$pdata<binding>}<porttype>}<operations>{$name}<output>};
            }
        }
    }
    
    # build in-message
    my @in;
    for $in-message<parts>.list -> $part {
        if $part<element> {
            my $element = $.wsdl.types<elements>{$part<element>};
            if $element<type> {
                my $value = @params.shift;
                @in.push(make-xml($part<element>, :xmlns($namespace), ~$value));
            }
            elsif $element<sequence> {
                my @seq;
                for $element<sequence>.list -> $seq-part {
                    if $seq-part<element> {
                        my $seq-elem = $.wsdl.types<elements>{$seq-part<element>};
                        if $seq-elem<type> {
                            my $value = @params.shift;
                            @seq.push(make-xml($seq-part<element>, ~$value));
                        }
                        elsif $seq-elem<sequence> {
                            die "Nested params NYI";
                        }
                    }
                }
                @in.push(make-xml($part<element>, :xmlns($namespace), |@seq));
            }
        }
    }
    
    # build soap request
    my $body = make-xml("soap:Body", |@in);
    my $request = make-xml("soap:Envelope",
                            $body);
    $request.setNamespace('http://schemas.xmlsoap.org/soap/envelope/', 'soap');
    
    $request = '<?xml version="1.0" encoding="utf-8"?>' ~ $request;
    
    # send to location
    my %headers = ('Content-Type' => 'text/xml');
    if $type eq 'soap' {
        %headers<SOAPAction> = $soapaction;
    }
    my $response = LWP::Simple.post($location, %headers, $request);
    
    my $r-xml = from-xml($response);
    
    my $soap-prefix = $r-xml.nsPrefix('http://schemas.xmlsoap.org/soap/envelope/');
    
    my $rbody = $r-xml.elements(:TAG($soap-prefix~':Body'), :SINGLE);
    
    # Cheat!
    return $rbody.elements[0][0].contents;
}