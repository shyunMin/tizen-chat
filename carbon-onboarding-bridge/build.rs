fn main() {
    tonic_build::configure()
        .build_server(true)
        .build_client(false)
        .compile_protos(&["proto/carbon/v1/config.proto"], &["proto"])
        .expect("failed to compile proto files");
}
