USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XAPCheck_FlagUpdate]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XAPCheck_FlagUpdate] @BatNbr char(10) AS
Update XAPCheck set Printed = 1 where BatNbr = @BatNbr
GO
