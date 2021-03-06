USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[APCheck_Prtd_to_Keep]    Script Date: 12/21/2015 16:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APCheck_Prtd_to_Keep    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APCheck_Prtd_to_Keep] @parm1 varchar ( 10), @parm2 varchar ( 10) As
        Select Acct, Sub, RefNbr, DocType, CuryOrigDocAmt, Vendid, BatNbr
         From APDoc where BatNbr = @parm1 and RefNbr Like @parm2
         order by  Acct, Sub, DocType, RefNbr
GO
