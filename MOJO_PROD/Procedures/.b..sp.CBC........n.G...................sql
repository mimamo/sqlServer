USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodePercentGet]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodePercentGet]
	@CBCodePercentKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/

		SELECT cbp.*, cbc.CBCode, cbc.ProjectNumber, cbc.TaskNumber
		FROM tCBCodePercent cbp (nolock)
		inner join tCBCode cbc (nolock) on cbp.CBCodeKey = cbc.CBCodeKey
		WHERE
		CBCodePercentKey = @CBCodePercentKey

	RETURN 1
GO
