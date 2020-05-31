    #!/usr/bin/perl
    #
    # Update the jormangandr config file with the current good peers from adapools.org/peers
    # - calling with --quick will clear the trsuted peers list to bypass bootstrap phase
    #
    use HTTP::Request;
    use LWP::UserAgent;
    use File::Basename;
    use JSON qw( encode_json decode_json );
    use Cwd qw( realpath );
    chdir realpath( dirname(__FILE__) );

    # Get the conf file name and decoded JSON content
    my $confFile = qx( ls *config.yaml | tr -d '\n' );
    my $conf = decode_json( qx( cat "$confFile" ) );

    my %peers = ();

    # Don't get any peers if the --quick option is set
    if( $ARGV[0] ne '--quick' ) {

    	# Get current good peers from adapools.org/peers, bail if none found after 10 tries
    	my $ua = LWP::UserAgent->new();
    	my $n = 0;
    	my $l = 0;
    	do {
    		sleep 2 if $n++;
    		my $html = $ua->get( 'https://adapools.org/peers' )->content;
    		%peers = $html =~ m|<td>(/ip[^<]+)</td>\s*<td>([0-9a-f]+)</td>\s*<td><span[^<]+success|gs;
    		$l = keys %peers;
    	} while( $l < 1 and $n < 10 );
    	die "No good peers found!" unless $l;
    }

    # Update the conf with the new peers and write back to the file
    $conf->{p2p}->{trusted_peers} = [];
    push @{$conf->{p2p}->{trusted_peers}}, {'address' => $_, 'id' => $peers{$_}} for keys %peers;
    $json = JSON->new->allow_nonref;
    open CONF, '>', $confFile;
    print CONF $json->pretty->encode( $conf );
    close CONF;