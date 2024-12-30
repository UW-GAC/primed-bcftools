version 1.0

workflow extract_vcf_ids {
    input {
        Array[File] vcf_file
        Boolean pass_only = false
    }

    scatter (f in vcf_file) {
        call bcftools_query {
            input:
                vcf_file = f,
                pass_only = pass_only
        }
    }

    call concat_files {
        input: files = bcftools_query.variant_file
    }

    output {
        File variant_file = concat_files.output_file
    }

     meta {
          author: "Stephanie Gogarten"
          email: "sdmorris@uw.edu"
     }
}


task bcftools_query {
    input {
        File vcf_file
        Boolean pass_only
    }

    Int disk_gb = ceil(size(vcf_file, "GB")*2) + 10

    command <<<
        set -e -o pipefail

        bcftools query \
            ~{if pass_only then "-i 'FILTER=\"PASS\"'" else ""} \
            -f '%CHROM:%POS:%REF:%ALT\n' \
            ~{vcf_file} \
            > variants.txt
    >>>

    output {
        File variant_file = "variants.txt"
    }

    runtime {
        docker: "staphb/bcftools:1.16"
        disks: "local-disk ${disk_gb} SSD"
    }
}


task concat_files {
    input {
        Array[File] files
    }

    command <<<
        cat ~{sep=' ' files} > concat.txt
    >>>

    output {
        File output_file = "concat.txt"
    }

    runtime {
        docker: "staphb/bcftools:1.16"
    }
}
