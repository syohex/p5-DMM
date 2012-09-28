use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::Repository;

name 'DMM';
all_from 'lib/DMM.pm';

author_tests('xt');
auto_set_repository();
WriteAll;
