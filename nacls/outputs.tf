output "nacl_ids" {
  description = "IDs das NACLs criadas"
  value       = { for nacl in aws_network_acl.this : nacl.tags.Name => nacl.id }
}
