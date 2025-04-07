resource "oci_budget_budget" "main" {
  # Must be a tenancy ocid, compartment ocid does not work
  compartment_id = var.tenancy_ocid

  target_type  = "COMPARTMENT"
  targets      = [oci_identity_compartment.main.id]
  amount       = var.budget_amount
  reset_period = "MONTHLY"
}

resource "oci_budget_alert_rule" "main" {
  budget_id      = oci_budget_budget.main.id
  type           = "ACTUAL"
  threshold      = 100
  threshold_type = "PERCENTAGE"
  recipients     = var.budget_alarm_email_address
}
