USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetProjectList]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetProjectList]
  @ProjectKey int
AS --Encrypt
 select us.UserKey
       , case when us.OwnerCompanyKey is null then 
			us.LastName + ', ' + us.FirstName
		 else 
			c.CompanyName + ' / ' +us.LastName + ', ' + us.FirstName end as UserName
       ,us.LastName
       ,us.FirstName
       ,us.Email
       ,case when us.OwnerCompanyKey is null then 0 else 1 end as CompanySort
   from tUser       us (nolock)
       ,tAssignment ag (nolock)
       ,tCompany    c  (nolock)
  where ag.ProjectKey = @ProjectKey
    and ag.UserKey = us.UserKey
    and us.Active = 1
    and us.CompanyKey = c.CompanyKey
    
    order by CompanySort, UserName
    
 return  1
GO
