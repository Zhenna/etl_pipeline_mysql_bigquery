resource "google_monitoring_alert_policy" "etl_fms_alert_policy" {
  display_name = "No successful job execution in one day"
  combiner     = "OR"

  conditions {
    display_name = "Cloud Run Job - Completed Executions"
    condition_absent {
      filter   = "resource.type = \"cloud_run_job\" AND metric.type = \"run.googleapis.com/job/completed_execution_count\" AND metric.labels.result = \"succeeded\""
      duration = "86400s"
      trigger {
        percent = 100
      }
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  enabled               = true
  notification_channels = ["projects/${var.gcp-project-id}/notificationChannels/<notification-channel-id>"]
}
