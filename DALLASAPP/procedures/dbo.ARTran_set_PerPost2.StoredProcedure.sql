USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_set_PerPost2]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[ARTran_set_PerPost2] @parm1 varchar (10), @parm2 varchar (6)
AS
UPDATE ARTran SET ARTran.PerPost = @parm2
WHERE ARTran.BatNbr = @parm1 and ARTran.PerPost <> @parm2
GO
