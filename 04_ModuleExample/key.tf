resource "aws_key_pair" "main" {
  key_name   = "${var.key_pair["name"]}"
  public_key = "${file(var.key_pair["public_path"])}"
}
