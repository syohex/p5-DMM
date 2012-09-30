use strict;
use warnings;
use Test::More;

use DMM::Util qw/separate_name/;

use utf8;

subtest 'Only one name' => sub {
    my $str = '成瀬心美';
    my ($name) = separate_name($str);
    is $name, $str, 'Only one name';
};

subtest 'separate name(has alias)' => sub {
    my $str = "澤村レイコ（高坂保奈美、高坂ますみ）";
    my ($name, $aliases_ref) = separate_name($str);

    is $name, '澤村レイコ', 'Current name';
    is_deeply $aliases_ref, ['高坂保奈美', '高坂ますみ'], 'Old name(aliases)';
};

subtest 'separate name with hanaku separator' => sub {
    my $str = "澤村レイコ(高坂保奈美,高坂ますみ)";
    my ($name, $aliases_ref) = separate_name($str);

    is $name, '澤村レイコ', 'Current name with Hankaku';
    is_deeply $aliases_ref, ['高坂保奈美', '高坂ますみ'], 'Old name(aliases) with Hankaku';
};

done_testing;
