USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetGroupSecurityAddFile]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetGroupSecurityAddFile]
  @FileKey uniqueidentifier
 ,@CompanyKey int
AS --Encrypt
declare @kEntityGroup varchar(50)
 select @kEntityGroup = 'Group'
  
 select SecurityGroupKey as GroupKey
       ,GroupName
   from tSecurityGroup (nolock)
  where SecurityGroupKey not in (select EntityKey
                                      from tFileRight (nolock)
                                     where FileKey = @FileKey
                                       and EntityType = @kEntityGroup)
    and CompanyKey = @CompanyKey
    and Active =1
  order by GroupName
  
 return 1
GO
