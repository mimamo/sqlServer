USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJAcct_Rev_Ex]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJAcct_Rev_Ex]
   @Acct       varchar( 16 )

AS
   SELECT      *
   FROM        PJAcct
   WHERE       Acct LIKE @Acct and
               Acct_Type IN ('RV','EX')
   ORDER BY    Acct
GO
