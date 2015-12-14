USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCatalinaGetProjectAndTaskByUserIDWS]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCatalinaGetProjectAndTaskByUserIDWS]
 (  
	@UserID varchar(100),  
	@StartDate smalldatetime,
	@EndDate smalldatetime
 )  
AS --Encrypt  
  
 SET NOCOUNT ON  

/*  
|| When      Who Rel		What  
|| 3/20/10   MAS 10.5.2		Created.  Cusomization for Catalina Marketing Web Service
|| 06/16/10  MAS 10.5.3.2	(83217)Return ProjectStatusID rather than ProjectStatus
|| 12/13/10  MAS 10.5.3.9	(94961)Catalina asked us to filter for only 'PRODUCTION' Projects
|| 06/01/11  GHL 10.5.4.4   Added Nolock to first query. Also added index on tUser.UserID
*/  

If ISNULL(@UserID, '') = ''
	Return -1  -- No UserID

Declare @UserKey INT
Declare @FieldDefKey INT
Declare @CompanyKey INT

Select @UserKey = UserKey, @CompanyKey = CompanyKey from tUser (nolock) Where UserID = ISNULL(@UserID, '')

-- Figure out the CF Key we're interested
Select @FieldDefKey = FieldDefKey 
from tFieldDef  (nolock)
Where OwnerEntityKey = @CompanyKey
And AssociatedEntity = 'TaskAssignmentTypes'
And FieldName = 'Asset_ID'

If ISNULL(@FieldDefKey,0) = 0
	Return - 2		-- No Asset_ID Field

Select  
p.ProjectKey,
p.ProjectNumber, 
p.ProjectNumber + '-' + p.ProjectName AS ProjectFullName, 
p.StartDate, p.CompleteDate As EndDate,
ps.ProjectStatusID As ProjectStatus,
c.CompanyName AS ClientName,
t.TaskKey, t.TaskID, t.TaskName, t.PlanStart, t.PlanComplete, 
Case IsNull(tu.ActComplete, 0)
		When 0 Then 1
		Else 2
	End  AS  TaskStatus,  
fv.FieldValue
from tTaskUser tu (nolock)
Join tTask t (nolock) on t.TaskKey = tu.TaskKey
Join tProject p (nolock) on p.ProjectKey = t.ProjectKey
Join tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
Left Join tCompany c (nolock) on c.CompanyKey = p.ClientKey
Left Join tFieldValue fv (nolock) on fv.ObjectFieldSetKey = t.CustomFieldKey

Where tu.UserKey =  @UserKey
And ISNULL(t.PlanStart, '2050-01-01') >= ISNULL(@StartDate, '1970-01-01' )
And ISNULL(t.PlanComplete, '1970-01-01') <= ISNULL(@EndDate,'2050-01-01' )
And Upper(ps.ProjectStatusID) = 'PRODUCTION' 
Order by p.ProjectNumber, t.TaskKey

Return 1

 -- EXEC spCatalinaGetProjectAndTaskByUserIDWS 'tc', '2001-01-01', NULL
GO
