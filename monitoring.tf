# リソース監視用のアラートポリシーをlocal変数に定義
locals {
  notification-channel-warn = "10852550799377080773"
  notification-channel-crit = "9971492931548053371"
  monitoring = {
    gce-cpu-usage-warning = {
      display_name          = "${local.project} / GCE / CPU-Usage / Warning"
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-warn}"]
      threshold_value       = "50"
      filter                = "metric.type=\"agent.googleapis.com/cpu/utilization\" AND resource.type=\"gce_instance\" AND metric.label.cpu_state!=\"idle\""
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }

    gce-cpu-usage-critical = {
      display_name          = "${local.project} / GCE / CPU-Usage / Critical"
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-crit}"]
      threshold_value       = "90"
      filter                = "metric.type=\"agent.googleapis.com/cpu/utilization\" AND resource.type=\"gce_instance\" AND metric.label.cpu_state!=\"idle\""
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }

    gce-memory-usage-warning = {
      display_name          = "${local.project} / GCE / Memory-Usage / Warning"
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-warn}"]
      threshold_value       = "50"
      filter                = "metric.type=\"agent.googleapis.com/memory/percent_used\" AND resource.type=\"gce_instance\" AND metric.label.state!=\"free\""
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }

    gce-memory-usage-critical = {
      display_name          = "${local.project} / GCE / Memory-Usage / Critical"
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-crit}"]
      threshold_value       = "90"
      filter                = "metric.type=\"agent.googleapis.com/memory/percent_used\" AND resource.type=\"gce_instance\" AND metric.label.state!=\"free\""
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }

    gce-disk-usage-warning = {
      display_name          = "${local.project} / GCE / Disk-Usage / Warning"
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-warn}"]
      threshold_value       = "80"
      filter                = "metric.type=\"agent.googleapis.com/disk/percent_used\" AND resource.type=\"gce_instance\" AND (metric.labels.device != starts_with(\"loop\") AND metric.labels.state = \"used\")"
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }

    gce-disk-usage-critical = {
      display_name          = "${local.project} / GCE / Disk-Usage / Critical"
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-crit}"]
      threshold_value       = "90"
      filter                = "metric.type=\"agent.googleapis.com/disk/percent_used\" AND resource.type=\"gce_instance\" AND (metric.labels.device != starts_with(\"loop\") AND metric.labels.state = \"used\")"
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }

    gce-load-average-warning = {
      display_name          = "${local.project} / GCE / Load-Average / Warning",
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-warn}"]
      threshold_value       = "1"
      filter                = "metric.type=\"agent.googleapis.com/cpu/load_5m\" AND resource.type=\"gce_instance\""
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }

    gce-load-average-critical = {
      display_name          = "${local.project} / GCE / Load-Average / Critical",
      notification_channels = ["projects/${local.project}/notificationChannels/${local.notification-channel-crit}"]
      threshold_value       = "2"
      filter                = "metric.type=\"agent.googleapis.com/cpu/load_5m\" AND resource.type=\"gce_instance\""
      comparison            = "COMPARISON_GT"
      per_series_aligner    = "ALIGN_MEAN"
      cross_series_reducer  = "REDUCE_MEAN"
      group_by_fields       = ["resource.*"]
    }
  }
}

# リソース監視のアラートポリシーをまとめて作成
resource "google_monitoring_alert_policy" "alert_policy" {
  for_each = local.monitoring

  display_name          = each.value.display_name
  combiner              = "OR"
  enabled               = "true"
  notification_channels = each.value.notification_channels
  conditions {
    display_name = each.value.display_name
    condition_threshold {
      threshold_value = each.value.threshold_value
      filter          = each.value.filter
      duration        = "60s"
      comparison      = each.value.comparison
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = each.value.per_series_aligner
        cross_series_reducer = each.value.cross_series_reducer
        group_by_fields      = each.value.group_by_fields
      }
      trigger {
        count = "1"
      }
    }
  }
}
