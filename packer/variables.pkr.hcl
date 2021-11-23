variables {
    project_id = "ca-nagano-taichi-test" #project名変更
    source_image = "ubuntu-2004-focal-v20211118" 
    disk_size = "20"
    ssh_username = "packer"
    zone = "asia-northeast1-a"
    network = "projects/ca-nagano-taichi-test/global/networks/default" #project名変更
    subnetwork = "projects/ca-nagano-taichi-test/regions/asia-northeast1/subnetworks/default" #project名変更
    tags = "monitoring-server"
    image_name = "tnagano-custom-image-ubuntu2004" #変更
    playbook_file = "./playbook.yml"
    groups = ["tnagano-custom-image-ubuntu2004"] #変更
}