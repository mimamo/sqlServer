USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CreditMgrID_Name]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[CreditMgrID_Name] @parm1 Varchar(10) as
       Select CreditMgrName from CreditMgr where CreditMgrID = @Parm1
GO
