USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJ_Account_Acct_GL]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJ_Account_Acct_GL]
   @PJAcct     varchar( 16 ),
   @Acct       varchar( 16 )

AS
   SELECT      *
   FROM        Account LEFT JOIN PJ_Account
               ON Account.Acct = PJ_Account.GL_Acct
   WHERE       PJ_Account.Acct = @PJAcct and
               Account.Acct LIKE @Acct and
               Account.Active = 1
   ORDER BY    Account.Acct
GO
