USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectGetAssignedUsers]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProjectGetAssignedUsers]
  @ProjectKey int
 ,@FolderKey uniqueidentifier
 ,@CompanyKey int
AS --Encrypt
declare @kEntityUser varchar(50)
 select @kEntityUser = 'User'
 select us.UserKey
       ,us.LastName + ', ' + us.FirstName as UserName
   from tUser us (nolock)
       ,tAssignment ag (nolock)
  where ag.ProjectKey = @ProjectKey
    and ag.UserKey = us.UserKey
    and us.UserKey not in (select EntityKey
                           from tFolderRight (nolock)
                          where FolderKey = @FolderKey
                            and EntityType = @kEntityUser)
    and (us.CompanyKey = @CompanyKey or us.OwnerCompanyKey = @CompanyKey)
    and us.Active =1
  order by UserName
    
 return  1
GO
