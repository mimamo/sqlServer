USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR08690_Pst]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR08690_Pst    Script Date: 4/7/98 12:54:32 PM ******/
--apptable
CREATE PROC [dbo].[AR08690_Pst] @RI_ID smallint
AS
        DELETE FROM AR08690_Wrk WHERE RI_ID = @RI_ID
GO
