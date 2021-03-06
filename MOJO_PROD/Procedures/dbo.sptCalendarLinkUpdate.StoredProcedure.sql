USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarLinkUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarLinkUpdate]
	@CalendarKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Action varchar(10)
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/23/08   CRG 10.5.0.0 Created for the Calendar Manager
*/

IF @Action = 'insert'
	IF NOT EXISTS
			(SELECT NULL
			FROM	tCalendarLink (nolock) 
			WHERE	CalendarKey = @CalendarKey 
			AND		Entity = @Entity 
			AND		EntityKey = @EntityKey)
		INSERT	tCalendarLink
				(CalendarKey,
				Entity,
				EntityKey)
		VALUES	(@CalendarKey,
				@Entity,
				@EntityKey)

IF @Action = 'delete'
	DELETE	tCalendarLink
	WHERE	CalendarKey = @CalendarKey 
	AND		Entity = @Entity 
	AND		EntityKey = @EntityKey
GO
