version 1.0

workflow check_vcf_samples {
    input {
        File vcf_file # can change this to Array[File] and scatter
        Array[String] sample_list
    }

    call vcf_samples {
        input: vcf_file = vcf_file
    }

    call compare_string_sets {
        input: string_file = vcf_samples.sample_file,
               string_array = sample_list
    }

    output {
        String check_status = compare_string_sets.check_status
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

task compare_string_sets {
    input {
        Array[String] string_array
        File string_file
    }

    command {
        echo ${sep='\n' string_array} > string_list.txt
        Rscript -e "a <- readLines('string_list.txt'); b <- readLines('${string_file}'); if (setequal(a,b)) message('PASS') else message('FAIL')" > status.txt
    }

    output {
        String check_status = read_string("status.txt")
    }

    runtime {
        docker: "rocker/r-ver:4.1.2"
    }
}
