#!/usr/bin/env bash

script_path=$(dirname $0)

cat > pan_te/make_pan_te_lib.sh << EOF
#!/usr/bin/env bash

genomes="$1"
threads=$2
fl_copy=$3
outfile=$4
EOF

sed -n 213,256p "$script_path/panEDTA.sh" \
    >> pan_te/make_pan_te_lib.sh

sed -i "s|\$path/bin|$script_path|g" \
    pan_te/make_pan_te_lib.sh

chmod a+x pan_te/make_pan_te_lib.sh
