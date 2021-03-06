USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodeDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodeDelete]
	@CBCodeKey int

AS --Encrypt

	if exists(select 1 from tCBCodePercent (nolock) Where CBCodeKey = @CBCodeKey)
		return -1

	if exists(select 1 from tCBPosting (nolock) Where CBCodeKey = @CBCodeKey)
		return -2

	DELETE
	FROM tCBCode
	WHERE
		CBCodeKey = @CBCodeKey 

	RETURN 1
GO
