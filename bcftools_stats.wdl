version 1.0

workflow bcftools_stats {
    input {
        File vcf_file
        Array[String] sample_list
    }

    call results {
        input: vcf_file = vcf_file,
               sample_list = sample_list
    }

    output {
        File output_file = results.output_file
    }

     meta {
          author: "Stephanie Gogarten"
          email: "sdmorris@uw.edu"
     }
}

task results {
    input {
        File vcf_file
        Array[String] sample_list
    }

    command {
        bcftools stats --samples ${sep=',' sample_list} ${vcf_file} > stats.txt
    }

    output {
        File output_file = "stats.txt"
    }

    runtime {
        docker: "biocontainers/bcftools:v1.9-1-deb_cv1"
    }
}
