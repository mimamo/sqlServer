USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormUpdateContactLink]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptFormUpdateContactLink]

	(
		@FormKey int,
		@ContactCompanyKey int
	)

AS --Encrypt

Update tForm
Set ContactCompanyKey = @ContactCompanyKey
Where FormKey = @FormKey
GO
