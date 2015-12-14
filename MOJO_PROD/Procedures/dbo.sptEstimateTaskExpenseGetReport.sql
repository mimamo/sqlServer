USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseGetReport]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseGetReport]

	@EstimateKey int


AS --Encrypt

/*
|| When      Who Rel     What
|| 04/26/10  GHL 10.522  Reading now tEstimateTaskTemp or tTask
|| 05/10/10  GHL 10.523  (80312) Moved t.Entity = @Entity from the where clause
||                       to the left join with tEstimateTaskTemp
||                       The original query was failing for service only estimates where
||                       TaskKey was null
|| 05/19/10  MFT 10.530  Put DisplayOrder in the ORDER BY clause
|| 08/18/10  GHL 10.534  Added support of 'By Project Only' estimate type
*/


Declare @EstType int
Declare @LeadKey int
Declare @Entity varchar(50)
Declare @EntityKey int
Declare @ReadTempTaskTable int
 
select @EstType = EstType
      ,@LeadKey = LeadKey
from   tEstimate (nolock)
where  EstimateKey = @EstimateKey

-- for now we only have 1 entity but we could have more in the future
if isnull(@LeadKey, 0) > 0
begin
	select @Entity = 'tLead', @EntityKey = @LeadKey 
	
	if exists (select 1 from tEstimateTaskTemp (nolock) where Entity = @Entity and EntityKey = @EntityKey)
		select @ReadTempTaskTable = 1
end

if @EstType <> 6 
begin
-- Not by project
if isnull(@ReadTempTaskTable, 0) = 0			
		SELECT t.TaskID
			   ,i.ItemName
			   ,t.SummaryTaskKey
			   ,ete.*
			   ,Case 
			   when isnull(e.ApprovedQty, 1) = 1 Then ete.BillableCost
			   when isnull(e.ApprovedQty, 1) = 2 Then ete.BillableCost2
			   when isnull(e.ApprovedQty, 1) = 3 Then ete.BillableCost3
			   when isnull(e.ApprovedQty, 1) = 4 Then ete.BillableCost4
			   when isnull(e.ApprovedQty, 1) = 5 Then ete.BillableCost5
			   when isnull(e.ApprovedQty, 1) = 6 Then ete.BillableCost6
			   end AS ApprovedBillableCost
			   ,Case 
			   when isnull(e.ApprovedQty, 1) = 1 Then ete.Quantity
			   when isnull(e.ApprovedQty, 1) = 2 Then ete.Quantity2
			   when isnull(e.ApprovedQty, 1) = 3 Then ete.Quantity3
			   when isnull(e.ApprovedQty, 1) = 4 Then ete.Quantity4
			   when isnull(e.ApprovedQty, 1) = 5 Then ete.Quantity5
			   when isnull(e.ApprovedQty, 1) = 6 Then ete.Quantity6
			   end AS ApprovedQuantity			   
		FROM tEstimateTaskExpense ete (nolock)
		INNER JOIN tEstimate e (NOLOCK) ON ete.EstimateKey = e.EstimateKey
		LEFT OUTER JOIN tTask t (nolock) ON ete.TaskKey = t.TaskKey
		LEFT OUTER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
		WHERE ete.EstimateKey = @EstimateKey
		ORDER BY ete.DisplayOrder, TaskID, EstimateTaskExpenseKey
else
		SELECT t.TaskID
			   ,i.ItemName
			   ,t.SummaryTaskKey
			   ,ete.*
			   ,Case 
			   when isnull(e.ApprovedQty, 1) = 1 Then ete.BillableCost
			   when isnull(e.ApprovedQty, 1) = 2 Then ete.BillableCost2
			   when isnull(e.ApprovedQty, 1) = 3 Then ete.BillableCost3
			   when isnull(e.ApprovedQty, 1) = 4 Then ete.BillableCost4
			   when isnull(e.ApprovedQty, 1) = 5 Then ete.BillableCost5
			   when isnull(e.ApprovedQty, 1) = 6 Then ete.BillableCost6
			   end AS ApprovedBillableCost
			   ,Case 
			   when isnull(e.ApprovedQty, 1) = 1 Then ete.Quantity
			   when isnull(e.ApprovedQty, 1) = 2 Then ete.Quantity2
			   when isnull(e.ApprovedQty, 1) = 3 Then ete.Quantity3
			   when isnull(e.ApprovedQty, 1) = 4 Then ete.Quantity4
			   when isnull(e.ApprovedQty, 1) = 5 Then ete.Quantity5
			   when isnull(e.ApprovedQty, 1) = 6 Then ete.Quantity6
			   end AS ApprovedQuantity			   
		FROM tEstimateTaskExpense ete (nolock)
		INNER JOIN tEstimate e (NOLOCK) ON ete.EstimateKey = e.EstimateKey
		LEFT OUTER JOIN tEstimateTaskTemp t (nolock) 
			ON ete.TaskKey = t.TaskKey AND t.Entity = @Entity AND t.EntityKey = @EntityKey 
		LEFT OUTER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
		WHERE ete.EstimateKey = @EstimateKey
		ORDER BY ete.DisplayOrder, TaskID, EstimateTaskExpenseKey
end
else
begin
-- by Project only

		SELECT i.ItemName
			   ,ete.*
			   ,Case 
			   when isnull(e.ApprovedQty, 1) = 1 Then ete.BillableCost
			   when isnull(e.ApprovedQty, 1) = 2 Then ete.BillableCost2
			   when isnull(e.ApprovedQty, 1) = 3 Then ete.BillableCost3
			   when isnull(e.ApprovedQty, 1) = 4 Then ete.BillableCost4
			   when isnull(e.ApprovedQty, 1) = 5 Then ete.BillableCost5
			   when isnull(e.ApprovedQty, 1) = 6 Then ete.BillableCost6
			   end AS ApprovedBillableCost
			   ,Case 
			   when isnull(e.ApprovedQty, 1) = 1 Then ete.Quantity
			   when isnull(e.ApprovedQty, 1) = 2 Then ete.Quantity2
			   when isnull(e.ApprovedQty, 1) = 3 Then ete.Quantity3
			   when isnull(e.ApprovedQty, 1) = 4 Then ete.Quantity4
			   when isnull(e.ApprovedQty, 1) = 5 Then ete.Quantity5
			   when isnull(e.ApprovedQty, 1) = 6 Then ete.Quantity6
			   end AS ApprovedQuantity			   
		FROM tEstimateProject ep (nolock) 
		INNER JOIN tEstimateTaskExpense ete (nolock) ON ep.ProjectEstimateKey = ete.EstimateKey
		INNER JOIN tEstimate e (NOLOCK) ON ete.EstimateKey = e.EstimateKey
		LEFT OUTER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
		WHERE ep.EstimateKey = @EstimateKey

		ORDER BY i.ItemName

end

	RETURN 1
GO
