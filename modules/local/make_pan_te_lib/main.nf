process MAKE_PAN_TE_LIB {
    tag "$meta.id"
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/91/91c1946f5edb90aa9d2c26eb14e7348f8f4e94dda03bdb2185b72cb3c2d54932/data':
        'community.wave.seqera.io/library/blast_repeatmasker:816962ca420d1d16' }"

    input:
    tuple val(meta), val(genomes)
    path "pan_te/genome*.mod.EDTA.anno/genome*.mod.EDTA.RM.out"
    path "pan_te/genome*.mod.EDTA.TElib.fa"
    val fl_copy

    output:
    tuple val(meta), path("*.TElib.fa") , emit: pan_te_lib, optional: true
    tuple val(meta), path("*.log")      , emit: log
    path "versions.yml"                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix   ?: "${meta.id}"
    """
    setup_make_pan_te_lib.sh \\
        "$genomes" \\
        $task.cpus \\
        $fl_copy \\
        $prefix

    cd pan_te
    
    ./make_pan_te_lib.sh \\
        &> >(tee ../"${prefix}.log" 2>&1)

    cd -

    if [ -s pan_te/${prefix}.panEDTA.TElib.fa ]; then
        mv \\
            pan_te/${prefix}.panEDTA.TElib.fa \\
            ${prefix}.TElib.fa
    fi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl -v | sed -n 's|This is perl.*(\\(.*\\)).*|\\1|p')
        repeatmasker: \$(RepeatMasker -v | sed 's/RepeatMasker version //1')
    END_VERSIONS
    """

    stub:
    def prefix  = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.TElib.fa

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl -v | sed -n 's|This is perl.*(\\(.*\\)).*|\\1|p')
        repeatmasker: \$(RepeatMasker -v | sed 's/RepeatMasker version //1')
    END_VERSIONS
    """
}
