USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkW2Form_DEL_RIID]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkW2Form_DEL_RIID] @parm1 smallint as
       Delete wrkw2form from WrkW2Form
           where RI_ID  =  @parm1
GO
