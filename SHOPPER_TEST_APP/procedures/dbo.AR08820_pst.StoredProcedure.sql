USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR08820_pst]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR08820_pst    Script Date: 4/7/98 12:54:32 PM ******/
--apptable
CREATE PROC [dbo].[AR08820_pst] @RI_ID smallint
AS
        DELETE FROM AR08820_wrk WHERE RI_ID = @RI_ID
GO
