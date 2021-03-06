USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10531]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10531]

AS


Update tSystemMessage Set Active = 0 Where InactiveDate is null


-- Remove Duplicates from tAssignment
/*
select ProjectKey, UserKey, MAX(ISNULL(HourlyRate, 0)) as HourlyRate into #tmpAss from tAssignment (nolock)
Group By ProjectKey, UserKey
Having count(*) > 1 

delete tAssignment
From #tmpAss Where tAssignment.ProjectKey = #tmpAss.ProjectKey and tAssignment.UserKey = #tmpAss.UserKey

insert tAssignment (UserKey, ProjectKey, HourlyRate)
Select UserKey, ProjectKey, HourlyRate from #tmpAss


drop table #tmpAss
*/
-- Fix Digital Art Review Data

update tApproval set ApprovalOrderType = 1 where ApprovalKey in(
select ApprovalKey from tApproval (nolock) where ApprovalOrderType = 0 and ISNull(ActiveApprover, 0) = 0 and Status = 1
)



update tApproval set ApprovalOrderType = 2 where ApprovalKey in(
select ApprovalKey from tApproval (nolock) where ApprovalOrderType = 0 and ISNull(ActiveApprover, 0) > 0 and Status = 1
)

update tApproval set ApprovalOrderType = 1 where ApprovalKey in(
select ApprovalKey from tApproval (nolock) where ApprovalOrderType = 0 and ISNull(ActiveApprover, 0) = 0 and Status = 2
)


update tApproval set ApprovalOrderType = 2 where ApprovalKey in(
select ApprovalKey from tApproval (nolock) where ApprovalOrderType = 0 and ISNull(ActiveApprover, 0) > 0 and Status = 2
)
GO
