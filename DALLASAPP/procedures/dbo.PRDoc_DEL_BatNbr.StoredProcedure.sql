USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_DEL_BatNbr]    Script Date: 12/21/2015 13:45:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRDoc_DEL_BatNbr] @parm1 varchar ( 10) as
       Delete prdoc from PRDoc
           where BatNbr  =  @parm1
GO
