# use data source to get all avalablility zones in the region which are in 'available' state

data "aws_availability_zones" "available" {
  state = "available"
}
