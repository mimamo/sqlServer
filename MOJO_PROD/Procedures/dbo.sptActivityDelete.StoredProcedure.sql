USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityDelete]
	(
	@ActivityKey int
	)
	
AS

/*
|| When     Who Rel      What
|| 6/9/09   CRG 10.5.0.0 Added tCalendarReminder
|| 10/20/14 RLB 10.5.8.5 delete any children activities
*/

Declare @CustomFieldKey int

Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) 
FROM tActivity (NOLOCK) 
WHERE
	ActivityKey = @ActivityKey 
	
if @CustomFieldKey > 0 
	exec spCF_tObjectFieldSetDelete @CustomFieldKey

-- delete any children of the activity getting deleted
Delete tActivityLink where ActivityKey in (select ActivityKey from tActivity (nolock) where ParentActivityKey = @ActivityKey)
Delete tActivityEmail where ActivityKey in (select ActivityKey from tActivity (nolock) where ParentActivityKey = @ActivityKey)
Delete tActivity Where ParentActivityKey =  @ActivityKey



Delete tActivityLink Where ActivityKey = @ActivityKey
Delete tActivityEmail Where ActivityKey = @ActivityKey
DELETE tCalendarReminder WHERE Entity = 'tActivity' AND EntityKey = @ActivityKey
Delete tActivity Where ActivityKey = @ActivityKey
GO
