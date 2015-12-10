USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10569]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10569]
	
AS
	SET NOCOUNT ON

-- enable new handling of custom fields in listing at Mudd 	
update tPreference
set    tPreference.Customizations = tPreference.Customizations + '|newcf'
from   tCompany c (nolock)
where  tPreference.CompanyKey = c.CompanyKey
and    c.CompanyKey = 1					-- installed companies only, no hosted companies
and    c.CompanyName like '%Mudd%'		-- must be Mudd

-- remove from Credit Card users if inactive
delete tGLAccountUser
from   tUser (nolock)
where  tGLAccountUser.UserKey = tUser.UserKey
and    tUser.Active = 0


Insert tRightAssigned (EntityType, EntityKey, RightKey)
Select EntityType, EntityKey, 30101 from tRightAssigned Where RightKey = 30100

	RETURN
GO
