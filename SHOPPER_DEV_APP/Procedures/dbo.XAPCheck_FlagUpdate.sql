USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XAPCheck_FlagUpdate]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XAPCheck_FlagUpdate] @BatNbr char(10) AS
Update XAPCheck set Printed = 1 where BatNbr = @BatNbr
GO
