package Apache::LogIgnore;

$Apache::LogIgnore::VERSION = 0.02;

use 5.006;
use strict;
use Apache::Constants qw(:common);

sub handler {
    my $r = shift;
    my $debugflag = $r->dir_config("DebugFlag");
    my $ignorehost = $r->dir_config("IgnoreHost");
    return DONE if $r->get_remote_host eq $ignorehost;
    warn "Checked Remote Host" if $debugflag;
    my $ignoreagent = $r->dir_config("IgnoreAgent");
    return DONE if $r->header_in("User-Agent") =~ /$ignoreagent/i && $r->header_in("User-Agent") && $r->dir_config("IgnoreAgent");
    warn "Checked User Agent" if $debugflag;
    my $ignorereferer = $r->dir_config("IgnoreReferer");
    return DONE if $r->header_in("Referer") =~ /$ignorereferer/i && $r->header_in("Referer") && $r->dir_config("IgnoreReferer");
    warn "Checked Referer" if $debugflag;
    my $ignorefrom = $r->dir_config("IgnoreFrom");
    return DONE if $r->header_in("From") =~ /$ignorefrom/i && $r->header_in("From") && $r->dir_config("IgnoreFrom");
    warn "Checked From" if $debugflag;
    my $filesize = -s $r->filename;
    my $ignoreminsize = $r->dir_config("IgnoreMinSize");
    return DONE if $filesize <= $ignoreminsize && $filesize && $r->dir_config("IgnoreMinSize");
    warn "Checked Minimum Size" if $debugflag;
    my $ignoremaxsize = $r->dir_config("IgnoreMaxSize");
    return DONE if $filesize >= $ignoremaxsize && $filesize && $r->dir_config("IgnoreMaxSize");
    warn "Checked Maximum Size" if $debugflag;
    my $ignoretype = $r->dir_config("IgnoreType");
    return DONE if $r->content_type =~ /$ignoretype/i && $r->content_type && $r->dir_config("IgnoreType");
    warn "Checked Content Type" if $debugflag;
    my $ignorestatus = $r->dir_config("IgnoreStatus");
    return DONE if $r->status eq $ignorestatus && $r->status && $r->dir_config("IgnoreStatus");
    warn "Checked Status" if $debugflag;
    return OK;
}

1;
__END__
=head1 NAME

Apache::LogIgnore - mod_perl log handler to ignore connections

=head1 SYNOPSIS

in your httpd.conf file, put this in the mod_perl load block (if you have one)

<Location />

PerlLogHandler Apache::LogIgnore

PerlSetVar     DebugFlag 1

#Turn Debugging on

PerlSetVar     IgnoreHost 192.168.0.2

#Dont log connections from host

#Exact match

PerlSetVar     IgnoreAgent Moz

#Dont log connections using agent

#Containing match, case insensitive

PerlSetVar     IgnoreReferer 192.168.0.2

#Dont log connections referred by IP

#Containing match, case insensitive

PerlSetVar     IgnoreFrom foo@bar.com

#Dont log connections from Agents with certain E-Mail addresses set

#Containing match, case insensitive

PerlSetVar     IgnoreMinSize 100

#Dont log connections below 100 bytes

PerlSetVar     IgnoreMaxSize 400000

#Dont log connections above 400000 bytes

PerlSetVar     IgnoreType Image

#Dont log connections to certain mime-types

#Containing match, case insensitive

PerlSetVar     IgnoreStatus 403

#Dont log status code

#Exact match

</Location>

=head1 DESCRIPTION

This mod_perl log handler can be used to ignore connections which match the
criteria.

=head1 USING

Use the following settings in your apache config file.

=over 3

=item IgnoreHost 192.168.0.1

This option disables the logging of requests from the specified host.

=back

=over 3

=item IgnoreAgent MSIE

This option disables the logging of requests with a specified browser.
The matching is not exact, the provided keyword is used to match within the
browser signature.

=back

=over 3

=item IgnoreReferer 192.168.0.2

This option disables the logging of requests referred by the specified 
host/pageowser. The matching is not exact, the provided keyword is used to 
match within the referrer. Some browsers (like Konqueror and Mozilla) don't 
send a referrer. 

=back

=over 3

=item IgnoreFrom foo@bar.com

This option disables the logging of requests which send the specified E-Mail 
address as part of the From tag in the HTTP header.

=back

=over 3

=item IgnoreMinSize 100

This option disables the logging of requests which size is below a number of 
bytes.

=back

=over 3

=item IgnoreMaxSize 400000

This option disables the logging of requests which size is above a number of 
bytes.

=back

=over 3

=item IgnoreType Image

This option disables the logging of requests for certain mime types. The 
matching is not exact, the provided keyword is used to match within the 
mime type.

=back

=over 3

=item IgnoreStatus 403

This option disables the logging of requests resulting in a certain status 
code.

=back

=over 3

=item DebugFlag 1

Set this to true to get debug information in your error log.

=back


=head1 EXPORT

None by default.

=head1 AUTHOR

Hendrik Van Belleghem <lt> beatnik - at - quickndirty - dot - org<t>

=head1 SEE ALSO

=cut
