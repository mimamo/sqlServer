USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormAssignToGetList]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormAssignToGetList] 
 @CompanyKey int
AS --Encrypt
 select distinct(co.CompanyName + ' / ' + us.LastName + ', ' + us.FirstName) as Name
       ,us.UserKey
   from tUser us (nolock)
       ,tForm fo (nolock)
       ,tCompany co (nolock)
  where fo.CompanyKey = @CompanyKey
    and fo.AssignedTo = us.UserKey
    and us.Active = 1
    and co.CompanyKey = us.CompanyKey
 
 return 1
GO
