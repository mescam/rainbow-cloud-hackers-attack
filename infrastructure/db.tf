resource "aws_dynamodb_table" "rainbows" {
    name = "rainbows"
    read_capacity = 5
    write_capacity = 100
    hash_key = "Key"
    attribute {
      name = "Key"
      type = "S"
    }
    tags {
      Name = "rcah-dynamodb-rainbows"
      Service = "RainbowCloudHackersAttack"
    }
}

resource "aws_dynamodb_table" "tasks" {
    name = "tasks"
    read_capacity = 1
    write_capacity = 1
    hash_key = "ID"
    attribute {
      name = "ID"
      type = "S"
    }
    tags {
      Name = "rcah-dynamodb-tasks"
      Service = "RainbowCloudHackersAttack"
    }
}