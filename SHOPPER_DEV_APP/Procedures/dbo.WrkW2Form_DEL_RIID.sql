USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkW2Form_DEL_RIID]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkW2Form_DEL_RIID] @parm1 smallint as
       Delete wrkw2form from WrkW2Form
           where RI_ID  =  @parm1
GO
