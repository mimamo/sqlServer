USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vEstimate_Details]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vEstimate_Details]

as


Select e.EstimateKey, t.TaskID, t.TaskName, st.TaskID as SummaryTaskID, st.TaskName as SummaryTaskName, s.ServiceCode as ItemID, s.Description as ItemName, etl.Hours as Quantity, etl.Hours * etl.Rate as Gross, 'Labor' as ItemType
From 
	tEstimate e (nolock)
	inner join tEstimateTaskLabor etl (nolock) on e.EstimateKey = etl.EstimateKey
	left outer join tTask t (nolock) on etl.TaskKey = t.TaskKey
	left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	left outer join tService s (nolock) on etl.ServiceKey = s.ServiceKey
	
Union ALL

Select e.EstimateKey, t.TaskID, t.TaskName, st.TaskID as SummaryTaskID, st.TaskName as SummaryTaskName, i.ItemID, i.ItemName, 
	SUM(Case When e.ApprovedQty = 1 then Quantity
			 When e.ApprovedQty = 2 then Quantity2
			 When e.ApprovedQty = 3 then Quantity3
			 When e.ApprovedQty = 4 then Quantity4
			 When e.ApprovedQty = 5 then Quantity5 end) as Quantity, 
	
	Sum(Case When e.ApprovedQty = 1 then BillableCost
			 When e.ApprovedQty = 2 then BillableCost2
			 When e.ApprovedQty = 3 then BillableCost3
			 When e.ApprovedQty = 4 then BillableCost4
			 When e.ApprovedQty = 5 then BillableCost5 end) as Gross, 'Expense' as ItemType
From 
	tEstimate e (nolock)
	inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
	left outer join tTask t (nolock) on ete.TaskKey = t.TaskKey
	left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	left outer join tItem i (nolock) on ete.ItemKey = i.ItemKey
Group By e.EstimateKey, t.TaskID, t.TaskName, st.TaskID, st.TaskName, i.ItemID, i.ItemName
GO
