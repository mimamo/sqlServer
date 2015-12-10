USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10573]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10573]
	
AS
	

-- convert the VI details

update tVoucherDetail
set    GrossAmount = case when Billable = 0 then 0
					else ROUND(TotalCost * (1 + isnull(Markup, 0) /100), 2)
					end

--Issue 193381 saving these as null instead of 0
update tPreference set IOApprover = null where IOApprover = 0

update tPreference set BCApprover = null where BCApprover = 0

-- Default the right of prjViewTran to those of billingedittran

 DECLARE @RK INT, @NewRK INT, @RAK INT
 
 SELECT @RAK = -1
 SELECT @RK = RightKey FROM tRight (nolock) WHERE RightID = 'billingedittran'
 SELECT @NewRK = RightKey FROM tRight (nolock) WHERE RightID = 'prjViewTran'
 
 WHILE (@NewRK IS NOT NULL)
 BEGIN
	SELECT @RAK = MIN(RightAssignedKey)
	  FROM   tRightAssigned (nolock)
	 WHERE RightKey = @RK
	   AND RightAssignedKey > @RAK
	
	IF @RAK IS NULL
		BREAK
	
	INSERT tRightAssigned (EntityType, EntityKey, RightKey)
	SELECT EntityType, EntityKey, @NewRK
	  FROM tRightAssigned (nolock)
	 WHERE RightAssignedKey = @RAK

 END
 
 -- Default the right of prjnotesedit to those of prjnotes
 
  SELECT @RAK = -1
  SELECT @RK = RightKey FROM tRight (nolock) WHERE RightID = 'prjnotes'
  SELECT @NewRK = RightKey FROM tRight (nolock) WHERE RightID = 'prjnotesedit'
  
  WHILE (@NewRK IS NOT NULL)
  BEGIN
 	SELECT @RAK = MIN(RightAssignedKey)
 	  FROM   tRightAssigned (nolock)
 	 WHERE RightKey = @RK
 	   AND RightAssignedKey > @RAK
 	
 	IF @RAK IS NULL
 		BREAK
 	
 	INSERT tRightAssigned (EntityType, EntityKey, RightKey)
 	SELECT EntityType, EntityKey, @NewRK
 	  FROM tRightAssigned (nolock)
 	 WHERE RightAssignedKey = @RAK
 
 END

-- Fix missing CashTransactionLineKey for credit cards (issue 195153)
update tCashTransaction
set    tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
from   tCashTransactionLine ctl 
where  tCashTransaction.CashTransactionLineKey < 100
and    tCashTransaction.CashTransactionLineKey > 0
and    tCashTransaction.AEntity = ctl.Entity
and    tCashTransaction.AEntityKey = ctl.EntityKey
and    tCashTransaction.DetailLineKey = ctl.DetailLineKey
and    tCashTransaction.DateCreated > '01/01/2013'
GO
