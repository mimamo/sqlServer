USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUnLink]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadUnLink]
	(
	@LeadKey int
	)
AS


Update tLead 
Set ConvertEntity = null, ConvertEntityKey = null
Where LeadKey = @LeadKey
GO
