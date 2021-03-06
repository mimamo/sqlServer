USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTranLCCodeExists]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[APTranLCCodeExists]
@Parm1 varchar(10),
@Parm2 varchar(10)
AS
SELECT MAX(CpnyID)
  FROM APTran
 WHERE BatNbr = @Parm1 AND
       RefNbr like @Parm2
GO
