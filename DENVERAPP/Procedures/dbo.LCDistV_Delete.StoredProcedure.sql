USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCDistV_Delete]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCDistV_Delete]
@Parm1 varchar(10),
@Parm2 varchar(10),
@Parm3 varchar(5)
AS
DELETE FROM LCVoucher
      WHERE APBatNbr = @Parm1 AND
            APRefNbr LIKE @Parm2 AND
            APLineRef LIKE @Parm3
GO
