USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_AR_VerifyAccount]    Script Date: 12/21/2015 14:34:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FMG_AR_VerifyAccount] @Parm1 VARCHAR (10) AS

SELECT * FROM account WHERE Acct = @Parm1
GO
