USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetSelUsers]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetSelUsers]
AS --Encrypt
 select u.*, u.UserID as LoginID, c.CompanyName
  from tUser       u (NOLOCK)
      ,#tPeopleSelected w
      ,tCompany c (NOLOCK)
 where u.UserKey = w.UserKey
 and   u.CompanyKey = c.CompanyKey
 order by u.LastName ASC, u.FirstName ASC
 return 1
GO
