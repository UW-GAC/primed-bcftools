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
        echo ${sep=' ' sample_list} > file.txt
    }

    output {
        File output_file = "file.txt"
    }

    runtime {
        docker: "biocontainers/bcftools:v1.9-1-deb_cv1"
    }
}
