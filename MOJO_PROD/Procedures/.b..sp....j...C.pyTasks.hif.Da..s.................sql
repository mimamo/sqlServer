USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectCopyTasksShiftDates]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectCopyTasksShiftDates]
	(
		@ProjectKey int,
		@CopyProjectKey int
	)

AS --Encrypt

  /*
  || When     Who Rel        What
  || 12/11/12 GWG 10.5.6.3   Fixed not rolling dates forward correctly
  || 2/3/13   GWG 10.5.6.4   Added a customization to enable this
  */

				
	DECLARE @SourceDate smalldatetime, @TargetDate smalldatetime, @DateDiff int, @TodayDiff int
	
	-- if you don't have the kohls customization, then don't shift dates
	if exists(Select 1 from tPreference p (nolock) inner join tProject pr (nolock) on pr.CompanyKey = p.CompanyKey Where pr.ProjectKey = @ProjectKey and lower(Customizations) like '%pushconstraintdates%')
	BEGIN
		SELECT @SourceDate = ISNULL(StartDate, CompleteDate) 
		FROM   tProject (NOLOCK)
		WHERE  ProjectKey = @CopyProjectKey 

		SELECT @TargetDate = ISNULL(StartDate, CompleteDate) 
		FROM   tProject (NOLOCK)
		WHERE  ProjectKey = @ProjectKey 

		Select @DateDiff = DATEDIFF(d, @SourceDate, @TargetDate)

		Update tTask Set
			ConstraintDate = DATEADD(d, @DateDiff, ConstraintDate)
		Where ProjectKey = @ProjectKey and TaskConstraint > 0
	END
	RETURN 1
GO
