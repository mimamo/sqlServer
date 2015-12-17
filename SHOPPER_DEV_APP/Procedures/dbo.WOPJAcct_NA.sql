USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJAcct_NA]    Script Date: 12/16/2015 15:55:36 ******/
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
