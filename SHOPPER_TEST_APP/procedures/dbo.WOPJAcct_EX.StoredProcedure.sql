USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJAcct_EX]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJAcct_EX]
   @Acct       varchar(16)

AS
   SELECT      *
   FROM        PJAcct
   WHERE       Acct_Status = 'A' and
               Acct_Type = 'EX' and
               Acct LIKE @Acct
   ORDER BY    Acct
GO
