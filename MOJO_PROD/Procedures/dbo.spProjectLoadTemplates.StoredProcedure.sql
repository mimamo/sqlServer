USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadTemplates]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadTemplates]
	@ProjectKey int,
	@CompanyKey int
AS
				
/*
|| When      Who Rel      What
|| 2/18/10   CRG 10.5.1.8 Created
|| 12/3/10   CRG 10.5.3.9 Modified project query because now we're using a lookup on the UI so we don't need DisplayName
|| 12/20/10  CRG 10.5.3.9 Added query of tTaskUser
|| 2/9/11    CRG 10.5.4.1 Modified project query because we went back to a combo and need DisplayName again
|| 6/1/11    GHL 10.5.4.5 Replaced select into by selects into already created tables because tempdb is locked during query
|| 03/08/12  GHL 10.5.5.4 (133198) Added task predecessors
|| 4/6/12    CRG 10.5.5.4 (138810) Added @ProjectKey param. Now getting the template list from ListManager, and only returning task information for one project at a time
*/

	create table #tasks (TaskKey int null)

	insert  #tasks (TaskKey)
	SELECT	TaskKey
	FROM	tTask (nolock)
	WHERE	ProjectKey = @ProjectKey
	
	SELECT	t.*
			,ISNULL(t.TaskID, '') + '-' + ISNULL(t.TaskName, '') AS DisplayName
	FROM	tTask t (nolock)
	INNER JOIN #tasks tmp ON t.TaskKey = tmp.TaskKey
	ORDER BY t.ProjectKey, t.ProjectOrder

	SELECT	tu.TaskUserKey,
			tu.UserKey,
			u.UserName,
			tu.TaskKey,
			u.DefaultServiceKey,
			tu.Hours,
			tu.ServiceKey,
			s.Description AS ServiceDescription
	FROM	tTaskUser tu (nolock)
	INNER JOIN #tasks tmp ON tu.TaskKey = tmp.TaskKey
	LEFT JOIN vUserName u (nolock) ON tu.UserKey = u.UserKey
	LEFT JOIN tService s (nolock) ON tu.ServiceKey = s.ServiceKey

	select tp.*
	from   tTaskPredecessor tp (nolock)
	inner join #tasks t on tp.TaskKey = t.TaskKey
GO
