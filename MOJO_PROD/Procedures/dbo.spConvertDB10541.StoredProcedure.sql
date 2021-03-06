USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10541]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10541]

AS

	update tActivity 
	set    ActivityEntity = 'ToDo'
	where  isnull(ProjectKey, 0) > 0
	and    isnull(TaskKey, 0) > 0

	update tActivity 
	set    ActivityEntity = 'Diary'
	where  isnull(ProjectKey, 0) > 0
	and    isnull(TaskKey, 0) = 0

	update tActivity 
	set    ActivityEntity = 'Activity'
	where  ActivityEntity is null

	Update tPreference Set UseToDo = 1
GO
