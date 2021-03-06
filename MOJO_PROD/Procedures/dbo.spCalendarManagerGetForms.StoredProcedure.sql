USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetForms]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetForms]
	@UserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime
AS

/*
|| When      Who Rel      What
|| 2/27/09   CRG 10.5.0.0 Created for the CalendarManager to display tracking forms,
||                        For now the joing to tProject is commented out, but I figure we'll need it in the toolTip
||                        eventually.  But I didn't want to join out to tProject unecessarily until we really need to.
*/

	SELECT	f.FormKey,
			fd.FormName,
			fd.FormPrefix,
			ISNULL(fd.FormPrefix+'-', '') + ISNULL(CONVERT(VARCHAR(100),f.FormNumber), '') as FormNumber,
--			p.ProjectNumber,
			f.Subject,
			f.DueDate
	FROM	tForm f (NOLOCK)
	INNER JOIN tFormDef fd (NOLOCK) ON f.FormDefKey = fd.FormDefKey
--	LEFT JOIN tProject p (NOLOCK) ON f.ProjectKey = p.ProjectKey
	WHERE   f.AssignedTo = @UserKey
	AND		f.DueDate >= @StartDate
	AND     f.DueDate <= @EndDate    
	AND     f.DateClosed IS NULL
GO
