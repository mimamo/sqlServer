USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Update_Ledger_BaseCuryid]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Update_Ledger_BaseCuryid] @parm1 varchar ( 4) as
Update ledger Set BaseCuryID = @parm1
GO
