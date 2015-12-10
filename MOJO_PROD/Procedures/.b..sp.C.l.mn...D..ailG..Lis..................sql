USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptColumnSetDetailGetList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptColumnSetDetailGetList]
	@ColumnSetKey int
AS

/*
|| When      Who Rel      What
|| 9/12/12   CRG 10.5.6.0 Created
*/

	SELECT	*
	FROM	tColumnSetDetail (nolock)
	WHERE	ColumnSetKey = @ColumnSetKey
	ORDER BY DisplayOrder
GO
