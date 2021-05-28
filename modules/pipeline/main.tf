
module "codepipeline_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["codepipeline"]

  context = module.this.context
}

resource "aws_s3_bucket" "default" {
  bucket        = module.codepipeline_label.id
  acl           = "private"
  force_destroy = false
  tags          = module.codepipeline_label.tags
}

module "codepipeline_assume_role_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["codepipeline", "assume"]

  context = module.this.context
}

resource "aws_iam_role" "default" {
  name               = module.codepipeline_assume_role_label.id
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.default.*.arn)
}

resource "aws_iam_policy" "default" {
  name   = module.codepipeline_label.id
  # policy = data.aws_iam_policy_document.default.json
  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetRepository",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
            ],
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole"
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

module "codepipeline_s3_policy_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["codepipeline", "s3"]

  context = module.this.context
}

resource "aws_iam_policy" "s3" {
  name   = module.codepipeline_s3_policy_label.id
  policy = join("", data.aws_iam_policy_document.s3.*.json)
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]

    resources = [
      join("", aws_s3_bucket.default.*.arn),
      "${join("", aws_s3_bucket.default.*.arn)}/*"
    ]

    effect = "Allow"
  }
}

module "code_deploy_blue_green" {
  source  = "cloudposse/code-deploy/aws"
  version = "0.1.0"

  context = module.this.context

  minimum_healthy_hosts = null

  traffic_routing_config = {
    type       = "TimeBasedLinear"
    interval   = 10
    percentage = 10
  }

  deployment_style = {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config = {
    deployment_ready_option = {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 10
    }
    terminate_blue_instances_on_deployment_success = {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service = [
    {
      cluster_name = var.ecs_cluster_name
      service_name = var.ecs_alb_service_task_name
    }
  ]

  load_balancer_info = {
    target_group_pair_info = {
      prod_traffic_route = {
        listener_arns = [var.alb_http_listener_arn]
      }
      blue_target_group = {
        name = var.target_groups.blue_name
      }
      green_target_group = {
        name = var.target_groups.green_name
      }
    }
  }
}

resource "aws_codepipeline" "default" {
  name     = module.codepipeline_label.id
  role_arn = join("", aws_iam_role.default.*.arn)

  artifact_store {
    location = join("", aws_s3_bucket.default.*.bucket)
    type     = "S3"
  }

  depends_on = [
    aws_iam_role_policy_attachment.default,
    aws_iam_role_policy_attachment.s3,
  ]

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["src"]

      configuration = {
        OAuthToken = var.github_oauth_token
        Owner = var.repo_owner
        Repo = var.repo_name
        Branch = var.branch
      }
    }

    action {
      name             = "Image"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["image"]

      configuration = {
        RepositoryName = var.ecr_repository_name
        ImageTag       = "latest"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["src", "image"]
      version         = "1"

      configuration = {
        ApplicationName = module.code_deploy_blue_green.name
        DeploymentGroupName = module.code_deploy_blue_green.deployment_config_name
        TaskDefinitionTemplateArtifact = "src"
        AppSpecTemplateArtifact        = "src"
        Image1ArtifactName = "image"
        Image1ContainerName = "IMAGE1_NAME"
      }
    }
  }

  lifecycle {
    # prevent github OAuthToken from causing updates, since it's removed from state file
    ignore_changes = [stage[0].action[0].configuration]
  }
}

# taken from https://github.com/hashicorp/terraform-provider-aws/issues/7012,
# needs cleanup
resource "aws_cloudwatch_event_rule" "image_push" {
  name     = "ecr_image_push"
  role_arn = aws_iam_role.cloudwatchevent_role.arn

  event_pattern = <<EOF
{
  "source": [
    "aws.ecr"
  ],
  "detail": {
    "action-type": [
      "PUSH"
    ],
    "image-tag": [
      "latest"
    ],
    "repository-name": [
      "${var.ecr_repository_name}"
    ],
    "result": [
      "SUCCESS"
    ]
  },
  "detail-type": [
    "ECR Image Action"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule      = aws_cloudwatch_event_rule.image_push.name
  target_id = "${var.ecr_repository_name}-Image-Push-Codepipeline"
  arn       = aws_codepipeline.default.arn
  role_arn  = aws_iam_role.cloudwatchevent_role.arn
}


module "cloudwatchevent_role_label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["cloudwatchevent", "ecr"]

  context = module.this.context
}

resource "aws_iam_role" "cloudwatchevent_role" {
  name = module.cloudwatchevent_role_label.id
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": ["events.amazonaws.com"]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cloudwatchevent_policy" {
  name = module.cloudwatchevent_role_label.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "codepipeline:StartPipelineExecution"
        ],
        "Resource": [
            "${aws_codepipeline.default.arn}"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "cws_policy_attachment" {
  name = module.cloudwatchevent_role_label.id
  roles      = [aws_iam_role.cloudwatchevent_role.name]
  policy_arn = aws_iam_policy.cloudwatchevent_policy.arn
}

