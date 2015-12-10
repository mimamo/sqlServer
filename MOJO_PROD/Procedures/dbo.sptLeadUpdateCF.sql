USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUpdateCF]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptLeadUpdateCF]

	(
		@LeadKey int,
		@CustomFieldKey int
	)

AS --Encrypt

Update tLead
Set CustomFieldKey = @CustomFieldKey
Where LeadKey = @LeadKey
GO
