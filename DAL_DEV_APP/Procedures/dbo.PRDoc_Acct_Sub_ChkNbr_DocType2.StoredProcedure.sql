USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Acct_Sub_ChkNbr_DocType2]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRDoc_Acct_Sub_ChkNbr_DocType2] @parm1 varchar (10), @parm2 varchar (24), @parm3 smallint, @parm4 varchar (10), @parm5 varchar (10) as
SELECT *
FROM PRDoc
WHERE Acct = @parm1
      And Sub = @parm2
      And DocType IN ('HC', 'CK', 'ZC')
      And (Status = 'O' Or (Status = 'C' And @parm3 = 0))
      And CpnyId = @parm4
      And ChkNbr LIKE @parm5
ORDER BY Acct, Sub, ChkNbr, DocType
GO
