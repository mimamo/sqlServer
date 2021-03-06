USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadClientContacts]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadClientContacts]
	(
	@ProjectKey int
	)
AS
/*
|| When     Who Rel    What
|| 02/13/13 WDF 10.565 (168051) Added Billing Contact
*/

	Declare @Parent int, @CompanyKey int, @BillingContact int
	Select @BillingContact = p.BillingContact, @Parent = ISNULL(ParentCompanyKey, c.CompanyKey), @CompanyKey = p.ClientKey 
	  from tCompany c (NOLOCK) 
	       inner join tProject p (nolock) on p.ClientKey = c.CompanyKey
	 Where p.ProjectKey = @ProjectKey

	Select
		u.*,
		u.FirstName + ' ' + u.LastName as UserName,
		c.CompanyName
	from 
		tUser u (nolock)
		inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
	Where
		(u.CompanyKey = @CompanyKey or u.UserKey = @BillingContact or c.ParentCompanyKey = @Parent or c.CompanyKey = @Parent) 
	Order By u.FirstName, u.LastName
GO
