USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Estimate_Detail]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vReport_Estimate_Detail]

as


Select e.*
	,ed.ItemID as [Item ID]
	,ed.ItemName as [Item Name]
	,ed.TaskID as [Task ID]
	,ed.TaskName as [Task Name]
	,ed.SummaryTaskID as [Summary Task ID]
	,ed.SummaryTaskName as [Summary Task Name]
	,ed.Quantity
	,ed.Gross
	,ed.ItemType as [Item Type]
	,Case When ed.Quantity <> 0 then ed.Gross / ed.Quantity else 0 end as Rate


from vReport_Estimate e (nolock)
left outer join vEstimate_Details ed (nolock) on e.EstimateKey = ed.EstimateKey
GO
