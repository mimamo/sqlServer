USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[MMG_PJAcct_Descr]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[MMG_PJAcct_Descr]
	@Acct      varchar(16)
AS
   SELECT     Acct_Desc
	FROM 	     PJAcct
   WHERE 	  Acct = @Acct
GO
