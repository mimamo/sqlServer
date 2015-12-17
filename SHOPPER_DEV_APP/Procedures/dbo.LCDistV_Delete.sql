USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCDistV_Delete]    Script Date: 12/16/2015 15:55:24 ******/
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
