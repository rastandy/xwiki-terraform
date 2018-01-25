## XWiki outputs

output "public_ip" {
  description = "The XWiki instance public ip"
  value       = "${aws_eip.xwiki_eip.public_ip}"
}

## End of XWiki outputs

