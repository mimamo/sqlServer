USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRejectExpenseEnvelope]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spRejectExpenseEnvelope]
 @ExpenseEnvelopeKey int,
 @ApprovalComments varchar(300)
 
AS --Encrypt
 UPDATE tExpenseEnvelope
 SET  ApprovalComments = @ApprovalComments,
   Status = 3
 WHERE ExpenseEnvelopeKey = @ExpenseEnvelopeKey
 
 RETURN 1
GO
