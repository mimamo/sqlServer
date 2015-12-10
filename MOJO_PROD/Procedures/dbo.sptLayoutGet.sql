USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutGet]
	@LayoutKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/15/10  MFT 10.5.2.0 Created
*/

SELECT
	*
FROM
	tLayout (nolock)
WHERE
	LayoutKey = @LayoutKey
GO
