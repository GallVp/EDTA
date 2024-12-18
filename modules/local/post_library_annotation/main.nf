process POST_LIBRARY_ANNOTATION {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/repeatmasker:4.1.5--pl5321hdfd78af_0':
        'biocontainers/repeatmasker:4.1.5--pl5321hdfd78af_0' }"

    input:
    tuple val(meta), path(genome, name: 'anno/genome')
    path('anno/genome.EDTA.TElib.fa')
    path('anno/genome.EDTA.intact.gff3')
    val maxdiv

    output:
    tuple val(meta), path('*.TEanno.gff3')  , emit: te_anno
    path "versions.yml"                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix          = task.ext.prefix   ?: "${meta.id}"
    """
    setup_Post-library_annotation.sh \\
        $task.cpus \\
        $maxdiv

    cd anno
    
    perl Post-library_annotation.pl

    cd -

    mv \\
        anno/genome.EDTA.TEanno.gff3 \\
        ${prefix}.TEanno.gff3

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl -v | sed -n 's|This is perl.*(\\(.*\\)).*|\\1|p')
        repeatmasker: \$(RepeatMasker -v | sed 's/RepeatMasker version //1')
    END_VERSIONS
    """

    stub:
    def prefix  = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.TEanno.gff3

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl -v | sed -n 's|This is perl.*(\\(.*\\)).*|\\1|p')
        repeatmasker: \$(RepeatMasker -v | sed 's/RepeatMasker version //1')
    END_VERSIONS
    """
}