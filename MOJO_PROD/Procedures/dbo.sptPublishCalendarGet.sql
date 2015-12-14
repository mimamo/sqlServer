USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPublishCalendarGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPublishCalendarGet]
	@PublishCalendarKey int
AS

/*
|| When      Who Rel      What
|| 6/7/12    CRG 10.5.5.6 Created
*/

	SELECT	*
	FROM	tPublishCalendar (nolock)
	WHERE	PublishCalendarKey = @PublishCalendarKey
GO
