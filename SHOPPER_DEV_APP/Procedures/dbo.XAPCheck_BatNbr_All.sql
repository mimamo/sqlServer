USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XAPCheck_BatNbr_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XAPCheck_BatNbr_All] @BatNbr char(10) AS
Select distinct BatNbr, CpnyID, Acct, Sub from XAPCheck where BatNbr like @BatNbr  and Printed = 1 order by BatNbr
GO
