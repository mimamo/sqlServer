USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetByUID]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetByUID]
	@UID as varchar(2000)
AS

/*
|| When      Who Rel      What
|| 6/17/09   CRG 10.5.0.0 Created to get activities by their UID for CalDAV.
*/

	SELECT	ActivityKey
	FROM	tActivity (nolock)
	WHERE	UID = @UID
GO
