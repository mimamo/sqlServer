USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJAcct_NA]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJAcct_NA]
   @Acct       varchar(16)

AS
   SELECT      *
   FROM        PJAcct
   WHERE       Acct_Status = 'A' and
               Acct_Type = 'NA' and
               Acct LIKE @Acct
   ORDER BY    Acct
GO
