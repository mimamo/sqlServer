USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactGetForms]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptContactGetForms]

	(
		@CompanyKey int
	)

AS --Encrypt

Select
	f.FormKey,
	f.Subject,
	f.DateClosed,
	f.DueDate,
	f.FormDefKey,
	fd.FormPrefix + '-' + rtrim(CAST(f.FormNumber as varchar(15))) as FormNumber,
	f.Priority,
	fd.FormName
From
	tForm f (nolock),
	tFormDef fd (nolock)
Where
	f.FormDefKey = fd.FormDefKey and
	f.ContactCompanyKey = @CompanyKey
Order By
	f.DateClosed
GO
