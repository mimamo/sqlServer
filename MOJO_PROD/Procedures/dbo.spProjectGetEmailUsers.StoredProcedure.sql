USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectGetEmailUsers]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProjectGetEmailUsers]
  @ProjectKey int
AS --Encrypt
 select us.UserKey
       ,c.CompanyName + ' / ' +us.LastName + ', ' + us.FirstName as UserName
       ,us.LastName
       ,us.FirstName
       ,us.Email
   from tUser       us (nolock)
       ,tAssignment ag (nolock)
       ,tCompany    c  (nolock)
  where ag.ProjectKey = @ProjectKey
    and ag.UserKey = us.UserKey
    and us.Active = 1
    and us.Email IS NOT NULL
    and us.CompanyKey = c.CompanyKey
    
    order by UserName
    
 return  1
GO
