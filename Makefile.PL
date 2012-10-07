use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::Repository;

name 'DMM';
all_from 'lib/DMM.pm';

requires 'XML::RSS::LibXML';
requires 'LWP::UserAgent';
requires 'Furl';
requires 'Web::Scraper';
requires 'URI';
requires 'DateTime';
requires 'Class::Accessor::Lite' => '0.05';

test_requires 'Test::More' => '0.98';

tests 't/*.t t/*/*.t';

author_tests('xt');
auto_set_repository();
WriteAll;
