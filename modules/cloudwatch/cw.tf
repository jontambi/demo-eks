/***
resource "aws_cloudwatch_metric_alarm" "vpn_alarm" {
  alarm_name          = "${var.environment}-${var.name}-vpnstate_alarm"
  alarm_description   = "A CloudWatch Alarm that triggers when the state of both VPN tunnels in an AWS VPN connection are down."
  metric_name         = "TunnelState"
  namespace           = "AWS/VPN"
  statistic           = "Maximum"
  period              = "300"
  threshold           = "0"
  evaluation_periods  = "1"
  comparison_operator = "LessThanOrEqualToThreshold"
  dimensions = {
    VpnId = var.vpn_id
  }

}
***/
resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.environment}-${var.name}/cluster"
  retention_in_days = 7

  # ... potentially other configuration ...
}