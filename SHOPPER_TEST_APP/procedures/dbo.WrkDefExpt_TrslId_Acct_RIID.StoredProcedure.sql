USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkDefExpt_TrslId_Acct_RIID]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[WrkDefExpt_TrslId_Acct_RIID] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 smallint as
Select * from WrkDefExpt
Where TrslId = @parm1
and   Acct   = @parm2
and   RI_ID  = @parm3
Order by TrslId, Acct
GO
