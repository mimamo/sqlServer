USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10539]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10539]
AS
	SET NOCOUNT ON

	
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

	-- if summary line, display option = Sub Item Details
	-- if detail line, display option = No detail
	
	update tInvoiceLine 
	set    DisplayOption = case when LineType = 1 then 2 else 1 end
	where  DisplayOption is null

	RETURN 1
GO
