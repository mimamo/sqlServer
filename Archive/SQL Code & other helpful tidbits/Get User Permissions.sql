-- get user permissions
SELECT  [Schema]            =   sys.schemas.name 
,       [Object]            =   sys.objects.name 
,       username            =   sys.database_principals.name 
,       permissions_type    =   sys.database_permissions.type 
,       permission_name     =   sys.database_permissions.permission_name
,       permission_state    =   sys.database_permissions.state 
,       state_desc          =   sys.database_permissions.state_desc
,       permissionsql       =   state_desc + ' ' + permission_name 
                                 + ' on ['+ sys.schemas.name + '].[' + sys.objects.name 
                                 + '] to [' + sys.database_principals.name + ']' 
                                  COLLATE LATIN1_General_CI_AS 
FROM sys.database_permissions 
 INNER JOIN sys.objects ON sys.database_permissions.major_id =      sys.objects.object_id 
 INNER JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id 
 INNER JOIN sys.database_principals ON sys.database_permissions.grantee_principal_id =  sys.database_principals.principal_id 
 where sys.database_principals.name = 'timecard'
ORDER BY 1, 2, 3, 5