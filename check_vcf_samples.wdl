version 1.0

workflow check_vcf_samples {
    input {
        File vcf_file
    }

    call vcf_samples {
        input: vcf_file = vcf_file
    }

    call compare_sample_sets {
        input: sample_file = vcf_samples.sample_file
    }

    output {
        String check_status = compare_sample_sets.check_status
    }

     meta {
          author: "Stephanie Gogarten"
          email: "sdmorris@uw.edu"
     }
}

task vcf_samples {
    input {
        File vcf_file
    }

    command {
        bcftools query --list-samples ${vcf_file} > samples.txt
    }

    output {
        File sample_file = "samples.txt"
    }

    runtime {
        docker: "xbrianh/xsamtools:v0.5.2"
    }
}

task compare_sample_sets {
    input {
        File sample_file
    }

    command {
        cp ${sample_file} samples.txt
        Rscript -e "a <- readLines('samples.txt'); b <- AnVIL::avtable('sample')$sample_id; if (setequal(a,b)) message('PASS') else message('FAIL')" > status.txt
    }

    output {
        String check_status = read_string("status.txt")
    }

    runtime {
        docker: "us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.14.0"
    }
}
