USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupDelete]
	@DistributionGroupKey int
AS -- Encrypt

	DECLARE @CompanyKey INT
	
	SELECT @CompanyKey = CompanyKey
	FROM tDistributionGroup (NOLOCK)
	WHERE DistributionGroupKey = @DistributionGroupKey
	 
	IF EXISTS (SELECT 1
				FROM  tCalendarAttendee ca (NOLOCK)
					INNER JOIN tCalendar c (NOLOCK) ON ca.CalendarKey = c.CalendarKey
				WHERE c.CompanyKey = @CompanyKey
				AND   ca.Entity = 'Group'
				AND   ca.EntityKey = @DistributionGroupKey
				)
		RETURN -1

	DELETE
	FROM tDistributionGroupUser
	WHERE
		DistributionGroupKey = @DistributionGroupKey 
		
	DELETE
	FROM tDistributionGroup
	WHERE
		DistributionGroupKey = @DistributionGroupKey 


	RETURN 1
GO
