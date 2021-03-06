USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCMUGL_CuryId_DocType_RefNbr]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkCMUGL_CuryId_DocType_RefNbr    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc  [dbo].[WrkCMUGL_CuryId_DocType_RefNbr] @parm1 varchar ( 4), @parm2 varchar ( 2), @parm3 varchar ( 10), @parm4 smallint as
       Select * from WrkCMUGL
           where CuryId like @parm1
           and DocType like @parm2
           and RefNbr like @parm3
           and RI_ID like @parm4	 
           order by CuryId, DocType, RefNbr
GO
