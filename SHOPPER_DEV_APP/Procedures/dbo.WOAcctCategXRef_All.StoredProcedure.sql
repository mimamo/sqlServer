USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOAcctCategXRef_All]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOAcctCategXRef_All]
   @Acct       varchar( 16 )
AS
   SELECT      *
   FROM        WOAcctCategXRef
   WHERE       Acct LIKE @Acct
   ORDER BY    Acct
GO
