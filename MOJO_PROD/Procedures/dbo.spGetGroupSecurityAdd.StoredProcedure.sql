USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetGroupSecurityAdd]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetGroupSecurityAdd]
  @FolderKey uniqueidentifier
 ,@CompanyKey int
AS --Encrypt
declare @kEntityGroup varchar(50)
 select @kEntityGroup = 'Group'
  
 select SecurityGroupKey as GroupKey
       ,GroupName
   from tSecurityGroup (nolock)
  where (SecurityGroupKey not in (select EntityKey
                                      from tFolderRight (nolock)
                                     where FolderKey = @FolderKey
                                       and EntityType = @kEntityGroup))
    and CompanyKey = @CompanyKey
    and Active = 1
  order by GroupName
  
 return 1
GO
