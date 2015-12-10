USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10543]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10543]

AS




Update tJournalEntry Set RecurringParentKey = 0 Where RecurringParentKey > 0 and RecurringParentKey not in (
Select RecurTranKey from tRecurTran)

Update tPayment Set RecurringParentKey = 0 Where RecurringParentKey > 0 and RecurringParentKey not in (
Select RecurTranKey from tRecurTran)

Update tCheck Set RecurringParentKey = 0 Where RecurringParentKey > 0 and RecurringParentKey not in (
Select RecurTranKey from tRecurTran)
GO
