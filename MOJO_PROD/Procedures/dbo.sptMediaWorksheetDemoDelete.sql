USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetDemoDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptMediaWorksheetDemoDelete]
	@MediaWorksheetDemoKey int
AS

/*
|| When      Who Rel      What
|| 2/5/14    CRG 10.5.7.7 Created
*/

	DELETE	tMediaWorksheetDemo
	WHERE	MediaWorksheetDemoKey = @MediaWorksheetDemoKey
GO
