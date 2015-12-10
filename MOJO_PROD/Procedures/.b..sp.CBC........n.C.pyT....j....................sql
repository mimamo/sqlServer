USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodePercentCopyToProject]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodePercentCopyToProject]
	(
		@ProjectKey int,
		@ProjectRequestKey int
	)

AS --Encrypt


Insert Into tCBCodePercent (CBCodeKey, Entity, EntityKey, Percentage)
Select CBCodeKey, 'tProject', @ProjectKey, Percentage
From tCBCodePercent (nolock)
Where Entity = 'tRequest' and EntityKey = @ProjectRequestKey
GO
