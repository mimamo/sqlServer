USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOAcctCategXRef_All]    Script Date: 12/21/2015 16:07:22 ******/
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
