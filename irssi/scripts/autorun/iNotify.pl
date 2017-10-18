## /script load ~/iNotify.pl

use strict;
use Irssi;
use vars qw($VERSION %IRSSI);
use LWP::UserAgent;

$VERSION = "0.1";
%IRSSI = (
  authors     => "Nicolas Trippar",
  contact     => "ntrippar\@gmail.com",
  name        => "iNotify",
  description => "Script",
  license     => "",
  url         => "",
  changed     => ""
);

sub notify {
  my ($title, $subtitle, $body) = @_;
    $body =~ s/["';]//g;

  my $ua = LWP::UserAgent->new;

  my $server_endpoint = "http://127.0.0.1:31337/notify";
  my $application = "Irssi";

  my $req = HTTP::Request->new(POST => $server_endpoint);
  $req->header('content-type' => 'application/json');
   
  # # add POST data to HTTP request body

  my $post_data = sprintf('{
                "application": "%s",
                "title" : "%s",
                "subtitle": "%s",
                "body": "%s"
                }', $application ,$title, $subtitle, $body);

  $req->content($post_data);
   
  my $resp = $ua->request($req);
  if ($resp->is_success) {
      return 1
  }
  else {
      return 0
  }
}

sub notifier_it {
  my ($server, $title, $data, $channel, $nick) = @_;

    my $notifier_on_nick = Irssi::settings_get_str('notifier_on_nick');

    my $current_nick = $server->{nick};

    # handle normal msgs, not private ones
    if($current_nick ne $channel) {
      if ($notifier_on_nick && $data =~ m/$current_nick/) {
        $data = sprintf("%s: %s", $title, $data);
        $title = $channel;
        notify($server->{address}, $title, $data);
      }
    }
}

sub notifier_public_message {
  my ($server, $data, $nick, $mask, $target) = @_;
    notifier_it($server, $nick, $data, $target, $nick);
            my ($server, $title, $data, $channel, $nick) = @_;

    my $notifier_on_nick = Irssi::settings_get_str('notifier_on_nick');
    my $current_nick = $server->{nick};

    if ($notifier_on_nick && $data =~ m/$current_nick/) {
        $data = sprintf("%s: %s", $nick, $data);
        $title = $channel;
        notify($server->{address}, $target, $data);
    }

  Irssi::signal_continue($server, $data, $nick, $mask, $target);
}

sub notifier_private_message {
  my ($server, $data, $nick, $mask, $target) = @_;
    notify($server->{address}, $nick, $data);
  Irssi::signal_continue($server, $data, $nick, $mask, $target);
}


Irssi::settings_add_str('misc', 'notifier_on_nick', 1);
Irssi::signal_add('message public', 'notifier_public_message');
Irssi::signal_add('message private', 'notifier_private_message');

