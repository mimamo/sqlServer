USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadReport_GetStage]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptLeadReport_GetStage]

	(
		@CompanyKey int,
		@AccountManagerKey int
	)

AS --Encrypt

if @AccountManagerKey = 0 
	Select
		lg.LeadStageKey,
		lg.LeadStageName,
		lg.DisplayOrder,
		Sum(l.SaleAmount) as SaleAmount,
		Sum(l.SubAmount) as SubAmount,
		Count(*) as ItemCount,
		Sum(l.SaleAmount * (l.Probability/100.00)) as WeightSaleAmount
	From
		tLead l (nolock),
		tLeadStatus ls (nolock),
		tLeadStage lg (nolock)
	Where
		l.CompanyKey = @CompanyKey and
		l.LeadStatusKey = ls.LeadStatusKey and
		l.LeadStageKey = lg.LeadStageKey and
		ls.Active = 1
	Group By
		lg.LeadStageKey, lg.LeadStageName, lg.DisplayOrder
	Order By
		lg.DisplayOrder

else
	Select
		lg.LeadStageKey,
		lg.LeadStageName,
		lg.DisplayOrder,
		Sum(l.SaleAmount) as SaleAmount,
		Sum(l.SubAmount) as SubAmount,
		Count(*) as ItemCount,
		Sum(l.SaleAmount * (l.Probability/100.00)) as WeightSaleAmount
	From
		tLead l (nolock),
		tLeadStatus ls (nolock),
		tLeadStage lg (nolock)
	Where
		l.CompanyKey = @CompanyKey and
		l.LeadStatusKey = ls.LeadStatusKey and
		l.LeadStageKey = lg.LeadStageKey and
		ls.Active = 1 and
		l.AccountManagerKey = @AccountManagerKey
	Group By
		lg.LeadStageKey, lg.LeadStageName, lg.DisplayOrder
	Order By
		lg.DisplayOrder
GO
