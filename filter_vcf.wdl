version 1.0

workflow filter_vcf {
    input {
        File vcf_file
        String filter_column = "INFO/DR2"
        String filter_threshold = "0.3"
        String suffix = "filtered"
    }

    call filter {
        input: vcf_file = vcf_file,
        filter_column = filter_column,
        filter_threshold = filter_threshold,
        suffix = suffix
    }

    output {
        File output_file = filter.output_file
    }

     meta {
          author: "Stephanie Gogarten"
          email: "sdmorris@uw.edu"
     }
}

task filter {
    input {
        File vcf_file
        String filter_column
        String filter_threshold
        String suffix
    }

    String out_file = basename(vcf_file, ".vcf.gz") + "_" + suffix + ".vcf.gz"

    command <<<
        bcftools view -i '~{filter_column}>~{filter_threshold}' -O z -o ~{out_file} ~{vcf_file}
    >>>

    output {
        File output_file = "~{out_file}"
    }

    runtime {
        docker: "biocontainers/bcftools:v1.9-1-deb_cv1"
    }
}
