resource "google_project_iam_binding" "access_user" {
  role = google_project_iam_custom_role.iap_access_role.id
  project = local.project
  members = [
    "user:${local.my-email}",
  ]
}

resource "google_project_iam_custom_role" "iap_access_role" {
  role_id = "IapAccessRole"
  title   = "IAP Access Role"

  permissions = [
    # VMインスタンスにSSH接続するのに必要な権限
    "compute.projects.get",
    "compute.instances.get",
    "compute.instances.setMetadata",
    "iam.serviceAccounts.actAs",
    # IAPに必要な権限
    "iap.tunnelInstances.accessViaIAP",
  ]
}
