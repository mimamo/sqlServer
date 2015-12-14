USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetbyTaskID]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptTaskGetbyTaskID]
	@ProjectKey int,
	@TaskID varchar(50)
AS

/*
|| When      Who Rel      What
|| 5/12/09   MAS 10.5.0.0 Created
*/

	SELECT	*
	FROM	tTask (nolock)
	WHERE	ProjectKey = @ProjectKey
	AND		upper(ltrim(rtrim(TaskID))) = upper(ltrim(rtrim(@TaskID)))
	
Return 1
GO
