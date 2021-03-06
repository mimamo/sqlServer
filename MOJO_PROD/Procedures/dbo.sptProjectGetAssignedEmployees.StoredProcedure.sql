USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetAssignedEmployees]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectGetAssignedEmployees]
	@ProjectKey int
AS --Encrypt
 select us.UserKey
       ,us.FirstName + ' ' + us.LastName as UserName
       ,left(isnull(us.FirstName, ''), 1) + left(isnull(us.MiddleName, ''), 1) + left(isnull(us.LastName, ''), 1) AS Initials
   from tUser       us (nolock)
       ,tAssignment ag (nolock)
       ,tCompany    c  (nolock)
  where ag.ProjectKey = @ProjectKey
    and ag.UserKey = us.UserKey
    and us.Active = 1
    and us.CompanyKey = c.CompanyKey
    
    order by UserName
    
 return  1
GO
