USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDBDiaryToDo]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDBDiaryToDo]
	@CompanyKey int = -1
AS

/*
|| When      Who Rel      What
|| 3/9/11    CRG 10.5.4.2 I have copied this from spConvertDB10539 so we can call this when the lab is turned on for a specific company.
*/

	SET NOCOUNT ON

	update	tActivity 
	set		ActivityEntity = 'ToDo'
	where	(@CompanyKey = -1 OR CompanyKey = @CompanyKey)
	and		isnull(ProjectKey, 0) > 0
	and		isnull(TaskKey, 0) > 0


	update	tActivity 
	set		ActivityEntity = 'Diary'
	where	(@CompanyKey = -1 OR CompanyKey = @CompanyKey)
	and		isnull(ProjectKey, 0) > 0
	and		isnull(TaskKey, 0) = 0
	and		ISNULL(ActivityEntity, 'Activity') <> 'ToDo' 

	update	tActivity 
	set		ActivityEntity = 'Activity'
	where	(@CompanyKey = -1 OR CompanyKey = @CompanyKey)
	and		ActivityEntity is null

	Update tPreference Set UseToDo = 1 Where @CompanyKey = -1 OR CompanyKey = @CompanyKey
GO
