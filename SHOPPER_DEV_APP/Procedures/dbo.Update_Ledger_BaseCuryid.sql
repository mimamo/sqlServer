USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Update_Ledger_BaseCuryid]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Update_Ledger_BaseCuryid] @parm1 varchar ( 4) as
Update ledger Set BaseCuryID = @parm1
GO
