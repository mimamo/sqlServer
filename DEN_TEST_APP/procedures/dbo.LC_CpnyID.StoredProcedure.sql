USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LC_CpnyID]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LC_CpnyID]
@Parm1 varchar(10),
@Parm2 varchar(10)
AS
SELECT CpnyID
  FROM LCVoucher
 WHERE APBatNbr = @Parm1 AND
       APRefNbr = @Parm2
GO
