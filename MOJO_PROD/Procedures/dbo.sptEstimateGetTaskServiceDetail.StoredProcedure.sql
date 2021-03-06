USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetTaskServiceDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateGetTaskServiceDetail]

	(
		@EstimateKey int
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 06/25/08  GHL 8.515  (29186) Changed Sum(Hours * Rate) > 0 to Sum(Hours * Rate) <> 0
||                       so that we can display negative amounts
|| 01/05/10  GWG 10.516  Changed the filter so that rows with hours but no rate or negative rate show up. 
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
	-- no entity, so read tTask
	Select 
		s.ServiceKey,
		s.ServiceCode,
		s.Description,
		etl.TaskKey,
		t.SummaryTaskKey,
		sum(Hours) as TotalHrs,
		Sum(Hours * Rate) as TotalAmt
	from 
		tService s (nolock),
		tEstimateTaskLabor etl (nolock),
		tTask t (nolock)
	Where
		s.ServiceKey = etl.ServiceKey and
		etl.TaskKey = t.TaskKey and
		etl.EstimateKey = @EstimateKey
	Group By s.ServiceKey, s.ServiceCode, s.Description, etl.TaskKey, t.SummaryTaskKey
	Having Sum(Hours) <> 0
	Order By 
		s.ServiceCode

else
	-- entity, so read tEstimateTask
	Select 
		s.ServiceKey,
		s.ServiceCode,
		s.Description,
		etl.TaskKey,
		t.SummaryTaskKey,
		sum(Hours) as TotalHrs,
		Sum(Hours * Rate) as TotalAmt
	from 
		tService s (nolock),
		tEstimateTaskLabor etl (nolock),
		tEstimateTaskTemp t (nolock)
	Where
		s.ServiceKey = etl.ServiceKey and
		etl.TaskKey = t.TaskKey and
		etl.EstimateKey = @EstimateKey and
		t.Entity = @Entity and
		t.EntityKey = @EntityKey
	Group By s.ServiceKey, s.ServiceCode, s.Description, etl.TaskKey, t.SummaryTaskKey
	Having Sum(Hours) <> 0
	Order By 
		s.ServiceCode
GO
