USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spAddDefaultPeople]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddDefaultPeople]
 @ProjectKey int
AS --Encrypt
 select u.*, c.CompanyName
  from tUser       u (NOLOCK)
      ,tAssignment a (NOLOCK)
   ,tCompany    c (NOLOCK)
 where u.UserKey = a.UserKey
   and a.ProjectKey = @ProjectKey
   and u.Active = 1
   and u.CompanyKey = c.CompanyKey
 order by u.LastName ASC, u.FirstName ASC
 return 1
GO
