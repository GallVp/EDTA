#!/usr/bin/env bash

script_path=$(dirname $0)

cat > anno/Post-library_annotation.pl << EOF
my \$genome             = 'genome';
my \$threads            = $1;
my \$rm_threads         = $1;
my \$maxdiv             = $2;
my \$exclude            = '';

my \$make_masked        = "$script_path/make_masked.pl";
my \$combine_RMrows     = "$script_path/combine_RMrows.pl";
my \$RMout2bed          = "$script_path/RMout2bed.pl";
my \$bed2gff            = "$script_path/bed2gff.pl";
my \$gff2bed            = "$script_path/gff2bed.pl";
my \$combine_overlap    = "$script_path/combine_overlap.pl";
my \$get_frag           = "$script_path/get_frag.pl";
my \$keep_nest          = "$script_path/keep_nest.pl";
my \$format_gff3        = "$script_path/format_gff3.pl";
my \$gff2RMout          = "$script_path/gff2RMout.pl";

my \$repeatmasker       = ''; # Assumed on PATH

EOF

sed -n 11,11p "$script_path/EDTA.pl" \
    >> anno/Post-library_annotation.pl

sed -n 714,729p "$script_path/EDTA.pl" \
    >> anno/Post-library_annotation.pl

sed -n 741,741p "$script_path/EDTA.pl" \
    >> anno/Post-library_annotation.pl

sed -n 745,765p "$script_path/EDTA.pl" \
    >> anno/Post-library_annotation.pl
