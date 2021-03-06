USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutReportGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutReportGet]
	@LayoutKey int,
	@Entity varchar(50)
AS

/*
|| When      Who Rel      What
|| 3/18/10   CRG 10.5.2.0 Created
*/

	SELECT	*
	FROM	tLayoutReport (nolock)
	WHERE	LayoutKey = @LayoutKey
	AND		Entity = @Entity
GO
