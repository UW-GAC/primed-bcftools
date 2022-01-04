version 1.0

workflow test_data_tables {
    input {
        Array[String] sample_list
        String subject_column
    }

    call results {
        input: sample_list = sample_list,
               subject_column = subject_column    
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
        Array[String] sample_list
        String subject_column
    }

    command {
        Rscript -e "message(AnVIL::avworkspace())" > output.txt
    }

    output {
        File output_file = "output.txt"
    }

    runtime {
        docker: "us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.14.0"
    }
}
