USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGroupBudget]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGroupBudget]

	(
		@ProjectKey int,
		@BudgetType varchar(10)
	)

AS --Encrypt
	
  /*
  || When		Who		Rel		What
  || 02/11/15  WDF      10.5.8.9 (AbelsonTaylor) Added 'if' stmt for tProjectEstByTitle
 */

if @BudgetType = 'Item'
	Select * from tProjectEstByItem (nolock) Where ProjectKey = @ProjectKey
	
if @BudgetType = 'TaskID'
	Select * from tTask (nolock) Where ProjectKey = @ProjectKey
	
if @BudgetType = 'Title'
    select * from tProjectEstByTitle (nolock) Where ProjectKey = @ProjectKey
GO
