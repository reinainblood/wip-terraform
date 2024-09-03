output "cluster_endpoint" {
  value = aws_docdb_cluster.docdb.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_docdb_cluster.docdb.reader_endpoint
}