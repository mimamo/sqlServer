USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJ_Account_XRef]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJ_Account_XRef]
   @GL_Acct    varchar( 10 )

AS
   SELECT      *
   FROM        PJ_Account LEFT JOIN WOAcctCategXRef
               ON PJ_Account.Acct = WOAcctCategXRef.Acct
   WHERE       PJ_Account.GL_Acct = @GL_Acct
   ORDER BY    PJ_Account.GL_Acct
GO
