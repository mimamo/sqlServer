USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetTaskUserDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateGetTaskUserDetail]

	(
		@EstimateKey int
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 04/26/10  GHL 10.522  Reading now tEstimateTaskTemp or tTask
*/

Declare @LeadKey int
Declare @Entity varchar(50)
Declare @EntityKey int
Declare @ReadTempTaskTable int
 
select @LeadKey = LeadKey
from   tEstimate (nolock)
where  EstimateKey = @EstimateKey

-- for now we only have 1 entity but we could have more in the future
if isnull(@LeadKey, 0) > 0
begin
	select @Entity = 'tLead', @EntityKey = @LeadKey 
	
	if exists (select 1 from tEstimateTaskTemp (nolock) where Entity = @Entity and EntityKey = @EntityKey)
		select @ReadTempTaskTable = 1
end

if isnull(@ReadTempTaskTable, 0) = 0			
	Select 
		u.UserKey,
		u.FirstName + ' ' + u.LastName as UserName,
		etl.TaskKey,
		t.SummaryTaskKey,
		sum(Hours) as TotalHours,
		Sum(Hours * Rate) as TotalAmt
	from 
		tUser u (nolock),
		tEstimateTaskLabor etl (nolock),
		tTask t (nolock)
	Where
		u.UserKey = etl.UserKey and
		etl.TaskKey = t.TaskKey and
		etl.EstimateKey = @EstimateKey
	Group By u.UserKey, u.FirstName + ' ' + u.LastName, etl.TaskKey, t.SummaryTaskKey
	Having Sum(Hours * Rate) > 0
	Order By 
		etl.TaskKey, UserName

else

	Select 
		u.UserKey,
		u.FirstName + ' ' + u.LastName as UserName,
		etl.TaskKey,
		t.SummaryTaskKey,
		sum(Hours) as TotalHours,
		Sum(Hours * Rate) as TotalAmt
	from 
		tUser u (nolock),
		tEstimateTaskLabor etl (nolock),
		tEstimateTaskTemp t (nolock)
	Where
		u.UserKey = etl.UserKey and
		etl.TaskKey = t.TaskKey and
		etl.EstimateKey = @EstimateKey and
		t.Entity = @Entity and
		t.EntityKey = @EntityKey
	Group By u.UserKey, u.FirstName + ' ' + u.LastName, etl.TaskKey, t.SummaryTaskKey
	Having Sum(Hours * Rate) > 0
	Order By 
		etl.TaskKey, UserName
GO
