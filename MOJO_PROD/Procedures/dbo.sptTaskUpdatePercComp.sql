USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUpdatePercComp]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUpdatePercComp]

	(
		@TaskKey int
	)

AS --Encrypt

Declare @PercComp int
Declare @Denominator as Float
		,@Numerator as Float
		,@ActStart smalldatetime
		,@ActComplete smalldatetime
 
Select @Denominator = 0

-- Weighted average, make the duration 1 if 0
Select @Numerator = sum((case when Duration = 0 then 1 else Duration end) * isnull(PercComp, 0)) 
from tTaskAssignment (nolock) 
where TaskKey = @TaskKey

Select @Denominator = sum(case when Duration = 0 then 1 else Duration end) 
from tTaskAssignment (nolock) 
where TaskKey = @TaskKey
 
Select @Denominator = isnull(@Denominator, 0)
 
if @Denominator > 0
Begin
	Select @PercComp = Cast(ROUND(@Numerator / @Denominator, 0) as Integer)
	
	if @PercComp > 100
		Select @PercComp = 100
		
	Update tTask
	Set PercComp = @PercComp 
	Where TaskKey = @TaskKey
	
End	

Select @ActStart = Min(ActStart) from tTaskAssignment (NOLOCK) Where TaskKey = @TaskKey
if @ActStart is not null
	Update tTask Set ActStart = @ActStart Where TaskKey = @TaskKey

if not exists(Select 1 from tTaskAssignment (NOLOCK) Where TaskKey = @TaskKey and ActComplete is null)
BEGIN
	Select @ActComplete = Max(ActComplete) from tTaskAssignment (NOLOCK) Where TaskKey = @TaskKey
	if @ActComplete is not null
		Update tTask Set ActComplete = @ActComplete Where TaskKey = @TaskKey
		
	if exists(select 1 from tTask (NOLOCK) Where TaskStatus > 1 and TaskKey = @TaskKey)
		Update tTask Set TaskStatus = 1, ScheduleNote = '' Where TaskKey = @TaskKey
END
GO
