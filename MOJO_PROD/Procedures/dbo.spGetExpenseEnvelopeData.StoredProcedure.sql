USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetExpenseEnvelopeData]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetExpenseEnvelopeData]
 @ExpenseEnvelopeKey int
 
AS --Encrypt
 SELECT Email, EnvelopeNumber
 FROM tUser u (nolock),
   tExpenseEnvelope ee
 WHERE ee.ExpenseEnvelopeKey = @ExpenseEnvelopeKey
 AND  ee.UserKey = u.UserKey
 
 RETURN 1
GO
