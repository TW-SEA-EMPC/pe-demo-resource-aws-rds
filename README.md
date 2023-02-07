# Self-service an AWS RDS resource 

This project is a simple example of a self-servicable, composable AWS RDS resource.

You do not need to know or worry about low-level details of the AWS RDS resource, or the platform. 
Eg. 
- Subnets, 
- Secruity groups, 
- Networking, Encryption, 
- Security compliance,
- Availability, etc.  

You only need to define
- the database version, 
- and the database capacity. 

The project follows the API conventions for resources in the PE Demo project. 

## To provision
### Via Backstage
If your component(application) is registered in backstage you may use the resource template from 'create' option here:
https://backstage.iqa.seaempc.com/create 

### Without Backstage 
The simple convention and API design means you can self service this component without Backstage simply. 
1. Add a `resource.yaml` definition under the resource directory in your porject 
```text
resource: TW-SEA-EMPC/pe-demo-resource-aws-rds
version: v0.2.0
```

2. Add a configuration file
```text
engine_major_version = "11"
instance_size        = "db.t4g.medium"
```
...

## To connect
A K8s secret with the following keys will be created in the namespace of your component:
```text
POSTGRES_HOST
POSTGRES_PORT
POSTGRES_USER
POSTGRES_PASSWORD
```

## Maintenance and updating
The resource follows a split responsibility model, between the platform and the application team. 
The platform team is responsible for updating, patching the resource and releases following *SemVer* conventions.
The product/application team is responsible for updating the version and deploying the resource. 
This is the same model that organisations practice with could providers managed services eg. AWS EKS with managed nodes

# API
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | The instance size of the RDS instance | `string` | n/a | yes |
| <a name="input_engine_major_version"></a> [engine\_major\_version](#input\_engine\_major\_version) | The major version of the RDS PG Engine | `string` | n/a | yes |

## Outputs

No outputs.
