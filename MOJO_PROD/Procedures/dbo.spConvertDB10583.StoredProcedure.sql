USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10583]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10583]
AS
	SET NOCOUNT ON
	
	UPDATE	tAppFavorite
	SET		ActionID = 'today.creative.myTasks'
	WHERE	ActionID = 'User.Today.MyTasks'

	UPDATE	tAppMenu 
	SET		ActionID = 'today.creative'
	WHERE	ActionID = 'user.today'

/*
    -- Removed because the column is no longer valid
	-- Transfer tPreference 'CollapseSchedule' data to tSession
	DECLARE @UserKey INT
	SELECT @UserKey = -1

	WHILE (1=1)
	BEGIN
		SELECT @UserKey = MIN(u.UserKey)
		  FROM tPreference p inner join tUser u on (u.CompanyKey = p.CompanyKey)
		 WHERE p.CollapseSchedule = 1
		   AND u.UserKey > @UserKey

		IF @UserKey IS NULL
			BREAK
				
		UPDATE tSession
		   SET Data = REPLACE(Cast(Data as Varchar(max)),'</SESSION>','<COLLAPSESCHEDULE>1</COLLAPSESCHEDULE></SESSION>')
		 WHERE Entity = 'user'
		   AND EntityKey = @UserKey
	END
*/

-- it seems like this did not go thru in spConverDB10582	
insert tEstimateTaskExpenseOrder (EstimateTaskExpenseKey, PurchaseOrderDetailKey)
select EstimateTaskExpenseKey, PurchaseOrderDetailKey
from tEstimateTaskExpense (nolock)
where  PurchaseOrderDetailKey > 0
and PurchaseOrderDetailKey not in (select PurchaseOrderDetailKey from tEstimateTaskExpenseOrder (nolock) )
	
	


	RETURN
GO
