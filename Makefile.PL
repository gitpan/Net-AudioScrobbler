use 5.008007;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Net::AudioScrobbler',
    VERSION_FROM      => 'lib/Net/AudioScrobbler.pm', # finds $VERSION
    PREREQ_PM         => {LWP}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     
      (#ABSTRACT_FROM  => 'lib/Net/AudioScrobbler.pm', 
       AUTHOR         => 'Lee Aylward <lee@laylward.com>') : ()),
);
