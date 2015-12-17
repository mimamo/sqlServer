USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RptRuntime_NE_RIID_EQ_BatNbr]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[RptRuntime_NE_RIID_EQ_BatNbr] @parm1 smallint, @parm2 varchar ( 10) as
       Select * from RptRuntime
           where RptRuntime.RI_ID   <>  @parm1
             and RptRuntime.BatNbr  =   @parm2
           order by RI_ID
GO
